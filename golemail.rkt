#lang racket

(require "client.rkt"
         "configuration.rkt"
         "headers-analysis.rkt"
         "imap-access.rkt"
         "parsing.rkt"
         "reminders.rkt"
         "schedule.rkt"
         "structures.rkt")

(let loop()
    (thread-wait (thread main))
    (sleep 10)
    (loop))
