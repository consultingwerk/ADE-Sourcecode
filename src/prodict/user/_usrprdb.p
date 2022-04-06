/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* create a new database */

{ prodict/user/uservar.i }

DEFINE VARIABLE newdb AS CHARACTER NO-UNDO.

RUN adecomm/_dbcreat.p (INPUT "", INPUT-OUTPUT newdb).
user_env[2] = newdb.

IF newdb = ? THEN user_path = "".

