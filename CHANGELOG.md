Changelog
=========

2.3.0
-----

New feature:
- Automatic indentation and prettification of fish files (#16):
  - Utilises the `fish_indent` program that comes with fish
  - Compatible with Sublime Text 2 and 3 on all platforms
    - No additional configuration is necessary for standard fish installs
  - Indentation respects user preferences of tab size
  - Indentation is restricted to highlighted regions if any are present, otherwise the full file is acted on
  - Default shortcut for indentation is `ctrl+alt+i`
  - Build system execution is also available
  - Optionally, turn on automatic indentation at every save

2.2.6
-----

Bugfixes:
- ST2 would freeze encountering consecutive command substitutions (#14)
- ST2 would freeze encountering consecutive variable expansions (#14)
- `end` at end of file wasn't highlighted correctly (#15)

2.2.5
-----

Bugfixes:
- ST2 would freeze encountering an escaped newline (#14)
- ST2 would freeze encountering a pipe (#14)
- `not` wasn't recognised in a command chain

2.2.4
-----

Bugfix:
- Control characters appearing in brace expansion would freeze ST2 (#14)

2.2.3
-----

Bugfix:
- Menu options could not open the README or CHANGELOG files

2.2.2
-----

Bugfix:
- Snippets did not use tabs for indenting (#12)

2.2.1
-----

Bugfix:
- An argument consisting of a lone `-` was scoped as an option

2.2.0
-----

Improvement:
- Make numeric scoping more consistent, and now recognise numbers starting with a plus or minus sign.
  After the end of options argument `--`, an argument like `-5` will be scoped as numeric rather than as an option. Additionally, recognition of sign is important for when numbers are used in index expansion

Bugfix:
- Redirected process expansion failed to recognise special names like "self"

2.1.2
-----

Bugfixes:
- A command call line ending with `=` did not terminate (#11)
- An `=` could not safely be a command name

2.1.1
-----

Bugfix:
- A lone `.` was scoped as a decimal point for a numeric (#10)

2.1.0
-----

New features:
- Support for short (`-x`) and long (`--x=arg`) option arguments using the `variable.parameter` scope (#5)
- Recognise `--` as the end of options and treat further arguments as normal, even if they start with a dash

2.0.1
-----

Bugfixes:
- Comment lines could incorrectly appear after certain line continuations
- stderr redirection into pipe (`^|` and `^^|`) was not recognised
