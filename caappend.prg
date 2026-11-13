*set delete on ***We are trying to put 1)Source Data Folder from carpetnew1 into 2) Destination Data Folder Carpetnew
*Rename copy data folder to carpetnew1 -> COMPANY DATA FOLDER 
*Place laptop folder to carpetnew -> PROGRAM FOLDER RAMESH LAPTOP

set safe on
set talk on
close all
open database carpet exclus
use cabuyer exclus
appen from c:\carpetnew1\cabuyer
use cabuyord exclus
appen from c:\carpetnew1\cabuyord
use cacolour exclus
appen from c:\carpetnew1\cacolour
use cadesign exclus
appen from c:\carpetnew1\cadesign
use cagrade exclus
appen from c:\carpetnew1\cagrade
use cafield exclus
appen from c:\carpetnew1\cafield
use caloomsz exclus
appen from c:\carpetnew1\caloomsz
use capo exclus
appen from c:\carpetnew1\capo
use caqlty exclu
appen from c:\carpetnew1\caqlty
use casize exclus
appen from c:\carpetnew1\casize
use casupord exclus
appen from c:\carpetnew1\casupord 
use casupplr exclus
appen from c:\carpetnew1\casupplr
use category exclus
appen from c:\carpetnew1\category
use caweaver exclus
appen from c:\carpetnew1\caweaver
use cawevdel exclus
appen from c:\carpetnew1\cawevdel
use cawshtyp exclus
appen from c:\carpetnew1\cawshtyp
use consump exclus
appen from c:\carpetnew1\consump 
use cstatus exclus
appen from c:\carpetnew1\cstatus
use ctype exclus
appen from c:\carpetnew1\ctype
use destination exclus
appen from c:\carpetnew1\destination
use expackingf exclus
appen from c:\carpetnew1\expackingf
use fullhalf exclus
appen from c:\carpetnew1\fullhalf
use wicolour exclus
appen from c:\carpetnew1\wicolour
use wiissue exclus
appen from c:\carpetnew1\wiissue
use wiqlty exclus
appen from c:\carpetnew1\wiqlty
use wirecv exclus
appen from c:\carpetnew1\wirecv
use wistock exclus
appen from c:\carpetnew1\wistock 
use wireturn exclus
appen from c:\carpetnew1\wireturn
use witrnord exclu
appen from c:\carpetnew1\witrnord
use woolissu excl
appen from c:\carpetnew1\woolissu
use woolop exclus
appen from c:\carpetnew1\woolop
use woolorder exclus
appen from c:\carpetnew1\woolorder
use woolqlty exclus
appen from c:\carpetnew1\woolqlty
use woolpu exclus
appen from c:\carpetnew1\woolpu
use stkcarpet exclus
appen from c:\carpetnew1\stkcarpet
use grregstr exclus
appen from c:\carpetnew1\grregstr
use grsuptran exclus
appen from c:\carpetnew1\grsuptran
****INVOICE/ PACKING LIST
use invtran exclus
appen from c:\carpetnew1\invtran
use yrcalc exclus
appen from c:\carpetnew1\yrcalc
use packtran
appen from c:\carpetnew1\packtran
use expackingnp
appen from c:\carpetnew1\expackingnp
use invdata
appen from c:\carpetnew1\invdata
*******************************
use yrecp exclus
appen from c:\carpetnew1\yrecp
use yrnissdy exclus
appen from c:\carpetnew1\yrnissdy
use yrnop exclus
appen from c:\carpetnew1\yrnop
use yrnorder exclus
appen from c:\carpetnew1\yrnorder
use yrnrecvd exclus
appen from c:\carpetnew1\yrnrecvd
use yrsupop exclus
appen from c:\carpetnew1\yrsupop
use ytype exclus
appen from c:\carpetnew1\ytype
use washtran exclus
appen from c:\carpetnew1\washtran
do vd
**********************************************************
