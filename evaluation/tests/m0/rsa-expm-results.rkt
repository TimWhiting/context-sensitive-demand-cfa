'(expression:
  (lettypes
   ((cons car cdr) (error r))
   (letrec*
    ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
     (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
     (extended-gcd
      (λ (a b)
        (match
         (app = (app modulo a b) 0)
         ((#f)
          (let* ((x:y (app extended-gcd b (app modulo a b)))
                 (x (app car x:y))
                 (y (app cdr x:y)))
            (app cons y (app - x (app * y (app quotient a b))))))
         (_ (app cons 0 1)))))
     (modulo-inverse (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
     (totient (λ (p q) (app * (app - p 1) (app - q 1))))
     (square (λ (x) (app * x x)))
     (modulo-power
      (λ (base exp n)
        (match
         (app = exp 0)
         ((#f)
          (match
           (app odd? exp)
           ((#f)
            (app
             modulo
             (app square (app modulo-power base (app / exp 2) n))
             n))
           (_
            (app
             modulo
             (app * base (app modulo-power base (app - exp 1) n))
             n))))
         (_ 1))))
     (is-legal-public-exponent?
      (λ (e p q)
        (match
         (app < 1 e)
         ((#f) (app #f))
         (_
          (match
           (app < e (app totient p q))
           ((#f) (app #f))
           (_
            (match
             (app = 1 (app gcd e (app totient p q)))
             ((#f) (app #f))
             (_ (app #t)))))))))
     (private-exponent
      (λ (e p q)
        (match
         (app is-legal-public-exponent? e p q)
         ((#f) (app error "Not a legal public exponent for that modulus."))
         (_ (app modulo-inverse e (app totient p q))))))
     (encrypt
      (λ (m e n)
        (match
         (app > m n)
         ((#f) (app modulo-power m e n))
         (_ (app error "The modulus is too small to encrypt the message.")))))
     (decrypt (λ (c d n) (app modulo-power c d n)))
     (p 41)
     (q 47)
     (n (app * p q))
     (e 7)
     (d (app private-exponent e p q))
     (plaintext 42)
     (ciphertext (app encrypt plaintext e n))
     (decrypted-ciphertext (app decrypt ciphertext d n)))
    (match
     (app not (app = plaintext decrypted-ciphertext))
     ((#f) (app display "RSA success!"))
     (_ (app error "RSA fail!"))))))

'(query:
  (app * (-> base <-) (app modulo-power base (app - exp 1) n))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app * base (-> (app modulo-power base (app - exp 1) n) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons (-> y <-) (app - x (app * y (app quotient ...))))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app cons y (-> (app - x (app * y (app quotient ...))) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app * base (app modulo-power base (app - ...) n)) <-) n)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (-> (app square (app modulo-power base (app / ...) n)) <-) n)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (app modulo (app * base (app modulo-power base (app - ...) n)) (-> n <-))
  (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query:
  (app modulo (app square (app modulo-power base (app / ...) n)) (-> n <-))
  (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query:
  (app square (-> (app modulo-power base (app / exp 2) n) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (let* (... () (x:y (-> (app extended-gcd b (app modulo a b)) <-)) x ...) ...)
  (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-))
  (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    ciphertext
    (decrypted-ciphertext (-> (app decrypt ciphertext d n) <-))
    ()
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec*
   (...
    plaintext
    (ciphertext (-> (app encrypt plaintext e n) <-))
    decrypted-ciphertext
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (letrec*
   (car ... decrypted-ciphertext)
   (-> (match (app not (app = ...)) ...) <-))
  (env ()))
clos/con:
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... e (d (-> (app private-exponent e p q) <-)) plaintext ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... decrypted-ciphertext) ...))
  (env ()))
clos/con:
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app < e (app totient p q))
   (#f)
   (_ (-> (match (app = 1 (app gcd ...)) ...) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app is-legal-public-exponent? e p q)
   (#f)
   (_ (-> (app modulo-inverse e (app totient p q)) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app not (app = plaintext decrypted-ciphertext))
   (#f)
   (_ (-> (app error "RSA fail!") <-)))
  (env ()))
clos/con:
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app not (app = plaintext decrypted-ciphertext))
   ((#f) (-> (app display "RSA success!") <-))
   _)
  (env ()))
clos/con:
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   (#f)
   (_ (-> (app modulo (app * base (app modulo-power ...)) n) <-)))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match
   (app odd? exp)
   ((#f) (-> (app modulo (app square (app modulo-power ...)) n) <-))
   _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (-> (app = 1 (app gcd e (app totient ...))) <-) (#f) _)
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app is-legal-public-exponent? e p q) <-) (#f) _)
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (-> (app not (app = plaintext decrypted-ciphertext)) <-) (#f) _)
  (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app < 1 e) (#f) (_ (-> (match (app < e (app totient ...)) ...) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-)))
  (env (())))
clos/con:
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = (app modulo a b) 0) ((#f) (-> (let* (x:y ... y) ...) <-)) _)
  (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = 1 (app gcd e (app totient ...))) (#f) (_ (-> (app #t) <-)))
  (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (match (app = exp 0) ((#f) (-> (match (app odd? exp) ...) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (match (app > m n) ((#f) (-> (app modulo-power m e n) <-)) _)
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (a n) (-> (app modulo (app car (app extended-gcd ...)) n) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query:
  (λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((con
   error
   (match
    (app not (app = plaintext decrypted-ciphertext))
    (#f)
    (_ (-> (app error "RSA fail!") <-))))
  (env ()))
	'((con void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app * (-> (app - p 1) <-) (app - q 1)) (env (())))
clos/con: ⊥
literals: '(40 ⊥ ⊥)

'(query: (app * (-> x <-) x) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (-> y <-) (app quotient a b)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * (app - p 1) (-> (app - q 1) <-)) (env (())))
clos/con: ⊥
literals: '(46 ⊥ ⊥)

'(query: (app * x (-> x <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app * y (-> (app quotient a b) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> exp <-) 1) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - (-> p <-) 1) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app - (-> q <-) 1) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app - (-> x <-) (app * y (app quotient a b))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app - x (-> (app * y (app quotient a b)) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app / (-> exp <-) 2) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app < (-> e <-) (app totient p q)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app < 1 (-> e <-)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app < e (-> (app totient p q) <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app = (-> (app modulo a b) <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = (-> exp <-) 0) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app = 1 (-> (app gcd e (app totient p q)) <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(query: (app = plaintext (-> decrypted-ciphertext <-)) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app > (-> m <-) n) (env (())))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app > m (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app car (-> (app extended-gcd a n) <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app car (-> x:y <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app cdr (-> x:y <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (app decrypt (-> ciphertext <-) d n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app decrypt ciphertext (-> d <-) n) (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app decrypt ciphertext d (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app encrypt plaintext e (-> n <-)) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app extended-gcd (-> a <-) n) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app extended-gcd (-> b <-) (app modulo a b)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app extended-gcd a (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app extended-gcd b (-> (app modulo a b) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app gcd (-> e <-) (app totient p q)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app gcd e (-> (app totient p q) <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app is-legal-public-exponent? (-> e <-) p q) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app is-legal-public-exponent? e (-> p <-) q) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app is-legal-public-exponent? e p (-> q <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app modulo (-> (app car (app extended-gcd a n)) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> a <-) b) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (-> a <-) b) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo (app car (app extended-gcd a n)) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app modulo a (-> b <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo a (-> b <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-inverse (-> e <-) (app totient p q)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo-inverse e (-> (app totient p q) <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app - exp 1) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> base <-) (app / exp 2) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> c <-) d n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power (-> m <-) e n) (env (())))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(query: (app modulo-power base (-> (app - exp 1) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (-> (app / exp 2) <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power base (app - exp 1) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power base (app / exp 2) (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power c (-> d <-) n) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app modulo-power c d (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app modulo-power m (-> e <-) n) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(query: (app modulo-power m e (-> n <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (app not (-> (app = plaintext decrypted-ciphertext) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app odd? (-> exp <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app quotient (-> a <-) b) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app quotient a (-> b <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient (-> p <-) q) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (app totient p (-> q <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(query: (let* (... x (y (-> (app cdr x:y) <-)) () ...) ...) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (let* (... x:y (x (-> (app car x:y) <-)) y ...) ...) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (letrec* (... q (n (-> (app * p q) <-)) e ...) ...) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(query: (match (-> (app < 1 e) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app < e (app totient p q)) <-) (#f) _) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = (app modulo a b) 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app = exp 0) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app > m n) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app odd? exp) <-) (#f) _) (env (())))
clos/con:
	'((con #f) (env ()))
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> car-v <-) (cons car-c car-d)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> cdr-v <-) (cons cdr-c cdr-d)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (a b) (-> (match (app = (app modulo ...) 0) ...) <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (c d n) (-> (app modulo-power c d n) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (car-v) (-> (match car-v ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (cdr-v) (-> (match cdr-v ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (e p q) (-> (match (app < 1 e) ...) <-)) (env (())))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (λ (m e n) (-> (match (app > m n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(query: (λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(query: (λ (x) (-> (app * x x) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  a
  (λ (a n) (-> (app modulo (app car (app extended-gcd ...)) n) <-))
  (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  car
  (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cdr
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) extended-gcd ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ciphertext
  (letrec*
   (...
    plaintext
    (ciphertext (-> (app encrypt plaintext e n) <-))
    decrypted-ciphertext
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons (-> y <-) (app - x (app * y (app quotient ...))))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  con
  (app cons y (-> (app - x (app * y (app quotient ...))) <-))
  (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  d
  (letrec* (... e (d (-> (app private-exponent e p q) <-)) plaintext ...) ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  decrypt
  (letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...)
  (env ()))
clos/con:
	'((letrec* (... encrypt (decrypt (-> (λ (c d n) ...) <-)) p ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  decrypted-ciphertext
  (letrec*
   (...
    ciphertext
    (decrypted-ciphertext (-> (app decrypt ciphertext d n) <-))
    ()
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store:
  e
  (λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store:
  encrypt
  (letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... private-exponent (encrypt (-> (λ (m e n) ...) <-)) decrypt ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  extended-gcd
  (letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cdr (extended-gcd (-> (λ (a b) ...) <-)) modulo-inverse ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  is-legal-public-exponent?
  (letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    modulo-power
    (is-legal-public-exponent? (-> (λ (e p q) ...) <-))
    private-exponent
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-inverse
  (letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... extended-gcd (modulo-inverse (-> (λ (a n) ...) <-)) totient ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  modulo-power
  (letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    square
    (modulo-power (-> (λ (base exp n) ...) <-))
    is-legal-public-exponent?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  n
  (λ (a n) (-> (app modulo (app car (app extended-gcd ...)) n) <-))
  (env (())))
clos/con: ⊥
literals: '(1840 ⊥ ⊥)

'(store:
  p
  (λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store:
  plaintext
  (letrec* (... d (plaintext (-> 42 <-)) ciphertext ...) ...)
  (env ()))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(store:
  private-exponent
  (letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-legal-public-exponent?
    (private-exponent (-> (λ (e p q) ...) <-))
    encrypt
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  q
  (λ (e p q) (-> (match (app is-legal-public-exponent? e p q) ...) <-))
  (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store:
  square
  (letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
clos/con:
	'((letrec* (... totient (square (-> (λ (x) ...) <-)) modulo-power ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  totient
  (letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
clos/con:
	'((letrec* (... modulo-inverse (totient (-> (λ (p q) ...) <-)) square ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  x:y
  (let* (... () (x:y (-> (app extended-gcd b (app modulo a b)) <-)) x ...) ...)
  (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: a (λ (a b) (-> (match (app = (app modulo ...) 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: b (λ (a b) (-> (match (app = (app modulo ...) 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: base (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: c (λ (c d n) (-> (app modulo-power c d n) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: car-c (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: car-d (match car-v ((cons car-c car-d) (-> car-c <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: car-v (λ (car-v) (-> (match car-v ...) <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: cdr-c (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: cdr-d (match cdr-v ((cons cdr-c cdr-d) (-> cdr-d <-))) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: cdr-v (λ (cdr-v) (-> (match cdr-v ...) <-)) (env (())))
clos/con:
	'((con cons (let* (x:y ... y) (-> (app cons y (app - x (app * ...))) <-)))
  (env (())))
	'((con cons (match (app = (app modulo a b) 0) (#f) (_ (-> (app cons 0 1) <-))))
  (env (())))
literals: '(⊥ ⊥ ⊥)

'(store: con (app cons (-> 0 <-) 1) (env (())))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store: con (app cons 0 (-> 1 <-)) (env (())))
clos/con: ⊥
literals: '(1 ⊥ ⊥)

'(store: con (app error (-> "RSA fail!" <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "RSA fail!")

'(store: d (λ (c d n) (-> (app modulo-power c d n) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: e (letrec* (... n (e (-> 7 <-)) d ...) ...) (env ()))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store: e (λ (e p q) (-> (match (app < 1 e) ...) <-)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store: e (λ (m e n) (-> (match (app > m n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(7 ⊥ ⊥)

'(store: exp (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: m (λ (m e n) (-> (match (app > m n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(42 ⊥ ⊥)

'(store: n (letrec* (... q (n (-> (app * p q) <-)) e ...) ...) (env ()))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store: n (λ (base exp n) (-> (match (app = exp 0) ...) <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store: n (λ (c d n) (-> (app modulo-power c d n) <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store: n (λ (m e n) (-> (match (app > m n) ...) <-)) (env (())))
clos/con: ⊥
literals: '(1927 ⊥ ⊥)

'(store: p (letrec* (... decrypt (p (-> 41 <-)) q ...) ...) (env ()))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store: p (λ (e p q) (-> (match (app < 1 e) ...) <-)) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store: p (λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env (())))
clos/con: ⊥
literals: '(41 ⊥ ⊥)

'(store: q (letrec* (... p (q (-> 47 <-)) n ...) ...) (env ()))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store: q (λ (e p q) (-> (match (app < 1 e) ...) <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store: q (λ (p q) (-> (app * (app - p 1) (app - q 1)) <-)) (env (())))
clos/con: ⊥
literals: '(47 ⊥ ⊥)

'(store: x (let* (... x:y (x (-> (app car x:y) <-)) y ...) ...) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: x (λ (x) (-> (app * x x) <-)) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)

'(store: y (let* (... x (y (-> (app cdr x:y) <-)) () ...) ...) (env (())))
clos/con: ⊥
literals: '(⊤ ⊥ ⊥)
