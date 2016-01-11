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
/*
 * Prototype include file: C:\adm90\src\adm2\brsprto.i
 * Created from procedure: C:\adm90\src\adm2\browser.p at 09:47 on 10/27/98
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

/***** Start excluded prototypes

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE updateRecord IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE enableFields IN SUPER:
END PROCEDURE.

PROCEDURE displayFields IN SUPER:
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER.
END PROCEDURE.

PROCEDURE disableFields IN SUPER:
  DEFINE INPUT PARAMETER pcFields AS CHARACTER.
END PROCEDURE.

PROCEDURE deleteRecord IN SUPER:
END PROCEDURE.

PROCEDURE copyRecord IN SUPER:
END PROCEDURE.

PROCEDURE cancelRecord IN SUPER:
END PROCEDURE.

PROCEDURE addRecord IN SUPER:
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION colValues RETURNS CHARACTER
  (INPUT pcViewColList AS CHARACTER) IN SUPER.

FUNCTION getBrowseHandle RETURNS HANDLE IN SUPER.

FUNCTION getDataSignature RETURNS CHARACTER IN SUPER.

END excluded prototypes *****/


FUNCTION stripCalcs RETURNS CHARACTER
  (INPUT cClause AS CHARACTER) IN SUPER.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pd_height AS DECIMAL.
  DEFINE INPUT PARAMETER pd_width AS DECIMAL.
END PROCEDURE.

