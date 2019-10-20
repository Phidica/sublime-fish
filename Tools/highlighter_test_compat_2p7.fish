#! HIGHLIGHTER TEST COMPATIBILITY fish2.7

! true; !! true
#! <- op-bang

true && ! false
#!   ^^ op-double-ampersand
#!      ^ op-bang

# No regions here
true & false
true &&& true
true >&& false

false || ! true
#!    ^^ op-double-bar
#!       ^ op-bang

# No regions here
false | true
false ||| true
false >|| true

# In fish 2.7 this comment is illegal, but no way to check currently
test pipe | # comment
and same pipe

test pipe |
#!         ^ op-newline-in-pipeline
and same pipe

test pipe &&
#!        ^^ op-double-ampersand
#!          ^ op-newline-in-pipeline
and same pipe ||
#!            ^^ op-double-bar
#!              ^ op-newline-in-pipeline
and same pipe

# No regions (3.0)
echo arg ^&11 ^^&12 2>&13 2>>&14 \
  ^a ^^b 2>c 2>>d \
  ^?e ^^?f 2>?g 2>>?h \
  ^|i ^^|j 2>|k 2>>|l

# No regions (3.0)
echo star* qmark? foo??r

ech{o,a}
#! ^^^^^ cmd-brace-expansion

$function; /bin/$function-2 arg
#! <- cmd-variable-expansion
#! <-- cmd-variable-expansion
#!^^^^^^^       ^^^^^^^^^ cmd-variable-expansion

echo {} out {   } {  b  }
#!   ^^ arg-braces-empty
#!           ^^^   ^^ ^^ arg-braces-space

#!      V arg-braces-space
echo {a,
b}

# No regions (3.0)
echo %a1 %name %12w %selfa%self %lasta
