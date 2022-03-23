import os.path
import logging
import abc
import re

from fish.Tools.misc import getSetting

import sublime, sublime_plugin


class BaseHighlighter(metaclass = abc.ABCMeta):
  def __init__(self, view):
    self.drawnRegions = dict()
    self.nextKeyID = 0
    if self.view.file_name() is None:
      self.baseName = 'untitled'
    else:
      self.baseName = os.path.basename(self.view.file_name())

    logging.basicConfig()
    self.logger = logging.getLogger(self.__class__.__name__ + ':' + self.baseName)
    if view.settings().get('highlighter_debugging'):
      self.logger.setLevel(logging.DEBUG)
    else:
      self.logger.setLevel(logging.WARNING)

    # Status elements get displayed alphabetically, so be thematic
    self.statusKey = 'fish_' + self.__class__.__name__

    self.statusSetting = getSetting(view.settings(), 'highlighter_show_status', r'always|critical|off', 'off')

    # Abstract members
    self.selectors = None

  # Clear everything that uses keys, because we're about to lose them
  def __del__(self):
    for key in self.drawnRegions:
      self.view.erase_regions(key)

    self.view.erase_status(self.statusKey)

  def _update_markup(self, local = False):
    # https://github.com/SublimeTextIssues/Core/issues/289 means that we can't
    #   mark up multiple views into the same file at the same time

    # Check our conditions
    if self.baseName in self.view.settings().get('highlighter_blacklist'):
      self.logger.info("Refusing to mark up because file in blacklist")
      return

    if self.selectors is None:
      return

    # Check derived class conditions
    if not self._should_markup():
      return

    self.logger.debug("Next key ID = {}".format(self.nextKeyID))

    # Build a complete list of candidate regions from the selectors we can match
    fullFileSelMatch = [(r,s) for s in self.selectors for r in self.view.find_by_selector(s)]

    self.logger.debug("{} candidate regions found in file".format(len(fullFileSelMatch)))

    nearCursorSelMatch = []
    if local:
      sel = list(self.view.sel())
      self.logger.debug("Focusing on regions near this cursor {}".format(sel))

      # Keep only the candidates that are on the same line as a cursor selection
      for cand in fullFileSelMatch:
        if any( map(lambda r: cand[0].intersects( self.view.line(r) ), sel) ):
          nearCursorSelMatch.append(cand)

      self.logger.debug("{} focused candidates".format(len(nearCursorSelMatch)))
      regionsInQuestion = nearCursorSelMatch
    else:
      # Keep all candidate regions
      regionsInQuestion = fullFileSelMatch

    def erase_region(key):
      self.view.erase_regions(key)
      self.drawnRegions.pop(key)

    # Rather than erase every region and re-test every candidate, try to keep
    # existing regions that still align with a candidate
    for key,props in list(self.drawnRegions.items()):
      cachedArea = props['area']
      self.logger.debug("Reviewing previously drawn region '{}' {}".format(key, cachedArea))

      # Check if region has been deleted by the user
      activeArea = self.view.get_regions(key)
      if not activeArea:
        self.logger.debug("Region no longer exists")
        erase_region(key)
        continue

      activeArea = self.view.get_regions(key)[0]
      self.logger.debug("Found it at {}".format(activeArea))

      # If the _test_draw_region() logic is complex, we may be directed not to
      # attempt this optimisation for keeping regions when possible
      if not props.get('quick-check-selector', True):
        self.logger.debug("Erasing region we cannot quick-check via selector")
        if local:
          # local mode assumes we'll only need to redraw regions near the
          # cursor, but because we're erasing these regions no matter where
          # they are in the file we will still need to test redrawing them
          for cand in fullFileSelMatch:
            if cand[0] == activeArea:
              regionsInQuestion.append(cand)
        erase_region(key)
        continue

      # If content of region has changed, erase it and we'll test later if we can redraw
      if activeArea.size() != cachedArea.size():
        self.logger.debug("Erasing region because its size has changed")
        erase_region(key)
        continue

      # If size is the same, region may have moved but remain valid
      self.drawnRegions[key]['area'] = activeArea

      # If the region covers the entirety of a matched selector anywhere in the
      # file, then keep it. Otherwise the file content has changed in a way
      # that this region no longer aligns to any matched selectors
      foundInFile = False
      for cand in fullFileSelMatch:
        if activeArea == cand[0]:
          self.logger.debug("Keeping drawn region")
          foundInFile = True
          break
      if not foundInFile:
        self.logger.debug("Erasing stale drawn region '{}'".format(key))
        erase_region(key)

    # Discard any focused candidates which exactly align to regions we've left
    # drawn, assuming they would test true to being redrawn anyway
    for drawn in self.drawnRegions.values():
      for i,cand in enumerate(regionsInQuestion):
        if cand[0] == drawn['area']:
          regionsInQuestion.pop(i)
          break

    self.logger.debug("Remaining candidates = {} = {}".format(len(regionsInQuestion), regionsInQuestion))

    # Test and draw each remaining candidate region
    for region,selector in regionsInQuestion:
      # Discard any candidate that intersects with an already drawn region
      if any( map(lambda d: d['area'].intersects(region), self.drawnRegions.values()) ):
        continue

      regionID = "{}_{}".format(self.__class__.__name__, self.nextKeyID)

      props = self._test_draw_region(region, selector, regionID)
      if not props:
        continue

      props['style'] = props['style'] | sublime.HIDE_ON_MINIMAP

      self.view.add_regions(regionID, [region], scope = props['scope'], flags = props['style'])
      self.drawnRegions[regionID] = dict(
        area = region,
        **props # unpack 'name' and any optional props
      )

      self.nextKeyID += 1

    self.logger.debug("Final drawn regions = {} = {}".format(len(self.drawnRegions), self.drawnRegions))

    status = self._build_status()
    if status \
    and self.statusSetting == 'always' \
    or (self.statusSetting == 'critical' and status[0]):
      self.view.set_status(self.statusKey, status[1])
    else:
      self.view.erase_status(self.statusKey)

  def _run_test(self):
    self.logger.debug("Running test")

    # Make sure we have the latest markup
    self._update_markup()

    # Set up the build results panel
    # We could use any name, but this name is special and grants extra functionality
    #   by highlighting lines within the panel while navigating the errors
    panel = self.view.window().create_output_panel('exec')
    panel.settings().set('result_file_regex', r'(.*):([0-9]+):([0-9]+): (.*)')

    # Convenience method for printing to the panel
    def print_panel(arg):
      if isinstance(arg, list):
        for a in arg:
          print_panel(a)
      else:
        panel.run_command('append', {'characters': "{}\n".format(arg), 'force': True})

    # Convenience method for formatting results
    def make_error(point, message):
      # Note rowcol() is zero-indexed but we must print one-indexed for error navigation
      rowcol = self.view.rowcol(point)
      return "{}:{}:{}: {}".format(self.view.file_name(), rowcol[0] + 1, rowcol[1] + 1, message)

    # Show the build results panel
    def show_panel():
      self.view.window().run_command('show_panel', {'panel': 'output.exec'})

    countAsrtFail = 0
    countAsrtTotal = 0
    checkedPts = []
    errorResults = []

    # Iterate over lines starting with "#!"
    for lineReg in self.view.find_all(r'^#!'):
      lineRegB = lineReg.begin()

      # Skip the start of the file
      if lineRegB == 0:
        continue

      # Get full line string
      lineReg = self.view.line(lineReg)
      lineRegE = lineReg.end()
      lineText = self.view.substr(lineReg)
      lineSize = lineReg.size()

      # relPt is a point relative to the start of this line
      relPt = 2 # Skip first two chars because they are "#!"
      pointLeft = False
      pointVert = None
      hiliteAsrt = []
      while relPt < lineSize:
        if lineText[relPt] == '<' and lineText[relPt + 1] == '-' and not pointLeft:
          pointLeft = True # Only allow "<-"/"<--" to appear once
          if lineText[relPt + 2] == '-':
            hiliteAsrt.append(1) # Second char on line
            relPt += 2
          else:
            hiliteAsrt.append(0) # First char on line
            relPt += 1
        elif lineText[relPt] == '^' and pointVert != 'down':
          pointVert = 'up' # All remaining vertical arrows must be this way
          hiliteAsrt.append(relPt)
        elif lineText[relPt] == 'V' and pointVert != 'up':
          pointVert = 'down' # All remaining vertical arrows must be this way
          hiliteAsrt.append(relPt)
        elif lineText[relPt] == ' ':
          pass # Ignore whitespace
        else: # Something other than [<^V ]
          break # From here on is the name
        relPt += 1

      # If line only pointed left then target line must be above the assert line
      if not pointVert:
        pointVert = 'up'

      # Check the assertion line for the name
      if relPt < lineSize:
        assertName = self.view.substr( sublime.Region(lineRegB + relPt, lineRegE) ).strip()
      else:
        print_panel(make_error(lineRegE, "Incomplete assertion line"))
        print_panel("FAILED: There was an error parsing the file")
        show_panel()
        return # Abort!

      # Walk forwards or backwards to find the first non-comment line (the target line)
      targetLineRegB = lineRegB
      targetLineRegE = lineRegE
      while self.view.find(r'^#!', targetLineRegB).begin() == targetLineRegB:
        if pointVert == 'up':
          targetLineReg = self.view.line(targetLineRegB - 1)
        elif pointVert == 'down':
          targetLineReg = self.view.line(targetLineRegE + 1)
        targetLineRegB = targetLineReg.begin()
        targetLineRegE = targetLineReg.end()
        targetLineSize = targetLineReg.size()

      countAsrtTotal += len(hiliteAsrt)
      for relPt in hiliteAsrt:
        # Check if this assertPt would extend beyond end of targetLine
        if relPt > targetLineSize:
          errorResults.append(make_error(lineRegB + relPt, "Assertion extends beyond end of line"))
          countAsrtFail += 1
          continue

        # Convert point relative along the assert line to absolute in the target line
        assertPt = targetLineRegB + relPt
        checkedPts.append(assertPt)

        # Check if the expected point is drawn, and what name that drawn region has
        foundPt = False
        foundName = None
        for drawn in self.drawnRegions.values():
          if drawn['area'].begin() <= assertPt < drawn['area'].end():
            # Can't use .contains() because it's end-inclusive
            foundPt = True
            if drawn['name'] == assertName:
              foundName = True
            else:
              foundName = drawn['name']
            break

        if foundPt:
          if foundName is True:
            # The assertion succeeded, yay!
            pass
          elif foundName is not None:
            # There's a drawn region, but with wrong name :(
            errorResults.append(make_error(assertPt, "Expectation [{}] does not match region [{}]".format(assertName, foundName)))
            countAsrtFail += 1
        else:
          # There is no drawn region at all D:
          errorResults.append(make_error(assertPt, "Expectation [{}] does not exist".format(assertName)))
          countAsrtFail += 1

    # Find any points that have a region drawn on them but weren't checked by any explicit assertion
    # Call these more failed assertions, since we implicitly asserted they *wouldn't* exist!
    for drawn in self.drawnRegions.values():
      for dPt in range(drawn['area'].begin(), drawn['area'].end()):
        if dPt not in checkedPts:
          errorResults.append(make_error(dPt, "Unexpected region [{}]".format(drawn['name'])))
          countAsrtFail += 1
          countAsrtTotal += 1

    # Sort by the line and column numbers only, by converting them to a unified int (column number can't exceed 9999)
    # Use regex matching instead of simple string splitting because filename may contain a ':' on Windows
    def rowColInt(s):
      match = re.match(r'(.*):([0-9]+):([0-9]+):', s)
      return int(match.group(2))*10000 + int(match.group(3))
    errorResults.sort(key = rowColInt)
    print_panel(errorResults)

    if countAsrtFail == 0:
      print_panel("Success: {} assertion{} in file passed".format(countAsrtTotal, "" if countAsrtTotal == 1 else "s"))
    else:
      print_panel("FAILED: {} of {} assertion{} in file failed".format(countAsrtFail, countAsrtTotal, "" if countAsrtTotal == 1 else "s"))

    show_panel()

  @abc.abstractmethod
  def _should_markup(self):
    # Return bool
    pass

  @abc.abstractmethod
  def _test_draw_region(self, region, selector, regionID):
    # Return None or a dict of the properties 'name', 'scope', and 'style' (optional
    # properties: 'quick-check-selector')
    pass

  @abc.abstractmethod
  def _build_status(self):
    # Return None or (critical [bool], message [string])
    pass


# Define text command run_highlighter_test_trigger
class RunHighlighterTestTriggerCommand(sublime_plugin.TextCommand):
  def is_visible(self):
    return False


# Define window command run_highlighter_test
# Only a window command can be a build system target
class RunHighlighterTestCommand(sublime_plugin.WindowCommand):
  def run(self):
    self.window.run_command('run_highlighter_test_trigger')
