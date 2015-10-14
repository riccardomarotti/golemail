#lang racket

(require "imap-access.rkt"
         "headers-analysis.rkt"
         "reminders.rkt"
         "configuration.rkt"
         "structures.rkt"
         net/head
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

(define (update-reminders-with-original-messages current-reminders all-headers output-reminders)
  (if (empty? current-reminders) output-reminders
      (let()
        (define current-reminder (first current-reminders))
        (define original-message (filter (λ(message)
                                           (equal?
                                            (reminder-original-subject current-reminder)
                                            (bytes->string/utf-8 (extract-field #"Subject" (message-header message)))))
                                         all-headers
                                         ))
        (if (empty? original-message)
            (update-reminders-with-original-messages (rest current-reminders) all-headers (cons current-reminder output-reminders))
            (let()
              (define full-original-message (first (add-body-to original-message "Inbox")))
              (move-messages-to "golemail" (list full-original-message) "Inbox")
              (define new-reminder (struct-copy reminder current-reminder
                                                [message (~a
                                                          (message-header full-original-message)
                                                          (message-body full-original-message))]))
              (update-reminders-with-original-messages (rest current-reminders) all-headers (cons new-reminder output-reminders))
              )))))



(define (loop)
  (define message-reminders-headers (filter-reminders
                                     (filter-headers-with-same-to-and-from
                                      (filter-headers-with-from-address (username) (get-headers "Inbox")))))

  (or (empty? message-reminders-headers)
      (let()
        (define message-reminders (add-body-to message-reminders-headers "Inbox"))
        (move-messages-to "golemail" message-reminders "Inbox")
        (define reminders (messages->reminders message-reminders (current-seconds)))
        (set! reminders (update-reminders-with-original-messages reminders (get-headers "Inbox") '()))
        (define old-reminders (file->reminders "./current-reminders"))
        (reminders->file! "./current-reminders" (append old-reminders reminders))
        ))

  (define saved-reminders (file->reminders "./current-reminders"))
  (and saved-reminders (for-each check-reminder saved-reminders))

  (sleep 10)
  (loop))
