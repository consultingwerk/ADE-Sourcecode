/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_diskits.p
Author:       Ross Hunter
Created:      12/95
Updated:      
Purpose:      Procedure to disconnect from all connected kit databases.
                                     
*/          

DEFINE VARIABLE dbnm AS CHARACTER                           NO-UNDO.

FOR EACH xlatedb.XL_Kit WHERE NOT xlatedb.XL_Kit.KitZipped:
  dbnm = REPLACE(xlatedb.XL_Kit.KitName,".DB":U, "":U).
  IF CONNECTED(dbnm) THEN DISCONNECT VALUE(dbnm).
END.                                                                
