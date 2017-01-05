;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname Hwk3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;;Benjamin Hylak and Nathan Dennler

;;file is (make-file symbol number value)
(define-struct file (name size content))

#|
(define (file-fun a-file)
  ...(file-name a-file)...
  ...(file-size a-file)...
  ...(file-content a-file)...)
|#

;;list of files is either
;;-empty, or
;;-(cons file list-of-files)

#|
(define (lof-fun a-lof)
  (cond [(empty? a-lof)...]
        [(cons? a-lof)
         ...(file-fun (first a-lof))...
         ...(lof-fun (rest a-lof))]))
|#


;;dir is (make-dir symbol list-of-dirs list-of-files)
(define-struct dir (name dirs files))

#|
(define (dir-fun a-dir)
  ...(dir-name a-dir)...
  ...(lod-fun (dir-dirs a-dir))...
  ...(lof-fun (dir-files a-dir))...)
|#

;;list-of-dirs is either
;;-empty
;;-(cons dir list-of-dirs)
  
#|
(define (lod-fun a-lod)
  (cond[(empty? a-lod)...]
       [(cons? a-lod)
        ...(dir-fun (first a-lod))
        ...(lod-fun (rest a-lod))]))
|#

;;functions over systems template

#|
(define (sys-fun a-sys)
  ...(dir-name a-sys)...
  ...(lod-fun (dir-dirs a-sys))...
  ...(lof-fun (dir-files a-sys))...)

(define (lod-fun a-lod)
  (cond[(empty? a-lod)...]
       [(cons? a-lod)
        ...(dir-fun (first a-lod))
        ...(lod-fun (rest a-lod))]))

(define (lof-fun a-lof)
  (cond [(empty? a-lof)...]
        [(cons? a-lof)
         ...(file-fun (first a-lof))...
         ...(lof-fun (rest a-lof))]))
|#

(define SYSTEM1 (make-dir 'SYSTEM1 (list (make-dir 'Folder01
                                                   empty
                                                   (list (make-file 'BIG 100 empty)
                                                         (make-file 'HUGE 5340 empty)
                                                         (make-file 'JUNK1 0 empty)
                                                         (make-file 'IMPORTANT 10 42)
                                                         (make-file 'CRITICAL 20 "Launch Codes")))
                                         (make-dir 'Folder02
                                                   empty
                                                   (list(make-file 'JUNK2 0 empty)
                                                        (make-file 'GIGANTIC 21340 empty)
                                                        (make-file 'JUNK3 0 empty)))
                                         (make-dir 'Folder03
                                                   (list (make-dir 'Folder001 empty empty))
                                                   empty))
                          (list (make-file 'JUNK4 0 empty)
                                (make-file 'JUNK5 0 empty)
                                (make-file 'DESIRABLE 5 empty)
                                (make-file 'JUNK6 0 empty))))



(define ANIMALS (make-dir 'animals
                          (list (make-dir 'mammals
                                          (list (make-dir 'dogs empty (list (make-file 'Chihuahua 100 empty)
                                                                            (make-file 'ShibaInu 10 empty)
                                                                            (make-file 'GoldenRetreiver 50 empty)))
                                                (make-dir 'cats empty (list (make-file 'MaineCoon 103 empty)
                                                                            (make-file 'Abyssinian 7 empty)
                                                                            (make-file 'Tabby 98 empty))))
                                          empty)
                                (make-dir 'fish empty
                                          (list (make-file 'Shark 9 empty)
                                                (make-file 'SwordFish 120 empty)
                                                (make-file 'Salmon 18 empty)
                                                (make-file 'Trout 53 empty)))
                                (make-dir 'birds
                                          (list (make-dir 'tropical empty
                                                          (list (make-file 'Parrot 73 empty)
                                                                (make-file 'Toucan 43 empty)))
                                                (make-dir 'newengland
                                                          (list (make-dir 'finches empty
                                                                          (list (make-file 'HouseFinch 12 empty)
                                                                                (make-file 'GoldenFinch 112 empty))))
                                                          (list (make-file 'IndigoBunting 999 empty)
                                                                (make-file 'BlueJay 3 empty))))
                                          (list (make-file 'Test1 0 empty)
                                                (make-file 'Test2 1 empty))))
                                (list (make-file 'ClassificationRules 0 empty))))

(define BOOKS (make-dir 'BOOKS
                        (list (make-dir 'FICTION
                                        (list (make-dir 'FANTASY empty
                                                        (list (make-file 'LordoftheRings 20 "Tolkien")
                                                              (make-file 'TheHobbit 20 "Tolkien")
                                                              (make-file 'AWrinkleinTime 99 "L'Engle")))
                                              (make-dir 'SCIENCEFICTION empty
                                                        (list (make-file 'Dune 804 "Herbert")
                                                              (make-file 'HitchhikersGuidetotheGalaxy 42 "Adams")
                                                              (make-file 'IRobot 376 "Asimov")))
                                              (make-dir 'DYSTOPIANFUTURE empty
                                                        (list (make-file 'NineteenEightyFour 1984 "Orwell")
                                                              (make-file 'Fahrenheit451 451 "Bradbury")
                                                              (make-file 'HungerGames 13 "Collins"))))
                                        empty)
                              (make-dir 'NONFICTION
                                        (list (make-dir 'BIOGRAPHY empty
                                                        (list (make-file 'DiaryOfAYoungGirl 1940 "Frank")
                                                              (make-file 'APieceofCake 422 "Brown")
                                                              (make-file 'Walden 32459 "Thoreau")))
                                              (make-dir 'SCIENTIFIC empty
                                                        (list (make-file 'Cosmos 804 "Sagan")
                                                              (make-file 'ABriefHistoryofTime 345 "Hawking")
                                                              (make-file 'GodCreatedTheIntegers 587 "Hawking"))))
                                        empty))
                        empty))


;;any-huge-files? dir number -> boolean
;;Determines if any of the files in the directory are above the given value

(check-expect (any-huge-files? SYSTEM1 100) true)
(check-expect (any-huge-files? SYSTEM1 1000000) false)

(define (any-huge-files? a-dir limit)
  (or (lof-has-big? (dir-files a-dir) limit)
      (lod-has-big? (dir-dirs a-dir) limit)))

;;lof-has-big?: list-of-files max-size -> boolean
;;consumes a list of files and a number and returns a boolean
;;if any files in the list has a file size greater than max-size
(check-expect (lof-has-big? (dir-files SYSTEM1) 1) true)
(check-expect (lof-has-big? (dir-files SYSTEM1) 1000000) false)

(define (lof-has-big? a-lof max-size)
  (cond [(empty? a-lof) false]
        [(cons? a-lof)
         (cons? (filter (lambda (a-file) (< max-size (file-size a-file))) a-lof))]))

;;lod-has-big?: list-of-dirs -> boolean
;;determines if there are oversized files in the list of dirs
(check-expect (lod-has-big? (dir-dirs SYSTEM1) 1) true)
(check-expect (lod-has-big? (dir-dirs SYSTEM1) 1000000) false)

(define (lod-has-big? a-lod limit)
  (cond [(empty? a-lod) false]
        [(cons? a-lod)
         (or (any-huge-files? (first a-lod) limit)
             (lod-has-big? (rest a-lod) limit))]))

;;clean-directory: dir symbol -> dir
;;finds directory with given name and removes files with 0 size
(check-expect (clean-directory ANIMALS 'birds)  (make-dir 'animals
                          (list (make-dir 'mammals
                                          (list (make-dir 'dogs empty (list (make-file 'Chihuahua 100 empty)
                                                                            (make-file 'ShibaInu 10 empty)
                                                                            (make-file 'GoldenRetreiver 50 empty)))
                                                (make-dir 'cats empty (list (make-file 'MaineCoon 103 empty)
                                                                            (make-file 'Abyssinian 7 empty)
                                                                            (make-file 'Tabby 98 empty))))
                                          empty)
                                (make-dir 'fish empty
                                          (list (make-file 'Shark 9 empty)
                                                (make-file 'SwordFish 120 empty)
                                                (make-file 'Salmon 18 empty)
                                                (make-file 'Trout 53 empty)))
                                (make-dir 'birds
                                          (list (make-dir 'tropical empty
                                                          (list (make-file 'Parrot 73 empty)
                                                                (make-file 'Toucan 43 empty)))
                                                (make-dir 'newengland
                                                          (list (make-dir 'finches empty
                                                                          (list (make-file 'HouseFinch 12 empty)
                                                                                (make-file 'GoldenFinch 112 empty))))
                                                          (list (make-file 'IndigoBunting 999 empty)
                                                                (make-file 'BlueJay 3 empty))))
                                          (list (make-file 'Test2 1 empty))))
                                (list (make-file 'ClassificationRules 0 empty))))

(check-expect (clean-directory SYSTEM1 'Folder01) (make-dir 'SYSTEM1 (list (make-dir 'Folder01
                                                   empty
                                                   (list (make-file 'BIG 100 empty)
                                                         (make-file 'HUGE 5340 empty)
                                                         (make-file 'IMPORTANT 10 42)
                                                         (make-file 'CRITICAL 20 "Launch Codes")))
                                         (make-dir 'Folder02
                                                   empty
                                                   (list(make-file 'JUNK2 0 empty)
                                                        (make-file 'GIGANTIC 21340 empty)
                                                        (make-file 'JUNK3 0 empty)))
                                         (make-dir 'Folder03
                                                   (list (make-dir 'Folder001 empty empty))
                                                   empty))
                          (list (make-file 'JUNK4 0 empty)
                                (make-file 'JUNK5 0 empty)
                                (make-file 'DESIRABLE 5 empty)
                                (make-file 'JUNK6 0 empty))))

(define (clean-directory a-dir name)
  (make-dir (dir-name a-dir)
            (clean-directory-lod (dir-dirs a-dir) name)
            (cond [(symbol=? name (dir-name a-dir))
                   (filter (lambda (file) (< 0 (file-size file))) (dir-files a-dir))]
                  [else
                   (dir-files a-dir)])))

;;clean-directory-lod: list-of-dirs symbol -> list-of-dirs
;;returns a list of dirs that will be used to reconstruct the file system

(define (clean-directory-lod a-lod name)
  (cond[(empty? a-lod) empty]
       [(cons? a-lod)
        (cond [(or (ormap (lambda (dir) (symbol=? (dir-name dir) name)) (dir-dirs (first a-lod)))
               (symbol=? name (dir-name (first a-lod)))) 
               (cons (clean-directory (first a-lod) name) (clean-directory-lod (rest a-lod) name))]
              [else
               (cons (first a-lod) (clean-directory-lod (rest a-lod) name))])]))


;;find-file-path: sys symbol -> list-of-dirs or boolean
;;takes a filesystem and a filename, and returns the path to the file if it exists,
;;or it returns false if it does not

(check-expect (find-file-path ANIMALS 'GoldenFinch) (list 'animals 'birds 'newengland 'finches))
(check-expect (find-file-path BOOKS 'Lolita) false)

(define (find-file-path a-sys name)
  (cond [(exists? a-sys name)
         (cons (dir-name a-sys) (file-path-lod (dir-dirs a-sys) name))]
        [else false]))

;;file-path-lod: list-of-dirs symbol -> dir
;;finds which directory in the list has the target file

(define (file-path-lod a-lod name)
  (cond [(empty? a-lod) empty]
        [(cons? a-lod)
         (cond [(exists? (first a-lod) name)
                (find-file-path (first a-lod) name)]
               [else (file-path-lod (rest a-lod) name)])]))


;;exists?: dir symbol->boolean
;;determines if file name is in dir
(check-expect (exists? BOOKS 'AWrinkleinTime) true)
(check-expect (exists? ANIMALS 'Axolotl) false)

(define (exists? a-dir name)
  (or (exists-lod? (dir-dirs a-dir) name)
      (cons? (filter (lambda (x) (symbol=? name (file-name x))) (dir-files a-dir)))))

;;exists-lod?: list-of-directories symbol -> boolean
;;determines if the file with the given name exists somewhere in the list of directories

(define (exists-lod? a-lod name)
  (cond [(empty? a-lod) false]
        [(cons? a-lod)
         (or (exists? (first a-lod) name)
             (exists-lod? (rest a-lod) name))]))

;;file-names-satisfying : dir [file -> boolean] -> list[symbols]
;;takes a directory and a function that takes a file to a boolean (called keep?), and generates a list
;;of files that satisfy the function
(check-expect (file-names-satisfying ANIMALS (lambda(file) (< 300 (file-size file)))) (list 'IndigoBunting))
(check-expect (file-names-satisfying SYSTEM1 (lambda(file) (empty? (file-content file))))
              (list 'JUNK4 'JUNK5 'DESIRABLE 'JUNK6 'BIG 'HUGE 'JUNK1 'JUNK2 'GIGANTIC 'JUNK3))
(check-expect (file-names-satisfying SYSTEM1 (lambda(file) (symbol=? 'GIGANTIC (file-name file)))) (list 'GIGANTIC))
(check-expect (file-names-satisfying BOOKS (lambda(file) (= 5 (string-length (file-content file))))) (list 'HitchhikersGuidetotheGalaxy 'DiaryOfAYoungGirl 'APieceofCake 'Cosmos))

(define (file-names-satisfying sys keep?)
  (append
  (map file-name (filter keep? (dir-files sys)))
  (file-names-satisfying-lod (dir-dirs sys) keep?)))

;;file-names-satisfying-lod: list[dirs] [file->boolean] -> list[symbols]
;;exlpores the rest of the directories for files that satisfy function, and calls
;;file-names-satisfying to get the  list of symbols.

(define (file-names-satisfying-lod a-lod keep?)
  (cond[(empty? a-lod) empty]
       [(cons? a-lod)
        (append
        (file-names-satisfying (first a-lod) keep?)
        (file-names-satisfying-lod (rest a-lod) keep?))]))
  
;;files-containing sys value -> list[symbols]
;;examines tree for files containing given value in content, and returns a list of their names
(check-expect (files-containing SYSTEM1 "Launch Codes") (list 'CRITICAL))
(check-expect (files-containing SYSTEM1 "?????") empty)

(define (files-containing sys value)
  (file-names-satisfying sys (lambda (file) (equal? (file-content file) value))))





        