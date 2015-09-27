#lang racket

(define week-day-regexp
  "(?i:luned[iì]|marted[iì]|mercoled[iì]|gioved[iì]|venerd[iì]|sabato|domenica|oggi|domani|dopodomani)")

(define hour-regexp "(?:([0-2]?[0-9]):)?([0-5]?[0-9])(?!.*minut[io])")
(define month-regexp "(?i:gennaio|febbraio|marzo|aprile|maggio|giugno|luglio|agosto|settembre|ottobre|novembre|dicembre)")

(define timing-regexps
  (list
   "tra +([0-9]+) +minut[io] *$"
   "tra +([0-9]+) +or[ae] *$"
   "tra +([0-9]+) +giorn[io] *$"
   (~a week-day-regexp " +alle +" hour-regexp)
   (~a "alle +" hour-regexp)
   (~a "il +([0-9]+) +" month-regexp)
   week-day-regexp))

(define timing-regexp (string-join timing-regexps "|"))



(define (get-reminder-string string_to_parse)
  (define result (regexp-match "(.*)\\.>>>$" string_to_parse))
  (and result (second result)))

(define (extract-timing string)
  (define result (regexp-match timing-regexp string))
  (and result (string-downcase (first result))))


(provide get-reminder-string extract-timing)
