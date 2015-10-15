#lang racket

(require json
         net/imap)

(define (read-config)
  (define config-in (open-input-file "config.json" #:mode 'text))
  (define config (read-json config-in))
  (close-input-port config-in)

  (imap-port-number (hash-ref config 'port))

  (list
   (hash-ref config 'server)
   (hash-ref config 'username)
   (hash-ref config 'password)
   (hash-ref config 'tag)
   (hash-ref config 'polling-interval)))

(define (server)
  (first (read-config)))

(define (username)
  (second (read-config)))

(define (password)
  (third (read-config)))

(define (tag)
  (fourth (read-config)))

(define (polling-interval)
  (fifth (read-config)))



(provide server
         username
         password
         tag
         polling-interval)
