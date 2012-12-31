import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Route_Header.txt" ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let routes = lines contents
      error_routes = [44,51,74,120,143,154,160,166,171,172,179,196,197,199,208,209,259,261,263,281,292,295,296,330,339,340,341,345,346,353,372,375,396,402,404,422,428,451,461,464,471,480,481,483,484,485,492,493,499,503,532,533,540,572,573,574,577,583,601,631,639,671,688,695,700,701,704,707,726,728,740,747,769,778,789,806,807,846,847,851,872,906,926,941]
      new_routes = deleteByIndex error_routes routes
  hPutStr tempHandle $ unlines new_routes
  hClose handle
  hClose tempHandle

deleteByIndex :: (Enum a, Eq a, Num a) => [a] -> [b] -> [b]
deleteByIndex r = map snd . filter (\(i, _) -> notElem i r) . zip [0..]

