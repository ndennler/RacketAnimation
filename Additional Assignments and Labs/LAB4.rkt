;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname LAB4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; Kathi Fisler and Charles Rich
;; Stage 1: The basic prototype

;;;;;;;;;;;; THE LANGUAGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a program in this language is a talk

;; a talk is (make-talk list[cmd])
(define-struct talk (cmds))

;; A cmd is either
;; - (make-displaycmd slide)
;; - (make-displaywocmd swo)
(define-struct displaycmd (slide))
(define-struct displaywocmd (swo))

;; a slide is (make-slide string slide-body)
(define-struct slide (title body))
;;a slide-with-overlays is (make-swo string slide-body list[overlay]
(define-struct swo(title body overlays))

;;an overlay is either
;; -  string
;; - pointlist 

;; a slide-body is either
;;  - a string (paragraph), or
;;  - a (make-pointlist list[string] boolean)
(define-struct pointlist (points numbered?))

;; example talk

(define talk1
  (let ([intro-slide
         (make-swo "Hand Evals in DrRacket"
                     "Hand evaluation helps you learn how Racket reduces programs to values" empty)]
        [arith-eg-slide
         (make-swo "Example 1" ""
                     (list (make-pointlist (list "(+ (* 2 3) 6)") 
                                     false)
                           (make-pointlist (list "(+ (* 2 3) 6)"
                                           "(+ 6 6)"
                                           "12") 
                                     false)))]
        [func-eg-slide
         (make-swo "Example 2" ""
                     (list (make-pointlist (list "(define (foo x) (+ x 3))" )
                                     false)
                     (make-pointlist (list "(define (foo x) (+ x 3))" 
                                            "(* (foo 5) 4)" )
                                     false)
                     (make-pointlist (list "(define (foo x) (+ x 3))" 
                                            "(* (foo 5) 4)" 
                                            "(* (+ 5 3) 4)")
                                     false)
                     (make-pointlist (list "(define (foo x) (+ x 3))" 
                                            "(* (foo 5) 4)" 
                                            "(* (+ 5 3) 4)"
                                            "(* 8 4)")                                    
                                     false)
                     (make-pointlist (list "(define (foo x) (+ x 3))" 
                                            "(* (foo 5) 4)" 
                                            "(* (+ 5 3) 4)"
                                            "(* 8 4)"
                                            "32")
                                     false)))]
        [summary-slide
         (make-swo "Summary: How to Hand Eval"
                   ""
                   (list (make-pointlist (list
                                         "Find the innermost expression") true)
                         (make-pointlist (list
                                         "Find the innermost expression"
                                         "Evaluate one step") true)
                         (make-pointlist (list
                                         "Find the innermost expression"
                                         "Evaluate one step"
                                         "Repeat until have a value") true)
                         ))])
    (make-talk
     (list (make-displaywocmd intro-slide)
           (make-displaywocmd arith-eg-slide)
           (make-displaywocmd func-eg-slide)
           (make-displaywocmd summary-slide)))))

;;;;;;;;;;;;;;;; THE INTERPRETER ;;;;;;;;;;;;;;;;;;;;;;;;;;

;; run-talk : talk -> void
;; executes the commands in a talk then displays end-of-show message
(define (run-talk a-talk)
  (begin
    (run-cmdlist (talk-cmds a-talk))
    (end-show)))

;; run-cmdlist : list[cmd] -> void
;; executes every command in a list
(define (run-cmdlist cmd-lst)
  (for-each run-cmd cmd-lst))

;; run-cmd : cmd -> void
;; executes the given command
(define (run-cmd cmd)
  (cond [(displaycmd? cmd) 
         (begin (print-slide (displaycmd-slide cmd))
                (await-click))]
        [(displaywocmd? cmd)
         (begin (print-swo (displaywocmd-swo cmd))
                (await-click))
         ]))

;;print-swo: swo -> void
;;prints a slide with overlays one overlay at a time
(define (print-swo swo)
  (let [(aslide (make-slide (swo-title swo) (swo-body swo)))]
    (cond [(empty? (swo-overlays swo))
           (begin
             (print-slide aslide))]
          [(cons? (swo-overlays swo))
           (begin
             (print-slide aslide)
             (await-click)
             (print-swo (make-swo (swo-title swo) (first (swo-overlays swo)) (rest (swo-overlays swo)))))])))
    

;; print-slide : slide -> void
;; displays contents of slide on screen
(define (print-slide aslide)
  (begin
    (print-string "------------------------------")    
    (print-slide-title (slide-title aslide))
    (print-slide-body (slide-body aslide) 1)
    (print-string "------------------------------")))

;; print-slide-title : string -> void
;; displays title of slide on screen
(define (print-slide-title title-str)
  (begin
    (print-string (string-append "Title: " title-str))
    (print-newline)))
  
;; print-slide-body : slide-body number-> void
;; displays contents of body on screen
(define (print-slide-body body label)
  (cond [(string? body) (print-string body)]
        [(pointlist? body) 
         (cond [(pointlist-numbered? body) 
                (print-numbered-strings (pointlist-points body) label)]
               [else (print-unnumbered-strings (pointlist-points body))])]))

;; end-show : -> void
;; displays end of show message on screen
(define (end-show) (print-string "End of show"))

;;;;;;;;;;;;;;; THE INTERFACE HELPERS ;;;;;;;;;;;;;;;;;;;;;;;

;; print-string : string -> void
;; prints string and a newline to the screen
(define (print-string str)
  (printf "~a~n" str))

;; print-newline : -> void
;; prints a newline on the screen
(define (print-newline) (printf "~n"))

;; print-unnumbered-strings : list[string] -> void
;; prints a list of strings to the screen, each prefixed with a -
(define (print-unnumbered-strings strlist)
  (for-each (lambda (str) (printf "- ~a~n" str)) strlist))

;; print-numbered-strings : list[string] number -> void
;; prints a list of strings to the screen, each prefixed with
;;   a number (in consecutive increasing order)
(define (print-numbered-strings strlist label)
  (cond [(empty? strlist) (void)]
        [(cons? strlist) 
         (begin
           (printf "~a. ~a~n" label (first strlist))
           (print-numbered-strings (rest strlist) (+ 1 label)))]))

;; await-click : -> void
;; mimics a mouse click by waiting for the user to type a character
(define (await-click) (read))