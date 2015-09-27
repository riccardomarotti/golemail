#lang racket

(require racket/date)

(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))

(define (tra value type current-second)
  (define multiplier
    (cond
     [(regexp-match "^min.*" type) 60]
     [else 3600]))

  (+ current-second (* multiplier (string->number value))))

(define (execute command current-second)
  (define command-list (string-split command))
  (set! command-list (cons (string->symbol (first command-list)) (rest command-list)))
  (set! command-list (append command-list (list current-second)))
  (eval command-list ns))

(provide execute)
