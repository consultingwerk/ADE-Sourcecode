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

File: adecomm/_getfdbs.p

Description:
    
    creates s_ttb_db-records for all foreign schemas in this physical
    PROGRESS-Db
            
Input-Parameters:
    p_sdbnm     Name of SchemaHolder
    p_sdbnm     Name of SchemaHolder
    p_vrsn      Version of SchemaHolder

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    none
    
Author: Tom Hutegger

History:
    hutegger    94/06   creation
    hutegger    95/08   added dbrcd, empty and dspnm fields
    mcmann      00/07   Added check for _db-type = PROGRESS so duplicate
                        s_ttb_db records won't be created when auto connect
                        records are present.

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define input parameter p_dbnr       as integer.
define input parameter p_sdbnm      as character.
define input parameter p_vrsn       as character.

{ adecomm/getdbs.i }

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/*------------------------------------------------------------------*/

for each DICTDB._Db NO-LOCK:

  if  DICTDB._Db._Db-local = TRUE          /* not a foreign schema  */
   or DICTDB._Db._Db-name  = "z_ora_links" /* for internal use only */
   OR DICTDB._Db._Db-type = "PROGRESS"    /* Only foreign wanted */
   then next.

  IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
    find first DICTDB._File of DICTDB._Db WHERE
      LOOKUP(DICTDB._FILE._OWNER,"_FOREIGN":U) > 0      
      no-lock no-error.                     
  ELSE
    find first DICTDB._File of DICTDB._Db
         where DICTDB._File._File-num > 0   /* foregin schemas don't  */
      no-lock no-error.                     /* have negativ file-num  */
   

    create s_ttb_db.
    assign
      s_ttb_db.cnnctd = CONNECTED(DICTDB._Db._Db-name)
      s_ttb_db.dbnr   = p_dbnr
      s_ttb_db.dbrcd  = RECID(DICTDB._Db)
      s_ttb_db.dbtyp  = { adecomm/ds_type.i
                        &direction = "itoe"
                        &from-type = "DICTDB._Db._Db-type"
                      }
      s_ttb_db.dspnm  = DICTDB._Db._Db-name + "(" + p_sdbnm + ")"
      s_ttb_db.empty  = NOT available DICTDB._File
      s_ttb_db.ldbnm  = DICTDB._Db._Db-name
      s_ttb_db.local  = FALSE
      s_ttb_db.pdbnm  = ( if CONNECTED(DICTDB._Db._Db-name)
                          then PDBNAME(DICTDB._Db._Db-name)
                          else DICTDB._Db._Db-addr
                      )
      s_ttb_db.sdbnm  = p_sdbnm
      s_ttb_db.vrsn   = p_vrsn.
  
  end.

/*------------------------------------------------------------------*/
