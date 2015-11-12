#lang racket/base

(require rackunit
         rackunit/text-ui
         "../configuration.rkt")

(define all
  (list
   (test-suite
    "read"
    (test-case
     "1"
     (check-equal? '("email1@server.com" "email2@server.com") (allowed-senders))

     ))
   ))


(for-each run-tests all)
