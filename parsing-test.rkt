#lang racket/base

(require rackunit
         rackunit/text-ui
         "parsing.rkt")

(require/expose "parsing.rkt" (extract-hour extract-minute extract-second))

(define all
  (list
   (test-suite
    "time extraction"
    (test-case
     "extract-hour"
     (define current-date (seconds->date 1443191395));"Friday, September 25th, 2015 4:29:55pm"

     (check-equal? (extract-hour "any string" current-date) 16)
     (check-equal? (extract-hour "10:30" current-date) 10)
     (check-equal? (extract-hour "23" current-date) 23)
     (check-equal? (extract-hour "32  minuti" current-date) 16))

    (test-case
     "extract-minute"
     (define current-date (seconds->date 1443191395));"Friday, September 25th, 2015 4:29:55pm"

     (check-equal? (extract-minute "any non timing string" current-date) 0)
     (check-equal? (extract-minute "10:30" current-date) 30)
     (check-equal? (extract-minute "9" current-date) 0)
     (check-equal? (extract-minute "tra 5 minuti" current-date) 34)

     (check-equal? (extract-second "any string") 0)))

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
    (check-equal? (extract-timing "any text tra 7 minuti") "tra 7 minuti")
    (check-equal? (extract-timing "any text alle 10") "alle 10")
    (check-equal? (extract-timing "any text il 10 settembre") "il 10 settembre")
    (check-equal? (extract-timing "any text lunedì") "lunedì")
    (check-equal? (extract-timing "any text MercolEdi") "MercolEdi")
    (check-equal? (extract-timing "any text oggi") "oggi")
    (check-equal? (extract-timing "any text domaNi") "domaNi")
    (check-equal? (extract-timing "any text sabato alle 17") "sabato alle 17"))

   (test-suite
    "understanding timing expressions"
    (test-case
     "no timing string"
     (check-equal? (date-of-reminder "" "any date") #f)
     (check-equal? (date-of-reminder "any non timing string" "any date") #f))

    (test-case
     "today"
     (define current-date (seconds->date 1442851540)) ;"Monday, September 21st, 2015 6:05:40pm"

     (define 17time (date-of-reminder "oggi alle 17" current-date))
     (check-equal? (date-hour 17time) 17)
     (check-equal? (date-minute 17time) 0)
     (check-equal? (date-second 17time) 0)
     (check-equal? (date-week-day 17time) 1)
     (check-equal? (date-day 17time) 21)
     (check-equal? (date-month 17time) 9)
     (check-equal? (date-year 17time) 2015)

     (define 22time (date-of-reminder "oggi alle 22" current-date))
     (check-equal? (date-hour 22time) 22))

    (test-case
     "tomorrow"
     (define current-date (seconds->date 1442948973)) ;"Tuesday, September 22nd, 2015 9:09:33pm"

     (define a-time (date-of-reminder "domani alle 15" current-date))
     (check-equal? (date-hour a-time) 15)
     (check-equal? (date-minute a-time) 0)
     (check-equal? (date-second a-time) 0)
     (check-equal? (date-week-day a-time) 3)
     (check-equal? (date-day a-time) 23))

    (test-case
     "more precise time"
     (define current-date (seconds->date 1443006675)) ;"Wednesday, September 23rd, 2015 1:11:15pm"

     (define calculated-time (date-of-reminder "alle 12:37" current-date))
     (check-equal? (date-hour calculated-time) 12)
     (check-equal? (date-minute calculated-time) 37)
     (check-equal? (date-second calculated-time) 0)
     (check-equal? (date-day calculated-time) 23))

    (test-case
     "in X hours/minutes"
     (define current-date (seconds->date 1443037023)) ;"Wednesday, September 23rd, 2015 9:37:48pm"
     (define calculated-time (date-of-reminder "tra 12 minuti" current-date))
     (check-equal? (date-hour calculated-time) 21)
     (check-equal? (date-minute calculated-time) 49)
     (check-equal? (date-day calculated-time) 23)

     (define calculated-time2 (date-of-reminder "tra 23 minuti" current-date))
     (check-equal? (date-hour calculated-time2) 22)
     (check-equal? (date-minute calculated-time2) 0)
     )
    )))

(for-each run-tests all)
  ; (run-tests (car all))
