'(expression:
  (letrec*
   ((phi
     (λ (x1)
       (λ (x2)
         (λ (x3)
           (λ (x4)
             (λ (x5)
               (λ (x6)
                 (λ (x7)
                   (match
                    (match
                     x1
                     ((#f) (match x2 ((#f) (app #f)) (_ (app #t))))
                     (_ (app #t)))
                    ((#f) (app #f))
                    (_
                     (match
                      (match
                       x1
                       ((#f)
                        (match
                         (app not x2)
                         ((#f)
                          (match (app not x3) ((#f) (app #f)) (_ (app #t))))
                         (_ (app #t))))
                       (_ (app #t)))
                      ((#f) (app #f))
                      (_
                       (match
                        (match
                         x3
                         ((#f) (match x4 ((#f) (app #f)) (_ (app #t))))
                         (_ (app #t)))
                        ((#f) (app #f))
                        (_
                         (match
                          (match
                           (app not x4)
                           ((#f) (match x1 ((#f) (app #f)) (_ (app #t))))
                           (_ (app #t)))
                          ((#f) (app #f))
                          (_
                           (match
                            (match
                             (app not x2)
                             ((#f)
                              (match
                               (app not x3)
                               ((#f) (app #f))
                               (_ (app #t))))
                             (_ (app #t)))
                            ((#f) (app #f))
                            (_
                             (match
                              (match
                               x4
                               ((#f) (match x2 ((#f) (app #f)) (_ (app #t))))
                               (_ (app #t)))
                              ((#f) (app #f))
                              (_ (app #t)))))))))))))))))))))
    (try
     (λ (f)
       (match
        (app f (app #t))
        ((#f) (match (app f (app #f)) ((#f) (app #f)) (_ (app #t))))
        (_ (app #t)))))
    (sat-solve-7
     (λ (p)
       (app
        try
        (λ (n1)
          (app
           try
           (λ (n2)
             (app
              try
              (λ (n3)
                (app
                 try
                 (λ (n4)
                   (app
                    try
                    (λ (n5)
                      (app
                       try
                       (λ (n6)
                         (app
                          try
                          (λ (n7)
                            (app
                             (app
                              (app (app (app (app (app p n1) n2) n3) n4) n5)
                              n6)
                             n7))))))))))))))))))
   (app sat-solve-7 phi)))
