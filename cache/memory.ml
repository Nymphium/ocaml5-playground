module Make (S : Cache.S) = struct
  include S
  open Effect.Deep

  let newh () =
    let tbl : (key, value) Hashtbl.t = Hashtbl.create 10 in
    fun th ->
      let effc : type e. e Effect.t -> ((e, 'a) continuation -> 'a) option = function
        | S.Get key ->
          Some
            (fun k ->
              let v = Hashtbl.find_opt tbl key in
              continue k v)
        | S.Set (key, v) ->
          Some
            (fun k ->
              Hashtbl.replace tbl key v;
              continue k ())
        | _ -> None
      in
      try_with th () { effc }
  ;;
end
