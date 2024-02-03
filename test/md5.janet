(import md5)

(assert (= (md5/md5checksum "hell" "5d41402abc4b2a76b9719d911017c592") false))
(assert (= (md5/md5checksum "hello" "5d41402abc4b2a76b9719d911017c592") true))

