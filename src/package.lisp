(defpackage #:rpc-protocol-json
  (:use #:cl)
  (:nicknames #:stack-rpc-json)
  (:export #:jsonrpc-codec
           #:*jsonrpc-codec*
           #:use-jsonrpc-codec))

(in-package #:rpc-protocol-json)
