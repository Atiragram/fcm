Параметры

Usage: fcm FILE [-o|--output FILE] [-d|--delimiter CHAR] [--hasHeader BOOL]
           [-f|--useFirstColumn BOOL] [-l|--useLastColumn BOOL] [-c|--c INT]
           [-e|--eps DOUBLE] [-m|--metric NAME] [-i|--initType NAME]

Available options:
  -h,--help                Show this help text
  FILE                     Input file
  -o,--output FILE         Output file
  -d,--delimiter CHAR      Сsv file delimiter, ',' by default
  --hasHeader BOOL         False - ignore csv file header, false by default
  -f,--useFirstColumn BOOL False - ignore csv file first column, false by
                           default
  -l,--useLastColumn BOOL  False - ignore csv file last column, true by default
  -c,--c INT               Number of clusters, 3 by default
  -e,--eps DOUBLE          Computation precision, 0.001 by default
  -m,--metric NAME         Choose distance metric from "Hamming" or "Evklid",
                           "Hamming" by default
  -i,--initType NAME       How to start algoritm from random "Matrix" or
                           "Centers", "Matrix" by default

Запуск с помощью sandbox

cabal sandbox init
cabal install --only-dependencies
cabal build
