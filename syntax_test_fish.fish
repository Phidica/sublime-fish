#! SYNTAX TEST "Packages/sublime-fish-shell/fish.tmLanguage"

# If using fish to test parsing of this file, all invalid illegal tokens must be commented out, and their tests disabled

;
#! <- keyword.control
&
#! <- invalid.illegal.control
|
#! <- invalid.illegal.control
\
#! <- constant.character.escape
\\
#! <- invalid.illegal.escape

echo --arg -arg arg ; echo arg # comment
#! <- support.function.user
#! ^^^^^^^^^^^^^^^^^ meta.function-call
#!   ^^^^^ meta.function-call.argument
#!         ^^^^ meta.function-call.argument
#!              ^^^ meta.function-call.argument
#!                  ^ keyword.control
#!                    ^^^^ support.function.user
#!                    ^^^^^^^^ meta.function-call
#!                             ^ punctuation.definition.comment
#!                             ^^^^^^^^^ comment.line.insert

echo arg & # comment
#!       ^ keyword.control
#!         ^ comment.line

echo \  # comment
#!   ^ meta.function-call.argument

echo arg \ arg \
#! <- support.function.user
#! ^^^^^^^^^^^^^ meta.function-call
#!   ^^^ meta.function-call.argument
#!       ^ meta.function-call.argument
#!             ^ constant.character.escape
  # comment
#! <- comment.line
arg arg # comment
#! <- meta.function-call meta.function-call.argument
#! ^^^^ meta.function-call
#!  ^^^ meta.function-call meta.function-call.argument
#!      ^ comment.line.insert

echo arg (echo inner arg) outer arg
#!       ^^^^^^^^^^^^^^^^ meta.command-substitution
#!       ^ keyword.control.command-substitution
#!        ^^^^^^^^^^^^^^ meta.function-call
#!                      ^ keyword.control.command-substitution
#!                        ^ meta.function-call

echo (echo one \
#!   ^^^^^^^^^^^ meta.command-substitution
#!             ^ constant.character.escape
two three # comment
#!        ^ comment.line.insert
# comment
#! <- comment.line
echo four \
#! <- support.function.user
#! ^^^^^^ meta.command-substitution
five six # tricky comment \
echo seven
#! <- support.function.user
)
#! <- meta.command-substitution

echo ( \
#!     ^ constant.character.escape
;  &
#! <- keyword.control
#! ^ invalid.illegal.control
echo & \\
#!     ^ invalid.illegal.escape
#! <- meta.function-call
)  &  &
#! ^ keyword.control
#!    ^ invalid.illegal.control

echo ( # comment
#!    ^^^^^^^^^^ comment.line
)

exec echo \
#! <- meta.function-call.recursive support.function.builtin
#!   ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user
arg
#! <-meta.function-call.recursive meta.function-call.standard meta.function-call.argument
#! ^ meta.function-call.recursive meta.function-call.standard

builtin echo arg ; and echo arg
#! <- meta.function-call.recursive support.function.builtin
#!      ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user
#!           ^^^ meta.function-call.recursive meta.function-call.standard meta.function-call.argument
#!               ^ keyword.control
#!                 ^^^ meta.function-call.recursive keyword.operator.word
#!                     ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user

# See scope end match for meta.function-call.recursive
command  \
#! <- meta.function-call.recursive support.function.builtin
#!       ^ constant.character.escape
echo  \
#! <- meta.function-call.standard support.function.user
arg & # comment
#! <-meta.function-call.standard meta.function-call.argument
#!    ^ comment.line
echo arg
#! <- meta.function-call.standard support.function.user

command  &
#! <- meta.function-call support.function.user
echo arg &
#! <-meta.function-call

echo arg1 ; and echo arg2 & not echo arg3 | cat
#! <- meta.function-call support.function.user
#!          ^^^ meta.function-call keyword.operator.word
#!              ^^^^ meta.function-call meta.function-call support.function.user
#!                        ^ keyword.control
#!                          ^^^ meta.function-call keyword.operator.word
#!                              ^^^^ meta.function-call meta.function-call support.function.user

# See scope end match for meta.function-call.recursive
# Cannot nest recursive scopes across lines if line break occurs before recursion
builtin \
#! <- meta.function-call.recursive
not \
#! <- meta.function-call.recursive
command \
#! <- meta.function-call.recursive
echo \
#! <- meta.function-call.standard
arg \
#! <- meta.function-call.standard meta.function-call.argument
&
#! <- meta.function-call.standard

echo "string"(echo "inner string")" outer string"
#!           ^^^^^^^^^^^^^^^^^^^^^ meta.command-substitution
#!                                ^ string.quoted

echo $var
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable

echo $var $var[$var[1 $var[1]] $var[1]] "str"
#!   ^^^^ variable.other
#!        ^^^^ meta.item-access variable.other
#!                  ^ meta.item-access meta.item-access.arguments meta.item-access meta.item-access.arguments
#!                    ^^^^ meta.item-access meta.item-access.arguments meta.item-access meta.item-access.arguments meta.item-access variable.other
#!                                      ^^^^^ string.quoted

echo 'str$str\$str\'str\\"str"'
#!   ^ string.quoted.single punctuation.definition.string.begin
#!    ^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.single
#!                ^^ constant.character.escape
#!                     ^^ constant.character.escape
#!                            ^ string.quoted.single punctuation.definition.string.end

# This is to test that single-quoted strings always include newlines
echo 'str\
str
'

echo "str$var\$str\"str\\'str'"
#!   ^ string.quoted.double punctuation.definition.string.begin
#!    ^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.double
#!       ^^^^ variable.other
#!       ^ punctuation.definition.variable
#!           ^^ constant.character.escape
#!                ^^ constant.character.escape
#!                     ^^ constant.character.escape
#!                            ^ string.quoted.double punctuation.definition.string.end

# This is to test that double-quoted strings can escape newlines
echo "str\
str
"

echo $var(echo {$arg} "{$var}")$var"str"$var
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!              ^^^^ variable.other
#!                    ^^^^^^^^ string.quoted

echo -n --switch=(echo "str;";);
#!   ^^ meta.function-call.argument
#!      ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.argument
#!                         ^ string.quoted
#!                           ^ keyword.control
#!                             ^ keyword.control

echo --switch=(echo "str;";
#!   ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.argument
#!                      ^ string.quoted
#!                        ^ keyword.control
  echo test \
#!   ^^^^^^^^^ meta.function-call.argument
#!          ^ constant.character.escape
    &
#!  ^ keyword.control
#!   ^ meta.function-call.argument
)  ;
#! ^ keyword.control

while --help; break& end
#! <- meta.function-call.standard support.function.user
#!    ^^^^^^ meta.function-call.argument
#!          ^ keyword.control
#!            ^^^^^ support.function.user
#!                   ^^^ invalid.illegal.function

begin
#! <- meta.block.begin keyword.control.conditional
  while echo arg
#! ^^^^ meta.block.while keyword.control.conditional
#!      ^^^^^^^^^ meta.function-call.standard
    echo arg
#   ^^^^^^^^ meta.function-call.standard
    break &
#!  ^^^^^ keyword.control.conditional
#!        ^ keyword.control
  end ;
#! ^^ keyword.control.conditional
  break;
#! ^^^^ support.function.user
end &
#! <- keyword.control.conditional
#!  ^ keyword.control

if echo arg
#! <- meta.block.if keyword.control.conditional
  and echo arg
  echo arg
else if echo arg
#! <- keyword.control.conditional
#!   ^^ keyword.control.conditional
  and echo arg
  echo arg
else
#! <- keyword.control.conditional
  echo arg
  if echo arg
    # comment
  end
#! ^^ keyword.control.conditional
end # comment
#! <- keyword.control.conditional
#!  ^^^^^^^^^ comment.line

if --help; else;
#! <- meta.function-call.standard support.function.user
#! ^^^^^^ meta.function-call.argument
#!       ^ keyword.control
#!         ^^^^ invalid.illegal.function

if \
#! ^ constant.character.escape
  test foo; end & # comment
#! ^^^ meta.block.if
#!        ^ keyword.control
#!          ^^^ keyword.control.conditional
#!              ^ keyword.control
#!                ^^^^^^^^^ comment.line

#######################

for \
  varname \
  in \
  (\
  echo \
  one two \
  three \
)

  echo arg arg
end

for in in in
end

echo ~/"string"

########################

switch (echo $var)
#! <- meta.block.switch keyword.control.conditional
#!     ^^^^^^^^^^^ meta.block.switch.value
  case foo
#! ^^^ meta.block.switch.case keyword.control.conditional
#!     ^^^ meta.block.switch.case.wildcard
    echo bar
  case bar
#! ^^^ meta.block.switch.case keyword.control.conditional
#!     ^^^ meta.block.switch.case.wildcard
    echo foo
end

switch \
# Comment
"foo"
#! <- meta.block.switch.value string.quoted.double
  case \
#! ^^^ meta.block.switch.case keyword.control.conditional
  (echo foo) bar one two
#! ^^^^^^^^^^^^^^^^^^^^^ meta.block.switch.case.wildcard
    echo bar
  case '*'
#!     ^^^ meta.block.switch.case.wildcard string.quoted.single
    echo wild
end

switch value; case wildcard; command echo foo; end # comment
#!          ^ keyword.control
#!                         ^ keyword.control
#!                                           ^ keyword.control
#!                                                 ^ comment.line

switch --help; case;
#! <- meta.function-call.standard support.function.user
#!     ^^^^^^ meta.function-call.argument
#!           ^ keyword.control
#!             ^^^^ invalid.illegal.function
