/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
