#! HIGHLIGHTER TEST PATH

# For these tests this file must be on the C drive (where we assume the "Windows" directory exists), but in general paths onto other drives work

# Single slash only has meaning inside Cygwin/MSYS2, which os.path isn't aware of
ls /bin

# Single backslash (ie, unescaped) not an absolute path!
ls \Windows

# Double backslash is an absolute path on the same drive as this file
ls \\Windows
#! ^^^^^^^^^ path

# Can include a drive specifier, but must have double backslash
ls C: C:\  C:\\ C:\\Windows
#!         ^^^^ ^^^^^^^^^^^ path

# Slash notation is also compatible with drive specifiers
ls C:/ C:/Windows
#! ^^^ ^^^^^^^^^^ path

cat dir\\file dir/file
#!  ^^^^^^^^^ ^^^^^^^^ path
