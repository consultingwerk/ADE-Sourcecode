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
**********************************************************************

File: _fldtype.p

Description:
    Takes a database-table-field and returns the data-type for it.    
    
    This is a wrapper routing to _fldtyp1.p that actually does the work.  This
    file just makes sure that if a dbname is specified, that DICTDB points to
    it.  

Input Parameter:   
   p_db-tbl-fld - name as triple: "db.tbl.fld" (We do handle the case of
                  "tbl.fld" by assuming DICTDB as the db.)

Output Parameter:
   p_fld_type      - The field data type

NOTE:  How to hook to a V6 Database.
   1) Start a V6 Server.
        a) rdl 6
        b) proserve db-name -H host-name -S demosv
          (eg. proserve ~stern/v6 -H kodiak -S demosv)    
   2) Connect to this in your V7 Session
        connect ~stern/v6 -H kodiak -S demosv         

Author: Wm.T.Wood

Date Created: May 1996
----------------------------------------------------------------------------*/
/*Copyright (c) by PROGRESS SOFTWARE CORPORATION. 1993 - AllRights Reserved.*/
DEFINE INPUT  PARAMETER p_db-tbl-fld AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_fld_type   AS CHARACTER NO-UNDO.

DEFINE VARIABLE db_name  AS CHARACTER NO-UNDO.
DEFINE VARIABLE rID      AS RECID     NO-UNDO.

/* Parse field name. (tbl.fld or db.tbl.fld) */
IF NUM-ENTRIES (p_db-tbl-fld, ".":U) eq 3 THEN DO:
  ASSIGN db_name  = ENTRY(1, p_db-tbl-fld, ".":U).
  /* Make sure that DICTDB points to the right database. */
  IF SDBNAME('DICTDB':U) ne db_name THEN
    /* Get the id of the database they picked. This will set DICTDB correctly. */ 
    RUN adecomm/_getdbid.p (db_name, OUTPUT rID).
END.

/* Run the actual workhorse file. */
RUN webutil/_fldtyp1.p (p_db-tbl-fld, OUTPUT p_fld_type).

/* end of _fldtype.p */

