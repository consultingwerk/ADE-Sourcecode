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
 
   FILE: _newblob.p
   
   Description:
     Procedure used in creating a new Blob Field.
     
   Created: January 28, 2003  D. McMann
   History: 08/27/03 D. McMann Changes logic for size to 1B - 1G
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

    /*If user select BLOB or CLOB we need different information such
      as area to store the blob and initial size.  Here are the variables for
      the selection list 
    */
DEFINE BUTTON s_btn_Blob_Area IMAGE-UP FILE "btn-down-arrow".
DEFINE SHARED VARIABLE s_Blob_Area AS CHARACTER FORMAT "x(32)" NO-UNDO.
DEFINE SHARED VARIABLE s_lst_Blob_Area AS CHARACTER
      VIEW-AS SELECTION-LIST SINGLE
      INNER-CHARS 32 INNER-LINES 5 SCROLLBAR-VERTICAL.

DEFINE VARIABLE bnum      AS INTEGER                   NO-UNDO.
DEFINE VARIABLE blob-size AS CHARACTER INITIAL "100M" NO-UNDO.
DEFINE VARIABLE size-type AS CHARACTER FORMAT "x"      NO-UNDO.
DEFINE VARIABLE wdth      AS DECIMAL                   NO-UNDO.

DEFINE FRAME newbfld.

FORM
  SKIP({&VM_WID})  
  s_Blob_Area LABEL "&Area" COLON 18 {&STDPH_FILL} s_btn_blob_area
   SKIP({&VM_WID})

  blob-size LABEL "&Max Size" FORMAT "x(10)" colon 18 {&STDPH_FILL}
   SKIP({&VM_WID})

  b_Field._Order label "&Order #"        colon 18 {&STDPH_FILL}
    SKIP({&VM_WID})

  {adecomm/okform.i
      &BOX = "rect_btns"
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &HELP   = btn_Help
   }
      
    s_lst_Blob_Area      NO-LABEL                at col 1 row 1

  with FRAME newbfld 
  VIEW-AS DIALOG-BOX THREE-D  
  SIDE-LABELS ROW 4.5 COLUMN 10 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Blob Field Attributes".


/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame newbfld
DO:
      /* Avoid the test if the field hasn't changed */
      IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME newbfld) THEN
         LEAVE. 
      /* Is the new order number a duplicate?  Don't allow it.  */
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = s_TblRecId AND
                        _Field._Order =
			INT(b_Field._Order:SCREEN-VALUE IN FRAME newbfld) AND
			_Field._Order <> b_Field._Order) THEN 
      DO:
	 MESSAGE "Order number " +
	 TRIM(b_Field._Order:SCREEN-VALUE IN FRAME newbfld) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 b_Field._Order:SCREEN-VALUE IN FRAME newbfld = STRING(b_Field._Order).
        RETURN NO-APPLY.
      END.
END.
 
ON LEAVE OF blob-size IN FRAME newbfld 
DO:

  ASSIGN blob-size = CAPS(INPUT FRAME newbfld blob-size).
  IF INDEX(blob-size, "K") <> 0 THEN
    ASSIGN size-type = "K".
  ELSE IF INDEX(blob-size, "M") <> 0 THEN
    ASSIGN size-type = "M".
  ELSE IF INDEX(blob-size, "G") <> 0 THEN
    ASSIGN size-type = "G".
  ELSE IF INDEX(blob-size, "B") <> 0 THEN
    ASSIGN size-type = "B".
  ELSE IF INDEX("ACDEFHIJLNOPQRSTUVWXYZ", SUBSTRING(blob-size, LENGTH(blob-size), 1)) <> 0 THEN DO:
    MESSAGE "Size of blob must be expressed as #B, #K, #M, or #G"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    blob-size:SCREEN-VALUE IN FRAME newbfld = "100M".
    RETURN NO-APPLY.
  END.    
  ELSE 
    ASSIGN size-type = "B"
           blob-size = blob-size + "B"
           blob-size:SCREEN-VALUE IN FRAME newbfld = blob-size.
   
  CASE size-type:
    WHEN "K" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "K") - 1)))).
        ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "M") - 1)))).
        ASSIGN wdth = (wdth * (1024 * 1024)).
    END.
    WHEN "G" THEN
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "G") - 1))))
               wdth = (wdth * (1024 * 1024 * 1024) - 1).
    OTHERWISE
        ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "B") - 1)))). 
  END CASE.

  IF wdth < 1 OR wdth > 1073741823 THEN DO:
    MESSAGE "Size of Blob must be between 1B and 1G" SKIP
               "The default value is 100M" SKIP
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        /* Set size to default 1Mb */
       blob-size:SCREEN-VALUE IN FRAME newbfld = "100M".
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME newbfld DO: 
  Define var no_name  as logical NO-UNDO.
  Define var obj      as char 	  NO-UNDO.
  Define var ins_name as char    NO-UNDO.
  Define var ix       as integer NO-UNDO.
   
  FIND _Area WHERE _Area._Area-name = s_Blob_area:SCREEN-VALUE IN FRAME newbfld NO-ERROR.
  IF AVAILABLE _Area THEN DO:
    ASSIGN b_field._Fld-stlen = _Area._Area-number
           b_Field._Width = wdth
           b_Field._Fld-Misc2[1] = CAPS(INPUT FRAME newbfld blob-size)
           INPUT FRAME newbfld b_Field._Order.
    IF b_field._Initial <> ? THEN
      ASSIGN b_field._Initial = ?.

    RETURN "ADDED".
  END.  
end.

ON 'choose':U OF btn_cancel
DO:
    HIDE FRAME newbfld NO-PAUSE.
    RETURN "cancel".
END.

/*----- HELP -----*/
on HELP of frame newbfld OR choose OF btn_Help in frame newbfld
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Blob_Field_Att_Dlg_Box}, ?).

/* -------------------------- Main Line Code ------------------------------*/  


/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame newbfld" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
FIND _File where RECID(_File) = s_TblRecId.

s_lst_Blob_area:list-items in frame newbfld = "".

FIND DICTDB._Area WHERE DICTDB._Area._Area-num = _File._ianum.
ASSIGN s_Blob_Area = DICTDB._Area._Area-name.
  
FOR EACH DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                        AND DICTDB._Area._Area-type = 6 NO-LOCK:
   IF DICTDB._Area._Area-name = s_Blob_Area THEN
     s_res = s_lst_Blob_Area:ADD-FIRST(DICTDB._Area._Area-name) in frame newbfld.
   ELSE
     s_res = s_lst_Blob_Area:add-last(DICTDB._Area._Area-name) in frame newbfld.
END.
FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
ASSIGN s_res = s_lst_Blob_Area:add-last(DICTDB._Area._Area-name) in frame newbfld
       bnum = s_lst_Blob_Area:num-items in frame newbfld
        s_Lst_Blob_Area:inner-lines in frame newbfld = (if bnum <= 5 then bnum else 5). 


   /* fill Area combo box */
 {adecomm/cbdrop.i &Frame  = "frame newbfld"
      	       	  &CBFill = "s_Blob_Area"
      	       	  &CBList = "s_lst_Blob_Area"
      	       	  &CBBtn  = "s_btn_Blob_Area"
     	       	  &CBInit = """"}

ASSIGN
    s_Res = s_lst_blob_area:MOVE-AFTER-TAB-ITEM
       (s_btn_blob_area:HANDLE IN FRAME newbfld) IN FRAME newbfld
    blob-size = "100M"
    wdth = 104857600.
     

 DISPLAY s_Blob_Area 
         blob-size
         b_Field._Order
      WITH FRAME newbfld.

 

 ENABLE s_Blob_area
        s_btn_Blob_area
        blob-size
        b_Field._Order
        btn_OK
        btn_cancel
        btn_help
       WITH FRAME newbfld.

 wait-for choose of btn_OK in frame newbfld,
                    btn_Cancel IN FRAME newbfld
                     OR GO of frame newbfld
      	       FOCUS s_Blob_area in frame newbfld.


hide frame newbfld.
hide message no-pause.
