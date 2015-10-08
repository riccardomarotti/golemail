#lang racket

(require net/head
         racket/serialize
         "structures.rkt"
         "parsing.rkt"
         "schedule.rkt")

(serializable-struct reminder (seconds message uid) #:transparent)



(define (reminders-from-messages messages now)
  (map (λ(message) (reminder-from-message message now)) messages))

(define (reminder-from-message message now)
  (define subject (bytes->string/utf-8 (extract-field #"Subject" (message-header message))))
  (define seconds-of-schedule (get-seconds-for (extract-schedule subject) now))
  (reminder seconds-of-schedule (~a (message-header message) (message-body message)) (message-uid message))
  )

(define (reminders->file filename reminders)
  (define reminders-list (map serialize reminders))

  (write-to-file reminders-list filename #:mode 'text #:exists 'append))

(define (file->reminders filename)
  (map deserialize (file->value filename)))

(provide file->reminders
         reminders->file
         reminders-from-messages
         (struct-out reminder))
