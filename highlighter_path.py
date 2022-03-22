import os.path
import logging
import re
import sublime, sublime_plugin

from fish.highlighter_base import BaseHighlighter


class PathHighlighter(sublime_plugin.ViewEventListener, BaseHighlighter):
  def __init__(self, view):
    sublime_plugin.ViewEventListener.__init__(self, view)
    BaseHighlighter.__init__(self, view)

    self.viewDir = None

    # Override default properties of the template
    self.selectors = [
      'meta.function-call.parameter.argument.path.fish',
      'meta.function-call.operator.redirection.path.fish',
    ]

  # def __del__(self):
  #   BaseHighlighter.__del__(self)

  @classmethod
  def is_applicable(self, settings):
    try:
      return 'Packages/fish/fish' in settings.get('syntax') and 'path' in settings.get('enabled_highlighters')
    except TypeError: # In weird cases get() comes back NoneType
      return False

  @classmethod
  def applies_to_primary_view_only(self):
    return False

  # Using _async functions means regions may flash onscreen as they are changed,
  #   however the advantage is that input is not blocked. In very big files
  #   this is essential

  # Review full file at load
  def on_load_async(self):
    self.logger.debug("on_load")
    self._update_markup()

  # Review full file at save
  def on_post_save_async(self):
    self.logger.debug("on_post_save")
    self._update_markup()

  # Review current line after each modification
  # We still iterate over every currently drawn region to test if it should be
  #   erased, however we only test new regions that are on the current line,
  #   preventing a potentially large number of disk operations (testing if
  #   files exist)
  def on_modified_async(self):
    self.logger.debug("on_modified")
    self._update_markup(local = True)

  def on_text_command(self, command_name, args):
    if command_name == 'run_highlighter_test_trigger' \
    and self.view.find(r'^#! HIGHLIGHTER TEST PATH', 0).begin() == 0:
      self._run_test()

  def _should_markup(self):
    # If view is not backed by a file on disk then we have no directory reference
    filePath = self.view.file_name()
    if filePath is None:
      self.logger.info("Refusing to mark up unsaved buffer")
      return False

    # First time we have a file path, note the directory
    # Assumes directory cannot change while view is open (is this true?)
    if self.viewDir is None:
      self.viewDir = os.path.dirname(filePath)
      self.logger.info("Active directory = {}".format(self.viewDir))

    return True

  def _test_draw_region(self, region, selector, regionID):
    text = self.view.substr(region)
    self.logger.debug("Region {} text = {}".format(region, text))

    if text.startswith('~'):
      testPath = os.path.expanduser(text)
    else:
      # Attempt to extract the quoted text, but don't try anything smart
      #   like stripping whitespace as the quotes are there to preserve it
      if '"' in text or "'" in text:
        try:
          # I think this is safe, because to get here the text can't contain spaces unless the whole thing is quoted, so there isn't any way to do anything malicious
          # Alternatively we could getFishOutput(['echo', text]), but that puts a dependency on fish being installed
          newText = eval(text)
          text = newText
          if text == "":
            return None
        except (SyntaxError, NameError):
          return None

      # Keep an absolute path, otherwise assume we have a relative one
      if text.startswith('/'):
        testPath = text
      elif sublime.platform() == 'windows':
        # Fish can handle native Windows paths, but we have to take a little care
        if re.match(r'([A-z]:)?(\\\\|/)', text):
          # This is an absolute path with an optional drive and double backslash or single slash.
          # If a drive wasn't given, os.path will insert the drive of the viewDir
          testPath = os.path.join(self.viewDir, text)
        elif re.match(r'\\', text):
          # This is only one backslash, which to fish looks like a character escape and not a path
          return None
        elif any(c in text for c in [':', '*', '?']):
          # True Windows files can't contain these symbols. In Cygwin/MSYS2 they could, but we're agnostic of those subsystems
          return None
        else:
          # Otherwise just a regular relative path
          testPath = os.path.join(self.viewDir, text)
      else:
        testPath = os.path.join(self.viewDir, text)

    self.logger.debug("Test path = {}".format(testPath))

    if not os.path.exists(testPath):
      return None

    # We want the drawn region to be marked up like the actual text (eg, a
    #   string, etc), so draw using the complete scope of the last character.
    #   The only reason not to use the first character is that it might be a tilde
    drawScope = self.view.scope_name(region.end() - 1)

    # Whitespace will not be underlined, see https://github.com/SublimeTextIssues/Core/issues/137
    drawStyle = sublime.DRAW_NO_FILL | sublime.DRAW_NO_OUTLINE | sublime.DRAW_SOLID_UNDERLINE

    return dict(name = 'path', scope = drawScope, style = drawStyle)

  def _build_status(self):
    return None
