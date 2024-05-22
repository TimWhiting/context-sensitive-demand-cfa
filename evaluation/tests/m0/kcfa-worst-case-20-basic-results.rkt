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
                              (λ (f10)
                                (let ((_ (app f10 (app #t))))
                                  (app f10 (app #f))))
                              (λ (x10)
                                (app
                                 (λ (f11)
                                   (let ((_ (app f11 (app #t))))
                                     (app f11 (app #f))))
                                 (λ (x11)
                                   (app
                                    (λ (f12)
                                      (let ((_ (app f12 (app #t))))
                                        (app f12 (app #f))))
                                    (λ (x12)
                                      (app
                                       (λ (f13)
                                         (let ((_ (app f13 (app #t))))
                                           (app f13 (app #f))))
                                       (λ (x13)
                                         (app
                                          (λ (f14)
                                            (let ((_ (app f14 (app #t))))
                                              (app f14 (app #f))))
                                          (λ (x14)
                                            (app
                                             (λ (f15)
                                               (let ((_ (app f15 (app #t))))
                                                 (app f15 (app #f))))
                                             (λ (x15)
                                               (app
                                                (λ (f16)
                                                  (let ((_ (app f16 (app #t))))
                                                    (app f16 (app #f))))
                                                (λ (x16)
                                                  (app
                                                   (λ (f17)
                                                     (let ((_
                                                            (app
                                                             f17
                                                             (app #t))))
                                                       (app f17 (app #f))))
                                                   (λ (x17)
                                                     (app
                                                      (λ (f18)
                                                        (let ((_
                                                               (app
                                                                f18
                                                                (app #t))))
                                                          (app f18 (app #f))))
                                                      (λ (x18)
                                                        (app
                                                         (λ (f19)
                                                           (let ((_
                                                                  (app
                                                                   f19
                                                                   (app #t))))
                                                             (app
                                                              f19
                                                              (app #f))))
                                                         (λ (x19)
                                                           (app
                                                            (λ (f20)
                                                              (let ((_
                                                                     (app
                                                                      f20
                                                                      (app
                                                                       #t))))
                                                                (app
                                                                 f20
                                                                 (app #f))))
                                                            (λ (x20)
                                                              (app
                                                               (λ (z)
                                                                 (app
                                                                  z
                                                                  x1
                                                                  x2
                                                                  x3
                                                                  x4
                                                                  x5
                                                                  x6
                                                                  x7
                                                                  x8
                                                                  x9
                                                                  x10
                                                                  x11
                                                                  x12
                                                                  x13
                                                                  x14
                                                                  x15
                                                                  x16
                                                                  x17
                                                                  x18
                                                                  x19
                                                                  x20))
                                                               (λ (y1
                                                                   y2
                                                                   y3
                                                                   y4
                                                                   y5
                                                                   y6
                                                                   y7
                                                                   y8
                                                                   y9
                                                                   y10
                                                                   y11
                                                                   y12
                                                                   y13
                                                                   y14
                                                                   y15
                                                                   y16
                                                                   y17
                                                                   y18
                                                                   y19
                                                                   y20)
                                                                 y1)))))))))))))))))))))))))))))))))))))))))))

'(query: ((top) app (λ (f1) ...) (λ (x1) ...)) (env ()))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x1) (-> (app (λ (f2) ...) (λ (x2) ...)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x2) (-> (app (λ (f3) ...) (λ (x3) ...)) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x3) (-> (app (λ (f4) ...) (λ (x4) ...)) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (x4) (-> (app (λ (f5) ...) (λ (x5) ...)) <-)) (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x5) (-> (app (λ (f6) ...) (λ (x6) ...)) <-))
  (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x6) (-> (app (λ (f7) ...) (λ (x7) ...)) <-))
  (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x7) (-> (app (λ (f8) ...) (λ (x8) ...)) <-))
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x8) (-> (app (λ (f9) ...) (λ (x9) ...)) <-))
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f9) ...) (-> (λ (x9) ...) <-))
  (env (() () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x9) (-> (app (λ (f10) ...) (λ (x10) ...)) <-))
  (env (() () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f10) ...) (-> (λ (x10) ...) <-))
  (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f10) ...) (-> (λ (x10) ...) <-)) (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x10) (-> (app (λ (f11) ...) (λ (x11) ...)) <-))
  (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f11) ...) (-> (λ (x11) ...) <-))
  (env (() () () () () () () () () ())))
clos/con:
	'((app (λ (f11) ...) (-> (λ (x11) ...) <-))
  (env (() () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x11) (-> (app (λ (f12) ...) (λ (x12) ...)) <-))
  (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f12) ...) (-> (λ (x12) ...) <-))
  (env (() () () () () () () () () () ())))
clos/con:
	'((app (λ (f12) ...) (-> (λ (x12) ...) <-))
  (env (() () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x12) (-> (app (λ (f13) ...) (λ (x13) ...)) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f13) ...) (-> (λ (x13) ...) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'((app (λ (f13) ...) (-> (λ (x13) ...) <-))
  (env (() () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x13) (-> (app (λ (f14) ...) (λ (x14) ...)) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f14) ...) (-> (λ (x14) ...) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f14) ...) (-> (λ (x14) ...) <-))
  (env (() () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x14) (-> (app (λ (f15) ...) (λ (x15) ...)) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f15) ...) (-> (λ (x15) ...) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f15) ...) (-> (λ (x15) ...) <-))
  (env (() () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x15) (-> (app (λ (f16) ...) (λ (x16) ...)) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f16) ...) (-> (λ (x16) ...) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f16) ...) (-> (λ (x16) ...) <-))
  (env (() () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x16) (-> (app (λ (f17) ...) (λ (x17) ...)) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f17) ...) (-> (λ (x17) ...) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f17) ...) (-> (λ (x17) ...) <-))
  (env (() () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x17) (-> (app (λ (f18) ...) (λ (x18) ...)) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f18) ...) (-> (λ (x18) ...) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f18) ...) (-> (λ (x18) ...) <-))
  (env (() () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x18) (-> (app (λ (f19) ...) (λ (x19) ...)) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f19) ...) (-> (λ (x19) ...) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f19) ...) (-> (λ (x19) ...) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x19) (-> (app (λ (f20) ...) (λ (x20) ...)) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (λ (f20) ...) (-> (λ (x20) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f20) ...) (-> (λ (x20) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (x20)
    (->
     (app
      (λ (z) ...)
      (λ (y1
          y2
          y3
          y4
          y5
          y6
          y7
          y8
          y9
          y10
          y11
          y12
          y13
          y14
          y15
          y16
          y17
          y18
          y19
          y20)
        ...))
     <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (λ (z) ...)
   (->
    (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
      ...)
    <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app
   (λ (z) ...)
   (->
    (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
      ...)
    <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
    (-> y1 <-))
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> (λ (z) ...) <-)
   (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
     ...))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app
   (-> (λ (z) ...) <-)
   (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
     ...))
  (env (() () () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (z)
    (->
     (app
      z
      x1
      x2
      x3
      x4
      x5
      x6
      x7
      x8
      x9
      x10
      x11
      x12
      x13
      x14
      x15
      x16
      x17
      x18
      x19
      x20)
     <-))
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   (-> x20 <-))
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   (-> x19 <-)
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   (-> x18 <-)
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   (-> x17 <-)
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   (-> x16 <-)
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   (-> x15 <-)
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   (-> x14 <-)
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   (-> x13 <-)
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   (-> x12 <-)
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   (-> x11 <-)
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   (-> x10 <-)
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   (-> x9 <-)
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   (-> x8 <-)
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   x6
   (-> x7 <-)
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   x5
   (-> x6 <-)
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   x4
   (-> x5 <-)
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   x3
   (-> x4 <-)
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   x2
   (-> x3 <-)
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   x1
   (-> x2 <-)
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   z
   (-> x1 <-)
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app
   (-> z <-)
   x1
   x2
   x3
   x4
   x5
   x6
   x7
   x8
   x9
   x10
   x11
   x12
   x13
   x14
   x15
   x16
   x17
   x18
   x19
   x20)
  (env (() () () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app
   (λ (z) ...)
   (->
    (λ (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y19 y20)
      ...)
    <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f20) ...) <-) (λ (x20) ...))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f20) ...) <-) (λ (x20) ...))
  (env (() () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f20) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f20 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f20 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f20 <-) (app #t))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f20) ...) (-> (λ (x20) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f20 (app #f)) <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f20 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f20 <-) (app #f))
  (env (() () () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f20) ...) (-> (λ (x20) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f19) ...) <-) (λ (x19) ...))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f19) ...) <-) (λ (x19) ...))
  (env (() () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f19) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f19 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f19 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f19 <-) (app #t))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f19) ...) (-> (λ (x19) ...) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f19 (app #f)) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f19 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f19 <-) (app #f))
  (env (() () () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f19) ...) (-> (λ (x19) ...) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f18) ...) <-) (λ (x18) ...))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f18) ...) <-) (λ (x18) ...))
  (env (() () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f18) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f18 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f18 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f18 <-) (app #t))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f18) ...) (-> (λ (x18) ...) <-))
  (env (() () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f18 (app #f)) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f18 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f18 <-) (app #f))
  (env (() () () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f18) ...) (-> (λ (x18) ...) <-))
  (env (() () () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f17) ...) <-) (λ (x17) ...))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f17) ...) <-) (λ (x17) ...))
  (env (() () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f17) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f17 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f17 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f17 <-) (app #t))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f17) ...) (-> (λ (x17) ...) <-))
  (env (() () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f17 (app #f)) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f17 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f17 <-) (app #f))
  (env (() () () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f17) ...) (-> (λ (x17) ...) <-))
  (env (() () () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f16) ...) <-) (λ (x16) ...))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f16) ...) <-) (λ (x16) ...))
  (env (() () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f16) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f16 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f16 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #t <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f16 <-) (app #t))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f16) ...) (-> (λ (x16) ...) <-))
  (env (() () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f16 (app #f)) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f16 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> #f <-))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f16 <-) (app #f))
  (env (() () () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f16) ...) (-> (λ (x16) ...) <-))
  (env (() () () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f15) ...) <-) (λ (x15) ...))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f15) ...) <-) (λ (x15) ...))
  (env (() () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f15) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f15 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f15 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f15 <-) (app #t))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f15) ...) (-> (λ (x15) ...) <-))
  (env (() () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f15 (app #f)) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f15 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f15 <-) (app #f))
  (env (() () () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f15) ...) (-> (λ (x15) ...) <-))
  (env (() () () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f14) ...) <-) (λ (x14) ...))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f14) ...) <-) (λ (x14) ...))
  (env (() () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f14) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f14 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f14 (-> (app #t) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f14 <-) (app #t))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f14) ...) (-> (λ (x14) ...) <-))
  (env (() () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f14 (app #f)) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f14 (-> (app #f) <-))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f14 <-) (app #f))
  (env (() () () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f14) ...) (-> (λ (x14) ...) <-))
  (env (() () () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f13) ...) <-) (λ (x13) ...))
  (env (() () () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f13) ...) <-) (λ (x13) ...))
  (env (() () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f13) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f13 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f13 (-> (app #t) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f13 <-) (app #t))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f13) ...) (-> (λ (x13) ...) <-))
  (env (() () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f13 (app #f)) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f13 (-> (app #f) <-))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f13 <-) (app #f))
  (env (() () () () () () () () () () () () ())))
clos/con:
	'((app (λ (f13) ...) (-> (λ (x13) ...) <-))
  (env (() () () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f12) ...) <-) (λ (x12) ...))
  (env (() () () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f12) ...) <-) (λ (x12) ...))
  (env (() () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f12) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f12 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f12 (-> (app #t) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f12 <-) (app #t))
  (env (() () () () () () () () () () () ())))
clos/con:
	'((app (λ (f12) ...) (-> (λ (x12) ...) <-))
  (env (() () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f12 (app #f)) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app f12 (-> (app #f) <-))
  (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> f12 <-) (app #f))
  (env (() () () () () () () () () () () ())))
clos/con:
	'((app (λ (f12) ...) (-> (λ (x12) ...) <-))
  (env (() () () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f11) ...) <-) (λ (x11) ...))
  (env (() () () () () () () () () ())))
clos/con:
	'((app (-> (λ (f11) ...) <-) (λ (x11) ...))
  (env (() () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (f11) (-> (let (_) ...) <-))
  (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f11 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f11 (-> (app #t) <-)) (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f11 <-) (app #t)) (env (() () () () () () () () () () ())))
clos/con:
	'((app (λ (f11) ...) (-> (λ (x11) ...) <-))
  (env (() () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f11 (app #f)) <-))
  (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f11 (-> (app #f) <-)) (env (() () () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f11 <-) (app #f)) (env (() () () () () () () () () () ())))
clos/con:
	'((app (λ (f11) ...) (-> (λ (x11) ...) <-))
  (env (() () () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f10) ...) <-) (λ (x10) ...))
  (env (() () () () () () () () ())))
clos/con:
	'((app (-> (λ (f10) ...) <-) (λ (x10) ...)) (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f10) (-> (let (_) ...) <-)) (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f10 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f10 (-> (app #t) <-)) (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f10 <-) (app #t)) (env (() () () () () () () () () ())))
clos/con:
	'((app (λ (f10) ...) (-> (λ (x10) ...) <-)) (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f10 (app #f)) <-))
  (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f10 (-> (app #f) <-)) (env (() () () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f10 <-) (app #f)) (env (() () () () () () () () () ())))
clos/con:
	'((app (λ (f10) ...) (-> (λ (x10) ...) <-)) (env (() () () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (app (-> (λ (f9) ...) <-) (λ (x9) ...))
  (env (() () () () () () () ())))
clos/con:
	'((app (-> (λ (f9) ...) <-) (λ (x9) ...)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f9) (-> (let (_) ...) <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f9 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f9 (-> (app #t) <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f9 <-) (app #t)) (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (_) (-> (app f9 (app #f)) <-))
  (env (() () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f9 (-> (app #f) <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f9 <-) (app #f)) (env (() () () () () () () () ())))
clos/con:
	'((app (λ (f9) ...) (-> (λ (x9) ...) <-)) (env (() () () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f8) ...) <-) (λ (x8) ...)) (env (() () () () () () ())))
clos/con:
	'((app (-> (λ (f8) ...) <-) (λ (x8) ...)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f8) (-> (let (_) ...) <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f8 (app #t)) <-)) () ...) ...)
  (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f8 (-> (app #t) <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f8 <-) (app #t)) (env (() () () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f8 (app #f)) <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f8 (-> (app #f) <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f8 <-) (app #f)) (env (() () () () () () () ())))
clos/con:
	'((app (λ (f8) ...) (-> (λ (x8) ...) <-)) (env (() () () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f7) ...) <-) (λ (x7) ...)) (env (() () () () () ())))
clos/con:
	'((app (-> (λ (f7) ...) <-) (λ (x7) ...)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f7) (-> (let (_) ...) <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f7 (app #t)) <-)) () ...) ...)
  (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f7 (-> (app #t) <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f7 <-) (app #t)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f7 (app #f)) <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f7 (-> (app #f) <-)) (env (() () () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f7 <-) (app #f)) (env (() () () () () () ())))
clos/con:
	'((app (λ (f7) ...) (-> (λ (x7) ...) <-)) (env (() () () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f6) ...) <-) (λ (x6) ...)) (env (() () () () ())))
clos/con:
	'((app (-> (λ (f6) ...) <-) (λ (x6) ...)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f6) (-> (let (_) ...) <-)) (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f6 (app #t)) <-)) () ...) ...)
  (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f6 (-> (app #t) <-)) (env (() () () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f6 <-) (app #t)) (env (() () () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f6 (app #f)) <-)) (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f6 (-> (app #f) <-)) (env (() () () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f6 <-) (app #f)) (env (() () () () () ())))
clos/con:
	'((app (λ (f6) ...) (-> (λ (x6) ...) <-)) (env (() () () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f5) ...) <-) (λ (x5) ...)) (env (() () () ())))
clos/con:
	'((app (-> (λ (f5) ...) <-) (λ (x5) ...)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f5) (-> (let (_) ...) <-)) (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f5 (app #t)) <-)) () ...) ...)
  (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f5 (-> (app #t) <-)) (env (() () () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f5 <-) (app #t)) (env (() () () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f5 (app #f)) <-)) (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f5 (-> (app #f) <-)) (env (() () () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f5 <-) (app #f)) (env (() () () () ())))
clos/con:
	'((app (λ (f5) ...) (-> (λ (x5) ...) <-)) (env (() () () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f4) ...) <-) (λ (x4) ...)) (env (() () ())))
clos/con:
	'((app (-> (λ (f4) ...) <-) (λ (x4) ...)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f4) (-> (let (_) ...) <-)) (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f4 (app #t)) <-)) () ...) ...)
  (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f4 (-> (app #t) <-)) (env (() () () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f4 <-) (app #t)) (env (() () () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f4 (app #f)) <-)) (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f4 (-> (app #f) <-)) (env (() () () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f4 <-) (app #f)) (env (() () () ())))
clos/con:
	'((app (λ (f4) ...) (-> (λ (x4) ...) <-)) (env (() () ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env (() ())))
clos/con:
	'((app (-> (λ (f3) ...) <-) (λ (x3) ...)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f3) (-> (let (_) ...) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (... () (_ (-> (app f3 (app #t)) <-)) () ...) ...)
  (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #t) <-)) (env (() () ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() () ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #t)) (env (() () ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f3 (app #f)) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f3 (-> (app #f) <-)) (env (() () ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() () ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f3 <-) (app #f)) (env (() () ())))
clos/con:
	'((app (λ (f3) ...) (-> (λ (x3) ...) <-)) (env (() ())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
clos/con:
	'((app (-> (λ (f2) ...) <-) (λ (x2) ...)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f2) (-> (let (_) ...) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f2 (app #t)) <-)) () ...) ...) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #t) <-)) (env (() ())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (() ())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #t)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f2 (app #f)) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f2 (-> (app #f) <-)) (env (() ())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (() ())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f2 <-) (app #f)) (env (() ())))
clos/con:
	'((app (λ (f2) ...) (-> (λ (x2) ...) <-)) (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
clos/con:
	'((app (-> (λ (f1) ...) <-) (λ (x1) ...)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (f1) (-> (let (_) ...) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (... () (_ (-> (app f1 (app #t)) <-)) () ...) ...) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #t) <-)) (env (())))
clos/con:
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #t <-)) (env (())))
clos/con:
	'(((top) . #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #t)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (let (_) (-> (app f1 (app #f)) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app f1 (-> (app #f) <-)) (env (())))
clos/con:
	'(((top) app #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> #f <-)) (env (())))
clos/con:
	'(((top) . #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> f1 <-) (app #f)) (env (())))
clos/con:
	'((app (λ (f1) ...) (-> (λ (x1) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)
