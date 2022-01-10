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
    type aircraft = { id_aircraft : int; x : float; y : float; }
    type node_aircraft = {
      id : int;
      mutable aircraft : aircraft;
      mutable pred : int;
      mutable time:float;
    }
    type param = {
      nb_aircrafts : int;
      goal : node_aircraft array;
      start : node_aircraft array;
      dist_min : float;
      x_min : float;
      y_min : float;
      x_max : float;
      y_max : float;
      v : float;
      mutable pas : float;
      
    }
    val init : unit -> param
    val predecessor : node_aircraft array -> node_aircraft -> node_aircraft
    (** [predecessor nodes node] returns the predecessor of [node] in the array [nodes]*)
  end
