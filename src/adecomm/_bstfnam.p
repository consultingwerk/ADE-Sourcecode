&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
