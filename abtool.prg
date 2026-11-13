**This colour scheme is obsolute as We can define colour from windows, try to avoid this colour scheme where ever possible - Remark by Ramesh 23//10/2014
**Even then it is used in selection windows and Carpet Order Issue Form - first solve this then you can Remove this colour scheme.
**Something is displays whole are blue colour usually in report - this will be removed in all the report *.prg
PROCEDURE SetColour 
PARAMETER m.SetToColor 
  SET COLOR OF SCHEME 1 TO ;
    W+/B, W+/BG, GR+/B, GR+/B, GR+/B, W+/GR, GR+/R, N+/N, GR+/B, R+/B, +
  SET COLOR OF SCHEME 2 TO ;
    GR+/B, GR+/B, N/W, B/W, GR+/B, N/BG, W+/W, N+/N, B/W, W/N, +
  SET COLOR OF SCHEME 3 TO ;
    BG/W, N/W, BG/N, BG/N, GR+/B, N/BG, W+/W, N+/N, BG/N, BG/N, +
  SET COLOR OF SCHEME 4 TO ;
    BG/W, N/W, N/W, B/W, GR+/B, N/BG, W+/W, N+/N, B/W, W/N, +
  SET COLOR OF SCHEME 5 TO ;
    W+/RB, W+/BG, W+/RB, W+/RB, GR+/B, W+/B, GR+/RB, N+/N, W+/RB, W/RB, +
  SET COLOR OF SCHEME 6 TO ;
    W+/BG, W+/BG, W+/RB, W+/RB, GR+/B, W+/B, BG+/BG, N+/N, W+/RB, W/RB, +
  SET COLOR OF SCHEME 7 TO ;
    GR+/R, W+/W, GR+/R, W+/R, GR+/B, W+/N, GR+/R, N+/N, W+/R, W/R, +
  SET COLOR OF SCHEME 8 TO ;
    W+/BG, W+/W, GR+/W, GR+/W, N+/W, W+/GR, BG+/BG, N+/N, B/BG, W/BG, +
  SET COLOR OF SCHEME 9 TO ;
    W+/BG, W+/BG, B/BG, GR+/W, GR+/B, W+/GR, W+/B, N+/N, GR+/W, N+/W, +
  SET COLOR OF SCHEME 10 TO ;
    W+/BG, GR+/B, GR+/W, GR+/W, N+/W, GR+/GR, W+/B, N+/N, GR+/W, N+/W, +
* We use only scheme 1 to 10, the rest is useless - so copy the scheme 10 to
* all the rest schemes
RETURN


* Function to Return 'CanFinds' for a certain USI Database.
*

FUNCTION SetCanFind
PARAMETER m.scfNumber, m.scfInsMode
DO CASE
  CASE m.scfNumber = 1       && Colours
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaColour', 'CODE', 'CODE', '[ Colours ]', 'CODE', ;
      'Colour Code', '@!', 'DESC', 'Description', '@X')"
  CASE m.scfNumber = 2       && Size Groups 
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaSize', 'SZCODE', 'SZCODE', '[ Size Groups ]', 'SZCODE', ;
        'Size Code', '@!', 'BREADTH', 'Breadth', '@!', 'LENGTH', 'Length',  '@X')"     
  CASE m.scfNumber = 3       && Carpet Type
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Ctype', 'CTYPE', 'CTYPE', '[ Carpet Type ]', 'CTYPE', ;
        'Carpet Type',  '@X')"
  CASE m.scfNumber = 4       && Ship_inst ,Via Air/Ship
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Via', 'SHIP_INST', 'SHIP_INST', '[ Shippint Inst. ]', 'SHIP_INST', ;
        'Shipping Inst.',  '@X')"
  CASE m.scfNumber =5       && Wash Type
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cawshtyp', 'WASHTYPE', 'WASHTYPE', '[ Wash Type ]', 'WASHTYPE', ;
        'Wash Type', '@!', 'DESC', 'Description',  '@X')"    
   CASE m.scfNumber = 6       && Designs
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cadesign', 'CODE', 'CODE', '[ Designs ]', 'CODE:21', ;
      'Design Code', '@!', 'QUALITY:10', 'Quality', '@!', 'FLDTYPE', 'Field ', '@X')"
  CASE m.scfNumber = 7       && Destination
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Destination', 'DESTINAT', 'DESTINAT', '[ Destination ]', 'DESTINAT', ;
        'Destination',  '@X')"
  CASE m.scfNumber = 8       && Fields (Design)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaField', 'FIELDCODE', 'FIELDCODE', '[ Design Fields ]', ;
      'FIELDCODE:10', 'Field Code', '@!','DESC:20', 'Description','@!', ;
      'QUALITY:10', 'Quality',  '@X')"
  CASE m.scfNumber = 9       && PO Detail Pending at present 
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Capo', 'PO_NO', 'PO_NO', '[ PO Details ]', 'PO_NO', ;
      'PO No.', '@!',  'BCODE', 'Buyer Code', '@!', 'ORDER_TYPE', 'Order Type', '@X')"      
  CASE m.scfNumber = 10       && CSTATUS 
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CStatus', 'status', 'status', '[ Status Details ]', 'status', ;
      'status', '@X')"      
   CASE m.scfNumber = 11       && Carpet Quality
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Caqlty', 'CODE', 'CODE', '[ Carpet Quality ]', 'CODE', ;
      'Carpet Quality', '@!', 'DESC', 'Description', '@X')"
  CASE m.scfNumber = 12       && Yarn Quality
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Wiqlty', 'QUALITY', 'QUALITY', '[Yarn Quality ]', 'QUALITY', ;
      'Yarn Quality', '@!', 'RATE', 'Buying Rate', '@X')"
 CASE m.scfNumber = 13       && Full Half
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'FullHalf', 'FULLHALF', 'FULLHALF', '[ Full/ Half ]', 'FULLHALF', ;
        'FullHalf',  '@X')"
 CASE m.scfNumber = 14       && Supplier
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Casupplr', 'CODE', 'CODE', '[ Supplier ]', 'CODE', ;
        'code', '@!', 'Category', 'Category',  '@X')"
 CASE m.scfNumber = 15       && Order Type (Grordtype.dbf for graphs only)
     RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Grordtype', 'ORDTYPE', 'ORDTYPE', '[ Grpah Order Type ]', 'ORDTYPE', ;
        'Ordtype',  '@X')"
  CASE m.scfNumber = 16       && Rooms
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Rooms', 'Rooms', 'Rooms', '[ Rooms No.]', 'Rooms', ;
        'Rooms',  '@X')"
  CASE m.scfNumber = 17       && Location (Yarn & Carept Store Location)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Location', 'LOCATION', 'LOCATION', '[Store Location ]', 'LOCATION', ;
        'Location', '@!',  'CATEGORY', 'Store Category', '@X')"
  CASE m.scfNumber = 18       && Casupord Card_No
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Casupord', 'CARD_NO', 'CARD_NO', '[ Weaver Card No. ]', 'CARD_NO', ;
        'Card_No',   '@!',  'WEAVER', 'Weaver', '@!', 'SUPPLIER', 'Supplier','@X')"
   CASE m.scfNumber = 19       && Cabuyer (Carpet Buyers)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cabuyer', 'BCODE', 'BCODE', '[ Buyers ]', 'BCODE', ;
      'Carpet Buyer', '@!', 'NAME', 'Name', '@X')"
   CASE m.scfNumber = 20       && Woolqlty
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Woolqlty', 'WQLTY', 'WQLTY', '[ Wool Quality ]', 'WQLTY', ;
        'Woolqlty',  '@!',  'WSRATE', 'Wool Rate', '@X')"      
   CASE m.scfNumber = 21       && Location (Yarn Store Location)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Wash', 'WTYPE', 'WTYPE', '[ Wash / Unwash ]', 'WTYPE', ;
        'WashUnwash',  '@X')"
   CASE m.scfNumber = 22    && Yarn RM Order No.    
     RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'yrnorder', 'RONO', 'RONO', '[Yarn/Raw Material Order]', 'RONO', ;
          'RM No.', '@!',  'DATE', 'Order Date', '@!', 'SUPLIER', 'Supplier','@X')"
  CASE m.scfNumber = 23    && Wool RM Order No.
     RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'woolorder', 'RONO', 'RONO', '[Wool Order]', 'RONO', ;
          'RM No.', '@!',  'DATE', 'Order Date', '@!', 'SUPLIER', 'Supplier','@X')"
  CASE m.scfNumber = 24    && For Dyed Yarn Return Quality
     RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'wiissue', 'QUALITY', 'QUALITY', '[Dyed Yarn Issued]', 'QUALITY', ;
          'Quality', '@!',  'COLOUR', 'Colour', 'QUANTITY', 'Net Wt.', '@X')"
   CASE m.scfNumber = 25       && Weaver
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaWeaver', 'WEAVER', 'WEAVER', '[ Weaver ]', 'WEAVER', ;
        'Weaver', '@!', 'Supplier', 'Supplier',  '@X')"
  CASE m.scfNumber = 26       && Dyed Yarn Type
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Ytype', 'YTYPE', 'YTYPE', '[ Dyed Yarn Type ]', 'YTYPE', ;
        'Yarn Type',  '@X')"
 CASE m.scfNumber = 27       && Ol_No from Casupord.bf
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaSupord', 'OL_NO', 'OL_NO', '[ OL No. ]', 'OL_NO', ;
        'OL_NO', '@!', 'Weaver', 'Weaver',  '@X')"        
 CASE m.scfNumber = 28       && CarpetNo from Casupord.bf
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaSupord', 'CARPETNO', 'CARPETNO', '[ CARPET NO. ]', 'CARPETNO', ;
        'CARPETNO', '@!', 'FINSQMT', 'FINSQMT',  '@X')"  
 CASE m.scfNumber = 29       && Category from CaCategory.bf (carpet category)
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaCategroy', 'CATEGORY', 'CATEGORY', '[ CARPET CATEGORY ]', 'CATEGORY', ;
        'Carpet Category', '@X')" 
 CASE m.scfNumber = 30       && Cabuyer
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Cabuyer', 'BCODE', 'BCODE', '[ Sub Buyer ]', 'BCODE', ;
      'Buyer Code', '@X')"
 CASE m.scfNumber = 31    && YrnWshRcd from YrnWshIss.dbf   
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'YrnWshIss', 'DELINO', 'DELINO', '[Yarn Wash Issue Detail]', 'DELINO', ;
          'Delivery No.', '@!',  'QUALITY', 'QUALITY', '@!', 'COLOUR', 'Colour','@X')"
  CASE m.scfNumber = 32    && YrnWshRcd from YrnWshIss.dbf   
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'WITRNORD', 'BILLNO', 'BILLNO', '[Dyeing Order Issued Detail]', 'BILLNO', ;
          'Delivery No.', '@!',  'QUALITY', 'QUALITY', '@!', 'COLOUR', 'Colour','@X')" 
  CASE m.scfNumber = 33       && Ship_inst ,Via Air/Ship
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Freights', 'FREIGHT', 'FREIGHT', '[ Freights ]', 'FREIGHT', ;
        'Freight',  '@X')" 
   CASE m.scfNumber = 34       && Ship_inst ,Via Air/Ship
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Curncytypes', 'CURNTYPE', 'CURNTYPE', '[ Currency Type ]', 'CURNTYPE', ;
        'CurnType',  '@X')"  
    CASE m.scfNumber = 35       && Ol_No from CaBuyord.bf
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'CaBuyord', 'OL_NO', 'OL_NO', '[ OL No. ]', 'OL_NO', ;
        'OL_NO', '@!', 'Design', 'Design',  '@X')"  
    CASE m.scfNumber = 36      
         RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'MatchTo', 'Match', 'Match', '[ Match To ]', 'Match', ;
        'Match', '@X')" 
    CASE m.scfNumber = 37    && Washrate.dbf used in Washtran.dbf Code for washrate
     RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
       ", 'WashRate', 'CODE', 'CODE', '[Carpet Process Detail]', 'CODE', ;
          'Code', '@!',  'JOBDESC', 'JOBDESC', '@!', 'Name', 'Name','@X')"           
    CASE m.scfNumber = 38       && person name who pass the carpet
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Capass', 'CODE', 'CODE', '[Name Initials]', 'CODE', ;
        'CODE', '@!', 'Name', 'Name',  '@X')"   
   CASE m.scfNumber = 39       && Rooms
    RETURN "ShowList(SYS(18), " + IIF(m.scfInsMode, ".T.", ".F.") + ;
      ", 'Capass', 'CODE', 'CODE', '[Name Initials]', 'CODE', ;
        'CODE', '@!', 'Name', 'Name',  '@X')"                    
ENDCASE
RETURN ""

* Function to Display help (list) fro Database File if the user leaves the
* input variable empty or invalid. It sets the record pointer to the half 
* input variable if it exists in the data file, otheriwse to the top of the
* file. Previously opened data files, index set and record pointer is not
* affected by this program. All fields are displayed in READ ONLY mode. The
* reading variable name is assumes as 'MEMORY' variable - and if it is not
* passed as 'm.', program will automatically add it. User can Pass some
* special fields - like Calculated Field etc. from the file. If No field is
* passed - it will always return a FALSE value.
*
* Input   : 1.  NAME of the current input field.
*           2.  Flag for Insert Mode - If it is True, program will always
*               pass a TRUE value.
*           3.  Alias name of Database to be used for display operation.
*           4.  Searching Order Name - It will Set Index to this Order for
*               displaying/listing.
*           5.  Title of the Help/List to be Displayed in the top of the
*               list. (different languages - will be processed here)
*           5.  Information of Field 1 to be Displayed - Field Name, Header
*               Text and Picture Format.
*           6.  Information of Field 2 to be Displayed - Field Name, Header
*               Text and Picture Format
*           7.  Information of Field 3 to be Displayed - Field Name, Header
*               Text and Picture Format
*           8.  FOR Condition - It will filter necessary records from the
*               file to show as per user's requirement.
*
* Output  : 1.  If user selects a choice pressing ENTER, the current value
*               will be returned. But if the file is empty, it will be like
*               pressing ESC and the same old value will be returned.
*           2.  If user ESCAPEs in the List/Help, the value of the input
*               variable remains same.
*

FUNCTION ShowList
PARAMETERS m.slVarName, m.slInsMode, m.slAlias, m.slSetOrder, m.slRetField, ;
  m.slTitle, m.slField1, m.slHeader1, m.slPict1, m.slField2, m.slHeader2, ;
  m.slPict2, m.slField3, m.slheader3, m.slPict3, m.slForCond
* If exited by any Invalid Key, Do not perform anything
IF LASTKEY() = 18 .OR. LASTKEY() = 19 .OR. LASTKEY() = 5 .OR. LASTKEY() = 15  && 13=Enter, 18=pageup, 19=left arrow, 5=up arrow
  RETURN .T.
ENDIF
m.slVarName = IIF(LOWER(LEFT(m.slVarName, 2)) # "m.", "m.", "") + m.slVarName
IF m.slInsMode .AND. (.NOT. EMPTY(&slVarName))
  RETURN .T.
ENDIF
* SEEK is right here because index is in CODE now, later it can be in any
* field passed in the parameter.
 IF SEEK(&slVarName, m.slAlias)
  * Check for FOR Condition
  IF (.NOT. EMPTY(m.slForCond))
    PRIVATE m.slCurAlias, m.slCurRecNo, m.slTempVar
    m.slCurAlias = ALIAS()
    m.slCurRecNo = RECNO()
    SELECT (m.slAlias)
    m.slTempVar  = RECNO()
    IF &slForCond
      IF RECCOUNT() <= m.slTempVar
        GOTO m.slTempVar
      ENDIF
      SELECT (m.slCurAlias)
      IF m.slCurRecNo <= RECCOUNT()
        GOTO m.slCurRecNo
      ENDIF
      RETURN .T.
    ENDIF
    IF RECCOUNT() <= m.slTempVar
      GOTO m.slTempVar
    ENDIF
    SELECT (m.slCurAlias)
    IF m.slCurRecNo <= RECCOUNT()
      GOTO m.slCurRecNo
    ENDIF
  ELSE
    RETURN .T.
  ENDIF
ENDIF
IF EMPTY(m.slField1)
  RETURN .F.
ENDIF
PRIVATE m.slScreen, m.slCurAlias, m.slCurRecNo, m.slPrvRecNo, m.slPrvOrder,;
  m.slBrowCond, m.slLastKey, m.slTempVar
SAVE SCREEN TO m.slScreen
m.slCurAlias = ALIAS()
m.slCurRecNo = RECNO()
m.slTitle    = LEFT(m.slTitle, 35)
m.slHeader1  = IIF(EMPTY(m.slHeader1), "", m.slHeader1)
m.slHeader2  = IIF(EMPTY(m.slHeader2), "", m.slHeader2)
m.slHeader3  = IIF(EMPTY(m.slHeader3), "", m.slHeader3)
IF EMPTY(m.slPict1)
  m.slBrowCond = m.slField1 + ":H='" + m.slHeader1 + "':R"
ELSE
  m.slBrowCond = m.slField1 + ":H='" + m.slHeader1 + "':P='" + m.slPict1 + "':R"
ENDIF
IF (.NOT. EMPTY(m.slField2))
  IF EMPTY(m.slPict2)
    m.slBrowCond = m.slBrowCond + ", " + m.slField2 + ":H='" + m.slHeader2 + "':R"
  ELSE
    m.slBrowCond = m.slBrowCond + ", " + m.slField2 + ":H='" + m.slHeader2 + ;
      "':P='" + m.slPict2 + "':R"
  ENDIF
  IF (.NOT. EMPTY(m.slField3))
    IF EMPTY(m.slPict3)
      m.slBrowCond = m.slBrowCond + ", " + m.slField3 + ":H='" + m.slHeader3 + "':R"
    ELSE
      m.slBrowCond = m.slBrowCond + ", " + m.slField3 + ":H='" + m.slHeader3 + ;
        "':P='" + m.slPict3 + "':R"
    ENDIF
  ENDIF
ENDIF

DEFINE WINDOW slWindow FROM 13,100 TO 40,150 IN DESKTOP PANEL CLOSE FLOAT ;
 NOGROW NOZOOM COLOR SCHEME 5
SELECT (m.slAlias)
m.slPrvRecNo = RECNO()
m.slPrvOrder = ORDER()
SET ORDER TO    &slSetOrder          && Index Setting on Passed Parameter
IF (.NOT. EMPTY(&slVarName))
  * There will occur an error when we use ALLTRIM, actually this is for
  * character type data only. So, for character data we use ALLTRIM but
  * for other data type we will use the value of the variable.
  IF TYPE("&slVarName") = "C"
    = SEEK(ALLTRIM(&slVarName), ALIAS())
  ELSE
    = SEEK(&slVarName, ALIAS())
  ENDIF
  IF (.NOT. FOUND())
    IF RECNO(0) # 0                        && Soft SEEK
      GOTO RECNO(0)
    ELSE                                   && Value Greater than last Record
      GOTO BOTTOM
    ENDIF
    DO CASE
      CASE TYPE("&slVarName") = "C"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + ALLTRIM(&slVarName) + " !" NOWAIT
      CASE TYPE("&slVarName") = "N"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + ALLTRIM(STR(&slVarName)) + " !" NOWAIT
      CASE TYPE("&slVarName") = "D"
        ?? CHR(7)
        WAIT WINDOW "Nothing starts from " + DTOC(&slVarName) + " !" NOWAIT
    ENDCASE
  ENDIF
ELSE
  GOTO TOP
ENDIF
*DO MessDisplay WITH "[ENTER]/[RETURN]  -  Selects the Current Option and Returns Back" by && ramesh
ON KEY LABEL ENTER   KEYBOARD CHR(23)       && Value of Ctrl-W / Ctrl-END
IF EMPTY(m.slForCond)
  BROWSE FIELDS &slBrowCond NOAPPEND NODELETE NOEDIT NOMENU REST TITLE ;
    m.slTitle WINDOW slWindow COLOR SCHEME 6
    ELSE
  BROWSE FIELDS &slBrowCond FOR &slForCond NOAPPEND NODELETE NOEDIT NOMENU ;
    REST TITLE m.slTitle WINDOW slWindow COLOR SCHEME 6
ENDIF
m.slLastKey  = LASTKEY()
ON KEY LABEL ENTER
IF m.slLastKey = 23 .AND. (RECNO() <= RECCOUNT())
  &slVarName  = &slRetField
  m.slLastKey = 999
ENDIF
SET ORDER TO  &slPrvOrder
IF m.slPrvRecNo <= RECCOUNT()
  GOTO m.slPrvRecNo
ENDIF
SELECT (m.slCurAlias)
*IF m.slCurRecNo <= RECCOUNT() && Withdrew by ramesh
 * GOTO m.slCurRecNo
*ENDIF
RELEASE WINDOW slWindow
RESTORE SCREEN FROM m.slScreen
IF m.SlInsMode           && not to be changed if other than USI CanFind
  m.SecondBrow = .T.     && Variable for Basic (USI) Files
ENDIF
IF m.slInsMode
  IF EMPTY(&slVarName)
    RETURN .F.
  ENDIF
  RETURN (m.slLastKey # 27)
ENDIF
RETURN (m.slLastKey = 999)

***********
PROCEDURE MessDisplay
PARAMETER m.MessLine
PRIVATE m.mdCurrWind, mdDispCol
m.mdCurrWind = WOUTPUT()
m.mdDispCol  = "GR+/B"     && IIF(ISCOLOR(), "GR+/B", "W+/N")
m.MessLine   = IIF(EMPTY(m.MessLine), "  ", LEFT(m.MessLine, 60)) &&100
IF (.NOT. EMPTY(m.mdCurrWind)) .AND. WROWS(m.mdCurrWind) <= 30 && 40
  ACTIVATE SCREEN
ENDIF
@ 30,0 SAY SPACE(WCOLS()) COLOR (m.mdDispCol) && orginal @40,0
@ 30,(WCOLS()-LEN(m.MessLine))/2 SAY m.MessLine COLOR (m.mdDispCol) &&@30
IF (.NOT. EMPTY(m.mdCurrWind)) .AND. WROWS(m.mdCurrWind) <= 30 &&40
  ACTIVATE WINDOW (m.mdCurrWind) SAME
ENDIF
RETURN


* Function to Check EXIT Validity from a READ Object
*

FUNCTION ReadExit
m.ReadExitKey = LASTKEY()
IF m.ReadExitKey = 18 .OR. m.ReadExitKey = 19 .OR. ReadExitKey = 5 .OR. ;
  m.ReadExitKey = 15
  RETURN .F.
ENDIF
RETURN .T.



* Function to check how the READ field was exited. If it was exited having
* LASTKEY value ENTER or F12, it will return TRUE otherwise FALSE.
*

FUNCTION EnterF12
PARAMETER m.AllowUp
IF EMPTY(m.AllowUp)     && Allow ENTER, F12, ESC and CTRL-W/CTRL-END
  RETURN (LASTKEY() = 13 .OR. LASTKEY() = 134 .OR. LASTKEY() = 27 .OR. ;
    LASTKEY() = 23)
ENDIF
RETURN (LASTKEY() = 13 .OR. LASTKEY() = 134 .OR. LASTKEY() = 5 .OR. ;
  LASTKEY() = 19 .OR. LASTKEY() = 18 .OR. LASTKEY() = 15 .OR. ;
  LASTKEY() = 27 .OR. LASTKEY() = 23)

* End of Function EnterF12

*=====================================================================
* SPLIT ISSUE BY SQMT  -  Issue Dyed Yarn to SUPPLIER (wiissue.scx)
*
* One entry on the form (OL No, quality, colour, Net Wt) is saved as one
* Wiissue row per OL of the same ORDER FORM, the Net Wt being shared in
* proportion to SqMt.  All rows of one entry carry the same Wiissue.GRPID.
*
* Order Form group (same selection as rordformyarn.prg): Casupord.Issdt and
* Supplier the same as the entered OL, Cabuyord Design, Colour and Quality
* the same, Cstatus On-Loom / Distri.  The entered OL is always included.
*
* Needs the GRPID column in Wiissue -> run   DO wiissue_addgrp   once.
* Rows with a blank GRPID (all old data) are never touched by this code.
*
* Called from the form (BUTTONSET1.UpdateRows / cmdEdit.Click / cmdExit):
*   WiPostSave    after an Add or Edit row was saved  -> split / re-split
*   WiDeleteGroup on Delete of a split row            -> delete whole entry
*   WiGroupInfo   on Edit of a split row              -> show the entry TOTAL
*=====================================================================

* GRPID of the current Wiissue row ("" if none, a temporary marker, or no GRPID column)
FUNCTION WiCurGrp
LOCAL lcGrp
IF !USED("wiissue") .OR. TYPE("wiissue.grpid") = "U"
	RETURN ""
ENDIF
lcGrp = ALLTRIM(wiissue.grpid)
RETURN IIF(LEFT(lcGrp, 1) = "~", "", lcGrp)
* End of Function WiCurGrp


* Second, unbuffered handle on Wiissue (alias wi_w) used for the split work
FUNCTION WiOpenW
IF USED("wi_w")
	USE IN wi_w
ENDIF
USE wiissue AGAIN SHARED IN 0 ALIAS wi_w
RETURN USED("wi_w")
* End of Function WiOpenW


* Fill cursor cWiSib with the OLs of the Order Form of tcOlNo (+ their SqMt).
* Returns the number of OLs (1 when the OL has no Order Form partners).
FUNCTION WiSiblings
LPARAMETERS tcOlNo
LOCAL lnSel, lcAnsi, ldIss, lcSup, lcDes, lcCol, lcQlt
lnSel = SELECT()
lcAnsi = SET("ANSI")
SET ANSI ON
tcOlNo = ALLTRIM(tcOlNo)
IF USED("cWiSib")
	USE IN cWiSib
ENDIF
CREATE CURSOR cWiSib (ol_no C(15), sqmt N(8,2), share N(11,3), taken L)

SELECT s.issdt, s.supplier, b.design, b.colour, b.quality, b.sqmt ;
	FROM casupord s, cabuyord b ;
	WHERE b.ol_no = s.ol_no AND s.ol_no = tcOlNo ;
	INTO CURSOR cWiKey

IF RECCOUNT("cWiKey") = 0
	INSERT INTO cWiSib (ol_no) VALUES (tcOlNo)
ELSE
	ldIss = cWiKey.issdt
	lcSup = cWiKey.supplier
	lcDes = cWiKey.design
	lcCol = cWiKey.colour
	lcQlt = cWiKey.quality
	IF !EMPTY(ldIss) .AND. !EMPTY(lcSup)
		SELECT s.ol_no, b.sqmt ;
			FROM casupord s, cabuyord b ;
			WHERE b.ol_no = s.ol_no AND s.issdt = ldIss AND s.supplier = lcSup ;
			AND b.design = lcDes AND b.colour = lcCol AND b.quality = lcQlt ;
			AND (b.cstatus = "On-Loom" OR b.cstatus = "Distri") ;
			ORDER BY s.ol_no ;
			INTO CURSOR cWiSib0
		SELECT cWiSib0
		SCAN
			INSERT INTO cWiSib (ol_no, sqmt) VALUES (cWiSib0.ol_no, cWiSib0.sqmt)
		ENDSCAN
		USE IN cWiSib0
	ENDIF
	SELECT cWiSib
	LOCATE FOR ALLTRIM(ol_no) == tcOlNo
	IF !FOUND()
		* the OL itself is not On-Loom / Distri, so it is not part of the Order Form: no split
		USE IN cWiSib
		CREATE CURSOR cWiSib (ol_no C(15), sqmt N(8,2), share N(11,3), taken L)
		INSERT INTO cWiSib (ol_no, sqmt) VALUES (tcOlNo, cWiKey.sqmt)
	ENDIF
ENDIF
USE IN cWiKey
SET ANSI &lcAnsi
SELECT cWiSib
GO TOP
SELECT (lnSel)
RETURN RECCOUNT("cWiSib")
* End of Function WiSiblings

* Edit of a split entry: fill cWiSib with the OLs the entry already has (alias wi_w
* must be open) plus tcOlNo, the OL now on the edited row.  The Order Form status is
* NOT looked at again, so an old entry keeps its OLs after the carpets moved on.
FUNCTION WiMembers
LPARAMETERS tcGrp, tcOlNo
LOCAL lnSel, laS[1]
lnSel = SELECT()
tcOlNo = ALLTRIM(tcOlNo)
IF USED("cWiSib")
	USE IN cWiSib
ENDIF
CREATE CURSOR cWiSib (ol_no C(15), sqmt N(8,2), share N(11,3), taken L)
SELECT DISTINCT w.ol_no, b.sqmt ;
	FROM wi_w w LEFT JOIN cabuyord b ON b.ol_no = w.ol_no ;
	WHERE w.grpid = tcGrp ;
	INTO CURSOR cWiM
SELECT cWiM
SCAN
	INSERT INTO cWiSib (ol_no, sqmt) VALUES (cWiM.ol_no, IIF(ISNULL(cWiM.sqmt), 0, cWiM.sqmt))
ENDSCAN
USE IN cWiM
SELECT cWiSib
LOCATE FOR ALLTRIM(ol_no) == tcOlNo
IF !FOUND()
	SELECT sqmt FROM cabuyord WHERE ol_no = tcOlNo INTO ARRAY laS
	INSERT INTO cWiSib (ol_no, sqmt) VALUES (tcOlNo, IIF(_TALLY > 0, laS[1], 0))
ENDIF
GO TOP
SELECT (lnSel)
RETURN RECCOUNT("cWiSib")
* End of Function WiMembers


* Share tnTotal over cWiSib by SqMt (3 decimals).  The rounding difference
* goes to the OL with the biggest share so that the shares add up exactly.
PROCEDURE WiSetShares
LPARAMETERS tnTotal
LOCAL lnSel, lnSq, lnN, lnSum, lnMax
lnSel = SELECT()
SELECT cWiSib
lnN = RECCOUNT()
CALCULATE SUM(sqmt) TO lnSq
SCAN
	IF lnSq > 0
		REPLACE share WITH ROUND(tnTotal * sqmt / lnSq, 3), taken WITH .F.
	ELSE
		REPLACE share WITH ROUND(tnTotal / lnN, 3), taken WITH .F.
	ENDIF
ENDSCAN
CALCULATE SUM(share) TO lnSum
IF ROUND(tnTotal - lnSum, 3) # 0
	CALCULATE MAX(share) TO lnMax
	LOCATE FOR share = lnMax
	REPLACE share WITH ROUND(share + (tnTotal - lnSum), 3)
ENDIF
SELECT (lnSel)
RETURN
* End of Procedure WiSetShares


* A GRPID not used by any Wiissue row yet (alias wi_w must be open)
FUNCTION WiNewGrpId
LOCAL lcId, laCnt[1]
DO WHILE .T.
	lcId = SUBSTR(DTOS(DATE()), 3) + STRTRAN(TIME(), ":", "") + PADL(INT(RAND() * 1000), 3, "0")
	SELECT COUNT(*) FROM wi_w WHERE grpid = lcId INTO ARRAY laCnt
	IF laCnt[1] = 0
		EXIT
	ENDIF
ENDDO
RETURN lcId
* End of Function WiNewGrpId


* Count / total quantity / printed slips of the rows of one entry.
* Returns the number of rows; tnTotal, tnPrinted are passed by reference.
FUNCTION WiGroupInfo
LPARAMETERS tcGrp, tnTotal, tnPrinted
LOCAL lnSel, laInf[3], lnN
lnSel = SELECT()
tnTotal = 0
tnPrinted = 0
lnN = 0
IF !EMPTY(tcGrp) .AND. WiOpenW()
	SELECT COUNT(*), SUM(quantity), SUM(IIF(EMPTY(slipno), 0, 1)) ;
		FROM wi_w WHERE grpid = tcGrp INTO ARRAY laInf
	lnN = laInf[1]
	tnTotal = IIF(lnN > 0, laInf[2], 0)
	tnPrinted = IIF(lnN > 0, laInf[3], 0)
	USE IN wi_w
ENDIF
SELECT (lnSel)
RETURN lnN
* End of Function WiGroupInfo


* Position of field tcField in alias wi_w (for the row arrays below)
FUNCTION WiFno
LPARAMETERS tcField
LOCAL laF[1], lni
=AFIELDS(laF, "wi_w")
FOR lni = 1 TO ALEN(laF, 1)
	IF laF[lni, 1] == UPPER(tcField)
		RETURN lni
	ENDIF
ENDFOR
RETURN 0
* End of Function WiFno


* Write the rows of one entry: update the rows already in the group, delete the
* ones whose OL left the entry, insert the missing ones.  The lead row (record
* tnRec, already saved) supplies party, bill, date, quality, colour ...
* cWiSib must hold the shares (WiSiblings / WiMembers + WiSetShares).
* All or nothing (one transaction).
FUNCTION WiSyncGroup
LPARAMETERS tcGrp, tnRec
LOCAL lnSel, laRow[1], lnOl, lnQty, lnAmt, lnGrp, lnRate, lcOldErr, llOk
PRIVATE pcWiErr
lnSel = SELECT()
IF EMPTY(tcGrp) .OR. !WiOpenW()
	SELECT (lnSel)
	RETURN .F.
ENDIF
lnOl = WiFno("OL_NO")
lnQty = WiFno("QUANTITY")
lnAmt = WiFno("AMT")
lnGrp = WiFno("GRPID")
lnRate = WiFno("RATE")
pcWiErr = ""
lcOldErr = ON("ERROR")
ON ERROR pcWiErr = MESSAGE()
BEGIN TRANSACTION
SELECT wi_w
GO tnRec
SCATTER TO laRow
REPLACE grpid WITH tcGrp IN wi_w
laRow[lnGrp] = tcGrp
SCAN FOR EMPTY(pcWiErr) .AND. grpid = tcGrp
	SELECT cWiSib
	LOCATE FOR ALLTRIM(ol_no) == ALLTRIM(wi_w.ol_no) .AND. !taken .AND. share > 0
	IF FOUND()
		REPLACE taken WITH .T.
		laRow[lnOl] = cWiSib.ol_no
		laRow[lnQty] = cWiSib.share
		laRow[lnAmt] = ROUND(laRow[lnRate] * cWiSib.share, 2)
		SELECT wi_w
		GATHER FROM laRow
	ELSE
		SELECT wi_w
		DELETE
	ENDIF
	SELECT wi_w
ENDSCAN
SELECT cWiSib
SCAN FOR EMPTY(pcWiErr) .AND. !taken .AND. share > 0
	laRow[lnOl] = cWiSib.ol_no
	laRow[lnQty] = cWiSib.share
	laRow[lnAmt] = ROUND(laRow[lnRate] * cWiSib.share, 2)
	SELECT wi_w
	INSERT INTO wi_w FROM ARRAY laRow
	SELECT cWiSib
ENDSCAN
IF EMPTY(pcWiErr)
	END TRANSACTION
	llOk = .T.
ELSE
	ROLLBACK
	llOk = .F.
ENDIF
ON ERROR &lcOldErr
USE IN wi_w
IF !llOk
	=MESSAGEBOX("Could not split the issue over the OLs:" + CHR(13) + pcWiErr + CHR(13) + ;
		"The row was saved as entered (full quantity on one OL).", 48, "Split by SqMt")
ENDIF
SELECT (lnSel)
RETURN llOk
* End of Function WiSyncGroup


* Call just BEFORE the current Wiissue row is saved; hand the result to WiPostSave.
*   Add  : the new (buffered) row gets a unique marker in GRPID.  After the save it
*          is found again on disk by that marker - the record pointer of the form
*          can sit on ANOTHER row of the same OL after a TABLEUPDATE, so RECNO()
*          cannot be trusted then.
*   Edit : the record number of the row being edited (it exists already).
FUNCTION WiPreSave
LPARAMETERS tlAdd
LOCAL lcMark
IF TYPE("wiissue.grpid") = "U"
	RETURN ""
ENDIF
IF !tlAdd
	RETURN ALLTRIM(STR(RECNO("wiissue")))
ENDIF
lcMark = "~" + SYS(2015) + PADL(INT(RAND() * 10000), 4, "0")
REPLACE grpid WITH lcMark IN wiissue
RETURN lcMark
* End of Function WiPreSave


* After an Add / Edit row has been saved (tcTok = result of WiPreSave).
*   tlAdd .T.  new row: split it if its OL has Order Form partners, else just
*              take the marker off
*   tlAdd .F.  edited row of a split entry: share the (new) quantity again over
*              the OLs the entry already has
PROCEDURE WiPostSave
LPARAMETERS tlAdd, tcTok
LOCAL lnSel, lnRec, lcOl, lnQty, lcGrp, lnN, llSplit, laPrn[1]
lnSel = SELECT()
IF EMPTY(tcTok) .OR. TYPE("wiissue.grpid") = "U"
	IF tlAdd .AND. TYPE("wiissue.grpid") = "U"
		=MESSAGEBOX("Split by SqMt is not active: Wiissue has no GRPID column." + CHR(13) + ;
			"Run  DO wiissue_addgrp  once (all users out of the program).", 48, "Split by SqMt")
	ENDIF
	SELECT (lnSel)
	RETURN
ENDIF
IF !WiOpenW()
	SELECT (lnSel)
	RETURN
ENDIF
SELECT wi_w
lnRec = 0
IF tlAdd
	LOCATE FOR grpid = tcTok
	IF FOUND()
		lnRec = RECNO()
	ENDIF
ELSE
	lnRec = VAL(tcTok)
	IF lnRec < 1 .OR. lnRec > RECCOUNT()
		lnRec = 0
	ENDIF
ENDIF
IF lnRec = 0
	USE IN wi_w
	SELECT (lnSel)
	RETURN
ENDIF
GO lnRec
lcOl = ALLTRIM(ol_no)
lnQty = quantity
lcGrp = IIF(tlAdd, "", ALLTRIM(grpid))
llSplit = .T.
DO CASE
CASE DELETED() .OR. EMPTY(lcOl) .OR. lnQty <= 0 .OR. (!tlAdd .AND. EMPTY(lcGrp))
	llSplit = .F.
CASE tlAdd
	lnN = WiSiblings(lcOl)
	IF lnN <= 1
		llSplit = .F.
	ELSE
		lcGrp = WiNewGrpId()
	ENDIF
OTHERWISE
	SELECT SUM(IIF(EMPTY(slipno), 0, 1)) FROM wi_w WHERE grpid = lcGrp INTO ARRAY laPrn
	IF laPrn[1] > 0
		* a bill/slip of this entry is already printed: do not touch the other rows
		=MESSAGEBOX("The slip of this split issue is already printed: only the edited row was changed." + CHR(13) + ;
			"The other OL rows were NOT re-split.", 48, "Split by SqMt")
		llSplit = .F.
	ELSE
		lnN = WiMembers(lcGrp, lcOl)
	ENDIF
ENDCASE
IF tlAdd .AND. !llSplit
	REPLACE grpid WITH "" IN wi_w
ENDIF
USE IN wi_w
IF llSplit
	=WiSetShares(lnQty)
	IF WiSyncGroup(lcGrp, lnRec)
		WAIT WINDOW TRANSFORM(lnQty, "999,999.999") + " kg split by SqMt over " + ;
			ALLTRIM(STR(lnN)) + " OL of the Order Form" NOWAIT
	ELSE
		IF tlAdd .AND. WiOpenW()
			SELECT wi_w
			GO lnRec
			REPLACE grpid WITH "" IN wi_w
			USE IN wi_w
		ENDIF
	ENDIF
ENDIF
IF USED("cWiSib")
	USE IN cWiSib
ENDIF
* show the saved row, re-read from disk (its share, no marker)
IF USED("wiissue") .AND. lnRec <= RECCOUNT("wiissue")
	GO lnRec IN wiissue
ENDIF
SELECT (lnSel)
RETURN
* End of Procedure WiPostSave


* Delete ALL rows of the split entry tcGrp (after asking).
* Returns  1 = whole entry deleted,  0 = cancelled / not possible,
*        -1 = entry has only this one row left (do the normal delete).
FUNCTION WiDeleteGroup
LPARAMETERS tcGrp
LOCAL lnN, lnTot, lnPrn
lnN = WiGroupInfo(tcGrp, @lnTot, @lnPrn)
IF lnN <= 1
	* nothing but this row: let the normal delete do it
	RETURN -1
ENDIF
IF lnPrn > 0
	=MESSAGEBOX("Cannot delete: the bill/slip of this split issue is already printed.", 48, "Split by SqMt")
	RETURN 0
ENDIF
IF MESSAGEBOX("This row belongs to ONE issue of " + TRANSFORM(lnTot, "999,999.999") + " kg split over " + ;
		ALLTRIM(STR(lnN)) + " OL rows." + CHR(13) + "Delete the WHOLE issue (all " + ALLTRIM(STR(lnN)) + " rows)?", ;
		36, "Split by SqMt") # 6
	RETURN 0
ENDIF
RETURN IIF(WiDelGrpRows(tcGrp), 1, 0)
* End of Function WiDeleteGroup


* Delete every row of the entry tcGrp in one transaction.  .T. = done.
FUNCTION WiDelGrpRows
LPARAMETERS tcGrp
LOCAL lcOldErr, llOk
PRIVATE pcWiErr
IF EMPTY(tcGrp) .OR. !WiOpenW()
	RETURN .F.
ENDIF
pcWiErr = ""
lcOldErr = ON("ERROR")
ON ERROR pcWiErr = MESSAGE()
BEGIN TRANSACTION
DELETE FROM wi_w WHERE grpid = tcGrp
IF EMPTY(pcWiErr)
	END TRANSACTION
	llOk = .T.
ELSE
	ROLLBACK
	llOk = .F.
ENDIF
ON ERROR &lcOldErr
USE IN wi_w
IF !llOk
	=MESSAGEBOX("Could not delete the issue:" + CHR(13) + pcWiErr, 48, "Split by SqMt")
ENDIF
RETURN llOk


* End of SPLIT ISSUE BY SQMT
