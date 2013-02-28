import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Route_Nodes.txt" ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let routes = lines contents
      error_routes = [1,2]
      nroutes = map (\x -> words x) routes
      int_nroutes = map f nroutes
      some_routes = to_fileformat $ to_nodefile $ zip [0..] $ clean_routes (zip [0..] $ join_routes $ int_nroutes) error_routes
  hPutStr tempHandle $ unlines some_routes
  print some_routes
  hClose handle
  hClose tempHandle

f :: [String] -> [Int]
f = map read

join_routes :: [[Int]] -> [[Int]]
join_routes [[]] = [[]]
join_routes xs = map (\y -> foldr (\x acc -> if (head x) == y then (x !! 1) : acc else acc) [] xs) route_list
                 where route_list = nub $ map head xs
                       
-- This function removes last node of some route in Route header file. (Reduces warning from microsimulator.)
clean_routes :: [(Int,[Int])] -> [Int] -> [[Int]]
clean_routes [] _ = []
clean_routes xs error_routes = map (\x -> if ((fst x) `elem` error_routes) then reverse . tail . reverse $ (snd x) else (snd x)) xs

-- Convert route nodes to route node file format. Eg: i/p: [(0,[1,2,3])] o/p: [[0,1,10],[0,2,10],[0,3,10]]
to_nodefile :: [(Int,[Int])] -> [[Int]]
to_nodefile [] = []
to_nodefile xs = case xs of x:xs' ->  map (\y -> [ fst x , y , 10 ])  (snd x)  ++ to_nodefile xs'
                            
-- I/P [[0,1,10],[0,2,10]] o/p: ["0\t1\t10\n","0\t2\t10\n"]
to_fileformat :: [[Int]] -> [String]
to_fileformat x = case x of [] -> []
                            y -> map (\x -> foldl1 (\acc y -> acc ++  "\t" ++ y) x) str_y
                            where str_y = map (map show) x
