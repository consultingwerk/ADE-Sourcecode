/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _shutdwn.p

Description:
    Shuts down the workshop and cleans up the various persistent objects.
   
Input Parameters:
  <none>

Output Parameters:
  <none>

Author: Wm.T.Wood

Date Created: January 1997

Modified:
 --------------------------------------------------------------------------*/

{ workshop/sharvars.i }    /* Most common shared variables        */
{ workshop/errors.i }      /* Error handling procedures           */

DEFINE VARIABLE h      AS HANDLE NO-UNDO.
DEFINE VARIABLE h_next AS HANDLE NO-UNDO.
/* =====================================================================  */
/*            Shutdown environment and empty some globals                 */
/* =====================================================================  */

/* Stop the error handler, if necessary. Also stop any old copies that are
   accidently lying around. */
IF VALID-HANDLE(_err-hdl) THEN DO:
  /* Loop through all the persistent procedures and delete anything that
     looks like the _err-hdl procedure. */
  h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    /* Store the next procedure before the current one is deleted. */
    h_next = h:NEXT-SIBLING.
    IF h ne _err-hdl AND h:FILE-NAME eq _err-hdl:FILE-NAME
    THEN DELETE PROCEDURE h.
    /* Go to the next procedure. */
    h = h_next.
  END. /* DO WHILE VALID-HANDLE(h)... */ 
  /* Now delete the error handler itself. */
  DELETE PROCEDURE _err-hdl.
END.
