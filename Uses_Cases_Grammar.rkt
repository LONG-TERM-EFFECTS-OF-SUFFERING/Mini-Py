#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")

;;; (define grammar '(
;;; 	(program ("int" "main" "(" ")" "{" expression "}") a-program)
;;; 	(expression (number) lit-number)
;;; 	(expression (identifier) var-exp)
;;; 	(expresion ("\"" text "\"") lit-text)
;;; 	(expression ("false") false-exp)
;;; 	(expression ("true") true-exp)
;;; 	(expression (primitive "(" (separated-list expression ",") ")" ) primapp-exp)
;;; 	(expression ("if" expression "then" expression "else" expression) if-exp)
;;; 	(expression ("let" (arbno identifier "=" expression) "in" expression) let-exp)
;;; 	(expression ("letrec"
;;; 		(arbno identifier "(" (separated-list identifier ",") ")" "=" expression) "in" expression)
;;; 		letrec-exp)
;;; 	(expression ("proc" "(" (separated-list identifier ",") ")" expression) proc-exp)
;;; 	(expression ("(" expression (arbno expression) ")") app-exp)
;;; 	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
;;; 	(expression ("set" identifier "=" expression) set-exp)
;;; 	(primitive ("+") add-prim)
;;; 	(primitive ("-") substract-prim)
;;; 	(primitive ("*") mult-prim)
;;; 	(primitive ("add1") incr-prim)
;;; 	(primitive ("sub1") decr-prim)
;;; ))

; -------------------------------------------------------------------------- ;
;                          USES CASES OF GRAMMAR                             ;
; -------------------------------------------------------------------------- ;

; -------------------------- Define a program ------------------------------ ;
; With this we can initialize a program in our language
; We based in C++ syntax for this
(scan&parse "
  int main() {
  ;;; ... 
  3
  }
")

; -------------------------- Numbers -------------------------------------- ;
; In our language we have entire numbers, floating numbers and hexadecimal numbers
(scan&parse "
  int main() {
  ;;; entire number: 
  ;;; 3
  ;;; floating number:
  ;;; 3.1415
  ;;; hexadecimal number:
  x 16 (4,12,10)
  }
")

; -------------------------- String of Characteres --------------------------------- ;
; In our language we have string of characteres
(scan&parse "
  int main() {
  ;;; string of characteres:
  \"Hello World\"
  }
")
