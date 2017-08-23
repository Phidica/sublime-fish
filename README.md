Shell Script Improved (fish)
============================

A Sublime Text 2/3 package for [fish-shell](https://github.com/fish-shell/fish-shell). It features a robust syntax highlighting scheme that mimics the native highlighting behavior of fish.

This package is currently under active development and, while complete enough for general use, is not yet fully implemented.

To do:
- Command piping
- Additional useful highlighting

Installation
------------

Clone the repository to your [Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish-shell-improved.git

Open a `.fish` file and set the default syntax highlighting to "Shell Script Improved (fish)".

Exposed scopes
--------------

| fish construct       | Scope name
| :------------:       | :----------
| Unquoted string      | `meta.string.unquoted`
| File path            | `meta.path`
| Variable expansion   | `meta.variable-expansion` and `punctuation.definition.variable`
| Index expansion      | `meta.brackets.index-expansion` and `punctuation.section.brackets.index-expansion.begin`/`end`
| Process expansion    | `meta.process-expansion` and `punctuation.definition.process`

Contribution
------------

This package is built with [PackageDev](https://github.com/SublimeText/PackageDev).

The source file for the syntax highlighting is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
