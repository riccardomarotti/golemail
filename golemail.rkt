#lang racket

(require racket/cmdline
         racket/system
         "client.rkt"
         "core/configuration.rkt"
         "core/headers-analysis.rkt"
         "core/imap-access.rkt"
         "core/parsing.rkt"
         "core/reminders.rkt"
         "core/schedule.rkt"
         "core/structures.rkt")

(define version "0.0.2")
(define show-version (make-parameter #f))

(define (get-password)
  (dynamic-wind
   (λ()
     (printf (~a "Insert password for " (username) ": ")) (system* "/bin/stty" "-echo" "echonl"))
   read-line
   (λ() (system* "/bin/stty" "echo"))))

(command-line
 #:program "golemail"
 #:once-each
 [("--version") "Show version"
                (show-version #t)])

(cond [(show-version)
       (displayln (~a "golemail version " version))]
      [else
       (password (get-password))
       (let loop()
         (thread-wait (thread main))
         (collect-garbage)
         (sleep (polling-interval))
         (loop))]
      )
