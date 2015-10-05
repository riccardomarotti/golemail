#lang racket

(require net/head
         "schedule.rkt"
         "parsing.rkt"
         "messages.rkt")

(define (filter-reminders messages-list)
  (filter (λ(message) (not (equal? #f (extract-schedule (bytes->string/utf-8(extract-field #"Subject"(message-header message) )))))) messages-list))

(define (filter-headers-with-same-to-and-from messages-list)
  (filter has-same-to-and-from messages-list))

(define (filter-headers-with-from-address address messages)
  (filter (λ(message) (equal? address (extract-address "From" (message-header message)))) messages))

(define (has-same-to-and-from message)
  (define to-address (extract-address "To" (message-header message)))
  (define from-address (extract-address "From" (message-header message)))
  (equal? to-address from-address))


(define (extract-address where header)
  (first (extract-addresses (extract-field where (bytes->string/utf-8 header)) 'address)))


(provide filter-headers-with-same-to-and-from
         filter-headers-with-from-address
         filter-reminders)
