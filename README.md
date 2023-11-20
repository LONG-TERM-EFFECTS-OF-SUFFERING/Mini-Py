# Mini-Py

## Grammar specification

```
<program>              := int main() { <expression> }
                          a-program (exp)

<a-hex-exp>            := x16 ({ <number> }+)
                          a-hex-exp_ (numbers)

<a-list-exp>           := list( { <expression> }* (,))
                          a-list-exp_ (exps)

<a-tuple-exp>          := tuple({ <expression> }* (,))
                          a-tuple-exp_ (exps)

<a-dictionary-exp>     := {{ <text> = <expression> ;}* <text> = <expression>}
                          a-dictionary-exp_ (key value keys values)

<expression>           := <number>
                          lit-number (number)

                       := <a-hex-exp>
                          hex-exp (a-hex-exp)

                       := <identifier>
                          var-exp (identifier)

                       := "<text>"
                          lit-text (text)

                       := <a-list-exp>
                          list-exp ()

                       := <a-tuple-exp>
                           tuple-exp ()

                       := <a-dictionary-exp>
                          dictionary-exp ()

                       := var { <identifier> = <expression> }* in <expression>
                          let-exp (identifiers bodies body)

                       := const { <identifier> = <expression> }* in <expression>
                          const-exp (identifiers bodies body)

                       := rec { <identifier> ({ identifier }* (,)) = <expression> }* in <expression>
                          letrec-exp (procedures-names procedures-arguments procedures-bodies body)

                       := proc({ <identifier> }* (,)) <expression>
                          proc-exp (procedure-arguments body)

                       := (<expression> { <expression> }*)
                          app-exp (rator rands)

                       := set <identifier> = <expression>
                          set-exp (identifier expression)

                       := begin <expression> { ; <expression> }*
                          begin-exp (expression expressions)

                       := if <expression> then <expression> else <expression>
                          if-exp (test-exp true-exp false-exp)

                       := while (<boolean-expression>) { <expression> }
                          while-exp (boolean-exp body)

                       := for <identifier> = <expression> <iterator> <expression> { <expression> }
                          for-exp (var initialization iterator body)

<comparator_prim>      := <
                       smaller-than-comparator-prim ()

                       := >
                       greater-than-comparator-prim ()

                       := <=
                       less-equal-to-comparator-prim ()

                       := >=
                       greater-equal-to-comparator-prim ()

                       := ==
                       equal-to-comparator-prim ()

                       := !=
                       not-equal-to-comparator-prim ()

<boolean>              := true
                          true-boolean-exp ()

                       := false
                          false-boolean-exp ()

<bool_binary_operator> := and
                          and-bool-binary-operator ()

                       := or
                          or-bool-binary-operator ()

<bool_unary_operator>  := not
                          negation-bool-unary-operator ()

<boolean-expression>   := <boolean>
                          atomic-boolean-exp (atomic-boolean)

                       := <bool_binary_operator> ( <boolean-expression> , <boolean-expression> )
                          app-binary-boolean-operator-exp (rator rand1 rand2)

                       := <bool_unary_operator> ( <boolean-expression> )
                          app-unary-boolean-operator-exp (rator rand)

                       := <comparator_prim> ( <expression> , <expression> )
                          app-comparator-boolean-exp (rator rand1 rand2)
```
