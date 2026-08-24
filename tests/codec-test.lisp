(in-package #:rpc-protocol-json/tests)

(deftest encode-roundtrip-shape
  (let* ((req (rpc-protocol:encode-request "sum" #(1 2) :id 7))
         (msg (rpc-protocol:decode-message req)))
    (ok (equal "2.0" (gethash "jsonrpc" msg)))
    (ok (equal "sum" (gethash "method" msg)))
    (ok (= 7 (gethash "id" msg)))))

(deftest encode-false-is-json-boolean
  (let ((h (make-hash-table :test 'equal)))
    (setf (gethash "isError" h) :false)
    (let ((wire (rpc-protocol:encode-response h :id 1)))
      (ok (search "\"isError\":false" (remove #\space wire))))))

(deftest notification-has-no-id
  (let ((msg (rpc-protocol:decode-message
              (rpc-protocol:encode-notification "ping" nil))))
    (ok (null (gethash "id" msg)))
    (ok (equal "ping" (gethash "method" msg)))))

(deftest error-response
  (let ((msg (rpc-protocol:decode-message
              (rpc-protocol:encode-error-response
               rpc-protocol:+method-not-found+ "nope" :id 3))))
    (ok (hash-table-p (gethash "error" msg)))
    (ok (= rpc-protocol:+method-not-found+
           (gethash "code" (gethash "error" msg))))))
