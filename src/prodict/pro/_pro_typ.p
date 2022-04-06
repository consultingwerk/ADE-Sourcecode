/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

{ prodict/user/uservar.i }

DEFINE INPUT-OUTPUT PARAMETER io-dtype     AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-length    AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-pro-type  AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER io-gate-type AS CHARACTER NO-UNDO.
DEFINE       OUTPUT PARAMETER io-format    AS CHARACTER NO-UNDO.

assign
  user_env[12] = ?
  user_env[14] = ?.

RETURN.
