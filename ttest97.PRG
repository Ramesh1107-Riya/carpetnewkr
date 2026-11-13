Select d.bcode,d.Code,d.Dgndesc,d.quality,d.Fldtype,f.grate_a,f.grate_b,f.grate_c,f.wages;
From Cadesign d;
Join Cafield f;
ON d.Quality=f.Quality .and. d.fldtype=f.fldtype;
Order by d.bcode,f.grate_a