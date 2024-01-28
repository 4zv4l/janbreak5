(declare-project
  :name "janbreak5"
  :description ```simple md5 breaker client/server in Janet/C ```
  :version "0.0.0")

(declare-native
  :name "md5"
  :source ["md5/md5.c"]
  :ldflags ["-lcrypto"])
