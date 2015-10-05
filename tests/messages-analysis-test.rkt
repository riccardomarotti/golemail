#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../messages-analysis.rkt")

(define all
  (list
   (test-suite
    "message headers filtering"
    (test-case
     "filter message from someone"
     (define header1 (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define header2 (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define headers (list header1 header2))
     (define filtered-headers (filter-messages-with-same-to-and-from headers))

     (check-equal? (length filtered-headers) 1)
     (check-equal? (car filtered-headers) header1)))))




(for-each run-tests all)
