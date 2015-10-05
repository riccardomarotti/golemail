#lang racket

(struct message (header uid))


(provide (struct-out message))
