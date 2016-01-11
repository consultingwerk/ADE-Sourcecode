&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
