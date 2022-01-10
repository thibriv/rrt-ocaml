open Problem

let main = fun () ->
    let pb = Problem.init () in
    Ihm.init_graph pb;
    Rrt.rrt pb Rrt.distance_node_aircraft Rrt.sample_free Rrt.nearest Rrt.steer Rrt.tracebacks;;
    (*let fin=Rrt.rrt pb Rrt.distance_node_aircraft Rrt.sample_free Rrt.nearest Rrt.steer Rrt.tracebacks in
    Printf.printf "%d\n" (List.length fin);
    List.iter Rrt.print_node fin;;*)

main ()
