/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------

  File: webutil/dbcheck.p

  Description: 
    This program is an external procedure, because for some reason, 
    external procedures are more efficient at picking up on dropped 
    database connections. 
    This disconnects the connected databases in failover situation.

  Input Parameters:

  Output Parameters:
      <none>

--------------------------------------------------------------------*/
DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
DO i1 = 1 TO NUM-DBS:
  DISCONNECT VALUE(LDBNAME(i1)) NO-ERROR.
END.
RETURN.

/* dbcheck.p - end of file */
