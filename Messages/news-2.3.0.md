News - 2.3.0
============

Sublime Text fish can now utilise `fish_indent` to automatically indent and prettify your fish code. Indentation will respect your view's current tab size preferences, including your choice of spaces or tabs.

Press `ctrl+alt+i` to trigger indentation and prettification in current document (either on any highlighted regions, or if no regions are highlighted then on the whole file), or use your build system shortcut (`ctrl+b` by default). Optionally, turn on automatic indentation at every save in the settings.

This feature is available on all platforms, and no configuration is necessary if your system has a standard fish install.

If fish is installed in an unusual way on your system, you can configure its install directory in Preferences > Package Settings > Fish > Settings. On Windows, the Cygwin or MSYS2 architecture is assumed to be the same as the system architecture; if this is not the case then configure the directory manually in the settings.
