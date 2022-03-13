#! HIGHLIGHTER TEST COMPATIBILITY fish3.3

echo "$(echo out)"
#!    ^^^^^^^^^^^ op-cmdsub-in-str

echo $(echo out)
#!   ^ op-cmdsub-with-dollar
