#lang racket/base
(require "fixpoint.rkt" "demand.rkt" racket/match)

(module+ main
  (require racket/pretty)
  (define exp (cons `(top)
                      `(app (λ (x) x)
                            (λ (y) y))))
  (for ([q (gen-queries exp (list))])
    (match-let ([(list c p) q])
      (define evalq (>>= (unit c p) eval))
      (pretty-print "Running query: ")
      (pretty-print q)
      
      (pretty-print "Basic ")
      (demand-kind 'basic)
      (pretty-print (foldl + 0 (map length (hash-values (run evalq)))))

      (pretty-print "Hybrid ")
      (demand-kind 'hybrid)
      (pretty-print (foldl + 0 (map length (hash-values (run evalq)))))
      )
  )
)