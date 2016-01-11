/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: del_con.p

Description:   
   This file contains the procedure for the deletion of a selected constraint.

HISTORY
Author: Kumar Mayur

Date Created:08/05/2011
----------------------------------------------------------------------------*/

{prodict/mss/key/viewmnt.i}

DEFINE STREAM   constlog.
DEFINE VARIABLE cnstrpt_name       AS CHARACTER   NO-UNDO.
DEFINE BUFFER   CON_DICTDB         FOR DICTDB._Constraint.

FIND FIRST DICTDB._File where DICTDB._File._File-Name = c_table_name AND DICTDB._File._Db-Recid = DbRecid EXCLUSIVE-LOCK NO-ERROR.

FOR EACH Dictdb._constraint OF DICTDB._File  WHERE Dictdb._constraint._Con-Name = constr_name AND DICTDB._constraint._Db-Recid = DbRecid
                                EXCLUSIVE-LOCK:

ASSIGN cnstrpt_name = "constraint.lg".
OUTPUT STREAM constlog TO VALUE(cnstrpt_name) UNBUFFERED APPEND NO-ECHO NO-MAP.
  
  IF (DICTDB._Constraint._con-type = "PC" OR DICTDB._Constraint._con-type = "P" OR
                         DICTDB._Constraint._con-type = "U" OR DICTDB._Constraint._con-type = "MP") 
  THEN DO:
   IF CAN-FIND (FIRST CON_DICTDB WHERE CON_DICTDB._Index-Parent-Recid = DICTDB._Constraint._Index-Recid 
                 AND (CON_DICTDB._Con-Status <> "O" AND CON_DICTDB._Con-Status <> "D"))
   THEN DO:
    MESSAGE "Unable to delete as " constr_name " is referenced by a Foreign Key" VIEW-AS ALERT-BOX ERROR.
    PUT STREAM constlog UNFORMATTED " cannot delete constraint " + constr_name + " as it is referenced by a foreign key"  SKIP.
   END. 
   ELSE DO:
     IF Dictdb._constraint._Con-Status  = "N" OR  Dictdb._constraint._Con-Status  = "C"
       THEN DELETE Dictdb._constraint.

     ELSE IF Dictdb._constraint._Con-Status = "M"
       THEN ASSIGN Dictdb._constraint._Con-Status = "D"
                   Dictdb._constraint._Con-Active = FALSE. 
    END.
  END.
  ELSE DO:
     IF Dictdb._constraint._Con-Status  = "N" OR  Dictdb._constraint._Con-Status  = "C"
       THEN DELETE Dictdb._constraint.

     ELSE IF Dictdb._constraint._Con-Status = "M"
       THEN ASSIGN Dictdb._constraint._Con-Status = "D"
                   Dictdb._constraint._Con-Active = FALSE.    
  END. 
  
OUTPUT STREAM constlog  CLOSE.           
END.
