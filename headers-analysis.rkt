#lang racket

(require net/head
         "schedule.rkt"
         "parsing.rkt")

(define (filter-headers-with-same-to-and-from messages-list)
  (filter has-same-to-and-from messages-list))

(define (filter-headers-with-from-address address headers)
  (filter (λ(header) (equal? address (extract-address "From" header))) headers))

(define (has-same-to-and-from message-header)
  (define to-address (extract-address "To" message-header))
  (define from-address (extract-address "From" message-header))
  (equal? to-address from-address))

(define (extract-address where header)
  (first (extract-addresses (extract-field where header) 'address)))


(provide filter-headers-with-same-to-and-from
         filter-headers-with-from-address)
