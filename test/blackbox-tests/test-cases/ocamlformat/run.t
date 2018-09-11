Formatting can be checked using the @format target:

  $ cp lib/lib.ml.orig lib/lib.ml
  $ dune build @format
  File "exe/hello.ml", line 1, characters 0-0:
  Files _build/default/exe/hello.ml and _build/default/exe/hello.ml.formatted differ.
  File "lib/lib.ml", line 1, characters 0-0:
  Files _build/default/lib/lib.ml and _build/default/lib/lib.ml.formatted differ.
  File "lib/lib.mli", line 1, characters 0-0:
  Files _build/default/lib/lib.mli and _build/default/lib/lib.mli.formatted differ.
  File "lib_osl/b.ml", line 1, characters 0-0:
  Files _build/default/lib_osl/b.ml and _build/default/lib_osl/b.ml.formatted differ.
  File "lib_osl/a.ml", line 1, characters 0-0:
  Files _build/default/lib_osl/a.ml and _build/default/lib_osl/a.ml.formatted differ.
  File "lib_reason/ocaml_file.mli", line 1, characters 0-0:
  Files _build/default/lib_reason/ocaml_file.mli and _build/default/lib_reason/ocaml_file.mli.formatted differ.
  File "lib_reason/ocaml_file.ml", line 1, characters 0-0:
  Files _build/default/lib_reason/ocaml_file.ml and _build/default/lib_reason/ocaml_file.ml.formatted differ.
  File "test/test.ml", line 1, characters 0-0:
  Files _build/default/test/test.ml and _build/default/test/test.ml.formatted differ.
  [1]

And fixable files can be promoted:

  $ dune promote lib/lib.ml
  Promoting _build/default/lib/lib.ml.formatted to lib/lib.ml.
  $ cat lib/lib.ml
  let x = 1
