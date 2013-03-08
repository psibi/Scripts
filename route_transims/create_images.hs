import System.IO
import System.Directory

main = do
 -- (tempName, tempHandle) <- openTempFile "." "temp"
  let name = file_names 5 455
      str_name = map (map show) name
      corect_str_name = map correct_file str_name
--  hPutStr tempHandle $ unlines some_routes
  print corect_str_name
--  hClose tempHandle



-- I/0 2,4 -> [2,3,4]
file_names :: Int -> Int -> [[Int]]
file_names x y = map create_till_minute [x..y]

-- I/O 5 -> [5,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559]
create_till_minute :: Int -> [Int]
create_till_minute d = map (\x -> if x==0 then d else (d*100)+x) [0..59]

-- I/O  1000 -> 4
no_digits :: Int -> Int
no_digits x = no_digits' x 0
  where no_digits' :: Int -> Int -> Int
        no_digits' x acc = if x == 0 then acc else no_digits' (x `div` 10) (acc+1)
        
correct_file :: [String] -> [String]
correct_file x = correct_head (head x) (3) : correct_tail (tail x)
  where correct_head :: String -> Int -> String
        correct_head x y = if length x /= y then correct_head ("0" ++ x) y else x
        correct_tail :: [String] -> [String]
        correct_tail x = case x of [] -> []
                                   (x:xs') -> correct_head x 5 : correct_tail xs'