/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* usercon.i - displays current dbname and dbtype */

DISPLAY
  user_dbname + (IF user_dbname = "" THEN "" ELSE " ("
    + ( IF CONNECTED(user_dbname) 
         THEN CAPS({adecomm/ds_type.i
                     &direction = "itoe"
                     &from-type = "user_dbtype"
                     }) 
         ELSE LC  ({adecomm/ds_type.i
                     &direction = "itoe"
                     &from-type = "user_dbtype"
                     })
      )
    + ")") @ user_dbname
  {*}
  WITH FRAME user_ftr.
