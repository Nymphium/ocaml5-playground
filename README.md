OCaml 5.0 playground
===

# cache
calculate `fib 35` with memory cache, redis, and no modification

```
$ docker compose up -d
$ dune build cache/main.exe
$ time BACKEND=redis _build/default/cache/main.exe
9227465BACKEND=redis _build/default/cache/main.exe  0.01s user 0.01s system 57% cpu 0.040 total
$ time BACKEND=memory _build/default/cache/main.exe
9227465BACKEND=memory _build/default/cache/main.exe  0.01s user 0.00s system 69% cpu 0.017 total
$ time BACKEND=default _build/default/cache/main.exe
9227465BACKEND=default _build/default/cache/main.exe  0.86s user 0.01s system 99% cpu 0.881 total
```
