/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*------------------------------------------------------------------------

name_U.i - standard include file to create an output name for a _U record
       Arguements: U_BUFFER -- name of the buffer. 
       
------------------------------------------------------------------------*/
       
(IF LDBNAME({&U_BUFFER}._DBNAME) NE ? AND NOT _suppress_dbname 
   THEN LDBNAME({&U_BUFFER}._DBNAME) + ".":U ELSE "":U)
 + (IF {&U_BUFFER}._TABLE ne ? THEN {&U_BUFFER}._TABLE + ".":U ELSE "":U) 
 + {&U_BUFFER}._NAME
 
/* name_u.i - end of file */

