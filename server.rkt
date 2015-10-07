#lang racket

(require json
         net/imap
         "structures.rkt"
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
  (define messages-positions (map add1 (range messages)))
  (map (λ(message-and-uid message-number)
    (message (first message-and-uid) "Inbox" (second message-and-uid) message-number))
       (imap-get-messages connection
                          messages-positions
                          '(header uid)) messages-positions))

(define (mark-as status connection messages-positions)
  (imap-store connection '+ messages-positions (list (symbol->imap-flag status))))

(define (move-messages-to mailbox messages connection)
  (define messages-positions (map (λ(message) (message-position message)) messages))
  (imap-copy connection messages-positions mailbox)
  (mark-as 'deleted connection messages-positions)
  (imap-expunge connection))



(define (loop server username password)
  (define-values (connection messages newmessages) (connect server username password))

  (define all-messages (get-new-messages connection messages newmessages))
  (define reminders (filter-reminders
                     (filter-headers-with-same-to-and-from
                      (filter-headers-with-from-address username all-messages))))

  (move-messages-to "reminders" reminders connection)
  )
