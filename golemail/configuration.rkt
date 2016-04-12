#lang racket

(require json
         net/imap)


(define password (make-parameter ""))

(define (read-config field)
  (define config-in (open-input-file "config.json" #:mode 'text))
  (define config (read-json config-in))
  (close-input-port config-in)

  (imap-port-number (hash-ref config 'port))

  (hash-ref config field))

(define (server)
  (read-config 'server))

(define (username)
  (read-config 'username))

(define (tag)
  (read-config 'tag))

(define (polling-interval)
  (read-config 'polling-interval))

(define (allowed-senders)
  (read-config 'allowed-senders))


(provide server
         username
         password
         tag
         polling-interval
         allowed-senders)
