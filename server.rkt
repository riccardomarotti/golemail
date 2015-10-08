#lang racket

(require "imap-access.rkt"
         "headers-analysis.rkt"
         "reminders.rkt"
         "configuration.rkt"
         )


(define (loop)
  (define all-messages (get-messages "Inbox"))
  (define message-reminders (filter-reminders
                             (filter-headers-with-same-to-and-from
                              (filter-headers-with-from-address (username) all-messages))))

  (or (empty? message-reminders)
    (begin
         (reminders->file "./current-reminders" (messages->reminders message-reminders (current-seconds)))
         (move-messages-to "golemail" message-reminders "Inbox")
        ))

  (sleep 60)
  (loop))
