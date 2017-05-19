Sublime fish shell
==================

Sublime Text 2/3 package for [fish-shell](https://github.com/fish-shell/fish-shell). Features syntax highlighting and snippets.


Installation
------------

Clone the repository to your [Sublime Text Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish-shell.git

Open a `.fish` file and set the default syntax highlighting to "Shell Script (fish)".

Tweaks
------

As with any shell, every string in fish that isn't enclosed in quotes is considered an unquoted string. If your Sublime Text color scheme highlights unquoted strings the same way it does quoted strings then you might find the result unappealing, so you may wish to render unquoted strings in the default text color instead. To do so, edit your color scheme `.tmTheme` file and change

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

Contribution
------------

This package is built with [PackageDev](https://github.com/SublimeText/PackageDev).

The source file for the syntax highlighting is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
