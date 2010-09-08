(defpackage "ASAMA_UI"
  (:use xlib common-lisp))

(in-package "ASAMA_UI")

(defun just-say-lisp (host &optional (font-name "-adobe-courier-medium-o-normal--8-80-75-75-m-50-iso8859-1"))
  (let* ((display   (OPEN-DISPLAY host))
         (screen    (first (DISPLAY-ROOTS display)))
         (fg-color  (SCREEN-BLACK-PIXEL screen))
         (bg-color  (SCREEN-WHITE-PIXEL screen))
         (nice-font (OPEN-FONT display font-name))
         
         ;; Create a menu as a child of the root window.
         (a-menu       (create-menu (SCREEN-ROOT screen)
                                    fg-color bg-color nice-font)))

    (setf (menu-title a-menu) "Please pick your favorite language:")
    (menu-set-item-list a-menu "Fortran" "APL" "Forth" "Lisp")

    ;; Bedevil the user until he picks a nice programming language
    (unwind-protect
        (loop
          ;; Determine the current root window position of the pointer
          (multiple-value-bind (x y) (QUERY-POINTER (SCREEN-ROOT screen))

            (let ((choice (menu-choose a-menu x y)))
              (when (string-equal "Lisp" choice)
                (return)))))

      (CLOSE-DISPLAY display))))

(just-say-lisp "")

(OPEN-DISPLAY  "deneb")
(open-display "localhost")

(open-display "")


(let* ((display   (OPEN-DISPLAY ""))
       (screen    (first (DISPLAY-ROOTS display)))
       (fg-color  (SCREEN-BLACK-PIXEL screen))
       (bg-color  (SCREEN-WHITE-PIXEL screen)))
  (list-font-names display "a"))

(list-font-names  (OPEN-DISPLAY "") "*")

(defun pop-up-window (life-time &optional (host ""))
  (let* ((display (xlib:open-display host))
         (screen (first (xlib:display-roots display)))
         (black (xlib:screen-black-pixel screen))
         (root-window (xlib:screen-root screen))
         (my-window (xlib:create-window
                     :parent root-window
                     :x 500
                     :y 500
                     :width 200
                     :height 100
                     :background black)))
    (xlib:map-window my-window)
    (xlib:display-finish-output display)
    (format t "should appear now~%")
    (sleep life-time)
    (xlib:destroy-window my-window)
    (xlib:close-display display)))



(pop-up-window 50)

(defun blow-bubble (&optional (host ""))
  (let* ((display (xlib:open-display host))
         (screen (first (xlib:display-roots display)))
         (black (xlib:screen-black-pixel screen))
         (root-window (xlib:screen-root screen))
         (my-window (xlib:create-window
                     :parent root-window
                     :x 50
                     :y 50
                     :width 200
                     :height 100
                     :background black
                     :event-mask (xlib:make-event-mask :exposure
                                                       :enter-window))))
    (xlib:map-window my-window)
    (xlib:event-case (display :force-output-p t
                              :discard-p t)
      (:exposure ()(format t "Exposed~%"))
      (:enter-notify () t))
    (xlib:destroy-window my-window)
    (xlib:close-display display)))
(blow-bubble)


(defun graphic-x (width height &optional (host ""))
  (let* ((display (xlib:open-display host))
         (screen (first (xlib:display-roots display)))
         (black (xlib:screen-black-pixel screen))
         (white (xlib:screen-white-pixel screen))
         (root-window (xlib:screen-root screen))
         (grackon (xlib:create-gcontext
                   :drawable root-window
                   :foreground white
                   :background black))
         (my-window (xlib:create-window
                     :parent root-window
                     :x 0
                     :y 0
                     :width width
                     :height height
                     :background black
                     :event-mask (xlib:make-event-mask :exposure
                                                       :button-press))))
    (describe grackon)
    (xlib:map-window my-window)
    (xlib:event-case (display :force-output-p t
                              :discard-p t)
      (:exposure ()
                 (xlib:draw-line my-window
                                 grackon
                                 0 height
                                 width 0)
                 (xlib:draw-line my-window
                                 grackon
                                 0 0
                                 width height))
      (:button-press () t))
    (xlib:destroy-window my-window)
    (xlib:close-display display)))
(graphic-x 200 300)


(load "/home/soma/graph-f.lisp")




(load "understanding-exposure.lisp")
(show-exposure-events 200 300)


(defun hello-world (width height &optional (host ""))
  (let* ((display (xlib:open-display host))
         (screen (first (xlib:display-roots display)))
         (black (xlib:screen-black-pixel screen))
         (white (xlib:screen-white-pixel screen))
         (root-window (xlib:screen-root screen))
         (grackon (xlib:create-gcontext
                   :drawable root-window
                   :foreground white
                   :background black))
         (my-window (xlib:create-window
                     :parent root-window
                     :x 0
                     :y 0
                     :width width
                     :height height
                     :background black
                     :event-mask (xlib:make-event-mask :exposure
                                                       :button-press))))
    (describe (xlib:gcontext-font grackon))
    (xlib:map-window my-window)
    (xlib:event-case (display :force-output-p t
                              :discard-p t)
      (:exposure (count)
                 (when (zerop count)
                   (xlib:draw-glyphs
                    my-window
                    grackon
                    20 50
                    "Hello World!"))
                 nil)
      (:button-press () t))
    (xlib:destroy-window my-window)
    (xlib:close-display display)))

(hello-world 200 300)








