#lang racket

(define (should-parse? string_to_parse)
	(define list (string->list string_to_parse))
	(cond
		[(empty? list) #f]
		[(string=? ".>>>" string_to_parse) #t]
		[else (should-parse? (list->string (rest list)))]))


(provide should-parse?)
