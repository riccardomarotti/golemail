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
     "filter headers with same from and to address"
     (define same-sender-and-receiver-header (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define anopther-header (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define headers (list same-sender-and-receiver-header anopther-header))
     (define filtered-headers (filter-messages-with-same-to-and-from headers))

     (check-equal? (length filtered-headers) 1)
     (check-equal? (car filtered-headers) same-sender-and-receiver-header))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define header-from-another-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define headers (list header-from-sender header-from-another-sender))
     (define filtered-headers (filter-messages-with-from-address "sender@email.it" headers))

     (check-equal? (length filtered-headers) 1)
     (check-equal? (car filtered-headers) header-from-sender))))


  )




(for-each run-tests all)
