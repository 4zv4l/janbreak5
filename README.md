# Janbreak5

## What

Simple md5 breaker client/server in Janet/C.

## Why

To enforce C and Git skills and to learn a new language (Janet).

## How to use

### The server:

```
$ ./server 127.0.0.1 8080 hashfile
```

This will start an udp server on `127.0.0.1:8080` and load into `md5break.sqlite3`
the hashes found in `hashfile`, it is not destructive so if a hash already exists in the db, it will simply skip it.

## Protocol

This is a very simple protocol.

The client send `GET` to the server to receive a hash to break.

The client send `POST [hash] [password]` to the server to update the hash status.

The server send `OK` if the hash matches the password.

The server send `NOT OK` if the hash does not match the password.

> NOTE: The server will check if the password matches the hash.

## TODO

- [ ] Check if password match hash (adding native module md5)
- [ ] Handle the case when there are no more 'todo' hash (but maybe still 'doing')
- [X] Check if hash exists before update it in the db
