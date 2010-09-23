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
  (load "/home/soma/personal/eb/eb.lisp"))


(let ((return-code (eb_initialize_library)))
  (if (/= return-code EB_SUCCESS)
      (error "eb_initialize_library() failed.(code = ~d)" return-code)
       return-code))

;; (eb_finalize_library)

(defun check-book-type (path)
  (with-foreign-pointer (book (foreign-type-size 'EB_Book_Struct))
    (eb_initialize_book  book)
    (with-foreign-string (book-path  path)
      (let((return-code  (eb_bind book book-path)))
        (if (/= return-code EB_SUCCESS)
            (error "Failed to bind the book, ~S: ~S~%" 
                   (foreign-string-to-lisp
                    (eb_error_message return-code)) path))
        (with-foreign-object (code :int)
          (if (/= EB_SUCCESS (setf return-code (eb_disc_type book code))) ; get dictonaly type 
              (error "Failed to bind the book, ~S: ~S~%" 
                     (foreign-string-to-lisp (eb_error_message return-code)) path)
              (case (mem-ref code :int)
                (#.EB_DISC_EB (format t "~s is DISC_EB." path ))
                (#.EB_DISC_EPWING (format t "~s is DISC EPWING.~%" path))
                (#.EB_DISC_INVALID (format t "~s is invalided.~%" path))
                (t nil)))
          (with-foreign-objects 
              ((sub_count :int)
               (sub_codes :int  EB_MAX_SUBBOOKS))
            (if (and 
                 (/= EB_SUCCESS (setf return-code (eb_subbook_list book sub_codes sub_count)))
                 (/= EB_SUCCESS (setf return-code (eb_set_subbook book sub_codes))))
                (error "Failed to bind the book, ~S: ~S~%" 
                       (foreign-string-to-lisp (eb_error_message return-code)) path))))))))
  



;;  (load "/home/soma/personal/eb/eb_bind.lisp")
;;  (in-package :lib-eb)
;; (check-book-type "/home/soma/dic/CRCEN")
;;
