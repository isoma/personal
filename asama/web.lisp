;;:
;;;  (load "/home/soma/personal/asama/web.lisp")
;;;
(defpackage :asama_web
  (:use :common-lisp :hunchentoot :cl-who 
        :cl-ppcre :cl-fad :css-lite :parenscript :json))

(in-package :asama_web)

(defvar *server*)
(if (not  (nth-value 1 (intern "*server*")))
      (setq *server* (start (make-instance 'acceptor :port 8888))))

(setf *PS-PRINT-PRETTY* t)

(setf *message-log-pathname* "./server_web_lisp.log")
(setf *LOG-LISP-ERRORS-P* t)
(setf *log-lisp-backtraces-p* t)
;;(setf +newline+ nil)

;; *hunchentoot-default-external-format* ←　hunchentootの出力format
(setq *hunchentoot-default-external-format* (flex:make-external-format :utf-8 :eol-style :lf))
(setq *default-content-type* "text/html; charset=utf-8")
(setf *ps-print-pretty* t)

(defun top ()
  ;;    (format t "~A~%" (request-uri*))
  ;; (setf (content-type*) "text/plain")
  ;;    (setf (return-code*) +http-ok+)
  ;;    (print `(*acceptor* ,*acceptor*))
  ;;  (print (request-uri*))
  ;;    (format t "~a  ~s  ~S ~%" `(next ,(content-type*)) (user-agent) (headers-in*))
  ;;    (setf (content-type*) "application/xhtml+xml")
  (start-session)
  (let ((client-identifier (user-agent)))
    (cond ((search "Safari" client-identifier) (setf (session-value :browser-application) :Safari))
          ((search "Chrome"  client-identifier) (setf (session-value :browser-application) :Chrome))
          ((search "Firefox"  client-identifier) (setf (session-value :browser-application) :Firefox))
          ((search "MSIE"  client-identifier) (setf (session-value :browser-application) :IE))
          (t (setf (session-value :browser-application) client-identifier))))
  
  (with-html-output-to-string (p nil :prologue t :indent nil)
    ;;      (str "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
    ;;      (fmt "~%")
    ;;      (str (conc "<!DOCTYPE html PUBLIC \"-//w3c//dtd xhtml 1.1 strict//en\"" " "
    ;;                 "\"http://www.w3.org/tr/xhtml11/dtd/xhtml11.dtd\">"))
    ;;      (:html :xmlns "http://www.w3.org/1999/xhtml" :xmlns\:svg "http://www.w3.org/2000/svg"
    (:html
     (:head
      (:script :type "text/javascript" :src "/javascript"))
     (:body :bgcolor "#888888" :onload "startDOMHandling();"))))

(push (create-regex-dispatcher "^/$" 'top) *dispatch-table*)

(defpsmacro add-text-node (base text &optional id class)
  (let ((label (gensym)))
    `(let ((,label ((@ document create-text-node) ,text)))
       ,(cond ((char= (char base 0) #\#)
               `(@ ((@ ((@ document get-element-by-ID) ,(remove #\# base)) append-child) ,label)))
              ((char= (char base 1) #\.)
               `(@ ((@ (aref ((@ document get-elements-by-class-name) ,(remove #\. base)) 0) append-child) ,label)))
              (t
               `(@ ((@ (aref ((@ document get-elements-by-tag-name) ,base) 0) append-child) ,label))))
       ,(if id `((@ ,label set-attribute) :ID ,id))
       ,(if class `((@ ,label set-attribute) :CLASS ,class)))))

(defpsmacro add-tag-element (base tag &optional id class)
  (let ((label (gensym)))
    `(let ((,label ((@ document create-element) ,tag)))
       (@ ((@ (aref ((@ document get-elements-by-tag-name) ,base) 0) append-child) ,label))
       ,(if id `((@ ,label set-attribute) :ID ,id))
       ,(if class `((@ ,label set-attribute) :CLASS ,class)))))

(defpsmacro add-style-attribute (id atribute value)
  `((@ ((@ document get-element-by-ID) ,id) set-attribute) ,atribute ,value))


(defpsmacro create-style-node-o (style-node)
  `(progn
     (setf ,style-node ((@ document create-element) "style"))
     (setf (@ ,style-node type) "text/css")
     ((@ (aref ((@ document get-elements-by-tag-name) "head") 0) append-child) ,style-node)))

(defpsmacro create-style-node-ie (style-node)
  `(setf ,style-node ((@ document create-style-sheet))))


(defpsmacro add-css-element-o (element selector style)
  `((@ ,element sheet insert-rule) ,(format nil "~A {~A}" selector style) (@ ,element sheet length)))

(defpsmacro add-css-element-ie (element selector style)
  `((@ ,element add-rule) ,(format nil "~A" selector) ,(format nil "~A" style)))

(defpsmacro each-tag-elements (tag mathod &rest paramater) 
  (let ((label (gensym)))
    `(let ((,label ((@ document get-elements-by-tag-name) ,tag)))
       (do* ((i (- (@ ,label length) 1) (decf i)))
            ((< i 0))
         ((@ (aref ,label i) ,mathod) ,paramater)))))

(defun javascript ()
  (setf (content-type*) "text/javascript")
  (format t "~A  ~S  ~% " ( request-uri*) (session-value :browser-application))
  (let ((client (session-value :browser-application)))
    (ps
      (defmacro add-text-node5 (base text)
        `(@ ((@ (aref ((@ document get-elements-by-tag-name) ,base) 0) append-child)
             ((@ document create-text-node) ,text))))
      
      (defmacro create-style-node (style-node)   
        `(lisp (list (if (string= client "IE")
                         'create-style-node-ie 'create-style-node-o) ',style-node)))
      
      (defmacro add-css (style-node selector style) 
        `(lisp (list (if (string= client "IE")
                         'add-css-element-ie 'add-css-element-o) ',style-node ,selector ,style)))
      
      (defun greeting-callback ()
        (alert "hello world"))

      (defun set-listener ()
        (setf (@ document title) "intialize"))

       (defun draw()
         (let ((canvas ((@ document get-element-by-id) "canvassample"))) ; canvas要素のノードオブジェクト
           (if (or (! canvas) (! (@ canvas get-context))) ; canvas要素の存在チェックとCanvas未対応ブラウザの対処
               (return false)
               (let ((ctx ((@ canvas get-context) "2d")))  ; 2Dコンテキスト 
                 ((@ ctx begin-path))   ; 四角を描く
                 ((@ ctx move-to) 20 20)
                 ((@ ctx line-to) 120 20)
                 ((@ ctx line-to) 120 120)
                 ((@ ctx line-to) 20 120)
                 ((@ ctx close-path))
                 ((@ ctx stroke))))))
       

;;  style-nodeはHTMLに一つだけ、引数で渡すのでなく隠蔽できるはず。
;;  classのセレクタの場合cssを作成する。
;;  IDの指定の場合はStyle属性で処理する。(全てCSSでも可能だが、HTMLのStyleの方が早いはず。)
;; 全てCSSでの表現をコンテンツ作成者が望のであればclassを使用することを推奨する。
;; どちらの方法も提供することが重要だ。

      (defun http-request()
        (let ((http-obj (new (-X-M-L-Http-Request)))
              (style-node nil))
          ((@ http-obj open) "POST" "command" t)
          (setf (@ http-obj onreadystatechange) 
                (lambda() 
                  (if (&& (== (@ http-obj ready-state) 4)
                          (== (@ http-obj status) 200))
                      (progn
                        (create-style-node style-node)
                        (add-css style-node "html body" "background:gray")
                        (add-css style-node "#p1" "color:#cc3333")

                        (add-css style-node "#menu" "background:#0099ff; height:20px; width:auto")
                        
                        (add-text-node "body" "ABCDEFG")
                        (add-tag-element "body" "div" "menu" "10")


                        (add-text-node "body" (@ http-obj response-text))
                        (add-text-node "body" "text nodeって何だ?")


                        (add-text-node "#menu" (@ http-obj response-text))
                        (add-tag-element "body" "div" "358" "10")
                        
                        (add-tag-element "body" "p" "p1")
                        (add-text-node "#p1" "text nodeって何だ?")

                        (add-tag-element "body" "p" "p2")
                        (add-text-node "#p2" "text nodeって何だ?")


                        ;;HTML5対応でないbrowserの処理が必要

                        (add-tag-element "body" "canvas" "canvassample")
                        (add-style-attribute "canvassample" "width" "140")
                        (add-style-attribute "canvassample" "height" "140")
                        (add-style-attribute "canvassample" "bgcolor" "#ffffffff")
                        (add-css style-node "#canvassample" "background-color:#ffffffff")
                        (add-css style-node "#canvassample" "width:500px")
                        (draw)


                        (add-tag-element "body" "textarea" "in-text1")
                        (add-css style-node "#in-text1" "background-color:#F22333")
                        (add-css style-node "#in-text1" "border-width:10px")
                        (add-css style-node "#in-text1" "width:500px")

                        (add-style-attribute "in-text1" "cols" "120")
                        (add-style-attribute "in-text1" "rows" "12")

                        (each-tag-elements "p" append-child (@ document create-text-node) " opqrstu ")
                        
                        (let ((elements ((@ document get-elements-by-tag-name) "p"))
                              (text-element ((@ document create-text-node) " 123456789 ")))
                          (do* ((i (- (@ elements length) 1) (decf i)))
                               ((< i 0))
                            ((@ (aref elements i) append-child) text-element)))))))
          ((@ http-obj send) "name = 12324")))

      (defun start-d-o-m-handling()
        (set-listener)
        (http-request)))))

(push (create-regex-dispatcher "^/javascript" 'javascript) *dispatch-table*)


;;*PS-LISP-LIBRARY*

(defun command()
  (progn
    ;; (setf (content-type*) "text/plain")
    ;;(setf (return-code*) +http-ok+)
    (format t "~A~%" (request-uri*))
    (format t "post data is ~A~%" (raw-post-data));;(post-parameters*))
  ;;  (print `(*acceptor* ,*acceptor*))
  ;;  (print `(*reply* ,*reply*))
  ;;  (format t "~a  ~s  ~S ~%" `(next ,(content-type*)) (user-agent) (headers-in*))
  ;;(setf (content-type*) "application/xhtml+xml")
    
    (let ((out (make-string-output-stream)))
      
      (format out "あいうえお3")
      (encode-json
       '#( ((foo . (1 2 3)) (bar . t) (baz . #\!))
          "quux" 4/17 4.25) out)
      (get-output-stream-string out))))
    

(push (create-regex-dispatcher "^/command" 'command) *dispatch-table*)
