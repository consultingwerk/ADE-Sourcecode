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
/* _anykey.p

    This looks wierd but it really does make sense!

    This routine will be run from ON ANYKEY persistent trigger on the fields
    in Form view.  (Because the trigger is persistent the body must be in a 
    separate .p - i.e. this one).  The whole point of this is to get around
    the GUI anomaly that in order to make a field moveable, it must be
    made sensitive as well.  This unfortunately makes it editable which is
    very misleading in Form View.  In order to really edit those fields the
    user must hit the Update button and proceed from there.

    This will act like a NO-APPLY from the ANYKEY trigger, which will block
    the editing from happening.
*/

RETURN ERROR.
