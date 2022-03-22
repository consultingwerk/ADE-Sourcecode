/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: trigrpt.p

Description:
   Trigger report for both the GUI and character dictionary.
 
Input Parameters:
   p_DbId   - Id of the _Db record corresponding to the current database
   p_PName  - Physical name of the database
   p_DbType - Database type (e.g., PROGRESS)

Author: Laura Stern

Date Created: 11/19/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs on file accesses.
            07/10/98    D. McMann    Added DBVERSION and _Owner check
            03/29/99    Mario B      BUG# 99-03-26-019, see comment below, also changed 
                                     DBNAME to DICTDB on conditional expression that 
                                     tests for db version.
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.
DEFINE VAR flags      AS CHAR 	 NO-UNDO.
DEFINE VAR can_see    AS LOGICAL NO-UNDO init yes.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
DO:
  FIND _File WHERE _File._File-name = "_File" 
               AND _File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  IF can_see THEN DO:
    FIND _File WHERE _File._File-name = "_File-trig" 
                 AND _File._Owner = "PUB" NO-LOCK.
    IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  END.
  IF can_see THEN DO:
    FIND _File WHERE _File._File-name = "_Field-trig" 
                 AND _File._Owner = "PUB" NO-LOCK.
    IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  END.
END.
ELSE DO:
  FIND _File "_File" NO-LOCK.
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  IF can_see THEN DO:
    FIND _File "_File-trig" NO-LOCK.
    IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  END.
  IF can_see THEN DO:
    FIND _File "_Field-trig" NO-LOCK.
    IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN can_see = no.
  END.
END.  
IF NOT can_see THEN DO:
  MESSAGE "You do not have permission to use this option."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

ASSIGN can_see = FALSE.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN 
DO:

  FOR EACH _File WHERE (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                   NO-LOCK.
    FIND LAST _File-trig OF _File NO-LOCK NO-ERROR.
    IF NOT AVAILABLE _File-trig THEN DO:
      FIND LAST _Field-trig OF _File NO-LOCK NO-ERROR.
      IF AVAILABLE _Field-trig THEN ASSIGN can_see = TRUE.
    END.
    ELSE ASSIGN can_see = true.
    IF can_see THEN LEAVE.
  END.    
END.
ELSE do:
  FIND LAST _File-trig NO-LOCK NO-ERROR.
  IF NOT AVAILABLE _File-trig THEN DO: 
    FIND LAST _Field-trig NO-LOCK NO-ERROR.
    IF NOT AVAILABLE _Field-trig THEN
       ASSIGN can_see = TRUE.   
  END.
  ELSE ASSIGN can_see = TRUE.  
/* BUG# 99-03-26-019.  This leaves the procedure.  We're going to leave the    *
 * block on the very next statement "END" anyway, so what purpose could this   *
 * have served here?  Seems the intent was probably to leave the block.        *
 * IF can_see THEN LEAVE.                                                      */

END.  

IF NOT can_see THEN DO:
   MESSAGE "There are no triggers in this database to look at."
     	VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")".
flags = "Flags: * = overridable, 'm' = mismatched crc, 'nr' = no r-code found".
RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Trigger Report",
    INPUT flags,
    INPUT "",
    INPUT "adecomm/_trigdat.p",
    INPUT "",
    INPUT {&Trigger_Report}).

/* _trigrpt.p - end of file */





