/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
   History:  DLM 09/03/98  New ProToOdb already connects to Progress
                           database.  I added a check so connect would
                           not issue an error
*/                           


DEFINE INPUT PARAMETER odb-name     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-name     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-conparms AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_edbtype  AS CHARACTER NO-UNDO.

DEFINE VARIABLE connted AS LOGICAL INITIAL FALSE.

/* connect up the databases to work with ------------------------------------*/

DELETE ALIAS DICTDB2.

IF NOT CONNECTED (pro-name) THEN DO:
  CONNECT VALUE(pro-name) -ld DICTDB2 VALUE (pro-conparms) -1.
  ASSIGN connted = TRUE.
END.  

ELSE
  CREATE ALIAS DICTDB2 FOR DATABASE VALUE(pro-name).  

RUN prodict/odb/_odb_fix.p (p_edbtype).

IF connted THEN
  DISCONNECT DICTDB2.
ELSE
  DELETE ALIAS DICTDB2.
    
RETURN.

