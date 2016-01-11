/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _reask.p - Re-ask 'ask-at-runtime' values for browse and forms views.
 *            This wickedly complex code lets y-menu.p redraw the screen
 *            and in the process, re-ask any 'ask-at-runtime' questions.
 *
 * Input Parameters:	 <none>
 *
 * Output Parameters:	 <none>
 *
 */

{ aderes/s-system.i }
{ aderes/s-define.i }

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO.

APPLY "U1":u TO qbf-widxit.
/*RUN main_loop IN wGlbMainLoop.*/

/* _reask.p - end of file */

