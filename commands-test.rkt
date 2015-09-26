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
     )

    (test-case
     "tra X ore"
     (define current 1443191395);"Friday, September 25th, 2015 4:29:55pm"

     (define actual-result-seconds (execute "tra 1 ora" current))
     (check-equal? actual-result-seconds (+ current 3600))

     (set! actual-result-seconds (execute "tra 10 ore" current))
     (check-equal? actual-result-seconds (+ current 36000))

     ))))

(for-each run-tests all)
