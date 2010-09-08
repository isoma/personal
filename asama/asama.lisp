;  swig -cffi -cpperraswarn -outdir ./ cxtypes.i
(defpackage :asama
  (:use :common-lisp :cffi "SB-THREAD" "SB-EXT"))

(in-package :asama)

;; (define-foreign-library cxcore
;;    (:unix (:or "libcxcore.so.4" "libcxcore.so"))
;;    (t (:default "cxcore")))
;;(use-foreign-library cxcore)
(progn
  (if (and (foreign-symbol-pointer "cvNamedWindow")
           (nth-value 1 (intern "*highgui*")))
      (close-foreign-library *highgui*))
  (define-foreign-library highgui
      (:unix (:or "libhighgui.so.4" "libhighgui.so"))
    (t (:default "highgui")))
  (define-foreign-library cxcore
      (:unix (:or "libcxcore.so.4.0.0" "libcxcore.so.4" "libcxcore.so"))
    (t (:default "libcxcore")))
  (define-foreign-library cv
      (:unix (:or "libcv.so.4.0.0" "ibcv.so.4" "libcv.so"))
    (t (:default "libcv")))
  (define-foreign-library cvaux
      (:unix (:or "libcvaux.4.0.0" "ibcvaux.so.4" "libcvaux.so"))
    (t (:default "libcvaux")))
  (define-foreign-library ml
      (:unix (:or "libml.4.0.0" "ibcml.so.4" "libml.so"))
    (t (:default "libml")))
  
  (defvar *highgui*)
  (setf *highgui* (use-foreign-library highgui))
  (use-foreign-library cxcore)
  (use-foreign-library cv)
  (use-foreign-library cvaux)
  (use-foreign-library ml))

(defcstruct IplImage
	(nSize :int)
	(ID :int)
	(nChannels :int)
	(alphaChannel :int)
	(depth :int)
	(colorModel :unsigned-char :count 4)
	(channelSeq :unsigned-char :count 4)
	(dataOrder :int)
	(origin :int)
	(align :int)
	(width :int)
	(height :int)
	(roi :pointer)
	(maskROI :pointer)
	(imageId :pointer)
	(tileInfo :pointer)
	(imageSize :int)
	(imageData :pointer)
	(widthStep :int)
	(BorderMode :pointer)
	(BorderConst :pointer)
	(imageDataOrigin :string))

(defconstant CV_LOAD_IMAGE_UNCHANGED -1)
(defconstant CV_LOAD_IMAGE_GRAYSCALE 0)
(defconstant CV_LOAD_IMAGE_COLOR 1)
(defconstant CV_LOAD_IMAGE_ANYDEPTH 2)
(defconstant CV_LOAD_IMAGE_ANYCOLOR 4)

(defconstant CV_WINDOW_AUTOSIZE 1)

(defcfun ("cvNamedWindow" cvNamedWindow) :int
  (name :string)
  (flags :int))

(defcfun ("cvSetMouseCallback" cvSetMouseCallback) :void
  (window_name :string)
  (on_mouse :pointer)
  (param :pointer))

(defconstant CV_LOAD_IMAGE_UNCHANGED -1)
(defconstant CV_LOAD_IMAGE_GRAYSCALE 0)
(defconstant CV_LOAD_IMAGE_COLOR 1)
(defconstant CV_LOAD_IMAGE_ANYDEPTH 2)
(defconstant CV_LOAD_IMAGE_ANYCOLOR 4)

(defcfun ("cvLoadImage" cvLoadImage) :pointer
  (filename :string)
  (iscolor :int))
(defcfun ("cvShowImage" cvShowImage) :void
  (name :string)
  (image :pointer))
(defcfun ("cvWaitKey" cvWaitKey) :int 
   (delay :int))
(defcfun ("cvReleaseImageHeader" cvReleaseImageHeader) :void
  (image :pointer))
(defcfun ("cvReleaseImage" cvReleaseImage) :void
  (image :pointer))
(defcfun ("cvDestroyWindow" cvDestroyWindow) :void
  (name :string))
(defcfun ("cvDestroyAllWindows" cvDestroyAllWindows) :void)
(cffi:defcfun ("cvCreateTrackbar" cvCreateTrackbar) :int
  (trackbar_name :string)
  (window_name :string)
  (value :pointer)
  (count :int)
  (on_change :pointer))
(cffi:defcfun ("cvCreateTrackbar2" cvCreateTrackbar2) :int
  (trackbar_name :string)
  (window_name :string)
  (value :pointer)
  (count :int)
  (on_change :pointer)
  (userdata :pointer))
(cffi:defcfun ("cvGetTrackbarPos" cvGetTrackbarPos) :int
  (trackbar_name :string)
  (window_name :string))
(cffi:defcfun ("cvSetTrackbarPos" cvSetTrackbarPos) :void
  (trackbar_name :string)
  (window_name :string)
  (pos :int))

(defconstant CV_EVENT_MOUSEMOVE 0)
(defconstant CV_EVENT_LBUTTONDOWN 1)
(defconstant CV_EVENT_RBUTTONDOWN 2)
(defconstant CV_EVENT_MBUTTONDOWN 3)
(defconstant CV_EVENT_LBUTTONUP 4)
(defconstant CV_EVENT_RBUTTONUP 5)
(defconstant CV_EVENT_MBUTTONUP 6)
(defconstant CV_EVENT_LBUTTONDBLCLK 7)
(defconstant CV_EVENT_RBUTTONDBLCLK 8)
(defconstant CV_EVENT_MBUTTONDBLCLK 9)
(defconstant CV_EVENT_FLAG_LBUTTON 1)
(defconstant CV_EVENT_FLAG_RBUTTON 2)
(defconstant CV_EVENT_FLAG_MBUTTON 4)
(defconstant CV_EVENT_FLAG_CTRLKEY 8)
(defconstant CV_EVENT_FLAG_SHIFTKEY 16)
(defconstant CV_EVENT_FLAG_ALTKEY 32)

(defcfun ("cvStartWindowThread" cvStartWindowThread) :int)
(defcallback change :void ((pos :int))
               (format t "~& callback pos=~d ~% " pos))

(defun test2 ()
  (cvStartWindowThread)
  (with-foreign-strings ((window-name "TestWindow")
                         (trackbar-name "Trackbar")
                         (trackbar-name2 "Trackbar2")
                         (path "/home/soma/image/source.bmp"))
    (let ((image (cvLoadImage path (logior CV_LOAD_IMAGE_ANYDEPTH CV_LOAD_IMAGE_ANYCOLOR))))
      (cvNamedWindow window-name CV_WINDOW_AUTOSIZE)
      (with-foreign-pointer (levels 4)
        (setf (mem-ref levels :int) 100)
        (cvCreateTrackbar "Trackbar" "TestWindow" levels 256 (get-callback 'change))
      
        (cvShowImage window-name image)
        (mapcar 
         #'(lambda (slot-name) 
             (format t "~S=~S~%" slot-name
                     (foreign-slot-value image 'IplImage slot-name)))
         (foreign-slot-names 'IplImage))
      
        
        (let ((image-data (foreign-slot-value image 'IplImage 'imageData)))
          (mem-ref image-data :char )
          (format t "~%~% data = ~a^%" 
                  (loop for i from 0 below 8
                     collect (mem-ref image-data  :char i))))
        (cvWaitKey 0)
        (format t "window close.~%")
        (format t "release image.~%")
        (print  image)
        (print (pointer-address image ))
        (print (make-pointer (pointer-address image)))



        (with-foreign-object (handle :pointer)
          (setf (mem-ref handle :pointer) image)
          (cvReleaseImage handle));
        ;;(cvDestroyWindow window-name)
        (cvDestroyAllWindows)

;        (cvReleaseImage (pointer-address image))
;;    (with-foreign-pointer (tmp :pointer)
;;      (setf (men-ref tmp) image)
;;      (cvReleaseImage tmp ))

     ;;   (cvReleaseImage (make-pointer (pointer-address image)))
        (format t "all done.~%")
        (cvWaitKey 300)
        ))))



;; (load #p"/home/soma/personal/asama/asama.lisp") (in-package :asama)
;; (test2)

;(callback on-change)
;(get-callback 'on-change)

;(foreign-funcall  "on-change" :int 34 :void)
;(foreign-funcall-pointer (callback on-change) () :int 32 :void)
;;(foreign-funcall-pointer (callback on-change) () :int 32 :void)