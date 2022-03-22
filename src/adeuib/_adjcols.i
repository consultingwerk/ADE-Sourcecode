/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _adjcols.i

Description:
Traps the END-RESIZE event of each browse-column and adjusts the size
of browse column to the one set after the resize opreation.

Input Parameters:
   h_self : The handle of the object we are editing

Output Parameters:
   <None>

Author: Alex Chlenski

Date Created: 07.28.2000 

----------------------------------------------------------------------------*/
IF _U._TYPE = "BROWSE" THEN DO:  /* The user may have changed the column widths */
  FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
    IF VALID-HANDLE(_BC._COL-HANDLE) THEN
      ASSIGN _BC._WIDTH = _BC._COL-HANDLE:WIDTH WHEN _BC._COL-HANDLE:WIDTH > 0.1.
  END.  /* FOR EACH column */
END.  /* If working on a browse */
