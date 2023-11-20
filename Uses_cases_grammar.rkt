#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")



;;; 
;;; ; -------------------------------------------------------------------------- ;
;;; ;                                   LEXICA                                   ;
;;; ; -------------------------------------------------------------------------- ;
;;; 
;;; (define lexica '(
;;; 	(white-sp (whitespace) skip)
;;; 	(comment ("//" (arbno (not #\newline))) skip) ; Comments
;;; 	(comment ("/*" (arbno (not #\*/)) "*/") skip) ; Block comments
;;; 	(identifier ("#" letter (arbno (or letter digit "?"))) symbol)
;;; 	(number (digit (arbno digit)) number) ; Positive int numbers
;;; 	(number ("-" digit (arbno digit)) number) ; Negative int numbers
;;; 	(number (digit (arbno digit) "." digit (arbno digit)) number) ; Positive float numbers
;;; 	(number ("-" digit (arbno digit) "." digit (arbno digit)) number) ; Negative float numbers
;;; 	(text ((or letter "-") (arbno (or letter digit "-" "?" ":"))) string)
;;; ))
;;; 
;;; ; -------------------------------------------------------------------------- ;
;;; ;                                   GRAMMAR                                  ;
;;; ; -------------------------------------------------------------------------- ;
;;; 
;;; (define grammar '(
;;; 	(program ("int" "main" "(" ")" "{" expression "}") a-program)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                    DATA                                    ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(expression (number) lit-number)
;;; 	; (expression ("x" number "(" (separated-list number ",") ")") bignum-exp)
;;; 
;;; 	(a-hex-exp ("x16" "(" (separated-list number ",") ")") a-hex-exp_)
;;; 	(expression (a-hex-exp) hex-exp)
;;; 
;;; 	(expression (identifier) var-exp)
;;; 	(expression ("\"" text "\"") lit-text)
;;; 
;;; 	(a-list-exp ("list" "(" (separated-list number ",") ")") a-list-exp_)
;;; 	(expression (a-list-exp) list-exp)
;;; 
;;; 	(a-tuple-exp ("tuple" "(" (separated-list number ",") ")") a-tuple-exp_)
;;; 	(expression (a-tuple-exp) tuple-exp)
;;; 
;;; 	(a-dictionary-exp ("{" text "=" expression (arbno ";" text "=" expression) "}") a-dictionary-exp_)
;;; 	(expression (a-dictionary-exp) dictionary-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                 DEFINITIONS                                ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(expression ("var" (arbno identifier "=" expression) "in" expression) let-exp)
;;; 	(expression ("const" (arbno identifier "=" expression) "in" expression) const-exp)
;;; 	(expression ("rec"
;;; 		(arbno identifier "(" (separated-list identifier ",") ")" "=" expression) "in" expression)
;;; 		letrec-exp)
;;; 	(expression ("proc" "(" (separated-list identifier ",") ")" expression) proc-exp)
;;; 
;;; 
;;; 	(expression ("(" expression (arbno expression) ")") app-exp)
;;; 	(expression ("set" identifier "=" expression) set-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                   BOLEANS                                  ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	; ------------------------------- COMPARATORS ------------------------------ ;
;;; 
;;; 	(comparator_prim ("<") smaller-than-comparator-prim)
;;; 	(comparator_prim (">") greater-than-comparator-prim)
;;; 	(comparator_prim ("<=") less-equal-to-comparator-prim)
;;; 	(comparator_prim (">=") greater-equal-to-comparator-prim)
;;; 	(comparator_prim ("==") equal-to-comparator-prim)
;;; 	(comparator_prim ("!=") not-equal-to-comparator-prim)
;;; 
;;; 	; --------------------------------- ATOMIC --------------------------------- ;
;;; 
;;; 	(atomic_boolean ("true") true-boolean)
;;; 	(atomic_boolean ("false") false-boolean)
;;; 
;;; 	; ---------------------------- BINARY OPERATORS ---------------------------- ;
;;; 
;;; 	(bool_binary_operator ("and") and-bool-binary-operator)
;;; 	(bool_binary_operator ("or") or-bool-binary-operator)
;;; 
;;; 	; ----------------------------- UNARY OPERATORS ---------------------------- ;
;;; 
;;; 	(bool_unary_operator ("not") negation-bool-unary-operator)
;;; 
;;; 	; ------------------------------- EXPRESSIONS ------------------------------ ;
;;; 
;;; 	(boolean_expression (atomic_boolean) atomic-boolean-exp)
;;; 	(boolean_expression (bool_binary_operator "(" boolean_expression "," boolean_expression ")" ) app-binary-boolean-operator-exp)
;;; 	(boolean_expression (bool_unary_operator "(" boolean_expression ")" ) app-unary-boolean-operator-exp)
;;; 	(boolean_expression (comparator_prim "(" expression "," expression ")" ) app-comparator-boolean-exp)
;;; 
;;; 	(expression (boolean_expression) a-boolean_expression)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                             CONTROL STRUCTURES                             ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
;;; 	(expression ("if" expression "then" expression "else" expression) if-exp)
;;; 	(expression ("while" "(" boolean_expression ")" "{" expression "}") while-exp)
;;; 	(expression ("for" identifier "=" expression iterator expression "{" expression "}") for-exp)
;;; 
;;; 	; -------------------------------- ITERATORS ------------------------------- ;
;;; 
;;; 	(iterator ("to") to-iterator)
;;; 	(iterator ("downto") downto-iterator)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                 PRIMITIVES                                 ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	; ----------------------------------- INT ---------------------------------- ;
;;; 
;;; 	(int-primitive ("+i") int-add-prim)
;;; 	(int-primitive ("-i") int-substract-prim)
;;; 	(int-primitive ("*i") int-mult-prim)
;;; 	(int-primitive ("add1i") int-incr-prim)
;;; 	(int-primitive ("sub1i") int-decr-prim)
;;; 
;;; 	(expression (int-primitive "(" (separated-list expression ",") ")" ) app-int-prim-exp)
;;; 
;;; 	; ---------------------------------- FLOAT --------------------------------- ;
;;; 
;;; 	(float-primitive ("+f") float-add-prim)
;;; 	(float-primitive ("-f") float-substract-prim)
;;; 	(float-primitive ("*f") float-mult-prim)
;;; 	(float-primitive ("add1f") float-incr-prim)
;;; 	(float-primitive ("sub1f") float-decr-prim)
;;; 
;;; 	(expression (float-primitive "(" (separated-list expression ",") ")" ) app-float-prim-exp)
;;; 
;;; 	; ------------------------------ HEXADECIMALS ------------------------------ ;
;;; 
;;; 	(hex-primitive ("+h") hex-add-prim)
;;; 	(hex-primitive ("-h") hex-substract-prim)
;;; 	(hex-primitive ("*h") hex-mult-prim)
;;; 	(hex-primitive ("add1h") hex-incr-prim)
;;; 	(hex-primitive ("sub1h") hex-decr-prim)
;;; 
;;; 	(expression (hex-primitive "(" (separated-list expression ",") ")" ) app-hex-prim-exp)
;;; 
;;; 	; --------------------------------- STRING --------------------------------- ;
;;; 
;;; 	(unary_string_primitive ("my-length") length-string-prim)
;;; 
;;; 	(binary_string_primitive ("my-concat") concat-string-prim)
;;; 
;;; 	; ---------------------------------- LIST ---------------------------------- ;
;;; 
;;; 	(unary_list_primitive ("empty-list?") is-empty-list-prim)
;;; 	(unary_list_primitive ("empty-list") empty-list-prim)
;;; 	(unary_list_primitive ("my-list?") is-list-prim)
;;; 	(unary_list_primitive ("head-list") head-list-prim)
;;; 	(unary_list_primitive ("tail-list") tail-list-prim)
;;; 
;;; 	(list_primitive ("create-list" "(" (separated-list expression ",") ")" ) create-list-prim)
;;; 	(list_primitive ("append") append-list-prim)
;;; 	(list_primitive ("ref-list") ref-list-prim)
;;; 	(list_primitive ("set-list") set-list-prim)
;;; 
;;; 	(expression (unary_list_primitive "(" expression ")" ) unary_list_primitive-app-exp)
;;; 	(expression (list_primitive "(" (separated-list expression ",") ")" ) list_primitive-app-exp) ; Pending
;;; 
;;; 	; --------------------------------- TUPLES --------------------------------- ;
;;; 
;;; 	(unary_tuple_primitive ("empty-tuple?") is-empty-tuple-prim)
;;; 	(unary_tuple_primitive ("empty-ttuple") empty-tuple-prim)
;;; 	(unary_tuple_primitive ("tuple?") is-tuple-prim)
;;; 	(unary_tuple_primitive ("head-tuple") head-tuple-prim)
;;; 	(unary_tuple_primitive ("tail-tuple") head-tuple-prim)
;;; 
;;; 	(tuple_primitive ("create-tuple" "(" expression "," expression ")" ) create-tuple-prim)
;;; 	(tuple_primitive ("ref-tuple") ref-tuple-prim)
;;; 
;;; 	(expression (unary_tuple_primitive "(" expression ")" ) unary_tuple_primitive-app-exp)
;;; 	(expression (tuple_primitive "(" (separated-list expression ",") ")" ) tuple_primitive-app-exp) ; Pending
;;; 
;;; 	; --------------------------------- RECORDS -------------------------------- ;
;;; 
;;; 	(unary_record_primitive ("dictionary?") is-dictionary-prim)
;;; 
;;; 	(record_primitive ("create-dictionary" "(" a-dictionary-exp ")") create-dictionary-prim) ; Pending
;;; 	(record_primitive ("ref-dictionary") ref-dictionary-prim)
;;; 	(record_primitive ("set-dictionary") set-dictionary-prim)
;;; 
;;; 	(expression (unary_record_primitive "(" expression ")" ) unary_record_primitive-app-exp) ; Pending
;;; 	(expression (record_primitive "(" (separated-list expression ",") ")" ) record_primitive-app-exp) ; Pending
;;; ))
;;; 
;;; ; -------------------------------------------------------------------------- ;
;;; ;                                   SLLGEN                                   ;
;;; ; -------------------------------------------------------------------------- ;
;;; 
;;; (sllgen:make-define-datatypes lexica grammar)
;;; 
;;; 
;;; (define show-the-datatypes (
;;; 	sllgen:list-define-datatypes lexica grammar
;;; ))
;;; 
;;; 
;;; (define scan&parse (
;;; 	sllgen:make-string-parser lexica grammar
;;; ))
;;; 
;;; 
;;; (define just-scan (
;;; 	sllgen:make-string-scanner lexica grammar
;;; ))
;;; 
;;; 
;;; (provide (all-defined-out))
;;; 


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

