***************************
*SELECT n.Quality,n.OL_NO,n.po_no,n.Design;
*FROM Cabuyord n;
*WHERE .NOT. EXISTS (SELECT * FROM Cabuyord9 b;
*					WHERE b.Quality=n.Quality .and. b.ol_no=n.ol_no)
					
*select * from cabuyord
*select * from cabuyord9

					
*Select * ;
*From Cabuyord b;
*Left Join Cabuyord9 n;
*on b.ol_no=n.ol_no .and. b.quality=n.quality

*Select b.ol_no,b.quality,n.ol_no,n.quality;
*From Cabuyord9 n,Cabuyord b;
*Where n.ol_no=b.ol_no 
*.and. (b.quality="80 KNOTS1" .OR. b.quality="80 KNOTS2" .OR. b.quality="80 KNOTS3" .OR. b.quality="80 KNOTS4")


Select b.ol_no,b.quality,n.ol_no,n.quality;
From Cabuyord9 n,Cabuyord b;
Where n.ol_no=b.ol_no .and. b.quality<>n.quality