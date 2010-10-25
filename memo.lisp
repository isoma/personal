;;;
;;; アイデアとかプロトタイプを貯めておくところ
;;;


(directory "/")




(let ((dir "/home/soma/dic/IWANAMI_K4/"))
  (directory (make-pathname :directory dir :name :wild))

(let ((dir "/home/soma/dic/IWANAMI_K4/"))
  (make-pathname :directory dir :name "CATALOGS"))

(let ((dir "/home/soma/dic/IWANAMI_K4/"))
  (make-pathname :directory dir :name "CATALOGS"))


(let* ((dir "/home/soma/dic/IWANAMI_K4/")
       (file (make-pathname :directory dir :name "CATALOGS")))
  (if (probe-file file)
      (format t "File exist ~S." file)
      (format t "File dose not exist ~S." file)))


;;;------------------------------------------------------

(defun as-keyword (sym)
  (intern (string sym) :keyword))

(defun slot->defclass-slot (spec)
  (let ((name (first spec)))
    `(,name :initarg ,(as-keyword name) :accessor  ,name)))

(defmacro define-binary-class (name slots)
  `(defclass ,name ()
     ,(mapcar #'slot->defclass-slot slots)))


(define-binary-class id3-tag
    ((file-identifier (iso-8859-1-string :length 3))
     (major-version ui)
     (version ui)
     (flags ui)
     (size id3-tag-size)
     (frames (id3-frames :tag-size size))))


(as-keyword 'ul)
(slot->defclass-slot '(major-version ul))

;;;------------------------------------------------------


(defun print-cstruct (cstruct type)
  (loop for i in (foreign-slot-names type)
     do (let ((v (foreign-slot-value cstruct type i)))
          (format t "~A -> ~A  ~A  ~A~%"
                  i v (type-of v) (type-of (cffi::get-slot-info type i))))))

(print-cstruct (slot-value  *kou* 'book) 'EB_Book_Struct)

(defun dump-memory (adress &key (count 16))
  (loop for i from 0 to count
     collect (mem-ref (inc-pointer (make-pointer adress) i) :char)))

;;; DUMP MEMORY:
;;; (loop for i from 0 to 20
;;;    collect (mem-ref (inc-pointer (slot-value *kou* 'sub_codes) i) :char))
;;;(loop for i from 0 to 20
;;;             collect (mem-ref (inc-pointer (make-pointer #X7FFFEC02E880) i) :char))


;;;;  前のeblibの実装　　
;; (defun check-book-type (path)
;;   (with-foreign-pointer (book (foreign-type-size 'EB_Book_Struct))
;;     (eb_initialize_book  book)
;;     (with-foreign-string (book-path  path)
;;       (let((return-code  (eb_bind book book-path)))
;;               (if (/= EB_SUCCESS (setf return-code (eb_set_subbook book (mem-aref sub_codes :int 0))))
;;                   (error "Failed to set subbook in the book, ~S: ~S~%" 
;;                          (eb_error_message return-code) path))
;;               (with-foreign-pointer-as-string (find-word MAX-FIND-WORD-LENGTH)
;;                 ;;(lisp-string-to-foreign  "にほん" find-word  MAX-FIND-WORD-LENGTH)
;;                 (lisp-string-to-foreign  "abc" find-word  MAX-FIND-WORD-LENGTH :encoding :eucjp )
;;                 (if (/= EB_SUCCESS (setf return-code (eb_search_word book find-word)))
;;                     (error "Failed to search word from the book, ~S: ~S~%" 
;;                              (eb_error_message return-code) path))
;;                 (with-foreign-objects 
;;                     ((heading :char (1+ MAXLEN_HEADING))
;;                      (hit_count :int)
;;                      (heading-length :int)
;;                      (hits  'EB_Hit_Struct MAX_HITS))
;;                   (if (/= EB_SUCCESS (setf return-code (eb_hit_list book MAX_HITS hits hit_count)))
;;                       (error "Failed to get hit list word from the book, ~S: ~S~%" 
;;                              (eb_error_message return-code) path)
;;                       (format t "~d hits.~%" (mem-ref hit_count :int)))
;;                   (if (/= EB_SUCCESS 
;;                           (setf return-code 
;;                                 (eb_seek_text book (foreign-slot-pointer
;;                                                     (mem-aref hits 'EB_Hit_Struct 0) 'EB_Hit_Struct 'heading))))
;;                       (error "Failed to get hit list word from the book, ~S: ~S~%" 
;;                              (eb_error_message return-code) path)
;;                       (if (/= EB_SUCCESS (setf return-code
;;                                                (eb_read_heading book (null-pointer) (null-pointer) (null-pointer)
;;                                                                 MAXLEN_HEADING heading heading-length)))
;;                           (error "Failed to read heading from the book, ~S: ~S~%" 
;;                                  (eb_error_message return-code)  path)
;;                           (format t  "heading is -~S-~%"  (foreign-string-to-lisp heading :encoding :eucjp)))))))))))))
  
;; (defun print-cstruct (cstruct type)
;;   (loop for i in (foreign-slot-names type)
;;        collect (foreign-slot-value cstruct type i)))


;;    (loop for i in (foreign-slot-names 'EB_Book_Struct)
;;               do (let ((val (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i))
;;                        (type (slot-value (cffi::get-slot-info 'EB_Book_Struct i) 'type)))
;;                   (if (equal type :pointer) nil
;;                       (format t "~A (~A) = ~A  ~A~%" i type val (type-of val)))))


;; (loop for i in (foreign-slot-names 'EB_Book_Struct)
;;    do (let ((type (slot-value (cffi::get-slot-info 'EB_Book_Struct i) 'type)))
;;         (if (equal type :string) nil
;;             (format t "~A (~A) = ~A  ~A~%" i type 
;;                     (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i)
;;                     (type-of (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i))))))


(loop for i in (foreign-slot-names 'EB_Book_Struct)
   do (typecase (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i)
        ((simple-array character)
         (format t "~A -> ~S ~t ";; #~A  ~A~%"
                 i  
 ;;                (foreign-string-to-lisp 
                 (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i) 
                  ;;                 :encoding :ascii)
                  ;;                (type-of (foreign-slot-value (slot-value *kou* 'book) 'EB_Book_Struct i))
                  ;;                (type-of (cffi::get-slot-info 'EB_Book_Struct i)))
                 ))
        (t (format t "~A -> ~A ~t ~A  ~A~%"
                   i 
                   (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i)
                   (type-of (foreign-slot-value (slot-value  *kou* 'book) 'EB_Book_Struct i))
                   (type-of (cffi::get-slot-info 'EB_Book_Struct i))))))


