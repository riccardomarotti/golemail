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
      )))

(map run-tests all)
