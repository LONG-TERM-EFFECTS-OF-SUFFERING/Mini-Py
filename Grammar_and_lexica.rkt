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
	(comment ("/*" (arbno (not #\*/)) "*/") skip) ; Block comments
	(identifier ("#" letter (arbno (or letter digit "?"))) symbol)
	(number (digit (arbno digit)) number) ; Positive int numbers
	(number ("-" digit (arbno digit)) number) ; Negative int numbers
	(number (digit (arbno digit) "." digit (arbno digit)) number) ; Positive float numbers
	(number ("-" digit (arbno digit) "." digit (arbno digit)) number) ; Negative float numbers
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
	(expression ("(" expression (arbno expression) ")") app-exp)
	(expression ("set" identifier "=" expression) set-exp)

	; ------------------------------- COMPARATORS ------------------------------ ;

	(comparator-prim ("") smaller-than-comparator-prim)
	(comparator-prim (">") greater-than-comparator-prim)
	(comparator-prim ("<=") less-equal-to-comparator-prim)
	(comparator-prim (">=") greater-equal-to-comparator-prim)
	(comparator-prim ("==") equal-to-comparator-prim)
	(comparator-prim ("!=") not-equal-to-comparator-prim)

	; ------------------------ BOOLEAN BINARY OPERATORS ------------------------ ;

	(bool-binary-operator ("and") and-bool-binary-operator)
	(bool-binary-operator ("or") or-bool-binary-operator)

	; -------------------------- BOOL UNARY OPERATORS -------------------------- ;

	(bool-unary-operator ("not") negation-bool-unary-operator)

	; --------------------------- CONTROL STRUCTURES --------------------------- ;

	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
	(expression ("if" expression "then" expression "else" expression) if-exp)
	(expression ("while" "(" expression ")" "{" expression "}") while-exp)
	(expression ("for" identifier "=" expression iterator expression "{" expression "}") for-exp)

	; -------------------------------- ITERATORS ------------------------------- ;

	(iterator ("to") to-iterator)
	(iterator ("downto") downto-iterator)

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
