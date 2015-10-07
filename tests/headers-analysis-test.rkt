#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../headers-analysis.rkt"
         "../structures.rkt")

(define all
  (list
   (test-suite
    "message headers filtering"
    (test-case
     "filter headers with same from and to address"
     (define same-sender-and-receiver-header (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define same-sender-and-receiver-message (message same-sender-and-receiver-header "any mailbox" "any id" "any position"))

     (define another-header (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define another-message (message another-header "any mailbox" "any other id" "any position"))

     (define messages (list same-sender-and-receiver-message another-message))
     (define filtered-messages (filter-headers-with-same-to-and-from messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) same-sender-and-receiver-message))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-sender (message header-from-sender "any mailbox" "any id" "any position"))
     (define header-from-another-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-another-sender (message header-from-another-sender "any mailbox" "any other id" "any other position"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-sender (message header-from-sender "any mailbox" "any id" "any position"))
     (define header-from-another-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-another-sender (message header-from-another-sender "any mailbox" "any other id" "any other position"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))

    (test-case
     "filter reminders"
     (define not-a-reminder-header (insert-field #"Subject" #"any subejct" (string->bytes/utf-8 empty-header)))
     (define not-a-reminder-message (message not-a-reminder-header "any mailbox" "any id" "any position"))
     (define a-reminder-header (insert-field #"Subject" #"any text oggi alle 10.>>>" (string->bytes/utf-8 empty-header)))
     (define a-reminder-message (message a-reminder-header "any mailbox" "a reminder id" "any other position"))
     (define messages (list a-reminder-message not-a-reminder-message))

     (define filtered-messages (filter-reminders messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) a-reminder-message))

    ))


  )




(for-each run-tests all)
