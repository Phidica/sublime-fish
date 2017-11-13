Changes - 2.1.0
===============

New features:
- Support for short (`-x`) and long (`--x=arg`) option arguments using the `variable.parameter` scope (#5)
- Recognise `--` as the end of options and treat further arguments as normal, even if they start with a dash
