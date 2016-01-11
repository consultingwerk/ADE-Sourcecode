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

File: _prmlist.p

Description:
   Fill a selection list with parameters.  The parameters will be ordered alphabetically.
   
Input Parameters:
   p_List   - Handle of the selection list widget to add to.
	      p_List:private-data is a comma seperated list of items
	      NOT to be added. OR no items if the entire table-list is
	      to be added.

   p_Recid  - The recid of the procedure to which these parameters belong.
    

Output Parameters:
   p_Stat   - Set to true if list is retrieved (even if there were no parameters
              this is successful).  Set to false, if user doesn't have access
      	      to parameters.

Author: Donna McMann

Date Created: 04/05/99

----------------------------------------------------------------------------*/


Define INPUT  PARAMETER p_List         as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Recid        as recid     	 NO-UNDO.
Define INPUT  PARAMETER p_Items        as character 	 NO-UNDO.
Define OUTPUT PARAMETER p_Stat         as logical    NO-UNDO.

define buffer bParm for as4dict.p__Field.

define variable p_ExpandExtent as integer no-undo.
define variable v_dbname as character no-undo.
define variable err       as logical        NO-UNDO.
define variable widg      as widget-handle  NO-UNDO.
define variable v_ItemCnt as integer	       NO-UNDO.
define variable v_BldLine as char  	       NO-UNDO.
Define variable lInclude  as logical        NO-UNDO.
define variable i         as integer        no-undo.
define variable fName     as character      no-undo.
define variable sep       as character      no-undo.

FIND as4dict.p__File WHERE RECID(as4dict.p__File) = p_recid NO-ERROR.

FIND FIRST as4dict.p__DB. 
IF p_Items = "" THEN p_Items = "1".
v_dbname = as4dict.p__db._db-name.

widg = p_List:parent.  	/* gives me the group */
widg = widg:parent.  	/* gives me the frame */
run adecomm/_setcurs.p ("WAIT").

for each bParm where bParm._File-number = as4dict.p__file._File-number      	  	   
      	       	   NO-LOCK
    	       	   by bParm._Field-Name:
  ASSIGN v_BldLine = ""
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
 end.

run adecomm/_setcurs.p ("").
p_Stat = true.

RETURN.



