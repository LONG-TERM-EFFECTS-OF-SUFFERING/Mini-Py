#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)


; -------------------------------------------------------------------------- ;
;                                  AUXILIAR                                  ;
; -------------------------------------------------------------------------- ;

;; Objectvie: Returns the nth element of a list.
;; Parameters:
;; - list: The input list.
;; - n: The index of the element to retrieve.
;; Returns:
;; - The nth element of the list.
;; Examples:
;; (nth-element '(1 2 3 4 5) 2) ; returns 3
;;
(define nth-element (
	lambda (list n) (
		cond
			[(zero? n) (car list)]
			[else (nth-element (cdr list) (- n 1))]
	)
))


;; Objective: Find the index of the first occurrence of an element in a list.
;; Parameters:
;;   - element: The element to search for.
;;   - list: The list to search in.
;; Returns:
;;   - The index of the first occurrence of the element in the list, or #f if the element is not found.
;; Examples:
;;   (index-of 2 '(1 2 3 4 5)) ; returns 1
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


;; Objective: Compute the length of a given list.
;; Parameters:
;;   - list: The list for which the length needs to be computed.
;; Returns: The length of the given list.
;; Examples:
;;   (my-length '()) => 0
;;   (my-length '(1 2 3 4 5)) => 5
(define my-length (
	lambda (list) (
		cond
			[(empty? list) 0]
			[else (+ 1 (my-length (cdr list)))]
	)
))


;; Objective: Generate a list of integers from 0 to the given end value.
;; Parameters:
;; - end: The end value of the list (inclusive).
;; Returns: A list of integers from 0 to the given end value.
;; Examples:
;; (iota 0) => '()
;; (iota 5) => '(0 1 2 3 4)
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


;; Objective: Convert a number from a given base to decimal.
;; Parameters:
;;   - number: A list of digits representing the number in the given base.
;;   - base: The base of the number.
;; Returns: The decimal representation of the number.
;; Examples:
;;   (number-to-decimal '(2 11 4) 16) => 692
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


(define is-valid-number (
	lambda (numbers base) (
		cond
			[(empty? numbers) #t]
			[(or
				(>= (car numbers) base)
				(< (car numbers) 0)
			) #f]
			[else (is-valid-number (cdr numbers) base)]
	)
))

(define list-find-position
	(lambda (sym los)
		(list-index (lambda (sym1) (eqv? sym1 sym)) los)))

(define list-index
	(lambda (pred ls)
		(cond
			((null? ls) #f)
			((pred (car ls)) 0)
			(else (let ((list-index-r (list-index pred (cdr ls))))
							(if (number? list-index-r)
									(+ list-index-r 1)
									#f))))))


(provide (all-defined-out))
