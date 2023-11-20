#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)


; -------------------------------------------------------------------------- ;
;                                  AUXILIAR                                  ;
; -------------------------------------------------------------------------- ;

(define nth-element (
	lambda (list n) (
		cond
			[(zero? n) (car list)]
			[else (nth-element (cdr list) (- n 1))]
	)
))


(define index-of (
	lambda (element list) (
		letrec (
			(get-index (
				lambda (element list index) (
					cond
						[(empty? list) #f]
						[(eqv? (car list) element) index]
						[else (get-index element (cdr list) (+ index 1))]
				)
			))
		)
		(get-index element list 0)
	)
))


(define my-length (
	lambda (list) (
		cond
			[(empty? list) 0]
			[else (+ 1 (my-length (cdr list)))]
	)
))


(define iota (
	lambda(end) (
		letrec (
			(iota-aux (
				lambda(start) (
					cond
						[(= start (- end 1)) (cons start empty)]
						[else (cons start (iota-aux (+ start 1)))]
				)
			))
		)
		(if (= end 0)
			empty
			(iota-aux 0)
		)
	)
))


(define number-to-decimal (
	lambda (number base) (
		letrec (
			(make-conversion (
				lambda (number actual-exponent) (
					cond
					[(empty? number) 0]
					[else (+ (* (car number) (expt base actual-exponent))
						(make-conversion (cdr number) (- actual-exponent 1)))]
				)
			))
		)
		(make-conversion number (- (my-length number) 1))
	)
))


(provide (all-defined-out))
