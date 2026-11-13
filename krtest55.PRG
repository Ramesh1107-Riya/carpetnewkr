Select k.compname;
From cabuyer i;
Join cabuyord j;
On i.bcode=j.bcode;
Join packhead k;
On i.compcode=k.compcode