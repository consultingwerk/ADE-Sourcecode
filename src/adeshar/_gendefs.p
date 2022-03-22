/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _gendefs.p

Description:
    Procedure called by _gen4gl.p, _qikcomp.p and _writedf.p to generate the
    definitions of a .w file.  
   
    When called from _writedf.p it is intended write code for checking
    QUERY syntax (from the query builder).  In that case we don't want
    put out the existing query definition, so we need to skip queries.

Preprocessor Parameters:

Input Parameters:
    p_status     = used to check status of _U records
    skip_queries = IF DEFINED, don't write out queries.

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

Last Modifed:

    02/01/01 JEP  Added code to generate frame WITH phrase when breaking frame
                  statements for 4k limit. New: Procedure put-frame-with-clause
                  and added gentitle parameter to put_color_font_title.
                  ( Issue 273 )
    07/02/99 TSM  Removed generation of NO-BOX for editor widgets, genproc.i 
                  already does this
    06/30/99 TSM  Added support for NO-AUTO-VALIDATE for frames
    06/18/99 TSM  Stop generation of format for SIMPLE and DROP-DOWN combo-boxes
    06/14/99 TSM  Added support for NO-AUTO-VALIDATE
    06/04/99 TSM  Added support for context-sensitive help
    06/03/99 TSM  Added support for stretch-to-fit, retain-shape and transparent
                  image attributes
    02/25/99 JEP  Db-Aware preprocessor start and end around open-query's only.
    10/19/98 GFS  Changed code generation order for buttons such that FLAT-BUTTON
                  comes out after NO-FOCUS.
    07/15/98 HD   Added support for User Fields 
    03/31/98 SLK  Added support for SmartDataBrowser CalcField Check Syntax
                   Uses skip_queries to output DEFINE TEMP-TABLE rowObject
    03/10/98 SLK  Removed support for DO's Private-data
    03/04/98 JEP  Reworked the _TT temp-table handling.
    02/20/98 HD   If WEB don't RUN adeuib/_tabordr.p 
    02/17/98 GFS  Added new browse attrs. ROW-HEIGHT-CHARS and EXPANDABLE
    02/13/98 SLK  Added support for generating SmartData.i
    02/10/98 GFS  Added support for NO-TAB-STOP
    01/30/98 GFS  Add new browse attrs.
    04/09/97 JEP  Move function prototypes to just after preprocess defs.
    04/07/97 GFS  Write out COM-HANDLE defs for Control Frames
    01/31/97 JEP  Write out function prototypes
    10/29/96 GFS  Write out TOOLTIP for field-level widgets
    09/25/95 WTW  Add ADM-CONTAINER type = "VIRTUAL" if no frames allowed 
    03/27/95 GFS  Removed Procedure Query and added "basic" query
    09/22/94 GFS  Added XFTR support
    12/29/93 RPR  Added new browser widget attributes
---------------------------------------------------------------------------- */

{adeuib/sharvars.i}    /* UIB shared variables                               */
{adeuib/uniwidg.i}     /* Universal widget definitions                       */
{adeuib/layout.i}      /* Layout temp-table definitions                      */
{adeuib/triggers.i}    /* Trigger TEMP-TABLE definitions                     */
{adeuib/links.i}       /* ADM links TEMP-TABLE definition                    */
{adeuib/xftr.i}        /* XFTR TEMP-TABLE definition                         */
{adeuib/brwscols.i}    /* Browse Column Temp-table                           */
{src/adm2/globals.i}   /* Dynamics global variables                          */



/* FUNCTION PROTOTYPES */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.
FUNCTION db-tbl-name RETURNS CHARACTER
  (INPUT db-tbl AS CHARACTER) IN _h_func_lib.
FUNCTION dbtt-fld-name RETURNS CHARACTER
  (INPUT rec-recid AS RECID) IN _h_func_lib.

DEFINE INPUT PARAMETER p_status     AS CHARACTER                       NO-UNDO.
DEFINE INPUT PARAMETER skip_queries AS LOGICAL                         NO-UNDO.

{adeshar/genshar.i}    /* Shared variable definitions                        */

DEFINE SHARED STREAM P_4GL.

/* Variables used for generating smartdata.i */
DEFINE VARIABLE sdo_temp-file    AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE sdo_temp-fileInW AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cTemp            AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cTemp1           AS CHARACTER                             NO-UNDO.
DEFINE STREAM P_4GLSDO.


/* Local Definitions:  these variables are used only in _gendefs.i.  
   They are defined here because this is included in two files:
      adeshar/_gen4gl.p and adeuib/_qikcomp.p
   By defining these variables here, we don't have to do it in each .p.      */
   
{ adeuib/dialvars.i }  /* Standard dialog border width and height            */
{ adeuib/property.i }  /* List of valid properties by type                   */
{ adecomm/appsrvtt.i } /* Give this file access to the AppServer Temp-table  */

DEF VAR brwsr_bufs     AS CHARACTER                                   NO-UNDO.
DEF VAR cancel_btn     AS CHARACTER                                   NO-UNDO.
DEF VAR cnt            AS INTEGER                                     NO-UNDO.
DEF VAR col-hdl        AS HANDLE                                      NO-UNDO.
DEF VAR curr_browse    AS CHARACTER                                   NO-UNDO.
DEF VAR def-line       AS CHARACTER                                   NO-UNDO.
DEF VAR define_type    AS CHARACTER                                   NO-UNDO.
DEF VAR frame_layer    AS HANDLE                                      NO-UNDO.
DEF VAR i              AS INTEGER                                     NO-UNDO.
DEF VAR include-name   AS CHARACTER                                   NO-UNDO.
DEF VAR repos-inc-name AS CHARACTER                                   NO-UNDO.
DEF VAR isaSO          AS LOGICAL                                     NO-UNDO.
DEF VAR l_dummy        AS LOGICAL                                     NO-UNDO.
DEF VAR lDLProc        AS LOGICAL                                     NO-UNDO.
DEF VAR q_label        AS CHARACTER                                   NO-UNDO.
DEF VAR seq-num        AS INTEGER                                     NO-UNDO.
DEF VAR tab-ord        AS INTEGER                                     NO-UNDO.
DEF VAR tmp_date       AS DATE                                        NO-UNDO.
DEF VAR tmp_datetime   AS DATETIME                                    NO-UNDO.
DEF VAR tmp_datetimetz AS DATETIME-TZ                                 NO-UNDO.
DEF VAR tmp_name       AS CHARACTER                                   NO-UNDO.
DEF VAR tmp_string     AS CHARACTER                                   NO-UNDO.
DEF VAR tmp_str2       AS CHARACTER                                   NO-UNDO.
DEF VAR tmp_db         AS CHARACTER                                   NO-UNDO.
DEF VAR tmp_tbl        AS CHARACTER                                   NO-UNDO.
DEF VAR win_variable   AS CHARACTER                                   NO-UNDO.
DEF VAR lDbRequiredDone AS LOGICAL                                    NO-UNDO. 
DEF VAR cSourceList    AS CHARACTER                                   NO-UNDO.

DEFINE TEMP-TABLE acopy
       FIELD _u-recid AS RECID
    INDEX _u-recid IS PRIMARY UNIQUE _u-recid.

DEFINE TEMP-TABLE defined
       FIELD _name      AS CHAR
       FIELD _data-type AS CHAR
       FIELD _type      AS CHAR
    INDEX _name IS PRIMARY UNIQUE _name.

DEF BUFFER x_C  FOR _C.
DEF BUFFER x_F  FOR _F.
DEF BUFFER x_L  FOR _L.
DEF BUFFER x_Q  FOR _Q.
DEF BUFFER x_U  FOR _U.
DEF BUFFER xx_U FOR _U.


/* END OF LOCAL DEFINITIONS */

/* We need a local variable to hold the name of the current layout.  This is */
/* equal to the {&WINDOW-NAME}-layout (limited to only 32 characters).  We   */
/* only need this if there is more than one layout.                          */
FIND _U WHERE _U._HANDLE = _h_win.
FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".
FIND _C WHERE RECID(_C) = _U._x-recid.
FIND _P WHERE _P._u-recid = RECID(_U).

/* Initialize information about this window. [Note: if this is a "window"
   .w file that does not "allow the window, then use CURRENT-WINDOW.] */
ASSIGN wndw          = (_U._TYPE eq "WINDOW")   /* Else a dialog box */
       tty_win       = NOT _L._WIN-TYPE
       win_name      = _U._NAME
       /* If the file has NO window, then the "variable" that maps to the
          default window will be CURRENT-WINDOW */
       win_variable  = IF CAN-DO(_P._allow, "Window":U) 
                       THEN win_name
                       ELSE "CURRENT-WINDOW"
        .
IF CAN-FIND(FIRST _L WHERE _L._LO-NAME NE "Master Layout" AND
                           _L._u-recid EQ RECID(_U)) THEN DO:
  /* Create the layout variable */
  IF LENGTH(win_variable,"CHARACTER":U) > 30 
  THEN layout-var = SUBSTRING(win_variable,1,30,"CHARACTER":U) + "-l".
  ELSE DO:
    layout-var = win_variable + "-layout".
    IF LENGTH(layout-var,"CHARACTER":U) > 32
    THEN layout-var = SUBSTRING(layout-var,1,32,"CHARACTER":U).
  END.
END.

/* Put out window name (which is equal to the frame-name for dialog boxes).
   Only put this code out if UIB file type is .w (window).
*/
IF _P._FILE-TYPE = "w":U THEN
DO:
    PUT STREAM P_4GL UNFORMATTED
      "&Scoped-define WINDOW-NAME " win_variable SKIP.
    IF wndw THEN curr_frame = "".
    ELSE DO:
      ASSIGN curr_frame = _U._NAME.  /* The dialog-box */
      PUT STREAM P_4GL UNFORMATTED
         "&Scoped-define FRAME-NAME " curr_frame SKIP.
    END.
END.

/* First of all, output the users custom DECLARATION code if any
   This is for statements like using and routine level error that must come 
   before any other statements like defintions and executions 
   NOTE: No XFTR block will currently be written before this 
   (The current block ordering is implemented in a way that 
    nests blocks using recids for xftr and predefined negative 
    numbers (adeuib/pre_proc.i) for supported sections. This is a 
    bit complicated (although possible) to use for a block that 
    is optional and the need for an xftr before this is rather 
    unlikely (could in theory be needed if xftr code 
    should write THIS section, but one might as well replace  
    this with the xftr in that case)  */
FIND _TRG  WHERE _TRG._wRECID = RECID(_U) AND
                 _TRG._tSECTION = "_CUSTOM" AND
                 _TRG._tEVENT = "_DECLARATIONS" AND
                 _TRG._STATUS EQ u_status NO-ERROR.
IF AVAILABLE _TRG THEN DO:
   PUT STREAM P_4GL UNFORMATTED SKIP(1).
   RUN put_code_block.
END. /* If we have the trigger */

/* Write out include and AppServer handles if this is AppServer Aware */
IF _P._app-srv-aware THEN DO:
  PUT STREAM P_4GL UNFORMATTED "~{adecomm/appserv.i}" SKIP.
  FOR EACH AppSrv-TT WHERE AppSrv-TT.Partition NE "":
    PUT STREAM P_4GL UNFORMATTED
       "DEFINE VARIABLE h_" + REPLACE(AppSrv-TT.Partition," ","_") +
               FILL(" ", MAX(1,25 - LENGTH(AppSrv-TT.Partition,"CHARACTER"))) +
               "AS HANDLE          NO-UNDO."  SKIP.
  END.
END.

/* We want FRAME-NAME and BROWSE-NAME to point to the first name of these types.
   Also, we want the FRAME-NAME to point to the parent frame of the window
   (Except if the user has indicated a specific frame for frame name.)
   Remember the first browser name and the designated frame name frame. */
IF _P._frame-name-recid NE ? THEN DO:
  FIND x_U WHERE RECID(x_U) = _P._frame-name-recid and x_U._STATUS BEGINS u_status
                 NO-ERROR.
  IF AVAILABLE x_U THEN frame_name_f = x_U._NAME.
END.
IF _P._frame-name-recid = ? OR NOT AVAILABLE x_U THEN DO:
  FIND FIRST x_U WHERE CAN-DO("FRAME,DIALOG-BOX":U, x_U._TYPE)  
                   AND x_U._WINDOW-HANDLE eq _h_win  
                   AND x_U._STATUS BEGINS u_status
                   AND x_U._PARENT-RECID = RECID(_U)
                 USE-INDEX _OUTPUT NO-ERROR.
  IF AVAILABLE x_U THEN frame_name_f = x_U._NAME.
  ELSE DO:
    FIND FIRST x_U WHERE CAN-DO("FRAME,DIALOG-BOX":U, x_U._TYPE)  
                     AND x_U._WINDOW-HANDLE eq _h_win  
                     AND x_U._STATUS BEGINS u_status
                   USE-INDEX _OUTPUT NO-ERROR.
    IF AVAILABLE x_U THEN frame_name_f = x_U._NAME.
  END.
END.
FIND FIRST x_U WHERE x_U._TYPE eq "BROWSE":U 
                 AND x_U._WINDOW-HANDLE eq _h_win  
                 AND x_U._STATUS BEGINS u_status
               USE-INDEX _OUTPUT NO-ERROR.
IF AVAILABLE x_U THEN first_browse = x_U._NAME.

/* Write out any XFTRs following the TopOfFile section of .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&TOPOFFILE}, INPUT no).

/* Write out temp-tables and buffers */
IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) AND 
  NOT CreatingSuper THEN DO:
  RUN gen-tt-def (OUTPUT def-line).
  PUT STREAM P_4GL UNFORMATTED SKIP(1)
    def-line SKIP(1). 
END.

/* Write out user fields */
IF CAN-FIND(FIRST _UF WHERE _UF._p-recid = RECID(_P)) THEN DO:
  RUN gen-uf-def (OUTPUT def-line).
  PUT STREAM P_4GL UNFORMATTED SKIP(1)
     "/* User Field definitions                                              */"
     SKIP
     def-line SKIP (1).
END.
 
/* First Output the users custom DEFINITIONS code (if any)                      */
FIND _TRG  WHERE _TRG._wRECID = RECID(_U) AND
                 _TRG._tSECTION = "_CUSTOM" AND
                 _TRG._tEVENT = "_DEFINITIONS" AND
                 _TRG._STATUS EQ u_status NO-ERROR.
IF AVAILABLE _TRG THEN DO:
  IF CreatingSuper THEN DO:
    /* Set FILE: line to just File: */
    FileSet:
    DO i = 1 TO NUM-ENTRIES(_TRG._tCode, CHR(10)):
      cTemp = ENTRY(i, _TRG._tCode,CHR(10)).
      IF cTemp BEGINS "  File: ":U THEN DO:
        cTemp = "  File: ":U + IF INDEX(_P._SAVE-AS-FILE, "~\":U) > 0
                THEN ENTRY( NUM-ENTRIES(_P._SAVE-AS-FILE, "~\":U), 
                                        _P._SAVE-AS-FILE, "~\":U)
                ELSE _P._SAVE-AS-FILE.
        ENTRY(i, _TRG._tCode, CHR(10)) = cTemp.
        LEAVE FileSet.
      END. /* If we find the file name line */
    END. /* IndentObject Do i = 1 to num-lines */

    /* Set identifying object global to AstraProcedure */
    IdentObject:
    DO i = 1 TO NUM-ENTRIES(_TRG._tCode, CHR(10)):
      cTemp = ENTRY(i, _TRG._tCode,CHR(10)).
      IF cTemp BEGINS "&glob ":U THEN DO:
        IF cTemp MATCHES "*astra* yes*" THEN DO:
          cTemp = "&glob   AstraProcedure    yes":U.
          ENTRY(i, _TRG._tCode, CHR(10)) = cTemp.
          LEAVE IdentObject.
        END.  /* If we find the line to replace */
      END. /* If we find a global definition */
    END. /* IndentObject Do i = 1 to num-lines */

    /* Mesage the header comments to make it look like a real structured procedure */
    ASSIGN _TRG._tCode = REPLACE(_TRG._tCode,
                         "from viewer.w - Template for SmartDataViewer objects":U,
                         "Custom Super Procedure":U).
  END. /* If CreatingSuper */
  RUN put_code_block.
  /* Add any XFTR sections that follow DEFINITIONS */ 
  IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&DEFINITIONS}, INPUT no).
END. /* If we have the trigger */

/* Before we write out any lists, compute the TAB-ORDER of all objects in
   all the frames we are going to be writing out.  */
FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _h_win
              AND CAN-DO("FRAME,DIALOG-BOX", x_U._TYPE) 
              AND x_U._STATUS eq u_status:
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN        /* In FreezeFrame don't do this. */
   IF NOT (_P._TYPE BEGINS "WEB") THEN
     RUN adeuib/_tabordr.p (INPUT u_status, INPUT RECID(x_U)).
&ENDIF
   /* Make sure Smartqueries are at the end of the tab order */
   FOR EACH xx_U WHERE xx_U._WINDOW-HANDLE eq _h_win AND
                       xx_U._PARENT-RECID = RECID(x_U) AND
                       xx_U._TYPE eq "SmartObject":U AND
                       xx_U._SUBTYPE eq "SmartQuery":
      xx_U._TAB-ORDER = xx_U._TAB-ORDER + 1500.
   END.
   tab-ord = 0.
   DO PRESELECT EACH xx_U WHERE xx_U._WINDOW-HANDLE eq _h_win AND
                       xx_U._PARENT-RECID = RECID(x_U) AND
                       xx_U._TAB-ORDER > 0
                       BY xx_U._TAB-ORDER:
     REPEAT:
       FIND NEXT xx_U.
       ASSIGN tab-ord = tab-ord + 1
              xx_U._TAB-ORDER = tab-ord.
     END.
   END. /* DO Preselect */
END. /* For each frame or dialog */

/* ************************************************************************* */
/*                                                                           */
/*                         PREPROCESSOR DEFINITIONS                          */
/*                                                                           */
/* ************************************************************************* */

IF p_status NE "PREVIEW" THEN
PUT STREAM P_4GL UNFORMATTED
    "&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK "  SKIP.
    
/* Define the frames for this window                                         */
PUT STREAM P_4GL UNFORMATTED SKIP (1)
   "/* ********************  Preprocessor Definitions  ******************** */"
    SKIP (1)
    .

/* IF object is a smartDataObject and there is a datalogic procedure */
IF (_P._TYPE = "SmartDataObject":U OR _P._TYPE = "SmartBusinessObject":U ) AND _C._DATA-LOGIC-PROC > "" THEN
   PUT STREAM P_4GL UNFORMATTED 
    "&Global-define DATA-LOGIC-PROCEDURE ":U REPLACE(_C._DATA-LOGIC-PROC,"~\":U,"/") SKIP(1).
    
/* Only put out Procedure-Type for .p and .w files (not for .i's) */
IF _P._TYPE ne "" AND _P._FILE-TYPE ne "i":U THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define PROCEDURE-TYPE ":U _P._TYPE SKIP
    "&Scoped-define DB-AWARE ":U _P._db-aware SKIP(1).
    
IF _P._html-file ne ""  THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define WEB-FILE ":U _P._html-file SKIP (1).

/*The widget-id file name is assigned only when the container is saved the first time, in that case
  _widgetid-file-name = ?, and blank is the default value that is not written in the code. So if the file
  is not blank and not null is because the container already has a file name assigned, so write it.*/
IF _P._widgetid-file-name NE "" AND _P._widgetid-file-name NE ?  THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define WIDGETID-FILE-NAME ":U _P._widgetid-file-name SKIP (1).
ELSE
    /*If the file is saved the first time (_P._widgetid-file-name = ?), and we have the flags to assign
      custom widget-id file name in the preference page, we write it in the code.*/
    IF _widgetid_save_filename AND NOT _widgetid_default_filename AND _P._widgetid-file-name = ? THEN
      PUT STREAM P_4GL UNFORMATTED 
        "&Scoped-define WIDGETID-FILE-NAME ":U _widgetid_custom_filename SKIP (1).

/* Is it an adm container?  Put out Window, Frame, or Dialog-box. 
   Note that Frames are "no-window" windows.  The final (unusual) case
   is a "virtual" ADM-CONTAINER that holds only SmartObjects, but which can
   have no FRAME or WINDOW. */
IF CAN-DO(_P._allow,"Smart") AND NOT CreatingSuper THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define ADM-CONTAINER " 
    (IF _U._TYPE eq "DIALOG-BOX":U      THEN "DIALOG-BOX":U
     ELSE IF CAN-DO(_P._allow,"WINDOW") THEN "WINDOW":U
     ELSE IF _P._max-frame-count eq 0   THEN "VIRTUAL":U
     ELSE "FRAME":U)
    SKIP (1).

IF layout-var ne "" THEN
  PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define LAYOUT-VARIABLE " layout-var
    SKIP (1).

/* Put UIB supported (and internal links) */
RUN put_links.

/* Put in the TEMP-TABLE definitions for the Object Temp-Tables for SBOs */
IF _P._TYPE = "SmartBusinessObject":U THEN
  RUN put_contained_tables.

/* Db-Required Preprocessor defs. */
IF _P._DB-AWARE THEN
DO:
  RUN gen-db-required(output def-line).
  IF def-line <> '':U THEN
   PUT STREAM P_4GL UNFORMATTED SKIP(1)
       def-line.
END.

/* Generate Data Logic Procedure preprocessor definitions */
IF _DynamicsIsRunning AND VALID-HANDLE(gshRepositoryManager) THEN
DO:
  IF DYNAMIC-FUNCTION("classIsA":U IN gshRepositoryManager,
                   INPUT _P.object_type_code,
                   INPUT "DLProc":U) THEN 
    ASSIGN lDLProc = TRUE.
END.  /* if dynamics is running and valid repos manager */
/* Even if Dynamics is running, the object being opened may be a data
   logic procedure but may not be registered in the repository so 
   _P._TYPE must always be checked. */
IF _P._TYPE = "DataLogicProcedure":U THEN
  ASSIGN lDLProc = TRUE.

IF lDLProc THEN
DO:
  IF _C._DATA-LOGIC-PROC-TABLE-BUFF NE "":U THEN
    PUT STREAM P_4GL UNFORMATTED
      "&Global-define TABLE-NAME ":U _C._DATA-LOGIC-PROC-TABLE-BUFF SKIP.
  IF _C._DATA-LOGIC-PROC-BUFF-SUFFIX NE "":U THEN
    PUT STREAM P_4GL UNFORMATTED
      "&Global-define DATA-LOGIC-TABLE ":U _C._DATA-LOGIC-PROC-BUFF-SUFFIX SKIP.
  IF _C._DATA-LOGIC-PROC-INCLUDE NE "":U THEN
    PUT STREAM P_4GL UNFORMATTED
     '&Global-define DATA-FIELD-DEFS "':U + _C._DATA-LOGIC-PROC-INCLUDE + '"':U SKIP.
  IF _C._Rowobject-NO-UNDO THEN 
    PUT STREAM P_4GL UNFORMATTED
      "&Global-define DATA-TABLE-NO-UNDO NO-UNDO":U SKIP.
END.  /* if data logic procedure */


/* If a SmartBrowse or SmartViewer - define the temp-table include file */
IF _P._data-object > "" THEN 
DO:
  /* Avoid this if _p._data-object IS an include  (identified by comma sep) */ 
  IF NUM-ENTRIES(_P._data-object) = 1 THEN 
  DO:

    ASSIGN i            = R-INDEX(_P._data-object,".")
           include-name = IF i > 0 THEN SUBSTRING(_P._data-object,1,i) + "i" 
                                   ELSE _P._data-object + ".i".
           
    /* Remove X:/ (where X is the MS-DOS drive letter) if it can be found in
       the propath - IZ 9617                                                 */
    IF include-name MATCHES ".:*":U THEN DO:
      IF SEARCH(SUBSTRING(include-name, 4, -1, "CHARACTER")) NE ? THEN
         include-name = SUBSTRING(include-name, 4, -1, "CHARACTER").
    END.
  
    include-name = REPLACE(include-name,"~\","~/").
  
    /* find include from repos (if name is pathed we know it's a static source)
       Repository has presedence if file should exist in propath with same name
       as logical name. (get-sdo-hdl in _abfunc and wizards uses same rule) */
    IF _DynamicsIsRunning AND INDEX("~/",include-name) = 0 THEN 
    DO: 
      /* Check whether specified proc-filename is a repository object */
      IF VALID-HANDLE(gshRepositoryManager) THEN
      DO:
        repos-inc-name = DYNAMIC-FUNCTION("getSDOincludeFile" IN gshRepositoryManager, 
                                        include-name).
        IF repos-inc-name > '' THEN
          include-name = repos-inc-name.
      END.
  
    END.  /* If unable to locate include-file and ICF is running */
    /* quote in case of spaces in name */
    include-name = '"' + include-name + '"'.
  
    PUT STREAM P_4GL UNFORMATTED
      "/* Include file with RowObject temp-table definition */" SKIP
      "&Scoped-define DATA-FIELD-DEFS " + include-name SKIP(1).
  END. /* num-entries(_P._data-object) = 1  */

  /* The following is used by the Query Builder for a SmartDataBrowser referencing
   * a SmartData. We generate the temp-table in order to do a CHECK-SYNTAX */
  IF skip_queries THEN
    RUN put_tt_defs. 
  
END.

/* List the designated Frame-Name and First Browse */
IF (frame_name_f ne "" OR first_browse ne "") AND NOT CreatingSuper THEN DO:
  ASSIGN curr_frame  = frame_name_f
         curr_browse = first_browse.
  IF _P._frame-name-recid = ? THEN
    PUT STREAM P_4GL UNFORMATTED
     "/* Name of first Frame and/or Browse and/or first Query                 */" 
     SKIP.
  ELSE PUT STREAM P_4GL UNFORMATTED
     "/* Name of designated FRAME-NAME and/or first browse and/or first query */"
     SKIP.
  IF curr_frame NE "" THEN PUT STREAM P_4GL UNFORMATTED
    "&Scoped-define FRAME-NAME " curr_frame SKIP.
  IF curr_browse NE "" THEN PUT STREAM P_4GL UNFORMATTED
    "&Scoped-define BROWSE-NAME " curr_browse SKIP.
END.  /* Frame_name_f or first_browse */

/* Write out QUERY-NAME. This will get written out even if a query
 * exists without a table list 
 */
FIND FIRST x_U WHERE x_U._TYPE = "QUERY" 
                 AND x_U._WINDOW-HANDLE eq _h_win  
                 AND x_U._STATUS BEGINS u_status USE-INDEX _NAME NO-ERROR.
IF AVAILABLE x_U THEN PUT STREAM P_4GL UNFORMATTED
  "&Scoped-define QUERY-NAME " x_U._NAME SKIP.
PUT STREAM P_4GL UNFORMATTED SKIP(1).

/* Now put the external tables.  Note: I have seen cases where xTblList becomes
   unknown.  Make sure this doesn't happen. */
IF _P._xTblList eq ? THEN _P._xTblList = "".
/* No need to write out out external table preprocessor variables for an export
   because we don't look at them when reading it back in.                    */ 
IF _P._xTblList ne "" AND p_status NE "EXPORT":U THEN DO:
  PUT STREAM P_4GL UNFORMATTED
    "/* External Tables                                                      */" 
    SKIP.
  /* Put out a comma delimeted list */
  RUN put_tbllist (_P._xTblList, FALSE, 
                   "EXTERNAL-TABLES":U, "&1-EXTERNAL-TABLE":U, 1," ":U).
  PUT STREAM P_4GL UNFORMATTED SKIP (1).
   
  /* If outputting external tables put out an unused query to get the
     external tables properly scoped. */
  PUT STREAM P_4GL UNFORMATTED
         "/* Need to scope the external tables to this procedure                  */":U
         SKIP
         "DEFINE QUERY external_tables FOR ".   
  cnt = NUM-ENTRIES(_P._xTblList).
  DO i = 1 to cnt:
    tmp_string = ENTRY (1, TRIM (ENTRY (i,_P._xTblList)), " ").
    IF _suppress_dbname OR CAN-DO(_tt_log_name, ENTRY(1,tmp_string,".":U)) THEN
    tmp_string = ENTRY(2,tmp_string,".").
    PUT STREAM P_4GL UNFORMATTED tmp_string IF i = cnt THEN "." ELSE ", ".
  END.
  PUT STREAM P_4GL UNFORMATTED SKIP.
END.

/* Put internal Tables */
RUN put_tbllist_internal.

/* If any query is using a KEY-PHRASE in its 4GL query, then define it 
   as TRUE just so things compile better. */
KEY-PHRASE-SEARCH:
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _h_win
              AND CAN-DO("BROWSE,FRAME,DIALOG-BOX,QUERY", _U._TYPE) 
              AND _U._STATUS eq u_status
            USE-INDEX _OUTPUT:
  /* Find the _C & _Q records for use in put_query_preproc_vars.
     (If there are any preprocessor variables.)  */
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  FIND _Q WHERE RECID(_Q) eq _C._q-recid.

  /* Is the keyphrase used in a query? */
  IF LOOKUP("KEY-PHRASE":U, _Q._OptionList, " ":U) > 0 THEN DO:
     PUT STREAM P_4GL UNFORMATTED SKIP 
       "/* Define KEY-PHRASE in case it is used by any query. */":U SKIP 
       "&Scoped-define KEY-PHRASE TRUE":U SKIP (1).
     LEAVE KEY-PHRASE-SEARCH.
  END.
END.   

/* Frame, Query & Browser preprocessor variables (eg. User &FIELDS-IN-QUERY) */
FOR EACH _U WHERE _U._WINDOW-HANDLE eq _h_win
              AND CAN-DO("BROWSE,FRAME,DIALOG-BOX,QUERY", _U._TYPE) 
              AND _U._STATUS eq u_status
            USE-INDEX _OUTPUT:
  /* Find the _C & _Q records for use in put_query_preproc_vars.
     (If there are any preprocessor variables.)  */
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  FIND _Q WHERE RECID(_Q) eq _C._q-recid.
  /* Only put out the section if it has some tables, or some contained 
     browse frames */
  IF _Q._TblList ne "" OR 
     CAN-FIND (FIRST x_U WHERE x_U._parent-recid = RECID(_U)
                           AND x_U._STATUS <> "DELETED" 
                           AND x_U._TYPE eq "BROWSE":U) OR
     CAN-FIND (FIRST _TRG WHERE _TRG._wRECID = RECID(_U) AND
                                _TRG._tEVENT = "OPEN_QUERY":U AND
                                _TRG._STATUS NE "DELETED":U)
  THEN DO:
    /* This is not necessary for syntax checking, and it will cause
    ** problems if you have newly added calc fields that have not
    ** been added to the browse yet. (5/2/00 tomn)
    */
    IF _U._TYPE = "BROWSE":U AND p_status <> "CHECK-SYNTAX":U THEN DO:
      /* IF GUI then resequnce the columns */
      FIND _L WHERE RECID(_L) = _U._lo-recid.

      IF _L._WIN-TYPE THEN DO:
        ASSIGN i       = 1
               col-hdl = _U._HANDLE:FIRST-COLUMN WHEN VALID-HANDLE(_U._HANDLE).
        FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
          _BC._SEQ = _BC._SEQ * -1.
        END.
        DO WHILE VALID-HANDLE(col-hdl):
          FIND _BC WHERE _BC._x-recid    = RECID(_U) AND
                         _BC._COL-HANDLE = col-hdl NO-ERROR.
          IF AVAILABLE _BC THEN
            ASSIGN _BC._SEQ = i
                   i        = i + 1.
          col-hdl  = col-hdl:NEXT-COLUMN.
        END.  /* DO WHILE VALIF-HANDLE */
      END.  /* IF GUI, columns may have been resequenced */
    END.  /* IF Browse */

    ASSIGN tmp_string = "/* Definitions for " + _U._TYPE + " ":U + _U._NAME
           tmp_string = tmp_string + 
                        FILL(" ":U,MAXIMUM(1,72 - LENGTH(tmp_string,"RAW":U))) +
                        "*/".
    PUT STREAM P_4GL UNFORMATTED SKIP tmp_string SKIP.
    RUN put_query_preproc_vars.
  END. 
END.

/* Window preprocessor variables (eg. User &LIST-1) */
IF _P._FILE-TYPE eq "w":U OR CreatingSuper THEN RUN put_win_preproc_vars.

IF p_status NE "PREVIEW" THEN
    PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-PREPROCESSOR-BLOCK-END */" SKIP
          "&ANALYZE-RESUME" SKIP (2).             

/* Write out any XFTRs to follow Std. PreProcessor section in .W */
IF p_status NE "EXPORT" THEN RUN put_next_xftrs (INPUT {&STDPREPROCS}, INPUT no).


/* ************************************************************************* */
/*                                                                           */
/*                            FUNCTION PROTOTYPES                            */
/*                                                                           */
/* ************************************************************************* */
RUN put-func-prototypes-in.

/* If UIB file type is not .w (window), we're finished generating definitions. */
IF _P._FILE-TYPE <> "w":U THEN RETURN.


/* ************************************************************************* */
/*                                                                           */
/*                        LOCAL VARIABLE DEFINITIONS                         */
/*                                                                           */
/* ************************************************************************* */
/* Variables maintained by UIB, but not defined as controls.                 */

/* Define the local variable to hold the name of the current layout          */
/* (only do this if we need the variable).                                   */
IF layout-var ne "" 
THEN PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "/* Define a variable to store the name of the active layout.            */"
    SKIP
    "DEFINE VAR " + layout-var + " AS CHAR INITIAL ~"Master Layout~":U NO-UNDO."
    SKIP.

/* ************************************************************************* */
/*                                                                           */
/*                         WINDOW HANDLE DEFINITION                          */
/*                                                                           */
/* ************************************************************************* */
/* Output the widget handle for the window                                   */
PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "/* ***********************  Control Definitions  ********************** */"
     SKIP(1).

IF NOT wndw THEN 
  PUT STREAM P_4GL UNFORMATTED
    "/* Define a dialog box                                                  */"
    SKIP.
ELSE IF CAN-DO(_P._allow,"WINDOW") THEN 
  PUT STREAM P_4GL UNFORMATTED
    "/* Define the widget handle for the window                              */"
    SKIP
    "DEFINE VAR " + win_variable + " AS WIDGET-HANDLE NO-UNDO."
    SKIP.

IF p_status = "EXPORT" THEN win_name = "".

/* ************************************************************************* */
/*                                                                           */
/*                              MENU DEFINITIONS                             */
/*                                                                           */
/* ************************************************************************* */
/* First see if there are any menus to output.                               */
i = 0.
FOR EACH _U WHERE _U._TYPE = "MENU" AND _U._WINDOW-HANDLE = _h_win
              USE-INDEX _OUTPUT:
  IF _U._SUBTYPE = "MENUBAR" THEN menubar_name = _U._NAME.
  FIND x_U WHERE RECID(x_U) eq _U._PARENT-RECID NO-ERROR.
  /* We must use "eq" here.  We don't want to export POPUP menus on a frame
     unless that frame is truly being exported. */
  IF AVAILABLE x_U AND x_U._STATUS eq u_status THEN DO:  
    /* Put out a header the first time. */ 
    i = i + 1.
    IF i eq 1 THEN PUT STREAM P_4GL UNFORMATTED SKIP (1)
      "/* Menu Definitions                                                     */"
      SKIP.
    /* Now output the menu. */
    RUN adeuib/_outpmen.p (INPUT RECID(_U), INPUT u_status).
  END.
END. /* END OF MENU DEFINITIONS */

/* ************************************************************************** */
/*                                                                            */
/*                 HANDLE DEFINITIONS  (SmartData,SmartObjects & OCX's)       */
/*                                                                            */
/* ************************************************************************** */

/* Cycle through the objects that are defined as HANDLES (ie. SmartObjects and
   OCX Containers.   */
FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _h_win 
               AND (CAN-DO("SmartObject,OCX":U, x_U._TYPE))
               AND x_U._STATUS eq u_status 
            USE-INDEX _OUTPUT
            BREAK BY x_U._TYPE:
            
  /* Add a header line to each type of Handle */
  IF FIRST-OF (x_U._TYPE) THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "/* Definitions of handles for " 
        IF x_U._TYPE eq "SmartObject" THEN "SmartObjects  "
        ELSE IF x_U._TYPE eq "OCX"    THEN "OCX Containers"
        ELSE (x_U._TYPE + FILL(" ", 14 - LENGTH(x_U._TYPE,"CHARACTER":u)))
    "                            */"
    SKIP.  
  END.
  
  /* Make sure that the variable hasn't already been defined.  */
  FIND defined WHERE defined._name = x_U._NAME NO-ERROR.
  IF AVAILABLE defined THEN DO:
    RUN adecomm/_setcurs.p ("").
    RUN adeshar/_bstname.p
          (x_U._NAME, ?, "", 0, _h_win, OUTPUT tmp_name).
    MESSAGE "The name for" x_U._TYPE x_U._NAME
            "has already been defined." SKIP (1)
            "Renaming" x_U._TYPE x_U._NAME "to" tmp_name + "."
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    x_U._NAME = tmp_name.
  END.
  /* Note that there is now a VARIABLE defined for this handle */
  CREATE defined.
  ASSIGN defined._name      = x_U._NAME
         defined._type      = "VARIABLE"
         defined._data-type = "HANDLE"
         .
  /* Define the variable as a Handle or Widget-Handle, as appropriate. */
  PUT STREAM P_4GL UNFORMATTED
           "DEFINE VARIABLE " x_U._NAME " AS "
              (IF x_U._TYPE eq "SmartObject" THEN "HANDLE" ELSE "WIDGET-HANDLE") 
              " NO-UNDO." SKIP.
  
  /* If the object is an OCX, also generate a COM-HANDLE */
  IF x_U._TYPE = "OCX" THEN
    PUT STREAM P_4GL UNFORMATTED
           "DEFINE VARIABLE " "ch":U + x_U._NAME " AS COMPONENT-HANDLE NO-UNDO." SKIP.
END. /* FOR EACH...SmartObject */

/* ************************************************************************** */
/*                                                                            */
/*                           WIDGET DEFINITIONS                               */
/*                                                                            */
/* ************************************************************************** */
IF CAN-FIND
   (FIRST _U WHERE _U._WINDOW-HANDLE = _h_win 
         AND NOT CAN-DO ("WINDOW,FRAME,DIALOG-BOX,SmartObject,OCX,QUERY", _U._TYPE))
THEN PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "/* Definitions of the field level widgets                               */"
    SKIP.

/* Cycle through the frames for this window                                   */
FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                  CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) AND
                  _U._STATUS        NE "DELETED" USE-INDEX _OUTPUT:
  FIND _L WHERE RECID(_L) = _U._lo-recid.

  /* Cycle through the field-level widgets for this frame to create the       */
  /* widget definitions, be carefull not to create definitions for text       */
  /* widgets as they are displayed as literals in the frame.                  */
  frame_layer = _U._HANDLE:FIRST-CHILD.
  DEFINE-BLK:
  FOR EACH x_U WHERE x_U._PARENT        = frame_layer
                 AND x_U._WINDOW-HANDLE = _h_win
                 AND NOT CAN-DO("TEXT,FRAME,OCX":U,x_U._TYPE)
                 AND x_U._DEFINED-BY    = "TOOL":U
                 AND x_U._STATUS        = u_status USE-INDEX _OUTPUT,
      EACH _F WHERE RECID(_F) = x_U._x-recid:

    /* Process fields that have db-table references if they are "LIKE" a db-fld and
       fields that source data type is not CLOB (RowObject LONGCHAR fields) */
    IF x_U._TABLE NE ? AND 
       _F._DISPOSITION NE "LIKE":U AND 
       _F._SOURCE-DATA-TYPE NE "CLOB":U THEN NEXT DEFINE-BLK.

    FIND x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "Master Layout".
    
    /* Lots of widgets are really defined as variables.  Only a few are a
       distinct widget type. (i.e. We can have a fill-in and a toggle with
       the same name, but not an image and a variable.) */
    IF CAN-DO("BUTTON,RECTANGLE,IMAGE", x_U._TYPE)
    THEN define_type = x_U._TYPE.
    ELSE define_type = "VARIABLE".

    /* Make sure that this object hasn't already been defined.  A variable 
       is the only exception. It can be used in multiple windows (as long as
       the datatype does not conflict).  When the name of a local variable is
       different from the datafield name (CLOB datafields represented as 
       LONGCHAR local editors on viewers), the local name must be used. */
    FIND defined WHERE defined._name = IF x_U._LOCAL-NAME = "":U THEN x_U._NAME
                                       ELSE x_U._LOCAL-NAME NO-ERROR.
    IF AVAILABLE defined THEN DO:
      IF (define_type NE "VARIABLE") OR
         (defined._type NE define_type) THEN DO:
        RUN adecomm/_setcurs.p ("").
        RUN adeshar/_bstname.p
            (x_U._NAME, ?, x_U._TYPE, 0, _h_win, OUTPUT tmp_name).
        MESSAGE x_U._TYPE x_U._NAME 
                "name conflicts with the" SKIP
                "previously defined"
                defined._type defined._name + "." SKIP (1)
                "Renaming" x_U._TYPE x_U._NAME "to" tmp_name + "."
                 VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        x_U._NAME = tmp_name.
      END.  /* Its been defined and is not a variable or widget type has changed */
      ELSE IF define_type = "VARIABLE" AND 
             (defined._data-type NE _F._DATA-TYPE) THEN DO:
        RUN adecomm/_setcurs.p ("").
        RUN adeshar/_bstname.p
            (x_U._NAME, ?, "", 0, _h_win, OUTPUT tmp_name).
        MESSAGE "Variable" x_U._NAME
                "is defined in two frames with two" SKIP (1)
                "different datatypes:" _F._DATA-TYPE "and" 
                defined._data-type + "." SKIP (1)
               "Renaming" x_U._TYPE x_U._NAME "to" tmp_name + "." 
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
         x_U._NAME = tmp_name.
      END.  /* Else has been defined and is a variable but has wrong data-type */
      ELSE DO:
        /* Note the copy */
        CREATE acopy.
        ASSIGN acopy._u-recid = RECID(x_U).
        NEXT DEFINE-BLK.
      END.  /* Else do */
    END.  /* This name has already been defined */
    /* When the name of a local variable is different from the datafield name 
      (CLOB datafields represented as LONGCHAR local editors on viewers), 
      the local name must be used. */
    CREATE defined.
    ASSIGN defined._name      = IF x_U._LOCAL-NAME = "":U THEN x_U._NAME
                                ELSE x_U._LOCAL-NAME
           defined._data-type = _F._DATA-TYPE
           defined._type      = define_type.

    /* Make sure that this object isn't an array that has already been        */
    /* been defined                                                           */
    IF _F._SUBSCRIPT < 0 THEN NEXT DEFINE-BLK.
      

    /* DEPENDING on TYPE this section puts out one of the following:          */
    /* BUTTON         - DEFINE BUTTON   blah                                  */
    /* COMBO-BOX      - DEFINE VARIABLE blah AS data-typ 
                                          FORMAT fnt VIEW-AS COMBO-BOX        */
    /* EDITOR         - DEFINE VARIABLE blah AS CHAR VIEW-AS EDITOR           */
    /* FILL-IN        - DEFINE VARIABLE blah AS CHAR 
                                          FORMAT fnt VIEW-AS FILL-IN          */
    /* RADIO-SET      - DEFINE VARIABLE blah AS data-tp LABEL VIEW-AS
                                        RADIO-SET HORIZONTAL EXPAND buttons   */
    /* SELECTION-LIST - DEFINE VARIABLE blah AS CHAR VIEW-AS SELECTION-LIST   */
    /* SLIDER         - DEFINE VARIABLE blah AS INTEGER VIEW-AS SLIDER        */
    /* TOGGLE-BOX     - DEFINE VARIABLE blah AS LOGICAL VIEW-AS TOGGLE-BOX    */

    tmp_name = IF _F._SUBSCRIPT > 0 THEN
                 SUBSTRING(x_U._NAME,1,INDEX(x_U._NAME,"[") - 1,"CHARACTER":U)
               ELSE x_U._NAME.
               
    IF define_type NE "VARIABLE"
    THEN PUT STREAM P_4GL UNFORMATTED "DEFINE " define_type " " tmp_name.
    ELSE DO:  /* This is a variable */
      IF _F._DISPOSITION = "LIKE":U THEN   /* When the variable is LIKE a DB field */
      DO:                                      
          PUT STREAM P_4GL UNFORMATTED
               "DEFINE "
               IF x_U._SHARED THEN "~{~&NEW} SHARED " ELSE ""
               "VARIABLE " tmp_name " LIKE " db-fld-name("_U":U, RECID(x_U)).
        
      END.  /* When the variable is LIKE a DB field */
      /* When the variable is normal local variable or a CLOB data field  */
      ELSE IF _F._DISPOSITION = "LOCAL" OR 
              _F._DISPOSITION = "" OR 
              (_F._DISPOSITION = "FIELD" AND _F._SOURCE-DATA-TYPE = "CLOB") THEN
      DO:   
        /* A CLOB data field is represented by a local LONGCHAR variable, the local
           name must be used to define the variable */
        PUT STREAM P_4GL UNFORMATTED                     
             "DEFINE "
             IF x_U._SHARED THEN "~{~&NEW} SHARED " ELSE ""
             "VARIABLE " (IF _F._SOURCE-DATA-TYPE = "CLOB" THEN x_U._LOCAL-NAME ELSE tmp_name) " AS " CAPS(_F._DATA-TYPE)
             IF x_U._TYPE = "FILL-IN" OR (x_U._TYPE = "COMBO-BOX" AND x_U._SUBTYPE = "DROP-DOWN-LIST") 
             THEN  (" FORMAT ~"" + _F._FORMAT + "~"" +
                (IF _F._FORMAT-ATTR NE "" THEN ":" + _F._FORMAT-ATTR ELSE "") +
                " ")
             ELSE " ".
          
        IF _F._INITIAL-DATA NE "" THEN 
        INITIAL-VALUE-BLK:
        DO:
          IF x_U._TYPE = "EDITOR" AND _F._DATA-TYPE = "LONGCHAR" THEN
            LEAVE INITIAL-VALUE-BLK.
          IF x_U._TYPE = "RADIO-SET" AND _F._INITIAL-DATA = ? THEN
            LEAVE INITIAL-VALUE-BLK.
          tmp_string = _F._INITIAL-DATA.
          IF CAN-DO("INTEGER,INT64,DECIMAL":U, _F._DATA-TYPE) THEN DO:
            ASSIGN tmp_string = REPLACE(tmp_string, _numeric_separator, "":U)
                   tmp_string = REPLACE(tmp_string, _numeric_decimal, ".":U).
          END.
 
          /* For logical fill-ins, determine if initial value is yes or no based on format.
           * (i.e. for format "GUI/TTY" 'GUI' is not a legal initial value, 'yes' is. */          
          IF CAN-DO("FILL-IN,COMBO-BOX":U, x_U._TYPE) AND _F._DATA-TYPE = "Logical":U THEN DO:
            tmp_string = IF ENTRY (1, _F._FORMAT, "/") EQ _F._INITIAL-DATA THEN "YES"
                         ELSE "NO".
          END.  /* IF a fill-in or combo-box logical */
          /* Quote this if an character. */
          IF _F._DATA-TYPE eq "Character":U
          THEN tmp_string = "~"" +                                                
                        REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                        tmp_string ,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                        "~{","~~~{"), "~;","~~~;") +
                        "~"".
          /* Note that this TRIM won't remove leading (or trailing) spaces on
             character values because of the quotes added in the last line.
             It only trims non-character values for neatness. */
          IF _F._DATA-TYPE = "DATE":U THEN 
            ASSIGN tmp_date            = DATE(tmp_string)
                   SESSION:DATE-FORMAT = "mdy":U
                   tmp_string          = STRING(tmp_date)
                   SESSION:DATE-FORMAT = _orig_dte_fmt.
          IF _F._DATA-TYPE = "DATETIME":U THEN
            ASSIGN tmp_datetime        = DATETIME(tmp_string)
                   SESSION:DATE-FORMAT = "mdy":U
                   tmp_string          = '"' + STRING(tmp_datetime) + '"'
                   SESSION:DATE-FORMAT = _orig_dte_fmt.
          IF _F._DATA-TYPE = "DATETIME-TZ":U THEN
            ASSIGN tmp_datetimetz      = DATETIME-TZ(tmp_string)
                   SESSION:DATE-FORMAT = "mdy":U
                   tmp_string          = '"' + STRING(tmp_datetimetz) + '"'
                   SESSION:DATE-FORMAT = _orig_dte_fmt.
          PUT STREAM P_4GL UNFORMATTED "INITIAL "  TRIM(tmp_string)  " " .
        END. /* IF...INITIAL-DATA... */
      END.  /* End the "LOCAL" case of disposition */      
    END. /* IF..VARIABLE  */

    IF _F._SUBSCRIPT > 0 THEN DO:
      {adeuib/defextnt.i}
    END.
    
    /* Specify the filename of a button (which will override any label)       */
    IF (x_U._TYPE = "BUTTON") THEN DO:
      PUT STREAM P_4GL UNFORMATTED SPACE
                IF _F._AUTO-GO THEN "AUTO-GO " ELSE ""
          IF _F._AUTO-ENDKEY THEN "AUTO-END-KEY " ELSE ""
          IF _F._DEFAULT THEN "DEFAULT " ELSE "".
      IF _F._IMAGE-FILE <> "" AND _F._IMAGE-FILE <> ?
      THEN PUT STREAM P_4GL UNFORMATTED SKIP
               "     IMAGE-UP FILE """ _F._IMAGE-FILE """:U".
      IF _F._IMAGE-DOWN-FILE <> "" AND _F._IMAGE-DOWN-FILE <> ?
      THEN PUT STREAM P_4GL UNFORMATTED SKIP
               "     IMAGE-DOWN FILE """ _F._IMAGE-DOWN-FILE """:U".
      IF _F._IMAGE-INSENSITIVE-FILE <> "" AND _F._IMAGE-INSENSITIVE-FILE <> ? 
      THEN PUT STREAM P_4GL UNFORMATTED SKIP
               "     IMAGE-INSENSITIVE FILE """ _F._IMAGE-INSENSITIVE-FILE """:U".
      IF x_L._NO-FOCUS THEN PUT STREAM P_4GL UNFORMATTED " NO-FOCUS":U.
      IF _F._FLAT THEN PUT STREAM P_4GL UNFORMATTED " FLAT-BUTTON":U. /* Note that FLAT-BUTTON is an option of NO-FOCUS */
      IF NOT x_L._CONVERT-3D-COLORS THEN
        PUT STREAM P_4GL UNFORMATTED " NO-CONVERT-3D-COLORS":U.
    END.  /* If BUTTON */

    /* Specify the label if any (remove the colon from a fill-in label).      */
    /* Also put empty labels (otherwise default label = variable name)        */
    IF x_U._LABEL ne ? AND (NOT x_L._NO-LABELS OR x_U._TYPE = "BUTTON") AND
       x_U._LABEL-SOURCE NE "D" AND
       NOT CAN-DO("RECTANGLE,IMAGE",x_U._TYPE) AND
       (_F._SUBSCRIPT = ? OR _F._SUBSCRIPT = 0)
    THEN
    DO:
      ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                          x_U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                          "~{","~~~{"), "~;","~~~;").
      PUT STREAM P_4GL UNFORMATTED SKIP "     LABEL """ q_label """"
         IF x_U._LABEL-ATTR NE "" THEN ":" + x_U._LABEL-ATTR + " " ELSE " ".
    END.
    
    /* Specify the filename of an image                                       */
    IF x_U._TYPE = "IMAGE" THEN DO:
      IF _F._IMAGE-FILE NE ? AND _F._IMAGE-FILE NE ""
       THEN PUT STREAM P_4GL UNFORMATTED
              SKIP "     FILENAME """ _F._IMAGE-FILE """:U".
      IF x_L._CONVERT-3D-COLORS THEN
        PUT STREAM P_4GL UNFORMATTED " CONVERT-3D-COLORS":U.
      IF _F._STRETCH-TO-FIT THEN
        PUT STREAM P_4GL UNFORMATTED SKIP "     STRETCH-TO-FIT":U.
      IF _F._RETAIN-SHAPE THEN
        PUT STREAM P_4GL UNFORMATTED " RETAIN-SHAPE":U.
      IF _F._TRANSPARENT THEN
        PUT STREAM P_4GL UNFORMATTED " TRANSPARENT":U.
    END.

    /* Specify special rectangle attributes                                   */
    IF x_U._TYPE = "RECTANGLE" THEN
      PUT STREAM P_4GL UNFORMATTED
               SKIP "     EDGE-PIXELS " x_L._EDGE-PIXELS
               (IF x_L._GRAPHIC-EDGE THEN " GRAPHIC-EDGE " ELSE " ")
               (IF NOT x_L._FILLED   THEN " NO-FILL " ELSE " ")
               (IF x_L._GROUP-BOX    THEN " GROUP-BOX " ELSE " ")
               (IF x_L._ROUNDED      THEN " ROUNDED " ELSE " ").

    /* Put context-help-id when variable is not defined like a db field */
    IF _F._DISPOSITION NE "LIKE":U AND x_U._CONTEXT-HELP-ID NE ? THEN
      PUT STREAM P_4GL UNFORMATTED
        SKIP "     CONTEXT-HELP-ID " x_U._CONTEXT-HELP-ID.

    /* Put the view-as phrase for variables - this also puts size */
    IF (_F._DISPOSITION NE "LIKE":U OR _F._SIZE-SOURCE = "E":U OR
        _U._TYPE NE "FILL-IN":U) AND
        NOT _F._DICT-VIEW-AS THEN
      RUN put_view-as ("     ").
    
    /* Put the color and font. */
    RUN put_color_font("     ").

    /* Put out DROP-TARGET if necessary */
    IF x_U._DROP-TARGET THEN
      PUT STREAM p_4GL UNFORMATTED " DROP-TARGET".
       
    /* Add NO-UNDO to Variables. */
    IF define_type eq "VARIABLE" AND _F._UNDO eq NO 
    THEN PUT STREAM P_4GL UNFORMATTED " NO-UNDO".

    /* Close out the 4GL statement. */
    PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
    
  END.  /* For each field level widget DEFINE-BLK */
END.  /* For each WINDOW */

/* Have the subscripts revert to positive numbers                            */
FOR EACH _F WHERE _F._SUBSCRIPT < 0:
  _F._SUBSCRIPT = -1 * _F._SUBSCRIPT.
END.

/* ************************************************************************* */
/*                                                                           */
/*                            QUERY DEFINITIONS                              */
/*                                                                           */
/* ************************************************************************* */

IF NOT skip_queries THEN DO:
l_dummy = YES. /* Flag to set if this is the first valid query */
FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win
              AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY":U,_U._TYPE)
              AND _U._STATUS        EQ u_status USE-INDEX _OUTPUT,
    EACH _C WHERE RECID(_C)         = _U._x-recid,
    EACH _Q WHERE RECID(_Q)         = _C._q-recid:

  /* Note: we only make shared queries for browsers.  Shared frames do NOT
     have shared queries (This is an arbitrary limitation - wood 1/7/94) */
  IF _Q._TblList NE "" THEN DO:
    /* Put out a header line if this is the first one */
    IF l_dummy THEN DO:  /* we haven't done the first yet */
      /* Db-Required Start Preprocessor block. */
      IF _P._DB-AWARE THEN
          PUT STREAM P_4GL UNFORMATTED '~{&DB-REQUIRED-START~}' SKIP(1).
      IF p_status NE "PREVIEW":U THEN
        PUT STREAM P_4GL UNFORMATTED SKIP
        "/* Query definitions                                                    */"
        SKIP "&ANALYZE-SUSPEND":U SKIP.
      ELSE
        PUT STREAM P_4GL UNFORMATTED SKIP
        "/* Query definitions                                                    */"
        SKIP.
    END.  /* If l_dummy */

    /* If it is a free form "DEFINE QUERY" write it out */
    FIND FIRST _TRG WHERE _TRG._wRECID = RECID(_U) AND
                          _TRG._tEVENT = "DEFINE_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
      IF NOT l_dummy THEN PUT STREAM P_4GL UNFORMATTED SKIP (1).
      l_dummy = NO. /* Don't do this again */
      _TRG._tOFFSET = SEEK(P_4GL).
      /* Need to change <cr><lf> to just <lf> */
      _TRG._tCODE = REPLACE(_TRG._tCODE, CHR(13) + CHR(10), CHR(10)).
      PUT STREAM P_4GL UNFORMATTED _TRG._tCODE SKIP.
      NEXT.
    END.

    IF _U._SHARED AND _U._TYPE eq "BROWSE":U THEN DO:
      /* If the BROWSE is shared, then the QUERY is also shared, and we need 
         to have shared buffers for each of the tables referenced */
      DO i = 1 TO NUM-ENTRIES(_Q._TblList):
        tmp_string  = ENTRY (1, TRIM(ENTRY(i,_Q._TblList)), " ").
        IF NUM-ENTRIES(tmp_string,".":U) > 1 AND
          (_suppress_dbname OR CAN-DO(_tt_log_name, ENTRY(1,tmp_string,".":U))) THEN
           tmp_string = ENTRY(2,tmp_string,".").
        IF NOT CAN-DO(brwsr_bufs,tmp_string) THEN DO:
          IF NOT l_dummy THEN PUT STREAM P_4GL UNFORMATTED SKIP (1).
          l_dummy = NO. /* Don't do this again */
          PUT STREAM P_4GL UNFORMATTED SKIP
            "DEFINE ~{~&NEW} SHARED BUFFER "  REPLACE(tmp_string,".","_") + 
                     IF _suppress_dbname THEN "_" ELSE ""
            " FOR " tmp_string "." SKIP.
          brwsr_bufs = brwsr_bufs + "," + tmp_string.
        END.
      END.
    END.  /* If a shared browser */

    IF NOT l_dummy THEN PUT STREAM P_4GL UNFORMATTED SKIP (1).
    l_dummy = NO. /* Don't do this again */
    
    /* Check to see if this is a SmartDataBrowser - if so write out the SDO temp-table def */
    RUN adeuib/_isa.p (INPUT INTEGER(RECID(_P)), INPUT "SmartObject", OUTPUT isaSO).
    IF isaSO AND (_P._data-object NE "") AND (LOOKUP("BROWSE",_P._ALLOW) > 0) 
    AND (LOOKUP("SMART",_P._ALLOW) = 0) THEN 
      RUN put_tt_defs.

    PUT STREAM P_4GL UNFORMATTED SKIP "DEFINE "
      (IF _U._SHARED AND _U._TYPE eq "BROWSE":U THEN "~{~&NEW} SHARED " ELSE "")
      "QUERY " _U._NAME " FOR " SKIP.
    DO i = 1 TO NUM-ENTRIES(_Q._TblList):
      tmp_string = ENTRY (1, TRIM (ENTRY (i,_Q._TblList)), " ").
      IF NUM-ENTRIES(tmp_string,".":U) > 1 AND
         (_suppress_dbname OR CAN-DO(_tt_log_name, ENTRY(1,tmp_string,".":U))) THEN
        tmp_string = ENTRY(2,tmp_string,".") + 
                              IF _U._SHARED AND _U._TYPE = "BROWSE":U THEN "_" ELSE "".
      IF _U._SHARED AND _U._TYPE = "BROWSE":U THEN
         tmp_string = REPLACE(tmp_string,".","_").
      IF _Q._TblOptList NE ""                        AND 
         INDEX(ENTRY(i,_Q._TblOptList),"USED":U) > 0 AND
         NOT (CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND _TRG._tEVENT = "OPEN_QUERY":U)) THEN 
      DO: /* NOTE: A Field List is not written out for a Freeform Query */
        /* Make a Field List */
        /* If there is only one entry then this may be a buffer and "Temp-Tables" needs to
           be used as the db name to find the fields */
        IF NUM-ENTRIES(ENTRY(1, TRIM(ENTRY(i,_Q._TblList)), " ":U),".":U) = 1 THEN
        DO:
          FIND FIRST _TT WHERE _TT._P-RECID = RECID(_P) 
            AND _TT._NAME = ENTRY(1, TRIM(ENTRY(i,_Q._TblList)), " ":U) NO-ERROR.
          IF AVAILABLE _TT THEN
            ASSIGN tmp_db = "Temp-Tables":U
                   tmp_tbl = ENTRY(1, TRIM(ENTRY(i,_Q._TblList)), " ":U).
        END.  /* if one entry for the table */
        ELSE 
          ASSIGN tmp_db  = ENTRY(1, ENTRY(1, TRIM(ENTRY(i,_Q._TblList)), " "), ".")
                 tmp_tbl = ENTRY(2, ENTRY(1, TRIM(ENTRY(i,_Q._TblList)), " "), ".").
        ASSIGN tmp_string = tmp_string + CHR(10) + "    FIELDS(":U.
        IF _U._TYPE EQ "BROWSE":U 
           OR (_U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U)
        THEN DO:
          IF CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(_U) AND
                                      ((_BC._DBNAME  = tmp_db AND
                                      _BC._TABLE   = tmp_tbl) OR
                                      _BC._DBNAME = "_<CALC>":U)) THEN DO:
            /* This is not necessary for syntax checking, and it will cause
            ** problems if you have newly added calc fields that have not
            ** been added to the browse yet. (5/2/00 tomn)
            */
            IF _L._WIN-TYPE AND _U._TYPE NE "QUERY":U AND p_status <> "CHECK-SYNTAX":U
            THEN DO:
              /* If GUI  then resequence the columns */
              ASSIGN seq-num = 1
                     col-hdl = _U._HANDLE:FIRST-COLUMN.
              FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
                _BC._SEQ = _BC._SEQ * -1.
              END.
              DO WHILE VALID-HANDLE(col-hdl):
                FIND _BC WHERE _BC._x-recid    = RECID(_U) AND
                               _BC._COL-HANDLE = col-hdl NO-ERROR.
                IF AVAILABLE _BC THEN
                  ASSIGN _BC._SEQ = seq-num
                         seq-num  = seq-num + 1.
                col-hdl  = col-hdl:NEXT-COLUMN.
              END.  /* DO WHILE VALIF-HANDLE */
            END.  /* IF GUI (not not a QUERY), columns may have been resequenced */
            FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
              IF _BC._DBNAME NE "_<CALC>":U THEN DO:
                IF _BC._DBNAME = tmp_db AND _BC._TABLE = tmp_tbl THEN
                  tmp_string = tmp_string + db-fld-name("_BC":U, RECID(_BC)) +
                                            CHR(10) + "      ":U.
              END.
              ELSE DO:  /* A Calculated field - find the DB fields in it */
                tmp_str2 = "":U.
                IF NUM-DBS > 0 THEN
                  RUN adeuib/_bcparse.p (INPUT RECID(_BC), INPUT tmp_db, INPUT tmp_tbl,
                                         OUTPUT tmp_str2).
                IF tmp_str2 NE "":U THEN 
                  tmp_string = tmp_string + tmp_str2.
              END.  /* ELSE a calculated field */
            END.  /* FOR EACH _BC */
          END.  /* IF we can find any _BC fields */
        END.  /* IF working with a Browse */
        ELSE IF LOOKUP(_U._TYPE,"FRAME,DIALOG-BOX":U) > 0 THEN DO:
          FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win AND
                             x_U._PARENT-RECID = RECID(_U) AND
                             x_U._DBNAME       = tmp_db    AND
                             x_U._TABLE        = tmp_tbl:
            tmp_string = tmp_string + db-fld-name("_BC":U, RECID(_BC)) +
                                      CHR(10) + "      ":U.
          END. /* FOR EACH x_U */
        END. /* If a frame or dialog-box */
        ASSIGN tmp_string = TRIM(tmp_string) + ")":U.
      END.
      PUT STREAM P_4GL UNFORMATTED "      " tmp_string
          IF i = NUM-ENTRIES(_Q._TblList) THEN " SCROLLING." ELSE ", " SKIP.
    END.                           
  END. /* Valid _TblList */
END. /* FOR EACH query */
IF p_status NE "PREVIEW":U AND NOT l_dummy THEN
  PUT STREAM P_4GL UNFORMATTED  "&ANALYZE-RESUME":U SKIP.

/* Db-Required End Preprocessor block for Query definitions. */
IF _P._DB-AWARE AND NOT l_dummy THEN
    PUT STREAM P_4GL UNFORMATTED '~{&DB-REQUIRED-END~}' SKIP(1).

/* ************************************************************************* */
/*                                                                           */
/*                         BROWSE DEFINITIONS                               */
/*                                                                           */
/* ************************************************************************* */

IF CAN-FIND(FIRST _U WHERE _U._TYPE          = "BROWSE":U AND
                           _U._WINDOW-HANDLE = _h_win AND
                           _U._STATUS        EQ u_status) THEN DO:
/* Define the frames for this window                                         */
  PUT STREAM P_4GL UNFORMATTED SKIP (1)
    "/* Browse definitions                                                   */"
    SKIP.
  BROWSE-BLK:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _h_win AND
                    _U._TYPE          = "BROWSE":U AND
                    _U._STATUS        EQ u_status USE-INDEX _OUTPUT,
      EACH _C WHERE RECID(_C)         = _U._x-recid,
      EACH _Q WHERE RECID(_Q)         = _C._q-recid,
      _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout":

    /* Added new browser attributes here RPR 7/94 */
    ASSIGN
      tmp_string = ENTRY(1,_Q._OptionList," ":U)
      tmp_string = IF tmp_string = "SHARE-LOCK":U or tmp_string = "EXCLUSIVE-LOCK" 
                   THEN
                     " ":U + tmp_string  + " NO-WAIT"
                   ELSE
                     " ":U + tmp_string.
    /* In 7.4A, it is possible to have a BROWSE with neither a QUERY nor a set
       of display fields. */
    PUT STREAM P_4GL UNFORMATTED 
       "DEFINE "
         IF _U._SHARED THEN "~{~&NEW} SHARED BROWSE " ELSE "BROWSE " _U._NAME SKIP.
                              
    IF p_status NE "PREVIEW":U THEN 
      PUT STREAM P_4GL UNFORMATTED "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS "
                 _U._NAME + " " + (IF win_name = "" THEN "-" ELSE win_name) +
                (IF CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(_U) AND
                                        _TRG._tEVENT = "DISPLAY":U)
                  THEN " _FREEFORM":U ELSE " _STRUCTURED":U) SKIP.

    IF CAN-FIND (FIRST _BC WHERE _BC._x-recid = RECID(_U)) THEN DO:
      PUT STREAM P_4GL UNFORMATTED IF _Q._TblList ne ""
                THEN "  QUERY " + _U._NAME + RIGHT-TRIM(tmp_string) ELSE ""
                " DISPLAY" SKIP.                                        
      /* Build the DISPLAY and ENABLE from _BC RECORDS */
      RUN adeshar/_coddflt.p (INPUT "_DISPLAY-FIELDS", INPUT RECID(_U),
             OUTPUT tmp_string).
      PUT STREAM P_4GL UNFORMATTED FILL(" ":U,6) + TRIM(tmp_string) SKIP.
    END.
    ELSE DO:   /* Write out code block if it exists */
      FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                      _TRG._tEVENT = "DISPLAY":U NO-ERROR.
      IF AVAILABLE _TRG THEN DO:
        PUT STREAM P_4GL UNFORMATTED IF _Q._TblList ne ""
                THEN "  QUERY " + _U._NAME + RIGHT-TRIM(tmp_string) ELSE ""
                " DISPLAY" SKIP.                                        
        _TRG._tOFFSET = SEEK(P_4GL) + 6.
        PUT STREAM P_4GL UNFORMATTED FILL(" ":U,6) + TRIM(_TRG._tCODE) SKIP.
      END.
      ELSE PUT STREAM P_4GL UNFORMATTED "  " SKIP.
    END.
    IF p_status NE "PREVIEW":U THEN
      PUT STREAM P_4GL UNFORMATTED 
         "/* _UIB-CODE-BLOCK-END */" SKIP
           "&ANALYZE-RESUME":U SKIP.
       
    PUT STREAM P_4GL UNFORMATTED
      "    WITH"
       IF _L._NO-BOX               THEN " NO-BOX"              ELSE ""
       IF _L._NO-LABELS            THEN " NO-LABELS"           ELSE ""
       IF _C._NO-ASSIGN            THEN " NO-ASSIGN"           ELSE ""
       IF _C._NO-AUTO-VALIDATE     THEN " NO-AUTO-VALIDATE"    ELSE ""
       IF _C._NO-ROW-MARKERS       THEN " NO-ROW-MARKERS"      ELSE ""
       IF NOT _C._COLUMN-SCROLLING THEN " NO-COLUMN-SCROLLING" ELSE ""
       IF _L._SEPARATORS           THEN " SEPARATORS"          ELSE ""
       IF _C._MULTIPLE             THEN " MULTIPLE"            ELSE ""
       IF NOT _U._SCROLLBAR-V      THEN " NO-SCROLLBAR-VERTICAL" ELSE ""
       IF NOT _C._VALIDATE         THEN " NO-VALIDATE"           ELSE ""
       IF _U._DROP-TARGET          THEN " DROP-TARGET"           ELSE ""
       IF _U._NO-TAB-STOP          THEN " NO-TAB-STOP"           ELSE "".
       
    IF _U._LAYOUT-UNIT
    THEN PUT STREAM P_4GL UNFORMATTED
                       " SIZE " ROUND(_L._WIDTH,2) " BY " ROUND(_L._HEIGHT,2).
    ELSE PUT STREAM P_4GL UNFORMATTED SKIP
            "          &IF '~{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE "
                               INTEGER(_L._WIDTH) " BY " INTEGER(_L._HEIGHT) SKIP
            "          &ELSE SIZE-PIXELS "
                              INTEGER(_L._WIDTH * SESSION:PIXELS-PER-COLUMN)
                       " BY " INTEGER(_L._HEIGHT * SESSION:PIXELS-PER-ROW) " &ENDIF".

    /* Specify color font and title.                   */
    RUN put_color_font_title ("         ", Yes /* gentitle */).

    /* Write out row height if user specified it */
    IF _C._ROW-HEIGHT NE 0 AND _C._ROW-HEIGHT NE ? THEN
      PUT STREAM P_4GL UNFORMATTED " ROW-HEIGHT-CHARS ":U ROUND(_C._ROW-HEIGHT,2).
    
    /* Write out expandable option if user specified it */
    IF _C._FIT-LAST-COLUMN THEN PUT STREAM P_4GL UNFORMATTED " FIT-LAST-COLUMN":U.
    IF _C._NO-EMPTY-SPACE  THEN PUT STREAM P_4GL UNFORMATTED " NO-EMPTY-SPACE":U.

    /* Write out the tooltip definition */
    RUN put_tooltip (INPUT _U._TOOLTIP, INPUT _U._TOOLTIP-ATTR).

    /* Put context-help-id */
    IF _U._CONTEXT-HELP-ID NE ? THEN
      PUT STREAM P_4GL UNFORMATTED
        SKIP "         CONTEXT-HELP-ID ":U _U._CONTEXT-HELP-ID.

    PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
    
  END. /* FOR EACH BROWSE_U. */

END. /* IF THERE ARE ANY BROWSERS */
END.  /* If not skipping query and browser definitions */


/* ************************************************************************* */
/*                                                                           */
/*                            FRAME DEFINITIONS                              */
/*                                                                           */
/* ************************************************************************* */
/* Define the frames for this window                                         */
PUT STREAM P_4GL UNFORMATTED SKIP (1)
   "/* ************************  Frame Definitions  *********************** */"
    SKIP (1).

/* Write out the DEFINE FRAME statements.  Note the special case of a DIALOG-BOX
   where we need to pass in the "dummy" design window parent. */
FIND _U WHERE RECID(_U) eq _P._u-recid.
RUN put-frame-definitions-in (IF _U._TYPE ne "DIALOG-BOX":U 
                              THEN _P._WINDOW-HANDLE
                              ELSE _P._WINDOW-HANDLE:PARENT).

/* * * * * * * * * * * * * * Internal Procedures * * * * * * * * * * * * * * */

/* put-frame-definitions-in - Write out the frame definition for each of the
 *     frames that are children of the object. Do this in "reverse" child
 *     order so that we get the frame definitions in correct Z-order.
 *
 * NOTE: the parent must be the TRUE parent (i.e. it can be a WINDOW or a
 * field-group, but not a FRAME itself).
 */
PROCEDURE put-frame-definitions-in :
  DEFINE INPUT PARAMETER ph_parent AS WIDGET-HANDLE NO-UNDO.
   
  DEF VAR d              AS DECIMAL       NO-UNDO.
  DEF VAR default_btn    AS CHARACTER     NO-UNDO.
  DEF VAR empty_frame    AS LOGICAL       NO-UNDO.
  DEF VAR frame_handle   AS WIDGET-HANDLE NO-UNDO.
  DEF VAR gd_last_width  AS DECIMAL       NO-UNDO.
  DEF VAR gd_last_height AS DECIMAL       NO-UNDO.
  DEF VAR min_width      AS DECIMAL       NO-UNDO.
  DEF VAR min_height     AS DECIMAL       NO-UNDO.
  DEF VAR iteration_ht   AS DECIMAL       NO-UNDO.
  DEF VAR stack_lbl_rw   AS INTEGER       NO-UNDO.
  
  /* Get the LAST "child" of the parent object. Check for invalid call with
     a FRAME. */
  IF ph_parent:TYPE eq "FRAME" THEN ph_parent = ph_parent:CURRENT-ITERATION.  
  frame_handle = ph_parent:LAST-CHILD.
  
  FRAME-DEF-LOOP:
  REPEAT WHILE frame_handle NE ?:
    FIND _U WHERE _U._HANDLE = frame_handle NO-ERROR.
    IF AVAILABLE _U AND CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN DO:
      frame_layer  = _U._HANDLE:FIRST-CHILD.
      IF _U._STATUS BEGINS u_status THEN DO:
        FIND _L WHERE _L._u-recid = RECID(_U) AND _L._LO-NAME = "Master Layout".
        FIND _C WHERE RECID(_C) = _U._x-recid.
    
        IF curr_frame = "" THEN DO:
          PUT STREAM P_4GL UNFORMATTED
              "&Scoped-define FRAME-NAME " _U._NAME SKIP.
          curr_frame = _U._NAME.
        END.
        
        ASSIGN stmnt_strt  = SEEK(P_4GL)
               default_btn = ?
               cancel_btn  = ?.
        /* If we are exporting widgets (without the contained frame) then
           we need to use an unnamed frame [defined with FORM].  
           NOTE: We need to duplicate this code if we break the FORM statement
           at 4K. */
        IF _U._STATUS = u_status  /* EXPORT vs EXPORT-FORM */
        THEN PUT STREAM P_4GL UNFORMATTED "DEFINE "
               IF _U._SHARED THEN "~{~&NEW} SHARED " ELSE ""
               "FRAME " _U._NAME SKIP.
        ELSE PUT STREAM P_4GL UNFORMATTED "FORM" SKIP.
    
        ASSIGN iteration_ht = 0.0
               stack_lbl_rw = 1.0
               empty_frame  = yes
               .
        /* Dynamic Widgets, or widgets that are going to be placed at runtime
           (eg. FRAMES and SmartObject), won't appear in the DEFINE FRAME
           statement.  However, we need to allocate space for them in a
           SIZE-TO-FIT frame. */
        IF _C._SIZE-TO-FIT THEN DO: 
          ASSIGN min_width  = 0
                 min_height = 0.
          FOR EACH x_U WHERE x_U._PARENT = frame_layer 
                         AND CAN-DO("SmartObject,FRAME,{&WT-CONTROL}":U,x_U._TYPE)
                         AND x_U._STATUS EQ u_status,
              EACH x_L WHERE x_L._u-recid = RECID(x_U) 
                         AND x_L._LO-NAME = "Master Layout". 
          /* Frame is not empty. */
            empty_frame = no.
            /* Is this bigger than the minimum? [Note we add a little
               to the size to handle rounding error.] */ 
            d = (x_L._COL - 1.0) + x_L._WIDTH + 0.01.
            IF d > min_width  THEN min_width = d.
            d = (x_L._ROW - 1.0) + x_L._HEIGHT + 0.01.
            IF d > min_height THEN min_height = d.
          END.     
        END.

        /* Look through the widgets that we are going to have to define in
           the frame itself. */
        WIDGET-LOOP:
        FOR EACH x_U WHERE x_U._PARENT = frame_layer 
                       AND NOT CAN-DO("SmartObject,FRAME,{&WT-CONTROL},QUERY":U,x_U._TYPE)
                       AND NOT x_U._NAME BEGINS "_LBL" 
                       AND x_U._STATUS EQ u_status,
            EACH x_L WHERE x_L._u-recid = RECID(x_U) 
                       AND x_L._LO-NAME = "Master Layout"
                        BY IF CAN-DO("RECTANGLE,IMAGE,TEXT",x_U._TYPE) THEN 2 ELSE 1
                        BY x_U._TAB-ORDER
                        BY x_U._NAME BY x_U._BUFFER BY x_U._DBNAME BY x_U._TYPE:
 
          /* The frame IS not empty, (so don't size to fit). */
          empty_frame = no.
          
          IF x_U._TYPE NE "BROWSE":U AND x_U._TYPE NE "QUERY" THEN DO:
            FIND _F WHERE RECID(_F)    = x_U._x-recid.
    
            IF NOT _C._DOWN OR NOT x_U._NAME BEGINS "_LBL" THEN
              iteration_ht = MAX(iteration_ht, x_L._ROW - 1 + x_L._HEIGHT).
            IF SEEK(P_4GL) - stmnt_strt > 3300 THEN DO:  /* DEF FRAME statement is  */
              stmnt_strt = SEEK(P_4GL).                  /* getting too long, break */
              
              /* Put the Frame "WITH" clause out. Needs to be on all frame references
                 to ensure USE-DICT-EXPS and other compiler directives are recognized
                 for each DEFINE FRAME generated for a given frame. */
              RUN put-frame-with-clause (INPUT empty_frame, INPUT default_btn, INPUT No /* gentitle */).
              PUT STREAM P_4GL UNFORMATTED SKIP
              "/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */"
              SKIP.
              IF _U._STATUS = u_status  /* EXPORT vs EXPORT-FORM */
              THEN PUT STREAM P_4GL UNFORMATTED "DEFINE "
                       IF _U._SHARED THEN "~{~&NEW} SHARED " ELSE ""
                      "FRAME " _U._NAME SKIP.
              ELSE PUT STREAM P_4GL UNFORMATTED "FORM" SKIP.
            END.
    
            IF x_U._TYPE NE "TEXT" THEN DO:
             /* Is this the cancel/default button */
             IF x_U._TYPE EQ "BUTTON" THEN DO:
               IF _C._default-btn-recid = RECID(x_U) THEN default_btn = x_U._NAME.
               IF _C._cancel-btn-recid = RECID(x_U)  THEN cancel_btn  = x_U._NAME.
             END.
             /* A CLOB data field is represented by a local LONGCHAR variable, the local
                name must be used in the frame definition */
             IF x_U._TABLE = ? OR 
                _F._DISPOSITION = "LIKE":U OR 
                _F._SOURCE-DATA-TYPE = "CLOB":U THEN
               PUT STREAM P_4GL UNFORMATTED
                 "     " (IF _F._SOURCE-DATA-TYPE = "CLOB":U THEN x_U._LOCAL-NAME ELSE x_U._NAME).
               ELSE PUT STREAM P_4GL UNFORMATTED
                 "     " (IF LDBNAME(x_U._DBNAME) NE ? AND NOT _suppress_dbname AND
                          NOT CAN-DO(_tt_log_name, LDBNAME(x_U._DBNAME))
                         THEN (LDBNAME(x_U._DBNAME) + "." + x_U._BUFFER)
                         ELSE x_U._BUFFER) + "." +
                        (IF _F._DISPOSITION = "FIELD" AND _F._LIKE-FIELD NE ""
                         THEN _F._LIKE-FIELD ELSE x_U._NAME).
    
               IF x_U._DEFINED-BY = "USER" THEN
                  RUN put_view-as ("     ").
              
               RUN put_position (INPUT " ", INPUT "DEF":U).
               
               RUN put_help_msg.
            
               /* Display multi-line widgets with NO-LABEL                           */
               IF CAN-DO("EDITOR,RADIO-SET,SLIDER,SELECTION-LIST",x_U._TYPE) OR
                  x_L._NO-LABELS THEN PUT STREAM P_4GL UNFORMATTED " NO-LABEL".
              
               /* Put context-help-id */
               IF x_U._DBNAME NE ? AND x_U._CONTEXT-HELP-ID NE ? THEN
                 PUT STREAM P_4GL UNFORMATTED
                   " CONTEXT-HELP-ID " x_U._CONTEXT-HELP-ID.
             
               /* Put widget-id */
               IF x_U._WIDGET-ID NE ? THEN
                 PUT STREAM P_4GL UNFORMATTED
                   " WIDGET-ID " x_U._WIDGET-ID.
               /* Special fill-in field attributes                                   */          
               IF x_U._TYPE EQ "FILL-IN"
               THEN PUT STREAM P_4GL UNFORMATTED
                    IF _F._BLANK THEN " BLANK " ELSE ""
                    IF _F._DEBLANK THEN " DEBLANK " ELSE ""
                    IF _F._AUTO-RETURN THEN " AUTO-RETURN " ELSE ""
                    IF _F._DISABLE-AUTO-ZAP THEN " DISABLE-AUTO-ZAP " ELSE ""
                    IF _F._PASSWORD-FIELD THEN " PASSWORD-FIELD " ELSE "".
                  
               /* Add label, format, view-as phrase and color to database fields to
                  variables that are defined multiple times or are defined in the
                  database. */
               FIND acopy WHERE acopy._u-recid = RECID(x_U) NO-ERROR.
               IF AVAILABLE acopy OR (x_U._TABLE <> ?) THEN DO:
                 /* Special fill-in attributes                                      */
                 IF CAN-DO("FILL-IN,COMBO-BOX,TOGGLE-BOX",x_U._TYPE) THEN DO:
                   ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                                    x_U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                              "~{","~~~{"), "~;","~~~;").
                   IF q_label ne ? AND x_U._LABEL-SOURCE = "E":U AND
                      NOT _L._NO-LABELS AND NOT x_L._NO-LABELS THEN
                     PUT STREAM P_4GL UNFORMATTED SKIP "          "
                         IF NOT _C._SIDE-LABELS AND x_U._TYPE NE "TOGGLE-BOX":U
                         THEN "COLUMN-LABEL ~"" ELSE "LABEL ~"" q_label "~""
                         IF x_U._LABEL-ATTR NE "" AND x_U._LABEL-ATTR NE ?
                       THEN ":" + x_U._LABEL-ATTR ELSE "".
    
                   IF _F._FORMAT-SOURCE = "E":U AND x_U._TYPE NE "TOGGLE-BOX":U THEN DO:
                     IF x_U._TYPE = "COMBO-BOX":U AND LOOKUP(x_U._SUBTYPE,"SIMPLE,DROP-DOWN":U) > 0 THEN.
                     ELSE
                       PUT STREAM P_4GL UNFORMATTED " FORMAT ~"" _F._FORMAT "~""
                          IF _F._FORMAT-ATTR NE "" AND _F._FORMAT-ATTR NE ?
                          THEN ":" + _F._FORMAT-ATTR ELSE "".
                   END.  /* if format-source = "E" and not toggle-box */
    
                 END.  /* Special fill-in stuff */

                 /* A CLOB data field is represented by a local LONGCHAR variable, the local
                    name must be used on the frame and should not have a view-as phrase */
                 IF _F._DISPOSITION NE "LIKE":U AND NOT _F._DICT-VIEW-AS AND 
                    _F._SOURCE-DATA-TYPE <> "CLOB":U THEN
                   RUN put_view-as ("          ").
                 RUN put_color_font ("          "). 
               END.
               RUN put_NO-TAB-STOP. /* Put out NO-TAB-STOP if it's set*/   
               PUT STREAM P_4GL UNFORMATTED SKIP.
             END.
             ELSE DO:    /* TEXT - Be careful no to put out a label                   */
               IF x_U._SUBTYPE ne "LABEL":U THEN DO:
                 /* Massage the string with tildas so it can be placed in quotes.
                    Remember to leave in leading spaces. */
                 ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                              _F._INITIAL-DATA,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                              "~{","~~~{"), "~;","~~~;").
                 PUT STREAM P_4GL UNFORMATTED "     ~"" q_label "~""
                     (IF x_U._LABEL-ATTR NE "" THEN ":" + x_U._LABEL-ATTR ELSE "")
                      " VIEW-AS TEXT" SKIP.
                 RUN put_size (INPUT "          ", INPUT "DEF":U).
                 /* Write out the tooltip definition */
                 RUN put_tooltip (INPUT x_U._TOOLTIP, INPUT x_U._TOOLTIP-ATTR).
                 RUN put_position (INPUT " ", INPUT "DEF":U).
                 /* Put widget-id */
                 IF x_U._WIDGET-ID NE ? THEN
                   PUT STREAM P_4GL UNFORMATTED
                     " WIDGET-ID " x_U._WIDGET-ID.
                 PUT STREAM P_4GL UNFORMATTED SKIP.
                 RUN put_color_font ("          "). 
                 IF NOT tty_win AND (x_L._FGCOLOR NE ? OR x_L._BGCOLOR NE ? OR
                                     x_L._FONT NE ?) THEN
                   PUT STREAM P_4GL UNFORMATTED SKIP.
              END.
            END. /* A text field */
          END.  /* IF NOT A BROWSER */
          ELSE IF NOT skip_queries THEN DO:  /* A BROWSER */
  
            PUT STREAM P_4GL UNFORMATTED
                 "     " x_U._NAME.
            RUN put_position (INPUT " ", INPUT "DEF":U).
    
            RUN put_help_msg.
            
            /* Put widget-id */
            IF x_U._WIDGET-ID NE ? THEN
              PUT STREAM P_4GL UNFORMATTED
                " WIDGET-ID " x_U._WIDGET-ID.

            PUT STREAM P_4GL UNFORMATTED SKIP.
            
          END.  /* Browser has a valid query */
                      
          /* For dialog-boxes and SIZE-TO-FIT frames, we need to remember the last 
             location in the skip chain. */
          ASSIGN gd_last_width  = x_L._COL - .99 + x_L._WIDTH   /* .99 corrects for a   */
                 gd_last_height = x_L._ROW - .99 + x_L._HEIGHT  /* Compiler quirk that  */
                 .                                              /* Makes the dialog .01 */
                                                                /* too big in each load */
        END. /* WIDGET-LOOP: FOR... */
        
        /* Add spaces and skips to fill out the inner-size of dialog-boxes
           and SIZE-TO-FIT frames. 
           NOTE: we cannot do this if the dialog-box is sized in Pixels.  For the
           pixel case, we need to use the SIZE-PIXELS phrase. */ 
        IF _C._SIZE-TO-FIT OR
           (_U._TYPE eq "DIALOG-BOX":U AND _U._LAYOUT-UNIT /* Character */)          
        THEN DO: 
          IF _U._TYPE eq "DIALOG-BOX" 
          THEN ASSIGN min_width = _L._WIDTH
                      min_height = _L._HEIGHT
                      .
          IF gd_last_width < min_width OR gd_last_height < min_height THEN DO:
            PUT STREAM P_4GL UNFORMATTED
               "     SPACE(" LEFT-TRIM(STRING(MAX(0,min_width  - gd_last_width),
                                              ">>>>9.99":U)) ")"
                    " SKIP(" LEFT-TRIM(STRING(MAX(0,min_height - gd_last_height),
                                              ">>>>9.99":U)) ")"
                 SKIP.
          END. /* IF need to add in anything */      
        END. /* IF...DIALOG-BOX...*/

        /* Put the Frame "WITH" clause out. */
        RUN put-frame-with-clause (empty_frame, INPUT default_btn, INPUT Yes /* gentitle */).

      END.  /* If an active frame or dialog box */
      
      /* See if the Frame has any child frames. */
      IF CAN-FIND(FIRST x_U WHERE x_U._TYPE = "FRAME":U AND
                x_U._PARENT = frame_layer AND
                x_U._STATUS NE "DELETED":U) THEN DO:
        /* This frame has child frames - drill down. */
        RUN put-frame-definitions-in (INPUT frame_layer).
      END.
    END.
        
    /* Go to the PREVIOUS sibling that is a true FRAME (Note that this
       might also point to a QUERY object or a SmartObject, both of which are
       visualized in the UIB as FRAMES.  However, the larger FRAME-DEFS-LOOP
       will catch these cases.) */
    frame_handle = frame_handle:PREV-SIBLING. 
    REPEAT WHILE VALID-HANDLE(frame_handle) AND frame_handle:TYPE NE "FRAME":
      frame_handle = frame_handle:PREV-SIBLING. 
    END. 
    
  END.  /*  FRAME-DEFS-LOOP: While frame_handle NE ? */
    
END PROCEDURE.

/* put-frame-with-clause - Write out a frame's WITH clause.
 *
 * NOTE: To keep from exceeding 4k statement limit, AB at times breaks
 * a frame definition into more than one Define Frame or Form statement.
 * This procedure is called whenever the WITH frame phrase is generated
 * to ensure uniformity in a frame's definitions across more than one
 * statement.
 *
 * NOTE: Added as part of fix to Issue 273.
 */
PROCEDURE put-frame-with-clause.
  DEF INPUT PARAMETER empty_frame   AS LOGICAL       NO-UNDO.
  DEF INPUT PARAMETER default_btn   AS CHARACTER     NO-UNDO.
  DEF INPUT PARAMETER gentitle      AS LOGICAL       NO-UNDO.

  /* Put with clause in                                                      */
  PUT STREAM P_4GL UNFORMATTED
      "    WITH "
      IF _U._TYPE = "DIALOG-BOX"    THEN "VIEW-AS DIALOG-BOX " ELSE
        IF _C._DOWN THEN "DOWN "    ELSE "1 DOWN "
      IF _L._NO-BOX AND _U._TYPE NE "DIALOG-BOX"
                                    THEN "NO-BOX "           ELSE ""
      IF NOT _C._HIDE               THEN "NO-HIDE "          ELSE ""
      IF _C._KEEP-TAB-ORDER         THEN "KEEP-TAB-ORDER "   ELSE ""
      IF _C._OVERLAY AND _U._TYPE NE "DIALOG-BOX "
                                    THEN "OVERLAY "          ELSE ""
      IF _C._NO-HELP                THEN "NO-HELP "          ELSE ""
      IF _C._USE-DICT-EXPS          THEN "USE-DICT-EXPS "    ELSE ""
      SKIP "         "
      IF _C._PAGE-BOTTOM            THEN "PAGE-BOTTOM "      ELSE ""
      IF _C._PAGE-TOP AND NOT _C._PAGE-BOTTOM
                                    THEN "PAGE-TOP "         ELSE ""
      IF _L._NO-LABELS              THEN "NO-LABELS "        ELSE ""
      IF _C._SIDE-LABELS            THEN "SIDE-LABELS "      ELSE ""
      IF _C._TOP-ONLY               THEN "TOP-ONLY "         ELSE ""
      IF _L._NO-UNDERLINE           THEN "NO-UNDERLINE "     ELSE ""
      IF NOT _C._VALIDATE           THEN "NO-VALIDATE "      ELSE ""
      IF _L._3-D                    THEN "THREE-D "          ELSE ""
      IF _U._NO-TAB-STOP            THEN "NO-TAB-STOP "      ELSE ""
      IF _C._NO-AUTO-VALIDATE       THEN "NO-AUTO-VALIDATE " ELSE "".
  
  IF _U._LAYOUT-UNIT THEN DO:
    IF _L._COL ne ?  AND _U._TYPE NE "DIALOG-BOX" THEN
      PUT STREAM P_4GL UNFORMATTED SKIP
          "         AT COL "    /* Max is necessary only because of syntax */
            MAX(ROUND(_L._COL,2),1) " ROW " MAX(ROUND(_L._ROW,2),1).
    /* Size for dialog-boxes is handled in the Frame (with skips & spaces).
       Size-to-fit frames are already handled, unless they are empty.) */
    IF _U._TYPE eq "FRAME":U AND (empty_frame OR _C._SIZE-TO-FIT eq NO)
    THEN DO:
      IF _C._SCROLLABLE 
      THEN PUT STREAM P_4GL UNFORMATTED SKIP
          "         SCROLLABLE SIZE " ROUND(_L._VIRTUAL-WIDTH,2) " BY "
                   ROUND(_L._VIRTUAL-HEIGHT,2).
      ELSE PUT STREAM P_4GL UNFORMATTED SKIP
          "         SIZE " ROUND(_L._WIDTH,2) " BY " ROUND(_L._HEIGHT,2).
    END. /* IF...FRAME and not Size-to-Fit... */
    ELSE DO:
      /* For dialogs boxes (and SIZE-TO-FIT frames), we specify SCROLLABLE 
         in case the size of the frame exceeds the "default" window size. 
         If we don't add SCROLLABLE and the width exceeds the 
         DEFAULT WINDOW WIDTH, then the spaces are wrapped to the next line. 
         [See bug # 94-07-27-103]. */
      PUT STREAM P_4GL UNFORMATTED " SCROLLABLE ". 
    END. /* IF...DIALOG... */
  END.  /* If layout is in characters */
  ELSE DO:  /* Layout is in PIXELS */
    IF _L._COL ne ? AND _U._TYPE NE "DIALOG-BOX" THEN
      PUT STREAM P_4GL UNFORMATTED SKIP
          "         AT X "   /* Max is necessary only because of syntax */
            MAX(INTEGER((_L._COL - 1) * SESSION:PIXELS-PER-COLUMN),0) " Y "
            MAX(INTEGER((_L._ROW - 1) * SESSION:PIXELS-PER-ROW),0).
    IF _U._TYPE eq "FRAME":U THEN DO:
      /* Size-to-fit frames are always scrollable in order to avoid 
         compiler errors. */
      IF _C._SIZE-TO-FIT AND NOT empty_frame
      THEN PUT STREAM P_4GL UNFORMATTED " SCROLLABLE ". 
      ELSE DO:
        IF _C._SCROLLABLE
        THEN PUT STREAM P_4GL UNFORMATTED SKIP
          "         SCROLLABLE SIZE-PIXELS "
                 INTEGER(_L._VIRTUAL-WIDTH * SESSION:PIXELS-PER-COLUMN) " BY "
                 INTEGER(_L._VIRTUAL-HEIGHT * SESSION:PIXELS-PER-ROW).
        ELSE PUT STREAM P_4GL UNFORMATTED  SKIP
          "         SIZE-PIXELS " INTEGER(_L._WIDTH * SESSION:PIXELS-PER-COLUMN)
          " BY "                  INTEGER(_L._HEIGHT * SESSION:PIXELS-PER-ROW).
      END. /* IF not Size-to-fit */
   END. /* IF...FRAME... */
   ELSE IF _U._TYPE eq "DIALOG-BOX":U THEN DO:
      /* Pixel-Size for dialog-boxes CANNOT behandled in the Frame 
       (with skips & spaces), so this is a difference between Character and
       Pixel layout.  */ 
      PUT STREAM P_4GL UNFORMATTED  SKIP
          "         SIZE-PIXELS " 
                                  INTEGER((_L._WIDTH + _dialog_border_width) *  
                                           SESSION:PIXELS-PER-COLUMN)
          " BY "                  INTEGER((_L._HEIGHT + _dialog_border_height) * 
                                           SESSION:PIXELS-PER-ROW).
    END. /* IF...DIALOG... */
  END.
                        
  RUN put_color_font_title ("         ", gentitle).
  /* Put out the DEFAULT and CANCEL BUTTON */
  IF (default_btn NE ?) OR (cancel_btn NE ?) 
  THEN PUT STREAM P_4GL UNFORMATTED SKIP "        "
           IF default_btn NE ? THEN (" DEFAULT-BUTTON " + default_btn) ELSE ""
           IF cancel_btn NE ?  THEN (" CANCEL-BUTTON " + cancel_btn) ELSE "".

  /* Put out DROP-TARGET if turned on for this frame/dialog */
  IF _U._DROP-TARGET THEN
    PUT STREAM P_4GL UNFORMATTED " DROP-TARGET".
          
  /* Put out WIDGET-id if set for this frame/dialog */
  IF _U._WIDGET-ID NE ? THEN
      PUT STREAM P_4GL UNFORMATTED " WIDGET-ID " _U._WIDGET-ID.
  /* Put out Context Sensitive help if turned on for this dialog */  
  IF _U._TYPE = "DIALOG-BOX":U THEN DO:
    IF _C._CONTEXT-HELP THEN PUT STREAM P_4GL UNFORMATTED SKIP "         CONTEXT-HELP".
    IF _C._CONTEXT-HELP-FILE > "" THEN PUT STREAM P_4GL UNFORMATTED " CONTEXT-HELP-FILE """ _C._CONTEXT-HELP-FILE """:U".
  END.  /* if dialog-box */

  PUT STREAM P_4GL UNFORMATTED "." SKIP (1).
END PROCEDURE. /* put-frame-with-clause */

PROCEDURE put_tooltip:
/* Write out the tooltip definition if one exists */
   DEFINE INPUT PARAMETER tooltip_text AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER tt_transattr AS CHARACTER NO-UNDO.
       
   IF tooltip_text NE "" AND tooltip_text NE ? THEN
     PUT STREAM P_4GL UNFORMATTED " TOOLTIP " + """" + 
       REPLACE(tooltip_text,'"', '~~"') + """" + 
       (IF (tt_transattr NE "" AND tt_transattr NE ?) THEN (":":U + tt_transattr) ELSE "").
END PROCEDURE.       

PROCEDURE put_tt_defs:
   /* write out tt defs */
   /* use definition include (Dataview)*/
   IF NUM-ENTRIES(_P._data-object) > 1 THEN
     PUT STREAM P_4GL UNFORMATTED SKIP
       "~{" ENTRY(1,_P._data-object) "~}" SKIP(1).
   ELSE
     PUT STREAM P_4GL UNFORMATTED SKIP
       "DEFINE TEMP-TABLE RowObject NO-UNDO" SKIP
       "    ~{~{~&DATA-FIELD-DEFS~}~}" SKIP
       "    ~{src/adm2/robjflds.i~}." SKIP (1).
END.

PROCEDURE put-func-prototypes-in.

  DEFINE VARIABLE vCode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE Ref-Type     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iIn          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEndFunction AS INTEGER    NO-UNDO.

  /* Preprocessor directives. */
  &SCOPED-DEFINE AMPER-IF     "&IF"
  &GLOBAL-DEFINE AMPER-THEN   "&THEN"
  &GLOBAL-DEFINE AMPER-ENDIF  "&ENDIF"
    
  FIND _U WHERE _U._HANDLE eq _h_win.

  /* Are there any user functions to output? */
  FIND FIRST _TRG WHERE _TRG._wrecid = RECID(_U) AND
                        _TRG._tSECTION = "_FUNCTION" AND
                        _TRG._STATUS EQ u_status NO-ERROR.
  IF (AVAILABLE _TRG) /*AND (p_status <> "EXPORT")*/ THEN
  DO:

  IF p_status = "PREVIEW" THEN PUT STREAM P_4GL UNFORMATTED SKIP(1).
  
  PUT STREAM P_4GL UNFORMATTED
   "/* ************************  Function Prototypes ********************** */" 
   SKIP (1).

  /*  Output all function prototypes. */
  FOR EACH _TRG WHERE _TRG._wrecid = RECID(_U) AND
                      _TRG._tSECTION = "_FUNCTION" AND
                      _TRG._STATUS EQ u_status BY _TRG._tEVENT:

    RUN Put_Special_Preprocessor_Start.

    /* Determine default code on the fly, otherwise use the user input code. */
    IF (_TRG._tCODE = ?) AND (_TRG._tSPECIAL <> ?) THEN
      RUN adeshar/_coddflt.p (_TRG._tSPECIAL, _TRG._wrecid, OUTPUT vCode).
    ELSE
      ASSIGN vCode = TRIM(_TRG._tCode).

    /* Determine if we need to output function prototype as forward or external.
         FORWARD:   FUNCTION func-name RETURNS data-type
                      (parameter-definition) FORWARD.

         EXTERNAL:  FUNCTION func-name RETURNS data-type
                      (parameter-definition) [MAP [TO] map-name] IN proc-handle.
       _TRG._tCODE does not store the FORWARD keyword, only the implementation
       code. So determine if external based on the presence of the required " IN "
       keyword and the lack of an END FUNCTION. Using IN alone is not enough, since
       the code block could make references to RUN..IN <proc-handle>,etc. - jep 1/31/97
    */

    /*The INDEX functions were removed from the IF statement to avoid error 42
      when the function code block is too big.*/
    ASSIGN iIn          = INDEX(vCode, " IN ")
           iEndFunction = INDEX(vCode, "END FUNCTION").

    IF iIn > 0 AND iEndFunction = 0 THEN
      ASSIGN Ref-Type = "EXTERNAL".
    ELSE
      ASSIGN Ref-Type = "FORWARD".

    /* Heading = _FUNCTION-FORWARD or _FUNCTION-EXTERNAL event window [DEFAULT] */
    IF p_status NE "PREVIEW" THEN
      PUT STREAM P_4GL UNFORMATTED
        "&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-" Ref-Type " "
        _TRG._tEVENT SPACE win_name SPACE
        IF (_TRG._tSPECIAL <> ?) THEN _TRG._tSPECIAL ELSE ""
        IF (_TRG._DB-REQUIRED)   THEN (" " + "_DB-REQUIRED":u) ELSE ""
        SKIP.

    PUT STREAM P_4GL UNFORMATTED  "FUNCTION " _TRG._tEVENT " ".   
    _TRG._tOFFSET = SEEK(P_4GL).

    /* Handle adding the PRIVATE keyword when needed. */
    IF _TRG._PRIVATE-BLOCK AND INDEX(ENTRY(1, vCode, CHR(10))," PRIVATE":U) = 0 THEN
      RUN add-func-private (INPUT-OUTPUT vCode).
    ELSE IF NOT _TRG._PRIVATE-BLOCK AND INDEX(ENTRY(1, vCode, CHR(10))," PRIVATE":U) > 0 THEN 
      RUN remove-func-private(INPUT-OUTPUT vCode).

    IF Ref-Type = "FORWARD" THEN
    DO:
      /* During a Section Editor Check Syntax, only the function prototypes are generated.
         If you forward declare a function and reference it before its implemented, the
         Compiler generates a syntax error. To avoid that, we determine if we are generating
         code for a check syntax. If so, we generate an external reference for the function
         using IN THIS-PROCEDURE. To do that, we truncate the function block after the
         first colon (:) and add the IN THIS-PROCEDURE code to complete the prototype.

         Otherwise, we actually insert the FORWARD keyword in place of the colon.
         
         - jep _FUNC 1/31/97
      */
      IF p_Status <> "CHECK-SYNTAX" THEN
        ASSIGN vCode = ENTRY(1, vCode, ":") + " FORWARD." NO-ERROR.
      ELSE
        ASSIGN iIn   = INDEX(vCode, ":") - 1
               vCode = SUBSTRING(vCode, 1, iIn, "CHARACTER") + " IN THIS-PROCEDURE." NO-ERROR.
      IF ERROR-STATUS:ERROR = TRUE THEN
        ASSIGN vCode = TRIM(_TRG._tCODE).
    END.
    PUT STREAM P_4GL UNFORMATTED vCode.

    IF p_status NE "PREVIEW"
    THEN PUT STREAM P_4GL UNFORMATTED SKIP (1) "/* _UIB-CODE-BLOCK-END */" SKIP
         "&ANALYZE-RESUME".

    RUN Put_Special_Preprocessor_End (INPUT 1 /* skip lines */).

  END. /* FOR EACH... _FUNCTION... */
  END. /* IF AVAILABLE */

END PROCEDURE.

PROCEDURE put_NO-TAB-STOP:
  /* Outputs the attribute if it is set. */
  IF x_U._NO-TAB-STOP THEN
    PUT STREAM P_4GL UNFORMATTED " NO-TAB-STOP ".
END PROCEDURE.

PROCEDURE gen-tt-def :
/*------------------------------------------------------------------------------
  Purpose:  Fill up a character parameter with the temp-table definition    
  Parameters:  def-line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER def-line AS CHARACTER                         NO-UNDO.

  DEFINE VAR      cdbaware    AS CHARACTER  NO-UNDO.

  RUN adeuib/_getttdefs.p (RECID(_P ), YES, OUTPUT def-line). 
  /* If buffer then prepend the db-required preprocessor  */

  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P )
                        AND   _TT._TABLE-TYPE = "B")  THEN
  DO:
    RUN gen-db-required(OUTPUT cdbaware).
    def-line = cdbaware + def-line.
  END.

END PROCEDURE.

PROCEDURE gen-uf-def :
   DEFINE OUTPUT PARAMETER def-line AS CHARACTER NO-UNDO.

   FIND _UF WHERE _UF._p-recid = RECID(_P).
   def-line = _UF._DEFINITION.            
END.

PROCEDURE gen-db-required:
  DEFINE OUTPUT PARAMETER def-line AS CHARACTER NO-UNDO.
  /* The dbrequired definition is normally defined with the preprocessors, 
     but need to be higher up if there are buffers, so we use a flag to
     check if it has already been defined.  */ 
  IF _P._DB-AWARE THEN
  DO:
    IF lDbRequiredDone THEN
      def-line = '/* Note that Db-Required is defined before the buffer definitions for this object. */'
       +  CHR(10) + CHR(10).
    ELSE DO:
     def-line = 
      '/* Db-Required definitions. */'      +  CHR(10) +
      '&IF DEFINED(DB-REQUIRED) = 0 &THEN'  +  CHR(10) +
      '    &GLOBAL-DEFINE DB-REQUIRED TRUE' +  CHR(10) +
      '&ENDIF'                              +  CHR(10) +
      '&GLOBAL-DEFINE DB-REQUIRED-START   &IF ~{&DB-REQUIRED~} &THEN'  +  CHR(10) +
      '&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF' +  CHR(10) +
       CHR(10) + CHR(10).
      lDbRequiredDone = TRUE.
    END.
  END.
END.

{adeuib/_genproc.i}
{adeuib/_genpro2.i}







