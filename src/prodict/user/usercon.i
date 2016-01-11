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
