Major changes or additions
==========================

Before starting work on significant contributions, please open an issue to discuss them. For example, work may already be underway on a similar project.

Developing
==========

- (ST2 development only) Check there are no silent errors in the console (``ctrl+` ``) after conversion from YAML-tmLanguage to tmLanguage, especially from "comment" elements being where they aren't actually allowed.

- (ST2 development only) Check syntax test file doesn't crash in ST2 (caused by infinite recursion in the old regex engine).

- Check all syntax tests pass.

- Check all commit messages pass basic gitlint tests.

Style guide
===========

In commit messages, use '' and "" to quote characters and commands, respectively. In `CHANGELOG.md` use \`\` for both.

In commit messages, always use imperative forms of verbs ("add", "change", "fix", etc). In `CHANGELOG.md`, typically use imperative forms to describe new features, but describe fixed bugs in past tense.

For collaborators cutting a new release
=======================================

Ensure `CHANGELOG.md` has a new version number, and all *relevant* committed changes (ie, changes that users will see the effects of) are logged.
- Only pluralise headings for lists of more than one item.
- Be aware that the text is copied directly to the GitHub release description, so stick to valid markdown.

Bump the version number in `messages.json` to the version number in `CHANGELOG.md`. Depending on the release, enact one of the following two options:
- If this is a bugfix release or there's nothing that important to say, just bump the number corresponding to `Messages/changes.md`.
- If there's a major addition, add a news message `Messages/news-X.X.X.md` and set that to have the new highest version number. Don't do this *and* bump the `changes` number.

Ensure all changes are on master, `git push origin master`.

Create a tagged release on GitHub: put new version number in the title field, and version number prepended by `st2-` or `st3-` in the tag field, and copy in the `CHANGELOG.md` text for that release directly.
