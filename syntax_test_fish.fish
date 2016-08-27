#! SYNTAX TEST "Packages/sublime-fish-shell/fish.tmLanguage"

echo --arg -arg arg ; echo arg # comment
#! <- support.function.user
#! ^^^^^^^^^^^^^^^^^ meta.command-call
#!   ^^^^^ function.call.argument
#!         ^^^^ function.call.argument
#!              ^^^ function.call.argument
#!                    ^^^^ support.function.user
#!                    ^^^^^^^^ meta.command-call
#!                             ^ punctuation.definition.comment
#!                             ^^^^^^^^^ comment.line

echo arg \ arg \
#! <- support.function.user
#! ^^^^^^^^^^^^^ meta.command-call
#!   ^^^ function.call.argument
#!       ^ function.call.argument
#!             ^ constant.character.escape
# comment
#! <- comment.line
arg arg
#! <- meta.command-call function.call.argument
#! ^^^^ meta.command-call
#!  ^^^ meta.command-call function.call.argument

echo arg (echo inner arg) outer arg
#!       ^^^^^^^^^^^^^^^^ meta.command-substitution
#!       ^ constant.character.command-substitution
#!        ^^^^^^^^^^^^^^ meta.command-call
#!                      ^ constant.character.command-substitution
#!                        ^ meta.command-call

echo (echo one \
#!   ^^^^^^^^^^^ meta.command-substitution
#!             ^ constant.character.escape
two three # comment
# comment
#! <- comment.line
echo four
#! <- support.function.user
#! ^^^^^^ meta.command-substitution
)
#! <- meta.command-substitution

echo "string"(echo "inner string")" outer string"
#!           ^^^^^^^^^^^^^^^^^^^^^ meta.command-substitution
#!                                ^ string.quoted

echo $variable
#!   ^^^^^^^^^ variable.other
#!   ^ punctuation.definition.variable

echo 'str$str\$str\'str\\"str"'
#!   ^ string.quoted.single punctuation.definition.string.begin
#!    ^^^^^^^^^^^^^^^^^^^^^^^^ string.quoted.single
#!                ^^ constant.character.escape
#!                     ^^ constant.character.escape
#!                            ^ string.quoted.single punctuation.definition.string.end

# This is to test that single-quoted strings always include newlines
echo 'str\
str'

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
#!                    ^^^^^^^^ function.call.argument
