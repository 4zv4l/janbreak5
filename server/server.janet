(import ./db-helper)
(import ./peg-helper)

(defn send-hash
  "Send a hash to crack to the client (without newline so 32 bytes)"
  [server client]
  (if-let [hash (db-helper/gethash 'todo)]
    (do
      (db-helper/updatehash hash 'doing)
      (net/send-to server client (string/format "%s" hash))
      (printf "Sent %q to %s:%d" hash ;(net/address-unpack client)))
    (net/send-to server client "EMPTY")))

(defn recv-hash
  "Receive a hash and password from client, check if it match and update the db"
  [server client hash password]
  # TODO: check if password match hash instead of `true`
  (case true
    (not (db-helper/hashindb hash)) (net/send-to server client "NOT INSIDE")
    (db-helper/hashstatus hash "done") (net/send-to server client "ALREADY CRACKED")
    true (do
           (net/send-to server client "OK")
           (db-helper/updatehash hash 'done password)
           (print "db state after update:")
           (db-helper/showdb))
    ((net/send-to server client "NOT OK")
     (db-helper/updatehash hash 'todo))))

(defn main [& args]
  (unless (= (length args) 4)
    ((eprintf "usage: %s [ip] [port] [hash file]" (args 0))
     (os/exit 1)))
  (def [ip port file] [(get args 1) (scan-number (get args 2)) (get args 3)])
  (printf "Initialise db with %s" file)
  (db-helper/initdb file)
  (def server (net/listen ip port :datagram))
  (printf "Listening on %s:%d" ip port)
  (while true
    (var buffer @"")
    (def client (net/recv-from server 1024 buffer))
    (match (peg/match peg-helper/hash-grammar (string/trim buffer))
      ["GET"] (send-hash server client)
      ["POST" hash password] (recv-hash server client hash password)
      _ (print "got garbage from a client: " (string/format "%q" buffer)))))
