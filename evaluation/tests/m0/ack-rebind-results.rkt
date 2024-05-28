'(expression:
  (letrec*
   ((ack
     (λ (m n)
       (match
        (app = m 0)
        ((#f)
         (match
          (app = n 0)
          ((#f) (app ack (app - m 1) (app ack m (app - n 1))))
          (_ (app ack (app - m 1) 1))))
        (_ (app + n 1))))))
   (app ack 3 12)))

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - ...))) <-))
   _)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (ack) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app + (-> n <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> m <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> m <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> m <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> n <-) 0) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ack (-> (app - m 1) <-) (app ack m (app - n 1))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ack (-> (app - m 1) <-) 1) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ack (-> m <-) (app - n 1)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ack (app - m 1) (-> (app ack m (app - n 1)) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app ack m (-> (app - n 1) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (ack) (-> (app ack 3 12) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (-> (app = m 0) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = n 0) <-) (#f) _) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app = m 0) (#f) (_ (-> (app + n 1) <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (m n) (-> (match (app = m 0) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: m (λ (m n) (-> (match (app = m 0) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: n (λ (m n) (-> (match (app = m 0) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)
