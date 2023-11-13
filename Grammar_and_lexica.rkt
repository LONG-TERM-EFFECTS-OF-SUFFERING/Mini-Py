#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)


; -------------------------------------------------------------------------- ;
;                                   LEXICA                                   ;
; -------------------------------------------------------------------------- ;

(define lexica '(
	(white-sp (whitespace) skip)
	(comment ("//" (arbno (not #\newline))) skip) ; Comments
    (comment (#\# (arbno (not #\#)) #\#) skip) ; Comment in block
	(identifier (letter (arbno (or letter digit "?"))) symbol)
	(number (digit (arbno digit)) number) ; Positive int numbers
	(number ("-" digit (arbno digit)) number) ; Negative int numbers
	(number (digit (arbno digit) "." digit (arbno digit)) number) ; Positive float numbers
	(number ("-" digit (arbno digit) "." digit (arbno digit)) number) ; Negative float numbersdd
	(text ((or letter "-") (arbno (or letter digit "-" "?" ":"))) string)
))

; -------------------------------------------------------------------------- ;
;                                   GRAMMAR                                  ;
; -------------------------------------------------------------------------- ;

(define grammar '(
	(program ("int" "main" "(" ")" "{" expression "}") a-program)

	; ---------------------------------- DATA ---------------------------------- ;

	(expression (number) lit-number)
	; (expression ("x" number "(" (separated-list number ",") ")") bignum-exp)
	(expression ("x16" "(" (separated-list number ",") ")") hex-exp)
	(expression (identifier) var-exp)
	(expression ("\"" text "\"") lit-text)
	(expression ("true") true-exp)
	(expression ("false") false-exp)
	(expression ("list" "(" (separated-list number ",") ")") list-exp)
	(expression ("tuple" "(" (separated-list number ",") ")") tuple-exp)
	(expression ("{" text "=" expression (arbno ";" text "=" expression) "}") record-exp)

	; ------------------------------- DEFINITIONS ------------------------------ ;

	(expression ("var" (arbno identifier "=" expression) "in" expression) let-exp)
	(expression ("const" (arbno identifier "=" expression) "in" expression) const-exp)
	(expression ("rec"
		(arbno identifier "(" (separated-list identifier ",") ")" "=" expression) "in" expression)
		letrec-exp)
	(expression ("proc" "(" (separated-list identifier ",") ")" expression) proc-exp)

	(expression (primitive "(" (separated-list expression ",") ")" ) primapp-exp)
	(expression ("if" expression "then" expression "else" expression) if-exp)

	(expression ("(" expression (arbno expression) ")") app-exp)
	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
	(expression ("set" identifier "=" expression) set-exp)


	; ------------------------------- PRIMITIVES ------------------------------- ;

	(primitive ("+") add-prim)
	(primitive ("-") substract-prim)
	(primitive ("*") mult-prim)
	(primitive ("add1") incr-prim)
	(primitive ("sub1") decr-prim)
))

; -------------------------------------------------------------------------- ;
;                                   SLLGEN                                   ;
; -------------------------------------------------------------------------- ;

(sllgen:make-define-datatypes lexica grammar)


(define show-the-datatypes (
	sllgen:list-define-datatypes lexica grammar
))


(define scan&parse (
	sllgen:make-string-parser lexica grammar
))


(define just-scan (
	sllgen:make-string-scanner lexica grammar
))


(provide (all-defined-out))
