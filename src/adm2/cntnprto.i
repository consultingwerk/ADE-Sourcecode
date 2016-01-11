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
 * Prototype include file: C:\adm90\src\adm2\cntnprto.i
 * Created from procedure: C:\adm90\src\adm2\containr.p at 09:47 on 10/27/98
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

/***** Start excluded prototypes

PROCEDURE viewPage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE selectPage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE removePageNTarget IN SUPER:
  DEFINE INPUT PARAMETER phTarget AS HANDLE.
  DEFINE INPUT PARAMETER piPage AS INTEGER.
END PROCEDURE.

PROCEDURE notifyPage IN SUPER:
  DEFINE INPUT PARAMETER pcProc AS CHARACTER.
END PROCEDURE.

PROCEDURE initPages IN SUPER:
  DEFINE INPUT PARAMETER pcPageList AS CHARACTER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE deletePage IN SUPER:
  DEFINE INPUT PARAMETER piPageNum AS INTEGER.
END PROCEDURE.

PROCEDURE createObjects IN SUPER:
END PROCEDURE.

PROCEDURE constructObject IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
  DEFINE INPUT PARAMETER phParent AS HANDLE.
  DEFINE INPUT PARAMETER pcPropList AS CHARACTER.
  DEFINE OUTPUT PARAMETER phObject AS HANDLE.
END PROCEDURE.

PROCEDURE confirmExit IN SUPER:
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL.
END PROCEDURE.

PROCEDURE changePage IN SUPER:
END PROCEDURE.

PROCEDURE assignPageProperty IN SUPER:
  DEFINE INPUT PARAMETER pcProp AS CHARACTER.
  DEFINE INPUT PARAMETER pcValue AS CHARACTER.
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION getContainerTarget RETURNS CHARACTER IN SUPER.

FUNCTION getContainerTargetEvents RETURNS CHARACTER IN SUPER.

FUNCTION getDataTarget RETURNS CHARACTER IN SUPER.

FUNCTION getPageNTarget RETURNS CHARACTER IN SUPER.

FUNCTION getPageSource RETURNS HANDLE IN SUPER.

FUNCTION pageNTargets RETURNS CHARACTER
  (INPUT phTarget AS HANDLE,
   INPUT piPageNum AS INTEGER) IN SUPER.

FUNCTION setContainerTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setDataTarget RETURNS LOGICAL
  (INPUT pcTarget AS CHARACTER) IN SUPER.

FUNCTION setPageNTarget RETURNS LOGICAL
  (INPUT pcObject AS CHARACTER) IN SUPER.

FUNCTION setPageSource RETURNS LOGICAL
  (INPUT phObject AS HANDLE) IN SUPER.

END excluded prototypes ********/

FUNCTION getCurrentPage RETURNS INTEGER IN SUPER.

