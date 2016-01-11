/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-form.i - part of c-form.p */

(IF qbf-toggle3 = 1 THEN
  SUBSTRING(ENTRY(1,qbf-form.cValue),INDEX(qbf-form.cValue,".") + 1)
  + FILL(" ",47 - LENGTH(ENTRY(1,qbf-form.cValue)))
  + "("
  + SUBSTRING(ENTRY(1,qbf-form.cValue),1,INDEX(qbf-form.cValue,".") - 1)
  + ")"
ELSE IF qbf-toggle3 = 2 THEN
  (IF ENTRY(2,qbf-form.cValue) = "" THEN
    SUBSTRING(ENTRY(1,qbf-form.cValue),INDEX(ENTRY(1,qbf-form.cValue),".") + 1,8)
  ELSE
    ENTRY(2,qbf-form.cValue)
  ) + ".p"
ELSE
  (IF qbf-form.cDesc <> "" THEN
    qbf-form.cDesc
  ELSE IF LENGTH(qbf-a[({*}) MODULO 100 + 1]) < 5 THEN
    SUBSTRING(ENTRY(1,qbf-form.cValue),INDEX(ENTRY(1,qbf-form.cValue),".") + 1)
  ELSE
    SUBSTRING(qbf-a[({*}) MODULO 100 + 1],5))
)
