/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: qidxrpt.p

Description:
   Quick and dirty index report for both the GUI and character dictionary.

Input Parameters:
   p_DbId    - Id of the _Db record corresponding to the current database
   p_PName   - Physical name of the database
   p_DbType  - Database type (e.g., PROGRESS)
   p_TblName - Name of the table or "ALL"
   p_Btns    - Character string indicating which optional buttons
      	       should be visible.  These include "s" for switch files and
      	       "o" for order fields.  So to do both you would pass in "so".

Returns:
   "s" (if user asked to switch files) or 
   "".
 
Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            03/29/99 by Mario B      BUG# 99-03-26-19 Changed DBNAME to 
                                     "DICTDB" in _Owner check.

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

FIND _DB WHERE RECID(_DB) = p_DbId NO-LOCK.
IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
  FIND _File WHERE _File._File-name = "_Index"
               AND _File._Owner = "PUB"
               NO-LOCK.
  permit = CAN-DO(_File._Can-read,USERID("DICTDB")).
  FIND _File WHERE _File._File-name = "_Field"
               AND _File._Owner = "PUB"
               NO-LOCK.  
  permit = permit AND CAN-DO(_File._Can-read,USERID("DICTDB")).
  FIND _File WHERE _File._File-name = "_Index-Field"
               AND _File._Owner = "PUB"
               NO-LOCK.  
  permit = permit AND CAN-DO(_File._Can-read,USERID("DICTDB")).  
END.
ELSE DO:                        
  FIND _File "_Index" NO-LOCK.
  permit = CAN-DO(_File._Can-read,USERID("DICTDB")).
  FIND _File "_Field" NO-LOCK.
  permit = permit AND CAN-DO(_File._Can-read,USERID("DICTDB")).
  FIND _File "_Index-field" NO-LOCK.
  permit = permit AND CAN-DO(_File._Can-read,USERID("DICTDB")).
END.  
IF NOT permit THEN DO:
   MESSAGE "You do not have permission to use this option."
     VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   RETURN.
END.

IF p_TblName <> "ALL" THEN DO:
  IF INTEGER(DBVERSION("DICTDB")) > 8 THEN DO:
    FIND _File NO-LOCK WHERE _File._Db-recid = p_DbId 
                         AND _File._File-name = p_TblName
                         AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
    FIND LAST _Index OF _File NO-LOCK NO-ERROR.  
  END.
  ELSE DO:
    FIND _File NO-LOCK WHERE _File._Db-recid = p_DbId 
                         AND _File._File-name = p_TblName.
    FIND LAST _Index OF _File NO-LOCK NO-ERROR.
  END.
  IF NOT AVAILABLE _Index  THEN DO:
    MESSAGE "There are no indexes on this file to look at."
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")" +
      	     STRING("", "x(8)") + "Table: " + p_TblName.
flags = "Flags: <p>rimary, <u>nique, <w>ord, <a>bbreviated, <i>nactive, " +
      	"+ asc, - desc".

RUN adecomm/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Index Report",
    INPUT flags,
    INPUT p_Btns,
    INPUT "adecomm/_qidxdat.p",
    INPUT p_TblName,
    INPUT {&Quick_Index_Report}).

RETURN RETURN-VALUE.



