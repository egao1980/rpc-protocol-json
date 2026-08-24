(in-package #:rpc-protocol-json)

(defclass jsonrpc-codec (rpc-protocol:rpc-codec) ()
  (:documentation "JSON-RPC 2.0 (https://www.jsonrpc.org/specification)."))

(defvar *jsonrpc-codec* (make-instance 'jsonrpc-codec))

(defun use-jsonrpc-codec ()
  (setf rpc-protocol:*rpc-codec* *jsonrpc-codec*))

(defmethod yason:encode ((object (eql :false)) &optional (stream *standard-output*))
  (write-string "false" stream)
  object)

(defmethod yason:encode ((object (eql :true)) &optional (stream *standard-output*))
  (write-string "true" stream)
  object)

(defun %json (obj)
  (let ((yason:*symbol-encoder* #'yason:encode-symbol-as-lowercase))
    (with-output-to-string (s)
      (yason:encode obj s))))

(defun %parse (string)
  (yason:parse string :object-as :hash-table :json-arrays-as-vectors t))

(defun %object (&rest kvs)
  (let ((h (make-hash-table :test 'equal)))
    (loop for (k v) on kvs by #'cddr
          unless (or (null k) (eq v :omit))
            do (setf (gethash k h) v))
    h))

(defmethod rpc-protocol:encode-request-using-codec
    ((codec jsonrpc-codec) method params &key (id 1))
  (declare (ignore codec))
  (%json (%object "jsonrpc" "2.0"
                  "method" method
                  "params" (or params #())
                  "id" id)))

(defmethod rpc-protocol:encode-notification-using-codec
    ((codec jsonrpc-codec) method params &key)
  (declare (ignore codec))
  (%json (%object "jsonrpc" "2.0"
                  "method" method
                  "params" (or params #()))))

(defmethod rpc-protocol:encode-response-using-codec
    ((codec jsonrpc-codec) result &key (id 1))
  (declare (ignore codec))
  (%json (%object "jsonrpc" "2.0" "result" result "id" id)))

(defmethod rpc-protocol:encode-error-response-using-codec
    ((codec jsonrpc-codec) code message &key id data)
  (declare (ignore codec))
  (let ((err (%object "code" code "message" message)))
    (when data (setf (gethash "data" err) data))
    (%json (%object "jsonrpc" "2.0" "error" err "id" id))))

(defmethod rpc-protocol:decode-message-using-codec ((codec jsonrpc-codec) source)
  (declare (ignore codec))
  (%parse (if (stringp source) source (princ-to-string source))))

(use-jsonrpc-codec)
