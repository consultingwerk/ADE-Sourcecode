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

File:rydynsckrp.p

Description:
    Suck in dynamic objects -- This regenerates a UIB session.
    NOTE: This is a stipped down version of _qssuckr.p that has been
          modified for the sole purpose of reading dynamic objects
          (initially only Dynamic Viewers) into the AppBuilder for
          editing.

Input Parameters:
   open_file - File name (should be a dynamic object name) to suck in.
   import_mode - Mode for operation.
                  "WINDOW" - open a .w file (Window or Dialog Box)
   
Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 2002

History:
    Hunter 2/25/2002 created from _qssuckr.p
                   to the file to open (input parameter open_file).
---------------------------------------------------------------------------- */
{src/adm2/globals.i}
{adeuib/timectrl.i}  /* Controls inclusion of profiling code */
{adecomm/adefext.i}

DEFINE INPUT PARAMETER open_file AS CHAR NO-UNDO .
                         /* File to open                                     */
DEFINE INPUT PARAMETER import_mode  AS CHAR NO-UNDO .
                         /* "WINDOW", "WINDOW UNTITLED" or "IMPORT"          */

{adeuib/uniwidg.i}       /* Universal Widget TEMP-TABLE definition           */
{adeuib/brwscols.i}      /* Temp-table to browser columns                    */
{adeuib/triggers.i}      /* Trigger TEMP-TABLE definition                    */
{adeuib/xftr.i}          /* XFTR TEMP-TABLE definition                       */
{adeuib/layout.i}        /* Layout temp-table definitions                    */
{adeuib/name-rec.i NEW}  /* Name indirection table                           */
{adeuib/sharvars.i}      /* Shared variables                                 */
{adeuib/frameown.i NEW}  /* Frame owner temp table definition                */
{adecomm/adeintl.i}
{adeshar/mrudefs.i}      /* MRU FileList shared vars and temp table definition */
{ry/app/rydefrescd.i}    /* Global definitons needed for customization       */


/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "~r" + &ENDIF CHR(10)

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE NEW SHARED VAR _inp_line      AS CHAR       EXTENT 100          NO-UNDO.
DEFINE NEW SHARED STREAM _P_QS.
DEFINE NEW SHARED STREAM _P_QS2.
DEFINE NEW SHARED VAR adj_joincode    AS LOGICAL    INITIAL NO         NO-UNDO.
DEFINE NEW SHARED VAR _can_butt       AS CHAR       INITIAL ?          NO-UNDO.
DEFINE NEW SHARED VAR _def_butt       AS CHAR       INITIAL ?          NO-UNDO.
DEFINE NEW SHARED VAR tab-number      AS INTEGER                       NO-UNDO.
DEFINE NEW SHARED VAR adm_version     AS CHARACTER                     NO-UNDO.


/* ok to load if not connected to the backend database that made the qs file */
DEFINE NEW SHARED VARIABLE dot-w-file AS CHAR   FORMAT "X(40)"         NO-UNDO.
DEFINE NEW SHARED VARIABLE def_found  AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE NEW SHARED VARIABLE main_found AS LOGICAL INITIAL FALSE         NO-UNDO.

DEFINE VARIABLE added_fields  AS     CHAR                              NO-UNDO.
DEFINE VARIABLE adv_choice    AS     CHAR                              NO-UNDO.
DEFINE VARIABLE adv_never     AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE BaseQryStrng  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE BldSeq        AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE block_pointer AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE cAssignList   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cAttr         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cBrokerURL    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cBrowseFields         AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cEnabledFields        AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColBGColors      AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColFGColors      AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColFonts         AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColFormats       AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColLabelBGColors AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColLabelFGColors AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColLabelFonts    AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColLabels        AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cBrwsColWidths        AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cAssignsInThisTable   AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cCode         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cColumnsInThisTable   AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE cColumnName   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cColumnTable  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDataColumns  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDataColumnsByTable  AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cCalcFields   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDBNAME       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDispName     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDynClass     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDynExtClass  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cEnabledInThisTable  AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cFieldName    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cHideOnInit   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cIncludeFile  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cInstanceColumns     AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cLogicalObjName      AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE cName         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE ComboDel      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE ComboFlg      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE ComboFlgVal   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE count_tmp     AS     INTEGER
                              EXTENT {&WIDGET-COUNT-DIMENSION}         NO-UNDO.
DEFINE VARIABLE cProperties   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBDBNames    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBFieldDataTypes AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBFieldWidths AS    CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBInhVals    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBJoinCode   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cQBWhereClauses AS   CHARACTER                         NO-UNDO.
DEFINE VARIABLE cDataFieldFormat   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDataFieldHelp     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDataFieldLabel    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cResultCodes  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cSDOName      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTables       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTableName    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cToken        AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTmp          AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cTmpFldList   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cUpdatableColumns AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE cUpdatableColumnsByTable AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE CurDescVal    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE CurKeyVal     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cValue        AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE cWidgetName   AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE dCurrentLanguageObj  AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE dCurrentUserObj AS   DECIMAL                           NO-UNDO.
DEFINE VARIABLE dRecordIdentifier    AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE dSdoSmartObjectObj   AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE disedFld      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE DisDT         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE DisFrmt       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE disOnIn       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE dMinHeight    AS     DECIMAL                           NO-UNDO.
DEFINE VARIABLE dMinWidth     AS     DECIMAL                           NO-UNDO.
DEFINE VARIABLE DSFormat      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE dyn_offset    AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE dyn_object    AS     LOGICAL                           NO-UNDO. /* jep-icf */
DEFINE VARIABLE dyn_temp_file AS     CHARACTER                         NO-UNDO. /* jep-icf */
DEFINE VARIABLE dyn_widget    AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE enableFld     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE err_msgs      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE f_bar_pos     AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE file_version  AS     CHAR                              NO-UNDO.
DEFINE VARIABLE file_ext      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE FldLabel      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE FldName       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE FldToolTip    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE foundIt       AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE _frame_name   AS     CHAR                              NO-UNDO.
DEFINE VARIABLE h             AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE hAttributeBuffer     AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hBufferTableBuffer   AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hClassTable   AS     HANDLE        EXTENT 32           NO-UNDO.
DEFINE VARIABLE hColumn       AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hfgp          AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE hField        AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hLinkTable    AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hObjectBuffer AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hObjectQuery  AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hPageInstanceTable   AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hPageTable    AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hRowObjectBuffer     AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hSDO          AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hSDOBuffer    AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hSDOAttributeBuffer  AS HANDLE                         NO-UNDO.
DEFINE VARIABLE hTableBuffer  AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE hUiEventTable AS     HANDLE                            NO-UNDO.
DEFINE VARIABLE h_butt        AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_frame_init  AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_menu        AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_toggle      AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_xml         AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE i             AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iCode         AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iCnt          AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iCounter      AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iColumn       AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iField        AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE ilnth         AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iNumCalc      AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE InLines       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE import_unnamedframe  AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE isRyObject    AS     LOGICAL                           NO-UNDO. /* jep-icf */
DEFINE VARIABLE iTable        AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iToken        AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iWhereStored  AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE j             AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE iPos          AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE KeyDT         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE KeyFld        AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE KeyFrmt       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE lSBODataSource AS    LOGICAL                           NO-UNDO.
DEFINE VARIABLE ldummy        AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE lFoundIt      AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE ListItmPrs    AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE lMasterLO     AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE menu_recid    AS     RECID                             NO-UNDO.
DEFINE VARIABLE newDigit      AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE no-block-flag AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE notVisual     AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE numCol        AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE par_menu_rec  AS     RECID                             NO-UNDO.
DEFINE VARIABLE ParentFld     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE ParentFldQry  AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE ParentRecid   AS     RECID                             NO-UNDO.
DEFINE VARIABLE pressed-ok    AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE QryTables     AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE relative_path AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE SdfFN         AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE SdfTmplt      AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE SDOFile       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE Secured       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE settings      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE temp_file     AS     CHARACTER INITIAL ""             NO-UNDO.
DEFINE VARIABLE temp-name     AS     CHAR                              NO-UNDO.
DEFINE VARIABLE tmpName       AS     CHARACTER                         NO-UNDO.
DEFINE VARIABLE tmp-rec       AS RECID                                 NO-UNDO.
DEFINE VARIABLE v_exists      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE web_file      AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE web_temp_file AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE wndw          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE dFrameMaxWidth  AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE dFrameMaxHeight AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE dWidgetHeight   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidgetRow      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidgetWidth    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidgetCol      AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hWindow         AS HANDLE                              NO-UNDO.
DEFINE VARIABLE cCustomSuperProc AS CHARACTER                             NO-UNDO.

/* Define variables required for Dynamic Lookups and Combos */
DEFINE VARIABLE lLocalField               AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lBlankOnNotAvail          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cLkupBrowseFieldDataTypes AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLkupBrowseFieldFormats   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLkupBrowseFields         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLkupBrowseTitle          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLkupColumnFormats        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLkupColumnLabels         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dFieldWidth               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cLinkedFieldDataTypes     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLinkedFieldFormats       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMaintenanceObject        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMaintenanceSDO           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPhysicalTableNames       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lPopupOnAmbiguous         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lPopupOnUniqueAmbiguous   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lPopupOnNotAvail          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cQueryBuilderOptionList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryBuilderOrderList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryBuilderTableOptList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryBuilderTuneOptions  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQueryBuilderWhereClauses AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iRowsToBatch              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTemp                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempTables               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedFields       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cViewerLinkedWidgets      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hCustomizationManager AS HANDLE                        NO-UNDO.
DEFINE VARIABLE gcSessionResultCodes  AS CHARACTER                     NO-UNDO.

DEFINE BUFFER p_U             FOR _U.
DEFINE BUFFER p_C             FOR _C.
DEFINE BUFFER l_U             FOR _U.
DEFINE BUFFER l_F             FOR _F.
DEFINE BUFFER x_U             FOR _U.
DEFINE BUFFER x_P             FOR _P.
DEFINE BUFFER x_M             FOR _M.
DEFINE BUFFER x_L             FOR _L.
DEFINE BUFFER f_U             FOR _U.
DEFINE BUFFER f_F             FOR _F.
DEFINE BUFFER f_L             FOR _L.
DEFINE BUFFER m_L             FOR _L.
DEFINE BUFFER obj1_U          FOR _U.
DEFINE BUFFER obj2_U          FOR _U.
DEFINE BUFFER parent_NAME-REC FOR _NAME-REC.
DEFINE BUFFER x_smartObject   FOR ryc_smartObject.

DEFINE VAR FileHeader        AS CHAR INITIAL "" NO-UNDO.
DEFINE VAR AbortImport         AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR tCode               AS CHAR NO-UNDO.
DEFINE VAR Selected_Frames     AS INT  NO-UNDO.

/* These are generic attributes for all widgets. */
DEFINE TEMP-TABLE ttWidget          NO-UNDO             RCODE-INFORMATION
    /* Key data */
    FIELD tWidgetType           AS CHARACTER        /* visualisation */
    FIELD tWidgetName           AS CHARACTER
    FIELD tWidgetHandle         AS HANDLE
    FIELD tFrameHandle          AS HANDLE
    FIELD tObjectInstanceObj    AS DECIMAL
    FIELD tRecordIdentifier     AS DECIMAL
    FIELD tClassBufferHandle    AS HANDLE
    FIELD tLabelFont            AS INTEGER      INITIAL ?
    FIELD tBasedOnDataSource    AS LOGICAL      INITIAL NO
    FIELD tBasedOnSchema        AS LOGICAL      INITIAL NO
    INDEX idxObjectInstance
        tObjectInstanceObj.

/* jep-icf: Process repository object requests. */
RUN processRepositoryObject.
IF RETURN-VALUE = "_ABORT":U THEN RETURN "_ABORT":U.

/* Make the _ryObject record available to all internal procs */
FIND _RyObject WHERE _RyObject.object_filename = open_file NO-LOCK NO-ERROR.

ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.
  

/* If the mode is not WINDOW/IMPORT, put a message                        */
/* and abort importing the file.                                          */
IF CAN-DO("IMPORT,WINDOW,WINDOW UNTITLED":U, import_mode) EQ no THEN DO:
  MESSAGE "Unknown {&UIB_NAME} load mode " + import_mode + ". Aborting load." 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN "_ABORT":U.
END.

ASSIGN dot-w-file = open_file.
       pressed-ok = TRUE.

/*
 * If the user is trying to open a window that is already open then
 * tell caller. The caller should then make that window the active one.
 * Do not open the window twice. The UIB can open the same window twice.
 * However, the windows are disjoint and cause useability problems since
 * the windows are not in synch.
 *
 * This situation handles reopening a file via "Edit Master...".
 *
 * We don't need to do this if import_mode is "WINDOW UNTITLED".
 */
IF import_mode eq "WINDOW":U THEN DO:
  /* Search the universal records for a window with the same file name and,
     if on a remote WebSpeed file, the same broker URL. */
  FIND x_P WHERE x_P._SAVE-AS-FILE EQ dot-w-file NO-ERROR.

  IF AVAILABLE x_P THEN DO:
    h = x_P._WINDOW-HANDLE.
    /* Get the real window for a dialog-box _U */
    IF h:TYPE ne "WINDOW":U THEN h = h:PARENT.
    RUN adecomm/_setcurs.p ("").
    /* Tell caller file already exists using "reopen" message. */
    RETURN "_REOPEN,":U + STRING(h).
  END.
END.  /* If import mode is "WINDOW" */

/* May we can get rid of this, but for now we need it */
RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB_QS}, OUTPUT temp_file).

/*  In a dynamic object, dot-w-file contains only the object name. Since 
    it doesn't really exist (except as data in the repository), set the dot-w-file 
    variable to the name of a copy of the dynamic object's template file, which the 
    AB uses for opening such objects. Variable dot-w-file is set back to the object 
    name (stored in open_file) after the analyze is complete. */
ASSIGN _save_file = dot-w-file
       dot-w-file = dyn_temp_file.

/* Analyse and Verify the file we are looking at. If there is a problem then exit */
AbortImport = no.
{adeuib/vrfyimp.i} /* This Runs ANALYSE ... NO-ERROR. */

IF AbortImport THEN DO:
  RUN dynsucker_cleanup.
  RETURN "_ABORT":U.
END.

/* jep-icf: If dynamic object, reset variable dot-w-file to the object name. */
ASSIGN dot-w-file = open_file.


/* Deselect any selected objects prior to loading (because loading will
   load a new set). */
FOR EACH _U WHERE _U._SELECTEDib:
  _U._SELECTEDib = no.
  IF VALID-HANDLE(_U._HANDLE) AND CAN-SET(_U._HANDLE,"SELECTED")
  THEN _U._HANDLE:SELECTED = NO.
END.

/* Save current count */
DO i = 1 TO {&WIDGET-COUNT-DIMENSION}:
  count_tmp[i] = _count[i].
END.

CASE import_mode:
  WHEN "WINDOW":U OR WHEN "WINDOW UNTITLED":U THEN DO:
    ASSIGN _count       = 0 
           h_frame_init = ?  
           _h_frame     = ?
           _h_win       = ?.
  END. /* Importing a WINDOW */

  OTHERWISE DO: /* This should not occur, since it is verified first */
    MESSAGE "Unknown import mode " + import_mode + ". Aborting import." 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RUN dynsucker_cleanup. /* Close everyting qssucker does */
    RETURN "_ABORT":U.
  END. /* Unknowm Import Format */
END CASE.

/* Save the file position, we scan down to the Analyzer widget definitions    */
/* and process them, then come back to this point to process code blocks      */
/* NOTE: For the case of a single window with NO frames, there will be no     */
/* _ANALYZER_BEGIN section. So the 2nd exit condition is if we get an error   */
/* reading from the file. */
block_pointer = SEEK(_P_QS).
SCAN-FILE:
REPEAT WHILE NOT _inp_line[1] begins "_ANALYZER_BEGIN" 
       ON END-KEY UNDO SCAN-FILE, RETRY SCAN-FILE:   /* Ignore "." lines in a file */
  IMPORT STREAM _P_QS UNFORMATTED _inp_line[1] NO-ERROR. /* Catch END-OF-FILE here */
  IF ERROR-STATUS:ERROR THEN DO:
    no-block-flag = TRUE.
    LEAVE SCAN-FILE.                                 
  END.        

  /* Catch ? as the only entry. Bug #96-06-06-10*/
  IF _inp_line[1] eq ? THEN _inp_line[1] = "?":U.
  
  /* In 7.4A, the _CREATE-WINDOW is preceded by a _PROCEDURE-SETTINGS section */
  IF _inp_line[1] BEGINS " _PROCEDURE-SETTINGS":U THEN DO:
    /* For WDT_v2 objects, we have already created a _P, since the Procedure
       type and template info is stored along with the version number on the
       first line. */
    IF NOT AVAILABLE _P THEN CREATE _P.
    _P._file-version = file_version.  /* Its important to save file_version early */
    RUN adeuib/_rdproc.p (RECID(_P)).
  END.

  /* We need to read the Window definition before we create the frame */
  IF _inp_line[1] BEGINS " _CREATE-WINDOW" THEN DO:
    /* 7.3 Compatilitity: There will not be a _P if the .w file is old. */
    IF NOT AVAILABLE (_P) THEN DO:
      CREATE _P.
      ASSIGN _P._TYPE         = "Window":U
             _P._file-version = file_version.
    END.
    RUN adeuib/_rdwind.p (RECID(_P)).
    FIND _U WHERE _U._HANDLE = _h_win.
    ASSIGN _U._PARENT-RECID = RECID(_U)
           _U._WIN-TYPE     = YES.
  END. /* End of window creation block */
  
  IF _inp_line[1] BEGINS "/* REPARENT FRAME":U THEN DO:
    _inp_line = "".
    REPEAT WHILE INDEX(_inp_line[5],".":U) = 0 AND INDEX(_inp_line[6],".":U) = 0:
      IMPORT STREAM _P_QS _inp_line.
      i = IF _inp_line[1] = "ASSIGN":U THEN 1 ELSE 0.
      CREATE _frame_owner_tt.
      ASSIGN _frame_owner_tt._child  = ENTRY(1,_inp_line[i + 2],":":U)
             _frame_owner_tt._parent = ENTRY(1,_inp_line[i + 5],":":U).
    END.  /* Repeat till period is found. */   
    SEEK STREAM _P_QS TO block_pointer.
    LEAVE SCAN-FILE.
  END.
END.  /* SCAN-FILE */

IF no-block-flag THEN DO:
  INPUT STREAM _P_QS CLOSE.
  INPUT STREAM _P_QS FROM VALUE(temp_file) {&NO-MAP}.
  SEEK STREAM _P_QS TO block_pointer.
END.

/* Check to see if this exists */
FILE-INFO:FILE-NAME = temp_file + "2":U.
IF FILE-INFO:FILE-TYPE = ? THEN
  _inp_line[1] = "".
ELSE DO:
  INPUT STREAM _P_QS2 FROM VALUE(temp_file + "2":U) {&NO-MAP}.
  IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1] NO-ERROR.
END.

/*  Now we are at the start of the ANALYZER DEFINITIONS.  */
IF _inp_line[1] begins "_ANALYZER_BEGIN" THEN
WIDGET-LOOP:
REPEAT ON END-KEY UNDO WIDGET-LOOP, LEAVE WIDGET-LOOP:
  /* Let the user know we are working on something */
  RUN adecomm/_setcurs.p ("WAIT":U).

  /* Read the next line */
  _inp_line = "".
  IMPORT STREAM _P_QS2 _inp_line.
  /* Check to see if we have a valid window to place things into.    */           
  IF _h_win = ? AND _inp_line[1] NE "FR" AND /* May be a dialog      */
     NOT _inp_line[1] BEGINS "M"  /* Menus can come any time - they  */
                                  /* get parented later              */
  THEN DO:   
    MESSAGE "There is no window or dialog-box to place things in.  Aborting" SKIP
            "the opening of" dot-w-file + "."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN "_ABORT":U.
  END.

  CASE _inp_line[1]:
                                        
    WHEN "FR":U THEN DO:  /* Read static FRAME information              */
      ASSIGN _def_butt = ?
             _can_butt = ?.
      /* The UNNAMED frame does not have to be read-in when we are importing. 
         It indicates a frame the UIB used to cut field-level widgets.  */
      IF NOT (import_mode = "IMPORT":U AND _inp_line[2] = "") THEN DO:
        /* Before importing a frame, restore the initial _h_frame so that we
           can parent it, if we need to. */
        _h_frame = h_frame_init.
        tab-number = 0.
        RUN adeuib/_rdfram.p (INPUT-OUTPUT import_mode). 
        
        IF import_mode = "ABORT" THEN DO:
          /* Reset the cursor for user input.*/
          RUN adecomm/_setcurs.p ("").
          MESSAGE "Aborting import." 
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
          RUN dynsucker_cleanup. /* Close everything qssucker does */
          RETURN "_ABORT":U. 
        END.
      END.  /* If importing from the default frame */
      ELSE /* We have found the unnamed frame in import mode.  Be sure to  */
      DO:  /* set the current frame back to the initial in order to parent */
           /* the upcoming widgets */
           ASSIGN _h_frame = h_frame_init.
           /* Set a var to track that the import file is for an unnamed frame.
              Used later when importing an export file to determine which frame's
              properties to set and when setting tab order items. -jep */
           ASSIGN import_unnamedframe = TRUE.
      END.
      /* If a dialog, set menu window handles, and attach it to the procedure.*/
      FIND _U WHERE _U._HANDLE = _h_frame.
      IF _U._TYPE = "DIALOG-BOX" THEN DO:
        /* Attach to Procedure record. */
        IF import_mode NE "IMPORT" THEN DO:
          /* We will have already read in Procedure Settings (and created a _P) but
             the associated _U-recid will not have been set. [unless the file is old].
             -------
             7.3 Compatilitity: There will not be a _P if the .w file is old. */
          IF NOT AVAILABLE (_P) OR _P._u-recid NE ? THEN DO:
            CREATE _P.
            ASSIGN _P._TYPE         = "Dialog-Box":U.
          END.
          ASSIGN _P._SAVE-AS-FILE  = _save_file
                 _P._file-version  = file_version
                 _P._WINDOW-HANDLE = _U._WINDOW-HANDLE
                 _P._u-recid       = RECID(_U).
        END.
        /* Set Menu - Popup menus have been created and attatched to the
           CURRENT-WINDOW (because the dialog-box _h_win was not created
           when the menus were built).  Reparent them*/
        FOR EACH x_U WHERE x_U._WINDOW-HANDLE = CURRENT-WINDOW AND
                          x_U._TYPE BEGINS "MENU":
          x_U._WINDOW-HANDLE = _U._HANDLE.
        END.
      END.
    END.  /* END FR CASE */

    OTHERWISE NEXT WIDGET-LOOP.
  END CASE.
  
  IF RETURN-VALUE = "_ABORT":U THEN DO:
    IF VALID-HANDLE(_h_win) THEN 
       RUN wind-close IN _h_uib (INPUT _h_win).   
    RUN dynsucker_cleanup. /* Close everything qssucker does */
    RETURN "_ABORT":U.
  END.

END.  /* WIDGET-LOOP */

/* Finished reading the analyzer definitions, reset file to begining of code  */
/* block information                                                          */
INPUT STREAM _P_QS2 CLOSE.

SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

ASSIGN AbortImport = no.

/* Make some adjustments to the _P record */
ASSIGN _P._Desc                = IF cDynClass = "DynView":U      THEN "Dynamic SmartDataViewer":U
                                 ELSE IF cDynClass = "DynBrow":U THEN "Dynamic SmartDataBrowser":U
                                 ELSE IF cDynClass = "DynSDO":U  THEN "Dynamic SmartDataObject":U
                                 ELSE "Dynamic Object":U
       _P._Template            = NO
       _P.static_object        = NO
       _P._RUN-PERSISTENT      = YES
       _P._LISTS               = "ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6":U
       _ryObject.design_precid = RECID(_P)
       _P.object_type_code     = _RyObject.object_type_code
       _P.product_module_code  = _RyObject.product_module_code
       _P.object_filename      = _RyObject.object_filename
       _P.design_action        = "OPEN":U
       _P.design_ryobject      = YES.


/* Modify title of window */
_h_win:TITLE = _P._type + "(" + _P.OBJECT_type_code + ") - " 
                              + _P.OBJECT_filename.

/* We need to get the following info of the viewer:
   Its associated SDO (data-source),
   Its obj number,
   Its Height,
   Its Width
   Its title (not currently used */
  ASSIGN cProperties         = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj,currentLanguageObj":U,
                                                INPUT YES)
         dCurrentUserObj       = DECIMAL(ENTRY(1, cProperties, CHR(3))) 
         dCurrentLanguageObj   = DECIMAL(ENTRY(2, cProperties, CHR(3)))
         hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U)
         .

  IF VALID-HANDLE(hCustomizationManager) THEN
      ASSIGN gcSessionResultCodes  = DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager).
  ELSE
      ASSIGN gcSessionResultCodes  = "{&DEFAULT-RESULT-CODE}":U.

  /* Get SDO info from the repository for DynView and DynBrow */
  IF LOOKUP(cDynClass,"DynBrow,DynView":U) > 0 THEN DO:

    /* Create a list of the result codes for this object */
    cResultCodes = "Master Layout":U.   /* Master Layout */
    FOR EACH ryc_smartObject WHERE ryc_smartObject.object_filename = _ryObject.object_filename 
                           AND ryc_smartobject.customization_result_obj NE 0 NO-LOCK:
      FIND ryc_customization_result WHERE ryc_customization_result.customization_result_obj =
                                          ryc_smartobject.customization_result_obj NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_customization_result THEN
        cResultCodes = cResultCodes + ",":U + ryc_customization_result.customization_result_code.
    END.

    FIND ryc_smartobject WHERE ryc_smartobject.object_filename = _ryObject.object_filename 
                           AND ryc_smartobject.customization_result_obj = 0 NO-LOCK NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN DO:
      /* Now find SDO record */
      ASSIGN dSDOSmartObjectObj   = ryc_smartobject.sdo_smartobject_obj.
      FIND ryc_smartobject WHERE ryc_smartobject.smartobject_obj = dSDOSmartObjectObj NO-LOCK NO-ERROR.
      IF AVAILABLE ryc_smartobject THEN DO:
        _P._DATA-OBJECT = ryc_smartobject.object_filename.
        FIND gsc_object_type WHERE 
             gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK NO-ERROR.
        IF AVAILABLE gsc_object_type THEN
          lSBODataSource = DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager,
                                            gsc_object_type.object_type_code , 
                                            "SBO":U).
       
        /* Start SDO (or SBO) */
        IF VALID-HANDLE(gshRepositoryManager) THEN
          RUN StartDataObject IN gshRepositoryManager
                (INPUT ryc_smartobject.object_filename, OUTPUT hSDO).
      END.  /* If we have SDO record */
    END. /* If we have dynviewer or dynbrowser */
    ELSE DO:
      MESSAGE "Unable to locate SDO for this" _RyObject.object_type_code + ".":U
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN.
    END.  /* Else error - abort */
  END. /* If a dynbrow or dynview */


  /* Make sure that the datafield is in the cache */     
  ASSIGN lFoundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                       INPUT _ryObject.object_filename,  /* Object to be fetched into cache */
                       INPUT "*":U,                      /* ResultCode                      */
                       INPUT "":U,                       /* RunAttribute                    */
                       INPUT YES).                       /* Design Mode                     */
                  
  IF NOT lFoundIt THEN DO:
    MESSAGE "Unable to locate" _ryObject.object_filename + ".":U
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "_ABORT":U.
  END.

  ASSIGN hObjectBuffer  = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

  /* loop through all result codes */
  IF cResultCodes = "":U THEN cResultCodes = "Master Layout":U.
  DO iCode = 1 TO NUM-ENTRIES(cResultCodes):
    ASSIGN cCode = ENTRY(iCode, cResultCodes).
    IF cCode = "Master Layout":U THEN
      ASSIGN cCode = "":U
             lMasterLO = YES.
    ELSE lMasterLO = NO.

    IF lMasterLO THEN
      hObjectBuffer:FIND-FIRST(" WHERE ":U
                + hObjectBuffer:NAME + ".tContainerObjectName = '" + _ryObject.object_filename + "' AND ":U
                + hObjectBuffer:NAME + ".tLogicalObjectName = '" + _ryObject.object_filename + "' AND ":U
                + hObjectBuffer:NAME + ".tResultCode = '{&DEFAULT-RESULT-CODE}' AND ":U
                + hObjectBuffer:NAME + ".tUserObj = " + QUOTER(dCurrentUserObj) + " AND "
                + hObjectBuffer:NAME + ".tRunAttribute = '' AND ":U  
                + hObjectBuffer:NAME + ".tLanguageObj = " + QUOTER(dCurrentLanguageObj)  ) .

    ELSE 
      hObjectBuffer:FIND-FIRST(" WHERE ":U
                + hObjectBuffer:NAME + ".tContainerObjectName = '" + _ryObject.object_filename + "' AND ":U
                + hObjectBuffer:NAME + ".tLogicalObjectName = '" + _ryObject.object_filename + "' AND ":U
                + hObjectBuffer:NAME + ".tResultCode = '" + cCode + "' AND ":U
                + hObjectBuffer:NAME + ".tUserObj = " + QUOTER(dCurrentUserObj) + " AND "
                + hObjectBuffer:NAME + ".tRunAttribute = '' AND ":U  
                + hObjectBuffer:NAME + ".tLanguageObj = " + QUOTER(dCurrentLanguageObj)  ) .
  
    IF hObjectBuffer:AVAILABLE THEN DO:
      /* Window and frame stuff into AppBuilder */
      ASSIGN hAttributeBuffer           = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
             dRecordIdentifier          = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
             dSdoSmartObjectObj         = hObjectBuffer:BUFFER-FIELD("tSdoSmartObjectObj":U):BUFFER-VALUE
             cLogicalObjName            = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
             cCustomSuperProc           = hObjectBuffer:BUFFER-FIELD("tCustomSuperProcedure":U):BUFFER-VALUE.

      /* There is only one attribute record for an object */
      hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                              + STRING(dRecordIdentifier) + "' ":U) NO-ERROR.
 
      /* Find window _U and populate */
      FIND _U WHERE _U._TYPE EQ "WINDOW":U AND
                    _U._WINDOW-HANDLE EQ _h_win AND
                    _U._STATUS NE "DELETED":U.

      IF lMasterLO THEN DO:  /* Master Layout */
        FIND _L WHERE RECID(_L) = _U._lo-recid.

        /* Assign the smartObject_obj, this lets us know that the object already exists */
        ASSIGN _U._OBJECT-OBJ = _RyObject.smartobject_obj NO-ERROR.
        /* Set the Custom super procedure */
        FIND _C WHERE RECID(_C) = _U._x-recid.
        ASSIGN _C._CUSTOM-SUPER-PROC = cCustomSuperProc.
      END.  /* If the Master Layout */
      ELSE DO:  /* Any other layout */
        CREATE _L.

        /* Initialize with Master Layout because we only read changes */
        FIND m_L WHERE RECID(m_L) = _U._lo-recid.
        ASSIGN _L._u-recid = RECID(_U)
               _L._LO-NAME = cCode.
        BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME TO _L.
      END.  /* Create an _L for other layouts */

      IF cDynClass NE "DynSDO":U THEN DO:
        ASSIGN dMinHeight = hAttributeBuffer:BUFFER-FIELD("minHeight"):BUFFER-VALUE
               dMinWidth  = hAttributeBuffer:BUFFER-FIELD("minWidth"):BUFFER-VALUE.

        IF dMinHeight = ? THEN dMinHeight = 0.
        IF dMinWidth  = ? THEN dMinWidth  = 0.

        ASSIGN _L._HEIGHT         = IF dMinHeight > 0 THEN dMinHeight ELSE _L._HEIGHT
               _L._Virtual-Height = _L._HEIGHT
               _L._WIDTH          = IF dMinWidth > 0 THEN dMinWidth ELSE _L._WIDTH
               _L._VIRTUAL-WIDTH  = _L._WIDTH
               _L._FONT           = ?
               _L._WIN-TYPE       = YES
               dFrameMaxWidth     = _L._WIDTH
               dFrameMaxHeight    = _L._HEIGHT.

        /* Do the same for the frame */
        FIND _U WHERE _U._TYPE EQ "FRAME":U AND
                      _U._WINDOW-HANDLE EQ _h_win AND
                      _U._STATUS NE "DELETED":U.
        FIND _C WHERE RECID(_C) = _U._x-recid.
        
        /* Assign the custom superprocedure value to the _C record */
        ASSIGN _C._CUSTOM-SUPER-PROC = cCustomSuperProc.
        

        IF lMasterLO THEN /* Master Layout */
          FIND x_L WHERE RECID(x_L) = _U._lo-recid.
        ELSE DO:  /* All other layouts */
          CREATE x_L.
          ASSIGN x_L._u-recid = RECID(_U)
                 x_L._LO-NAME = cCode.

          /* Initialize with Master Layout because we only read changes */
          FIND m_L WHERE RECID(m_L) = _U._lo-recid.
          BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME TO x_L.
        END. /* Create x_L for the frame */

        ASSIGN x_L._HEIGHT         = _L._HEIGHT
               x_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
               x_L._WIDTH          = _L._WIDTH
               x_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH
               x_L._FONT           = _L._FONT.

        IF lMasterLO THEN DO:  /* Only render Master Layout */
          IF _L._WIDTH > _h_win:WIDTH THEN
            ASSIGN _h_win:WIDTH   = _L._WIDTH
                   _h_frame:WIDTH = _L._WIDTH.
          ELSE IF _L._WIDTH < _h_win:WIDTH THEN
            ASSIGN _h_frame:WIDTH = _L._WIDTH
                   _h_win:WIDTH   = _L._WIDTH.
  
          IF _L._HEIGHT > _h_win:HEIGHT THEN
            ASSIGN _h_win:HEIGHT   = _L._HEIGHT
                   _h_frame:HEIGHT = _L._HEIGHT.
          ELSE IF _L._HEIGHT < _h_win:HEIGHT THEN
            ASSIGN _h_frame:HEIGHT = _L._HEIGHT
                   _h_win:HEIGHT   = _L._HEIGHT.
        END.  /* if Master Layout */
      END. /* If not DynSDO */

      /* Process all of the attributes of the Master object*/
      /* Big loop to populate all f_U, f_F and f_L fields */
      IF cDynClass = "DynBrow" THEN DO:
        /* Create _U, _C and _L for it */
        VALIDATE _U.
        VALIDATE _C.
        VALIDATE _L.

        ASSIGN ParentRecid   = RECID(_U).

        IF lMasterLO THEN DO:
          CREATE _U.
          CREATE _C.
        END.
        ELSE DO: /* If not Master Layout */
          FIND _U WHERE _U._NAME = STRING(hObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE)
                    AND _U._TYPE = "Browse":U AND _U._WINDOW-HANDLE = _h_win.
          FIND _C WHERE RECID(_C) = _U._x-recid.
        END.
        CREATE _L.
        IF NOT lMasterLO THEN DO:
          /* Initialize with Master Layout because we only read changes */
          FIND m_L WHERE RECID(m_L) = _U._lo-recid.
          ASSIGN _L._u-recid = RECID(_U)
                 _L._LO-NAME = cCode.
          BUFFER-COPY m_L EXCEPT _u-recid _LO-NAME TO _L.
        END.
       
        IF lMasterLO THEN
          ASSIGN _U._NAME          = hObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE
                 _U._TYPE          = "BROWSE":U
                 _U._HELP-SOURCE   = "E":U
                 _U._LABEL-SOURCE  = "E":U
                 _U._CLASS-NAME    = cDynExtClass
                 _U._LAYOUT-NAME   = "Master Layout":U
                 _U._lo-recid      = RECID(_L)
                 _U._OBJECT-OBJ    = _RyObject.smartobject_obj
                 _U._PARENT        = _h_frame:FIRST-CHILD
                 _U._PARENT-RECID  = ParentRecid
                 _U._SENSITIVE     = YES
                 _U._WINDOW-HANDLE = _h_win
                 _U._x-recid       = RECID(_C)
                 _C._CUSTOM-SUPER-PROC = cCustomSuperProc.

        ASSIGN _L._LO-NAME       = IF lMasterLO THEN "Master Layout":U ELSE cCode
               _L._u-recid       = RECID(_U)
               _L._WIN-TYPE      = YES
               _L._ROW           = 1
               _L._COL           = 1
               _L._COL-MULT      = 1
               _L._ROW-MULT      = 1.

      END.  /* If a DynBrow */

      ELSE IF cDynClass = "DynSDO":U THEN DO:
        /* CREATE _U, _C, _L and _Q for SDO's query */
        VALIDATE _U.
        VALIDATE _C.
        VALIDATE _L.

        ASSIGN ParentRecid   = RECID(_U).

        CREATE _U.   /* Query _U */
        CREATE _C.   /* Query _C */
        CREATE _Q.   /* Query record of the query  */
        CREATE _L.   /* Query _L (not really used) */

        ASSIGN _U._NAME              = "Query-Main"
               _U._TYPE              = "QUERY":U
               _C._q-RECID           = RECID(_Q)
               _U._HELP-SOURCE       = "E":U
               _U._LABEL-SOURCE      = "E":U
               _U._CLASS-NAME        = cDynExtClass
               _U._LAYOUT-NAME       = "Master Layout":U
               _U._lo-recid          = RECID(_L)
               _U._OBJECT-OBJ        = _RyObject.smartobject_obj
               _U._PARENT-RECID      = ParentRecid
               _U._SENSITIVE         = YES
               _U._WINDOW-HANDLE     = _h_win
               _U._SUBTYPE           = "SmartDataObject":U 
               _U._x-recid           = RECID(_C)
               _L._LO-NAME           = _U._LAYOUT-NAME
               _L._u-recid           = RECID(_U)
               _L._ROW               = 1
               _L._COL               = 1
               _L._COL-MULT          = 1
               _L._ROW-MULT          = 1 
               _C._CUSTOM-SUPER-PROC = cCustomSuperProc.
               
      END.  /* End If a DynSDO */

      /* Now get the rest of the attributes */
      DO ifield = 1 TO hAttributeBuffer:NUM-FIELDS:
        ASSIGN hField = hAttributeBuffer:BUFFER-FIELD(ifield)
               cAttr  = hField:NAME.

        IF lMasterLO THEN DO:  /* This case has only default layout stuff */
        
          CASE cAttr:
             
          WHEN "AppService":U                THEN _P._PARTITION         = hField:BUFFER-VALUE.
          WHEN "AssignList":U                THEN cAssignList           = hField:BUFFER-VALUE.
          WHEN "ALLOW-COLUMN-SEARCHING":U    THEN _C._COLUMN-SEARCHING  = hField:BUFFER-VALUE.
          WHEN "AUTO-VALIDATE":U             THEN _C._NO-AUTO-VALIDATE  = NOT hField:BUFFER-VALUE.
          WHEN "BaseQuery":U                 THEN DO:
            _Q._4GLQury           = TRIM(hField:BUFFER-VALUE).
            IF _Q._4glQury BEGINS "FOR ":U THEN 
              _Q._4GLQury = SUBSTRING(_Q._4GLQury, 5, -1, "CHARACTER":U).
            _Q._4glQury = REPLACE(_Q._4GLQury, "INDEXED-REPOSITION":U, "":U).
          END.
          WHEN "BGCOLOR":U                   THEN _L._BGCOLOR           = hField:BUFFER-VALUE.
          WHEN "BrowseColumnBGColors":U      THEN cBrwsColBGColors      = hField:BUFFER-VALUE.
          WHEN "BrowseColumnFGColors":U      THEN cBrwsColFGColors      = hField:BUFFER-VALUE.
          WHEN "BrowseColumnFonts":U         THEN cBrwsColFonts         = hField:BUFFER-VALUE.
          WHEN "BrowseColumnFormats":U       THEN cBrwsColFormats       = hField:BUFFER-VALUE.
          WHEN "BrowseColumnLabelBGColors":U THEN cBrwsColLabelBGColors = hField:BUFFER-VALUE.
          WHEN "BrowseColumnLabelFGColors":U THEN cBrwsColLabelFGColors = hField:BUFFER-VALUE.
          WHEN "BrowseColumnLabelFonts":U    THEN cBrwsColLabelFonts    = hField:BUFFER-VALUE.
          WHEN "BrowseColumnLabels":U        THEN cBrwsColLabels        = hField:BUFFER-VALUE.
          WHEN "BrowseColumnWidths":U        THEN cBrwsColWidths        = hField:BUFFER-VALUE.
          WHEN "BOX":U                       THEN IF cDynClass = "DynView":U
                                                   THEN x_L._NO-BOX = NOT hField:BUFFER-VALUE.
                                                   ELSE _L._NO-BOX  = NOT hField:BUFFER-VALUE.
          WHEN "BOX-SELECTABLE":U            THEN _C._BOX-SELECTABLE    = hField:BUFFER-VALUE.
          WHEN "COLUMN-MOVABLE":U            THEN _C._COLUMN-MOVABLE    = hField:BUFFER-VALUE.
          WHEN "COLUMN-RESIZABLE":U          THEN _C._COLUMN-RESIZABLE  = hField:BUFFER-VALUE.
          WHEN "COLUMN-SCROLLING":U          THEN _C._COLUMN-SCROLLING  = hField:BUFFER-VALUE.
          WHEN "CONTEXT-HELP-ID":U           THEN _U._CONTEXT-HELP-ID   = hField:BUFFER-VALUE.
          WHEN "DataColumns":U               THEN cDataColumns          = hField:BUFFER-VALUE.
          WHEN "DataColumnsByTable":U        THEN cDataColumnsByTable   = hField:BUFFER-VALUE.
          WHEN "DataLogicProcedure":U        THEN DO: /* Set both the procedure AND its
                                                         ProductModule */
              ASSIGN _C._DATA-LOGIC-PROC   = hField:BUFFER-VALUE
                     cTemp                 = REPLACE(_C._DATA-LOGIC-PROC,"~\":U,"~/":U).
              IF cTemp NE "":U THEN DO:
                cTemp = ENTRY(1, ENTRY(NUM-ENTRIES(cTemp,"~/"), cTemp, "~/"), ".":U).

                FIND FIRST x_smartObject NO-LOCK
                     WHERE x_smartobject.OBJECT_filename = cTemp NO-ERROR.
                IF AVAILABLE x_smartobject THEN DO:
                  FIND FIRST gsc_product_module NO-LOCK
                       WHERE gsc_product_module.product_module_obj = x_smartobject.product_module_obj NO-ERROR.
                  IF AVAILABLE gsc_product_module THEN 
                    _C._DATA-LOGIC-PROC-PMOD = gsc_product_module.product_module_code.
                END. /* if x_smartobject is available */
              END. /* If there is a registered data logic procedure */
          END.  /* When DataLogicProcedure */
          WHEN "DisplayedFields":U           THEN cBrowseFields         = hField:BUFFER-VALUE.
          WHEN "DOWN":U                      THEN _C._DOWN              = hField:BUFFER-VALUE.
          WHEN "DROP-TARGET":U               THEN _U._DROP-TARGET       = hField:BUFFER-VALUE.
          WHEN "EnabledFields":U             THEN cEnabledFields        = hField:BUFFER-VALUE.
          WHEN "FGCOLOR":U                   THEN _L._FGCOLOR           = hField:BUFFER-VALUE.
          WHEN "FIT-LAST-COLUMN":U           THEN _C._FIT-LAST-COLUMN   = hField:BUFFER-VALUE.
          WHEN "FolderWindowToLaunch":U      THEN _C._FOLDER-WINDOW-TO-LAUNCH = hField:BUFFER-VALUE.
          WHEN "FONT":U                      THEN _L._FONT              = hField:BUFFER-VALUE.
          WHEN "HELP":U                      THEN _U._HELP              = hField:BUFFER-VALUE.
          WHEN "HIDDEN":U                    THEN _U._HIDDEN            = hField:BUFFER-VALUE.
          WHEN "LogicalObjectName":U         THEN _P._save-as-file      = hField:BUFFER-VALUE.
          WHEN "MANUAL-HIGHLIGHT":U          THEN _U._MANUAL-HIGHLIGHT  = hField:BUFFER-VALUE.
          WHEN "MAX-DATA-GUESS":U            THEN _C._MAX-DATA-GUESS    = hField:BUFFER-VALUE.
          WHEN "MinHeight":U                 THEN _L._HEIGHT            = hField:BUFFER-VALUE.
          WHEN "MinWidth":U                  THEN _L._WIDTH             = hField:BUFFER-VALUE.
          WHEN "MOVABLE":U                   THEN _U._MOVABLE           = hField:BUFFER-VALUE.
          WHEN "MULTIPLE":U                  THEN _C._MULTIPLE          = hField:BUFFER-VALUE.
          WHEN "NO-EMPTY-SPACE":U            THEN _C._NO-EMPTY-SPACE    = hField:BUFFER-VALUE.
          WHEN "NUM-LOCKED-COLUMNS":U        THEN _C._NUM-LOCKED-COLUMNS = hField:BUFFER-VALUE.
          WHEN "ObjectType":U                THEN _P.object_type_code   = hField:BUFFER-VALUE.
          WHEN "OVERLAY":U                   THEN _C._OVERLAY           = hField:BUFFER-VALUE.
          WHEN "PAGE-BOTTOM":U               THEN _C._PAGE-BOTTOM       = hField:BUFFER-VALUE.
          WHEN "PAGE-TOP":U                  THEN _C._PAGE-TOP          = hField:BUFFER-VALUE.
          WHEN "PRIVATE-DATA":U              THEN _U._PRIVATE-DATA      = hField:BUFFER-VALUE.
          WHEN "QueryBuilderFieldDataTypes":U THEN cQBFieldDataTypes    = hField:BUFFER-VALUE.
          WHEN "QueryBuilderDBNames":U       THEN cQBDBNames            = hField:BUFFER-VALUE.
          WHEN "QueryBuilderFieldWidths":U   THEN cQBFieldWidths        = hField:BUFFER-VALUE.
          WHEN "QueryBuilderInheritValidations":U THEN cQBInhVals       = hField:BUFFER-VALUE.
          WHEN "QueryBuilderJoinCode":U      THEN cQBJoinCode           = hField:BUFFER-VALUE.
          WHEN "QueryBuilderOptionList":U    THEN _Q._OptionList        = hField:BUFFER-VALUE.
          WHEN "QueryBuilderOrderList":U     THEN _Q._OrdList           = hField:BUFFER-VALUE.
          WHEN "QueryBuilderTableList":U     THEN _Q._TblList           = hField:BUFFER-VALUE.
          WHEN "QueryBuilderTableOptionList":U THEN _Q._TblOptList      = hField:BUFFER-VALUE.
          WHEN "QueryBuilderTuneOptions":U   THEN _Q._TuneOptions       = hField:BUFFER-VALUE.
          WHEN "QueryBuilderWhereClauses":U  THEN cQBWhereClauses       = hField:BUFFER-VALUE.
          WHEN "RESIZABLE":U                 THEN _U._RESIZABLE         = hField:BUFFER-VALUE.
          WHEN "ROW-HEIGHT-CHARS":U          THEN _C._ROW-HEIGHT        = hField:BUFFER-VALUE.
          WHEN "ROW-MARKERS":U               THEN _C._NO-ROW-MARKERS    = NOT hField:BUFFER-VALUE.
          WHEN "SCROLLABLE":U                THEN _C._SCROLLABLE        = hField:BUFFER-VALUE.
          WHEN "SCROLLBAR-VERTICAL":U        THEN _U._SCROLLBAR-V       = hField:BUFFER-VALUE.
          WHEN "SELECTABLE":U                THEN _U._SELECTABLE        = hField:BUFFER-VALUE.
          WHEN "SENSITIVE":U                 THEN _U._SENSITIVE         = hField:BUFFER-VALUE.
          WHEN "SEPARATOR-FGCOLOR":U         THEN _L._SEPARATOR-FGCOLOR = hField:BUFFER-VALUE.
          WHEN "SEPARATORS":U                THEN _L._SEPARATORS        = hField:BUFFER-VALUE.
          WHEN "ShowPopup":U                 THEN _U._SHOW-POPUP        = hField:BUFFER-VALUE.
          WHEN "SIDE-LABELS":U               THEN _C._SIDE-LABELS       = hField:BUFFER-VALUE.
          WHEN "SizeToFit":U                 THEN _C._SIZE-TO-FIT       = hField:BUFFER-VALUE.
          WHEN "TAB-STOP":U                  THEN _U._NO-TAB-STOP       = NOT hField:BUFFER-VALUE.
          WHEN "Tables":U                    THEN cTables               = hField:BUFFER-VALUE.
          WHEN "THREE-D":U                   THEN IF cDynClass = "DynView":U
                                                    THEN x_L._3-D = hField:BUFFER-VALUE.
                                                    ELSE _L._3-D  = hField:BUFFER-VALUE.
          WHEN "TOOLTIP":U                   THEN _U._TOOLTIP           = hField:BUFFER-VALUE.
          WHEN "tWhereStored":U              THEN _U._WHERE-STORED      = hField:BUFFER-VALUE.
          WHEN "UpdatableColumns":U          THEN cUpdatableColumns     = hField:BUFFER-VALUE.
          WHEN "UpdatableColumnsByTable":U   THEN cUpdatableColumnsByTable = hField:BUFFER-VALUE.
          WHEN "WindowTitleField":U          THEN _C._WINDOW-TITLE-FIELD = hField:BUFFER-VALUE.

          /* These attributes are not manipulated in the AppBuilder or not useful to
             the dynamics framework, ignore them */
          WHEN "tRecordIdentifier":U OR
          WHEN "DataSourceNames":U OR
          WHEN "DataSource":U OR
          WHEN "DhtmlClass":U OR
          WHEN "DhtmlFilterType":U OR
          WHEN "DisableOnInit":U OR
          WHEN "DynamicObject":U OR
          WHEN "FrameMinHeightChars":U OR
          WHEN "FrameMinWidthChars":U OR
          WHEN "HideOnInit":U OR
          WHEN "LayoutType":U OR
          WHEN "LayoutUnits":U OR
          WHEN "LogicalVersion":U OR
          WHEN "ObjectLayout":U OR
          WHEN "ResizeHorizontal":U OR
          WHEN "ResizeVertical":U OR
          WHEN "SELECTED":U OR
          WHEN "SizeUnits":U OR
          WHEN "TemplateObjectName":U OR
          WHEN "TITLE":U OR              /* See TITLE above */
          WHEN "UpdateTargetNames":U OR
          WHEN "VISIBLE":U OR
          WHEN "tWhereConstant":U
          THEN DO:
                /* No Action - Not needed */
          END.

          /* OTHERWISE
              MESSAGE "Attribute" cAttr "is not currently supported. ("
                      hField:BUFFER-VALUE ")"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.                 */               
          END CASE. /* Case for Master Layout only stuff */
        END. /* If Master Layout */
        ELSE DO:
          /* The case for all other layouts */
          CASE cAttr:

            WHEN "BGCOLOR":U                   THEN _L._BGCOLOR           = hField:BUFFER-VALUE.
            WHEN "BOX":U                       THEN IF cDynClass = "DynView":U
                                                    THEN x_L._NO-BOX = NOT hField:BUFFER-VALUE.
                                                    ELSE _L._NO-BOX  = NOT hField:BUFFER-VALUE.
            WHEN "FGCOLOR":U                   THEN _L._FGCOLOR           = hField:BUFFER-VALUE.
            WHEN "FONT":U                      THEN _L._FONT              = hField:BUFFER-VALUE.
            WHEN "MinHeight":U                 THEN IF hField:BUFFER-VALUE NE 0 AND 
                                                       hField:BUFFER-VALUE NE ? THEN 
                                                      _L._HEIGHT            = hField:BUFFER-VALUE.
            WHEN "MinWidth":U                  THEN IF hField:BUFFER-VALUE NE 0  AND 
                                                       hField:BUFFER-VALUE NE ? THEN 
                                                      _L._WIDTH             = hField:BUFFER-VALUE.
            WHEN "SEPARATOR-FGCOLOR":U         THEN _L._SEPARATOR-FGCOLOR = hField:BUFFER-VALUE.
            WHEN "SEPARATORS":U                THEN _L._SEPARATORS        = hField:BUFFER-VALUE.
            WHEN "THREE-D":U                   THEN IF cDynClass = "DynView":U
                                                     THEN x_L._3-D = hField:BUFFER-VALUE.
                                                     ELSE _L._3-D  = hField:BUFFER-VALUE.
          END CASE. /* Case for all layouts */
        END.  /* Else do the case for other layouts */
      END.  /* Loop through attributes */

      /* Special for Browse columns */
      IF _U._TYPE = "BROWSE":U AND cCode = "":U THEN DO:
        DO numCol = 1 TO NUM-ENTRIES(cBrowseFields):

          IF VALID-HANDLE(hSDO) AND 
             DYNAMIC-FUNCTION("ColumnHandle":U IN hSDO, ENTRY(numCol,cBrowseFields)) = ? THEN
             NEXT.
          CREATE _BC.
          ASSIGN _BC._x-recid   = RECID(_U)
                 _BC._NAME      = ENTRY(numCol,cBrowseFields)
                 _BC._BGCOLOR   = IF cBrwsColBGColors = "" THEN ?
                                  ELSE INTEGER(ENTRY(numCol, cBrwsColBGColors, CHR(5))).
          IF VALID-HANDLE(hSDO) THEN
            ASSIGN _BC._DATA-TYPE  = DYNAMIC-FUNCTION("ColumnDataType":U IN hSDO, _BC._NAME)
                   _BC._DBNAME     = "_<SDO>":U
                   _BC._DEF-FORMAT = DYNAMIC-FUNCTION("ColumnFormat":U IN hSDO, _BC._NAME)
                   _BC._DEF-HELP   = DYNAMIC-FUNCTION("ColumnHelp":U IN hSDO, _BC._NAME)
                   _BC._DEF-LABEL  = DYNAMIC-FUNCTION("ColumnColumnLabel":U IN hSDO, _BC._NAME)
                   _BC._DEF-WIDTH  = MIN(120,MAX(DYNAMIC-FUNCTION("columnWidth" IN hSDO,_BC._NAME),
                                         FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))).

          ASSIGN _BC._DISP-NAME  = _BC._NAME
                 _BC._ENABLED    = LOOKUP(_BC._DISP-NAME, cEnabledFields) > 0
                 _BC._FGCOLOR    = IF cBrwsColFGColors = "" THEN ?
                                   ELSE INTEGER(ENTRY(numCol, cBrwsColFGColors, CHR(5)))
                 _BC._FONT       = IF cBrwsColFonts = "" THEN ?
                                   ELSE INTEGER(ENTRY(numCol, cBrwsColFonts, CHR(5)))
                 _BC._FORMAT     = IF cBrwsColFormats = "" THEN _BC._DEF-FORMAT 
                                   ELSE IF ENTRY(numCol, cBrwsColFormats, CHR(5)) = "?" THEN _BC._DEF-FORMAT
                                   ELSE ENTRY(numCol, cBrwsColFormats, CHR(5))
                 _BC._HELP       = _BC._DEF-HELP
                 _BC._LABEL      = IF cBrwsColLabels = "" THEN _BC._DEF-LABEL
                                   ELSE IF ENTRY(numCol, cBrwsColLabels, CHR(5)) = "?" THEN _BC._DEF-LABEL
                                   ELSE ENTRY(numCol, cBrwsColLabels, CHR(5))
                 _BC._LABEL-BGCOLOR = IF cBrwsColLabelBGColors = "" THEN ?
                                      ELSE INTEGER(ENTRY(numCol, cBrwsColLabelBGColors, CHR(5)))
                 _BC._LABEL-FGCOLOR = IF cBrwsColLabelFGColors = "" THEN ?
                                      ELSE INTEGER(ENTRY(numCol, cBrwsColLabelFGColors, CHR(5)))
                 _BC._LABEL-FONT = IF cBrwsColLabelFonts = "" THEN ?
                                   ELSE INTEGER(ENTRY(numCol, cBrwsColLabelFonts, CHR(5)))
                 _BC._SEQUENCE   = numCol
                 _BC._TABLE      = "RowObject":U
                 _BC._WIDTH      = IF cBrwsColWidths = "" THEN _BC._DEF-WIDTH
                                   ELSE IF ENTRY(numCol, cBrwsColWidths, CHR(5)) EQ "?" THEN _BC._DEF-WIDTH
                                   ELSE INTEGER(ENTRY(numCol, cBrwsColWidths, CHR(5))). 
        END.  /* Do for each Browse Field */
        /*
        MESSAGE cBrowseFields SKIP
                cEnabledFields  SKIP
                cBrwsColBGColors  SKIP
                cBrwsColFGColors   SKIP
                cBrwsColFonts       SKIP
                cBrwsColFormats       SKIP
                cBrwsColLabelBGColors SKIP
                cBrwsColLabelFGColors SKIP
                cBrwsColLabelFonts    SKIP
                cBrwsColLabels        SKIP
                cBrwsColWidths        SKIP
            VIEW-AS ALERT-BOX INFO BUTTONS OK.  */
        RUN adeuib/_undbrow.p (RECID(_U)).
        CREATE _Q.
        ASSIGN _C._q-RECID = RECID(_Q)
               _Q._4GLQury =  "EACH rowObject":U
               _Q._TblList = "rowObject":U.
      END. /* If a Dynamic Browse and master layout */

      /* Else if an DynSDO query */
      ELSE IF _U._TYPE = "QUERY":U AND lMasterLO THEN DO:
        /* We have read _C._DATA-LOGIC-PROC into the _C for Query.
           It needs to be in the _C for the Window. */
        FIND p_U WHERE RECID(p_U) = ParentRecid.
        FIND p_C WHERE RECID(p_C) = p_U._x-recid.
        ASSIGN p_C._DATA-LOGIC-PROC      = _C._DATA-LOGIC-PROC
               p_C._DATA-LOGIC-PROC-PMOD = _C._DATA-LOGIC-PROC-PMOD.

        DO i = 1 TO NUM-ENTRIES(_Q._TblList):
          IF NUM-ENTRIES(cQBJoinCode, CHR(5)) > 0 THEN
            _Q._JoinCode[i] = IF ENTRY(i,cQBJoinCode,CHR(5)) = "?":U THEN ? ELSE ENTRY(i,cQBJoinCode,CHR(5)).

          IF NUM-ENTRIES(cQBWhereClauses,CHR(5)) > 0 THEN
            _Q._Where[i] = IF ENTRY(i,cQBWhereClauses,CHR(5)) = "?":U THEN ? ELSE ENTRY(i,cQBWhereClauses,CHR(5)).
        END.  /* do to tbllist num-entries */

        /* We need to rebuild the _BC records.  This is made somewhat difficult because
           the attribute lists we have read in have had their tables stripped off.  These
           can be rediscovered by looking at the DataColumnsByTable and the Tables 
           attributes together.  The DataColumnsByTable attribute is a list of columns 
           separated by commas, but with breaks denoted by colons.  If there are 3 tables,
           then there are 3 colon delimited breaks corresponding to the tables. */
        ASSIGN numCol = 0.

        /* Create list of fields that have instance records */
        CREATE QUERY hObjectQuery. 
        hObjectQuery:ADD-BUFFER(hObjectBuffer).

        /* Now get the contents of the SDO */
        hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                              + hObjectBuffer:NAME + ".tContainerRecordIdentifier = '" + STRING(dRecordIdentifier) + "' AND ":U
                              + hObjectBuffer:NAME + ".tLogicalObjectName <> '" + _ryObject.object_filename + "' AND ":U
                              + hObjectBuffer:NAME + ".tResultCode = '{&DEFAULT-RESULT-CODE}' AND ":U
                              + hObjectBuffer:NAME + ".tUserObj = " + QUOTER(dCurrentUserObj) + " AND "
                              + hObjectBuffer:NAME + ".tRunAttribute = '' AND ":U  
                              + hObjectBuffer:NAME + ".tLanguageObj = " + QUOTER(dCurrentLanguageObj)  ) .

        hObjectQuery:QUERY-OPEN().
        hObjectQuery:GET-FIRST().

        DO WHILE hObjectBuffer:AVAILABLE:
          ASSIGN hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                 cLogicalObjName   = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
                 cInstanceColumns  = cInstanceColumns + ",":U + cLogicalObjName.
          hObjectQuery:GET-NEXT().
        END.

        /* Create _BC records table by table */
        cTmpFldList = cDataColumns.
        DO iTable = 1 TO NUM-ENTRIES(cTables):
          ASSIGN cTableName = ENTRY(iTable, cTables).
          /* Trick to capture the field info from the DB */
          CREATE BUFFER hTableBuffer FOR TABLE cTableName NO-ERROR.
          ASSIGN cColumnsInThisTable = ENTRY(iTable, cDataColumnsByTable, ";":U)
                 cAssignsInThisTable = IF cAssignList EQ "":U THEN "":U
                                         ELSE ENTRY(iTable, cAssignList, ";":U)
                 cEnabledInThisTable = IF NUM-ENTRIES(cUpdatableColumnsByTable, ";":U) GE iTable 
                                         THEN ENTRY(iTable, cUpdatableColumnsByTable, ";":U)
                                         ELSE "":U.
          IF cColumnsInThisTable NE "":U THEN DO:
            DO iColumn = 1 TO NUM-ENTRIES(cColumnsInThisTable):
              ASSIGN cColumnName = ENTRY(icolumn, cColumnsInThisTable)
                     cDispName   = cColumnName.
              IF LOOKUP(cColumnName, cAssignsInThisTable) > 0 THEN
                cColumnName = ENTRY(LOOKUP(cColumnName, cAssignsInTHisTable) + 1 , cAssignsInThisTable).

              /* Need to remove extent before getting the handle of the buffer field */
              cColumnName = SUBSTRING(cColumnName,1,INDEX(cColumnName,'[':U) - 1).
              IF VALID-HANDLE(hTableBuffer) THEN
                /* Get handle to the field to get default info */
                hField = hTableBuffer:BUFFER-FIELD(cColumnName).

              /* Determine the correct sequence number */
              numCol = LOOKUP(cDispName, cTmpFldList).
              /* Remove name from the temporary list of fields, but keep a place holder */
              ENTRY(numCol,cTmpFldList) = "_".

              ASSIGN lFoundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager, 
                                                 INPUT cTableName + ".":U + cColumnName,  
                                                 INPUT ?,
                                                 INPUT ?,               
                                                 INPUT NO).                      
              IF lFoundIt THEN
              DO:
                hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
                hObjectBuffer:FIND-FIRST("WHERE ":U + hObjectBuffer:NAME + ".tLogicalObjectName = '":U +
                                          cTableName + ".":U + cColumnName + "'":U) NO-ERROR.       
                IF hObjectBuffer:AVAILABLE THEN
                DO:
                  hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE NO-ERROR.
                  hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + 
                                              QUOTER(hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)) NO-ERROR.
                  IF VALID-HANDLE(hAttributeBuffer) AND hAttributeBuffer:AVAILABLE THEN
                  DO:
                    ASSIGN 
                      cDataFieldFormat   = hAttributeBuffer:BUFFER-FIELD("Format":U):BUFFER-VALUE
                      cDataFieldHelp     = hAttributeBuffer:BUFFER-FIELD("Help":U):BUFFER-VALUE
                      cDataFieldLabel    = hAttributeBuffer:BUFFER-FIELD("Label":U):BUFFER-VALUE NO-ERROR.
                  END.  /* if valid hAttributeBuffer */
                  ELSE lFoundIt = NO.
                END.  /* if hObjectBuffer available */
                ELSE lFoundIt = NO.
              END.  /* if found it */
              ELSE lFoundIt = NO.
              
              CREATE _BC.
              ASSIGN _BC._x-recid    = RECID(_U)
                     _BC._SEQUENCE   = numCol
                     _BC._DBNAME     = IF cQBDBNames = "":U OR 
                                          ENTRY(numCol, cQBDBNames) = "?":U THEN hField:DBNAME 
                                          ELSE ENTRY(numCol, cQBDBNames)
                     _BC._TABLE      = cTableName
                     _BC._DATA-TYPE  = IF cQBFieldDataTypes = "":U OR
                                          ENTRY(numCol, cQBFieldDataTypes) = "?":U THEN hField:DATA-TYPE
                                          ELSE ENTRY(numCol, cQBFieldDataTypes)
                     _BC._DISP-NAME  = IF cDataColumns = "":U OR
                                         ENTRY(numCol, cDataColumns) = "?":U THEN hField:NAME 
                                         ELSE ENTRY(numCol, cDataColumns)                   
                     _BC._NAME       = IF LOOKUP(_BC._DISP-NAME,cAssignsInThisTable) > 0
                                       THEN ENTRY(LOOKUP(_BC._DISP-NAME,cAssignsInThisTable) + 1,
                                                  cAssignsInThisTable)
                                       ELSE _BC._DISP-NAME
                     _BC._DEF-FORMAT = hField:FORMAT
                     _BC._FORMAT     = IF lFoundIt THEN cDataFieldFormat ELSE hField:FORMAT
                     _BC._DEF-HELP   = hField:HELP
                     _BC._DEF-LABEL  = hField:LABEL
                     _BC._DEF-WIDTH  = 10      /* Haven't saved this */
                     _BC._ENABLED    = LOOKUP(_BC._DISP-NAME, cEnabledInThisTable) > 0
                     _BC._HELP       = IF lFoundIt THEN cDataFieldHelp ELSE hField:HELP
                     _BC._LABEL      = IF lFoundIt THEN cDataFieldLabel ELSE hField:LABEL
                     _BC._WIDTH      = IF cQBFieldWidths = "":U or
                                         ENTRY(numCol,cQBFieldWidths) = "?":U THEN hField:WIDTH-CHARS
                                         ELSE DECIMAL(ENTRY(numCol,cQBFieldWidths))
                     _BC._INHERIT-VALIDATION = IF cQBInhVals = "":U OR
                                                ENTRY(numCol, cQBInhVals) = "NO":U THEN NO
                                                ELSE YES
                     _BC._INSTANCE-LEVEL = LOOKUP(cTableName + ".":U + _BC._NAME, cInstanceColumns) > 0
                     _BC._HAS-DATAFIELD-MASTER = lFoundIt
                  .
                
            END.  /* FOr each column in the table */
          END. /* If there are columns for this table */
        END. /* DO for each table */
     
        /* Calculated fields are stored in DataColumnsByTable last separated by ;
           like an additional table.  If there are more entries in 
           DataColumnsByTable than number of tables, these are calculated fields. */
        IF NUM-ENTRIES(cDataColumnsByTable,";":U) GT NUM-ENTRIES(cTables) THEN
        DO:
          ASSIGN 
            cCalcFields         = ENTRY(NUM-ENTRIES(cDataColumnsByTable,";":U), cDataColumnsByTable, ";":U)
            cEnabledInThisTable = IF NUM-ENTRIES(cUpdatableColumnsByTable, ";":U) = NUM-ENTRIES(cDataColumnsByTable, ";":U)
                                  THEN ENTRY(NUM-ENTRIES(cDataColumnsByTable,";":U), cUpdatableColumnsByTable, ";":U)
                                  ELSE "":U
                                  .
          DO iNumCalc = 1 TO NUM-ENTRIES(cCalcFields):
            numCol = LOOKUP(ENTRY(iNumCalc,cCalcFields), cTmpFldList).
            ENTRY(numCol,cTmpFldList) = "_".
            
            ASSIGN lFoundIt = DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager, 
                                               INPUT ENTRY(iNumCalc,cCalcFields),  
                                               INPUT ?,
                                               INPUT ?,               
                                               INPUT NO).                      
            IF lFoundIt THEN
            DO:
              hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
              hObjectBuffer:FIND-FIRST("WHERE ":U + hObjectBuffer:NAME + ".tLogicalObjectName = '":U +
                                        ENTRY(iNumCalc,cCalcFields) + "'":U) NO-ERROR.       
              IF hObjectBuffer:AVAILABLE THEN
              DO:
                hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE NO-ERROR.
                hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + 
                                            QUOTER(hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE)) NO-ERROR.
                IF VALID-HANDLE(hAttributeBuffer) AND hAttributeBuffer:AVAILABLE THEN
                  ASSIGN 
                    cDataFieldFormat   = hAttributeBuffer:BUFFER-FIELD("Format":U):BUFFER-VALUE
                    cDataFieldHelp     = hAttributeBuffer:BUFFER-FIELD("Help":U):BUFFER-VALUE
                    cDataFieldLabel    = hAttributeBuffer:BUFFER-FIELD("Label":U):BUFFER-VALUE.
                ELSE 
                  ASSIGN 
                    cDataFieldFormat = "x(8)":U
                    cDataFieldHelp   = "":U
                    cDataFieldLabel  = "":U
                    lFoundIt = NO.
              END.  /* if hObjectBuffer available */
              ELSE lFoundIt = NO.
            END.  /* if found it */
            ELSE lFoundIt = NO.

            CREATE _BC.
            ASSIGN _BC._x-recid        = RECID(_U)
                   _BC._SEQUENCE       = numCol
                   _BC._DISP-NAME      = ENTRY(iNumCalc,cCalcFields)
                   _BC._DBNAME         = "_<CALC>":U
                   _BC._TABLE          = ?
                   _BC._LABEL          = cDataFieldLabel
                   _BC._FORMAT         = cDataFieldFormat
                   _BC._DATA-TYPE      = IF NUM-ENTRIES(cQBFieldDataTypes) >= numCol 
                                         THEN ENTRY(numCol, cQBFieldDataTypes) ELSE ?
                   _BC._HELP           = cDataFieldHelp
                   _BC._WIDTH          = IF NUM-ENTRIES(cQBFieldWidths) >= numCol
                                         THEN DECIMAL(ENTRY(numCol, cQBFieldWidths)) ELSE 0
                   _BC._STATUS         = "UPDATE,":U + ENTRY(iNumCalc,cCalcFields)
                   _BC._ENABLED        = LOOKUP(_BC._DISP-NAME, cEnabledInThisTable) > 0
                   _BC._INSTANCE-LEVEL = LOOKUP(_BC._DISP-NAME, cInstanceColumns) > 0
                   _BC._HAS-DATAFIELD-MASTER = lFoundIt
                   .
          END.  /* do to number calc fields */
        END.  /* if have calc fields */
  
        RUN adeuib/_undqry.p (INPUT RECID(_U)).
  
      END.  /* If a query for a dynamic SDO and Master Layout */

      /* Else if a viewer - get field info */
      ELSE IF _U._TYPE = "FRAME":U THEN DO:
        /* If this is not the master, create _Ls for all contained widgets, because the repository only
           gives us the differences and the AppBuilder requires all of the info.  We will change the
           copied info when we get the changes.                                                       */
        IF NOT lMasterLO THEN DO:
          FOR EACH f_U WHERE f_U._PARENT-RECID = RECID(_U):
            FIND m_L WHERE RECID(m_L) = f_U._lo-recid NO-ERROR.  /* Should be the master LO */
            IF AVAILABLE m_l THEN DO:
              /* Create _L for this layout */
              CREATE f_L.
              ASSIGN f_L._LO-NAME = cCode
                     f_L._u-recid = RECID(f_U).
              BUFFER-COPY m_l EXCEPT _LO-NAME _u-recid TO f_L.
            END.  /* If we find the master _L */
          END.  /* for each child of the frame */
        END.  /* If not Master Layout */

        /* Force the Tabbing to be Custom */
        _C._tabbing = "CUSTOM":U.

        CREATE QUERY hObjectQuery. 
        hObjectQuery:ADD-BUFFER(hObjectBuffer).

        /* Now get the contents of the viewer */
        hObjectQuery:QUERY-PREPARE(" FOR EACH ":U + hObjectBuffer:NAME + " WHERE ":U
                                + hObjectBuffer:NAME + ".tContainerRecordIdentifier = '" + STRING(dRecordIdentifier) + "' AND ":U
                                + hObjectBuffer:NAME + ".tLogicalObjectName <> '" + _ryObject.object_filename + "' AND ":U
                                + hObjectBuffer:NAME + ".tResultCode = '{&DEFAULT-RESULT-CODE}' AND ":U
                                + hObjectBuffer:NAME + ".tUserObj = " + QUOTER(dCurrentUserObj) + " AND "
                                + hObjectBuffer:NAME + ".tRunAttribute = '' AND ":U  
                                + hObjectBuffer:NAME + ".tLanguageObj = " + QUOTER(dCurrentLanguageObj)  ) .

        hObjectQuery:QUERY-OPEN().
        hObjectQuery:GET-FIRST().

        DO WHILE hObjectBuffer:AVAILABLE:
          ASSIGN hAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
                 dRecordIdentifier = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
                 cLogicalObjName   = hObjectBuffer:BUFFER-FIELD("tLogicalObjectName":U):BUFFER-VALUE
                 cWidgetName       = hObjectBuffer:BUFFER-FIELD("tObjectInstanceName":U):BUFFER-VALUE.
 
          IF NUM-ENTRIES(cWidgetName,".":U) > 1 THEN
            ASSIGN cName = ENTRY(2, cWidgetName, ".":U).
          ELSE IF NUM-ENTRIES(cWidgetName," ":U) > 1 THEN
            ASSIGN cName = ENTRY(2, cWidgetName, " ":U).
          ELSE
            ASSIGN cName = cWidgetName.

          hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = '" 
                                         + STRING(dRecordIdentifier) + "' ":U) NO-ERROR.

          IF lMasterLO THEN DO:  /* If the Master Layout */
            CREATE f_U.
            CREATE f_F.
            CREATE f_L.
          END.  /* If the Master Layout */
          ELSE DO:  /* All other Layouts */
            FIND f_U WHERE f_U._NAME = cWidgetName AND
                           f_U._WINDOW-HANDLE = _h_win NO-ERROR.
            IF NOT AVAILABLE f_U AND NUM-ENTRIES(cWidgetName, ".":U) > 1 THEN
              FIND f_U WHERE f_U._NAME = ENTRY(2, cWidgetName, ".":U) AND
                             f_U._WINDOW-HANDLE = _h_win.
            FIND f_F WHERE RECID(f_F) = f_U._x-recid.
            FIND f_L WHERE f_L._LO-NAME = cCode AND f_L._u-recid = RECID(f_U).
          END.
 
          IF lMasterLO THEN DO:  /* If master layout */
            /* Initialize the following fields  */
            ASSIGN f_U._ALIGN         = "C":U
                   f_U._HELP-SOURCE   = "E":U
                   f_U._LABEL-SOURCE  = "E":U
                   f_U._lo-recid      = RECID(f_L)
                   f_U._PARENT        = _h_frame:FIRST-CHILD
                   f_U._PARENT-RECID  = RECID(_U)
                   f_U._OBJECT-OBJ    = hObjectBuffer:BUFFER-FIELD("tObjectInstanceObj":U):BUFFER-VALUE
                   f_U._CLASS-NAME    = hObjectBuffer:BUFFER-FIELD("tClassName":U):BUFFER-VALUE
                   f_U._OBJECT-NAME   = cLogicalObjName
                   f_U._NAME          = cName
                   f_U._SENSITIVE     = YES
                   f_U._SUBTYPE       = ""
                   f_U._x-recid       = RECID(f_F)
                   f_U._WINDOW-HANDLE = _h_win
                   f_U._LAYOUT-NAME   = "Master Layout":U.
 
            IF lSBODataSource AND NUM-ENTRIES(cWidgetName, ".":U) = 2 THEN
              cSDOName = ENTRY(1, cWidgetName, ".":U).

            /* Make sure we know the type before reading other attributes */
            ASSIGN hField    = hAttributeBuffer:BUFFER-FIELD("tInheritsFromClasses":U) 
                   f_U._TYPE  = hAttributeBuffer:BUFFER-FIELD("VisualizationType":U):BUFFER-VALUE
                   NO-ERROR.
            IF VALID-HANDLE(hField) THEN DO:
              IF LOOKUP("Field":U, hField:BUFFER-VALUE) > 0 THEN
                ASSIGN f_U._TYPE = "SmartDataField":U.
            END.
            IF f_U._TYPE = "TOGGLE-BOX" THEN f_F._DATA-TYPE = "LOGICAL":U.

            ASSIGN f_L._ROW-MULT      = 1
                   f_L._COL-MULT      = 1
                   f_L._u-recid       = RECID(f_U)
                   f_L._WIN-TYPE      = YES
                   f_L._LO-NAME       = "Master Layout":U.
          END.  /* If master layout */


          /* Calculate the maximum width and height of the widgets */
          ASSIGN dWidgetRow    = hAttributeBuffer:BUFFER-FIELD("Row":U):BUFFER-VALUE
                 dWidgetCol    = hAttributeBuffer:BUFFER-FIELD("Column":U):BUFFER-VALUE
                 dWidgetHeight = hAttributeBuffer:BUFFER-FIELD("HEIGHT-CHARS":U):BUFFER-VALUE
                 dWidgetWidth  = hAttributeBuffer:BUFFER-FIELD("WIDTH-CHARS":U):BUFFER-VALUE
              NO-ERROR.

          /* Safety measure until bug gets fixed */
          IF dWidgetHeight = 0 OR dWidgetHeight = ? THEN dWidgetHeight = 1.
          IF dWidgetWidth  = 0 OR dWidgetWidth = ?  THEN dWidgetWidth  = 2.

          IF NOT ERROR-STATUS:ERROR  THEN
             ASSIGN dFrameMaxWidth  = MAX(dFrameMaxWidth, dWidgetCol + dWidgetWidth)
                    dFrameMaxHeight = MAX(dFrameMaxHeight, dWidgetRow + dWidgetHeight).

          /* Big loop to populate all f_U, f_F and f_L fields */
          Attr-LOOP:
          DO ifield = 1 TO hAttributeBuffer:NUM-FIELDS:
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD(ifield)
                   cAttr  = hField:NAME
                   iWhereStored = INTEGER(ENTRY(iField, hAttributeBuffer:BUFFER-FIELD("tWhereStored":U):BUFFER-VALUE)).
            IF lMasterLO THEN DO:
              /* Case statement for Master Layout only */
              CASE cAttr:
             
                WHEN "AUTO-COMPLETION":U  THEN ASSIGN f_F._AUTO-COMPLETION = hField:BUFFER-VALUE.
                WHEN "AUTO-END-KEY":U     THEN ASSIGN f_F._AUTO-ENDKEY     = hField:BUFFER-VALUE.
                WHEN "AUTO-GO":U          THEN ASSIGN f_F._AUTO-GO         = hField:BUFFER-VALUE.
                WHEN "AUTO-INDENT":U      THEN ASSIGN f_F._AUTO-INDENT     = hField:BUFFER-VALUE.
                WHEN "AUTO-RESIZE":U      THEN ASSIGN f_F._AUTO-RESIZE     = hField:BUFFER-VALUE.
                WHEN "AUTO-RETURN":U      THEN ASSIGN f_F._AUTO-RETURN     = hField:BUFFER-VALUE.
                WHEN "BaseQueryString":U  THEN ASSIGN BaseQryStrng         = hField:BUFFER-VALUE.
                WHEN "BLANK":U            THEN ASSIGN f_F._BLANK           = hField:BUFFER-VALUE.
                WHEN "BuildSequence":U    THEN ASSIGN BldSeq               = hField:BUFFER-VALUE.
                WHEN "BGColor":U          THEN ASSIGN f_L._BGCOLOR         = hField:BUFFER-VALUE.
                WHEN "BOX":U              THEN ASSIGN f_L._NO-BOX          = NOT hField:BUFFER-VALUE.
                WHEN "CHECKED":U          THEN ASSIGN f_F._INITIAL-DATA    = IF hField:BUFFER-VALUE
                                                                             THEN "YES" ELSE "NO".
                WHEN "COLUMN":U           THEN ASSIGN f_L._COL             = hField:BUFFER-VALUE.
                WHEN "ComboDelimiter":U   THEN ASSIGN ComboDel             = hField:BUFFER-VALUE.
                WHEN "ComboFlag":U        THEN ASSIGN ComboFlg             = hField:BUFFER-VALUE.
                WHEN "CONTEXT-HELP-ID":U  THEN ASSIGN f_U._CONTEXT-HELP-ID = hField:BUFFER-VALUE.
                WHEN "CONVERT-3D-COLORS":U THEN ASSIGN f_L._CONVERT-3D-COLORS = hField:BUFFER-VALUE.
                WHEN "CurrentDescValue":U THEN ASSIGN CurDescVal           = hField:BUFFER-VALUE.
                WHEN "CurrentKeyValue":U  THEN ASSIGN CurKeyVal            = hField:BUFFER-VALUE.
                WHEN "DataBaseName":U     THEN DO:
                    ASSIGN f_U._DBNAME          = hField:BUFFER-VALUE.
                    IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                              INPUT "DataField":U)) <> 0 THEN
                      ASSIGN f_U._DBNAME = "Temp-Tables":U
                             f_U._TABLE = IF lSBODataSource THEN cSDOName ELSE "RowObject":U.
                END.
                WHEN "Data-Type":U        THEN DO:
                  IF hField:BUFFER-VALUE NE ? THEN
                     ASSIGN f_F._DATA-TYPE       = hField:BUFFER-VALUE.
                END.
                WHEN "DataSourceNames":U  THEN ASSIGN SDOFile              = hField:BUFFER-VALUE.
                WHEN "DEBLANK":U          THEN ASSIGN f_F._DEBLANK         = hField:BUFFER-VALUE.
                WHEN "DEFAULT":U          THEN ASSIGN f_F._DEFAULT         = hField:BUFFER-VALUE
                                                      _C._default-btn-recid = RECID(f_U). 
                WHEN "DELIMITER":U        THEN ASSIGN f_F._DELIMITER       = hField:BUFFER-VALUE.
                WHEN "DescSubstitute":U   THEN ASSIGN DSFormat             = hField:BUFFER-VALUE.
                WHEN "DISABLE-AUTO-ZAP":U THEN ASSIGN f_F._DISABLE-AUTO-ZAP = hField:BUFFER-VALUE.
                WHEN "DisableOnInit"      THEN ASSIGN disOnIn              = hField:BUFFER-VALUE.
                WHEN "DisplayField":U     THEN ASSIGN f_U._DISPLAY         = hField:BUFFER-VALUE.
                WHEN "DisplayedField":U   THEN ASSIGN disedFld             = hField:BUFFER-VALUE.
                WHEN "DisplayFormat":U    THEN ASSIGN disFrmt              = hField:BUFFER-VALUE.
                WHEN "DisplayDataType":U  THEN ASSIGN disDT                = hField:BUFFER-VALUE.
                WHEN "DRAG-ENABLED":U     THEN ASSIGN f_F._DRAG-ENABLED    = hField:BUFFER-VALUE.
                WHEN "DROP-TARGET":U      THEN ASSIGN f_U._DROP-TARGET     = hField:BUFFER-VALUE.
                WHEN "EDGE-PIXELS":U      THEN ASSIGN f_L._EDGE-PIXELS     = hField:BUFFER-VALUE.
                WHEN "Enabled":U          THEN ASSIGN f_U._ENABLE          = hField:BUFFER-VALUE.
                WHEN "EnableField":U      THEN ASSIGN enableFld            = hField:BUFFER-VALUE.
                WHEN "EXPAND":U           THEN ASSIGN f_F._EXPAND          = hField:BUFFER-VALUE.
                WHEN "FGCOLOR":U          THEN ASSIGN f_L._FGCOLOR         = hField:BUFFER-VALUE.
                WHEN "FieldLabel":U       THEN ASSIGN FldLabel             = hField:BUFFER-VALUE.
                WHEN "FieldName":U        THEN ASSIGN FldName              = hField:BUFFER-VALUE.
                WHEN "FieldToolTip":U     THEN ASSIGN FldToolTip           = hField:BUFFER-VALUE.
                WHEN "FILLED":U           THEN ASSIGN f_L._FILLED          = hField:BUFFER-VALUE.
                WHEN "FlagValue":U OR
                WHEN "ComboFlagValue":U   THEN ASSIGN ComboFlgVal          = hField:BUFFER-VALUE.
                WHEN "FLAT-BUTTON":U      THEN ASSIGN f_F._FLAT            = hField:BUFFER-VALUE.
                WHEN "FONT":U             THEN ASSIGN f_L._FONT            = hField:BUFFER-VALUE.
                WHEN "FORMAT":U           THEN DO:
                    IF hField:BUFFER-VALUE = "X(8)":U AND
                       LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                              INPUT "DataField":U)) <> 0 AND VALID-HANDLE(hSDO) THEN
                      ASSIGN f_F._FORMAT = DYNAMIC-FUNCTION("columnFormat":U IN hSDO, f_U._NAME).
                    ELSE ASSIGN f_F._FORMAT          = hField:BUFFER-VALUE.
                END.
                WHEN "GRAPHIC-EDGE":U     THEN ASSIGN f_L._GRAPHIC-EDGE    = hField:BUFFER-VALUE.
                WHEN "HEIGHT-CHARS":U     THEN ASSIGN f_L._HEIGHT          = hField:BUFFER-VALUE.
                WHEN "HELP":U             THEN DO:
                    IF hField:BUFFER-VALUE = "":U AND
                       LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                              INPUT "DataField":U)) <> 0 AND VALID-HANDLE(hSDO) THEN
                      ASSIGN f_U._HELP = DYNAMIC-FUNCTION("columnHelp":U IN hSDO, f_U._NAME).
                    ELSE ASSIGN f_U._HELP            = hField:BUFFER-VALUE.
                END.
                WHEN "HIDDEN":U           THEN ASSIGN f_U._HIDDEN          = hField:BUFFER-VALUE
                                                      f_U._VISIBLE         = NOT hField:BUFFER-VALUE.
                WHEN "HideOnInit":U       THEN ASSIGN cHideOnInit          = hField:BUFFER-VALUE.
                WHEN "Horizontal":U       THEN ASSIGN f_F._HORIZONTAL      = hField:BUFFER-VALUE.
                WHEN "InitialValue":U     THEN ASSIGN f_F._INITIAL-DATA    = hField:BUFFER-VALUE.
                WHEN "Inner-Lines":U      THEN ASSIGN f_F._INNER-LINES     = hField:BUFFER-VALUE.
                WHEN "InnerLines":U       THEN ASSIGN InLines              = hField:BUFFER-VALUE.
                WHEN "LARGE":U            THEN ASSIGN f_F._LARGE           = hField:BUFFER-VALUE.
                WHEN "IMAGE-FILE":U       THEN ASSIGN f_F._IMAGE-FILE      = hField:BUFFER-VALUE.
                WHEN "ListItemPairs":U    THEN ASSIGN ListItmPrs           = hField:BUFFER-VALUE.
                WHEN "LogicalObjectName":U 
                                          THEN ASSIGN _P.object_filename   = hField:BUFFER-VALUE.
                WHEN "KeyDataType":U      THEN ASSIGN KeyDT                = hField:BUFFER-VALUE.
                WHEN "KeyField":U         THEN ASSIGN KeyFld               = hField:BUFFER-VALUE.
                WHEN "KeyFormat":U        THEN ASSIGN KeyFrmt              = hField:BUFFER-VALUE.
                WHEN "LABEL":U OR
                WHEN "FieldLabel":U THEN DO:
                  IF hField:BUFFER-VALUE = "":U AND 
                     LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                            INPUT "DataField":U)) <> 0 AND VALID-HANDLE(hSDO) THEN
                      ASSIGN f_U._LABEL = DYNAMIC-FUNCTION("columnLabel":U IN hSDO, f_U._NAME).
                  ELSE ASSIGN f_U._LABEL = hField:BUFFER-VALUE.
                  IF f_U._LABEL = ? OR f_U._LABEL = "":U THEN
                    ASSIGN f_U._LABEL = REPLACE(hAttributeBuffer:BUFFER-FIELD("NAME":U):BUFFER-VALUE,
                                                 "_":U, " ":U).
                  f_L._LABEL = f_U._LABEL.   /* Set Master Layout _L label same as _U _label */
                END.
                WHEN "LABELS":U           THEN ASSIGN f_L._NO-LABEL        = NOT hField:BUFFER-VALUE.
                WHEN "MAX-CHARS":U        THEN ASSIGN f_F._MAX-CHARS       = hField:BUFFER-VALUE.
                WHEN "MOVABLE":U          THEN ASSIGN f_U._MOVABLE         = hField:BUFFER-VALUE.
                WHEN "MULTIPLE":U         THEN ASSIGN f_F._MULTIPLE        = hField:BUFFER-VALUE.
                WHEN "NAME":U  OR
                WHEN "WidgetName":U       THEN DO:
                  IF hField:BUFFER-VALUE > "" THEN ASSIGN f_U._NAME       = hField:BUFFER-VALUE.
                  IF NUM-ENTRIES(f_U._NAME, ".":U) = 2 THEN f_U._NAME = ENTRY(2,f_U._NAME,".":U).
                  IF NUM-ENTRIES(f_U._NAME, " ":U) = 2 THEN f_U._NAME = ENTRY(2,f_U._NAME," ":U).
                END.
                WHEN "NO-FOCUS":U         THEN ASSIGN f_L._NO-FOCUS        = hField:BUFFER-VALUE.
                WHEN "LIST-ITEM-PAIRS":U  THEN ASSIGN f_F._LIST-ITEM-PAIRS = hField:BUFFER-VALUE.
                WHEN "LIST-ITEMS":U       THEN DO:
                  IF f_U._TYPE NE "RADIO-SET":U THEN
                    ASSIGN f_F._LIST-ITEMS      = hField:BUFFER-VALUE.
                END.
                WHEN "MANUAL-HIGHLIGHT":U THEN ASSIGN f_U._MANUAL-HIGHLIGHT = hField:BUFFER-VALUE.
                WHEN "ORDER":U            THEN ASSIGN f_U._TAB-ORDER       = hField:BUFFER-VALUE.
                WHEN "ParentField":U      THEN ASSIGN ParentFld            = hField:BUFFER-VALUE.
                WHEN "ParentFieldQuery":U OR
                WHEN "ParentFilterQuery":U THEN ASSIGN ParentFldQry        = hField:BUFFER-VALUE.
                WHEN "PRIVATE-DATA":U     THEN ASSIGN f_U._PRIVATE-DATA    = hField:BUFFER-VALUE.
                WHEN "QueryTables":U      THEN ASSIGN QryTables            = hField:BUFFER-VALUE.
                WHEN "RADIO-BUTTONS":U    THEN DO:
                  IF f_U._TYPE = "RADIO-SET":U THEN
                    ASSIGN f_F._LIST-ITEMS      = hField:BUFFER-VALUE.
                END.
                WHEN "READ-ONLY":U        THEN ASSIGN f_F._READ-ONLY       = hField:BUFFER-VALUE.
                WHEN "RESIZABLE":U        THEN ASSIGN f_U._RESIZABLE       = hField:BUFFER-VALUE.
                WHEN "RETAIN-SHAPE":U     THEN ASSIGN f_F._RETAIN-SHAPE    = hField:BUFFER-VALUE.
                WHEN "RETURN-INSERTED":U  THEN ASSIGN f_F._RETURN-INSERTED = hField:BUFFER-VALUE.
                WHEN "ROW":U              THEN ASSIGN f_L._ROW             = hField:BUFFER-VALUE.
                WHEN "SCROLLBAR-HORIZONTAL":U THEN ASSIGN f_F._SCROLLBAR-H = hField:BUFFER-VALUE.
                WHEN "SCROLLBAR-VERTICAL":U THEN ASSIGN f_U._SCROLLBAR-V   = hField:BUFFER-VALUE.
                WHEN "SDFFileName":U      THEN ASSIGN SdfFN                = hField:BUFFER-VALUE.
                WHEN "SDFTemplate":U      THEN ASSIGN SdfTmplt             = hField:BUFFER-VALUE.
                WHEN "Secured":U          THEN ASSIGN Secured              = hField:BUFFER-VALUE.
                WHEN "SELECTABLE":U       THEN ASSIGN f_U._SELECTABLE      = hField:BUFFER-VALUE.
                WHEN "SENSITIVE":U        THEN ASSIGN f_U._SENSITIVE       = hField:BUFFER-VALUE.
                WHEN "ShowPopup":U        THEN ASSIGN f_U._SHOW-POPUP      = hField:BUFFER-VALUE.
                WHEN "SORT":U             THEN ASSIGN f_F._SORT            = hField:BUFFER-VALUE.
                WHEN "STRETCH-TO-FIT":U   THEN ASSIGN f_F._STRETCH-TO-FIT  = hField:BUFFER-VALUE.
                WHEN "SubType":U          THEN DO: 
                  IF f_U._SUBTYPE NE "TEXT":U 
                                          THEN ASSIGN f_U._SUBTYPE         = hField:BUFFER-VALUE.
                END. /* SubType */
                WHEN "TAB-STOP":U         THEN ASSIGN f_U._NO-TAB-STOP     = NOT hField:BUFFER-VALUE.
                WHEN "TableName":U        THEN DO:
                    ASSIGN f_U._BUFFER          = hField:BUFFER-VALUE
                           f_U._TABLE           = hField:BUFFER-VALUE.
                    IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                               INPUT "DataField":U)) <> 0 AND VALID-HANDLE(hSDO) THEN DO:
                      IF lSBODataSource THEN  /* Viewer was built against an SBO */
                        ASSIGN f_U._TABLE = cSDOName.
                      ELSE /* From an SDO */
                        ASSIGN cColumnTable = DYNAMIC-FUNCTION("columnTable":U IN hSDO, f_U._NAME)
                               f_U._TABLE  = IF NUM-ENTRIES(cColumnTable, ".":U) = 2 THEN 
                                                ENTRY(2, cColumnTable, ".":U) ELSE cColumnTable
                               f_U._BUFFER = "RowObject":U.
                    END.  /* IF it is a datafield */
                END.
                WHEN "THREE-D":U          THEN ASSIGN f_L._3-D             = hField:BUFFER-VALUE.
                WHEN "Tooltip":U          THEN ASSIGN f_U._TOOLTIP         = hField:BUFFER-VALUE.
                WHEN "TRANSPARENT":U      THEN ASSIGN f_F._TRANSPARENT     = hField:BUFFER-VALUE.
                WHEN "tWhereStored":U     THEN ASSIGN f_U._WHERE-STORED    = hField:BUFFER-VALUE.
                WHEN "VISIBLE":U          THEN ASSIGN f_U._HIDDEN          = NOT hField:BUFFER-VALUE
                                                      f_U._VISIBLE         = hField:BUFFER-VALUE
                                                      f_L._REMOVE-FROM-LAYOUT = NOT hField:BUFFER-VALUE.
                WHEN "VisualizationType":U THEN DO:
                    ASSIGN f_U._TYPE           = hField:BUFFER-VALUE
                           f_U._ALIGN          = IF LOOKUP(f_U._TYPE,
                                                           "RADIO-SET,IMAGE,SELECTION-LIST,EDITOR":U) > 0
                                                 THEN "L":U ELSE "C":U.
                  IF f_U._TYPE = "TEXT":U AND (LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN
                                                                                         gshRepositoryManager,
                                                                                         INPUT "DataField":U)) <> 0 OR
                                               LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN
                                                                                         gshRepositoryManager,
                                                                                         INPUT "DynFillin":U)) <> 0)
                  THEN  DO: 
                    ASSIGN f_U._TYPE    = "FILL-IN":U
                           f_U._SUBTYPE = "TEXT":U.
                    IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN
                                                                                         gshRepositoryManager,
                                                                                         INPUT "DataField":U)) <> 0 THEN
                    f_F._DATA-TYPE = IF VALID-HANDLE(hSDO) THEN 
                                       DYNAMIC-FUNCTION("ColumnDataType":U IN hSDO, f_U._NAME)
                                     ELSE "Character":U.
                  END.  /* If a view-as fill-in */
                END. /* Visualization Type */
                WHEN "WIDTH-CHARS":U      THEN DO:
                    IF (hField:BUFFER-VALUE = ? OR hField:BUFFER-VALUE = 14) AND
                        LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                               INPUT "DataField":U)) <> 0 AND VALID-HANDLE(hSDO) THEN
                      ASSIGN f_L._WIDTH = DYNAMIC-FUNCTION("columnWidth":U IN hSDO, f_U._NAME).
                    ELSE ASSIGN f_L._WIDTH           = hField:BUFFER-VALUE.
                END.
                WHEN "LocalField":U THEN ASSIGN lLocalField = hField:BUFFER-VALUE.
                WHEN "BlankOnNotAvail":U    THEN ASSIGN lBlankOnNotAvail     = hField:BUFFER-VALUE.
                WHEN "BrowseFieldDataTypes":U THEN ASSIGN cLkupBrowseFieldDataTypes = hField:BUFFER-VALUE.
                WHEN "BrowseFieldFormats":U THEN ASSIGN cLkupBrowseFieldFormats = hField:BUFFER-VALUE.
                WHEN "BrowseFields":U THEN ASSIGN cLkupBrowseFields = hField:BUFFER-VALUE.
                WHEN "BrowseTitle":U THEN ASSIGN cLkupBrowseTitle = hField:BUFFER-VALUE.
                WHEN "ColumnFormats":U THEN ASSIGN cLkupColumnFormats = hField:BUFFER-VALUE.
                WHEN "ColumnLabels":U THEN ASSIGN cLkupColumnLabels = hField:BUFFER-VALUE.
                WHEN "FieldWidth":U THEN ASSIGN dFieldWidth = hField:BUFFER-VALUE.
                WHEN "LinkedFieldDataTypes":U THEN ASSIGN cLinkedFieldDataTypes = hField:BUFFER-VALUE.
                WHEN "LinkedFieldFormats":U THEN ASSIGN cLinkedFieldFormats = hField:BUFFER-VALUE.
                WHEN "MaintenanceObject":U THEN ASSIGN cMaintenanceObject = hField:BUFFER-VALUE.
                WHEN "MaintenanceSDO":U THEN ASSIGN cMaintenanceSDO = hField:BUFFER-VALUE.
                WHEN "PhysicalTableNames":U THEN ASSIGN cPhysicalTableNames = hField:BUFFER-VALUE.
                WHEN "PopupOnAmbiguous":U THEN ASSIGN lPopupOnAmbiguous = hField:BUFFER-VALUE.
                WHEN "PopupOnUniqueAmbiguous":U THEN ASSIGN lPopupOnUniqueAmbiguous = hField:BUFFER-VALUE.
                WHEN "PopupOnNotAvail":U THEN ASSIGN lPopupOnNotAvail = hField:BUFFER-VALUE.
                WHEN "QueryBuilderJoinCode":U THEN ASSIGN cQBJoinCode = hField:BUFFER-VALUE.
                WHEN "QueryBuilderOptionList":U THEN ASSIGN cQueryBuilderOptionList = hField:BUFFER-VALUE.
                WHEN "QueryBuilderOrderList":U THEN ASSIGN cQueryBuilderOrderList = hField:BUFFER-VALUE.
                WHEN "QueryBuilderTableOptionList":U THEN ASSIGN cQueryBuilderTableOptList = hField:BUFFER-VALUE.
                WHEN "QueryBuilderTuneOptions":U THEN ASSIGN cQueryBuilderTuneOptions = hField:BUFFER-VALUE.
                WHEN "QueryBuilderWhereClauses":U THEN ASSIGN cQueryBuilderWhereClauses = hField:BUFFER-VALUE.
                WHEN "RowsToBatch":U THEN ASSIGN iRowsToBatch = hField:BUFFER-VALUE.
                WHEN "TempTables":U THEN ASSIGN cTempTables = hField:BUFFER-VALUE.
                WHEN "ViewerLinkedFields":U THEN ASSIGN cViewerLinkedFields = hField:BUFFER-VALUE.
                WHEN "ViewerLinkedWidgets":U THEN ASSIGN cViewerLinkedWidgets = hField:BUFFER-VALUE.
                WHEN "WORD-WRAP":U        THEN ASSIGN f_F._WORD-WRAP       = hField:BUFFER-VALUE.
                WHEN "ColumnLabel":U       OR
                WHEN "DatabaseName":U      OR
                WHEN "DhtmlClass":U        OR
                WHEN "DynamicObject":U     OR
                WHEN "KeyValueFormat":U    OR
                WHEN "LabelBGColor":U      OR
                WHEN "LabelFGColor":U      OR
                WHEN "LabelFont":U         OR
                WHEN "LogicalVersion":U    OR
                WHEN "Mandatory":U         OR
                WHEN "MasterFile":U        OR
                WHEN "MinHeight":U         OR
                WHEN "MinWidth":U          OR
                WHEN "ObjectLayout":U      OR
                WHEN "ResizeHorizontal":U  OR
                WHEN "ResizeVertical":U    OR
                WHEN "tRecordIdentifier":U OR
                WHEN "tWhereConstant":U    OR
                WHEN "WindowTitleField":U
                THEN DO:
                      /* No Action - Not needed */
                END.
                /*
                OTHERWISE
                  MESSAGE "Attribute" cAttr "is not currently supported."
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.  */
              END CASE.
            END.  /* If Master Layout */
            ELSE IF iWhereStored > 3 THEN DO:  /* Case for other layouts */

                CASE cAttr:
             
                  WHEN "BGColor":U          THEN ASSIGN f_L._BGCOLOR         = hField:BUFFER-VALUE.
                  WHEN "BOX":U              THEN ASSIGN f_L._NO-BOX          = NOT hField:BUFFER-VALUE.
                  WHEN "COLUMN":U           THEN ASSIGN f_L._COL             = hField:BUFFER-VALUE.
                  WHEN "CONVERT-3D-COLORS":U THEN ASSIGN f_L._CONVERT-3D-COLORS = hField:BUFFER-VALUE.
                  WHEN "EDGE-PIXELS":U      THEN ASSIGN f_L._EDGE-PIXELS     = hField:BUFFER-VALUE.
                  WHEN "FGCOLOR":U          THEN ASSIGN f_L._FGCOLOR         = hField:BUFFER-VALUE.
                  WHEN "FILLED":U           THEN ASSIGN f_L._FILLED          = hField:BUFFER-VALUE.
                  WHEN "FONT":U             THEN ASSIGN f_L._FONT            = hField:BUFFER-VALUE.
                  WHEN "GRAPHIC-EDGE":U     THEN ASSIGN f_L._GRAPHIC-EDGE    = hField:BUFFER-VALUE.
                  WHEN "HEIGHT-CHARS":U     THEN ASSIGN f_L._HEIGHT          = hField:BUFFER-VALUE.
                  WHEN "LABEL":U OR
                  WHEN "FieldLabel":U       THEN ASSIGN f_L._LABEL           = hField:BUFFER-VALUE.
                  WHEN "LABELS":U           THEN ASSIGN f_L._NO-LABEL        = NOT hField:BUFFER-VALUE.
                  WHEN "NO-FOCUS":U         THEN ASSIGN f_L._NO-FOCUS        = hField:BUFFER-VALUE.
                  WHEN "ROW":U              THEN ASSIGN f_L._ROW             = hField:BUFFER-VALUE.
                  WHEN "THREE-D":U          THEN ASSIGN f_L._3-D             = hField:BUFFER-VALUE.
                  WHEN "VISIBLE":U          THEN ASSIGN f_L._REMOVE-FROM-LAYOUT = NOT hFIELD:BUFFER-VALUE.
                  WHEN "WIDTH-CHARS":U      THEN ASSIGN f_L._WIDTH           = hField:BUFFER-VALUE.
            
                END CASE.  /* For non Master Layouts */

            END. /* Else do case for non master layouts */

          END.  /* Do for each attribute in the attribute buffer */

          /* If we have a datafield whose width is 0, then ask the SDO */
          IF f_L._WIDTH = ? AND VALID-HANDLE(hSDO) AND 
             LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                    INPUT "DataField":U)) <> 0 THEN
            f_L._WIDTH = DYNAMIC-FUNCTION("ColumnWidth":U IN hSDO, f_U._NAME).

          /* Safety measure */
          IF f_L._WIDTH  = 0 THEN f_L._WIDTH  = dWidgetWidth.
          IF f_L._HEIGHT = 0 THEN f_L._HEIGHT = dWidgetHeight.


          IF lMasterLO THEN DO: /* Master Layout */
            /* Now that we have read all of the attributes in, and know the delimiter (if any),
               fix list-items and list-item-pairs */
            IF f_F._LIST-ITEMS NE ? AND f_U._TYPE NE "RADIO-SET":U
              THEN f_F._LIST-ITEMS = REPLACE(f_F._LIST-ITEMS, f_F._DELIMITER, CHR(10)).
            ELSE IF f_U._TYPE EQ "RADIO-SET" THEN DO:
              /* Put <CR> after the values */
              IF NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) > 3 AND
                 NUM-ENTRIES(f_F._LIST-ITEMS, CHR(10)) < 2 THEN DO:
                DO iCnt = 3 TO NUM-ENTRIES(f_F._LIST-ITEMS, f_F._DELIMITER) BY 2:
                  ENTRY(iCnt, f_F._LIST-ITEMS, f_F._DELIMITER) = CHR(10) + 
                      ENTRY(iCnt, f_F._LIST-ITEMS, f_F._DELIMITER).
                END.
              END.  /* There are more than 1 item and no <CR>s */
            END.
    
            IF f_F._LIST-ITEM-PAIRS NE ? AND f_F._LIST-ITEM-PAIRS NE "":U THEN DO: 
              cTmp = "":U.
              DO iCnt = 1 TO NUM-ENTRIES(f_F._LIST-ITEM-PAIRS, f_F._DELIMITER):
                cTmp = cTmp + f_F._DELIMITER + 
                              (IF iCnt MOD 2 = 1 THEN CHR(10) ELSE "") +
                              ENTRY(iCnt, f_F._LIST-ITEM-PAIRS, f_F._DELIMITER). 
              END.
              f_F._LIST-ITEM-PAIRS = TRIM(cTmp, CHR(10) + f_F._DELIMITER).
            END. /* IF List ITEM PAIRS is non blank */
          END.  /* IF the Master Layout */

          /* Reset the parent frames Width and height  */
          /* Find window _U and populate */
          FIND _U WHERE _U._TYPE EQ "WINDOW":U AND
                        _U._WINDOW-HANDLE EQ _h_win AND
                        _U._STATUS NE "DELETED":U.
          FIND _L WHERE _L._u-recid = RECID(_U) AND 
                        _L._LO-NAME = IF lMasterLO THEN "Master Layout":U ELSE cCode.
          ASSIGN _L._HEIGHT         = dFrameMaxHeight
                 _L._Virtual-Height = _L._HEIGHT
                 _L._WIDTH          = dFrameMaxWidth
                 _L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH
                 _L._FONT           = ?.

          /* Do the same for the frame */
          FIND _U WHERE _U._TYPE EQ "FRAME":U AND
                        _U._WINDOW-HANDLE EQ _h_win AND
                        _U._STATUS NE "DELETED":U.
          FIND _C WHERE RECID(_C) = _U._x-recid.
          FIND x_L WHERE x_L._u-recid = RECID(_U) AND
                         x_L._LO-NAME = IF lMasterLO THEN "Master Layout":U ELSE cCode.

          ASSIGN x_L._HEIGHT         = _L._HEIGHT
                 x_L._VIRTUAL-HEIGHT = _L._VIRTUAL-HEIGHT
                 x_L._WIDTH          = _L._WIDTH
                 x_L._VIRTUAL-WIDTH  = _L._VIRTUAL-WIDTH
                 x_L._FONT           = _L._FONT.

          IF lMasterLO THEN DO:  /* Only realize Master layout */
            IF _L._WIDTH > _h_win:WIDTH THEN
              ASSIGN _h_win:WIDTH   = _L._WIDTH
                     _h_frame:WIDTH = _L._WIDTH.
            ELSE IF _L._WIDTH < _h_win:WIDTH THEN
              ASSIGN _h_frame:WIDTH = _L._WIDTH
                     _h_win:WIDTH   = _L._WIDTH.

            IF _L._HEIGHT > _h_win:HEIGHT THEN
              ASSIGN _h_win:HEIGHT   = _L._HEIGHT
                     _h_frame:HEIGHT = _L._HEIGHT.
            ELSE IF _L._HEIGHT < _h_win:HEIGHT THEN
              ASSIGN _h_frame:HEIGHT = _L._HEIGHT
                     _h_win:HEIGHT   = _L._HEIGHT.
          END.  /* If Master Layout */

          /* Realize widget */
          CASE f_U._TYPE:
            WHEN "FILL-IN":U    THEN DO:
              /* The height is defaulted to 1, the field is not populated above so do it explicitly */
              IF f_L._HEIGHT = 0 THEN f_L._HEIGHT = 1.

              /* Make the label _U for this fill-in */
              IF lMasterLO THEN DO:
                CREATE l_U.
                CREATE l_F.
                ASSIGN f_U._l-recid       = RECID(l_U)
                       l_U._l-recid       = RECID(f_U)
                       l_U._x-recid       = RECID(l_F)
                       l_U._PARENT-RECID  = f_U._PARENT-RECID
                       l_U._PARENT        = _h_frame:FIRST-CHILD
                       l_F._FRAME         = f_F._FRAME
                       l_U._SUBTYPE       = "LABEL":U
                       l_U._NAME          = "_LBL-":U + f_U._NAME
                       l_U._TYPE          = "TEXT":U
                       l_F._DATA-TYPE     = "Character":U
                       l_U._WINDOW-HANDLE = _h_win.
                RUN adeuib/_undfill.p (RECID(f_U)).
              END. /* if Master Layout */
            END.  /* End Fill-in case */
            WHEN "EDITOR":U         THEN IF lMasterLO THEN RUN adeuib/_undedit.p (RECID(f_U)).
            WHEN "RECTANGLE":U      THEN IF lMasterLO THEN RUN adeuib/_undrect.p (RECID(f_U)).
            WHEN "BUTTON":U         THEN IF lMasterLO THEN RUN adeuib/_undbutt.p (RECID(f_U)).
            WHEN "IMAGE":U          THEN IF lMasterLO THEN RUN adeuib/_undimag.p (RECID(f_U)).
            WHEN "RADIO-SET":U      THEN IF lMasterLO THEN RUN adeuib/_undRadi.p (RECID(f_U)).
            WHEN "SELECTION-LIST":U THEN IF lMasterLO THEN RUN adeuib/_undSele.p (RECID(f_U)).
            WHEN "TOGGLE-BOX":U     THEN IF lMasterLO THEN RUN adeuib/_undtogg.p (RECID(f_U)).
            WHEN "TEXT":U           THEN IF lMasterLO THEN RUN adeuib/_undtext.p (RECID(f_U)).
            WHEN "COMBO-BOX":U      THEN IF lMasterLO THEN RUN adeuib/_undcomb.p (RECID(f_U)).
            WHEN "SmartDataField":U THEN DO:
              /* We need to create an _S for the SDF */
              IF lMasterLO THEN DO:
                DELETE f_F.
                CREATE _S.

                tmpName = "h_":U + f_U._CLASS-NAME.
                DO WHILE CAN-FIND(X_U WHERE X_U._NAME = tmpName AND 
                                  RECID(X_U) NE RECID(f_U)):
                  IF LOOKUP(tmpName,"h_DynLookup,h_DynCombo,h_DynSelect":U) > 0 THEN
                    tmpName = tmpName + "1":U.
                  ELSE DO:
                    ilnth = LENGTH(tmpName). 
                    ASSIGN newDigit = INTEGER(SUBSTRING(tmpName, ilnth, 1)) + 1
                           tmpName  = SUBSTRING(tmpName, 1, ilnth - 1) + STRING(newDigit).
                  END. /* Else DO */
                END. /* Do while looking for a unique name */

                /* This prevents all settings being set to ? */
                IF KeyFld = ? THEN KeyFld = "":U.
  
                /* This is for backward compatibility */
                IF NUM-ENTRIES(f_U._NAME,".":U) > 1 THEN f_U._NAME = tmpName.
  
                /* Override some of the stuff above */
                ASSIGN f_U._ALIGN          = "L":U
                       f_U._TYPE           = "SmartObject":U
                       f_U._SUBTYPE        = "SmartDataField":U
                       f_U._x-recid        = RECID(_S).
                ASSIGN _S._FILE-NAME       = IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                                      gshRepositoryManager, INPUT "DynCombo":U)) <> 0
                                               THEN "adm2\dyncombo.w":U
                                             ELSE IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                                      gshRepositoryManager, INPUT "DynLookup":U)) <> 0
                                               THEN "adm2\dynlookup.w":U
                                             ELSE IF LOOKUP(f_U._CLASS-NAME, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN 
                                                      gshRepositoryManager, INPUT "DynSelect":U)) <> 0
                                               THEN "adm2\dynselect.w":U
                                             ELSE _P.OBJECT_filename.
                ASSIGN _S._SETTINGS = "DisplayedField":U       + CHR(4) + disedFld     + CHR(3) +
                                      "KeyField":U             + CHR(4) + KeyFld       + CHR(3) +
                                      "FieldLabel":U           + CHR(4) + FldLabel     + CHR(3) +
                                      "FieldName":U            + CHR(4) + FldName      + CHR(3) +
                                      "FieldToolTip":U         + CHR(4) + FldToolTip   + CHR(3) +
                                      "KeyFormat":U            + CHR(4) + KeyFrmt      + CHR(3) +
                                      "KeyDataType":U          + CHR(4) + 
                                                 (IF KeyDT NE "":U THEN KeyDT ELSE "Character":U)
                                                                                       + CHR(3) +
                                      "DisplayFormat":U        + CHR(4) + DisFrmt      + CHR(3) +
                                      "DisplayDataType":U      + CHR(4) + DisDT        + CHR(3) +
                                      "BaseQueryString":U      + CHR(4) + BaseQryStrng + CHR(3) +
                                      "QueryTables":U          + CHR(4) + QryTables    + CHR(3) +
                                      "SDFFileName":U          + CHR(4) + SDFFN        + CHR(3) +
                                      "SDFTemplate":U          + CHR(4) + sdfTmplt     + CHR(3) +
                                      "ParentField":U          + CHR(4) + ParentFld    + CHR(3) +
                                      "ParentFilterQuery":U     + CHR(4) + (IF ParentFldQry = ? THEN "" ELSE ParentFldQry) + CHR(3) +
                                      "DescSubstitute":U       + CHR(4) + DSFormat     + CHR(3) +
                                      "CurrentKeyValue":U      + CHR(4) + CurKeyVal    + CHR(3) +
                                      "ComboDelimiter":U       + CHR(4) + 
                                        (IF ComboDel NE "":U THEN ComboDel ELSE ",":U) + CHR(3) +
                                      "ListItemPairs":U        + CHR(4) + ListItmPrs   + CHR(3) +
                                      "CurrentDescValue":U     + CHR(4) + CurDescVal   + CHR(3) +
                                      "InnerLines":U           + CHR(4) + InLines      + CHR(3) +
                                      "ComboFlag":U            + CHR(4) + ComboFlg     + CHR(3) +
                                      "FlagValue":U            + CHR(4) + ComboFlgVal  + CHR(3) +
                                      "BuildSequence":U        + CHR(4) + BldSeq       + CHR(3) +
                                      "Secured":U              + CHR(4) + Secured      + CHR(3) +
                                      "DisplayField":U         + CHR(4) + 
                                            (IF f_U._DISPLAY THEN "Yes":U ELSE "no":U) + CHR(3) +
                                      "EnableField":U          + CHR(4) + enableFld    + CHR(3) + 
                                      "LocalField":U           + CHR(4) + STRING(lLocalField)       + CHR(3) +
                                      "BlankOnNotAvail":U      + CHR(4) + STRING(lBlankOnNotAvail)  + CHR(3) +
                                      "BrowseFieldDataTypes":U + CHR(4) + cLkupBrowseFieldDataTypes + CHR(3) +
                                      "BrowseFieldFormats":U   + CHR(4) + cLkupBrowseFieldFormats   + CHR(3) +
                                      "BrowseFields":U         + CHR(4) + cLkupBrowseFields         + CHR(3) +
                                      "BrowseTitle":U          + CHR(4) + cLkupBrowseTitle          + CHR(3) +
                                      "ColumnFormats":U        + CHR(4) + cLkupColumnFormats        + CHR(3) +
                                      "ColumnLabels":U         + CHR(4) + cLkupColumnLabels         + CHR(3) +
                                      "FieldWidth":U           + CHR(4) + STRING(dFieldWidth)       + CHR(3) +
                                      "LinkedFieldDataTypes":U + CHR(4) + cLinkedFieldDataTypes     + CHR(3) +
                                      "LinkedFieldFormats":U   + CHR(4) + cLinkedFieldFormats       + CHR(3) +
                                      "MaintenanceObject":U    + CHR(4) + cMaintenanceObject        + CHR(3) +
                                      "MaintenanceSDO":U       + CHR(4) + cMaintenanceSDO           + CHR(3) +
                                      "PhysicalTableNames":U   + CHR(4) + cPhysicalTableNames       + CHR(3) +
                                      "PopupOnAmbiguous":U     + CHR(4) + STRING(lPopupOnAmbiguous) + CHR(3) +
                                      "PopupOnUniqueAmbiguous":U      + CHR(4) + STRING(lPopupOnUniqueAmbiguous) + CHR(3) +
                                      "PopupOnNotAvail":U      + CHR(4) + STRING(lPopupOnNotAvail)  + CHR(3) +
                                      "QueryBuilderJoinCode":U + CHR(4) + cQBJoinCode               + CHR(3) +
                                      "QueryBuilderOptionList":U      + CHR(4) + cQueryBuilderOptionList   + CHR(3) +
                                      "QueryBuilderOrderList":U       + CHR(4) + cQueryBuilderOrderList    + CHR(3) +
                                      "QueryBuilderTableOptionList":U + CHR(4) + cQueryBuilderTableOptList + CHR(3) +
                                      "QueryBuilderTuneOptions":U     + CHR(4) + cQueryBuilderTuneOptions  + CHR(3) +
                                      "QueryBuilderWhereClauses":U    + CHR(4) + cQueryBuilderWhereClauses + CHR(3) +
                                      "RowsToBatch":U          + CHR(4) + STRING(iRowsToBatch)      + CHR(3) +
                                      "TempTables":U           + CHR(4) + cTempTables               + CHR(3) +
                                      "ViewerLinkedFields":U   + CHR(4) + cViewerLinkedFields       + CHR(3) +
                                      "ViewerLinkedWidgets":U  + CHR(4) + cViewerLinkedWidgets      + CHR(3).
                       
                IF SEARCH(_S._FILE-NAME) = ? THEN DO:
                  FIND ryc_smartobject NO-LOCK
                      WHERE ryc_smartobject.OBJECT_filename = _S._FILE-NAME AND 
                            ryc_smartobject.customization_result_obj = 0 NO-ERROR.
                  IF AVAILABLE ryc_smartobject THEN DO:
                    _S._FILE-NAME = ryc_smartobject.object_path + "/":U +
                                       ryc_smartobject.object_filename.
                    IF SEARCH(_S._FILE-NAME) = ? AND NUM-ENTRIES(_S._FILE-NAME, ".") = 1 AND 
                               ryc_smartobject.object_extension NE "":U THEN DO:
                      _S._FILE-NAME = ryc_smartobject.object_path + "/":U +
                                       ryc_smartobject.object_filename + ".":U +
                                       ryc_smartobject.object_extension.
                    END.  /* If still not found and not using the extension */
                  END. /* If found the ryc_smartobject record */
                END. /* Can't find the file */

                /* Try it again */
                IF SEARCH(_S._FILE-NAME) = ? THEN DO:
                  MESSAGE "Unable to locate" _S._File-name + ".":U SKIP
                          "Can't instantiate it."
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.

                RUN adeuib/_undsmar.p (RECID(f_U)).
              END.  /* If it is a Master Layout */
            END.  /* When a SmartData Field */
          END CASE.
          hObjectQuery:GET-NEXT().
        END. /* While we a field widget record */
        DELETE OBJECT hObjectQuery.
      END. /* Else if we have a viewer object */
    END. /* IF we have an objectbuffer */

    IF lMasterLO THEN DO:
      IF lSBODataSource THEN DO:
        /* Create a _TT for each SDO in the SBO */
        RUN adeuib/_upddott.w (RECID(_P)).
      END.
      ELSE DO: /* Create a _TT for the SDO RowObject DataSource */
        cIncludeFile = DYNAMIC-FUNCTION('getSDOincludeFile' IN gshRepositoryManager,
                                         _P._DATA-OBJECT).
        IF NUM-ENTRIES(cIncludeFile, ".":U) = 1 THEN
            ASSIGN cIncludeFile = cIncludeFile + ".i":U.
        IF cIncludeFile BEGINS "~/":U THEN 
            ASSIGN cIncludeFile = ".":U + cIncludeFile.
        CREATE _TT.
        ASSIGN _TT._NAME              = "RowObject":U
               _TT._p-recid           = RECID(_P)
               _TT._Table-Type        = "D":U
               _TT._ADDITIONAL_FIELDS = "~{":U + cIncludeFile + "~}":U.
      END.
    END. /* If we are doing a master layout */

    IF AbortImport THEN DO:
      RUN wind-close IN _h_uib (INPUT _h_win).
      RUN dynsucker_cleanup.
      RETURN "_ABORT":U.
    END.

    IF _h_frame = ? and _h_win = ? THEN DO:
      RUN adecomm/_setcurs.p ("").
      MESSAGE "Aborting import." 
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RUN dynsucker_cleanup. /* Close everything qssucker does */
      RETURN "_ABORT":U. 
    END. /* If no frame and no window */

    /* A valid file should always have a Custom Definitions and Main-Code block 
       (even if they are empty).  As protection, make sure we have these sections
       even if one was not in the input file. [Note - don't add these sections 
       if we are importing a section of .w file]. */
    IF lMasterLO THEN DO:
      IF import_mode <> "IMPORT" AND ((def_found = no) OR (main_found = no)) THEN DO:
        FIND _U WHERE _U._HANDLE = _h_win.
        IF NOT def_found THEN DO:
          CREATE _TRG.
          ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
                 _TRG._tSECTION = "_CUSTOM":U
                 _TRG._wRECID   = RECID(_U)
                 _TRG._tEVENT   = "_DEFINITIONS":U.
          RUN adeshar/_coddflt.p ("_DEFINITIONS":U, RECID(_U), OUTPUT _TRG._tCODE). 
        END. /* If not found a definitions section */
        IF NOT main_found THEN DO:
          CREATE _TRG.
          ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
                 _TRG._tSECTION = "_CUSTOM":U
                 _TRG._wRECID   = RECID(_U)
                 _TRG._tEVENT   = "_MAIN-BLOCK":U
                 _TRG._tCODE    = "". 
        END. /* If not a main section found */
      END. /* If importing and we haven't found either a main of definitions section */

      /* When Importing, we need to do some special actions.
       *   a) mark all widgets
       *   b) modify the default query for frames
       */
      IF import_mode eq "IMPORT":U THEN DO:
        /* If we have imported, then "Select" all the widgets we have just added.  
           Note that if we also imported the parent of an object, then we won't
           select its children.  That is, if we import a FRAME, only select the
           frame. */
        FOR EACH _NAME-REC:
          FIND _U WHERE RECID(_U) eq _NAME-REC._wRECID.
          IF NOT CAN-FIND(parent_NAME-REC WHERE
                                   parent_NAME-REC._wRECID eq _U._parent-recid)
          THEN ASSIGN _U._HANDLE:SELECTED = YES
                      _U._SELECTEDib      = YES.
        END.

        /* Add any pasted fields to the frame query, if appropriate. */
        added_fields = "".
        FOR EACH _NAME-REC,
            EACH _U WHERE RECID(_U) eq _NAME-REC._wRECID
                    AND _U._TABLE ne ?,
            EACH _L WHERE RECID(_L) eq _U._lo-recid BY _L._ROW BY _L._COL:
          IF added_fields ne "" THEN added_fields = added_fields + ",":U.
          added_fields = added_fields + 
                           _U._DBNAME + ".":U + _U._TABLE + ".":U + _U._NAME.     
        END. /* for each added widget. */

        /* Check the frames query to verify that the new fields are in the default
           query. */
        IF added_fields ne "" 
        THEN RUN adeuib/_vrfyqry.p (_h_frame, "ADD-FIELDS":U, added_fields).
      END. /* if importing */

      /* Restore counts */
      DO i = 1 TO {&WIDGET-COUNT-DIMENSION}:
        _count[i] = MAX(count_tmp[i],_count[i]).
      END.

      /* Delete any unwanted VBX controls loaded as OCX. -jep 1/24/97 5:39PM */
      FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win
                    AND _U._TYPE          = "_DELETE-" + "{&WT-CONTROL}":
        /* Change back to original type to ensure of correct deletion. */
        ASSIGN _U._TYPE = "{&WT-CONTROL}":U.
        RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT YES /* TRASH ALL _U */).
      END.

      /* Cleanup after ourselves. */
      RUN dynsucker_cleanup.

      /* Now force the current window visible and on the screen.  This gets around
         bug where the some other window-system window has moved to the foreground. */
      FIND _U WHERE _U._HANDLE eq _h_win.
      IF _U._TYPE = "DIALOG-BOX" THEN h = _U._HANDLE:PARENT. /* the "real" window */
      ELSE h = _h_win.

      /* Don't show the dummy wizard for HTML files in design mode. */
      IF NOT AVAILABLE (_P) OR _P._file-type <> "HTML" OR _P._TEMPLATE THEN DO:  
        h:VISIBLE = TRUE.
      END.

      /* It's important to do this for hidden windows also,
         if not window triggers in the wizard will fire for the last entered window */ 
      IF h:MOVE-TO-TOP() THEN APPLY "ENTRY":U TO h.      
    
      /* Having read in the values for the Procedure, check if this is a special `
         ADM SmartObject and reset the _P record according to ADM standards */
      IF import_mode BEGINS "WINDOW":U THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
        IF _P._TYPE BEGINS "Smart":U THEN 
          RUN adeuib/_admpset.p (RECID(_P)).
        IF LOOKUP(_P._TYPE, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, 
                            INPUT "SmartBrowser":U)) <> 0 AND _P._ADM-VERSION > "ADM1" THEN DO:
          ASSIGN h    = _h_win:FIRST-CHILD  /* The Frame       */
                 hfgp = h:FIRST-CHILD       /* The field group */
                 h    = hfgp:FIRST-CHILD.   /* The browse      */
          DO WHILE VALID-HANDLE(h):
            IF h:TYPE = "BROWSE":U THEN
              ASSIGN h:HIDDEN = TRUE.
            ASSIGN h = h:NEXT-SIBLING.
          END. /* Do while valid handle */
        END.  /* If a SmartBrowser and > adm1 */
      END.  /* If import begins window */
     
      IF import_mode ne "IMPORT" THEN DO:
        IF NOT AVAILABLE(_P) THEN 
          FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    
        /* Copy all _RyObject fields to _P */
        BUFFER-COPY _RyObject TO _P.
    
        /* Send event to notify anyone interested that the UIB has opened a file.
           Note that opening a window UNTITLED counts as a NEW event.  */
        CASE import_mode:
          WHEN "WINDOW":U THEN
            RUN adecomm/_adeevnt.p 
                (INPUT  "UIB":U, "OPEN":U, STRING(_P._u-recid), _P._SAVE-AS-FILE,
                 OUTPUT ldummy).
          WHEN "WINDOW UNTITLED":U THEN
            RUN adecomm/_adeevnt.p
                (INPUT  "UIB":U, "NEW":U, STRING(_P._u-recid), ?,
                 OUTPUT ldummy).
        END CASE.
      
        /* Add procedure to MRU Filelist - we need to make sure that import mode
           is not "window untitled" so that templates do not display in the MRU 
           filelist. */
        IF import_mode NE "WINDOW UNTITLED" AND _mru_filelist THEN DO:
          ASSIGN cBrokerURL = IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL.
          RUN adeshar/_mrulist.p (open_file, "":U).  
        END.  /* if import_mode and _mru_filelist */
      
      END. /* IF import_mode ne "IMPORT"  */ 
    END.  /* If mastr Layout */
  END.  /* Loop through layouts */

  /* The _rd* procedures may have started an sdo */
  DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
     
  /* If Treeview design window, refresh the Treeview. */
  RUN TreeviewUpdate.


RETURN.

/****************************** Internal Procedures ***************************/


PROCEDURE dynsucker_cleanup:
   /* ---------------------------------------------------------------------
      Description: Close open file streams and restore cursor.  This
                   should be called everywhere we return from _qssuckr
          
      Parameters:  None
      Non-local effects: _P_QS
   ------------------------------------------------------------------------*/ 
  INPUT STREAM _P_QS CLOSE.           /* Close Streams                     */
  IF temp_file ne "" THEN DO:
    OS-DELETE VALUE(temp_file).       /* Delete disk garbage               */
    OS-DELETE VALUE(temp_file + "2"). /* Delete disk garbage               */
  END.

  /*  jep-icf: Cleanup repository related stuff. */
  IF isRyObject THEN
  DO:
    /*  jep-icf: Delete the temporary template file for dynamic repository objects. */
    IF dyn_object AND FALSE THEN
      OS-DELETE VALUE(dyn_temp_file).

    /*  jep-icf: If _qssuckr ended via an abort, delete the _RyObject. It's not 
        used beyond the NEW or OPEN processing. */
    IF AbortImport THEN
    DO:
      IF NOT AVAILABLE _RyObject THEN
        FIND _RyObject WHERE _RyObject.object_filename = open_file NO-ERROR.
      IF AVAILABLE _RyObject THEN
        DELETE _RyObject.
    END. /* AbortImport */
  END.
      
  /* The _rd* procedures may have started an sdo */
  IF AVAILABLE _P THEN
    DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).

  IF VALID-HANDLE(hsdo) THEN RUN destroyObject IN hsdo.
  IF VALID-HANDLE(hsdo) THEN DELETE OBJECT hsdo.
    
  CURRENT-WINDOW = _h_menu_win.       /* Make sure we reset current-window */
  RUN adecomm/_setcurs.p ("").        /* Restore cursor pointers           */
  
END PROCEDURE.
  
PROCEDURE get_window_hidden_value.
  FIND _U WHERE _U._HANDLE = _h_win.
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.        
  IF import_mode NE "IMPORT":U THEN 
   _U._HIDDEN = (_inp_line[4] BEGINS "y").
END.  /* Get Window Hidden value */


PROCEDURE get_object_name: 

/* take a token parsed from the input line and figure out what     */
/* the name of the frame is. The format of the input parameter     */
/* is always XXXXXX:YYYYYY, where XXXXXX is the object's name and  */
/* YYYYYY is HANDLE, MOVE-BEFORE-TAB-ITEM, or MOVE-AFTER-TAB-ITEM. */

DEFINE INPUT  PARAMETER token    AS CHAR.
DEFINE OUTPUT PARAMETER obj_name AS CHAR.

obj_name = TRIM(ENTRY(1,token,":":U)).

END PROCEDURE. /* get_object_name */


PROCEDURE insert_in_tab_order:
/* take the frame and insert it in the proper place of the tab */
/* order.                                                      */

DEFINE INPUT PARAMETER parent_recid AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER obj_recid    AS RECID     NO-UNDO.
DEFINE INPUT PARAMETER start_i      AS INTEGER   NO-UNDO.

DEFINE BUFFER x_U FOR _U.

FOR EACH x_U WHERE x_U._PARENT-RECID = parent_recid
         AND x_U._STATUS = 'NORMAL':U
         AND RECID (x_U) <> parent_recid
         AND NOT CAN-DO ('SMartObject,QUERY,OCX,TEXT,IMAGE,RECTANGLE,LABEL':U, x_U._TYPE)
         AND x_U._TAB-ORDER >= start_i BY x_U._TAB-ORDER DESCENDING:
  x_U._TAB-ORDER = x_u._TAB-ORDER + 1.
END.
/* Now set the frame's _TAB-ORDER value. */
FIND x_U WHERE RECID(x_U) = obj_recid.
x_U._TAB-ORDER = start_i.
END PROCEDURE. /* insert_in_tab_order */ 

PROCEDURE TreeViewUpdate:
/* If Treeview design window, refresh the Treeview to show fields,
  code sections, etc. */

  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
  IF VALID-HANDLE(_P._tv-proc) THEN
    RUN createTree IN _P._tv-proc (RECID(_P)).

END PROCEDURE.


PROCEDURE processRepositoryObject:
/* jep-icf: Process a request to create a new or open an existing repository 
   object. Handles both static and dynamic. */

  DO ON ERROR UNDO, LEAVE:

    /* jep-icf: If there isn't an _RyObject, then we aren't processing a
       repository object. */
    FIND _RyObject WHERE _RyObject.object_filename = open_file NO-LOCK NO-ERROR.
    ASSIGN isRyObject = AVAILABLE _RyObject.
    IF NOT AVAILABLE _RyObject THEN RETURN.

    ASSIGN dyn_object = (NOT _RyObject.static_object).
    IF dyn_object THEN
    DO:
      ASSIGN dyn_temp_file = _Ryobject.design_template_file.

      /* If we can't determine the template file or the property sheet procedure, we can't open the 
         object, unless it is a Dynamic Viewer */
      ASSIGN cDynClass    = DYNAMIC-FUNCTION("RepositoryDynamicClass" IN _h_func_lib, INPUT _RyObject.object_type_code)
             cDynExtClass = _RyObject.object_type_code.
      IF LOOKUP(cDynClass,"DynBrow,DynSDO,DynView":U) = 0 AND 
        ((SEARCH(_Ryobject.design_template_file) = ?) OR (SEARCH(_Ryobject.design_propsheet_file) = ?)) THEN DO:
        /* Reset the cursor for user input.*/
        RUN adecomm/_setcurs.p ("").
        MESSAGE "Cannot open or create the dynamic object." SKIP(1)
                "The dynamic object's template file or property sheet procedure could not be found."
                "Check that the appropriate custom object files (.cst) are loaded"
                "and the files specified for the template and property sheet can be"
                "found in the PROPATH."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ASSIGN AbortImport = Yes.
        RUN dynsucker_cleanup. /* Close everything qssucker does */
        RETURN "_ABORT":U.
      END. /* Can't find template or prop sheet. */

    END.
    
  END.  /* DO ON ERROR */

END PROCEDURE.

/* rydynsckrp.p - end of file */
