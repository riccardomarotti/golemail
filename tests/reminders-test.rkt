#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../structures.rkt"
         "../reminders.rkt")

(define all
  (list
   (test-suite
    "conversions"
    (test-case
     "from message to reminder"
     (define now 1444233314) ;"Wednesday, October 7th, 2015 5:55:14pm"
     (define header (insert-field #"Subject" #"any text domani alle 20.>>>"  (string->bytes/utf-8 empty-header)))
     (define source-message (message header "reminder" "an uid" "a position"))
     (define expected-reminder (reminder 1444327200 "golemail" "an uid"))

     (define actual-reminder (car (reminders-from-messages (list source-message) now)))

     (check-equal? actual-reminder expected-reminder)

    ))))


(for-each run-tests all)
