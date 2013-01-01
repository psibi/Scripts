import System.IO
import System.Directory
import Data.List --for isPrefixOf

main = do
  handle <- openFile "Route_Nodes.txt" ReadMode
  (tempName, tempHandle) <- openTempFile "." "temp"
  contents <- hGetContents handle
  let routes = lines contents
      error_routes = [44,44,51,74,120,140,143,154,160,166,171,172,179,196,197,199,208,209,259,261,263,281,292,295,296,330,339,340,341,345,346,353,372,375,396,402,404,422,428,451,461,464,471,480,481,483,484,485,492,493,499,503,532,533,540,572,573,573,574,577,583,601,631,639,671,688,695,700,701,704,707,726,728,740,747,769,778,789,806,807,846,847,851,872,906,926,941,943,952,961,975,1010,1019,1020,1021,1037,1039,1045,1046,1067,1067,1068,1087,1093,1117,1125,1134,1135,1137,1141,1143,1156,1171,1172,1172,1174,1176,1190,1196,1215,1258,1261,1275,1313,1315,1316,1317,1333,1346,1349,1351,1353,1356,1367,1378,1384,1396,1398,1404,1407,1411,1419,1450,1451,1471,1519,1523,1543,1578,1600,1601]
      nroutes = map (\x -> words x) routes
      int_nroutes = map (map read) nroutes
      new_routes = filter (\x -> not ((head x) `elem` error_routes)) int_nroutes
      string_routes = map (\x -> (map (\y -> show y) x)) new_routes
      tabbed = map (\x -> foldl (\acc y -> acc ++ y ++ "\t") [] x) string_routes
  hPutStr tempHandle $ unlines tabbed
  hClose handle
  hClose tempHandle




