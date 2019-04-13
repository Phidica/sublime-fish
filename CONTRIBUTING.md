Major changes or additions
==========================

Before starting work on significant contributions, please open an issue to discuss them. For example, work may already be underway on a similar project.

Developing
==========

- Check there are no silent errors in the console (``ctrl+` ``) after conversion from YAML-tmLanguage to tmLanguage, especially from "comment" elements being where they aren't actually allowed.

- Check all syntax tests pass.

- Check syntax test file doesn't crash in ST2 (caused by infinite recursion in the old regex engine)

- Check all commit messages pass basic gitlint tests.

Style guide
===========

In commit messages, use '' and "" to quote characters and commands, respectively. In `CHANGELOG.md` use \`\` for both.

For collaborators cutting a new release
=======================================

Ensure `CHANGELOG.md` has a new version number, and all *relevant* committed changes (ie, changes that users will see the effects of) are logged.
- Only pluralise headings for lists of more than one item.
- Be aware that the text is copied directly to the GitHub release description, so stick to valid markdown.

Bump the version number in `messages.json` to the new version number in `CHANGELOG.md`.

If there's a major addition, add a news message and link it in `messages.json`.

Ensure all changes are on master, `git push origin master`.

Create a tagged release on GitHub: put new version number in fields for tag *and* title, and copy in the `CHANGELOG.md` text for that release directly.
