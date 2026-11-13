USE CADESIGN
repl all dgndesc with upper(dgndesc)
CLOSE ALL

USE CAQLTY
*Field added -> qltyinv c(15), qltyknot c(10)
repl all qltyinv with code && manual edit
repl all qltyknot with '60 KNOT' FOR code='LAMA'
repl all qltyknot with '60 KNOT' FOR code='KOTANA'
repl all qltyknot with '60 KNOT' FOR code='SETANA'
repl all qltyknot with '80 KNOT' FOR CODE='TIMPA'
repl all qltyknot with '100 KNOT' FOR CODE='SHAKTI'
CLOSE ALL