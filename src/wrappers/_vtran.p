/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _vtran.p

Description:
   This is the startup program for the Visual Translator tool.

Input/Output Parameters:
   
Author: John Palazzo

Date Created: 09/05/95

----------------------------------------------------------------------------*/

{ adecomm/adewrap.i
  &MSWIN   = adetran/vt/_main.p
  &MOTIF   = adetran/vt/_main.p
  &PRODUCT = "VTRAN"
  &SETCURS = WAIT
}
