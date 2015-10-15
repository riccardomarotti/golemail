#lang racket

(require racket/cmdline
         "client.rkt"
         "configuration.rkt"
         "headers-analysis.rkt"
         "imap-access.rkt"
         "parsing.rkt"
         "reminders.rkt"
         "schedule.rkt"
         "structures.rkt")

(define version "0.0.1")
(define show-version (make-parameter #f))

(command-line
 #:program "golemail"
 #:once-each
 [("--version") "Show version"
                (show-version #t)])

(if (show-version)
    (displayln (~a "golemail version " version))

    (let loop()
      (thread-wait (thread main))
      (sleep 10)
      (loop))
    )
