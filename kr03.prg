** This Program will generate casupord7,cabuyord7 not in 
*!*	SELECT b.ol_no,b.Cstatus,b.Design,b.PO_Dt,b.Delclose ;
*!*	FROM cabuyord4 b;
*!*	WHERE .NOT. EXISTS (SELECT s.ol_no FROM Cabuyord s;
*!*						WHERE s.ol_no=b.Ol_no );
*!*	Into table updateneed

*!*	Select *;
*!*	FROM cabuyord4;  
*!*	WHERE ol_no IN (SELECT ol_no FROM  updateneed);
*!*	Into table cabuyord7

*!*	Select * ;
*!*	From cabuyord7 && required file for updation

*!*	******************************************************************
*!*	Select *;
*!*	FROM casupord4;  
*!*	WHERE ol_no IN (SELECT ol_no FROM  updateneed);
*!*	Into table casupord7

*!*	Select * ;
*!*	From casupord7
*!*	*****************************************************************

*!*	Select *;
*!*	FROM cabuyord;  
*!*	WHERE ol_no IN (SELECT ol_no FROM  cabuyord7)  && empty 

*!*	Select *;
*!*	FROM casupord;  
*!*	WHERE ol_no IN (SELECT ol_no FROM  casupord7)
*******

*!*	close all
*!*	use cabuyord exclus
*!*	appen from cabuyord7


select b.ol_no,c.supplier ;
From Cabuyord7 b;
Join Casupord c;
on b.ol_no=c.ol_no

