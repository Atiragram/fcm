module Main where

import Calculations
import Data.Vector as V
import CsvParser
import Data.ByteString.Lazy as L
import Options.Applicative
import CmdArguments
import Control.Exception

main :: IO()
main = do
    let arguments = info (helper <*> parseCArguments) fullDesc
    cmdOptions <- execParser arguments
    readResult <- try (L.readFile (inputFile cmdOptions)):: IO(Either SomeException ByteString)
    case readResult of
         Left someException -> print someException
         Right contents -> do
           let result = dataFromString contents cmdOptions
           case result of Left err -> error err
                          Right matrix -> do
                            result2 <- fcmAlgoritm cmdOptions matrix
                            case result2 of Left err -> error err
                                            Right matrix2 ->
                                              if outputFile cmdOptions /= ""
                                                then do
                                                  writeResult <- try (Prelude.mapM_ (\ x -> Prelude.appendFile (outputFile cmdOptions) (show x Prelude.++ "\n")) (V.toList (V.map V.toList matrix2))) :: IO (Either SomeException ())
                                                  case writeResult of Left someException -> print someException
                                                                      Right nothing -> return nothing
                                                else Prelude.mapM_ print (V.toList (V.map V.toList matrix2))


fcmAlgoritm::Arguments -> Vector(Vector Double) -> IO (Either String (Vector (Vector Double)))
fcmAlgoritm fcmOptions objects =
  if c fcmOptions <= V.length objects
    then do
      belongingMx <- if initType fcmOptions == Matrix
                      then randomMatrix (c fcmOptions) (V.length objects)
                      else do
                        randCenters <- randomCenters (c fcmOptions) objects
                        return (newBelongingMatrix fcmOptions objects randCenters)
      let step prevBelongingMx = do
          let nextCenters = newCenters prevBelongingMx objects
              nextBelongingMx = newBelongingMatrix fcmOptions objects nextCenters
          if normMatrix prevBelongingMx nextBelongingMx <= eps fcmOptions
            then Right nextBelongingMx
            else step nextBelongingMx
      return (step belongingMx)
    else return (Left "Wrong clusters count")
