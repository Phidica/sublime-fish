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
echo arg ^&11 2>&12 ^^&13 2>>&14 \
  ^a 2>b ^^c 2>>d \
  ^?e 2>?f ^^?g 2>>?h \
  ^|i 2>|j ^^|k 2>>|l

# No regions (3.0)
echo star* qmark? foo??r

ech{o,a}
#! ^^^^^ cmd-brace-expansion

$function; /bin/$function-2 arg
#! <- cmd-variable-expansion
#! <-- cmd-variable-expansion
#!^^^^^^^       ^^^^^^^^^ cmd-variable-expansion

echo {} out {   } {  ,  }
#!   ^^ arg-braces-empty
#!           ^^^   ^^ ^^ arg-braces-space

#!      V arg-braces-space
echo {a,
b}

echo {$var} {foo} { foo }
#!          ^^^^^ arg-braces-non-empty
#!                 ^   ^ arg-braces-space

# No regions (3.0)
echo %a1 %name %12w %selfa%self %lasta
