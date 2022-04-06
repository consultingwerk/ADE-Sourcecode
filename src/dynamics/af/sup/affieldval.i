/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: affieldval.i

  Description: Standard write trigger wrapper code

  Purpose: pulled into write triggers

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History:
  (010000)  Task: 33    19/12/1997  Anthony D Swindells
            New include written from scratch

------------------------------------------------------------------------*/

 OR DEFINED(WRITE_TRIGGER) <> 0 &THEN
    &IF DEFINED(WRITE_TRIGGER) &THEN
        ASSIGN lv-value = STRING({&FIELDNAME}).
    &ENDIF
