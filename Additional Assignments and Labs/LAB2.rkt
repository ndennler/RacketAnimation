;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname LAB2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #t)))
;; Nathaniel Dennler CS 1102

#|

For each of the following expressions, try to predict (a) what they will return and (b) what the length of the resulting list is, then check your answers in DrRacket: 

(cons empty empty) -> (list empty) -> length 1
(list empty empty) -> (list empty empty) -> length 2
(append empty empty) -> empty -> length 0
(cons (list 1 2 3) (list 4 5)) -> (list (list 1 2 3)  4 5) -> length 3
(list (list 1 2 3) (list 4 5)) -> (list (list 1 2 3) (list 4 5))-> length 2
(append (list 1 2 3) (list 4 5)) -> (list 1 2 3 4 5) -> length 5

|#

;;a transition is (make-transition string string string)
(define-struct transition (source label target))

;;Example: (make-transition "5-cents" "nickel" "10-cents")

#|
(define (transition-fun a-transition)
  ...(transition-source a-transition)...
  ...(transition-label a-transition)...
  ...(transition-target a-transition)...)
|#

;;a list-of-X is either:
;;- empty
;;- (cons transition list-of-X)

#|
(define (lot-fun a-loX)
  (cond[(empty? a-loX) ...]
       [(cons? a-loX)
         ...
        (loX-fun (rest a-loX))]))
|#

(define soda-machine (list (make-transition "0-cents" "nickel" "5-cents")
                           (make-transition "0-cents" "dime" "10-cents")
                           (make-transition "5-cents" "nickel" "10-cents")
                           (make-transition "5-cents" "dime" "15-cents")
                           (make-transition "10-cents" "nickel" "15-cents")
                           (make-transition "10-cents" "dime" "20-cents")
                           (make-transition "15-cents" "nickel" "20-cents")
                           (make-transition "15-cents" "dime" "soda")
                           (make-transition "20-cents" "nickel" "soda")
                           (make-transition "20-cents" "dime" "soda")
                           (make-transition "soda" "nickel" "soda")
                           (make-transition "soda" "dime" "soda")))

;;get-next-state: string string list-of-transitions -> string
;;consumes state-name an action, and a list of transitions, and gives the next state-name
(check-expect (get-next-state "0-cents" "dime" soda-machine) "10-cents")
(check-expect (get-next-state "soda" "nickel" soda-machine) "soda")
(check-expect (get-next-state "0-cents" "dome" soda-machine) "action does not exist at given state")

(define (get-next-state a-name an-action a-lot)
  (cond[(empty? a-lot) "action does not exist at given state"]
       [(cons? a-lot)
        (cond [(and (string=? a-name (transition-source (first a-lot)))
               (string=? an-action (transition-label (first a-lot))))
               (transition-target (first a-lot))]
              [else(get-next-state a-name an-action (rest a-lot))])]))


;;get-state-sequence: string list-of-actions list-of-transitions -> list-of-state-names
;;consumes a starting state, a list of actions, and a list of transitions and gives
;;a list of state names that lead up to the desired state destnationstart at the start state and end
;;at the result of taking the actions guiven in the list of actions
(check-expect (get-state-sequence "0-cents" (list "nickel" "dime" "nickel") soda-machine)
              (list "0-cents" "5-cents" "15-cents" "20-cents"))
(check-expect (get-state-sequence "0-cents" (list "nickel" "dime" "dime" "nickel") soda-machine)
              (list "0-cents" "5-cents" "15-cents" "soda" "soda"))
(check-expect (get-state-sequence "0-cents" empty soda-machine)
              (list "0-cents"))

(define (get-state-sequence start a-loa a-lot)
  (cond[(empty? a-loa) (cons start empty)]
       [(cons? a-loa)       
        (cons start
              (get-state-sequence
               (get-next-state start (first a-loa) a-lot)
               (rest a-loa)
               a-lot))]))

;;gets-soda?: list-of-actions -> boolean
;;indicates if the action path eventually visits the soda state
(check-expect (gets-soda? (list "nickel" "dime" "nickel")) false)
(check-expect (gets-soda? (list "nickel" "dime" "nickel" "dime")) true)
(check-expect (gets-soda? empty) false)

(define (gets-soda? a-loa)
  (cond [(empty? a-loa) false]
        [(cons? a-loa)
         (cond [(not(member "soda" (get-state-sequence "0-cents" a-loa soda-machine))) false]
               [else true])]))

;;find-non-det-states: list-of-transitions -> list-of-states
;;consumes a list of transitions and returns a list of states that have different outcomes for same action
;; list is assumed to be sorted by source state and action.
(check-expect (find-non-det-states soda-machine) empty)
(check-expect (find-non-det-states (list (make-transition "0-cents" "nickel" "5-cents")
                                         (make-transition "0-cents" "nickel" "10-cents")
                                         (make-transition "5-cents" "dime" "10-cents")
                                         (make-transition "5-cents" "dime" "15-cents")
                                         (make-transition "10-cents" "nickel" "15-cents")
                                         (make-transition "10-cents" "nickel" "15-cents")
                                         (make-transition "15-cents" "nickel" "20-cents")
                                         (make-transition "15-cents" "dime" "soda")
                                         (make-transition "20-cents" "nickel" "soda")
                                         (make-transition "20-cents" "dime" "soda")
                                         (make-transition "soda" "nickel" "soda")
                                         (make-transition "soda" "dime" "soda")))
              (list(make-transition "0-cents" "nickel" "5-cents")
                   (make-transition "0-cents" "nickel" "10-cents")
                   (make-transition "5-cents" "dime" "10-cents")
                   (make-transition "5-cents" "dime" "15-cents")))

(define (find-non-det-states a-lot)
  (cond [(empty? (rest a-lot)) empty]
        [(cons? (rest a-lot))
         (cond [(and (string=? (transition-source (first a-lot)) (transition-source (first (rest a-lot))))
                     (string=? (transition-label (first a-lot)) (transition-label (first (rest a-lot)))))
                (cond [(not(string=? (transition-target (first a-lot)) (transition-target (first (rest a-lot)))))
                       (append (list (first a-lot) (first (rest a-lot))) (find-non-det-states (rest a-lot)))]
                      [else (find-non-det-states (rest a-lot))])]
               [else (find-non-det-states (rest a-lot))])]))

                           












