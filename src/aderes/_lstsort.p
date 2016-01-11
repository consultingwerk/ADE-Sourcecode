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

  File: _lstsort.p

  Description: sort a comma-separated list

  Input Parameters:	qbf-o - unsorted list

  Output Parameters:    qbf-o - sorted list

  Author:  Doug Adams

  Created: 06/29/94 - 02:58 pm

-----------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

DEFINE VARIABLE ix AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE _ttlist NO-UNDO
  FIELD _ttentry AS CHARACTER
  INDEX _ttentry IS PRIMARY _ttentry.

DO ix = 1 TO NUM-ENTRIES(qbf-o):
  IF TRIM(ENTRY(ix, qbf-o)) = "" THEN NEXT.

  CREATE _ttlist.
  _ttlist._ttentry = ENTRY(ix, qbf-o).
END.

qbf-o = "".

FOR EACH _ttlist:
  qbf-o = (IF qbf-o = "" THEN "" ELSE qbf-o + ",") + _ttlist._ttentry.
END.

/* _lstsort.p - end of file */

