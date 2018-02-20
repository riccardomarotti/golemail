#lang racket

(require net/head
         net/unihead
         "schedule.rkt"
         "parsing.rkt"
         "structures.rkt")

(define (subject-of message)
  (decode-for-header (clean (bytes->string/utf-8 (extract-field #"Subject"(message-header message))))))

(define (filter-reminders messages-list)
  (filter (λ(message) (not (equal? #f (extract-schedule (subject-of message))))) messages-list))

(define (filter-headers-with-from-address address messages)
  (filter (λ(message) (equal? address (extract-address "From" (message-header message)))) messages))

(define (filter-headers-with-subject subject messages)
  (filter (λ(message) (equal? subject (subject-of message))) messages))

(define (extract-address where header)
  (first (extract-addresses (extract-field where (bytes->string/utf-8 header)) 'address)))

(define (filter-headers-with-from-addresses addresses messages)
  (filter-headers-with-from-addresses-recursive addresses messages '()))

(define (filter-headers-with-from-addresses-recursive addresses messages acc)
  (cond [(empty? addresses) acc]
        [else
          (define current-address (first addresses))
          (define filtered-messages (filter-headers-with-from-address current-address messages))
          (filter-headers-with-from-addresses-recursive (rest addresses) messages (append acc filtered-messages))
        ]))



(provide filter-headers-with-from-addresses
         filter-headers-with-subject
         filter-reminders
         subject-of)