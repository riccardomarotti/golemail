#lang racket

(require net/head
         "schedule.rkt"
         "parsing.rkt"
         "messages.rkt")

(define (filter-headers-with-same-to-and-from messages-list)
  (filter has-same-to-and-from messages-list))

(define (filter-headers-with-from-address address messages)
  (filter (λ(message) (equal? address (extract-address "From" (message-header message)))) messages))

(define (has-same-to-and-from message)
  (define to-address (extract-address "To" (message-header message)))
  (define from-address (extract-address "From" (message-header message)))
  (equal? to-address from-address))


(define (extract-address where header)
  (first (extract-addresses (extract-field where header) 'address)))

(define (get-reminders-headers-and-uid messages-list)
  (filter (λ(list-of-list) (is-message-a-reminder? (first list-of-list))) messages-list))

(define (is-message-a-reminder? header)
  (extract-schedule (extract-subject header)))

(define (get-reminders-schedule-and-uid remidners-headers-and-uid)
  (map (λ(header-and-uid) (list (extract-schedule (extract-subject (first header-and-uid))) (second header-and-uid))) remidners-headers-and-uid))

(define (get-reminders-times reminders-schedule-and-uid)
  (map (λ(reminder-and-uid) (list (get-seconds-for (first reminder-and-uid) (current-seconds)) (second reminder-and-uid))) reminders-schedule-and-uid)
  )

(define (extract-subject header)
  (bytes->string/utf-8
   (extract-field #"Subject" header)))


(provide filter-headers-with-same-to-and-from
         filter-headers-with-from-address)
