open Import

let flag_of_kind : Ml_kind.t -> _ =
  function
  | Impl -> "--impl"
  | Intf -> "--intf"

let add_alias_format sctx loc ~dir ~scope action =
  let alias_conf =
    { Dune_file.Alias_conf.name = "format"
    ; deps = []
    ; action = Some (loc, action)
    ; locks = []
    ; package = None
    ; enabled_if = None
    ; loc
    }
  in
  Simple_rules.alias sctx ~dir ~scope alias_conf

let sv = String_with_vars.virt_text __POS__

let target_var = String_with_vars.virt_var __POS__ "targets"

let run_rule ~target ~exe ~args ~loc =
  { Dune_file.Rule.targets = Static [target]
  ; action = (loc, Run (exe, args))
  ; mode = Standard
  ; deps = []
  ; locks = []
  ; loc
  }

let diff file1 file2 =
  Action.Unexpanded.Diff
    { optional = false
    ; mode = Text
    ; file1
    ; file2
    }

let rules_for_ocaml_file loc ocamlformat kind path =
  let flag = flag_of_kind kind in
  let path = Path.basename path in
  let formatted = path ^ ".formatted" in
  let dep x = String_with_vars.make_macro loc "dep" x in
  let format_rule =
    run_rule
      ~loc
      ~target:formatted
      ~exe:(dep @@ Path.to_string ocamlformat)
      ~args:[sv flag; dep path; sv "-o"; target_var]
  in
  let diff_action = diff (dep path) (sv formatted) in
  (format_rule, diff_action)

let ml_kind_of_extension = function
  | ".ml" -> Some Ml_kind.Impl
  | ".mli" -> Some Ml_kind.Intf
  | _ -> None

let gen_rules sctx fmt ~dir ~scope ~dir_contents =
  let {Dune_file.Ocamlformat.loc; files} = fmt in
  let add_alias action = add_alias_format sctx loc ~dir ~scope action in
  let setup_rules (format_rule, diff_action) =
    let _ : Path.t list =
      Simple_rules.user_rule sctx ~dir ~scope format_rule
    in
    add_alias diff_action
  in
  match Bin.which "ocamlformat" with
  | None ->
    let msg = "Cannot find ocamlformat, skipping.\n" in
    add_alias (Echo [sv msg])
  | Some ocamlformat ->
    let standard =
      String.Set.to_list @@ Dir_contents.text_files dir_contents
    in
    let parse ~loc:_ x = x in
    let files =
      Ordered_set_lang.String.eval
        files
        ~standard
        ~parse
    in
    List.iter files ~f:(fun file ->
      let extension = Filename.extension file in
      let path = Path.of_string file in
      Option.iter
        (ml_kind_of_extension extension)
        ~f:(fun kind ->
          setup_rules (rules_for_ocaml_file loc ocamlformat kind path)))
