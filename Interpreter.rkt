#lang racket
(require (except-in eopl #%module-begin))
(provide (all-from-out eopl))
(provide #%module-begin)
;(require "Auxiliary_functions.rkt")
(require "Grammar_and_lexica.rkt")


; -------------------------------------------------------------------------- ;
;                                ENVIRONMENTS                                ;
; -------------------------------------------------------------------------- ;


; -------------------------------------------------------------------------- ;
;                                 REFERENCES                                 ;
; -------------------------------------------------------------------------- ;


; -------------------------------------------------------------------------- ;
;                                 PROCEDURES                                 ;
; -------------------------------------------------------------------------- ;


; -------------------------------------------------------------------------- ;
;                             PROGRAM EVALUATION                             ;
; -------------------------------------------------------------------------- ;

;(define interpreter (
;	sllgen:make-rep-loop  "--> " (lambda (pgm) (eval-program  pgm)) (sllgen:make-stream-parser lexica grammar)
;))

(scan&parse "
int main() {
	{hello = 5; bye = 10}
}
")
