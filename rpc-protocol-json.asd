(defsystem "rpc-protocol-json"
  :version "0.1.0"
  :description "JSON-RPC 2.0 codec for rpc-protocol"
  :author "egao1980"
  :license "MIT"
  :depends-on ("rpc-protocol" "json-protocol" "json-backend-jzon")
  :properties (:cl-repo (:ci (:with ("dissect")
                             :sources (("json-protocol" :oci)))))
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "codec"))
  :in-order-to ((test-op (test-op "rpc-protocol-json/tests"))))

(defsystem "rpc-protocol-json/tests"
  :depends-on ("rpc-protocol-json" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "codec-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
