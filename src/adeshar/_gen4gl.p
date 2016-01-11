/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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

File: _gen4gl.p

Description:
    Test creation of 4GL code -- This routine makes the .w file.
    NOTE: We always run adecomm/_setcurs.p ("") before a run of UIB_last.p
    but it is up to the calling routine to set the cursor in the first place.

Input Parameters:
   p_status     "EXPORT"
                "SAVE"
                "SAVE:CHECK"   This is a special remote WebSpeed case in which 
                               check-syntax is being performed on an untitled 
                               SmartDataObject.  We want to SAVE the object
                               remotely but only for the purpose of checking
                               its syntax.
                "PREVIEW"
                "RUN"
                "DEBUG"
                "PRINT"
                
Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Last Modified:

    jep        09/28/01 IZ 1429 adm-create-objects is db-required.
                        It now defaults to not db-required.
    jep        08/08/00 Assign _P recid to newly created _TRG records.
                        Also added _P recid check to the where clause of the
                        FIND FIRST _TRG when a compile error has occurred.
    achlensk   07/26/00 added fix for BUG# : 20000627-025
    achlensk   07/25/00 added fix for BUG# : 20000607-037
    tsm        06/10/99 Added auto-resize and columm-read-only attributes 
    tsm        06/04/99 Added context-help and context-help-file to CREATE WINDOW
    tsm        05/21/99 Added browse column visible attribute
    tsm        04/21/99 Added print status
    tsm        04/06/99 Added support for various Intl numeric formats
                        (in addition to American and European) by setting
                        the session numeric format back with 
                        set-numeric-format method 
    tsm        02/17/99 Changed SHOW-IN-TASKBAR to be written out if it is
                            TRUE and SMALL-TITLE is TRUE
    SLK        08/21/98 Removed EXPORT _BC._USER-LIST
    HD         07/15/98 Put user-fields in procedure settings
    SLK        06/23/98 Advise signature mismatch
    SLK        06/02/98 EXPORT _BC._USER-LIST
    GFS        04/18/98 Added Preproc around Window icon for TTY
    SLK        04/02/98 EXPORT _BC._NAME and _BC._INHERIT-VALIDATION
    SLK        03/25/98 Added signature check if recreating SmartObject
    SLK        02/98    added SmartData include file with temp table
    SLK        01/98    added SmartData
    GFS        03/27/95 removed Procedure Query, added "basic" query
    GFS        09/20/94 added XFTR support
    RPR        01/12/94 added Browse run-time attr
    hutegger   94/03/03 added call for extra session for
                             tty-windows on OSF/Motif
                             (look for "<hutegger> 94/03") 
    tullmann   07/19/94 modified the call to validbrw.i to
                             validate browser blocks.
---------------------------------------------------------------------------- */

{adecomm/adestds.i}
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/xftr.i}         /* XFTR TEMP-TABLE definition                        */
{adeuib/brwscols.i}     /* Browse Column Temp-table                          */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adecomm/adeintl.i}
{adeuib/links.i}
{adeuib/advice.i}
{adeuib/uibhlp.i}

/* FUNCTION PROTOTYPES */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.
FUNCTION db-tbl-name RETURNS CHARACTER
  (INPUT db-tbl AS CHARACTER) IN _h_func_lib.
FUNCTION dbtt-fld-name RETURNS CHARACTER
  (INPUT rec-recid AS RECID) IN _h_func_lib.

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* PROGRESS Preprocessor system message number. */
&GLOBAL-DEFINE PP-4345 4345
/* PROGRESS "Unable to create compile file: "file name" . */
&GLOBAL-DEFINE ERR-cant-compile 477

/* Preprocessor directives. */
&GLOBAL-DEFINE AMPER-IF     "&IF"
&GLOBAL-DEFINE AMPER-THEN   "&THEN"
&GLOBAL-DEFINE AMPER-ENDIF  "&ENDIF"

DEFINE INPUT PARAMETER p_status   AS CHAR.

{adeshar/genshar.i NEW} /* Shared variables for _gendefs.p */

DEFINE VARIABLE admVersion    AS CHAR                                  NO-UNDO.
DEFINE VARIABLE c_errMsg      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE choice        AS CHAR                                  NO-UNDO.
DEFINE VARIABLE comp_file     AS CHAR                                  NO-UNDO.
DEFINE VARIABLE context       AS CHAR                                  NO-UNDO.
DEFINE VARIABLE curr_browse   AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cRelName      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cReturnValue  AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cTemp         AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cTemp2        AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cTemp3        AS CHAR                                  NO-UNDO.
DEFINE VARIABLE cTempError    AS CHAR                                  NO-UNDO.
DEFINE VARIABLE def-values    AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE extra         AS CHAR                                  NO-UNDO.
DEFINE VARIABLE f_list        AS CHAR                                  NO-UNDO.
DEFINE VARIABLE fnt           AS INTEGER                               NO-UNDO.
DEFINE VARIABLE file_name     AS CHAR                                  NO-UNDO.
DEFINE VARIABLE first_pass    AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE frame_layer   AS WIDGET-HANDLE                         NO-UNDO.
DEFINE VARIABLE frame_parent  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE frame_sect    AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                               NO-UNDO.
DEFINE VARIABLE isaSDO        AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE isaSO         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE isaSContainer AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE i_count       AS INTEGER                               NO-UNDO.
DEFINE VARIABLE l_SDOExisted  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l_dummy       AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l_saveas      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE lOK           AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE multi-layout  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE n_down        AS INTEGER                               NO-UNDO.
DEFINE VARIABLE never-again   AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE ok2continue   AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE output-colLabel AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE output-format AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE output-help   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE output-label  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE output-width  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE output-valexp AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE proxy-file    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE proxy-temp    AS CHARACTER                             NO-UNDO.

DEFINE VARIABLE q_label       AS CHAR                                  NO-UNDO.
DEFINE VARIABLE qry_defs      AS LOGICAL         INITIAL FALSE         NO-UNDO.
       /* qry_defs    is a flag to indicate if query variable definitions    */
       /*             have been outputted                                    */
DEFINE VARIABLE self_name     AS CHAR                                  NO-UNDO.
DEFINE VARIABLE stp           AS INTEGER                               NO-UNDO.
DEFINE VARIABLE strt          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE tmp_file      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE sdo_tmp_file  AS CHAR                                  NO-UNDO.
DEFINE VARIABLE tmp_name      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE tmp_string    AS CHAR                                  NO-UNDO.
DEFINE VARIABLE tmp_string2   AS CHAR                                  NO-UNDO.
DEFINE VARIABLE trig_sect     AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE tt_sect       AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE TuneOpts      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE widget_sect   AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE window_sect   AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE run_persistent AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE run_flags     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE null_section  AS LOGICAL   INITIAL no                  NO-UNDO.
DEFINE VARIABLE wfrun         AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE ext           AS INTEGER                               NO-UNDO.
DEFINE VARIABLE OCXBinary     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE madeBinary    AS LOGICAL   INITIAL no                  NO-UNDO.
DEFINE VARIABLE bStatus       AS INTEGER   INITIAL 0                   NO-UNDO.
DEFINE VARIABLE write-access  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE app_handle    AS HANDLE                                NO-UNDO.
DEFINE VARIABLE OCXName       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE SpecialEvent  AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE web_file      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE TagLine       AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cSuperEvent   AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE lEmpty        AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE ctempFile     AS CHARACTER                             NO-UNDO.

DEFINE BUFFER x_U  FOR _U.
DEFINE BUFFER xx_U FOR _U.
DEFINE BUFFER x_L  FOR _L.
DEFINE BUFFER x_C  FOR _C.
DEFINE BUFFER x_Q  FOR _Q.
DEFINE BUFFER x_S  FOR _S.

DEFINE NEW SHARED STREAM P_4GL.

/* ************************************************************************* */

_p_status = p_status. /* sets shared var */

/* Initialize u_status - used to check status of an _U record                */
ASSIGN 
  u_status = IF p_status EQ "EXPORT" THEN "EXPORT" ELSE "NORMAL"
  l_saveas = (p_status EQ "SAVEAS":U).

/* If creating a new Super Procedure for a dynamic object, set the flag and
   change input parameter to "SAVE"                                          */
IF p_status BEGINS "SAVESuperProc":U THEN DO:
  ASSIGN CreatingSuper = YES
         lEmpty        = p_status MATCHES "*Empty*":U
         p_status      = "SAVE":U.
END.
ELSE 
  ASSIGN CreatingSuper = NO.

/* Get the procedure we are saving.                                          */
FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
ASSIGN 
  SESSION:NUMERIC-FORMAT = "AMERICAN":U
  run_persistent         = _P._RUN-PERSISTENT
  run_flags              = (IF run_persistent THEN "_PERSISTENT":U ELSE "")
  web_file               = (web-tmp-file <> "" AND web-tmp-file <> ?)
  .

/* Clean out _TRG._toffsets */
FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
  _TRG._tOFFSET = ?.
END.

/* Notify others of BEFORE and AFTER events (except for preview and print).  Provide
   opportunity for developer to cancel. */
IF p_status NE "PREVIEW":U AND p_status NE "PRINT":U THEN DO:
  /* Give others a chance to abort the save */
  context = STRING(_P._u-recid).
  RUN adecomm/_adeevnt.p (INPUT  "UIB":U, 
                          INPUT  "BEFORE-":U + p_status,
                          INPUT  context,
                          INPUT  _save_file,
                          OUTPUT ok2continue).
  IF NOT ok2continue THEN RETURN "Error-Override":U.
END.

/* Open output file. */
IF p_status BEGINS "SAVE":U THEN 
DO ON STOP  UNDO, RETRY
  ON ERROR UNDO, RETRY: /* if an error occurs writing this file, abort */
  IF RETRY THEN DO:
    MESSAGE "An error has occurred while writing to " + _save_file skip
            "This file cannot be saved until the problem is resolved."
            VIEW-AS ALERT-BOX ERROR.
    RETURN "Error-Write":U.
  END.
  
  ASSIGN write-access = "W":U. 
  RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)), INPUT "SmartDataObject":U,
                   OUTPUT isaSDO).
  IF NOT web_file THEN DO:
    ASSIGN l_SDOExisted = IF isaSDO AND SEARCH(_save_file) <> ? THEN YES ELSE NO.
    RUN adecomm/_osfrw.p
        (INPUT _save_file , INPUT "_WRITE-TEST":U , OUTPUT write-access).
  END.
  IF write-access <> "W":U THEN DO:
    MESSAGE _save_file SKIP
      "Cannot save to this file."  SKIP(1)
      "File is read-only or the path specified" SKIP
      "is invalid. Use a different filename."
      VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW ACTIVE-WINDOW.
    RETURN "Error-Write":U.
  END.
  
  /* Check and see if an SDO's .i exists when the SDO's.w does not */

  IF isaSDO
     AND (NOT web_file) 
     AND (NOT l_SDOExisted) THEN
  DO:
     sdo_tmp_file = SUBSTRING(_save_file,1,(LENGTH(_save_file) - 1)) + "i":U.
     IF SEARCH(sdo_tmp_file) <> ? THEN
     DO:
        RUN adecomm/_s-alert.p 
           (INPUT-OUTPUT lOK, 
            "information":U,
            "yes-no":U,
            SUBSTITUTE("&1 already exists. Do you want to replace it?:^^&2",
            sdo_tmp_file,
            cReturnValue)).
        IF NOT lOK THEN 
        DO:
           tmp_file =  SEARCH(_save_file).
           OS-DELETE VALUE(tmp_file) NO-ERROR.
           RETURN "Error-Write":U.
        END.
     END. /* no .w but .i found */
  END. /* Not web file */
  /* Output to temporary file */
  IF NOT web_file THEN
     RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                             OUTPUT cTempFile).
  /* Save WebSpeed file to local temp file before copying to WebSpeed agent. */
  OUTPUT STREAM P_4GL TO VALUE(IF web_file THEN web-tmp-file ELSE cTempFile).
END.
ELSE DO:
  IF _comp_temp_file = ? THEN
    RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                          OUTPUT _comp_temp_file).
  OUTPUT STREAM P_4GL TO VALUE(_comp_temp_file) {&NO-MAP}.
END.
/* ************************************************************************* */
/*                                                                           */
/*                    OUTPUT UIB "Tag" LINE & DESCRIPTION                    */
/*                                                                           */
/* ************************************************************************* */

FIND _U WHERE RECID(_U) EQ _P._u-recid.
FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".

/* OUTPUT VERSION NUMBER                                                     */
IF NOT CAN-DO("EXPORT,PREVIEW",p_status) THEN 
DO: 
   ASSIGN TagLine = "&ANALYZE-SUSPEND _VERSION-NUMBER " +
                    (IF _P._file-version BEGINS "AB_v9" THEN _UIB_VERSION
                     ELSE _P._file-version) +
                    (IF _P._FILE-TYPE EQ "w"
                     THEN (IF _L._WIN-TYPE THEN " GUI":U ELSE " Character":U)
                     ELSE (IF _P._ADM-VERSION <> "" THEN " -" ELSE "")) +
                    (IF _P._ADM-VERSION <> "" THEN " " + _P._ADM-VERSION ELSE "").
                    
   PUT STREAM P_4GL UNFORMATTED
      TagLine SKIP.
   IF _P._DESC <> "" THEN RUN Put_Proc_Desc.
   PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-RESUME" SKIP.
END.
IF p_status = "EXPORT" THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _EXPORT-NUMBER " _UIB_VERSION SKIP
      "&ANALYZE-RESUME" SKIP.

IF NUM-DBS > 0 THEN RUN db-conn.

IF CAN-DO ("RUN,DEBUG",p_status) THEN
  PUT STREAM P_4GL UNFORMATTED
    "&Scoped-define UIB_is_Running " _comp_temp_file SKIP
    "&Scoped-define AB_is_Running ~{~&UIB_is_Running~}" SKIP
    "&Scoped-define AppBuilder_is_Running ~{~&AB_is_Running~}" SKIP
    "&Scoped-define NEW            NEW" SKIP.

/* ************************************************************************* */
/*                                                                           */
/*                           GENERATE DEFINITIONS                            */
/*                                                                           */
/* ************************************************************************* */

IF _P._TYPE BEGINS "WEB":U THEN
  RUN adeweb/_gentt.p (RECID(_P)).

RUN adeshar/_gendefs.p (INPUT p_status, INPUT no).

/* ************************************************************************* */
/*                                                                           */
/*                             PROCEDURE SETTINGS                            */
/*                                                                           */
/* ************************************************************************* */

IF p_status NE "EXPORT" THEN DO:

    FIND _U WHERE _U._HANDLE EQ _P._WINDOW-HANDLE.
    
    PUT STREAM P_4GL UNFORMATTED SKIP (1)
     "/* *********************** Procedure Settings ************************ */"
      SKIP (1).
  
    IF p_status NE "PREVIEW" 
    THEN PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _PROCEDURE-SETTINGS" SKIP.
  
    PUT STREAM P_4GL UNFORMATTED
     "/* Settings for THIS-PROCEDURE" SKIP
     "   Type: " _P._TYPE (IF _P._template THEN " Template" ELSE "")
     SKIP.

    IF _P._file-type EQ "i" 
    THEN ASSIGN _P._compile = no
                _P._compile-into = ?.
    IF _P._compile-into NE ?
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Compile into: " _P._compile-into SKIP.

    IF _P._xTblList NE "":U 
    THEN PUT STREAM P_4GL UNFORMATTED
     "   External Tables: " _P._xTblList SKIP.

    IF _P._data-object NE "":U THEN DO:
      /* Remove X:/ (where X is the MS-DOS drive letter) if it can be found in
         the propath - IZ 9617                                                 */
      IF _P._data-object MATCHES ".:*":U THEN DO:
        IF SEARCH(SUBSTRING(_P._data-object, 4, -1, "CHARACTER")) NE ? THEN
          _P._data-object = SUBSTRING(_P._data-object, 4, -1, "CHARACTER").
      END.

       PUT STREAM P_4GL UNFORMATTED
       "   Data Source: " '"' _P._data-object '"' SKIP.
    END.

    /* Don't bother putting out the default "Allow" values.  Note that Windows
       have "Window" in the default. */
    IF _P._allow NE "Basic,Browse,DB-Fields":U +
                    (IF _U._TYPE EQ "WINDOW" THEN ",Window" ELSE "") AND 
      NOT CreatingSuper
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Allow: " _P._allow SKIP.
  
    /* Put out the Internal Container Links for SmartContainers (if they are
       not equal to the default value). */
    IF CAN-DO (_P._allow, "Smart") AND _P._links ne
       "Record-Source,Record-Target,Navigation-Source,Navigation-Target," + 
       "TableIO-Source,TableIO-Target,Page-Target" AND
      NOT CreatingSuper
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Container Links: " _P._links SKIP.
    
    IF _P._max-frame-count NE ? 
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Frames: " _P._max-frame-count SKIP.
  
    IF _P._add-fields NE "FRAME-QUERY"  
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Add Fields to: " _P._add-fields SKIP.

    IF _P._page-current NE 0  
    THEN PUT STREAM P_4GL UNFORMATTED 
     "   Design Page: " 
         (IF _P._page-current EQ ? THEN "All":U ELSE STRING(_P._page-current)) SKIP.
  
    IF _P._Editing NE "":U 
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Editing: " _P._Editing SKIP.

    IF _P._Events NE "":U 
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Events: " _P._Events SKIP.

    IF _P._partition NE "" AND _P._partition NE "(None)"
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Partition: " _P._partition SKIP.


    IF _P._persistent-only OR _P._file-type <> "w":U OR _P._compile OR
       _P._app-srv-aware
    THEN PUT STREAM P_4GL UNFORMATTED
     "   Other Settings:" 
         (IF _P._file-type = "p" THEN " CODE-ONLY"
          ELSE IF _P._file-type = "i" THEN " INCLUDE-ONLY"
          ELSE "") 
         (IF _P._persistent-only THEN " PERSISTENT-ONLY" ELSE "")
         (IF _P._compile         THEN " COMPILE" ELSE "")
         (IF _P._app-srv-aware   THEN " APPSERVER" ELSE "")
         (IF _P._db-aware        THEN " DB-AWARE" ELSE "")
         (IF _P._no-proxy        THEN " NO-PROXY" ELSE "")
         SKIP.
    
    IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) AND 
       (NOT CreatingSuper OR _P._TYPE = "SmartDataObject":U) THEN DO:
      PUT STREAM P_4GL UNFORMATTED
               "   Temp-Tables and Buffers:":U SKIP.
      FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
        PUT STREAM P_4GL UNFORMATTED
             "      TABLE: " IF _TT._NAME = ? THEN "? ":U
                                             ELSE (_TT._NAME + " ":U)
                           (_TT._TABLE-TYPE + " ":U)
                           '"':U + (IF _TT._SHARE-TYPE = "":U THEN "?":U ELSE
                                   _TT._SHARE-TYPE) + '" ':U
                           (IF _TT._UNDO-TYPE = "":U THEN
                            "?" ELSE _TT._UNDO-TYPE) + " ":U
                           _TT._LIKE-DB + " ":U _TT._LIKE-TABLE SKIP.
        IF _TT._ADDITIONAL_FIELDS NE "" THEN DO:
          tmp_string = "          ":U + REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                                                CHR(10) + "          ":U).
          PUT STREAM P_4GL UNFORMATTED
               "      ADDITIONAL-FIELDS:":U SKIP
               tmp_string SKIP
               "      END-FIELDS.":U SKIP.
        END. /* If there are additional fields */
      END. /* FOR EACH _TT */
      PUT STREAM P_4GL UNFORMATTED
        "   END-TABLES.":U
         SKIP.
    END. /* if there are any temp-tables or buffers */
    
    IF CAN-FIND(FIRST _UF WHERE _UF._p-recid = RECID(_P)) THEN DO:
       FIND FIRST _UF WHERE _UF._p-recid = RECID(_P).
     
       PUT STREAM P_4GL UNFORMATTED
           "   User-Fields:":U SKIP 
           "           ":U +
           REPLACE(_UF._DEFINITIONS, CHR(10),CHR(10) + "           ":U) SKIP
           "   END-USER-FIELDS.":U        SKIP.
    
    END. /* if there are any user fields */
     
    PUT STREAM P_4GL UNFORMATTED
     " */" SKIP.

    /* If this Procedure should only be run persistent, then add code that 
       ensures this. */
    IF _P._persistent-only AND (LOOKUP(p_status,"RUN,DEBUG":U) = 0 OR
       _cur_win_type) THEN
      PUT STREAM P_4GL UNFORMATTED SKIP (1)
      "/* This procedure should always be RUN PERSISTENT.  Report the error,  */"
      SKIP
      "/* then cleanup and return.                                            */"
      SKIP
      "IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:" SKIP
      "  MESSAGE ""~{&FILE-NAME} should only be RUN PERSISTENT."":U" SKIP
      "          VIEW-AS ALERT-BOX ERROR BUTTONS OK." SKIP
      "  RETURN." SKIP
      "END."  SKIP (1).
    
    IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-RESUME _END-PROCEDURE-SETTINGS" SKIP.
END. /* IF...not...EXPORT...*/
 
/* ************************************************************************* */
/*                                                                           */
/*                              WINDOW CREATION                              */
/*                                                                           */
/* ************************************************************************* */
FIND _U WHERE _U._HANDLE  = _h_win.
FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".
FIND _C WHERE RECID(_C)   = _U._x-recid.

/* If the master layout, update position so that most recent changes */
/* take hold.  But, only if the window is in a 'normal' state.       */
IF _U._LAYOUT-NAME = "Master Layout" AND _U._TYPE NE "DIALOG-BOX" AND
   _h_win:WINDOW-STATE EQ WINDOW-NORMAL THEN 
  ASSIGN _L._ROW    = _h_win:ROW 
         _L._COL    = _h_win:COLUMN
         .        
IF wndw AND p_status NE "EXPORT" THEN DO:
  PUT STREAM P_4GL UNFORMATTED SKIP (1)
   "/* *************************  Create Window  ************************** */"
    SKIP (1).

  IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _CREATE-WINDOW" SKIP.

  ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE(_U._LABEL,
                   "~~","~~~~"), "~"","~~~""), "~\","~~~\"),"~;","~~~;").
  
 /* Write out that we're generating a create window statement for
    a design window for non-window objects.
 */
 IF NOT CAN-DO(_P._ALLOW, "Window":U) THEN
 DO:
    PUT STREAM P_4GL UNFORMATTED
      "/* DESIGN Window definition (used by the UIB) " SKIP
      "  CREATE WINDOW " _U._NAME " ASSIGN"                   SKIP.
    IF _C._EXPLICIT_POSITION THEN PUT STREAM P_4GL UNFORMATTED
      "         COLUMN             = " _L._COL                SKIP
      "         ROW                = " _L._ROW                SKIP.
    PUT STREAM P_4GL UNFORMATTED
      "         HEIGHT             = " _L._HEIGHT             SKIP
      "         WIDTH              = " _L._WIDTH  
                                                 "."          SKIP
      "/* END WINDOW DEFINITION */"                           SKIP
      . /* END PUT */
    PUT STREAM P_4GL UNFORMATTED
    "                                                                        */"
    SKIP.
    IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-RESUME" SKIP.
 END.
 ELSE DO:
   IF _C._SUPPRESS-WINDOW THEN PUT STREAM P_4GL UNFORMATTED 
      "/* SUPPRESS Window definition (used by the UIB) " SKIP.

  PUT STREAM P_4GL UNFORMATTED
      "IF SESSION:DISPLAY-TYPE = ~"GUI~":U THEN" SKIP
      "  CREATE WINDOW " _U._NAME " ASSIGN"                                SKIP
      "         HIDDEN             = YES"                                  SKIP
      "         TITLE              = """ q_label """"
                IF _U._LABEL-ATTR NE "" THEN ":" + _U._LABEL-ATTR ELSE ""  SKIP.
  IF _U._LAYOUT-UNIT THEN DO:
    IF _C._EXPLICIT_POSITION THEN PUT STREAM P_4GL UNFORMATTED
      "         COLUMN             = " _L._COL                    SKIP
      "         ROW                = " _L._ROW                    SKIP.
    PUT STREAM P_4GL UNFORMATTED
      "         HEIGHT             = " _L._HEIGHT                 SKIP
      "         WIDTH              = " _L._WIDTH                  SKIP
      "         MAX-HEIGHT         = " _L._VIRTUAL-HEIGHT         SKIP
      "         MAX-WIDTH          = " _L._VIRTUAL-WIDTH          SKIP
      "         VIRTUAL-HEIGHT     = " _L._VIRTUAL-HEIGHT         SKIP
      "         VIRTUAL-WIDTH      = " _L._VIRTUAL-WIDTH          SKIP.
  END.
  ELSE DO: /* PIXELS */
  
    IF _C._EXPLICIT_POSITION THEN PUT STREAM P_4GL UNFORMATTED
      "         X                  = " INTEGER((_L._COL - 1) *
                                              SESSION:PIXELS-PER-COLUMN) SKIP
      "         Y                  = " INTEGER((_L._ROW - 1) *
                                              SESSION:PIXELS-PER-ROW)    SKIP.
    PUT STREAM P_4GL UNFORMATTED
      "         HEIGHT-P           = " INTEGER(_L._HEIGHT *
                                              SESSION:PIXELS-PER-ROW)    SKIP
      "         WIDTH-P            = " INTEGER(_L._WIDTH  *
                                              SESSION:PIXELS-PER-COLUMN) SKIP
      "         MAX-HEIGHT-P       = " INTEGER(_L._VIRTUAL-HEIGHT *
                                              SESSION:PIXELS-PER-ROW)    SKIP
      "         MAX-WIDTH-P        = " INTEGER(_L._VIRTUAL-WIDTH  *
                                              SESSION:PIXELS-PER-COLUMN) SKIP
      "         VIRTUAL-HEIGHT-P   = " INTEGER(_L._VIRTUAL-HEIGHT *
                                              SESSION:PIXELS-PER-ROW)    SKIP
      "         VIRTUAL-WIDTH-P    = " INTEGER(_L._VIRTUAL-WIDTH  *
                                              SESSION:PIXELS-PER-COLUMN) SKIP.
  END.    
  
  /* SMALL-TITLE defaults to FALSE, write it out only if it's TRUE */
  IF _C._SMALL-TITLE THEN
    PUT STREAM P_4GL UNFORMATTED
      "         SMALL-TITLE        = " _C._SMALL-TITLE         SKIP.
  /* SHOW-IN-TASKBAR default to TRUE, write it out if it's FALSE OR
     if it is TRUE and SMALL-TITLE is TRUE 
     SHOW-IN-TASKBAR defaults to FALSE when SMALL-TITLE is set to TRUE 
     but this can be overridden by setting SHOW-IN-TASKBAR to TRUE 
     AFTER setting SMALL-TITLE to TRUE */
  IF NOT _C._SHOW-IN-TASKBAR OR (_C._SHOW-IN-TASKBAR AND _C._SMALL-TITLE) THEN
    PUT STREAM P_4GL UNFORMATTED
      "         SHOW-IN-TASKBAR    = " _C._SHOW-IN-TASKBAR     SKIP.
  /* CONTROL-BOX defaults to TRUE, write it out if it's FALSE. Also
   * write it out if it is set to TRUE and SMALL-TITLE is TRUE. In that
   * case, setting CONTROL-BOX to TRUE leaves a Close button on the window.
   */
  IF (NOT _C._CONTROL-BOX) OR (_C._CONTROL-BOX AND _C._SMALL-TITLE) THEN
    PUT STREAM P_4GL UNFORMATTED
      "         CONTROL-BOX        = " _C._CONTROL-BOX         SKIP.
  /* Since MIN-BUTTON defaults to TRUE and MIN-BUTTON does not appear when 
   * SMALL-TITLE is TRUE, only write out MIN-BUTTON when SMALL-TITLE is
   * FALSE.
   */ 
  IF NOT _C._MIN-BUTTON THEN
    PUT STREAM P_4GL UNFORMATTED
      "         MIN-BUTTON         = " _C._MIN-BUTTON          SKIP.
  /* MAX-BUTTON uses the same logical as for MIN-BUTTON */
  IF NOT _C._MAX-BUTTON THEN  
    PUT STREAM P_4GL UNFORMATTED
      "         MAX-BUTTON         = " _C._MAX-BUTTON          SKIP.
  /* ALWAYS-ON-TOP defaults to FALSE, write it out if it's TRUE */
  IF _C._ALWAYS-ON-TOP THEN
    PUT STREAM P_4GL UNFORMATTED
      "         ALWAYS-ON-TOP      = " _C._ALWAYS-ON-TOP       SKIP.
  /* TOP-ONLY defaults to FALSE, but if it's TRUE, only write it out if
   * ALWAYS-ON-TOP is FALSE since it encompasses this functionality
   */
  ELSE IF _C._TOP-ONLY THEN
    PUT STREAM P_4GL UNFORMATTED
      "         TOP-ONLY           = " _C._TOP-ONLY            SKIP.
  /* DROP-TARGET defaults to FALSE, write it out only if it's TRUE */
  IF _U._DROP-TARGET THEN
    PUT STREAM P_4GL UNFORMATTED
      "         DROP-TARGET        = " _U._DROP-TARGET         SKIP.
      
  PUT STREAM P_4GL UNFORMATTED        
      "         RESIZE             = " _U._RESIZABLE           SKIP
      "         SCROLL-BARS        = " _C._SCROLL-BARS         SKIP
      "         STATUS-AREA        = " _C._STATUS-AREA         SKIP
      "         BGCOLOR            = " _L._BGCOLOR             SKIP
      "         FGCOLOR            = " _L._FGCOLOR             SKIP.

  IF _U._POPUP-RECID NE ? THEN DO:
    FIND xx_U WHERE RECID(xx_U) = _U._POPUP-RECID.
    PUT STREAM P_4GL UNFORMATTED SKIP
      "         POPUP-MENU         = MENU " xx_U._NAME ":HANDLE" SKIP.
  END.
  IF _U._PRIVATE-DATA NE "" THEN DO:
    tmp_string = "~"" + _U._PRIVATE-DATA + "~"".
    IF _U._PRIVATE-DATA-ATTR NE "":U AND _U._PRIVATE-DATA-ATTR NE ? THEN
    tmp_string = tmp_string + ":":U + _U._PRIVATE-DATA-ATTR.
    PUT STREAM P_4GL UNFORMATTED SKIP
      "         PRIVATE-DATA       = " tmp_string SKIP.
  END.
  IF _C._KEEP-FRAME-Z-ORDER THEN
    PUT STREAM P_4GL UNFORMATTED
      "         KEEP-FRAME-Z-ORDER = yes"                     SKIP.
  IF _L._3-D THEN
    PUT STREAM P_4GL UNFORMATTED
      "         THREE-D            = yes"                     SKIP.
  IF _L._FONT NE ? THEN
    PUT STREAM P_4GL UNFORMATTED
      "         FONT               = " _L._FONT               SKIP.
      
  /* CONTEXT-HELP defaults to FALSE, only write out if it's TRUE */
  IF _C._CONTEXT-HELP THEN
    PUT STREAM P_4GL UNFORMATTED
      "         CONTEXT-HELP       = " _C._CONTEXT-HELP       SKIP.
  IF _C._CONTEXT-HELP-FILE > "" THEN
    PUT STREAM P_4GL UNFORMATTED
      "         CONTEXT-HELP-FILE  = """ _C._CONTEXT-HELP-FILE """:U" SKIP.

  PUT STREAM P_4GL UNFORMATTED
      "         MESSAGE-AREA       = " _C._MESSAGE-AREA       SKIP
      "         SENSITIVE          = " _U._SENSITIVE "."      SKIP.
  PUT STREAM P_4GL UNFORMATTED
      "ELSE ~{&WINDOW-NAME} = CURRENT-WINDOW."                SKIP.
   
  IF menubar_name <> "" OR _U._POPUP-RECID NE ? THEN DO:
    IF _U._POPUP-RECID NE ? THEN
      FIND xx_U WHERE RECID(xx_U) = _U._POPUP-RECID.
    tmp_string = "ASSIGN ~{&WINDOW-NAME}:".
    IF menubar_name <> "" THEN
      tmp_string = tmp_string + "MENUBAR    = MENU " + menubar_name + ":HANDLE" +
                   IF _U._POPUP-RECID NE ? THEN CHR(10) + "       ~{&WINDOW-NAME}:"
                                           ELSE ".".
    IF _U._POPUP-RECID NE ? THEN 
      tmp_string = tmp_string + "POPUP-MENU = MENU " + xx_U._NAME + ":HANDLE.".
      
    PUT STREAM P_4GL UNFORMATTED SKIP (1) tmp_string SKIP.
  END.
  
  IF _C._ICON NE ? AND _C._ICON NE "" THEN
    PUT STREAM P_4GL UNFORMATTED SKIP (1)
        "&IF '~{&WINDOW-SYSTEM}' NE 'TTY' &THEN" SKIP
        "IF NOT " _U._NAME ":LOAD-ICON(""" + _C._ICON + """:U) THEN" SKIP
        "    MESSAGE ~"Unable to load icon: " _C._ICON "~"" SKIP
        "            VIEW-AS ALERT-BOX WARNING BUTTONS OK." SKIP
        "&ENDIF" SKIP.
        
  IF _C._SMALL-ICON NE ? AND _C._SMALL-ICON NE "" THEN
    PUT STREAM P_4GL UNFORMATTED SKIP (1)
        "&IF '~{&WINDOW-SYSTEM}' NE 'TTY' &THEN" SKIP
        "IF NOT " _U._NAME ":LOAD-SMALL-ICON(""" + _C._SMALL-ICON + """:U) THEN" SKIP
        "    MESSAGE ~"Unable to load small icon: " _C._SMALL-ICON "~"" SKIP
        "            VIEW-AS ALERT-BOX WARNING BUTTONS OK." SKIP
        "&ENDIF" SKIP.
        
  IF _C._SUPPRESS-WINDOW THEN
    PUT STREAM P_4GL UNFORMATTED 
    "                                                                        */"  SKIP.
  PUT STREAM P_4GL UNFORMATTED
    "/* END WINDOW DEFINITION                                                */"  SKIP.
  IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-RESUME" SKIP.

  IF _C._SUPPRESS-WINDOW AND _P._FILE-TYPE = "w":U THEN
    PUT STREAM P_4GL UNFORMATTED
        "ASSIGN " _U._NAME  " = CURRENT-WINDOW."
        SKIP (1).
 END. /* IF Allow Window */  
END.  /* If wndw */
  
/* Write out any XFTRs to follow the CONTROLDEFS section in .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&CONTROLDEFS}, INPUT no).

/* ************************************************************************* */
/*                                                                           */
/*                     OUTPUT INCLUDED LIBRARIES CODE BLOCK                  */
/*                                                                           */
/* ************************************************************************* */

/* First Output the included libraries (if any)                              */
PUT STREAM P_4GL UNFORMATTED SKIP (1).
FIND _U WHERE _U._HANDLE = _h_win.
FIND _TRG  WHERE _TRG._wRECID   EQ RECID(_U) AND
                 _TRG._tSECTION EQ "_CUSTOM" AND
                 _TRG._tEVENT   EQ "_INCLUDED-LIB" AND
                 _TRG._STATUS   EQ u_status NO-ERROR.
IF AVAILABLE _TRG AND (NOT CreatingSuper OR _P._TYPE = "SmartDataObject":U) 
  THEN RUN put_code_block.
/* Write out any XFTRs that follow this Block in .W */
IF p_status NE "EXPORT" THEN 
    RUN put_next_xftrs (INPUT {&INCLUDED-LIB}, INPUT no).

IF CreatingSuper THEN 
DO:
  PUT STREAM P_4GL UNFORMATTED SKIP(1)
    "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure" SKIP
    "/* ************************* Included-Libraries *********************** */" SKIP(1)
    "~{src/adm2/customsuper.i}" SKIP(1)
    "/* _UIB-CODE-BLOCK-END */" SKIP
    "&ANALYZE-RESUME" SKIP.
END.

/* ************************************************************************* */
/*                                                                           */
/*                           RUN-TIME ATTRIBUTES                             */
/*                                                                           */
/* ************************************************************************* */
 
/* Generate RT Attribute ony if the UIB file type is .w. */
RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)), INPUT "SmartDataObject":U,
                   OUTPUT isaSDO).
IF _P._FILE-TYPE = "w":U OR isaSDO THEN
DO:
  {adeuib/_genrt.i}  
END.

/* ************************************************************************* */
/*                                                                           */
/*                       QUERIES AND BROWSE WIDGETS                          */
/*                                                                           */
/* ************************************************************************* */

/* Define the Queries and Browse Widgets for this window                     */
/* Put out the header for the section only for the first non-blank query.    */
IF NOT CreatingSuper OR _P._TYPE = "SmartDataObject":U THEN DO:
  i_count = 0.
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win 
                  AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY":U,_U._TYPE) 
                  AND _U._STATUS = u_status,
      EACH _C WHERE RECID(_C)    = _U._x-recid,
      EACH _Q WHERE RECID(_Q)    = _C._q-recid BY _U._NAME BY _U._TYPE:
  
    /* We always put out QUERY objects (because they are defined here and only
       here.  We only put out FRAME and BROWSE queries if necessary. */
    IF (_U._TYPE EQ "QUERY")  
      OR
       ( (_U._TYPE EQ "BROWSE")  AND
         CAN-FIND(FIRST _BC WHERE _BC._x-recid EQ RECID(_U)) )
      OR
       ( CAN-FIND(_TRG WHERE _TRG._wRECID EQ RECID(_U) AND 
                             _TRG._tEVENT EQ "OPEN_QUERY":U) )
      OR
       (_Q._4GLQury NE ? AND _Q._4GLQury NE "") 
      OR 
       (_Q._OpenQury EQ NO)
    THEN DO:
      /* The NOT OpenQury is to preserve that status even if not tables in the */
      /* the query.                                                            */
      i_count = i_count + 1.
      IF i_count EQ 1 THEN 
        PUT STREAM P_4GL UNFORMATTED SKIP (1)
        "/* Setting information for Queries and Browse Widgets fields            */"
        SKIP (1).
        IF p_status NE "PREVIEW":U THEN PUT STREAM P_4GL UNFORMATTED
            "&ANALYZE-SUSPEND _QUERY-BLOCK " _U._TYPE " " _U._NAME SKIP .

        PUT STREAM P_4GL UNFORMATTED          
            "/* Query rebuild information for ".
        IF _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U THEN
             PUT STREAM P_4GL UNFORMATTED _U._SUBTYPE " " _U._NAME SKIP.
        ELSE PUT STREAM P_4GL UNFORMATTED _U._TYPE " " _U._NAME SKIP.

        /* Handle freeform query situation */
        FIND _TRG WHERE _TRG._wRECID EQ RECID(_U) AND
                        _TRG._tEVENT EQ "OPEN_QUERY":U NO-ERROR.
        IF AVAILABLE _TRG THEN DO:  /* A Freeform query */
          PUT STREAM P_4GL UNFORMATTED          
            "     _START_FREEFORM" SKIP _TRG._tCODE SKIP
            "     _END_FREEFORM" SKIP.
          FIND _TRG WHERE _TRG._wRECID EQ RECID(_U) AND
                          _TRG._tEVENT EQ "DEFINE_QUERY":U NO-ERROR.
          IF AVAILABLE _TRG THEN DO:  /* A Freeform DEFINE QUERY */
            PUT STREAM P_4GL UNFORMATTED     
            "     _START_FREEFORM_DEFINE" SKIP TRIM(_TRG._tCODE) SKIP
            "     _END_FREEFORM_DEFINE" SKIP.
          END.  /* If a free form define query */
        END.  /* Freeform query */
        ELSE DO:  /* Not a freeform query */
          ASSIGN TuneOpts = REPLACE(REPLACE(TRIM(_Q._TuneOptions),CHR(13),""),
                                    CHR(10),CHR(10) + FILL(" ",26)) .
               
          IF _Q._TblList NE "" THEN PUT STREAM P_4GL UNFORMATTED 
                 "     _TblList          = """ _Q._TblList """" SKIP .
        END.  /* Not a freeform query */
      
        /* Frame Queries default to SHARE-LOCK */
        IF (_U._TYPE EQ "FRAME" AND _Q._OptionList NE "SHARE-LOCK") OR
           (_U._TYPE NE "FRAME" AND _Q._OptionList NE "") 
        THEN PUT STREAM P_4GL UNFORMATTED 
               "     _Options          = """ _Q._OptionList """" SKIP.
             
        IF NOT AVAILABLE _TRG THEN DO:  /* If not a freeform query */
          IF TuneOpts NE "" THEN PUT STREAM P_4GL UNFORMATTED 
                 "     _TuneOptions      = """ TuneOpts """" SKIP.
          IF _Q._TblOptList NE "" THEN PUT STREAM P_4GL UNFORMATTED 
                 "     _TblOptList       = """ TRIM(_Q._TblOptList) """" SKIP.   
          IF _Q._OrdList NE "" THEN PUT STREAM P_4GL UNFORMATTED 
              "     _OrdList          = """ _Q._OrdList """" SKIP.
  
          EXTENT-STUFF:
          REPEAT i = 1 TO NUM-ENTRIES(_Q._TblList):
            IF _Q._JoinCode[i] = ? AND
               _Q._Where[i] = ? THEN NEXT EXTENT-STUFF.
            ASSIGN tmp_string = REPLACE(_Q._Where[i],CHR(34),CHR(34) + CHR(34))
                   tmp_string2 = REPLACE(_Q._JoinCode[i],CHR(34),CHR(34) + CHR(34)).
            IF _Q._JoinCode[i] NE ? AND _Q._JoinCode[i] NE ""
            THEN PUT STREAM P_4GL UNFORMATTED
                 "     _JoinCode[" i "]      = "
                          IF tmp_string2 = ? THEN tmp_string2
                                 ELSE ("~"" + tmp_string2 + "~"") SKIP.
            IF _Q._Where[i] NE ? and _Q._Where[i] NE ""
            THEN PUT STREAM P_4GL UNFORMATTED 
                 "     _Where[" i "]         = "
                          IF tmp_string = ?  THEN tmp_string
                                 ELSE ("~"" + tmp_string + "~"") SKIP.
          END.  /* Extent-Stuff: Repeat: */
  
          i = 1.
          FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
            /* this is the fix for bug number: 20000607-037. 07.25.00. Alex  */
            IF VALID-HANDLE(_BC._COL-HANDLE) THEN                                                   
              ASSIGN _BC._WIDTH = _BC._COL-HANDLE:WIDTH WHEN _BC._COL-HANDLE:WIDTH > 0.1.           

            /* Determine the label, format and help string to output */    
            ASSIGN output-label    = IF _BC._LABEL NE _BC._DEF-LABEL
                                     THEN _BC._LABEL ELSE ?
                   output-colLabel = IF _BC._COL-LABEL NE _BC._DEF-COLLABEL
                                     THEN _BC._COL-LABEL ELSE ?
                   output-format   = IF _BC._FORMAT NE _BC._DEF-FORMAT
                                     THEN _BC._FORMAT ELSE ?
                   output-help     = IF _BC._HELP NE _BC._DEF-HELP
                                     THEN _BC._HELP ELSE ?
                   output-width    = IF _BC._WIDTH NE _BC._DEF-WIDTH
                                     THEN STRING(_BC._WIDTH) ELSE ?.

            /* Determine if all defaults */
            ASSIGN def-values = IF _U._TYPE = "QUERY":U AND
                                   _U._SUBTYPE = "SmartDataObject":U THEN
                                  (output-label            = ? AND
                                   output-collabel         = ? AND
                                   output-format           = ? AND
                                   output-help             = ? AND
                                   output-valexp           = ? AND
                                   NOT _BC._ENABLED            AND
                                   _BC._DBNAME NE "_<CALC>":U) 
                                ELSE
                                  (output-label            = ? AND
                                   output-format           = ? AND
                                   output-help             = ? AND
                                   output-width            = ? AND
                                   _BC._BGCOLOR            = ? AND 
                                   _BC._FGCOLOR            = ? AND 
                                   _BC._FONT               = ? AND 
                                   _BC._LABEL-BGCOLOR      = ? AND 
                                   _BC._LABEL-FGCOLOR      = ? AND 
                                   _BC._LABEL-FONT         = ? AND
                                   NOT _BC._ENABLED            AND
                                   NOT _BC._DISABLE-AUTO-ZAP   AND
                                   NOT _BC._AUTO-RETURN        AND
                                   _BC._DBNAME NE "_<CALC>":U) AND
                                   _BC._VISIBLE                AND
                                   NOT _BC._AUTO-RESIZE        AND
                                   NOT _BC._COLUMN-READ-ONLY.
                                                                       
            /* Always put out the field name.  Only put out the Label and Format
               if they exist */
            PUT STREAM P_4GL UNFORMATTED 
              "     _FldNameList[" i (IF def-values THEN "]   = " ELSE "]   > ")
              IF _BC._DBNAME NE "_<CALC>" THEN 
                _BC._DBNAME + ".":U + _BC._TABLE + ".":U + _BC._NAME
              ELSE '"_<CALC>"':U SKIP.
            /* The next 2 lines is a kluge to allow a logical format of "*" for true. */
            IF output-format BEGINS "*/":U THEN
              output-format = "*~~~~/":U + SUBSTRING(output-format,3,-1,"CHARACTER":U).

            IF NOT def-values THEN DO:
              IF _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U THEN
                EXPORT STREAM P_4GL
                  _BC._NAME _BC._DISP-NAME output-label output-format _BC._DATA-TYPE _BC._BGCOLOR
                  _BC._FGCOLOR _BC._FONT _BC._LABEL-BGCOLOR _BC._LABEL-FGCOLOR 
                  _BC._LABEL-FONT _BC._ENABLED output-help
                  _BC._MANDATORY _BC._WIDTH _BC._INHERIT-VALIDATION output-colLabel
                  .
              ELSE
                EXPORT STREAM P_4GL
                  _BC._DISP-NAME output-label output-format _BC._DATA-TYPE _BC._BGCOLOR
                  _BC._FGCOLOR _BC._FONT _BC._LABEL-BGCOLOR _BC._LABEL-FGCOLOR _BC._LABEL-FONT
                  _BC._ENABLED output-help _BC._DISABLE-AUTO-ZAP _BC._AUTO-RETURN output-width _BC._VISIBLE
                  _BC._AUTO-RESIZE _BC._COLUMN-READ-ONLY
                  _BC._FORMAT-ATTR
                  _BC._HELP-ATTR
                  _BC._LABEL-ATTR.
            END. /* If NOT def-values */
            i = i + 1.
          END. /* _BC */
        END.  /* Not a freeform query */

        /* Additionally writeout parent & position info if a basic Query object.
           NOTE: on export, if we aren't cutting the parent, note the parent as
           "FRAME ?".  This will indicate to _rdqury to parent the Query to the
           current container. */
        IF _U._TYPE = "QUERY" THEN DO:
          FIND x_U WHERE RECID(x_U) = _U._parent-recid.
          FIND x_L WHERE RECID(x_L) = _U._lo-recid.
          PUT STREAM P_4GL UNFORMATTED 
             "     _Design-Parent    is " 
             (IF p_status EQ "EXPORT" and x_U._STATUS NE p_status
                THEN "FRAME ?"
                ELSE x_U._TYPE + " " + x_U._NAME)
             " @ ( "  STRING(x_L._ROW) " , " STRING(x_L._COL)  " )" SKIP.
        END.  /* If _U._TYPE = Query */
        ELSE DO:
          /* Frames and Browses support an option to OPEN the query automatically. */
          PUT STREAM P_4GL UNFORMATTED
            "     _Query            is " 
            (IF NOT _Q._OpenQury THEN "NOT ":U ELSE "":U)  "OPENED":U
            SKIP.
        END. /* Else DO */
        
        /* Additionally writeout PRIVATE-DATA information if SDO */.
        IF     _U._TYPE = "QUERY" 
           AND _U._SUBTYPE = "SmartDataObject":U 
           AND _U._PRIVATE-DATA NE "":U THEN DO:
             tmp_string = "~"" + _U._PRIVATE-DATA + "~"".
             IF _U._PRIVATE-DATA-ATTR NE "":U AND _U._PRIVATE-DATA-ATTR NE ? THEN
               tmp_string = tmp_string + ":":U + _U._PRIVATE-DATA-ATTR.
             PUT STREAM P_4GL UNFORMATTED SKIP
               "    _Private-Data       = " tmp_string SKIP.
        END. /* If _U._TYPE = Query for an SDO */
     
        /* This line signals the end of the Query rebuild information. */
        PUT STREAM P_4GL UNFORMATTED 
          "*/  /* " _U._TYPE " " _U._NAME " */" SKIP 
          IF p_status NE "PREVIEW" THEN "&ANALYZE-RESUME":U ELSE "":U
          SKIP (1).
    END. /* If..4GLQury..is not empty */
  END.  /* FOR EACH BROWSE */

  PUT STREAM P_4GL UNFORMATTED " " SKIP (1).
END. /* IF NOT CreatingSuper */

/* Write out any XFTRs that follow the RunTime Settings in .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&RUNTIMESET}, INPUT no).

/* OLD LOCATION        OUTPUT INCLUDED LIBRARIES CODE BLOCK                  */

/* ************************************************************************* */
/*                                                                           */
/*                          DYNAMIC WIDGET CREATION                          */
/*                             (OCX Containers)                              */
/*                                                                           */
/* ************************************************************************* */

/*
 * Figure out the name of the OCX binary. It is needed to delete the
 * existing binary file for a SAVE. THis will insure that the
 * saved binary version will removed when a .w used to have a
 * OCX but no longer has one. But copy it, just in case the
 * binary write fails.
 */
 
RUN adeshar/_contbnm.p (false, _h_win, p_status, OUTPUT OCXBinary).

/* Should be converted to test for platfrom support of VBX or OCX.
   -jep 01/30/96 */
DEFINE VARIABLE saveBinaryName AS CHARACTER NO-UNDO.
IF (p_status BEGINS "SAVE":U OR p_status = "EXPORT":U) THEN DO:
     
   /*
    * Move the existing OCX binary off to another directory, in
    * case there is a problem during the write of the binary file. 
    */
      
   ASSIGN saveBinaryName = REPLACE(_comp_temp_file, {&STD_EXT_UIB}:U, ".sbx":U).
   OS-COPY value(OCXBinary) value(saveBinaryName).
END.

IF CAN-FIND (FIRST x_U WHERE x_U._WINDOW-HANDLE EQ _h_win
                         AND x_U._TYPE          EQ "{&WT-CONTROL}":U
                         AND x_U._STATUS        EQ u_status)
THEN DO:
  PUT STREAM P_4GL UNFORMATTED SKIP (1)
   "/* **********************  Create OCX Containers  ********************** */"
    SKIP (1).

  IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED
      "&ANALYZE-SUSPEND _CREATE-DYNAMIC" SKIP.
      
  /* Write out the section containing dynamic widget creation. */

  RUN adeuib/_wrcont.p (INPUT _h_win, INPUT u_status, INPUT p_status, INPUT OCXBinary).

  /*
   * Take care of any OCX binary that needs to be created.
   */
  run adeshar/_contbin.p (input  _h_win,
                          input  u_status,
                          input  p_status,
                          input  OCXBinary,
                          output madeBinary,
                          output bStatus).
  IF p_status NE "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED SKIP (1)
      "&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */" SKIP.
     
END. /* IF CAN-FIND...OCX... */
  
/*
 * If there were no error then delete the "disaster" file. This must
 * done, even if there are no OCXs, otherwise we'd leave turds around
 */
   
IF (p_status BEGINS "SAVE":U OR p_status = "EXPORT":U) THEN DO:
 
   IF bStatus <> 0 THEN
     MESSAGE "The {&WT-CONTROL} binary file could not be created." skip
             "The previous version of the binary file has been" skip
             "saved as" saveBinaryName + ". The " skip
             "binary file and the .w file may be out of synch." skip
             "You should try to save using a new filename."
     VIEW-AS ALERT-BOX ERROR TITLE "Binary File Not Created".
   ELSE
     OS-DELETE VALUE(saveBinaryName).
END. 

/* ************************************************************************* */
/*                                                                           */
/*                         OUTPUT CONTROL TRIGGERS                           */
/*                                                                           */
/* ************************************************************************* */
ASSIGN null_section = yes
       trig_sect    = no.
WIDGET-BLOCK:
FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND _U._STATUS <> "DELETED"
                  BY IF CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) THEN 1
                     ELSE IF _U._TYPE = "FRAME" THEN 2
                     ELSE 3
                  BY _U._NAME
                  BY _U._TYPE:

  /* Skip this section if no triggers.  */
  IF _U._TYPE NE "BROWSE":U AND 
     NOT CAN-FIND(FIRST _TRG WHERE _TRG._wRECID   EQ RECID (_U)
                               AND _TRG._STATUS   EQ u_status
                               AND _TRG._tSECTION EQ "_CONTROL":U)
  THEN NEXT WIDGET-BLOCK.

  IF _U._TYPE = "BROWSE":U THEN 
  CHECK-BROWSE:
  DO:
    IF NOT CAN-FIND(FIRST _TRG WHERE _TRG._wRECID   EQ RECID (_U)
                                 AND _TRG._STATUS   EQ u_status
                                 AND _TRG._tSECTION EQ "_CONTROL":U
                                 AND NOT CAN-DO("DISPLAY,OPEN_QUERY,DEFINE_QUERY",_TRG._tEVENT))
    THEN DO:
      /* BROWSE HAS NO TRIGGER - see if COLUMNS DO */
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
        IF CAN-FIND(FIRST _TRG WHERE _TRG._wRECID   EQ RECID(_BC)
                                 AND _TRG._STATUS   EQ u_status
                                 AND _TRG._tSECTION EQ "_CONTROL":U) THEN
          LEAVE CHECK-BROWSE.                                          
      END. /* For each browse column */
      /* Only get here if both browse and _BC's don't have triggers */
      NEXT WIDGET-BLOCK.
    END. /* IF browse doesn't have any triggers */
  END. /* CHECK-BROWSE */
  
  /* Find _F to see if this is a Field Level Widget (don't want Menus or
     windows etc) */
  FIND _F WHERE RECID (_F) = _U._x-recid NO-ERROR.

  IF NOT trig_sect THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP (2)
      "/* ************************  Control Triggers  ************************ */"
      SKIP (1).
  trig_sect = true.
  IF CreatingSuper AND NOT lEmpty AND _P._TYPE NE "SmartDataObject":U THEN
    PUT STREAM P_4GL UNFORMATTED
      "/* Trigger code is converted to internal procedures when creating a Custom Super":U
      SKIP
      "   Procedure for a Dynamic Object.  Manual modifications will almost certainly":U
      SKIP
      "   be necessary. */":U SKIP (1).
  END.  /* If creating a super procedure */
 
  /* Setup the local preprocessor values for this widget.  Set BROWSE-NAME
     if this is a browse, set FRAME-NAME if it has changed.  Always set 
     SELF-NAME.  */
  IF _U._TYPE EQ "BROWSE":U THEN DO:
    PUT STREAM P_4GL UNFORMATTED
          "&Scoped-define BROWSE-NAME " _U._NAME SKIP.
    curr_browse = _U._NAME.
  END.  /* If _U._TYPE is a browse */
  IF AVAILABLE _F OR _U._TYPE EQ "BROWSE":U THEN DO:
    FIND x_U WHERE RECID(x_U) = _U._parent-recid.
    IF curr_frame <> x_U._NAME THEN DO:
      PUT STREAM P_4GL UNFORMATTED
          "&Scoped-define FRAME-NAME " x_U._NAME SKIP.
      curr_frame = x_U._NAME.
    END. 
  END. /* If a field level widget or a browse */

  /* Always put out SELF-NAME (which equals NAME [or tbl.name or db.tbl.name]) */
  self_name = IF (_U._DBNAME EQ ? OR (AVAILABLE _F AND _F._DISPOSITION EQ "LIKE":U))
                THEN _U._NAME
                ELSE db-tbl-name(_U._DBNAME + "." + _U._TABLE) + "." + _U._NAME.
  IF CreatingSuper AND NUM-ENTRIES(self_name,".") > 1 THEN
     self_name = ENTRY(NUM-ENTRIES(self_name,"."),self_name,".").

  PUT STREAM P_4GL UNFORMATTED
          "&Scoped-define SELF-NAME " self_name SKIP. 

  TRIGGER-BLOCK:
  FOR EACH _TRG WHERE _TRG._wRECID   EQ RECID(_U)
                AND   _TRG._tSECTION EQ "_CONTROL":U
                AND   _TRG._STATUS   EQ u_status
                USE-INDEX _RECID-EVENT:

    IF lEmpty AND NOT CAN-DO("_DEFINITIONS,_INCLUDE-LIB,_MAIN-BLOCK":U, _TRG._tEVENT) THEN
      NEXT TRIGGER-BLOCK.

    IF CAN-DO("DISPLAY,OPEN_QUERY,DEFINE_QUERY",_TRG._tEVENT) THEN  NEXT TRIGGER-BLOCK.

    /* These events are handled by the dynamic browser code and not needed unless an override is
       needed */
    IF CreatingSuper AND _U._TYPE = "BROWSE":U AND
      CAN-DO("CTRL-END,CTRL-HOME,END,HOME,OFF-END,OFF-HOME,ROW-ENTRY,ROW-LEAVE,SCROLL-NOTIFY,VALUE-CHANGED":U,
             _TRG._tEVENT) THEN NEXT TRIGGER-BLOCK.
    
    ASSIGN null_section = no. /* Initialize to not null section. */
  
    /* If its not an empty DO: END. block or there is code following the
       DO: END. block, save the trigger. Fixes bug 94-07-21-051. */
    ASSIGN strt = INDEX(_TRG._tCODE,":") + 1       /* Colon after DO */
           stp  = R-INDEX(_TRG._tCODE,"END.") - 1. /* END. */
    /* If strt is 1 then we are missing the colon; if stp is -1 then
       there is no "END.". In these cases, we cannot check for a null block. */
    IF (strt > 1 AND stp > -1) THEN DO:
      IF TRIM(SUBSTRING(_TRG._tCODE, strt , stp - strt , "CHARACTER":U)) = ""
      THEN
        ASSIGN stp = stp + 4 /* Move to the period in "END." */
               null_section = (LENGTH(RIGHT-TRIM(_TRG._tCODE), "CHARACTER":U)
                               = stp) NO-ERROR.
    END. /* If we have both the colon and the "END." */
    
    IF (null_section = FALSE) THEN DO:
      IF CreatingSuper AND _P._TYPE NE "SmartDataObject":U THEN /* Temporarily change _tEvent */
        ASSIGN cSuperEvent  = _TRG._tEvent
               _TRG._tEvent = self_name + _TRG._tEvent.

      RUN Put_Special_Preprocessor_Start.

      /* For special events, put out up caret for win_name instead of blank so
         cut, copy, paste, export, etc work for special events. Make sure
         the special event is written out as well. jep 11/21/97 */
      ASSIGN SpecialEvent = (" " + _TRG._tSPECIAL).
      IF (SpecialEvent = ?) THEN ASSIGN SpecialEvent = "".
      IF (SpecialEvent <> "") AND (win_name = "") THEN
        ASSIGN SpecialEvent = "^ " + SpecialEvent.

      /* Db-Required Start Preprocessor block. */
      IF _P._DB-AWARE AND _TRG._DB-REQUIRED THEN
        ASSIGN SpecialEvent = SpecialEvent + " " + "_DB-REQUIRED":u.
        
      /* If not a preview  */
      IF p_status NE "PREVIEW" THEN DO:
        IF NOT CreatingSuper THEN
          PUT STREAM P_4GL UNFORMATTED
             "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL " self_name " " win_name SpecialEvent
             SKIP.
        ELSE /* Creating a Super Procedure */
            PUT STREAM P_4GL UNFORMATTED
               "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE " _TRG._tEvent " Procedure"
               SKIP.
      END. /* If not a preview */

      /*
       * Control Triggers that are special events are actually internal procedures
       * and use a different syntax than PROGRESS events. These special events in V9
       * have a value for _tSPECIAL and _tEVENT has more than one period.
       *
       * E.g., OCX Trigger events are stored internally as OCX.event but are written out
       * as frame.control.event. Changes here must be made in adeshar/_gen4gl.p too.
       */
      IF (NUM-ENTRIES(_TRG._tEVENT, ".") > 1) THEN
      DO:
        /* JEP 1/16/97: OCX trigger is frame.control.event. */
        IF (_U._TYPE = "{&WT-CONTROL}") THEN
        DO:
            ASSIGN OCXName = IF (_U._OCX-NAME = "":U) OR (_U._OCX-NAME = ?)
                             THEN self_name ELSE _U._OCX-NAME.
            PUT STREAM P_4GL UNFORMATTED
              "PROCEDURE " self_name "." OCXName "." ENTRY(2, _TRG._tEVENT, ".") " ." SKIP
            .
        END.
        ELSE DO:
          PUT STREAM P_4GL UNFORMATTED
            "PROCEDURE " self_name "." ENTRY(2, _TRG._tEVENT, ".") " ." SKIP
          . 
        END.
      END.
      ELSE DO:
        /* ON event OF [TYPE] widget */
        IF NOT CreatingSuper THEN
          PUT STREAM P_4GL UNFORMATTED
            "ON " (IF _TRG._tEVENT = "." THEN "'.'" ELSE _TRG._tEVENT) " OF "
            (IF CAN-DO("FRAME,MENU,MENU-ITEM", _U._TYPE)  THEN  (_U._TYPE + " ")
             ELSE IF _U._TYPE = "SUB-MENU"                THEN "MENU "
             ELSE IF _U._TYPE = "DIALOG-BOX"              THEN "FRAME "
             ELSE "")
             self_name.
        ELSE DO:
          /* When creatng a super procedure change the "ON EVENT' to a procedure */
          PUT STREAM P_4GL UNFORMATTED
              "PROCEDURE " _TRG._tEVENT  " :".
          /* Turn the event back to what it was */
          _TRG._tEvent = cSuperEvent.
        END.  /* When creating a Super Proc */

        IF (AVAILABLE _F OR _U._TYPE = "BROWSE":U)
            AND (_U._TYPE <> "{&WT-CONTROL}") AND NOT CreatingSuper THEN 
          PUT STREAM P_4GL UNFORMATTED " IN FRAME " x_U._NAME.
          PUT STREAM P_4GL UNFORMATTED 
           (IF LENGTH(_U._LABEL,"RAW":U) > 0
            THEN (" /* " + REPLACE(_U._LABEL,"&","") +  " */")
            ELSE "")
           SKIP.
      END.
     _TRG._tOFFSET = SEEK(P_4GL).
     IF CreatingSuper AND _TRG._tCode BEGINS "DO:" THEN
     DO:
       _TRG._tCode = SUBSTRING(_TRG._tCODE, 4).
       /* Now replace the last end with a end procedure */
       IF R-INDEX(_Trg._tcode,"end":U) > 0 THEN
          _TRG._tcode = SUBSTRING(_TRG._tcode,1,R-INDEX(_Trg._tcode,"end":U) - 1 )  + "END PROCEDURE.":U.
     END.
     PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE).
     
      IF p_status NE "PREVIEW" THEN
         PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
          "&ANALYZE-RESUME" SKIP (2).
      ELSE PUT STREAM P_4GL UNFORMATTED SKIP (2).

      RUN Put_Special_Preprocessor_End (INPUT 0 /* skip lines */).

    END. /* null_section */
  END.  /* TRIGGER-BLOCK */

  IF _U._TYPE = "BROWSE":U THEN DO:  /* Put out any triggers from browse columns */
    BROWSE-COLUMN-BLOCK:
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
      /* Skip this column if no triggers.  */
      IF NOT CAN-FIND(FIRST _TRG WHERE _TRG._wRECID   EQ RECID (_BC)
                                   AND _TRG._STATUS   EQ u_status
                                   AND _TRG._tSECTION EQ "_CONTROL":U)
        THEN NEXT BROWSE-COLUMN-BLOCK.
      /* Put out SELF-NAME (which equals NAME [or tbl.name or db.tbl.name]) */
      self_name = IF _BC._DBNAME NE "_<CALC>":U THEN  db-fld-name("_BC":U, RECID(_BC))
                  ELSE _BC._NAME.
      PUT STREAM P_4GL UNFORMATTED "&Scoped-define SELF-NAME " self_name SKIP. 

      COLUMN-TRIGGER-BLOCK:
      FOR EACH _TRG WHERE _TRG._wRECID EQ RECID(_BC) 
                      AND _TRG._STATUS EQ u_status
                      USE-INDEX _RECID-EVENT:
        IF _TRG._tSECTION <> "_CONTROL" THEN NEXT COLUMN-TRIGGER-BLOCK.

        ASSIGN null_section = no. /* indicate section is not blank */  
        /* Make sure that it is a meaningful trigger                              */
        ASSIGN strt = INDEX(_TRG._tCODE,":") + 1       /* Initialize white space  */
               stp  = R-INDEX(_TRG._tCODE,"END.") - 1. /* search parameters       */
        IF strt = 1 OR stp = -1 OR strt > stp OR
          TRIM(SUBSTRING(_TRG._tCODE,strt,stp + 1 - strt,"RAW":U)) NE " " THEN DO:
          /* If a non-blank trigger  */
          IF p_status NE "PREVIEW" THEN
            PUT STREAM P_4GL UNFORMATTED
             "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL " self_name " " _U._NAME
                               " _BROWSE-COLUMN " win_name SKIP.
  
          /* ON event OF [TYPE] widget */
          PUT STREAM P_4GL UNFORMATTED
             "ON "   _TRG._tEVENT   " OF " self_name " IN BROWSE " _U._NAME.
          PUT STREAM P_4GL UNFORMATTED 
             (IF LENGTH(_BC._LABEL,"RAW":U) > 0 
                 THEN (" /* " + REPLACE(_BC._LABEL,"&","") +  " */")
                 ELSE "")  SKIP.
          _TRG._tOFFSET = SEEK(P_4GL).
          PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE).
       
          IF p_status NE "PREVIEW" THEN
             PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
              "&ANALYZE-RESUME" SKIP (2).
          ELSE PUT STREAM P_4GL UNFORMATTED SKIP (2).
        END.
      END.  /* COLUMN-TRIGGER-BLOCK */
                 
    END.  /* BROWSE-COLUMN-BLOCK */
  END.  /* IF working on a browse */

END.  /* WIDGET-BLOCK */


/* Make sure frame-name and browse-name is defined as the first frame or
   browse (in case the user wants to use it in the main code block). */
IF curr_frame NE frame_name_f THEN DO:
  PUT STREAM P_4GL UNFORMATTED "&Scoped-define FRAME-NAME " frame_name_f SKIP.
  curr_frame = frame_name_f.
END.
 
IF curr_browse NE first_browse THEN DO:
  PUT STREAM P_4GL UNFORMATTED "&Scoped-define BROWSE-NAME " first_browse SKIP.
  curr_browse = first_browse.
END.

/* Get rid of SELF-NAME */
IF self_name NE "":U THEN DO:
  PUT STREAM P_4GL UNFORMATTED "&UNDEFINE SELF-NAME" SKIP.
  self_name = "":U.
END.
/* Write out any XFTRs that follow the Triggers Section in .W */                                                     
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&CONTROLTRIG}, INPUT null_section).


/* ************************************************************************* */
/*                                                                           */
/*                           OUTPUT MAIN CODE BLOCK                          */
/*                                                                           */
/* ************************************************************************* */

/* First Output the main-code block (if any)                      */
PUT STREAM P_4GL UNFORMATTED SKIP (1).
FIND _U WHERE _U._HANDLE = _h_win.
FIND _TRG  WHERE _TRG._wRECID   EQ RECID(_U) AND
                 _TRG._tSECTION EQ "_CUSTOM" AND
                 _TRG._tEVENT   EQ "_MAIN-BLOCK" AND
                 _TRG._STATUS   EQ u_status NO-ERROR.                
IF AVAILABLE _TRG THEN DO:
   /*  Remark out the initializeObject in the main block when creating superprocedures*/
  IF CreatingSuper AND _P._TYPE NE "SmartDataObject":U THEN 
  DO:
     IF _TRG._tCode MATCHES "*RUN initializeObject*":U AND
        NOT _TRG._tCode MATCHES "*Commented out*":U THEN /* Don't do it twice */
      _TRG._tCode = REPLACE(_TRG._tCode,"RUN initializeObject.":U,
                        "/* RUN initializeObject. */  /* Commented out by migration progress */":U  ).
     IF _TRG._tCode MATCHES "*RUN dispatch IN THIS-PROCEDURE ('initialize':U).*":U THEN
      _TRG._tCode = REPLACE(_TRG._tCode,"RUN dispatch IN THIS-PROCEDURE ('initialize':U).":U,
                                        "/* RUN dispatch IN THIS-PROCEDURE ('initialize':U). */":U  ).
  END.
  RUN put_code_block.
END.

/* For basic SmartObjects (not SmartContainers) being tested in TTY mode,
   put in a pause and a quit.                                             */
RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)), INPUT "SmartObject":U,
                   OUTPUT isaSO).
RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)), INPUT "SmartContainer":U,
                   OUTPUT isaSContainer).
IF LOOKUP(p_status,"RUN,DEBUG":U) > 0 AND NOT _cur_win_type AND
          isaSO AND NOT isaSContainer THEN
PUT STREAM P_4GL UNFORMATTED SKIP "PAUSE.":U SKIP "QUIT.":U SKIP (2).

/* Write out any XFTRs that follow Main Block in .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&MAINBLOCK}, INPUT no).

/* ************************************************************************* */
/*                                                                           */
/*                           OUTPUT PROCEDURES                               */
/*                                                                           */
/* ************************************************************************* */
ASSIGN null_section = yes.

/* Add in ADM generated section for adm-create-objects if there are any
   contained smartobjects. */
IF u_status NE "EXPORT" AND 
   CAN-FIND(FIRST x_U WHERE x_U._WINDOW-HANDLE EQ _P._WINDOW-HANDLE
                        AND x_U._status EQ u_status
                        AND x_U._TYPE EQ "SmartObject":U)
THEN DO:
  FIND _TRG WHERE _TRG._wrecid   EQ RECID(_U) 
              AND _TRG._tSECTION EQ "_PROCEDURE" 
              AND _TRG._tEVENT   EQ  "adm-create-objects" NO-ERROR.
  /* Create the trigger section, if necessary */
  IF NOT AVAILABLE _TRG THEN DO:
    CREATE _TRG.
    ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
           _TRG._wrecid   = RECID(_U) 
           _TRG._tSECTION = "_PROCEDURE" 
           _TRG._tEVENT   =  "adm-create-objects"
           _TRG._DB-REQUIRED = NO     /* jep: IZ 1429 */
           _TRG._STATUS   = u_status
           .
  END. /* If available _TRG */
  /* Make this a special section. */
  ASSIGN _TRG._tSPECIAL = "_ADM-CREATE-OBJECTS"
         _TRG._tCODE    = ?
         .
  /* Make sure there is only one _ADM-CREATE-OBJECTS procedure. (Because we
     read it when you suck the file back into the UIB and we don't want to
     create multiple copies.) */
  i = RECID(_TRG).
  FOR EACH _TRG WHERE _TRG._wrecid   EQ RECID(_U) 
                  AND _TRG._tSECTION EQ "_PROCEDURE" 
                  AND _TRG._tSPECIAL EQ "_ADM-CREATE-OBJECTS"
                  AND RECID(_TRG)    NE i:
    DELETE _TRG.
  END.  /* For each _TRG with _ADM-CRETE-OBJECTS */
END.  /* If we're not exporting and we're dealing with a SmartObject */

/*
 * Add in OCX control internal procedure. This procedure is needed
 * to work around limitations of CORE with regards to control containers.
 * The controls must be loaded and enabled after the everthing is
 * in place for ADM objects.
 */
 
IF u_status NE "EXPORT" AND
   CAN-FIND(FIRST x_U WHERE x_U._WINDOW-HANDLE EQ _P._WINDOW-HANDLE
                        AND x_U._status EQ u_status
                        AND x_U._TYPE EQ "{&WT-CONTROL}":U)
                        
THEN DO: 
  FIND _TRG WHERE _TRG._wrecid   EQ RECID(_U) 
              AND _TRG._tSECTION EQ "_PROCEDURE" 
              AND _TRG._tEVENT   EQ "control_load" NO-ERROR.
  /* Create the trigger section, if necessary */
  IF NOT AVAILABLE _TRG THEN DO:
    CREATE _TRG.
    ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
           _TRG._wrecid   = RECID(_U)
           _TRG._tSECTION = "_PROCEDURE" 
           _TRG._tEVENT   = "control_load"
           _TRG._STATUS   = u_status
           .
  END.  /* If available _TRG */
  
  /* Make this a special section. */
  ASSIGN _TRG._tSPECIAL = "_CONTROL-LOAD"
         _TRG._tCODE    = ?
         .
  /* Make sure there is only one _CONTROL-LOAD procedure. (Because we
     read it when you suck the file back into the UIB and we don't want to
     create multiple copies.) */
  i = RECID(_TRG).
  FOR EACH _TRG WHERE _TRG._wrecid   EQ RECID(_U) 
                  AND _TRG._tSECTION EQ "_PROCEDURE" 
                  AND _TRG._tSPECIAL EQ "_CONTROL-LOAD"
                  AND RECID(_TRG)    NE i:
    DELETE _TRG.
  END.  /* For each _TRG */

END.  /* If we are loading a control */
ELSE DO:
  /*
   * No controls. IF there is control_load ip then remove it
   */
  
  FIND _TRG WHERE _TRG._wrecid   EQ RECID(_U) 
              AND _TRG._tSECTION EQ "_PROCEDURE" 
              AND _TRG._tEVENT   EQ  "control_load" NO-ERROR.
  IF AVAILABLE _TRG THEN DELETE _TRG.
END.  /* Else do */

/* Are there any procedures to output? */
FIND FIRST _TRG WHERE _TRG._wrecid   EQ RECID(_U) AND
                      _TRG._tSECTION EQ "_PROCEDURE" AND
                      _TRG._STATUS   EQ u_status AND
                      (_TRG._tEVENT NE "disable_UI":U OR NOT CreatingSuper)
                     NO-ERROR.

IF (AVAILABLE _TRG) AND NOT lEmpty  /*AND (p_status <> "EXPORT")*/ THEN DO:
  PUT STREAM P_4GL UNFORMATTED
 "/* **********************  Internal Procedures  *********************** */" 
    SKIP (1).

  /*  Output all procedures. */
  PROCEDURE-LOOP:
  FOR EACH _TRG WHERE _TRG._wrecid   EQ RECID(_U) AND
                      _TRG._tSECTION EQ "_PROCEDURE" AND
                      _TRG._STATUS   EQ u_status BY _TRG._tEVENT:
    /* Omit the creation of various adm specific procedures that are not applicable
       for insertion in super procedures */
    IF CreatingSuper AND LOOKUP(_TRG._tEvent,"Disable_ui,control_load,adm-create-objects,send-records,adm-row-available":U) > 0 THEN 
       NEXT PROCEDURE-LOOP.
    IF CreatingSuper AND _TRG._tEvent = "state-changed":U THEN 
       ASSIGN _TRG._tCode = REPLACE(_TRG._tCode,"~{src/adm/template/vstates.i}", " /*~{src/adm/template/vstates.i} */ ")
              _TRG._tCode = REPLACE(_TRG._tCode,"~{src/adm/template/bstates.i}", " /*~{src/adm/template/bstates.i} */ ").

    ASSIGN null_section = no. /* indicate section is not blank */

    RUN Put_Special_Preprocessor_Start.

    /* For special event procedures, put out up caret for win_name instead of blank
     so cut, copy, paste, export, etc work for special event procs and db-required.
     Make sure the special event and db-required is written out as well. jep 09/21/97 */
    ASSIGN SpecialEvent = (" " + _TRG._tSPECIAL).
    IF (SpecialEvent = ?) THEN ASSIGN SpecialEvent = "".
    IF (win_name = "") THEN
        ASSIGN SpecialEvent = "^ " + SpecialEvent.
    /* Db-Required Start Preprocessor block. */
    IF _P._DB-AWARE AND _TRG._DB-REQUIRED THEN
        ASSIGN SpecialEvent = SpecialEvent + " " + "_DB-REQUIRED":u.

    /* Heading = _PROCEDURE event window [SPECIAL] [DB-REQUIRED] */
    IF p_status NE "PREVIEW" THEN
        PUT STREAM P_4GL UNFORMATTED
         "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE " _TRG._tEVENT SPACE win_name SPACE SpecialEvent
         SKIP.

    /* Now put out the procedure itself.  */
    PUT STREAM P_4GL UNFORMATTED  "PROCEDURE " _TRG._tEVENT.
    IF _TRG._PRIVATE-BLOCK THEN
        PUT STREAM P_4GL UNFORMATTED " PRIVATE :"  SKIP.   
    ELSE
        PUT STREAM P_4GL UNFORMATTED " :"  SKIP.   

    _TRG._tOFFSET = SEEK(P_4GL).
    /* Generate default code on the fly, otherwise use the user input code */   
    IF (_TRG._tCODE = ?) AND (_TRG._tSPECIAL <> ?) THEN DO:
      RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wrecid, OUTPUT tmp_string).
      PUT STREAM P_4GL UNFORMATTED tmp_string.
    END.
    ELSE PUT STREAM P_4GL UNFORMATTED TRIM(_TRG._tCODE).
    
    IF p_status NE "PREVIEW"
    THEN PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
         "&ANALYZE-RESUME".

    RUN Put_Special_Preprocessor_End (INPUT 1 /* skip lines */).

  END. /* FOR EACH... _PROCEDURE... */

  /* Output multiple layout procedure if necessary                               */
  IF multi-layout THEN RUN adeuib/_locases.p (INPUT layout-var).
        
END. /* IF (AVAILABLE _TRG) ... */

/* Write out any XFTRs that follow the Internal Procedures in .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&INTPROCS}, INPUT null_section).

/* If we are exporting SmartObjects, we need to write out the code that
   defines them.  These are in the _ADM-CREATE-OBJECTS procedure, but this
   will not have been written out if we are exporting. */
IF p_status EQ "EXPORT":U AND  
   CAN-FIND (FIRST _U WHERE _U._WINDOW-HANDLE EQ _h_win     
                        AND _U._STATUS        EQ p_status  
                        AND _U._TYPE          EQ "SmartObject":U)
THEN DO:
  /* Write out the create statement in the form of a procedure. */  
  RUN adeuib/_adm-crt.p (INPUT _P._u-recid, INPUT p_status, OUTPUT tmp_string). 
  PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _EXPORT-CODE-BLOCK _ADM-CREATE-OBJECTS " win_name SKIP
        "PROCEDURE adm-create-objects :" SKIP
        tmp_string SKIP
        "END PROCEDURE." SKIP
        "&ANALYZE-RESUME" SKIP (2).
  END.

/* In 7.3 we used to undefine BROWSE-NAME, FRAME-NAME and WINDOW-NAME.
 *    This was not necessary (and could cause some ANALYZER bugs if the
 *    names were not defined outside an ANALYZE-SUSPEND block.).   [wood 2/95]
 * IF curr_browse <> "" THEN
 *   PUT STREAM P_4GL UNFORMATTED "&UNDEFINE BROWSE-NAME" SKIP.
 * IF curr_frame <> "" THEN
 *   PUT STREAM P_4GL UNFORMATTED "&UNDEFINE FRAME-NAME" SKIP.
 * PUT STREAM P_4GL UNFORMATTED "&UNDEFINE WINDOW-NAME" SKIP.
 * */
 

/* ************************************************************************* */
/*                                                                           */
/*                           OUTPUT FUNCTIONS                                */
/*                                                                           */
/* ************************************************************************* */
IF NOT lEmpty THEN
  RUN put-func-definitions-in.

PROCEDURE put-func-definitions-in.

DEFINE VAR vCode        AS CHARACTER  NO-UNDO.
DEFINE VAR Ref-Type     AS CHARACTER  NO-UNDO.
DEFINE VAR null_section AS LOGICAL    NO-UNDO.

/* Are there any user functions to output? */
ASSIGN null_section = yes.
FIND FIRST _TRG WHERE _TRG._wrecid   EQ RECID(_U) AND
                      _TRG._tSECTION EQ "_FUNCTION" AND
                      _TRG._STATUS   EQ u_status NO-ERROR.
IF (AVAILABLE _TRG) /*AND (p_status <> "EXPORT")*/ THEN DO:

  PUT STREAM P_4GL UNFORMATTED
   "/* ************************  Function Implementations ***************** */" 
   SKIP (1).

  /*  Output all functions. */
  FOR EACH _TRG WHERE _TRG._wrecid   EQ RECID(_U) AND
                      _TRG._tSECTION EQ "_FUNCTION" AND
                      _TRG._STATUS   EQ u_status BY _TRG._tEVENT:

    ASSIGN null_section = no. /* indicate section is not blank */

    /* Determine default code on the fly, otherwise use the user input code. */
    IF (_TRG._tCODE = ?) AND (_TRG._tSPECIAL <> ?) THEN
      RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wrecid, OUTPUT vCode).
    ELSE
      ASSIGN vCode = TRIM(_TRG._tCode).

    /* Now determine if we need to output function block. If its an EXTERNAL, the block
       was already generated by adeshar/_gendefs.p. Otherwise, put the block out as is.
         FORWARD:   FUNCTION func-name RETURNS data-type
                      (parameter-definition) FORWARD.
         
         EXTERNAL:  FUNCTION func-name RETURNS data-type
                      (parameter-definition) [MAP [TO] map-name] IN proc-handle.
    */
    IF (INDEX(vCode, " IN ") > 0) AND (INDEX(vCode, "END FUNCTION") = 0) THEN
      ASSIGN Ref-Type = "EXTERNAL".
    ELSE
      ASSIGN Ref-Type = "FORWARD".
    IF Ref-Type = "EXTERNAL" THEN NEXT.
      
    RUN Put_Special_Preprocessor_Start.


    /* For special event functions, put out up caret for win_name instead of blank
     so cut, copy, paste, export, etc work for special event funcs and db-required.
     Make sure the special event and db-required is written out as well. jep 09/21/97 */
    ASSIGN SpecialEvent = (" " + _TRG._tSPECIAL).
    IF (SpecialEvent = ?) THEN ASSIGN SpecialEvent = "".
    IF (win_name = "") THEN
        ASSIGN SpecialEvent = "^ " + SpecialEvent.
    /* Db-Required Start Preprocessor block. */
    IF _P._DB-AWARE AND _TRG._DB-REQUIRED THEN
        ASSIGN SpecialEvent = SpecialEvent + " " + "_DB-REQUIRED":u.

    /* Heading = _FUNCTION event window [SPECIAL] [DB-REQUIRED] */
    IF p_status NE "PREVIEW" THEN
        PUT STREAM P_4GL UNFORMATTED
         "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION " _TRG._tEVENT SPACE win_name SPACE SpecialEvent
         SKIP.

    /* Now put out the function itself.  */
    PUT STREAM P_4GL UNFORMATTED  "FUNCTION " _TRG._tEVENT " ".   
    _TRG._tOFFSET = SEEK(P_4GL).
    /* Before actually writing the function code block, add the PRIVATE keyword
       if necessary. */
    IF _TRG._PRIVATE-BLOCK AND INDEX(ENTRY(1, vCode, CHR(10))," PRIVATE":U) = 0 THEN
      RUN add-func-private (INPUT-OUTPUT vCode).
    ELSE IF NOT _TRG._PRIVATE-BLOCK AND INDEX(ENTRY(1, vCode, CHR(10))," PRIVATE":U) > 0 THEN 
      RUN remove-func-private(INPUT-OUTPUT vCode).

    PUT STREAM P_4GL UNFORMATTED vCode.
    
    IF p_status NE "PREVIEW"
    THEN PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
         "&ANALYZE-RESUME".

    RUN Put_Special_Preprocessor_End (INPUT 1 /* skip lines */).

  END. /* FOR EACH... _FUNCTION... */

END. /* IF (AVAILABLE _TRG) ... */

/* Write out any XFTRs that follow the User Functions in .W - not enabled yet. INTPROCS */
/* IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&INTFUNCS}, INPUT null_section). */
END PROCEDURE.

OUTPUT STREAM P_4GL CLOSE.
IF p_status BEGINS "SAVE":U AND cTempFile > "" THEN
DO:
  OS-COPY VALUE(cTempFile) VALUE(_save_file).
  IF OS-ERROR <> 0 then 
     RUN adecomm/_proserr.p (OS-ERROR, _save_file, "saved", cTempFile + " has not been deleted.").
  ELSE
    OS-DELETE VALUE(cTempFile).  
END.

/* If saving a DB-Aware object, write out the proxy file */
IF p_status BEGINS "SAVE":U AND _P._DB-AWARE AND NOT _P._NO-PROXY AND NOT _P._TEMPLATE THEN DO:
  IF web_file THEN
    RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT tmp_file).

  proxy-file = SUBSTRING(_save_file,1,R-INDEX(_save_file,".":U) - 1,
                         "CHARACTER":U) + "_cl.":U +
                         ENTRY(NUM-ENTRIES(_save_file,".":U), _save_file,".":U).

  IF proxy-file NE ? THEN DO:
    OUTPUT STREAM P_4GL TO VALUE(IF web_file THEN tmp_file ELSE proxy-file).
      
    RUN adecomm/_relname.p (INPUT _save_file, INPUT "", OUTPUT tmp_name).
    RUN adecomm/_relname.p (INPUT proxy-file, INPUT "", OUTPUT proxy-temp).

    PUT STREAM P_4GL UNFORMATTED
        "/* ":U + proxy-temp + " - non-db proxy for " + tmp_name + " */" SKIP (1)
        "&GLOBAL-DEFINE DB-REQUIRED FALSE" SKIP (1)
        '~{"' + tmp_name + '"~}' SKIP.
   
    OUTPUT STREAM P_4GL CLOSE.

    /* Save the [file]_cl.w file to a remote WebSpeed agent. */
    IF web_file THEN DO:
      RUN adeweb/_webcom.w (RECID(_P), 
                            (IF _P._broker-url = "" OR l_saveas THEN 
                            _BrokerURL ELSE _P._broker-url), 
                            proxy-file, "save":U, 
                            OUTPUT cRelName, 
                            INPUT-OUTPUT tmp_file).
      IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
        cReturnValue = SUBSTRING(RETURN-VALUE, INDEX(RETURN-VALUE,CHR(10)) + 1,
                                 -1, "CHARACTER":U).
        RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
          SUBSTITUTE("&1 could not be saved for the following reason:^^&2",
          proxy-file, cReturnValue)).
      END.
      OS-DELETE VALUE(tmp_file).
    END.
  END.
END.  /* If writing a proxy file */

/* WEB: Cleanup the stuff needed to write out unmapped fields as temp-table 
   fields. */
FOR EACH _U WHERE 
  _U._WINDOW-HANDLE EQ _P._WINDOW-HANDLE AND
  _U._STATUS        EQ "NORMAL":U AND
  _U._DBNAME        EQ "Temp-Tables":U AND
  _U._TABLE         EQ "{&WS-TEMPTABLE}":U:
  
  ASSIGN
    _U._DBNAME = ?
    _U._TABLE  = ?.
END.

/* Now that we have finished writing the file, restore the numeric format */
SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

/*
 * Cleanup the workaround needed for writing the OCX load proecdure.
 * Refer _contbnm.p for details.
 */
IF OPSYS = "WIN32":U THEN
DO:
  IF LENGTH(ENTRY(1, _P._VBX-FILE)) = 0 THEN
    _P._VBX-FILE = ?.
  ELSE
  _P._VBX-FILE = ENTRY(1, _P._VBX-FILE).
  
  /*
   * If the binary file couldn't be saved then return an error.
   * This is done here, so that the the .w file will be created,
   * even if the binary file cannot be created.
   */
      
  IF bStatus <> 0 THEN RETURN "Error-Binary":U.
END.

/* Compile/Run/Debug the file we just created. */
IF p_status NE "PREVIEW":U AND
   p_status NE "PRINT":U AND
   p_status NE "EXPORT":U  AND
   NOT p_status BEGINS "SAVE":U
THEN
RUN-BLK:
DO ON STOP UNDO RUN-BLK, LEAVE RUN-BLK
   ON ERROR UNDO RUN-BLK, LEAVE RUN-BLK:

  COMPILE VALUE(_comp_temp_file) NO-ERROR.
  RUN add-cmp-msgs.
  
  IF COMPILER:ERROR THEN DO:
    RUN report-compile-errors (INPUT _comp_temp_file).

    IF _err_recid NE ? THEN DO:
      OS-DELETE VALUE(_comp_temp_file).
      OS-DELETE VALUE(_comp_temp_file + ".i").
      RETURN "Error-Compile".   
    END.
  END. /* Block handling compiler errors */
  ELSE DO:
      
    /* Display any preprocessor messages. */
    ASSIGN comp_file = COMPILER:FILE-NAME.
    RUN adecomm/_errmsgs.p ( INPUT _h_menu_win , INPUT comp_file ,
                             INPUT _comp_temp_file ).
    
    CASE p_status:
    WHEN "RUN":U OR WHEN "DEBUG":U THEN DO:
      /* Minimize the UIB's Main Window, if necessary.  This will
         be reset in the UIB Main (in enable_widgets).  We could have
         done this right after the user chose the "Run" option, but then
         the screen would have been empty while we were generating the
         .w file.  It is best to minimize it now, just before the run.  
         NOTE: In MS-WINDOWS, the window cannot change state while
         SET-WAIT-STATE is "WAIT", so make sure it is not. */
      IF _minimize_on_run THEN DO: 
         &IF "{&WINDOW-SYSTEM}" NE "OSF/Motif" &THEN
           l_dummy = SESSION:SET-WAIT-STATE ("").
         &ENDIF
        _h_menu_win:WINDOW-STATE = WINDOW-DELAYED-MINIMIZE.
      END.
      
      RUN adecomm/_wfrun.p (INPUT "AppBuilder", OUTPUT wfrun).
      IF wfrun THEN LEAVE.

      RUN adecomm/_setcurs.p ("").
      CREATE WIDGET-POOL.              /* Isolate any widgets CREATED */
      /* Provide a default window for messages/dialogs. Otherwise these would
         go the the uib main window. NOTE: this will be similar to the  
         Procedure Editor behavior. */ 
      /* If running tty-window, this should not be done, to not have two
         run-windows on the screen. <hutegger> 94/03 */
        IF _cur_win_type = true
          THEN ASSIGN
             CURRENT-WINDOW = DEFAULT-WINDOW
             CURRENT-WINDOW:TITLE = "{&UIB_NAME} - Run"
             . 
      /* Handle any special cases in the RUN by LEAVING the Execute-Block.
         (this is similar to the ExecuteRun logic in adeedit/psystem.i). */
      Execute-Block:
      DO ON ERROR  UNDO Execute-Block, LEAVE Execute-Block
         ON ENDKEY UNDO Execute-Block, LEAVE Execute-Block
         ON STOP   UNDO Execute-Block, LEAVE Execute-Block
         ON QUIT                     , LEAVE Execute-Block:
                    
        /* Now RUN -- make sure the numeric-format is reset to the users
           desired value. (The COMPILE statement above sometimes reset
           the numeric-format [see LANG bug# 94-01-19-004]. */
        ASSIGN SESSION:DATE-FORMAT    = _orig_dte_fmt.
        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
 
        /* If debugging, set up to break at line 1. Actually, we use
           -1 to tell the debugger to set the break at the first
           executable line in the main or greater procedure block.
           Prevents debugger from setting break at first line
           in an internal procedure if its first in the file.
        */
        IF _cur_win_type = true and p_status = "DEBUG":U
        THEN ASSIGN l_dummy = DEBUGGER:INITIATE()
                    l_dummy = DEBUGGER:SET-BREAK(_comp_temp_file, -1).
        /* Run the file */
        /* A tty-window gets ran on in extra xterm-session (motif)
         * or DOS Shell (Windows). <hutegger> 94/03 */   
         
        IF _cur_win_type = true THEN
        DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
            RUN adecomm/_runcode.p ( INPUT  _comp_temp_file ,
                                     INPUT  run_flags ,
                                     INPUT  Stop_Button,
                                     OUTPUT app_handle ).
        END.
        ELSE IF p_status = "RUN":U THEN
           RUN adeuib/_ttyss.p ( INPUT "RUN":U , INPUT _comp_temp_file ).
        ELSE IF p_status = "DEBUG":U THEN
           RUN adeuib/_ttyss.p ( INPUT "RUN-DEBUG":U , INPUT _comp_temp_file ).

      END. /* Execute-Block: DO... */  
      /* Clean up after a Debugger Run - Graphical or Character. */
      IF p_status = "DEBUG":U
      THEN ASSIGN DEBUGGER:VISIBLE = FALSE
                  l_dummy          = DEBUGGER:CLEAR().
      
      /*
       * Clean up any OCX binaries on a run or debug
       */
      IF (madeBinary AND NOT p_status BEGINS "SAVE":U) THEN 
        OS-DELETE VALUE(OCXBinary).

      /* Clean up after all runs */
      PAUSE 0 BEFORE-HIDE.
      ASSIGN SESSION:SYSTEM-ALERT-BOXES = YES
             CURRENT-WINDOW             = _h_menu_win
             DEFAULT-WINDOW:VISIBLE     = FALSE
             wfRunning                  = "".
      DELETE WIDGET-POOL.    
    END.
    WHEN "CHECK-SYNTAX":U THEN DO:
      RUN adecomm/_setcurs.p ("").
      MESSAGE "Syntax is correct" 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Information"
                          IN WINDOW _h_menu_win.
    END.
    OTHERWISE DO:
      OS-COPY VALUE(_comp_temp_file) VALUE(_save_file).
          IF OS-ERROR <> 0 then do:

            extra = _comp_temp_file + " has not been deleted.".
             
            /* 
             * We've got a problem. Let the user know but DO NOT
             * delete the temp file! Since we could not copy the
             * file right now, we'll leave it around so that the
             * user can copy it later by hand.
             */
            run adecomm/_proserr.p (OS-ERROR, _save_file, "saved", extra).

            END.
         END.
    END CASE.

    OS-DELETE VALUE(_comp_temp_file).
    IF OS-ERROR <> 0 THEN
            run adecomm/_proserr.p (OS-ERROR, _comp_temp_file, "deleted", "").
    OS-DELETE VALUE(_comp_temp_file + ".i").

  END. /* ELSE */
END. /* RUN-BLK */
ELSE IF p_status = "EXPORT" THEN DO:
    OS-COPY VALUE(_comp_temp_file) VALUE(_save_file).
    IF OS-ERROR <> 0 then do:

        extra = _comp_temp_file + " has not been deleted.".
             
        /* 
           * We've got a problem. Let the user know but DO NOT
          * delete the temp file! Since we could not copy the
         * file right now, we'll leave it around so that the
         * user can copy it later by hand.
         */
         run adecomm/_proserr.p (OS-ERROR, _save_file, "exported", extra).

    END.
END.

/* Let others know that the save was a success. (Again, except for Preview and Print.)  */
IF p_status NE "PREVIEW":U AND p_status NE "PRINT":U THEN
  RUN adecomm/_adeevnt.p ("UIB":U, p_status, context, _save_file,
                          OUTPUT ok2continue).
                             
/* Do we need to compile the object after the save?  If so, compile it. 
   NOTE: that we never compile TEMPLATES themselves.  The "compile" flag really
   means "Compile Derived Master on Save". */

IF p_status BEGINS "SAVE":U AND NOT web_file AND
  (NOT CreatingSuper OR _P._TYPE = "SmartDataObject":U) THEN 
  RUN compile-and-load.    

/* The code below (commented out) was placed here by someone who thought that
   the _tOFFSET values had been used and needed to be cleaned out.  However,
   this was too early and broke the cursor setting capability when an error
   occurred.  The reason why the offset might need to be cleaned out is that
   depending upon weather a file is completely written out (_gen4gl.p) or 
   only parts are written out (_qikcomp.p or _writedf.p) the offset can change
   creately and cause errors when attempting to position the cursor.  Therefore,
   a new strategy of cleaning out the offsets just before writing a file has
   been put in place.  This is done near the top of _gen4gl.p, _qikcomp.p and
   _writeddf.p.   DRH 03/12/03 
    
   IF NOT web_file THEN
   FOR EACH _TRG WHERE _TRG._tOFFSET NE ?:
     _TRG._tOFFSET = ?.
   END.
*/

/* Set all OCX control dirty settings to clean. */
IF p_status BEGINS "SAVE":U THEN
  RUN Set_Control_Dirty IN _h_uib (INPUT _h_win, INPUT NO).

RETURN "".
/* ************************************************************************* */
/*                                                                           */
/*     COMMON PROCEDURES FOR DEFINING VIEW-AS SUPPORT, COLOR and FONT        */
/*                                                                           */
/* ************************************************************************* */

/* Common - routine to check whether a links are valid */
{adeuib/_chkrlnk.i}
           
/* compile-and-load: compile the file (if desired) and then, if it is a
 * SmartObject that is currently in use, re-instantiate those uses. */
PROCEDURE compile-and-load:

  DEFINE VARIABLE cant_compile      AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE can_run           AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE cnt               AS INTEGER        NO-UNDO.   
  DEFINE VARIABLE compile-into      AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE err_msg           AS CHARACTER      NO-UNDO.  
  DEFINE VARIABLE i                 AS INTEGER        NO-UNDO.
  DEFINE VARIABLE hProc             AS WIDGET-HANDLE  NO-UNDO.

  /* Dynamics Enhancements */
  DEFINE VARIABLE cSaveIntoString   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE iSaveIntoLoop     AS INTEGER        NO-UNDO.
  DEFINE VARIABLE cSaveIntoValue    AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSaveIntoSource   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSaveIntoTarget   AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE cToSaveSourceName AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cToSaveTargetName AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE cSaveFilename     AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSaveDirectory    AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSaveDirRoot      AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cSaveDirRelative  AS CHARACTER      NO-UNDO.

  DEFINE VARIABLE iCompileLoop      AS INTEGER        NO-UNDO.
  DEFINE VARIABLE cCompileIntoDir   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE cCompileSaveInto  AS CHARACTER      NO-UNDO.

  /* If the SmartObject Upgrade Utility is in the middle of an upgrade,
     do not compile the objects */
  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hproc):
    IF hProc:PRIVATE-DATA = "SmartObject Upgrade Utility,YES"
    THEN RETURN.
    hProc = hProc:NEXT-SIBLING.
  END.

  /* Assume that the file will run successfully. */
  ASSIGN can_run   = yes
         comp_file = ?.
  IF _P._compile AND NOT _P._template
  THEN DO:     
    RUN setstatus IN _h_UIB ("WAIT":U, "Compiling file...":U).
    RUN adecomm/_adeevnt.p ("UIB":U
                           ,"BEFORE-COMPILE"
                           ,context
                           ,_save_file
                           ,OUTPUT ok2continue).

    IF ok2continue
    THEN DO:
      /* For _P._db-aware objects. Won't bother checking for _db-aware. -jep */
      proxy-file = SUBSTRING(_save_file,1,R-INDEX(_save_file,".":U) - 1, "CHARACTER":U)
                 + "_cl.":U
                 + ENTRY(NUM-ENTRIES(_save_file,".":U), _save_file, ".":U).

      /* Can we compile into the Save into directory? */    
      COMPILE-BLK:
      DO ON STOP  UNDO COMPILE-BLK, LEAVE COMPILE-BLK
         ON ERROR UNDO COMPILE-BLK, LEAVE COMPILE-BLK:

        ASSIGN
          cSaveIntoString   = "":U
          cCompileIntoDir  = "":U
          .

        /* Dynamics Enhancement Checks */
        IF CAN-DO(_AB_Tools,"Enable-ICF")
        THEN DO:
          cSaveIntoString  = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE , "enable_save_into":U) NO-ERROR.
          ERROR-STATUS:ERROR = NO.
        END. /* CAN-DO(_AB_Tools,"Enable-ICF") */
        ELSE 
          cSaveIntoString = ?.

        IF  cSaveIntoString <> "":U
        AND cSaveIntoString <> ?
        THEN
        DO iSaveIntoLoop = 1 TO NUM-ENTRIES(cSaveIntoString,",":U):

          cSaveIntoValue     = ENTRY(iSaveIntoLoop,cSaveIntoString,",":U).

          cSaveIntoSource    = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE , ENTRY(1,cSaveIntoValue,"|":U)) NO-ERROR.
          ERROR-STATUS:ERROR = NO.

          cSaveIntoTarget    = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE , ENTRY(2,cSaveIntoValue,"|":U)) NO-ERROR.
          ERROR-STATUS:ERROR = NO.

          ASSIGN
            cSaveIntoSource   = TRIM( REPLACE(cSaveIntoSource,"~\":U,"~/":U) ,"~/":U)
            cSaveIntoTarget   = TRIM( REPLACE(cSaveIntoTarget,"~\":U,"~/":U) ,"~/":U)
            cToSaveSourceName = TRIM( REPLACE(_save_file     ,"~\":U,"~/":U) ,"~/":U)
            .

          /* Only compile into if the file reside in the root directory */
          /* This statement might not be true for all cases, but will be changed if it occurs */
          IF cToSaveSourceName BEGINS cSaveIntoSource
          THEN DO:

            ASSIGN
              cToSaveTargetName = REPLACE( cToSaveSourceName ,cSaveIntoSource , cSaveIntoTarget).
            /* Break the file name into its component parts. */
            RUN adecomm/_osprefx.p (cToSaveTargetName, OUTPUT cSaveDirectory, OUTPUT cSaveFilename).
            ASSIGN
              cSaveFilename     = TRIM( REPLACE(cSaveFilename ,"~\":U          ,"~/":U) ,"~/":U)
              cSaveDirectory    = TRIM( REPLACE(cSaveDirectory,"~\":U          ,"~/":U) ,"~/":U)
              cSaveDirRelative  = TRIM( REPLACE(cSaveDirectory,cSaveIntoTarget ,"":U)   ,"~/":U)
              cSaveDirRoot      = TRIM( REPLACE(cSaveDirectory,cSaveDirRelative,"":U)   ,"~/":U)
              .
            ASSIGN
              cCompileIntoDir = cCompileIntoDir
                               + (IF cCompileIntoDir <> "":U THEN ",":U ELSE "":U)
                               + cSaveDirectory
              compile-into     = cSaveDirRelative
              .

          END.

        END. /* cSaveInto = "YES":U */
        ELSE
          ASSIGN
            compile-into     = _P._compile-into
            cCompileIntoDir  = _P._compile-into.

        IF cCompileIntoDir   = "":U
        THEN
          ASSIGN
            cCompileIntoDir  = _P._compile-into.
        IF cCompileIntoDir   = "":U
        OR cCompileIntoDir   = ?
        THEN
          ASSIGN
            cCompileIntoDir  = "?":U.

        IF _P._compile-into  = ?
        THEN
          ASSIGN
            _P._compile-into = compile-into.
        IF compile-into      = ?
        THEN
          ASSIGN
            compile-into     = _P._compile-into.

        IF  _P._compile-into <> "":U
        AND SUBSTRING(_P._compile-into,1,4) =  "icf/":U
        AND SUBSTRING(_P._compile-into,1,7) <> "icf/trg":U
        THEN
          ASSIGN
            _P._compile-into = SUBSTRING(_P._compile-into,5,LENGTH(_P._compile-into)).

        DO iCompileLoop = 1 TO NUM-ENTRIES(cCompileIntoDir,",":U):

          ASSIGN
            cCompileSaveInto = ENTRY(iCompileLoop,cCompileIntoDir,",":U).

          IF cCompileSaveInto = ? /* (was) _P._compile-into = ? */
          OR cCompileSaveInto = "?":U
          THEN DO:

            COMPILE VALUE(_save_file) SAVE NO-ERROR.
            IF NOT COMPILER:ERROR AND _P._db-aware AND NOT _P._no-proxy
            THEN
              COMPILE VALUE(proxy-file) SAVE NO-ERROR.
            RUN add-cmp-msgs.
  
          END.  /* IF _compile-into = ? */
          ELSE DO:

            /* Make sure the compile-into directory is a valid (writable) directory. */
            ASSIGN
              FILE-INFO:FILE-NAME = cCompileSaveInto. /* compile-into */

            err_msg = IF FILE-INFO:FULL-PATHNAME = ?
                      THEN "does not exist." 
                      ELSE IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0
                      THEN "is not a directory."
                      ELSE IF INDEX(FILE-INFO:FILE-TYPE,"W") = 0
                      THEN "is not a directory that can be written to."
                      ELSE "".

            IF err_msg = ""
            THEN DO:

              /* Compile the file into the desired directory. */
              COMPILE VALUE(_save_file) SAVE INTO VALUE(FILE-INFO:FULL-PATHNAME) NO-ERROR.
              IF NOT COMPILER:ERROR AND _P._db-aware AND NOT _P._no-proxy
              THEN
                COMPILE VALUE(proxy-file) SAVE INTO VALUE(FILE-INFO:FULL-PATHNAME) NO-ERROR.
              RUN add-cmp-msgs.

            END.
            ELSE DO:

              MESSAGE "The compile directory specified in the" {&SKP}
                      "Procedure Settings (" + _P._Compile-into + ")" {&SKP}
                      err_msg SKIP(1)
                      "'" + _save_file + "' will be compiled locally."
                      VIEW-AS ALERT-BOX WARNING.
              compile-into = ?.
              COMPILE VALUE(_save_file) SAVE NO-ERROR.
              IF NOT COMPILER:ERROR AND _P._db-aware AND NOT _P._no-proxy
              THEN
                COMPILE VALUE(proxy-file) SAVE NO-ERROR.
              RUN add-cmp-msgs.

            END.                                  

          END. /* _P._compile-into <> ? */

          /* Save the file we compiled into. */
          RUN get-comp-file (_save_file, compile-into, OUTPUT comp_file).

          /* Note any errors. */            
          IF COMPILER:ERROR
          THEN DO:   
            /* There is one error that we want to trap for explicitly.
               That is the error where the compile file could not be created. */
            ASSIGN
              cant_compile  = NO
              cnt           = ERROR-STATUS:NUM-MESSAGES.
            DO i = 1 TO cnt:
              IF ERROR-STATUS:GET-NUMBER(i) = {&ERR-cant-compile}
              THEN
                ASSIGN
                  cant_compile  = YES
                  err_msg       = ERROR-STATUS:GET-MESSAGE (i).
            END.    
            /* If we couldn't compile because the file could not be created,
               then report that error just as PROGRESS would.  Otherwise note 
               that the file was saved, but it won't run. */
            IF cant_compile
            THEN
              MESSAGE
                err_msg SKIP(1)
                "Check that the directory exists, and that you" {&SKP}
                "have privileges to write there." {&SKP} 
                "However, the source file was saved successfully." 
                VIEW-AS ALERT-BOX ERROR.
            ELSE DO:
              ASSIGN
                can_run = NO.
              MESSAGE
                _save_file SKIP
                "The file was saved. However, it did not compile successfully." SKIP (1)
                "Would you like to view the compilation errors?"
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO 
                UPDATE ok2continue.  
              IF ok2continue
              THEN
                RUN report-compile-errors (_save_file).

            END. /* saved, but did not compile. */

          END. /* IF compiler:error ... */

        END. /* DO iCompileLoop = 1 TO NUM-ENTRIES(cCompileIntoDir,",":U) */

      END. /* COMPILE-BLK: DO... */

    END. /* IF (before-compile)...OK2Continue... */

    /* Note that the compile is over. */
    RUN adecomm/_adeevnt.p ("UIB":U
                           ,"COMPILE"
                           ,context
                           ,_save_file
                           ,OUTPUT ok2continue).

  END. /* IF _P._COMPILE... */

  /* If we saved a SmartObject, then recreate all the objects that this file
     points to. [Note: we need to test with FILE-INFO because the pathnames may
     be stored differently. */
  IF can_run
  THEN DO:     
    /* Get the complete file name for the saved file. */
    ASSIGN
      FILE-INFO:FILE-NAME = _save_file
      file_name           = FILE-INFO:FULL-PATHNAME
      .
    /* Preselect here because "_recreat.p" is going to create a new _U._HANDLE
       which would change the default ordering in a FOR EACH _U... */
    RECREATE-BLOCK:
    REPEAT PRESELECT EACH _U WHERE _U._TYPE   EQ "SmartObject"
                             AND   _U._STATUS NE "DELETED":U:
      FIND NEXT _U.
      FIND _S WHERE RECID(_S) EQ _U._x-recid.
      FILE-INFO:FILE-NAME = _S._FILE-NAME.
      /* Is the smartObject an instance of either the source file or the compiled file? */
      IF FILE-INFO:FULL-PATHNAME EQ file_name OR 
         (comp_file NE ? AND FILE-INFO:FULL-PATHNAME EQ comp_file) THEN DO:
        /* Before we recreate the object, check the flag.  Note that this code
           will happen only on the 2nd SmartObject found.  Tell the user that
           we are going to stop recreating instances of the file. */
        IF NOT can_run THEN DO:
          MESSAGE _save_file SKIP
                  "The SmartObject was saved. However, it does not" {&SKP}
                  "run successfully."   SKIP (1)
                  "Additional instances of this" _P._TYPE "will not" {&SKP}
                  "be recreated using the new master file until the" {&SKP}
                  "errors have been fixed."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.            
          /* Stop recreating objects */
          LEAVE RECREATE-BLOCK.
        END.
        RUN adeuib/_recreat.p (RECID(_U)).
        /* If the SmartObject did not recreate successfully, set the flag so
           we won't try to use it again. */
        IF NOT _S._valid-object THEN can_run = no.
        /* Check all the _admlimks and determine if there are still valid */
        ELSE 
        DO:
           /** ************************************
            ** DELETE _admlinks if corresponding _U's signature do not match 
            **/
           /* Determine if queryObject
            * Determine if datalink
            * Determine if signature check required 
            */
           {adeuib/admver.i _S._HANDLE admVersion}
           IF admVersion >= "ADM2":U THEN
           DO:
              ASSIGN lOK = YES
                     cTemp2 = "The SmartObject " + _U._NAME + " was saved."
                              + " However, the following links no longer have a matching signature."
                              + CHR(10).
              .
              LOOPLINKS:
              FOR EACH _admlinks WHERE 
                       (CAN-DO("Data,Update,Filter":U,_admlinks._link-type))
           AND  (INTEGER(_admlinks._link-source) = INTEGER(RECID(_U))
                        OR INTEGER(_admlinks._link-dest) = INTEGER(RECID(_U))) :
                 IF INTEGER(_admlinks._link-dest) = INTEGER(RECID(_U)) THEN
                 DO:
                    FIND x_U WHERE INTEGER(RECID(x_U)) = 
                        INTEGER(_admlinks._link-source) NO-ERROR.

                    /* Pass thru links rely on a link to the _P record rather than _X. There is no
                       point checking the signature with passthrus as they won't match anyway. 
                       I put this code in here to fix 20000404-013. - BSG */
                    IF NOT AVAILABLE(x_U) AND 
                      CAN-FIND(_P WHERE RECID(_P) = INTEGER(_admlinks._link-source)) THEN
                      NEXT LOOPLINKS.

                    ASSIGN cTemp = "from " + x_U._NAME + " to " + _U._NAME
                           cTemp3 = x_U._NAME + " -> " + CAPS(_admlinks._link-type) + " -> " + _U._NAME.
                 END.
                 ELSE
                 DO:
                    FIND x_U WHERE INTEGER(RECID(x_U)) = 
                        INTEGER(_admlinks._link-dest) NO-ERROR.

                    /* Pass thru links rely on a link to the _P record rather than _X. There is no
                       point checking the signature with passthrus as they won't match anyway. 
                       I put this code in here to fix 20000404-013. - BSG */
                    IF NOT AVAILABLE(x_U) AND 
                      CAN-FIND(_P WHERE RECID(_P) = INTEGER(_admlinks._link-dest)) THEN
                      NEXT LOOPLINKS.

                    ASSIGN cTemp = "from " + _U._NAME + " to " + x_U._NAME
                           cTemp3 = _U._NAME + " -> " + CAPS(_admlinks._link-type) + " -> " + x_U._NAME.
                 END.
                 FIND x_S WHERE RECID(x_S) = x_U._x-recid.

                 RUN ok-sig-match (INPUT _S._HANDLE,
                                   INPUT x_S._HANDLE,
                                   INPUT _admlinks._link-type,
                                   INPUT NO,
                                   OUTPUT lOK,
                                   OUTPUT cTempError).
                 IF NOT lOK THEN DO:
                     cTemp2 = cTemp2 + cTemp3 + CHR(10).
                 END. /* Not OK */
              END. /* Each _admlinks */
              IF NOT lOK THEN
              DO:
                     RUN adeuib/_advisor.w (
                     /* Text        */ INPUT cTemp2,
                     /* Options     */ INPUT "",
                     /* Toggle Box  */ INPUT TRUE,
                     /* Help Tool   */ INPUT "uib":U,
                     /* Context     */ INPUT {&Advisor_Link_Conflict},
                     /* Choice      */ INPUT-OUTPUT choice,
                     /* Never Again */ OUTPUT never-again). 
          
                    /* Store the never again value */
                    {&NA-Signature-Mismatch-advslnk} = never-again.
              END.
           END.  /* version ADM2 or greater */
        END.
      END. /* IF..comp_file...*/
    END. /* RECREATE-BLOCK: REPEAT... */
  END. /* IF can_run... */
END PROCEDURE. /* compile-and-save */

/* This procedure outputs the list of connected databases                    */
PROCEDURE db-conn.
  DEF VAR i       AS INTEGER                                           NO-UNDO.
  DEF VAR pass    AS INTEGER                                           NO-UNDO.
  DEF VAR db-used AS LOGICAL                                           NO-UNDO.
  
  /* Check to see if any DB's are used.  The easiest place to look is
     at the procedures external tables, if we are not exporting only some
     widgets. */
  IF p_status NE "EXPORT" THEN db-used = (_P._xTblList NE "").
  ELSE db-used = NO.

  /* Check widgets */
  IF NOT db-used 
  THEN db-used = CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE  
                                     AND _U._STATUS EQ u_status 
                                     AND _U._DBNAME NE ?).
  
  /* Check objects with a query. */
  IF NOT db-used THEN DO:
    SEARCH-BLOCK:
    FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                  AND _U._STATUS EQ u_status 
                  AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY":U, _U._TYPE),
        EACH _C WHERE RECID(_C) = _U._x-recid,
        EACH _Q WHERE RECID(_Q) = _C._q-recid:
      /* Check for Freeform query and populate _Q._TblList */
      FIND _TRG WHERE _TRG._wRECID EQ RECID(_U) AND
                      _TRG._tEVENT EQ "OPEN_QUERY":U NO-ERROR.
     
      IF AVAILABLE _TRG THEN
        RUN build_table_list (INPUT _TRG._tCODE, ",":U, YES, INPUT-OUTPUT _Q._TblList).

      IF _Q._TblList NE "" AND _Q._TblList NE ? THEN DO:
        db-used = YES.
        LEAVE SEARCH-BLOCK.
      END. 
    END.  /* SEARCH-BLOCK: FOR EACH FRAME */
  END. /* IF not db-used */

  /* Check SmartObjects. */
  IF NOT db-used THEN DO:
    SEARCH-BLOCK:
    FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                  AND _U._STATUS EQ u_status 
                  AND _U._TYPE EQ "SmartObject",
        EACH _S WHERE RECID(_S) = _U._x-recid:
      IF _S._external-tables NE "" OR _S._internal-tables NE "" THEN DO:
        db-used = YES.
        LEAVE SEARCH-BLOCK.
      END. 
    END.  /* SEARCH-BLOCK: FOR EACH FRAME */
  END. /* IF not db-used */

  /* Check Temp-Table definitions */
  IF NOT db-used THEN DO:
    /* Don't check for type "D" or "W". These are temp-table records for
       the SmartDataViewer and the HTML Mapping Web-Object that we don't want
       to process here. The connected databases for the SmartDataViewer are
       picked up by the check for the DataObject. jep-code 4/22/98 */
    IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                            AND NOT CAN-DO("D,W":U, _TT._TABLE-TYPE)) THEN
       db-used = YES.
  END.  /* IF NOT db-used */

  /* Check for DataObject, which most likely has a database connection.
     Generally this will mean we'll want to check its db connections
     and write them out if none of the above conditions have been met.
     jep-code 4/22/98 */
  IF NOT db-used AND NOT CreatingSuper THEN
    db-used = (_P._data-object <> "":U).
   
  /* Some databases are used, somewhere.  Write them out. */
  IF db-used THEN DO:   /* Some DB is being used */
    PUT STREAM P_4GL UNFORMATTED SKIP "/* Connected Databases " SKIP.

    /* First output the PROGRESS databases - there may be a schema holder. */
    DO pass = 1 to 2:
      DO i = 1 TO NUM-DBS:
        db-used = NO.
        /* First Pass - check progress db's. */
        IF pass = 1 THEN DO:
          IF DBTYPE(i) EQ "PROGRESS"
          THEN RUN db-in-use (INPUT ldbname(i), OUTPUT db-used).
        END.
        ELSE DO:
          IF DBTYPE(i) NE "PROGRESS"   /* A NON-PROGRESS DB */
          THEN RUN db-in-use (INPUT ldbname(i), OUTPUT db-used).
        END.
        
        IF db-used THEN
          PUT STREAM P_4GL UNFORMATTED
              "          " LC(ldbname(i)) 
              FILL(" ",16 - LENGTH(ldbname(i),"CHARACTER":U))
              " "  dbtype(i) SKIP.
      END.  /* DO i = 1 TO NUM-DBS */
    END.  /* DO pass... */
    /* Close the Connected DB Comment. */
    PUT STREAM P_4GL UNFORMATTED "*/" SKIP.    
  END.  /* If a DB is used */
END PROCEDURE.       

/* db-in-use - check if any fields, queries, smartObjects, external tables
   in this procedure use the p_ldbname (its logical name).  Return p_db-used
   if it is. */
PROCEDURE db-in-use :
  DEFINE INPUT  PARAMETER p_ldbname AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_db-used AS LOGICAL NO-UNDO.       

  DEF VAR j             AS INTEGER  NO-UNDO.
  DEF VAR hDataObject   AS HANDLE   NO-UNDO.
  DEF VAR ret-msg       AS CHAR     NO-UNDO.
  DEF VAR DbReferences  AS CHAR     NO-UNDO.
  DEF VAR OldBrokerURL  AS CHAR     NO-UNDO.

  p_db-used = NO.  /* Reinitialize for this DB  (p_ldbname)  */

  /* Check Procedure external tables (if we are not exporting). */
  IF p_status NE "EXPORT" THEN DO:
    DO j = 1 TO NUM-ENTRIES(_P._xTblList):
      IF ENTRY(j,_P._xTblList) BEGINS p_ldbname THEN DO:
        p_db-used = YES.
        RETURN.
      END.
    END. /* DO j... */
  END.
  
  /* Look for any widgets that use this database. */
  IF CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                         AND _U._STATUS EQ u_status 
                         AND _U._DBNAME EQ p_ldbname) THEN DO:
    p_db-used = YES.
    RETURN.
  END.
  
  /* Check all the queries (on dialog-boxes, frames, queries, or browses) */
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                AND _U._STATUS EQ u_status 
                AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY":U, _U._TYPE):
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND _Q WHERE RECID(_Q) = _C._q-recid.
    DO j = 1 TO NUM-ENTRIES(_Q._TblList):
      IF ENTRY(j,_Q._TblList) BEGINS p_ldbname THEN DO:
        p_db-used = YES.
        RETURN.
      END.
    END.  /* DO j = 1 TO NUM-ENTRIES */
  END. /* FOR EACH _U where browse */

  /* Check all the SmartObjects used */
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                AND _U._STATUS EQ u_status 
                AND _U._TYPE EQ "SmartObject":U:
    FIND _S WHERE RECID(_S) = _U._x-recid.
    DO j = 1 TO NUM-ENTRIES(_S._external-tables):
      IF ENTRY(j,_S._external-tables) BEGINS p_ldbname THEN DO:
        p_db-used = YES.
        RETURN.
      END.
    END.  /* DO j = 1 TO NUM-ENTRIES */
    DO j = 1 TO NUM-ENTRIES(_S._internal-tables):
      IF ENTRY(j,_S._internal-tables) BEGINS p_ldbname THEN DO:
        p_db-used = YES.
        RETURN.
      END.
    END.  /* DO j = 1 TO NUM-ENTRIES */
  END. /* FOR EACH _U where SmartObject */
  
  /* Any temp-tables match up? */
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P) 
                          AND _TT._LIKE-DB = p_ldbname) THEN
  DO:
    p_db-used = YES.
    RETURN.
  END.
  
  /* What about the DataObject? Does it have a matching db-reference?
     jep-code 4/22/98 */  
  IF (_P._data-object <> "":U) THEN
  DO:
     
     /* We need to deal with rempote procedures also */
    IF web_file THEN
    DO:
       /* The _rsdoatt.p uses the _brokerURL SHARED variable */
      ASSIGN OldBrokerURL = _brokerURL 
            _brokerURL    =  IF  _brokerURL     <> _p._broker-url 
                             AND _p._broker-url <> ''
                             AND _p._broker-url <> ? 
                             THEN _P._Broker-URL
                             ELSE _brokerURL.
                        
      RUN adeweb/_rsdoatt.p (_P._data-object,
                             "Attribute",
                             "DB-REFERENCES",
                              OUTPUT DbReferences) NO-ERROR. 
      IF ERROR-STATUS:ERROR THEN
      DO:
        /* 
        What should happen if we an error is returned from this request ?  
        It is most likely an error in _P._broker-url, which again means that 
        the object won't get saved anyway */
      
        MESSAGE 
         "An error was encountered when trying to request " _P._data-object 
         "database references." 
        view-as alert-box warning.         
      END.        
      ASSIGN _brokerUrl = OldBrokerURL. 
    END.          
    ELSE
    DO:    
      hDataObject = DYNAMIC-FUNC("get-proc-hdl" IN _h_func_lib, _P._data-object).
      IF VALID-HANDLE(hDataObject) THEN
      DO:
        DbReferences = hDataObject:DB-REFERENCES. 
        ret-msg = DYNAMIC-FUNC("shutdown-proc" IN _h_func_lib, _P._data-object).
      END.
    END.
    ASSIGN
      p_db-used = CAN-DO(DbReferences, p_ldbname).       
  END.

END PROCEDURE. /* db-in-use */

/* report-compile-errors - show any errors either in the Section editor or
   in the Code Preview window.  [Note that the Section Editor is actually
   called by the calling routine in the UIB main procedure (and is indicated
   by a non-? _err_recid). */
PROCEDURE report-compile-errors :
  DEF INPUT PARAMETER p_comp-file AS CHAR NO-UNDO.

  DEF VAR Err_Num      AS INTEGER NO-UNDO.
  DEF VAR uib_err_text AS CHAR    NO-UNDO.
  DEF VAR rest_of_err  AS CHAR    NO-UNDO.
  DEF VAR erow         AS INTEGER NO-UNDO.
  DEF VAR ecol         AS INTEGER NO-UNDO.
  
  ASSIGN _err_recid   = ?
         _err_msg     = ""  
         uib_err_text = ""
         rest_of_err  = ""
        .
         
  RUN adecomm/_setcurs.p ("").  /* restore cursor for input */

  /* Get message for first non-preprocessor message. */
  DO Err_Num = 1 TO ERROR-STATUS:NUM-MESSAGES:
      IF ERROR-STATUS:GET-NUMBER( Err_Num ) <> {&PP-4345} THEN LEAVE.
  END.

  /* Save the first non-preprocessor error in _err_msg (in case it was in a
     trigger).  Save all errors in case we need "full disclosure". */
  _err_msg = ERROR-STATUS:GET-MESSAGE( Err_Num ).   
  DO i = Err_num + 1 to ERROR-STATUS:NUM-MESSAGES:
    rest_of_err = rest_of_err + CHR(10) + ERROR-STATUS:GET-MESSAGE(i).
  END.   

  /* A compile error has occurred, popup the trigger editor               */
  FIND FIRST _TRG WHERE _TRG._precid = RECID(_P)
                    AND (_TRG._tOFFSET < COMPILER:FILE-OFFSET)
                    AND COMPILER:FILE-OFFSET < (_TRG._tOFFSET + LENGTH(_TRG._tCODE,"RAW":U))
                    AND _TRG._STATUS <> "DELETED"
                    AND _TRG._tEVENT <> "_INCLUDED-LIB" NO-ERROR.

  IF AVAILABLE _TRG 
  THEN ASSIGN _err_recid = RECID(_TRG).
  ELSE DO: 
    /* Build the error message backwords */
    IF p_status BEGINS "SAVE":U
    THEN uib_err_text = 
              "Due to the error, " + _save_file + " was not compiled. ".
    ELSE uib_err_text = 
              "An error has occurred during the 4GL code generation. " + 
              "A copy of the erroneous code is saved as " +  
              p_comp-file + ".".
    _err_msg = uib_err_text + chr(10) + chr(10) + 
               "The following errors were found:" + chr(10) + 
               _err_msg + rest_of_err.

    IF _save_file NE COMPILER:FILENAME THEN
    /* If the file that has the error is an include file, we
     * cannot position the editor to the error. So, put it up
     * at the top of the file.
     */
      ASSIGN ecol = 0
             erow = 0.
    ELSE
      ASSIGN ecol = COMPILER:ERROR-COLUMN
             erow = COMPILER:ERROR-ROW.
             
    /* Show the error and the bad code */
    RUN adeuib/_prvw4gl.p (INPUT p_comp-file, 
                           INPUT _err_msg, 
                           INPUT ecol, 
                           INPUT erow).
  END.
END PROCEDURE. 

/* get-comp-file: starting with a source file and a compile-into directory,
 * Try to get the full pathname of the file that they were compiled into.
 * If the r-code does not exist, return ?. */
PROCEDURE get-comp-file :

  DEFINE INPUT  PARAMETER p_source  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_dir     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_rcode   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cnt               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE file-base         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE file-prfx         AS CHARACTER  NO-UNDO.

  /* Break the file name into its component parts. For example:
     c:\bin.win\gui\test.w => file-prfx "c:\bin.win\gui\", file-base "test.r" */
  RUN adecomm/_osprefx.p (p_source, OUTPUT file-prfx, OUTPUT file-base).

  /* Replace the file extention with "r". */
  cnt = NUM-ENTRIES(file-base, ".").
  CASE cnt:
    WHEN 0 THEN file-base = ?.
    WHEN 1 THEN file-base = file-base + ".r".
    OTHERWISE   ENTRY(cnt, file-base, ".") = "r".
  END CASE.

  /* Is the p_dir (compile) directory a real directory?  If so, parse it,
     Otherwise, use the current directory. */
  IF  p_dir NE ?
  AND p_dir NE "."
  THEN DO:
    /* Is the compile directory a full path, or is it relative to the file 
       prefix?  Check for names that have ":", indicating a DRIVE or names
       that start with / or \.  */
    IF (CAN-DO("OS2,MSDOS,WIN32,UNIX,VMS":u,OPSYS)
    AND INDEX(p_dir,":":u) > 0) 
    OR  CAN-DO("~\/", SUBSTRING(p_dir, 1, 1, "CHARACTER"))
    THEN file-prfx = p_dir + "/".
    ELSE file-prfx = file-prfx + p_dir + "/".
  END.

  /* Return the full pathname of the compiled file, if it exists. */
  ASSIGN
    FILE-INFO:FILE-NAME = file-prfx + file-base
    p_rcode = FILE-INFO:FULL-PATHNAME
    .

END PROCEDURE.

PROCEDURE Put_Proc_Desc:
/* Outputs the Procedure Description into the .W */
  PUT STREAM P_4GL UNFORMATTED
    "/* Procedure Description" SKIP.
  EXPORT STREAM P_4GL _P._DESC.
  PUT STREAM P_4GL UNFORMATTED
    SKIP "*/" SKIP.
END PROCEDURE.     

{adeuib/_genpro2.i}    




