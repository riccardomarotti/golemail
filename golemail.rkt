#lang racket

(require "client.rkt"
         "configuration.rkt"
         "headers-analysis.rkt"
         "imap-access.rkt"
         "parsing.rkt"
         "reminders.rkt"
         "schedule.rkt"
         "structures.rkt")


(define (handled-loop)
  (with-handlers ([exn:break? (λ(exn) 'ciao)]
                  [exn:fail? (λ(exn)
                          (let()
                            (displayln (exn-message exn))
                            (handled-loop)
                            ))])
    (loop)
    ))


(handled-loop)
