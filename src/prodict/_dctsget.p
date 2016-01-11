/*********************************************************************
* Copyright (C) 2000,2010 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    hutegger    94/06    creation (derived from & replacing old version)
    mcmann      11/26/02 Changed adecomm/_dictdb.p to prodict/_dictdb.p
    fernando    09/30/10 Support for OE11

                            
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
  RUN prodict/_dictdb.p.
  RUN adecomm/_getdbs.p.
  end.
  
for each s_ttb_db:
  
  /* get rid of older versions, because we can't handle them    */
  /* if s_ttb_db.vrsn <> "10" then next.                         */

  assign
    cache_db#             = cache_db# + 1
    cache_db_e[cache_db#] = s_ttb_db.dbtyp
                          + ( if INTEGER(s_ttb_db.vrsn) < 11 
                                then "/R" + s_ttb_db.vrsn
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
                          + ( if integer(s_ttb_db.vrsn) < 11 
                                then "/R" + s_ttb_db.vrsn
                                else ""
                            ).
  end.


