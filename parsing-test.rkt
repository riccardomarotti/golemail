#lang racket/base

(require rackunit
	 rackunit/text-ui
         "parsing.rkt")

(define all
	(test-suite
		"subject parsing"
		(test-equal? "empty string" (should-parse? "") #f)
		(test-equal? "string with no keyword" (should-parse? "any string") #f)
		(test-equal? "string with keyword not as last" (should-parse? ".>>> and anything else") #f)
		(test-equal? "string with keyword as last" (should-parse? "anything ending with .>>>") #t)))


(run-tests all)
