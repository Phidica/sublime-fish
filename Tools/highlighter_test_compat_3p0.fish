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
echo arg >&11 1>&12 >>&13 1>>&14 \
  >a 1>b >>c 1>>d \
  >?e 1>?f >>?g 1>>?h \
  >|i 1>|j >>|k 1>>|l

echo arg ^&11 2>&12 \
#!       ^ op-stderr-nocaret-truncate
  ^^&13 2>>&14 \
#!^^ op-stderr-nocaret-append
  ^a 2>b \
#!^ op-stderr-nocaret-truncate
  ^^c 2>>d \
#!^^ op-stderr-nocaret-append
  ^?e 2>?f \
#!^ op-stderr-nocaret-truncate
  ^^?g 2>>?h \
#!^^ op-stderr-nocaret-append
  ^|i 2>|j \
#!^ op-stderr-nocaret-truncate
  ^^|k 2>>|l
#!^^ op-stderr-nocaret-append

echo arg &>file &>?file \
#!       ^^     ^^ op-std-write-file-truncate
  &>>file &>>?file
#!^^^     ^^^ op-std-write-file-append

echo arg &| cat
#!       ^^ op-std-write-pipe

echo star* qmark? foo??r
#!              ^    ^^ op-qmark-noglob

# No regions (2.7)
ech{o,a}
$function; /bin/$function-2 arg
echo {} out {   } {  ,  }
echo {a,
b}

VAR=val echo $VAR
#! <- cmd-environment
#! <-- cmd-environment
#!^^^^^ cmd-environment

git reset HEAD@{0} { foo }
#!             ^^^ ^^^^^^^ arg-braces-non-empty
ech{o} out
#! ^^^ arg-braces-non-empty

# No regions here (job expansion)
echo %1 %9999

echo %a1 %name %12w %self %selfa%self
#!   ^^^ ^^^^^ ^^^^       ^^^^^^^^^^^ arg-process-expansion

echo %last %lasta
#!   ^^^^^ arg-process-expansion-last
#!         ^^^^^^ arg-process-expansion
