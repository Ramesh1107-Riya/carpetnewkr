tnVal=7.3167
tnPlaces=2
do RoundDown



Private lnFactor,lnRetval
Store 0.00 to lnFactor,lnRetval

FUNCTION RoundDown( tnVal, tnPlaces )
lnFactor = 100.00
lnRetVal = INT( tnVal * lnFactor )/ lnFactor
RETURN lnRetVal
