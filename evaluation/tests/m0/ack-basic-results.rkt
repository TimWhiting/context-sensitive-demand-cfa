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

'(query: ((top) letrec* (ack) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (λ (m n) (-> (match (app = m 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (match (app = m 0) (#f) (_ (-> (app + n 1) <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app + n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app + (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> + <-) n 1) (env (())))
clos/con:
	#<procedure:do-add>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query:
  (match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app ack (app - m 1) (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app ack (-> (app - m 1) <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - m (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> m <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) m 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> ack <-) (app - m 1) 1) (env (())))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app ack (app - m 1) (-> (app ack m (app - n 1)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app ack m (-> (app - n 1) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - n (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) n 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app ack (-> m <-) (app - n 1)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> ack <-) m (app - n 1)) (env (())))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app ack (-> (app - m 1) <-) (app ack m (app - n 1))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app - m (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥ ⊥)

'(query: (app - (-> m <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> - <-) m 1) (env (())))
clos/con:
	#<procedure:do-sub>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app (-> ack <-) (app - m 1) (app ack m (app - n 1))) (env (())))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app = n 0) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app = n (-> 0 <-)) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥ ⊥)

'(query: (app = (-> n <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> = <-) n 0) (env (())))
clos/con:
	#<procedure:do-demand-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (match (-> (app = m 0) <-) (#f) _) (env (())))
clos/con:
	'(((top) app #f) (env ()))
	'(((top) app #t) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (app = m (-> 0 <-)) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥ ⊥)

'(query: (app = (-> m <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app (-> = <-) m 0) (env (())))
clos/con:
	#<procedure:do-demand-equal>
literals: '(⊥ ⊥ ⊥ ⊥)

'(query: (letrec* (ack) (-> (app ack 3 12) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥ ⊥)

'(query: (app ack 3 (-> 12 <-)) (env ()))
clos/con: ⊥
literals: '(12 ⊥ ⊥ ⊥)

'(query: (app ack (-> 3 <-) 12) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥ ⊥)

'(query: (app (-> ack <-) 3 12) (env ()))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥ ⊥)
