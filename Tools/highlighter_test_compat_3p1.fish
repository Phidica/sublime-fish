#! HIGHLIGHTER TEST COMPATIBILITY fish3.1

# No regions (3.0)
git reset HEAD@{0} { foo }
ech{o} out

# No regions (3.0)
echo arg &>file &>?file \
  &>>file &>>?file
echo arg &| cat

# No region (3.0)
VAR=val echo $VAR
