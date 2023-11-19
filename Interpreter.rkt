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

(define eval-expression (
	lambda (exp env) (
		cases expression exp
			(lit-number (number) number)
			(hex-exp (a-hex-exp) (hex-to-decimal a-hex-exp))

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

			(else (error "Invalid expression"))
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


(eval-program (scan&parse "
int main() {
	+h(x16 (4, 5, 6), x16 (4, 5, 6))
}
"))
