/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _desk.p

Description:
   this is the startup program for the desktop.  It will run 
   festart.p which will log in to any connected databases,
   then then run desktop.p

Input/Output Parameters:
   
Author: Warren Bare

Date Created: 08/14/92

----------------------------------------------------------------------------*/

{ adecomm/adewrap.i
  &MSWIN   = adedesk/_desktop.p
  &MOTIF   = adedesk/_desktop.p
  &PRODUCT = "DESK"
  &SETCURS = WAIT }
