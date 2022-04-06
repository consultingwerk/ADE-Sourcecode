/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _usershw.p

Description:
   Display the output of an operation (errors etc) in an editor widget.
 
Input:
   user_env[5] MATCHES "*s*" to allow searching ("browse" mode) 
      (NOT CURRENTLY SUPPORTED)
   user_env[6] and user_env[7] contain text for message lines: 
      instructions for use of ok and cancel buttons.
      (If both message lines are null, only the OK button will be shown.)

Input Parameter:
   p_Help - Help context Id

Returns: "ok" or "cancel".
   
Author: Laura Stern

Date Created: 10/02/92

----------------------------------------------------------------------------*/

{ prodict/user/uservar.i }

DEFINE INPUT PARAMETER p_Help AS INTEGER NO-UNDO.
DEFINE VARIABLE sho_file  AS CHARACTER INITIAL ?   NO-UNDO.
DEFINE VARIABLE sho_pages AS CHARACTER EXTENT 1024 NO-UNDO. 
DEFINE VARIABLE sho_limit AS INTEGER               NO-UNDO.
DEFINE VARIABLE sho_title AS CHARACTER             NO-UNDO.
DEFINE VARIABLE only_OK	     AS LOGICAL	     	    NO-UNDO.
DEFINE VARIABLE ix           AS INTEGER             NO-UNDO.
DEFINE VARIABLE stat         AS LOGICAL             NO-UNDO.
DEFINE VARIABLE sho_instruct AS CHARACTER EXTENT 2  NO-UNDO.
DEFINE VARIABLE sho_editor   AS CHARACTER           NO-UNDO
      VIEW-AS EDITOR SIZE 76 BY 10 SCROLLBAR-VERTICAL.

FORM sho_editor      AT 2     	       	     	      SKIP
     sho_instruct[1] AT 2 VIEW-AS TEXT FORMAT "X(70)" SKIP
     sho_instruct[2] AT 2 VIEW-AS TEXT FORMAT "X(70)"
     {prodict/user/userbtns.i} 
     WITH FRAME sho_stuff 
     ROW 3 CENTERED NO-LABELS DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
     VIEW-AS DIALOG-BOX TITLE sho_title.

/*============================= Trigger ==================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame sho_stuff
   or CHOOSE of btn_Help in frame sho_stuff
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT p_Help,
      	       	     	     INPUT ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME sho_stuff
   APPLY "END-ERROR" TO FRAME sho_stuff.

/*========================== Mainline Code ===============================*/

ASSIGN
   sho_instruct[1] = user_env[6]
   sho_instruct[2] = user_env[7].

/* Fill the editor widget with the data (either sho_pages or sho_file) */
IF sho_file = ? THEN
   DO ix = 1 to sho_limit:
      sho_pages[ix] = sho_pages[ix] + CHR(10).
      IF OPSYS = "DOS" THEN
         sho_pages[ix] = sho_pages[ix] + CHR(13).
      stat = sho_editor:insert-string(sho_pages[ix]) IN FRAME sho_stuff.
   END.
ELSE
   stat = sho_editor:read-file(sho_file) IN FRAME sho_stuff.

ASSIGN
   sho_editor:FONT IN FRAME sho_stuff = 0  /* make it a fixed font */
   sho_editor:PFCOLOR IN FRAME sho_stuff = 0
   sho_editor:SENSITIVE IN FRAME sho_stuff = yes  
   sho_editor:READ-ONLY IN FRAME sho_stuff = yes
   only_OK = (IF user_env[6] = "" AND user_env[7] = "" THEN yes ELSE no).

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF only_OK THEN DO:
  btn_Cancel:VISIBLE IN FRAME sho_stuff = no.
  {adecomm/okrun.i  
     &FRAME  = "FRAME sho_stuff" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     &CANCEL =
     {&HLP_BTN}
  }
END.
ELSE DO:
  {adecomm/okrun.i  
     &FRAME  = "FRAME sho_stuff" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
  }
END.

DISPLAY sho_instruct[1] sho_instruct[2] WITH FRAME sho_stuff.
DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   IF only_OK THEN
      UPDATE btn_OK {&HLP_BTN_NAME} WITH FRAME sho_stuff.
   ELSE
      UPDATE btn_OK btn_Cancel {&HLP_BTN_NAME} WITH FRAME sho_stuff.
   HIDE FRAME sho_stuff NO-PAUSE.
   RETURN "ok".
END.

HIDE FRAME sho_stuff NO-PAUSE.
RETURN "cancel".


