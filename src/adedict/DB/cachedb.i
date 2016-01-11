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

File: cachedb.i

Description:
   Include file for code to store a new database into the database cache.

Arguments:
   &Lname   - Logical name to store
   &Pname   - Physical name to store
   &Holder  - Name of the schema holder
   &Type    - Database type.

Author: Laura Stern

Date Created: 03/03/92 

----------------------------------------------------------------------------*/


s_DbCache_Cnt = s_DbCache_Cnt + 1.

s_DbCache_Pname[s_DbCache_Cnt]  = {&Pname}.
s_DbCache_Holder[s_DbCache_Cnt] = {&Holder}.
s_DbCache_Type[s_DbCache_Cnt]  = {&Type}.


