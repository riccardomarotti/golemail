#lang racket

(struct message (header uid position) #:transparent)


(provide (struct-out message))
