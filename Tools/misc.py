import sublime
import os.path
import re
import subprocess

# Check for command, expanding search to valid fish installs on Windows
def commandOnAbsolutePath(command, settings):
  dirPath = settings.get('fish_directory')
  if type(dirPath) is dict:
    subl_os = sublime.platform()
    if subl_os in dirPath:
      dirPath = dirPath[subl_os]
    else:
      dirPath = None

  if not dirPath and sublime.platform() == 'windows':
    if sublime.arch() == 'x32':
      testPaths = ('C:/cygwin/bin', 'C:/msys32/usr/bin')
    elif sublime.arch() == 'x64':
      testPaths = ('C:/cygwin64/bin', 'C:/msys64/usr/bin')
    for p in testPaths:
      if os.path.exists(p):
        dirPath = p
        break

  if dirPath:
    return os.path.join(dirPath, command)
  else:
    return command

def getFishOutput(args, settings, pipeInput = None):
  # Put command name on an absolute path if needed
  command = args[0]
  args[0] = commandOnAbsolutePath(command, settings)

  out = None
  err = None
  try:
    # Run the program, which is searched for on PATH if necessary
    if pipeInput is None:
      out = subprocess.check_output(args, universal_newlines = True)
    else:
      p = subprocess.Popen(args, stdin = subprocess.PIPE, stdout = subprocess.PIPE,
        stderr = subprocess.PIPE, universal_newlines = True)
      # Pipe the file content in and catch outputs
      out,err = p.communicate(input = pipeInput)
  except FileNotFoundError:
    msg = "Error: Couldn't find {} executable.".format(args[0])
    # Check if command wasn't modified to an absolute path
    if args[0] == command:
      msg += " Specify a nonstandard install location in Preferences > " \
        "Package Settings > Fish > Settings."
    sublime.error_message(msg)
  except OSError as ex:
    # Right now I only know of this happening when fish is in WSL.
    # That's not meant to be supported, so keep the error quiet
    print("Error: Couldn't run {}, system reports '{}'".format(command, ex))

  return (out,err)

def getSetting(settings, name, schema, default = None):
  value = settings.get(name)
  # https://stackoverflow.com/a/30212799
  # Effectively backport re.fullmatch() to Python 3.3 by adding end-of-string anchor
  if re.match('(?:' + schema + r')\Z', value):
    return value
  else:
    sublime.error_message("Error in fish.sublime-settings: Invalid value '{}' for '{}'.".format(value, name))
    return default
