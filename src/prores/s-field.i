/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-field.i - part of c-field.p and s-field.p */

ASSIGN
  qbf-1 = (IF qbf-toggle1 THEN
            SUBSTRING({*},INDEX({*},"|") + 1)
          ELSE
            ENTRY(2,{*}))
  qbf-2 = ENTRY(1,{*})
  qbf-2 = "("
        + (IF LENGTH(qbf-1) > 40 - 2 - LENGTH(qbf-2) THEN
            SUBSTRING(qbf-2,1,MAXIMUM(0,40 - 2 - 3 - LENGTH(qbf-1))) + "..."
          ELSE
            qbf-2)
        + ")"
  qbf-1 = (IF LENGTH(qbf-1) > 40 + 1 - LENGTH(qbf-2) THEN
            SUBSTRING(qbf-1,1,40 - 3 - LENGTH(qbf-2)) + "..."
          ELSE
            qbf-1)
  OVERLAY(qbf-1,40 + 1 - LENGTH(qbf-2)) = qbf-2.
