#lang racket

(require net/head
         net/unihead
         "structures.rkt"
         "parsing.rkt"
         "schedule.rkt")

(struct reminder (seconds message original-subject uids) #:prefab)



(define (messages->reminders messages now)
  (map (λ(message) (message->reminder message now)) messages))

(define (message->reminder message now)
  (define full-subject (decode-for-header (bytes->string/utf-8 (extract-field #"Subject" (message-header message)))))
  (define seconds-of-schedule (get-seconds-for (extract-schedule full-subject) now))
  (define original-subject (extract-message full-subject))
  (define remidner-header
    (insert-field "Subject" original-subject
                  (remove-field "Subject"
                                (bytes->string/utf-8 (message-header message)))))

  (reminder seconds-of-schedule (~a remidner-header (message-body message)) original-subject (list (message-uid message)))
  )

(define (reminders->file! filename reminders)
  (reminders->file/mode filename reminders 'replace))

(define (reminders->file/mode filename reminders mode)
  (if (empty? reminders)
      (delete-file filename)
      (write-to-file reminders filename #:mode 'text #:exists mode)))

(define (file->reminders filename)
  (and (file-exists? filename)
    (let()
      (define in (open-input-file filename))
      (define reminders (read in))
      (close-input-port in)
      reminders)))

(define (merge-reminders old-reminders new-reminders)
  (define new-subjects (map (λ(rem) (reminder-original-subject rem)) new-reminders))
  (define filtered-old-reminders (filter (λ(rem) (not (member (reminder-original-subject rem) new-subjects))) old-reminders))
  (append filtered-old-reminders new-reminders))

(provide file->reminders
         reminders->file!
         messages->reminders
         merge-reminders
         (struct-out reminder))
