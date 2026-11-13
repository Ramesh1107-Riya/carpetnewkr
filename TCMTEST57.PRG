*counting no. of record in a query
clea
close all
select bcode from cabuyord where bcode='WS' into cursor cTemp

USE (DBF([cTemp])) ALIAS cTemp2 AGAIN IN 0 SHARED
USE IN SELECT([cTemp])

select count(bcode) as recnt from cTemp2 where bcode='WS' into cursor cTemp3
?cTemp3->recnt
select recnt from ctemp3
use in cTemp2
use in cTemp3
*INDEX ON OL_NO   TAG OL_NO
*SET ORDER TO OL_NO

