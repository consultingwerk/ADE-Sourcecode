/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR CREATE OF xlatedb.XL_Instance.
    find first xlatedb.XL_Project exclusive-lock no-error.
    if avail xlatedb.XL_Project then
       xlatedb.XL_Project.NumberOfPhrases = 
         xlatedb.XL_Project.NumberOfPhrases + 1.
       

