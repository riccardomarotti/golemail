#lang racket

(struct message (header uid) #:transparent)


(provide (struct-out message))
