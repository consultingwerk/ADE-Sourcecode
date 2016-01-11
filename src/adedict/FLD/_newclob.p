/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************
 
   FILE: _newclob.p
   
   Description:
     Procedure used in creating a new clob Field.
     
   Created: June 4, 2003  D. McMann
   History: 07/14/03 D. McMann Added assignment of _I or _S to collation 
            08/27/03 D. McMann Changes logic for size to 1B - 1G
            10/17/03 D. McMann Add NO-LOCK statement to _Db find in support of on-line schema add
            10/21/03 D. McMann Remove UCS2 from code page selection list
---------------------------------------------------------------------------- */
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adecomm/commeng.i}
{adecomm/adestds.i}

Define button btn_Ok     label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

Define rectangle rect_Btns {&STDPH_OKBOX}.
Define button    btn_Help label "&Help" {&STDPH_OKBTN}.

&SCOPED-DEFINE VM_WIDG 0.33

Define SHARED buffer  b_Field for _Field. 

    /*If user select CLOB we need different information such
      as area to store the clob and initial size.  Here are the variables for
      the selection list 
    */
DEFINE BUTTON s_btn_clob_Area IMAGE-UP FILE "btn-down-arrow".
DEFINE SHARED VARIABLE s_clob_Area AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE SHARED VARIABLE s_lst_clob_Area AS CHARACTER
      VIEW-AS SELECTION-LIST SINGLE
      INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_cp IMAGE-UP FILE "btn-down-arrow".
DEFINE SHARED VARIABLE s_clob_cp AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE SHARED VARIABLE s_lst_clob_cp AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE BUTTON s_btn_clob_col IMAGE-UP FILE "btn-down-arrow".
DEFINE SHARED VARIABLE s_clob_col AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE SHARED VARIABLE s_lst_clob_col AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SORT
     INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE VARIABLE bnum      AS INTEGER                   NO-UNDO.
DEFINE VARIABLE clob-size AS CHARACTER INITIAL "100M" NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.
DEFINE VARIABLE wdth      AS DECIMAL                   NO-UNDO.
DEFINE VARIABLE hldcp     AS CHARACTER                 NO-UNDO.
DEFINE VARIABLE i         AS INTEGER                   NO-UNDO.

DEFINE FRAME newcfld.

FORM
  SKIP({&VM_WID})  
  s_clob_Area LABEL "&Area" COLON 18 {&STDPH_FILL} s_btn_clob_area
   SKIP({&VM_WID})

  clob-size LABEL "&Max Size" FORMAT "x(10)" colon 18 {&STDPH_FILL}
   SKIP({&VM_WID})

  b_Field._Order label "&Order #"        colon 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  b_Field._Fld-case LABEL "Case &Sensitive" COLON 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  s_clob_cp LABEL "&Code Page" COLON 18 {&STDPH_FILL} s_btn_clob_cp
   SKIP({&VM_WID})

  s_clob_col LABEL "Co&llation" COLON 18 {&STDPH_FILL} s_btn_clob_col
   SKIP({&VM_WID})

 
    s_lst_clob_Area      NO-LABEL                at col 1 row 5.4
    s_lst_clob_cp        NO-LABEL                at col 1 row 5.4
    s_lst_clob_col       NO-LABEL                AT COL 1 ROW 5.4

   {adecomm/okform.i
      &BOX = "rect_btns"
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help
   }

  with FRAME newcfld 
  VIEW-AS DIALOG-BOX THREE-D  
  SIDE-LABELS ROW 4 COLUMN 10 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Clob Field Attributes".


/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame newcfld
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME newcfld) THEN
         LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			INT(b_Field._Order:SCREEN-VALUE IN FRAME newcfld) AND
			_Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
	 TRIM(b_Field._Order:SCREEN-VALUE IN FRAME newcfld) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME newcfld = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.
 
/* The size will be in bytes since it is used for allocating size
   and you can't determine characters without actually reading
   the data */
ON LEAVE OF clob-size IN FRAME newcfld 
DO:
  ASSIGN clob-size = CAPS(INPUT FRAME newcfld clob-size).
  IF INDEX(clob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(clob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(clob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(clob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(clob-size, LENGTH(clob-size), 1)) <> 0 THEN DO:
    MESSAGE "Size of clob must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    clob-size:SCREEN-VALUE IN FRAME newcfld = "100M".
    RETURN NO-APPLY.
  END.    
  ELSE
    ASSIGN size-type = "B"
           clob-size = clob-size + "B"
           clob-size:SCREEN-VALUE IN FRAME newcfld = clob-size.

  CASE size-type:    
    WHEN "K" THEN 
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(clob-size, 1, (INDEX(clob-size, "K") - 1))))
               wdth = (wdth * 1024).
    
    WHEN "M" THEN 
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(clob-size, 1, (INDEX(clob-size, "M") - 1))))
               wdth = (wdth * (1024 * 1024)).

    WHEN "G" THEN 
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(clob-size, 1, (INDEX(clob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024) - 1).
    OTHERWISE 
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(clob-size, 1, (INDEX(clob-size, "B") - 1)))).   
  END CASE.

  IF wdth < 1 OR wdth > 1073741823 THEN DO:
    MESSAGE "Size of clob must be between 1B and 1G" SKIP
                "The default value is 100M" SKIP
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
       clob-size:SCREEN-VALUE IN FRAME newcfld = "100M".
    RETURN NO-APPLY.
  END.
END.

/* When code page changes, we need to redo the collations that belong to that
   code page.  adecomm/cbtdrop.i applys U1 to this variable.
*/   

ON "U1" OF s_clob_cp IN FRAME newcfld
DO:
    IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
      ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
             s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
      DO i = 1 TO NUM-ENTRIES(hldcp):
        IF i = 1 THEN
          ASSIGN s_clob_col = ENTRY(i, hldcp)
                 s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
          s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN FRAME newcfld.
      END.
    END.
    ELSE 
      ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
             s_lst_clob_col:LIST-ITEMS IN FRAME newcfld = ""
             s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation").
    RETURN.
END.

ON LEAVE OF s_clob_cp IN FRAME newcfld DO:
  ASSIGN s_lst_clob_col:LIST-ITEMS IN FRAME newcfld = "".
  IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN DO:
    ASSIGN hldcp = GET-COLLATIONS(s_clob_cp:SCREEN-VALUE)
           s_clob_cp = s_clob_cp:SCREEN-VALUE.
         
    DO i = 1 TO NUM-ENTRIES(hldcp):
      IF i = 1 THEN
        ASSIGN s_clob_col = ENTRY(i, hldcp)
               s_clob_col:SCREEN-VALUE = ENTRY(i, hldcp).
        s_res = s_lst_clob_col:ADD-LAST(ENTRY(i, hldcp)) IN FRAME newcfld.
    END.
  END.
  ELSE DO:
    ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
       s_lst_clob_col:LIST-ITEMS IN FRAME newcfld = ""
       s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation")
       s_clob_col:SCREEN-VALUE = "*Use DB Collation" .
     
  END.
  RETURN.
END.

ON GO OF FRAME newcfld DO: 
  Define var no_name  as logical NO-UNDO.
  Define var obj      as char 	  NO-UNDO.
  Define var ins_name as char    NO-UNDO.
  Define var ix       as integer NO-UNDO.
   
  IF _Db._Db-xl-name = "undefined" AND 
    s_clob_cp:SCREEN-VALUE = "*Use DB Code Page"  THEN DO:
      MESSAGE "The database code page is 'undefined' " SKIP
              "A clob cannot be defined with this code page." SKIP(1)
              "Select a code page other than 'Use DB Code Page'." SKIP
          VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
  END.
  
  FIND _Area WHERE _Area._Area-name = s_clob_area:SCREEN-VALUE IN FRAME newcfld NO-ERROR.
  IF AVAILABLE _Area THEN DO:
    ASSIGN b_field._Fld-stlen = _Area._Area-number
           b_Field._Width = wdth
           b_Field._Data-Type = "CLOB"
           b_Field._Fld-Misc2[1] = CAPS(INPUT FRAME newcfld clob-size)           
           INPUT FRAME newcfld b_Field._Fld-case
           INPUT FRAME newcfld b_Field._Order.  

    IF s_clob_cp:SCREEN-VALUE <> "*Use DB Code Page" THEN
      ASSIGN b_Field._Charset = INPUT FRAME newcfld s_clob_cp:SCREEN-VALUE
             b_Field._Collation = INPUT FRAME newcfld s_clob_col:SCREEN-VALUE
             b_Field._Attributes1 = 2. 
    ELSE 
      ASSIGN b_Field._Charset = _Db._Db-xl-name
             b_Field._Collation = _Db._Db-coll-name
             b_Field._Attributes1 = 1. 

   IF b_field._Initial <> ? THEN
       ASSIGN b_field._Initial = ?.

    RETURN "ADDED".
  END.  
end.

ON 'choose':U OF btn_cancel
DO:
    HIDE FRAME newcfld NO-PAUSE.
    RETURN "cancel".
END.

/*----- HELP -----*/
on HELP of frame newcfld OR choose OF btn_Help in frame newcfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Clob_Field_Att_Dlg_Box}, ?).

/* -------------------------- Main Line Code ------------------------------*/  


/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame newcfld" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
FIND DICTDB._File where RECID(_File) = s_TblRecId.
FIND DICTDB._Db WHERE RECID(_Db) = DICTDB._File._Db-recid NO-LOCK.

s_lst_clob_area:list-items in frame newcfld = "".

FIND DICTDB._Area WHERE DICTDB._Area._Area-num = _File._ianum.
ASSIGN s_clob_Area = DICTDB._Area._Area-name.
  
FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                        AND DICTDB._Area._Area-type = 6 NO-LOCK:
   IF DICTDB._Area._Area-name = s_Clob_Area THEN
     s_res = s_lst_clob_Area:ADD-FIRST(DICTDB._Area._Area-name) in frame newcfld.
   ELSE
     s_res = s_lst_clob_Area:add-last(DICTDB._Area._Area-name) in frame newcfld.
END.

FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
ASSIGN s_res = s_lst_clob_Area:add-last(DICTDB._Area._Area-name) in frame newcfld
       bnum = s_lst_clob_Area:num-items in frame newcfld
        s_Lst_clob_Area:inner-lines in frame newcfld = (if bnum <= 5 then bnum else 5). 

ASSIGN s_clob_cp = "*Use DB Code Page"
       hldcp = GET-CODEPAGES
       s_lst_clob_cp:LIST-ITEMS IN FRAME newcfld = ""
       s_res = s_lst_clob_cp:ADD-FIRST(s_clob_cp) IN FRAME newcfld.

DO i = 1 TO NUM-ENTRIES(hldcp):
    IF ENTRY(i, hldcp) <> "undefined" AND 
       ENTRY(i, hldcp) <> "UCS2"      AND 
       ENTRY(i, hldcp) <> "GB18030"   THEN
      s_res = s_lst_clob_cp:ADD-LAST(ENTRY(i, hldcp)) in frame newcfld.
END.

ASSIGN s_clob_col = DICTDB._DB._Db-coll-name
       s_lst_clob_col:LIST-ITEMS IN FRAME newcfld = ""
       s_res = s_lst_clob_col:ADD-FIRST("*Use DB Collation").

   /* fill Area combo box */
 {adecomm/cbdrop.i &Frame  = "frame newcfld"
      	       	  &CBFill = "s_clob_Area"
      	       	  &CBList = "s_lst_clob_Area"
      	       	  &CBBtn  = "s_btn_clob_Area"
     	       	  &CBInit = """"}

ASSIGN
    s_Res = s_lst_clob_area:MOVE-AFTER-TAB-ITEM
       (s_btn_clob_area:HANDLE IN FRAME newcfld) IN FRAME newcfld
    clob-size = "100M"
    wdth = 104857600.
     
   /* fill code page combo box */
 {adecomm/cbdrop.i &Frame  = "frame newcfld"
      	       	  &CBFill = "s_clob_cp"
      	       	  &CBList = "s_lst_clob_cp"
      	       	  &CBBtn  = "s_btn_clob_cp"
     	       	  &CBInit = """"}

ASSIGN
    s_Res = s_lst_clob_cp:MOVE-AFTER-TAB-ITEM
       (s_btn_clob_cp:HANDLE IN FRAME newcfld) IN FRAME newcfld.

 /* fill collation combo box */
 {adecomm/cbdrop.i &Frame  = "frame newcfld"
      	       	  &CBFill = "s_clob_col"
      	       	  &CBList = "s_lst_clob_col"
      	       	  &CBBtn  = "s_btn_clob_col"
     	       	  &CBInit = """"}

ASSIGN
    s_Res = s_lst_clob_col:MOVE-AFTER-TAB-ITEM
       (s_btn_clob_col:HANDLE IN FRAME newcfld) IN FRAME newcfld.

 DISPLAY s_clob_Area 
         clob-size
         b_Field._Order
         b_Field._Fld-case
         s_clob_cp
        s_clob_col
      WITH FRAME newcfld.

 

 ENABLE s_clob_area
        s_btn_clob_area
        clob-size
        b_Field._Order
        b_Field._Fld-case
        s_clob_cp
        s_btn_clob_cp
        s_clob_col
        s_btn_clob_col 
        btn_OK
        btn_cancel
        btn_help
       WITH FRAME newcfld.

 wait-for choose of btn_OK in frame newcfld,
                    btn_Cancel IN FRAME newcfld
                     OR GO of frame newcfld
      	       FOCUS s_clob_area in frame newcfld.


hide frame newcfld.
hide message no-pause.
