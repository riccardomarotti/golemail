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

  (cond [(empty? message-reminders) (sleep 60)]
        [else
         (move-messages-to "golemail" message-reminders "Inbox")
         (define reminders (reminders-from-messages message-reminders (current-seconds)))
         (for-each (λ(reminder)
                      (write-to-file reminder "./current-reminders" #:mode 'text #:exists 'append))
                   reminders)])
  (loop))
