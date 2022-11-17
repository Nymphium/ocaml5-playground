open struct
  module R = Redis_sync.Client
end

module type S = sig
  include Cache.S

  val string_of_key : key -> string
  val value_of_string : string -> value
  val string_of_value : value -> string
end

module Make (S : S) = struct
  include S
  open Effect.Deep

  let newh conn th =
    let effc : type e a. e Effect.t -> ((e, a) continuation -> a) option = function
      | S.Get key ->
        Some
          (fun k ->
            let key' = string_of_key key in
            let v' = R.get conn key' in
            continue k (Option.map value_of_string v'))
      | S.Set (key, value) ->
        Some
          (fun k ->
            let key' = string_of_key key in
            let value' = string_of_value value in
            let _ = R.set conn key' value' in
            continue k ())
      | _ -> None
    in
    try_with th () { effc }
  ;;
end
