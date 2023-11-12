# Mini-Py

## Grammar specification

```
<program>           := int main() { <expression> }
                        a-program (exp)

<expression>        := <number>
                       lit-number (num)

                    := x <number> ({ expression }+)
                       bignum-exp (base numbers)

                    := "<text>"
                       lit-text (txt)

                    := <identifier>
                       var-exp (id)

                    := "true"
                        true-exp

                    := "false"
                        false-exp

                    := var { <identifier> = <expression> }* in <expression>
                       let-exp (identifiers bodies body)

                    := const { <identifier> = <expression> }* in <expression>
                       const-exp (identifiers bodies body)

                    := rec { <identifier> ({ identifier }* (,)) = <expression> }* in <expression>
                       letrec-exp (procedures-names procedures-arguments procedures-bodies body)
```