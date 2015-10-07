#lang racket

(struct message (header mailbox uid position) #:transparent)
(struct reminder (seconds mailbox uid) #:transparent)


(provide (struct-out message))
