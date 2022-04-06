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
    This connects a database using parameters.

  Input Parameters:

  Output Parameters:
      <none>

--------------------------------------------------------------------*/
DEFINE INPUT PARAM cDB      AS CHAR    NO-UNDO.
DEFINE INPUT PARAM cConnect AS CHAR    NO-UNDO.
DEFINE VARIABLE c1          AS CHAR    NO-UNDO.

CONNECT VALUE(cConnect) NO-ERROR.
ASSIGN c1 = STRING(CONNECTED(cDB),"yes/no") NO-ERROR.
RETURN c1.
