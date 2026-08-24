# rpc-protocol-json

**JSON-RPC 2.0** codec for [`rpc-protocol`](https://github.com/egao1980/rpc-protocol).

`rpc-protocol` owns interaction modes (`:call-response`, `:notify`, `:call-stream`, …). This package owns `{jsonrpc:"2.0", method, params, id}` encode/decode.

```lisp
(asdf:load-system "rpc-protocol-json")  ; sets *rpc-codec*
(rpc-protocol:encode-request "sum" #(1 2) :id 7)
;; => "{\"jsonrpc\":\"2.0\",\"method\":\"sum\",\"params\":[1,2],\"id\":7}"
```

gRPC is [`rpc-protocol-grpc`](https://github.com/egao1980/rpc-protocol-grpc), not this codec. Do **not** wrap AG-UI in a JSON-RPC envelope.

## License

MIT
