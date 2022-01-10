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

val define_colors : int -> int -> int -> Graphics.color array
(** [define_colors nb mini maxi] returns an array of [nb] [Graphics.color] between [mini] and [maxi] for the floating value of [r], [g] or [b]. *)

val compare_node_id : Problem.node -> Problem.node -> int
(** [compare_node_id n1 n2] returns [0] if [n1.id] equals [n2.id], a negative integer if [n1.id] is less than [n2.id], and a positive integer if [n1.id] is greater than [n2.id] *)

val scale : gui -> Problem.param -> Problem.aircraft -> int*int
(** [scale window param aircraft] returns the graphic window coordinates corresponding to coordinates [(x,y)] of the [aircraft] in the problem space. *)

val display_pt : (Problem.aircraft -> int * int) -> Problem.node -> int -> float -> bool -> unit
(** [display_pt scale node r_pt r_obst last] shows on the graphic window the dots corresponding to the aircrafts of [node] with the help of the [scale] function.
    The dots have the radius [r_pt] and if [last] is [true] it will draw a red circle of radius [r_obst] which represents the obstacle area. *)

val display_seg : (Problem.aircraft -> int * int) -> Problem.node -> Problem.node -> unit
(** [display_seg scale node1 node2] shows on the graphic window the segments between [node1] and [node2] with the help of the [scale] function. *)

val predecessor : Problem.node array -> Problem.node -> Problem.node
(** [predecessor nodes node] returns the predecessor of [node] in the array [nodes], which must be sorted by the [id] of the nodes. *)

val sleep : float -> unit
(** [sleep t] waits [t] seconds. *)

val display : (Problem.aircraft -> int * int) -> Problem.node array -> int -> float -> unit
(** [display scale nodes r_pt r_obst] shows on the graphic window the aircrafts of [nodes] with a dot radius of [r_pt] and with an obstacle radius of [r_obst]. *)

val init_graph : Problem.param -> unit
(** [init_graph ()] initializes the graphic window. *)

val do_at_iter : Problem.node array ref -> Problem.param -> unit

val display_traceback : Problem.node list -> Problem.node array -> (Problem.aircraft -> int * int) -> unit
(** [display_traceback path nodes scale] display the [path] with the help of the [scale] function and [nodes] which is the array of all the nodes of the graph. *)

val do_at_end : Problem.node list -> Problem.node array -> Problem.param -> unit