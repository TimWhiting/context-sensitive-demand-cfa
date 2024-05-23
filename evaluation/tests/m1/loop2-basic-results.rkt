'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (let ((lp1 (app cons 'unspecified (app nil))))
     (let ((a
            (app
             set!
             lp1
             (λ (i x)
               (let ((a (app = 0 i)))
                 (match
                  a
                  ((#f)
                   (let ((lp2 (app cons 'unspecified (app nil))))
                     (let ((b
                            (app
                             set!
                             lp2
                             (λ (j f y)
                               (let ((b (app = 0 j)))
                                 (match
                                  b
                                  ((#f)
                                   (let (($tmp$3 (app f y)))
                                     (app lp2 (app - j 1) f $tmp$3)))
                                  (_ (app lp1 (app - i 1) y))))))))
                       (app lp2 10 (λ (n) (app + n i)) x))))
                  (_ x)))))))
       (app lp1 10 0)))))
