#lang racket/base

(require rackunit
         rackunit/text-ui
         "../golemail/schedule.rkt"
         "../golemail/parsing.rkt")

(define all
  (list
   (test-suite
    "command from strings"
    (test-case
     "full subject interpretation"
     (define today 1443365260);"Sunday, September 27th, 2015 4:47:40pm"
     (define message "ricordami di fare la spesa il 30 settembre alle 10:30.>>>")

     (check-equal? (extract-message message) "ricordami di fare la spesa")

     (define timing-command (extract-schedule message))
     (check-equal? timing-command "il 30 settembre alle 10:30")
     (check-equal? (get-seconds-for timing-command today) 1443601800) ;"Wednesday, September 30th, 2015 10:30:00am"
     )

    (test-case
     "date before today should be next year"
     (define today 1443365260);"Sunday, September 27th, 2015 4:47:40pm"
     (define message "ricordami di fare la spesa il 10 settembre alle 10:30.>>>")

     (check-equal? (extract-message message) "ricordami di fare la spesa")

     (define timing-command (extract-schedule message))
     (check-equal? timing-command "il 10 settembre alle 10:30")
     (check-equal? (get-seconds-for timing-command today) 1473496200) ;"Wednesday, September 30th, 2016 10:30:00am"
     )
    )))


(for-each run-tests all)
