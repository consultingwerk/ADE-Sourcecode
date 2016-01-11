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

/* called from _usrsget.p, used with _dctsget.p */
/* ----------------------------------------------------------------------
File:   prodict/_dctsset.p

Description:
    1. sets drec_db to the currently selected _Db-record and sets
       dict_rog for this db
    2. issues a message if db-type is not supported by the current
       executable
    3. Reads file-list into cache

Input Parameters:
    none
    
Output Parameters:
    none

history:
        95/07    hutegger   Prefixed _Db with DICTDB
        07/09/98 D. McMann  Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                            to _File Finds
---------------------------------------------------------------------- */
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE INPUT PARAMETER nam AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */

DEFINE VARIABLE istrans  AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */
DEFINE VARIABLE i        AS INTEGER NO-UNDO.
DEFINE VARIABLE l_hidden AS LOGICAL NO-UNDO.

/* ------------------------------------------------------------------- */

DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
  end.


/* --- Check to see if dictionary is called from within Fast Track --- */

DO i = 1 TO i + 1
  WHILE PROGRAM-NAME(i) <> ?
  AND   NOT fast_track:
  fast_track = ( "ft.p" 
               = SUBSTRING(PROGRAM-NAME(i)
                          ,MAXIMUM(1
                                  ,LENGTH(PROGRAM-NAME(i)) - 3
                                  )
                          ,-1
                          ,"character"
                          )
               ).
  end.


/* -------------------- set drec_db and dict_rog --------------------- */

find DICTDB._Db WHERE DICTDB._Db._Db-name = nam.
assign
  drec_db  = RECID(DICTDB._Db)
  dict_rog = 
      istrans  /* cannot change dict if called from w/i a trans */
      OR PROGRESS = "Query"    /* or used with query product    */
      OR PROGRESS = "Run-Time" /* or used with run-time product */
      OR fast_track            /* or called from within Fast Track */
      OR CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")). /* or read-only DB */

/* (los 12/27/94) */
if NOT CAN-DO(GATEWAYS, DICTDB._Db._Db-type)
 then MESSAGE
    "This module does not support connections to this Data Server type."
    view-as alert-box.


/* -------------------- recreate file-list cache --------------------- */

find first DICTDB._File 
  where DICTDB._File._Db-recid  = drec_db 
  and   DICTDB._File._File-name = user_filename
  AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
   no-lock no-error.
assign l_hidden = ( available DICTDB._File
                    and DICTDB._File._Hidden = TRUE).

run prodict/_dctcach.p 
  ( INPUT l_hidden
  ).

/* ------------------------------------------------------------------- */

