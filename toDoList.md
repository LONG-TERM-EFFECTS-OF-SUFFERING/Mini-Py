# Mini Py

## Observaciones

- La gramatica debe estar acompañada de comentarios casos de uso y ejemplos usando el scan-and-parse
- Entregar el lenguaje normal y el tipado
- Implementar tipado por checkeo no pr inferencia, igual a la primera parte del curso

- Valores

    - [X] Enteros.

    - [X] Flotantes.

    - [X] BIGNUM.

    - [X] Cadenas de caracteres.

    - [X] Booleanos.

    - [ ] Procedimientos.

    - [ ] Listas.

    - [ ] Registros.

    - [ ] Tuplas.

## Gramatica

- Sintaxis Gramatical.

    - [X] Identificadores.

    - Definiciones.

        - [X] var.

        - [X] const.

        - [X] rec.

    - Datos.

        - [ ] numero

        - [ ] cadena

        - [ ] booleano

    - Constructores de Datos Predefinidos.

        - [ ] lista

        - [ ] tupla

        - [ ] registro

        - [ ] expr-bool

    - Estructuras de control

        - [ ] begin-end
        
        - [ ] if-then-else

        - [ ] while-do

        - [ ] for-do

    - Primitiva aritmetica para enteros

        - [ ] +e

        - [ ] -e

        - [ ] *e    

        - [ ] /e    

        - [ ] add1e

        - [ ] sub1e

    - Primitiva aritmetica para flotantes

        - [ ] +f

        - [ ] -f

        - [ ] *f

        - [ ] /f

        - [ ] add1f

        - [ ] sub1f

    - Primitiva aritmetica para hexadecimales

        - [ ] +h

        - [ ] -h

        - [ ] *h

        - [ ] add1h

        - [ ] sub1h


    - Primitivas sobre cadenas

        - [ ] length

        - [ ] concat

    - Primitivas sobre listas (recordar que las listas son mutables)

        - [ ] empty? : list -> bool

        - [ ] empty : list

        - [ ] create-list : list

        - [ ] list? : list -> bool

        - [ ] head : list -> value

        - [ ] tail : list -> value

        - [ ] append : list, value -> list : Agrega un elemento al final de la lista

        - [ ] ref-list : list, int -> value

        - [ ] set-list : list, int, value -> list

    - Primitivas sobre tuplas. (Recordar que son inmutables)

        - [ ] empty-tuple? : tuple -> bool

        - [ ] empty-tuple : tuple

        - [ ] create-tuple : tuple
        
        - [ ] tuple? : tuple -> bool

        - [ ] head-tuple : tuple -> value

        - [ ] tail-tuple : tuple -> value

        - [ ] ref-tuple : tuple, int -> value

    - Primitivas sobre registros. (Recordar que son mutables compuestas por conjuntos de claves y valor)

        - [ ] dict? : dict -> bool

        - [ ] create-dict : dict

        - [ ] ref-dict : dict, key -> value : Retorna el valor asociado a la clave

        - [ ] set-dict : dict, key, value -> dict : Asocia una clave con un valor

    - Definicion e invocacion de procedimientos

        - [ ] El lenguaje debe permititr la creacion e invocacion de procedimientos que retornen un valor.

        - [ ] El paso de parametros sera por valor para : **valores numericos, caracteres, cadenas, procedimientos, tuplas**

        - [ ] El paso de parametros sera por referencia para : **listas y registros**

    - Definicion/Invocacion de prodecimientos recursivos

        - [ ] El lenguaje debe permitir la definicion e invocacion de procedimientos que puedan invocarse recursivamente.

        - [ ] El paso de parametros sera por valor para : **valores numericos, caracteres, cadenas, procedimientos, tuplas**

        - [ ] El paso de parametros sera por referencia para : **listas y registros**

    - Variables actualizables (mutables)

        - [ ] Se debe introducir una coleccion de variables actualizables y sus valores iniciales.

        - [ ] Una variable actualizable puede ser actualizada cuantas veces sea necesario.

        - [ ] Se realiza la declaracion de variables mutables (Por ejemplo `a = 5, b = 10;`)

        - [ ] Se realiza la declaracion para mutar variables (Por ejemplo `a -> 10;`)

        - [ ] El intento de mutar una variable inmutable genera un error.

    - Secuenciacion

        - [ ] El lenguaje debera permitir expresiones para la creacion de bloques de instrucciones

    - Iteracion

        - [ ] Se permite la definicion de estructuras **while** y **for**. 

        - [ ] Se agrega la funcionalidad de imprimir en pantalla tipo **print**.
