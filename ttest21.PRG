SELECT INVNO,q.QltyKnot,SQMT Actualsqmt,sqmtord as StdSqmt;
		FROM Packtran p;
		Inner Join Caqlty q;
		On p.quality=q.code;
		Where invno='TFK-23/19' .AND. q.QltyKnot='80 KNOT'
		
		
	*	SELECT INVNO,q.QltyKnot,sum(SQMT) Actualsqmt,sum(sqmtord) as StdSqmt,count(carpetno) as pcs;
	*	FROM Packtran p;
	*	Inner Join Caqlty q;
	*	On p.quality=q.code;
	*	Where invno='TFK-23/19' 
	*	Group by q.QltyKnot;
	*	Order by q.QltyKnot; 
	*	Into Cursor temp1