#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")



; -------------------------------------------------------------------------- ;
;                          USES CASES OF GRAMMAR                             ;
; -------------------------------------------------------------------------- ;

; -------------------------- Define a program ------------------------------ ;
; With this we can initialize a program in our language
; We based in C++ syntax for this
(scan&parse "
	int main() {
	3 
	}
")

; -------------------------- Numbers -------------------------------------- ;
; In our language we have entire numbers, floating numbers and hexadecimal numbers
(scan&parse "
	int main() {
	// entire number: 
	// 3
	// floating number:
	// 3.1415
	// hexadecimal number:
	x 16 (4,12,10)
	}
")

; -------------------------- String of Characteres --------------------------------- ;
; In our language we have string of characteres
(scan&parse "
	int main() {
	\"Hello-World\"
	}
")

; -------------------------- Booleans --------------------------------- ;
; In our language we have booleans

(scan&parse "
	int main() {
	// true
	// false
	}
")
