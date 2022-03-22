/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qfldrpt.p

Description:
   Quick and dirty field report for both the GUI and character dictionaries.

Input Parameters:
   p_DbId    - Id of the _Db record corresponding to the current database
   p_PName   - Physical name of the database
   p_DbType  - Database type (e.g., PROGRESS)
   p_TblName - Name of the table or "ALL"
   p_Btns    - Character string indicating which optional buttons
      	       should be visible.  These include "s" for switch files,
      	       "o" for order fields by _Order or "a" to order fields
      	       alphabetically.  So this could be "so", "sa", "o", OR "a".

Returns:
   Indicates actions that occurred within report:
   "s" if Switch file was chosen
   "o" if the last order shown was by order#
   "a" if the last order shown was alphabetical
   So this could be "so", "sa", "o", OR "a".

 
Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            07/10/98 D. McMann Added check for DBVERSION and_Owner.
            08/28/98 D. McMann Removed check since incorrect db being found
                               and report handles no fields found correctly
            03/29/99 by Mario B      BUG# 99-03-26-19 Changed DBNAME to 
                                     "DICTDB" in _Owner check.
            08/25/03 D. McMann Update report for 10.0A
                               
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_TblName AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Btns    AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.
DEFINE VAR flags      AS CHAR 	 NO-UNDO.
DEFINE VAR permit     AS LOGICAL NO-UNDO.


IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  FIND _File WHERE _File._File-name = "_File" 
               AND _File._Owner = "PUB" NO-LOCK.
  permit = CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File WHERE _File._File-name = "_Field" 
               AND _File._Owner = "PUB" NO-LOCK.
  permit = permit AND CAN-DO(_Can-read,USERID("DICTDB")).
END.  
ELSE DO:
  FIND _File "_File" NO-LOCK.
  permit = CAN-DO(_File._Can-read,USERID("DICTDB")).
  FIND _File "_Field" NO-LOCK.
  permit = permit AND CAN-DO(_File._Can-read,USERID("DICTDB")).
END.
  
IF NOT permit THEN DO:
  MESSAGE "You do not have permission to use this option."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")" +
      	     STRING("", "x(8)") + "Table: " + p_TblName.
flags = "Flags: <c>ase sensitive, <i>ndex component, <m>andatory ".

RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Field Report",
    INPUT flags,
    INPUT p_Btns,
    INPUT "adecomm/_qflddat.p",
    INPUT p_TblName,
    INPUT {&Quick_Field_Report}).

RETURN RETURN-VALUE.

/* _qfldrpt.p - end of file */




