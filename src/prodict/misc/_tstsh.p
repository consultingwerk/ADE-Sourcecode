/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

DEFINE INPUT  PARAMETER name AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER found AS LOGICAL  NO-UNDO.

found = CAN-FIND (DICTDB2._Db WHERE DICTDB2._Db._Db-name = name).
