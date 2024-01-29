(def hash-grammar
  ```
  PEG grammar to match and capture client requests

  Allow:
  - GET
  - POST [hex string 32 byte long] [password]

  `The hex string must be either lower OR upper case`
  ```
  (peg/compile
    ~{
      :main (1 :method)
      :method (+ (<- "GET") (* (<- "POST") :response))
      :response (* " " :hash " " (<- (any 1)))
      :hash_raw (+ (32 (range "09" "az")) (32 (range "09" "AZ")))
      :hash (/ (<- :hash_raw) ,string/ascii-lower)
      }))
