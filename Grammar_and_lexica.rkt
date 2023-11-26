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
	(number-f (digit (arbno digit) "." digit (arbno digit)) number) ; Positive float numbers
	(number-f ("-" digit (arbno digit) "." digit (arbno digit)) number) ; Negative float numbers
	(text (letter (arbno (or letter digit "-" "?" ":"))) string)
))

; -------------------------------------------------------------------------- ;
;                                   GRAMMAR                                  ;
; -------------------------------------------------------------------------- ;

(define grammar '(
	(program ("int" "main" "(" ")" "{" expression "}") a-program)

	; -------------------------------------------------------------------------- ;
	;                                    DATA                                    ;
	; -------------------------------------------------------------------------- ;

	(expression (number) lit-number-int)
	(expression (number-f) lit-number-float)
	; (expression ("x" number "(" (separated-list number ",") ")") bignum-exp)

	(a-hex-exp ("x16" "(" (separated-list number ",") ")") a-hex-exp_)
	(expression (a-hex-exp) hex-exp)

	(expression (identifier) var-exp)

	(a-lit-text ("\"" text "\"") a-lit-text_)
	(expression (a-lit-text) lit-text)

	(a-list-exp ("list" "(" (separated-list expression ",") ")") a-list-exp_)
	(expression (a-list-exp) list-exp)

	(a-tuple-exp ("tuple" "(" (separated-list expression ",") ")") a-tuple-exp_)
	(expression (a-tuple-exp) tuple-exp)

	(a-dictionary-exp ("{" text "=" expression (arbno ";" text "=" expression) "}") a-dictionary-exp_)
	(expression (a-dictionary-exp) dictionary-exp)


	; -------------------------------------------------------------------------- ;
	;                                 DEFINITION                                 ;
	; -------------------------------------------------------------------------- ;


	(expression ("var" (arbno identifier "=" expression) "in" expression) let-exp)
	(expression ("const" (arbno identifier "=" expression) "in" expression) const-exp)
	(expression ("rec"
		(arbno type-exp identifier "(" (separated-list type-exp identifier ",") ")" "=" expression) "in" expression)
		letrec-exp) 
	(expression ("proc" "(" (separated-list type-exp identifier ",") ")" expression) proc-exp) 


	(expression ("(" expression (arbno expression) ")") app-exp)
	(expression ("set" identifier "=" expression) set-exp)

	; -------------------------------------------------------------------------- ;
	;                                   BOOLEAN                                  ;
	; -------------------------------------------------------------------------- ;

	; ------------------------------- COMPARATOR ------------------------------- ;

	(comparator_prim ("<") smaller-than-comparator-prim)
	(comparator_prim (">") greater-than-comparator-prim)
	(comparator_prim ("<=") less-equal-to-comparator-prim)
	(comparator_prim (">=") greater-equal-to-comparator-prim)
	(comparator_prim ("==") equal-to-comparator-prim)
	(comparator_prim ("!=") not-equal-to-comparator-prim)

	; --------------------------------- ATOMIC --------------------------------- ;

	(atomic_boolean ("true") true-boolean)
	(atomic_boolean ("false") false-boolean)

	; ----------------------------- BINARY OPERATOR ---------------------------- ;

	(bool_binary_operator ("and") and-bool-binary-operator)
	(bool_binary_operator ("or") or-bool-binary-operator)

	; ----------------------------- UNARY OPERATOR ----------------------------- ;

	(bool_unary_operator ("not") negation-bool-unary-operator)

	; ------------------------------- EXPRESSION ------------------------------- ;

	(boolean_expression (atomic_boolean) atomic-boolean-exp)
	
	(boolean_expression (bool_binary_operator "(" expression "," expression ")" ) app-binary-boolean-operator-exp)
	
	(boolean_expression (bool_unary_operator "(" expression ")" ) app-unary-boolean-operator-exp)
	
	(boolean_expression (comparator_prim "(" expression "," expression ")" ) app-comparator-boolean-exp)

	(expression (boolean_expression) a-boolean_expression)


	; -------------------------------------------------------------------------- ;
	;                              CONTROL STRUCTURE                             ;
	; -------------------------------------------------------------------------- ;

	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
	(expression ("if" expression "then" expression "else" expression) if-exp)
	(expression ("while" "(" expression ")" "{" expression "}") while-exp)
	(expression ("for" "(" identifier "=" expression iterator expression ")" "{" expression "}") for-exp)

	(expression ("print" "(" expression ")") print-exp)

	; -------------------------------- ITERATOR -------------------------------- ;

	(iterator ("to") to-iterator)
	(iterator ("downto") downto-iterator)

	; -------------------------------------------------------------------------- ;
	;                                  PRIMITIVE                                 ;
	; -------------------------------------------------------------------------- ;

	; ----------------------------------- INT ---------------------------------- ;

	(int-primitive ("+i") int-add-prim)
	(int-primitive ("-i") int-substract-prim)
	(int-primitive ("*i") int-mult-prim)
	(int-primitive ("/i") int-div-prim)
	(int-primitive ("%i") int-module-prim)
	(int-primitive ("add1i") int-incr-prim)
	(int-primitive ("sub1i") int-decr-prim)

	(expression (int-primitive "(" (separated-list expression ",") ")" ) app-int-prim-exp)

	; ---------------------------------- FLOAT --------------------------------- ;

	(float-primitive ("+f") float-add-prim)
	(float-primitive ("-f") float-substract-prim)
	(float-primitive ("*f") float-mult-prim)
	(float-primitive ("/f") float-div-prim)
	(float-primitive ("%f") float-module-prim)
	(float-primitive ("add1f") float-incr-prim)
	(float-primitive ("sub1f") float-decr-prim)

	(expression (float-primitive "(" (separated-list expression ",") ")" ) app-float-prim-exp)

	; ------------------------------- HEXADECIMAL ------------------------------ ;

	(hex-primitive ("+h") hex-add-prim)
	(hex-primitive ("-h") hex-substract-prim)
	(hex-primitive ("*h") hex-mult-prim)
	(hex-primitive ("add1h") hex-incr-prim)
	(hex-primitive ("sub1h") hex-decr-prim)

	(expression (hex-primitive "(" (separated-list expression ",") ")" ) app-hex-prim-exp)

	; --------------------------------- STRING --------------------------------- ;

	(unary_string_primitive ("my-string-length") length-string-prim)
	(expression (unary_string_primitive  "(" expression ")" ) app-unary-string-prim-exp)

	(binary_string_primitive ("my-string-concat") concat-string-prim)
	(expression (binary_string_primitive "(" expression "," expression ")" ) app-binary-string-prim-exp)

	; -------------------------------------------------------------------------- ;
	;                                    LIST                                    ;
	; -------------------------------------------------------------------------- ;

	(unary_list_primitive ("empty-list?") is-empty-list-prim)
	(unary_list_primitive ("empty-list") empty-list-prim)
	(unary_list_primitive ("my-list?") is-list-prim)
	(unary_list_primitive ("list-head") list-head-prim)
	(unary_list_primitive ("list-tail") list-tail-prim)

	(expression ("create-list" "(" expression "," expression ")" ) create-list-exp)

	(list_primitive ("append") append-list-prim)
	(list_primitive ("ref-list") ref-list-prim)
	(list_primitive ("set-list") set-list-prim)
	(expression (unary_list_primitive "(" expression ")" ) unary_list_primitive-app-exp)
	(expression (list_primitive identifier "(" (separated-list expression ",") ")" ) list_primitive-app-exp)
	;PEND

	; -------------------------------------------------------------------------- ;
	;                                    TUPLE                                   ;
	; -------------------------------------------------------------------------- ;

	(unary_tuple_primitive ("empty-tuple?") is-empty-tuple-prim)
	(unary_tuple_primitive ("empty-tuple") empty-tuple-prim)
	(unary_tuple_primitive ("tuple?") is-tuple-prim)
	(unary_tuple_primitive ("head-tuple") tuple-head-prim)
	(unary_tuple_primitive ("tail-tuple") tuple-tail-prim)

	(expression  ("create-tuple" "(" expression "," expression ")" ) create-tuple-exp)

	(tuple_primitive ("ref-tuple") ref-tuple-prim);PEND

	(expression (unary_tuple_primitive "(" expression ")" ) unary_tuple_primitive-app-exp)

	(expression (tuple_primitive identifier "(" expression ")" ) tuple_primitive-app-exp)

	; -------------------------------------------------------------------------- ;
	;                                 DICTIONARY                                 ;
	; -------------------------------------------------------------------------- ;

	(expression ("create-dictionary" "(" a-dictionary-exp ")") create-dictionary-prim)

	(unary_dictionary_primitive ("dictionary?") is-dictionary-prim)

	(dictionary_primitive ("ref-dictionary") ref-dictionary-prim)
	(dictionary_primitive ("set-dictionary") set-dictionary-prim); PEND

	(expression (unary_dictionary_primitive "(" expression ")" ) unary_dictionary_primitive-app-exp)

	(expression (dictionary_primitive "(" identifier "," (separated-list expression ",") ")" ) dictionary_primitive-app-exp)


	; -------------------------------------------------------------------------- ;
	;                               TYPE EXPRESSION                              ;
	; -------------------------------------------------------------------------- ;

	(type-exp ("int") int-type-exp)
	(type-exp ("float") float-type-exp)
	(type-exp ("hex") hex-type-exp)
	(type-exp ("string") string-type-exp)
  (type-exp ("bool") bool-type-exp)
  (type-exp ("tuplbool-tye") tuple-type-exp)
  (type-exp ("dictionary") dictionary-type-exp)
	
	(type-exp
		("(" (separated-list type-exp ",") "->" type-exp ")")
		proc-type-exp
	)
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
