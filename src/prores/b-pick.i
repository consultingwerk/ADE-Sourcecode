/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-pick.i - part of b-pick.p */

( SUBSTRING(qbf-form.cValue,INDEX(qbf-form.cValue,".") + 1)
  + FILL(" ",65 - LENGTH(qbf-form.cValue))
  + " (" + SUBSTRING(qbf-form.cValue,1,INDEX(qbf-form.cValue,".") - 1) + ")"
)
