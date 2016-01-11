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

File: nexttbl.i

Description:
   Find the next table, alphabetically, in the current database.

Arguments:
   &Name - table name to get next for
   &Next - "next" variable - will get set with the name of the next
      	   table (or "" if there is no next)

Author: Laura Stern

Date Created: 07/22/93
    Modified: 06/29/98 D. McMann Added _Owner to _File find

----------------------------------------------------------------------------*/

if s_Show_Hidden_Tbls then
   find FIRST _File where _File._Db-recid = s_DbRecId AND
       		     	  _File._File-Name > {&Name} AND
       		     	  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")       		     	  
      	     	          NO-ERROR.
else
   find FIRST _File where _File._Db-recid = s_DbRecId AND
       		     	  _File._File-Name > {&Name} AND
      	     	      	  NOT _File._Hidden AND
       		     	  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
      	     	          NO-ERROR.

{&Next} = (if AVAILABLE _File then _File._File-name else "").

