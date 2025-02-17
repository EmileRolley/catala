(* This file is part of the Catala compiler, a specification language for tax and social benefits
   computation rules. Copyright (C) 2020 Inria, contributor: Denis Merigoux
   <denis.merigoux@inria.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
   in compliance with the License. You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License
   is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
   or implied. See the License for the specific language governing permissions and limitations under
   the License. *)

[@@@ocaml.warning "-7-34"]

open Utils

module ScopeName : Uid.Id with type info = Uid.MarkedString.info = Uid.Make (Uid.MarkedString) ()

module StructName : Uid.Id with type info = Uid.MarkedString.info = Uid.Make (Uid.MarkedString) ()

module StructFieldName : Uid.Id with type info = Uid.MarkedString.info =
  Uid.Make (Uid.MarkedString) ()

module StructMap : Map.S with type key = StructName.t = Map.Make (StructName)

module EnumName : Uid.Id with type info = Uid.MarkedString.info = Uid.Make (Uid.MarkedString) ()

module EnumConstructor : Uid.Id with type info = Uid.MarkedString.info =
  Uid.Make (Uid.MarkedString) ()

module EnumMap : Map.S with type key = EnumName.t = Map.Make (EnumName)

type typ_lit = TBool | TUnit | TInt | TRat | TMoney | TDate | TDuration

type struct_name = StructName.t

type enum_name = EnumName.t

type typ =
  | TLit of typ_lit
  | TTuple of typ Pos.marked list * struct_name option
  | TEnum of typ Pos.marked list * enum_name
  | TArrow of typ Pos.marked * typ Pos.marked
  | TArray of typ Pos.marked
  | TAny

type date = Runtime.date

type duration = Runtime.duration

type integer = Runtime.integer

type decimal = Runtime.decimal

type money = Runtime.money

type lit =
  | LBool of bool
  | LEmptyError
  | LInt of integer
  | LRat of decimal
  | LMoney of money
  | LUnit
  | LDate of date
  | LDuration of duration

type op_kind = KInt | KRat | KMoney | KDate | KDuration

type ternop = Fold

type binop =
  | And
  | Or
  | Xor
  | Add of op_kind
  | Sub of op_kind
  | Mult of op_kind
  | Div of op_kind
  | Lt of op_kind
  | Lte of op_kind
  | Gt of op_kind
  | Gte of op_kind
  | Eq
  | Neq
  | Map
  | Concat
  | Filter

type log_entry = VarDef of typ | BeginCall | EndCall | PosRecordIfTrueBool

type unop =
  | Not
  | Minus of op_kind
  | Log of log_entry * Utils.Uid.MarkedString.info list
  | Length
  | IntToRat
  | GetDay
  | GetMonth
  | GetYear

type operator = Ternop of ternop | Binop of binop | Unop of unop

type expr =
  | EVar of expr Bindlib.var Pos.marked
  | ETuple of expr Pos.marked list * struct_name option
  | ETupleAccess of expr Pos.marked * int * struct_name option * typ Pos.marked list
  | EInj of expr Pos.marked * int * enum_name * typ Pos.marked list
  | EMatch of expr Pos.marked * expr Pos.marked list * enum_name
  | EArray of expr Pos.marked list
  | ELit of lit
  | EAbs of (expr, expr Pos.marked) Bindlib.mbinder Pos.marked * typ Pos.marked list
  | EApp of expr Pos.marked * expr Pos.marked list
  | EAssert of expr Pos.marked
  | EOp of operator
  | EDefault of expr Pos.marked list * expr Pos.marked * expr Pos.marked
  | EIfThenElse of expr Pos.marked * expr Pos.marked * expr Pos.marked
  | ErrorOnEmpty of expr Pos.marked

type struct_ctx = (StructFieldName.t * typ Pos.marked) list StructMap.t

type enum_ctx = (EnumConstructor.t * typ Pos.marked) list EnumMap.t

type decl_ctx = { ctx_enums : enum_ctx; ctx_structs : struct_ctx }

type binder = (expr, expr Pos.marked) Bindlib.binder

type scope_let_kind =
  | DestructuringInputStruct
  | ScopeVarDefinition
  | SubScopeVarDefinition
  | CallingSubScope
  | DestructuringSubScopeResults
  | Assertion

type scope_let = {
  scope_let_var : expr Bindlib.var Pos.marked;
  scope_let_kind : scope_let_kind;
  scope_let_typ : typ Pos.marked;
  scope_let_expr : expr Pos.marked Bindlib.box;
}

type scope_body = {
  scope_body_lets : scope_let list;
  scope_body_result : expr Pos.marked Bindlib.box;  (** {x1 = x1; x2 = x2; x3 = x3; ... } *)
  scope_body_arg : expr Bindlib.var;  (** x: input_struct *)
  scope_body_input_struct : StructName.t;
  scope_body_output_struct : StructName.t;
}

type program = { decl_ctx : decl_ctx; scopes : (ScopeName.t * expr Bindlib.var * scope_body) list }

module Var = struct
  type t = expr Bindlib.var

  let make (s : string Pos.marked) : t =
    Bindlib.new_var
      (fun (x : expr Bindlib.var) : expr -> EVar (x, Pos.get_position s))
      (Pos.unmark s)

  let compare x y = Bindlib.compare_vars x y
end

module VarMap = Map.Make (Var)

let union : unit VarMap.t -> unit VarMap.t -> unit VarMap.t = VarMap.union (fun _ _ _ -> Some ())

let rec free_vars_set (e : expr Pos.marked) : unit VarMap.t =
  match Pos.unmark e with
  | EVar (v, _) -> VarMap.singleton v ()
  | ETuple (es, _) | EArray es -> es |> List.map free_vars_set |> List.fold_left union VarMap.empty
  | ETupleAccess (e1, _, _, _) | EAssert e1 | ErrorOnEmpty e1 | EInj (e1, _, _, _) ->
      free_vars_set e1
  | EApp (e1, es) | EMatch (e1, es, _) ->
      e1 :: es |> List.map free_vars_set |> List.fold_left union VarMap.empty
  | EDefault (es, ejust, econs) ->
      ejust :: econs :: es |> List.map free_vars_set |> List.fold_left union VarMap.empty
  | EOp _ | ELit _ -> VarMap.empty
  | EIfThenElse (e1, e2, e3) ->
      [ e1; e2; e3 ] |> List.map free_vars_set |> List.fold_left union VarMap.empty
  | EAbs ((binder, _), _) ->
      let vs, body = Bindlib.unmbind binder in
      Array.fold_right VarMap.remove vs (free_vars_set body)

let free_vars_list (e : expr Pos.marked) : Var.t list =
  free_vars_set e |> VarMap.bindings |> List.map fst

type vars = expr Bindlib.mvar

let make_var ((x, pos) : Var.t Pos.marked) : expr Pos.marked Bindlib.box =
  Bindlib.box_apply (fun x -> (x, pos)) (Bindlib.box_var x)

let make_abs (xs : vars) (e : expr Pos.marked Bindlib.box) (pos_binder : Pos.t)
    (taus : typ Pos.marked list) (pos : Pos.t) : expr Pos.marked Bindlib.box =
  Bindlib.box_apply (fun b -> (EAbs ((b, pos_binder), taus), pos)) (Bindlib.bind_mvar xs e)

let make_app (e : expr Pos.marked Bindlib.box) (u : expr Pos.marked Bindlib.box list) (pos : Pos.t)
    : expr Pos.marked Bindlib.box =
  Bindlib.box_apply2 (fun e u -> (EApp (e, u), pos)) e (Bindlib.box_list u)

let make_let_in (x : Var.t) (tau : typ Pos.marked) (e1 : expr Pos.marked Bindlib.box)
    (e2 : expr Pos.marked Bindlib.box) (pos : Pos.t) : expr Pos.marked Bindlib.box =
  make_app (make_abs (Array.of_list [ x ]) e2 pos [ tau ] pos) [ e1 ] pos

let empty_thunked_term : expr Pos.marked =
  let silent = Var.make ("_", Pos.no_pos) in
  Bindlib.unbox
    (make_abs
       (Array.of_list [ silent ])
       (Bindlib.box (ELit LEmptyError, Pos.no_pos))
       Pos.no_pos [ (TLit TUnit, Pos.no_pos) ] Pos.no_pos)

let is_value (e : expr Pos.marked) : bool =
  match Pos.unmark e with ELit _ | EAbs _ | EOp _ -> true | _ -> false

let build_whole_scope_expr (ctx : decl_ctx) (body : scope_body) (pos_scope : Pos.t) =
  let body_expr =
    List.fold_right
      (fun scope_let acc ->
        make_let_in
          (Pos.unmark scope_let.scope_let_var)
          scope_let.scope_let_typ scope_let.scope_let_expr acc
          (Pos.get_position scope_let.scope_let_var))
      body.scope_body_lets body.scope_body_result
  in
  make_abs
    (Array.of_list [ body.scope_body_arg ])
    body_expr pos_scope
    [
      ( TTuple
          ( List.map snd (StructMap.find body.scope_body_input_struct ctx.ctx_structs),
            Some body.scope_body_input_struct ),
        pos_scope );
    ]
    pos_scope

let build_scope_typ_from_sig (ctx : decl_ctx) (scope_input_struct_name : StructName.t)
    (scope_return_struct_name : StructName.t) (pos : Pos.t) : typ Pos.marked =
  let scope_sig = StructMap.find scope_input_struct_name ctx.ctx_structs in
  let scope_return_typ = StructMap.find scope_return_struct_name ctx.ctx_structs in
  let result_typ = (TTuple (List.map snd scope_return_typ, Some scope_return_struct_name), pos) in
  let input_typ = (TTuple (List.map snd scope_sig, Some scope_input_struct_name), pos) in
  (TArrow (input_typ, result_typ), pos)

let build_whole_program_expr (p : program) (main_scope : ScopeName.t) =
  let end_result =
    make_var
      (let _, x, _ =
         List.find (fun (s_name, _, _) -> ScopeName.compare main_scope s_name = 0) p.scopes
       in
       (x, Pos.no_pos))
  in
  List.fold_right
    (fun (scope_name, scope_var, scope_body) acc ->
      let pos = Pos.get_position (ScopeName.get_info scope_name) in
      make_let_in scope_var
        (build_scope_typ_from_sig p.decl_ctx scope_body.scope_body_input_struct
           scope_body.scope_body_output_struct pos)
        (build_whole_scope_expr p.decl_ctx scope_body pos)
        acc pos)
    p.scopes end_result

let rec expr_size (e : expr Pos.marked) : int =
  match Pos.unmark e with
  | EVar _ | ELit _ | EOp _ -> 1
  | ETuple (args, _) | EArray args -> List.fold_left (fun acc arg -> acc + expr_size arg) 1 args
  | ETupleAccess (e1, _, _, _) | EInj (e1, _, _, _) | EAssert e1 | ErrorOnEmpty e1 ->
      expr_size e1 + 1
  | EMatch (arg, args, _) | EApp (arg, args) ->
      List.fold_left (fun acc arg -> acc + expr_size arg) (1 + expr_size arg) args
  | EAbs ((binder, _), _) ->
      let _, body = Bindlib.unmbind binder in
      1 + expr_size body
  | EIfThenElse (e1, e2, e3) -> 1 + expr_size e1 + expr_size e2 + expr_size e3
  | EDefault (exceptions, just, cons) ->
      List.fold_left
        (fun acc except -> acc + expr_size except)
        (1 + expr_size just + expr_size cons)
        exceptions

let variable_types (p : program) : typ Pos.marked VarMap.t =
  List.fold_left
    (fun acc (_, _, scope) ->
      List.fold_left
        (fun acc scope_let ->
          VarMap.add (Pos.unmark scope_let.scope_let_var) scope_let.scope_let_typ acc)
        acc scope.scope_body_lets)
    VarMap.empty p.scopes
