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

