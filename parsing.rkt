#lang racket

(define (should-parse? string_to_parse)
  (define list (string->list string_to_parse))
  (cond
    [(empty? list) #f]
    [(string=? ".>>>" string_to_parse) #t]
    [else (should-parse? (list->string (rest list)))]))

(define timing-words
  (list
    "tra"
    "alle"
    "il"
    "lunedì"
    "lunedi"
    "martedì"
    "martedi"
    "mercoledì"
    "mercoledi"
    "giovedì"
    "giovedi"
    "venerdì"
    "venerdi"
    "sabato"
    "domenica"))

(define (contains-timing? string)
	(contains-timing?recursive (reverse (string-split string))))

(define (contains-timing?recursive words)
  (cond
  	[(empty? words) #f]
  	[(not (equal? #f (member (string-downcase (first words)) timing-words))) #t]
  	[else (contains-timing?recursive (rest words))]))


(provide should-parse? contains-timing?)
