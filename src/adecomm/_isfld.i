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


