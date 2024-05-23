'(expression:
  (lettypes
   ((cons car cdr) (nil))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (cadar (λ (p) (app car (app cdr (app car p)))))
     (initial-environment-amap
      (app
       cons
       (app cons '+ (app cons + (app nil)))
       (app cons (app cons '- (app cons - (app nil))) (app nil)))))
    (let ((x (app (app cadar initial-environment-amap) 1 1)))
      (app display x)))))
