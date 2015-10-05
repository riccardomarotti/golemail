#lang racket

(require json
         net/imap
         "messages.rkt"
         "headers-analysis.rkt")

(define (start)
  (define config-in (open-input-file "config.json" #:mode 'text))
  (define config (read-json config-in))

  (imap-port-number (hash-ref config 'port))

  (loop (hash-ref config 'server) (hash-ref config 'username) (hash-ref config 'password)))


(define (connect server username password)
  (imap-connect
   server
   username
   password
   "Inbox"
   #:tls? #t))

(define (get-new-messages connection messages recent-messages-count)
  (map (λ(message-and-uid) (message (first message-and-uid) (second message-and-uid))) (imap-get-messages connection
                                                                                                          (map add1 (range messages))
                                                                                                          '(header uid))))


(define (loop server username password)
  (define-values (connection messages newmessages) (connect server username password))

  (define all-messages (get-new-messages connection messages newmessages))
  (define reminders (filter-reminders
                     (filter-headers-with-same-to-and-from
                      (filter-headers-with-from-address username all-messages))))

  (write-to-file reminders "./current-reminders" #:mode 'text #:exists 'append )
  )
