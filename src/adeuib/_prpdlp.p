&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File:              adeuib/_prpdlp.p

  Description:       Data logic procedure property sheet

  Input Parameters:  INPUT h_self as HANDLE (_U of data logic procedure) 
      

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER h_self AS HANDLE     NO-UNDO.

/* Local Variable Definitions ---                                       */

{adeuib/uibhlp.i}
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adecomm/icondir.i}
{src/adm2/globals.i}
{destdefi.i}

DEFINE VARIABLE glUpdateDefs AS LOGICAL  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnSDO cSDO cBufferSuffix cTableName ~
cInclude lUseNOUNDO Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS cSDO cBufferSuffix cTableName cInclude ~
lUseNOUNDO 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenObjectFilter Dialog-Frame 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSDO 
     LABEL "" 
     CONTEXT-HELP-ID 0
     SIZE 5 BY 1.14.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE cBufferSuffix AS CHARACTER FORMAT "X(28)":U 
     LABEL "Buffer suffix" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 TOOLTIP "Suffix for data logic procedure buffer (c_ and old_ preceed buffer name)" NO-UNDO.

DEFINE VARIABLE cInclude AS CHARACTER FORMAT "X(50)":U 
     LABEL "SDO include file" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 TOOLTIP "Data logic procedure include file name" NO-UNDO.

DEFINE VARIABLE cSDO AS CHARACTER FORMAT "X(28)":U 
     LABEL "SmartDataObject" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 67 BY 1 TOOLTIP "SmartDataObject used to default property values" NO-UNDO.

DEFINE VARIABLE cTableName AS CHARACTER FORMAT "X(50)":U 
     LABEL "Table name buffer" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 73 BY 1 TOOLTIP "Table name buffer, used when buffer suffix is truncated to 28 characters" NO-UNDO.

DEFINE VARIABLE lUseNOUNDO AS LOGICAL INITIAL no 
     LABEL "Use NO-UNDO for RowObject" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .81 TOOLTIP "Option to specify whether NO-UNDO is used for RowObject temp table definition" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     btnSDO AT ROW 1 COL 88.8
     cSDO AT ROW 1.1 COL 19 COLON-ALIGNED
     cBufferSuffix AT ROW 2.19 COL 19 COLON-ALIGNED
     cTableName AT ROW 3.24 COL 19 COLON-ALIGNED
     cInclude AT ROW 4.33 COL 19 COLON-ALIGNED
     lUseNOUNDO AT ROW 5.43 COL 21
     Btn_OK AT ROW 6.67 COL 4
     Btn_Cancel AT ROW 6.67 COL 20
     Btn_Help AT ROW 6.67 COL 78.4
     SPACE(4.39) SKIP(0.42)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Property Sheet"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON HELP OF FRAME Dialog-Frame /* Property Sheet */
ANYWHERE DO:
   APPLY "CHOOSE":U TO Btn_Help.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Property Sheet */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSDO Dialog-Frame
ON CHOOSE OF btnSDO IN FRAME Dialog-Frame
DO:
  RUN lookupSDO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
DO: 
  IF _DynamicsIsRunning THEN
    RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&DLProc_Property_Sheet_Dynamics}, ?).
  ELSE 
    RUN adecomm/_adehelp.p( "AB", "CONTEXT", {&DLProc_Property_Sheet_ADE}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cSDO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cSDO Dialog-Frame
ON LEAVE OF cSDO IN FRAME Dialog-Frame /* SmartDataObject */
DO:
  RUN getSDOValues.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initializeValues.
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN updateValues.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cSDO cBufferSuffix cTableName cInclude lUseNOUNDO 
      WITH FRAME Dialog-Frame.
  ENABLE btnSDO cSDO cBufferSuffix cTableName cInclude lUseNOUNDO Btn_OK 
         Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSDOValues Dialog-Frame 
PROCEDURE getSDOValues :
/*------------------------------------------------------------------------------
  Purpose:     Get values from the running SDO or repository manager to set
               default property values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPhysicalTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDynamic       AS LOGICAL    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    hSDO = DYNAMIC-FUNCTION('get-proc-hdl':U IN _h_func_lib, INPUT cSDO:SCREEN-VALUE).
    IF VALID-HANDLE(hSDO) THEN
    DO:
      cPhysicalTable = ENTRY(1,DYNAMIC-FUNCTION('getPhysicalTables':U IN hSDO)).
      IF LENGTH(cPhysicalTable) > 28 THEN
        ASSIGN 
          cTableName:SCREEN-VALUE = cPhysicalTable
          cBufferSuffix:SCREEN-VALUE = SUBSTRING(cPhysicalTable,1,28).
      ELSE ASSIGN cBufferSuffix:SCREEN-VALUE = cPhysicalTable.
      IF DYNAMIC-FUNCTION('getLargeColumns':U IN hSDO) > '':U THEN
        ASSIGN 
          lUseNOUNDO:SCREEN-VALUE = 'yes':U
          lUseNOUNDO:SENSITIVE    = FALSE.

      IF _DynamicsIsRunning THEN
      DO:
        hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
        /* Retrieve the objects for the specified object  */
        IF VALID-HANDLE(hRepDesManager) THEN
        DO:
          RUN retrieveDesignObject IN hRepDesManager ( INPUT  cSDO:SCREEN-VALUE,
                                                       INPUT  "",  /* Get default result Code */
                                                       OUTPUT TABLE ttObject ,
                                                       OUTPUT TABLE ttPage,
                                                       OUTPUT TABLE ttLink,
                                                       OUTPUT TABLE ttUiEvent,
                                                       OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
          FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cSDO:SCREEN-VALUE 
                                AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
         IF AVAIL ttObject THEN
          DO:
            lDynamic = DYNAMIC-FUNCTION("classisA":U IN gshRepositoryManager, ttObject.tClassName, "DynSDO":U).
          END.  /* if avail ttObject */
        END.  /* valid repository design manager */
        IF lDynamic AND VALID-HANDLE(gshRepositoryManager) THEN 
          cInclude:SCREEN-VALUE = DYNAMIC-FUNCTION('getSDOIncludeFile':U IN gshRepositoryManager,
                                                   INPUT cSDO:SCREEN-VALUE) + '.i':U.
        ELSE cInclude:SCREEN-VALUE = TRIM(DYNAMIC-FUNCTION('getDataFieldDefs':U IN hSDO), '"':U).
      END.  /* if Dynamics is running */
      ELSE cInclude:SCREEN-VALUE = TRIM(DYNAMIC-FUNCTION('getDataFieldDefs':U IN hSDO), '"':U).
      DYNAMIC-FUNCTION('shutdown-proc':U IN _h_func_lib, INPUT cSDO:SCREEN-VALUE).
        
    END.  /* if valid SDO */
    ELSE DO:
      MESSAGE 'The SmartDataObject is not valid and could not be run to retrieve default property values. '
          VIEW-AS ALERT-BOX ERROR.
    END.  /* else do */
  END.  /* do with frame */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeValues Dialog-Frame 
PROCEDURE initializeValues :
/*------------------------------------------------------------------------------
  Purpose:     Sets property sheet values from _C data
  Parameters:  <none>
  Notes:       Attempts to find preprocessor definitions in the Definitions
               section of the file to support old data logic procedures
               that have these preprocessors defined in the Custom 
               Definitions section.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDefCode         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLine            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPreprocessList  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iEnd             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPreprocessNum   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iStart           AS INTEGER    NO-UNDO.
DEFINE VARIABLE rID              AS RECID      NO-UNDO.

  cPreprocessList = "DATA-LOGIC-TABLE,TABLE-NAME,DATA-FIELD-DEFS":U.
  RUN adeuib/_accsect.p("GET":U, ?, "DEFINITIONS":U, INPUT-OUTPUT rID, INPUT-OUTPUT cDefCode).
  DO iPreprocessNum = 1 TO NUM-ENTRIES(cPreprocessList):
    ASSIGN 
      iStart = 0  
      iEnd   = 0
      cLine  = "":U
      iStart = INDEX(cDefCode,"&GLOB ":U + ENTRY(iPreprocessNum,cPreprocessList))
      iStart = IF iStart = 0
               THEN INDEX(cDefCode,"&GLOBAL-DEFINE ":U + ENTRY(iPreprocessNum,cPreprocessList))
               ELSE iStart
      iEnd   = IF iStart > 0 
                    THEN INDEX(cDefCode,CHR(10), iStart)
                    ELSE 0
      cLine  = IF iStart > 0 AND iEnd > 0 
                    THEN SUBSTRING(cDefCode, iStart, iEnd - iStart)
                    ELSE "":U
                        NO-ERROR.
    IF cLine > "":U THEN
    DO:
      glUpdateDefs = TRUE.
      CASE ENTRY(iPreprocessNum,cPreprocessList):
        WHEN "DATA-LOGIC-TABLE":U THEN
          ASSIGN cBufferSuffix = TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U))).
        WHEN "TABLE-NAME":U THEN
          ASSIGN cTableName = TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U))).
        WHEN "DATA-FIELD-DEFS":U THEN
          ASSIGN cInclude = TRIM(TRIM(SUBSTRING(cLine,R-INDEX(cline," ":U))),'"').
      END CASE.
    END.  /* if cLine > "" */
  END.   /* do iPreprocessNum */
 
  DO WITH FRAME {&FRAME-NAME}:
    IF _DynamicsIsRunning THEN
      btnSDO:HANDLE:LOAD-IMAGE("ry/img/afbinos.gif":U) NO-ERROR.
    ELSE
      btnSDO:handle:LOAD-IMAGE-UP({&ADEICON-DIR} + "open":U) NO-ERROR. 

    FIND _U WHERE _U._HANDLE = h_self.
    FIND _C WHERE RECID(_C) = _U._x-recid.

    ASSIGN 
      lUseNOUNDO    = _C._RowObject-NO-UNDO
      cBufferSuffix = _C._DATA-LOGIC-PROC-BUFF-SUFFIX WHEN cBufferSuffix = "":U
      cTableName    = _C._DATA-LOGIC-PROC-TABLE-BUFF WHEN cTableName = "":U
      cInclude      = _C._DATA-LOGIC-PROC-INCLUDE WHEN cInclude = "":U.
  END.  /* do with frame */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupSDO Dialog-Frame 
PROCEDURE lookupSDO :
/*------------------------------------------------------------------------------
  Purpose:     Allows the user to select an SDO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCalcError        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFile         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcFullPath     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcObject       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRelativePath AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRelPathSCM   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCalcRootDir      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFileName         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPathedFileName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesManager    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lok               AS LOGICAL    NO-UNDO.

  ASSIGN CURRENT-WINDOW:PRIVATE-DATA = STRING(THIS-PROCEDURE).
  IF _DynamicsIsRunning THEN
  DO:
    RUN adecomm/_setcurs.p ("WAIT":U).
    RUN ry/obj/gopendialog.w (INPUT CURRENT-WINDOW,
                              INPUT "",
                              INPUT No,
                              INPUT "Get Object",
                              OUTPUT cFilename,
                              OUTPUT lok).
    RUN adecomm/_setcurs.p ("":U).
    IF lok THEN
    DO:
      cSDO:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFileName.
      RUN getSDOValues.
    END.  /* if lok */
  END.  /* if dynamics is running */
  ELSE DO:
    ASSIGN cFileName = TRIM(cSDO:SCREEN-VALUE).

    RUN adecomm/_opnfile.w 
                ("Choose a SmartDataObject",
                 "SmartDataObject Files (*.w), All Files (*.*)",
                 INPUT-OUTPUT cFileName).

    IF cFileName <> "":U THEN
    DO:
      ASSIGN cSDO:SCREEN-VALUE = REPLACE(cFileName,"~\","/").
      RUN getSDOValues.
    END.  /* if cFileName not blank */
  END.  /* else do - dynamics is not running */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateValues Dialog-Frame 
PROCEDURE updateValues :
/*------------------------------------------------------------------------------
  Purpose:     Updates _C values from property sheet
  Parameters:  <none>
  Notes:       Removes preprocessors from Defintions section of file (where
               they exist for old data logic procedures), they 
               will be generated in the Preprocessor Definitions section instead
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDefCode        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPreprocessList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iEnd            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPreprocessNum  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iStart          AS INTEGER    NO-UNDO.
DEFINE VARIABLE rID             AS RECID      NO-UNDO.

  FIND _U WHERE _U._HANDLE = h_self.
  FIND _C WHERE RECID(_C) = _U._x-recid.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lUseNOUNDO
      cBufferSuffix
      cTableName
      cInclude
      _C._RowObject-NO-UNDO           = lUseNOUNDO
      _C._DATA-LOGIC-PROC-BUFF-SUFFIX = cBufferSuffix
      _C._DATA-LOGIC-PROC-TABLE-BUFF  = cTableName
      _C._DATA-LOGIC-PROC-INCLUDE     = cInclude.
  END.  /* do with frame */

  IF glUpdateDefs THEN
  DO:
    cPreprocessList = "DATA-LOGIC-TABLE,TABLE-NAME,DATA-FIELD-DEFS":U.
    RUN adeuib/_accsect.p("GET":U, ?, "DEFINITIONS":U, INPUT-OUTPUT rID, INPUT-OUTPUT cDefCode).
    DO iPreprocessNum = 1 TO NUM-ENTRIES(cPreprocessList):
      ASSIGN
        iStart = 0
        iEnd   = 0
        iStart = INDEX(cDefCode,"&GLOB ":U + ENTRY(iPreprocessNum,cPreprocessList))
        iStart = IF iStart = 0
                 THEN INDEX(cDefCode,"&GLOBAL-DEFINE ":U + ENTRY(iPreprocessNum,cPreprocessList))
                 ELSE iStart
        iEnd   = IF iStart > 0 
                 THEN INDEX(cDefCode,CHR(10), iStart)
                 ELSE 0.
      
      IF iStart > 0 THEN
        ASSIGN 
          cDefCode = SUBSTRING(cDefCode,1, iStart - 1) +
                     IF iEnd < LENGTH(cDefCode) 
                     THEN SUBSTRING(cDefcode, iEnd)
                     ELSE "".
    END.  /* do iPreprocessNum */
    ASSIGN 
      iStart = 0
      iEnd   = 0
      iStart = INDEX(cDefCode,"/* Data Preprocessor Definitions":U)
      iEnd   = IF iStart > 0
               THEN INDEX(cDefCode,CHR(10), iStart)
               ELSE 0.
    IF iStart > 0 THEN
      ASSIGN 
        cDefCode = SUBSTRING(cDefCode,1, iStart - 1) +
                   IF iEnd < LENGTH(cDefCode) 
                   THEN SUBSTRING(cDefcode, iEnd)
                   ELSE "".
    RUN adeuib/_accsect.p (INPUT "SET":U,
                           INPUT ?,
                           INPUT 'DEFINITIONS':U,
                           INPUT-OUTPUT rID,
                           INPUT-OUTPUT cDefCode).
  END.  /* if glUpdateDefs */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenObjectFilter Dialog-Frame 
FUNCTION getOpenObjectFilter RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Required by ry/obj/gopendialog.w invoked in lookupSDO
    Notes:  
------------------------------------------------------------------------------*/

  IF _DynamicsIsRunning AND VALID-HANDLE(gshRepositoryManager) THEN
  DO:
    RETURN 
      REPLACE(DYNAMIC-FUNCTION('getClassChildrenFromDB':U IN gshRepositoryManager,
                               INPUT 'Data':U), CHR(3),',':U).
  END.
  ELSE RETURN '':U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

