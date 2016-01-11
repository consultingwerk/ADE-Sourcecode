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
/* s-file.i - part of c-file.p */

(IF CAN-DO("f,q",qbf-g) AND qbf-toggle2 THEN
  IF LENGTH(ENTRY(3,qbf-schema.cValue)) > 5 THEN
    SUBSTRING(qbf-schema.cValue,INDEX(qbf-schema.cValue,"|") + 1)
  ELSE
    ENTRY(2,qbf-schema.cValue) + "." + ENTRY(1,qbf-schema.cValue)
ELSE
  ENTRY(1,qbf-schema.cValue)
  + FILL(" ",qbf-b -
    (IF LENGTH(ENTRY(2,qbf-schema.cValue))
    + LENGTH(ENTRY(1,qbf-schema.cValue)) > 46 THEN
      qbf-b - LENGTH(ENTRY(1,qbf-schema.cValue))
    ELSE
      LENGTH(ENTRY(2,qbf-schema.cValue))
    )
    - LENGTH(ENTRY(1,qbf-schema.cValue))
  )
  + "(" +
  (IF LENGTH(ENTRY(2,qbf-schema.cValue))
  + LENGTH(ENTRY(1,qbf-schema.cValue)) > 46 THEN
    SUBSTRING(ENTRY(2,qbf-schema.cValue),1,
    qbf-b - 3 - LENGTH(ENTRY(1,qbf-schema.cValue))) + "..."
  ELSE
    ENTRY(2,qbf-schema.cValue)
  )
  + ")"
)
