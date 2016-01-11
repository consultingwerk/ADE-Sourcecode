/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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
