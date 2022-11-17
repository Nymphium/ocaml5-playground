module Make (S : Cache.S) = struct
  open Effect.Deep

  let newh () th =
    let effc : type e. e Effect.t -> ((e, 'a) continuation -> 'a) option = function
      | S.Get _ -> Some (fun k -> continue k None)
      | S.Set _ -> Some (fun k -> continue k ())
      | _ -> None
    in
    try_with th () { effc }
  ;;
end
