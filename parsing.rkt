#lang racket

(require racket/date)

(define (get-reminder-string string_to_parse)
  (define result (regexp-match "(.*)\\.>>>$" string_to_parse))
  (and result (second result)))

(define week-day-regexp
  "(?i:luned[iì]|marted[iì]|mercoled[iì]|gioved[iì]|venerd[iì]|sabato|domenica|oggi|domani|dopodomani)")

(define hour-regexp "(?:([0-2]?[0-9]):)?([0-5]?[0-9])")
(define minute-regexp "[0-2]?[0-9]:([0-5]?[0-9])")
(define month-regexp "(?i:gennaio|febbraio|marzo|aprile|maggio|giugno|luglio|agosto|settembre|ottobre|novembre|dicembre)")

(define timing-regexps
  (list
   "tra +([0-9]+) +minuti *$"
   "tra +([0-9]+) +or[ae] *$"
   (~a week-day-regexp " +alle +" hour-regexp)
   (~a "alle +" hour-regexp)
   (~a "il +([0-9]+) +" month-regexp)
   week-day-regexp))

(define timing-regexp (string-join timing-regexps "|"))


(define (extract-timing string)
  (define result (regexp-match timing-regexp string))
  (and result (first result)))

(define (date-of-reminder reminder current-date)
  (if (extract-timing reminder)
      (struct-copy date current-date
                   [hour (extract-hour reminder)]
                   [minute (extract-minute reminder)]
                   [second (extract-second reminder)]
                   [week-day (extract-week-day reminder current-date)]
                   [day (extract-day reminder current-date)])
    #f ))

(define (extract-hour reminder)
  (define matches (regexp-match hour-regexp reminder))
  (and matches
    (string->number (first (filter (lambda(x) (not (equal? #f x))) (rest matches))))))


(define (extract-minute reminder)
  (define matches (regexp-match minute-regexp reminder))
  (if matches (string->number (last matches)) 0))

(define (extract-second reminder)
  0)

(define (extract-week-day reminder current-date)
  (define matches (regexp-match week-day-regexp reminder))
  (define day (and matches (first matches)))
  (cond
   [(equal? day "domani") (add1 (date-week-day current-date))]
   [else (date-week-day current-date)]))

(define (extract-day reminder current-date)
  (define matches (regexp-match week-day-regexp reminder))
  (define day (and matches (first matches)))
  (cond
   [(equal? day "domani") (add1 (date-day current-date))]
   [else (date-day current-date)]))





(provide get-reminder-string extract-timing date-of-reminder)
