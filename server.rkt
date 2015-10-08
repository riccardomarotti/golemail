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

  (cond [(empty? message-reminders) 'ok]
        [else
         (define reminders (reminders-from-messages message-reminders (current-seconds)))
         (reminders->file "./current-reminders" reminders)
         (move-messages-to "golemail" message-reminders "Inbox")]
        )

  (sleep 60)
  (loop))
