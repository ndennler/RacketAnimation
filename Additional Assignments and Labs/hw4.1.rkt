;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname hw4.1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;;;;;;;;; THE LANGUAGE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;a program in this language is an exam

;;An exam is (make-exam list[symbols] list[prompt])
(define-struct exam (subjects prompts))

;;A prompt is either
;;(make-dispquestion question), or
;;(make-dispmessage string), or
;;(make-dispsummary summary), or
;;(make-needspractice (symbol -> boolean) list[prompt] list[prompt])
(define-struct dispquestion (question))

;;needshint? will check if the user types hint (or whatever the word happens to be)
(define-struct dispmessage (message))
(define-struct dispsummary (summary))
(define-struct needspractice (doingwell? easy hard))
;;doingwell? would take the subject name, and determine if the student is doing well enough to move on

;;a subject is a symbol

;;a question is either a:
;; 1. (make-simplequestion string list[string] subject), or
;; 2. (make-hintquestion simplequestion string)
(define-struct simplequestion (content answers subject))

;;a hintquestion is a (make-hintquestion (question string))
(define-struct hintquestion (aquestion hint))

;;a summary is (make-summary toScore)

;;toScore is either
;; 1. a subject or,
;; 2. 'overall

(define-struct summary (toScore))

;;;;;;;;;;;;; EXAMPLE EXAMS ;;;;;;;;;;;;;;;

(define math-exam
  (let(
       [question1
        (make-simplequestion "What is 3*4+2?" (list "14" "fourteen") 'arithmetic)]
       [question2
        (make-simplequestion "What is 2+3*4?" (list "14" "fourteen") 'arithmetic)]
       [question3
        (make-simplequestion "What is 5+2*6?" (list "17" "seventeen") 'arithmetic)]
       [question4
        (make-simplequestion "What is 3+5*2?" (list "13" "thirteen") 'arithmetic)]
       [question5
        (make-simplequestion "What is the reduced form of 12/18?: (1) 6/9 (2) 1/1.5 (3) 2/3" (list "3" "(3)") 'fractions)]
       [question6
        (make-simplequestion "What is 8+3*2?" (list "14" "fourteen") 'arithmetic)]
       [question7
        (make-simplequestion "What is 1/4 + 1/2?: (1) 3/4  (2) 1/6  (3) 2/6" (list "1" "(1)") 'fractions)])
        
       (make-exam
        (list 'arithmetic 'fractions)
        (list
                    (make-dispquestion question1)
                    (make-dispquestion question2)
                    (make-dispquestion question3)
                    (make-needspractice (lambda (arithmeticpercent) (< arithmeticpercent 50))
                                            (list
                                             (make-dispmessage  "You seem to be having trouble with this. Try again.")
                                             (make-dispquestion question4)
                                             (make-dispquestion question5)
                                             (make-dispquestion question6))
                                            (list
                                             (make-dispquestion question5)
                                             (make-dispquestion question7)))
                    
                    (make-dispsummary (make-summary 'arithmetic))
                    (make-dispsummary (make-summary 'fractions))))))

(define wpi-history
  (let (
        [question1
        (make-simplequestion "When was WPI founded?" (list "1865") 'general)]
       [question2
        (make-simplequestion "What is Gompei?" (list "Goat" "a goat") 'personality)]
       [question3
        (make-simplequestion "Who was the first president of WPI?: (1) Boynton (2) Washburn (3) Thompson" (list "3" "(3)") 'personality)]
       [question4
        (make-simplequestion "Name one of the two towers behind a WPI education" (list "Theory" "Practice") 'general)]
       [hint
        "Think bleating"])

    (make-exam
     (list 'general 'personality)
     (list
                (make-dispquestion question1)
                (make-dispmessage "Let's see if you know your WPI personalities")
                (make-dispquestion (make-hintquestion question2  hint))
                (make-dispquestion question3)
                (make-dispsummary (make-summary 'personality))
                (make-dispquestion question4)
                (make-dispsummary (make-summary 'general))
                (make-dispmessage"There's more WPI history on the web. And life.")))))







