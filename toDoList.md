# Mini Py

## Observaciones

- La gramatica debe estar acompañada de comentarios casos de uso y ejemplos usando el scan-and-parse
- Entregar el lenguaje normal y el tipado
- Implementar tipado por checkeo no por inferencia, igual a la primera parte del curso

- Valores

	- [X] Enteros.

	- [X] Flotantes.

	- [X] BIGNUM.

	- [X] Cadenas de caracteres.

	- [X] Booleanos.

	- [X] Procedimientos.

	- [X] Listas.

	- [X] Registros.

	- [X] Tuplas.

## Gramatica

- Sintaxis Gramatical.

	- [X] Identificadores.

	- Definiciones.

		- [X] var.

		- [X] const.

		- [X] rec.

	- Datos.

		- [X] numero

		- [X] cadena

		- [X] booleano

	- Constructores de Datos Predefinidos.

		- [ ] lista

		- [ ] tupla

		- [ ] registro

		- [ ] expr-bool

	- Estructuras de control

		- [X] begin-end

		- [X] if-then-else

		- [X] while-do

		- [X] for-do

	- Primitiva aritmetica para enteros

		- [X] +i

		- [X] -i

		- [X] *i

		- [X] /i

		- [X] add1i

		- [X] sub1i

	- Primitiva aritmetica para flotantes

		- [X] +f

		- [X] -f

		- [X] *f

		- [X] /f

		- [X] add1f

		- [X] sub1f

	- Primitiva aritmetica para hexadecimales

		- [X] +h

		- [X] -h

		- [X] *h

		- [X] add1h

		- [X] sub1h

	- Primitivas sobre cadenas

		- [x] length

		- [x] concat

	- Primitivas sobre listas (recordar que las listas son mutables)

		- [X] empty? : list -> bool

		- [X] empty : list

		- [X] create-list : list

		- [X] list? : list -> bool

		- [X] head : list -> value

		- [X] tail : list -> value

		- [X] append : list, value -> list : Agrega un elemento al final de la lista

		- [X] ref-list : list, int -> value

		- [X] set-list : list, int, value -> list

	- Primitivas sobre tuplas. (Recordar que son inmutables)

		- [x] empty-tuple? : tuple -> bool

		- [x] empty-tuple : tuple

		- [x] create-tuple : tuple

		- [x] tuple? : tuple -> bool

		- [x] head-tuple : tuple -> value

		- [x] tail-tuple : tuple -> value

		- [x] ref-tuple : tuple, int -> value

	- Primitivas sobre registros. (Recordar que son mutables compuestas por conjuntos de claves y valor)

		- [X] dictionary? : dictionary -> bool

		- [X] create-dictionary : dictionary

		- [X] ref-dictionary : dictionary, key -> value : Retorna el valor asociado a la clave

		- [X] set-dictionary : dictionary, key, value -> dictionary : Asocia una clave con un valor

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
