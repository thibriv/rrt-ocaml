(***********************************************************************)
(*                                                                     *)
(*                                RRT                                  *)
(*                                                                     *)
(*          Noémie Billion, Mélanie Jouquey, Thibault Rivoalen         *)
(*                                                                     *)
(***********************************************************************)

(** Find a path avoiding obstacles between two point *)

open Problem

val distance_aircraft : Problem.aircraft -> Problem.aircraft -> float
(** [distance_aircraft a1 a2] return the euclidian distance between [a1] and [a2] *)

val distance_node_aircraft : Problem.node_aircraft -> Problem.node_aircraft -> float
(** [distance_node_aircraft param n1 n2] return the distance between [n1] and [n2] *)

val compare_dist : Problem.node_aircraft -> Problem.node_aircraft -> Problem.node_aircraft -> (Problem.node_aircraft -> Problem.node_aircraft -> float) -> int
(** [compare_dist n_ref n1 n2 f_dist] compares [f_dist n_ref n1] and [f_dist n_ref n2] as with [Float.compare] in the standard library *)

val random_aircraft : Problem.param -> int -> Problem.aircraft
(** [random_aircraft param i] return a random aircraft for the aircraft [i] within the space of research defined in param *)

val test_avion : Problem.aircraft -> Problem.aircraft -> float -> bool
(** [test_avion a1 a2 dist] return true if the distance between [a1] and [a2] is greater than [dist] *)

val test_dist_secu : Problem.param -> Problem.node_aircraft array -> int -> Problem.aircraft -> bool
(** [test_dist_secu param n i a1] recursive function return true if there is no distance issue between aircrafts of node array [n] and [a1] *)

val collision_free : Problem.param -> Problem.node_aircraft array -> bool
(** [collision_free param nodes] return true if all the aircraft of [nodes] are not in conflicts with each other *)

val sample_free : Problem.param -> int -> Problem.node_aircraft array
(** [sample_free param i] create a random node with the id [i] *)

val nearest : Problem.param -> Problem.node_aircraft array -> Problem.node_aircraft array -> bool array -> (Problem.node_aircraft -> Problem.node_aircraft -> float) -> Problem.node_aircraft array
(** [nearest param n_target array_nodes bool_array f_dist] return the closest node in [array_nodes] from [n_target] with the criteria [f_dist] *)

val calcul_x :
  Problem.param ->
  Problem.node_aircraft -> Problem.node_aircraft -> float
(** [calcul_x param node_start node_goal] returns the coordinates [x] from [node_start] to [node_goal] *)

val calcul_y :
  Problem.param ->
  Problem.node_aircraft -> Problem.node_aircraft -> float
(** Same as [calcul_x] for coordinate [y] *)

val travel_time :
  Problem.param -> float -> float -> Problem.node_aircraft -> float
(** [travel_time param x_dest y_dest node_start] returns the time associated with the travel from [node_start] to [(x_dest,y_dest)] *)

val steer :
  Problem.param ->
  Problem.node_aircraft array ->
  Problem.node_aircraft array ->
  int -> bool array -> Problem.node_aircraft array
(** [steer param array_nearest array_random id_first bool_array] return the [new_node_array] from [array_nearest] to [array_target] *)

val add_and_test :
  Problem.param ->
  bool array ->
  Problem.node_aircraft array ->
  Problem.node_aircraft array ref ->
  (Problem.node_aircraft -> Problem.node_aircraft -> float) -> bool array
(** [add_and_test param bool_array new_node_array nodes f_dist] returns an array of booleans and add [new_node_array] to the tree *)

val traceback :
  (int * Problem.node_aircraft) list ->
  Problem.node_aircraft ->
  Problem.node_aircraft list -> Problem.node_aircraft list
(** [traceback assoc_nodes node list_node] recursive function which look for the predecesor of node in assoc_nodes and add it to list_node *)


val tracebacks :
  Problem.param ->
  (int * Problem.node_aircraft) list ->
  Problem.node_aircraft array ->
  int ->
  Problem.node_aircraft list array -> Problem.node_aircraft list array
(** [tracebacks param assoc_nodes i list_nodes] recursive function which return the tracebacks of all aircrafts in [list_nodes]. The function should always be called with [i=0] and [list_nodes] as the empty array.*)


val rrt :
  Problem.param ->
  (Problem.node_aircraft -> Problem.node_aircraft -> float) ->
  (Problem.param -> int -> Problem.node_aircraft array) ->
  (Problem.param ->
   Problem.node_aircraft array ->
   Problem.node_aircraft array ->
   bool array ->
   (Problem.node_aircraft -> Problem.node_aircraft -> float) -> Problem.node_aircraft array) ->
  (Problem.param ->
   Problem.node_aircraft array ->
   Problem.node_aircraft array ->
   int -> bool array -> Problem.node_aircraft array) ->
  (Problem.param ->
   (int * Problem.node_aircraft) list ->
   Problem.node_aircraft array ->
   int -> Problem.node_aircraft list array -> Problem.node_aircraft list array) ->
  Problem.node_aircraft list array
(** [rrt param f_dist f_random_node f_nearest_neighbours f_extend f_traceback] returns the tracebacks and display a solution of the problem in [param] *)