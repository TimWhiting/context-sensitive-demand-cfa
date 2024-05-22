'(expression:
  (letrec*
   ((count1 (λ (count) (app set! count (app + count 1)))) (x 0))
   (app count1 x)))

'(query: ((top) letrec* (count1 ... x) ...) (env ()))
