(use /server/peg-helper)

(assert (deep=
  (peg/match hash-grammar "GET")
  @["GET"]))

# only lower case hex
(assert (deep=
  (peg/match hash-grammar "POST 7d793037a0760186574b0282f2f435e7 world")
  @["POST" "7d793037a0760186574b0282f2f435e7" "world"]))

# only uppercase hex
(assert (deep=
  (peg/match hash-grammar "POST 7D793037A0760186574B0282F2F435E7 world")
  @["POST" "7d793037a0760186574b0282f2f435e7" "world"]))

# mix case in hex
(assert (deep=
  (peg/match hash-grammar "POST 7d793037A0760186574B0282F2F435E7 world")
  nil))

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
