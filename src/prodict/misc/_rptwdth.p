/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _rptwdth.p

History:  09/18/02 D. McMann Created


----------------------------------------------------------------------------*/

{ prodict/dictvar.i } 
{ prodict/user/uservar.i }

RUN prodict/misc/_rptwdat.p
   (INPUT drec_db,
    INPUT (IF LDBNAME(user_dbname) = ? 
      	     THEN user_dbname ELSE LDBNAME(user_dbname)),
    INPUT user_dbtype,
    INPUT user_filename,
    INPUT ?).
