module Problem =
    struct
        type aircraft = {
            id_aircraft:int;
            x:float;
            y:float
          }

        type node_aircraft = {
            id:int;
            mutable aircraft: aircraft;
            mutable pred:int;
            mutable time:float
          }

        type param = {
            nb_aircrafts:int;
            goal:node_aircraft array;
            start:node_aircraft array;
            dist_min:float;
            x_min:float;
            y_min:float;
            x_max:float;
            y_max:float;
            v:float;
            mutable pas:float;
          }

        let init = fun () ->
            let node2 = [|{id=1000000000;aircraft={id_aircraft=0;x=0.;y=5.};pred=0;time=0.};{id=1000000001;aircraft={id_aircraft=1;x=5.;y=10.};pred=0;time=0.};{id=1000000004;aircraft={id_aircraft=2;x=0.;y=10.};pred=0;time=0.};{id=1000000006;aircraft={id_aircraft=3;x=9.;y=10.};pred=0;time=0.}|] in
            let node3 = [|{id=1000000002;aircraft={id_aircraft=0;x=10.;y=10.};pred=0;time=Float.infinity};{id=1000000003;aircraft={id_aircraft=1;x=0.;y=0.};pred=1;time=Float.infinity};{id=1000000005;aircraft={id_aircraft=2;x=10.;y=5.};pred=1;time=Float.infinity};{id=1000000007;aircraft={id_aircraft=3;x=5.;y=0.};pred=1;time=Float.infinity}|] in
            let pb ={nb_aircrafts=4;
            goal=node3;start=node2;
            dist_min=1.;
            x_min=0.;y_min=0.;x_max=10.;y_max=10.;
            v=1.;
            pas=0.3;} in
            pb

        let predecessor = fun nodes node ->
            let pred = Array.find_opt (fun n -> node.pred=n.id) nodes in
            match pred with
                None -> node
                |Some n -> n
    end
