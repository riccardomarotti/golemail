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
                              (λ(reminder) (not (equal? (reminder-uid reminder) (reminder-uid reminder-to-delete))))
                              all-reminders))
  (reminders->file "./current-reminders" filtered-reminders 'replace)
  )

(define (loop)
  (define all-messages (get-messages "Inbox"))
  (define message-reminders (filter-reminders
                             (filter-headers-with-same-to-and-from
                              (filter-headers-with-from-address (username) all-messages))))
  
  (or (empty? message-reminders)
      (begin
        (reminders->file "./current-reminders" (messages->reminders message-reminders (current-seconds)) 'append)
        (move-messages-to "golemail" message-reminders "Inbox")
        ))
  
  (define saved-reminders (file->reminders "./current-reminders"))
  (and saved-reminders (for-each check-reminder saved-reminders))
  
  (sleep 60)
  (loop))
