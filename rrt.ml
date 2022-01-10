open Problem

type obstacle = {
    x:float;
    y:float;
    radius:float
  };;

let distance = fun x y->
  sqrt ((x-.y)**2.);;

let distance_aircraft = fun (aircraft1:Problem.aircraft) (aircraft2:Problem.aircraft)->
  sqrt ((aircraft1.x-.aircraft2.x)**2.+.(aircraft1.y-.aircraft2.y)**2.)

  
let distance_node=fun param node1 node2->
  let rec dist =fun aircraft1 aircraft2 d i->
    if i=(Array.length node1.Problem.aircrafts_coord)-1
    then d+.(distance_aircraft aircraft1 aircraft2)
    else 
    dist node1.Problem.aircrafts_coord.(i+1) node2.Problem.aircrafts_coord.(i+1) (d+.(distance_aircraft aircraft1 aircraft2)) (i+1) in
  (*(dist node1.aircrafts_coord.(0) node2.aircrafts_coord.(0) 0. 0)+.(sqrt (param.v*.(node1.time-.node2.time)**2.));;*)
  (dist node1.Problem.aircrafts_coord.(0) node2.Problem.aircrafts_coord.(0) 0. 0);;

let compare_dist = fun param node_ref node1 node2 f_distance->
    Float.compare (f_distance param node_ref node1) (f_distance param node_ref node2);;

let nearest_neighbours = fun param node_target array_nodes f_distance ->
  Array.fold_left (fun min_node node->if ((compare_dist param node_target min_node node f_distance)>0) then node else min_node) array_nodes.(0) array_nodes;;

let set_parent = fun node_parent new_node array_nodes->
  new_node.Problem.pred<-node_parent.Problem.id;
  array_nodes:=Array.append !array_nodes [|new_node|];;

let rec traceback = fun assoc_nodes node liste_node->
  if node.Problem.pred=0 then (liste_node@[node]) else traceback assoc_nodes (List.assoc node.pred assoc_nodes) (liste_node@[node]);;

let random_aircraft = fun param->
  let random_coord=fun a_min a_max->
    Random.self_init ();
    let l=a_max-.a_min in
    a_min+.Random.float l in
  {Problem.id_aircraft=0;x=random_coord param.Problem.x_min param.Problem.x_max;y=random_coord param.Problem.y_min param.Problem.y_max}

let random_node =fun param id ->
  {Problem.id=id;aircrafts_coord=Array.init param.Problem.nb_aircrafts (fun i->random_aircraft param);time=param.Problem.time_min+.(Random.float (param.Problem.time_max-.param.Problem.time_min));pred=0};;

let test_obstacle = fun obstacle aircraft->
  if (distance_aircraft aircraft {Problem.id_aircraft=0;x=obstacle.x;y=obstacle.y})<=obstacle.radius then false else true;;

let collision_free = fun node ->
  let circle={x=3.;y=5.;radius=2.}in
  Array.for_all (fun aircraft->test_obstacle circle aircraft) node.Problem.aircrafts_coord;;

let test_domain = fun param (aircraft:Problem.aircraft)->
    param.Problem.x_max >= aircraft.x
        &&  param.Problem.x_min<= aircraft.x
        && param.Problem.y_max >= aircraft.y
        && param.Problem.y_min<= aircraft.y;;

let in_domain = fun (param:Problem.param)  node ->
    Array.fold_left (fun bool aircraft->if bool then test_domain param aircraft else bool) true node.Problem.aircrafts_coord;;


let test_avion = fun aircraft1 aircraft2 dist->
  (distance_aircraft aircraft1 aircraft2)>dist;;


let rec test_dist_secu= fun param node i aircraft->
  if test_avion aircraft node.Problem.aircrafts_coord.(i) param.Problem.dist_min
  then (if i=(param.Problem.nb_aircrafts-1) then true else test_dist_secu param node (i+1) aircraft)
  else false;;

let collision_free_bis= fun (param:Problem.param) node->
  let rec sous_collision=fun i->
    if test_dist_secu param node (i+1) node.Problem.aircrafts_coord.(i)
    then (if i=(param.nb_aircrafts-2) then true else sous_collision (i+1))
    else false in
  sous_collision 0 ;;

let extend= fun param nearest_node node_target ->
    let steer=fun node_start node_goal coord i->
        match coord with
        'x'->
       let diff=(node_goal.Problem.aircrafts_coord.(i).x)-.(node_start.Problem.aircrafts_coord.(i).x) in
       if diff>0. then ((node_start.Problem.aircrafts_coord.(i).x)+.(min param.Problem.pas diff)) else ((node_start.Problem.aircrafts_coord.(i).x)+.(max (-.param.Problem.pas) diff))
       |'y'->let diff=(node_goal.Problem.aircrafts_coord.(i).y)-.(node_start.Problem.aircrafts_coord.(i).y) in
              if diff>0. then ((node_start.Problem.aircrafts_coord.(i).y)+.(min param.Problem.pas diff)) else ((node_start.Problem.aircrafts_coord.(i).y)+.(max (-.param.Problem.pas) diff)) in
    let new_node={Problem.id=node_target.Problem.id;
                aircrafts_coord=Array.init param.Problem.nb_aircrafts (fun i->{Problem.id_aircraft=i;x=steer nearest_node node_target 'x' i;y=steer nearest_node node_target 'y' i});
                time=node_target.Problem.time;
                pred=0} in
    if (collision_free_bis param new_node)
    then (if (in_domain param new_node) then new_node else  (new_node.Problem.aircrafts_coord<-[||];new_node))
    else (new_node.Problem.aircrafts_coord<-[||];new_node);;

let rrt = fun param f_dist f_random_node f_nearest_neighbours f_extend f_set_parent f_traceback->
  let rec sous_rrt = fun param current_node array_nodes->

    if (f_dist param current_node param.Problem.goal)<param.Problem.dist_min
    then (param.Problem.goal.pred<-current_node.Problem.id; !array_nodes)
    else (
      let node_target=(f_random_node param (current_node.Problem.id+1)) in
      let node_nearest_neighbours=(f_nearest_neighbours param (node_target:Problem.node) !array_nodes f_dist) in
         let new_node=(f_extend param node_nearest_neighbours node_target) in
         if new_node.Problem.aircrafts_coord!=[||]
         then (f_set_parent node_nearest_neighbours new_node array_nodes;
          (* Ihm.do_at_iter array_nodes param; *)
          sous_rrt param new_node array_nodes)
         else (sous_rrt param current_node array_nodes)) in
  let nodes=ref [|param.Problem.start|] in
  nodes:=(sous_rrt param param.Problem.start nodes);
  let path=f_traceback (Array.to_list (Array.combine (Array.map (fun node->node.Problem.id) !nodes) !nodes)) param.Problem.goal [] in
  Ihm.do_at_end path !nodes param;
  path;;

let print_node = fun node->
  Printf.printf "%d: [" node.Problem.id;
  for i=0 to ((Array.length node.Problem.aircrafts_coord)-1) do
    Printf.printf " avion %d: x=%f y=%f |" i node.Problem.aircrafts_coord.(i).x node.Problem.aircrafts_coord.(i).y
  done;
  Printf.printf "time: %f ]\n" node.Problem.time;;

(*let array_obstacle_node = fun param node->
    Array.map (fun aircraft -> {x=aircraft.x;y=aircraft.y;radius=param.dist_min}) node.aircrafts_coord;;*)

(*let collision_free_bis= fun (param:param) (node_nearest:node) node->
    let obstacles =array_obstacle_node param node_nearest in
    Array.for_all (fun aircraft-> Array.for_all (fun obstacle -> if obstacle.x=aircraft.x)) ;;*)









