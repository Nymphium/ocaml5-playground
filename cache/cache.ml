module type T = sig
  type key
  type value
end

module type S = sig
  type key
  type value

  type _ Effect.t +=
    | Get : key -> value option Effect.t
    | Set : (key * value) -> unit Effect.t
end

(* effect instantiation *)
module Inst (T : T) : S with type key = T.key and type value = T.value = struct
  include T

  type _ Effect.t +=
    | Get : key -> value option Effect.t
    | Set : (key * value) -> unit Effect.t
end
