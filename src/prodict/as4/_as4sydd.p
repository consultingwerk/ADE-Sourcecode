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

/* -------------------------------------------------------------------   
  
   Procedure _as4sydd.p 

  Load is finished now see what user wants to do.  This procedures is used in
  usermenu.i as an entry point to the PROGRESS/400 dictionary directory.
  
  Created 05/05/95 D. McMann.
----------------------------------------------------------------------- */   

{ prodict/user/uservar.i }

 FIND _Db WHERE _Db._Db-name = ldbname("DICTDBG").

CREATE ALIAS as4dict FOR DATABASE VALUE(_Db._Db-name).      
RUN as4dict/as4_sydd.p.

{ as4dict/delalias.i }   /* delete alias */
