;; Nathan Dennler and Benjamin Hylak
(load "server.rkt")

;;;;;;;; DATA DEFINITIONS ;;;;;;;
;; a post is (make-post string string)
(define-struct post(name message))

(define POSTS 
  (list (make-post "Nathan Dennler" "Welcome to the forum!")
        (make-post "Ben Hylak" "Enjoy your Stay!")))


;;;;;;;;; WEB SCRIPTS ;;;;;;;;;;;;

;;forum-main-page: forum cookies -> (void)
;;main page where user can view posts or click a button that allows them to write a post
(define-script (forum-main-page forum cookies)
           (values
            (html-page "Forum Main Page"
                       (append (list 'form 
                                     (list (list 'action "http://localhost:8088/authoring-page"))) ;in new window/tab
                               (display-posts POSTS)
                               (list (list 'br) (list 'br)(list 'input (list (list 'type "submit")
                                                                             (list 'value "New Post"))))))
            false))
            

;;authoring page: form cookies-> (void)
;;allows user to write post and then takes user to preview page
(define-script (authoring-page form cookies) ;args ignored
  (values 
   (html-page "Authoring Page"
              (append (list 'form 
                            (list (list 'action "http://localhost:8088/preview-page")
                                  (list 'target "_blank"))) ;in new window/tab
                      
                      (list "Name:"(list 'input (list (list 'ty(lambda (a-dept course get)
       (schedule-teach (first (filter (lambda (y) (= (schedule-course y) course))
               (dept-scheds (first (filter (lambda (x) (symbol=? (dept-name x) a-dept))
               (list (make-dept 'dept1 (list (make-schedule 'courseA 'timeA 'teachA)
                                  ...))
           ...))))))))])pe "text")
                                                      (list 'name "name")))
                            (list 'br))
                      
                      (list "Message:"(list 'br)(list 'input (list (list 'type "text")
                                                      (list 'name "msg")))
                            (list 'br)(list 'br))
                      
                      (list (list 'input (list (list 'type "submit")
                                               (list 'value "Preview"))))))
   ;; no cookie
   false))

;;preview-page: form cookies -> (void)
;;allows user to preview post before final submission
(define-script (preview-page form cookies) ;args ignored
  (let* ([name (cdr (assoc 'name form))]
         [message (cdr (assoc 'msg form))])
    (values 
     (html-page "Preview Page"
                (append (list 'form 
                              (list (list 'action "http://localhost:8088/submit")))
                        
                        (list (string->xexpr (string-append "<p>"
                                                            "<h1>" name "</h1>"
                                                            message
                                                            "</p>")))
                        
                        (list (list 'input (list (list 'type "submit")
                                                 (list 'value "Accept"))))
                        (list (list 'input (list (list 'type "hidden")
                                                 (list 'name "name")
                                                 (list 'value name))))
                        (list (list 'input (list (list 'type "hidden")
                                                 (list 'name "msg")
                                                 (list 'value message)))))
                (append (list 'form 
                              (list (list 'action "http://localhost:8088/submit")))
                        (list (list 'input (list (list 'type "submit")
                                                 (list 'value "Cancel"))))))
     ;; no cookie
     false)))

;;submit: form cookies -> (void)
;;processes submit request and provides option for user to return to home page

;;Note to TA: we chose to make a seperate page for submit because we couldn't
;figure out how to redirect the user to the home page. (If we used invoke, it would have
;;looked like the home page but refreshing would re-run the submit script.)
(define-script (submit form cookies)
  (let* ([name (cdr (assoc 'name form))]
         [message (cdr (assoc 'msg form))]
         [newpost (make-post name message)])
    (begin
      (set! POSTS (cons newpost POSTS))
      (values
       (html-page "Successfully Posted"
                (append (list 'form 
                              (list (list 'action "http://localhost:8088/forum-main-page")))
                        (list "Your post has been successfully submitted.")
                        (list (list 'input (list (list 'type "submit")
                                                 (list 'value "Return"))))))
       false))))

;; format-posts : list[post] -> list[string]
;; produces numbered list of hotel names
(define (format-posts postlist)
  (cond [(empty? postlist) empty]
        [else
         (append (first postlist) (format-posts (rest postlist)))]))

;;display posts: (list[posts]->list[xexpr])
;;produces list of xexpr with post data
(define (display-posts data)
  (format-posts
   (map (lambda (post) 
          (list (string->xexpr (string-append "<p>"
                                              "<h1>" (post-name post) "</h1>"
                                              (post-message post)
                                              "</p>"))))
        data)))
