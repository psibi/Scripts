import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Route_Nodes.txt" ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let routes = lines contents
      error_routes = [2,3]
      nroutes = map (\x -> words x) routes
      int_nroutes = map f nroutes
      --new_routes = filter (\x -> not ((head x) `elem` error_routes)) int_nroutes
      some_routes = clean_routes . join_routes $ int_nroutes
      --hPutStr tempHandle $ unlines tabbed      
  print some_routes
  hClose handle
  hClose tempHandle

f :: [String] -> [Int]
f = map read

join_routes :: [[Int]] -> [[Int]]
join_routes [[]] = [[]]
join_routes xs = map (\y -> foldr (\x acc -> if (head x) == y then (x !! 1) : acc else acc) [] xs) route_list
                 where route_list = nub $ map head xs
                       
-- This function removes last node of each route in Route header file. (Reduces warning from microsimulator.)
clean_routes :: [[Int]] -> [[Int]]
clean_routes [[]] = [[]]
clean_routes xs = map (\x -> reverse . tail . reverse $ x) xs