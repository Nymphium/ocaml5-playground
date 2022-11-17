let get_handler () =
  match Sys.getenv "BACKEND" with
  | "memory" ->
    let module H = Memory.Make (Fib.Eff) in
    H.newh ()
  | "redis" ->
    let module H =
      Redis.Make (struct
        include Fib.Eff

        let string_of_key = string_of_int
        let string_of_value = string_of_int
        let value_of_string = int_of_string
      end)
    in
    let conn = Redis_sync.Client.(connection_spec "localhost" |> connect) in
    H.newh conn
  | _ ->
    let module H = Nocache.Make (Fib.Eff) in
    H.newh ()
;;

let main handler = handler @@ fun () -> print_int @@ Fib.fib 50
let () = get_handler () |> main
