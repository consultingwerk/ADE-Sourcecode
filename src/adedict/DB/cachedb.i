/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


