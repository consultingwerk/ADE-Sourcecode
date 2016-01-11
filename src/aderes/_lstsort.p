/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

