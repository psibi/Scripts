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

(*Read files*)
fun read_routes filename =
    let
        val ins = TextIO.openIn filename
        fun aux(copt: char option) =
            case copt of
                NONE => []
              | SOME line => line :: aux(TextIO.input1 ins)
    in
        aux(TextIO.input1 ins)
    end
