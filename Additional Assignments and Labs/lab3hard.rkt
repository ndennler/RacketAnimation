;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname lab3hard) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #t)))
;;Nathan Dennler

;; A formula is one of
;; - boolean
;; - symbol
;; - (make-notf formula)
;; - (make-andf formula formula)
;; - (make-orf formula formula)
(define-struct notf (fmla))
(define-struct andf (fmla1 fmla2))
(define-struct orf (fmla1 fmla2))

(define laptop-conf (make-andf 'hard-disk (make-orf 'track-point 'track-pad)))
(define TEST (make-andf (make-orf 'yes 'no) (make-andf 'yes 'no)))
;;eval-formula: formula list-of-symbols -> boolean
;;determines if formula is true or false
(define (eval-formula fmla los)
  (cond [(andf? fmla)
         (andf-eval fmla los)]
        [(orf? fmla)
         (orf-eval fmla los)]
        [(notf? fmla)
         (notf-eval fmla los)]
        [(symbol? fmla)
         (member fmla los)]
        [(boolean? fmla)
         fmla]
        ))
(define (operator? fmla)
  (cond[(or (andf? fmla) (orf? fmla) (notf? fmla)) true]
       [else false]))



         
(define (andf-eval fmla los)
  (cond[(cons? los)
        (cond [(and (symbol? (andf-fmla1 fmla))
                    (symbol? (andf-fmla2 fmla)))
               (and (member (andf-fmla1 fmla) los)
                    (member (andf-fmla2 fmla) los))]
              
              [(and (operator? (andf-fmla1 fmla))
                    (symbol? (andf-fmla2 fmla)))
               (and (member (andf-fmla2 fmla) los)(eval-formula (andf-fmla1 fmla) los))]
              [(and (operator? (andf-fmla2 fmla))
                    (symbol? (andf-fmla1 fmla)))
               (and (member (andf-fmla1 fmla) los)(eval-formula (andf-fmla2 fmla) los))]
              
              [(and (boolean? (andf-fmla1 fmla)) (boolean? (andf-fmla2 fmla)))
               (and (andf-fmla1 fmla)(andf-fmla2 fmla))]
              
              [(and (boolean? (andf-fmla1 fmla))(symbol? (andf-fmla2 fmla)))
               (and (andf-fmla1 fmla) (member (andf-fmla2 fmla) los))]
              [(and (boolean? (andf-fmla2 fmla))(symbol? (andf-fmla1 fmla)))
               (and (andf-fmla2 fmla) (member (andf-fmla1 fmla) los))]
              
              [(and (operator? (andf-fmla1 fmla))
                    (boolean? (andf-fmla2 fmla)))
               (and (andf-fmla2 fmla)(eval-formula (andf-fmla1 fmla) los))]
              [(and (operator? (andf-fmla2 fmla))
                    (boolean? (andf-fmla1 fmla)))
               (and (andf-fmla1 fmla)(eval-formula (andf-fmla2 fmla) los))]
              
              [(and (operator? (andf-fmla1 fmla))(operator? (andf-fmla2 fmla)))
               (and (eval-formula (andf-fmla1 fmla) los) (eval-formula (andf-fmla2 fmla) los))])]

       
       [(empty? los) false]))

(define (orf-eval fmla los)
  (cond[(cons? los)
        (cond
          [(and (symbol? (orf-fmla1 fmla))(symbol? (orf-fmla2 fmla)))
               (or (member (orf-fmla1 fmla) los)(member (orf-fmla2 fmla) los))]
              
              [(and (operator? (orf-fmla1 fmla))(symbol? (orf-fmla2 fmla)))
               (or (eval-formula (orf-fmla1 fmla) los) (member (orf-fmla2 fmla) los)) ]
              [(and (operator? (orf-fmla2 fmla))(symbol? (orf-fmla1 fmla)))
               (or (member (orf-fmla1 fmla) los)(eval-formula (orf-fmla2 fmla) los))]
              
              [(and (boolean? (orf-fmla1 fmla)) (boolean? (orf-fmla2 fmla)))
               (or (orf-fmla1 fmla)(orf-fmla2 fmla))]
              
              [(and (boolean? (orf-fmla1 fmla))(symbol? (orf-fmla2 fmla)))
               (or (orf-fmla1 fmla) (member (orf-fmla2 fmla) los))]
              [(and (boolean? (orf-fmla2 fmla))(symbol? (orf-fmla1 fmla)))
               (or (orf-fmla2 fmla) (member (orf-fmla1 fmla) los))]

              [(and (operator? (orf-fmla1 fmla))
                    (boolean? (orf-fmla2 fmla)))
               (or (andf-fmla2 fmla)(eval-formula (orf-fmla1 fmla) los))]
              [(and (operator? (orf-fmla2 fmla))
                    (boolean? (orf-fmla1 fmla)))
               (or (orf-fmla1 fmla)(eval-formula (orf-fmla2 fmla) los))]
              
              [(and (operator? (orf-fmla1 fmla))(operator? (orf-fmla2 fmla)))
               (or (eval-formula (orf-fmla1 fmla)) (eval-formula (orf-fmla2 fmla)))])]
       [(empty? los) false]))

(define (notf-eval fmla los)
  (cond[(cons? los)
        (cond [(boolean? (notf-fmla fmla))
               (not fmla)]
              [(symbol? (notf-fmla fmla))
               (not (member (notf-fmla los)))]
              [(andf? (notf-fmla fmla))
               (not (eval-formula (notf-fmla)))]
              [(orf? (notf-fmla fmla))
               (not (eval-formula (notf-fmla)))]
              [(notf? (notf-fmla fmla))
               (not (eval-formula (notf-fmla)))])]
       [(empty? los) true]))

;;formulas-equiv? : formula formula list[symbols]->boolean
;; determines if formulas are equal
(define (formulas-equiv? fmla1 fmla2 los)
  (andmap (lambda (x) (equal? (eval-formula fmla1 x) (eval-formula fmla2 x))) (sublists los)))





;;sublists: list[symbols] -> list[list[symbols]]
(define (sublists los)
  (cond[(empty? los)(cons empty empty)]
       [(cons? los)
        (let ((op (sublists (rest los)))
              (fl (first los)))
          (append op (map (lambda (x) (cons fl x)) op)))]))


              
  
                     









                       