#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")

;;; #lang racket
;;; (require (except-in eopl #%module-begin))
;;; (provide (all-from-out eopl))
;;; (provide #%module-begin)
;;; 
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
;;; 	(number-f (digit (arbno digit) "." digit (arbno digit)) number) ; Positive float numbers
;;; 	(number-f ("-" digit (arbno digit) "." digit (arbno digit)) number) ; Negative float numbers
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
;;; 	(expression (number) lit-number-int)
;;; 	(expression (number-f) lit-number-float)
;;; 	; (expression ("x" number "(" (separated-list number ",") ")") bignum-exp)
;;; 
;;; 	(a-hex-exp ("x16" "(" (separated-list number ",") ")") a-hex-exp_)
;;; 	(expression (a-hex-exp) hex-exp)
;;; 
;;; 	(expression (identifier) var-exp)
;;; 
;;; 	(a-lit-text ("\"" text "\"") a-lit-text_)
;;; 	(expression (a-lit-text) lit-text)
;;; 
;;; 	(a-list-exp ("list" "(" (separated-list expression ",") ")") a-list-exp_)
;;; 	(expression (a-list-exp) list-exp)
;;; 
;;; 	(a-tuple-exp ("tuple" "(" (separated-list expression ",") ")") a-tuple-exp_)
;;; 	(expression (a-tuple-exp) tuple-exp)
;;; 
;;; 	(a-dictionary-exp ("{" text "=" expression (arbno ";" text "=" expression) "}") a-dictionary-exp_)
;;; 	(expression (a-dictionary-exp) dictionary-exp)
;;; 
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                 DEFINITION                                 ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 
;;; 	(expression ("var" (arbno identifier "=" expression) "in" expression) let-exp)
;;; 	(expression ("const" (arbno identifier "=" expression) "in" expression) const-exp)
;;; 	(expression ("rec"
;;; 		(arbno type-exp identifier "(" (separated-list type-exp identifier ",") ")" "=" expression) "in" expression)
;;; 		letrec-exp) 
;;; 	(expression ("proc" "(" (separated-list type-exp identifier ",") ")" expression) proc-exp) 
;;; 
;;; 
;;; 	(expression ("(" expression (arbno expression) ")") app-exp)
;;; 	(expression ("set" identifier "=" expression) set-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                   BOOLEAN                                  ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	; ------------------------------- COMPARATOR ------------------------------- ;
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
;;; 	; ----------------------------- BINARY OPERATOR ---------------------------- ;
;;; 
;;; 	(bool_binary_operator ("and") and-bool-binary-operator)
;;; 	(bool_binary_operator ("or") or-bool-binary-operator)
;;; 
;;; 	; ----------------------------- UNARY OPERATOR ----------------------------- ;
;;; 
;;; 	(bool_unary_operator ("not") negation-bool-unary-operator)
;;; 
;;; 	; ------------------------------- EXPRESSION ------------------------------- ;
;;; 
;;; 	(boolean_expression (atomic_boolean) atomic-boolean-exp)
;;; 	(boolean_expression (bool_binary_operator "(" boolean_expression "," boolean_expression ")" ) app-binary-boolean-operator-exp)
;;; 	(boolean_expression (bool_unary_operator "(" boolean_expression ")" ) app-unary-boolean-operator-exp)
;;; 	(boolean_expression (comparator_prim "(" expression "," expression ")" ) app-comparator-boolean-exp)
;;; 
;;; 	(expression (boolean_expression) a-boolean_expression)
;;; 
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                              CONTROL STRUCTURE                             ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(expression ("begin" expression (arbno ";" expression ) "end") begin-exp)
;;; 	(expression ("if" expression "then" expression "else" expression) if-exp)
;;; 	(expression ("while" "(" boolean_expression ")" "{" expression "}") while-exp)
;;; 	(expression ("for" "(" identifier "=" expression iterator expression ")" "{" expression "}") for-exp)
;;; 
;;; 	(expression ("print" "(" expression ")") print-exp)
;;; 
;;; 	; -------------------------------- ITERATOR -------------------------------- ;
;;; 
;;; 	(iterator ("to") to-iterator)
;;; 	(iterator ("downto") downto-iterator)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                  PRIMITIVE                                 ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	; ----------------------------------- INT ---------------------------------- ;
;;; 
;;; 	(int-primitive ("+i") int-add-prim)
;;; 	(int-primitive ("-i") int-substract-prim)
;;; 	(int-primitive ("*i") int-mult-prim)
;;; 	(int-primitive ("/i") int-div-prim)
;;; 	(int-primitive ("%i") int-module-prim)
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
;;; 	(float-primitive ("/f") float-div-prim)
;;; 	(float-primitive ("%f") float-module-prim)
;;; 	(float-primitive ("add1f") float-incr-prim)
;;; 	(float-primitive ("sub1f") float-decr-prim)
;;; 
;;; 	(expression (float-primitive "(" (separated-list expression ",") ")" ) app-float-prim-exp)
;;; 
;;; 	; ------------------------------- HEXADECIMAL ------------------------------ ;
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
;;; 	(unary_string_primitive ("my-string-length") length-string-prim)
;;; 	(expression (unary_string_primitive  "(" expression ")" ) app-unary-string-prim-exp)
;;; 
;;; 	(binary_string_primitive ("my-string-concat") concat-string-prim)
;;; 	(expression (binary_string_primitive "(" expression "," expression ")" ) app-binary-string-prim-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                    LIST                                    ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(unary_list_primitive ("empty-list?") is-empty-list-prim)
;;; 	(unary_list_primitive ("empty-list") empty-list-prim)
;;; 	(unary_list_primitive ("my-list?") is-list-prim)
;;; 	(unary_list_primitive ("list-head") list-head-prim)
;;; 	(unary_list_primitive ("list-tail") list-tail-prim)
;;; 
;;; 	(expression ("create-list" "(" expression "," expression ")" ) create-list-exp)
;;; 
;;; 	(list_primitive ("append") append-list-prim)
;;; 	(list_primitive ("ref-list") ref-list-prim)
;;; 	(list_primitive ("set-list") set-list-prim)
;;; 
;;; 	(expression (unary_list_primitive "(" expression ")" ) unary_list_primitive-app-exp)
;;; 	(expression (list_primitive identifier "(" (separated-list expression ",") ")" ) list_primitive-app-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                    TUPLE                                   ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(unary_tuple_primitive ("empty-tuple?") is-empty-tuple-prim)
;;; 	(unary_tuple_primitive ("empty-tuple") empty-tuple-prim)
;;; 	(unary_tuple_primitive ("tuple?") is-tuple-prim)
;;; 	(unary_tuple_primitive ("head-tuple") tuple-head-prim)
;;; 	(unary_tuple_primitive ("tail-tuple") tuple-tail-prim)
;;; 
;;; 	(expression  ("create-tuple" "(" expression "," expression ")" ) create-tuple-exp)
;;; 
;;; 	(tuple_primitive ("ref-tuple") ref-tuple-prim)
;;; 
;;; 	(expression (unary_tuple_primitive "(" expression ")" ) unary_tuple_primitive-app-exp)
;;; 	(expression (tuple_primitive identifier "(" expression ")" ) tuple_primitive-app-exp)
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                                 DICTIONARY                                 ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(expression ("create-dictionary" "(" a-dictionary-exp ")") create-dictionary-prim)
;;; 
;;; 	(unary_dictionary_primitive ("dictionary?") is-dictionary-prim)
;;; 
;;; 	(dictionary_primitive ("ref-dictionary") ref-dictionary-prim)
;;; 	(dictionary_primitive ("set-dictionary") set-dictionary-prim)
;;; 
;;; 	(expression (unary_dictionary_primitive "(" expression ")" ) unary_dictionary_primitive-app-exp)
;;; 	(expression (dictionary_primitive "(" identifier "," (separated-list expression ",") ")" ) dictionary_primitive-app-exp)
;;; 
;;; 
;;; 	; -------------------------------------------------------------------------- ;
;;; 	;                               TYPE EXPRESSION                              ;
;;; 	; -------------------------------------------------------------------------- ;
;;; 
;;; 	(type-exp ("int") int-type-exp)
;;; 	(type-exp ("float") float-type-exp)
;;; 	(type-exp ("hex") hex-type-exp)
;;; 	(type-exp ("string") string-type-exp)
;;;   (type-exp ("bool") bool-type-exp)
;;; 	
;;; 	(type-exp
;;; 		("(" (separated-list type-exp ",") "->" type-exp ")")
;;; 		proc-type-exp
;;; 	)
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


; -------------------------------------------------------------------------- ;
;                                 ENVIRONMENT                                ;
; -------------------------------------------------------------------------- ;


(define-datatype environment environment?
	(empty-environment)
	(extended-environment
		(symbols (list-of symbol?))
		(vec vector?)
		(env environment?))
	(extended-const-environment
		(symbols (list-of symbol?))
		(vec vector?)
		(env environment?))
)


(define extend-env (
	lambda (syms vals env) (
		extended-environment syms (list->vector vals) env
	)
))


(define extend-const-env (
	lambda (syms vals env) (
		extended-const-environment syms (list->vector vals) env
	)
))


(define extend-env-recursively (
	lambda (procedures-names procedures-parametes bodies old-env) (
		let* (
			(len (length procedures-names))
			(vec (make-vector len))
			(env (extended-environment procedures-names vec old-env))
		)
		(for-each (
			lambda (pos parameters body) (
				vector-set! vec pos (closure parameters body env)
			))
			(iota len) procedures-parametes bodies)
		env
	)
))


(define scheme-value? (lambda (anything) #t))


(define apply-env (
	lambda (env var) (
		cases environment env
			(empty-environment () (eopl:error "No binding for ~s" var))
			(extended-environment (symbols values old-env) (
					let (
						(index (index-of var symbols))
					)
					(if index
						(a-ref index values)
						(apply-env old-env var)
					)
				)
			)
			(extended-const-environment (symbols values old-env) (
					let (
						(index (index-of var symbols))
					)
					(if index
						(a-const index values)
						(apply-env old-env var)
					)
				)
			)
	)
))


; -------------------------------------------------------------------------- ;
;                              TYPES ENVIRONMENT                             ;
; -------------------------------------------------------------------------- ;

(define-datatype type-environment type-environment?
	(empty-tenv-record)
	(extended-tenv-record
	(syms (list-of symbol?))
	(vals (list-of type?))
	(tenv type-environment?)))

(define empty-tenv empty-tenv-record)
(define extend-tenv extended-tenv-record)

(define apply-tenv 
	(lambda (tenv sym)
		(cases type-environment tenv
			(empty-tenv-record ()
				(eopl:error 'apply-tenv "Unbound variable ~s" sym))
			(extended-tenv-record (syms vals env)
				(let ((pos (list-find-position sym syms)))
					(if (number? pos)
						(list-ref vals pos)
						(apply-tenv env sym)))))))

; -------------------------------------------------------------------------- ;
;                              DATATYPE OF TYPE                              ;
; -------------------------------------------------------------------------- ;

(define-datatype type type?
	(atomic-type
		(name symbol?))
	(proc-type
		(arg-types (list-of type?))
		(result-type type?))
	(list-type
		(element-type type?))
)

(define int-type
	(atomic-type 'int))

(define float-type
	(atomic-type 'float))	

(define hex-type
	(atomic-type 'hex))

(define string-type
	(atomic-type 'string))

(define bool-type
  (atomic-type 'bool))

(define tuple-type
	(atomic-type 'tuple))

(define dictionary-type
	(atomic-type 'dictionary))

(define expand-type-expression
	(lambda (texp)
		(cases type-exp texp
			(int-type-exp () int-type)
			(float-type-exp () float-type)
			(hex-type-exp () hex-type)
			(string-type-exp () string-type)
			(bool-type-exp () bool-type)
			(tuple-type-exp () tuple-type)
			(dictionary-type-exp () dictionary-type)
			(proc-type-exp (arg-texps result-texp)
				(proc-type
				(expand-type-expressions arg-texps)
				(expand-type-expression result-texp)))
	))
)

(define expand-type-expressions
	(lambda (texps)
		(map expand-type-expression texps)))



; -------------------------------------------------------------------------- ;
;                                  REFERENCE                                 ;
; -------------------------------------------------------------------------- ;

(define-datatype reference reference?
	(a-ref (position integer?) (vector vector?))
	(a-const (position integer?) (vector vector?))
)


(define deref (
	lambda (ref) (
		cases reference ref
			(a-ref (pos vec) (vector-ref vec pos))
			(a-const (pos vec) (vector-ref vec pos))
	)
))


(define set-ref (
	lambda(ref val) (
		cases reference ref
			(a-ref (pos vec) (vector-set! vec pos val))
			(a-const (pos vec) (eopl:error 'setref! "The value of a constant cannot be changed"))
	)
))

; -------------------------------------------------------------------------- ;
;                                  PROCEDURE                                 ;
; -------------------------------------------------------------------------- ;

(define-datatype procedure procedure? (
	closure
		(identifiers (list-of symbol?))
		(body expression?)
		(env environment?)

))


(define apply-procedure (
	lambda (proc arguments) (
		cases procedure proc
			(closure (identifiers body env)
				(eval-expression body (extend-env identifiers arguments env)))
	)
))

; -------------------------------------------------------------------------- ;
;                             PROGRAM EVALUATION                             ;
; -------------------------------------------------------------------------- ;

(define init-env (
	lambda () (
		empty-environment
	)
))


(define eval-program (
	lambda (pgm) (
		cases program pgm
			(a-program (body) (eval-expression body (init-env)))
	)
))


(define eval-expressions (
	lambda (expressions env) (
		map (lambda (expression) (eval-expression expression env)) expressions
	)
))

; -------------------------------------------------------------------------- ;
;                                   BOOLEAN                                  ;
; -------------------------------------------------------------------------- ;

(define eval-atomic_boolean (
	lambda (expression) (
		cases atomic_boolean expression
			(true-boolean () #t)
			(false-boolean () #f)
			(else (eopl:error "~s invalid atomic_boolean expression" expression))
	)
))


(define apply-binary-boolean-operator (
	lambda (rator rand1 rand2 env) (
		let (
			(evaluated-rand1 (eval-expression rand1 env))
			(evaluated-rand2 (eval-expression rand2 env))
		)
			(cases bool_binary_operator rator
				(and-bool-binary-operator () (and evaluated-rand1 evaluated-rand2))
				(or-bool-binary-operator () (or evaluated-rand1 evaluated-rand2))
				(else (eopl:error "~s invalid bool_binary_operator expression" rator))
			)
	)
))


(define apply-unary-boolean-operator (
	lambda (rator rand env) (
		let (
			(evaluated-rand (eval-expression rand env))
		)
		(cases bool_unary_operator rator
			(negation-bool-unary-operator () (not evaluated-rand))
			(else (eopl:error "~s invalid bool_unary_operator expression" rator))
		)
	)
))


(define apply-comparator-boolean (
	lambda (rator rand1 rand2 env) (
		let (
			(evaluated-rand1 (eval-expression rand1 env))
			(evaluated-rand2 (eval-expression rand2 env))
		)
			(cases comparator_prim rator
				(smaller-than-comparator-prim () (< evaluated-rand1 evaluated-rand2))
				(greater-than-comparator-prim () (> evaluated-rand1 evaluated-rand2))
				(less-equal-to-comparator-prim () (<= evaluated-rand1 evaluated-rand2))
				(greater-equal-to-comparator-prim () (>= evaluated-rand1 evaluated-rand2))
				(equal-to-comparator-prim () (eqv? evaluated-rand1 evaluated-rand2))
				(not-equal-to-comparator-prim () (not (eqv? evaluated-rand1 evaluated-rand2)))
				(else (eopl:error "~s invalid comparator_prim expression" rator))
			)
		)
	)
)


(define eval-boolean_expression (
	lambda (expression env) (
		cases boolean_expression expression
			(atomic-boolean-exp (atomic-boolean) (eval-atomic_boolean atomic-boolean))
			(app-binary-boolean-operator-exp (rator rand1 rand2) (apply-binary-boolean-operator rator rand1 rand2 env))
			(app-unary-boolean-operator-exp (rator rand) (apply-unary-boolean-operator rator rand env))
			(app-comparator-boolean-exp (rator rand1 rand2) (apply-comparator-boolean rator rand1 rand2 env))
			(else (eopl:error "~s invalid boolean_expression expression" expression))
	)
))

; -------------------------------------------------------------------------- ;
;                                   STRING                                   ;
; -------------------------------------------------------------------------- ;

(define eval-text-expression (
	lambda (expression) (
		cases a-lit-text expression
			(a-lit-text_ (text) text)
	)
))


(define apply-unary-string-primitive (
	lambda (rator rand) (
		cases unary_string_primitive rator
			(length-string-prim () (string-length rand))
			(else (eopl:error "~s invalid unary_string_primitive expression" rator))
	)
))


(define apply-binary-string-primitive (
	lambda (rator rand1 rand2) (
		cases binary_string_primitive rator
			(concat-string-prim () (string-append rand1 rand2))
			(else (eopl:error "~s invalid binary_string_primitive expression" rator))
	)
))

; -------------------------------------------------------------------------- ;
;                             CONTROL STRUCTURES                             ;
; -------------------------------------------------------------------------- ;

(define apply-iterator (
	lambda (expression) (
		cases iterator expression
			(to-iterator () 1)
			(downto-iterator () -1)
			(else (eopl:error "~s invalid iterator expression" expression))
	)
))

; -------------------------------------------------------------------------- ;
;                                    LIST                                    ;
; -------------------------------------------------------------------------- ;

(define-datatype my-list my-list?
	(empty-list)
	(extended-list (values vector?))
)


(define eval-list_exp (
	lambda (list env) (
		cases a-list-exp list
			(a-list-exp_ (exps) (
				let (
					(values (eval-expressions exps env))
				)
				(if (null? values)
					(empty-list)
					(extended-list (list->vector values))))
			)
	)
))


(define apply-unary-list-primitive (
	lambda (rator rand) (
		cases unary_list_primitive rator
			(is-empty-list-prim () (
				cases my-list rand
					(empty-list () #t)
					(extended-list (values) #f)
			))
			(empty-list-prim () (empty-list))
			(is-list-prim () (my-list? rand))
			(list-head-prim () (
				cases my-list rand
					(empty-list () (eopl:error 'list-head-prim "Cannot call apply head primitive on an empty list" rator))
					(extended-list (values) (vector-ref values 0))
			))
			(list-tail-prim () (
				cases my-list rand
					(empty-list () (eopl:error 'tail-list-prim "Cannot call apply tail primitive on an empty list" rator))
					(extended-list (values) (extended-list (vector-copy values 1)))
			))
			(else (eopl:error 'apply-unary-list-primitive "~s invalid unary_list_primitive expression" rator))
	)
))


(define eval-create-list-exp (
	lambda (value list) (
		cases my-list list
			(empty-list () (extended-list (vector value)))
			(extended-list (values) (
				extended-list (vector-append (vector value) values)
			))
			(else (eopl:error 'eval-create-list-exp "~s invalid my-list expression" list))
	)
))


(define get-list-elements (
	lambda (list) (
		cases my-list list
			(empty-list () (vector '()))
			(extended-list (values) values)
	)
))


(define apply-list-primitive (
	lambda (rator list-ref rands) (
		let (
			(list (deref list-ref))
			(first-argument (car rands))
		)
		(cases list_primitive rator
			(append-list-prim () (
				let (
					(new-list (
						cases my-list list
							(empty-list () (get-list-elements list))
							(extended-list (values) (
								extended-list (vector-append values (get-list-elements first-argument))
							))
					))
				)
				(set-ref list-ref new-list)
			))
			(ref-list-prim () (
				cases my-list list
					(empty-list () (eopl:error 'ref-list-prim "Cannot call apply ref list primitive on an empty list"))
					(extended-list (values) (
						vector-ref values first-argument
					))
			))
			(set-list-prim () (
				cases my-list list
					(empty-list () (eopl:error 'set-list-prim "Cannot call apply set list primitive on an empty list"))
					(extended-list (values) (
						vector-set! values first-argument (cadr rands)
					))
			))
			(else (eopl:error 'apply-list-primitive "~s invalid list_primitive expression" rator))
		)
	)
))

; -------------------------------------------------------------------------- ;
;                                    TUPLE                                   ;
; -------------------------------------------------------------------------- ;

(define-datatype my-tuple my-tuple?
	(empty-tuple)
	(extended-tuple (values vector?))
)


(define eval-tuple-exp (
	lambda (tuple env) (
		cases a-tuple-exp tuple
			(a-tuple-exp_ (exps) (
				let (
					(values (eval-expressions exps env))
				)
				(if (null? values)
					(empty-tuple)
					(extended-tuple (list->vector values))))
			)
	)
))


(define apply-unary-tuple-primitive (
	lambda (rator rand) (
		cases unary_tuple_primitive rator
			(is-empty-tuple-prim () (
				cases my-tuple rand
					(empty-tuple () #t)
					(extended-tuple (values) #f)
			))
			(empty-tuple-prim () (empty-tuple))
			(is-tuple-prim () (my-tuple? rand))
			(tuple-head-prim () (
				cases my-tuple rand
					(empty-tuple () (eopl:error 'tuple-head-prim "Cannot call apply head primitive on an empty tuple" rator))
					(extended-tuple (values) (vector-ref values 0))
			))
			(tuple-tail-prim () (
				cases my-tuple rand
					(empty-tuple () (eopl:error 'tuple-tail-prim "Cannot call apply tail primitive on an empty tuple" rator))
					(extended-tuple (values) (extended-tuple (vector-copy values 1)))
			))
			(else (eopl:error 'apply-unary-list-primitive "~s invalid unary_list_primitive expression" rator))
	)
))


(define eval-create-tuple-exp (
	lambda (value tuple) (
		cases my-tuple tuple
			(empty-tuple () (extended-tuple (vector value)))
			(extended-tuple (values) (
				extended-tuple (vector-append (vector value) values)
			))
			(else (eopl:error 'eval-create-tuple-exp "~s invalid my-tuple expression" tuple))
	)
))


(define apply-tuple-primitive (
	lambda (rator tuple-ref rand) (
		cases tuple_primitive rator
			(ref-tuple-prim () (
				cases my-tuple (deref tuple-ref)
					(empty-tuple () (eopl:error 'ref-list-prim "Cannot call apply ref list primitive on an empty list"))
					(extended-tuple (values) (
						vector-ref values rand
					))
			))
			(else (eopl:error 'apply-tuple-primitive "~s invalid tuple_primitive expression" rator))
	)
))

; -------------------------------------------------------------------------- ;
;                                 DICTIONARY                                 ;
; -------------------------------------------------------------------------- ;

(define-datatype my-dictionary my-dictionary?
	(extended-dictionary (keys vector?) (values vector?))
)


; This function checks if a list has no repeated elements
(define (no-repeats? keys)
	(if (null? keys)
			#t
			(if (not-repeated? (car keys) (cdr keys))
					(no-repeats? (cdr keys))
					#f)))


; This auxiliary function checks if an element is not repeated in a list
(define (not-repeated? element list)
	(if (null? list)
			#t
			(if (equal? element (car list))
					#f
					(not-repeated? element (cdr list)))))


(define eval-dictionary-exp
	(lambda (expr env)
		(cases a-dictionary-exp expr
			(a-dictionary-exp_ (key1 value1 restKeys restValues)
				(let
						(
							(evaluatedValues (eval-expressions restValues env))
							(evaluatedValue1 (eval-expressions (list value1) env))
						)
					(if (no-repeats? (append (list key1) restKeys))
							(extended-dictionary
								(list->vector (append (list key1) restKeys))
								(list->vector (append evaluatedValue1 evaluatedValues))
							)
							(eopl:error 'eval-dictionary-exp "The keys of a dictionary must be different")))))))


(define apply-unary-record-primitive
	(lambda (primitive exp)
	(cases unary_dictionary_primitive primitive
			(is-dictionary-prim () (my-dictionary? exp))
		)
	)
)

(define apply-record-primitive
	(lambda (recordPrimitive registerRef arguments)
		(let
			(
				(registerValue (deref registerRef))
				(firstArg (car arguments))
			)
			(cases dictionary_primitive recordPrimitive
				(
					ref-dictionary-prim ()
						(cases my-dictionary registerValue
							(extended-dictionary (ids vals)
								(vector-ref vals (find-index ids firstArg 0))
								)
						)
				)
				(
					set-dictionary-prim ()
						(cases my-dictionary registerValue
							(extended-dictionary (ids vals)
								(vector-set! vals (find-index ids firstArg 0) (cadr arguments))
							)
						)
				)
			)
		)
	)
)

(define find-index
	(lambda (values id index)
		(if (equal? (vector-ref values index) id) index (find-index values id (+ index 1)))))

; -------------------------------------------------------------------------- ;

(define eval-expression (
	lambda (exp env) (
		cases expression exp
			(lit-number-int (number) number)
			(lit-number-float (number) number)
			(hex-exp (a-hex-exp) (hex-to-decimal a-hex-exp))
			(var-exp (identifier) (deref (apply-env env identifier)))
			(lit-text (a-lit-text) (eval-text-expression a-lit-text))
			(list-exp (a-list-exp) (eval-list_exp a-list-exp env))
			(tuple-exp (a-tuple-exp) (eval-tuple-exp a-tuple-exp env))
			(a-boolean_expression (boolean-expression) (eval-boolean_expression boolean-expression env))

			; -------------------------------------------------------------------------- ;
			;                                 DEFINITIONS                                ;
			; -------------------------------------------------------------------------- ;

			(let-exp (identifiers expressions body) (
				let (
					(args (eval-expressions expressions env))
				)
				(eval-expression body (extend-env identifiers args env))
			))

			(const-exp (identifiers expressions body) (
				let (
					(args (eval-expressions expressions env))
				)
				(eval-expression body (extend-const-env identifiers args env))
			))

			(letrec-exp (result-texps procedures-names arg-texpss procedures-parameters procedures-bodies body) (
				eval-expression body (extend-env-recursively
					procedures-names
					procedures-parameters
					procedures-bodies
					env
				)
			))
			
			(proc-exp (args-texps identifiers body) (closure identifiers body env))

			(app-exp (rator rands) (
				let (
					(proc (eval-expression rator env))
					(args (eval-expressions rands env))
				)
				(if (procedure? proc)
					(apply-procedure proc args)
					(eopl:error 'app-exp "exp ~s is not a procedure" proc)
				)
			))

			(set-exp (id rhs-exp) (
				begin (
					set-ref (apply-env env id) (eval-expression rhs-exp env)
				)
				1
			))

			; -------------------------------------------------------------------------- ;
			;                             CONTROL STRUCTURES                             ;
			; -------------------------------------------------------------------------- ;

			(begin-exp (exp exps) (
				letrec (
					(loop (
						lambda (accum exps) (
							if (null? exps)
								accum
								(loop (eval-expression (car exps) env) (cdr exps))
						)
					))
				)
				(loop (eval-expression exp env) exps)
			))

			(if-exp (test-exp true-exp false-exp)
				(if (eval-expression test-exp env)
					(eval-expression true-exp env)
					(eval-expression false-exp env)
				)
			)

			(while-exp (test-exp body) (
				letrec (
					(loop (
						lambda (test-exp body last-evaluation) (
							if (eval-boolean_expression test-exp env)
								(loop test-exp body (eval-expression body env))
								1
						)
					))
				)
				(loop test-exp body empty)
			))

			(for-exp (identifier initial-value iterator iterator-lim body) (
				let (
					(initial-value (eval-expression initial-value env))
					(iterator-value (apply-iterator iterator))
					(iterator-lim-value (eval-expression iterator-lim env))
				)
				(
					letrec (
						(loop (
							lambda (iteration last-evaluation) (
								let (
									(new-environment (extend-env (list identifier) (list iteration) env))
								)
								(if (eqv? iteration iterator-lim-value)
									(eval-expression body new-environment)
									(loop (+ iteration iterator-value) (eval-expression body new-environment))
								)
							)
						))

					)
					(loop initial-value empty)
				)
			))

			(print-exp (exp) (
				begin
					(display (eval-expression exp env))
					(display "\n")
			))

			; -------------------------------------------------------------------------- ;
			;                                 PRIMITIVES                                 ;
			; -------------------------------------------------------------------------- ;

			; ----------------------------------- INT ---------------------------------- ;

			(app-int-prim-exp (prim rands) (
					let (
						(args (eval-expressions rands env))
					)
					(apply-int-primitive prim args)
				)
			)

			; ---------------------------------- FLOAT --------------------------------- ;

			(app-float-prim-exp (prim rands) (
					let (
						(args (eval-expressions rands env))
					)
					(apply-float-primitive prim args)
				)
			)

			; ------------------------------ HEXADECIMALS ------------------------------ ;

			(app-hex-prim-exp (prim rands) (
					let (
						(args (eval-expressions rands env))
					)
					(apply-hex-primitive prim args)
				)
			)

			; --------------------------------- STRING --------------------------------- ;

			(app-unary-string-prim-exp (prim rand) (
					let (
						(evaluated-rand (eval-expression rand env))
					)
					(apply-unary-string-primitive prim evaluated-rand)
				)
			)

			(app-binary-string-prim-exp (prim rand1 rand2) (
					let (
						(evaluated-rand1 (eval-expression rand1 env))
						(evaluated-rand2 (eval-expression rand2 env))
					)
					(apply-binary-string-primitive prim evaluated-rand1 evaluated-rand2)
				)
			)

			; -------------------------------------------------------------------------- ;
			;                                    LIST                                    ;
			; -------------------------------------------------------------------------- ;

			(unary_list_primitive-app-exp (rator rand) (
				apply-unary-list-primitive rator (eval-expression rand env)
			))

			(create-list-exp (exp list-exp) (
				eval-create-list-exp (eval-expression exp env) (eval-expression list-exp env)
			))

			(list_primitive-app-exp (rator identifier rand) (
				apply-list-primitive rator (apply-env env identifier)  (eval-expressions rand env)
			))

			; -------------------------------------------------------------------------- ;
			;                                    TUPLE                                   ;
			; -------------------------------------------------------------------------- ;

			(unary_tuple_primitive-app-exp (rator rand) (
				apply-unary-tuple-primitive rator (eval-expression rand env)
			))

			(create-tuple-exp (exp tuple-exp) (
				eval-create-tuple-exp (eval-expression exp env) (eval-expression tuple-exp env)
			))

			(tuple_primitive-app-exp (rator identifier rand) (
				apply-tuple-primitive rator (apply-env env identifier) (eval-expression rand env)
			))

			; -------------------------------------------------------------------------- ;
			;                                DICTIONARIES                                ;
			; -------------------------------------------------------------------------- ;

			(dictionary-exp (a-dictionary-exp)
				(eval-dictionary-exp a-dictionary-exp env)
			)

			(unary_dictionary_primitive-app-exp (primitive exp)
				(apply-unary-record-primitive primitive (eval-expression exp env))
			)

			(dictionary_primitive-app-exp (primitive recordId expressions)
					(apply-record-primitive
						primitive
						(apply-env env recordId)
						(eval-expressions expressions env)
					)
			)

			(else (eopl:error "~s invalid expression" exp))
	)
))

; -------------------------------------------------------------------------- ;
;                                 PRIMITIVES                                 ;
; -------------------------------------------------------------------------- ;

; ----------------------------------- INT ---------------------------------- ;

(define apply-int-primitive (
	lambda (prim args) (
		cases int-primitive prim
			(int-add-prim () (+ (car args) (cadr args)))
			(int-substract-prim () (- (car args) (cadr args)))
			(int-mult-prim () (* (car args) (cadr args)))
			(int-div-prim () (/ (car args) (cadr args)))
			(int-module-prim () (remainder (car args) (cadr args)))
			(int-incr-prim () (+ (car args) 1))
			(int-decr-prim () (- (car args) 1))
	)
))

; ---------------------------------- FLOAT --------------------------------- ;

(define apply-float-primitive (
	lambda (prim args) (
		cases float-primitive prim
			(float-add-prim () (+ (car args) (cadr args)))
			(float-substract-prim () (- (car args) (cadr args)))
			(float-mult-prim () (* (car args) (cadr args)))
			(float-div-prim () (/ (car args) (cadr args)))
			(float-module-prim () (remainder (car args) (cadr args)))
			(float-incr-prim () (+ (car args) 1))
			(float-decr-prim () (- (car args) 1))
	)
))

; ------------------------------ HEXADECIMALS ------------------------------ ;

(define hex-to-decimal (
	lambda (hex) (
		cases a-hex-exp hex
			(a-hex-exp_ (numbers) (
				if (is-valid-number numbers 16)
					(number-to-decimal numbers 16)
					(eopl:error "~s is not a hexadecimal number" hex)
			))
			(else (eopl:error "~s is not a hexadecimal number" hex))
	)
))


(define apply-hex-primitive (
	lambda (prim args) (
		cases hex-primitive prim
			(hex-add-prim () (+ (car args) (cadr args)))
			(hex-substract-prim () (- (car args) (cadr args)))
			(hex-mult-prim () (* (car args) (cadr args)))
			(hex-incr-prim () (+ (car args) 1))
			(hex-decr-prim () (- (car args) 1))
	)
))

; -------------------------------------------------------------------------- ;
;                       AUXILIARY FUNCTION TYPE CHECKER                      ;
; -------------------------------------------------------------------------- ;
(define type-of-boolean_expression
	(lambda (expression tenv) (
		cases boolean_expression expression
			(atomic-boolean-exp (atomic-boolean) (type-of-atomic-boolean atomic-boolean))
		
			(app-binary-boolean-operator-exp (rator rand1 rand2) 
				(type-of-binary-boolean-operator rator rand1 rand2 tenv)
			)
		
			(app-unary-boolean-operator-exp (rator rand) 
				(type-of-uninary-boolean-operator rator rand tenv)
			)
		
			(app-comparator-boolean-exp (rator rand1 rand2) 
				(type-of-comparator-boolean rator rand1 rand2 tenv)
			)
		
			(else (eopl:error "~s invalid boolean_expression expression" expression))
	))
)

(define type-of-uninary-boolean-operator
	(lambda (rator rand tenv) (
		let (
			(type-of-rand (type-of-expression rand tenv))
		)
		(cases bool_unary_operator rator
			(negation-bool-unary-operator () (type-of-negation-boolean-operator type-of-rand))
			(else (eopl:error "~s invalid bool_unary_operator expression" rator))
		)
	))
)

(define type-of-comparator-boolean 
	(lambda (rator rand1 rand2 tenv) (
		let (
			(type-of-rand1 (type-of-expression rand1 tenv))
			(type-of-rand2 (type-of-expression rand2 tenv))
		)
		(cases comparator_prim rator
			(smaller-than-comparator-prim () (type-of-smaller-than-comparator-boolean type-of-rand1 type-of-rand2))
			(greater-than-comparator-prim () (type-of-greater-than-comparator-boolean type-of-rand1 type-of-rand2))
			(less-equal-to-comparator-prim () (type-of-less-equal-to-comparator-boolean type-of-rand1 type-of-rand2))
			(greater-equal-to-comparator-prim () (type-of-greater-equal-to-comparator-boolean type-of-rand1 type-of-rand2))
			(equal-to-comparator-prim () (type-of-equal-to-comparator-boolean type-of-rand1 type-of-rand2))
			(not-equal-to-comparator-prim () (type-of-not-equal-to-comparator-boolean type-of-rand1 type-of-rand2))
			(else (eopl:error "~s invalid comparator_prim expression" rator))
		)
	))
)

(define type-of-smaller-than-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid smaller-than-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-greater-than-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid greater-than-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-less-equal-to-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid less-equal-to-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-greater-equal-to-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid greater-equal-to-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-equal-to-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid equal-to-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-not-equal-to-comparator-boolean
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid not-equal-to-comparator-boolean expression" type-of-rand1)
	))
)

(define type-of-negation-boolean-operator
	(lambda (type-of-rand) (
		if (equal? type-of-rand bool-type)
			bool-type
			(eopl:error "~s invalid negation-boolean-operator expression" type-of-rand)
	))
)

(define type-of-binary-boolean-operator
	(lambda (rator rand1 rand2 tenv) (
		let (
			(type-of-rand1 (type-of-expression rand1 tenv))
			(type-of-rand2 (type-of-expression rand2 tenv))
		)
		(cases bool_binary_operator rator
			(and-bool-binary-operator () (type-of-and-boolean-operator type-of-rand1 type-of-rand2))
			(or-bool-binary-operator () (type-of-or-boolean-operator type-of-rand1 type-of-rand2))
			(else (eopl:error "~s invalid bool_binary_operator expression" rator))
		)
	))
)

(define type-of-and-boolean-operator
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid and-boolean-operator expression" type-of-rand1)
	))
)

(define type-of-or-boolean-operator
	(lambda (type-of-rand1 type-of-rand2) (
		if (and (equal? type-of-rand1 bool-type) (equal? type-of-rand2 bool-type))
			bool-type
			(eopl:error "~s invalid or-boolean-operator expression" type-of-rand1)
	))
)

(define type-of-atomic-boolean (
	lambda (expression) (
		cases atomic_boolean expression
			(true-boolean () bool-type)
			(false-boolean () bool-type)
			(else (eopl:error "~s invalid atomic_boolean expression" expression))
	)
))

;;; (define type-of-binary-boolean-operator (
;;; 	lambda (rator rand1 rand2 tenv) (
;;; 		let (
;;; 			(type-of-rand1 (type-of-boolean_expression rand1 tenv))
;;; 			(type-of-rand2 (type-of-boolean_expression rand2 tenv))
;;; 		)
;;; 		(cases bool_binary_operator rator
;;; 			(and-bool-binary-operator () (type-of-and-boolean-operator type-of-rand1 type-of-rand2))
;;; 			(or-bool-binary-operator () (type-of-or-boolean-operator type-of-rand1 type-of-rand2))
;;; 			(else (eopl:error "~s invalid bool_binary_operator expression" rator))
;;; 		)
;;; 	))
;;; )


(define check-equal-type!
	(lambda (t1 t2 exp)
		(if (not (equal? t1 t2))
				(eopl:error 'check-equal-type!
					"Types didn’t match: ~s != ~s in~%~s"
					(type-to-external-form t1)
					(type-to-external-form t2)
					exp)
				#t)))

(define type-to-external-form
	(lambda (ty)
		(cases type ty
			(atomic-type (name) name)
			(proc-type (arg-types result-type)
				(append
				(arg-types-to-external-form arg-types)
				'(->)
				(list (type-to-external-form result-type))))
			(list-type (element-type)
				(list (type-to-external-form element-type) '...
					'(list)))
	)))

(define arg-types-to-external-form
	(lambda (types)
		(if (null? types)
			'()
			(if (null? (cdr types))
				(list (type-to-external-form (car types)))
				(cons
					(type-to-external-form (car types))
					(cons '*
						(arg-types-to-external-form (cdr types))))))))

(define type-of-proc-exp
	(lambda (texps ids body tenv)
		(let ((arg-types (expand-type-expressions texps)))
			(let ((result-type
						(type-of-expression body
																(extend-tenv ids arg-types tenv))))
				(proc-type arg-types result-type)))))

(define type-of-application
	(lambda (rator-type rand-types rator rands exp)
		(cases type rator-type
		(proc-type (arg-types result-type)
			(if (= (length arg-types) (length rand-types))
					(begin
						(for-each
							check-equal-type!
							rand-types arg-types rands)
						result-type)
					(eopl:error 'type-of-expression
											(string-append
												"Wrong number of arguments in expression ~s:"
												"~%expected ~s~%got ~s")
											exp
											(map type-to-external-form arg-types)
											(map type-to-external-form rand-types))))
		(else
		(eopl:error 'type-of-expression
			"Rator not a proc type:~%~s~%had rator type ~s"
			rator (type-to-external-form rator-type))))))

(define types-of-expressions
	(lambda (rands tenv)
		(map (lambda (exp) (type-of-expression exp tenv)) rands)))

(define type-of-let-exp
	(lambda (ids rands body tenv)
		(let ((tenv-for-body
						(extend-tenv
						ids
						(types-of-expressions rands tenv)
						tenv)))
			(type-of-expression body tenv-for-body))))

(define type-of-app-int-primitive-verify
	(lambda (prim n)
			(if (>= n 2)
				(proc-type (make-list n int-type) int-type)
				(eopl:error 'type-of-app-int-primitive "~s invalid int-primitive expression" prim)
			)
	)
)

(define type-of-app-int-primitive
	(lambda (prim n)
				(cases int-primitive prim
					(int-add-prim () (
						type-of-app-int-primitive-verify prim n
					))
					(int-substract-prim () (
						type-of-app-int-primitive-verify prim n
					))
					(int-mult-prim () (
						type-of-app-int-primitive-verify prim n
					))
					(int-div-prim () (proc-type (list int-type int-type) int-type))
					(int-module-prim () (proc-type (list int-type int-type) int-type))
					(int-incr-prim () (proc-type (list int-type) int-type))
					(int-decr-prim () (proc-type (list int-type) int-type))
					(else (eopl:error 'type-of-app-int-primitive "~s invalid int-primitive expression" prim)))
	)
)

(define type-of-letrec-exp
	(lambda (result-texps proc-names texpss idss bodies letrec-body tenv)
		(let ((arg-typess (map (lambda (texps)
						(expand-type-expressions texps))
						texpss))
						(result-types (expand-type-expressions result-texps)))
					(let ((the-proc-types
						(map proc-type arg-typess result-types)))
							(let 
								((tenv-for-body (extend-tenv proc-names the-proc-types tenv)))
								(for-each
						(lambda (ids arg-types body result-type)
							(check-equal-type!
							(type-of-expression
								body
								(extend-tenv ids arg-types tenv-for-body))
							result-type
							body))
						idss arg-typess bodies result-types)
					(type-of-expression letrec-body tenv-for-body))))))

(define (extract-list-expressions list-exp)
  (cases a-list-exp list-exp
    (a-list-exp_ (expressions) expressions)))

(define (type-of-list-expressions expressions tenv)
  (let* ((element-types (types-of-expressions expressions tenv))
         (first-type (car element-types)))
    (for-each (lambda (type) (check-equal-type! type first-type exp)) (cdr element-types))
    (list-type first-type)))

(define (extract-tuple-expressions tuple-exp)
	(cases a-tuple-exp tuple-exp
		(a-tuple-exp_ (expressions) tuple-type)))

(define (extract-dictionary-expressions dictionary-exp)
	(cases a-dictionary-exp dictionary-exp
		(a-dictionary-exp_ (key1 value1 restKeys restValues) dictionary-type)))

(define type-of-set-exp
	(lambda (id new-value tenv)
		(let ((old-type (apply-tenv tenv id))
					(new-type (type-of-expression new-value tenv)))
			(if (equal? old-type new-type)
					old-type
					(error "Type mismatch: trying to set variable to a different type" id old-type new-type)))))

(define type-of-begin-exp
	(lambda (exp exps tenv)
		(let ((exp-types (types-of-expressions (cons exp exps) tenv)))
			;;si esta vacio damos error, si no obtenemos el ultimo de la lista y ese es el tipo
			(if (null? exp-types)
					(error "Empty begin expression")
					(last exp-types))
		)))

(define type-of-while-exp
	(lambda (test-exp body tenv)
		(let ((test-type (type-of-expression test-exp tenv))
					(body-type (type-of-expression body tenv)))
			(check-equal-type! test-type bool-type test-exp)
			(check-equal-type! body-type int-type body)
			body-type)))

; -------------------------------------------------------------------------- ;
;                                TYPE CHECKER                                ;
; -------------------------------------------------------------------------- ;

(define type-of-program
	(lambda (pgm)
		(cases program pgm
			(a-program (exp) (type-of-expression exp (empty-tenv))))))

(define type-of-expression
	(lambda (exp tenv)
		(cases expression exp
			(lit-number-int (number)
							int-type)
			(lit-number-float (number-f)
							float-type)
			(hex-exp (a-hex-exp)
							hex-type)
			(lit-text (a-lit-text)
							string-type)
			(list-exp (a-list-exp)
				(type-of-list-expressions (extract-list-expressions a-list-exp) tenv))
			(tuple-exp (a-tuple-exp)
							(extract-tuple-expressions a-tuple-exp))
			(dictionary-exp (a-dictionary-exp)
							(extract-dictionary-expressions a-dictionary-exp))
			(a-boolean_expression (expression)
				(type-of-boolean_expression expression tenv))
			(var-exp (id)
							(apply-tenv tenv id))
			(if-exp (test-exp true-boolean false-boolean)
							(let ((test-type (type-of-expression test-exp tenv))
										(false-type (type-of-expression false-boolean tenv))
										(true-type (type-of-expression true-boolean tenv)))
								(check-equal-type! test-type bool-type test-exp)
								(check-equal-type! true-type false-type exp)
								true-type)) 
			(proc-exp (texps ids body)
								(type-of-proc-exp texps ids body tenv))
			(app-int-prim-exp (prim rands)
				(let ((n (length rands)))
					(type-of-application
						(type-of-app-int-primitive prim n)
						(types-of-expressions rands tenv)
						prim rands exp))
			)
			(app-exp (rator rands)
							(type-of-application
								(type-of-expression rator tenv)
								(types-of-expressions rands tenv)
								rator rands exp))
			(let-exp (ids rands body)
							(type-of-let-exp ids rands body tenv))
			(const-exp (ids rands body)
							(type-of-let-exp ids rands body tenv))
			(letrec-exp (result-texps proc-names texpss idss bodies letrec-body)
									(type-of-letrec-exp result-texps proc-names texpss idss bodies
																			letrec-body tenv))
			(begin-exp (exp exps)
				(type-of-begin-exp exp exps tenv)
			)
			(set-exp (id new-value)
			(type-of-set-exp id new-value tenv))
			(while-exp (test-exp body)
				(type-of-while-exp test-exp body tenv))	
			(else (eopl:error "~s invalid expression" exp))
)))

; -------------------------------------------------------------------------- ;


(define interpreter (
	sllgen:make-rep-loop "--> " (lambda (pgm) (eval-program pgm)) (sllgen:make-stream-parser lexica grammar)
))

(define interpreter-types (
	sllgen:make-rep-loop "--> " (lambda (pgm) (interpret-program pgm)) (sllgen:make-stream-parser lexica grammar)
))

(define interpret-program
	(lambda (program)
		(if (type? (type-of-program program)) (eval-program program) 'error)))


(define test-exp "
	int main() {
				var
					#f = 2
        in
					begin
						set #f = 3;
						#f
					end
	}
")


; (scan&parse test-exp)
(eval-program (scan&parse test-exp))

(type-of-program
	(scan&parse "
		int main() {
			while (2) {
				var #f = 2
				in
				#f
				}
		}
	")	
)

	;;; (expression ("begin" expression (arbno ";" expression ) "end") begin-exp)

	;;; (expression ("proc" "(" (separated-list type-exp identifier ",") ")" expression) proc-exp) 
	;;; (expression (int-primitive "(" (separated-list expression ",") ")" ) app-int-prim-exp)
	;;; (a-list-exp ("list" "(" (separated-list expression ",") ")") a-list-exp_)
