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

/*--------------------------------------------------------------------

File: prodict/_dctsget.p

Description:
    
    populates the shared variables that hold the available dbs info.
            
Input-Parameters:
    none

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    cache_db_l  array of logical db-names
    cache_db_p  array of physical db-names
    cache_db_s  array of names of the db, thats the schemaholder
    cache_db_t  array of db-types
    cache_db#   index of the current working-db to the above arrays


Author: Tom Hutegger

History:
    hutegger    94/06   creation (derived from & replacing old version)

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }

{ adecomm/getdbs.i
  &new = "NEW"
  }

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


ASSIGN
  cache_db#  = 0
  cache_db_l = ""
  cache_db_p = ""
  cache_db_s = ""
  cache_db_t = "".

if NUM-DBS > 0 
 then do:
  RUN adecomm/_dictdb.p.
  RUN adecomm/_getdbs.p.
  end.
  
for each s_ttb_db:
  
  /* get rid of older versions, because we can't handle them    */
  /* if s_ttb_db.vrsn <> "9" then next.                         */

  assign
    cache_db#             = cache_db# + 1
    cache_db_e[cache_db#] = s_ttb_db.dbtyp
                          + ( if s_ttb_db.vrsn < "9" 
                                then "/V" + s_ttb_db.vrsn
                                else ""
                            )
    cache_db_l[cache_db#] = s_ttb_db.ldbnm
    cache_db_p[cache_db#] = ( if s_ttb_db.cnnctd
                                then s_ttb_db.pdbnm
                                else ?
                            )
    cache_db_s[cache_db#] = s_ttb_db.sdbnm
    cache_db_t[cache_db#] = {adecomm/ds_type.i
                               &direction = "etoi"
                               &from-type = "s_ttb_db.dbtyp"
                            }
    cache_db_t[cache_db#] = cache_db_t[cache_db#]
                          + ( if s_ttb_db.vrsn < "9" 
                                then "/V" + s_ttb_db.vrsn
                                else ""
                            ).
  end.

