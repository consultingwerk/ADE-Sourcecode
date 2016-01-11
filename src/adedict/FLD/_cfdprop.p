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
 
   FILE: _cfdprop.p
   
   Description:
     Displays and handles the changes to a clob, clob, and xlob fields.
     
   Created: January 28, 2003  D. McMann
   History: DLM 07/28/03 Removed display of case sensitive indicator.
            08/27/03 D. McMann Changes logic for size to 1B - 1G
 
---------------------------------------------------------------------------- */


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

{ adedict/FLD/clobvar.i "new shared" }

DEFINE INPUT PARAMETER readonly AS LOGICAL NO-UNDO.

/* Triggers */
ON 'choose':U OF btn_cancel
DO:
   apply "END-ERROR" to frame cfldprop.
END.

/*----- HELP -----*/
on HELP of frame cfldprop OR choose of btn_Help in frame cfldprop
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Clob_Field_Att_Dlg_Box}, ?).

/* Go trigger */
ON GO OF FRAME cfldprop
DO:
  {adedict/forceval.i}  /* force leave trigger to fire */
  RUN adedict/FLD/_saveclb.p.
  
  IF RETURN-VALUE = "error" THEN 
      RETURN NO-APPLY.

  run adedict/_brwgray.p (INPUT NO).  /* For Adjust Width Browser graying */
END.

/* On Leave of _Field-name */
on leave of b_Field._Field-Name in frame cfldprop
do:
   DEFINE VARIABLE p_okay AS LOGICAL NO-UNDO.

   IF b_field._Field-name = INPUT b_Field._Field-name THEN
     RETURN.
   
   IF INPUT b_Field._Field-name  = "" OR
      INPUT b_Field._Field-name  = ? THEN DO:
     MESSAGE "Please enter a name for this field"
   	    VIEW-AS ALERT-BOX ERROR buttons OK.

     ASSIGN b_field._Field-name:SCREEN-VALUE IN FRAME cfldprop = b_Field._Field-name.
     RETURN NO-APPLY.
   END.

   RUN adecomm/_valname.p (INPUT b_field._Field-name:SCREEN-VALUE,
                           INPUT TRUE,
                           OUTPUT p_okay).
   IF p_okay THEN RETURN.
   ELSE RETURN NO-APPLY.
END.

/* On leave of clob-size - calculate new size if necessary */
ON 'leave':U OF clob-size IN FRAME cfldprop
DO:
  ASSIGN clob-size = CAPS(INPUT FRAME cfldprop clob-size).
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
    clob-size:SCREEN-VALUE IN FRAME cfldprop = b_field._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.    
  ELSE 
    ASSIGN size-type = "B"
           clob-size = clob-size + "B"
           clob-size:SCREEN-VALUE IN FRAME cfldprop = clob-size.

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
      clob-size:SCREEN-VALUE IN FRAME cfldprop = b_Field._Fld-Misc2[1].
    RETURN NO-APPLY.
  END.
END.

/*---------- LEAVE OF ORDER FIELD ---------*/
on leave of b_Field._order in frame cfldprop
DO:
  /* Avoid the test if the field hasn't changed */
  IF b_Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME cfldprop) THEN
    LEAVE. 
  /* Is the new order number a duplicate?  Don't allow it.  */
  IF CAN-FIND(FIRST _Field WHERE _Field._File-recid = s_TblRecId AND
              _Field._Order = INT(b_Field._Order:SCREEN-VALUE IN FRAME cfldprop) AND
		      _Field._Order <> b_Field._Order) THEN DO:
    MESSAGE "Order number " +
	  TRIM(b_Field._Order:SCREEN-VALUE IN FRAME cfldprop) "already exists." 
	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	b_Field._Order:SCREEN-VALUE IN FRAME cfldprop = STRING(b_Field._Order).
    RETURN NO-APPLY.
  END.
END.

ON LEAVE OF b_field._Fld-case IN FRAME cfldprop DO: 
  IF b_Field._Fld-case ENTERED THEN
    ASSIGN b_Field._Fld-case = LOGICAL(b_Field._Fld-case:SCREEN-VALUE IN FRAME cfldprop, "YES/NO").
END.

/* ---------------------------Mainline Code --------------------------------*/
/* Find the storage object so that we can see which area the clob is stored
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

ASSIGN s_clob_Area = _Area._Area-name
       clob-size = b_field._Fld-Misc2[1]
       wdth = b_Field._Width.

DISPLAY b_field._Field-name
          s_clob_area 
          clob-size
          b_field._Order 
          b_Field._Fld-case
          b_Field._Charset 
          b_Field._Collation
      WITH FRAME cfldprop.

IF readonly THEN
    PROMPT-FOR btn_cancel WITH FRAME cfldprop.

ELSE
  PROMPT-FOR b_field._Field-name
             clob-size 
             b_field._Order 
             b_field._Fld-case WHEN NOT CAN-FIND(FIRST DICTDB._Index-field WHERE DICTDB._Index-field._Field-recid = RECID(b_field))
             btn_ok
             btn_Cancel
             btn_help
       WITH FRAME cfldprop.

