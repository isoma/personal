(defpackage :lib-eb2
  (:use :common-lisp :cffi))

(in-package :lib-eb2)

(defconstant MAX_HITS 500)
(defconstant MAX-FIND-WORD-LENGTH 100)
(defconstant MAXLEN_HEADING 127)

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
  (load "/home/soma/personal/akagi/defs.lisp"))

(defun print-cstruct (cstruct type)
  (loop for i in (foreign-slot-names type)
     do (let ((v (foreign-slot-value cstruct type i)))
          (format t "~A -> ~A  ~A  ~A~%"
                  i v (type-of v) (type-of (cffi::get-slot-info type i))))))

(defun dump-memory (adress &key (count 16))
  (loop for i from 0 to count
     collect (mem-ref (inc-pointer (make-pointer adress) i) :char)))

(defun read_eb (path subbook word)
  (with-foreign-objects ((book 'EB_Book_Struct)
                        ; (sub-count :int)
                        ; (sub-codes :int EB_MAX_SUBBOOKS)
                        ; (hits 'EB_Hit_Struct MAX_HITS)
                        ; (hit-count :int)
                         (book-pointer :pointer))
    (setf (mem-ref book-pointer :pointer) book)
    (with-foreign-string (str word) 
      (eb_initialize_library)
      (print-cstruct book 'EB_Book_Struct)

      (eb_initialize_book book-pointer)
      (print-cstruct book 'EB_Book_Struct)
      ;;(print (dump-memory (pointer-address book-pointer)))
      (eb_bind book-pointer path)
      (print-cstruct book 'EB_Book_Struct)

      (print subbook)

      (eb_initialize_library)
     ;;  ;; (eb_initialize_book book-pointer)
     ;;  ;; (eb_bind book-pointer path)
     ;;  ;; (eb_subbook_list book-pointer sub-codes sub-count)
     ;;  ;; (eb_set_subbook book-pointer (mem-aref sub-codes :int subbook))
     ;;  ;; ;; (eb_search_exactword book-pointer str)
     ;;  ;; (eb_search_word book-pointer str)

     ;;  ;; (eb_hit_list book-pointer MAX_HITS hits hit-count)
     ;;  (eb_initialize_book book)
     ;;  (eb_bind book-pointer path)
     ;;  (eb_subbook_list book sub-codes sub-count)
     ;;  (eb_set_subbook book (mem-aref sub-codes :int subbook))
     ;;  ;; (eb_search_exactword book str)
     ;;  (eb_search_word book str)

     ;;  (eb_hit_list book MAX_HITS hits hit-count)
     ;;  (eb_finalize_library))
    )))

;;  (load "/home/soma/personal/akagi/akagi2.lisp")  (in-package :lib-eb2)
;;  (read_eb "/home/soma/dic/CRCEN/" 1 "apple")


(with-foreign-object (book 'EB_Book_Struct)
  (print book))

(foreign-alloc 'EB_Book_Struct)