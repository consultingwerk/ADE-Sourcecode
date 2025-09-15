/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

DEFINE SHARED VARIABLE totrecs AS INTEGER INITIAL 0 NO-UNDO.
DISABLE TRIGGERS FOR DUMP OF DICTDB2.{1}.
FOR EACH DICTDB2.{1} {2}:
 totrecs = totrecs + 1.
END.
