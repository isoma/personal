(defpackage :lib-eb
  (:use :common-lisp :cffi))

(in-package :lib-eb)

(progn
  (if (and (foreign-symbol-pointer "eb_initialize_library")
           (nth-value 1 (intern "*libeb*")))
      (close-foreign-library *libeb*))
  (defvar *libeb*)
  (define-foreign-library libeb
      (:unix (:or "libeb.so" "libeb.so.13.1.0"))
    (t (:default "libeb")))
  (setf *libeb* (use-foreign-library libeb))
  (load "/home/soma/personal/akagi/eb.lisp"))


(let ((return-code (eb_initialize_library)))
  (if (/= return-code EB_SUCCESS)
      (error "eb_initialize_library() failed.(code = ~d)" return-code)
       return-code))

(defconstant MAX_HITS 50)
(defconstant MAX-FIND-WORD-LENGTH 100)
(defconstant MAXLEN_HEADING 127)


;; (eb_finalize_library)

(defun check-book-type (path)
  (with-foreign-pointer (book (foreign-type-size 'EB_Book_Struct))
    (eb_initialize_book  book)
    (with-foreign-string (book-path  path)
      (let((return-code  (eb_bind book book-path)))
        (if (/= return-code EB_SUCCESS)
            (error "Failed to bind the book, ~S: ~S~%" 
                   (eb_error_message return-code) path))
        (with-foreign-object (code :int)
          (if (/= EB_SUCCESS (setf return-code (eb_disc_type book code))) ; get dictonaly type 
              (error "Failed to bind the book, ~S: ~S~%" 
                     (eb_error_message return-code) path)
              (case (mem-ref code :int)
                (#.EB_DISC_EB (format t "~s is DISC_EB." path ))
                (#.EB_DISC_EPWING (format t "~s is DISC EPWING.~%" path))
                (#.EB_DISC_INVALID (format t "~s is invalided.~%" path))
                (t nil)))
          (with-foreign-objects 
              ((sub_count :int)
               (sub_codes :int  EB_MAX_SUBBOOKS)
               (title :char (1+ EB_MAX_TITLE_LENGTH))
               (book-charcter-code :int))
            (progn
              (if (and 
                   (/= EB_SUCCESS (setf return-code (eb_subbook_list book sub_codes sub_count)))
                   (/= EB_SUCCESS (setf return-code (eb_set_subbook book sub_codes))))
                  (error "Failed to get subbooks info from the book, ~S: ~S~%" 
                         (eb_error_message return-code) path)
                  (format t "It has ~d subbooks.~%" (mem-ref sub_count :int )))
              (if (/= EB_SUCCESS (setf return-code (eb_character_code book book-charcter-code)))
                   (error "Failed to get character code from the book, ~S: ~S~%" 
                         (eb_error_message return-code) path)
                   (format t "caracter code is ~s. ~%" 
                           (case (mem-ref  book-charcter-code :int)
                             (#.EB_CHARCODE_ISO8859_1 "ISO 8859-1(ラテン文字 1) ")
                             (#.EB_CHARCODE_JISX0208 "JIS X 0208 (日本語のかな漢字)")
                             (#.EB_CHARCODE_JISX0208_GB2312 "JIS X 0208 (日本語のかな漢字) と GB 2312 (中国語の簡体字)")
                             (#.EB_CHARCODE_INVALID "不正な文字コード")
                             (t nil))))
              (loop for i from 0 to  (1- (mem-ref sub_count :int ))
                 do (if (/= EB_SUCCESS (setf return-code (eb_subbook_title2 book (mem-aref sub_codes :int i) title)))
                        (error "eb_subbook_title2() failed~%")
                        (if (= (mem-ref book-charcter-code :int) EB_CHARCODE_ISO8859_1)
                            (format nil "Title[~d] is ~S .~%" i (foreign-string-to-lisp title :encoding :ascii))
                            (format t  "Title[~d] is ~S .~%" i (foreign-string-to-lisp title :encoding :eucjp)))))
              (if (/= EB_SUCCESS (setf return-code (eb_set_subbook book (mem-aref sub_codes :int 0))))
                  (error "Failed to set subbook in the book, ~S: ~S~%" 
                         (eb_error_message return-code) path))
              (with-foreign-pointer-as-string (find-word MAX-FIND-WORD-LENGTH)
                ;;(lisp-string-to-foreign  "にほん" find-word  MAX-FIND-WORD-LENGTH)
                (lisp-string-to-foreign  "abc" find-word  MAX-FIND-WORD-LENGTH :encoding :eucjp )
                (if (/= EB_SUCCESS (setf return-code (eb_search_word book find-word)))
                    (error "Failed to search word from the book, ~S: ~S~%" 
                             (eb_error_message return-code) path))
                (with-foreign-objects 
                    ((hit_count :int)
                     (hits  'EB_Hit_Struct MAX_HITS))
                  (if (/= EB_SUCCESS (setf return-code (eb_hit_list book MAX_HITS hits hit_count)))
                      (error "Failed to get hit list word from the book, ~S: ~S~%" 
                             (eb_error_message return-code)  path)
                      (format t "~d hits.~%" (mem-ref hit_count :int)))
                  (if  (/= EB_SUCCESS (setf return-code 
                                            (eb_seek_text book (foreign-slot-pointer (mem-aref hits 0) 'heading))))
                       (error "Failed to get hit list word from the book, ~S: ~S~%" 
                              (eb_error_message return-code)  path)
                       (if  (/= EB_SUCCESS  (setf return-code 
                                                  (eb_read_heading book (null-pointer) (null-pointer) (null-pointer)
)
                ))))))))
  

;;  (load "/home/soma/personal/akagi/akagi.lisp")
;;  (in-package :lib-eb)
;; (check-book-type "/home/soma/dic/CRCEN")    ??
;; (check-book-type "/home/soma/dic/IWANAMI_K4")
;; (check-book-type "/home/soma/dic/CRCEN")
;; (check-book-type "/home/soma/dic/DEVIL")
;; (check-book-type "/home/soma/dic/ROGET")
;; (check-book-type "/home/soma/dic/RYAKU") 
;; (check-book-type "/home/soma/dic/EDICT") 
