set delete off
set safe off
set talk off
close all
clear
WAIT WINDOW "Deleleting All Files...Wait .." TIMEOUT 2
open database carpet exclus
use cabuyer exclus
zap
use cabuyord exclus
zap
use category exclus
zap
use cacolour exclus
zap
use cadesign exclus
zap
use cagrade exclus
zap
use cafield exclus
zap
use caloomsz exclus
zap
use capo exclus
zap
use caqlty exclu
zap
use casize exclus
zap 
use casupord exclus
zap
use casupplr exclus
zap
use category exclus
zap
use caweaver exclus
zap
use cawevdel exclus
zap
use cawshtyp exclus
zap
use consump exclus
zap
use cstatus exclus
zap
use ctype exclus
zap
use destination exclus
zap
use expackingf exclus
zap
use fullhalf exclus
zap
use packtran exclus
zap
use wicolour exclus
zap
use wiissue exclus
zap
use wiqlty exclus
zap
use wirecv exclus
zap
use wistock exclus
zap
use wireturn exclus
zap
use wisupop exclu
zap
use witrnord exclu
zap
use woolissu excl
zap
use woolop exclus
zap
use woolorder exclus
zap
use woolqlty exclus
zap
use woolpu exclus
zap
use stkcarpet exclus
zap
use grmaster exclus
zap
use grregstr exclus
zap
use grsuptran exclus
zap
use yrcalc exclus
zap
use yrecp exclus
zap
use yrnissdy exclus
zap
use yrnop exclus
zap
use yrnorder exclus
zap
*use yrnqlty exclus
*zap
use yrnrecvd exclus
zap
use yrsupop exclus
zap
use ytype exclus
*zap
use washtran exclus
zap
*** invoice & packing list
use invtran
zap
use packtran
zap
use expackingnp
zap
use invdata
zap
do vd

**********************************************************
close all
clear
WAIT WINDOW "Copying Data From Carpetnew1...Wait .." TIMEOUT 2
do caappend
**********************************************************
close all
clear
WAIT WINDOW "Carpet Reindex of Carpetnew...Wait .." TIMEOUT 2
do careindx
close all
WAIT WINDOW "All Job Finished ..." TIMEOUT 2
**********************************************************
