/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: trelrpt.p

Description:
   Invoke table relations report for both the GUI and Char dictionaries.
 
Input Parameters:
   p_DbId    - Id of the _Db record corresponding to the current database
   p_PName   - Physical name of the database
   p_DbType  - Database type (e.g., PROGRESS)
   p_TblName - Name of the table or "ALL".
   p_Btns    - Character string indicating which optional buttons
      	       should be visible.  These include "s" for switch files.
      	       So this could be "" OR "s"

Author: Tony Lavinio, Laura Stern

Date Created: 10/12/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            07/10/98 by D. McMann    Added DBVERSION and _Owner check.
            03/29/99 by Mario B      BUG# 99-03-26-19 Changed DBNAME to 
                                     "DICTDB" in _Owner check.
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId    AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_TblName AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Btns    AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.
DEFINE VAR permit     AS LOGICAL NO-UNDO.

FIND _DB WHERE RECID(_Db) = p_DbId NO-LOCK.
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  FIND _File WHERE _File._File-name = "_File" 
               AND _File._Owner = "PUB" NO-LOCK.
  permit = CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File WHERE _File._File-name = "_Field" 
               AND _File._Owner = "PUB" NO-LOCK.
  permit = permit AND CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File WHERE _File._File-name = "_Index" 
               AND _File._Owner = "PUB" NO-LOCK.
  permit = permit AND CAN-DO(_Can-read,USERID("DICTDB")).
  
END.  
ELSE DO:
  FIND _File "_File" NO-LOCK.
  permit = CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File "_Index" NO-LOCK.
  permit = permit AND CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File "_Field" NO-LOCK.
  permit = permit AND CAN-DO(_Can-read,USERID("DICTDB")).
END.  
IF NOT permit THEN DO:
  MESSAGE "You do not have permission to use this option"
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")" +
      	     STRING("", "x(8)") + "Table: " + p_TblName.

RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Table Relations Report",
    INPUT "",
    INPUT p_Btns,
    INPUT "adecomm/_treldat.p",
    INPUT p_TblName,
    INPUT {&Table_Relations_Report}).

RETURN RETURN-VALUE.

/* _trelrpt.p - end of file */ 





