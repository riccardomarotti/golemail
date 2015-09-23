#lang racket/base

(require rackunit
         rackunit/text-ui
         "parsing.rkt")

(define all
  (list
   (test-suite
    "subject parsing"
    (test-equal? "empty string" (should-parse? "") #f)
    (test-equal? "string with no keyword" (should-parse? "any string") #f)
    (test-equal? "string with keyword not as last" (should-parse? ".>>> and anything else") #f)
    (test-equal? "string with keyword as last" (should-parse? "anything ending with .>>>") #t))

   (test-suite
    "finding timing expressions"
    (check-false (extract-timing ""))
    (check-false (extract-timing "any non timing string"))
    (check-equal? "tra un'ora" (extract-timing "any text tra un'ora"))
    (check-equal? "alle 10" (extract-timing "any text alle 10"))
    (check-equal? "il 10 settembre" (extract-timing "any text il 10 settembre"))
    (check-equal? "lunedì" (extract-timing "any text lunedì"))
    (check-equal? "MercolEdi" (extract-timing "any text MercolEdi"))
    (check-equal? "oggi" (extract-timing "any text oggi"))
    (check-equal? "domaNi" (extract-timing "any text domaNi"))
    (check-equal? "sabato alle 17" (extract-timing "any text sabato alle 17")))

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

    ; (test-case
    ;  "in X hours/minutes"
    ;  (define current-date (seconds->date 1443037023)) ;"Wednesday, September 23rd, 2015 9:37:48pm"
    ;  (define calculated-time (date-of-reminder "tra 32 minuti" current-date))
    ;  (check-equal? (date-hour calculated-time) 22)
    ;  )
    )))
(for-each run-tests all)
