Sublime fish shell
==================

Sublime Text 2/3 package for [fish-shell](https://github.com/fish-shell/fish-shell). Features syntax highlighting and snippets.


Installation
------------

Clone the repository to your [Sublime Text Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish-shell.git

Open a `.fish` file and set the default syntax highlighting to "Shell Script (fish)".

Contribution
------------

This package is built with [PackageDev](https://github.com/SublimeText/PackageDev).

The source file for the syntax highlighting is `fish.json-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
