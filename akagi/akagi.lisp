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

(defclass eb-dictonary ()
  ((path :initarg :path)  ; class slotを作成し初期化を一回だけすること
   book
   subbook
   type
   encode
   (error-code :initform #.EB_SUCCESS)
   sub_count
   sub_codes))


(defmacro sucsessp (procedure result)
  `(equal #.EB_SUCCESS (setf ,result ,procedure)))

(defmethod initialize-instance :after ((dic eb-dictonary) &key)
  (with-slots (book path type error-code encode sub_count sub_codes) dic
    (setf book (foreign-alloc 'EB_Book_Struct)
          type (foreign-alloc :int)
          encode (foreign-alloc :int)
          sub_count (foreign-alloc :int)
          sub_codes (foreign-alloc :int :count EB_MAX_SUBBOOKS))
    (eb_initialize_book book)
    (and (sucsessp (eb_bind book path) error-code)
         (sucsessp (eb_disc_type book type) error-code)
         (sucsessp (eb_character_code book encode) error-code) 
         (sucsessp (eb_subbook_list book sub_codes sub_count) error-code)
                   )))

  ;; (calleb (eb_set_subbook book sub_codes) "Failed to get subbook count from the book"
  ;;               (format t "It has ~d subbooks.~%" (mem-ref sub_count :int)))

(defmethod print-object ((dic eb-dictonary) stream)
  (with-slots (book path type error-code encode sub_count sub_codes) dic
    (format stream "path:~S~%" path)
    (format stream "This book Type is ~S.~%" 
            (case (mem-ref type :int) 
              (#.EB_DISC_EB "DISC_EB")
              (#.EB_DISC_EPWING "DISC EPWING")
              (#.EB_DISC_INVALID "invalided")))
    (format stream "This book encodeing is ~S.~%"
            (case (mem-ref encode :int)
              (#.EB_CHARCODE_ISO8859_1 "ISO 8859-1(ラテン文字 1) ")
              (#.EB_CHARCODE_JISX0208 "JIS X 0208 (日本語のかな漢字)")
              (#.EB_CHARCODE_JISX0208_GB2312 "JIS X 0208 (日本語のかな漢字) とGB 2312 (中国語の簡体字)")
              (#.EB_CHARCODE_INVALID "不正な文字コード")))
    (format stream "This book has ~D subbooks.~%" (mem-ref sub_count :int))
    (with-foreign-objects ((title :char (1+ EB_MAX_TITLE_LENGTH)))
      (loop for i from 0 to  (1- (mem-ref sub_count :int))
         do (calleb 
             (eb_subbook_title2 book (mem-aref sub_codes :int i) title)
             "eb_subbook_title2() failed"
             (if (= (mem-ref encode :int) EB_CHARCODE_ISO8859_1)
                 (format stream "Subbook [~d] title is ~S .~%" i (foreign-string-to-lisp title :encoding :ascii))
                 (format stream "subbook [~d] title is ~S .~%" i (foreign-string-to-lisp title :encoding :eucjp))))))
    (format stream (eb_error_message error-code))))

;; (defmethod select-subbook ((dic eb-dictonary) subbook-index)
;;   (with-slots (book path type error-code encode sub_count sub_codes) dic
;;     (eb_set_subbook book sub_codes)))

(defvar *kou*)
(setq *kou* (make-instance 'eb-dictonary :path "/home/soma/dic/IWANAMI_K4"))
(make-instance 'eb-dictonary :path "/home/soma/dic/IWANAMI_K4")
*kou*

(slot-value *kou* 'book)
(mem-ref (slot-value *kou* 'type) :int)

(defmacro calleb (function error-string &rest body)
  (let ((return-code (gensym))
        (error-message (gensym)))
    (setf error-message (concatenate 'string error-string " ~S: ~S~%"))
    `(let ((,return-code ,function))
       (if (/= #.EB_SUCCESS ,return-code)
           (error ,error-message (eb_error_message ,return-code) path)
           ,@body))))

;; (macroexpand  '(calleb (eb_bind book book-path) "error" (format t "No problem")))
         
(defun search-word (path word)
  (declare (ignore word))
  (with-foreign-pointer (book (foreign-type-size 'EB_Book_Struct))
    (eb_initialize_book book)
    (with-foreign-string (book-path path)
      (with-foreign-objects ((code :int)
                             (sub_count :int)
                             (sub_codes :int  EB_MAX_SUBBOOKS)
                             (title :char (1+ EB_MAX_TITLE_LENGTH))
                             (book-charcter-code :int))
        (calleb (eb_bind book book-path) "Failed to bind the book.")
        (calleb (eb_disc_type book code) "Failed to get booktype."
                (case (mem-ref code :int) 
                  (#.EB_DISC_EB (format t "~s is DISC_EB." path ))
                  (#.EB_DISC_EPWING (format t "~s is DISC EPWING.~%" path))
                  (#.EB_DISC_INVALID (format t "~s is invalided.~%" path))))
        (calleb (eb_character_code book book-charcter-code)
                "Failed to get character code from the book." 
                (format t "caracter code is ~s. ~%" 
                        (case (mem-ref  book-charcter-code :int)
                          (#.EB_CHARCODE_ISO8859_1 "ISO 8859-1(ラテン文字 1) ")
                          (#.EB_CHARCODE_JISX0208 "JIS X 0208 (日本語のかな漢字)")
                          (#.EB_CHARCODE_JISX0208_GB2312 "JIS X 0208 (日本語のかな漢字) と GB 2312 (中国語の簡体字)")
                          (#.EB_CHARCODE_INVALID "不正な文字コード")
                          (t nil))))
        (calleb (eb_subbook_list book sub_codes sub_count)
                "Failed to get subbooks codes from the book"
                (format t "It has ~d subbooks.~%" (mem-ref sub_count :int )))
        (loop for i from 0 to  (1- (mem-ref sub_count :int ))
                 do (calleb 
                     (eb_subbook_title2 book (mem-aref sub_codes :int i) title)
                     "eb_subbook_title2() failed"
                     (if (= (mem-ref book-charcter-code :int) EB_CHARCODE_ISO8859_1)
                         (format t "Title[~d] is ~S .~%" i (foreign-string-to-lisp title :encoding :ascii))
                         (format t "Title[~d] is ~S .~%" i (foreign-string-to-lisp title :encoding :eucjp)))))
        (calleb (eb_set_subbook book sub_codes) "Failed to get subbook count from the book"
                (format t "It has ~d subbooks.~%" (mem-ref sub_count :int)))))))

;; (search-word "/home/soma/dic/IWANAMI_K4"  "word")
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
                    ((heading :char (1+ MAXLEN_HEADING))
                     (hit_count :int)
                     (heading-length :int)
                     (hits  'EB_Hit_Struct MAX_HITS))
                  (if (/= EB_SUCCESS (setf return-code (eb_hit_list book MAX_HITS hits hit_count)))
                      (error "Failed to get hit list word from the book, ~S: ~S~%" 
                             (eb_error_message return-code) path)
                      (format t "~d hits.~%" (mem-ref hit_count :int)))
                  (if (/= EB_SUCCESS 
                          (setf return-code 
                                (eb_seek_text book (foreign-slot-pointer
                                                    (mem-aref hits 'EB_Hit_Struct 0) 'EB_Hit_Struct 'heading))))
                      (error "Failed to get hit list word from the book, ~S: ~S~%" 
                             (eb_error_message return-code) path)
                      (if (/= EB_SUCCESS (setf return-code
                                               (eb_read_heading book (null-pointer) (null-pointer) (null-pointer)
                                                                MAXLEN_HEADING heading heading-length)))
                          (error "Failed to read heading from the book, ~S: ~S~%" 
                                 (eb_error_message return-code)  path)
                          (format t  "heading is -~S-~%"  (foreign-string-to-lisp heading :encoding :eucjp)))))))))))))
  

;;  (load "/home/soma/personal/akagi/akagi.lisp")
;;  (in-package :lib-eb)
;;
;; (check-book-type "/home/soma/dic/CRCEN")    ??
;; (check-book-type "/home/soma/dic/IWANAMI_K4")
;; (check-book-type "/home/soma/dic/CRCEN")
;; (check-book-type "/home/soma/dic/DEVIL")
;; (check-book-type "/home/soma/dic/ROGET")
;; (check-book-type "/home/soma/dic/RYAKU") 
;; (check-book-type "/home/soma/dic/EDICT") 
