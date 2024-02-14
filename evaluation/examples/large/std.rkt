#lang s-exp "../../lang/simple-scheme.rkt"


; List operations

;take n, applied to a list xs, returns the prefix of xs of length n, or xs itself if n >= length xs.
(define (take [n : Number] [lst : (Listof 'a)]) : (Listof 'a)
  (if (> n 0)
      (cons (first lst)
            (take (- n 1) (rest lst)))
      empty))

;drop n xs returns the suffix of xs after the first n elements, or [] if n >= length xs.
(define (drop [n : Number] [lst : (Listof 'a)]) : (Listof 'a)
  (if (> n 0)
      (drop (- n 1) (rest lst))
      lst))

;takes a list of lists and makes it into a single list
(define (flatten [lst : (Listof (Listof 'a))]) : (Listof 'a)
  (cond
    [(empty? lst) empty]
    [else (append (first lst) (flatten (rest lst)))]))

; max but for lists
(define (list-max lst)
  (list-max-helper (first lst) (rest lst)))

; helper for maximum to find the max of a list
(define (list-max-helper item lst)
  (cond
    [(empty? lst) item]
    [else (list-max-helper (max item (first lst)) (rest lst))]))


(define (foldl2 [f : ('a 'b 'c -> 'a)] [init : 'a] [lst1 : (Listof 'b)] [lst2 : (Listof 'c)]) : 'a
  (if (or (empty? lst1) (empty? lst2))
      init
      (foldl2 f (f init (first lst1) (first lst2)) (rest lst1) (rest lst2))))

(define (list-set [lst : (Listof 'a)] [index : Number] [val : 'a]) : (Listof 'a)
  (cond
    [(empty? lst) empty]
    [(= index 0) (cons val (rest lst))]
    [else (append (take index lst) (cons val (drop (+ index 1) lst)))]))



; Performs the Union between two lists.
(define (union [lst1 : (Listof 'a)] [lst2 : (Listof 'a)]) : (Listof 'a)
  (if (empty? lst1)
      lst2
      (if (member (first lst1) lst2)
          (union (rest lst1) lst2)
          (cons (first lst1) (union (rest lst1) lst2)))))




; Algorithms

(define (qsort [lst : (Listof 'a)] [val->num : ('a -> Number)])
  (if (< 1 (length lst))
      (let ([pivot (first lst)])
        (append (qsort (filter (λ (x) (< (val->num x) (val->num pivot))) lst) val->num)
                (append (filter (λ (x) (equal? (val->num x) (val->num pivot))) lst)
                        (qsort (filter (λ (x) (> (val->num x) (val->num pivot))) lst) val->num))))
      lst))



; Convience functions

; Convinience function for floor division
(define (// [x : Number] [y : Number]) : Number
  (floor (/ x y)))


(define (bind-optionof [x : (Optionof 'a)] [f : ('a -> (Optionof 'b))]) : (Optionof 'b)
  (type-case (Optionof 'a) x
    [(some value) (f value)]
    [(none) (none)]))

(define (>= [x : Number] [y : Number]) : Boolean
  (or (> x y) (= x y)))
(define (<= [x : Number] [y : Number]) : Boolean
  (or (< x y) (= x y)))

(define (xor [x : Boolean] [y : Boolean]) : Boolean
  (or (and x (not y)) (and (not x) y)))

(define (abs [x : Number]) : Number
  (if (< x 0)
      (* x -1)
      x))

(define (while [start : 'a] [condition : ('a -> Boolean)] [body : ('a -> 'a)])
  (if (condition start)
      (while (body start) condition body)
      start))



; Useful Types and associated function

(define-type Ord
  [Lt]
  [Eq]
  [Gt])

(define (compare [x : 'a] [y : 'a] [cmp : ('a 'a -> Ord)]) : Ord
  (cmp x y))

(define (compare-number [x : Number] [y : Number]) : Ord
  (cond
    [(< x y) (Lt)]
    [(> x y) (Gt)]
    [else (Eq)]))


(define-type (Result 'a 'b)
  [Ok (value : 'a)]
  [Err (err : 'b)])

(define (ok-v [result : (Result 'a 'b)]) : 'a
  (type-case (Result 'a 'b) result
    [(Ok value) value]
    [(Err err) (error 'ok-v"Tried to get value of an error")]))

(define (err-v [result : (Result 'a 'b)]) : 'b
  (type-case (Result 'a 'b) result
    [(Ok value) (error 'err-v "Tried to get error of a value")]
    [(Err err) err]))

(define (ok? [result : (Result 'a 'b)]) : Boolean
  (type-case (Result 'a 'b) result
    [(Ok value) #t]
    [(Err err) #f]))

(define (err? [result : (Result 'a 'b)]) : Boolean
  (type-case (Result 'a 'b) result
    [(Ok value) #f]
    [(Err err) #t]))


(define (bind-result [x : (Result 'a 'b)] [f : ('a -> (Result 'c 'b))]) : (Result 'c 'b)
  (type-case (Result 'a 'b) x
    [(Ok value) (f value)]
    [(Err err) (Err err)]))





; Data Structures

; A binary Heap

(define-type PqType
  [MinHeap]
  [MaxHeap])


(define-type (PriorityQueue 'a)
  [Heap (positions : (Hashof 'a Number)) (heap : (Hashof Number 'a)) (type : PqType) (get-priority : ('a -> Number))])


(define (heap-empty-queue [type : PqType] [get-priority : ('a -> Number)])
  (Heap (hash empty) (hash empty) type get-priority))

; constructor for a priority queue
; type is either MinHeap or MaxHeap
; lst is a list of elements to be inserted into the priority queue
; get-priority is a function that takes an element and returns its priority
(define (heap-make-queue [lst : (Listof 'a)] [type : PqType] [get-priority : ('a -> Number)])
  (foldl (λ (x y) (heap-insert y x)) (Heap (hash empty) (hash empty) type get-priority) lst))

; insert an element into the priority queue
(define (heap-insert [queue : (PriorityQueue 'a)] [node : 'a]) : (PriorityQueue 'a)
  (bubble-up (Heap
              (hash-set (Heap-positions queue) node (let ([len (length (hash-keys (Heap-heap queue)))])
                                                      (if (= len 0)
                                                          1
                                                          (+ len 1))))
              (hash-set (Heap-heap queue) (let ([len (length (hash-keys (Heap-heap queue)))])
                                            (if (= len 0)
                                                1
                                                (+ len 1))) node)
              (Heap-type queue)
              (Heap-get-priority queue))
             node))


; updates a particular node's priority in the priority queue
; transform is a function that takes a node and a new value and returns a new node
(define (heap-decrease-key [queue : (PriorityQueue 'a)] [node : 'a] [new-val : 'b] [transform : ('a 'b -> 'a)])
  (let ([pos (hash-ref (Heap-positions queue) node)])
    (cond
      [(some? pos)
       (let ([pos (some-v pos)])
         (let ([queue (Heap (hash-set (hash-remove (Heap-positions queue) node) (transform node new-val) pos) (hash-set (Heap-heap queue) pos (transform node new-val)) (Heap-type queue) (Heap-get-priority queue))])
           (bubble-up queue (transform node new-val))))]
      [(none? pos)
       queue])))


; moves a node up the heap until it is in the correct position
(define (bubble-up [queue : (PriorityQueue 'a)] [node : 'a])
  (let ([pos (hash-ref (Heap-positions queue) node)])
    (type-case (Optionof Number) pos
      [(some pos)
       (bubble-up-loop pos queue node
                       (type-case PqType (Heap-type queue)
                         [(MinHeap) <]
                         [(MaxHeap) >]))]
      [(none)
       (error 'bubble-up "node not in queue")])))

(define (parent index) (// index 2))
(define (heap-priority-of [queue : (PriorityQueue 'a)] [index : Number])
  ((Heap-get-priority queue) (some-v (hash-ref (Heap-heap queue) index))))

(heap-swap : ((PriorityQueue 'a) Number Number -> (PriorityQueue 'a)))
(define (heap-swap [queue : (PriorityQueue 'a)] [i : Number] [j : Number])
  (let ([i-val (some-v (hash-ref (Heap-heap queue) i))]
        [j-val (some-v (hash-ref (Heap-heap queue) j))])
    (Heap
     (hash-set (hash-set (Heap-positions queue) i-val j) j-val i)
     (hash-set (hash-set (Heap-heap queue) j i-val) i j-val)
     (Heap-type queue)
     (Heap-get-priority queue))))

; main loop for bubble-up
(bubble-up-loop : (Number (PriorityQueue 'a) 'a (Number Number -> Boolean) -> (PriorityQueue 'a)))
(define (bubble-up-loop [pos : Number] [queue : (PriorityQueue 'a)] [node : 'a] [order-before? : (Number Number -> Boolean)])
  (if (or (= pos 0) (= (parent pos) 0))
      queue
      (if (order-before? (heap-priority-of queue pos)
                         (heap-priority-of queue (parent pos)))
          (bubble-up-loop (parent pos) (heap-swap queue pos (parent pos)) node order-before?)
          queue)))

; moves a node down the heap until it is in the correct position
(define (sift-down [queue : (PriorityQueue 'a)])
  (sift-down-loop 1 queue))

; main loop for sift-down
; TODO: sift-down-loop could probably use many of the improvements from bubble-up-loop's new implementation
(define (sift-down-loop [pos : Number] [queue : (PriorityQueue 'a)])
  (let ([smallest (sift-down-for-loop (* pos 2) pos (none) queue)])
    (cond
      [(none? smallest) queue]
      [(> ((Heap-get-priority queue) (some-v (hash-ref (Heap-heap queue) pos))) ((Heap-get-priority queue) (some-v smallest)))
       (type-case PqType (Heap-type queue)
         [(MinHeap)
          (let ([node (some-v (hash-ref (Heap-heap queue) pos))])
            (let ([smallest (some-v smallest)])
              (let ([smallest-pos (some-v (hash-ref (Heap-positions queue) smallest))])
                (let ([temp (some-v (hash-ref (Heap-positions queue) node))])
                  (let ([queue (Heap (hash-set (hash-set (Heap-positions queue) node (some-v (hash-ref (Heap-positions queue) smallest))) smallest temp) (Heap-heap queue) (Heap-type queue) (Heap-get-priority queue))])
                    (let ([queue (Heap (Heap-positions queue) (hash-set (hash-set (Heap-heap queue) pos smallest) smallest-pos node) (Heap-type queue) (Heap-get-priority queue))])
                      (sift-down-loop (+ pos 1) queue)))))))]
         [(MaxHeap) queue])]
      [(< ((Heap-get-priority queue) (some-v (hash-ref (Heap-heap queue) pos))) ((Heap-get-priority queue) (some-v smallest)))
       (type-case PqType (Heap-type queue)
         [(MaxHeap)
          (let ([node (some-v (hash-ref (Heap-heap queue) pos))])
            (let ([smallest (some-v smallest)])
              (let ([smallest-pos (some-v (hash-ref (Heap-positions queue) smallest))])
                (let ([temp (some-v (hash-ref (Heap-positions queue) node))])
                  (let ([queue (Heap (hash-set (hash-set (Heap-positions queue) node (some-v (hash-ref (Heap-positions queue) smallest))) smallest temp) (Heap-heap queue) (Heap-type queue) (Heap-get-priority queue))])
                    (let ([queue (Heap (Heap-positions queue) (hash-set (hash-set (Heap-heap queue) pos smallest) smallest-pos node) (Heap-type queue) (Heap-get-priority queue))])
                      (sift-down-loop (+ pos 1) queue)))))))]
         [(MinHeap) queue])]
      [else queue])))

; finds the smallest node in the priority queue
(define (sift-down-for-loop [i : Number] [pos : Number] [smallest : (Optionof 'a)] [queue : (PriorityQueue 'a)]) : (Optionof 'a)
  (if (or (= pos 0) (= (* pos 2) 0))
      smallest
      (if (> i (length (hash-keys (Heap-heap queue))))
          smallest
          (cond
            [(none? smallest) (sift-down-for-loop (+ i 1) pos (hash-ref (Heap-heap queue) i) queue)]
            [(> ((Heap-get-priority queue) (some-v smallest)) ((Heap-get-priority queue) (some-v (hash-ref (Heap-heap queue) i))))
             (type-case PqType (Heap-type queue)
               [(MinHeap) (sift-down-for-loop (+ i 1) pos (hash-ref (Heap-heap queue) i) queue)]
               [(MaxHeap) smallest])]
            [(< ((Heap-get-priority queue) (some-v smallest)) ((Heap-get-priority queue) (some-v (hash-ref (Heap-heap queue) i))))
             (type-case PqType (Heap-type queue)
               [(MaxHeap) (sift-down-for-loop (+ i 1) pos (hash-ref (Heap-heap queue) i) queue)]
               [(MinHeap) smallest])]

            [else smallest]))))

; deletes the minimum node from the priority queue
(define (heap-pop [queue : (PriorityQueue 'a)]) : ((PriorityQueue 'a) * 'a)
  (let ([return (some-v (hash-ref (Heap-heap queue) 1))])
    (let ([queue (Heap (hash-remove (Heap-positions queue) return) (hash-remove (Heap-heap queue) 1) (Heap-type queue) (Heap-get-priority queue))])
      (if (or (= (length (hash-keys (Heap-heap queue))) 1) (> (length (hash-keys (Heap-heap queue))) 1))
          (let ([end-node (some-v (hash-ref (Heap-heap queue) (+ 1 (length (hash-keys (Heap-heap queue))))))])
            (let ([queue (Heap (hash-set (Heap-positions queue) end-node 1) (hash-set (hash-remove (Heap-heap queue) (+ 1 (length (hash-keys (Heap-heap queue))))) 1 end-node) (Heap-type queue) (Heap-get-priority queue))])
              (pair (sift-down queue) return)))
          (if (= (length (hash-keys (Heap-heap queue))) 1)
              (let ([end-node (some-v (hash-ref (Heap-heap queue) (+ 1 (length (hash-keys (Heap-heap queue))))))])
                (let ([queue (Heap (hash-set (Heap-positions queue) end-node 1) (hash-set (hash-remove (Heap-heap queue) (+ 1 (length (hash-keys (Heap-heap queue))))) 1 end-node) (Heap-type queue) (Heap-get-priority queue))])
                  (pair queue return)))
              (pair queue return))))))

; checks if the priority queue is empty
(define (heap-empty? [queue : (PriorityQueue 'a)]) : Boolean
  (if (= (length (hash-keys (Heap-heap queue))) 0)
      #t
      #f))
