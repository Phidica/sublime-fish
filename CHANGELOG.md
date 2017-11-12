Changelog
=========

2.2.1
-----

Bugfixes:
- An argument consisting of a lone `-` was scoped as an option

2.2.0
-----

Improvements:
- Make numeric scoping more consistent, and now recognise numbers starting with a plus or minus sign.
  After the end of options argument `--`, an argument like `-5` will be scoped as numeric rather than as an option. Additionally, recognition of sign is important for when numbers are used in index expansion

Bugfixes:
- Redirected process expansion failed to recognise special names like "self"

2.1.2
-----

Bugfixes:
- A command call line ending with `=` did not terminate
- An `=` could not safely be a command name

2.1.1
-----

Bugfixes:
- A lone `.` was scoped as a decimal point for a numeric

2.1.0
-----

New features:
- Support for short (`-x`) and long (`--x=arg`) option arguments using the `variable.parameter` scope
- Recognise `--` as the end of options and treat further arguments as normal, even if they start with a dash

2.0.1
-----

Bugfixes:
- Comment lines could incorrectly appear after certain line continuations
- stderr redirection into pipe (`^|` and `^^|`) was not recognised
