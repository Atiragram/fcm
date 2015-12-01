module Calculations where

import System.Random
import Data.List.Split
import CmdArguments
import Data.Vector as V
import Data.List

randomMatrix::Int -> Int -> IO (Vector (Vector Double))
randomMatrix clustersCount objectsCount = do
  stdGen <- newStdGen
  let matrix = chunksOf clustersCount (Prelude.take (clustersCount * objectsCount) (randoms stdGen :: [Double]))
      normalizedMatrix = Prelude.map (\ row -> Prelude.map (\ element -> element / Prelude.sum row) row) matrix
  return (V.fromList (Prelude.map V.fromList normalizedMatrix))

randomCenters::Int -> Vector(Vector Double) -> IO (Vector (Vector Double))
randomCenters clustersCount objects = do
  stdGen <- newStdGen
  let randomNumbers = Prelude.take clustersCount (nub (randomRs (0, V.length objects - 1 ) stdGen :: [Int]))
  return (V.fromList( Prelude.map (\ rowNumber -> objects ! rowNumber) randomNumbers))

newCenters::Vector(Vector Double) -> Vector(Vector Double) -> Vector (Vector Double)
newCenters belongingMatrix objects =
  let belongingMxColSumPow l = V.sum (V.map (\ row -> (row ! l) ** 2) belongingMatrix)
      belongingMxAndObjectsPow l = V.foldr1 (V.zipWith (+)) (V.fromList (Prelude.map (\ i -> V.map (\ attribute -> attribute * (((belongingMatrix ! i) ! l) ** 2)) (objects ! i)) [0..V.length objects - 1]))
      division l = V.map (/ belongingMxColSumPow l) (belongingMxAndObjectsPow l)
  in V.fromList (Prelude.map division [0..V.length (V.head belongingMatrix) - 1])

newBelongingMatrix::Arguments -> Vector(Vector Double) -> Vector(Vector Double) -> Vector(Vector Double)
newBelongingMatrix options objects centers =
  let belongingMxElem i k = 1 / V.sum (V.fromList (Prelude.map (\ j -> (distance (metric options) (objects ! i) (centers ! k) / distance (metric options) (objects ! i) (centers ! j)) ** 2) [0..V.length centers-1]))
      belongingMxRow i = V.fromList (Prelude.map (belongingMxElem i) [0..V.length centers - 1])
  in V.fromList (Prelude.map belongingMxRow [0..V.length objects - 1])

normMatrix::Vector(Vector Double) -> Vector(Vector Double) -> Double
normMatrix matrix1 matrix2 = V.maximum (V.map abs (V.zipWith (-) (V.concat (V.toList matrix2)) (V.concat (V.toList matrix1))))

distance:: DistanceMethod -> Vector Double-> Vector Double-> Double
distance distanceMethod vector1 vector2 =
  case distanceMethod of
    Hamming -> hammingDistance vector1 vector2
    Evklid  ->  evklidDistance vector1 vector2

hammingDistance::Vector Double-> Vector Double-> Double
hammingDistance vector1 vector2 = V.sum (V.map abs (V.zipWith (-) vector1 vector2))

evklidDistance::Vector Double -> Vector Double -> Double
evklidDistance vector1 vector2 = sqrt (V.sum (V.map (** 2) (V.zipWith (-) vector1 vector2)))
