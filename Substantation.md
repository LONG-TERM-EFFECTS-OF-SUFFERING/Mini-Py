# Substantiation

1. Muestre mediante un solo ejemplo que su interpretador Mini-Py es capaz de almacenar todos los siguientes valores denotados:

	- Enteros.

	- Flotantes.

	- Hexadecimales.

	- Caracteres.

	- Cadenas de caracteres.

	- Booleanos (true, false).

	- Procedimientos.

	- Listas.

	- registros.

	- tuplas.

	```
	int main() {
		var
			#int = 3
			#float = 3.0
			#hex = x16 (3)
			#string = \"Hello-world\"
			#bool = true
			#proc = proc() 3
			#list = list(3)
			#dictionary = { number = 3 }
			#tuple = tuple(3)
		in
			begin
				print(#int);
				print(#float);
				print(#string);
				print(#bool);
				print((#proc));
				print(#list);
				print(#dictionary);
				print(#tuple)
			end
	}
	```

	> Caracteres.

2. Muestre mediante un solo ejemplo que su interpretador Mini-Py es capaz de manejar variables actualizables o mutables. El ejemplo deberá contener una variable X con algún valor inicial, luego se debe evidenciar que la variable cambia de valor con alguna instrucción tipo set o similar. No es válido un ejemplo donde a través de ambientes se creen variables con el mismo nombre y con distintos valores, es necesario evidenciar la instrucción para modificación de la variable.

	```
	int main() {
		var
			#x = 1
		in
			begin
				set #x = 0;
				#x // 0
			end
	}
	```

3. Muestre mediante dos ejemplos que su interpretador Mini-Py es capaz de crear variables de asignación única (constantes):

	- Un programa debe permitir crear una constante con algún valor asignado y retornar su valor.

	- Un programa debe permitir crear una constante con algún valor asignado y retornar un error al tratar de modificar su valor a través de la instrucción para modificación de variables de su lenguaje.

	```
	int main() {
		const
			#x = 1
		in
			begin
				print(#x); // 1
				set #x = 0
			end
	}
	```

4. Muestre mediante un solo ejemplo que su interpretador Mini-Py tiene la capacidad de procesar las siguientes Primitivas aritméticas:  "+", "−", "∗", "%", "/", "add1", "sub1" para:

	- Enteros

	- Hexadecimales (excepto las operaciones "%" y "/").

	```
	int main() {
		const
			#hex1 = x16 (14, 2, 15)
			#hex2 = x16 (15, 14, 2)

			#int1 = 52
			#int2 = 60
		in
			begin
				print(+i (#int1, #int2));
				print(-i (#int1, #int2));
				print(*i (#int1, #int2));
				print(%i (#int1, #int2));
				print(/i (#int1, #int2));

				print(+h (#hex1, #hex2));
				print(-h (#hex1, #hex2));
				print(*h (#hex1, #hex2))
			end
	}
	```

5. Muestre mediante un solo ejemplo que su interpretador Mini-Py tiene la capacidad de procesar las siguientes Primitivas booleanas:  ("<", ">", "<=", ">=", "==", "!=", "and", "or", "not") para números enteros.

	```
	int main() {
		const
			#int1 = 52
			#int2 = 60
		in
			begin
				print(< (#int1, #int2));
				print(> (#int1, #int2));
				print(<= (#int1, #int2));
				print(>= (#int1, #int2));
				print(== (#int1, #int2));
				print(!= (#int1, #int2));
				print(or (#int1, #int2));
				print(and (#int1, #int2));
				print(not (#int1))
			end
	}
	```

6. Muestre mediante un solo ejemplo que su interpretador Mini-Py tiene la capacidad de procesar las Primitivas (longitud, concatenar) para cadenas.

	```
	int main() {
		const
			#string1 = \"Hello\"
			#string2 = \"-world\"
		in
			begin
				print(my-string-length(#string1));
				print(my-string-concat(#string1, #string2))
			end
	}
	```

7. Muestre mediante un solo ejemplo, muestre que su interpretador Mini-Py tiene la capacidad de manejar paso de parámetros por valor (para valores numéricos, caracteres, cadenas, procedimientos, tuplas) y por referencia (para listas y registros) similar a como sucede en Python.

	```
	int main() {
		var
			#number = 5
			#list = list(5)
			#F1 = proc(#a) set-list #a (0, 30)
			#F2 = proc(#b) set #b = 10
		in
			begin
				print(ref-list #list (0)); // 5
				(#F1 #list);
				(#F2 #number);
				print(#number);
				print(ref-list #list (0)) // 30
			end
	}
	```

8. Elabore una función en su lenguaje de programación que reciba una lista de enteros "L" y retorne un registro con dos claves: "valores" y "factoriales". La clave "valores" debe tener asociada una tupla con los mismos valores de "L" y la clave "factoriales" debe tener asociada una lista con el factorial de cada valor de la lista "L".

	```

	```

9. Elabore la función "map" en su lenguaje de programación. La función "map" recibe una lista "L" y una función unaria "F". "map" debe retornar una lista donde se le ha aplicado la función "F" a cada elemento de la lista "L" (utilice las funciones auxiliares necesarias).

	```
	int main() {
		var
			#list = list(4, 3, 5, 6)
			#f = proc(int #n) *i(#n, #n)
		in
			rec
				int #map(int #list, int #f) =
						if empty-list?(#list)
						then list()
						else create-list((#f list-head(#list)), (#map list-tail(#list) #f))
			in
				(#map #list #f)
	}
	```

10. Mediante 2 ejemplos muestre que su interpretador Mini-Py tiene la capacidad de utilizar ciclos de repetición. Para esto, escriba dos programas independientes en su lenguaje de programación (uno con while y otro con for) que:

	- contenga un ciclo de repetición que itere de 1 a 5 e imprima o retorne los estados de la variable del ciclo que se utiliza (i.e., 1,2,3,4,5). El programa podrá retornar ya sea una lista o una tupla o imprimir los valores en pantalla.

	- contenga un ciclo de repetición que itere de 1 a 5 e invoque al procedimiento "esPar?" con la variable del ciclo que utiliza (i.e., false,true,false,true,false). El programa podrá retornar ya sea una lista o una tupla o imprimir los valores en pantalla.

	```


	```