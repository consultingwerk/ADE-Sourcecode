/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: osnul.i

Description:
   This include file will place the name of the system null device in the
   one parameter that is passed.

Example:
  {adecomm/osnul.i v_TheNulDevice}
  OUTPUT TO VALUE(v_TheNulDevice).

Author: Tony Lavinio

Date Created: 07/21/92

----------------------------------------------------------------------------*/
 
ASSIGN {1} = "nul":u.
IF OPSYS = "UNIX"  THEN {1} = "/dev/null":u.
