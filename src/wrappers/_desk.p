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
