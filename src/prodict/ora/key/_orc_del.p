
/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _orc_del.p

Description:   
   This file contains the form for the deletion of Foreign Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/admnhlp.i }

DEFINE BUTTON OK_BUT 
     LABEL "OK" 
     SIZE 13 BY 1.

DEFINE BUTTON CANCEL_BUT 
     LABEL "Cancel" 
     SIZE 13 BY 1.

DEFINE BUTTON HELP_BUT 
     LABEL "Help" 
     SIZE 13 BY 1.

&IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL FGCOLOR 7
     SIZE 53 BY 1.4. 
&ENDIF.

DEFINE VARIABLE ans AS logical.
DEFINE STREAM   constlog.
DEFINE VARIABLE cnstrpt_name       AS CHARACTER   NO-UNDO.
DEFINE BUFFER   CON_DICTDB         FOR DICTDB._Constraint.

DEFINE {1} VARIABLE Constrainttype AS CHARACTER FORMAT "X(12)":U 
     LABEL "Constraint type  ." 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "ALL","PRIMARY","UNIQUE","FOREIGN KEY","CHECK"
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE FRAME DEFAULT-FRAME
   
     Constrainttype AT ROW 2 COL 20 COLON-ALIGNED WIDGET-ID 6
     OK_BUT  AT ROW 5.5 COL 3 WIDGET-ID 8
     CANCEL_BUT AT ROW 5.5 COL 17 WIDGET-ID 10
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  HELP_BUT AT ROW 5.5 COL 40 &ENDIF  
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-1 AT ROW 5.3 COL 2 &ENDIF  
     WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57 BY 8.05 WIDGET-ID 100
     VIEW-AS DIALOG-BOX TITLE "Delete Constraint Definitions".

ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME  
DO:
    APPLY "END-ERROR" TO FRAME DEFAULT-FRAME .
END.

ON CHOOSE OF OK_BUT IN FRAME DEFAULT-FRAME
  DO:          
	   RUN SAVE.
       APPLY "END-ERROR" TO FRAME DEFAULT-FRAME .
  END.
  
ON CHOOSE OF CANCEL_BUT IN FRAME DEFAULT-FRAME
  DO:     
       APPLY "END-ERROR" TO FRAME DEFAULT-FRAME .
  END.   


/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME DEFAULT-FRAME OR CHOOSE OF HELP_BUT IN FRAME DEFAULT-FRAME
 DO:   
    RUN adecomm/_adehelp.p (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&ORACLE_DataServer_Delete_Constraints_Dialog_Box}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


PROCEDURE enable_UI :
  DISPLAY  Constrainttype 
      WITH FRAME DEFAULT-FRAME.
      ASSIGN Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "ALL".
  
  ENABLE Constrainttype OK_BUT CANCEL_BUT 
          &IF "{&WINDOW-SYSTEM}" <> "TTY"
          &THEN HELP_BUT  
          &ENDIF            
      WITH FRAME DEFAULT-FRAME.
 
END PROCEDURE.

PROCEDURE SAVE:

ASSIGN cnstrpt_name = "constraint.lg".
OUTPUT STREAM constlog TO VALUE(cnstrpt_name) UNBUFFERED APPEND NO-ECHO NO-MAP.

  IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "ALL"  
  THEN DO :
    MESSAGE "Are you sure you want to delete all constraints from database ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
      IF ans = YES THEN
        FOR EACH DICTDB._constraint WHERE (DICTDB._constraint._con-type <> "D" AND DICTDB._constraint._con-type <> "M") EXCLUSIVE-LOCK :
            DELETE DICTDB._constraint.
	    END.
  END.
  
  IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "PRIMARY"
  THEN DO :
    MESSAGE "Are you sure you want to delete all Primary constraint(s) from database ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
      IF ans = YES THEN
         FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "PC" 
              OR DICTDB._constraint._con-type = "P" OR DICTDB._constraint._con-type = "MP" EXCLUSIVE-LOCK :
            IF CAN-FIND (FIRST CON_DICTDB WHERE CON_DICTDB._Index-Parent-Recid = DICTDB._Constraint._Index-Recid 
                        AND (CON_DICTDB._Con-Status <> "O" AND CON_DICTDB._Con-Status <> "D"))
            THEN          
              PUT STREAM constlog UNFORMATTED " cannot delete constraint " + DICTDB._constraint._con-Name + " as it is referenced by a foreign key"  SKIP.
            ELSE   
	          DELETE DICTDB._constraint.
         END.
  END.
  
  IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "UNIQUE"
  THEN DO :
    MESSAGE "Are you sure you want to delete all Unique constraint(s) from database ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
      IF ans = YES THEN
         FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "U" EXCLUSIVE-LOCK :
            IF CAN-FIND (FIRST CON_DICTDB WHERE CON_DICTDB._Index-Parent-Recid = DICTDB._Constraint._Index-Recid 
                     AND (CON_DICTDB._Con-Status <> "O" OR CON_DICTDB._Con-Status <> "D"))
            THEN          
              PUT STREAM constlog UNFORMATTED " cannot delete constraint " + DICTDB._constraint._con-Name + " as it is referenced by a foreign key"  SKIP.
            ELSE   
	          DELETE DICTDB._constraint.
         END.
  END. 

  IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "CHECK"
  THEN DO :
    MESSAGE "Are you sure you want to delete all Check constraint(s) from database ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
      IF ans = YES THEN
         FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "C" EXCLUSIVE-LOCK :
	         DELETE DICTDB._constraint.
         END.
  END.
  
  IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "FOREIGN KEY"
  THEN DO:
    MESSAGE "Are you sure you want to delete all Foreign constraint(s) from database ?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO  update ans.
      IF ans = YES THEN
         FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "F" EXCLUSIVE-LOCK :
	         DELETE DICTDB._constraint.
         END.
  END. 
OUTPUT STREAM constlog  CLOSE.  
END.