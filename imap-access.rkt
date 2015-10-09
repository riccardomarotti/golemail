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

(define (get-new-messages connection positions)
  (map (λ(message-and-uid message-number)
          (message (first message-and-uid) (second message-and-uid) (third message-and-uid) message-number))
       (imap-get-messages connection
                          positions
                          '(header body uid)) positions))

(define (get-new-headers connection messages recent-messages-count)
  (define messages-positions (map add1 (range messages)))
  (map (λ(message-and-uid message-number)
          (message (first message-and-uid) "" (second message-and-uid) message-number))
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

(define (add-body-to messages-without-body mailbox)
  (define positions (map (λ(message) (message-position message)) messages-without-body))

  (define-values (connection messages newmessages) (connect mailbox))
  (get-new-messages connection positions))

(define (get-headers mailbox)
  (define-values (connection messages newmessages) (connect mailbox))
  (get-new-headers connection messages newmessages))

(define (append-new message mailbox)
  (define-values (connection messages newmessages) (connect mailbox))
  (imap-append connection  mailbox message (list 'flagged)))


(provide add-body-to
         get-headers
         move-messages-to
         append-new)
