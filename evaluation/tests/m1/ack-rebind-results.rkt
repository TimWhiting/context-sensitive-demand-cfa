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
  (app + (-> n <-) 1)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + (-> n <-) 1)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app + (-> n <-) 1)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app - (-> m <-) 1)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> m <-) 1)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> m <-) 1)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> m <-) 1)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> m <-) 1)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app - (-> n <-) 1)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app = (-> m <-) 0)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> m <-) 0)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> m <-) 0)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 0)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 0)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app = (-> n <-) 0)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) (app ack m (app - n 1)))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) (app ack m (app - n 1)))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) (app ack m (app - n 1)))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) (app ack m (app - n 1)))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) 1)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> (app - m 1) <-) 1)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> m <-) (app - n 1))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> m <-) (app - n 1))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (-> m <-) (app - n 1))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query:
  (app ack (-> m <-) (app - n 1))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (app - m 1) (-> (app ack m (app - n 1)) <-))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (app - m 1) (-> (app ack m (app - n 1)) <-))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (app - m 1) (-> (app ack m (app - n 1)) <-))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack (app - m 1) (-> (app ack m (app - n 1)) <-))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack m (-> (app - n 1) <-))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack m (-> (app - n 1) <-))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app ack m (-> (app - n 1) <-))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(11 ⊥ ⊥)

'(query:
  (app ack m (-> (app - n 1) <-))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app = n 0)
   ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
   _)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = m 0) <-) (#f) _)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = m 0) <-) (#f) _)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = m 0) <-) (#f) _)
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = m 0) <-) (#f) _)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 0) <-) (#f) _)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 0) <-) (#f) _)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 0) <-) (#f) _)
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app = n 0) <-) (#f) _)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = m 0) (#f) (_ (-> (app + n 1) <-)))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = m 0) (#f) (_ (-> (app + n 1) <-)))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = m 0) (#f) (_ (-> (app + n 1) <-)))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(2 ⊥ ⊥)

'(query:
  (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = m 0) ((#f) (-> (match (app = n 0) ...) <-)) _)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-)))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-)))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) letrec* (ack) ...) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> m <-) 1) (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app - (-> n <-) 1) (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(12 ⊥ ⊥)

'(query: (app = (-> m <-) 0) (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app = (-> n <-) 0) (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(12 ⊥ ⊥)

'(query: (letrec* (ack) (-> (app ack 3 12) <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ack
  (letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (ack (-> (λ (m n) ...) <-)) () ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  m
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  m
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  m
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  m
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env
   ((match
     (app = n 0)
     ((#f) (-> (app ack (app - m 1) (app ack m (app - n 1))) <-))
     _))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((app ack (app - m 1) (-> (app ack m (app - n 1)) <-)))))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  n
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((letrec* (ack) (-> (app ack 3 12) <-)))))
clos/con: ⊥
literals: '(12 ⊥ ⊥)

'(store:
  n
  (λ (m n) (-> (match (app = m 0) ...) <-))
  (env ((match (app = n 0) (#f) (_ (-> (app ack (app - m 1) 1) <-))))))
clos/con: ⊥
literals: '(1 ⊥ ⊥)
