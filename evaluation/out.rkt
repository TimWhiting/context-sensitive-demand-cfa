(list '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))
(eval '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))
(list
 'start
 (list 'eval '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '())))
(list 'APP (envenv '()))
(list
 'start
 (list 'eval '((rat ((λ (z) z) 2) (top)) λ (x y) (app x y)) (envenv '())))
(list
 'end
 (list 'eval '((rat ((λ (z) z) 2) (top)) λ (x y) (app x y)) (envenv '())))
(list 'result '(app (-> (λ (x y) (app x y)) <-) (λ (z) z) 2) (envenv '()))
(list
 'start
 (list
  'app-eval
  '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'start
 (list
  'eval
  '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'APP
 (envenv
  (list
   (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '())))))
(list
 'start
 (list
  'refines
  (list
   'eval
   '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
   (envenv
    (list
     (list
      'cenv
      '((top) app (λ (x y) (app x y)) (λ (z) z) 2)
      (envenv '())))))))
(list
 'start
 (list
  'eval
  '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'start
 (list
  'refines
  (list
   'eval
   '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
   (envenv
    (list
     (list
      'cenv
      '((top) app (λ (x y) (app x y)) (λ (z) z) 2)
      (envenv '())))))))
(list
 'start
 (list
  'call
  '(rat ((λ (z) z) 2) (top))
  '(x y)
  '(app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
'HYBRID
'(CALL-UNKNOWN #f)
(list
 'start
 (list 'expr '((rat ((λ (z) z) 2) (top)) λ (x y) (app x y)) (envenv '())))
(list
 'end
 (list 'expr '((rat ((λ (z) z) 2) (top)) λ (x y) (app x y)) (envenv '())))
(list 'result '(top) (envenv '()))
(list '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))
"CALL-EQ"
(list
 'end
 (list
  'call
  '(rat ((λ (z) z) 2) (top))
  '(x y)
  '(app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result '(top) (envenv '()))
(list
 'start
 (list
  '(ref 0)
  '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z)
  (envenv '())))
(list
 'start
 (list 'eval '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z) (envenv '())))
(list
 'end
 (list 'eval '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z) (envenv '())))
(list 'result '(app (λ (x y) (app x y)) (-> (λ (z) z) <-) 2) (envenv '()))
(list
 'end
 (list
  '(ref 0)
  '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z)
  (envenv '())))
(list 'result '(app (λ (x y) (app x y)) (-> (λ (z) z) <-) 2) (envenv '()))
(list
 'end
 (list
  'eval
  '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result '(app (λ (x y) (app x y)) (-> (λ (z) z) <-) 2) (envenv '()))
(list
 'start
 (list
  'app-eval
  '((bod (z) (ran (λ (x y) (app x y)) () (2) (top))) . z)
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
(list
 'start
 (list
  'eval
  '((bod (z) (ran (λ (x y) (app x y)) () (2) (top))) . z)
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
(list
 'start
 (list
  'refines
  (list
   'eval
   '((bod (z) (ran (λ (x y) (app x y)) () (2) (top))) . z)
   (envenv
    (list
     (list
      'cenv
      '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
      (envenv '((□? (x y))))))))))
(list
 'start
 (list
  'call
  '(ran (λ (x y) (app x y)) () (2) (top))
  '(z)
  'z
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
'HYBRID
'(CALL-UNKNOWN #f)
(list
 'start
 (list 'expr '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z) (envenv '())))
(list
 'start
 (list
  'expr
  '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'start
 (list
  'refines
  (list
   'expr
   '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
   (envenv
    (list
     (list
      'cenv
      '((top) app (λ (x y) (app x y)) (λ (z) z) 2)
      (envenv '())))))))
(list
 'end
 (list
  'expr
  '((rat (y) (bod (x y) (rat ((λ (z) z) 2) (top)))) . x)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'result
 '(λ (x y) (-> (app x y) <-))
 (envenv (list (list 'cenv '(top) (envenv '())))))
(list
 'end
 (list 'expr '((ran (λ (x y) (app x y)) () (2) (top)) λ (z) z) (envenv '())))
(list
 'result
 '(λ (x y) (-> (app x y) <-))
 (envenv (list (list 'cenv '(top) (envenv '())))))
(list
 '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
 (envenv
  (list
   (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '())))))
"CALL-EQ"
(list
 'end
 (list
  'call
  '(ran (λ (x y) (app x y)) () (2) (top))
  '(z)
  'z
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
(list
 'result
 '(λ (x y) (-> (app x y) <-))
 (envenv (list (list 'cenv '(top) (envenv '())))))
(list
 'start
 (list
  '(ref 0)
  '((ran x () () (bod (x y) (rat ((λ (z) z) 2) (top)))) . y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'start
 (list
  'eval
  '((ran x () () (bod (x y) (rat ((λ (z) z) 2) (top)))) . y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list
 'start
 (list
  'refines
  (list
   'eval
   '((ran x () () (bod (x y) (rat ((λ (z) z) 2) (top)))) . y)
   (envenv
    (list
     (list
      'cenv
      '((top) app (λ (x y) (app x y)) (λ (z) z) 2)
      (envenv '())))))))
(list
 'start
 (list
  'call
  '(rat ((λ (z) z) 2) (top))
  '(x y)
  '(app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
'HYBRID
'(CALL-UNKNOWN #f)
(list '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))
"CALL-EQ"
(list
 'end
 (list
  'call
  '(rat ((λ (z) z) 2) (top))
  '(x y)
  '(app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result '(top) (envenv '()))
(list
 'start
 (list
  '(ref 1)
  '((ran (λ (x y) (app x y)) ((λ (z) z)) () (top)) . 2)
  (envenv '())))
(list
 'start
 (list
  'eval
  '((ran (λ (x y) (app x y)) ((λ (z) z)) () (top)) . 2)
  (envenv '())))
(list
 'end
 (list
  'eval
  '((ran (λ (x y) (app x y)) ((λ (z) z)) () (top)) . 2)
  (envenv '())))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  '(ref 1)
  '((ran (λ (x y) (app x y)) ((λ (z) z)) () (top)) . 2)
  (envenv '())))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  'eval
  '((ran x () () (bod (x y) (rat ((λ (z) z) 2) (top)))) . y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  '(ref 0)
  '((ran x () () (bod (x y) (rat ((λ (z) z) 2) (top)))) . y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  'eval
  '((bod (z) (ran (λ (x y) (app x y)) () (2) (top))) . z)
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  'app-eval
  '((bod (z) (ran (λ (x y) (app x y)) () (2) (top))) . z)
  (envenv
   (list
    (list
     'cenv
     '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
     (envenv '((□? (x y)))))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  'eval
  '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list
  'app-eval
  '((bod (x y) (rat ((λ (z) z) 2) (top))) app x y)
  (envenv
   (list
    (list 'cenv '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '()))))))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
(list
 'end
 (list 'eval '((top) app (λ (x y) (app x y)) (λ (z) z) 2) (envenv '())))
(list 'result (literal (list (singleton 2) (bottom) (bottom) (bottom))))
'(clos/con: ⊥)
'(literals: (2 ⊥ ⊥ ⊥))
