SELECT p.BCODE, CARPETNO, p.PO_NO, p.Buyerno, Baleno, p.OL_NO, p.QUALITY, p.DESIGN, p.COLOUR,szcode, Shipbrth, Shiplngth, Subbuyer,p.SQMT,Invno,expdt;
FROM  Packtran p;
Join Cabuyord b;
On p.ol_no=b.ol_no;
WHERE p.BCODE='36' .and. invno='TFK-26/19' .OR. INVNO='TFK-27/19'
