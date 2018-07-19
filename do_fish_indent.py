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

    # Check for executable
    exe = 'fish_indent'
    pathToDir = self.view.settings().get('fish_indent_directory')
    if pathToDir:
      exe = os.path.join(pathToDir, exe)

    # Select the entire contents of the file
    fileRegion = sublime.Region(0, self.view.size())
    fileContent = self.view.substr(fileRegion)

    # Note the file encoding, converting to lowercase as expected by Python
    # However, fish_indent assumes UTF-8 encoding so the user may get unexpected results if this file's encoding is different
    enc = self.view.encoding().lower()
    if enc == 'undefined': # ie, temp file
      enc = 'utf-8'
    print('Running {0} on file with encoding {1}'.format(exe, enc))

    # Run the program, which is searched for on PATH if necessary
    try:
      # Pipe the file content into fish_indent and catch the outputs
      p = subprocess.Popen(exe, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
      out, err = p.communicate(input = fileContent.encode(enc))
    except OSError: # Soft compatibility with Python 2
      msg = "Couldn't find {0}".format(exe)
      sublime.error_message(msg)
      return

    if err:
      sublime.message_dialog(err.decode('utf-8'))

    # Create a copy of all current cursor positions
    pos = list( self.view.sel() );

    # Replace the entire contents of the file with the output of fish_indent
    self.view.replace(edit, fileRegion, out.decode(enc))

    # Note the user's current settings for this buffer
    indentUsingSpaces = self.view.settings().get('translate_tabs_to_spaces')
    tabSize = self.view.settings().get('tab_size')

    # Convert the format to the user's preferred format
    if indentUsingSpaces and tabSize == 4:
      # Do nothing as this is the format produced by fish_indent
      pass
    else:
      # Convert sets of 4 spaces to tabs
      # Note that running unexpand_tabs will set translate_tabs_to_spaces to False
      self.view.settings().set('tab_size', 4)
      self.view.run_command('unexpand_tabs')

      if not indentUsingSpaces:
        # User prefers tabs
        if tabSize == 4:
          # Conversion finished
          pass
        else:
          # Resize
          self.view.settings().set('tab_size', tabSize)
      else:
        # User prefers spaces, so reset to True
        self.view.settings().set('translate_tabs_to_spaces', True)

        # Resize tabs, then convert back into spaces
        self.view.settings().set('tab_size', tabSize)
        self.view.run_command('expand_tabs')

    # Revert back to the old cursor positions and centre on the first one
    self.view.sel().clear()
    if versionAPI == 3:
      self.view.sel().add_all(pos)
    elif versionAPI == 2:
      map(self.view.sel().add, pos)
    self.view.show_at_center(pos[0])