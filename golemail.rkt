#lang racket

(require racket/engine
         racket/cmdline
         racket/system
         "client.rkt"
         "configuration.rkt"
         "headers-analysis.rkt"
         "imap-access.rkt"
         "parsing.rkt"
         "reminders.rkt"
         "schedule.rkt"
         "structures.rkt")

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

(define check_engine (engine main))

(cond [(show-version)
       (displayln (~a "golemail version " version))]
      [else
       (password (get-password))
       (let loop()
         (engine-run 20000 check_engine)
         (collect-garbage)
         (sleep (polling-interval))
         (loop))]
      )
