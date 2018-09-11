open Import

(** Setup ocamlformat rules for the given dir.
    If ocamlformat is not available in $PATH, just display an error message
    when the alias is built. *)
val gen_rules:
  Super_context.t
  -> Dune_file.Ocamlformat.t
  -> dir:Path.t
  -> scope:Scope.t
  -> dir_contents:Dir_contents.t
  -> unit
