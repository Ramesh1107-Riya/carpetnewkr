*End of the year, we clear data of transaction file, leave empty openbal for Dyed Yarn Store
set date to briti
set safe off
set talk off
close all
clea
use wiissue exclus
zap
use wirecv exclus
zap
use witrnord exclus
zap
use wistock exclus
repl all openbal with 0
repl all opendate with {^2020/07/16}
close all
return
************************************dyed yarn closing
procedure checklst
use woolissu exclus
zap
use woolop exclus
zap
use woolpu exclus
zap
use woolqlty exclus
zap
use yrecp exclus
zap
use yrnissdy exclus
zap
use ynlocat exclus
zap
use yrnop exclus
zap
use yrnordby exclus
zap
use yrnorder exclus
zap
use yrnorder exclus
zap
use yrnrecd exclus
zap
use yrsupop exclus
zap
use location exclus
zap
use orderby exclus
zap
return