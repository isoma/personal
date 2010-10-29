(defpackage :cl-rfb
  (:use :common-lisp :chunga :usocket :flexi-streams))

(in-package :cl-rfb)

(defclass rfb-server (usocket:stream-server-usocket)()

  (with)

(defvar *server* (make-instance 'rfb-server))
(start-listiening *server*)

(defmethod start-listening ((server rfb-server)) x y port)
  (usocket:socket-listen host poort

  (socket:socket-listen server))


(usocket:socket-listen usocket:*wildcard-host* 5900 
                       :reuseaddress t
                       :element-type '(unsigned-byte 8))


(defvar *connection*
  (socket-listen *wildcard-host* 5900 
                 :reuseaddress t :element-type '(unsigned-byte 8)))

(socket-close *connection*)
(slot-value *connection* 'socket)
