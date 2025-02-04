(import db)

(defmacro with-conn 
  "automatically open and close the db connection after executing body"
  [& body]
  ~(defer (db/disconnect)
     (db/connect "md5break.sqlite3")
     ,;body))

(defn initdb
  ``
  Load each hash from the file and insert them in the db
  Keeping already existing entry unchanged (avoid loosing already broken hash)
  ``
  [filename]
  (with-conn
    (db/execute "drop table if exists md5break")
    (db/execute "create table if not exists md5break (id text primary key, status text, pass text)")
    (try(do
        (with [file (file/open filename)]
          (each hash (file/lines file)
            (def hash (string/trim hash))
            (if (= (length hash) 32)
              (db/insert :md5break {:id hash :status 'todo} :on-conflict :id :do :nothing)
              (eprintf "skipping: %s" hash)))))
        ([err] (eprintf "couldnt open %s: %s" filename err)))))

(defn showdb
  "Show the md5break table from the db in pretty printing"
  []
  (with-conn
    (each hash (db/fetch-all [:md5break])
    (pp hash))))

(defn gethash
  "Get a random hash from the db with `status`"
  [status]
  (with-conn
    (get-in (db/from :md5break :limit 1 :where {:status status} :order "random()") [0 :id])))

(defn hashindb
  "Check if the given hash is in the db"
  [hash]
  (with-conn
    (not= (db/find :md5break hash) nil)))

(defn hashstatus
  "Check the if the status of a hash is the one passed in argments"
  [hash status]
  (with-conn
    (= (get-in (db/from :md5break :limit 1 :where {:id hash}) [0 :status]) status)))

(defn updatehash
  "Update the status of a hash in the db"
  [hash status &opt pass]
  (with-conn
    (if pass 
      (db/update :md5break hash {:status status :pass pass})
      (db/update :md5break hash {:status status}))))
