#lang racket/base

(require rackunit
         rackunit/text-ui
         "../core/configuration.rkt")

(define all
  (list
   (test-suite
    "read tests/config.json"
    (test-case
     "read every configuration field"
     (check-equal? "test-imap-sender" (server))
     (check-equal? "an-email" (username))
     (check-equal? ".>>>" (tag))
     (check-equal? 987 (polling-interval))
     (check-equal? '("email1@server.com" "email2@server.com") (allowed-senders))
     ))
   ))


(for-each run-tests all)
