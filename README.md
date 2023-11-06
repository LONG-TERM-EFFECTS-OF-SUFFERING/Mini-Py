# Mini-Py

## Grammar specification

```
<program>           := main() { <expression> }

<expression>        := <number>
                       lit-number (num)

                    := "<text>"
                       lit-text (txt)

                    := <identifier>
                       var-exp (id)

                    := "true"
                        true-exp

                    := "false"
                        false-exp
```