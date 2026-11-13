Select i.Bcode,alltrim(b.Pname) as Name,i.PO_NO,i.OL_NO,i.QUALITY,i.DESIGN,i.COLOUR,i.SZCODE,i.sqmt,i.po_dt;
From Cabuyord i, Expackingnp b;
Where i.Bcode=alltrim(b.Bcode)