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
