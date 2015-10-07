#lang racket

(require net/head
         "structures.rkt"
         "parsing.rkt"
         "schedule.rkt")

(struct reminder (seconds mailbox uid) #:transparent)



(define (reminders-from-messages messages now)
  (map (λ(message) (reminder-from-message message now)) messages))

(define (reminder-from-message message now)
	(define subject (bytes->string/utf-8 (extract-field #"Subject" (message-header message))))
	(define seconds-of-schedule (get-seconds-for (extract-schedule subject) now))
	(reminder seconds-of-schedule "golemail" (message-uid message))
	)


(provide reminders-from-messages (struct-out reminder))
