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
