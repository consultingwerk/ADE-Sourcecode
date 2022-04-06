/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*
-------------------------------------------------------------------------------
FIELD-TRIGGERS:

                                                               Override- Check
             Trigger Programs                                  able      CRC?
             ------------------------------------------------  -----     -----
 for ASSIGN: ________________________________________________  ___       __ 

       	      (press [PUT] to edit trigger source)
-------------------------------------------------------------------------------

dfields contains buffer for field that triggers belong to.

   Input Parameters:
      p_romode  - True if we're in read-only mode.
      p_tblname - Name of the table this field belongs to.      

   Input-Output Parameters:
      p_Check   - Do we check trigger syntax or not.  New setting will
      	       	  be returned so this is sticky for editing session.

   Output Parameters:
      p_changed - set to true if triggers were added/modified/deleted.
      
   Modified:  01/31/03 D. McMann Assign triggers can not be created for Blob fields.      
              07/28/03 D. McMann Block CLOB Fields
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE INPUT   	     PARAMETER p_romode   AS LOGICAL   NO-UNDO.
DEFINE INPUT   	     PARAMETER p_tblname  AS CHARACTER NO-UNDO. 
DEFINE INPUT-OUTPUT  PARAMETER p_Check 	  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT  	     PARAMETER p_changed  AS LOGICAL   NO-UNDO.

DEFINE SHARED BUFFER dfields FOR _Field.
DEFINE	      BUFFER ft      FOR _Field-Trig.

DEFINE VARIABLE pname	    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE override    AS LOGICAL 	  NO-UNDO.
DEFINE VARIABLE crc	    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE event	    AS CHARACTER  NO-UNDO init "Assign". 
DEFINE VARIABLE compfile    AS CHARACTER  NO-UNDO init "".
DEFINE VARIABLE do-get	    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE go-key	    AS INTEGER    NO-UNDO.
DEFINE VARIABLE old_crc_val AS INTEGER    NO-UNDO.
DEFINE VARIABLE new_crc_val AS INTEGER    NO-UNDO.


FORM
  "Override-"	      at 62 view-as TEXT
  "Check"	      at 73 view-as TEXT SKIP 
  "Trigger Programs"  at 14 view-as TEXT  
  "able?"	      at 62 view-as TEXT 
  "CRC?"	      at 73 view-as TEXT SKIP(1)

  pname    at 2  FORMAT "x(45)" LABEL "For ASSIGN" 
  override at 62 NO-LABEL 
  crc      at 73 NO-LABEL SKIP

  SPACE(12) "(removing the trigger file name deletes the trigger)" SKIP(1)
  SPACE(12) do-get FORMAT "x(45)" NO-LABEL
  {prodict/user/userbtns.i}
  WITH FRAME fldtrig
    SIDE-LABELS DEFAULT-BUTTON btn_OK SCROLLABLE
    VIEW-AS DIALOG-BOX  TITLE "Field Triggers".


/*------------------------------Triggers---------------------------------*/

/*----- PUT (Edit Trigger) -----*/
ON PUT OF pname IN FRAME fldtrig, 
      	  override IN FRAME fldtrig,
      	  crc IN FRAME fldtrig
DO:
  pname:SCREEN-VALUE IN FRAME fldtrig = 
      TRIM(pname:SCREEN-VALUE IN FRAME fldtrig).

  RUN "prodict/user/_usrtrig.p"
    (INPUT INPUT FRAME fldtrig pname, 
     INPUT event,
     INPUT p_tblname,  
     INPUT dfields._Field-Name,
     INPUT no,
     INPUT-OUTPUT new_crc_val,
     INPUT-OUTPUT p_Check).
END.


/*---- GO ----*/
ON GO OF FRAME fldtrig
DO:
  pname:SCREEN-VALUE IN FRAME fldtrig = 
      TRIM(pname:SCREEN-VALUE IN FRAME fldtrig).

   p_changed = no.
   {prodict/user/usertrig.i
      &Frame	   = "FRAME fldtrig"
      &pname	   = pname
      &override	   = override
      &crc	   = crc
      &new_crc_val = new_crc_val
      &old_crc_val = old_crc_val
      &changed 	   = p_changed}

   DO ON ERROR UNDO, LEAVE:
      /* replace altered trigger definitions */
      IF p_changed THEN DO:
      	 IF (pname = "" OR pname = ?) AND AVAILABLE ft THEN
      	    DELETE ft.
      	 ELSE DO:
      	    /* Progress doesn't let you modify a trigger record, so delete 
               and recreate. */
      	    IF AVAILABLE ft then DELETE ft.
      	    CREATE ft.
      	    ASSIGN
               ft._File-Recid = drec_File
               ft._Field-Recid = RECID(dfields)
               ft._Event = event
               ft._Proc-Name = pname
               ft._Override  = INPUT FRAME fldtrig override
      	       ft._Trig-CRC = (IF INPUT FRAME fldtrig crc 
      	       	     	       THEN new_crc_val ELSE ?).
      	 END.
      END.
      RETURN.
   END.

   /* There was an error */
   RETURN NO-APPLY.
END.
 

/*--------------------------Mainline code--------------------------------*/
IF dfields._Data-type = "Blob" THEN DO:
    MESSAGE "Triggers can not be created for Blob fields."
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.
ELSE IF dfields._Data-type = "Clob" THEN DO:
    MESSAGE "Triggers can not be created for Clob fields."
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

/* There should only be one there. */
FIND FIRST ft where ft._Field-Recid = RECID(dfields) AND ft._Event = event
   NO-ERROR.

ASSIGN
  do-get = "(press [" + KBLABEL("PUT") + "] to edit trigger program)"
  do-get = FILL(" ",45 - LENGTH(do-get)) + do-get 
  go-key = KEYCODE(KBLABEL("GO")).

if NOT AVAILABLE ft THEN
  ASSIGN
    pname = ""
    override = no
    crc = yes
    old_crc_val = ?.
ELSE
  ASSIGN
    pname = ft._Proc-Name
    override = ft._Override
    crc = (if ft._Trig-CRC = ? then no else yes)
    old_crc_val = ft._Trig-CRC.

new_crc_val = old_crc_val.

/* Adjust ok and cancel buttons */
{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME fldtrig"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}

DISPLAY
  pname override crc
  do-get WHEN NOT p_romode
  WITH FRAME fldtrig.

UPDATE
  pname    WHEN NOT p_romode
  override WHEN NOT p_romode
  crc      WHEN NOT p_romode
  btn_OK   WHEN NOT p_romode
  btn_Cancel
  WITH FRAME fldtrig.

HIDE FRAME fldtrig.



