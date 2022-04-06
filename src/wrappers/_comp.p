/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _comp.p

Description:
   This is the startup program for the Progress Application Compiler.

Input/Output Parameters:
   
Author: Warren Bare

Date Created: 08/92

----------------------------------------------------------------------------*/

{ adecomm/adewrap.i
  &TTY     = adecomp/_procomp.p
  &MSWIN   = adecomp/_procomp.p
  &MOTIF   = adecomp/_procomp.p 
  &PRODUCT = "COMP"
  &SETCURS = WAIT }
