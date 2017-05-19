Sublime Shell Script Improved (fish)
====================================

A Sublime Text 2/3 package for [fish-shell](https://github.com/fish-shell/fish-shell). It features a robust syntax highlighting scheme that mimics the native highlighting behavior of fish.

This package is currently under active development and, while complete enough for general use, is not yet fully implemented.

To do:
- Command piping
- Output redirection

Installation
------------

Clone the repository to your [Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish-shell.git

Open a `.fish` file and set the default syntax highlighting to "Shell Script Improved (fish)".

Highlighting strings
--------------------

As with any shell, a string in fish that isn't enclosed in quotes is considered an "unquoted string". If your Sublime Text color scheme highlights unquoted strings the same way it does quoted strings then you might find the result visually unappealing, as almost everything is a string. You may therefore wish to render unquoted strings in the default text color instead. To do so, edit your color scheme `.tmTheme` file and change

    <key>name</key>
    <string>String</string>
    <key>scope</key>
    <string>string</string>

to

    <key>name</key>
    <string>String</string>
    <key>scope</key>
    <string>string.quoted, string - string.unquoted</string>

This will exclude unquoted strings from receiving string highlighting, but it also explicitly enforces string highlighting on quoted strings to ensure that quoted strings embedded within unquoted strings (such as via a command substitution) receive the correct highlighting.

This should have no negative effects on other syntaxes which use strings, provided they follow convention and correctly scope them as "string.quoted".

Contribution
------------

This package is built with [PackageDev](https://github.com/SublimeText/PackageDev).

The source file for the syntax highlighting is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
