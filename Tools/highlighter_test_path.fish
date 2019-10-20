#! HIGHLIGHTER TEST PATH

# On Windows, os.path will interpret "~" as the user's home directory or drive
# On Windows, os.path will interpret "/" as the main drive (eg, "C:\") but fish will interpret it as relative to the Cygwin/MSYS2 environment
# So "/dev/null" for instance won't work on Windows

ls ~ ~~ /
#! ^    ^path

ls dir dir/ dir/file "dir/file"
#! ^^^ ^^^^ ^^^^^^^^ ^^^^^^^^^^ path

cat ./dir/file
#!  ^^^^^^^^^^ path

cat ../Tools/dir/file
#!  ^^^^^^^^^^^^^^^^^ path

cat "fish - Highlighter Test.sublime-build"
#!  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ path

# No highlight on name fragments
test -e highlighter_test path.fish

echo >>highlighter_test_path.fish
#!     ^^^^^^^^^^^^^^^^^^^^^^^^^^ path

# No highlight on empty strings
echo \  "" ''
