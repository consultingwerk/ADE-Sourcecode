&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
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
File: _bstfnam.p

Description:
    Generate the "best" filename for a wizard file.

    See if the suggested file exists.  If not, keep adding 1, 2, 3, etc
    until a unique name is NOT found on disk.

Input Parameter:
   p_suggestion - base name with &1 used where the number will go.

Output Parameter:
   p_name       - The final name.

Author: Wm.T.Wood

Date Created: May 1997
----------------------------------------------------------------------------*/
/*            This file was created with WebSpeed Workshop.                 */
/*--------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_suggestion AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_name       AS CHAR NO-UNDO.

/* Local Definitions --                                                */
DEF VAR i AS INTEGER NO-UNDO.

/* ************************ Main Code Block ************************** */

/* Initialize the name to the suggestion. */
p_name = SUBSTITUTE(p_suggestion, "":U).

/* ERROR CHECK: If p_suggestion did not contain &1, make sure it does.
   Otherwise we will look forever. */
IF p_name eq p_suggestion THEN p_suggestion = p_suggestion + "~&1":U.

/* Find a sample file name that does not exist. */
DO WHILE SEARCH(p_name) ne ?:
  ASSIGN i = i + 1
         p_name = SUBSTITUTE(p_suggestion, i).
END.
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS
