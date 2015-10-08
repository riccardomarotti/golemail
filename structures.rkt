#lang racket

(struct message (header body uid position) #:transparent)

(provide (struct-out message))
