import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Route_Nodes.txt" ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let routes = lines contents
      error_routes = [1677,345]
      nroutes = map (\x -> words x) routes
      int_nroutes = map (map read) nroutes
      new_routes = filter (\x -> not ((head x) `elem` error_routes)) int_nroutes
  print new_routes
  hClose handle
  hClose tempHandle

f :: [[String]] -> [[Int]]
f = map (map read)


