(use /server/peg-helper)

(assert (deep=
  (peg/match hash-grammar "GET")
  @["GET"]))

(assert (deep=
  (peg/match hash-grammar "POST 7d793037a0760186574b0282f2f435e7 world")
  @["POST" "7d793037a0760186574b0282f2f435e7" "world"]))

# totally wrong request
(assert (deep=
  (peg/match hash-grammar "Coucou")
  nil))

# miss one char in the hash
(assert (deep=
  (peg/match hash-grammar "POST 7d793037a0760186574b0282f2f435e world")
  nil))

# bad hex hash (contains a Z)
(assert (deep=
  (peg/match hash-grammar "POST 7D793037Z0760186574b0282f2f435ef world")
  nil))
