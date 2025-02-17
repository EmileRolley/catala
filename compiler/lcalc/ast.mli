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

open Utils

(** Abstract syntax tree for the lambda calculus *)

(** {1 Abstract syntax tree} *)

(** The expressions use the {{:https://lepigre.fr/ocaml-bindlib/} Bindlib} library, based on
    higher-order abstract syntax*)

type lit =
  | LBool of bool
  | LInt of Runtime.integer
  | LRat of Runtime.decimal
  | LMoney of Runtime.money
  | LUnit
  | LDate of Runtime.date
  | LDuration of Runtime.duration

type except = ConflictError | EmptyError | NoValueProvided | Crash

type expr =
  | EVar of expr Bindlib.var Pos.marked
  | ETuple of expr Pos.marked list * Dcalc.Ast.StructName.t option
      (** The [MarkedString.info] is the former struct field name*)
  | ETupleAccess of
      expr Pos.marked * int * Dcalc.Ast.StructName.t option * Dcalc.Ast.typ Pos.marked list
      (** The [MarkedString.info] is the former struct field name *)
  | EInj of expr Pos.marked * int * Dcalc.Ast.EnumName.t * Dcalc.Ast.typ Pos.marked list
      (** The [MarkedString.info] is the former enum case name *)
  | EMatch of expr Pos.marked * expr Pos.marked list * Dcalc.Ast.EnumName.t
      (** The [MarkedString.info] is the former enum case name *)
  | EArray of expr Pos.marked list
  | ELit of lit
  | EAbs of (expr, expr Pos.marked) Bindlib.mbinder Pos.marked * Dcalc.Ast.typ Pos.marked list
  | EApp of expr Pos.marked * expr Pos.marked list
  | EAssert of expr Pos.marked
  | EOp of Dcalc.Ast.operator
  | EIfThenElse of expr Pos.marked * expr Pos.marked * expr Pos.marked
  | ERaise of except
  | ECatch of expr Pos.marked * except * expr Pos.marked

(** {1 Variable helpers} *)

module Var : sig
  type t = expr Bindlib.var

  val make : string Pos.marked -> t

  val compare : t -> t -> int
end

module VarMap : Map.S with type key = Var.t

type vars = expr Bindlib.mvar

val make_var : Var.t Pos.marked -> expr Pos.marked Bindlib.box

val make_abs :
  vars ->
  expr Pos.marked Bindlib.box ->
  Pos.t ->
  Dcalc.Ast.typ Pos.marked list ->
  Pos.t ->
  expr Pos.marked Bindlib.box

val make_app :
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box list ->
  Pos.t ->
  expr Pos.marked Bindlib.box

val make_let_in :
  Var.t ->
  Dcalc.Ast.typ Pos.marked ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box

val option_enum : Dcalc.Ast.EnumName.t

val none_constr : Dcalc.Ast.EnumConstructor.t

val some_constr : Dcalc.Ast.EnumConstructor.t

val option_enum_config : (Dcalc.Ast.EnumConstructor.t * Dcalc.Ast.typ Pos.marked) list

val make_none : Pos.t -> expr Pos.marked Bindlib.box

val make_some : expr Pos.marked Bindlib.box -> expr Pos.marked Bindlib.box

val make_matchopt_with_abs_arms :
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box

val make_matchopt :
  Pos.t ->
  Var.t ->
  Dcalc.Ast.typ Pos.marked ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box ->
  expr Pos.marked Bindlib.box
(** [e' = make_matchopt'' pos v e e_none e_some] Builds the term corresponding to
    [match e with | None -> fun () -> e_none |Some -> fun v -> e_some]. *)

val handle_default : Var.t

val handle_default_opt : Var.t

type binder = (expr, expr Pos.marked) Bindlib.binder

type scope_body = {
  scope_body_name : Dcalc.Ast.ScopeName.t;
  scope_body_var : Var.t;
  scope_body_expr : expr Pos.marked;
}

type program = { decl_ctx : Dcalc.Ast.decl_ctx; scopes : scope_body list }
