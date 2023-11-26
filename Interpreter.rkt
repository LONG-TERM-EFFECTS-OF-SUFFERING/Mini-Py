#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")


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
			(evaluated-rand1 (eval-boolean_expression rand1 env))
			(evaluated-rand2 (eval-boolean_expression rand2 env))
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
			(evaluated-rand (eval-boolean_expression rand env))
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
			(lit-number (number) number)
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

			(letrec-exp (procedures-names procedures-parameters procedures-bodies body) (
				eval-expression body (extend-env-recursively
					procedures-names
					procedures-parameters
					procedures-bodies
					env
				)
			))

			(proc-exp (identifiers body) (closure identifiers body env))

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
				(if (eval-boolean_expression test-exp env)
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

(define interpreter (
	sllgen:make-rep-loop "--> " (lambda (pgm) (eval-program pgm)) (sllgen:make-stream-parser lexica grammar)
))


(define test-exp "
	int main() {
		var
			#x = 10
			#y = 1
		in
			begin
				/*
				while (> (#x, 0)) {
					begin
						set #y = add1i(#y);
						set #x = sub1i(#x);
						print(#x)
					end
				};
				*/
				for (#i = 1 to 5) {
					begin
						set #y = *i (#y, #i);
						print(#i)
					end
				};
				#y
			end
	}
")


; (scan&parse test-exp)
(eval-program (scan&parse test-exp))
