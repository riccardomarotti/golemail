#lang racket

(require net/head
         racket/serialize
         "structures.rkt"
         "parsing.rkt"
         "schedule.rkt")

(serializable-struct reminder (seconds message uids) #:transparent)



(define (messages->reminders messages now)
  (map (λ(message) (message->reminder message now)) messages))

(define (message->reminder message now)
  (define full-subject (bytes->string/utf-8 (extract-field #"Subject" (message-header message))))
  (define seconds-of-schedule (get-seconds-for (extract-schedule full-subject) now))
  (define original-subject (extract-message full-subject))
  (define remidner-header
    (insert-field "Subject" original-subject
                  (remove-field "Subject"
                                (bytes->string/utf-8 (message-header message)))))

  (reminder seconds-of-schedule (~a remidner-header (message-body message)) (list (message-uid message)))
  )

(define (reminders->file filename reminders)
  (reminders->file/mode filename reminders 'append))

(define (reminders->file! filename reminders)
  (reminders->file/mode filename reminders 'replace))

(define (reminders->file/mode filename reminders mode)
  (define reminders-list (map serialize reminders))

  (if (empty? reminders-list)
      (delete-file filename)
      (write-to-file reminders-list filename #:mode 'text #:exists mode)))

(define (file->reminders filename)
  (and (file-exists? filename) (map deserialize (file->value filename))))

(provide file->reminders
         reminders->file
         reminders->file!
         messages->reminders
         (struct-out reminder))
