/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _isdata.i

Description: 
   Check to see if there is any data in this table.  This will be compiled
   at run time when we know what the table name is.
 
Argument:
   &1  - The table to check.

Output Parameter:
   p_IsData - Flag - set to yes if there is data, no otherwise.

Author: Laura Stern

Date Created: 11/16/92 

----------------------------------------------------------------------------*/

Define OUTPUT parameter p_IsData as logical NO-UNDO.


p_IsData = CAN-FIND(FIRST {1}).
