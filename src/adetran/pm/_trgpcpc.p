/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR CREATE OF xlatedb.XL_Procedure.
    find first xlatedb.XL_Project EXCLUSIVE-LOCK NO-ERROR.
    if avail xlatedb.XL_Project then
       xlatedb.XL_Project.NumberOfProcedures = xlatedb.XL_Project.NumberOfProcedures + 1.
    

