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

File: fldlist.i

Description: 
   This is the piece of code that actually does the work for _fldlist.p - 
   to fill up a selection list with field names.  It is in a .i so that 
   we can avoid the overhead of calling an internal procedure for each field.
   This overhead adds up when you are dealing with very large databases.

Author: Laura Stern, Warren Bare Greg O'Connor

Date Created: 05/25/93
-----------------------------------------------------------------------------*/

ASSIGN
  v_BldLine = ""
  lInclude = TRUE.

DO v_ItemCnt = 1 to LENGTH(p_Items,"CHARACTER":u):

  IF p_CallBack <> "" THEN DO:

    RUN VALUE (p_CallBack) (v_DbName + "." + _File._File-name , bField._Field-name, 
                           USERID(v_DbName), OUTPUT lInclude).
  END. 

  IF lInclude THEN
    CASE SUBSTRING(p_Items,v_ItemCnt,1,"CHARACTER":u):
      WHEN "T" THEN v_BldLine = v_BldLine 
                              + STRING((if p_usetbl = ? THEN _File._File-name
                                                        ELSE p_usetbl),"x(20)":u).
      WHEN "F" THEN v_BldLine = v_BldLine 
                              + STRING(bField._Format,"x(15)":u).
      WHEN "1" THEN v_BldLine = v_BldLine 
                              + STRING(bField._Field-name,"x(32)":u).
      WHEN "2" THEN v_BldLine = v_BldLine 
                              + STRING((if p_usetbl = ? THEN _File._File-name
                                                        ELSE p_usetbl) + ".":u 
                              + bField._Field-name,"x(64)":u).
      WHEN "3" THEN v_BldLine = v_BldLine 
                              + STRING(v_DBName + ".":u
                                + (if p_usetbl = ? THEN _File._File-name
                                                        ELSE p_usetbl) + ".":u
                                + bField._Field-name,"x(70)":u).
    END CASE.
END.

IF (p_ExpandExtent > 0) AND (DICTDB.bField._Extent > 0) THEN
  if p_ExpandExtent = 1 then
   v_BldLine = TRIM(v_BldLine) + "[1-":u 
             + STRING (DICTDB.bField._Extent) + "]":u.
  else do:

     /*
      * Add *extent* number of entries to the list. And since we're putting
      * multiple entries restart the _vBldLine.
      */

     assign
         sep = ""
         fName = trim(v_BldLine)
         v_BldLine = ""
     .

     do i = 1 to DICTDB.bField._Extent:
         assign
             v_BldLine = v_BldLine + sep + fName + "[" + string(i) + "]"
             sep = ","
         .
     end.

  end.

/* Don't add an item if it's in the private data list. */
IF ((p_List:Private-data = ? OR p_List:Private-data = "" OR
    NOT CAN-DO (p_List:Private-data, TRIM(v_BldLine))) AND lInclude) THEN 

    do i = 1 to num-entries(v_BldLine):
        err = p_List:add-last(entry(i, TRIM(v_BldLine))).
    end.

/* fldlist.i - end of file */

