module Tests where

import Test.HUnit
import Calculations
import Data.Vector as V

main :: IO()
main = do
  let test1 = TestCase (assertEqual "(hammingDistance [0.0,0.0,0.0] [0.0,0.0,0.0])" 0.0 (hammingDistance (V.fromList [0.0,0.0,0.0]) (V.fromList [0.0,0.0,0.0])))
      test2 = TestCase (assertEqual "(hammingDistance [5.0,5.0] [10.0,10.0])" 10.0 (hammingDistance (V.fromList [5.0,10.0]) (V.fromList [5.0,10.0])))
      test3 = TestCase (assertEqual "(evklidDistance [0.0,0.0,0.0] [0.0,0.0,0.0])" 0.0 (evklidDistance (V.fromList [0.0,0.0,0.0]) (V.fromList [0.0,0.0,0.0])))
      test4 = TestCase (assertEqual "(evklidDistance [0.0,0.0] [3.0,0.0])" 3.0 (evklidDistance (V.fromList [2.0,2.0,2.0,2.0]) (V.fromList [4.0,4.0,4.0,4.0])))
      test5 = TestCase (assertEqual "(normMatrix [[0.0,0.0,0.0],[0.0,0.0,0.0]] [[0.0,0.0,0.0],[0.0,0.0,0.0]])" 0.0 (normMatrix (V.fromList $ Prelude.map V.fromList [[0.0,0.0,0.0],[0.0,0.0,0.0]]) (V.fromList $ Prelude.map V.fromList [[0.0,0.0,0.0],[0.0,0.0,0.0]])))
      test6 = TestCase (assertEqual "(normMatrix [[2.0,3.0],[11.0,10.0]] [[6.0,7.0],[21.0,11.0]])" 10.0 (normMatrix (V.fromList $ Prelude.map V.fromList [[1.0,2.0],[3.0,4.0]]) (V.fromList $ Prelude.map V.fromList [[5.0,6.0],[7.0,8.0]])))
      testList = TestList [test1, test2, test3, test4, test5, test6]
  counts <- runTestTT testList
  return ()
