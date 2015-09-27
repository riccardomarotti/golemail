#lang racket

(define week-day-regexp
  "(?i:luned[iì]|marted[iì]|mercoled[iì]|gioved[iì]|venerd[iì]|sabato|domenica|oggi|domani|dopodomani)")

(define hour-regexp "(?:([0-2]?[0-9]):)?([0-5]?[0-9])(?!.*minut[io])")
(define month-regexp "(?i:gennaio|febbraio|marzo|aprile|maggio|giugno|luglio|agosto|settembre|ottobre|novembre|dicembre)")

(define timing-regexps
  (list
   "tra +([0-9]+) +minut[io] *\\.>>>$"
   "tra +([0-9]+) +or[ae] *\\.>>>$"
   "tra +([0-9]+) +giorn[io] *\\.>>>$"
   (~a week-day-regexp " +alle +" hour-regexp "\\.>>>$")
   (~a "alle +" hour-regexp "\\.>>>$")
   (~a "il +([0-9]+) +" month-regexp " +alle +" hour-regexp "\\.>>>$")
   (~a "il +([0-9]+) +" month-regexp "\\.>>>$")
   (~a week-day-regexp "\\.>>>$")))

(define timing-regexp (string-join timing-regexps "|"))

(define (extract-schedule string)
  (define result (regexp-match timing-regexp string))
  (and result (string-downcase (string-replace (first result) ".>>>" ""))))

(define (extract-message string)
  (define timing-match (regexp-match timing-regexp string))
  (if (not timing-match)
      (string-replace string ".>>>" "")
    (string-trim (substring string 0 (- (string-length string) (string-length (first timing-match)))))))

(provide extract-schedule extract-message)
