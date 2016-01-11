/*********************************************************************
* Copyright (C) 2000,2013 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _seldir.w

  Description: 

  Input Parameters:
      INPUT-OUTPUT pcCur-Dir AS CHARACTER directory to look for

  Output Parameters:
      <none>

  Author: 

  Modified: 05/20/1999

----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pcCur-dir  AS CHARACTER           NO-UNDO.

SYSTEM-DIALOG GET-DIR pcCur-dir 
    INITIAL-DIR pcCur-dir
    TITLE "Select a Directory".

RETURN.
