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

File: _startup.p

Description:
    Startup the Workshop; initialize everything and create windows etc.
    This is called only once, when the Workshop is first initialized.
   
Input Parameters:
    <none>

Output Parameters:
    <none>

Return-Value:
   NO-LICENSE     : returned if the user does not have a Workshop license.

Author: Wm.T.Wood

Date Created: 1996

Modified:
 --------------------------------------------------------------------------*/

{ adecomm/adefext.i }      /* ADE Preprocessor - defines UIB_NAME */
{ workshop/j-define.i }     /* Shared table join temp-table        */
{ workshop/sharvars.i }    /* Most common shared variables        */
{ workshop/errors.i }      /* Error handling procedures           */
{ workshop/pre_proc.i }    /* Preprocessor Variables              */

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i NEW } 
&UNDEFINE DATASERVER

/* Local Variables */
DEFINE VARIABLE c-scrap   AS CHARACTER NO-UNDO.
DEFINE VARIABLE ilicense  AS INTEGER   NO-UNDO.

/* Start up the error handler, if necessary. */
IF NOT VALID-HANDLE(_err-hdl) OR
  _err-hdl:FILE-NAME ne "workshop/_errproc.w":U THEN
  RUN workshop/_errproc.w PERSISTENT SET _err-hdl.

/* ===================================================================== */
/*                             LICENSE CHECK                             */
/* ===================================================================== */
ilicense  = GET-LICENSE ("{&TOOL-SHORT-NAME}":U).
IF ilicense NE 0 THEN DO:
  CASE ilicense :
    WHEN 1 OR WHEN 3 THEN
      RUN Add-Error IN _err-hdl
        ("ERROR":U, ?,
         "A license for the {&TOOL-SHORT-NAME} is not available.").
    WHEN 2 THEN
      RUN Add-Error IN _err-hdl
        ("ERROR":U, ?, 
         "Your copy of the {&TOOL-SHORT-NAME} is past its expiration date.").
  END CASE.
  RETURN "NO-LICENSE":U.
END.

/* =====================================================================  */
/*            Setup environment and compute some globals                  */
/* =====================================================================  */

ASSIGN _numeric_format = SESSION:NUMERIC-FORMAT.

/* Establish UIB temporary file name. */
IF _comp_temp_file = ? THEN
  RUN adecomm/_tmpfile.p
    ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT _comp_temp_file).

/* Check connected databases. */
RUN check-dbs.

/* Create and load the Property information temp-table.  */
RUN workshop/_cr_prop.p.

/* Load File Preferences. */
RUN workshop/_getpref.p.

/* Load table relationships.  The QB AutoJoin feature has been removed for 
   Beta2, so this should be hidden for now. 
IF _reset_joins THEN
  RUN workshop/_jfind.p ("", OUTPUT c-scrap).
*/
  
/* =====================================================================  */
/*                           Internal Procedures                          */
/* =====================================================================  */

/* ---------------------------------------------------------------------
   check-dbs:
   
   Make sure the database and dictionary aliases are initialized 
   properly.  This code was "stolen" from the UIB and dictionary.
   ---------------------------------------------------------------------*/
PROCEDURE check-dbs :
  DEFINE VARIABLE i            AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE j            AS INTEGER                    NO-UNDO.
  DEFINE VARIABLE non          AS LOGICAL                    NO-UNDO. /* any non-PRO dbs? */
  DEFINE VARIABLE org          AS CHARACTER                  NO-UNDO.

  /* Make sure we have a decent DICTDB */
  IF DBTYPE("DICTDB":U) = "PROGRESS":U AND DBVERSION("DICTDB":U) <> "7":U THEN
    DELETE ALIAS "DICTDB":U.

  cache_dirty = ?. /* flag to dictgues that this is first time */
  RUN prodict/_dctsget.p. /* build db cache */
  IF NUM-DBS > 0 THEN DO:   /* Stolen code from prodict/_dctgues.p */
    org = LDBNAME("DICTDB":U).

    DO i = 1 TO cache_db# WHILE NOT non:
      non = cache_db_t[i] <> "PROGRESS":U.
    END.

    /* start optional code */
    IF non AND org <> ? AND DBTYPE("DICTDB":U) = "PROGRESS":U THEN DO:
      DO i = 1 TO cache_db# WHILE cache_db_l[i] <> LDBNAME("DICTDB":U):
        /* empty loop */
      END.
      RUN prodict/_dctscnt.p (INPUT cache_db_l[i], OUTPUT j).
      IF j = 0 THEN DELETE ALIAS "DICTDB".
    END.
    /* end optional code */

    DO i = 1 TO cache_db# WHILE LDBNAME("DICTDB":U) = ?:
      IF CAN-DO("PROGRESS/V5,PROGRESS/V6":U,cache_db_t[i])
         OR NOT CAN-DO(GATEWAYS,cache_db_t[i]) THEN NEXT.
      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(cache_db_s[i]) NO-ERROR.
      RUN prodict/_dctscnt.p (INPUT cache_db_l[i], OUTPUT j).
      IF j = 0 THEN
        DELETE ALIAS "DICTDB".
    END.
  END.

  /* If we don't have a DICTDB and we do have a connected DB, use the 1st */
  IF LDBNAME("DICTDB":U) = ? AND NUM-DBS > 0 AND cache_db# > 0 THEN DO:
   CREATE ALIAS DICTDB FOR DATABASE VALUE(cache_db_s[1]).
  END.
END PROCEDURE. /* check-dbs */

/* _startup.p - end of file */
