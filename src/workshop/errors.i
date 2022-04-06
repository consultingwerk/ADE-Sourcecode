/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: errors.i
  Description: Include file for the error handler and functions.
  Author: Wm.T.Wood 1-31-97
------------------------------------------------------------------------*/

DEFINE {1} SHARED VAR _err-hdl AS HANDLE NO-UNDO.
       /* _err-hdl is the error handler persistent procedure.           */

      	
&IF "{&WINDOW-SYSTEM}" ne "MS-WINDOWS" &THEN /* Allow compiling in 1mars */
FUNCTION errors-exist RETURNS LOGICAL (p_types AS CHAR) IN _err-hdl.
&Global-define Workshop-Errors errors-exist("ALL":U)
&ELSE
&Global-define Workshop-Errors false
&ENDIF

