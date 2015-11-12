#lang racket/base

(require rackunit
         rackunit/text-ui
         net/head
         "../headers-analysis.rkt"
         "../structures.rkt")

(require/expose "../headers-analysis.rkt" (filter-headers-with-from-address))

(define all
  (list
   (test-suite
    "message headers filtering"
    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-sender (message header-from-sender "any body" "any id" "any position"))
     (define header-from-another-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-another-sender (message header-from-another-sender "any other body" "any other id" "any other position"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))

    (test-case
     "filter headers from a particular address"
     (define header-from-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-sender (message header-from-sender "any body" "any id" "any position"))
     (define header-from-another-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-another-sender (message header-from-another-sender "any other body" "any other id" "any other position"))
     (define messages (list message-from-sender message-from-another-sender))
     (define filtered-messages (filter-headers-with-from-address "sender@email.it" messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message-from-sender))

    (test-case
     "filter headers from a list of addresses"
     (define header-from-allowed-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Sender <allowed-sender@email.it>" (string->bytes/utf-8 empty-header))))
     (define message-from-allowed-sender (message header-from-allowed-sender "any body" "any id" "any position"))
     (define header-from-another-allowed-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <another-allowed-sender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-another-allowed-sender (message header-from-another-allowed-sender "any other body" "any other id" "any other position"))
     (define header-from-a-not-allowed-sender (insert-field #"To" #"Sender <sender@email.it>" (insert-field #"From" #"Another Sender <anothersender@email.it>"  (string->bytes/utf-8 empty-header))))
     (define message-from-a-not-allowed-sender (message header-from-a-not-allowed-sender "any other body" "any other id" "any other position"))
     (define messages (list message-from-allowed-sender message-from-a-not-allowed-sender message-from-another-allowed-sender))
     (define filtered-messages (filter-headers-with-from-addresses '("allowed-sender@email.it" "another-allowed-sender@email.it") messages))

     (check-equal? (length filtered-messages) 2)
     (check-equal? filtered-messages (list message-from-allowed-sender message-from-another-allowed-sender)))

    (test-case
     "filter reminders"
     (define not-a-reminder-header (insert-field #"Subject" #"any subject" (string->bytes/utf-8 empty-header)))
     (define not-a-reminder-message (message not-a-reminder-header "any body" "any id" "any position"))
     (define a-reminder-header (insert-field #"Subject" #"any text oggi alle 10.>>>" (string->bytes/utf-8 empty-header)))
     (define a-reminder-message (message a-reminder-header "a reminder body" "a reminder id" "any other position"))
     (define messages (list a-reminder-message not-a-reminder-message))

     (define filtered-messages (filter-reminders messages))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) a-reminder-message))

    (test-case
     "filter subject"
     (define header1 (insert-field #"Subject" #"subject 1" (string->bytes/utf-8 empty-header)))
     (define header2 (insert-field #"Subject" #"subject 2" (string->bytes/utf-8 empty-header)))
     (define header3 (insert-field #"Subject" #"subject 3" (string->bytes/utf-8 empty-header)))
     (define message1 (message header1 "any body 1" "any id 1" "any position 1"))
     (define message2 (message header2 "any body 2" "any id 2" "any position 2"))
     (define message3 (message header3 "any body 3" "any id 3" "any position 3"))
     (define messages-to-filter (list message1 message2 message3))

     (define filtered-messages (filter-headers-with-subject "subject 2" messages-to-filter))

     (check-equal? (length filtered-messages) 1)
     (check-equal? (car filtered-messages) message2))

    (test-case
     "utf-8 encoding"
     (define header (insert-field #"Subject" #"=?utf-8?B?WUFOU1MgNjAg4oCTIEhvdyB0byB0dXJuIHlvdXIgZmVhcnMgYW5kIGFueGlldGllcyBpbnRvIHBvc2l0?==?utf-8?B?aXZpdHkgYW5kIHByb2R1Y3Rpdml0eSB3aXRoIGNvZ25pdGl2ZSByZWZyYW1pbmcgYWxsZSAxOC4+Pj4=?=" (string->bytes/utf-8 empty-header)))
     (define amessage (message header "any body" "any id" "any position"))

     (check-equal? (subject-of amessage) "YANSS 60 – How to turn your fears and anxieties into positivity and productivity with cognitive reframing alle 18.>>>")
     )

    ))


  )




(for-each run-tests all)
