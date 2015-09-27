#lang racket/base

(require rackunit
         rackunit/text-ui
         "parsing.rkt")

(define all
  (list
   (test-suite
    "finding timing expressions"
    (check-false (extract-schedule ""))
    (check-false (extract-schedule ".>>>"))
    (check-false (extract-schedule "any string with no tag"))
    (check-false (extract-schedule "any non timing string.>>>"))
    (check-equal? (extract-schedule "any text tra 1 ora.>>>") "tra 1 ora")
    (check-equal? (extract-schedule "any text tra 10 ore.>>>") "tra 10 ore")
    (check-equal? (extract-schedule "any text tra 10 giorni.>>>") "tra 10 giorni")
    (check-equal? (extract-schedule "any text tra 1 giorno.>>>") "tra 1 giorno")
    (check-equal? (extract-schedule "any text tra 7 minuti.>>>") "tra 7 minuti")
    (check-equal? (extract-schedule "any text tra 1 minuto.>>>") "tra 1 minuto")
    (check-equal? (extract-schedule "any text alle 10.>>>") "alle 10")
    (check-equal? (extract-schedule "any text alle 10:30.>>>") "alle 10:30")
    (check-equal? (extract-schedule "any text il 10 settembre.>>>") "il 10 settembre")
    (check-equal? (extract-schedule "any text il 10 settembre alle 10:30.>>>") "il 10 settembre alle 10:30")
    (check-equal? (extract-schedule "any text lunedì.>>>") "lunedì")
    (check-equal? (extract-schedule "any text MercolEdi.>>>") "mercoledi")
    (check-equal? (extract-schedule "any text oggi.>>>") "oggi")
    (check-equal? (extract-schedule "any text domaNi.>>>") "domani")
    (check-equal? (extract-schedule "any text sabato alle 17.>>>") "sabato alle 17"))
   
   (test-suite
    "finding messages"
    (check-equal? (extract-message ".>>>") "")
    (check-equal? (extract-message "") "")
    (check-equal? (extract-message "any text.>>>") "any text")
    (check-equal? (extract-message "any text tra 1 ora.>>>") "any text"))
   ))

(for-each run-tests all)
