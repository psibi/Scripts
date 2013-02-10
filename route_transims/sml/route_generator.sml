(* path function finds a single unique path*)
fun path xs =
    let
        fun aux xs acc last first =
            case xs of
                [] => if List.length acc = 1 then [] else acc
              | (a,b)::xs' => if a = last 
                              then aux xs' (acc @ [(a,b)]) b a
                              else if b = first
                              then aux xs' ((a,b)::acc) last first
                              else aux xs' acc last first
    in
        case xs of
            [] => []
          | x::xs' => case (aux (x::xs') [x] (#2 x) (#1 x)) of
                          [] => path xs'
                        | y => y
    end

(*Removes duplicate list elements*)
fun remove_duplicates duplicates original_list = 
    let
        fun aux duplicates original_list acc =
            case (original_list,duplicates) of
                ([],_) => acc
              | (x,[]) => x
              | (a::xs',d) => if List.exists (fn x=> x=a) d then aux d xs' acc else aux d xs' (a::acc)
    in
        aux duplicates original_list []
    end

(*Creates list of path lists*)
fun create_path path_list =
    let
        fun aux path_list acc =
            case path_list of
                [] => acc
              | p => case (path p) of
                         [] => acc
                       | y => aux (remove_duplicates y p) (y::acc)
    in
        aux path_list []
    end

(*Convert string to int * int tuples*)
fun toPair s =
    let
      val s' = String.substring(s, 0, size s-2)
    in
      case List.mapPartial Int.fromString (String.tokens (fn c => c = #",") s') of
          a::b::[] => (a,b)
    end

fun flatten_path path_list =
    let 
        fun aux xs acc =
            case xs of
                [] => acc
              | (a,b)::[] => acc @ [b]
              | (a,b)::(_,d)::tail => if acc = [] then aux tail (acc @ [a,b,d]) else aux tail (acc @ [b,d])
    in
        aux path_list []
    end

(*Read files*)
fun read_routes filename =
    let
        val ins = TextIO.openIn filename
        fun aux(copt: string option) =
            case copt of
                NONE => (TextIO.closeIn ins; [])
              | SOME line => toPair(line) :: aux(TextIO.inputLine ins)
    in
        aux(TextIO.inputLine ins)
    end

fun create_route_nodes filename nodes =
    let
        val outs = TextIO.openOut filename
        val flattended_nodes = map (fn x=> flatten_path x) nodes
        
        fun aux snodes counter_value =
            case snodes of
                [] => TextIO.closeOut outs
              | x::xs' => 
                let
                    val line = foldl (fn (y,acc) => acc ^ Int.toString counter_value  ^ "\t" ^ Int.toString y ^ "\t10\n" ) "" x
                in
                    (TextIO.output(outs,line); aux xs' (counter_value+1))
                end
    in
        TextIO.output(outs,"ROUTE\tNODE\tDWELL\n");
        aux flattended_nodes 1
    end

fun tasks input output =
    let
        val generate_route = create_path (read_routes input)
        val create_output_file = create_route_nodes output generate_route 
    in
        create_output_file
    end

