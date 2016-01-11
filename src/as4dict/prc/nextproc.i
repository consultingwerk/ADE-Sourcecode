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

File: nextproc.i

Description:
   Find the next procedure, alphabetically, in the current database.

Arguments:
   &Name - procedure name to get next for
   &Next - "next" variable - will get set with the name of the next
      	   procedure (or "" if there is no next)

Author: Donna McMann

Date Created: 05/04/99

----------------------------------------------------------------------------*/

FIND FIRST as4dict.p__File WHERE as4dict.p__File._File-Name > {&Name} 
    	     	      	     AND as4dict.p__File._Hidden <> "Y"
      	     	      	     AND as4dict.p__File._For-Info = "PROCEDURE"
      	     	          USE-INDEX  p__filel0 NO-ERROR.

{&Next} = (if AVAILABLE as4dict.p__File then as4dict.p__File._File-name else "").


