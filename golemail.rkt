#lang racket

(require racket/cmdline
         racket/system
         "golemail/client.rkt"
         "golemail/configuration.rkt"
         "golemail/headers-analysis.rkt"
         "golemail/imap-access.rkt"
         "golemail/parsing.rkt"
         "golemail/reminders.rkt"
         "golemail/schedule.rkt"
         "golemail/structures.rkt")

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
