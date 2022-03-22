/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
   Put up a frame for editing trigger code.

   Input Parameters:
      p_pgm	  - The name of the file to edit which contains trigger code
      p_event	  - The event of the trigger (e.g., "Create")
      p_tname	  - The name of the table that this trigger belongs to or
		    if a field trigger the name of the table the field belongs 
		    to.
      p_fname	  - The name of the field that this trigger belongs to.  
		    This should be "" for a table trigger.    
      p_synfixed  - yes if syntax toggle should be non-changeable - fixed at
      	       	    the input value below or no if user can decide. 
      	       	    (if yes, don't disable the toggle but give an error if 
      	       	     user tries to change it so he knows why)

   Input/Output Parameters:
      p_crc	  - On input, the current crc_value.  On ouput, set to new 
		    crc value if code was compiled successfully.
      p_Check	  - whether to default check syntax to yes or no.  Any new
		    setting is returned.

   History:
   
      tomn      04/96   Removed statement that assigned the screen-value
                        of the editor "tcode" to the underlying variable;
                        When the trigger procedure was large (gt 32K), it
                        would generate error 444.  "tcode" is a local var
                        that is not used in any comparison (as stated). 

---------------------------------------------------------------------------*/

{prodict/user/uservar.i}

DEFINE INPUT	    PARAMETER p_pgm    	  AS CHARACTER NO-UNDO.
DEFINE INPUT	    PARAMETER p_event  	  AS CHARACTER NO-UNDO.
DEFINE INPUT	    PARAMETER p_tname  	  AS CHARACTER NO-UNDO.
DEFINE INPUT	    PARAMETER p_fname  	  AS CHARACTER NO-UNDO.
DEFINE INPUT   	    PARAMETER p_synfixed  AS LOGICAL   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_crc    	  AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_Check  	  AS LOGICAL   NO-UNDO.

DEFINE VARIABLE tcode  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE saved  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE fname  AS CHARACTER   NO-UNDO.

FORM
   tcode view-as EDITOR INNER-CHARS 72 INNER-LINES 13 SCROLLBAR-V  SKIP
   p_check LABEL "Auto Check Syntax" AT 28 VIEW-AS TOGGLE-BOX
   {prodict/user/userbtns.i}
   WITH FRAME trigcode 
   DEFAULT-BUTTON btn_OK
   VIEW-AS DIALOG-BOX TITLE "Trigger Code" NO-LABELS.


/*=============================Triggers=================================*/

ON GO OF FRAME trigcode
DO:
   DEFINE VAR tmpfile AS CHAR NO-UNDO.

   /* Return if user doesn't want to check syntax. */
   ASSIGN p_check.
   IF NOT p_check THEN
      RETURN.

   RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".dct", OUTPUT tmpfile).
   saved = tcode:SAVE-FILE(tmpfile) IN FRAME trigcode.

   /* Try to compile it. */
   COMPILE VALUE(tmpfile) NO-ERROR.
   OS-DELETE VALUE(tmpfile).

   IF COMPILER:ERROR THEN
   DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1)
      	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      tcode:CURSOR-OFFSET IN FRAME trigcode =
        INTEGER(COMPILER:FILE-OFFSET).
      APPLY "ENTRY" TO tcode IN FRAME trigcode.
      RETURN NO-APPLY.
   END.
   ELSE DO:
      RCODE-INFO:FILENAME = tmpfile.
      p_crc = RCODE-INFO:CRC-VALUE.
      MESSAGE "Compiled successfully.".
   END.

   /* Save the file */
   saved = tcode:SAVE-FILE(fname) IN FRAME trigcode.
   IF NOT saved THEN
   DO:
      message "Unable to save trigger code in file."
	       view-as alert-box error buttons ok.
      RETURN NO-APPLY.
   END.
END.

/*----- VALUE-CHANGED of CHECK SYNTAX TOGGLE -----*/
ON VALUE-CHANGED OF p_check IN FRAME trigcode
DO:
   IF p_synfixed THEN
      IF SELF:SCREEN-VALUE = "yes" THEN  /* it was "no" before this trigger */
      DO:
      	 /* explain why compiling is a no-no and reset toggle to no */
      	 { prodict/user/usertrgw.i &widg = SELF }
      END.
      ELSE DO:
      	 MESSAGE "Since you chose to do CRC checking," SKIP
      	       	 "this requires that the trigger code" SKIP
               	 "be compiled before it is saved."
                 view-as ALERT-BOX INFORMATION buttons OK.

      	 SELF:SCREEN-VALUE = "yes".  /* reset to yes */
      END.
END.  


/*=========================Mainline code=================================*/

IF p_pgm = "" OR p_pgm = ? THEN DO:
  HIDE MESSAGE NO-PAUSE.
  MESSAGE "Please enter the filename of a trigger procedure to edit." SKIP
      	  "It will be created if it doesn't exist yet."
      	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* Adjust position of ok and cancel buttons */
{adecomm/okrun.i
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME trigcode"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}

/* Look for this procedure and load it if it's out there. If it's a 
   new file, preset the edit widget for this type of trigger. It will
   be saved in the current directory.
*/
fname = SEARCH(p_pgm).
IF fname = ? THEN fname = p_pgm.
IF tcode:read-file(fname) IN FRAME trigcode = no THEN 
  tcode:screen-value IN FRAME trigcode = 
      "TRIGGER PROCEDURE FOR " + p_Event + " OF " + p_tname + 
    	 (if p_fname <> "" then "." + p_fname else "") + ".".

/* Save in underlying variable for later comparison. */
ASSIGN
/*  tcode = tcode:screen-value IN FRAME trigcode */ /* I don't see where this     */
   tcode:PFCOLOR IN FRAME trigcode = 0.             /* is either used or needed;  */
                                                    /* Removing because it causes */
                                                    /* erc 444 with large files.  */
                                                    /* (tsn 4/96)                 */
DISPLAY p_check WITH FRAME trigcode.

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
  PROMPT-FOR tcode p_check btn_OK btn_Cancel WITH FRAME trigcode.
end.

HIDE FRAME trigcode.




