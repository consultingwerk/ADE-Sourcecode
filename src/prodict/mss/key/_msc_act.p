
/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _mss_act.p

Description:   
   This file contains the form for activation and deactivation of Foreign Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/admnhlp.i }
{prodict/user/uservar.i}

DEFINE {1} BUTTON OK_BUT  
     LABEL "OK" 
     SIZE 13 BY 1.

DEFINE {1} BUTTON CANCEL_BUT 
     LABEL "Cancel" 
     SIZE 13 BY 1.

DEFINE {1} BUTTON HELP_BUT 
     LABEL "Help" 
     SIZE 13 BY 1.
     
&IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL FGCOLOR 7
     SIZE 53 BY 1.4. 
&ENDIF.
     
DEFINE VARIABLE RADIO-SET-1 AS char 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Activate", "1",
          "Deactivate", "2"
     SIZE 32 BY 1.91 NO-UNDO.
     
DEFINE {1} VARIABLE Constrainttype AS CHARACTER FORMAT "X(12)":U 
     LABEL "Constraint type  ." 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "ALL","PRIMARY","CLUSTERED","UNIQUE","FOREIGN KEY","DEFAULT", "CHECK" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.
  

DEFINE FRAME DEFAULT-FRAME
     RADIO-SET-1 AT ROW 1.4 COL 4 NO-LABEL WIDGET-ID 2
     Constrainttype AT ROW 4.05 COL 20 COLON-ALIGNED WIDGET-ID 6
     OK_BUT AT ROW 6.5 COL 3 WIDGET-ID 8
     CANCEL_BUT AT ROW 6.5 COL 17 WIDGET-ID 10
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  HELP_BUT AT ROW 6.5 COL 40 &ENDIF
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-1 AT ROW 6.3 COL 2 &ENDIF    
     WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 57 BY 10.05 WIDGET-ID 100
     VIEW-AS DIALOG-BOX TITLE "Activate/Deactivate Constraint Definitions".


ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME  
DO:
    APPLY "END-ERROR" TO FRAME DEFAULT-FRAME .
END.

ON CHOOSE OF OK_BUT IN FRAME DEFAULT-FRAME
  DO:     
       IF user_dbtype    NE "MSS" then 
	   RUN SAVE.
	   RUN CHECK_DEL.	  
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
                              INPUT {&DataServer_Activate_Deactivate_Constraint_Definitions_Dialog_Box}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

RADIO-SET-1 = RADIO-SET-1:screen-value.

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.


PROCEDURE enable_UI :

  DISPLAY Constrainttype RADIO-SET-1 OK_BUT CANCEL_BUT 
  WITH FRAME DEFAULT-FRAME.
  ASSIGN Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "ALL".
  ENABLE Constrainttype RADIO-SET-1 OK_BUT CANCEL_BUT
          &IF "{&WINDOW-SYSTEM}" <> "TTY"
          &THEN HELP_BUT  
          &ENDIF          
      WITH FRAME DEFAULT-FRAME.
 
END PROCEDURE.

PROCEDURE SAVE:
    
   IF  Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME = "ALL"  THEN
   DO:
       FOR EACH DICTDB._constraint EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN 
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
    
   IF  Constrainttype:SCREEN-VALUE="PRIMARY"  THEN
   DO:
       FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "P" OR DICTDB._constraint._con-type = "PC" 
                     OR DICTDB._constraint._con-type = "MP" :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN   
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.  
     
   IF Constrainttype:SCREEN-VALUE= "UNIQUE" THEN
   DO:
       FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "U" EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN  
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
   
   IF Constrainttype:SCREEN-VALUE= "CLUSTERED" THEN
   DO:
       FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "M" EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN  
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
   
   IF Constrainttype:SCREEN-VALUE= "CHECK"  THEN
   DO:
       FOR EACH DICTDB._constraint WHERE DICTDB._constraint._con-type = "C" EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN  
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
    
   IF Constrainttype:SCREEN-VALUE= "DEFAULT"  THEN
   DO:
       FOR EACH DICTDB._constraint WHERE  DICTDB._constraint._con-type = "D"  EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN 
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
 
   IF Constrainttype:SCREEN-VALUE= "FOREIGN KEY"  THEN 
   DO:
       FOR EACH DICTDB._constraint WHERE  DICTDB._constraint._con-type = "F"  EXCLUSIVE-LOCK :
          IF RADIO-SET-1:screen-value = "1" THEN         
	          assign DICTDB._constraint._con-active = true.
         
          ELSE IF RADIO-SET-1:screen-value = "2" THEN  
	          assign DICTDB._constraint._con-active = False.
	   END.
   END.
   
END PROCEDURE.

PROCEDURE CHECK_DEL:

    FOR EACH DICTDB._constraint WHERE ( DICTDB._constraint._Con-Status = "O" OR  DICTDB._constraint._Con-Status = "D"):
        ASSIGN DICTDB._constraint._con-active = False.
    END.    
END.
