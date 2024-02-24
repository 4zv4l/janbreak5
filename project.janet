(declare-project
  :name "janbreak5"
  :description ```simple md5 breaker client/server in Janet/C```
  :dependencies ["https://github.com/joy-framework/db"
                 "https://github.com/janet-lang/sqlite3"])

(declare-executable
  :name "server"
  :entry "server/server.janet"
  :lflags ["-lcrypto"])

(declare-native
  :name "md5"
  :source ["md5/md5.c"]
  :ldflags ["-lcrypto"])
