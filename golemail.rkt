#lang racket

(require "server.rkt")

(define (handled-loop)
  (with-handlers ([exn? (λ(exn)
                          (let()
                            (displayln exn)
                            (sleep 10)
                            (handled-loop)))])
    (loop)
    ))


(handled-loop)
