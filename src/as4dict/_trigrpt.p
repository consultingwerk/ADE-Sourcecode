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
Modified on 02/13/95 by D. McMann to work with Progress/400 data dictionary.
            07/14/98 by D. McMann removed security check for _file
----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR  NO-UNDO.

DEFINE VAR header_str AS CHAR 	 NO-UNDO.
DEFINE VAR flags      AS CHAR 	 NO-UNDO.
DEFINE VAR can_see    AS LOGICAL NO-UNDO init yes.

FIND LAST as4dict.p__Trgfl NO-LOCK NO-ERROR.
IF NOT AVAILABLE as4dict.p__Trgfl THEN DO:
   FIND LAST as4dict.p__Trgfd NO-LOCK NO-ERROR.
   IF NOT AVAILABLE as4dict.p__Trgfd THEN DO:
      MESSAGE "There are no triggers in this database to look at."
      	VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
   END.
END.

header_str = "Database: " + p_PName + " (" + p_DbType + ")".
flags = "Flags: * = overridable, 'm' = mismatched crc, 'nr' = no r-code found".
RUN as4dict/_report.p 
   (INPUT p_DbId, 
    INPUT header_str,
    INPUT "Trigger Report",
    INPUT flags,
    INPUT "",
    INPUT "as4dict/_trigdat.p",
    INPUT "",
    INPUT {&Trigger_Report}).

/* _trigrpt.p - end of file */


