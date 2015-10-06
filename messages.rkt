#lang racket

(struct message (header uid original-position) #:transparent)


(provide (struct-out message))
