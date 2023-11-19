#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")


; -------------------------------------------------------------------------- ;
;                                ENVIRONMENTS                                ;
; -------------------------------------------------------------------------- ;

(define-datatype environment environment?
	(empty-environment)
	(extended-environment
		(symbols (list-of symbol?))
		(vec vector?)
		(env environment?))
)


(define extend-env (
	lambda (syms vals env) (
		extended-environment syms (list->vector vals) env
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
	)
))

; -------------------------------------------------------------------------- ;
;                                 REFERENCES                                 ;
; -------------------------------------------------------------------------- ;

(define-datatype reference reference?
	(a-ref (position integer?) (vector vector?))
)


(define deref (
	lambda(ref) (
		cases reference ref
			(a-ref (pos vec) (vector-ref vec pos))
	)
))


(define set-ref (
	lambda(ref val) (
		cases reference ref
			(a-ref (pos vec) (vector-set! vec pos val))
	)
))

; -------------------------------------------------------------------------- ;
;                                 PROCEDURES                                 ;
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
;                                  BOOLEANS                                  ;
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

(define eval-expression (
	lambda (exp env) (
		cases expression exp
			(lit-number (number) number)
			(hex-exp (a-hex-exp) (hex-to-decimal a-hex-exp))
			(var-exp (identifier) (deref (apply-env env identifier)))
			(lit-text (text) text)
			(a-boolean_expression (boolean-expression) (eval-boolean_expression boolean-expression env))

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
			(float-incr-prim () (+ (car args) 1))
			(float-decr-prim () (- (car args) 1))
	)
))

; ------------------------------ HEXADECIMALS ------------------------------ ;

(define hex-to-decimal (
	lambda (hex) (
		letrec (
			(make-conversion (
				lambda (numbers actual-exponent) (
					cond
					[(empty? numbers) 0]
					[else (+ (* (car numbers) (expt 16 actual-exponent))
						(make-conversion (cdr numbers) (- actual-exponent 1)))]
				)
			))
		)
		(cases a-hex-exp hex
			(a-hex-exp_ (numbers) (make-conversion numbers (- (my-length numbers) 1)))
			(else (eopl:error "~s is not a hexadecimal number" hex)))
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


(define interpreter (
	sllgen:make-rep-loop  "--> " (lambda (pgm) (eval-program  pgm)) (sllgen:make-stream-parser lexica grammar)
))

(define test-exp "
	int main() {
		!=(3,3)
	}
")

(scan&parse test-exp)

(eval-program (scan&parse test-exp))
