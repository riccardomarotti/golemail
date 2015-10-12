#lang racket

(require "imap-access.rkt"
         "headers-analysis.rkt"
         "reminders.rkt"
         "configuration.rkt"
         )

(define (check-reminder reminder)
  (and (>= (current-seconds) (reminder-seconds reminder))
       (begin
         (append-new (reminder-message reminder) "Inbox")
         (remove-from-saved reminder)
         )))

(define (remove-from-saved reminder-to-delete)
  (define all-reminders (file->reminders "./current-reminders"))
  (define filtered-reminders (filter
                              (λ(reminder) (not (equal? (reminder-uids reminder) (reminder-uids reminder-to-delete))))
                              all-reminders))
  (reminders->file! "./current-reminders" filtered-reminders)
  )

(define (loop)
  (define all-headers (get-headers "Inbox"))
  (define message-reminders-headers (filter-reminders
                             (filter-headers-with-same-to-and-from
                              (filter-headers-with-from-address (username) all-headers))))

  (or (empty? message-reminders-headers)
      (let()
        (define message-reminders (add-body-to message-reminders-headers "Inbox"))
        (reminders->file "./current-reminders" (messages->reminders message-reminders (current-seconds)))
        (move-messages-to "golemail" message-reminders "Inbox")
        ))

  (define saved-reminders (file->reminders "./current-reminders"))
  (and saved-reminders (for-each check-reminder saved-reminders))

  (sleep 10)
  (loop))
