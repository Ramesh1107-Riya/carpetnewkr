Set DEfa to c:\carpetnewkr
close all
*USE YRNRECVD
*BROW
*SELECT DISTIN QUALITY,colour from yrnrecvd where suplier="P.S.TRADE CONCER"
SELECT DISTIN QUALITY,colour from yrnrecvd where suplier="P.S.TRADE CONCER" .or. suplier="BHIMSEN" into cursor kr
