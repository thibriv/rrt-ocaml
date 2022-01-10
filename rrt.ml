open Problem

let print_array_nodes = fun nodes ->
    let rec sub_print = fun i ->
        if i=Array.length nodes
        then Printf.printf "]\n"
        else (Printf.printf "%d; " nodes.(i).Problem.pred;
        sub_print (i+1)) in
    Printf.printf "[";
    sub_print 0

let print_paths = fun paths ->
    let rec print_list = fun path ->
        match path with
            head::tail -> (Printf.printf "%d; " head.Problem.id;print_list tail)
            |_->(Printf.printf "]\n") in
    let rec sub_paths = fun i ->
        if i=Array.length paths
        then ()
        else (Printf.printf "["; print_list paths.(i); sub_paths (i+1)) in
    sub_paths 0

let distance_aircraft = fun aircraft1 aircraft2->
  sqrt ((aircraft1.Problem.x-.aircraft2.Problem.x)**2.+.(aircraft1.Problem.y-.aircraft2.Problem.y)**2.)

let distance_node_aircraft = fun node1 node2 ->
  distance_aircraft node1.Problem.aircraft node2.Problem.aircraft;;


 let compare_dist = fun (node_ref: Problem.node_aircraft) (node1: Problem.node_aircraft) (node2: Problem.node_aircraft) f_distance->
   Float.compare (f_distance node_ref node1) (f_distance node_ref node2);;

  let random_aircraft = fun param i->
   let random_coord=fun a_min a_max->
     Random.self_init ();
     let l=a_max-.a_min in
     a_min+.Random.float l in
   {Problem.id_aircraft=i;x=random_coord param.Problem.x_min param.Problem.x_max;y=random_coord param.Problem.y_min param.Problem.y_max}


  let test_avion = fun (aircraft1:Problem.aircraft) (aircraft2:Problem.aircraft) dist->
    (distance_aircraft aircraft1 aircraft2)>dist;;

  let rec test_dist_secu= fun param node i aircraft->
    if test_avion aircraft node.(i).Problem.aircraft param.Problem.dist_min
    then (if i=(param.Problem.nb_aircrafts-1) then true else test_dist_secu param node (i+1) aircraft)
    else false;;

  let collision_free= fun param node_array->
    let rec sous_collision=fun i->
     if test_dist_secu param node_array (i+1) node_array.(i).Problem.aircraft
     then (if i=(param.Problem.nb_aircrafts-2) then true else sous_collision (i+1))
     else (if (Float.abs (node_array.(i).time-.node_array.(i+1).time))>(param.Problem.dist_min/.param.Problem.v)
           then (if i=(param.Problem.nb_aircrafts-2) then true else sous_collision (i+1))
           else false)   in
   sous_collision 0 ;;


  let sample_free = fun param id_last->
    Array.init param.Problem.nb_aircrafts (fun i->{Problem.id=id_last+i;aircraft=random_aircraft param i;pred=0;time=0.})

  let nearest = fun param nodes random bool f_distance->
    let rec sub_nearest= fun (nearest:Problem.node_aircraft array) i->
      if i=param.Problem.nb_aircrafts then nearest else(
        if bool.(i)
        then
          (let node_near= (Array.fold_left (fun min_node node->if node.Problem.aircraft.id_aircraft=i
                                                               then (if ((compare_dist random.(i) min_node node f_distance)>0)
                                                                     then node
                                                                     else min_node)
                                                               else min_node)
                             (nodes.(i)) nodes) in
           sub_nearest (Array.append nearest [|node_near|]) (i+1))
        else
          sub_nearest (Array.append nearest [|random.(i)|]) (i+1)) in
    sub_nearest [||] 0;;



  let calcul_x = fun param node_start node_goal->
     let diff=(node_goal.Problem.aircraft.x)-.(node_start.Problem.aircraft.x) in
     if diff>0. then ((node_start.Problem.aircraft.x)+.(min param.Problem.pas diff)) else ((node_start.Problem.aircraft.x)+.(max (-.param.Problem.pas) diff));;

 let calcul_y = fun param node_start node_goal->
     let diff=(node_goal.Problem.aircraft.y)-.(node_start.Problem.aircraft.y) in
     if diff>0. then ((node_start.Problem.aircraft.y)+.(min param.Problem.pas diff)) else ((node_start.Problem.aircraft.y)+.(max (-.param.Problem.pas) diff));;

 let travel_time= fun param x_dest y_dest node_start->
   (sqrt ((x_dest-.node_start.Problem.aircraft.x)**2.+.(y_dest-.node_start.Problem.aircraft.y)**2.))/.param.Problem.v

  let steer = fun param array_nearest array_random id_first bool->
    let rec sub_steer = fun new_node i->
      if i=param.Problem.nb_aircrafts
      then new_node
      else ( if bool.(i)
             then sub_steer (Array.append new_node [|{Problem.id=id_first+i;aircraft={Problem.id_aircraft=i;x=calcul_x param array_nearest.(i) array_random.(i);y=calcul_y param array_nearest.(i) array_random.(i)};pred=array_nearest.(i).id;time=array_nearest.(i).time+.(travel_time param (calcul_x param array_nearest.(i) array_random.(i)) (calcul_y param array_nearest.(i) array_random.(i)) array_nearest.(i)) }|]) (i+1)
             else sub_steer (Array.append new_node [|array_random.(i)|]) (i+1)) in
    sub_steer [||] 0;;

  let add_and_test = fun param bool (new_node:Problem.node_aircraft array) nodes f_dist->
    let rec sub_add_and_test= fun i bool->
    if i=param.Problem.nb_aircrafts
    then bool
    else (if bool.(i)
          then (nodes:=Array.append !nodes [|new_node.(i)|];
                            (if (f_dist new_node.(i) param.Problem.goal.(i))<param.Problem.dist_min
                             then(param.Problem.goal.(i).pred<-new_node.(i).Problem.id ;bool.(i)<-false);
                            param.Problem.goal.(i).time<-new_node.(i).time+.(travel_time param param.Problem.goal.(i).aircraft.x param.Problem.goal.(i).aircraft.y new_node.(i)) );
                            sub_add_and_test (i+1) bool)
          else sub_add_and_test (i+1) bool) in
    sub_add_and_test 0 bool;;

let rec traceback = fun assoc_nodes node liste_node->
  if node.Problem.pred=0 then (liste_node@[node]) else(
  traceback assoc_nodes (List.assoc node.pred assoc_nodes) (liste_node@[node])
  );;



let rec tracebacks = fun param assoc_nodes nodes i array_paths ->
    if i=param.Problem.nb_aircrafts
    then array_paths
    else (let path = traceback assoc_nodes nodes.(i) [] in
          let array_paths = Array.append [|path|] array_paths in
          print_paths array_paths;
          Printf.printf "%d\n" i;
    tracebacks param assoc_nodes nodes (i+1) array_paths
    )

 let rrt = fun param f_dist f_random_node f_nearest_neighbours f_extend f_traceback->
   let rec sous_rrt = fun param (current_node:Problem.node_aircraft array) array_nodes bool->
     if (not (Array.exists (fun x->x) bool))
     then !array_nodes
     else (
       let node_target=f_random_node param ((Array.length !array_nodes)+1) in
       let node_nearest_neighbours=(f_nearest_neighbours param !array_nodes node_target bool f_dist ) in
          let new_node=(f_extend param node_nearest_neighbours (node_target:Problem.node_aircraft array) ((Array.length !array_nodes)+1) bool) in
          if collision_free param new_node
          then let bool=add_and_test param bool new_node array_nodes f_dist in
               (*Ihm.do_at_iter array_nodes param;*)
           sous_rrt param new_node array_nodes bool
          else (sous_rrt param current_node array_nodes bool)) in
   let nodes=ref param.Problem.start in
   nodes:=(sous_rrt param param.Problem.start nodes (Array.init param.Problem.nb_aircrafts (fun i -> true)));
   Printf.printf "array_goal_pred\n";
   print_array_nodes param.Problem.goal;
      let paths=f_traceback param (Array.to_list (Array.combine (Array.map (fun node->node.Problem.id) !nodes) !nodes)) param.Problem.goal 0 [||] in
      print_paths paths;
      Ihm.do_at_end paths !nodes param;
      paths;;
