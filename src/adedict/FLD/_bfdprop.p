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
 
   FILE: _bfdprop.p
   
   Description:
     Displays and handles the changes to a blob, clob, and xlob fields.
     
   Created: January 28, 2003  D. McMann
   History: 08/27/03 D. McMann Changes logic for size to 1B - 1G
 
---------------------------------------------------------------------------- */


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

{ adedict/FLD/blobvar.i "new shared" }

DEFINE INPUT PARAMETER readonly AS LOGICAL NO-UNDO.

/* Triggers */
ON 'choose':U OF btn_cancel
DO:
   apply "END-ERROR" to frame bfldprop.
END.

/*----- HELP -----*/
on HELP of frame bfldprop OR choose of btn_Help in frame bfldprop
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Blob_Field_Att_Dlg_Box}, ?).

/* Go trigger */
ON GO OF FRAME bfldprop
DO:
  {adedict/forceval.i}  /* force leave trigger to fire */
  RUN adedict/FLD/_saveblb.p.
  
  IF RETURN-VALUE = "error" THEN 
      RETURN NO-APPLY.

  run adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */
END.

/* On Leave of _Field-name */
on leave of b_Field._Field-Name in frame bfldprop
do:
   DEFINE VARIABLE p_okay AS LOGICAL NO-UNDO.

   IF b_field._Field-name = INPUT b_Field._Field-name THEN
     RETURN.
   
   IF INPUT b_Field._Field-name  = "" OR
      INPUT b_Field._Field-name  = ? THEN DO:
     MESSAGE "Please enter a name for this field"
   	    VIEW-AS ALERT-BOX ERROR buttons OK.

     ASSIGN b_field._Field-name:SCREEN-VALUE IN FRAME bfldprop = b_Field._Field-name.
     RETURN NO-APPLY.
   END.

   RUN adecomm/_valname.p (INPUT b_field._Field-name:SCREEN-VALUE,
                           INPUT TRUE,
                           OUTPUT p_okay).
   IF p_okay THEN RETURN.
   ELSE RETURN NO-APPLY.
END.

/* On leave of blob-size - calculate new size if necessary */
ON 'leave':U OF blob-size IN FRAME bfldprop
DO:
  ASSIGN blob-size = CAPS(INPUT FRAME bfldprop blob-size).
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
    blob-size:SCREEN-VALUE IN FRAME bfldprop = b_field._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.    
  ELSE 
    ASSIGN size-type = "B"
           blob-size = blob-size + "B"
           blob-size:SCREEN-VALUE IN FRAME bfldprop = blob-size.

  CASE size-type:
    WHEN "K" THEN DO:
       ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "K") - 1)))).
       ASSIGN wdth = (wdth * 1024).
    END.
    WHEN "M" THEN DO:
       ASSIGN wdth = INTEGER(TRIM(SUBSTRING(blob-size, 1, (INDEX(blob-size, "M") - 1))))
              wdth = (wdth * (1024 * 1024)).
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
      blob-size:SCREEN-VALUE IN FRAME bfldprop = b_Field._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
END.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame bfldprop
DO:
  /* Avoid the test if the field hasn't changed */
  IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME bfldprop) THEN
    LEAVE. 
  /* Is the new order number a duplicate?  Don't allow it.  */
  IF CAN-FIND(FIRST _Field WHERE _Field._File-recid = s_TblRecId AND
              _Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME bfldprop) AND
		      _Field._Order <> b_Field._Order) THEN DO:
    MESSAGE "Order number " +
	  TRIM(b_Field._Order:SCREEN-VALUE IN FRAME bfldprop) "already exists." 
	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	b_Field._Order:SCREEN-VALUE IN FRAME bfldprop = STRING(b_Field._Order).
    RETURN NO-APPLY.
  END.
END.

/* ---------------------------Mainline Code --------------------------------*/
/* Find the storage object so that we can see which area the blob is stored
   in and then find the area to display the name to the user if record has
   been committed.  Else find area using number in _fld-stlen */

IF b_field._Field-rpos <> ? THEN DO:
  FIND _storageobject WHERE _Storageobject._Db-recid = s_DbRecId
                        AND _Storageobject._Object-type = 3
                        AND _Storageobject._Object-number = b_Field._Fld-stlen
                        NO-LOCK.

  FIND _Area WHERE _Area._Area-number = _StorageObject._Area-number NO-LOCK.
END.
ELSE 
  FIND _Area WHERE _Area._Area-number = b_Field._Fld-stlen NO-LOCK.

ASSIGN s_Blob_Area = _Area._Area-name
       blob-size = b_field._Fld-Misc2[1]
       wdth = b_Field._Width.

DISPLAY b_field._Field-name
          s_blob_area 
          blob-size
          b_field._Order WITH FRAME bfldprop.

IF readonly THEN
    PROMPT-FOR btn_cancel WITH FRAME bfldprop.

ELSE
  PROMPT-FOR b_field._Field-name
             blob-size 
             b_field._Order 
             btn_ok
             btn_Cancel
             btn_help
       WITH FRAME bfldprop.

