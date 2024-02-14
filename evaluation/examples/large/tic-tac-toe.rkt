#lang s-exp "../../lang/simple-scheme.rkt"

(define-type Index
  (Ze)
  (On)
  (Tw))

(define is
  (list (Ze) (On) (Tw)))

(define-type Coord
  (coord [row : Index]
         [col : Index]))

(define-type Mark
  (X)
  (O))

(define-type Option
  (some v)
  (none))

(define (mark⁻¹ ma)
  (type-case Mark ma
    [(X) (O)]
    [(O) (X)]))

(define-type Cell
  (blank)
  (marked [xo : Mark]))

(define-type-alias Board (Coord -> Cell))

(define empty-board
  (λ (co) (blank)))

(define (board-mark co₀ ma bo)
  (λ (co)
    (if (equal? co₀ co)
        (marked ma)
        (board-lookup co bo))))

(define (board-lookup co bo)
  (bo co))

(define (marked-with? b co m)
  (type-case Cell (b co)
    [(blank)
     #f]
    [(marked m*)
     (equal? m m*)]))

(define (i⁻¹ i)
  (type-case Index i
    [(Ze) (Tw)]
    [(On) (On)]
    [(Tw) (Ze)]))

(define (ormap f xs)
  (type-case (Listof 'a) xs
    [empty
     #f]
    [(cons x rest-xs)
     (or (f x) (ormap f rest-xs))]))

(define (andmap f xs)
  (type-case (Listof 'a) xs
    [empty
     #t]
    [(cons x rest-xs)
     (and (f x) (andmap f rest-xs))]))

(define (wins? b m)
  (or (ormap (λ (r) (andmap (λ (c) (marked-with? b (coord r c) m)) is)) is)
      (ormap (λ (c) (andmap (λ (r) (marked-with? b (coord r c) m)) is)) is)
      (andmap (λ (rc) (marked-with? b (coord rc      rc ) m)) is)
      (andmap (λ (rc) (marked-with? b (coord rc (i⁻¹ rc)) m)) is)))

(define (full? b)
  (andmap (λ (r) (andmap (λ (c) (marked? (b (coord r c)))) is)) is))

(define-type Outcome
  (win)
  (draw)
  (lose))

(define (oc< oc₀ oc₁)
  (type-case Outcome oc₀
    [(win)
     #f]
    [(draw)
     (equal? oc₁ (win))]
    [(lose)
     (not (equal? oc₁ (lose)))]))

(define-type Horizon
  (horizon [outcome : Outcome]
           [step-count : Number]))

(define (horizon< h₀ h₁)
  (type-case Horizon h₀
    [(horizon oc₀ sc₀)
     (type-case Horizon h₁
       [(horizon oc₁ sc₁)
        (or (oc< oc₀ oc₁)
            (and (equal? oc₀ oc₁)
                 (< sc₀ sc₁)))])]))

(define (horizon-add1 h)
  (type-case Horizon h
    [(horizon oc sc)
     (horizon oc (+ sc 1))]))

(define-type Move
  (move [coord : Coord] [horizon : Horizon]))

(define (foldl f acc l)
  (match l
    [(nil) acc]
    [(cons x xs) (foldl f (f acc x) xs)]
    ))

(define (fold/coord f x)
  (foldl
   (λ (r x)
     (foldl
      (λ (c x)
        (f (coord r c) x))
      x
      is))
   x
   is))

(define (min-maybe-move mmo mo₁)
  (type-case (Optionof Move) mmo
    [(some mo₀)
     (some (if (horizon< (move-horizon mo₀)
                         (move-horizon mo₁))
               mo₀
               mo₁))]
    [(none)
     (some mo₁)]))

(define (max-maybe-move mmo mo₁)
  (type-case (Optionof Move) mmo
    [(some mo₀)
     (some (if (horizon< (move-horizon mo₀)
                         (move-horizon mo₁))
               mo₁
               mo₀))]
    [(none)
     (some mo₁)]))

(define (minimax [bo : Board]
                 [this-mark : Mark]
                 [that-mark : Mark])
  (fold/coord
   (λ (co mm)
     (if (blank? (board-lookup co bo))
         (let ([bo (board-mark co this-mark bo)])
           (min-maybe-move
            mm
            (move co (cond
                       [(wins? bo this-mark)
                        (horizon (lose) 0)]
                       [(full? bo)
                        (horizon (draw) 0)]
                       [else
                        (horizon-add1
                         (move-horizon
                          ; the use of `some-v` here is type-safe
                          (some-v
                           (maximin bo that-mark this-mark))))]))))
         mm))
   (none)))

(define (maximin [bo : Board]
                 [this-mark : Mark]
                 [that-mark : Mark])
  (fold/coord
   (λ (co mm)
     (if (blank? (board-lookup co bo))
         (let ([bo (board-mark co this-mark bo)])
           (max-maybe-move
            mm
            (move co (cond
                       [(wins? bo this-mark)
                        (horizon (win) 0)]
                       [(full? bo)
                        (horizon (draw) 0)]
                       [else
                        (horizon-add1
                         (move-horizon
                          ; the use of `some-v` here is type-safe
                          (some-v
                           (minimax bo that-mark this-mark))))]))))
         mm))
   (none)))

(define-type Player
  (player [mark : Mark]
          [action : (Board -> Coord)]))

(define (human-action bo)
  (begin
    #;(printf "Enter your move (e.g. \"(0,0)\": ")
    (error 'human-action "not implemented")))

(define (make-ai-action ma)
  (λ (bo)
    ; the use of `some-v` here is type-safe
    (move-coord (some-v (maximin bo ma (mark⁻¹ ma))))))

(define (draw-board! bo)
  (void))

(define (play-turn bo this-play that-play)
  (begin
    (draw-board! bo)
    (type-case Player this-play
      [(player mark action)
       (let ([co (letrec ([loop (λ ()
                                  (let ([co (action bo)])
                                    (if (blank? (board-lookup co bo))
                                        co
                                        (loop))))])
                   (loop))])
         (let ([bo (board-mark co mark bo)])
           (cond
             [(wins? bo mark)
              (begin
                (draw-board! bo)
                #;(printf "Player ~a wins.\n" mark)
                (void))]
             [(full? bo)
              (begin
                (draw-board! bo)
                (display "Cat's game.\n"))]
             [else
              (play-turn bo that-play this-play)])))])))

(define (play-game player-one player-two)
  (play-turn empty-board player-one player-two))

; Driver function for playing the game with two players
(define (two-player-game)
  (play-game (player (X)
                     human-action)
             (player (O)
                     human-action)))

; Driver function for playing the game with one AI
(define (one-player-game)
  (play-game (player (X)
                     human-action)
             (player (O)
                     (make-ai-action (O)))))

; Driver function for playing with two AIs
; really boring since the the first ai will always make the same first move
(define (zero-player-game)
  (play-game (player (X)
                     (make-ai-action (X)))
             (player (O)
                     (make-ai-action (O)))))

(zero-player-game)
