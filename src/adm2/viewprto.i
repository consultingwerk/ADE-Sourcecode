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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\viewprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\viewer.p at 14:26 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE addRecord IN SUPER:
END PROCEDURE.

PROCEDURE cancelRecord IN SUPER:
END PROCEDURE.

PROCEDURE copyRecord IN SUPER:
END PROCEDURE.

PROCEDURE disableFields IN SUPER:
  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER.
END PROCEDURE.

PROCEDURE displayFields IN SUPER:
  DEFINE INPUT PARAMETER pcColValues AS CHARACTER.
END PROCEDURE.

PROCEDURE enableFields IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE toolbar IN SUPER:
  DEFINE INPUT PARAMETER pcValue AS CHARACTER.
END PROCEDURE.

PROCEDURE updateState IN SUPER:
  DEFINE INPUT PARAMETER pcState AS CHARACTER.
END PROCEDURE.

PROCEDURE valueChanged IN SUPER:
END PROCEDURE.

PROCEDURE viewRecord IN SUPER:
END PROCEDURE.

FUNCTION getTargetProcedure RETURNS HANDLE IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

