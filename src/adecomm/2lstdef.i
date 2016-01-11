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

File: 2lstdef.i

Description:
    Includes all the definitions needed to make a shadow pick list work

Arguments
   
Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/


&IF (DEFINED(include2lstup) = 0)
&THEN

  {adecomm/lstdef1.i}

  DEFINE VARIABLE lst2_index      AS INTEGER NO-UNDO.
  DEFINE VARIABLE lst2_shadow     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lst2_pick_list  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lst2_orig_index AS INTEGER NO-UNDO.

&SCOPED-DEFINE include2lstup 1
&ENDIF
