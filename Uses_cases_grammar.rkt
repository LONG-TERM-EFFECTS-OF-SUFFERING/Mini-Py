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
