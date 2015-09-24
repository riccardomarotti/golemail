#lang racket

(require racket/date)

(define (get-reminder-string string_to_parse)
  (define result (regexp-match "(.*)\\.>>>$" string_to_parse))
  (and result (second result)))


(define timing-words
  (list
   "tra"
   "alle"
   "il"
   "lunedì"
   "lunedi"
   "martedì"
   "martedi"
   "mercoledì"
   "mercoledi"
   "giovedì"
   "giovedi"
   "venerdì"
   "venerdi"
   "sabato"
   "domenica"
   "oggi"
   "domani"))

(define (extract-timing string)
  (extract-timing-recursive (reverse (string-split string)) (list)))

(define (extract-timing-recursive words timing-words)
  (cond
    [(empty? words) #f]
    [(is-timing-word? (first words)) (string-join (cons (first words) timing-words))]
    [else (extract-timing-recursive (rest words) (cons (first words) timing-words))]))

(define (is-timing-word? word)
  (member (string-downcase word) timing-words))

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
  (string->number (first (string-split (last (string-split reminder)) ":"))))

(define (extract-minute reminder)
  (get-minutes (rest (string-split reminder ":"))))

(define (get-minutes time-list)
  (cond
    [(empty? time-list) 0]
    [(empty? (rest time-list)) (string->number (first time-list))]
    [else (get-minutes (rest time-list))]))



(define (extract-second reminder)
  0)

(define (extract-week-day reminder current-date)
  (define day (first-timing-word reminder))
  (cond
    [(string=? day "domani") (add1 (date-week-day current-date))]
    [else (date-week-day current-date)]))

(define (extract-day reminder current-date)
  (define day (first-timing-word reminder))
  (cond
    [(string=? day "domani") (add1 (date-day current-date))]
    [else (date-day current-date)]))

(define (first-timing-word reminder)
  (first-timing-word-recursive (string-split reminder)))

(define (first-timing-word-recursive words)
  (cond
    [(empty? words) #f]
    [(is-timing-word? (first words)) (first words)]
    [else (first-timing-word-recursive (rest words))]))




(provide get-reminder-string extract-timing date-of-reminder)
