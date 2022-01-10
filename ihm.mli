(***********************************************************************)
(*                                                                     *)
(*                                RRT                                  *)
(*                                                                     *)
(*          Noémie Billion, Mélanie Jouquey, Thibault Rivoalen         *)
(*                                                                     *)
(***********************************************************************)

(** Display on a graphic window all elements relative to the current state of a RRT resolution.*)

open Problem

type gui = { width:int; height:int; }

val round_dfrac : int -> float -> float
(** [round_dfrac i float] returns the rounded float with [i] digits *)

val define_colors : int -> int -> int -> Graphics.color array
(** [define_colors nb mini maxi] returns an array of [nb] [Graphics.color] between [mini] and [maxi] for the floating value of [r], [g] or [b]. *)

val compare_node_id : Problem.node_aircraft -> Problem.node_aircraft -> int
(** [compare_node_id n1 n2] returns [0] if [n1.id] equals [n2.id], a negative integer if [n1.id] is less than [n2.id], and a positive integer if [n1.id] is greater than [n2.id] *)

val scale : gui -> Problem.param -> Problem.aircraft -> int*int
(** [scale window param aircraft] returns the graphic window coordinates corresponding to coordinates [(x,y)] of the [aircraft] in the problem space. *)

val display_pt : (Problem.aircraft -> int * int) -> Problem.node_aircraft -> int -> float -> bool -> bool -> unit
(** [display_pt scale node r_pt r_obst last time] shows on the graphic window the dots corresponding to the aircrafts of [node] with the help of the [scale] function
    The dots have the radius [r_pt] and if [last] is [true], it will draw a red circle of radius [r_obst] which represents the obstacle area.
     If [time] is [true], the time of the node will be display. *)

val display_seg : (Problem.aircraft -> int * int) -> Problem.node_aircraft -> Problem.node_aircraft -> (int*int*int*int) array -> (int*int*int*int) array
(** [display_seg scale node1 node2 acc] shows on the graphic window the segments between [node1] and [node2] with the help of the [scale] function.
 As a recursive function, it should always be called with [acc] as the empty array.*)

val sleep : float -> unit
(** [sleep t] waits [t] seconds. *)

val display : Problem.param -> (Problem.aircraft -> int * int) -> Problem.node_aircraft array -> int -> float -> bool -> unit
(** [display param scale nodes r_pt r_obst time] shows on the graphic window the aircrafts of [nodes] with a dot radius of [r_pt] and with an obstacle radius of [r_obst] for the last aircrafts.
 If [time] is [true] it will display the time associated with each node.*)

val display_traceback : Problem.node_aircraft list -> Problem.node_aircraft array -> (Problem.aircraft -> int * int) -> (int * int * int * int) array-> unit
(** [display_traceback path nodes scale acc] display the [path] with the help of the [scale] function and [nodes] which is the array of all the nodes of the graph. [acc] is used internally and the function should always be called with the empty array. *)

val display_tracebacks : Problem.node_aircraft list array -> Problem.node_aircraft array -> (Problem.aircraft -> int * int) -> unit
(** [display_tracebacks paths nodes scale] display the each [path] of [paths] with the help of the [scale] function and [nodes] which is the array of all the nodes of the graph.*)

val init_graph : Problem.param -> unit
(** [init_graph param] initializes the graphic window. *)

val do_at_iter : Problem.node_aircraft array ref -> Problem.param -> unit
(** [do_at_iter nodes_array param] displays the aircrafts of [nodes_array] at each iteration of the RRT algorithm *)

val do_at_end : Problem.node_aircraft list array -> Problem.node_aircraft array -> Problem.param -> unit
(** [do_at_end paths nodes_array param] displays the final GUI for the user in the terminal *)