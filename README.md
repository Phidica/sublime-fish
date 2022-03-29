Friendly Interactive Shell (fish)
=================================

A Sublime Text package for the [friendly interactive shell](https://github.com/fish-shell/fish-shell).
It features a robust syntax highlighting scheme that mimics the native highlighting behaviour of fish.

The package currently supports up to fish version: **3.4**

Note: ST3 support will cease in a future release. ST2 support is capped at fish 2.7 with a limited set of the following features.

Features
--------

- Snippets for common constructs.
- Extensive syntax highlighting:
  - [Compatibility highlighter](https://github.com/Phidica/sublime-fish/wiki/Compatibility-highlighter): Code that is incompatible with the targeted version of fish is outlined.
  - [Path highlighter](https://github.com/Phidica/sublime-fish/wiki/Path-highlighter): Paths to existing files are underlined, just like in the fish shell.
- [Indent and prettify](https://github.com/Phidica/sublime-fish/wiki/Indent-and-prettify): Reformat the active file with `fish_indent`:
  - Use `ctrl+alt+i` or your build system shortcut (eg, `ctrl+b`).
  - Optional setting to run automatically when file is saved.

Installation
------------

### Via Package Control

Install [Package Control](https://packagecontrol.io), then go to Command Palette (Ctrl+Shift+P) > Package Control: Install Package > fish.

### Manual

Clone the repository to your [Packages directory](https://www.sublimetext.com/docs/packages.html) and rename it to `fish`.

    cd /path/to/sublime/packages/directory
    git clone https://github.com/Phidica/sublime-fish.git
    mv sublime-fish fish

Open a `.fish` file and verify the selected syntax is "Fish".

Screenshots
-----------

As of release 3.0.0, a fish script (for example, `fish-shell/share/functions/ls.fish`) will look something like:

![Screenshot of text in Monokai](https://imgur.com/JXyEMna.png)

Figure 1: Default Monokai colour scheme

![Screenshot of text in custom Monokai](https://imgur.com/qeyw0ld.png)

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
| Redirection                | `meta.function-call.operator.redirection.`{`stdin`,`stdout`,`stderr`}`.`{`explicit`,`implicit`} and `keyword.operator.redirect.`{`truncate`,`append`}
| Job expansion              | `meta.function-call.parameter.argument.job-expansion` and `punctuation.definition.job`
| Process expansion          | `meta.function-call.parameter.argument.process-expansion` and `punctuation.definition.process`
| Variable expansion         | `meta.variable-expansion` and `punctuation.definition.variable`
| Command substitution       | `meta.parens.command-substitution` and `punctuation.section.parens.begin`/`end`
| Index expansion            | `meta.brackets.index-expansion` and `punctuation.section.brackets.begin`/`end`
| Brace expansion            | `meta.braces.brace-expansion` and `punctuation.section.braces.begin`/`separator`/`end`
| Wildcard expansion         | `meta.wildcard-expansion` and `keyword.operator.question-mark`/`single-star`/`double-star`
| Home directory expansion   | `keyword.operator.tilde`

Branches and releases
---------------------

Support for different ST major versions is separated between several branches:

- `master`: Plugins compatible with ST4, and syntax provides highlighting for fish versions 2.7 *and up*.
- `st3`: Plugins compatible with ST3 and above (via backwards compatibility features), and syntax provides highlighting for fish versions 2.7 *and up*.
- `st2`: Plugins only compatible with ST2, syntax uses the more limited `tmLanguage` scheme instead of `sublime-syntax`, and provides highlighting for fish 2.7 *only*.

The particular fish major version supported by a tagged release is indicated by the version number:

- The 2.x.x series (on `st2` and `st3`) only supports fish 2.7.
- The 3.x.x series (on `st3` and `master`) includes support for fish 3.0 and beyond.

Contribution
------------

Requirements:

- [PackageDev](https://github.com/SublimeText/PackageDev), only for ST2 development and changing the `tmPreferences` file.

ST2 development: The source file of the syntax is `fish.YAML-tmLanguage`. When editing this file, "compile" it with the PackageDev build system to automatically generate the `fish.tmLanguage` file which is used by Sublime Text 2.

ST3+ development: The source file of the syntax is `fish.sublime-syntax`.

Guide for contributing is located [here](CONTRIBUTING.md).

History
-------

The first Sublime Text fish syntax highlighter was by [toru hamaguchi](https://github.com/toru-hamaguchi/sublime-fish-shell). When that project became unmaintained, @Phidica fully rewrote the schema and replaced the links on Package Control.
