/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dfldlist.i

Description: 
   This is the piece of code that actually does the work for _getdlst.p - 
   to fill up a selection list with field names.  It is in a .i so that 
   we can avoid the overhead of calling an internal procedure for each field.
   This overhead adds up when you are dealing with very large databases.
Author: SLK Stern, Warren Bare Greg O'Connor
Date Created: 02/98
Copied from fldlist.i
-----------------------------------------------------------------------------*/


ASSIGN v_BldLine = "":U.
DO v_ItemCnt = 1 to LENGTH(p_Items,"CHARACTER":u):
    CASE SUBSTRING(p_Items,v_ItemCnt,1,"CHARACTER":u):
      WHEN "T" THEN v_BldLine = v_BldLine + STRING(sdoData.fTable,"x(9)":U).
      WHEN "F" THEN v_BldLine = v_BldLine + STRING(sdoData.fFormat,"x(15)":u).
      WHEN "1" THEN v_BldLine = v_BldLine + STRING(sdoData.fName,"x(32)":u).
      WHEN "2" THEN v_BldLine = v_BldLine + STRING(sdoData.fTable + "." + sdoData.fName,"x(64)":u).
      WHEN "3" THEN v_BldLine = v_BldLine + STRING(sdoData.fName,"x(70)":u).
    END CASE.
END.

DO i = 1 to NUM-ENTRIES(v_BldLine):
   err = p_List:ADD-LAST(ENTRY(i,TRIM(v_BLdLine))).
END.
