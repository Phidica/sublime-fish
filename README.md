friendly interactive shell (fish)
=================================

A Sublime Text 2/3 package for the [friendly interactive shell](https://github.com/fish-shell/fish-shell). It features a robust syntax highlighting scheme that mimics the native highlighting behaviour of fish.

All the general syntax of fish is completely implemented, however a number of additional features are planned and bug reports are welcome.

To do:
- Optimise scope nesting
- Add further useful highlighting (eg, parameters)
- Rewrite for `.sublime-syntax`

Installation
------------

Clone the repository to your [Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory).

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish-shell-improved.git

Open a `.fish` file and set the default syntax highlighting to "friendly interactive shell (fish)".

Exposed scopes
--------------

| fish construct             | Scope name
| :------------:             | :----------
| Unquoted string            | `meta.string.unquoted`
| File path (in redirection) | `meta.path`
| Variable expansion         | `meta.variable-expansion` and `punctuation.definition.variable`
| Process expansion          | `meta.process-expansion` and `punctuation.definition.process`
| Command substitution       | `meta.parens.command-substitution` and `punctuation.section.parens.begin`/`end`
| Index expansion            | `meta.brackets.index-expansion` and `punctuation.section.brackets.begin`/`end`
| Brace expansion            | `meta.braces.brace-expansion` and `punctuation.section.braces.begin`/`separator`/`end`
| Home directory expansion   | `meta.home-directory-expansion` and `keyword.operator.tilde`
| Wildcard expansion         | `meta.wildcard-expansion` and `keyword.operator.question-mark`/`single-star`/`double-star`

Contribution
------------

This package is built with [PackageDev](https://github.com/SublimeText/PackageDev).

The source file for the syntax highlighting is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
