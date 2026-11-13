clea all
close all

* A button click code
local lcMyBrowse
text to m.lcMyBrowse noshow
oForm = createobject('myForm')
oForm.Show

define class myForm as form
  ShowWindow = 1
  WindowType = 1
  Height =  400
  Width = 600
  Caption = 'This is my browse'
 
  add object myGrid as Grid with Height = 400, Width = 600, recordsource = alias()
enddefine
endtext
*ExecScript(m.lcMyBrowse)