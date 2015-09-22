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
    		"no timing string"
    		(check-equal? (date-of-reminder "" "any date") #f)
    		(check-equal? (date-of-reminder "any non timing string" "any date") #f))

    	(test-case
    		"exact day and hour"
            (define current-date (seconds->date 1442851540)) ;"Monday, September 21st, 2015 6:05:40pm"

    		(define 21time (date-of-reminder "oggi alle 21" current-date))
    		(check-equal? (date-hour 21time) 21)
       		(check-equal? (date-week-day 21time) 1)

    		(define 22time (date-of-reminder "oggi alle 22" current-date))
    		(check-equal? (date-hour 22time) 22))
    )))

(for-each run-tests all)
