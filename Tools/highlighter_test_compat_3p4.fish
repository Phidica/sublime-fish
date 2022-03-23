#! HIGHLIGHTER TEST COMPATIBILITY fish3.4

# No regions (3.3)
echo "$(echo out)"
echo $(echo out)

# No regions
echo out & echo
echo  out& echo
echo     &echo
echo  out&&echo

echo  out&echo
#!       ^ op-ampersand-nobg-in-token
begin echo out&end ; end
#!            ^ op-ampersand-nobg-in-token
echo (echo out&#)echo
#!            ^ op-ampersand-nobg-in-token
)
