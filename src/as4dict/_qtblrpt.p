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

File: qtblrpt.p

Description:
   Quick and dirty table report for both the GUI and character dictionary.
 
Input Parameters:
   p_DbId   - Id of the _Db record corresponding to the current database
   p_PName  - Physical name of the database
   p_DbType - Database type (e.g., PROGRESS)

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92
    Modified: 07/14/98 D. McMann Removed _File check
              04/06/99 D. McMann Added stored procedure support
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR NO-UNDO.
DEFINE VAR flags      AS CHAR NO-UNDO.

FIND LAST as4dict.p__File WHERE as4dict.p__File._Hidden = "N" 
   AND as4dict.p__File._For-Info <> "PROCEDURE" NO-ERROR.
IF NOT AVAILABLE as4dict.p__File THEN DO:
  MESSAGE "There are no tables in this database to look at."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")".   

RUN as4dict/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Quick Table Report",
    INPUT  "",
    INPUT "",
    INPUT "as4dict/_qtbldat.p",
    INPUT "",
    INPUT {&Quick_Table_Report}).

/* _qtblrpt.p - end of file */



