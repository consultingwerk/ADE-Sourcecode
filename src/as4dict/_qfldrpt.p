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
Modified on 02/13/95 by Donna McMann to work with Progress/400 Data Dictionary.
            07/14/98    Donna McMann Removed _file security check
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

IF p_TblName <> "ALL" THEN
DO:
   FIND as4dict.p__File NO-LOCK WHERE as4dict.p__File._File-name = p_TblName.
   FIND LAST as4dict.p__Field WHERE as4dict.p__Field._File-number = as4dict.p__File._File-number
       NO-LOCK NO-ERROR.
   IF NOT AVAILABLE as4dict.p__Field THEN DO:
     MESSAGE "There are no fields to look at in this table."
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     RETURN.
   END.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")" +
      	     STRING("", "x(8)") + "Table: " + p_TblName.
flags = "Flags: <c>ase sensitive, <i>ndex component, <m>andatory, " +
       "<v>ariable".

RUN as4dict/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Field Report",
    INPUT flags,
    INPUT p_Btns,
    INPUT "as4dict/_qflddat.p",
    INPUT p_TblName,
    INPUT {&Quick_Field_Report}).

RETURN RETURN-VALUE.

/* _qfldrpt.p - end of file */


