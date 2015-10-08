#lang racket

(require net/imap
         "structures.rkt"
         "configuration.rkt")


(define (mark-as status connection messages-positions)
  (imap-store connection '+ messages-positions (list (symbol->imap-flag status))))

(define (move-messages-to mailbox messages from)
  (define-values (connection anything anything-else) (connect from))
  (define messages-positions (map (λ(message) (message-position message)) messages))
  (imap-copy connection messages-positions mailbox)
  (mark-as 'deleted connection messages-positions)
  (imap-expunge connection))

(define (get-new-messages connection messages recent-messages-count)
  (define messages-positions (map add1 (range messages)))
  (map (λ(message-and-uid message-number)
          (message (first message-and-uid) (second message-and-uid) message-number))
       (imap-get-messages connection
                          messages-positions
                          '(header uid)) messages-positions))

(define (connect mailbox)
  (imap-connect
   (server)
   (username)
   (password)
   mailbox
   #:tls? #t))

(define (get-messages mailbox)
    (define-values (connection messages newmessages) (connect mailbox))
    (get-new-messages connection messages newmessages))


(provide get-messages
         move-messages-to)