/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* resfuncs.i */

FUNCTION getRecord RETURNS LOGICAL
  ( INPUT pTable AS CHARACTER,
    INPUT pIndex AS INTEGER ):

  CASE pTable:
    WHEN "qbf-a":U THEN DO:
      IF NOT CAN-FIND(qbf-a WHERE qbf-a.iIndex = pIndex) THEN DO:
        CREATE qbf-a.
        ASSIGN qbf-a.iIndex = pIndex.
      END.
      ELSE FIND qbf-a WHERE qbf-a.iIndex = pIndex.
    END.
    WHEN "qbf-cfld":U THEN DO:
      IF NOT CAN-FIND(qbf-cfld WHERE qbf-cfld.iIndex = pIndex) THEN DO:
        CREATE qbf-cfld.
        ASSIGN qbf-cfld.iIndex = pIndex.
      END.
      ELSE FIND qbf-cfld WHERE qbf-cfld.iIndex = pIndex.
    END.
    WHEN "qbf-form":U THEN DO:
      IF NOT CAN-FIND(qbf-form WHERE qbf-form.iIndex = pIndex) THEN DO:
        CREATE qbf-form.
        ASSIGN qbf-form.iIndex = pIndex.
      END.
      ELSE FIND qbf-form WHERE qbf-form.iIndex = pIndex.
    END.
    WHEN "qbf-join":U THEN DO:
      IF NOT CAN-FIND(qbf-join WHERE qbf-join.iIndex = pIndex) THEN DO:
        CREATE qbf-join.
        ASSIGN qbf-join.iIndex = pIndex.
      END.
      ELSE FIND qbf-join WHERE qbf-join.iIndex = pIndex.
    END.
    WHEN "qbf-schema" THEN DO:
      IF NOT CAN-FIND(qbf-schema WHERE qbf-schema.iIndex = pIndex) THEN DO:
        CREATE qbf-schema.
        ASSIGN qbf-schema.iIndex = pIndex.
      END.
      ELSE FIND qbf-schema WHERE qbf-schema.iIndex = pIndex.
    END.
  END CASE.

END FUNCTION.
