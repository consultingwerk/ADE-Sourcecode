/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/* delete_p.i -- deletes the _P (procedure) record and its "extentions" */
     
/* Delete any ADM Links which references this _P */
FOR EACH _admlinks WHERE _admlinks._P-recid = RECID(_P):
  DELETE _admlinks.
END.

/* Delete any _TT records associated with this _P */
FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
  DELETE _TT.
END.

/* If the procedure has a Treeview, delete it. */
IF VALID-HANDLE(_P._tv-proc) THEN
DO:
    APPLY "CLOSE":U TO _P._tv-proc.
    IF VALID-HANDLE(_P._tv-proc) THEN
        DELETE PROCEDURE _P._tv-proc NO-ERROR.
END.

/* jep-icf: If the procedure has a property sheet object, delete it. */
IF VALID-HANDLE(_P.design_hpropsheet) THEN
DO:
    APPLY "CLOSE":U TO _P.design_hpropsheet.
    IF VALID-HANDLE(_P.design_hpropsheet) THEN
        DELETE PROCEDURE _P.design_hpropsheet NO-ERROR.
END.

/* Now delete the procedure */
DELETE _P.
