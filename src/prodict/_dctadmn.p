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


/*
To be a Security Administrator, you must have:

Write  permission on _File._Can-read
Write  permission on _File._Can-write
Write  permission on _File._Can-create
Write  permission on _File._Can-delete
Write  permission on _Field._Can-read
Write  permission on _Field._Can-write
Create permission on _User
Delete permission on _User

History:  07/14/98 DLM Added _Owner to _File finds

*/

DEFINE INPUT  PARAMETER usrn AS CHARACTER            NO-UNDO.
DEFINE OUTPUT PARAMETER okay AS LOGICAL INITIAL TRUE NO-UNDO.

/*check runtime privileges*/
FIND DICTDB._File "_File" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
FIND DICTDB._Field "_Can-read" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.
FIND DICTDB._Field "_Can-write" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.
FIND DICTDB._Field "_Can-create" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.
FIND DICTDB._Field "_Can-delete" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.

FIND DICTDB._File "_Field" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
FIND DICTDB._Field "_Can-read" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.
FIND DICTDB._Field "_Can-write" OF _File.
IF NOT CAN-DO(_Field._Can-write,usrn) THEN okay = FALSE.

FIND DICTDB._File "_User" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
IF NOT CAN-DO(_File._Can-create,usrn)
  OR NOT CAN-DO(_File._Can-delete,usrn) THEN okay = FALSE.

RETURN.

