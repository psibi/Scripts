import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Error.txt" ReadMode
  contents <- hGetContents handle
  let routes = lines contents
      nroutes = map (\x -> words x) routes
      int_routes = map (!! 2) nroutes
      error_routes = f int_routes
  print error_routes
  hClose handle
  
f :: [String] -> [Int]
f = map read


