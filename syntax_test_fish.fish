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
#!   ^^^^^ meta.function-call.arguments
#!         ^^^^ meta.function-call.arguments
#!              ^^^ meta.function-call.arguments
#!                  ^ keyword.control
#!                    ^^^^ support.function.user
#!                    ^^^^^^^^ meta.function-call
#!                             ^ punctuation.definition.comment
#!                             ^^^^^^^^^ comment.inline

echo arg & # comment
#!       ^ keyword.control
#!         ^ comment.line

echo \  # comment
#!   ^ meta.function-call.arguments

echo arg \ arg \
#! <- support.function.user
#! ^^^^^^^^^^^^^ meta.function-call
#!   ^^^ meta.function-call.arguments
#!       ^ meta.function-call.arguments
#!             ^ constant.character.escape
  # comment
#! <- comment.line
arg arg # comment
#! <- meta.function-call meta.function-call.arguments
#! ^^^^ meta.function-call
#!  ^^^ meta.function-call meta.function-call.arguments
#!      ^ comment.inline

echo arg (echo inner arg) outer arg
#!       ^^^^^^^^^^^^^^^^ meta.command-substitution
#!       ^ constant.character.command-substitution
#!        ^^^^^^^^^^^^^^ meta.function-call
#!                      ^ constant.character.command-substitution
#!                        ^ meta.function-call

echo (echo one \
#!   ^^^^^^^^^^^ meta.command-substitution
#!             ^ constant.character.escape
two three # comment
#!        ^ comment.inline
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
;
#! <- keyword.control
  &
#! <- invalid.illegal.control
echo &
#! <- meta.function-call
)

echo ( # comment
#!     ^ comment.line
)

exec echo \
#! <- meta.function-call.recursive support.function.builtin
#!   ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user
arg
#! <-meta.function-call.recursive meta.function-call.standard meta.function-call.arguments
#! ^ meta.function-call.recursive meta.function-call.standard

builtin echo arg ; and echo arg
#! <- meta.function-call.recursive support.function.builtin
#!      ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user
#!           ^^^ meta.function-call.recursive meta.function-call.standard meta.function-call.arguments
#!               ^ keyword.control
#!                 ^^^ meta.function-call.recursive keyword.control
#!                     ^^^^ meta.function-call.recursive meta.function-call.standard support.function.user

# See scope end match for meta.function-call.recursive
command  \
#! <- meta.function-call.recursive support.function.builtin
echo  \
#! <- meta.function-call.standard support.function.user
arg & # comment
#! <-meta.function-call.standard meta.function-call.arguments
#!    ^ comment.line
echo arg
#! <- meta.function-call.standard support.function.user

command  &
#! <- meta.function-call support.function.user
echo arg &
#! <-meta.function-call

echo arg1 ; and echo arg2 & not echo arg3 | cat
#! <- meta.function-call support.function.user
#!          ^^^ meta.function-call keyword.control
#!              ^^^^ meta.function-call meta.function-call support.function.user
#!                        ^ keyword.control
#!                          ^^^ meta.function-call keyword.control
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
#! <- meta.function-call.standard meta.function-call.arguments
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
#!   ^^ meta.function-call.arguments
#!      ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
#!                         ^ string.quoted
#!                           ^ keyword.control
#!                             ^ keyword.control

echo --switch=(echo "str;";
#!   ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.arguments
#!                      ^ string.quoted
#!                        ^ keyword.control
  echo test \
#!   ^^^^^^^^^ meta.function-call.arguments
#!          ^ constant.character.escape
    &
#!  ^ keyword.control
#!   ^ meta.function-call.arguments
)  ;
#! ^ keyword.control
