/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: modcons.p

Description:   
   This file contains the form for modification Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/
{prodict/ora/key/modforg.i }

&Scoped-define SELF-NAME Constrainttype


ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME  
DO:
    APPLY "END-ERROR" TO FRAME frame_primary.
    APPLY "END-ERROR" TO FRAME frame_unique.
    APPLY "END-ERROR" TO FRAME frame_foreign.
    APPLY "END-ERROR" TO FRAME frame_check.
END.  

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME frame_primary OR HELP OF FRAME frame_unique OR HELP OF FRAME frame_foreign  OR HELP OF FRAME frame_check
  OR CHOOSE of HELP_BUT IN FRAME frame_primary  OR CHOOSE of HELP_BUT IN FRAME frame_unique 
  OR CHOOSE of HELP_BUT IN FRAME frame_foreign  OR CHOOSE of HELP_BUT IN FRAME frame_check
 DO:
    RUN adecomm/_adehelp.p (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&ORACLE_DataServer_View_Modify_Contraint_Properties_Dialog_Box}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
  RUN enable_UI.  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
    
  ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME  
    APPLY "END-ERROR" TO FRAME DEFAULT-FRAME.
  
    
    
END.

PROCEDURE enable_UI :
  DISPLAY Constrainttype 
      WITH FRAME DEFAULT-FRAME.
  ASSIGN Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME =const_type.
    
     RUN TEMP1.
     RUN FILL_TEMP2.
     
     IF  const_type ="PRIMARY" THEN RUN primary.
     IF  const_type ="CHECK" THEN RUN check.
     IF  const_type ="UNIQUE" THEN RUN unique.
     IF  const_type ="FOREIGN KEY" THEN RUN foreign.

   IF cDbType = "MSS" OR cDbType = "ORACLE" THEN DO:
       DISABLE  OK_BUT CREATE_BUT WITH FRAME frame_primary.
       DISABLE  OK_BUT CREATE_BUT WITH FRAME frame_unique.
       DISABLE  OK_BUT CREATE_BUT WITH FRAME frame_foreign.
       DISABLE  OK_BUT CREATE_BUT WITH FRAME frame_check.
   END.  

END PROCEDURE.
           

