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
	(define h (string->number (first (parse-time value))))
	(define m (string->number (second (parse-time value))))
  (date->seconds (struct-copy date (seconds->date current-second)
                              [hour h]
                              [minute m])))

(define (doman when value current-second)
  (+ 86400 (date->seconds (struct-copy date (seconds->date current-second) [hour (string->number value)]))))

(define (dopod when value current-second)
  (+ 172800 (date->seconds (struct-copy date (seconds->date current-second) [hour (string->number value)]))))

(define (il day month when hour current-second)
  (define result-seconds (date->seconds (struct-copy date (seconds->date current-second)
                                                     [hour (string->number hour)]
                                                     [day (string->number day)]
                                                     [month (hash-ref months month)])))
  (if (> result-seconds current-second) result-seconds (+ 31556926 result-seconds)))

(define (execute command current-second)
  (define command-list (string-split command))
  (define function (substring (first command-list) 0 (min (string-length (first command-list)) 5)))
  (set! command-list (cons (string->symbol function) (rest command-list)))
  (set! command-list (append command-list (list current-second)))
  (eval command-list ns))

(define (parse-time time-string)
	(define tokens (string-split time-string ":"))
	(define minutes (cdr tokens))
	(and (empty? minutes) (set! minutes (list "0")))
	(cons (car tokens) minutes))

(provide execute)