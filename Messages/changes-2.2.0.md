Changes - 2.2.0
===============

Improvements:
- Make numeric scoping more consistent, and now recognise numbers starting with a plus or minus sign.
  After the end of options argument `--`, an argument like `-5` will be scoped as numeric rather than as an option. Additionally, recognition of sign is important for when numbers are used in index expansion

Bugfixes:
- Redirected process expansion failed to recognise special names like "self"
