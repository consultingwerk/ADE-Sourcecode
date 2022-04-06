/***********************************************************************
* Copyright (C) 2000,2008 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/* delete_p.i -- deletes the _P (procedure) record and its "extentions" */
     
/* Delete any ADM Links which references this _P */
FOR EACH _admlinks WHERE _admlinks._P-recid = RECID(_P):
  DELETE _admlinks.
END.

/* Delete any User Defined Field which references this _P */
FOR EACH _UF WHERE _UF._p-recid = RECID(_P):
    DELETE _UF.
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
