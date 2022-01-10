module Problem =
    struct
        type aircraft = {
            id_aircraft:int;
            x:float;
            y:float
          }

        type node = {
            id:int;
            mutable aircrafts_coord : aircraft array;
            time:float;
            mutable pred:int
          }

        type param = {
            nb_aircrafts:int;
            goal:node;
            start:node;
            dist_min:float;
            v:float;
            mutable time_min:float;
            mutable time_max:float;
            x_min:float;
            y_min:float;
            x_max:float;
            y_max:float;
            mutable pas:float;
          }

        let init = fun () ->
            (*let node1 = {id=1;aircrafts_coord=[|{id_aircraft=0;x=1.;y=2.};{id_aircraft=1;x=5.;y=0.}|];time=0.;pred=0} in*)
            let node2 = {id=2;aircrafts_coord=[|{id_aircraft=0;x=1.;y=2.}; {id_aircraft=1;x=6.;y=4.}|];time=1.;pred=0} in
            let node3 = {id=1;aircrafts_coord=[|{id_aircraft=0;x=6.;y=7.}; {id_aircraft=1;x=0.;y=0.}|];time=2.;pred=0} in
            (*let node4 = {id=4;aircrafts_coord=[|{id_aircraft=0;x=6.;y=7.};{id_aircraft=1;x=1.;y=8.}|];time=2.;pred=0} in*)
            let pb ={nb_aircrafts=2;
            goal=node2;start=node3;
            dist_min=1.;v=1.;
            time_min=0.;time_max=10.;
            x_min=0.;y_min=0.;x_max=10.;y_max=10.;
            pas=0.3} in
            pb
    end