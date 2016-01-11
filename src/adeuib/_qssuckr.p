/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _qssuckr.p

Description:
    Suck in QUICK SAVE code -- This regenerates a UIB session.

Input Parameters:
   open_file - File name (should be a .w file) to suck in.
               For web files, this contains both the relative and absolute path
   web_temp_file - Web temp file (should be a .w file) to suck in.
   import_mode - Mode for operation.
                  "WINDOW" - open a .w file (Window or Dialog Box)
                  "WINDOW UNTITLED" - open a .w file but don't save the
                             name (open as UNTITLED).
                  "IMPORT" - import from an EXPORT (Copy to File) action
                  "Window-Silent" - same as "WINDOW" but nothing is visualized
                             on the screen.  This is useful when a batch of
                             objects are being converted programatically.
   from_schema - True if processing schema-picker output.
   
Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

History:
    Hutegger 3/94    Added support of Internal Procedures to 
                       "Insert File"-Feature
    Tullmann 6/94    Added Profiler code
    wood     6/28/96 Remove NO-BOX, NO-LABELS, NO-UNDERLINE support 
                       (because it did not work Bug # 96-06-24-033)
    gfs     02/17/98 Added COLUMN-RESIZABLE & COLUMN-MOVABLE for Browse.
    gfs     04/20/98 Added ROW-RESIZABLE for Browse.
    hd      06/03/98 Added shutdown-sdo to kill SDO's started in _rd*.    
    SLK     06/03/98 Added support for SDO's USER-LIST stored in _BC not _U.    
    HD      06/19/98 Don't show dummy wizard for _file-type 'HTML' in design mode.
    HD      07/10/98 Read 'user' from runtime settings             
    HD      07/10/98 APPLY "WINDOW-CLOSE" to _h_win if _abort from wizard (XFTR).             
    HD      10/05/98 RUN wind-close in_h_uib when _abort from _rd* or wizard (XFTR).             
    tsm     05/07/99 Added support for Most Recently Used FileList
    tsm     05/21/99 Added support for browse column visible attribute
    tsm     06/08/99 Added support for browse ALLOW-COLUMN-SCROLLING attribute
    tsm     06/11/99 Changed ALLOW-COLUMN-SCROLLING to COLUMN-SEARCHING
    tsm     06/14/99 Added support for browse SEPARATOR-FGCOLOR
    tsm     06/24/99 When setting _P._broker-url, use the broker url from 
                     the mru filelist if the file is being opened from it
    jep     08/08/00 Assign _P recid to newly created _TRG records.
    jep-icf 08/29/01 ICF support. Use of _RyObject to process NEW and OPEN
                     repository object requests. Added procedures
                     setRepositoryObject and processRepositoryObject as part
                     of this support.
    jep-icf 09/27/01 IZ 1927 - If can't find template file or property sheet
                     procedure for a dynamic object, we can't open it.
    jep-icf 10/11/01 IZ 2467 - Open object cannot open Static SDV.
                     Fix: processRepositoryObject now adds the object_extension
                     to the file to open (input parameter open_file).
    Hunter  03/05/02 Add "silent" mode to the "WINDOW"s import mode.
    
    Hanter  12/18/02 Added code submitted by Alan J Copeland of OPENLOGISTIX 
                     SYSTEMS LIMITED to make sure delimiters are properly 
                     written and read to static objects for RADIO-SETS, 
                     SELECTION-LISTS and COMBO-BOXes.  (IZ 8044)
---------------------------------------------------------------------------- */

{adecomm/oeideservice.i}
{adeuib/timectrl.i}  /* Controls inclusion of profiling code */
{adecomm/adefext.i}

DEFINE INPUT PARAMETER open_file AS CHAR NO-UNDO .
                         /* File to open                                     */
DEFINE INPUT PARAMETER web_temp_file AS CHAR NO-UNDO .
                         /* Web / dynamic file contents in a temp file       */
DEFINE INPUT PARAMETER import_mode  AS CHAR NO-UNDO .
                         /* "WINDOW", "WINDOW UNTITLED" or "IMPORT"          */
DEFINE INPUT PARAMETER from_schema  AS LOGICAL NO-UNDO.
                         /* True if processing schema-picker output          */

{adeuib/uniwidg.i}       /* Universal Widget TEMP-TABLE definition           */
{adeuib/triggers.i}      /* Trigger TEMP-TABLE definition                    */
{adeuib/xftr.i}          /* XFTR TEMP-TABLE definition                       */
{adeuib/layout.i}        /* Layout temp-table definitions                    */
{adeuib/name-rec.i NEW}  /* Name indirection table                           */
{adeuib/sharvars.i}      /* Shared variables                                 */
{adeuib/frameown.i NEW}  /* Frame owner temp table definition                */
{adecomm/adeintl.i}
{adeshar/mrudefs.i}      /* MRU FileList shared vars and temp table definition */
{src/adm2/globals.i}     /* Dynamics global variable */
{adeweb/web_file.i}

/* Standard End-of-line character */
&Scoped-define EOL &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN "~r" + &ENDIF CHR(10)

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

DEFINE NEW SHARED VAR _inp_line      AS CHAR       EXTENT 100          NO-UNDO.
DEFINE NEW SHARED STREAM _P_QS.
DEFINE NEW SHARED STREAM _P_QS2.
DEFINE NEW SHARED VAR adj_joincode   AS LOGICAL    INITIAL NO          NO-UNDO.
DEFINE NEW SHARED VAR _can_butt      AS CHAR       INITIAL ?           NO-UNDO.
DEFINE NEW SHARED VAR _def_butt      AS CHAR       INITIAL ?           NO-UNDO.
DEFINE NEW SHARED VAR tab-number     AS INTEGER                        NO-UNDO.
DEFINE NEW SHARED VAR VbxChoice      AS CHARACTER  INITIAL "_VBX-1":U  NO-UNDO.
DEFINE NEW SHARED VAR OCX-Tab-Info   AS CHARACTER  INITIAL ?           NO-UNDO.
DEFINE NEW SHARED VAR adm_version    AS CHARACTER                      NO-UNDO.
DEFINE NEW SHARED VAR cDataFieldMapping AS CHARACTER                   NO-UNDO.

/* ok to load if not connected to the backend database that made the qs file */ 
DEFINE NEW SHARED VAR ok_to_load     AS LOG                            NO-UNDO.
DEFINE NEW SHARED VAR dot-w-file     AS CHAR   FORMAT "X(40)"          NO-UNDO.

DEFINE VARIABLE added_fields  AS     CHAR                              NO-UNDO.
DEFINE VARIABLE assign_attr   AS     CHAR                              NO-UNDO.
DEFINE VARIABLE block_pointer AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE cBrokerURL    AS     CHAR                              NO-UNDO.
DEFINE VARIABLE count_tmp     AS     INTEGER
                              EXTENT {&WIDGET-COUNT-DIMENSION}         NO-UNDO.
DEFINE VARIABLE err_msgs      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE f_bar_pos     AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE file_version  AS     CHAR                              NO-UNDO.
DEFINE VARIABLE file_ext      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE _frame_name   AS     CHAR                              NO-UNDO.
DEFINE VARIABLE ldummy        AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE settings      AS     CHAR                              NO-UNDO.
DEFINE VARIABLE temp_file     AS     CHARACTER  INITIAL ""             NO-UNDO.
DEFINE VARIABLE temp-name     AS     CHAR                              NO-UNDO.
DEFINE VARIABLE pressed-ok    AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE h             AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE hfgp          AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_butt        AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_frame_init  AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_menu        AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_toggle      AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE h_xml         AS     WIDGET-HANDLE                     NO-UNDO.
DEFINE VARIABLE i             AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE j             AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE menu_recid    AS     RECID                             NO-UNDO.
DEFINE VARIABLE no-block-flag AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE par_menu_rec  AS     RECID                             NO-UNDO.
DEFINE VARIABLE stupid        AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE tmp-rec       AS     RECID                             NO-UNDO.
DEFINE VARIABLE wndw          AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE v_exists      AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE adv_choice    AS     CHAR                              NO-UNDO.
DEFINE VARIABLE adv_never     AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE dyn_widget    AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE dyn_offset    AS     INTEGER                           NO-UNDO.
DEFINE VARIABLE web_file      AS     LOGICAL                           NO-UNDO.
DEFINE VARIABLE dyn_object    AS     LOGICAL                           NO-UNDO. /* jep-icf */
DEFINE VARIABLE dyn_temp_file AS     CHARACTER                         NO-UNDO. /* jep-icf */
DEFINE VARIABLE isRyObject    AS     LOGICAL                           NO-UNDO. /* jep-icf */
DEFINE VARIABLE import_unnamedframe  AS LOGICAL                        NO-UNDO.
DEFINE VARIABLE notVisual      AS     LOGICAL                          NO-UNDO.
DEFINE VARIABLE ideSynchSilent AS LOGICAL                              NO-UNDO.
DEFINE NEW SHARED VARIABLE def_found  AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE NEW SHARED VARIABLE main_found AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE NEW SHARED VARIABLE cur_sect   AS INTEGER INITIAL {&TOPOFFILE}  NO-UNDO.
DEFINE NEW SHARED VARIABLE trig_found AS LOGICAL INITIAL FALSE         NO-UNDO.
DEFINE NEW SHARED VARIABLE ips_found  AS LOGICAL INITIAL FALSE         NO-UNDO.

DEFINE BUFFER l_U             FOR _U.
DEFINE BUFFER x_U             FOR _U.
DEFINE BUFFER x_P             FOR _P.
DEFINE BUFFER x_M             FOR _M.
DEFINE BUFFER x_L             FOR _L.
DEFINE BUFFER obj1_U          FOR _U.
DEFINE BUFFER obj2_U          FOR _U.
DEFINE BUFFER parent_NAME-REC FOR _NAME-REC.

DEFINE VAR FileHeader          AS CHAR INITIAL "" NO-UNDO.
DEFINE VAR AbortImport         AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VAR tCode               AS CHAR NO-UNDO.
DEFINE VAR Selected_Frames     AS INT  NO-UNDO.

DEFINE VAR cRelPathWeb         AS CHAR NO-UNDO INIT ?.
DEFINE VAR cSavePath           AS CHAR NO-UNDO INIT ?.

/* jep-icf: Process repository object requests. */
IF _DynamicsIsRunning THEN
DO:
  RUN processRepositoryObject.
  IF RETURN-VALUE = "_ABORT":U THEN RETURN "_ABORT":U.
END.
  
ASSIGN
  SESSION:NUMERIC-FORMAT = "AMERICAN":U
  web_file               = (web_temp_file <> "").
  

/* If import mode is Window-Silent or Synch-Silent turn notVisual to true.  */
/* This supports the reading in of windows that don't visualize for batch */
/* processing of multiple windows. */
/* Synch-Silent is set to also avoid database connect check when opening */
/* as part of _uibmain.p ide_syncFromAppbuilder (when not open in design)  */
IF import_mode = "Window-Silent":U or import_mode = "Synch-Silent":U THEN 
DO:
  ASSIGN ideSynchSilent = (import_mode = "Synch-Silent":U)
         import_mode = "Window"
         notVisual   = TRUE.
END.

/* If the mode is not WINDOW/IMPORT, put a message                        */
/* and abort importing the file.                                          */
IF CAN-DO("IMPORT,WINDOW,WINDOW UNTITLED":U, import_mode) EQ no THEN DO:
  MESSAGE "Unknown {&UIB_NAME} load mode " + import_mode + ". Aborting load." 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RETURN "_ABORT":U.
END.

/* Allow the user to choose the file to import. */
IF open_file = "" THEN DO:
  IF import_mode EQ "IMPORT":U 
  THEN RUN adecomm/_getfile.p (INPUT CURRENT-WINDOW, "uib", "Insert File", "Insert File", "OPEN", 
                               INPUT-OUTPUT dot-w-file,
                               OUTPUT pressed-ok).
  ELSE RUN adecomm/_getfile.p (INPUT CURRENT-WINDOW, "uib", "Open", "Open", "OPEN", 
                               INPUT-OUTPUT dot-w-file,
                               OUTPUT pressed-ok).
  dot-w-file = TRIM(dot-w-file).  
END. 
ELSE DO:
    IF NOT web_file THEN
        ASSIGN dot-w-file = open_file.
    ELSE DO:   
        /* for web-files, if we got the save-as-path, need to process it differently */
        IF ws-get-save-as-path ( INPUT open_file) EQ ? THEN /* doesn't contain a path */
           ASSIGN dot-w-file = open_file.
        ELSE DO:
           ASSIGN cRelPathWeb = ws-get-relative-path (INPUT open_file)
                  /* dot-w-file needs to be the full pathname */
                  dot-w-file = ws-get-absolute-path (INPUT open_file)
                  cSavePath = ws-get-save-as-path (INPUT open_file).
        END.
    END.
    ASSIGN pressed-ok = TRUE.
END.
              
/* Make sure we have the full pathname, so that we don't open the same
   file twice. Don't do this for web or dynamic repository objects. jep-icf */
IF NOT web_file AND NOT dyn_object THEN
  ASSIGN 
    FILE-INFO:FILE-NAME = open_file
    dot-w-file          = IF FILE-INFO:FULL-PATHNAME = ? THEN open_file ELSE FILE-INFO:FULL-PATHNAME.

IF NOT pressed-ok THEN RETURN "_ABORT":U.

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
     if on a remote WebSpeed file, the same broker URL and same save-as-path.
     For web files we will need to look at cRelPathWeb - we store the relative
     path returned by the WebSpeed agent
  */
  IF web_file THEN
     FIND x_P WHERE x_P._SAVE-AS-FILE EQ cRelPathWeb AND
          x_P._BROKER-URL EQ _BrokerURL AND
          x_P._save-as-path EQ cSavePath NO-ERROR.
  ELSE
      FIND x_P WHERE x_P._SAVE-AS-FILE EQ dot-w-file NO-ERROR.

  IF AVAILABLE x_P THEN DO:
    h = x_P._WINDOW-HANDLE.
    /* Get the real window for a dialog-box _U */
    IF h:TYPE ne "WINDOW":U THEN h = h:PARENT.
    RUN adecomm/_setcurs.p ("").
    /* Tell caller file already exists using "reopen" message. */
    RETURN "_REOPEN,":U + STRING(h).
  END.
END.

/* At this point, we are aware of the file that needs to be imported.  Run the
   analyzer and produce the .qs file. Open the .qs file and figure out if the
   import mode that is currently set will work on this file.  If not, ask the
   user if they would like to change the import mode.  This is necessary since
   the open_file could be a .w or .p or UIB exported file. The .qs file will
   be a temporary file name. This will ensure that the work is done in the
   temp directory
*/
RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB_QS}, OUTPUT temp_file).

/*
   The title of the window is based off the value in _save_file. So give _save_file the
   value of the dot-w-file.  If we are opening UNTITLED, then set this to ?.
*/
CASE import_mode:
  WHEN "WINDOW":U THEN _save_file = dot-w-file.
  WHEN "WINDOW UNTITLED":U THEN _save_file = ?.
END CASE.


/*  jep-icf: If dynamic object, dot-w-file contains only the object name. Since 
    it doesn't really exist (except as data in the repository), set the dot-w-file 
    variable to the name of a copy of the dynamic object's template file, which the 
    AB uses for opening such objects. Variable dot-w-file is set back to the object 
    name (stored in open_file) after the analyze is complete. */
IF dyn_object THEN
DO:
  ASSIGN dot-w-file = dyn_temp_file.
END.
              
/* Analyse and Verify the file we are looking at. If there is a problem
   then exit */
AbortImport = no.
{adeuib/vrfyimp.i} /* This Runs ANALYSE ... NO-ERROR. */

IF AbortImport THEN DO:
  RUN qssucker_cleanup.
  IF notVisual AND err_msgs NE "":U THEN
    RETURN "_ABORT ":U + err_msgs.
  ELSE RETURN "_ABORT":U.
END.

/* jep-icf: If dynamic object, reset variable dot-w-file to the object name. */
IF dyn_object THEN
DO:
  ASSIGN dot-w-file = open_file.
END.

/* Cannot PASTE when more than one frame is selected.*/
IF import_mode = "IMPORT":U THEN DO:
  FOR EACH _U WHERE _U._SELECTEDib AND CAN-DO("FRAME,DIALOG-BOX", _U._TYPE):
    ASSIGN selected_frames = selected_frames + 1.
  END.
  IF selected_frames > 1 THEN DO:
    MESSAGE "Cannot paste when more than one frame is selected."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RUN qssucker_cleanup.
    RETURN "_ABORT":U.
  END.
END.

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

  WHEN "IMPORT":U THEN DO:
    /* Save the initial FRAME in case we are importing a frame. */
    h_frame_init = _h_frame.
    
    /* If we are in IMPORT mode and _h_win is not set, put a
       message and abort importing the file. */
    IF _h_win = ? THEN DO:
      /* Reset the cursor for user input.*/
      RUN adecomm/_setcurs.p ("").
      MESSAGE "There is no current window to import an object." {&SKP}
        "Please open a window before importing."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RUN qssucker_cleanup. /* Close everything qssucker does */
      RETURN "_ABORT":U.
    END. /* Unknown Window */

    FIND FIRST _U WHERE _U._handle = _h_win.
    IF _U._TYPE = "DIALOG-BOX" THEN DO: /* DIALOG-BOX */
      /* Point to the real window behind our dialog-box frame.
         Note that _h_win is really a frame in this case. */
      CURRENT-WINDOW = _U._handle:PARENT.
      /* Safety check - h_frame should always be a valid-handle */
      IF (_h_frame = ?) THEN _h_frame = _U._HANDLE .  
    END. /* DIALOG-BOX */
    ELSE DO: /* Not a DIALOG-BOX */
      CURRENT-WINDOW = _U._WINDOW-HANDLE.
      IF (_h_frame = ?) THEN DO: /* Unknown Frame */
        FIND FIRST x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                   x_U._TYPE = "FRAME" no-error.
        IF AVAILABLE (x_U) THEN _h_frame = x_U._HANDLE.
        IF h_frame_init = ? THEN h_frame_init = _h_frame.
      END. /* Unknown Frame */
    END. /* Not a DIALOG-BOX */
    
    /* IF _h_frame has a custom tab order, then set tab-number to be the highest
       existing tab number                                                      */
    FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
    IF AVAILABLE _U THEN DO:
      FIND _C WHERE RECID(_C) = _U._x-recid.
      IF AVAILABLE _C AND _C._tabbing = "CUSTOM":U THEN DO:
        FOR EACH x_U WHERE x_U._PARENT-RECID = RECID(_U):
          tab-number = MAX(tab-number,x_U._TAB-ORDER).
        END.  /* For each x_U */
      END.  /* If avail _C and custom */
    END.  /* If available _U */
  END.  /* Importing a UIB EXPORTED file */

  OTHERWISE DO: /* This should not occur, since it is verified first */
    MESSAGE "Unknown import mode " + import_mode + ". Aborting import." 
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RUN qssucker_cleanup. /* Close everyting qssucker does */
    RETURN "_ABORT":U.
  END. /* Unknowm Import Format */
END CASE.

/* If we've got a structured WebSpeed v2.x file then we need to read the file 
   directly, a side-effect of the file format change for v2.x, since it doesn't 
   contain the correct end-of-block markers to be read by adeuib/_cdsuckr.p. */
IF file_version BEGINS "WDT_v2":U THEN DO:
  IF NOT AVAILABLE (_P) THEN
    CREATE _P.
  ASSIGN 
    _P._type         = "WebObject":U
    _P._adm-version  = file_version
    _P._file-version = file_version
    _P._editing      = "special-events-only":U
    _P._events       = "web.output,web.input":U.

  /* Create a design window for a 2.x file. */
  /** oe4ideisrunning _rdwind is NOT tested... 
     looking for a true wdt_v2 file...  
     (it is possibly one attached to a bug somewhere, problem with disappearing code )
      It is certain that _mkwind will not work, so let's give it a try   
      11.3.1 is release noted as not supported.  */
  if OEIDEIsRunning then 
      RUN adeweb/_rdwind.p (RECID(_P)).
  else
      RUN adeweb/_mkwind.p (RECID(_P)).
  FIND _U WHERE _U._HANDLE = _h_win.
  _U._PARENT-RECID = RECID(_U).
  
  /* Now read the file. */
  RUN adeweb/_cdread.p ((IF web_file THEN web_temp_file ELSE open_file), 
                        INTEGER(RECID(_P)), import_mode, file_version, "":U).

  /* If Treeview design window, refresh the Treeview. */
  RUN TreeViewUpdate.
  _h_win:VISIBLE = TRUE.
  IF _h_win:MOVE-TO-TOP() THEN 
    APPLY "ENTRY":U TO _h_win.
    
  /* Cleanup after ourselves. */
  RUN qssucker_cleanup.

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
  
  /* Add procedure to MRU Filelist */
  IF _mru_filelist THEN DO:
    ASSIGN cBrokerURL = IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL.
    RUN adeshar/_mrulist.p (open_file, IF web_file THEN cBrokerURL ELSE "":U).  
  END.  /* if _mru_filelist */

  RETURN.
END. /* WDT_v2 */

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
    /* It is also important to set the _P.object_type_code if available as
       these are used in the wizards                                        */
    IF AVAILABLE _RyObject THEN
      ASSIGN _P.object_type_code   = _ryObject.object_type_code
             _P.object_description = _ryObject.object_description.

    RUN adeuib/_rdproc.p (RECID(_P)).

    /* If we are reading this into an UNTITLED window, then the file is no
       longer a template.  It is an instance of a template */
    IF import_mode eq "WINDOW UNTITLED":U THEN _P._template = FALSE.
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
    _U._PARENT-RECID = RECID(_U).
  END. /* End of window creation block */
  
  IF _inp_line[1] BEGINS "&Scoped-Define ADM-DATAFIELD-MAPPING " THEN
  DO:
    cDataFieldMapping = SUBSTRING(_inp_line[1], 37, -1, "CHARACTER":U).
    REPEAT WHILE INDEX(_inp_line[1],"~~":U) > 0:
      IMPORT STREAM _P_QS _inp_line.
      cDataFieldMapping = cDataFieldMapping + _inp_line[1].
    END.  /* repeat */
    cDataFieldMapping = TRIM(REPLACE(cDataFieldMapping, "~~":U, "":U)).
  END.  /* if ADM-DATAFIELD-MAPPING */  

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
    WHEN "BW":U THEN DO:  /* Read static BROWSE information            */
       RUN adeuib/_rdbrow.p.      
    END.  /* END BW CASE */
      
    WHEN "BU":U THEN DO:  /* Read static BUTTON information             */
      RUN adeuib/_rdbutt.p.
    END.  /* END BU CASE */

    WHEN "CB":U THEN DO:  /* Read static Combo-Box information          */
      RUN adeuib/_rdcomb.p (from_schema).
    END.  /* END CB CASE */

    WHEN "ED":U THEN DO:  /* Read static Editor information             */
      RUN adeuib/_rdedit.p (from_schema).
    END.  /* END ED CASE */

    WHEN "FF":U THEN DO:  /* Read static Fill-in Field information      */
      RUN adeuib/_rdfill.p ("", from_schema).
    END.  /* END FF CASE */

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
          RUN qssucker_cleanup. /* Close everything qssucker does */
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
           _h_menu_win (because the dialog-box _h_win was not created
           when the menus were built).  Reparent them*/
        FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_menu_win AND
                          x_U._TYPE BEGINS "MENU":
          x_U._WINDOW-HANDLE = _U._HANDLE.
        END.
      END.
    END.  /* END FR CASE */

    WHEN "IM":U THEN DO: /* Read static Image information               */
      RUN adeuib/_rdimag.p.
    END.  /* END IM CASE */

    WHEN "LI":U THEN DO: /* Read static TEXT (Litteral) information     */
      RUN adeuib/_rdtext.p (from_schema).
    END.  /* END LI CASE */

    WHEN "MC":U THEN DO: /* Read static Menu Cascade information        */
      IMPORT STREAM _P_QS2 _inp_line.
      CREATE _U.
      CREATE _M.
      CREATE _NAME-REC.
      ASSIGN _U._LABEL         = _inp_line[1]
             _U._LABEL-ATTR    = IF _inp_line[2] = ? THEN "" ELSE _inp_line[2]
             _U._SENSITIVE     = IF _inp_line[3] = "y" THEN FALSE ELSE TRUE
             _U._TYPE          = "SUB-MENU"
             _U._x-recid       = RECID(_M)
             _U._WINDOW-HANDLE = IF _h_win = ? THEN _h_menu_win ELSE _h_win
             _U._WIN-TYPE      = _cur_win_type
             _M._PARENT-RECID  = par_menu_rec
             _U._PARENT-RECID  = par_menu_rec
             _NAME-REC._wNAME  = _inp_line[4]
             _NAME-REC._wTYPE  = _U._TYPE
             _NAME-REC._wFRAME = ?       /* SUB-MENUs have a unique name */
             _NAME-REC._wRECID = RECID(_U).
      VALIDATE _NAME-REC.
      /* Make sure the name doesn't exist already */
      RUN adeshar/_bstname.p 
              (_NAME-REC._wNAME, ?, "", 0, _h_win, OUTPUT _U._NAME).
      VALIDATE _U.
      VALIDATE _M.
      FIND LAST x_M WHERE x_M._parent-recid  = par_menu_rec AND
                          x_M._sibling-recid = ? AND
                          RECID(x_M)        NE RECID(_M) NO-ERROR.
      IF AVAILABLE x_M THEN DO:
        x_M._sibling-recid = RECID(_U).
        VALIDATE x_M.
      END.
      ELSE DO:   /* This is the first child of the parent menu        */
        FIND x_U WHERE RECID(x_U) = par_menu_rec.
        FIND x_M WHERE RECID(x_M) = x_U._x-recid.
        x_M._child-recid = RECID(_U).
        VALIDATE x_M.
      END.
    END.  /* END MC CASE */

    WHEN "MI":U THEN DO: /* Read static Menu Item information           */
      IMPORT STREAM _P_QS2 _inp_line.
      CREATE _U.
      CREATE _M.
      CREATE _NAME-REC.
      ASSIGN _U._LABEL         = _inp_line[1]
             _U._LABEL-ATTR    = IF _inp_line[2] = ? THEN "" ELSE _inp_line[2]
             _U._SENSITIVE     = IF _inp_line[4] = "y" THEN FALSE ELSE TRUE
             _U._TYPE          = "MENU-ITEM"
             _U._x-recid       = RECID(_M)
             _U._WINDOW-HANDLE = IF _h_win = ? THEN _h_menu_win ELSE _h_win
             _U._WIN-TYPE      = _cur_win_type
             _M._ACCELERATOR   =  IF _inp_line[7] = ? THEN "" ELSE _inp_line[7]
             _U._SUBTYPE       = "NORMAL"
             _M._PARENT-RECID  = par_menu_rec
             _U._PARENT-RECID  = par_menu_rec
             _NAME-REC._wNAME  = _inp_line[3]
             _NAME-REC._wTYPE  = _U._TYPE
             _NAME-REC._wFRAME = ?       /* MENU-ITEMs have a unique name */
             _NAME-REC._wRECID = RECID(_U).
      VALIDATE _NAME-REC.
      /* Make sure the name doesn't exist already */
      RUN adeshar/_bstname.p 
              (_NAME-REC._wNAME, ?, "", 0, _h_win, OUTPUT _U._NAME).
      VALIDATE _U.
      VALIDATE _M.
      
      IF _inp_line[5] = "y" THEN _U._SUBTYPE = "TOGGLE-BOX".
      FIND LAST x_M WHERE x_M._parent-recid  = par_menu_rec AND
                          x_M._sibling-recid = ? AND
                          RECID(x_M)        NE RECID(_M) NO-ERROR.
      IF AVAILABLE x_M THEN DO:
        x_M._sibling-recid = RECID(_U).
        VALIDATE x_M.
      END.
      ELSE DO:   /* This is the first child of the parent menu */
        FIND x_U WHERE RECID(x_U) = par_menu_rec.
        FIND x_M WHERE RECID(x_M) = x_U._x-recid.
        x_M._child-recid = RECID(_U).
        VALIDATE x_M.
      END.
    END.  /* END MI CASE */

    WHEN "ML":U OR WHEN "MS":U THEN DO: /* Read static Menu SKIP OR RULE    */
      CREATE _U.
      CREATE _M.
      ASSIGN _U._LABEL         = IF _inp_line[1] = "MS" THEN "SKIP" ELSE "RULE"
             _U._NAME          = ""
             _U._SUBTYPE       = _U._LABEL
             _U._SENSITIVE     = TRUE
             _U._TYPE          = "MENU-ITEM"
             _U._x-recid       = RECID(_M)
             _U._WINDOW-HANDLE = IF _h_win = ? THEN _h_menu_win ELSE _h_win
             _U._WIN-TYPE      = _cur_win_type
             _M._PARENT-RECID  = par_menu_rec
             _U._PARENT-RECID  = par_menu_rec.
      VALIDATE _U.
      VALIDATE _M.

      FIND LAST x_M WHERE x_M._parent-recid  = par_menu_rec AND
                          x_M._sibling-recid = ? AND
                          RECID(x_M)         NE RECID(_M) NO-ERROR.
      IF AVAILABLE x_M THEN DO:
        x_M._sibling-recid = RECID(_U).
        VALIDATE x_M.
      END.
      ELSE DO:   /* This is the first child of the parent menu */
        FIND x_U WHERE RECID(x_U) = par_menu_rec.
        FIND x_M WHERE RECID(x_M) = x_U._x-recid.
        x_M._child-recid = RECID(_U).
        VALIDATE x_M.
      END.
    END.  /* END ML CASE */

    WHEN "MU":U THEN DO: /* Read static Menu information            */
      FIND _NAME-REC WHERE _NAME-REC._wNAME = _inp_line[2] AND
                           _NAME-REC._wTYPE = "SUB-MENU" NO-ERROR.
      /* Have we found a cascading menu that we have already defined */
      IF AVAILABLE _NAME-REC THEN DO:
        ASSIGN par_menu_rec      = _NAME-REC._wRECID.
        IMPORT STREAM _P_QS2 _inp_line.
      END.
      ELSE DO:
        /* The menu is not a previously defined sub-menu.  It could still be
           a POPUP-MENU for the window (which we defined when we read in the
           CREATE WINDOW statement. */
        FIND _NAME-REC WHERE _NAME-REC._wNAME = _inp_line[2] AND
                             _NAME-REC._wTYPE = "MENU" NO-ERROR.
        IF NOT AVAILABLE _NAME-REC THEN DO:
          CREATE _U.
          CREATE _NAME-REC.
          ASSIGN _U._TYPE          = "MENU"
                 _NAME-REC._wNAME  = _inp_line[2]
                 _NAME-REC._wTYPE  = _U._TYPE
                 _NAME-REC._wFRAME = ?       /* MENUs have a unique name */
                 _NAME-REC._wRECID = RECID(_U).
          VALIDATE _NAME-REC.
          /* Make sure the name doesn't exist already */
          RUN adeshar/_bstname.p 
                  (_NAME-REC._wNAME, ?, "", 0, _h_win, OUTPUT _U._NAME).
        END.
        ELSE FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.

        CREATE _M.
        ASSIGN _U._WINDOW-HANDLE = IF _h_win = ? THEN _h_menu_win ELSE _h_win
               _U._WIN-TYPE      = _cur_win_type
               par_menu_rec      = RECID(_U)
               _U._x-recid       = RECID(_M).
        IMPORT STREAM _P_QS2 _inp_line.
        _U._LABEL = IF _inp_line[1] NE ? THEN _inp_line[1] ELSE "".
        ASSIGN _U._SUBTYPE =  IF _inp_line[7] EQ "y" THEN "MENUBAR"
                              ELSE "POPUP-MENU".
        IF _U._SUBTYPE = "MENUBAR" THEN DO:
          FIND x_U WHERE x_U._HANDLE = _h_win NO-ERROR.
          IF NOT AVAILABLE x_U THEN DO:
            /* Reset the cursor for user input.*/
            RUN adecomm/_setcurs.p ("").
            MESSAGE "Window record not found for menu.".
          END.
          ELSE DO: 
            FIND _C WHERE RECID(_C) = x_U._x-recid.
            ASSIGN _U._PARENT-RECID = RECID(x_U)
                   _C._MENU-RECID   = RECID(_U).
          END.
        END.
        VALIDATE _U.
        VALIDATE _M.
      END.
    END.  /* END MU CASE */

    WHEN "RC":U THEN DO: /* Read static Rectangle information       */
      RUN adeuib/_rdrect.p.
    END.  /* END RC CASE */

    WHEN "RS":U THEN DO: /* Read static Radio Set information       */
      RUN adeuib/_rdradi.p (from_schema).
      IF RETURN-VALUE = "EOF" THEN LEAVE WIDGET-LOOP.
    END.  /* END RS CASE */

    WHEN "SE":U THEN DO: /* Read static Select-List information     */
      RUN adeuib/_rdsele.p (from_schema).
    END.  /* END SE CASE */

    WHEN "SL":U THEN DO: /* Read static Slider information          */
      RUN adeuib/_rdslid.p (from_schema).
    END.  /* END SL CASE */

    WHEN "TB":U THEN DO: /* Read static Toggle Box information      */
      RUN adeuib/_rdtogg.p (from_schema).
    END.  /* END TB CASE */

    WHEN "VT":U THEN DO:  /* Read Text Variable as fill-in with subtype "TEXT" */
         RUN adeuib/_rdfill.p ("TEXT", from_schema).
    END.  /* END FF CASE */

    OTHERWISE NEXT WIDGET-LOOP.
  END CASE.
  
  IF RETURN-VALUE = "_ABORT":U THEN DO:
    IF VALID-HANDLE(_h_win) THEN 
       RUN wind-close IN _h_uib (INPUT _h_win).   
    RUN qssucker_cleanup. /* Close everything qssucker does */
    RETURN "_ABORT":U.
  END.

  /* Force entry into field level widgets to make its frame stay on top for   */
  /* MOTIF only                                                               */
  &IF "{&WINDOW-SYSTEM}" = "OSF/MOTIF" &THEN
    IF _h_cur_widg NE ? THEN DO:
      IF CAN-DO( 
   "BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX",
       _h_cur_widg:TYPE) THEN stupid = _h_frame:MOVE-TO-TOP().
    END.
  &ENDIF

END.  /* WIDGET-LOOP */

/* In 7.2A - 7.2D, we assumed that recently created variables were NOT
   displayed.  In 7.3A we assume they are.  SO...if the input file was
    from UIB_v7r9 then invert the default value of _U._DISPLAY. */
IF file_version eq "UIB_v7r9":U THEN DO:
  FOR EACH _NAME-REC WHERE 
    CAN-DO( "BUTTON,COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX",
            _NAME-REC._wTYPE):
     FIND _U WHERE RECID(_U) eq _NAME-REC._wRECID.
     _U._DISPLAY = NO.
  END. 
END.

/* Finished reading the analyzer definitions, reset file to begining of code  */
/* block information                                                          */
INPUT STREAM _P_QS2 CLOSE.

ASSIGN AbortImport = no.

/* Discard the db and table names for unmapped Web object fields. */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _h_win AND
                  _U._STATUS        eq "NORMAL":U AND
                  _U._DBNAME        eq "Temp-Tables":U AND
                  _U._TABLE         eq "{&WS-TEMPTABLE}":U:
  ASSIGN
    _U._DBNAME = ?
    _U._TABLE  = ?.
END.

/* Read in all the SUSPENDED sections.  */  
RUN analyze-suspend-reader.

IF AbortImport THEN DO:
  RUN wind-close IN _h_uib (INPUT _h_win).
  RUN qssucker_cleanup.
  RETURN "_ABORT":U.
END.

/* Adjust column labels for all frames without side-labels */
FOR EACH _U WHERE _U._TYPE eq "FRAME":U
              AND _U._STATUS ne "DELETED":U
              AND _U._WINDOW-HANDLE eq _h_win:
  FIND _L WHERE RECID(_L) = _U._lo-recid.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  IF NOT _C._SIDE-LABELS AND NOT _L._NO-LABELS THEN DO:
     ASSIGN _h_frame       = _U._HANDLE
            _h_cur_widg    = _h_frame.   
     IF NOT from_schema THEN RUN adeuib/_adjclbl.p (INPUT _h_frame, INPUT FALSE).
     f_bar_pos      = _C._FRAME-BAR:Y.
     FOR EACH x_U WHERE x_U._PARENT-RECID = RECID(_U) AND
              NOT x_U._NAME BEGINS "_LBL" AND
              x_U._STATUS NE "DELETED":
       RUN adeuib/_chkpos.p (INPUT x_U._HANDLE).
       FIND l_U WHERE RECID(l_U) = x_U._l-recid NO-ERROR.
       IF AVAILABLE l_U THEN DO:
         ASSIGN f_bar_pos = _C._FRAME-BAR:Y
                i = l_U._HANDLE:Y + l_U._HANDLE:HEIGHT-P - f_bar_pos.
         IF i > 0 THEN DO:
           RUN adeuib/_exphdr.p (INPUT i).
           IF l_U._HANDLE:Y + l_U._HANDLE:HEIGHT-P > _C._FRAME-BAR:Y THEN
             l_U._HANDLE:Y = MAX(0,_C._FRAME-BAR:Y - l_U._HANDLE:HEIGHT-P - 2).
         END.
       END.
       FIND x_L WHERE RECID(x_L) = x_U._lo-recid.
       x_L._ROW = x_U._HANDLE:ROW / x_L._ROW-MULT.
     END.
  END.
END.

/* Instantiate Menus (that aren't already instantiated). */
FOR EACH _U WHERE _U._TYPE = "MENU":U AND _U._WINDOW-HANDLE = _h_win:
  /* Does the menu already exist? Or does it need to be recreated? */
  IF NOT VALID-HANDLE(_U._HANDLE) THEN DO:
    ASSIGN menu_recid = RECID(_U).
    RUN adeuib/_updmenu.p (INPUT FALSE, INPUT menu_recid, OUTPUT h_menu).
    /* Find the Parent of this menu */
    FIND x_U WHERE RECID(x_U) = _U._PARENT-RECID.
    IF x_U._TYPE = "WINDOW":U AND _U._SUBTYPE = "MENUBAR":U THEN
      ASSIGN x_U._HANDLE:MENUBAR = h_menu.
    ELSE
      IF x_U._HANDLE:TYPE NE "TEXT":U THEN    /* May be a tty mode window */
        ASSIGN x_U._HANDLE:POPUP-MENU = h_menu.
  END.
END.

IF _h_frame = ? and _h_win = ? THEN DO:
  RUN adecomm/_setcurs.p ("").

  MESSAGE "Aborting import." 
         VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  RUN qssucker_cleanup. /* Close everything qssucker does */
  RETURN "_ABORT":U. 
END.

/* A valid file should always have a Custom Definitions and Main-Code block 
   (even if they are empty).  As protection, make sure we have these sections
   even if one was not in the input file. [Note - don't add these sections 
   if we are importing a section of .w file]. */
IF import_mode <> "IMPORT" AND ((def_found = no) OR (main_found = no)) THEN DO:
  FIND _U WHERE _U._HANDLE = _h_win.
  IF NOT def_found THEN DO:
    CREATE _TRG.
    ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
           _TRG._tSECTION = "_CUSTOM":U
           _TRG._wRECID   = RECID(_U)
           _TRG._tEVENT   = "_DEFINITIONS":U.
    RUN adeshar/_coddflt.p ("_DEFINITIONS":U, RECID(_U), OUTPUT _TRG._tCODE). 
  END.
  IF NOT main_found THEN DO:
    CREATE _TRG.
    ASSIGN _TRG._pRECID   = (IF AVAIL(_P) THEN RECID(_P) ELSE ?)
           _TRG._tSECTION = "_CUSTOM":U
           _TRG._wRECID   = RECID(_U)
           _TRG._tEVENT   = "_MAIN-BLOCK":U
           _TRG._tCODE    = "". 
  END.
END.

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
                    parent_NAME-REC._wRECID eq _U._parent-recid) THEN
    DO:
      ASSIGN _U._HANDLE:SELECTED = YES
             _U._SELECTEDib      = YES.

      /* Check for widget id conflicts and reassign widget ids if there
         are conflicts. */
      IF LOOKUP(_U._TYPE, "FRAME,DIALOG-BOX":U) = 0 THEN
      DO:
        /* If widget id is already set check for conflicts and reassign it
           if there is a conflict and _widgetid_assign is true */
        IF _U._WIDGET-ID NE ? THEN
        DO:
          /* Browse widgets are treated like frame widgets for assignment
             of widget ids */
          IF _U._TYPE = "BROWSE":U THEN
          DO:
            IF DYNAMIC-FUNCTION("widgetIDFrameConflict":U IN _h_func_lib,
                                INPUT _h_win,
                                INPUT _U._WIDGET-ID,
                                INPUT RECID(_U)) THEN
              _U._WIDGET-ID = IF _widgetid_assign THEN DYNAMIC-FUNCTION("nextFrameWidgetID":U IN _h_func_lib,
                                                                        INPUT _h_win)
                                ELSE ?.
          END.  /* browse */
          ELSE DO:
            IF DYNAMIC-FUNCTION("widgetIDConflict":U IN _h_func_lib,
                                INPUT _U._parent-recid,
                                INPUT _U._WIDGET-ID,
                                INPUT RECID(_U)) THEN
              _U._WIDGET-ID = IF _widgetid_assign THEN DYNAMIC-FUNCTION("nextWidgetID":U IN _h_func_lib,
                                                                        INPUT _U._parent-recid,
                                                                        INPUT RECID(_U))
                              ELSE ?.
          END.  /* not browse */
        END.  /* widget id already set */
        /* If the widget id is not already set then set it if _widgetid_assign
           is true */
        ELSE IF _widgetid_assign THEN 
        DO:
          _U._WIDGET-ID = IF _U._TYPE = "BROWSE":U THEN 
                            DYNAMIC-FUNCTION("nextFrameWidgetID":U IN _h_func_lib,
                                             INPUT _h_win)
                          ELSE DYNAMIC-FUNCTION("nextWidgetID":U IN _h_func_lib,
                                                 INPUT _U._parent-recid,
                                                 INPUT RECID(_U)).
        END.  /* else if */
      END.  /* if not frame or dialog box */
      
    END.
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
RUN qssucker_cleanup.

/* Now force the current window visible and on the screen.  This gets around
   bug where the some other window-system window has moved to the foreground. */
FIND _U WHERE _U._HANDLE eq _h_win.
IF _U._TYPE = "DIALOG-BOX" THEN h = _U._HANDLE:PARENT. /* the "real" window */
ELSE h = _h_win.

/* Don't show the dummy wizard for HTML files in design mode. */
IF (NOT AVAILABLE (_P) OR _P._file-type <> "HTML" OR _P._TEMPLATE) AND
  NOT notVisual THEN
DO:  
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
   IF _P._TYPE EQ "SmartBrowser" AND _P._ADM-VERSION > "ADM1" THEN DO:
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
 
/* 'Realize' all XFTR's in this .W */
IF import_mode ne "IMPORT" THEN DO:
  IF NOT AVAILABLE(_P) THEN 
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.

  /* Make sure we know where to save the file we've just opened. If the file was opened 
    from the MRU file list, store that brokerurl rather than the current brokerurl */
  IF web_file THEN DO:
    _P._broker-url = IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL.
    IF cRelPathWeb NE ? THEN DO:
        _P._SAVE-AS-file = cRelPathWeb.
        IF cSavePath NE ? AND cSavePath NE "" THEN DO:
           /* if the full name matches the relative, then it is not a relative path
              to the PROPATH on the server - so leave _save-as-path alone.
              Otherwise, store just the path part of the full name into _save-as-path
           */
           _P._save-as-path = cSavePath.
        END.
    END.
  END.

  FOR EACH _XFTR WHERE _XFTR._wRECID = _P._u-RECID:
    FIND _TRG WHERE _TRG._xRecid = RECID(_XFTR) NO-ERROR.
    IF AVAILABLE _TRG AND _XFTR._realize NE ? THEN 
    DO ON STOP UNDO, LEAVE:
      ASSIGN tcode = _TRG._tCode.
      RUN VALUE(_XFTR._realize) (INPUT INT(RECID(_TRG)), INPUT-OUTPUT tcode).
      IF RETURN-VALUE = "_ABORT":U THEN DO:  /* Cancel was pressed */
        FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
          DELETE _TT.
        END.
        
        /* Let the AppBuilder (_uibmain.p) do the cleanup. */ 
        ASSIGN _P._file-saved = YES.
        RUN wind-close in _h_uib (_h_win).
        RUN mru_menu IN _h_uib.  /* Need to rebuild MRU filelist for previewed
                                    Detail and Report objects created w/ wizards */

        /**  This code left the _h_win with an invalid value 
             which caused error message in enable_widgets
        IF VALID-HANDLE(_P._tv-proc) THEN DO:
          APPLY "CLOSE" TO _P._tv-proc.
          IF VALID-HANDLE(_P._tv-proc) THEN
            DELETE PROCEDURE _P._tv-proc NO-ERROR.
        END.
        DELETE _P.
        RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash */).
        **/
        RUN qssucker_cleanup. /* Close everything qssucker does */
        RETURN "_ABORT":U.
      END.  /* If cancel was pressed */
      IF AVAILABLE _TRG THEN ASSIGN _TRG._tCode = tCode.
    END.
  END.     

  /* Send event to notify anyone interested that the UIB has opened a file.
     Note that opening a window UNTITLED counts as a NEW event.  */
  CASE import_mode:
    WHEN "WINDOW":U THEN
      /* File is being reload from the OEIDE */
      IF PROGRAM-NAME(2) BEGINS "syncFromIDE" THEN 
        ldummy = TRUE.
      ELSE
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
    /*  Remember that for web files, open_file may contain the file name plus the path, 
       if provided 
    */
    RUN adeshar/_mrulist.p (open_file, IF web_file THEN cBrokerURL ELSE "":U).  
  END.  /* if import_mode and _mru_filelist */
  
END. /* IF import_mode ne "IMPORT"  */ 

/* The _rd* procedures may have started an sdo */
DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
 
/* If Treeview design window, refresh the Treeview. */
RUN TreeviewUpdate.

/* jep-icf: Set some repository object related values. */
RUN setRepositoryObject.

RETURN.

/****************************** Internal Procedures ***************************/


PROCEDURE qssucker_cleanup:
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
  IF web_file THEN
    OS-DELETE VALUE(web_temp_file).

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

PROCEDURE analyze-suspend-reader :  
  DEFINE VARIABLE done AS LOGICAL NO-UNDO.

  /* If we are importing unnamed frame or a dialog box, remember to reset
     to the originally selected frame so that any Queries or SmartObjects
     will import onto the correct default frame (or Window). Remember that
     _h_frame eq ? implies we are importing to the window as a parent. */

  /* Just checking if we are importing is not enough. So we check the
     import_unnamedframe variable as well. -jep 19990722-050 / 19991223-015 */
 IF import_mode = "IMPORT":U AND import_unnamedframe THEN
   ASSIGN _h_frame = h_frame_init.

  DIRECTION-LOOP:
  REPEAT ON ENDKEY UNDO DIRECTION-LOOP, LEAVE DIRECTION-LOOP:
    /* Read the next line */
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.

    CASE _inp_line[1]:

      WHEN "_QUERY-BLOCK" THEN DO:    /* Read Query stuff for Browsers & frames */
        RUN adeuib/_rdqury.p (INPUT file_version).       
        IF RETURN-VALUE = "_ABORT":U THEN DO:
           ASSIGN AbortImport = TRUE.
           RUN qssucker_cleanup. /* Close everything qssucker does */
           RETURN "_ABORT":U.
        END.
      END.  /* _QUERY-BLOCK CASE */

      WHEN "_UIB-PREPROCESSOR-BLOCK" THEN DO:
        /* We are in the Preprocessor section.  We only need to parse it if we
           are NOT in IMPORT mode. */ 
        ASSIGN cur_sect = {&STDPREPROCS}
               DONE = (import_mode eq "IMPORT":U).

        REPEAT WHILE NOT DONE:
          _inp_line = "".
          IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].

          /* Does this list the ADM-SUPPORTED-LINKS?  Note: SmartContainer 
             links are not read here.  They are read in the Procedure Settings.*/
          IF _inp_line[1] BEGINS "&Scoped-define ADM-SUPPORTED-LINKS ":U THEN DO:
            FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
            IF NOT CAN-DO(_P._allow,"Smart") THEN 
             _P._links = SUBSTRING(_inp_line[1], 35, -1, "CHARACTER":U).
          END.
          /* Is the WEB-FILE defined? */
          ELSE IF _inp_line[1] BEGINS "&Scoped-define WEB-FILE ":U THEN DO:
            _P._html-file = TRIM(SUBSTRING(_inp_line[1], 24, -1, "CHARACTER":U)).
            /*
            IF LOOKUP("HTML-Mapping":U, _P._type-list) eq 0 THEN
              _P._type-list = _P._type-list + ",Html-Mapping":U.
            */
          END.
          ELSE IF _inp_line[1] BEGINS "&Scoped-define WIDGETID-FILE-NAME ":U THEN
              ASSIGN _p._widgetid-file-name = TRIM(SUBSTRING(_inp_line[1], 34, -1, "CHARACTER":U)).
           /* Get FRAME-NAME pre-processor definition */
          ELSE IF _inp_line[1] BEGINS  "/* Name of first Frame and/or Browse":U OR 
                  _inp_line[1] BEGINS  "/* Name of designated FRAME-NAME":U  THEN 
          DO:
            IMPORT STREAM _P_QS _inp_line.
            IF _inp_line[1] EQ "&Scoped-define":U AND 
               _inp_line[2] EQ "FRAME-NAME":U    THEN
            DO:
               FIND _U WHERE _U._NAME = TRIM(_inp_line[3]) NO-ERROR.
               IF AVAIL _U THEN
               DO:
                   FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
                   ASSIGN _P._frame-name-recid = RECID(_U).
               END.
            END.
          END.
          /* Does this list the custom settings */
          ELSE IF _inp_line[1] BEGINS  "/* Custom List Definitions ":U THEN DO:
            IMPORT STREAM _P_QS _inp_line.
            /* If the next line is not a comment, then we have an older version
               of the .w file.  This is our "tag" so that we know we can read in
               the names of the lists */
            IF _inp_line[1] eq "/*" THEN DO:
              FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
              /* Check the length of the list for errors */
              IF NUM-ENTRIES(_inp_line[2]) eq {&MaxUserLists} 
              THEN _P._LISTS = _inp_line[2].
              ELSE MESSAGE "The names for User Lists could not be loaded." SKIP
                           "Names are being reset to LIST-1, LIST-2, etc."
                           VIEW-AS ALERT-BOX ERROR. 
            END.
            DONE = YES.  /* Nothing else to read here */
          END. 
          ELSE IF _inp_line[1] BEGINS "&Global-define DATA-LOGIC-PROCEDURE ":U THEN DO:
             FIND _U WHERE _U._HANDLE = _h_win.
             FIND _C WHERE RECID(_C) = _U._x-recid.
             ASSIGN _C._DATA-LOGIC-PROC = TRIM(SUBSTRING(_inp_line[1], 37, -1, "CHARACTER":U)).                                  
          END.
          ELSE IF _inp_line[1] BEGINS "&Scoped-define DATA-TABLE-NO-UNDO ":U OR 
              _inp_line[1] BEGINS "&Global-define DATA-TABLE-NO-UNDO ":U THEN
          DO:
            FIND _U WHERE _U._HANDLE = _h_win.
            FIND _C WHERE RECID(_C) = _U._x-recid.
            ASSIGN _C._RowObject-NO-UNDO = TRUE.
          END.
          ELSE IF _inp_line[1] BEGINS "&Global-define TABLE-NAME ":U THEN
          DO:
            FIND _U WHERE _U._HANDLE = _h_win.
            FIND _C WHERE RECID(_C) = _U._x-recid.
            ASSIGN _C._DATA-LOGIC-PROC-TABLE-BUFF = TRIM(SUBSTRING(_inp_line[1], 27, -1, "CHARACTER":U)).
          END.
          ELSE IF _inp_line[1] BEGINS "&Global-define DATA-LOGIC-TABLE ":U THEN
          DO:
            FIND _U WHERE _U._HANDLE = _h_win.
            FIND _C WHERE RECID(_C) = _U._x-recid.
            ASSIGN _C._DATA-LOGIC-PROC-BUFF-SUFFIX = TRIM(SUBSTRING(_inp_line[1], 33, -1, "CHARACTER":U)).
          END.
          ELSE IF _inp_line[1] BEGINS "&Global-define DATA-FIELD-DEFS ":U THEN
          DO:
            FIND _U WHERE _U._HANDLE = _h_win.
            FIND _C WHERE RECID(_C) = _U._x-recid.
            ASSIGN _C._DATA-LOGIC-PROC-INCLUDE = TRIM(TRIM(SUBSTRING(_inp_line[1], 32, -1, "CHARACTER":U)), '"').
          END.
          ELSE DONE = _inp_line[1] BEGINS "/* _UIB-PREPROCESSOR-BLOCK-END".
        END.
      END.

      WHEN "_UIB-CTRLTRIG-STUB" THEN ASSIGN cur_sect = {&CONTROLTRIG}.

      WHEN "_UIB-INTPROC-STUB" THEN ASSIGN cur_sect = {&INTPROCS}.   

      WHEN "_CREATE-WINDOW" THEN DO:  /* Already Read Window stuff             */
        ASSIGN cur_sect = {&CONTROLDEFS}.
        _inp_line[3] = " ".           /* Skip over it this time                */
        REPEAT WHILE NOT DONE:
          IMPORT STREAM _P_QS _inp_line.
          DONE =  LENGTH(_inp_line[3],"RAW":U) > 0 AND 
                     SUBSTRING(_inp_line[3],LENGTH(_inp_line[3],"CHARACTER":U),1,
                               "CHARACTER":U) EQ ".".
        END.
      END.  /* End window creation CASE */

      WHEN "_CREATE-DYNAMIC" THEN DO:  /* Container for OCX's */
        ASSIGN cur_sect = {&CONTROLDEFS}.
        RUN adeuib/_rdcont.p (_h_win, import_mode).
        IF RETURN-VALUE = "_ABORT" THEN DO:
          ASSIGN AbortImport = TRUE.
          RETURN "_ABORT".
        END.
      END.  /* End dynamic widget creation CASE */

      WHEN "_RUN-TIME-ATTRIBUTES" THEN DO:
          ASSIGN cur_sect = {&RUNTIMESET}.
          RUN read_run_time_attributes.   
      END.

      WHEN "_UIB-CODE-BLOCK":U THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.

        /* Look for the special Alternate-Layout Procedure. In 8.0a1p 
           (pre-release) and earlier, we based the name of the procedure 
           on the {&WINDOW-NAME}-LAYOUTS.  This was changed in 8.0a1 to
           look for _inp_lin[4] = "_LAYOUT-CASES"  [wood 9/27/95] */
        FIND _U WHERE _U._HANDLE EQ _h_win.          /* Needed for <= 8.0a1p */ 
        IF (_inp_line[4] = "_LAYOUT-CASES":U) OR
           (_inp_line[3] = _U._NAME + "-Layouts":U)  /* Needed for <= 8.0a1p */
           THEN RUN layout_reader.
        ELSE DO:
          cBrokerURL = IF NOT web_file THEN "" ELSE
                         (IF _mru_broker_url NE "" 
                          THEN _mru_broker_url ELSE _BrokerURL).

          RUN adeuib/_cdsuckr.p (import_mode, cBrokerURL).
        END.
      END.

      WHEN "_EXPORT-CODE-BLOCK" THEN DO:   /* Importing a SmartObject */
        /* There are some code blocks we only write out when we export a group
           of widgets.  One of these is the ADM-CREATE-OBJECTS that is needed
           to read SmartObjects back in. */
        IF _inp_line[2] eq "_ADM-CREATE-OBJECTS" THEN DO:
          FIND _U WHERE _U._HANDLE = _h_win.
          RUN adeuib/_rdsmar.p (RECID(_U)).
        END.      
      END.  /* End dynamic widget creation CASE */

      WHEN "_ANALYZER_BEGIN" THEN DO:
        INPUT STREAM _P_QS CLOSE.
        LEAVE DIRECTION-LOOP.
      END.

      WHEN "/*" THEN
        IF _inp_line[2] = "Procedure" AND _inp_line[3] = "Description" THEN
          RUN Get_Proc_Desc.
      
      OTHERWISE NEXT DIRECTION-LOOP.
  
    END CASE.  
  END. /* DIRECTION-LOOP */

/*_P._widgetid-file-name=? is used only when the window is created, when the window is re-opened, this value
  must have a valid file name, or it must be blank.*/
IF import_mode = "WINDOW":U AND _P._widgetid-file-name = ? THEN
    ASSIGN _P._widgetid-file-name = "":U.
END PROCEDURE.

PROCEDURE layout_reader:
  DEFINE BUFFER m_L FOR _L.
  
  DEFINE VARIABLE attrbt       AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE dVal         AS DECIMAL        NO-UNDO.
  DEFINE VARIABLE dVal2        AS DECIMAL        NO-UNDO.
  DEFINE VARIABLE dw_recid     AS RECID          NO-UNDO.
  DEFINE VARIABLE lSize2Parent AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE num_entries  AS INTEGER        NO-UNDO.
  DEFINE VARIABLE pos          AS INTEGER        NO-UNDO.
  DEFINE VARIABLE tmp_name     AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE val          AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE w_name       AS CHARACTER      NO-UNDO.
    
  DEFINE BUFFER dw_L FOR _L.
  
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.
 
  /* See if the current window is a Design Window. */
  FIND _U WHERE _U._HANDLE eq _h_win.
  IF _U._TYPE eq "WINDOW" AND _U._SUBTYPE eq "Design-Window":U 
  THEN dw_recid = RECID(_U).
  ELSE dw_recid = ?.
 
  DO WHILE _inp_line[1] NE "END" AND _inp_line[2] NE "PROCEDURE.":
    IF _inp_line[1] = "WHEN"
      AND CAN-FIND(_LAYOUT WHERE _LAYOUT._LO-NAME = _inp_line[2]) THEN 
    DO:
      FIND _LAYOUT WHERE _LAYOUT._LO-NAME = _inp_line[2].
      _LAYOUT._ACTIVE = TRUE.
      IF _inp_line[2] NE "{&Master-Layout}" THEN DO:  
        /* Create Layout records for each object. */
        FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win,
            EACH m_L WHERE m_L._u-recid = RECID(_U) AND
                           m_L._LO-NAME = "{&Master-Layout}":
          FIND _L WHERE _L._LO-NAME = _inp_line[2] AND
                        _L._u-recid = RECID(_U) NO-ERROR.
          IF NOT AVAILABLE _L THEN CREATE _L.
        
          /* Save the Layout record of a design window. */
          IF RECID(_U) eq dw_recid THEN FIND dw_L WHERE RECID(dw_L) eq RECID(_L).
          ASSIGN _L._LO-NAME            = _inp_line[2]
                 _L._u-recid            = RECID(_U)
                 _L._BGCOLOR            = IF _LAYOUT._GUI-BASED THEN m_L._BGCOLOR
                                                                ELSE ?
                 _L._COL                = IF _LAYOUT._GUI-BASED THEN m_L._COL
                                                                ELSE INTEGER(m_L._COL)
                 _L._CONVERT-3D-COLORS  = m_L._CONVERT-3D-COLORS
                 _L._COL-MULT           = IF _LAYOUT._GUI-BASED THEN m_L._COL-MULT
                                                                ELSE _tty_col_mult
                 _L._FGCOLOR            = IF _LAYOUT._GUI-BASED THEN m_L._FGCOLOR
                                                                ELSE ?
                 _L._FONT               = IF _LAYOUT._GUI-BASED THEN m_L._FONT
                                                                ELSE _tty_font
                 _L._HEIGHT             = IF _LAYOUT._GUI-BASED THEN m_L._HEIGHT
                                          ELSE IF _U._TYPE = "WINDOW" THEN 21
                                          ELSE IF CAN-DO("FILL-IN,TOGGLE,BUTTON,TEXT",
                                                           _U._TYPE)  THEN 1
                                          ELSE INTEGER(m_L._HEIGHT)
                 _L._NO-BOX             = m_L._NO-BOX
                 _L._NO-FOCUS           = m_L._NO-FOCUS
                 _L._NO-LABELS          = m_L._NO-LABELS
                 _L._REMOVE-FROM-LAYOUT = FALSE
                 _L._ROW                = IF _LAYOUT._GUI-BASED THEN m_L._ROW
                                                                ELSE INTEGER(m_L._ROW)
                 _L._ROW-MULT           = IF _LAYOUT._GUI-BASED THEN m_L._COL-MULT
                                                                ELSE _tty_row_mult
                 _L._WIDTH              = IF _LAYOUT._GUI-BASED THEN m_L._WIDTH
                                          ELSE IF CAN-DO("WINDOW,FRAME",_U._TYPE) THEN 80
                                          ELSE INTEGER(m_L._WIDTH)
                 _L._WIN-TYPE           = _LAYOUT._GUI-BASED
                 _L._EDGE-PIXELS        = m_L._EDGE-PIXELS
                 _L._FILLED             = m_L._FILLED
                 _L._GRAPHIC-EDGE       = m_L._GRAPHIC-EDGE
                 _L._GROUP-BOX          = m_L._GROUP-BOX
                 _L._ROUNDED            = m_L._ROUNDED
                 _L._3-D                = m_L._3-D
                 _L._NO-BOX             = m_L._NO-BOX
                 _L._NO-UNDERLINE       = m_L._NO-UNDERLINE
                 _L._SEPARATORS         = m_L._SEPARATORS
                 _L._SEPARATOR-FGCOLOR  = IF _LAYOUT._GUI-BASED THEN m_L._SEPARATOR-FGCOLOR
                                                                ELSE ?
                 _L._TITLE-BGCOLOR      = IF _LAYOUT._GUI-BASED THEN
                                              m_L._TITLE-BGCOLOR ELSE ?
                 _L._TITLE-FGCOLOR      = IF _LAYOUT._GUI-BASED THEN
                                              m_L._TITLE-FGCOLOR ELSE ?
                 _L._VIRTUAL-HEIGHT     = MAX(m_L._VIRTUAL-HEIGHT,_L._HEIGHT)
                 _L._VIRTUAL-WIDTH      = MAX(m_L._VIRTUAL-WIDTH,_L._WIDTH)
                 _L._WIN-TYPE           = _LAYOUT._GUI-BASED.
        END.  /* FOR EACH _U and m_L */      
        
      END.  /* If not {&Master-Layout} */
    END. /* When we find a "WHEN" */

    ELSE IF _inp_line[1] = "ASSIGN":U OR  /* Handle VBXes */
           (_inp_line[1] = "IF":U AND _inp_line[4] = "ASSIGN":U) THEN DO:
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line.
      IF _LAYOUT._LO-NAME NE "{&Master-Layout}" THEN DO:
        IF _inp_line[1] = "widg-pos" AND _inp_line[2] = "=" OR
           _inp_line[1] = "~&IF" OR _inp_line[1] = "" THEN
        DO:
          _inp_line = "".
          IMPORT STREAM _P_QS _inp_line.
        END.
        ASSIGN pos    = IF _inp_line[1] = "FRAME" THEN 2 ELSE 1
               tmp_name = ENTRY(1,_inp_line[pos],":":U)
               num_entries = NUM-ENTRIES(tmp_name,".":U)
               w_name   = ENTRY(num_entries,tmp_name,".").

        FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                      _U._NAME          = w_name NO-ERROR.
        IF NOT AVAILABLE _U THEN DO:
          FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                        _U._NAME          = w_name AND
                        _U._TABLE         = ENTRY(num_entries - 1, tmp_name,".":U)
                  NO-ERROR.
          IF NOT AVAILABLE  _U THEN
          FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                        _U._NAME          = w_name AND
                        _U._TABLE         = ENTRY(num_entries - 1, tmp_name,".":U) AND
                        _U._DBNAME        = ENTRY(num_entries - 2, tmp_name,".":U)
                  NO-ERROR.
           
        END.
        IF AVAILABLE _U THEN DO:
          FIND _L WHERE _L._u-recid = RECID(_U) AND
                        _L._LO-NAME = _LAYOUT._LO-NAME.  
          /* Is this object a SIZE-TO-PARENT frame in a design-window? */
          lSize2Parent = _U._TYPE eq "FRAME" AND
                         _U._SIZE-TO-PARENT AND
                         _U._parent-recid eq dw_recid.
        END.
        ELSE DO:
          MESSAGE "Unable to locate internal record for" w_name + "."
                 VIEW-AS ALERT-BOX ERROR.
          _inp_line = "".
          IMPORT STREAM _P_QS _inp_line.
          NEXT.
        END.
      END.  /* Not {&Master-Layout} */
    END.  /* When we find an ASSIGN */
    
    IF (_inp_line[pos + 1] = "=" OR _inp_line[pos + 4] = "=") AND
        NOT _inp_line[1] BEGINS "lbl-hndl" AND _inp_line[1] NE "widg-pos" AND
            _LAYOUT._LO-NAME NE "{&Master-Layout}"
    THEN DO:
      ASSIGN attrbt = ENTRY(2,_inp_line[pos],":")
             val    = IF _inp_line[pos + 1] NE "IN" AND
                         _inp_line[pos + 2] NE "FRAME" THEN
                         RIGHT-TRIM(_inp_line[pos + 2],".")  ELSE
                         RIGHT-TRIM(_inp_line[pos + 5],".") .

      CASE attrbt:
        WHEN "BGCOLOR"             THEN _L._BGCOLOR            = INTEGER(val).
        WHEN "CONVERT-3D-COLORS"   THEN _L._CONVERT-3D-COLORS  = (val BEGINS "y").
        WHEN "COL"                 THEN _L._COL                = DECIMAL(val).
        /* Special case: need to convert pixels to character units */
        WHEN "X"                   THEN _L._COL                = 
          (INTEGER(val) / SESSION:PIXELS-PER-COL) + 1.
        WHEN "EDGE-PIXELS"         THEN _L._EDGE-PIXELS        = INTEGER(val).
        WHEN "FGCOLOR"             THEN _L._FGCOLOR            = INTEGER(val).
        WHEN "FILLED"              THEN _L._FILLED             = (val BEGINS "y").
        WHEN "FONT"                THEN _L._FONT               = INTEGER(val).
        WHEN "GRAPHIC-EDGE"        THEN _L._GRAPHIC-EDGE       = (val BEGINS "y").
        WHEN "GROUP-BOX"           THEN _L._GROUP-BOX          = (val BEGINS "y").
        WHEN "HIDDEN"              THEN _L._REMOVE-FROM-LAYOUT = (val BEGINS "y").
        WHEN "NO-BOX"              THEN _L._NO-BOX             = (val BEGINS "y").    
        WHEN "NO-FOCUS"            THEN _L._NO-FOCUS           = (val BEGINS "y").
        WHEN "ROUNDED"             THEN _L._ROUNDED            = (val BEGINS "y").
        WHEN "ROW"                 THEN _L._ROW                = DECIMAL(val).
        /* Special case: need to convert pixels to character units */
        WHEN "Y"                   THEN _L._ROW                = 
          (INTEGER(val) / SESSION:PIXELS-PER-ROW) + 1.
        WHEN "SEPARATORS"          THEN _L._SEPARATORS         = (val BEGINS "y").
        WHEN "SEPARATOR-FGCOLOR"   THEN _L._SEPARATOR-FGCOLOR  = INTEGER(val).
        WHEN "TITLE-BGCOLOR"       THEN _L._TITLE-BGCOLOR      = INTEGER(val).
        WHEN "TITLE-FGCOLOR"       THEN _L._TITLE-FGCOLOR      = INTEGER(val).
        WHEN "VIRTUAL-HEIGHT"      THEN _L._VIRTUAL-HEIGHT     = DECIMAL(val).
        WHEN "VIRTUAL-WIDTH"       THEN _L._VIRTUAL-WIDTH      = DECIMAL(val).  
        /* If we are assigning the Height/Width of a frame in a design
           window, then also size the design window to fit the frame. */
        WHEN "HEIGHT" THEN DO:
          _L._HEIGHT       = DECIMAL(val). 
           IF lSize2parent THEN dw_L._HEIGHT = _L._HEIGHT.
        END.
        WHEN "WIDTH" THEN DO:
          _L._WIDTH        = DECIMAL(val).
            IF lSize2parent THEN dw_L._WIDTH = _L._WIDTH.
        END.
        /* NOTE: for compatibility with older versions, we support VISIBLE = no
         * as another way to REMOVE-FROM-LAYOUT.  The version 8.1 _locases.p started
         * using HIDDEN = YES, which is better. (wood) */
        WHEN "VISIBLE"             THEN _L._REMOVE-FROM-LAYOUT = (val BEGINS "n") AND
                                                                  NOT _U._HIDDEN.
      END CASE.
    END.  /* if _inp_line[pos+1] = "=" and not lbl-hndl */
    
    /* Handle case of SmartObject attributes, which are set through methods
       or adm-events.*/
    ELSE IF _inp_line[1] = "RUN" AND  _inp_line[3] eq "IN"
         AND CAN-DO("set-position,set-size,dispatch,repositionObject,resizeObject",
                    _inp_line[2])
         AND _LAYOUT._LO-NAME NE "{&Master-Layout}"    
    THEN DO:    
      /* Find the record and assign to it */
      FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                    _U._NAME          = _inp_line[4].
      FIND _L WHERE _L._u-recid = RECID(_U) AND
                    _L._LO-NAME = _LAYOUT._LO-NAME.
                    
      /* Is it a dispatch to HIDE or VIEW? i.e, is the line 
         of the form:  RUN dispatch IN h_SmO ('hide':U) NO-ERROR
         with entries:  1     2      3   4      5       6*/
      IF _inp_line[2] eq "dispatch":U THEN DO:  
        IF INDEX ( _inp_line[5], "'hide'") > 0 THEN _L._REMOVE-FROM-LAYOUT = yes.
      END.   
      ELSE DO:
        /* Line is of the form "RUN set-size IN h_SmO ( 20 , 40 ) NO-ERROR." 
           or of the form       "/* set-size IN h_SmO ( 20 , 40 ) */"
           with entries          1     2      3    4  5  6 7  8 9    10  */
        ASSIGN  dVal  = DECIMAL (_inp_line[6])
                dVal2 = DECIMAL (_inp_line[8]) NO-ERROR.
        IF ERROR-STATUS:ERROR 
        THEN MESSAGE "[{&FILE-NAME}]" SKIP "Could not understand line in layout_reader."
                     VIEW-AS ALERT-BOX ERROR. 
        ELSE DO:
          CASE _inp_line[2]:
            WHEN "set-position"     OR
            WHEN "repositionObject" THEN ASSIGN _L._ROW = dVal
                                                _L._COL = dval2.                        
            WHEN "set-size"         OR
            WHEN "resizeObject"     THEN ASSIGN _L._HEIGHT = dVal
                                                _L._WIDTH  = dval2.  
          END CASE.                      
        END.  /* Values could be parsed. */    
      END. /* IF (not) dispatch... */
    END. /* IF Smartobject Method... */
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.
  END.  /* DO while we don't find an end OR another procedure */
  
END PROCEDURE.  /* layout_reader */


PROCEDURE read_layout_defs.
  DEFINE VARIABLE ans     AS LOGICAL                                 NO-UNDO.
  DEFINE VARIABLE present AS LOGICAL                                 NO-UNDO.
  DEFINE VARIABLE lo-type AS LOGICAL                                 NO-UNDO.
  DEFINE VARIABLE tmp_exp AS CHARACTER                               NO-UNDO.
  
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.

  DO WHILE _inp_line[2] NE "END-OF-LAYOUT-DEFINITIONS":
    IF _inp_line[1] = "/*" AND _inp_line[2] = "LAYOUT-NAME:" THEN DO:

      /* Process the Layout Name */                               
      FIND _LAYOUT WHERE _LAYOUT._LO-NAME = _inp_line[3] NO-ERROR.
      IF NOT AVAILABLE _LAYOUT THEN DO:
        CREATE _LAYOUT.
        ASSIGN _LAYOUT._LO-NAME = _inp_line[3]
               present          = FALSE.
      END.
      ELSE present = TRUE.

      /* Process the type - TTY or GUI */
      IMPORT STREAM _P_QS _inp_line.
      IF present THEN DO:
        lo-type            = (_inp_line[2] = "GUI":U).
        ans = no.
        IF lo-type ne _LAYOUT._GUI-BASED THEN
          MESSAGE "The definition for layout" _LAYOUT._LO-NAME SKIP
                  "in the input file specifies that it is" _inp_line[2] "based" SKIP
                  "while the existing definition specifies" 
                  IF _LAYOUT._GUI-BASED THEN "GUI":U ELSE "Character":U "based." SKIP (1)
                  "Do you want to change the definition to" _inp_line[2] "based?"
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans.
        IF ans THEN _LAYOUT._GUI-BASED = lo-type.   
      END.
      ELSE _LAYOUT._GUI-BASED = (_inp_line[2] = "GUI":U).
      
      /* Process the expression */
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      tmp_exp = TRIM(SUBSTRING(_inp_line[1],17,-1,"CHARACTER":U)).

      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      DO WHILE NOT TRIM(_inp_line[1]) BEGINS "COMMENT:":U :
        tmp_exp = tmp_exp + CHR(10) + TRIM(SUBSTRING(_inp_line[1],17,-1,"CHARACTER":U)).
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      END.
      IF present THEN DO:
        ans = no.
        IF tmp_exp NE _LAYOUT._EXPRESSION THEN
          MESSAGE "The definition for layout" _LAYOUT._LO-NAME "in" SKIP
                  "the input file specifies that the RUN-TIME expression is:" SKIP (1)
                  tmp_exp SKIP (1)
                  "while the existing definition specifies:" SKIP (1)
                  _LAYOUT._EXPRESSION SKIP (1) 
                  "Do you want to change the definition to be like the input file?" SKIP
                  "('No' changes the input definition to the original.)"
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans.
        IF ans THEN _LAYOUT._EXPRESSION = tmp_exp.
               ELSE tmp_exp = _LAYOUT._EXPRESSION.
      END.
      ELSE _LAYOUT._EXPRESSION = tmp_exp.

      /* Process the comment */
      tmp_exp = TRIM(SUBSTRING(_inp_line[1],17,-1,"CHARACTER":U)).
      IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      DO WHILE TRIM(_inp_line[1]) NE "*/":
        tmp_exp = tmp_exp + " " + TRIM(_inp_line[1]).
        IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
      END.
      _LAYOUT._COMMENT = tmp_exp.
    END.  /* Finished with a definition */
    
    /* Read ahead looking for END-OF-LAYOUT-DEFINITIONS" */
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.  
  END.
END.  /* Get Window Hidden value */


PROCEDURE read_run_time_attributes.
  DEFINE VARIABLE cMappedField  AS CHARACTER                            NO-UNDO.
  DEFINE VARIABLE cMappedTable  AS CHARACTER                            NO-UNDO.
  DEFINE VARIABLE dbnm          AS CHARACTER                            NO-UNDO. 
  DEFINE VARIABLE lMapped       AS LOGICAL                              NO-UNDO.
  DEFINE VARIABLE txt-value     AS CHARACTER                            NO-UNDO.

  /* Following variables are for tab order stuff */
  DEFINE VARIABLE obj1_name      AS CHAR                             NO-UNDO.
  DEFINE VARIABLE obj2_name      AS CHAR                             NO-UNDO.
  DEFINE VARIABLE obj3_name      AS CHARACTER                        NO-UNDO.
  DEFINE VARIABLE obj2_is_frame  AS LOGICAL                          NO-UNDO.
  DEFINE VARIABLE point_of_ref   AS LOGICAL                          NO-UNDO.
  DEFINE VARIABLE this_U_recid   AS RECID                            NO-UNDO.
  DEFINE VARIABLE last_known_tab AS INTEGER                          NO-UNDO.
  
  DEFINE BUFFER fram_U FOR _U.

  RUN-TIME-PROC:
  REPEAT:
    _inp_line = "".
    IMPORT STREAM _P_QS _inp_line.

    IF _inp_line[1] = "/*" AND
       _inp_line[2] = "_RUN-TIME-ATTRIBUTES-END" AND
       _inp_line[3] = "*/" THEN LEAVE RUN-TIME-PROC.
    
    /* Found the return variable for the tabbing of frames. */
    /* Eat it and ignore it.                                */
    ELSE IF _inp_line[1] = "DEFINE" AND
            _inp_line[2] = "VARIABLE" AND
            _inp_line[3] = "XXTABVALXX" THEN .

    /* Found a MOVE-BEFORE-TAB-ITEM or MOVE-AFTER-TAB-ITEM line. */
    /* Note the difference of one in the groupings of array sub- */
    /* scripts. This is because this conditional statement is    */
    /* serving double-duty, where the ASSIGN token is present    */
    /* only once for the frame.                                  */

    ELSE IF (_inp_line[2] = "XXTABVALXX" AND
            _inp_line[3] = "=" AND
            _inp_line[4] = "FRAME") OR
            (_inp_line[1] = "XXTABVALXX" AND
            _inp_line[2] = "=" AND
            _inp_line[3] = "FRAME") THEN DO:

      obj2_is_frame = FALSE.
      IF _inp_line[1] = "ASSIGN" THEN DO:
        RUN get_object_name (_inp_line[5], OUTPUT obj1_name).
        IF  _inp_line[6] = "(FRAME" THEN DO:
          obj2_is_frame = TRUE.
          RUN get_object_name (_inp_line[7], OUTPUT obj2_name).
          obj3_name = IF _inp_line[9] = "FRAME":U THEN ENTRY(1,_inp_line[10],")":U)
                      ELSE ?.
        END.
        ELSE DO: /* Eat the first "(" */
          RUN get_object_name (ENTRY(2,_inp_line[6],"(":U),
                               OUTPUT obj2_name).
          obj3_name = IF _inp_line[8] = "FRAME":U THEN ENTRY(1,_inp_line[9],")":U)
                      ELSE ?.
        END.
      END.
      ELSE DO:
        RUN get_object_name (_inp_line[4], OUTPUT obj1_name).
        IF  _inp_line[5] = "(FRAME" THEN DO:
          obj2_is_frame = TRUE.
          RUN get_object_name (_inp_line[6], OUTPUT obj2_name).
          obj3_name = IF _inp_line[8] = "FRAME":U THEN ENTRY(1,_inp_line[9],")":U)
                      ELSE ?.
        END.
        ELSE DO: /* Eat the first "(" */
          RUN get_object_name (ENTRY(2, _inp_line[5],"(":U),
                               OUTPUT obj2_name).
          obj3_name = IF _inp_line[7] = "FRAME":U THEN ENTRY(1,_inp_line[8],")":U)
                      ELSE ?.
        END.
      END.

      FIND fram_U WHERE fram_U._NAME = obj3_name AND fram_U._TYPE = "FRAME":U AND
                        fram_U._WINDOW-HANDLE = _h_win USE-INDEX _OUTPUT NO-ERROR.
      IF AVAILABLE fram_U THEN DO:
        IF NUM-ENTRIES(obj1_name,".":U) = 1 THEN
          FIND obj1_U WHERE obj1_U._NAME = obj1_name AND
                            obj1_U._PARENT-RECID = RECID(fram_U) AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE IF NUM-ENTRIES(obj1_name,".":U) = 2 THEN
          FIND obj1_U WHERE obj1_U._NAME = ENTRY(2,obj1_name,".":U) AND
                            obj1_U._PARENT-RECID = RECID(fram_U) AND
                            obj1_U._TABLE = ENTRY(1,obj1_name,".":U) AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE
          FIND obj1_U WHERE obj1_U._NAME = ENTRY(3,obj1_name,".":U) AND
                            obj1_U._PARENT-RECID = RECID(fram_U) AND
                            obj1_U._TABLE = ENTRY(2,obj1_name,".":U) AND
                            obj1_U._DBNAME = ENTRY(1,obj1_name,".":U) AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.

        IF NUM-ENTRIES(obj2_name,".":U) = 1 THEN
          FIND obj2_U WHERE obj2_U._NAME = obj2_name AND
                            obj2_U._PARENT-RECID = RECID(fram_U) AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE IF NUM-ENTRIES(obj2_name,".":U) = 2 THEN
          FIND obj2_U WHERE obj2_U._NAME = ENTRY(2,obj2_name,".":U) AND
                            obj2_U._PARENT-RECID = RECID(fram_U) AND
                            obj2_U._TABLE = ENTRY(1,obj2_name,".":U) AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
         ELSE
          FIND obj2_U WHERE obj2_U._NAME = ENTRY(3,obj2_name,".":U) AND
                            obj2_U._PARENT-RECID = RECID(fram_U) AND
                            obj2_U._TABLE = ENTRY(2,obj2_name,".":U) AND
                            obj2_U._DBNAME = ENTRY(1,obj2_name,".":U) AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
      END.  /* If we have the parent frame */
      ELSE DO:  /* This can be removed after 8.2A.  It is only for compatibility
                   for braindead 8.1A                                            */
      
        IF NUM-ENTRIES(obj1_name,".":U) = 1 THEN
          FIND obj1_U WHERE obj1_U._NAME = obj1_name AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE IF NUM-ENTRIES(obj1_name,".":U) = 2 THEN
          FIND obj1_U WHERE obj1_U._NAME = ENTRY(2,obj1_name,".":U) AND
                            obj1_U._TABLE = ENTRY(1,obj1_name,".":U) AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE
          FIND obj1_U WHERE obj1_U._NAME = ENTRY(3,obj1_name,".":U) AND
                            obj1_U._TABLE = ENTRY(2,obj1_name,".":U) AND
                            obj1_U._DBNAME = ENTRY(1,obj1_name,".":U) AND
                            obj1_U._WINDOW-HANDLE = _h_win AND
                            obj1_U._STATUS = 'NORMAL':U USE-INDEX _NAME.

        IF NUM-ENTRIES(obj2_name,".":U) = 1 THEN
          FIND obj2_U WHERE obj2_U._NAME = obj2_name AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
        ELSE IF NUM-ENTRIES(obj2_name,".":U) = 2 THEN
          FIND obj2_U WHERE obj2_U._NAME = ENTRY(2,obj2_name,".":U) AND
                            obj2_U._TABLE = ENTRY(1,obj2_name,".":U) AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
         ELSE
          FIND obj2_U WHERE obj2_U._NAME = ENTRY(3,obj2_name,".":U) AND
                            obj2_U._TABLE = ENTRY(2,obj2_name,".":U) AND
                            obj2_U._DBNAME = ENTRY(1,obj2_name,".":U) AND
                            obj2_U._WINDOW-HANDLE = _h_win AND
                            obj2_U._STATUS = 'NORMAL':U USE-INDEX _NAME.
         /* object 1 is always a frame! */
      END. /* Try for backward compatiblity */

      IF NOT obj2_is_frame THEN DO:

          /* First have to test whether the frame needs to be assigned */
          /* a number for the tab order. It might have already been    */
          /* given a valid number previously when a MOVE-AFTER was en- */
          /* countered. This situation arrises whenever a frame is     */
          /* sandwiched between to non-frame siblings.                 */

        IF obj1_U._TAB-ORDER = 0 THEN DO:
         
          /* Find the second object in the tab order of the frames, use   */
          /* its position in the tab order as the starting point from     */
          /* which to iterate all the other objects in the tab group with */
          /* a tab order greater than the second object's.                */
        
          point_of_ref = TRUE.        
          IF INDEX (_inp_line[4], "MOVE-BEFORE-TAB-ITEM") > 0 OR
             INDEX (_inp_line[5], "MOVE-BEFORE-TAB-ITEM") > 0 THEN DO:
            /* increment everything greater than or equal to _TAB-ORDER.*/
          last_known_tab = obj2_U._TAB-ORDER.
          RUN insert_in_tab_order (this_U_recid, RECID(obj1_U), obj2_U._TAB-ORDER).
          END.
          ELSE /* MOVE-AFTER-TAB-ITEM */ DO:
            /* increment everything greater than or equal to _TAB-ORDER + 1 */
            last_known_tab = obj2_U._TAB-ORDER + 1.
            RUN insert_in_tab_order (this_U_recid, 
                                     RECID(obj1_U), obj2_U._TAB-ORDER + 1).
          END.
        END.
      END.
      ELSE DO:
        /* Both objects are frames. Check if there is a point of reference. */
        /* If not, then all children of this frame are frames, and need to  */
        /* establish a point of reference.                                  */

        IF NOT point_of_ref THEN
          ASSIGN obj2_U._TAB-ORDER = 1
                 point_of_ref      = TRUE.

        /* There is a point of reference, but both frames may not have   */
        /* been assigned a tab order yet. If this is the case, the two   */
        /* are given a number at the highest known valid tab number plus */
        /* one and plus 2. All objects greater than this position have   */
        /* their tab numbers incremented by 2.                           */
        IF obj1_U._TAB-ORDER = obj2_U._TAB-ORDER THEN DO:
          /* Both frames have yet to have a number assigned to them when */
          /* both their _TAB-ORDERs are identical.                       */
          FOR EACH x_U WHERE x_U._PARENT-RECID = this_U_recid
                   AND x_U._STATUS = 'NORMAL':U
                   AND RECID (x_U) <> this_U_recid
                   AND NOT CAN-DO ('SMartObject,QUERY,OCX,TEXT,IMAGE,RECTANGLE,LABEL':U, x_U._TYPE)
                   AND x_U._TAB-ORDER > last_known_tab:
            x_U._TAB-ORDER = x_U._TAB-ORDER + 2.
          END.
          ASSIGN obj1_U._TAB-ORDER = last_known_tab + 1
                 obj2_U._TAB-ORDER = last_known_tab + 2
                 last_known_tab    = last_known_tab + 2.
        END.
        ELSE IF obj2_U._TAB-ORDER < obj1_U._TAB-ORDER THEN DO:
          /* obj1 has a non-zero tab number and, thus, has already been  */
          /* assigned a meaningful number earlier. Since it comes before */
          /* obj2 (this is a obj1 MOVE-BEFORE obj2), then obj2 is one    */
          /* greater than the value of obj1.                             */
          FOR EACH x_U WHERE x_U._PARENT-RECID = this_U_recid
                   AND x_U._STATUS = 'NORMAL':U
                   AND RECID (x_U) <> this_U_recid
                   AND NOT CAN-DO ('SMartObject,QUERY,OCX,TEXT,IMAGE,RECTANGLE,LABEL':U, x_U._TYPE)
                   AND x_U._TAB-ORDER > obj1_U._TAB-ORDER:
            x_U._TAB-ORDER = x_U._TAB-ORDER + 1.
          END.
          ASSIGN obj2_U._TAB-ORDER = obj1_U._TAB-ORDER + 1
                 last_known_tab    = obj1_U._TAB-ORDER + 1.
        END.
        ELSE
          RUN insert_in_tab_order (this_U_recid, RECID(obj1_U), obj2_U._TAB-ORDER). 
      END.
    END.
    
    /* Look for the end of the assign tabs comment for this frame. */
    ELSE IF _inp_line[1] = "/*" AND
            _inp_line[2] = "END-ASSIGN-TABS" AND
            _inp_line[3] = "*/." THEN  .

    /* Look for browse tabs section */
    ELSE IF _inp_line[1] = "/*" AND
            _inp_line[2] = "BROWSE-TAB" AND
            _inp_line[6] = "*/" THEN DO:
      FIND _U WHERE RECID(_U) = this_U_recid.
      IF _U._NAME NE _inp_line[5] THEN
        MESSAGE "Browse" _inp_line[3] "is in the wrong frame."
                VIEW-AS ALERT-BOX ERROR.
      ELSE DO:
        FIND obj1_U WHERE obj1_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                          obj1_U._NAME = _inp_line[3] AND
                          obj1_U._TYPE = "BROWSE":U AND
                          obj1_U._PARENT-RECID = this_U_recid NO-ERROR.
        IF _inp_line[4] NE "1" THEN
          FIND obj2_U WHERE obj2_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                            obj2_U._NAME = _inp_line[4] AND
                            obj2_U._PARENT-RECID = this_U_recid NO-ERROR.
        IF AVAILABLE obj1_U THEN
           RUN insert_in_tab_order (this_U_recid, RECID(obj1_U),
                IF AVAILABLE(obj2_U) AND _inp_line[4] ne "1"
                   THEN obj2_U._TAB-ORDER + 1 ELSE 1).                
      END.
    END.  /* Browser tab section */

    ELSE IF _inp_line[1] = "/*" AND _inp_line[2] = "SETTINGS" AND
       _inp_line[3] = "FOR" THEN DO:

      IF _inp_line[4] = "WINDOW" THEN DO:
        FIND _U WHERE _U._HANDLE = _h_win.
        FIND _C WHERE RECID(_C) = _U._x-recid.
        FIND _P WHERE _P._u-recid = RECID(_U).
      END.

      ELSE IF _inp_line[4] = "TEXT-LITERAL" THEN DO:
        txt-value = _inp_line[5].
        IMPORT STREAM _P_QS _inp_line.
        
        FOR EACH _U WHERE _U._TYPE = "TEXT" AND NOT _U._NAME BEGINS "_LBL-",
            EACH _F WHERE RECID(_F) = _U._x-recid:
          FIND _L WHERE RECID(_L) = _U._lo-recid.
          IF _F._INITIAL-DATA = txt-value       AND
             _L._WIDTH  = DECIMAL(_inp_line[2]) AND
             _L._HEIGHT = DECIMAL(_inp_line[4]) AND
             _L._ROW    = DECIMAL(_inp_line[7]) AND
             _L._COL    = DECIMAL(_inp_line[9]) - _L._WIDTH + 1 AND
             _inp_line[10] = "RIGHT-ALIGNED" THEN _U._ALIGN = "R".
        END.
        NEXT RUN-TIME-PROC.
      END.  /* TEXT-LITERAL */
                 
      ELSE DO:
        /* Support 7.2D (UIB_v7r9) BROWSER (ross) */
        IF _inp_line[4] = "BROWSER" THEN _inp_line[4] = "BROWSE".
        /* Get the frame name of the widget we a looking at.             */
        _frame_name = IF CAN-DO("FRAME,DIALOG-BOX",_inp_line[4])
                      THEN _inp_line[5] ELSE _inp_line[8].
               
        IF import_mode eq "IMPORT" THEN DO:
          /* IF _inp_line[4] is "FRAME" and we are ignoring frames       */
          /* because the target is a dialog-box, we want to set _h_frame */
          /* to the handle of the dialog-box.                            */
          FIND _U WHERE _U._HANDLE = _h_win.
          IF _U._TYPE NE "WINDOW" AND _inp_line[4] = "FRAME" THEN
            ASSIGN _h_frame = _h_win.
          FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
          IF AVAILABLE _U THEN _frame_name = _U._NAME.
        END.

        ASSIGN
          dyn_widget = false
          dyn_offset = 0
        .

        /* If the field is mapped to a data field (CLOB data fields
           are represented by local LONGCHAR editors and the local
           editor name has been mapped to the data field name)  
           the mapping is needed to read runtime attributes for
           the local fields. */
        lMapped = NO.
        IF cDataFieldMapping NE "":U AND 
            _inp_line[4] = "EDITOR":U THEN
          RUN checkName(INPUT _inp_line[5],
                        OUTPUT lMapped,
                        OUTPUT cMappedTable,
                        OUTPUT cMappedField).
        CASE NUM-ENTRIES(_inp_line[5],"."):
          WHEN 1 THEN DO:
          
            IF  _inp_line[4] = "{&WT-CONTROL}" THEN DO:
              FIND _NAME-REC WHERE _NAME-REC._wNAME   = _inp_line[5] AND
                                   _NAME-REC._wTYPE   = _inp_line[4]  NO-ERROR.
              ASSIGN
                dyn_widget = true
                dyn_offset = -3.
            END.  
            ELSE IF lMapped THEN
              FIND _NAME-REC WHERE _NAME-REC._wName  = cMappedField AND
                                   _NAME-REC._wType  = _inp_line[4] AND
                                   _NAME-REC._wTable = cMappedTable AND 
                                   _NAME-REC._wDBName = ? AND
                                   _NAME-REC._wFRAME = _frame_name  NO-ERROR.
            ELSE DO:
              FIND _NAME-REC WHERE _NAME-REC._wNAME   = _inp_line[5] AND
                                   _NAME-REC._wTYPE   = _inp_line[4] AND
                                   _NAME-REC._wFRAME  = _frame_name NO-ERROR.
              IF NOT AVAILABLE _NAME-REC THEN
                FIND _NAME-REC WHERE _NAME-REC._wNAME   = _inp_line[5] AND
                                     _NAME-REC._wDBNAME = ? AND
                                     _NAME-REC._wTABLE  = ? AND
                                     _NAME-REC._wTYPE   = _inp_line[4] AND
                                     _NAME-REC._wFRAME  = _frame_name NO-ERROR.
            END.
          END.
          WHEN 2 THEN DO:
            FIND _NAME-REC WHERE _NAME-REC._wNAME   = ENTRY(2,_inp_line[5],".") AND
                                 _NAME-REC._wTABLE  = ENTRY(1,_inp_line[5],".") AND
                                 _NAME-REC._wTYPE   = _inp_line[4] AND
                                 _NAME-REC._wFRAME  = _frame_name NO-ERROR.
          END.
          WHEN 3 THEN DO:
            FIND _NAME-REC WHERE _NAME-REC._wNAME   = ENTRY(3,_inp_line[5],".") AND
                                 _NAME-REC._wDBNAME = ENTRY(1,_inp_line[5],".") AND
                                 _NAME-REC._wTABLE  = ENTRY(2,_inp_line[5],".") AND
                                 _NAME-REC._wTYPE   = _inp_line[4] AND
                                 _NAME-REC._wFRAME  = _frame_name NO-ERROR.
          END.
        END CASE.
        
        IF NOT AVAILABLE _NAME-REC AND import_mode = "IMPORT" THEN
          FIND _U WHERE _U._HANDLE = _h_frame.
        ELSE
          FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.
        FIND _L WHERE RECID(_L) = _U._lo-recid.
            
      END.  /* ELSE DO Non-window case */
           
      /* This line checks the compile time preprocessor variables to ensure
        that we are looking for all the possible User-List preprocessor
        variables.  Currently this is set to 6.  */
      &IF {&MaxUserLists} > 6 &THEN
      &MESSAGE [_qssuckr.p] *** FIX NOW *** User list can have unexpected value (wood)
      &ENDIF
      _inp_line = "".
      IMPORT STREAM _P_QS _inp_line.
      ASSIGN i        = 1
             settings = "".
      DO WHILE _inp_line[i] NE "*/":
        /* Look for simple integers that indicate  an element of the
           User-List.  Otherwise append the item at the end of settings
           (Don't worry about an initial comma because we are going to 
           remove it later). */
        j = INDEX("123456":U, _inp_line[i]).
        IF j ne 0 AND NOT (_U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U)
             THEN _U._User-List[ j ] = YES.
        ELSE DO:
          IF settings eq "":U THEN settings = _inp_line[i].
          ELSE settings = settings + "," + _inp_line[i].
        END.
        i = i + 1.
      END.
        
      CASE _U._TYPE:          
        WHEN "WINDOW":U THEN DO:           
          IF import_mode NE "IMPORT":U THEN DO:  /* Don't inherit window attributes */
                                                 /* from the import window.  It is  */
                                                 /* just a container.               */
            IF CAN-DO(settings,"NOT-VISIBLE")    THEN _U._DISPLAY = FALSE.
            IF CAN-DO(settings,"RUN-PERSISTENT") THEN _P._RUN-PERSISTENT = TRUE.
            _U._LABEL-ATTR = ENTRY(2,settings).
          END.
        END.

        WHEN "FRAME":U OR WHEN "DIALOG-BOX":U OR WHEN "BROWSE":U THEN DO:
          FIND _L WHERE RECID(_L) = _U._lo-recid.
          FIND _C WHERE RECID(_C) = _U._x-recid.
          IF CAN-DO(settings,"ALIGN-C")      THEN _U._ALIGN = "C".
          IF CAN-DO(settings,"ALIGN-L")      THEN _U._ALIGN = "L".
          IF CAN-DO(settings,"ALIGN-R")      THEN _U._ALIGN = "R".
          IF CAN-DO(settings,"DISPLAY")      THEN _U._DISPLAY = TRUE.
          IF CAN-DO(settings,"EXP-POSITION") THEN _C._EXPLICIT_POSITION = TRUE.         
          IF CAN-DO(settings,"FRAME-NAME")   THEN _P._frame-name-recid = RECID(_U).
          IF CAN-DO(settings,"NO-DISPLAY")   THEN _U._DISPLAY = FALSE.
          IF CAN-DO(settings,"NO-ENABLE")    THEN _U._ENABLE = FALSE.
          IF CAN-DO(settings,"NOT-VISIBLE")  THEN _U._DISPLAY = FALSE.
          IF CAN-DO(settings,"SHARED")       THEN _U._SHARED  = TRUE.
          IF CAN-DO(settings,"SIZE-TO-FIT")  THEN _C._SIZE-TO-FIT = TRUE.
          IF CAN-DO(settings,"UNDERLINE")    THEN _L._NO-UNDERLINE = FALSE.

          /* Set the _C.tabbing field and set the point_of_ref */
          /* variable for when the frame's MOVE-AFTER-TAB-ITEM */
          /* and MOVE-BEFORE-TAB-ITEM lines are read in.       */

          point_of_ref = FALSE.

          /* Set tab order settings when we are not importing an unnamed frame. -jep */
          IF NOT import_unnamedframe AND (_U._TYPE = "FRAME":U OR _U._TYPE = "DIALOG-BOX":U) THEN
          DO:
            IF CAN-DO (settings, "Custom") THEN
              _C._tabbing = "Custom".
            ELSE IF CAN-DO (settings, "L-To-R") THEN DO:
              IF CAN-DO (settings, "COLUMNS") THEN
                _C._tabbing = "L-To-R,COLUMNS".
              ELSE
                _C._tabbing = "L-To-R".
            END.
            ELSE IF CAN-DO (settings, "R-To-L") THEN DO:
              IF CAN-DO (settings, "COLUMNS") THEN 
                _C._tabbing = "R-To-L,COLUMNS".
              ELSE
                _C._tabbing = "R-To-L".
            END.
            ELSE
              _C._tabbing = "Default".
          END.
          ASSIGN this_U_recid   = RECID (_U)
                 last_known_tab = 0.
        END.


        OTHERWISE DO:
          FIND _F WHERE RECID(_F) = _U._x-recid.
          IF CAN-DO(settings,"DISPLAY")    THEN _U._DISPLAY     = TRUE.
          IF CAN-DO(settings,"NO-DISPLAY") THEN _U._DISPLAY     = FALSE.
          IF CAN-DO(settings,"NO-ENABLE")  THEN _U._ENABLE      = FALSE.
          IF CAN-DO(settings,"SHARED")     THEN _U._SHARED      = TRUE.
          IF CAN-DO(settings,"ALIGN-C")    THEN _U._ALIGN         = "C".
          IF CAN-DO(settings,"ALIGN-L")    THEN _U._ALIGN         = "L".
          IF CAN-DO(settings,"ALIGN-R")    THEN _U._ALIGN         = "R".
          IF CAN-DO(settings,"LIKE")       THEN DO:
            ASSIGN dbnm = ENTRY(LOOKUP("LIKE":U,settings) + 2, settings)
                   _U._DBNAME        = ENTRY(1,dbnm,".")
                   _U._TABLE         = ENTRY(2,dbnm,".")
                   _F._LIKE-FIELD    = ENTRY(3,dbnm,".")
                   _F._DISPOSITION   = "LIKE":U
                   _U._LABEL-SOURCE  = "D"
                   _F._FORMAT-SOURCE = "D"
                   _U._HELP-SOURCE   = "D"
                   _F._SIZE-SOURCE   = "D".
          END. /* IF LIKE */
          IF CAN-DO(settings,"EXP-LABEL")  THEN _U._LABEL-SOURCE  = "E".
          IF CAN-DO(settings,"DEF-LABEL")  THEN _U._LABEL-SOURCE  = "D".
          IF CAN-DO(settings,"EXP-FORMAT") THEN _F._FORMAT-SOURCE = "E".
          IF CAN-DO(settings,"DEF-FORMAT") THEN _F._FORMAT-SOURCE = "D".
          IF CAN-DO(settings,"EXP-HELP")   THEN _U._HELP-SOURCE   = "E".
          IF CAN-DO(settings,"DEF-HELP")   THEN _U._HELP-SOURCE   = "D".
          IF CAN-DO(settings,"EXP-SIZE")   THEN _F._SIZE-SOURCE   = "E".
          IF CAN-DO(settings,"VIEW-AS")    THEN _F._DICT-VIEW-AS  = TRUE.
          IF CAN-DO(settings,"USER")       THEN _U._DEFINED-BY    = "User".
          IF CAN-DO(settings,"LABEL")      THEN DO:
            /* This only occurs when the frame is no-label (which is taken
               care of by the analyzer) and a fill-in has a label.  The 
               label is the item immediately after the LABEL keyword and
               has the string attributes appended to it.                  */
            /* First determine what the label is                          */
            ASSIGN i              = LOOKUP("LABEL":U,settings) + 1
                   temp-name      = ENTRY(i,settings)
                   _L._NO-LABELS  = FALSE
                   i              = R-INDEX(temp-name,":")
                   _U._LABEL      = SUBSTRING(temp-name,1,i - 1,"CHARACTER":U)
                   _U._LABEL-ATTR = SUBSTRING(temp-name,i + 1,-1,"CHARACTER":U).
          END.  /* IF LABEL */
        END.  /* OTHERWISE */
            
      END CASE.  /* _U._TYPE */
    END.  /* IF SETTINGS COMMENT */

    ELSE IF _inp_line[1] = "FRAME" AND _inp_line[3] = "=" AND
            INDEX(_inp_line[2],":") > 0 THEN DO:
      /* Frame attributes to process */      
      FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(1,_inp_line[2],":") AND
                            CAN-DO("FRAME,DIALOG-BOX", _NAME-REC._wTYPE) NO-ERROR.
      IF NOT AVAILABLE _NAME-REC THEN DO:
        FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
        /* If there is no current frame, get one. */
        IF NOT AVAILABLE _U THEN DO:
          FIND FIRST _U WHERE _U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                                       _U._TYPE = "FRAME" no-error.
          IF AVAILABLE (_U) THEN
            _h_frame = x_U._HANDLE.
        END.
        FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(1,_inp_line[2],":") AND
                             CAN-DO("FRAME,DIALOG-BOX", _NAME-REC._wTYPE) AND
                            _NAME-REC._wFRAME = _U._NAME NO-ERROR.
      END.
      IF AVAILABLE _NAME-REC THEN DO:
        FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.
      END.
      FIND _L WHERE RECID(_L) = _U._lo-recid.
      FIND _C WHERE RECID(_C) = _U._x-recid.
   
      CASE ENTRY(2,_inp_line[2],":"):         
        WHEN "BOX-SELECTABLE"   THEN _C._BOX-SELECTABLE = TRUE.
        WHEN "COLUMN"           THEN DO:
          ASSIGN _L._COL           =
                   IF SUBSTRING(_inp_line[4],LENGTH(_inp_line[4],"CHARACTER":U),1,
                                "CHARACTER":U) = "." THEN
                     DECIMAL(SUBSTRING(_inp_line[4],1,LENGTH(_inp_line[4],"CHARACTER":U)
                                       - 1,"CHARACTER":U))
                     ELSE DECIMAL(_inp_line[4]).
          IF _U._TYPE NE "DIALOG-BOX" THEN  _U._HANDLE:COLUMN  = _L._COL.
          ELSE ASSIGN _U._HANDLE:COLUMN = 1
                      _U._PARENT:COLUMN = _L._COL.
        END.

        WHEN "HEIGHT"           THEN
            ASSIGN _L._HEIGHT              = DECIMAL(_inp_line[4])
                   _U._HANDLE:HEIGHT       = _L._HEIGHT.

        WHEN "HIDDEN"           THEN _U._HIDDEN = TRUE. 

        WHEN "MANUAL-HIGHLIGHT" THEN _U._MANUAL-HIGHLIGHT = TRUE.
           
        WHEN "SCROLLABLE"       THEN DO:
                _C._SCROLLABLE = (_inp_line[4] BEGINS "TRUE").
                IF _U._HANDLE:SCROLLABLE ne _C._SCROLLABLE 
                THEN _U._HANDLE:SCROLLABLE = _C._SCROLLABLE.
        END.

        WHEN "SELECTABLE"       THEN _U._SELECTABLE = TRUE.

        WHEN "SELECTED"         THEN _U._SELECTED = TRUE.

        WHEN "MOVABLE"          THEN _U._MOVABLE = TRUE.

        WHEN "POPUP-MENU" THEN DO:
          /* Find the _U with the name of this menu.  Note: Parent menus
             are not located in any frame and they have unique names */
          FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(1,_inp_line[5],":") 
                           AND _NAME-REC._wDBNAME = ? AND _NAME-REC._wTABLE = ?
                           AND _NAME-REC._wTYPE = "MENU" NO-ERROR.
          IF AVAILABLE _NAME-REC THEN DO:
            FIND x_U WHERE RECID(x_U) eq _NAME-REC._wRECID.             
            ASSIGN _U._POPUP-RECID = RECID(x_U)
                  x_U._PARENT-RECID = RECID(_U).
          END.
          ELSE MESSAGE "Can't locate popup menu" ENTRY(1,_inp_line[5],":")
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
        WHEN "PRIVATE-DATA"     THEN DO:
          _inp_line = "".
          IMPORT STREAM _P_QS _inp_line.
          _U._PRIVATE-DATA = _inp_line[1].
          IF _inp_line[2] NE "" AND _inp_line[2] NE ".":U THEN
          _U._PRIVATE-DATA-ATTR = RIGHT-TRIM(LEFT-TRIM(_inp_line[2],":":U),".":U).
        END.

        WHEN "RESIZABLE"        THEN _U._RESIZABLE = TRUE.

        WHEN "ROW"              THEN DO:
          ASSIGN _L._ROW            = DECIMAL(_inp_line[4]).
          IF _U._TYPE NE "DIALOG-BOX" THEN  _U._HANDLE:ROW     = _L._ROW.
          ELSE ASSIGN _U._HANDLE:ROW = 1
                      _U._PARENT:ROW = _L._ROW.
        END.

        WHEN "SENSITIVE"        THEN _U._SENSITIVE = FALSE.
            
        WHEN "VISIBLE"          THEN ASSIGN _L._REMOVE-FROM-LAYOUT = TRUE
                                            _U._HANDLE:HIDDEN      = TRUE.

        WHEN "WIDTH"            THEN
           ASSIGN _L._WIDTH              = 
                IF SUBSTRING(_inp_line[4],LENGTH(_inp_line[4],"CHARACTER":U),1,
                                                 "CHARACTER":U) = "."
                  THEN DECIMAL(SUBSTRING(_inp_line[4],1,LENGTH(_inp_line[4],
                                          "CHARACTER":U) - 1,"CHARACTER":U))
                ELSE DECIMAL(_inp_line[4])
                  _U._HANDLE:WIDTH       = _L._WIDTH.

        WHEN "X"                THEN
          ASSIGN _U._HANDLE:X       = INTEGER(_inp_line[4])
                 _L._COL            = _U._HANDLE:COLUMN.

        WHEN "Y"                THEN
          ASSIGN _U._HANDLE:Y      = 
               IF SUBSTRING(_inp_line[4],LENGTH(_inp_line[4],"CHARACTER":U),1,
                                                "CHARACTER":U) = "."
                 THEN INTEGER(SUBSTRING(_inp_line[4],1,LENGTH(_inp_line[4],
                                         "CHARACTER":U) - 1,"CHARACTER":U))
               ELSE INTEGER(_inp_line[4])
                _L._COL            = _U._HANDLE:COLUMN.

      END CASE. /* ENTRY(2,_inp_line[2],":") -- ATTRIBUTE */
    END.

    ELSE IF _inp_line[5 + dyn_offset] = "=" AND INDEX(_inp_line[1],":") > 0 AND
      _inp_line[3] NE "BROWSE":U THEN DO:       /* if _inp_line[3] = BROWSE then this is a browse column
                                                   runtime attribute and we do not want to process it */
      temp-name = ENTRY(1,_inp_line[1],":").
      IF NUM-ENTRIES(temp-name,".") = 1 THEN
      DO:
        /* If the field is mapped to a data field (CLOB data fields
           are represented by local LONGCHAR editors and the local
           editor name has been mapped to the data field name)  
           the mapping is needed to read runtime attributes for
           the local fields. */
        lMapped = NO.
        IF cDataFieldMapping NE "":U THEN
          RUN checkName(INPUT temp-name, 
                        OUTPUT lMapped, 
                        OUTPUT cMappedTable,
                        OUTPUT cMappedField).
        IF lMapped THEN
          FIND _NAME-REC WHERE _NAME-REC._wNAME  = cMappedField AND
                               _NAME-REC._wTABLE = cMappedTable AND
                               NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE) AND
                               _NAME-REC._wFRAME = _inp_line[4] NO-ERROR.
        ELSE DO:
          IF NOT dyn_widget THEN
            FIND _NAME-REC WHERE _NAME-REC._wNAME = temp-name AND
                             NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                            AND _NAME-REC._wFRAME = _inp_line[4] NO-ERROR.
          ELSE
            FIND _NAME-REC WHERE _NAME-REC._wNAME = temp-name AND
                             NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE) NO-ERROR.        
        END.
      END.
      ELSE IF NUM-ENTRIES(temp-name,".") = 2 THEN
        FIND _NAME-REC WHERE _NAME-REC._wNAME  = ENTRY(2,temp-name,".") AND
                            _NAME-REC._wTABLE = ENTRY(1,temp-name,".") AND
                         NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                         AND _NAME-REC._wFRAME = _inp_line[4] NO-ERROR.
      ELSE IF NUM-ENTRIES(temp-name,".") = 3 THEN
        FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(3,temp-name,".") AND
                             _NAME-REC._wTABLE = ENTRY(2,temp-name,".") AND
                             _NAME-REC._wDBNAME = ENTRY(1,temp-name,".") AND
                         NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                         AND _NAME-REC._wFRAME = _inp_line[4] NO-ERROR.
      IF NOT AVAILABLE _NAME-REC AND import_mode = "IMPORT" THEN DO:
        FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
        IF AVAILABLE _U THEN _frame_name = _U._NAME.
        IF NUM-ENTRIES(temp-name,".") = 1 THEN
          FIND _NAME-REC WHERE _NAME-REC._wNAME = temp-name AND
                           NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                           AND _NAME-REC._wFRAME = _frame_name NO-ERROR.
        ELSE IF NUM-ENTRIES(temp-name,".") = 2 THEN
          FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(2,temp-name,".") AND
                               _NAME-REC._wTABLE = ENTRY(1,temp-name,".") AND
                           NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                           AND _NAME-REC._wFRAME = _frame_name.
        ELSE IF NUM-ENTRIES(temp-name,".") = 3 THEN
          FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(3,temp-name,".") AND
                               _NAME-REC._wTABLE = ENTRY(2,temp-name,".") AND
                               _NAME-REC._wDBNAME = ENTRY(1,temp-name,".") AND
                           NOT CAN-DO("FRAME,DIALOG-BOX,WINDOW", _NAME-REC._wTYPE)
                           AND _NAME-REC._wFRAME = _frame_name.
      END.
      FIND _U WHERE RECID(_U) = _NAME-REC._wRECID.
      IF _U._TYPE NE "BROWSE":U THEN FIND _F WHERE RECID(_F) = _U._x-recid.
      ELSE FIND _C WHERE RECID(_C) = _U._x-recid.
      FIND _L WHERE RECID(_L) = _U._lo-recid.    
                        
      CASE ENTRY(2,_inp_line[1],":"):
        WHEN "ALLOW-COLUMN-SEARCHING" THEN _C._COLUMN-SEARCHING = TRUE.
        WHEN "AUTO-INDENT"            THEN _F._AUTO-INDENT = TRUE. 
        WHEN "AUTO-RESIZE"            THEN _F._AUTO-RESIZE = TRUE. 
        WHEN "COLUMN-MOVABLE"         THEN _C._COLUMN-MOVABLE   = TRUE.
        WHEN "COLUMN-RESIZABLE"       THEN _C._COLUMN-RESIZABLE = TRUE.
        WHEN "DROP-TARGET"            THEN _U._DROP-TARGET = TRUE.
        WHEN "HIDDEN"                 THEN _U._HIDDEN = TRUE. 
        WHEN "MANUAL-HIGHLIGHT"       THEN _U._MANUAL-HIGHLIGHT = TRUE.
        WHEN "MAX-DATA-GUESS"         THEN _C._MAX-DATA-GUESS = INTEGER(_inp_line[6 + dyn_offset]). 
        WHEN "NUM-LOCKED-COLUMNS"     THEN _C._NUM-LOCKED-COLUMNS = INTEGER(_inp_line[6 + dyn_offset]). 
        WHEN "RETURN-INSERTED"        THEN _F._RETURN-INSERTED = TRUE.
        WHEN "ROW-RESIZABLE"          THEN _C._ROW-RESIZABLE = TRUE.
        WHEN "SELECTABLE"             THEN _U._SELECTABLE = TRUE.
        WHEN "SELECTED"               THEN _U._SELECTED = TRUE.
        WHEN "SEPARATOR-FGCOLOR"      THEN _L._SEPARATOR-FGCOLOR = INTEGER(_inp_line[6 + dyn_offset]).
        WHEN "MOVABLE"                THEN _U._MOVABLE = TRUE.
        WHEN "POPUP-MENU" THEN DO:
          /* Find the _U with the name of this menu.  Note: Parent menus
             are not located in any frame and they have unique names */
          FIND _NAME-REC WHERE _NAME-REC._wNAME = ENTRY(1,_inp_line[7 + dyn_offset],":") 
                           AND _NAME-REC._wDBNAME = ? AND _NAME-REC._wTABLE = ?
                           AND _NAME-REC._wTYPE = "MENU" NO-ERROR.
          IF AVAILABLE _NAME-REC THEN DO:
            FIND x_U WHERE RECID(x_U) eq _NAME-REC._wRECID. 
            ASSIGN _U._POPUP-RECID = RECID(x_U)
                  x_U._PARENT-RECID = RECID(_U).
          END.
          ELSE MESSAGE "Can't locate popup menu" ENTRY(1,_inp_line[7 + dyn_offset],":")
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
        /* AJC start */
        WHEN "DELIMITER"        THEN DO:              
            FIND _F WHERE RECID(_F) = _U._x-recid.    
            _F._DELIMITER = IF LENGTH(_inp_line[6]) = 1 
                  THEN  _inp_line[6]
                        ELSE IF SUBSTR(trim(_inp_line[6]),1,4) = "Chr(":U  and SUBSTR(trim(_inp_line[6]),LENGTH(trim(_inp_line[6])),1) = ")":U                              
                               THEN CHR(INTEGER(SUBSTR(_inp_line[6],5,length(_inp_line[6]) - 5)))
                               ELSE ",":U.
        END. /* AJC END */
        WHEN "PRIVATE-DATA"       THEN DO:
          /* This is for backwards compatability for beta blitz early versions of 7.3a */
          IF _inp_line[6 + dyn_offset] NE "" THEN _U._PRIVATE-DATA = _inp_line[6].
          ELSE DO:
            _inp_line = "".
            IMPORT STREAM _P_QS _inp_line.
            _U._PRIVATE-DATA = _inp_line[1].
            IF _inp_line[2] NE "" AND _inp_line[2] NE ".":U THEN
            _U._PRIVATE-DATA-ATTR = RIGHT-TRIM(LEFT-TRIM(_inp_line[2],":":U),".":U).
          END.
        END.
        WHEN "READ-ONLY"          THEN _F._READ-ONLY = TRUE. 
        WHEN "SENSITIVE"          THEN _U._SENSITIVE = FALSE.
        WHEN "RESIZABLE"          THEN _U._RESIZABLE = TRUE.
        WHEN "VISIBLE"            THEN ASSIGN _L._REMOVE-FROM-LAYOUT = TRUE
                                              _U._HANDLE:HIDDEN      = TRUE.
      END CASE. /* ENTRY(2,_inp_line[1],":") -- ATTRIBUTE */
    END.

    ELSE IF _inp_line[1] = "/*" AND 
            _inp_line[2] = "_MULTI-LAYOUT-RUN-TIME-ADJUSTMENTS" THEN
          RUN read_layout_defs.

    ELSE IF _inp_line[1] = "IF" AND _inp_line[2] = "SESSION:DISPLAY-TYPE" AND
            _inp_line[4] = "GUI":U THEN RUN get_window_hidden_value.

  END.  /* End of RUN-TIME-PROC Repeat block */

END PROCEDURE.  /* read_run_time_attributes */ 

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


PROCEDURE Get_Proc_Desc:
/* Read Procedure Description: Note that we only store this description if we
   are openning an existing file.  [So we effectively remove a Template's]
   Description if we creating a new one from it. ]  */
  DEFINE VARIABLE inline AS CHARACTER INITIAL "" FORMAT "X(1024)" NO-UNDO.
          
  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
  
  IMPORT STREAM _P_QS inline. 
  
  /* Only store the description when a file is "opened". */
  IF import_mode eq "WINDOW" THEN ASSIGN _P._DESC = inline.
  
END PROCEDURE. /* End of Get_Proc_Desc */

PROCEDURE TreeViewUpdate:
/* If Treeview design window, refresh the Treeview to show fields,
  code sections, etc. */

  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
  IF VALID-HANDLE(_P._tv-proc) THEN
    RUN createTree IN _P._tv-proc (RECID(_P)).

END PROCEDURE.

PROCEDURE setRepositoryObject:
/* jep-icf: Setup an _P record and it's design window for a repository object. */

  DEFINE VARIABLE cPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFlnm   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDesc   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSrcR   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCmpR   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrdM   AS CHARACTER  NO-UNDO.

  DO ON ERROR UNDO, LEAVE:
    /* Added FIRST option to the FIND in case there are duplicate records in _RYObject. 
      _RYObject should never have duplicate records as it is used only for dynamics and is
      temporary as it is deleted once the object is visualized on the screen */
    IF NOT AVAILABLE _RyObject THEN
      FIND FIRST _RyObject WHERE _RyObject.object_filename = open_file NO-LOCK NO-ERROR.
    
    IF NOT AVAILABLE _RyObject THEN RETURN.

    IF AVAILABLE _RyObject THEN DO:
      FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.

      /* Save some info */
      ASSIGN cPath = _P.object_path
             cFlnm = _P.object_filename
             cDesc = _P.object_description
             cSrcR = _P._save-as-path
             cCmpR = _P._compile-into
             cPrdM = _P.product_module_code.

      /*  jep-icf: Copy the repository related field values into the object's _P 
          record. With that accomplished, we no longer need the _RyObject record. It 
          only exists long enough to create a new or open an existing repository 
          object. From this point on, the _P handles the repository data. */
      BUFFER-COPY _RyObject TO _P.
      DELETE _RyObject.

      /* jep-icf: When creating a NEW object, set object_filename to unknown (?). */
      IF CAN-DO(_P.design_action, "NEW":U) THEN DO:
        IF cFlnm = "":U THEN
          ASSIGN _P.object_filename = ?.
        ELSE
          ASSIGN _P.object_path         = cPath
                 _P.object_filename     = cFlnm
                 _P.object_description  = cDesc
                 _P._save-as-path       = cSrcR
                 _P._compile-into       = cCmpR
                 _P.product_module_code = cPrdM.
      END. /* If a new object */

      /* jep-icf: Set some properties of the special dynamic object design window. */
      IF dyn_object
      THEN DO:
        /* We don't want an image on this object if it is a dynamic viewer,
           we also want to fix up the _P with a few things.   */
        IF LOOKUP("DynBrow":U, _P.PARENT_classes) <> 0
        OR LOOKUP("DynSDO":U, _P.PARENT_classes)  <> 0
        OR LOOKUP("DynView":U, _P.PARENT_classes) <> 0
        OR LOOKUP("DynDataView":U, _P.PARENT_classes) <> 0
        OR _P.OBJECT_type_code = "DynBrow":U
        OR _P.OBJECT_type_code = "DynSDO":U
        OR _P.OBJECT_type_code = "DynView":U
        OR _P.OBJECT_type_code = "DynDataView":U
        THEN DO:
          ASSIGN
            _P.object_filename = _P._save-as-file
            _P.run_when        = "ANY":U.
        END.
        ELSE
          RUN adeuib/_setdesignwin.p (INPUT RECID(_P)).
      END.  /* If a dynamic object */
      ELSE IF CAN-DO(_P.design_action, "NEW":U)
      THEN DO:
        IF INDEX(_P._save-as-file,cPath) = 0 and cpath <> "" 
        THEN
          ASSIGN
            _P._save-as-file = cPath + "/":U + _P._save-as-file.
        ELSE
          ASSIGN
            _P._save-as-file = _P._save-as-file.
      END.
    END.

  END.  /* DO ON ERROR */

END PROCEDURE.


PROCEDURE processRepositoryObject:
/* jep-icf: Process a request to create a new or open an existing repository 
   object. Handles both static and dynamic. */

/* Note: The check for the valid template and property sheet is done in ry/prc/rygendynp.p. So this may be redundant 
         for dynamic objects */

  DEFINE VARIABLE lIsValidClass AS LOGICAL NO-UNDO.
  def var lCanFindPropSheet as log no-undo.
  def var lCanFindDesignTemplate as log no-undo.

  DO ON ERROR UNDO, LEAVE:

    /* jep-icf: If there isn't an _RyObject, then we aren't processing a
       repository object. */
    FIND FIRST _RyObject WHERE _RyObject.object_filename = open_file NO-LOCK NO-ERROR.
        
    ASSIGN isRyObject = AVAILABLE _RyObject.
    IF NOT AVAILABLE _RyObject THEN RETURN.

    ASSIGN dyn_object = (NOT _RyObject.static_object).
    IF dyn_object THEN
    DO:
      ASSIGN dyn_temp_file = _Ryobject.design_template_file.

      /* Check that the class of the dynamic object is a child of either a DynView, DynBrow,DynSDO,DynSBO, DynContainer or DynTree class.
         These are the only supported dynamic objects in the appBuilder */
      lIsValidClass = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynView":U) OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynBrow":U) OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynSDO":U)  OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynSBO":U)  OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynContainer":U)  OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynDataView":U)  OR
                      DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _RyObject.object_type_code,"DynTree":U).
      
        lCanFindDesignTemplate = search(_Ryobject.design_template_file) ne ?.
        
        /* In certain cases, the property sheets are in adeuib. In this case, we don't always ship 
           source code and so need to also look for the r-code, which will be run. */
        lCanFindPropSheet = search(_Ryobject.design_propsheet_file) ne ? or
                            search(replace(_Ryobject.design_propsheet_file, ".p", ".r")) ne ? or
                            search(replace(_Ryobject.design_propsheet_file, ".w", ".r")) ne ? .
        
        /* Only check for the existence of the propsheet file for DynContainer objects. */                            
        if not dynamic-function('classIsA' in gshRepositoryManager, _RyObject.object_type_code, 'DynContainer') then
            lCanFindPropSheet = Yes.

      IF NOT lIsValidClass OR not lCanFindDesignTemplate or not lCanFindPropSheet then 
      DO:
      /* If we can't determine the template file or the property sheet procedure, we can't open the object. */
        /* Reset the cursor for user input.*/
        RUN adecomm/_setcurs.p ("").
        IF NOT lIsValidClass THEN
          MESSAGE "Cannot open or create the dynamic object" 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The object is specified as a dynamic object, but the object type is '" + _RyObject.object_type_code + "'." + CHR(10) 
                   + "The only supported dynamic objects are 'DynView, DynBrow, DynDataView, DynSDO, DynSBO, DynContainer and their extensions." + CHR(10) 
                   + "Check in the Repository Maintenance tool whether the object is defined as a static or dynamic object."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ELSE IF _Ryobject.design_template_file = "" THEN
          MESSAGE "Cannot open or create the dynamic object" 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The dynamic object's template file or property sheet procedure could not be found." + CHR(10)
                   + "Check that the appropriate custom object files (.cst) are loaded from either the static"  + CHR(10)
                   + ".cst files, or from the repository.  If from static .cst files, the object type must be specified" + CHR(10)
                   + "and there must be an entry for the 'NEW-TEMPLATE' property and the 'PROPERTY-SHEET' attribute." + CHR(10)
                   + "If its loading from the repository, ensure there is an object and object instance in the appropriate 'Template'" + CHR(10)
                   + "and 'Palette' class and that the 'PaletteNewTemplate' and the TemplatePropertySheet' attributes are set."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ELSE IF not lCanFindDesignTemplate THEN
          MESSAGE "Cannot open or create the dynamic object " 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The dynamic object's template file '" + _Ryobject.design_template_file + "' could not be found." + CHR(10)
                   + "If the system is loading a static custom .cst file, ensure that the entry for the 'NEW-TEMPLATE'" + CHR(10) 
                   + "property and the 'PROPERTY-SHEET' attribute can be found in the PROPATH."
                   + "If its loading the .cst from the repository, ensure that the 'PaletteNewTemplate' and the TemplatePropertySheet'" + CHR(10)
                   + "attributes are set and can be found in the PROPATH."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        ELSE IF not lCanFindPropSheet then
          MESSAGE "Cannot open or create the dynamic container " 
                   + (IF _RyObject.object_filename > "" THEN " '" + _RyObject.object_filename + "'." ELSE "."  )  + CHR(10) + CHR(10)
                   + "The dynamic object's property file '" + _Ryobject.design_propsheet_file + "' could not be found." + CHR(10) 
                   + "If the system is loading a static custom .cst file, ensure that the entry for the 'PROPERTY-SHEET' attribute" + CHR(10) 
                   + "can be found in the PROPATH. If it's loading the .cst from the repository, ensure that the 'PaletteNewTemplate'" + CHR(10) 
                   + "and the TemplatePropertySheet' attributes are set and can be found in the PROPATH."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

        ASSIGN AbortImport = Yes.
        RUN qssucker_cleanup. /* Close everything qssucker does */
        RETURN "_ABORT":U.
      END. /* Can't find template or prop sheet. */

      /* jep-icf-temp: We have a dynamic object. Create a special temporary template file to open.
         Do this for both NEW and OPEN. I don't think we need to do this. So comment out for now. */
/*
      RUN adecomm/_tmpfile.p ("dyn":U, ".tmp":U, OUTPUT dyn_temp_file).
      OS-COPY VALUE(_Ryobject.design_template_file) VALUE(dyn_temp_file).
*/
    END.
    ELSE IF NOT dyn_object THEN /* Static Object */
    DO:
      IF CAN-DO(_RyObject.design_action,"OPEN":u) THEN
      DO:
        /* jep-icf-temp: Need to make some API call to return a static object's physical file name. */
        RUN adecomm/_osfmush.p (INPUT _Ryobject.object_path, INPUT _Ryobject.object_filename,
                                OUTPUT open_file).
        /* IZ 2467 Add object extension if there is one. */
        IF NUM-ENTRIES(open_file,".") <= 1 THEN
           ASSIGN open_file = open_file + "." + _RyObject.object_extension WHEN (_RyObject.object_extension <> "").
      END.
    END.
    
  END.  /* DO ON ERROR */

END PROCEDURE.

PROCEDURE checkName:
/* This procedure takes a local field name and tries to find a mapping for it, it 
   returns a logical if a mapping was found and the data field table and field names
   the local field is mapped to.  A mapping exists for CLOB data fields that are
   represented by local LONGCHAR editors on viewer frames. */
  DEFINE INPUT  PARAMETER pcName         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plMapped       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcMappedTable  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcMappedField  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cMappedEntry AS CHARACTER  NO-UNDO.

  IF LOOKUP(pcName, cDataFieldMapping) > 0 THEN
  DO:
    cMappedEntry = DYNAMIC-FUNCTION("mappedEntry":U IN _h_func_lib,
                                     INPUT pcName,
                                     INPUT cDataFieldMapping,
                                     INPUT TRUE,
                                     INPUT ",":U).
    plMapped = TRUE.

    IF NUM-ENTRIES(cMappedEntry, ".":U) > 1 THEN
      ASSIGN
        pcMappedTable  = ENTRY(1, cMappedEntry, ".":U)
        pcMappedField  = ENTRY(2, cMappedEntry, ".":U).
    ELSE pcMappedField = cMappedEntry.

  END.

END PROCEDURE.
/* _qssuckr.p - end of file */

