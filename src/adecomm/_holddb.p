/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _holddb.p

Description:
   This will return a parameter to the caller telling whether the database
   with the dictdb alias is a schemaholder db.  This needs to be a subprogram
   because the caller just changed the alias on the db.

Input/Output Parameters:
   
Author: Warren Bare

Date Created: 10/19/92

----------------------------------------------------------------------------*/

define output parameter p_holder as log.

p_holder = CAN-FIND(FIRST DICTDB._DB WHERE DICTDB._DB._DB-Type NE "Progress").
