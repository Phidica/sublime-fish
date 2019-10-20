#! HIGHLIGHTER TEST COMPATIBILITY fish3.0

# No regions (2.7)
! true; !! true
true && ! false
false || ! true
test pipe |
and same pipe
test pipe &&
and same pipe ||
and same pipe

# No regions here (stdout only)
echo arg >&11 >>&12 1>&13 1>>&14 \
  >a >>b 1>c 1>>d \
  >?e >>?f 1>?g 1>>?h \
  >|i >>|j 1>|k 1>>|l&

echo arg ^&11 ^^&12 2>&13 2>>&14 \
#!       ^    ^^ op-stderr-nocaret
  ^a ^^b 2>c 2>>d \
#!^  ^^ op-stderr-nocaret
  ^?e ^^?f 2>?g 2>>?h \
#!^   ^^ op-stderr-nocaret
  ^|i ^^|j 2>|k 2>>|l
#!^   ^^ op-stderr-nocaret

echo star* qmark? foo??r
#!              ^    ^^ op-qmark-noglob

# No regions (2.7)
ech{o,a}
$function; /bin/$function-2 arg
echo {} out {   } {  b  }
echo {a,
b}

# No regions here (job expansion)
echo %1 %9999

echo %a1 %name %12w %self %selfa%self
#!   ^^^ ^^^^^ ^^^^       ^^^^^^^^^^^ arg-process-expansion

echo %last %lasta
#!   ^^^^^ arg-process-expansion-last
#!         ^^^^^^ arg-process-expansion
