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

File: parmlist.i

Description: 
   This is the piece of code that actually does the work for _prmlist.p - 
   to fill up a selection list with parmeter names.  It is in a .i so that 
   we can avoid the overhead of calling an internal procedure for each parameter.
   This overhead adds up when you are dealing with very large databases.

Author: Donna McMann
Date Created: 05/06/99
     
-----------------------------------------------------------------------------*/

ASSIGN
  v_BldLine = ""
  lInclude = TRUE.

DO v_ItemCnt = 1 to LENGTH(p_Items):             
  IF lInclude THEN
    CASE SUBSTR(p_Items,v_ItemCnt,1):
      WHEN "T" THEN v_BldLine = v_BldLine + STRING(as4dict.p__File._File-name,"x(20)").
      WHEN "F" THEN v_BldLine = v_BldLine + STRING(bParm._Format,"x(15)").
      WHEN "1" THEN v_BldLine = v_BldLine + STRING(bParm._Field-name,"x(32)").
      WHEN "2" THEN v_BldLine = v_BldLine + STRING(
        as4dict.p__File._File-name + "." + bParm._Field-name,"x(64)").
      WHEN "3" THEN v_BldLine = v_BldLine + STRING(
        v_DBName + "." + as4dict.p__File._File-name + "." + bParm._Field-name,"x(70)").
    END.
END.

/* Don't add an item if it's in the private data list. */
IF ((p_List:Private-data = ? OR p_List:Private-data = "" OR
    NOT CAN-DO (p_List:Private-data, TRIM(v_BldLine))) AND lInclude) THEN 

    do i = 1 to num-entries(v_BldLine):
        err = p_List:add-last(entry(i, TRIM(v_BldLine))).
    end.

