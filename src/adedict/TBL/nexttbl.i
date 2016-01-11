/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

