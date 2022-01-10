(***********************************************************************)
(*                                                                     *)
(*                                RRT                                  *)
(*                                                                     *)
(*          Noémie Billion, Mélanie Jouquey, Thibault Rivoalen         *)
(*                                                                     *)
(***********************************************************************)

(** A RRT problem *)

module Problem :
    sig
        type aircraft = {id_aircraft:int; x:float; y:float;}
        type node = {id:int; mutable aircrafts_coord : aircraft array; time:float; mutable pred:int; }
        type param = {nb_aircrafts:int; goal:node; start:node; dist_min:float; v:float; mutable time_min:float; mutable time_max:float;x_min:float; y_min:float; x_max:float; y_max:float; mutable pas:float;}
        val init : unit -> param
    end