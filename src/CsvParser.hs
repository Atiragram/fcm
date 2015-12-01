module CsvParser where

import Data.Csv
import Data.ByteString.Lazy
import Data.Vector as V
import Data.Char
import CmdArguments

dataFromString :: ByteString -> Arguments -> Either String (Vector (Vector Double))
dataFromString contents options =
    let decodeOptions = DecodeOptions { decDelimiter = fromIntegral (ord (delimiter options))}
        result = if hasHeader options
                  then decodeWith decodeOptions HasHeader contents
                  else decodeWith decodeOptions NoHeader contents
    in case result of Left err -> Left err
                      Right parsedData -> Right (V.map (V.map read) (deleteColumns parsedData options))

deleteColumns :: Vector(Vector String) -> Arguments -> Vector(Vector String)
deleteColumns parsedData options
  | useFirstColumn options && useLastColumn options = parsedData
  | useFirstColumn options = V.map V.init parsedData
  | useLastColumn options = V.map V.tail parsedData
  | otherwise = V.map V.init (V.map V.tail parsedData)
