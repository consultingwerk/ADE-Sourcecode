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
Modified on 02/13/95 by D. McMann to work with Progress/400 data dictionary.
            07/14/98 by D. McMann Removed _file checks
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId    AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_TblName AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_Btns    AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.
DEFINE VAR permit     AS LOGICAL NO-UNDO.

header_str = "Database: " + p_PName + " (" + p_DbType + ")" +
      	     STRING("", "x(8)") + "Table: " + p_TblName.

RUN as4dict/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Table Relations Report",
    INPUT "",
    INPUT p_Btns,
    INPUT "as4dict/_treldat.p",
    INPUT p_TblName,
    INPUT {&Table_Relations_Report}).

RETURN RETURN-VALUE.

/* _trelrpt.p - end of file */ 


