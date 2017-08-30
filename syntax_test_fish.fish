#! SYNTAX TEST "Packages/sublime-fish-shell-improved/fish.tmLanguage"

# If using fish to test parsing of this file, all invalid illegal tokens and their tests must be temporarily removed

;
#! <- keyword.operator
&
#! <- invalid.illegal.operator
|
#! <- invalid.illegal.operator
\
#! <- constant.character.escape

echo --arg -arg arg ; echo arg # comment
#! <- variable.function
#! ^^^^^^^^^^^^^^^^^ meta.function-call
#!   ^^^^^ meta.function-call.argument
#!         ^^^^ meta.function-call.argument
#!              ^^^ meta.function-call.argument
#!                  ^ keyword.operator
#!                    ^^^^ variable.function
#!                    ^^^^^^^^ meta.function-call
#!                             ^ punctuation.definition.comment
#!                             ^^^^^^^^^ comment.line.insert

echo arg & # comment
#!       ^ keyword.operator
#!         ^ comment.line

echo 'single-quoted' "double-quoted" unquoted
#!   ^^^^^^^^^^^^^^^ string.quoted.single
#!                   ^^^^^^^^^^^^^^^ string.quoted.double
#!                                   ^^^^^^^^ meta.string.unquoted

# The ~ and % are only special characters in need of escaping when at the front of arguments
echo ~foo \~bar~\~ %foo \%bar%\%
#!   ^^^^ meta.string.unquoted
#!   ^ keyword.operator
#!        ^^^^^^^^ meta.string.unquoted
#!        ^^ constant.character.escape
#!                 ^^^^ meta.process-expansion
#!                      ^^^^^^^^ meta.string.unquoted
#!                      ^^ constant.character.escape

echo str\a str\x12345 str\X12345 str\012345
#!   ^^^^^ meta.string.unquoted
#!      ^^ constant.character.escape
#!            ^^^^ constant.character.escape
#!                       ^^^^ constant.character.escape
#!                                  ^^^^ constant.character.escape

echo str\u01a2345 str\U01a2b3c45 str\cab
#!   ^^^^^^^^^^^^ meta.string.unquoted
#!      ^^^^^^ constant.character.escape
#!                   ^^^^^^^^^^ constant.character.escape
#!                                  ^^^ constant.character.escape

echo str\
#!   ^^^^^ meta.string.unquoted
#!      ^^ constant.character.escape
ing # comment
#! <- meta.string.unquoted
#!  ^^^^^^^^^ comment.line.insert

echo str1 2 3str -b="str" --num=2
#!   ^^^^ meta.string.unquoted
#!        ^ meta.string.unquoted constant.numeric
#!          ^^^^ meta.string.unquoted
#!               ^^^ meta.string.unquoted
#!                  ^^^^^ string.quoted.double
#!                        ^^^^^^ meta.string.unquoted
#!                              ^ meta.string.unquoted constant.numeric

echo str \ # not-comment \  # comment
#!   ^^^ meta.string.unquoted
#!       ^^^ meta.string.unquoted
#!       ^^ constant.character.escape
#!                       ^^ meta.string.unquoted constant.character.escape
#!                          ^^^^^^^^^ comment.line.insert

echo arg \ arg \
#! <- variable.function
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
#!       ^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!       ^ punctuation.section.parens.begin
#!        ^^^^^^^^^^^^^^^^ meta.function-call
#!                        ^ punctuation.section.parens.end
#!                          ^ meta.function-call

foo\ bar arg
#! ^^^^^ variable.function

'foo bar' arg
#! ^^^^^^ variable.function

"foo bar" arg
#! ^^^^^^ variable.function

f''o"o"\ ''b""ar arg
#! ^^^^^^^^^^^^^ variable.function

f'\''o"\$\\"o\ \|\$\*b\?\%a\#\(r\) arg
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.function

\\foo arg
#! <- variable.function
#! ^^ variable.function

# Some valid function names are very strange
\ \
#! <- variable.function
  arg
#! ^^ meta.function-call.argument

'\'\\'"\"\$\\"\a\b\e\f\n\r\t\v\ \$\\\*\?~\~%\%#\#\(\)\{\}\[\]\<\>^\^\&\|\;\"\'\x0a\X1b\01\u3ccc\U4dddeeee\c?
#! ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ variable.function

%process
#! <- invalid.illegal.operator

<in.log
#! <- invalid.illegal.operator

>out.log
#! <- invalid.illegal.operator

^err.log
#! <- invalid.illegal.operator

echo one >out.log two < in.log three ^^err.log four4> out.log five
#!       ^^^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!        ^^^^^^^ meta.path
#!                ^^^ meta.function-call.argument
#!                    ^^^^^^^^ meta.function-call.redirection
#!                    ^ keyword.operator
#!                      ^^^^^^ meta.path
#!                                   ^^^^^^^^^ meta.function-call.redirection
#!                                   ^^ keyword.operator
#!                                     ^^^^^^^ meta.path
#!                                             ^^^^^ meta.function-call.argument
#!                                                  ^^^^^^^^^ meta.function-call.redirection
#!                                                  ^ keyword.operator
#!                                                    ^^^^^^^ meta.path
#!                                                            ^^^^ meta.function-call.argument

echo one 1>err.log two 2^err.log three^four five^6 7>? \
#!       ^^^^^^^^^ meta.function-call.redirection
#!       ^ constant.numeric.file-descriptor
#!        ^ keyword.operator
#!         ^^^^^^^ meta.path
#!                 ^^^ meta.function-call.argument
#!                     ^^^^^^^^^ meta.function-call.argument
#!                               ^^^^^^^^^^ meta.function-call.argument
#!                                          ^^^^^^ meta.function-call.argument
#!                                                 ^^^^^^ meta.function-call.redirection
#!                                                 ^ constant.numeric.file-descriptor
#!                                                  ^^ keyword.operator
  out.log 8<? "in.log" nine
#!^^^^^^^ meta.path
#!        ^^^^^^^^^^^^ meta.function-call.redirection
#!        ^ constant.numeric.file-descriptor
#!         ^^ keyword.operator
#!            ^^^^^^^^ meta.path
#!                     ^^^^ meta.function-call.argument

echo one ^err.log^'log' >out.log<in.log < \?in.log > ?out.log
#!       ^^^^^^^^^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!        ^^^^^^^^^^^^^ meta.path
#!                      ^^^^^^^^^^^^^^^ meta.function-call.redirection
#!                      ^ keyword.operator
#!                       ^^^^^^^ meta.path
#!                              ^ keyword.operator
#!                               ^^^^^^ meta.path
#!                                      ^^^^^^^^^^ meta.function-call.redirection
#!                                      ^ keyword.operator
#!                                        ^^^^^^^^ meta.path
#!                                                 ^^^^^^^^^^ meta.function-call.redirection
#!                                                 ^ keyword.operator
#!                                                   ^^^^^^^^ invalid.illegal.path

echo one >? 1 >? 2<in.log
#!       ^^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!          ^ meta.path
#!            ^^^^^^^^^^^ meta.function-call.redirection
#!            ^^ keyword.operator
#!               ^^^^^^^^ invalid.illegal.path

echo one > $file <? (echo in.log) >{a,b} ^ \
#!       ^^^^^^ meta.function-call.redirection
#!       ^ keyword.operator
#!         ^^^^^ variable.other
#!               ^^^^^^^^^^^^^^^^ meta.function-call.redirection
#!               ^^ keyword.operator
#!                  ^^^^^^^^^^^^^ meta.parens.command-substitution
#!                                ^^^^^^ meta.function-call.redirection
#!                                ^ keyword.operator
#!                                 ^^^^^ meta.path
#!                                       ^^^^ meta.function-call.redirection
#!                                       ^ keyword.operator
#!                                         ^^ constant.character.escape
  "err.log"
#! <- meta.function-call.redirection
#! ^^^^^^^^ meta.path

echo one ^&2 two three3>&4 four 5>& \
#!       ^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!         ^ constant.numeric.file-descriptor
#!               ^^^^^ meta.function-call.argument
#!                     ^^^ meta.function-call.redirection
#!                     ^^ keyword.operator
#!                       ^ constant.numeric.file-descriptor
#!                              ^^^^^ meta.function-call.redirection
#!                              ^ constant.numeric.file-descriptor
#!                               ^^ keyword.operator
  - six 7<&->out.log 2> &1
#!^ keyword.operator.redirection.close
#!  ^^^ meta.function-call.argument
#!      ^^^^ meta.function-call.redirection
#!      ^ constant.numeric.file-descriptor
#!       ^^ keyword.operator
#!         ^ keyword.operator.redirection.close
#!          ^^^^^^^^ meta.function-call.redirection
#!          ^ keyword.operator
#!           ^^^^^^^ meta.path
#!                   ^^^^^ meta.function-call.redirection
#!                   ^ constant.numeric.file-descriptor
#!                    ^ keyword.operator
#!                      ^^ invalid.illegal.path

echo one >&1>?two<&2>&4five
#!       ^^^ meta.function-call.redirection
#!       ^^ keyword.operator
#!         ^ constant.numeric.file-descriptor
#!          ^^^^^ meta.function-call.redirection
#!          ^^ keyword.operator
#!            ^^^ meta.path
#!               ^^^ meta.function-call.redirection
#!               ^^ keyword.operator
#!                 ^ constant.numeric.file-descriptor
#!                  ^^^^^^^ meta.function-call.redirection
#!                  ^^ keyword.operator
#!                    ^^^^^ invalid.illegal.file-descriptor

echo (echo one \
#!   ^^^^^^^^^^^ meta.parens.command-substitution
#!             ^ constant.character.escape
two three # comment
#!        ^ comment.line.insert
# comment
#! <- comment.line
echo four \
#! <- variable.function
#! ^^^^^^ meta.parens.command-substitution
five six # tricky comment \
echo seven
#! <- variable.function
)
#! <- meta.parens.command-substitution

echo ( \
#!     ^ constant.character.escape
;  &
#! <- keyword.operator
#! ^ invalid.illegal.operator
echo &
#! <- meta.function-call
)  &  &
#! ^ keyword.operator
#!    ^ invalid.illegal.operator

echo ( # comment
#!    ^^^^^^^^^^ comment.line
)

echo foo(echo -e nar\nbar)[2] f(echo oo)\[bar]
#!      ^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!                        ^^^ meta.brackets.index-expansion
#!                        ^ punctuation.section.brackets.begin
#!                          ^ punctuation.section.brackets.end
#!                                      ^^ constant.character.escape

foo\  # comment
#! ^^ variable.function

foo\ bar
#! ^^^^^ variable.function

exec echo \
#! <- meta.function-call.recursive support.function
#!   ^^^^ meta.function-call.recursive meta.function-call.standard variable.function
arg
#! <-meta.function-call.recursive meta.function-call.standard meta.function-call.argument
#! ^ meta.function-call.recursive meta.function-call.standard

builtin echo arg ; and echo arg
#! <- meta.function-call.recursive support.function
#!      ^^^^ meta.function-call.recursive meta.function-call.standard variable.function
#!           ^^^ meta.function-call.recursive meta.function-call.standard meta.function-call.argument
#!               ^ keyword.operator
#!                 ^^^ meta.function-call.recursive keyword.operator.word
#!                     ^^^^ meta.function-call.recursive meta.function-call.standard variable.function

# See scope end match for meta.function-call.recursive
command  \
#! <- meta.function-call.recursive support.function
#!       ^ constant.character.escape
echo  \
#! <- meta.function-call.standard variable.function
arg & # comment
#! <-meta.function-call.standard meta.function-call.argument
#!    ^ comment.line
echo arg
#! <- meta.function-call.standard variable.function

command  &
#! <- meta.function-call variable.function
echo arg &
#! <-meta.function-call

echo arg1 ; and echo arg2 & not echo arg3 | cat
#! <- meta.function-call variable.function
#!          ^^^ meta.function-call keyword.operator.word
#!              ^^^^ meta.function-call meta.function-call variable.function
#!                        ^ keyword.operator
#!                          ^^^ meta.function-call keyword.operator.word
#!                              ^^^^ meta.function-call meta.function-call variable.function

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
#!           ^^^^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
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
#!       ^^^^^^^^^ meta.brackets.index-expansion
#!        ^ constant.numeric
#!         ^^ keyword.operator
#!           ^^^^ variable.other

echo $var $var[$var[1 $var[1]] $var[1..2]] "str"
#!   ^^^^ variable.other
#!        ^^^^ variable.other
#!                  ^ meta.brackets.index-expansion meta.brackets.index-expansion
#!                    ^^^^ meta.brackets.index-expansion meta.brackets.index-expansion variable.other
#!                                         ^^^^^ string.quoted

echo $$var[ 1 ][ 1 ]
#!   ^^^^^^^^^ variable.other
#!    ^^^^^^^^^ variable.other
#!        ^^^^^ meta.brackets.index-expansion

echo $var[(echo 1)] $var["2"] "str"
#!   ^^^^ variable.other
#!       ^^^^^^^^^^ meta.brackets.index-expansion
#!        ^^^^^^^^  meta.parens.command-substitution
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

echo $var{,'brace',"expansion",he{e,$e}re\,}"str"
#!   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.string.unquoted
#!   ^^^^ variable.other
#!   ^ punctuation.definition.variable
#!       ^ punctuation.section.braces.begin
#!        ^ punctuation.section.braces.separator
#!                ^ punctuation.section.braces.separator
#!                            ^ punctuation.section.braces.separator
#!                               ^ punctuation.section.braces.begin
#!                                 ^ punctuation.section.braces.separator
#!                                  ^^ variable.other
#!                                    ^ punctuation.section.braces.end
#!                                       ^^ constant.character.escape
#!                                         ^ punctuation.section.braces.end
#!                                          ^^^^^ string.quoted

echo %"fish" one%two %%percent
#!   ^^^^^^^ meta.process-expansion
#!   ^ punctuation.definition.process
#!    ^^^^^^ meta.string.unquoted
#!           ^^^^^^^ meta.string.unquoted
#!                   ^^^^^^^^^ meta.process-expansion
#!                   ^ punctuation.definition.process
#!                    ^^^^^^^^ meta.string.unquoted

echo %self foo %(set foo "fi"; echo $foo)sh "bar"
#!   ^^^^^ meta.process-expansion
#!   ^ punctuation.definition.process
#!         ^^^ meta.string.unquoted
#!             ^ punctuation.definition.process
#!              ^^^^^^^^^^^^^^^^^^^^^^^^^ meta.parens.command-substitution
#!                                       ^^ meta.process-expansion
#!                                          ^^^^^ string.quoted

echo $var(echo str{$arg}str "{$var}")$var"str"$var
#!   ^^^^ variable.other
#!                 ^^^^ variable.other
#!                          ^^^^^^^^ string.quoted

echo -n --switch=(echo "str;";);
#!   ^^ meta.function-call.argument
#!      ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.argument
#!                         ^ string.quoted
#!                           ^ keyword.operator
#!                             ^ keyword.operator

echo --switch=(echo "str;";
#!   ^^^^^^^^^^^^^^^^^^^^^^^ meta.function-call.argument
#!                      ^ string.quoted
#!                        ^ keyword.operator
  echo test \
#!   ^^^^^^^^^ meta.function-call.argument
#!          ^ constant.character.escape
    &
#!  ^ keyword.operator
#!   ^ meta.function-call.argument
)  ;
#! ^ keyword.operator

while --help; break& end
#! <- meta.function-call.standard variable.function
#!    ^^^^^^ meta.function-call.argument
#!          ^ keyword.operator
#!            ^^^^^ variable.function
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
#!        ^ keyword.operator
  end ;
#! ^^ keyword.control.conditional
  break;
#! ^^^^ variable.function
end &
#! <- keyword.control.conditional
#!  ^ keyword.operator

begin end
#! <- meta.block.begin keyword.control.conditional
#!    ^^^ keyword.control.conditional

begin
end; or begin
#!      ^^^^^ meta.block.begin keyword.control.conditional
end
#! <- keyword.control.conditional

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
#! <- meta.function-call.standard variable.function
#! ^^^^^^ meta.function-call.argument
#!       ^ keyword.operator
#!         ^^^^ invalid.illegal.function

if \
#! ^ constant.character.escape
  test foo; end & # comment
#! ^^^ meta.block.if
#!        ^ keyword.operator
#!          ^^^ keyword.control.conditional
#!              ^ keyword.operator
#!                ^^^^^^^^^ comment.line

for in in in in (seq 5) in in # comment
#! <- meta.block.for-in keyword.control.conditional
#!  ^^ meta.function-call.argument
#!     ^^ keyword.control.conditional
#!        ^^ meta.function-call.argument
#!           ^^ meta.function-call.argument
#!              ^^^^^^^ meta.function-call.argument meta.parens.command-substitution
#!                      ^^ meta.function-call.argument
#!                         ^^ meta.function-call.argument
#!                            ^^^^^^^^^ comment.line
  echo arg
#! ^^^ meta.function-call.standard
  continue
#! ^^^^^^^ keyword.control.conditional
end
#! <- keyword.control.conditional

for \
#! <- meta.block.for-in keyword.control.conditional
#!  ^ constant.character.escape
  varname \
#! ^^^^^^ meta.function-call.argument
#!        ^ constant.character.escape
  in \
#! ^ keyword.control.conditional
#!   ^ constant.character.escape
    (
#!  ^ meta.function-call.argument meta.parens.command-substitution
  echo \
#! ^^^ meta.function-call.standard
  one two \
  three
)
#! <- meta.function-call.argument meta.parens.command-substitution
  echo arg arg
#! ^^^ meta.function-call.standard
end
#! <- keyword.control.conditional

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
#! <- keyword.control.conditional

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
#! <- keyword.control.conditional

switch value; case wildcard; command echo foo; end # comment
#!          ^ keyword.operator
#!                         ^ keyword.operator
#!                                           ^ keyword.operator
#!                                                 ^ comment.line

switch --help; case;
#! <- meta.function-call.standard variable.function
#!     ^^^^^^ meta.function-call.argument
#!           ^ keyword.operator
#!             ^^^^ invalid.illegal.function

switch--help arg
#! <- variable.function
#! ^^^^^^^^^ meta.function-call.standard variable.function

function foo --arg="bar"
#! <- meta.block.function. keyword.control.conditional
#!       ^^^ entity.name.function
#!           ^^^^^^^^^^^ meta.function-call.argument
  return 1
#! ^^^^^ keyword.control.conditional
  echo arg
#! ^^^^^^^ meta.function-call.standard
end
#! <- keyword.control.conditional

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
#! <- keyword.control.conditional

function inline; echo arg; end # comment
#! <- meta.block.function. keyword.control.conditional
#!       ^^^^^^ entity.name.function
#!             ^ keyword.operator
#!                       ^ keyword.operator
