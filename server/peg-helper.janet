(def hash-grammar
  "PEG grammar to match and capture client requests"
  (peg/compile
    ~{
      :main (1 :method)
      :method (+ (<- "GET") (* (<- "POST") :response))
      :response (* " " (<- (32 :hex)) " " (<- (any 1)))
      :hex (+ (range "af") (range "AF") (range "09"))
      }))
