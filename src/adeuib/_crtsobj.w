&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : adeuib\_crtsobj.w
    Purpose     : To generate _BC records for a SmartDataBrowser 
                  or _U records and _TT  for a SmartDataViewer.

    Syntax      : RUN adeuib\_crtsobj.w (pType, pAction, pFields).

    Description : The Wizard calls this after a user has sucessfully choosen a
                  DataObject and at least one field for a SmartDataBrowser or 
                  SmartDataViewer.

    Author(s)   : Ross Hunter
    Created     : 2/12/98
    Changed     : 3/19/98 HD  
                  Moved create _TT to _upddott.w to let SmartViewer 
                  share logic with WebObject.  
                  04/07/99 tsm
                  Added support for various Intl Numeric formats (in addition
                  to American and European) by using session set-numeric-format
                  method to set format back to user's setting after it is set
                  to American.
                  05/18/2000 BSG
                  Changed the viewer generation process to not qualify field
                  names with RowObject if they're already qualified.
                                                      
   ---------------------------------------------------------------------------                    
    Parameters  : pType   - One of these values:   
                            - SmartDataBrowser 
                            - SmartDataViewer
                  pfields - List of fields, semicolon separated with
                            opitional list of objects that are qualifiers
                            of fields to enable.                               
  -------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.                */
/*-------------------------------------------------------------------------*/

/* *****************************  Definitions  *************************** */
DEFINE INPUT PARAMETER pcType    AS CHARACTER                         NO-UNDO.
DEFINE INPUT PARAMETER pcFields  AS CHARACTER                         NO-UNDO.

{adeuib/sharvars.i}  /* Shared variables needed by the AB                  */
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/brwscols.i}  /* Temp-Table definition for the columns of a browser */
{src/adm2/globals.i}
{destdefi.i}         /* Definitions for dynamics design-time temp-tables. */


DEFINE VARIABLE giNumFields     AS INTEGER    NO-UNDO.
DEFINE VARIABLE gcFields        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcEnableObjects AS CHARACTER  NO-UNDO.

/* Function prototypes */
FUNCTION get-sdo-hdl RETURNS HANDLE
    (INPUT proc-file-name AS CHARACTER,
     INPUT phOwner AS HANDLE) IN _h_func_lib.

FUNCTION shutdown-sdo RETURNS CHARACTER
    (INPUT phOwner AS HANDLE ) IN _h_func_lib.

FUNCTION isDynamicClassNative RETURNS LOGICAL
    (INPUT pcClass AS CHARACTER) IN _h_func_lib.

/* @TODO  pass sdo in as param?  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.86
         WIDTH              = 50.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN 
  gcEnableObjects = IF NUM-ENTRIES(pcFields,";":U) > 1 
                    THEN ENTRY(2,pcFields,";":U)
                    ELSE ?
  gcFields        = ENTRY(1,pcFields,";":U).

  FIND _P WHERE _P._WINDOW-HANDLE = _h_win. 
  IF _DynamicsIsRunning AND isDynamicClassNative(_P.object_type_code) THEN
    RUN assignClassAttributes IN THIS-PROCEDURE.

CASE pcType:
  WHEN "SmartDataBrowser":U THEN RUN create_a_SmartBrowser.
  WHEN "SmartDataViewer":U  THEN RUN create_a_SmartViewer.
END CASE.  /* Case on pType */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-adjustWindowSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustWindowSize Procedure 
PROCEDURE adjustWindowSize :
/*------------------------------------------------------------------------------
  Purpose:     To enlarge the standard template window of SmartViewers if
               necessary.
  Parameters:  
        INPUT cScratch - Name of the file with field layout
              hFrame   - Handle of the frame to adjust (along with _h_win)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER cScratch AS CHARACTER                       NO-UNDO.
    DEFINE INPUT  PARAMETER hFrame   AS HANDLE                          NO-UNDO.

    DEFINE VARIABLE cLine            AS CHARACTER EXTENT 100            NO-UNDO.
    DEFINE VARIABLE dHeight          AS DECIMAL                         NO-UNDO.
    DEFINE VARIABLE dWidth           AS DECIMAL                         NO-UNDO.

    DEFINE BUFFER w_U FOR _U.
    DEFINE BUFFER f_U FOR _U.
    DEFINE BUFFER w_L FOR _L.
    DEFINE BUFFER f_L FOR _L.

    ANALYZE VALUE(cScratch) VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

    INPUT FROM VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

    IMPORT cLine.
    DO WHILE cLine[1] NE "FR":U:
      IMPORT cLine.
    END.

    /* Have found the frame record, get its dimensions */
    IMPORT cLine.
    ASSIGN dWidth  = DECIMAL(cLine[6]) / 100
           dHeight = DECIMAL(cLine[7]) / 100.
    IF dWidth > hFrame:WIDTH OR dHeight > hFrame:HEIGHT THEN DO:
      /* Window needs to be enlarged */

      FIND w_U WHERE w_U._handle = _h_win.       /* Get the window _U */
      FIND w_L WHERE w_L._u-recid = RECID(w_U).  /* Get window _L     */
      FIND f_U WHERE f_U._handle = _h_win.       /* Get the frame _U  */
      FIND f_L WHERE f_L._u-recid = RECID(w_U).  /* Get frame _L      */

      IF dWidth > hFrame:WIDTH THEN
        ASSIGN _h_win:WIDTH        = dWidth
               hFrame:WIDTH        = dWidth
               w_L._WIDTH          = dWidth
               w_L._VIRTUAL-WIDTH  = MAX(w_L._VIRTUAL-WIDTH, dWidth)
               f_L._WIDTH          = dWidth
               f_L._VIRTUAL-WIDTH  = MAX(f_L._VIRTUAL-WIDTH, dWidth).


      IF dHeight > hFrame:HEIGHT THEN
        ASSIGN _h_win:HEIGHT       = dHeight
               hFrame:HEIGHT       = dHeight
               w_L._HEIGHT         = dHeight
               w_L._VIRTUAL-HEIGHT = MAX(w_L._VIRTUAL-HEIGHT, dHeight)
               f_L._HEIGHT         = dHeight
               f_L._VIRTUAL-HEIGHT = MAX(f_L._VIRTUAL-HEIGHT, dHeight).

    END.  /* IF the window needs to get bigger */

    INPUT CLOSE.
    OS-DELETE VALUE(SESSION:TEMP-DIR + "scratch.qs":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignClassAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignClassAttributes Procedure 
PROCEDURE assignClassAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Assigns all default class attributes for master objects
               of a dynamics viewer, browser or SDO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cInheritClasses  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDesignManager   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cValue           AS CHARACTER  NO-UNDO.

 DEFINE BUFFER x_U             FOR _U.
 DEFINE BUFFER x_C             FOR _C.

 ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, 
                                      INPUT "RepositoryDesignManager":U) NO-ERROR.
     /* get inherited values of the class once */
 RUN retrieveDesignClass IN hDesignManager
                      ( INPUT  _P.Object_type_code,
                        OUTPUT cInheritClasses,
                        OUTPUT TABLE ttClassAttribute,
                        OUTPUT TABLE ttUiEvent,
                        output table ttSupportedLink        ) NO-ERROR.  
 
 IF DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U) THEN
 DO:
   FIND FIRST _U WHERE  _U._TYPE = "Browse":U AND _U._WINDOW-HANDLE = _h_win.
   FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
   FIND _L WHERE RECID(_L) = _U._lo-recid NO-ERROR.
 END.
 ELSE IF DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) THEN
 DO:
   /* Do the same for the frame */
    FIND _U WHERE _U._TYPE EQ "FRAME":U AND
                  _U._WINDOW-HANDLE EQ _h_win AND
                  _U._STATUS NE "DELETED":U.
    FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
    FIND _L WHERE RECID(_L) = _U._lo-recid NO-ERROR.
 END.
 ELSE IF DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynSDO":U) THEN
 DO:
   FIND _U WHERE _U._TYPE = "QUERY":U AND _U._WINDOW-HANDLE = _h_win NO-ERROR.
 END.

 FOR EACH ttClassAttribute:
   ASSIGN cValue = ttClassAttribute.tAttributeValue .
   CASE ttClassAttribute.tAttributeLabel:
     WHEN "AppService":U               THEN _P._PARTITION         = cValue.
     WHEN "ALLOW-COLUMN-SEARCHING":U   THEN _C._COLUMN-SEARCHING  = LOGICAL(cValue).
     WHEN "AppBuilderTabbing":U        THEN _C._TABBING           = cValue.
     WHEN "AUTO-VALIDATE":U            THEN _C._NO-AUTO-VALIDATE  = NOT LOGICAL(cValue).
     WHEN "BGCOLOR":U                  THEN ASSIGN _L._BGCOLOR        = INTEGER(cValue)
                                                   _U._HANDLE:BGCOLOR = _L._BGCOLOR NO-ERROR.
     WHEN "BOX":U                      THEN _L._NO-BOX            = NOT LOGICAL(cValue).
     WHEN "BOX-SELECTABLE":U           THEN _C._BOX-SELECTABLE    = LOGICAL(cValue).
     WHEN "COLUMN-MOVABLE":U           THEN _C._COLUMN-MOVABLE    = LOGICAL(cValue).
     WHEN "COLUMN-RESIZABLE":U         THEN _C._COLUMN-RESIZABLE  = LOGICAL(cValue).
     WHEN "COLUMN-SCROLLING":U         THEN _C._COLUMN-SCROLLING  = LOGICAL(cValue).
     WHEN "CONTEXT-HELP-ID":U          THEN _U._CONTEXT-HELP-ID   = INTEGER(cValue).
     WHEN "DOWN":U                     THEN _C._DOWN              = LOGICAL(cValue).
     WHEN "DROP-TARGET":U              THEN _U._DROP-TARGET       = LOGICAL(cValue).
     WHEN "FGCOLOR":U                  THEN ASSIGN _L._FGCOLOR        = INTEGER(cValue)
                                                   _U._HANDLE:FGCOLOR =   _L._FGCOLOR NO-ERROR.
     WHEN "FIT-LAST-COLUMN":U          THEN _C._FIT-LAST-COLUMN   = LOGICAL(cValue).
     WHEN "FolderWindowToLaunch":U     THEN _C._FOLDER-WINDOW-TO-LAUNCH = cValue.
     WHEN "FONT":U                     THEN DO:
       IF _U._TYPE = "BROWSE":U THEN 
            ASSIGN _L._FONT = INTEGER(cValue).
       ELSE ASSIGN _U._HANDLE:FONT  = INTEGER(cValue)
                   _L._FONT        =  _U._HANDLE:FONT.
     END.
     WHEN "HELP":U                     THEN _U._HELP              = cValue.
     WHEN "HIDDEN":U                   THEN _U._HIDDEN            = LOGICAL(cValue).
     WHEN "MANUAL-HIGHLIGHT":U         THEN _U._MANUAL-HIGHLIGHT  = LOGICAL(cValue).
     WHEN "MAX-DATA-GUESS":U           THEN _C._MAX-DATA-GUESS    = INTEGER(cValue).
     WHEN "MOVABLE":U                  THEN _U._MOVABLE           = LOGICAL(cValue).
     WHEN "MULTIPLE":U                 THEN _C._MULTIPLE          = LOGICAL(cValue).
     WHEN "NO-EMPTY-SPACE":U           THEN _C._NO-EMPTY-SPACE    = LOGICAL(cValue).
     WHEN "NUM-LOCKED-COLUMNS":U       THEN _C._NUM-LOCKED-COLUMNS = INTEGER(cValue).
     WHEN "OVERLAY":U                  THEN _C._OVERLAY           = LOGICAL(cValue).
     WHEN "PAGE-BOTTOM":U              THEN _C._PAGE-BOTTOM       = LOGICAL(cValue).
     WHEN "PAGE-TOP":U                 THEN _C._PAGE-TOP          = LOGICAL(cValue).
     WHEN "PRIVATE-DATA":U             THEN _U._PRIVATE-DATA      = cValue.
     WHEN "RESIZABLE":U                THEN _U._RESIZABLE         = LOGICAL(cValue).
     WHEN "ROW-HEIGHT-CHARS":U         THEN _C._ROW-HEIGHT        = DECIMAL(cValue).
     WHEN "ROW-MARKERS":U              THEN _C._NO-ROW-MARKERS    = NOT LOGICAL(cValue).
     WHEN "SCROLLABLE":U               THEN _C._SCROLLABLE        = LOGICAL(cValue).
     WHEN "SCROLLBAR-VERTICAL":U       THEN _U._SCROLLBAR-V       = LOGICAL(cValue).
     WHEN "SELECTABLE":U               THEN _U._SELECTABLE        = LOGICAL(cValue).
     WHEN "SENSITIVE":U                THEN _U._SENSITIVE         = LOGICAL(cValue).
     WHEN "SEPARATOR-FGCOLOR":U 
       OR WHEN "SeparatorFGColor":U    THEN _L._SEPARATOR-FGCOLOR = INTEGER(cValue).
     WHEN "SEPARATORS":U               THEN _L._SEPARATORS        = LOGICAL(cValue).
     WHEN "ShowPopup":U                THEN _U._SHOW-POPUP        = LOGICAL(cValue).
     WHEN "SIDE-LABELS":U              THEN _C._SIDE-LABELS       = LOGICAL(cValue).
     WHEN "SizeToFit":U                THEN _C._SIZE-TO-FIT       = LOGICAL(cValue).
     WHEN "TAB-STOP":U                 THEN _U._NO-TAB-STOP       = NOT LOGICAL(cValue).
     WHEN "THREE-D":U                  THEN _L._3-D               = LOGICAL(cValue).
     WHEN "TOOLTIP":U                  THEN _U._TOOLTIP           = cValue.
     WHEN "WindowTitleField":U         THEN _C._WINDOW-TITLE-FIELD = cValue.
    
 END CASE. 

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create_a_SmartBrowser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_a_SmartBrowser Procedure 
PROCEDURE create_a_SmartBrowser :
/*------------------------------------------------------------------------------
  Purpose:  To create a SmartBrowser from the fields picked in the Wizard.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iw         AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE hSDO       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE lDbAware   AS LOGICAL                   NO-UNDO.

  /* Find the dummy browser created by the template */
  FIND _U WHERE _U._WINDOW-HANDLE = _h_win AND
                _U._TYPE = "BROWSE".
  FIND _C WHERE RECID(_C)  = _U._x-recid.
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
  
  /* Set up _Q record - two cases use the query built against the database
     if that is the case, or define the query if going against the SDO     */
  FIND _Q WHERE RECID(_Q) = _C._q-recid.
  
  /* This is the SDO case */
  IF _Q._4GLQury = "" THEN 
  DO:      
    /* Get the handle of the SDO */
    hSDO = get-sdo-hdl(_P._data-object,TARGET-PROCEDURE).
    lDbAware = DYNAMIC-FUNCTION('getDbAware':U IN hSDO).
    IF lDbAware THEN
      ASSIGN 
        _Q._tblList    = "rowObject"
        _Q._4GLQury    = "EACH rowObject"
        _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "KEY-PHRASE", ""))
        _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "SORTBY-PHRASE", "")).
        /* KeyPhrase and SortBy options are not needed for SDB's defined
           w/ SDO */

    AddFieldLoop:
    DO i = 1 TO NUM-ENTRIES(gcFields):
      ASSIGN 
        cName     = ENTRY(i,gcFields)
        cDataType = dynamic-function("columnDataType" IN hSDO,cName).
      IF LOOKUP(cDataType,'BLOB,CLOB':U) > 0 THEN
      DO:
        MESSAGE 
           cName + ' is defined as a large object and cannot be added to a SmartDataBrowser.':U
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        NEXT AddFieldLoop.
      END.
      CREATE _BC.
      /* Need separate ASSIGN for key */
      ASSIGN _BC._x-recid      = RECID(_U).
      ASSIGN
             _BC._NAME         = ENTRY(NUM-ENTRIES(cName,'.'),cName,'.')
             _BC._DATA-TYPE    = cDataType
             _BC._DBNAME       = "_<SDO>"
             _BC._DEF-FORMAT   = dynamic-function("columnFormat" IN hSDO,cName)
             _BC._DEF-HELP     = dynamic-function("columnHelp" IN hSDO,cName)
             _BC._DEF-LABEL    = dynamic-function("columnColumnLabel" IN hSDO,cName)
             _BC._DEF-WIDTH    = MAX(IF cDataType BEGINS "DATE":U THEN FONT-TABLE:GET-TEXT-WIDTH-CHARS(_BC._DEF-FORMAT) ELSE DYNAMIC-FUNCTION("columnWidth" IN hSDO,cName),
                                              FONT-TABLE:GET-TEXT-WIDTH(ENTRY(1,_BC._DEF-LABEL,"!":U)))
             _BC._DISP-NAME    = _BC._NAME
             _BC._FORMAT       = _BC._DEF-FORMAT
             _BC._HELP         = _BC._DEF-HELP
             _BC._LABEL        = _BC._DEF-LABEL
             _BC._WIDTH        = _BC._DEF-WIDTH
             _BC._SEQUENCE     = i
             _BC._TABLE        = IF NUM-ENTRIES(cName,'.') = 2 
                                 THEN ENTRY(1,cName,'.')
                                 ELSE _Q._tbllist
             _BC._DISP-NAME    = IF NUM-ENTRIES(cName,'.') = 2  
                                 THEN _BC._TABLE + '.':U + _BC._NAME
                                 ELSE _BC._NAME.

      /* If this is a DataView based browser, the table list and query should only
         include tables for fields that were selected.  The table list and query 
         are reset in the column editor as fields are updated for the 
         browser (_coledit.p). */  
      IF NOT lDbAware AND LOOKUP(_BC._TABLE, _Q._tblList) = 0 THEN
        _Q._tblList = _Q._tblList + (IF NUM-ENTRIES(_Q._tblList) > 0 THEN ',':U ELSE '':U) +
                      _BC._TABLE.

      IF NUM-ENTRIES(_BC._DEF-LABEL,"!":U) > 1 THEN DO:
        DO iw = 2 TO NUM-ENTRIES(_BC._DEF-LABEL,"!":U):
          ASSIGN _BC._DEF-WIDTH = MAX(_BC._DEF-WIDTH, 
                                     FONT-TABLE:GET-TEXT-WIDTH(ENTRY(iw,_BC._DEF-LABEL,"!":U)))
                 _BC._WIDTH     = _BC._WIDTH.
        END.
      END.  /* IF Stacked Columns */
    END.  /* Loop through the fields */

    IF NOT lDbAware THEN
    DO:
      DO iTable = 1 TO NUM-ENTRIES(_Q._tblList):
        _Q._4GLQury  = _Q._4GLQury
                     + (IF iTable = 1 THEN "EACH " ELSE ",EACH ")
                     + ENTRY(iTable,_Q._tblList).
      END.

      ASSIGN _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "KEY-PHRASE", ""))
             _Q._OptionList = RIGHT-TRIM(REPLACE(_Q._OptionList, "SORTBY-PHRASE", "")).
             /* KeyPhrase and SortBy options are not needed for SDB's defined
                w/ SDO */
    END.  /* if db aware */

    IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyOBJECT IN _U._PROC-HANDLE.
    shutdown-sdo(TARGET-PROCEDURE).
  END.  /* SDO CASE */

  /* If this is a static browse then assign widget id */
  IF _widgetid_assign THEN 
  DO: 
    IF (_DynamicsIsRunning AND 
        NOT DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U)) OR 
       (NOT _DynamicsIsRunning) THEN
       
      _U._WIDGET-ID = DYNAMIC-FUNCTION("nextFrameWidgetID":U IN _h_func_lib,
                                       INPUT _h_win).
  END.  /* if widget id assign */

  IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
  RUN adeuib\_undbrow.p (RECID(_U)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create_a_SmartViewer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_a_SmartViewer Procedure 
PROCEDURE create_a_SmartViewer :
/*------------------------------------------------------------------------------
  Purpose:    Generate a SmartDataViewer from th fields picked in the Wizard 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VAR ctmp          AS CHARACTER NO-UNDO.
    DEFINE VAR hframe        AS HANDLE    NO-UNDO.
    DEFINE VAR drawn         AS LOGICAL   NO-UNDO.
    DEFINE VAR upd-fields    AS CHARACTER NO-UNDO.
    DEFINE VAR iField        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hSDO    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cField  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cName   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cBuffer AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hRowObject AS HANDLE     NO-UNDO.

    DEFINE BUFFER X_U FOR _U. 
 
    IF gcFields = '':U THEN RETURN.

    /* Update _TT for DataObject */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win. 
    
    RUN adeuib/_upddott.w(RECID(_P)).

    /* Get handle of the SmartViewer frame. */
    RUN adeuib/_uibinfo.p (INPUT ?, INPUT "FRAME ?", INPUT "HANDLE", OUTPUT ctmp).

    /* Setup frame for drawing fields on it. */
    ASSIGN hframe = WIDGET-HANDLE(ctmp)
           _frmx = 0
           _frmy = 0
           _second_corner_x = hframe:WIDTH-P
           _second_corner_y = hframe:HEIGHT-P.  

    IF _DynamicsIsRunning AND 
       DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) THEN
    DO:
      FIND _U WHERE _U._HANDLE = hframe.
      FIND _C WHERE RECID(_C)  = _U._x-recid.
      RUN adeuib/_drwdfld.p (INPUT gcFields).
      drawn = YES.

    END.  /* if icfrunning and dynamic viewer */
    ELSE DO:
      /* If the field names are not qualified with a table */
      IF NUM-ENTRIES(ENTRY(1,gcFields),".") LE 1 THEN
      DO:
        /* Get the handle of the SDO 
        @TODO use DataTable for buffer name instead of rowobject */
        ASSIGN 
          hSDO = get-sdo-hdl(_P._data-object,TARGET-PROCEDURE)
          hRowObject = DYNAMIC-FUNCTION('getRowObject' IN hSDO)
          cBuffer = hRowObject:NAME
          /* Before drawing, must add in RowObject table name. */
          gcFields = cBuffer + ".":U + gcFields
          gcFields = REPLACE(gcFields,",","," + cBuffer + ".":U).
      END.
      /* Generate the file to import and draw the fields with by calling _drwflds.p and
         then using _qssuckr.p to import that file. */
      RUN adeuib/_drwflds.p (INPUT gcFields, INPUT-OUTPUT drawn, OUTPUT ctmp).
      IF drawn THEN
      DO:
        SESSION:NUMERIC-FORMAT = "AMERICAN":U.
        RUN adjustWindowSize(INPUT ctmp,    /* Name of scratch file created by _drwflds.p */
                             INPUT hframe). /* Handle of new frame to be adjusted         */
        RUN adeuib/_qssuckr.p (ctmp, "", "IMPORT":U, TRUE).
        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
     
        /* When drawing a data field for an object that is using a SmartData
          object, set the data field's Enable property based on the data object
          getUpdatableColumns. Must do this here since its not picked up automatically
          in the temp-table definition like format and label.  jep-code 4/29/98 */

        /* This logic turns off enable if field is not updatable  */
        RUN setDataFieldEnable IN _h_uib (INPUT RECID(_P)).
        
        /* For SBOs we pass in the SDO name that are enabled and we do a pass here 
           to also turn off the ones whose table are not enabled in this viewer  */
        IF gcEnableObjects > '' THEN
        DO iField = 1 TO NUM-ENTRIES(gcFields):
          ASSIGN
            cField  = ENTRY(iField,gcFields)
            cBuffer = IF NUM-ENTRIES(cField,".":U) > 1
                      THEN ENTRY(1,cField,".":U)
                      ELSE cBuffer.
          /* if not enabled then disable */

          IF LOOKUP(cBuffer,gcEnableObjects) = 0 THEN
          DO:
            cName   = ENTRY(NUM-ENTRIES(cField,".":U),cField,".":U).
            FIND x_U WHERE x_U._WINDOW-HANDLE = _h_win
                     AND   x_U._DBNAME = "Temp-Tables":U
                     AND   x_U._TABLE  = cBuffer
                     AND   x_U._NAME   = cName NO-ERROR.
            IF AVAIL X_U THEN
              x_U._ENABLE = NO.
         
          END. /* IF LOOKUP(cField,gcEnableFields) = 0 THEN */
        END.
        
        /* Delete the temporary file */
        OS-DELETE VALUE(ctmp) NO-ERROR.
      END.  /* if drawn */
    END.  /* else do - static viewer */
    shutdown-sdo(TARGET-PROCEDURE).
    /* set the file-saved state to false */
    IF drawn THEN 
      RUN adeuib/_winsave.p (_h_win, FALSE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

