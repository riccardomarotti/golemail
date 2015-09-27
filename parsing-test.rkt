#lang racket/base

(require rackunit
         rackunit/text-ui
         "parsing.rkt")

(define all
  (list
   (test-suite
    "subject parsing"
    (test-equal? "empty string" (get-reminder-string "") #f)
    (test-equal? "string with no keyword" (get-reminder-string "any string") #f)
    (test-equal? "string with keyword not as last" (get-reminder-string ".>>> and anything else") #f)
    (test-equal? "string with keyword as last" (get-reminder-string "anything ending with .>>>") "anything ending with "))

   (test-suite
    "finding timing expressions"
    (check-false (extract-timing ""))
    (check-false (extract-timing "any non timing string"))
    (check-equal? (extract-timing "any text tra 1 ora") "tra 1 ora")
    (check-equal? (extract-timing "any text tra 10 ore") "tra 10 ore")
    (check-equal? (extract-timing "any text tra 10 giorni") "tra 10 giorni")
    (check-equal? (extract-timing "any text tra 1 giorno") "tra 1 giorno")
    (check-equal? (extract-timing "any text tra 7 minuti") "tra 7 minuti")
    (check-equal? (extract-timing "any text tra 1 minuto") "tra 1 minuto")
    (check-equal? (extract-timing "any text alle 10") "alle 10")
    (check-equal? (extract-timing "any text alle 10:30") "alle 10:30")
    (check-equal? (extract-timing "any text il 10 settembre") "il 10 settembre")
    (check-equal? (extract-timing "any text lunedì") "lunedì")
    (check-equal? (extract-timing "any text MercolEdi") "mercoledi")
    (check-equal? (extract-timing "any text oggi") "oggi")
    (check-equal? (extract-timing "any text domaNi") "domani")
    (check-equal? (extract-timing "any text sabato alle 17") "sabato alle 17"))

   (test-suite
    "finding messages"
    (check-equal? (extract-message "") "")
    (check-equal? (extract-message "any text") "any text")
(check-equal? (extract-message "any text tra 1 ora") "any text"))
   ))

(for-each run-tests all)
