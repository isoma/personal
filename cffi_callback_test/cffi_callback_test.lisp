
(defpackage :cffi-user
  (:use :common-lisp :cffi))

(in-package :cffi-user)

(define-foreign-library cffi_callback_test
  (:unix "libcbtest.so.1.0" )
  (t (:default "libcbtest ")))

(defvar *cffi_callback_test*)

(setf *cffi_callback_test* (use-foreign-library cffi_callback_test))

(cffi:defcfun ("test_cffi_cb0" test_cffi_cb0) :int
  (c :int))

(cffi:defcfun ("test_cffi_cb1" test_cffi_cb1) :int
  (c :int)
  (f :pointer))

(cffi:defcfun ("test_cffi_cb2" test_cffi_cb2) :int
  (c :int)
  (f :pointer))

(cffi:defcfun ("testCreateTrackbar" testCreateTrackbar) :int
  (trackbar_name :string)
  (window_name :string)
  (value :pointer)
  (count :int)
  (on_change :pointer))

(cffi:defcfun ("testCreateTrackbar2" testCreateTrackbar2) :int
  (trackbar_name :string)
  (window_name :string)
  (value :pointer)
  (count :int)
  (on_change :pointer)
  (userdata :pointer))

(test_cffi_cb0 20)

(defcallback function :int ((i :int))
  (format t "~& callback pos=~d ~% " i)
  (* i  3))
(defcallback function2 :void ((i :int))
  (format t "~& callback pos=~d ~% " i))

(test_cffi_cb1 5 (get-callback 'function))
(test_cffi_cb2 5 (get-callback 'function2))

(with-foreign-pointer (levels 4)
  (setf (mem-ref levels :int) 100)
  (testCreateTrackbar "Trackbar" "TestWindow" levels 256 (get-callback 'function2)))