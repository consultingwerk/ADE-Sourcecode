/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* p-comma.i - converts format from ".," to ",." and back */

PROCEDURE comma_swap:
  DEFINE INPUT-OUTPUT PARAMETER qbf_f AS CHARACTER NO-UNDO.

  qbf_f = REPLACE(
            REPLACE(
              REPLACE(qbf_f,",":u,CHR(1))
            ,".":u,",":u)
          ,CHR(1),".":u).

  /*
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO.
  DO qbf_i = 1 TO LENGTH(qbf_f):
    IF SUBSTRING(qbf_f,qbf_i,1) = "." THEN SUBSTRING(qbf_f,qbf_i,1) = ",".
    ELSE
    IF SUBSTRING(qbf_f,qbf_i,1) = "," THEN SUBSTRING(qbf_f,qbf_i,1) = ".".
  END.
  */

END.

/* p-comma.i - end of file */

