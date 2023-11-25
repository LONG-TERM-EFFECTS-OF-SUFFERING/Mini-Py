# Mini-Py

## Grammar specification

```
<program>                := int main() { <expression> }
                            a-program (exp)

<a-hex-exp>              := x16 ({ <number> }+)
                            a-hex-exp_ (numbers)

<a-lit-text>              := "text"
                             a-lit-text_ (text)

<a-list-exp>             := list( { <expression> }* (,))
                            a-list-exp_ (exps)

<a-tuple-exp>            := tuple({ <expression> }* (,))
                            a-tuple-exp_ (exps)

<a-dictionary-exp>       := {{ <text> = <expression> ;}* <text> = <expression>}
                            a-dictionary-exp_ (key value keys values)

<expression>             := <number>
                            lit-number (number)

                         := <a-hex-exp>
                            hex-exp (a-hex-exp)

                         := <identifier>
                            var-exp (identifier)

                         := <a-lit-text>
                            lit-text (a-lit-text)

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

                         := if <boolean-expression> then <expression> else <expression>
                            if-exp (test-exp true-exp false-exp)

                         := while (<boolean-expression>) { <expression> }
                            while-exp (boolean-exp body)

                         := for <identifier> = <expression> <iterator> <expression> { <expression> }
                            for-exp (var initialization iterator body)

                         := <int-primitive> ({ <expression> }* (,))
                            app-int-prim-exp (rator rands)

                         := <float-primitive> ({ <expression> }* (,))
                            app-float-prim-exp (rator rands)

                         := <hex-primitive> ({ <expression> }* (,))
                            app-hex-prim-exp (rator rands)

                         := create-list (<expression> , <expression>)
                            create-list-exp (exp list-exp)

<int-primitive>          := +i
                            int-add-prim ()

                         := -i
                            int-substract-prim ()

                         := *i
                            int-mult-prim ()

                         := /i
                            int-div-prim ()

                         := %i
                            int-module-prim ()

                         := add1i
                            int-incr-prim ()

                         := sub1i
                            int-decr-prim ()

<float-primitive>          := +f
                            float-add-prim ()

                         := -f
                            float-substract-prim ()

                         := *f
                            float-mult-prim ()

                         := /f
                            float-div-prim ()

                         := %f
                            float-module-prim ()

                         := add1f
                            float-incr-prim ()

                         := sub1f
                            float-decr-prim ()

<hex-primitive>          := +h
                            hex-add-prim ()

                         := -h
                            hex-substract-prim ()

                         := *h
                            hex-mult-prim ()

                         := add1h
                            hex-incr-prim ()

                         := sub1h
                            hex-decr-prim ()

<comparator_prim>        := <
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

<boolean>                := true
                            true-boolean-exp ()

                         := false
                            false-boolean-exp ()

<bool_binary_operator>   := and
                            and-bool-binary-operator ()

                         := or
                            or-bool-binary-operator ()

<bool_unary_operator>    := not
                            negation-bool-unary-operator ()

<boolean-expression>     := <boolean>
                            atomic-boolean-exp (atomic-boolean)

                         := <bool_binary_operator> ( <boolean-expression> , <boolean-expression> )
                            app-binary-boolean-operator-exp (rator rand1 rand2)

                         := <bool_unary_operator> ( <boolean-expression> )
                            app-unary-boolean-operator-exp (rator rand)

                         := <comparator_prim> ( <expression> , <expression> )
                            app-comparator-boolean-exp (rator rand1 rand2)

<unary_string_primitive> := my-string-length
                            length-string-prim ()

<binary_string_primitive> := my-string-concat
                             concat-string-prim ()

<unary_list_primitive>    := empty-list?
                             is-empty-list-prim ()

                          := empty-list
                             empty-list-prim ()

                          := list-head
                             list-head-prim ()

                          := list-tail
                             list-tail-prim ()

<unary_tuple_primitive>   := empty-tuple?
                             is-empty-tuple-prim ()

                          := empty-tuple
                             empty-tuple-prim ()

                          := tuple-head
                             tuple-head-prim ()

                          := tuple-tail
                             tuple-tail-prim ()

```
