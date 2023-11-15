# Mini-Py

## Grammar specification

```
<program>              := int main() { <expression> }
                        a-program (exp)

<expression>           := <number>
                       lit-number (num)

                       := x16 ({ <number> }+)
                       hex-exp (numbers)

                       := <identifier>
                       var-exp (id)

                       := "<text>"
                       lit-text (txt)

                       := "true"
                        true-exp

                       := "false"
                        false-exp

                       := list( { <expression> }* (,))
                       list-exp (exps)

                       := tuple({ <expression> }* (,))
                       tuple-exp (exps)

                       := {{ <text> = <expression> ;}* <text> = <expression>}
                       record-exp (exps)

                       := var { <identifier> = <expression> }* in <expression>
                       let-exp (identifiers bodies body)

                       := const { <identifier> = <expression> }* in <expression>
                       const-exp (identifiers bodies body)

                       := rec { <identifier> ({ identifier }* (,)) = <expression> }* in <expression>
                       letrec-exp (procedures-names procedures-arguments procedures-bodies body)

                       := proc({ <identifier> }* (,)) <expression>
                       proc-exp (procedure-arguments body)

<comparator-prim>      := <
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

<bool-binary-operator> := and
                          and-bool-binary-operator ()

                       := or
                          or-bool-binary-operator ()
```
