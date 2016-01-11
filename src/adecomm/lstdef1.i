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

File: lstdef1.i

Description:
    Includes all the definitions needed for a choice in a single pick list
    to be moved up or down one slot

Arguments
   
Author: David Lee

Date Created: 03/04/93
----------------------------------------------------------------------------*/


&IF (DEFINED(lstdef1) = 0)
&THEN

DEFINE VARIABLE lst_choice       AS CHARACTER NO-UNDO. /* value from widget */
DEFINE VARIABLE lst_pick_list    AS CHARACTER NO-UNDO. /* list in widget */
DEFINE VARIABLE lst_index        AS INTEGER   NO-UNDO.
DEFINE VARIABLE lstup_i          AS INTEGER   NO-UNDO.

&SCOPED-DEFINE lstdef1 1
&ENDIF

