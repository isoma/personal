;;   (asdf:oos 'asdf:load-op :hunchentoot-test)
;;   (LOAD "/home/soma/trunk/Aldebaran/Aldebaran.lisp")
;;
;;  (load "/home/soma/trunk/Aldebaran/Aldebaran.lisp")
;;  (probe-file "/home/soma/trunk/Aldebaran/Aldebaran.lisp")
(cl::defpackage #:aldebaran 
  (:use :common-lisp :hunchentoot :cl-who :cl-ppcre :cl-fad :parenscript))

(in-package :aldebaran)

(defvar *server*)
(setq *server* (start (make-instance 'acceptor :port 8080)))
(setf *PS-PRINT-PRETTY* t)

;; (setq *server* (start (make-instance 'acceptor :port 8080))) 

(define-easy-handler (say-yo :uri "/yo") (name)
  (setf (content-type*) "text/plain")
  (format nil "Hey~@[ ~A~]!" name))

(setf *message-log-pathname* "./server.log")
(setf *LOG-LISP-ERRORS-P* t)
(setf *log-lisp-backtraces-p* t)

;; *hunchentoot-default-external-format* ←　hunchentootの出力format
(setq *hunchentoot-default-external-format* (flex:make-external-format :utf-8 :eol-style :lf))
(setq *default-content-type* "text/html; charset=utf-8")
(setf *PS-PRINT-PRETTY* t)

(defun homepage ()
  (progn 
    (prin1 `(initial ,(content-type*)))
    ;; (setf (content-type*) "text/plain")
    (setf (return-code*) +http-ok+)
    (prin1 `(*acceptor* ,*acceptor*))
    (prin1 `(next ,(content-type*)))
    (cl-who:with-html-output-to-string
        (p nil :prologue t :indent t)
      (:html (:head (:title "タイトル文字列"))
             (:body (:h1 "内容を表示します。"))))))

(defun javascript ()
  (setf (content-type*) "text/javascript")
  (ps
    (defun greeting-callback ()
      (alert "Hello World"))
    (defun set-listener ()
      ;; (alert "load complited.")
      ;;        (inner-html :p)
      ;;(chain ($ (ps-html (:div (:p "Hello world.")))) (append-to :body))
      ;;(chain ($ (ps-html :form)) (append-to :body))
      ;;(chain ($ (ps-html :textarea "\"Please enter some word...\""))(append-to :form))
      ;;(chain ($ (ps-html (:form :p :input (create :id "test" :value "2"))))  (append-to :body))

      ;;(chain ($ :head) (append (ps-html (:title "initialize"))))

      ;;(chain ($ "<svg></svg>") (append-to :body))
      ;;(chain ($ :textarea) (attr (create :rows 10 :cols 40 )))
      ;;(chain ($ (ps-html (:math (:mror (:mi "x")(:mo "+")(:mn "3")))))(append-to :body))
      ;;(chain ($ (ps-html :circle)) (append-to "#display"))
      (chain ($ (ps-html :svg)) 
             (attr (create ; :xmlns "http://www.w3.org/2000/svg"
                           ; :xmlns\:xlink "http://www.w3.org/1999/xlink"
                            :version "1.1" :baseProfile "full"
                            :width 400 :height 400
                            :id "display"))
             (append-to :body))

      (chain ($ (ps-html :g))
             (attr (create  :id "group" :fill-opacity "0.7" :stroke "black" :stroke-width "0.1cm"))
             (append-to "#display"))
      
      (chain ($ (ps-html :circle))
             (attr (create :cx "6cm" :cy "2cm" :r "100" :fill "red" :transform "translate(0,50)"))
             (append-to "#group"))

      ;;(chain ($ (@ document body)) (css :background :gray))


   ;;   (chain ($ (ps-html (:circle :cx "6cm" :cy "2cm" :r "100" :fill "blue" :transform "translate(70,150)"))) (append-to "#display"))

      
      (defvar *line* (new (lambda () ((@ document create-element-N-S) "http://www.w3.org/2000/svg" "line"))))
      
      ((@ *line* set-attribute-n-s) nil "stroke" "green")
      ((@ *line* set-attribute-n-s) nil "stroke-width" "3")
      ((@ *line* set-attribute-n-s) nil "stroke-opacity" "0.5")
      
      ((@ ((@ document get-element-by-id) "display") append-child) *line*))
    
    ;;((@ window add-event-listener) :load (@ set-listener) false)
    ($ (lambda ()
         ((@ ($ :p) click)
          (lambda () 
            (chain ($ (@ this)) (fade-out :slow))))))
    ((chain ($ (@ document)) ready) (lambda()(set-listener)))))


(push (create-regex-dispatcher "^/javascript" 'javascript) *dispatch-table*)

(defun tutorial2 ()
  (progn
    (setf (content-type*) "application/xhtml+xml")
    (setf (html-mode) :xml )
    (with-html-output-to-string (p nil :prologue nil :indent t)
      (str "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
      (fmt "~%")
      (str (conc "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1 Strict//EN\"" " "
                 "\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">"))
      
      (:html :xmlns "http://www.w3.org/1999/xhtml" :xmlns\:svg "http://www.w3.org/2000/svg"
             (:head
              (:script :type "text/javascript" 
                       :src "http://www.alcor.ne.jp/js/jquery.js")
             (:script :type "text/javascript" :src "/javascript"))
             (:body
              ;; (:svg :id "display" 
              ;;       ;;   :xmlns "http://www.w3.org/2000/svg"
              ;;       ;;   :xmlns\:xlink "http://www.w3.org/1999/xlink"
              ;;       ;;   :version "1.1" :baseProfile "full"
              ;;       :width 400 :height 400)
)))))

(push (create-regex-dispatcher "^/tutorial2" 'tutorial2) *dispatch-table*)

(defun tutorial1 ()
  (setf (content-type*) "text/javascript")
  (ps ((@ document write)
       (ps-html ((:a :href "#"
                     :onclick (ps-inline (transport))) "link")))))

(defun tablepage ()
  (cl-who:with-html-output-to-string
      (p nil)
    (:table :border 0 :cellpadding 4
            (loop
               for i below 25 by 5 do 
                 (cl-who:htm
                  (:tr :align "right"
                       (loop
                          for j from i below (+ i 5)
                          do (cl-who:htm
                              (:td :bgcolor 
                                   (if (oddp j)
                                       "pink"
                                       "green")
                                   (cl-who:fmt "~@R" (1+ j)))))))))))

(defun svg-image ()
  (progn 
    (setf (content-type*)  "image/svg+xml")
    (with-html-output-to-string (p nil)
      (:svg :xmlns "http://www.w3.org/2000/svg"
            :xmlns\:xlink "http://www.w3.org/1999/xlink"
            :version "1.1" :baseProfile "full"
            (:g :fill-opacity "0.7" :stroke "black" :stroke-width "0.1cm"
                (:circle :cx "6cm" :cy "2cm" :r "100" :fill "red" :transform "translate(0,50)")
                (:circle :cx "6cm" :cy "2cm" :r "100" :fill "blue" :transform "translate(70,150)")
                (:circle :cx "6cm" :cy "2cm" :r "100" :fill "green" :transform "translate(-70,150)"))))))

(defun svg ()
  (progn 
    (setf (content-type*) "application/xhtml+xml")
    (with-html-output-to-string (p nil :prologue nil :indent t)
      (str "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
      (fmt "~%")
      (str (conc "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1 Strict//EN\"" " "
                 "\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">"))
      
      ;; "\"http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd\">"))
      ;;  \"-//W3C//DTD HTML 4.01//EN\"" " "
      ;;  \"http://www.w3.org/TR/html4/strict.dtd\"" ", "
      ;;  \"-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN\"" " "
      ;;  "\"http://www.w3.org/TR/MathML2/dtd/xhtml-math11-f.dtd\">"))
      ;;<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20001102//EN"
      ;;"http://www.w3.org/TR/2000/CR-SVG-20001102/DTD/svg-20001102.dtd">
      (:html :xmlns "http://www.w3.org/1999/xhtml"
             :xmlns\:svg "http://www.w3.org/2000/svg" 
             (:head)
             (:body
              (:h1 "SVGの例　その1")
              (:br)
              (:svg :xmlns "http://www.w3.org/2000/svg"
                    :xmlns\:xlink "http://www.w3.org/1999/xlink"
                    :version "1.1" :baseProfile "full" :width 400 :height 400
                    (:g :fill-opacity "0.7" :stroke "black" :stroke-width "0.1cm"
                        (:circle :cx "6cm" :cy "2cm" :r "100" :fill "red" :transform "translate(0,50)")
                        (:circle :cx "6cm" :cy "2cm" :r "100" :fill "blue" :transform "translate(70,150)")
                        (:circle :cx "6cm" :cy "2cm" :r "100" :fill "green" :transform "translate(-70,150)"))))))))

;; (defun svg ()
;;    (progn 
;;       (setf (html-mode) :xml)
;;       (setf (content-type*) "application/xhtml+xml")
;;       (with-html-output-to-string (p nil :prologue nil :indent t)
;;          (str "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
;;          (fmt "~%")
;;          (str (conc "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1 Strict//EN\"" " "
;;                  "\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">"))

;;          (:html :xmlns "http://www.w3.org/1999/xhtml"
;;             :xmlns\:svg "http://www.w3.org/2000/svg" 
;;             (:head)
;;             (:body
;;                (:h1 "SVGの例　その1")
;;                (:svg :xmlns "http://www.w3.org/2000/svg"
;;                   :xmlns\:xlink "http://www.w3.org/1999/xlink"
;;                   :version "1.1" :baseProfile "full" :width 400 :height 400
;;                   ))))))

(defun mathml ()
  (progn 
    (setf (html-mode) :xml)
    (setf (content-type*) "application/xhtml+xml")
    (with-html-output-to-string (p nil)
      (str 
       (conc "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\"" ""
             "\"http://www.w3.org/TR/html4/strict.dtd\"" " "
             ;;  \"-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN\"" " "
             "\"http://www.w3.org/TR/MathML2/dtd/xhtml-math11-f.dtd\">"))

      (:html :xmlns "http://www.w3.org/1999/xhtml"
             (:head)
             (:body
              (:h1 "MathMLの例")
              (:br)
              (:math :xmlns "http://www.w3.org/1998/Math/MathML"
                     (:mror
                      (:mi "x")(:mo "+")(:mn "3")))
              (:br)
              (:math :xmlns "http://www.w3.org/1998/Math/MathML"
                     (:mror
                      (:mrow
                       (:mrow
                        (:msup
                         (:mi "x")(:mn "2"))
                        (:mo "+")
                        (:mrow
                         (:mn "4")(:mi "x"))
                        (:mo "+")(:mn "4"))
                       (:mo "=")(:mn "0"))))
              (:br)
              (:math :xmlns "http://www.w3.org/1998/Math/MathML"
                     (:mrow
                      (:mi "z")(:mo "=")
                      (:mfenced
                       (:mrow
                        (:mi "x")(:mo "+")(:mi "y"))))))))))

(defun mathml2 ()
  (progn
    (setf (content-type*) "application/xhtml+xml")
    (setf (html-mode) :xml)
    (setf (return-code*) +http-ok+)
    (with-html-output-to-string (p nil :prologue nil :indent t)
      (str "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
      (fmt "~%")
      (str (conc "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN\"" " "
                 ;;  \"-//W3C//DTD HTML 4.01//EN\"" " "
                 ;;  \"http://www.w3.org/TR/html4/strict.dtd\"" ", "
                 ;;  \"-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN\"" " "
                 "\"http://www.w3.org/TR/MathML2/dtd/xhtml-math11-f.dtd\">"))
      (:html :xmlns "http://www.w3.org/1999/xhtml"
             (:head)
             (:body
              (:h1 "MathMLの例　その2")
              (:br)
              (:math :xmlns "http://www.w3.org/1998/Math/MathML"
                     (:mi "x")
                     (:mo "=")
                     (:mfrac
                      (:mrow (:mo "-")(:mi "b")(:mo "&PlusMinus;")
                             (:msqrt (:mrow (:msup (:mi "b")(:mu 2))
                                            (:so "-")(:mrow (:mn "4")(:mo "&InvisibleTimes;")(:mi "a")
                                                            (:mo "&InvisibleTimes;")(:mi "c")))))
                      (:mror (:mn "2")(:mo "&InvisibleTimes;")(:mi "a")))))))))

(push (create-regex-dispatcher "^/table$" 'tablepage) *dispatch-table*)
(push (create-regex-dispatcher "^/mathml$" 'mathml) *dispatch-table*)
(push (create-regex-dispatcher "^/mathml2$" 'mathml2) *dispatch-table*)
(push (create-regex-dispatcher "^/svg$" 'svg) *dispatch-table*)
(push (create-regex-dispatcher "^/$" 'homepage) *dispatch-table*)

;; (inspector 'hunchentoot-asd)
;;  *package*
;;  (list-all-packages)
;;  (find-package 'hunchentoot-asd)
;;  (find-package 'asdf)
;; (find-all-symbols "sin")

;; (apropos (find-package 'hunchentoot ))
;;*acceptor*
;;(inspector *server*)

;;*default-handler*


;; (define-easy-handler "test")
;; *dispatch-table*
;; ここに入っているハンドラーにURLを渡していく。
;; 最終的には、DEFAULT-DISPATCHERにたどり着く(defaultでは) 

;;*default-handler*
;; (cl-who:with-html-output-to-string ("soma")
;;     (:html
;;      (:head (:title "Reddit in Lisp! -- Add link"))
;;      (:body
;;       (:h1 "Add a new link")
;;       (when message (cl-who:htm (:div (cl-who:str message))))
;;       (:form :action "/save" :method "post"
;; 	     (:div "title:" (:input :type "text" :name "title"))
;; 	     (:div "url:" (:input :type "text" :name "url"))
;; 	     (:input :type "submit" :value "save")))))

;;*message-log-pathname*
;;*access-log-pathname*
;;
;;(apropos *log-lisp-backtraces-p*)
;;(describe *log-lisp-backtraces-p*)
;;(inspector *log-lisp-backtraces-p*)
;;(intern "*log-lisp-backtraces-p*")



;;(trace 'aldebaran:homepage)

;;
;;  PDF / xmlhttprequest / css / video / 
                                        ;:


;;トップページの生成
;; (defun homepage ()
;;   (cl-who:with-html-output-to-string 
;;    (str)
;;    (:html
;;     (:head (:title "My RSS Reader"))
;;     (:body
;;      (:h1 "My RSS Reader")
;;      (:h2 "Using sbcl and hunchentoot")
;;      (:a :href "/add" "Add new link")
;;      (:h3 "Headlines")
;;      (do ((tle *titles* (cdr tle))
;;           (lnk *links* (cdr lnk)))
;; 	 ((null lnk) nil)
;; 	 (cl-who:htm (:h3 (cl-who:esc (title (car tle)))))
;;          (cl-who:htm (:ol
;;                       (dolist (l (car lnk))
;;                         (cl-who:htm 
;; 			 (:li (:a :href (url l)
;; 				  ;;私の環境ではエスケープしないと文字化けする
;; 				  (cl-who:esc (headline l)))))))))
;;      )))
;;   )



;; *acceptor*
;; (acceptor-port *server*)
;; (acceptor-persistent-connections-p *server*)
;; (setf (acceptor-persistent-connections-p *server*) nil)
;; (setf (acceptor-persistent-connections-p *server*) 5)
;; (acceptor-write-timeout *server*)

;; ;;;;;;;;;;;;;;;;;;      cl-whoの試し
;; (cl-who:with-html-output 
;;  (str)5
;;  (loop for (link . title) in '(("http://zappa.com/" . "Frank Zappa")
;; 			       ("http://marcusmiller.com/" . "Marcus Miller")
;; 			       ("http://www.milesdavis.com/" . "Miles Davis"))
;;        do (htm (:a :href link
;; 		   (:b (str title)))
;; 	       :br)))

;; (cl-who:with-html-output (s nil)
;;   (:table :border 0 :cellpadding 4
;;    (loop for i below 25 by 5
;;          do (htm
;;              (:tr :align "right"
;;               (loop for j from i below (+ i 5)
;;                     do (htm
;;                         (:td :bgcolor (if (oddp j)
;;                                         "pink"
;;                                         "green")
;;                              (fmt "~@R" (1+ j))))))))))


;; (let ((*http-stream* *STANDARD-OUTPUT*))
;;   (progn
;;     nil
;;     (write-string "<table border='0' cellpadding='4'>" *http-stream*)
;;     (loop for i below 25 by 5
;;           do (progn
;;                (write-string "<tr align='right'>" *http-stream*)
;;                (loop for j from i below (+ i 5)
;;                      do (progn
;;                           (write-string "<td bgcolor='" *http-stream*)
;;                           (princ (if (oddp j) "pink" "green") *http-stream*)
;;                           (write-string "'>" *http-stream*)
;;                           (format *http-stream* "~@r" (1+ j))
;;                           (write-string "</td>" *http-stream*)))
;;                (write-string "</tr>" *http-stream*)))
;;     (write-string "</table>" *http-stream*)))



;; (let ((*http-stream* *STANDARD-OUTPUT*))
;;   (with-html-output 
;;    (str *http-stream*)
;;    (loop for (link . title) in '(("http://zappa.com/" . "Frank Zappa")
;; 				 ("http://marcusmiller.com/" . "Marcus Miller")
;; 				 ("http://www.milesdavis.com/" . "Miles Davis"))
;; 	 do (htm (:a :href link
;; 		     (:b (str title)))
;; 		 :br))))


;; ;;  (setq fstr (make-array '(0) :element-type 'base-char
;; ;;                              :fill-pointer 0 :adjustable t)) =>  ""
;; ;;  (with-output-to-string (s fstr)
;; ;;     (format s "here's some output")
;; ;;     (input-stream-p s)) =>  false
;; ;;  fstr =>  "here's some output"

;;  (setq fstr (make-array '(0) :element-type 'base-char
;;                              :fill-pointer 0 :adjustable t))

;;  (with-output-to-string (s fstr)
;;     (format s "here's some output")
;;     (input-stream-p s))

;;  fstr





;; (with-output-to-string (s )
;;     (format s "here's some output")
;;     (input-stream-p s))


;; (cl-who:with-html-output-to-string
;;  (p nil)
;;  (:texarea :name 'name  :type 'type "sdfkl"))

;; (cl-who:with-html-output-to-string
;;  (p nil :prologue t :indent t)
;;  (:html (:head (:title "abc"))
;; 	(:body (:h1 "page"))))

;; (macroexpand
;; '(cl-who:with-html-output-to-string
;;  (p nil :prologue t :indent t)
;;  (:html (:head (:title "abc"))
;; 	(:body (:h1 "page")))))

;; (cl-who:with-html-output
;;  (*STANDARD-OUTPUT* *STANDARD-OUTPUT*)
;;  (:texarea :name 'name  :type 'type (princ-to-string 'value))) 

;; (macroexpand
;;  '(cl-who:with-html-output-to-string
;;    (p)
;;    (:texarea :name 'name  :type 'type)))

;; (macroexpand
;;  '(cl-who:with-html-output
;;    (t nil)
;;    (:texarea :name 'name  :type 'type (princ-to-string 'value))))


;;(list-all-packages)
;;i(intern "PS" "PARENSCRIPT")
