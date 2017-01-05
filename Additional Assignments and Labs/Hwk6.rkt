;; Nathan Dennler and Benjamin Hylak
(require test-engine/racket-gui)

;;;;;;;;;;;;;;;;;;;;;;;PART 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#| Original code

(define make-dillo-obj
  (lambda (length dead?)
    (lambda (message)
      (cond [(symbol=? message 'longer-than?) 
             (lambda (len) (> length len))]
            [(symbol=? message 'run-over) 
             (lambda () (make-dillo-obj (+ length 1) true))]))))

(define d1 (make-dillo-obj 5 false))
((d1 'longer-than?) 6)
((d1 'longer-than?) 5)
(define d2 ((d1 'run-over)))
((d2 'longer-than?) 5)

|#

;;--------------- MACROS -----------------------
(define-syntax class
  (syntax-rules (initvars method)
    [(class (initvars var1 ...)
       (method name (input1 ...) (function ...)) ...)
         (lambda (var1 ...)
           (lambda (message)
             (cond [(symbol=? message 'name)
                    (lambda (input1 ...) (function ...))]
                   ...
                   [else false])))]
    ;;if no initvars
    [(class (initvars)
       (method name (input1 ...) (function ...)) ...)
     (lambda ()
       (lambda (message)
         (cond [(symbol=? message 'name)
                (lambda (input1 ...) (function ...))]
               ...
               [else false])))]
    ;;if no methods
    [(class (initvars var1 ...))
     (lambda (var1 ...)
       (lambda (message) false))]
    ;;if no methods or initvars
    [(class (initvars))
     (empty)]))

(define-syntax send
  (syntax-rules()
    [(send object method input ...)
     ;;first detect if method is a valid method
     (let* ([method-selected (object 'method)]
            [req-arity (procedure-arity method-selected)]
            [given-arity (length (list input ...))])
       (cond [(boolean? method-selected)
              (error (format "could not find given method: ~a" 'method))]
             ;;check to make sure valid number of args
             [(= req-arity given-arity)
              ((object 'method) input ...)]
             [else (error (format
                           "The function ~a requires ~a argument(s), but ~a argument(s) were given"
                           'method req-arity given-arity))]))]))
          
;;--------------------------------------------

;;new code
(define dillo-class
  (class 
    (initvars length dead?)
    (method longer-than? (len) (> length len))
    (method run-over () (dillo-class (+ length 1) true))))

(define d3 (dillo-class 5 false)) 
(check-expect (send d3 longer-than? 6) false)
(check-expect (send d3 longer-than? 5) false)
(define d4 (send d3 run-over))
(check-expect (send d4 longer-than? 5) true)


(define no-init-vars-class
  (class (initvars)
    (method echo (string) (printf (format "~a~n" string)))))
  
(define NOINITVARS (no-init-vars-class))
(send NOINITVARS echo "hello") ;;prints hello and a carriage return

(define no-methods-class
  (class
      (initvars length width)))

(define NOMETHODS (no-methods-class 3 4))

(define no-initvars-or-methods-class
  (class
      (initvars)))

(define LITERALLYNOTHING (no-initvars-or-methods-class))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; PART 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;a policy is (make-policy symbol list[symbol] list[symbol])
(define-struct policy (title list-of-privileges list-of-types))

(define-syntax policy-checker
  (syntax-rules ()
    [(policy-checker
      (position (privilege ...) (type ...)) ...)
     (lambda (pos priv typ)
       (let* ([policy-list (list 
                           (make-policy 'position (list 'privilege ...) (list 'type ...))
                           ...)]
             [position-exists? (ormap (lambda (pol) 
                                        (symbol=? (policy-title pol) pos)) policy-list)]
             [privilege-exists? (ormap (lambda (pol) 
                                          (member priv (policy-list-of-privileges pol))) policy-list)]
             [type-exists? (ormap (lambda (pol) 
                                    (member typ (policy-list-of-types pol))) policy-list)])
             (cond 
               ;;checks if position given is a valid position
               [(not position-exists?)
                    (error (format "The position ~a does not exist" pos))]
               ;;checks if privilege given is a valid privilege    
               [(not privilege-exists?)
                    (error 
                     (format "The privilege ~a is not a possible privilege ~n 
(you probably mean read or write)" priv))]
               ;;checks if the given type of document is a possible type of document    
               [(not type-exists?)
                    (error (format "~a is not something that anyone can edit" typ))]
               ;;returns false if the specific entry given occurs in the structure
                   [(empty?
                     (filter (lambda (pol) (and
                                            (symbol=? (policy-title pol) pos)
                                            (member priv (policy-list-of-privileges pol))
                                            (member typ (policy-list-of-types pol))))
                             policy-list)) false]
                   [else true])))]))
               
(define check-policy
     (policy-checker
      (programmer (read write) (code documentation))
      (tester (read) (code))
      (tester (write) (documentation))
      (manager (read write) (reports))
      (manager (read) (documentation))
      (ceo (read write) (code documentation reports))))

(check-expect (check-policy 'programmer 'read 'code) true)
(check-expect (check-policy 'manager 'read 'code) false)



(test)







