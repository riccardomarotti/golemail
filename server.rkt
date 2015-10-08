#lang racket

(require "imap-access.rkt"
         "headers-analysis.rkt"
         "reminders.rkt"
         "configuration.rkt"
         )

(define (check-reminder reminder)
  (and (>= (current-seconds) (reminder-seconds reminder))
    (append-new (reminder-message reminder) "Inbox"))
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

  (define saved-reminders (file->reminders "./current-reminders"))
  (for-each check-reminder saved-reminders)

  (sleep 60)
  (loop))
