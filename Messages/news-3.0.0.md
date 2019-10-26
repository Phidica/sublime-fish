News - 3.0.0
============

Welcome to the next major release of the Sublime Text fish package!
This is an overview of changes. To see all the changes, go to
Preferences > Package Settings > Fish > Changelog.

This release brings complete support for fish 3.0 syntax highlighting.

Important! Some settings keys have changed!
`fish_indent_directory` has been renamed to `fish_directory`, and
`blacklist` has been renamed to `indent_on_save_blacklist`.
If you previously customised these settings, please update them.

You may now notice bright borders around snippets of text in your scripts.
Hover over any such outline to see more information. Generally this
is to alert you to code that is incompatible with the version of fish
that will execute the script, or syntax that has been deprecated. The
popup will offer a hint on how to resolve the issue.

You may also notice that some file paths within your fish scripts
appear underlined. This verifies they are valid paths to existing files.

Take a look at the new [wiki](https://github.com/Phidica/sublime-fish/wiki)
(shortcut at Preferences > Package Settings > Fish > Documentation) to read
more about these features and their customisations.
