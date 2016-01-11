/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: constraint.i

Description:   
   This file contains the form defination for creation of Constraints.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/ora/key/foreign.i }

&Scoped-define SELF-NAME Constrainttype

 
  ON VALUE-CHANGED OF Constrainttype IN FRAME DEFAULT-FRAME
  DO:
      RUN TEMP1.
      RUN FILL_TEMP2.
      IF Constrainttype:SCREEN-VALUE="PRIMARY" THEN
      DO:
         RUN primary.                 
      END.          
      
      IF Constrainttype:SCREEN-VALUE="FOREIGN KEY" THEN
      DO:
           RUN foreign.
      END. 
      
      IF Constrainttype:SCREEN-VALUE="UNIQUE" THEN
      DO:  
           RUN unique.
      END.

      IF Constrainttype:SCREEN-VALUE="CHECK" THEN
      DO:  
         RUN check.    
      END.      


  END.

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME frame_primary OR HELP OF FRAME frame_unique OR HELP OF FRAME frame_foreign  OR HELP OF FRAME frame_check
  OR CHOOSE of HELP_BUT IN FRAME frame_primary  OR CHOOSE of HELP_BUT IN FRAME frame_unique 
  OR CHOOSE of HELP_BUT IN FRAME frame_foreign  OR CHOOSE of HELP_BUT IN FRAME frame_check
 DO:
    RUN adecomm/_adehelp.p (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&ORACLE_DatatServer_Create_Constraints_Dialog}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME  
DO:
    APPLY "END-ERROR" TO FRAME frame_primary.
    APPLY "END-ERROR" TO FRAME frame_unique.
    APPLY "END-ERROR" TO FRAME frame_foreign.
    APPLY "END-ERROR" TO FRAME frame_check.
END.  

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
  ASSIGN Constrainttype:SCREEN-VALUE IN FRAME DEFAULT-FRAME ="PRIMARY".
  ENABLE Constrainttype 
      WITH FRAME DEFAULT-FRAME. 
  RUN TEMP1.
  RUN primary. 
 

END PROCEDURE.
           

PROCEDURE Create_Const_Name:
 DEF VAR L_Idx_Type as CHAR No-UNDO.
 DEF VAR N_Idx_Type as CHAR No-UNDO.
 DEF VAR L_Idx_Type1 as CHAR No-UNDO.
 DEF VAR N_Idx_Type1 as CHAR No-UNDO.
 L_Idx_Type = Constrainttype:screen-value in frame DEFAULT-FRAME.
 IF L_Idx_Type = "Primary" THEN
    Assign L_Idx_Type = "_PKC_"
           N_Idx_Type = "P".
           
  IF L_Idx_Type = "Unique" THEN
    Assign L_Idx_Type = "_UKC_"
           N_Idx_Type = "U".
 
   IF L_Idx_Type = "Check" THEN
    Assign L_Idx_Type = "_CC_"
           N_Idx_Type = "C".

   IF L_Idx_Type = "FOREIGN KEY" THEN
     Assign L_Idx_Type = "_FKC_"
           N_Idx_Type = "F".


 IF N_Idx_Type = "F" THEN 
    L_Idx_Type = L_Idx_Type +  Par_Idx + "-" + Selected_Idx + "-" + "idx".
 ELSE
    L_Idx_Type = L_Idx_Type + c_table_name + "-" + Selected_Idx + "-" + "idx". 
 IF N_Idx_Type = "P" THEN
   ASSIGN name:SCREEN-VALUE IN FRAME frame_primary = L_Idx_Type.
  
 IF N_Idx_Type = "U" THEN
   ASSIGN name:SCREEN-VALUE IN FRAME frame_unique = L_Idx_Type.
   
 IF N_Idx_Type = "C" THEN
   ASSIGN name:SCREEN-VALUE IN FRAME frame_check = L_Idx_Type. 
  
  IF N_Idx_Type = "F" THEN
   ASSIGN name:SCREEN-VALUE IN FRAME frame_foreign = L_Idx_Type. 
   
  &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_check ="".
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_foreign ="".
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_primary ="".  
  ASSIGN msg:SCREEN-VALUE IN FRAME frame_unique ="".   
  &ENDIF
END PROCEDURE.
