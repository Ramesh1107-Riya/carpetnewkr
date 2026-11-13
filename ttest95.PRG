*Colour in Cacolour2 not in Cacolour
SELECT *;
FROM fieldcode4;
WHERE .NOT. EXISTS (SELECT * FROM cafield;
					WHERE cafield.fieldcode=fieldcode4.fieldcode);
into table cafield5


*select disti fieldcode from cabuyord where cstatus="NotDistri" .or. cstatus="Distri" .or. cstatus="On-loom"
*Select * from cafield i,fieldcode4 j where i.fieldcode=j.fieldcode