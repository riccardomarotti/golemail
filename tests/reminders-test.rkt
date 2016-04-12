#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../golemail/structures.rkt"
         "../golemail/reminders.rkt")

(define all
  (list
   (test-suite
    "conversions"
    (test-case
     "from message to reminder"
     (define now 1444233314) ;"Wednesday, October 7th, 2015 5:55:14pm"
     (define header (insert-field #"Subject" #"any text domani alle 20.>>>"  (string->bytes/utf-8 empty-header)))
     (define source-message (message header "a body" "an uid" "a position"))
     (define expected-reminder (reminder 1444327200 "Subject: any text\r\n\r\na body" "any text" (list "an uid")))

     (define actual-reminder (car (messages->reminders (list source-message) now)))

     (check-equal? actual-reminder expected-reminder)

     ))

   (test-suite
    "manipulation"
    (test-case
     "merge reminders"
     (define now 1444233314) ;"Wednesday, October 7th, 2015 5:55:14pm"
     (define a-reminder (reminder 1444327200 "a message" "the subject" (list "any uid")))
     (define reminder-with-same-subject-but-different-schedule
       (reminder 1444327260 "another message" "the subject" (list "any other uid")))
     (define another-reminder (reminder 1444327210 "another message" "another text" (list "another uid")))

     (define old-reminders (list a-reminder another-reminder))
     (define new-reminders (list reminder-with-same-subject-but-different-schedule))

     (check-equal?
        (merge-reminders old-reminders new-reminders)
        (list another-reminder reminder-with-same-subject-but-different-schedule)

        )
     ))
   ))


(for-each run-tests all)
