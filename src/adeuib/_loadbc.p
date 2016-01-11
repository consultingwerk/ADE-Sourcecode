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
/*----------------------------------------------------------------------------

File: _loadbc.p

Description:
    Given a _BC record this loads it with dictionary values.
         

Input Parameters:
   _BC-rec  -  The recid of the BC record to be loaded.

Output Parameters:
   <None>

Author: D. Ross Hunter


Date Created:  1995
Updated:	1/98 SLK Added new param to _fldinfo.p

---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}             /* UIB Temp-Tables                            */
{adeuib/brwscols.i}            /* Browse Column Temptable definitions        */
{adeuib/sharvars.i}            /* Shared variables                           */
{adecomm/getdbs.i &NEW="NEW"}  /* Temp-table of connected databases          */

DEFINE INPUT PARAMETER _BC-rec AS RECID NO-UNDO.

DEF VAR descrip     AS CHAR                NO-UNDO.
DEF VAR fmt-sa      AS CHAR                NO-UNDO.
DEF VAR hlp-sa      AS CHAR                NO-UNDO.
DEF VAR extnt       AS INTEGER             NO-UNDO.
DEF VAR intl        AS CHAR                NO-UNDO.
DEF VAR isaSMO      AS LOG                 NO-UNDO.
DEF VAR isSmartData AS LOG                 NO-UNDO.
DEF VAR lbl-sa      AS CHAR                NO-UNDO.
DEF VAR tmp-db      AS CHAR                NO-UNDO.
DEF VAR tmp-name    AS CHAR                NO-UNDO.
DEF VAR tmp-tb      AS CHAR                NO-UNDO.
DEF VAR valexp      AS CHAR                NO-UNDO.
DEF VAR valmsg      AS CHAR                NO-UNDO.
DEF VAR valmsg-sa   AS CHAR                NO-UNDO.

FIND _BC WHERE RECID(_BC) = _BC-rec.
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

/* Note isa.p doesn't work for SmartDataObject here because this is query that
   it is looking for.  */
RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)),
                   INPUT "SmartObject":U,
                   OUTPUT isaSMO).

isSmartData = isaSMO AND
              NOT CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                 _U._TYPE = "FRAME":U) AND
              NOT CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                 _U._TYPE = "DIALOG-BOX":U) AND
              _P._DB-AWARE.

IF _BC._DBNAME = "Temp-Tables" THEN DO:
  FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND _TT._NAME = _BC._TABLE NO-ERROR.
  IF NOT AVAILABLE _TT THEN
    FIND FIRST _TT WHERE _TT._p-recid = RECID(_P) AND _TT._LIKE-TABLE = _BC._TABLE.
  ASSIGN tmp-db = _TT._LIKE-DB
         tmp-tb = _TT._LIKE-TABLE.
END.  /* Set up for temp-tables */
ELSE
  ASSIGN tmp-db = _BC._DBNAME
         tmp-tb = _BC._TABLE.
                 
/* Make sure DICTDB alias is correct */
FIND DICTDB._db WHERE DICTDB._db._db-name =
           (IF tmp-db = ldbname("DICTDB":U) THEN ? ELSE tmp-db)
                      NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._db THEN DO:
  IF NOT CAN-FIND(FIRST s_ttb_db) THEN RUN adecomm/_getdbs.p.
  FIND FIRST s_ttb_db WHERE s_ttb_db.ldbnm = tmp-db NO-ERROR. 
  IF NOT AVAILABLE s_ttb_db THEN
    /* Handle the case where _BC._DBNAME is an alias */
    FIND FIRST s_ttb_db WHERE s_ttb_db.ldbnm = LDBNAME(tmp-db) NO-ERROR.
  IF AVAILABLE s_ttb_db THEN
    CREATE ALIAS DICTDB FOR DATABASE VALUE(s_ttb_db.sdbnm).
END.

/* Remove extent (if any from _BC._NAME) */
tmp-name = ENTRY(1,_BC._NAME,"[":U).
    
/* Get the default label, format and help of the field */
RUN adeuib/_fldinfo.p (INPUT tmp-db,
                       INPUT tmp-tb,
                       INPUT tmp-name,
                       OUTPUT _BC._DEF-LABEL,
                       OUTPUT lbl-sa,
                       OUTPUT _BC._DEF-FORMAT,
                       OUTPUT fmt-sa,
                       OUTPUT _BC._DATA-TYPE,
                       OUTPUT _BC._DEF-HELP,
                       OUTPUT hlp-sa,
                       OUTPUT extnt,
                       OUTPUT intl,
                       OUTPUT descrip,
                       OUTPUT valexp,
                       OUTPUT valmsg,
                       OUTPUT valmsg-sa,
                       OUTPUT _BC._MANDATORY
		).

/* _s-schem.p returns the column-label if it exists */
IF NOT isSmartData THEN 
  RUN adecomm/_s-schem.p (tmp-db, tmp-tb, _BC._NAME,
                          "FIELD:LABEL":U, OUTPUT _BC._DEF-LABEL).
                              
