/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: ispro.i

Description:
   Determine if the current database is a progress database.  This is 
   meant to be plugged into an IF statement - e.g., if {ispro.i} then...
 
Author: Laura Stern

Date Created: 03/05/92

----------------------------------------------------------------------------*/


(s_DbCache_Type[s_DbCache_ix] = "PROGRESS")
