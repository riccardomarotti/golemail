#lang racket

(struct message (header mailbox uid position) #:transparent)

(provide (struct-out message))
