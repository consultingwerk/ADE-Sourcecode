/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _isfld.i

Description: 
   Check to see if a field and the table it belongs to are committed
   to the database and therefore in the schema cache by trying to compile 
   this .i which references the table and the field.
 
Argument:
   &1  - Name of the current database.
   &2  - The table that the field is in.
   &3  - The field we're checking for.

Author: Laura Stern

Date Created: 12/04/92 

----------------------------------------------------------------------------*/


/* We don't want any find trigger firing while we're doing this. */
disable triggers for dump of {1}.{2}.
find FIRST {1}.{2} NO-ERROR.

if AVAILABLE {1}.{2} then
   if {1}.{2}.{3} = ? then .


