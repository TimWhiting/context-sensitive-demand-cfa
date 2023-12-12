#lang racket/base
(require "fixpoint.rkt" "demand.rkt" "simple-examples.rkt" racket/match)

(module+ main
  (require racket/pretty)
  (for ([exp all-simple-examples])
    (pretty-print "Using expression: ")
    (pretty-print exp)
    (displayln "")
    (let ([h1 (hash)]
          [h2 (hash)])
      (for ([q (gen-queries (cons `(top) exp) (list))])
        (match-let ([(list c p) q])
          (define evalq (>>= (unit c p) eval))
          (pretty-print "Running query: ")
          (pretty-print q)
          (displayln "")
          
          (pretty-print "Basic ")
          (demand-kind 'basic)
          (set! h1 (run-with-hash evalq h1))
          (pretty-print (foldl + 0 (map length (hash-values h1))))
          (displayln "")

          (pretty-print "Hybrid ")
          (demand-kind 'hybrid)
          (set! h2 (run-with-hash evalq h2))
          (pretty-print (foldl + 0 (map length (hash-values h2))))
          (displayln "")
          )
      )
    )
  )
)