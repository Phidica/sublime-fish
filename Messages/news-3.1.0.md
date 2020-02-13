News - 3.1.0
============

This release brings complete support for fish 3.1 syntax highlighting.
This is an overview of changes. To see all the changes, go to
Preferences > Package Settings > Fish > Changelog.

The only behavioural change (ie, ignoring totally new features) relates to brace
expansion, which no longer occurs unless a comma or variable appears within the
braces. If you are targeting an older version of fish, then the compatibility
highlighter will warn you when the syntax highlighting doesn't imply that this
will happen even though it actually will.

As a quick check whether there are any compatibility issues in your current
script, you can now take a look at the status bar (bottom left of the Sublime
Text window) where a summary will be displayed.
