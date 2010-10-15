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
  (load "/home/soma/personal/akagi/eb.lisp")
  (load "/home/soma/personal/akagi/defs.lisp" ))

(let ((return-code (eb_initialize_library)))
  (if (/= return-code EB_SUCCESS)
      (error "eb_initialize_library() failed.(code = ~d)" return-code)
       return-code))

;;;(eb_finalize_library)

(defconstant MAX_HITS 10)
(defconstant MAX-FIND-WORD-LENGTH 100)
(defconstant MAXLEN_HEADING 127)

(defclass eb-dictonary ()
  ((path :initarg :path)  ; class slotを作成し初期化を一回だけすること
   subbook
   type
   encode
   (error-code :initform #.EB_SUCCESS)
   sub_count
   sub_codes
   hit-count
   hits
   book))

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
  (format t "Initialize ~S~%" (slot-value dic 'path))
  (with-slots (book path type error-code encode
               sub_count sub_codes hit-count hits) dic
    (setf book (foreign-alloc 'EB_Book_Struct)
          type (foreign-alloc :int)
          encode (foreign-alloc :int)
          sub_count (foreign-alloc :int)
          sub_codes (foreign-alloc :int :count EB_MAX_SUBBOOKS)
          hit-count (foreign-alloc :int)
          hits (foreign-alloc 'EB_Hit_Struct :count MAX_HITS))
    (eb_initialize_book book)
    (and (sucsessp (eb_bind book path) error-code)
         (sucsessp (eb_subbook_list book sub_codes sub_count) error-code)
         (sucsessp (eb_set_subbook book (mem-aref sub_codes :int 0)) error-code)
         (sucsessp (eb_disc_type book type) error-code)
         (sucsessp (eb_character_code book encode) error-code))))

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
               (format stream "The subbook[~d] was selected.~%" (mem-ref subbook_code :int)))
              ((= #.EB_ERR_NO_SUB result)
               (format stream  "Any subbocl dose not selected.~%"))
              ((= #.EB_ERR_NO_CUR_SUB result)
               (format stream  "subbookが設定されていません。~%"))
              (t (format stream "eb_subbook failed  [~d].~%" result)))))
    (format stream (eb_error_message error-code))))

(defgeneric select-subbook (dic index)
  (:documentation "subbookを指定する。"))

(defgeneric  error-message (dic)
  (:documentation "発生したerror messageを表示する。instanceにerrorが発生したかどうかは(slot-value #instance)で調べること。"))

(defgeneric selected-subbook (dic)
  (:documentation "bookの設定されているsubbookを答える。設定がされていない場合はNILを返す"))

(defgeneric search-book (dic word)
  (:documentation "bookからwordを検索"))

(defmethod select-subbook ((dic eb-dictonary) index)
  (with-slots (book error-code sub_codes) dic
    ;;    (format t "call eb_set_subbook ~A ~d~%" book (mem-aref sub_codes :int index))
    (sucsessp (eb_set_subbook book (mem-aref sub_codes :int index)) error-code)))

(defmethod selected-subbook ((dic eb-dictonary))
  (with-foreign-object (subbook_code :int)
    (setf (slot-value dic 'error-code)
          (eb_subbook (slot-value dic 'book) subbook_code))
    (if (= #.EB_SUCCESS (slot-value dic 'error-code))
        (mem-ref subbook_code :int))))

(defmethod error-message ((dic eb-dictonary))
  (eb_error_message (slot-value dic 'error-code)))

(defmethod search-book ((dic eb-dictonary) word)
  (with-slots (book error-code hit-count hits) dic
    (format t "eb_search_word~%")
    ;;    (let ((str (foreign-string-alloc word :encoding :eucjp)))
    ;;    (let ((str (foreign-string-alloc word)))
    
    ;; (with-foreign-string (str word)
    ;;   (format t "str=~a~%" str)
    ;;(setf error-code (eb_search_exactword book word))
    (setf error-code (eb_search_endword book (foreign-string-alloc word)))
    (if (= #.EB_SUCCESS error-code)
        (progn 
          (format t "eb_hit_list book~%")
          (setf error-code (eb_hit_list book MAX_HITS hits hit-count))
          (format t "eb_hit_list book end.~%")
          (if (= #.EB_SUCCESS error-code)
              (mem-ref hit-count :int))))))

(defun print-cstruct (cstruct type)
  (loop for i in (foreign-slot-names type)
     do (let ((v (foreign-slot-value cstruct type i)))
          (format t "~A -> ~A  ~A  ~A~%"
                  i v (type-of v) (type-of (cffi::get-slot-info type i))))))

(defun dump-memory (adress &key (count 16))
  (loop for i from 0 to count
     collect (mem-ref (inc-pointer (make-pointer adress) i) :char)))

;(defvar *kou*)
;(setq *kou* (make-instance 'eb-dictonary :path "/home/soma/dic/IWANAMI_K4/"))
;(select-subbook *kou* 0)
;; (print-cstruct (slot-value  *kou* 'book) 'EB_Book_Struct)
;; (error-message *kou*)
;(dump-memory (pointer-address (slot-value *kou* 'sub_codes)) :count 32)
;(print-cstruct (slot-value  *kou* 'book) 'EB_Book_Struct)
;; (select-subbook *kou*)
;; (slot-value *kou* 'book)
;; (mem-ref (slot-value *kou* 'type) :int)
;; (selected-subbook *kou*)
;; (search-book *kou* "apple")
;; (search-book *kou* "あお")


;(defvar *RYAKU*)
;(setq *RYAKU* (make-instance 'eb-dictonary :path "/home/soma/dic/RYAKU/"))
;(select-subbook *RYAKU* 1)

;(defvar *CRCEN*)
;(setq *CRCEN* (make-instance 'eb-dictonary :path "/home/soma/dic/CRCEN/"))
;(select-subbook *CRCEN* 1)
;(search-book *CRCEN* "apple")
;; (dump-memory (pointer-address (slot-value  *CRCEN* 'hits)) :count 32)
;; (dump-memory (pointer-address (foreign-slot-value　(slot-value  *CRCEN* 'hits) 'EB_Hit_Struct 'HEADING)) :count 32)
;; (pointer-address (foreign-slot-value　(slot-value  *CRCEN* 'hits) 'EB_Hit_Struct 'HEADING)])
;(print-cstruct (slot-value  *CRCEN* 'book) 'EB_Book_Struct)

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


