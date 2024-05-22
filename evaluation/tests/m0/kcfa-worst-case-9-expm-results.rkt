'(expression:
  (app
   (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
   (λ (x1)
     (app
      (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
      (λ (x2)
        (app
         (λ (f3) (let ((_ (app f3 (app #t)))) (app f3 (app #f))))
         (λ (x3)
           (app
            (λ (f4) (let ((_ (app f4 (app #t)))) (app f4 (app #f))))
            (λ (x4)
              (app
               (λ (f5) (let ((_ (app f5 (app #t)))) (app f5 (app #f))))
               (λ (x5)
                 (app
                  (λ (f6) (let ((_ (app f6 (app #t)))) (app f6 (app #f))))
                  (λ (x6)
                    (app
                     (λ (f7) (let ((_ (app f7 (app #t)))) (app f7 (app #f))))
                     (λ (x7)
                       (app
                        (λ (f8)
                          (let ((_ (app f8 (app #t)))) (app f8 (app #f))))
                        (λ (x8)
                          (app
                           (λ (f9)
                             (let ((_ (app f9 (app #t)))) (app f9 (app #f))))
                           (λ (x9)
                             (app
                              (λ (z) (app z x1 x2 x3 x4 x5 x6 x7 x8 x9))
                              (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9)
                                y1)))))))))))))))))))))

'(query:
  (app (-> (λ (f9) ...) <-) (λ (x9) ...))
  (env (() () () () () () () ())))
clos/con:
	'((app (-> (λ (f9) ...) <-) (λ (x9) ...)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (z) ...) <-) (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...))
  (env (() () () () () () () () ())))
clos/con:
	'((app (-> (λ (z) ...) <-) (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...))
  (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> z <-) x1 x2 x3 x4 x5 x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...) <-))
  (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f9) ...) (-> (λ (x9) ...) <-))
  (env (() () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (z) ...) (-> (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...) <-))
  (env (() () () () () () () () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...) <-))
  (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z (-> x1 <-) x2 x3 x4 x5 x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 (-> x2 <-) x3 x4 x5 x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 (-> x3 <-) x4 x5 x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 (-> x4 <-) x5 x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 x4 (-> x5 <-) x6 x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 x4 x5 (-> x6 <-) x7 x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 x4 x5 x6 (-> x7 <-) x8 x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 x4 x5 x6 x7 (-> x8 <-) x9)
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app z x1 x2 x3 x4 x5 x6 x7 x8 (-> x9 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f3 (app #t)) <-)) () ...) ...)
  (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f4 (app #t)) <-)) () ...) ...)
  (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f5 (app #t)) <-)) () ...) ...)
  (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f6 (app #t)) <-)) () ...) ...)
  (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f7 (app #t)) <-)) () ...) ...)
  (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f8 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f9 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f9 (app #f)) <-))
  (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x5) (-> (app (λ (f6) ...) (λ (x6) ...)) <-))
  (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x6) (-> (app (λ (f7) ...) (λ (x7) ...)) <-))
  (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x7) (-> (app (λ (f8) ...) (λ (x8) ...)) <-))
  (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x8) (-> (app (λ (f9) ...) (λ (x9) ...)) <-))
  (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x9) (-> (app (λ (z) ...) (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...)) <-))
  (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z) (-> (app z x1 x2 x3 x4 x5 x6 x7 x8 x9) <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env (() ())))
clos/con:
	'((app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f4) ...) <-) (λ (x4) ...)) (env (() () ())))
clos/con:
	'((app (-> (λ (f4) ...) <-) (λ (x4) ...)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f5) ...) <-) (λ (x5) ...)) (env (() () () ())))
clos/con:
	'((app (-> (λ (f5) ...) <-) (λ (x5) ...)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f6) ...) <-) (λ (x6) ...)) (env (() () () () ())))
clos/con:
	'((app (-> (λ (f6) ...) <-) (λ (x6) ...)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f7) ...) <-) (λ (x7) ...)) (env (() () () () () ())))
clos/con:
	'((app (-> (λ (f7) ...) <-) (λ (x7) ...)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f8) ...) <-) (λ (x8) ...)) (env (() () () () () () ())))
clos/con:
	'((app (-> (λ (f8) ...) <-) (λ (x8) ...)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #f)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #f)) (env (() () ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #t)) (env (() () ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f4 <-) (app #f)) (env (() () () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f4 <-) (app #t)) (env (() () () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f5 <-) (app #f)) (env (() () () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f5 <-) (app #t)) (env (() () () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f6 <-) (app #f)) (env (() () () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f6 <-) (app #t)) (env (() () () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f7 <-) (app #f)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f7 <-) (app #t)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f8 <-) (app #f)) (env (() () () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f8 <-) (app #t)) (env (() () () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f9 <-) (app #f)) (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f9 <-) (app #t)) (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #f) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env (() ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #f) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #t) <-)) (env (() () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f4 (-> (app #f) <-)) (env (() () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f4 (-> (app #t) <-)) (env (() () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f5 (-> (app #f) <-)) (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f5 (-> (app #t) <-)) (env (() () () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f6 (-> (app #f) <-)) (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f6 (-> (app #t) <-)) (env (() () () () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f7 (-> (app #f) <-)) (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f7 (-> (app #t) <-)) (env (() () () () () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f8 (-> (app #f) <-)) (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f8 (-> (app #t) <-)) (env (() () () () () () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f9 (-> (app #f) <-)) (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f9 (-> (app #t) <-)) (env (() () () () () () () () ())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f2 (app #t)) <-)) () ...) ...) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f1 (app #f)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f2 (app #f)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f3 (app #f)) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f4 (app #f)) <-)) (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f5 (app #f)) <-)) (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f6 (app #f)) <-)) (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f7 (app #f)) <-)) (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f8 (app #f)) <-)) (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f2) (-> (let (_) ...) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f3) (-> (let (_) ...) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f4) (-> (let (_) ...) <-)) (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f5) (-> (let (_) ...) <-)) (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f6) (-> (let (_) ...) <-)) (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f7) (-> (let (_) ...) <-)) (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f8) (-> (let (_) ...) <-)) (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f9) (-> (let (_) ...) <-)) (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x3) (-> (app (λ (f4) ...) (λ (x4) ...)) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x4) (-> (app (λ (f5) ...) (λ (x5) ...)) <-)) (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f2 (app #t)) <-)) () ...) ...)
  (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f3 (app #t)) <-)) () ...) ...)
  (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f4 (app #t)) <-)) () ...) ...)
  (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f5 (app #t)) <-)) () ...) ...)
  (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f6 (app #t)) <-)) () ...) ...)
  (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f7 (app #t)) <-)) () ...) ...)
  (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f8 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  _
  (let (... () (_ (-> (app f9 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x4
  (λ (x4) (-> (app (λ (f5) ...) (λ (x5) ...)) <-))
  (env (() () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x5
  (λ (x5) (-> (app (λ (f6) ...) (λ (x6) ...)) <-))
  (env (() () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x6
  (λ (x6) (-> (app (λ (f7) ...) (λ (x7) ...)) <-))
  (env (() () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x7
  (λ (x7) (-> (app (λ (f8) ...) (λ (x8) ...)) <-))
  (env (() () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x8
  (λ (x8) (-> (app (λ (f9) ...) (λ (x9) ...)) <-))
  (env (() () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x9
  (λ (x9) (-> (app (λ (z) ...) (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...)) <-))
  (env (() () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y1
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y2
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y3
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y4
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y5
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y6
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y7
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y8
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  y9
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) (-> y1 <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  z
  (λ (z) (-> (app z x1 x2 x3 x4 x5 x6 x7 x8 x9) <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((app (λ (z) ...) (-> (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9) ...) <-))
  (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: _ (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f1 (λ (f1) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: f2 (λ (f2) (-> (let (_) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: f3 (λ (f3) (-> (let (_) ...) <-)) (env (() () ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(store: f4 (λ (f4) (-> (let (_) ...) <-)) (env (() () () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(store: f5 (λ (f5) (-> (let (_) ...) <-)) (env (() () () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: f6 (λ (f6) (-> (let (_) ...) <-)) (env (() () () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: f7 (λ (f7) (-> (let (_) ...) <-)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: f8 (λ (f8) (-> (let (_) ...) <-)) (env (() () () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: f9 (λ (f9) (-> (let (_) ...) <-)) (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(store: x1 (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x2 (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)) (env (() ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: x3 (λ (x3) (-> (app (λ (f4) ...) (λ (x4) ...)) <-)) (env (() () ())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)
