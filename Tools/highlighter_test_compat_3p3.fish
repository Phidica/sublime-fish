#! HIGHLIGHTER TEST COMPATIBILITY fish3.3

echo "$(echo out)"
#!    ^^^^^^^^^^^ op-cmdsub-in-str

echo $(echo out)
#!   ^ op-cmdsub-with-dollar

# No regions (3.4)
echo  out&echo
begin echo out&end ; end
echo (echo out&#)echo
)
