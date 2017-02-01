#! SYNTAX TEST "Packages/sublime-fish-shell/fish.tmLanguage"

# If using fish to test parsing of this file, all invalid illegal tokens and their tests must be temporarily removed

;
#! <- keyword.control
&
#! <- invalid.illegal.control
|
#! <- invalid.illegal.control
\
#! <- constant.character.escape

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

echo 'single-quoted' "double-quoted" unquoted
#!   ^^^^^^^^^^^^^^^ string.quoted.single
#!                   ^^^^^^^^^^^^^^^ string.quoted.double
#!                                   ^^^^^^^^ string.unquoted

# The ~ and % are only special characters in need of escaping when at the front of arguments
echo ~foo \~bar~\~ %foo \%bar%\%
#!   ^^^^ string.unquoted
#!        ^^^^^^^^ string.unquoted
#!        ^^ constant.character.escape
#!                 ^^^^ string.unquoted
#!                      ^^^^^^^^ string.unquoted
#!                      ^^ constant.character.escape

echo str\a str\x12345 str\X12345 str\012345
#!   ^^^^^ string.unquoted
#!      ^^ constant.character.escape
#!            ^^^^ constant.character.escape
#!                       ^^^^ constant.character.escape
#!                                  ^^^^ constant.character.escape

echo str\u01a2345 str\U01a2b3c45 str\cab
#!   ^^^^^^^^^^^^ string.unquoted
#!      ^^^^^^ constant.character.escape
#!                   ^^^^^^^^^^ constant.character.escape
#!                                  ^^^ constant.character.escape

echo str\
#!   ^^^^^ string.unquoted
#!      ^^ constant.character.escape
ing # comment
#! <- string.unquoted
#!  ^^^^^^^^^ comment.line.insert

echo str1 2 3str -b="str" --num=2
#!   ^^^^ string.unquoted
#!        ^ string.unquoted constant.numeric
#!          ^^^^ string.unquoted
#!               ^^^ string.unquoted
#!                  ^^^^^ string.quoted.double
#!                        ^^^^^^ string.unquoted
#!                              ^ string.unquoted constant.numeric

echo str \ # not-comment \  # comment
#!   ^^^ string.unquoted
#!       ^^^ string.unquoted
#!       ^^ constant.character.escape
#!                       ^^ string.unquoted constant.character.escape
#!                          ^^^^^^^^^ comment.line.insert

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

echo arg (echo "inner" arg) outer arg
#!       ^^^^^^^^^^^^^^^^^^ meta.command-substitution
#!       ^ keyword.control.command-substitution
#!        ^^^^^^^^^^^^^^^^ meta.function-call
#!                        ^ keyword.control.command-substitution
#!                          ^ meta.function-call

foo\ bar arg
#! ^^^^^ support.function.user

'foo bar' arg
#! ^^^^^^ support.function.user

"foo bar" arg
#! ^^^^^^ support.function.user

f''o"o"\ ''b""ar arg
#! ^^^^^^^^^^^^^ support.function.user

f'\''o"\$\\"o\ \|\$\*b\?\%a\#\(r\) arg
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ support.function.user

\\foo arg
#! <- support.function.user
#! ^^ support.function.user

# Some valid function names are very strange
\ \
#! <- support.function.user
  arg
#! ^^ meta.function-call.argument

'\'\\'"\"\$\\"\a\b\e\f\n\r\t\v\ \$\\\*\?~\~%\%#\#\(\)\{\}\[\]\<\>^\^\&\|\;\"\'\x0a\X1b\01\u3ccc\U4dddeeee\c?
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ support.function.user

~
#! <- invalid.illegal.function

%
#! <- invalid.illegal.function

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
echo &
#! <- meta.function-call
)  &  &
#! ^ keyword.control
#!    ^ invalid.illegal.control

echo ( # comment
#!    ^^^^^^^^^^ comment.line
)

foo\  # comment
#! ^^ support.function.user

foo\ bar
#! ^^^^^ support.function.user

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

echo $var $ $$"str" $var $$var $
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!        ^ invalid.illegal.variable-expansion
#!          ^^ variable.other
#!          ^ punctuation.definition.variable
#!           ^ invalid.illegal.variable-expansion
#!            ^^^^^ string.quoted
#!                  ^^^^ variable.other
#!                       ^^^^^ variable.other
#!                       ^^ punctuation.definition.variable
#!                        ^^^^ variable.other variable.other
#!                             ^ invalid.illegal.variable-expansion

echo $var$ (echo $) $$!bad_var # comment
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!       ^ invalid.illegal.variable-expansion
#!               ^ invalid.illegal.variable-expansion
#!                   ^^^^^^^^^ invalid.illegal.variable-expansion
#!                             ^^^^^^^^^ comment.line

echo $var[1..$foo]
#!   ^^^^ variable.other
#!       ^^^^^^^^^ meta.index-expansion
#!        ^ constant.numeric
#!           ^^^^ variable.other

echo $var $var[$var[1 $var[1]] $var[1]] "str"
#!   ^^^^ variable.other
#!        ^^^^ variable.other
#!                  ^ meta.index-expansion meta.index-expansion
#!                    ^^^^ meta.index-expansion meta.index-expansion variable.other
#!                                      ^^^^^ string.quoted

echo $$var[ 1 ][ 1 ]
#!   ^^^^^^^^^ variable.other
#!    ^^^^^^^^^ variable.other
#!        ^^^^^ meta.index-expansion

echo $var[(echo 1)] $var["2"] "str"
#!   ^^^^ variable.other
#!       ^^^^^^^^^^ meta.index-expansion
#!        ^^^^^^^^  meta.command-substitution
#!                       ^^^ string.quoted
#!                            ^^^^^ string.quoted

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
#! <- string.quoted.single punctuation.definition.string.end

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
#! <- string.quoted.double punctuation.definition.string.end

echo $var{,'brace',"expansion",he{e,$e}re,}"str"
#!   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ string.unquoted
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!       ^ keyword.control.brace-expansion.begin
#!        ^ keyword.control.brace-expansion.separator
#!                ^ keyword.control.brace-expansion.separator
#!                            ^ keyword.control.brace-expansion.separator
#!                               ^ keyword.control.brace-expansion.begin
#!                                 ^ keyword.control.brace-expansion.separator
#!                                  ^^ variable.other
#!                                    ^ keyword.control.brace-expansion.end
#!                                       ^ keyword.control.brace-expansion.separator
#!                                        ^ keyword.control.brace-expansion.end
#!                                         ^^^^^ string.quoted

echo $var(echo str{$arg}str "{$var}")$var"str"$var
#!   ^^^^ variable.other
#!                 ^^^^ variable.other
#!                          ^^^^^^^^ string.quoted

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

begin end
#! <- meta.block.begin keyword.control.conditional
#!    ^^^ keyword.control.conditional

if echo arg
#! <- meta.block.if keyword.control.conditional
  and echo arg
  echo arg
else if echo arg
#! <- keyword.control.conditional
#!   ^^ keyword.control.conditional
  and echo arg
  echo arg
else # comment
#! <- keyword.control.conditional
#!   ^^^^^^^^^ comment.line
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
# comment
"foo"
#! <- meta.block.switch.value string.quoted.double
  case \
#! ^^^ meta.block.switch.case keyword.control.conditional
  (echo foo) bar one two
#! ^^^^^^^^^^^^^^^^^^^^^ meta.block.switch.case.wildcard
    echo bar
  case '*'
#!     ^^^ meta.block.switch.case.wildcard string.quoted.single
    echo arg
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

switch--help arg
#! <- support.function.user
#! ^^^^^^^^^ meta.function-call.standard support.function.user

function foo --arg="bar"
#! <- meta.block.function. keyword.control.conditional
#!       ^^^ entity.name.function
#!           ^^^^^^^^^^^ meta.function-call.argument
  return 1
#! ^^^^^ keyword.control.conditional
  echo arg
#! ^^^^^^^ meta.function-call.standard
end

function \
#! <- meta.block.function. keyword.control.conditional
#!       ^ constant.character.escape
foo\ bar \
#! <- entity.name.function
#!       ^ constant.character.escape
  arg1 \
#! ^^^ meta.function-call.argument
  arg2 # comment
#! ^^^ meta.function-call.argument
  echo arg
#! ^^^^^^^ meta.function-call.standard
end

function inline; echo arg; end # comment
#! <- meta.block.function. keyword.control.conditional
#!       ^^^^^^ entity.name.function
#!             ^ keyword.control
#!                       ^ keyword.control
