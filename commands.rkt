#lang racket

(require racket/date)

(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))

(define months (hash "gennaio"    1
                     "febbraio"   2
                     "marzo"      3
                     "aprile"     4
                     "maggio"     5
                     "giugno"     6
                     "luglio"     7
                     "agosto"     8
                     "settembre"  9
                     "ottobre"   10
                     "novembre"  11
                     "dicembre"  12))

(define (tra value type current-second)
  (define multiplier
    (cond
     [(regexp-match "^min.*" type) 60]
     [else 3600]))

  (+ current-second (* multiplier (string->number value))))

(define (oggi when value current-second)
  (date->seconds (struct-copy date (seconds->date current-second)
                              [hour (string->number value)]
                              [minute 0])))

(define (domani when value current-second)
  (+ 86400 (date->seconds (struct-copy date (seconds->date current-second) [hour (string->number value)]))))

(define (dopodomani when value current-second)
  (+ 172800 (date->seconds (struct-copy date (seconds->date current-second) [hour (string->number value)]))))

(define (il day month when hour current-second)
  (define result-seconds (date->seconds (struct-copy date (seconds->date current-second)
                                                     [hour (string->number hour)]
                                                     [day (string->number day)]
                                                     [month (hash-ref months month)])))
  (if (> result-seconds current-second) result-seconds (+ 31556926 result-seconds)))

(define (execute command current-second)
  (define command-list (string-split command))
  (set! command-list (cons (string->symbol (first command-list)) (rest command-list)))
  (set! command-list (append command-list (list current-second)))
  (eval command-list ns))

(provide execute)
