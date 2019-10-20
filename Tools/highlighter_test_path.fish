#! HIGHLIGHTER TEST PATH

# On Windows, os.path will interpret "~" as the user's home directory or drive
# On Windows, os.path will interpret "/" as the current drive, which could also be expanded "C:/" etc
# At present, this ignores Cygwin and MSYS2 environments so "/dev/null" for instance won't work

ls ~ ~~ /
#! ^    ^path

cat highlighter_test_path.fish "highlighter_test_path.fish"
#!  ^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ path

cat ./highlighter_test_path.fish
#!  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ path

cat ../Tools/highlighter_test_path.fish
#!  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ path

cat "fish - Highlighter Test.sublime-build"
#!  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ path

# No highlight on name fragments
test -e highlighter_test path.fish

echo >>highlighter_test_path.fish
#!     ^^^^^^^^^^^^^^^^^^^^^^^^^^ path

# No highlight on empty strings
echo \  "" ''
