(def hash-grammar
  "PEG grammar to match and capture client requests"
  (peg/compile
    ~{
      :main (1 :method)
      :method (+ (<- "GET") (* (<- "POST") :response))
      :response (* " " (<- (32 :w)) " " (<- (any 1)))
      }))
