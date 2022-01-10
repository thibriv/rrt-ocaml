open Problem

type gui = {
    width:int;
    height:int
}

let width=1200
let height=700
let radius_pt=2
let margin=5.
let window={width=width;height=height}
let colors= ref [|Graphics.blue;Graphics.green|]
let obst_color=Graphics.red
let default_color=Graphics.black

let define_colors = fun nb mini maxi->
    let range = fun nb pas -> mini + (nb * pas) in
    let rec colors = fun nb acc (r,vr) (g,vg) (b,vb) ->
        let pas = truncate (((float maxi) -. (float mini)) /. (float nb)) in
        if nb=0 then acc
        else (
            let color = ref Graphics.black in
            if r && (not g) && b then (color:=Graphics.rgb vr (range nb pas) vb;)
            else if r && g && (not b) then (color:=Graphics.rgb vr vg (range nb pas);)
            else (if (not r) && g && b then (color:=Graphics.rgb (range nb pas) vg vb;));
            let acc = Array.append [|!color|] acc in
            colors (nb-1) acc (r,vr) (g,vg) (b,vb);) in
    let modulo = nb / 6 in
    let rest = nb mod 6 in
    let nb_colors = [|modulo;modulo;modulo;modulo;modulo;modulo|] in
    let rec add = fun rest tab i ->
        if rest = 0
        then tab
        else (
            tab.(i)<-tab.(i) + 1;
            let rest = rest - 1 in
            let i = (i+1) mod 6 in
            add rest tab i) in
    let nb_colors = add rest nb_colors 0 in
    let acc = colors nb_colors.(0) [||] (true, 255) (true, 0) (false,0) in
    let acc = colors nb_colors.(1) acc (true, 0) (true, 255) (false,0) in
    let acc = colors nb_colors.(2) acc (true, 255) (false, 0) (true,0) in
    let acc = colors nb_colors.(3) acc (true, 0) (false, 0) (true, 255) in
    let acc = colors nb_colors.(4) acc (false, 0) (true, 255) (true, 0) in
    colors nb_colors.(5) acc (false, 0) (true, 0) (true, 255)

let compare_node_id = fun node1 node2 ->
    let id1 = node1.Problem.id in
    let id2 = node2.Problem.id in
    Int.compare id1 id2

let scale = fun window pb aircraft ->
    let x = aircraft.Problem.x in
    let y = aircraft.Problem.y in
    let dx = pb.Problem.x_max-.pb.Problem.x_min in
    let dy = pb.Problem.y_max-.pb.Problem.y_min in
    let x_graph= truncate (((float window.width -.(2.*.margin)) *.(x-.pb.Problem.x_min)/.dx)+.margin)
    and y_graph= truncate (((float window.height -.(2.*.margin)) *.(y-.pb.Problem.y_min)/.dy)+.margin) in
    (x_graph,y_graph)

let display_pt = fun scale node r_pt r_obst last->
    let rec show = fun i ->
        if i >= (Array.length node.Problem.aircrafts_coord)
        then ()
        else
            let (x,y) = scale node.Problem.aircrafts_coord.(i) in
            Graphics.set_color !colors.(node.Problem.aircrafts_coord.(i).id_aircraft);
            Graphics.draw_circle x y r_pt;
            Graphics.fill_circle x y r_pt;
            Graphics.set_color default_color;
            if last then (Graphics.set_color obst_color;
                let (rx,ry) = scale {Problem.id_aircraft=0;x=r_obst;y=r_obst} in
                Graphics.draw_ellipse x y rx ry);
            Graphics.set_color default_color;
            show (i+1) in
    ignore (show 0)

let display_seg = fun scale node1 node2 ->
    let rec show = fun i acc ->
        if i >= (Array.length node1.Problem.aircrafts_coord)
        then acc
        else
            let (x1,y1) = scale node1.Problem.aircrafts_coord.(i) in
            let (x2,y2) = scale node2.Problem.aircrafts_coord.(i) in
            let acc = Array.append [|(x1,y1,x2,y2)|] acc in
            show (i+1) acc in
    let tab = show 0 [||] in
    Graphics.draw_segments tab

let predecessor = fun nodes node -> (* nodes doit être trié selon les id des noeuds *)
    if node.Problem.pred = 0
    then node
    else Array.get nodes (node.Problem.pred - 1)

let sleep = fun n ->
  let start = Unix.gettimeofday() in
  let rec delay t =
    try
      ignore (Unix.select [] [] [] t)
    with Unix.Unix_error(Unix.EINTR, _, _) ->
      let now = Unix.gettimeofday() in
      let remaining = start +. n -. now in
      if remaining > 0.0 then delay remaining in
  delay n

let display = fun scale nodes radius_pt radius_obst ->
    let rec scan = fun i ->
        if i = (Array.length nodes)
        then ()
        else (let node = nodes.(i) in
            let pred = predecessor nodes node in
            display_seg scale pred node;
            display_pt scale node radius_pt radius_obst (i = (Array.length nodes)-1);
            scan (i+1)) in
    Array.sort compare_node_id nodes;
    Graphics.clear_graph ();
    ignore (scan 0)

let display_traceback = fun path nodes scale ->
    let rec scan = fun path ->
        match path with
            node::rest -> (display_pt scale node (radius_pt + 1) 0. false;
                let pred = predecessor nodes node in
                display_seg scale pred node;
                scan rest)
            | [] -> () in
    Array.sort compare_node_id nodes;
    Graphics.clear_graph ();
    ignore (scan path)

let init_graph = fun pb ->
  Graphics.open_graph (Printf.sprintf " %dx%d" width height);
  Graphics.set_window_title "RRT Billion, Jouquey, Rivoalen";
  colors := define_colors pb.Problem.nb_aircrafts 0 200

let do_at_iter = fun nodes param ->
    display (fun aircraft -> scale window param aircraft) !nodes radius_pt param.dist_min
    (* sleep 0.5 *)

let do_at_end = fun path nodes param->
    let finish = ref false in
    while (not !finish) do
        Printf.printf "\nWhat do you want to see?\n \t g: The whole graph\n\t t: The traceback\n\t q: Quit the application\nChoice: ";
        let action = read_line () in
        match action with
            "g"|"G"-> display (fun aircraft -> scale window param aircraft) nodes radius_pt param.dist_min
            |"t"|"T"-> display_traceback path nodes (fun aircraft -> scale window param aircraft)
            |"q"|"Q"-> finish:=true
            |_ -> Printf.printf "\nAn error has been encountered, please try again.\n"
    done