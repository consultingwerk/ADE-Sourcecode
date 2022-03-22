/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Procedure prodict/ora/_ora_md5.p

   Modified 11/12/97 DLM Removed DISCONNECT of Progress Database.
   
*/   


DEFINE INPUT PARAMETER ora-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pro-name AS CHARACTER NO-UNDO.
DEFINE VARIABLE i AS INTEGER NO-UNDO.

/* connect up the databases to work with ------------------------------------*/

DELETE ALIAS DICTDB2.

IF NOT CONNECTED(pro-name) THEN
  CONNECT VALUE(pro-name)-1 -ld DICTDB2 NO-ERROR.
ELSE
   CREATE ALIAS DICTDB2 FOR DATABASE VALUE(pro-name).  

RUN prodict/ora/_ora_fix.p.

RETURN.
