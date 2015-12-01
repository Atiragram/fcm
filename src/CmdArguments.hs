module CmdArguments where

import Options.Applicative

data DistanceMethod = Hamming | Evklid deriving(Read, Eq)
data InitMethod = Matrix | Centers deriving(Read, Eq)
data Arguments = Arguments { inputFile :: String,
                             outputFile :: String,
                             delimiter :: Char,
                             hasHeader :: Bool,
                             useFirstColumn :: Bool,
                             useLastColumn :: Bool,
                             c :: Int,
                             eps :: Double,
                             metric :: DistanceMethod,
                             initType :: InitMethod }

parseCArguments :: Parser Arguments
parseCArguments = Arguments
    <$> argument str (metavar "FILE" <> help "Input file")
    <*> option str (long "output" <> short 'o' <> metavar "FILE" <> help "Output file" <> value "")
    <*> option auto (long "delimiter" <> short 'd' <> metavar "CHAR" <> help "Сsv file delimiter, ',' by default" <> value ',')
    <*> option auto (long "hasHeader" <> metavar "BOOL" <> help "False - ignore csv file header, false by default" <> value False)
    <*> option auto (long "useFirstColumn" <> short 'f' <> metavar "BOOL" <> help "False - ignore csv file first column, false by default" <> value False)
    <*> option auto (long "useLastColumn" <> short 'l' <> metavar "BOOL" <> help "False - ignore csv file last column, true by default" <> value True)
    <*> option auto (long "c" <> short 'c' <> metavar "INT" <> help "Number of clusters, 3 by default" <> value 3)
    <*> option auto (long "eps" <> short 'e' <> metavar "DOUBLE" <> help "Computation precision, 0.001 by default" <> value 0.001)
    <*> option auto (long "metric" <> short 'm' <> metavar "NAME" <> help "Choose distance metric from \"Hamming\" or \"Evklid\", \"Hamming\" by default" <> value Evklid)
    <*> option auto (long "initType" <> short 'i' <> metavar "NAME" <> help "How to start algoritm from random \"Matrix\" or \"Centers\", \"Matrix\" by default" <> value Matrix)
