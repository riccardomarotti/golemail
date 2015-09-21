#lang racket/base

(require rackunit
         rackunit/text-ui
         "parsing.rkt")

(define all
  (list
    (test-suite
      "subject parsing"
      (test-equal? "empty string" (should-parse? "") #f)
      (test-equal? "string with no keyword" (should-parse? "any string") #f)
      (test-equal? "string with keyword not as last" (should-parse? ".>>> and anything else") #f)
      (test-equal? "string with keyword as last" (should-parse? "anything ending with .>>>") #t))

    (test-suite
      "finding timing expressions"
      (check-false (contains-timing? ""))
      (check-false (contains-timing? "any non timing string"))
      (check-true (contains-timing? "any text tra un'ora"))
      (check-true (contains-timing? "any text alle 10"))
      (check-true (contains-timing? "any text il 10 settembre"))
      (check-true (contains-timing? "any text lunedì"))
      (check-true (contains-timing? "any text MercolEdi"))
      (check-true (contains-timing? "any text sabato alle 17")))

    (test-suite
    	"understanding timing expressions"
    	; #:before (λ() (define current-date (seconds->date 1442851540))) ;"Monday, September 21st, 2015 6:05:40pm"
    	(test-case
    		"empty string"
    		(check-equal? #f (date-of-reminder "")))

    	(test-case
    		"exact day and hour"
    		(define current-date (seconds->date 1442851540)) ;"Monday, September 21st, 2015 6:05:40pm"

    		(define 21time (date-of-reminder "oggi alle 21"))
    		(check-equal? 21 (date-hour 21time))

    		(define 22time (date-of-reminder "oggi alle 22"))
    		(check-equal? 22 (date-hour 22time)))
    )))

(map run-tests all)
