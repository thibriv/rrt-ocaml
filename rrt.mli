(***********************************************************************)
(*                                                                     *)
(*                                RRT                                  *)
(*                                                                     *)
(*          Noémie Billion, Mélanie Jouquey, Thibault Rivoalen         *)
(*                                                                     *)
(***********************************************************************)

(** find a path avoiding obstacles between two point *)

open Problem

type obstacle = { x:float;y:float;radius:float}

val distance : float->float->float
(** [distance x1 x2] return the euclidian norm between x1 and x2 *)

val distance_aircraft : Problem.aircraft->Problem.aircraft->float
(** [distance_aircraft a1 a2] return the euclidian distance between a1 and a2 *)

val distance_node : Problem.param -> Problem.node -> Problem.node -> float
                                                                       (** [distance_node param n1 n2] return the sum of distance between each aircraft of n1 and n2*)

val compare_dist : 'a -> 'b -> 'c -> 'c -> ('a -> 'b -> 'c -> Float.t) -> int
                                                                            (** [compare_dist param n_ref n1 n2 f_dist] compare f_dist n_ref n1 and f_dist n_ref n2 *)

val nearest_neighbours :'a -> 'b -> 'c array -> ('a -> 'b -> 'c -> Float.t) -> 'c
(** [nearest_neighbours param n_target array_nodes f_dist] return the closest node in array_nodes from n_target with the criteria f_dist *)

val set_parent : Problem.node -> Problem.node -> Problem.node array ref -> unit               (** [set_parent node_parent new_node nodes] make new_node.pred node_parent and add new_node at nodes*)

val traceback : (int * Problem.node) list -> Problem.node -> Problem.node list -> Problem.node list
                                                                                               (** [traceback assoc_nodes node list_node] recursive function wich look for the predecesor of node in assoc_nodes and add it to list_node *)

val random_aircraft :  Problem.param -> Problem.aircraft
                                          (** [random_aircraft param] return a random aircraft within the space of research defined in param *)
                                          
val random_node : Problem.param -> int -> Problem.node
                                            (** [random_node param n] create a random node with the id n *)

val test_obstacle :  obstacle -> Problem.aircraft -> bool
                                                       (** [test_obstacle obst a1] return true if a1 is not in obst *)

val collision_free : Problem.node -> bool
                                       (** [collision_free param node] return false if node is in the circle of center (3,5) and of radius 2 *)

val test_domain : Problem.param -> Problem.aircraft -> bool
(** [test_domain param a] return true if a is within the problem parameters *)

val in_domain : Problem.param -> Problem.node -> bool
(** [in_domain param node] return true if all aircrafts of node are in the problem domain *)

val test_avion :  Problem.aircraft -> Problem.aircraft -> float -> bool
(** [test_avion a1 a2 dist] return true if the distance between a1 and a2 is greater to dist *)

val test_dist_secu : Problem.param -> Problem.node -> int -> Problem.aircraft -> bool               (** [test_dist_secu param n1 i a1] recursive function return true if there is no distance issue between aircrafts of node n1 and a1 *)

val collision_free_bis : Problem.param -> Problem.node -> bool
                                                            (** [collision_free_bis param node] return true if there is no distance issue in node between each aircraft *)

val extend : Problem.param -> Problem.node -> Problem.node -> Problem.node
                                                                (** [extend param nearest_node node_target nodes] return the new_node from nearest_node and to node_target and if it doesn't comply with the constraints new_node.aircrafts_coord is set to [||] *)

val rrt :
      Problem.param ->
      (Problem.param -> Problem.node -> Problem.node -> float) ->
      (Problem.param -> int -> Problem.node) ->
      (Problem.param ->
       Problem.node ->
       Problem.node array ->
       (Problem.param -> Problem.node -> Problem.node -> float) -> 'a) ->
      (Problem.param -> 'a -> Problem.node -> Problem.node) ->
      ('a -> Problem.node -> Problem.node array ref -> 'b) ->
      ((int * Problem.node) list ->
       Problem.node -> 'c list -> Problem.node list) ->
      Problem.node list

val print_node : Problem.node -> unit