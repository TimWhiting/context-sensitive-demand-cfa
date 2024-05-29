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
    (let ((_ (app display "The plaintext is:            ")))
      (let ((_ (app display plaintext)))
        (let ((_ (app newline)))
          (let ((_ (app display "The ciphertext is:           ")))
            (let ((_ (app display ciphertext)))
              (let ((_ (app newline)))
                (let ((_ (app display "The decrypted ciphertext is: ")))
                  (let ((_ (app display decrypted-ciphertext)))
                    (let ((_ (app newline)))
                      (match
                       (app not (app = plaintext decrypted-ciphertext))
                       ((#f) (app void))
                       (_ (app error "RSA fail!")))))))))))))))
