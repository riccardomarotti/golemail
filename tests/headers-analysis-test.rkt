#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../headers-analysis.rkt"
         "../messages.rkt")

(define all
  (list
   (test-suite
    "message headers filtering"
    (test-case
     "filter headers with same from and to address"
     (define same-sender-and-receiver-header (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define same-sender-and-receiver-message (message same-sender-and-receiver-header "any id"))

     (define another-header (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define another-message (message another-header "anuy other id"))

     (define messages (list same-sender-and-receiver-message another-message))
     (define filtered-messages (filter-headers-with-same-to-and-from messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) same-sender-and-receiver-message))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define message-from-sender (message header-from-sender "any id"))
     (define header-from-another-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define message-from-another-sender (message header-from-another-sender "any other id"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Sender <sender@email.it>"  empty-header)))
     (define message-from-sender (message header-from-sender "any id"))
     (define header-from-another-sender (insert-field "To" "Sender <sender@email.it>" (insert-field "From" "Another Sender <anothersender@email.it>"  empty-header)))
     (define message-from-another-sender (message header-from-another-sender "any other id"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))


    ))


  )




(for-each run-tests all)
