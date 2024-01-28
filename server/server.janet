(defn handle
  "Send a hash to a client"
  [server client]
  (net/send-to server client "hello !\n")
  (printf "Sent %q to %s:%d" "Hello !\n" ;(net/address-unpack client)))

(defn main [& args]
  (unless (= (length args) 4)
    ((eprintf "usage: %s [ip] [port] [hash file]" (args 0))
     (os/exit 1)))
  (def [ip port] [(get args 1) (scan-number (get args 2))])
  (def server (net/listen ip port :datagram))
  (printf "Listening on %s:%d" ip port)
  (while true
    (var buffer @"")
    (def client (net/recv-from server 1024 buffer))
    (match (string/trim buffer)
      "GET" (handle server client)
      "POST" (printf "got %q from %s:%d" buffer ;(net/address-unpack client))
      _ (print "got garbage from a client"))))
