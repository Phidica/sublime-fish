friendly interactive shell (fish)
=================================

A Sublime Text 2/3 package for the [friendly interactive shell](https://github.com/fish-shell/fish-shell). It features a robust syntax highlighting scheme that mimics the native highlighting behaviour of fish.

All the syntax of fish 2.7 is completely implemented. fish 3.0 support is in development. Suggestions and bug reports are welcome.

ST2 support and ST3 support is separated between two branches:
- `st2`: Plugins only compatible with ST2, syntax uses `tmLanguage` scheme, and provides highlighting for fish 2.7 *only*.
- `master`: Plugins only compatible with ST3, syntax uses `sublime-syntax` scheme, and provides highlighting for fish 2.7 (and eventually fish 3.0).

The 2.x.x series of releases (on both ST support branches) only support fish 2.7.
The coming 3.x.x series of releases (on the `master` branch alone) will include support for fish 3.0.

Features
--------

- Extensive syntax highlighting.
- Snippets for common constructs.
- Indentation and prettification of the active file (with `fish_indent`):
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

Open a `.fish` file and verify the selected syntax is "Friendly Interactive Shell (fish)".

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
| Command name               | `meta.function-call.name`
| Parameters                 | `meta.function-call.parameter.option`/`argument`
| File path (in argument)    | `meta.function-call.parameter.argument.path`
| File path (in redirection) | `meta.function-call.operator.redirection.path`
| Process expansion          | `meta.function-call.parameter.argument.process-expansion` and `punctuation.definition.process`
| Variable expansion         | `meta.variable-expansion` and `punctuation.definition.variable`
| Command substitution       | `meta.parens.command-substitution` and `punctuation.section.parens.begin`/`end`
| Index expansion            | `meta.brackets.index-expansion` and `punctuation.section.brackets.begin`/`end`
| Brace expansion            | `meta.braces.brace-expansion` and `punctuation.section.braces.begin`/`separator`/`end`
| Wildcard expansion         | `meta.wildcard-expansion` and `keyword.operator.question-mark`/`single-star`/`double-star`
| Home directory expansion   | `keyword.operator.tilde`

Contribution
------------

Requirements:
- [PackageDev](https://github.com/SublimeText/PackageDev), only for ST2 development and changing the `tmPreferences` file.

ST2 development: The source file of the syntax is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text 2.

ST3 development: The source file of the syntax is `fish.sublime-syntax`.

Guide for contributing is located [here](CONTRIBUTING.md).

History
-------

This project was forked from original groundwork laid by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell).
