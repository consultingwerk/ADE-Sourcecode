/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _istbl.i

Description: 
   Check to see if a table is committed to the database and therefore
   in the schema cache by trying to compile this .i which references
   the table.
 
Argument:
   &1  - Name of current database
   &2  - The table to check.

Author: Laura Stern

Date Created: 12/04/92 

----------------------------------------------------------------------------*/

/* We don't want any find trigger firing while we're doing this. */
disable triggers for dump of {1}.{2}.
find FIRST {1}.{2} NO-ERROR. 

