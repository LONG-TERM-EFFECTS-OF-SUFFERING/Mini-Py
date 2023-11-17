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


	(expression ("(" expression (arbno expression) ")") app-exp)
	(expression ("set" identifier "=" expression) set-exp)

	; ------------------------------- COMPARATORS ------------------------------ ;

	(comparator_prim ("") smaller-than-comparator-prim)
	(comparator_prim (">") greater-than-comparator-prim)
	(comparator_prim ("<=") less-equal-to-comparator-prim)
	(comparator_prim (">=") greater-equal-to-comparator-prim)
	(comparator_prim ("==") equal-to-comparator-prim)
	(comparator_prim ("!=") not-equal-to-comparator-prim)

	; ------------------------ BOOLEAN BINARY OPERATORS ------------------------ ;

	(bool_binary_operator ("and") and-bool-binary-operator)
	(bool_binary_operator ("or") or-bool-binary-operator)

	; -------------------------- BOOL UNARY OPERATORS -------------------------- ;

	(bool_unary_operator ("not") negation-bool-unary-operator)

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

	(expression (primitive "(" (separated-list expression ",") ")" ) primapp-exp)

	; ---------------------------- STRING PRIMITIVES --------------------------- ;

	(unary_string_primitive ("my-length") length-string-prim)

	(binary_string_primitive ("my-concat") concat-string-prim)

	; ----------------------------- LIST PRIMITIVES ---------------------------- ;

	(unary_list_primitive ("empty-list?") is-empty-list-prim)
	(unary_list_primitive ("empty-list") empty-list-prim)
	(unary_list_primitive ("list?") is-list-prim)
	(unary_list_primitive ("head-list") head-list-prim)
	(unary_list_primitive ("tail-list") tail-list-prim)

	(list_primitive ("create-list" "(" (separated-list expression ",") ")" ) create-list-prim)
	(list_primitive ("append") append-list-prim)
	(list_primitive ("ref-list") ref-list-prim)
	(list_primitive ("set-list") set-list-prim)

	(expression (unary_list_primitive "(" expression ")" ) unary_list_primitive-app-exp)
	(expression (list_primitive "(" (separated-list expression ",") ")" ) list_primitive-app-exp) ; Pending

	; ---------------------------- TUPLES PRIMITIVES --------------------------- ;

	(unary_tuple_primitive ("empty-tuple?") is-empty-tuple-prim)
	(unary_tuple_primitive ("empty-ttuple") empty-tuple-prim)
	(unary_tuple_primitive ("tuple?") is-tuple-prim)
	(unary_tuple_primitive ("head-tuple") head-tuple-prim)
	(unary_tuple_primitive ("tail-tuple") head-tuple-prim)

	(tuple_primitive ("create-tuple" "(" expression "," expression ")" ) create-tuple-prim)
	(tuple_primitive ("ref-tuple") ref-tuple-prim)

	(expression (unary_tuple_primitive "(" expression ")" ) unary_tuple_primitive-app-exp)
	(expression (tuple_primitive "(" (separated-list expression ",") ")" ) tuple_primitive-app-exp) ; Pending

	; --------------------------- RECORDS PRIMITIVES --------------------------- ;

	(unary_record_primitive ("record?") is-record-prim)

	; (record_primitive ("create-record" "(" record ")") create-record-prim) ; Pending
	(record_primitive ("ref-record") ref-record-prim)
	(record_primitive ("set-record") set-record-prim)

	(expression (unary_record_primitive "(" expression ")" ) unary_record_primitive-app-exp) ; Pending
	(expression (record_primitive "(" (separated-list expression ",") ")" ) record_primitive-app-exp) ; Pending
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
