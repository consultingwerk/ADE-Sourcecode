/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* adetran\vt\_prpty.i */
 
find first tTblObj where (tTblObj.ObjWName = CurWin:Title)    and
                         (tTblObj.ObjName = {4}:name)         and
                         (tTblObj.ObjType = "{1}":U)          and
                         (COMPARE({2}, "=":U, {3}, "CAPS":U))
                         no-error.        
        
/* End of adetran\vt\_prpty.i */
