# SYNTAX TEST "Packages/sublime-fish-shell/fish.tmLanguage"

echo test # Comment
# <- support.function.user
#     ^ meta.command
#         ^ punctuation.definition.comment
#         ^^^^^^^^^ comment.line

echo test (echo inner test) outer test
#         ^^^^^^^^^^^^^^^^^ meta.command-substitution
#         ^ storage.type.command-substitution
#          ^^^^^^^^^^^^^^^ meta.command
#                         ^ storage.type.command-substitution
#                           ^ meta.command

echo "string"(echo "inner string")" outer string"
#            ^^^^^^^^^^^^^^^^^^^^^ meta.command-substitution
#                                 ^ string.quoted

echo $variable
#    ^^^^^^^^^ variable.other
#    ^ punctuation.definition.variable

echo "{$variable}"
#      ^^^^^^^^^ variable.other
#      ^ punctuation.definition.variable

echo $variable "string" (echo {$test} "{$variable}")
#    ^^^^^^^^^ variable.other
#    ^ punctuation.definition.variable
#                              ^^^^^ variable.other
#                                       ^^^^^^^^^ variable.other
