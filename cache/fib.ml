module Eff = Cache.Inst (struct
  type key = int
  type value = int
end)

let rec fib n =
  if n < 2
  then n
  else (
    let n1 = cache (n - 1) in
    let n2 = cache (n - 2) in
    n1 + n2)

and cache k =
  match Effect.perform @@ Eff.Get k with
  | Some v -> v
  | None ->
    let n = fib k in
    Effect.perform @@ Eff.Set (k, n);
    n
;;
