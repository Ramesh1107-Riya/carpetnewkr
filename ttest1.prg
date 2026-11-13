SELECT b.BCODE, b.PO_NO, b.CTRL_NO, b.OL_NO, b.QUALITY, b.DESIGN, b.SZCODE, b.COLOUR, b.FIELDCODE, b.BREADTH, b.LENGTH,;
 		b.WASHTYPE, b.SPCL_INST, b.CSTATUS, b.ORDER_TYPE, b.CTYPE, b.NOTES, b.SQMT, b.PO_DT, b.DELIRY_DT, b.QTY, s.COMMENT,b.SKUNO,;
 		s.CARPETNO, s.SUPPLIER, s.CUTDATE, s.ISSDT, s.WEV_LAST_DT, s.WEV_CM, s.WEV_CMDT, s.BTHWEAV, s.LTHWEAV, s.FDATE, s.GRADE, s.COMMENTWAS, s.ISSDTWASH,;
 		s.RCDDTWASH, s.WSHSUPPLIER, s.WASHISLIP, s.WASHRSLIP,p.Invno,p.baleno,e.Invdt,e.Ship_Inst;
 	FROM  Cabuyord b;
	LEFT OUTER JOIN Casupord s;
		ON b.OL_NO=s.OL_NO;
	LEFT OUTER JOIN Packtran p;
		ON b.OL_NO=p.OL_NO;
	LEFT OUTER JOIN Expackingnp e; 
		ON p.Invno=e.Invno;
	WHERE b.cstatus<>"Exported";
	Into Cursor temp
	
	Select temp
	Brow
	*p.Invno,p.baleno,e.Invdt,e.Ship_Inst,;
	
	
	*LEFT OUTER JOIN Packtran p;
	*	ON b.OL_NO=p.OL_NO;
	*LEFT OUTER JOIN Expackingnp e; 
	*	ON p.Invno=e.Invno;