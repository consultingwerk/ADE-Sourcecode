/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _delet_p.p
  
  Description: Closes and Deletes the _P record.  
  Parameters:  p_id -- integer (RECID) of the _P to delete.

  Author:  Wm. T. Wood
  Created: Dec. 31, 1996
------------------------------------------------------------------------*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_id AS INTEGER NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/objects.i }      /* Shared web-object temp-tables. */

/* ************************  Main Code Block  *********************** */

/* Get the _P record for this file. */
FIND _P WHERE RECID(_P) eq p_id.

/* Close it (i.e. remove the associted code and objects. */
RUN workshop/_close_p.p (INPUT p_id, INPUT "":U /* No options */ ).

/* Now delete _P. */
DELETE _P.
