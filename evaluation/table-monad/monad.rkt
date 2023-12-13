#lang racket/base
(require racket/match
         racket/set)

; M a = Cont a × State v → State v
; Cont a = a → State v → State v
; State is a type constructor for maps from keys to sets of type v
; we can also have the type of the set depend on the value (variant) of the key
; (GADT--yes! see Fixing Non-determinism)

#|

If I were going to explain this monad, I would start with what's below
(which lacks any particular instantiation of state or caching).
The only hint that something interesting is going on is mt-κ which lets
us know that we care only about the state, and not the result.

(Actually, I would start with the composition of the continuation and state
and explain what it provides. Then I would take away the return values.)

|#

(define ((∘ . s→ss) s) (foldr (λ (s→s s) (s→s s)) s s→ss))

(provide ∘)

(define ((mt-κ . xs) s) s)
(define ((unit . xs) k) (apply k xs))
(define ((void k) s) s)
(define ((>>= m f) k) (m (λ xs ((apply f xs) k))))
#|
(>> m₀ m₁)
(>>= m₀ (λ _ m₁))
(λ (k) (m₀ (λ xs ((apply (λ _ m₁) xs) k))))
(λ (k) (m₀ (λ xs (m₁ k))))
|#
(define ((>> m . ms) k) (m (foldl (λ (m k) (λ _ (m k))) k ms)))

(define ((each m . ms) k) (foldl (λ (m s→s) (∘ (m k) s→s)) (m k) ms))

(define (run m [s (hash)]) ((m mt-κ) s))

(define (id s) s)
(define ((⊔ . cs) κ)
  (foldl (λ (c s→s) (∘ (c κ) s→s)) id cs))
(define ⊥ (⊔))
(provide unit void >>= >> each run ⊔ ⊥ id)

#|
'(>>= m unit)
'(λ (k) (m (extend-κ unit k)))
'(λ (k) (m (λ xs ((apply unit xs) k))))
'(λ (k) (m (λ xs ((apply (λ xs (λ (k) (apply k xs))) xs) k))))
'(λ (k) (m (λ xs ((λ (k) (apply k xs)) k))))
'(λ (k) (m (λ xs (apply k xs))))
'(λ (k) (m k))
'm
|#

#|
'(>>= (unit x) f)
'(λ (k) ((unit x) (extend-κ f k)))
'(λ (k) ((unit x) (λ xs ((apply f xs) k))))
'(λ (k) (((λ xs (λ (k) (apply k xs))) x) (λ xs ((apply f xs) k))))
'(λ (k) ((λ (k) (apply k (list x))) (λ xs ((apply f xs) k))))
'(λ (k) ((λ (k) (k x)) (λ xs ((apply f xs) k))))
'(λ (k) ((λ xs ((apply f xs) k)) x))
'(λ (k) ((apply f (list x)) k))
'(λ (k) ((f x) k))
'(f x)
|#
