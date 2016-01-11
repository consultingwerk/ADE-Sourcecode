/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: rstrtrg.i

Description: Restores the triggers to a normal state.
  While using this as an include file, make sure uRecId is set.

Input Parameters: <None>

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 15 February 1993

----------------------------------------------------------------------------*/

{adeuib/triggers.i}

FOR EACH _TRG WHERE _TRG._wRECID = uRecId:
  ASSIGN _TRG._STATUS = "NORMAL".
END.
