/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
