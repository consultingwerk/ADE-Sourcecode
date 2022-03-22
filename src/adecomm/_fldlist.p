/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: fldlist.p

Description:
   Fill a selection list with fields.  The fields will be ordered either
   either alphabetically or by order #.
   The database that these fields are stored in must be aliased to
   to DICTDB before this routine is called.

Input Parameters:
   p_List   - Handle of the selection list widget to add to.
	      p_List:private-data is a comma seperated list of items
	      NOT to be added. OR no items if the entire table-list is
	      to be added.

   p_Recid  - The recid of the table to which these fields belong.
   p_Alpha  - true if order should be alphabetical, false if we want to
      	      order by the _Order value of the field.
   p_Items  - List of fields to included in list.  If this parameter is
              blank, then just the field name is put in the list.  Currently
              the parameter can have the following values in any order:
              1 - just the field name - then is the default
              2 - tablename.fldname
              3 - dbname.tablename.fldname
              T - Name of table containing the field
              F - Format
   p_DType  - The data type to screen for.  If this is ?, then don't screen.
      	      Otherwise this must be either
      	       	  "character"
      	       	  "date"
      	       	  "decimal"
      	       	  "integer"
      	       	  "logical"
      	       	  "recid"
   p_ExpandExtent  - true if the array extents are to be expanded [1-N].


  p_CallBack  - The name of the program to run for security of a "" to blow
              this callback off.


Output Parameters:
   p_Stat   - Set to true if list is retrieved (even if there were no fields
      	      this is successful).  Set to false, if user doesn't have access
      	      to fields.

Author: Laura Stern, Warren Bare

Date Created: 06/02/92 

----------------------------------------------------------------------------*/


Define INPUT  PARAMETER p_List         as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Recid        as recid     	 NO-UNDO.
Define INPUT  PARAMETER p_Alpha        as logical   	 NO-UNDO.
Define INPUT  PARAMETER p_Items        as character 	 NO-UNDO.
Define INPUT  PARAMETER p_DType        as character      NO-UNDO.
Define INPUT  PARAMETER p_ExpandExtent as logical   	 NO-UNDO.
Define INPUT  PARAMETER p_CallBack     as character   	 NO-UNDO.
Define OUTPUT PARAMETER p_Stat         as logical    	 NO-UNDO.

define variable expandOption as integer no-undo.

if p_ExpandExtent = true then expandOption = 1.
                         else expandOption = 0.

run adecomm/_getflst.p(p_list, p_Recid, ?,
                               p_Alpha,
                               p_Items,
                               p_Dtype,
                               expandOption,
                               p_Callback,
                               output p_Stat).

RETURN.


