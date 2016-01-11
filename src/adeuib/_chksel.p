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
/*----------------------------------------------------------------------------

File: _chksel.p

Description: This procedure is used to determine if the selected objects
	have the same parent.

Input Parameters:  <None>

Output Parameters: iopStatus:
			- a negative value indicates that objects with
			  multiple parents are selected
			- 0 indicates there are no objects selected
			- a positive value indicates that objects with the
			  same parents are selected

Author: Ravi-Chandar Ramalingam

Date Created: 16 June 1993

----------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER iopStatus AS INTEGER INITIAL 0 NO-UNDO.

{adeuib/uniwidg.i}

/* -------------------------- Local Variables ------------------------------*/
DEFINE VARIABLE ridvParent AS RECID NO-UNDO.

FIND FIRST _U WHERE _U._SELECTEDib NO-ERROR.
IF AVAILABLE _U THEN DO:
  ASSIGN ridvParent = _U._parent-recid.
  FIND FIRST _U WHERE _U._SELECTEDib AND
	_U._parent-recid <> ridvParent NO-ERROR.
  ASSIGN iopStatus = IF AVAILABLE _U THEN -1 ELSE 1.
END.
