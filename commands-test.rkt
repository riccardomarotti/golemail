#lang racket/base

(require rackunit
         rackunit/text-ui
         "commands.rkt")

(require/expose "commands.rkt" (tra))

(define all
  (list
   (test-suite
    "command from strings"
    (test-case
     "tra X minuti"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (execute "tra 10 minuti" current))
     (check-equal? actual-result-seconds (+ current 600))

     (set! actual-result-seconds (execute "tra 45 minuti" current))
     (check-equal? actual-result-seconds (+ current 2700))

     (set! actual-result-seconds (execute "tra 1 minuto" current))
     (check-equal? actual-result-seconds (+ current 60)))

    (test-case
     "tra X ore"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (execute "tra 1 ora" current))
     (check-equal? actual-result-seconds (+ current 3600))

     (set! actual-result-seconds (execute "tra 10 ore" current))
     (check-equal? actual-result-seconds (+ current 36000))

     (define actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-day actual-result-date) 26))



    (test-case
     "oggi alle 10"
     (define current 1443340127);"Sunday, September 27th, 2015 9:48:47am"

     (define actual-result-seconds (execute "oggi alle 10" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 27)
     (check-equal? (date-month actual-result-date) 9)
     (check-equal? (date-year actual-result-date) 2015)
     (check-equal? (date-minute actual-result-date) 0)


     (set! actual-result-seconds (execute "oggi alle 23" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-hour actual-result-date) 23))

    (test-case
     "domani alle 10"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (execute "domani alle 10" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 1)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015)


     (set! actual-result-seconds (execute "domani alle 23" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-hour actual-result-date) 23)
     (check-equal? (date-day actual-result-date) 1))

    (test-case
     "dopodomani alle 10"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (execute "dopodomani alle 10" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 2)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015))

    (test-case
     "il 10 ottobre alle 11"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (execute "il 10 ottobre alle 11" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 11)
     (check-equal? (date-day actual-result-date) 10)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015)

     (set! actual-result-seconds (execute "il 10 luglio alle 7" current))
     (set! actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-month actual-result-date) 7)
     (check-equal? (date-year actual-result-date) 2016))




    )))

  (for-each run-tests all)
