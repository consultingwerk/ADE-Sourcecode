/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-extra.p - Converts VMS directory format to UNIX format */

DEFINE INPUT-OUTPUT PARAMETER qbf-v AS CHARACTER NO-UNDO. /* filename */

DEFINE VARIABLE qbf-c AS INTEGER INITIAL     0 NO-UNDO. /* num slashes */
DEFINE VARIABLE qbf-o AS INTEGER INITIAL     0 NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-p AS INTEGER               NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s AS LOGICAL INITIAL FALSE NO-UNDO. /* starts w/slash */

IF INDEX(qbf-v,"/") > 0 THEN DO:

  /* handle optional leading slash */
  IF qbf-v BEGINS "/" THEN
    ASSIGN
      SUBSTRING(qbf-v,1,1) = "["
      qbf-s                = TRUE
      qbf-c                = 1.
  ELSE
    qbf-v = "[." + qbf-v.

  /* convert each embedded "/" to "." */
  qbf-p = INDEX(qbf-v,"/").
  DO WHILE qbf-p > 0:
    ASSIGN
      qbf-c = qbf-c + 1
      SUBSTRING(qbf-v,qbf-p,1) = "."
      qbf-o = qbf-p
      qbf-p = INDEX(qbf-v,"/").
  END.
  IF qbf-o = 0 THEN
    SUBSTRING(qbf-v,1,1) = "".
  ELSE
    SUBSTRING(qbf-v,qbf-o,1) = "]".

  /* now convert first "[directory]" into "volume:" */
  IF qbf-s AND qbf-c >= 2 THEN
    ASSIGN
      qbf-v = SUBSTRING(qbf-v,2)
      qbf-p = INDEX(qbf-v,IF qbf-c = 2 THEN "]" ELSE ".")
      SUBSTRING(qbf-v,qbf-p,1) = (IF qbf-c = 2 THEN ":" ELSE ":[").

END.

RETURN.
