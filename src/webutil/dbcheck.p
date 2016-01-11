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
    database connections. While you can check for connections in a
    persistent procedure, and it sometimes works, it supposedly is more
    reliable if it is checked in a freshly called procedure.  Because 
    of the simple nature of this procedure, and the propensity for its 
    r-code to be cached, this procedure shouldn't add too much overhead.

  Input Parameters:

  Output Parameters:
      RETURN-VALUE (List of logical databases) 

--------------------------------------------------------------------*/
DEFINE VAR c1 AS CHARACTER NO-UNDO.
DEFINE VAR i1 AS INTEGER   NO-UNDO.

DO i1 = 1 TO NUM-DBS:
  c1 = c1 + (IF c1 > "" THEN "," ELSE "") + LDBNAME(i1).
END.
RETURN c1.

/* dbcheck.p - end of file */
