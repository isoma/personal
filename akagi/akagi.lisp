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

(defmacro calleb (function error-string &rest body)
  (let ((return-code (gensym))
        (error-message (gensym)))
    (setf error-message (concatenate 'string error-string " ~S: ~S~%"))
    `(let ((,return-code ,function))
       (if (/= #.EB_SUCCESS ,return-code)
           (error ,error-message (eb_error_message ,return-code) path)
           ,@body))))

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
         (sucsessp (eb_subbook_list book sub_codes sub_count) error-code))))

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
    (with-foreign-object (title :char (1+ EB_MAX_TITLE_LENGTH))
      (loop for i from 0 to (1- (mem-ref sub_count :int))
         do (calleb 
             (eb_subbook_title2 book (mem-aref sub_codes :int i) title)
             "eb_subbook_title2() failed"
             (if (= (mem-ref encode :int) EB_CHARCODE_ISO8859_1)
                 (format stream "Subbook [~d] title is ~S .~%" i (foreign-string-to-lisp title :encoding :ascii))
                 (format stream "subbook [~d] title is ~S .~%" i (foreign-string-to-lisp title :encoding :eucjp))))))
    (with-foreign-object (subbook_code :int)
      (let ((result  (eb_subbook book subbook_code)))
        (cond ((= #.EB_SUCCESS result)
               (format stream "The subbook[~d] was selected.~%" (mem-ref subbook_code :int))
               (= #.EB_ERR_NO_SUB result)
               (format stream  "Any subbocl dose not selected.~%")
               t (format stream "eb_subbook failed.~%")))))
    (format stream (eb_error_message error-code))))

(defgeneric select-subbook (dic index)
  (:documentation "subbookを指定する。"))

(defmethod select-subbook ((dic eb-dictonary) index)
  (with-slots (book error-code sub_codes) dic
    (format t "call eb_set_subbook ~A ~d~%" book (mem-aref sub_codes :int index))
    (sucsessp (eb_set_subbook book (mem-aref sub_codes :int index)) error-code)))
  ;;          (eb_set_subbook book (mem-aref sub_codes :int index))))

(defgeneric  error-message (dic)
  (:documentation 
   "発生したerror messageを表示する。instanceにerrorが発生したかどうかは(slot-value #instance)で調べること。"))

(defmethod error-message ((dic eb-dictonary))
  (eb_error_message (slot-value dic 'error-code)))

(defvar *kou*)
(setq *kou* (make-instance 'eb-dictonary :path "/home/soma/dic/IWANAMI_K4"))
(dump-memory (pointer-address (slot-value *kou* 'sub_codes)) :count 32)
(print-cstruct (slot-value  *kou* 'book) 'EB_Book_Struct)

(select-subbook *kou* 0)
(error-message *kou*)

(defun print-cstruct (cstruct type)
  (loop for i in (foreign-slot-names type)
     do (let ((v (foreign-slot-value cstruct type i)))
          (format t "~A -> ~A  ~A  ~A~%"
                  i v (type-of v) (type-of (cffi::get-slot-info type i))))))

(print-cstruct (slot-value  *kou* 'book) 'EB_Book_Struct)

(defun dump-memory (adress &key (count 16))
  (loop for i from 0 to count
     collect (mem-ref (inc-pointer (make-pointer adress) i) :char)))

  
;; (select-subbook *kou* )
;; (slot-value *kou* 'book)
;; (mem-ref (slot-value *kou* 'type) :int)

;; (defvar *RYAKU*)
;; (setq *RYAKU* (make-instance 'eb-dictonary :path "/home/soma/dic/RYAKU"))
;; (select-subbook *RYAKU* 0)

;; (defvar *CRCEN*)
;; (setq *CRCEN* (make-instance 'eb-dictonary :path "/home/soma/dic/CRCEN"))
;; (select-subbook *CRCEN* 1)



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

;; (macroexpand  '(calleb (eb_bind book book-path) "error" (format t "No problem")))
;; (search-word "/home/soma/dic/IWANAMI_K4"  "word")
;; (eb_finalize_library)


