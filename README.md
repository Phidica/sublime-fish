
Sublime fish shell
==================

Sublime text 2/3 package for [fish-shell](https://github.com/fish-shell/fish-shell).

Installation
-----------

Clone the repository in your [Sublime Text Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/toru-hamaguchi/sublime-fish-shell.git

Tweaks
------

Almost everything in fish is an unquoted string, so if your color scheme highlights unquoted strings the same as quoted strings then you may wish to render the unquoted strings as normal text. To do so, edit the color scheme `.tmTheme` file and change

    <key>name</key>
    <string>String</string>
    <key>scope</key>
    <string>string</string>

to

    <key>name</key>
    <string>String</string>
    <key>scope</key>
    <string>string - string.unquoted</string>

Contribution
------------

This package using [PackageDev](https://github.com/SublimeText/PackageDev) to develop.

The syntax highlighting source is `fish.YAML-tmLanguage`. You can edit it and press F7 to rewrite.
