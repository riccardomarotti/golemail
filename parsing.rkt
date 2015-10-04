#lang racket

(define golem-tag (make-parameter ".>>>"))

(define week-day-regexp
  "(?i:luned[iì]|marted[iì]|mercoled[iì]|gioved[iì]|venerd[iì]|sabato|domenica|oggi|domani|dopodomani)")

(define hour-regexp "(?:([0-2]?[0-9]):)?([0-5]?[0-9])(?!.*minut[io])")
(define month-regexp "(?i:gennaio|febbraio|marzo|aprile|maggio|giugno|luglio|agosto|settembre|ottobre|novembre|dicembre)")

(define (timing-regexps)
  (list
   (~a "tra +([0-9]+) +minut[io] *" (regexp-quote (golem-tag)) "$")
   (~a "tra +([0-9]+) +or[ae] *" (regexp-quote (golem-tag)) "$")
   (~a "tra +([0-9]+) +giorn[io] *" (regexp-quote (golem-tag)) "$")
   (~a week-day-regexp " +alle +" hour-regexp (regexp-quote (golem-tag)) "$")
   (~a "alle +" hour-regexp (regexp-quote (golem-tag)) "$")
   (~a "il +([0-9]+) +" month-regexp " +alle +" hour-regexp (regexp-quote (golem-tag)) "$")
   (~a "il +([0-9]+) +" month-regexp (regexp-quote (golem-tag)) "$")
   (~a week-day-regexp (regexp-quote (golem-tag)) "$")))

(define (timing-regexp) (string-join (timing-regexps) "|"))

(define (extract-schedule string)
  (define result (regexp-match (timing-regexp) string))
  (and result (string-downcase (string-replace (first result) (golem-tag) ""))))

(define (extract-message string)
  (define timing-match (regexp-match (timing-regexp) string))
  (if (not timing-match)
      (string-replace string (golem-tag) "")
      (string-trim (substring string 0 (- (string-length string) (string-length (first timing-match)))))))

(provide extract-schedule extract-message golem-tag)
