import sublime, sublime_plugin
import os.path
import subprocess

# Only a TextCommand can use replace()
class DoFishIndentCommand(sublime_plugin.TextCommand):
  def is_enabled(self):
    # We are very incompatible with ST1 and probably ST4 one day
    return 2 <= int(sublime.version()[0]) <= 3

  def is_visible(self):
    return 'source.shell.fish' in self.view.scope_name(self.view.sel()[0].begin())

  def description(self):
    return 'Indent and Prettify'

  def run(self, edit):
    versionAPI = int(sublime.version()[0])

    # Check for executable, expanding search to valid fish installs on Windows
    exe = 'fish_indent'
    pathToDir = self.view.settings().get('fish_indent_directory')
    if not pathToDir and sublime.platform() == 'windows':
      if sublime.arch() == 'x32':
        testPaths = ('C:/cygwin/bin', 'C:/msys32/usr/bin')
      elif sublime.arch() == 'x64':
        testPaths = ('C:/cygwin64/bin', 'C:/msys64/usr/bin')
      for p in testPaths:
        if os.path.exists(p):
          pathToDir = p
          break
    if pathToDir:
      exe = os.path.join(pathToDir, exe)

    # Note the user's current settings for this buffer
    indentUsingSpaces = self.view.settings().get('translate_tabs_to_spaces')
    tabSize = self.view.settings().get('tab_size')

    # If user does not use the native fish_indent format, convert file to tabs
    #   of user's preferred width. Then when the formatted text is inserted,
    #   we can convert it to tabs of width 4 without affecting anything else in
    #   the file
    # Note that unexpand_tabs sets translate_tabs_to_spaces to false
    if not indentUsingSpaces or not tabSize == 4:
      self.view.run_command('unexpand_tabs')

    # Note the file encoding, converting to lowercase as expected by Python
    # However, fish_indent assumes UTF-8 encoding so the user may get
    #   unexpected results if this file's encoding is different
    enc = self.view.encoding().lower()
    if enc == 'undefined': # ie, temp file
      enc = 'utf-8'
    print('Running {0} on file with encoding {1}'.format(exe, enc))

    # Create a copy of all current cursor positions (selection regions)
    # pos = list( self.view.sel() );

    # Select the first region
    # inputRegion = sublime.Region(0, self.view.size())

    # Iterate over the user's current selection regions
    for inputRegion in self.view.sel():
      # Skip zero-width cursor placements
      if inputRegion.size() == 0:
        continue

      inputContent = self.view.substr(inputRegion)

      # Run the program, which is searched for on PATH if necessary
      try:
        # Pipe the file content into fish_indent and catch the outputs
        p = subprocess.Popen(exe, stdin = subprocess.PIPE, stdout = subprocess.PIPE,
          stderr = subprocess.PIPE)
        out, err = p.communicate(input = inputContent.encode(enc))
      except OSError: # Soft compatibility with Python 2
        msg = "Couldn't find {0}".format(exe)
        if not pathToDir:
          msg += ". Specify a nonstandard install location in Preferences > " \
            "Package Settings > friendly interactive shell > Settings"
        sublime.error_message(msg)
        return

      if err:
        sublime.message_dialog(err.decode('utf-8'))

      # Replace the contents of the region with the output of fish_indent
      # We don't use replace() because it does not adequately track changes
      #   in cursor position. erase() changes the acted upon selection to be
      #   zero-width, and we recalculate its width based on the number of
      #   inserted characters
      beginIndex = inputRegion.begin()
      self.view.erase(edit, inputRegion)
      insChars = self.view.insert(edit, beginIndex, out.decode(enc))
      outputRegion = sublime.Region(beginIndex, beginIndex + insChars)

      # Add new selection region (extends the zero-width region now at beginIndex)
      self.view.sel().add(outputRegion)

    # Convert the format to the user's preferred format
    if indentUsingSpaces and tabSize == 4:
      # Do nothing as this is the format produced by fish_indent
      pass
    else:
      # Convert sets of 4 spaces to tabs in all the fish_indent output
      self.view.settings().set('tab_size', 4)
      self.view.run_command('unexpand_tabs')

      if not indentUsingSpaces:
        # User prefers tabs, which we now have
        if tabSize == 4:
          # Conversion finished
          pass
        else:
          # Resize everything back to the preferred tab size
          self.view.settings().set('tab_size', tabSize)
      else:
        # User prefers spaces, so set back to true after unexpand_tabs changed it
        self.view.settings().set('translate_tabs_to_spaces', True)

        # Resize tabs, then convert back into spaces
        self.view.settings().set('tab_size', tabSize)
        self.view.run_command('expand_tabs')

    # Ensure cursors remain in view and don't drift off with repeated runs
    # self.view.show(self.view.sel(), True)

# Only a WindowCommand can be a build system target
class DoFishIndentBuildCommand(sublime_plugin.WindowCommand):
  def run(self):
    self.window.run_command('do_fish_indent')

if sublime.version()[0] == '3':
  class DoFishIndentOnSave(sublime_plugin.ViewEventListener):
    def is_applicable(self):
      # In non-fish files the setting is unset (hence, we ask for False), or if
      #   the user set it to False then it will be False even in fish files
      return self.get('indent_on_save', False)

    def on_pre_save(self):
      # Skip blacklisted files
      if self.view.window().extract_variables()['file_name'] in self.view.settings().get('blacklist'):
        return
      self.view.run_command('do_fish_indent')
elif sublime.version()[0] == '2':
  class DoFishIndentOnSave(sublime_plugin.EventListener):
    def on_pre_save(self, view):
      if view.settings().get('indent_on_save') is not True:
        return
      if view.settings().has('blacklist') and os.path.basename(view.file_name()) in view.settings().get('blacklist'):
        return
      view.run_command('do_fish_indent')
