friendly interactive shell (fish)
=================================

A Sublime Text 2/3 package for the [friendly interactive shell](https://github.com/fish-shell/fish-shell). It features a robust syntax highlighting scheme that mimics the native highlighting behaviour of fish.

All the general syntax of fish is completely implemented, however a number of additional features are planned and suggestions or bug reports are welcome.

To do:
- Optimise scope nesting
- Add further useful highlighting (eg, `[ ... ]` form of `test`)
- Rewrite for `.sublime-syntax`

Features
--------

- Extensive syntax highlighting
- Snippets for common constructs
- Indentation and prettification of the active file (with `fish_indent`)
  - Use `ctrl+alt+i` or your build system shortcut (eg, `ctrl+b`)
  - Optional setting to run automatically on save
  - More information [here](Messages/news-2.3.0.md)

Installation
------------

### Via Package Control

Install [Package Control](https://packagecontrol.io), then go to Command Palette (Ctrl+Shift+P) > Package Control: Install Package > fish.

### Manual

Clone the repository to your [Packages directory](http://docs.sublimetext.info/en/latest/basic_concepts.html#the-packages-directory) and rename it to `fish`.

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish.git
    mv sublime-fish fish

Open a `.fish` file and ensure the default syntax highlighting is "friendly interactive shell (fish)".

Screenshots
-----------

As of version 2.1.0, a fish script (for example, `fish-shell/share/functions/ls.fish`) will look something like:

![Screenshot of text in Monokai](https://imgur.com/UUrDBSl.png)

Figure 1: Default Monokai colour scheme

![Screenshot of text in custom Monokai](https://imgur.com/oX51Ku7.png)

Figure 2: Example custom Monokai colour scheme formatting additional scopes

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

The source file for the syntax is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text.

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
