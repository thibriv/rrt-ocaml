open Problem

let main = fun () ->
    let pb = Problem.init () in
    Ihm.init_graph pb;
    let fin=Rrt.rrt pb Rrt.distance_node Rrt.random_node Rrt.nearest_neighbours Rrt.extend Rrt.set_parent Rrt.traceback in
    Printf.printf "%d\n" (List.length fin);
    List.iter Rrt.print_node fin;;

main ()