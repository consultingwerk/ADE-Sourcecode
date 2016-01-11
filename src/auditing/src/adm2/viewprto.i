/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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

FUNCTION getShowPopup RETURNS logical IN SUPER.

FUNCTION setShowPopup RETURNS logical 
    (input plShowPopup as logical) IN SUPER.
