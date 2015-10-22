#lang racket/base

(require rackunit
         rackunit/text-ui
         "../schedule.rkt")

(define all
  (list
   (test-suite
    "command from strings"
    (test-case
     "tra X minuti"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (get-seconds-for "tra 10 Minuti" current))
     (check-equal? actual-result-seconds (+ current 600))

     (set! actual-result-seconds (get-seconds-for "tra 45 minUti" current))
     (check-equal? actual-result-seconds (+ current 2700))

     (set! actual-result-seconds (get-seconds-for "trA 1 minuto" current))
     (check-equal? actual-result-seconds (+ current 60)))

    (test-case
     "tra X ore"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (get-seconds-for "tRa 1 oRa" current))
     (check-equal? actual-result-seconds (+ current 3600))

     (set! actual-result-seconds (get-seconds-for "tra 10 ore" current))
     (check-equal? actual-result-seconds (+ current 36000))

     (define actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-day actual-result-date) 26))

    (test-case
     "tra X giorni"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (get-seconds-for "tra 1 gioRno" current))
     (check-equal? actual-result-seconds (+ current 86400))

     (set! actual-result-seconds (get-seconds-for "tra 10 giorni" current))
     (check-equal? actual-result-seconds (+ current 864000)))



    (test-case
     "oggi alle 10"
     (define current 1443340127);"Sunday, September 27th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "oggI alle 10" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 27)
     (check-equal? (date-month actual-result-date) 9)
     (check-equal? (date-year actual-result-date) 2015)
     (check-equal? (date-minute actual-result-date) 0)


     (set! actual-result-seconds (get-seconds-for "oggi alle 23" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-hour actual-result-date) 23))

    (test-case
     "domani alle 10:19"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "doMani alle 10:19" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-minute actual-result-date) 19)
     (check-equal? (date-second actual-result-date) 0)
     (check-equal? (date-day actual-result-date) 1)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015)


     (set! actual-result-seconds (get-seconds-for "domani alle 23" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-hour actual-result-date) 23)
     (check-equal? (date-day actual-result-date) 1))

    (test-case
     "dopodomani alle 10"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "doPodomani alle 10" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 2)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015))

    (test-case
     "il 10 ottobre alle 11:27"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "Il 10 ottobre alle 11:27" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 11)
     (check-equal? (date-minute actual-result-date) 27)
     (check-equal? (date-second actual-result-date) 0)
     (check-equal? (date-day actual-result-date) 10)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015)

     (set! actual-result-seconds (get-seconds-for "il 10 luglio alle 7" current))
     (set! actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-month actual-result-date) 7)
     (check-equal? (date-day actual-result-date) 10)
     (check-equal? (date-hour actual-result-date) 7)
     (check-equal? (date-minute actual-result-date) 0)
     (check-equal? (date-second actual-result-date) 0)
     (check-equal? (date-year actual-result-date) 2016))

    (test-case
     "oggi alle 10:30"
     (define current 1443340127);"Sunday, September 27th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "ogGi alle 10:30" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 27)
     (check-equal? (date-month actual-result-date) 9)
     (check-equal? (date-year actual-result-date) 2015)
     (check-equal? (date-minute actual-result-date) 30)
     (check-equal? (date-second actual-result-date) 0))

    (test-case
     "alle 11"
     (define current 1443340127);"Sunday, September 27th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "aLle 11" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-hour actual-result-date) 11)
     (check-equal? (date-day actual-result-date) 27)
     (check-equal? (date-month actual-result-date) 9)
     (check-equal? (date-year actual-result-date) 2015)
     (check-equal? (date-minute actual-result-date) 0)
     (check-equal? (date-second actual-result-date) 0))

    (test-case
     "lunedì alle 10:30"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "Lunedi alle 10:30" current))
     (define actual-result-date (seconds->date actual-result-seconds))

     (check-equal? (date-week-day actual-result-date) 1)
     (check-equal? (date-hour actual-result-date) 10)
     (check-equal? (date-day actual-result-date) 5)
     (check-equal? (date-month actual-result-date) 10)
     (check-equal? (date-year actual-result-date) 2015)
     (check-equal? (date-minute actual-result-date) 30)
     (check-equal? (date-second actual-result-date) 0))

    (test-case
     "other days"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"

     (define actual-result-seconds (get-seconds-for "martEdi alle 10:30" current))
     (define actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 2)
     (check-equal? (date-day actual-result-date) 6)

     (set! actual-result-seconds (get-seconds-for "merColedi alle 10:30" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 3)
     (check-equal? (date-day actual-result-date) 7)

     (set! actual-result-seconds (get-seconds-for "gioveDi alle 10:30" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 4)
     (check-equal? (date-day actual-result-date) 1)

     (set! actual-result-seconds (get-seconds-for "veNerdì alle 10:30" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 5)
     (check-equal? (date-day actual-result-date) 2)

     (set! actual-result-seconds (get-seconds-for "sAbato alle 10:30" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 6)
     (check-equal? (date-day actual-result-date) 3)

     (set! actual-result-seconds (get-seconds-for "doMenica alle 10:30" current))
     (set! actual-result-date (seconds->date actual-result-seconds))
     (check-equal? (date-week-day actual-result-date) 0)
     (check-equal? (date-day actual-result-date) 4))


    (test-case
     "day with no time"
     (define current 1443599327);"Wednesday, September 30th, 2015 9:48:47am"
     (define expcted-seconds 1443685680);"Wednesday, September 30th, 2015 9:48:00am"
     (define actual-result-seconds (get-seconds-for "domani" current))

     (check-equal? actual-result-seconds expcted-seconds)

     (set! actual-result-seconds (get-seconds-for "il 2 novembre" current))
     (set! expcted-seconds 1446454080);"Friday, October 30th, 2015 9:48:00am"

     (check-equal? actual-result-seconds expcted-seconds)
     )


    )))

  (for-each run-tests all)
