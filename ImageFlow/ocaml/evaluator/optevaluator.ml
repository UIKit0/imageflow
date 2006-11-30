open Expr

(* Add cacheing to an evaluation function *)
let cacheingEval cache eval expr =
  try
    Cache.lookup cache expr
  with Not_found ->
    let res = eval expr in
    begin match res with
      Image res_image when not (is_value expr) ->
        Cache.store cache expr res_image
    | _ -> ()
    end;
    res

(* Add error propagation to an evaluation function *)
let propagatingEval eval = function
    Op(_, args) when Marray.exists is_error args ->
      Error None
  | Array elems when Marray.exists is_error elems ->
      Error None
  | Error _ ->
      Error None
  | expr ->
      eval expr

(* Turn a single-level evaluation function to a recursive one *)
let rec recursingEval eval = function
    Op(op, args) ->
      eval (Op(op, Array.map (recursingEval eval) args))
  | Array elems ->
      eval (Array (Array.map (recursingEval eval) elems))
  | other when not (is_value other) ->
      eval other
  | value ->
      value

(* Add logging to an evaluation function *)
let loggingEval eval expr =
  print_endline (" eval: " ^ (Printer.to_string expr));
  let res = eval expr in
  print_endline ("    => " ^ (Printer.to_string res));
  res

let (++) f g x = f (g x)

let eval cache expr =
  (recursingEval ++ (cacheingEval cache) ++ propagatingEval) Evaluator.eval
    (Optimiser.rewrite expr)

let eval_extent cache expr =
  match eval cache (Op("extent", [|expr|])) with
    Rect extent ->
      Some extent
  | Error _ ->
      None
  | o ->
      failwith ("unexpected result from evaluator: "^(Printer.to_string(o)))

let eval_as_image =
  let background = Op("checkerboard", [| Point Point.zero;
                                         Color (Color.make 1. 1. 1. 1.);
                                         Color (Color.make 0.8 0.8 0.8 1.);
                                         Num 40.0;
                                         Num 1.0 |])
  in fun cache expr ->
    match eval cache expr with
      Mask _ as mask ->
        eval cache (Op("mask-to-image", [| mask |]))
    | Image _ as image ->
        eval
          cache
          (Op("blend", [| background;
                          image;
                          Int (Blendmode.to_int Blendmode.SourceOver) |]))
    | Error _ as error ->
        error
    | other ->
        failwith ("non-image result from evaluator: "
                  ^ (Printer.to_string(other)))

let eval_as_masked_image =
  let mask_cutout_margin = 20.0
  and mask_color = Color.make 0.5 0.5 0.5 1.0
  in fun cache expr mask_cutout_bounds ->
    match eval_as_image cache expr with
      Image _ as image ->
        eval
          cache
          (Op("rectangular-window",
              [| image;
                 Color mask_color;
                 Rect mask_cutout_bounds;
                 Num mask_cutout_margin |]))
    | Error _ as error ->
        error
    | other ->
        failwith ("non-image result from evaluator: "
                  ^ (Printer.to_string(other)))
        
