#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")


; -------------------------------------------------------------------------- ;
;                          USES CASES OF GRAMMAR                             ;
; -------------------------------------------------------------------------- ;

; --------------------------- PROGRAM DEFINITION --------------------------- ;

; We based in C++ syntax for this

(scan&parse "
	int main() {
		3
	}
")

; --------------------------------- NUMBERS -------------------------------- ;

; Int, floating and hexadecimal numbers

(scan&parse "
	int main() {
		// 3 // Int
		// 3.1415 // Floating
		x16 (4, 12, 10) // Hexadecimal
	}
")
; --------------------------------- STRINGS -------------------------------- ;

(scan&parse "
	int main() {
		\"Hello-World\"
	}
")

; -------------------------------- BOOLEANS -------------------------------- ;

(scan&parse "
	int main() {
		// true
		false
	}
")

; ------------------------------- IDENTIFIERS ------------------------------ ;
(scan&parse "
	int main() {
		#myIdentifier 
	}
")

; ------------------------------- DEFINITION ------------------------------- ;
; Var definition
(scan&parse "
	int main() {
		var #x = 5 in #x
	}
")

; Const definition
(scan&parse "
	int main() {
		const #x = 5 in #x
	}
")

; Letrec definition
(scan&parse "
	int main() {
		rec #f (#x) = #x in 5
	}
")

;Proc definition
(scan&parse "
	int main() {
		proc (#x,#y,#z) #x
	}
")

(scan&parse "
	int main() {
		(#f 1 2)
	}
")

(scan&parse "
	int main() {
		set #x = 5
	}
")

; ---------------------------------- DATA ---------------------------------- ;

; List
(scan&parse "
	int main() {
		list (1,2,3)
	}
")

; Tuple
(scan&parse "
	int main() {
		tuple (1,2,3)
	}
")

; Record
(scan&parse "
	int main() {
		{ page = 5; cap = \"The-End\" }
	}
")


; ------------------------------- COMPARATORS ------------------------------ ;

; atomic boolean expression
(scan&parse "
	int main() {
		true
		// false
	}
")

; app-binary-boolean-operator-exp)
(scan&parse "
	int main() {
		// and (true, false)
		// or (true, false)
		and (true, or (true, false ))
	}
")

; app-unary-boolean-operator-exp
(scan&parse "
	int main() {
		not (true)
	}
")

; app-comparator-boolean-exp
(scan&parse "
	int main() {
		// < (1, 2)
		// > (1, 2)
		// <= (1, 2)
		// >= (1, 2)
		// == (1, 2)
		// != (1, 2)
		< (1, > (2, 3))
	}
")

; --------------------------- CONTROL STRUCTURES --------------------------- ;

; begin-exp
(scan&parse "
	int main() {
		begin
			1;
			2;
			#myVar
		end
	}
")

; if-exp
(scan&parse "
	int main() {
		if true then 1 else 2
	}
")

; while-exp
(scan&parse "
	int main() {
		while (true) {
			1
		}
	}
")

; for-exp
(scan&parse "
	int main() {
		for #i = 1 to 10 {
			1
		}
	}
")

; ------------------------------- PRIMITIVES ------------------------------- ;

; ----------------------------- INT PRIMITIVES ----------------------------- ;

; int-add-prim
(scan&parse "
	int main() {
		+i (1, 2)
	}
")

; int-substract-prim
(scan&parse "
	int main() {
		-i (1, 2)
	}
")

; int-mult-prim
(scan&parse "
	int main() {
		*i (1, 2)
	}
")

; int-div-prim
(scan&parse "
	int main() {
		/i (1, 2)
	}
")

; int-module-prim
(scan&parse "
	int main() {
		%i (1, 2)
	}
")

; int-incr-prim
(scan&parse "
	int main() {
		add1i (1)
	}
")

; int-decr-prim
(scan&parse "
	int main() {
		sub1i (1)
	}
")

; ---------------------------- FLOAT PRIMITIVES ---------------------------- ;

; float-add-prim
(scan&parse "
	int main() {
		+f (1, 2)
	}
")

; float-substract-prim
(scan&parse "
	int main() {
		-f (1, 2)
	}
")

; float-mult-prim
(scan&parse "
	int main() {
		*f (1, 2)
	}
")

; floar-div-prim
(scan&parse "
	int main() {
		/f (1, 2)
	}
")

; float-module-prim
(scan&parse "
	int main() {
		%f (1, 2)
	}
")

; float-incr-prim
(scan&parse "
	int main() {
		add1f (1)
	}
")

; float-decr-prim
(scan&parse "
	int main() {
		sub1f (1)
	}
")

; --------------------------- HEXADECIMAL PRIMITIVES --------------------------- ;

; hex-add-prim
(scan&parse "
	int main() {
		+h (1, 2)
	}
")

; hex-substract-prim
(scan&parse "
	int main() {
		-h (1, 2)
	}
")

; hex-mult-prim
(scan&parse "
	int main() {
		*h (1, 2)
	}
")

; hex-incr-prim
(scan&parse "
	int main() {
		add1h (1)
	}
")

; hex-decr-prim
(scan&parse "
	int main() {
		sub1h (1)
	}
")

; ----------------------------- LIST PRIMITIVES ---------------------------- ;

;unary-list-primitive-app-exp
(scan&parse "
	int main() {
		empty-list? (list (1,2,3))
		// my-list? (list (1,2,3))
		// head-list (list (1,2,3))
		// tail-list (list (1,2,3))
	}
")

; ---------------------------- TUPLES PRIMITIVES --------------------------- ;

;unary-tuple-primitive-app-exp
(scan&parse "
	int main() {
		empty-tuple? (tuple (1,2,3))
		// tuple? (tuple (1,2,3))
		// head-tuple (tuple (1,2,3))
		// tail-tuple (tuple (1,2,3))
	}
")

; --------------------------- RECORDS PRIMITIVES --------------------------- ;

; Pending

