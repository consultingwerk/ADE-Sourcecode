&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*---------------------------------------------------------------------------------
  File: inuiutilp.p

  Description:  Install UI Utility Procedure

  Purpose:      Contains functions and routines that are used by the install UI screen

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   11/14/2001  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       inuiutilp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* Global variables belonging to ICF */
{afglobals.i}

/* Replace control character function call */
{afxmlreplctrl.i}

/* ttNode table and manipulation include */
{afttnode.i}

DEFINE VARIABLE giRecNo       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghCurrPage    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcPageName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCurrFrame   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSourceProc  AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcWindowTitle AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghAPIProc     AS HANDLE     NO-UNDO.

DEFINE TEMP-TABLE ttPage NO-UNDO
  FIELD iPageNo         AS INTEGER
  FIELD cPageName       AS CHARACTER
  FIELD cPageGroup      AS CHARACTER
  FIELD cPageTitle      AS CHARACTER
  FIELD cPageProc       AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iPageNo
  INDEX udxPageName IS UNIQUE
    cPageName
  INDEX udxGrpPage  IS UNIQUE
    cPageGroup
    iPageNo
  .

DEFINE TEMP-TABLE ttButton NO-UNDO
  FIELD iButtonNo       AS INTEGER
  FIELD iPageNo         AS INTEGER
  FIELD cButtonLabel    AS CHARACTER
  FIELD cButtonName     AS CHARACTER
  FIELD cButtonJustify  AS CHARACTER
  FIELD cDefault        AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iButtonNo
  INDEX udxPage IS UNIQUE
    iPageNo
    cButtonJustify
    iButtonNo
  INDEX udxName IS UNIQUE
    iPageNo
    cButtonName
  .

DEFINE TEMP-TABLE ttField NO-UNDO
  FIELD iFieldNo        AS INTEGER
  FIELD iPageNo         AS INTEGER
  FIELD cFieldName      AS CHARACTER
  FIELD cDataType       AS CHARACTER
  FIELD cExpandTokens   AS CHARACTER
  FIELD cFieldValue     AS CHARACTER
  FIELD cFieldLabel     AS CHARACTER 
  FIELD cTableVariable  AS CHARACTER
  FIELD cDefaultValue   AS CHARACTER
  FIELD cStoreTo        AS CHARACTER
  FIELD cHidden         AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iFieldNo
  INDEX udxPage IS UNIQUE
    iPageNo
    iFieldNo
  INDEX dxPageVar
    iPageNo
    cTableVariable
  .

DEFINE TEMP-TABLE ttValue NO-UNDO
  FIELD cGroup         AS CHARACTER
  FIELD cVariable      AS CHARACTER
  FIELD cValue         AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    cGroup
    cVariable
  .

DEFINE TEMP-TABLE ttAction NO-UNDO
  FIELD iActionNo       AS INTEGER
  FIELD iPageNo         AS INTEGER
  FIELD cEvent          AS CHARACTER
  FIELD cObjectType     AS CHARACTER
  FIELD cObject         AS CHARACTER
  FIELD cAction         AS CHARACTER
  FIELD cActionParam    AS CHARACTER
  FIELD cActionTarget   AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    iActionNo
  INDEX dxPage 
    iPageNo
    cEvent
    cObject
    iActionNo
  .

DEFINE TEMP-TABLE ttWidget NO-UNDO
  FIELD cWidgetName AS CHARACTER
  FIELD hHandle     AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    cWidgetName
  .


/* List of services  */
DEFINE TEMP-TABLE ttService NO-UNDO 
  FIELD cServiceName     AS CHARACTER 
  FIELD cPhysicalService AS CHARACTER 
  FIELD cServiceType     AS CHARACTER 
  FIELD cConnectParams   AS CHARACTER 
  FIELD lDefaultService  AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cServiceName
  .

/* The remainder of this section contains constants used for the MessageBoxA
   Windows API call. */

&SCOPED-DEFINE MB_OK                       0
&SCOPED-DEFINE MB_OKCANCEL                 1
&SCOPED-DEFINE MB_ABORTRETRYIGNORE         2
&SCOPED-DEFINE MB_YESNOCANCEL              3
&SCOPED-DEFINE MB_YESNO                    4
&SCOPED-DEFINE MB_RETRYCANCEL              5


&SCOPED-DEFINE MB_ICONHAND                 16
&SCOPED-DEFINE MB_ICONQUESTION             32
&SCOPED-DEFINE MB_ICONEXCLAMATION          48
&SCOPED-DEFINE MB_ICONASTERISK             64

&SCOPED-DEFINE MB_USERICON                 128
&SCOPED-DEFINE MB_ICONWARNING              {&MB_ICONEXCLAMATION}
&SCOPED-DEFINE MB_ICONERROR                {&MB_ICONHAND}

&SCOPED-DEFINE MB_ICONINFORMATION          {&MB_ICONASTERISK}
&SCOPED-DEFINE MB_ICONSTOP                 {&MB_ICONHAND}

&SCOPED-DEFINE MB_DEFBUTTON1               0
&SCOPED-DEFINE MB_DEFBUTTON2               256
&SCOPED-DEFINE MB_DEFBUTTON3               512  
&SCOPED-DEFINE MB_DEFBUTTON4               768

&SCOPED-DEFINE MB_APPLMODAL                0
&SCOPED-DEFINE MB_SYSTEMMODAL              4096
&SCOPED-DEFINE MB_TASKMODAL                8192
&SCOPED-DEFINE MB_HELP                     16384 

&SCOPED-DEFINE MB_NOFOCUS                  32768
&SCOPED-DEFINE MB_SETFOREGROUND            65536
&SCOPED-DEFINE MB_DEFAULT_DESKTOP_ONLY     131072

&SCOPED-DEFINE MB_TOPMOST                  262144
&SCOPED-DEFINE MB_RIGHT                    524288
&SCOPED-DEFINE MB_RTLREADING               1048576


&SCOPED-DEFINE MB_TYPEMASK                 15
&SCOPED-DEFINE MB_ICONMASK                 240
&SCOPED-DEFINE MB_DEFMASK                  3840
&SCOPED-DEFINE MB_MODEMASK                 12288
&SCOPED-DEFINE MB_MISCMASK                 49152


&SCOPED-DEFINE IDOK                        1
&SCOPED-DEFINE IDCANCEL                    2
&SCOPED-DEFINE IDABORT                     3
&SCOPED-DEFINE IDRETRY                     4
&SCOPED-DEFINE IDIGNORE                    5
&SCOPED-DEFINE IDYES                       6
&SCOPED-DEFINE IDNO                        7
&SCOPED-DEFINE IDCLOSE                     8
&SCOPED-DEFINE IDHELP                      9

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-analyzeCase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD analyzeCase Procedure 
FUNCTION analyzeCase RETURNS CHARACTER
  (INPUT pcCaseStatement AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-analyzeIf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD analyzeIf Procedure 
FUNCTION analyzeIf RETURNS CHARACTER
  (INPUT pcIfStatement AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateExpression Procedure 
FUNCTION evaluateExpression RETURNS LOGICAL
  ( INPUT pcExpression AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expandTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD expandTokens Procedure 
FUNCTION expandTokens RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandablePropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExpandablePropertyValue Procedure 
FUNCTION getExpandablePropertyValue RETURNS CHARACTER
  ( INPUT pcProperty AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  (INPUT pcGroup    AS CHARACTER,
   INPUT pcVariable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperandValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOperandValue Procedure 
FUNCTION getOperandValue RETURNS CHARACTER
  ( INPUT pcOperand AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidgetHandle Procedure 
FUNCTION getWidgetHandle RETURNS HANDLE
  ( INPUT pcWidget AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-messageBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD messageBox Procedure 
FUNCTION messageBox RETURNS INTEGER
  ( INPUT pcMessage AS CHARACTER,
    INPUT pcTokens  AS CHARACTER,
    INPUT pcStyle   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL
  ( INPUT pcRecordType AS CHARACTER,
    INPUT piStackLevel AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeRecord Procedure 
FUNCTION writeRecord RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT piStackLevel AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
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
         HEIGHT             = 26.33
         WIDTH              = 56.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

PROCEDURE MessageBoxA EXTERNAL "user32":
  DEFINE RETURN PARAMETER iValue AS LONG.
  DEFINE INPUT PARAMETER hWin AS LONG.
  DEFINE INPUT PARAMETER lpText AS CHARACTER.
  DEFINE INPUT PARAMETER lpCaption AS CHARACTER.
  DEFINE INPUT PARAMETER uType AS LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-btnChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE btnChoose Procedure 
PROCEDURE btnChoose :
/*------------------------------------------------------------------------------
  Purpose:     Choose trigger for button.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN eventProc ("CHOOSE":U,SELF:NAME).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkForDBs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkForDBs Procedure 
PROCEDURE checkForDBs :
/*------------------------------------------------------------------------------
  Purpose:     Checks to see if the databases exist and if they do, sets
               appropriate properties.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER cInput  AS CHARACTER  NO-UNDO. /* Not used */

  DEFINE VARIABLE cSetup       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDB          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.

  /* dbs_to_setup should contain a list of all the databases that will
     be setup during this installation */
  cDBList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                             "dbs_to_setup":U).

  /* If the database list is blank, there's nothing we can do */
  IF cDBList = "":U OR 
     cDBList = ? THEN
    RETURN.

  /* Loop through the database list and check to see if the database already
     exists on disk */
  DO iCount = 1 TO NUM-ENTRIES(cDBList):
    cDB = ENTRY(iCount,cDBList).
    cDBPath = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               "path_db_":U + cDB).
    
    IF cDBPath <> "":U AND
       cDBPath <> ? AND
       SEARCH(cDBPath) <> ? THEN
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cDB + "_does_not_exist":U,
                       "NO":U).
    ELSE
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cDB + "_does_not_exist":U,
                       "YES":U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeFrame Procedure 
PROCEDURE closeFrame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN disable_UI IN ghCurrPage.
  DELETE PROCEDURE ghCurrPage.
  ghCurrPage = ?.

  DELETE WIDGET-POOL gcPageName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createButtons Procedure 
PROCEDURE createButtons :
/*------------------------------------------------------------------------------
  Purpose:     Creates all the buttons and associates them with the frame.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piPageNo AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER phFrame  AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iLeft        AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iRight       AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iCenter      AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iStartLeft   AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iStartRight  AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iStartCenter AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iBtnWidth    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE hButton      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iBtnPos      AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttButton FOR ttButton.

  CREATE WIDGET-POOL gcPageName PERSISTENT.

  FOR EACH bttButton 
    WHERE bttButton.iPageNo = piPageNo
    BY bttButton.iPageNo
    BY bttButton.cButtonJustify
    BY bttButton.iButtonNo:
    CASE bttButton.cButtonJustify:
      WHEN "A":U THEN
          iLeft = iLeft + 1.
      WHEN "B":U THEN
          iCenter = iCenter + 1.
      WHEN "C":U THEN
          iRight = iRight + 1.
    END CASE.
  END.

  iBtnWidth = MIN(530 / (iLeft + iCenter + iRight), 81) - 6.
  iStartLeft = 9.
  iStartRight = 537 - ((iBtnWidth + 6)* iRight).
  iStartCenter = (537  - ((iBtnWidth + 6)* iCenter)) / 2.

  IF (iStartCenter + ((iBtnWidth + 6)* iCenter)) > iStartRight - 6 THEN
    iStartCenter = iStartRight - (iStartCenter + ((iBtnWidth + 6)* iCenter)) - 6.

  FOR EACH bttButton 
    WHERE bttButton.iPageNo = piPageNo
    BY bttButton.iPageNo
    BY bttButton.cButtonJustify
    BY bttButton.iButtonNo:
    CASE bttButton.cButtonJustify:
      WHEN "A":U THEN
        ASSIGN
          iBtnPos = iStartLeft
          iStartLeft = iStartLeft + iBtnWidth + 6
        .
      WHEN "B":U THEN
        ASSIGN
          iBtnPos = iStartCenter
          iStartCenter = iStartCenter + iBtnWidth + 6
        .
      WHEN "C":U THEN
        ASSIGN
          iBtnPos = iStartRight
          iStartRight = iStartRight + iBtnWidth + 6
        .
    END CASE.

    CREATE BUTTON hButton IN WIDGET-POOL gcPageName
      ASSIGN
/*        DEFAULT       = bttButton.cDefault = "YES":U
        AUTO-GO       = bttButton.cDefault = "YES":U */
        NAME          = bttButton.cButtonName
        LABEL         = bttButton.cButtonLabel
        X             = iBtnPos
        Y             = 332
        WIDTH-PIXELS  = iBtnWidth
        HEIGHT-PIXELS = 24
        FRAME         = phFrame
        SENSITIVE     = TRUE
        VISIBLE       = TRUE
        HIDDEN        = FALSE
        TRIGGERS:
          ON CHOOSE
            PERSISTENT RUN btnChoose IN THIS-PROCEDURE.
        END TRIGGERS.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-eventProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eventProc Procedure 
PROCEDURE eventProc :
/*------------------------------------------------------------------------------
  Purpose:     This procedure handles events for objects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEvent  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObject AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hProc        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLastWidget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLastWidget  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSkipButtons AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttAction FOR ttAction.
  DEFINE BUFFER bttPage   FOR ttPage.


  /* Deal with moving to a button that will cause a close or a quit */
  IF LAST-EVENT:FUNCTION = "WINDOW-CLOSE":U THEN
    RETURN.

  ASSIGN
    hLastWidget = LAST-EVENT:WIDGET-ENTER
  .

  IF VALID-HANDLE(hLastWidget) AND
     hLastWidget:TYPE = "BUTTON":U THEN
  DO:
    cSkipButtons = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "skip_buttons":U).
    ASSIGN
      cLastWidget = hLastWidget:LABEL
      cLastWidget = REPLACE(cLastWidget,"&","")
    .

    IF CAN-DO(cSkipButtons,cLastWidget) THEN
      RETURN.
  END.


  FIND FIRST bttPage
    WHERE bttPage.cPageName = gcPageName.

  FOR EACH bttAction 
     WHERE bttAction.iPageNo = bttPage.iPageNo
       AND bttAction.cEvent  = pcEvent
       AND bttAction.cObject = pcObject
     BY bttAction.iPageNo
     BY bttAction.cEvent
     BY bttAction.cObject
     BY bttAction.iActionNo:
  
    CASE bttAction.cAction:
      WHEN "QUIT":U THEN
      DO:
        iRetVal = messageBox("MSG_confirm_quit":U, 
                             "":U,
                             "MB_YESNO,MB_ICONQUESTION,MB_TASKMODAL":U).
        IF iRetVal = {&IDYES} THEN
          QUIT.
        ELSE
          RETURN.
      END.
      WHEN "FINISH":U THEN
        QUIT.
      OTHERWISE
      DO:
        CASE bttAction.cActionTarget:
          WHEN "CONTAINER":U THEN
            hProc = ghSourceProc.
          WHEN "FRAME":U THEN
            hProc = ghCurrPage.
          WHEN "API":U THEN
            hProc = ghAPIProc.
          OTHERWISE
            hProc = THIS-PROCEDURE.
        END CASE.
        RUN VALUE(bttAction.cAction) IN hProc
          (INPUT bttAction.cActionParam) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
      END.
  
    END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDBFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDBFile Procedure 
PROCEDURE getDBFile :
/*------------------------------------------------------------------------------
  Purpose:     Calls SYSTEM-DIALOG GET-FILE to find a database file name.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcControl AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns      AS LOGICAL    NO-UNDO.
  hField = getWidgetHandle(pcControl).

  IF VALID-HANDLE(hField) THEN
  DO:
    cFileName = hField:SCREEN-VALUE.
    SYSTEM-DIALOG GET-FILE cFileName  
      FILTERS "Databases (*.db)" "*.db":U,
              "All Files (*.*)" "*.*":U
      CREATE-TEST-FILE 
      DEFAULT-EXTENSION "*.db":U
      RETURN-TO-START-DIR
      TITLE "Select Database"
      USE-FILENAME
      UPDATE lAns
      IN WINDOW CURRENT-WINDOW.
    IF lAns THEN
      hField:SCREEN-VALUE = cFileName.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDirectory Procedure 
PROCEDURE getDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Calls the Microsoft standard dialog to prompt for a directory.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPathField AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lhServer AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lhParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTitle   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hWidget = getWidgetHandle(pcPathField).
  hFrame = ghParentFrame.
  hWin   = hFrame:WINDOW.

  cTitle = hWidget:LABEL.
  
  CREATE 'Shell.Application' lhServer.
  
  ASSIGN
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,cTitle,0).
  
  IF VALID-HANDLE(lhFolder) = True 
  THEN DO:
      ASSIGN 
          lvFolder = lhFolder:Title
          lhParent = lhFolder:ParentFolder
          lvCount  = 0.
      REPEAT:
          IF lvCount >= lhParent:Items:Count THEN
              DO:
                  ASSIGN
                      cPath = "":U.
                  LEAVE.
              END.
          ELSE
              IF lhParent:Items:Item(lvCount):Name = lvFolder THEN
                  DO:
                      ASSIGN
                          cPath = lhParent:Items:Item(lvCount):Path.
                      LEAVE.
                  END.
          ASSIGN lvCount = lvCount + 1.
      END.
  END.
  ELSE
      ASSIGN
          cPath = "":U.
  
  RELEASE OBJECT lhParent NO-ERROR.
  RELEASE OBJECT lhFolder NO-ERROR.
  RELEASE OBJECT lhServer NO-ERROR.
  
  ASSIGN
    lhParent = ?
    lhFolder = ?
    lhServer = ?
    .
  
  IF cPath <> "":U AND
     cPath <> ? THEN
    ASSIGN 
      cPath = TRIM(cPath)
      hWidget:SCREEN-VALUE = cPath
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-gotoPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gotoPage Procedure 
PROCEDURE gotoPage :
/*------------------------------------------------------------------------------
  Purpose:     Changes the current page.
               
  Parameters:  
    pcPageName - May be one of:
               1) a simple page name.
               A simple page name is just the name of the page in the XML file 
               that must be shown.
               
               2) an if expression.
               An IF expression starts with a ? and is followed by the 
               expression to evaluate. && and :: can be used as AND and OR
               operators respectively. The portion after the first semicolon
               represents the THEN and the portion after the second semicolon
               represents the ELSE. If statements may not be nested.
               e.g. 
               ?createDBs=YES;page1;page2 
               "If the value of the createDBs property is YES then show page1 
                else show page2"
                
               ?createDBs=YES&&createRVDB=NO;page4;page3
               "If the value of createDBs is YES and createRVDB is NO then show
                page4 else show page 3"
               
               3) a case expression.
               A CASE expression starts with a colon and the name of the 
               property to evaluate. The cases are all enumerated on a value
               by value basis and if a match is found, only that match is
               used.
               e.g.
               :session_date_format:dmy|page1:mdy|page2:ymd|page3:default|page9
               Check the session_date_format property.
               If the value is dmy, show page1
               If the value is mdy, show page2
               If the value is ymd, show page3
               If none of the conditions are met, show page 9. 
            
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPageName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPage              AS CHARACTER  NO-UNDO.

  /* We need to figure out which of the expressions has come in here. */

  CASE SUBSTRING(pcPageName,1,1):
    WHEN ":":U THEN
      cPage = analyzeCase(pcPageName).
    WHEN "?":U THEN
      cPage = analyzeIf(pcPageName).
    OTHERWISE
      cPage = pcPageName.
  END CASE.

  /* Now initialize the page */
  RUN initializePage(cPage).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeInstall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeInstall Procedure 
PROCEDURE initializeInstall :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the install itility procedure.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSourceProc AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phFrame      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cInstallDir          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWorkDir             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBDir               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStrip               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString              AS CHARACTER  NO-UNDO.

  /* Set the handle to the source procedure and parent frame */
  ghSourceProc = phSourceProc.
  ghParentFrame = phFrame.
  
  /* Read the registry key list and it's values */
  RUN obtainRegistryKeys.

  /* Expand the properties that you can. */
  RUN propertyExpander.

  /* Set up the Window title for the window */
  gcWindowTitle = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "window_title":U).
  IF gcWindowTitle = ? OR
     gcWindowTitle = "":U THEN
    gcWindowTitle = "Dynamics Configuration Utility":U.


  RUN install/prc/indcuapip.p PERSISTENT SET ghAPIProc.

  DYNAMIC-FUNCTION("setUIUtilHandle":U IN ghAPIProc,
                   THIS-PROCEDURE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializePage Procedure 
PROCEDURE initializePage :
/*------------------------------------------------------------------------------
  Purpose:     Initializes a frame page.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcPageName    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE hChild AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin   AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttPage FOR ttPage.

  /* Find the page by name */
  FIND bttPage NO-LOCK
    WHERE bttPage.cPageName = pcPageName
    NO-ERROR.

  IF AVAILABLE(bttPage) THEN
  DO:
    IF ghCurrPage <> ? THEN 
      APPLY "CLOSE":U TO ghCurrPage. /* Apply close to the current frame */
    
    /* Run the page's procedure */
    RUN VALUE(bttPage.cPageProc) PERSISTENT SET ghCurrPage.
    ghCurrPage:ADD-SUPER-PROCEDURE(THIS-PROCEDURE).
    gcPageName = bttPage.cPageName.

    /* Get the frame's handle */
    RUN getFrameHandle IN ghCurrPage
      (OUTPUT ghCurrFrame) .

    /* Set the window title */
    hWin = ghParentFrame:WINDOW.
    hWin:TITLE = gcWindowTitle + (IF bttPage.cPageTitle = "":U THEN "":U ELSE " - ":U + bttPage.cPageTitle).

    RUN initializePageObject IN ghCurrPage (bttPage.iPageNo).

  END. /* IF AVAILABLE(ttPage) */
  ELSE
    MESSAGE "Page " + pcPageName + " not defined in ICFSETUP.XML file "
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializePageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializePageObject Procedure 
PROCEDURE initializePageObject :
/*------------------------------------------------------------------------------
  Purpose:     Does the standare behavior for initializing the page
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER piPageNo   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hWin AS HANDLE     NO-UNDO.

  /* Put the frame in the right place on the screen */
  ghCurrFrame:HIDDEN = TRUE.
  ghCurrFrame:FRAME = ghParentFrame.
  ghCurrFrame:X = 145.
  ghCurrFrame:Y = 9.
  ghCurrFrame:HIDDEN = FALSE.

  /* Run enable_UI */
  RUN enable_UI IN ghCurrPage.

  /* Create the buttons */
  RUN createButtons(piPageNo, ghParentFrame).

  /* Build the widget list */
  EMPTY TEMP-TABLE ttWidget.
  RUN loadWidgets (ghCurrFrame).

  RUN eventProc ("INITIALIZE":U, gcPageName).
  
  /* Load the values of the fields and their labels */
  RUN loadFieldValues(piPageNo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadFieldValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFieldValues Procedure 
PROCEDURE loadFieldValues :
/*------------------------------------------------------------------------------
  Purpose:     Loads any values that have been pre-set in the XML file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER piPageNo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttField  FOR ttField.

  FOR EACH bttField
    WHERE bttField.iPageNo = piPageNo:

    IF bttField.cFieldValue <> "":U AND
       bttField.cFieldValue <> ? THEN
      cValue = bttField.cFieldValue.
    ELSE
    DO:
      cValue = bttField.cDefaultValue.
      IF bttField.cExpandTokens = "YES":U THEN
        cValue = expandTokens(cValue).
    END.
         
    hWidget = getWidgetHandle(bttField.cFieldName).

    IF VALID-HANDLE(hWidget) THEN
    DO:
      IF CAN-SET(hWidget,"HIDDEN":U) AND
         bttField.cHidden = "YES":U THEN
      DO:
        hWidget:HIDDEN = YES.
        hWidget:VISIBLE = NO.
        hWidget:SENSITIVE = NO.
      END.
      IF CAN-SET(hWidget,"LABEL":U) AND
         bttField.cFieldLabel <> "":U THEN
        hWidget:LABEL = bttField.cFieldLabel.

      IF cValue <> "":U AND
         cValue <> ? AND
         CAN-SET(hWidget,"SCREEN-VALUE":U) THEN
        hWidget:SCREEN-VALUE = cValue.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadSetupXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSetupXML Procedure 
PROCEDURE loadSetupXML :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the ICFSETUP.XML file for the pages and 
               and information that it needs to run the utility.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phXDoc  AS HANDLE   NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hRootNode     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hSetupNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER  NO-UNDO.

  /* Create two node references */
  CREATE X-NODEREF hRootNode.

  /* Set the root node */
  lSuccess = phXDoc:GET-DOCUMENT-ELEMENT(hRootNode).

  /* If we're not successful we have an invalid XML file */
  IF NOT lSuccess THEN
    RETURN "DCUSTARTUPERR: COULD NOT PARSE CONFIG FILE":U.

  CREATE X-NODEREF hSetupNode.
  
  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:
    /* Set the current Session Node */
    lSuccess = hRootNode:GET-CHILD(hSetupNode,iCount).

    IF NOT lSuccess THEN
      NEXT.

    /* If the session node is blank, skip it */
    IF hSetupNode:SUBTYPE = "TEXT":U AND
       hSetupNode:NODE-VALUE = CHR(10) THEN
      NEXT.
    /* If the name of this node is "Session" and the SessionType attribute matches the
       one(s) we need to retrieve, we'll process this node */  
    IF hSetupNode:NAME = "setup":U AND
       CAN-DO(hSetupNode:ATTRIBUTE-NAMES,"SetupType":U) AND
       (pcSessType = "":U OR
        hSetupNode:GET-ATTRIBUTE("SetupType":U) = pcSessType) THEN
    DO:
      
      EMPTY TEMP-TABLE ttNode.
      RUN recurseNodes(hSetupNode,hSetupNode:GET-ATTRIBUTE("SetupType":U)).
    END.
  END.
   
  /* Make sure that ttNode is empty */
  EMPTY TEMP-TABLE ttNode.
  

  /* Delete the objects */
  DELETE OBJECT hRootNode.
  hRootNode = ?.
  DELETE OBJECT hSetupNode.
  hSetupNode = ?.

  FOR EACH ttButton:
    CASE ttButton.cButtonJustify:
      WHEN "LEFT":U THEN
        ttButton.cButtonJustify = "A":U.
      WHEN "CENTER":U OR
      WHEN "CENTERED":U THEN
        ttButton.cButtonJustify = "B":U.
      WHEN "RIGHT":U THEN
        ttButton.cButtonJustify = "C":U.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadWidgets Procedure 
PROCEDURE loadWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Loads the current frame's widgets into a temp-table so
               we don't land up walking the widget tree all the time.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phParent AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hChild AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttWidget FOR ttWidget.
  hChild = phParent:FIRST-CHILD.
  REPEAT WHILE VALID-HANDLE(hChild):
    IF hChild:TYPE = "FIELD-GROUP":U THEN
       RUN loadWidgets(hChild).
    ELSE
    DO:
      FIND FIRST bttWidget
        WHERE bttWidget.cWidgetName = hChild:NAME
        NO-ERROR.
      IF NOT AVAILABLE(bttWidget) THEN
        CREATE bttWidget.
      ASSIGN
        bttWidget.cWidgetName = hChild:NAME
        bttWidget.hHandle     = hChild
      .
    END.
    hChild = hChild:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainPatchList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainPatchList Procedure 
PROCEDURE obtainPatchList :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the list of patch files from the API that is applicable
               to a certain database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParams AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDB          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControl     AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cStartFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hControl     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iWidth       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTextWidth   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCurrFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDispFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVersionNo   AS CHARACTER  NO-UNDO.

  cDB = ENTRY(1,pcParams).
  cControl = IF NUM-ENTRIES(pcParams) > 1 THEN ENTRY(2,pcParams) ELSE "":U.
  hControl = getWidgetHandle(cControl).

  cStartFolder = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "path_":U + cDB + "_dfd":U).

  IF cStartFolder <> ? AND
     cStartFolder <> "":U THEN
  DO:
    FILE-INFO:FILE-NAME = cStartFolder.
    IF FILE-INFO:FULL-PATHNAME = ? THEN
      RETURN.

    RUN getPatchFiles IN ghAPIProc
      (INPUT cDB,
       INPUT cStartFolder,
       OUTPUT cFileList).
    
    IF cFileList <> "":U AND
       cFileList <> ? AND
       VALID-HANDLE(hControl) THEN
    DO:
      iWidth = hControl:WIDTH-CHARS - 3.
      hControl:LIST-ITEM-PAIRS = hControl:LIST-ITEM-PAIRS.
      hControl:DELIMITER = CHR(3).
      DO iCount = 1 TO NUM-ENTRIES(cFileList,CHR(3)):
        cCurrFile = LC(ENTRY(iCount,cFileList,CHR(3))).
        iTextWidth = FONT-TABLE:GET-TEXT-WIDTH-CHARS(cCurrFile, hControl:FONT).
        IF iTextWidth >= iWidth THEN
          cDispFile = SUBSTRING(cCurrFile, 1, 10) + "...":U 
                    + SUBSTRING(cCurrFile,iTextWidth - (iWidth - 18)).
                   
        ELSE
          cDispFile = cCurrFile.
        hControl:ADD-LAST(cDispFile,cCurrFile).             
      END.
      hControl:SCREEN-VALUE = cFileList.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainRegistryKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainRegistryKeys Procedure 
PROCEDURE obtainRegistryKeys :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the RegistryKeys property for the list
               of properties that contain registry keys that need to be loaded.
               It then parses each of those keys and loads the key values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrKeyProp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnvironment AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSection     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER  NO-UNDO.


  /* Obtain a list of all the properties that contain registry keys */
  cKeyList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "registry_keys":U).

  /* Ignore the key list if it is blank. */
  IF cKeyList = "":U OR
     cKeyList = ? THEN 
    RETURN.

  /* Loop through those properties */
  REPEAT iCount = 1 TO NUM-ENTRIES(cKeyList):
    ASSIGN
      cCurrKeyProp  = ENTRY(iCount,cKeyList)
      cKeyString    = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                      cCurrKeyProp)
      cBaseKey      = "":U
      cEnvironment  = "":U
      cSection      = "":U
      cKey          = "":U
      .
    /* Set up the three strings that affect this. */
    DO iLoop = 1 TO NUM-ENTRIES(cKeyString,":":U):
      cEntry = ENTRY(iLoop,cKeyString,":":U).
      CASE iLoop:
        WHEN 1 THEN
          cBaseKey = cEntry.
        WHEN 2 THEN
          cEnvironment = cEntry.
        WHEN 3 THEN
          cSection = cEntry.
        WHEN 4 THEN
          cKey = cEntry.
      END CASE.
    END.
    ERROR-STATUS:ERROR = NO.

    /* Try and load the environment */
    IF cBaseKey <> "":U THEN
      LOAD cEnvironment BASE-KEY cBaseKey NO-ERROR.
    ELSE
      LOAD cEnvironment NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
      ERROR-STATUS:ERROR = NO.
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cCurrKeyProp,
                       "ERROR":U).
      NEXT.
    END.

    /* Now try and use the environment we loaded */
    USE cEnvironment NO-ERROR.                   
    IF ERROR-STATUS:ERROR THEN
    DO:
      UNLOAD cEnvironment.
      ERROR-STATUS:ERROR = NO.
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cCurrKeyProp,
                       "ERROR":U).
      NEXT.
    END.

    /* Now we get the key value */
    IF cSection <> "":U THEN
    DO:
      IF cKey = "DEFAULT":U THEN
        GET-KEY-VALUE SECTION cSection 
          KEY DEFAULT 
          VALUE cKeyValue.
      ELSE
        GET-KEY-VALUE SECTION cSection 
          KEY cKey 
          VALUE cKeyValue.
    END.
    IF ERROR-STATUS:ERROR THEN
    DO:
      UNLOAD cEnvironment.
      ERROR-STATUS:ERROR = NO.
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cCurrKeyProp,
                       "ERROR":U).
      NEXT.
    END.

    /* If the cKey field is "" or unknown, we get all the keys in that section */
    IF cKey = ? OR 
       cKey = "":U THEN
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(cKey):
        GET-KEY-VALUE SECTION cSection
          KEY ENTRY(iLoop,cKey)
          VALUE cKeyValue.
        ASSIGN 
          cProp  = cBaseKey + "\":U + cEnvironment + "\":U + cSection + "\":U + ENTRY(iLoop,cKey)
          .
        DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                         cProp,
                         cKeyValue).
      END.
    END.
    /* Otherwise we just set the key to what we got in */
    ELSE
    DO:
      ASSIGN 
        cProp  = cBaseKey + "\":U + cEnvironment + "\":U + cSection + "\":U + cKey
        .
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cProp,
                       cKeyValue).
    END.

    UNLOAD cEnvironment.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processDB Procedure 
PROCEDURE processDB :
/*------------------------------------------------------------------------------
  Purpose:     Confirms that the database is available and can be connected
               and registers the connection with the connection manager.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcControlList AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hControl   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cLogicalDB AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConnParm  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCreate    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iResult    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOk        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cError     AS CHARACTER  NO-UNDO.


  DEFINE BUFFER bttService FOR ttService.

  DO iCount = 1 TO NUM-ENTRIES(pcControlList):
    cEntry = ENTRY(iCount,pcControlList).
    CASE iCount:
      WHEN 1 THEN
        cLogicalDB = cEntry.
      OTHERWISE
      DO:
        hControl = getWidgetHandle(cEntry).
        IF VALID-HANDLE(hControl) THEN
        CASE iCount:
          WHEN 2 THEN
            lCreate = hControl:SCREEN-VALUE = "YES":U.
          WHEN 3 THEN
            cDBFile = hControl:SCREEN-VALUE.
          WHEN 4 THEN
            cConnParm = hControl:SCREEN-VALUE.
        END CASE.
      END.
    END CASE.
  END.

    /* Register the database and its connection parameters with the Connection
     Manager */
  IF LOOKUP("-db":U, cConnParm, " ":U) = 0 AND
     LOOKUP("-pf":U, cConnParm, " ":U) = 0 THEN
    cConnParm = '-db "':U + cDBFile + '" ':U + cConnParm.

  EMPTY TEMP-TABLE bttService. /* There should be nothing in it anyway */
  CREATE bttService.
  ASSIGN
    bttService.cServiceName = cLogicalDB
    bttService.cServiceType = "Database":U 
    bttService.cConnectParams = cConnParm
  .

  IF DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                      cLogicalDB) THEN
    RUN disconnectService IN THIS-PROCEDURE 
      (cLogicalDB) NO-ERROR.

  ERROR-STATUS:ERROR = NO.
  RETURN-VALUE = "":U.

  IF lCreate THEN
  DO:

    /*Check that the directory for the db exists. if not create it*/  
    ASSIGN
      cDbFilename = REPLACE(cDbFile,"/":U,"\":U)
      cDbPAth     = SUBSTRING(cDbFilename,1,R-INDEX(cDbFilename,"\":U) - 1)
      FILE-INFO:FILE-NAME = cDbPath
      lOk         = TRUE.

    IF FILE-INFO:FULL-PATHNAME = ? THEN
      OS-COMMAND SILENT VALUE('mkdir "' + cDbPath + '"').
      ASSIGN
        iResult = OS-ERROR.
    IF iResult NE 0 THEN
    DO:
      messageBox("MSG_cannot_create_path,NO":U, cDBPath + "," + STRING(iResult),"MB_OK,MB_ICONSTOP,MB_TASKMODAL":U).
      RETURN ERROR "MSG_cannot_create_path":U.
    END.

    IF SEARCH (cDbFilename) <> ? THEN 
    DO:
      MESSAGE 
        "Are you sure you want to overwrite the database ?" SKIP
        cDbFilename
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lOk.
    END.

    IF lOk THEN 
    DO:
      ERROR-STATUS:ERROR = NO.
      RETURN-VALUE = "":U.
      CREATE DATABASE cDbFileName FROM "EMPTY" REPLACE NO-ERROR.
  
      IF ERROR-STATUS:ERROR THEN
      DO:
        cError = "":U.
        DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cError = cError 
                 + (IF cError = "":U THEN "":U ELSE CHR(13))
                 + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        messageBox("MSG_DB_creation_failed,NO", cError,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
        RETURN ERROR RETURN-VALUE.
      END.
    END.
    ELSE
      RETURN ERROR RETURN-VALUE.
  END.
    
  RUN registerService IN THIS-PROCEDURE (INPUT BUFFER bttService:HANDLE)
    NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
    (RETURN-VALUE <> "":U AND
     RETURN-VALUE <> ?) THEN
  DO:
    messageBox("MSG_register_service,NO":U, RETURN-VALUE,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR RETURN-VALUE.
  END.

  RUN connectService IN THIS-PROCEDURE 
    (cLogicalDB, OUTPUT cEntry) NO-ERROR.
  IF ERROR-STATUS:ERROR OR 
    (RETURN-VALUE <> "":U AND
     RETURN-VALUE <> ?) THEN
  DO:
    messageBox("MSG_DB_connect_failed,NO":U, RETURN-VALUE,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR RETURN-VALUE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processParams Procedure 
PROCEDURE processParams :
/*------------------------------------------------------------------------------
  Purpose:     This is the process that makes the calls into the API.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER cStatusHandle AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cGroups AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry  AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttPage  FOR ttPage.
  DEFINE BUFFER bttField FOR ttField.
  DEFINE BUFFER bttValue FOR ttValue.

  ASSIGN
    cGroups = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               "page_groups":U).

  /* Set up the ttValue table that contains all the important 
     variables that have been set. */
  IF cGroups <> ? THEN
  DO iCount = 1 TO NUM-ENTRIES(cGroups):
    cEntry = ENTRY(iCount,cGroups).
    FOR EACH bttPage
          WHERE bttPage.cPageGroup = cEntry,
        EACH bttField
          WHERE bttField.iPageNo = bttPage.iPageNo
            AND bttField.cTableVariable <> "":U:
      FIND FIRST bttValue 
        WHERE bttValue.cGroup    = bttPage.cPageGroup
          AND bttValue.cVariable = bttField.cTableVariable
        NO-ERROR.
      IF NOT AVAILABLE(bttValue) THEN
      DO:
        CREATE bttValue.
        ASSIGN
          bttValue.cGroup    = bttPage.cPageGroup      
          bttValue.cVariable = bttField.cTableVariable 
        .
      END.
      bttValue.cValue = bttField.cFieldValue.
    END.
  END.

  /* The databases are now connected. Everything is ready for the
     ttValue table to be used to process the stuff */
  
  SUBSCRIBE PROCEDURE ghCurrPage TO "updateStatus":U IN ghApiProc NO-ERROR.
  
  RUN applyPatches IN ghApiProc(INPUT TABLE ttValue).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyExpander) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyExpander Procedure 
PROCEDURE propertyExpander :
/*------------------------------------------------------------------------------
  Purpose:     Expands all the properties in the expand list using the
               appropriate method.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExpandList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPropertyList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpander      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpand        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty      AS CHARACTER  NO-UNDO.

  /* Now we need to know what order to expand the stuff in */
  cExpandList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "expand_list":U).

  DO iCount = 1 TO NUM-ENTRIES(cExpandList):
    cExpand = ENTRY(iCount,cExpandList).
    cPropertyList = ENTRY(1,cExpand,"|":U).
    IF NUM-ENTRIES(cExpand,"|":U) > 1 THEN
    DO:
      cExpander = ENTRY(2,cExpand,"|":U).
      RUN VALUE(cExpander) IN THIS-PROCEDURE
        (cPropertyList).
    END.
    ELSE
    DO:
      DO iCount2 = 1 TO NUM-ENTRIES(cPropertyList):
        cProperty = ENTRY(iCount2,cPropertyList).
        cPropertyValue = getExpandablePropertyValue(cProperty).
        cPropertyValue = expandTokens(cPropertyValue).
        DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                         cProperty,
                         cPropertyValue).
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recurseNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseNodes Procedure 
PROCEDURE recurseNodes :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for constructing the attributes
               into the node table to prepare them for the write into the
               appropriate tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phParent      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcStack       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hNode       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.


  /* If we're at the top of the stack, put the name in the node table */
  IF NUM-ENTRIES(pcStack) = 1 THEN
    setNode("SetupType":U,pcStack,NUM-ENTRIES(pcStack),NO).

  /* If we're on level 2 we're going into a page node. */
  IF NUM-ENTRIES(pcStack) = 2 THEN
  DO:
    giRecNo = giRecNo + 1.
    setNode("PageNo":U,STRING(giRecNo),NUM-ENTRIES(pcStack),NO).
  END.

  /* Set the node to look at the next child */
  CREATE X-NODEREF hNode.

  /* Iterate through the children */
  REPEAT iCount = 1 TO phParent:NUM-CHILDREN:
    /* Set the node to the child node */
    lSuccess = phParent:GET-CHILD(hNode,iCount).
    IF NOT lSuccess THEN
      NEXT.

    IF hNode:NAME = "page":U THEN
      setNode("PageName":U,hNode:GET-ATTRIBUTE("PageName":U),2,NO).

    /* If the text has nothing in it, skip it */
    IF hNode:SUBTYPE = "TEXT":U THEN
    DO:
      cTest = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
      cTest = REPLACE(cTest, CHR(13), "":U).
      cTest = TRIM(cTest).
      IF cTest = "" THEN
        NEXT.
    END.

    /* When we hit level 3, we know what kind of records these are,
       and we need to make sure that they get appropriately set. */
    IF NUM-ENTRIES(pcStack) = 3 THEN
    DO:
      cRecordType = ENTRY(1,pcStack).
      setNode("RecordType":U,cRecordType,NUM-ENTRIES(pcStack),NO).
    END.

    /* Set a node value for this node */
    IF hNode:SUBTYPE = "TEXT":U THEN
      setNode(ENTRY(1,pcStack),hNode:NODE-VALUE,NUM-ENTRIES(pcStack),YES).

    /* Go down lower if need be */
    RUN recurseNodes(hNode,hNode:NAME + ",":U + pcStack).

    
    /* If this is level 3 on the stack, we can write out this data
       to the appropriate files */
    cRecordType = getNode("RecordType":U).
    IF NUM-ENTRIES(pcStack) = 2 AND
       CAN-DO("button,action,field":U, cRecordType) THEN
      writeNode(cRecordType,NUM-ENTRIES(pcStack)).
    IF NUM-ENTRIES(pcStack) = 1 THEN
      writeNode("page":U,NUM-ENTRIES(pcStack)).
    
  END.

  DELETE OBJECT hNode.
  hNode = ?.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restoreProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restoreProperties Procedure 
PROCEDURE restoreProperties :
/*------------------------------------------------------------------------------
  Purpose:     Restores cascaded properties to their original values. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInput  AS CHARACTER  NO-UNDO. /* not used */

  DEFINE VARIABLE cExpandList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPropertyList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpander      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpand        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrigValue     AS CHARACTER  NO-UNDO.

  /* Now we need to know what order to expand the stuff in */
  cExpandList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "expand_list":U).

  DO iCount = 1 TO NUM-ENTRIES(cExpandList):
    cExpand = ENTRY(iCount,cExpandList).
    IF NUM-ENTRIES(cExpand,"|") > 1 THEN
      cPropertyList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                       ENTRY(1,cExpand,"|":U)).
    ELSE
      cPropertyList = cExpand.
    DO iCount2 = 1 TO NUM-ENTRIES(cPropertyList):
      cProperty = ENTRY(iCount2,cPropertyList).
      cOrigValue = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    ";:":U + cProperty).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "::":U + cProperty,
                       ?).
      IF cOrigValue = ? THEN
        cPropertyValue = "":U.
      ELSE
        cPropertyValue = cOrigValue.
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cProperty,
                       cPropertyValue).
    END.
  END.

  RUN propertyExpander.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-screenScrape) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenScrape Procedure 
PROCEDURE screenScrape :
/*------------------------------------------------------------------------------
  Purpose:     This procedure goes through all the fields that are in the
               ttField temp-table for this page and stores the value
               from the screen into the ttField.cFieldValue field.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInput  AS CHARACTER  NO-UNDO. /* not used */

  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttPage FOR ttPage.
  DEFINE BUFFER bttField FOR ttField.

  FIND FIRST bttPage
    WHERE bttPage.cPageName = gcPageName.

  FOR EACH bttField
    WHERE bttField.iPageNo = bttPage.iPageNo:

    hWidget = getWidgetHandle(bttField.cFieldName).

    IF VALID-HANDLE(hWidget) THEN
    DO:
      CASE hWidget:TYPE:
        WHEN "BROWSE":U OR
        WHEN "BUTTON":U THEN
        DO:
        END.
        OTHERWISE
        DO:
          bttField.cFieldValue = STRING(hWidget:SCREEN-VALUE).
        END.
      END CASE.
    END.
    IF bttField.cStoreTo <> "":U THEN
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       bttField.cStoreTo,
                       bttField.cFieldValue).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "::":U + bttField.cStoreTo,
                       ?).
      RUN propertyExpander.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupPaths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupPaths Procedure 
PROCEDURE setupPaths :
/*------------------------------------------------------------------------------
  Purpose:     This procedure establishes all the defaults for the paths.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPathOrder AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRawPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPathOrder  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripStart AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripEnd   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNoColon    AS INTEGER    NO-UNDO.

  /* First thing we have to do is establish the full path to the 
     root_directory */
  cString = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                             "root_directory":U).
  IF cString <> ? THEN
    FILE-INFO:FILE-NAME = cString.
  ELSE
    FILE-INFO:FILE-NAME = ".":U.
  cString = FILE-INFO:FULL-PATHNAME.
  DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                   "root_directory":U,
                   cString).

  cPathOrder = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                pcPathOrder).


  /* Now we loop through the paths in the right order and handle them */
  DO iCount = 1 TO NUM-ENTRIES(cPathOrder):

    /* Get the current path value */
    cCurrPath = ENTRY(iCount, cPathOrder).

    cRawPath = getExpandablePropertyValue(cCurrPath).

    /* If the current path value is ?, there's nothing we can do with
       it except set it to "" to avoid making anything that depends
       on it ? */
    IF cRawPath = ? THEN
      cRawPath = "":U.
    
    /* Break the path into its components and expand the tokens */
    iNoColon = NUM-ENTRIES(cRawPath,"|":U).
    cPath = expandTokens(ENTRY(1,cRawPath,"|":U)).
    IF iNoColon > 1 THEN
      cStripStart = expandTokens(ENTRY(2,cRawPath,"|":U)).
    IF iNoColon > 2 THEN
      cStripEnd = expandTokens(ENTRY(3,cRawPath,"|":U)).

    /* Now strip off the front portion if there's anything to strip */
    IF cStripStart <> ? AND
       cStripStart <> "":U AND
       SUBSTRING(cPath,1,LENGTH(cStripStart)) = cStripStart THEN
      cPath = SUBSTRING(cPath,LENGTH(cPath) - LENGTH(cStripStart)).

    /* And strip off the back if there's anything to strip */
    IF cStripEnd <> ? AND
       cStripEnd <> "":U AND
       SUBSTRING(cPath,LENGTH(cPath) - LENGTH(cStripEnd) + 1) = cStripEnd THEN
      cPath = SUBSTRING(cPath,1,LENGTH(cPath) - LENGTH(cStripEnd)).

    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     cCurrPath, cPath).

  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showValues Procedure 
PROCEDURE showValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInput AS CHARACTER  NO-UNDO. /* not used */

  RUN sessinfo.w PERSISTENT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDirectory Procedure 
PROCEDURE validateDirectory :
/*------------------------------------------------------------------------------
  Purpose:     This procedure validates that the directory exists and
               can in fact be created if necessary.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOutDir   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iResult   AS INTEGER    NO-UNDO.

  hWidget = getWidgetHandle(pcWidget).

  IF NOT VALID-HANDLE(hWidget) THEN
    RETURN.

  cPath = hWidget:SCREEN-VALUE.

  IF cPath = "":U OR 
     cPath = ? THEN
  DO:
    messageBox("MSG_blank_path":U, hWidget:LABEL,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR "MSG_blank_path":U.
  END.

  FILE-INFO:FILE-NAME = cPath.
  IF FILE-INFO:FULL-PATHNAME = ? THEN
  DO:
    iRetVal = messageBox("MSG_path_does_not_exist":U, 
                         cPath,
                         "MB_OKCANCEL,MB_ICONQUESTION,MB_TASKMODAL":U).
    IF iRetVal = {&IDOK} THEN
    DO:
      OS-COMMAND SILENT VALUE('mkdir "' + cPath + '"').
      ASSIGN
        iResult = OS-ERROR.
      IF iResult NE 0 THEN 
      DO:
        messageBox("MSG_cannot_create_path":U, 
                   cPath + "," + STRING(OS-ERROR),
                   "MB_OK,MB_ICONERROR,MB_TASKMODAL":U).
        RETURN ERROR "MSG_cannot_create_path":U.
      END.
      /*
      DO iCount = 1 TO NUM-ENTRIES(cPath,"~\":U):
        cOutDir = cOutDir + (IF cOutDir = "":U THEN "":U ELSE "~\":U)
                + ENTRY(iCount,cPath,"~\":U).
        FILE-INFO:FILE-NAME = cOutDir.
        IF FILE-INFO:FULL-PATHNAME = ? THEN
        DO:
          OS-CREATE-DIR VALUE(cOutDir).
          IF OS-ERROR <> 0 THEN
          DO:
            messageBox("MSG_cannot_create_path":U, 
                       cOutDir + "," + STRING(OS-ERROR),
                       "MB_OK,MB_ICONERROR,MB_TASKMODAL":U).
            RETURN ERROR "MSG_cannot_create_path":U.
          END.
        END.
      END.
      */
    END.
    ELSE
      RETURN ERROR "MSG_path_does_not_exist":U.
  END.

  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSiteNumber Procedure 
PROCEDURE validateSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSite     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal   AS INTEGER    NO-UNDO.

  hWidget = getWidgetHandle(pcWidget).

  IF NOT VALID-HANDLE(hWidget) THEN
    RETURN.

  cSite = hWidget:SCREEN-VALUE.

  IF cSite = "":U OR cSite = ? OR cSite = "0":U THEN
  DO:
    messageBox("MSG_site_number":U, hWidget:LABEL,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR "MSG_site_number":U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-analyzeCase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION analyzeCase Procedure 
FUNCTION analyzeCase RETURNS CHARACTER
  (INPUT pcCaseStatement AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Analyzes a CASE expression and determines the 
  
               A CASE expression starts with a colon and the name of the 
               property to evaluate. The cases are all enumerated on a value
               by value basis and if a match is found, only that match is
               used.
               e.g.
               :session_date_format:dmy|page1:mdy|page2:ymd|page3:default|page9
               Check the session_date_format property.
               If the value is dmy, show page1
               If the value is mdy, show page2
               If the value is ymd, show page3
               If none of the conditions are met, show page 9. 

    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOperand AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCase    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDo      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefault AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

  cDo = ?.
  cOperand = ENTRY(2,pcCaseStatement,":":U).
  cOperand = getOperandValue(cOperand).

  loop-blk:
  DO iCount = 3 TO NUM-ENTRIES(pcCaseStatement,":":U):
    cValue = ENTRY(iCount,pcCaseStatement,":":U).
    cCase  = ENTRY(1,cValue,"|":U).
    IF cCase = "default":U THEN
      cDefault = ENTRY(2,cValue,"|":U).
    
    IF cOperand = cCase THEN
    DO:
      cDo = ENTRY(2,cValue,"|":U).
      LEAVE loop-blk.
    END.
    
  END.

  IF cDo = ? AND
     cDefault <> "":U THEN
    cDo = cDefault.

  RETURN cDo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-analyzeIf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION analyzeIf Procedure 
FUNCTION analyzeIf RETURNS CHARACTER
  (INPUT pcIfStatement AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     An IF expression starts with a ? and is followed by the 
               expression to evaluate. && and :: can be used as AND and OR
               operators respectively. The portion after the first semicolon
               represents the THEN and the portion after the second semicolon
               represents the ELSE. If statements may not be nested.
               e.g. 
               ?createDBs=YES;page1;page2 
               "If the value of the createDBs property is YES then show page1 
                else show page2"
                
               ?createDBs=YES&createRVDB=NO;page4;page3
               "If the value of createDBs is YES and createRVDB is NO then show
                page4 else show page 3"
                
                This function simply returns the value of the THEN or ELSE 
                portion.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCondition AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cThen      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElse      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iAnd       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLHS       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRHS       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLHS       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRHS       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cWrkExp    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL    NO-UNDO.

  IF NUM-ENTRIES(pcIfStatement, ";":U) = 1 THEN
    RETURN "".
  
  /* Get the condition */
  cCondition = ENTRY(1,pcIfStatement,";":U).
  /* strip the ? off the front */
  IF SUBSTRING(cCondition,1,1) = "?":U THEN
    cCondition = SUBSTRING(cCondition,2).

  /* Determine the THEN */
  cThen = ENTRY(2,pcIfStatement,";":U).

  /* Determine the ELSE if there is one */
  IF NUM-ENTRIES(pcIfStatement, ";":U) > 2 THEN
    cElse = ENTRY(3,pcIfStatement,";":U).

  cRetVal = "":U.
  lOK = YES.

  /* Loop through the ORs */
  or-loop:
  DO WHILE NUM-ENTRIES(cCondition,":":U) > 1:

    /* Get the two expressions into a string */
    cLHS = ENTRY(1,cCondition,":":U).
    cRHS = ENTRY(2,cCondition,":":U).
    
    /* There may be an and in this expression so strip it out */
    iPos = R-INDEX(cLHS,"&":U).
    IF iPos > 0 THEN
      cLHS = SUBSTRING(cLHS,iPos + 1).

    /* Now evaluate the left hand side of the or */
    lLHS = evaluateExpression(cLHS).
    
    /* Strip the and from the right hand side */
    iPos = INDEX(cRHS,"&":U).
    IF iPos > 0 THEN
      cRHS = SUBSTRING(cRHS,1,iPos - 1).

    /* Evaluate the right hand side */
    lRHS = evaluateExpression(cRHS).

    /* Now check the return from the or of the two expressions */
    IF lLHS = YES OR lRHS = YES THEN
    DO:
      /* The or returned TRUE so lets replace these two expressions that 
         have been evaluated against each other with a TRUE in the string */
      cWrkExp = cLHS + ":":U + cRHS.
      iPos = INDEX(cCondition,cWrkExp).
      cCondition = SUBSTRING(cCondition,1,iPos - 1) 
                 + "TRUE":U 
                 + SUBSTRING(cCondition,iPos + LENGTH(cWrkExp)).
    END.
    /* If the or is false, leave the loop. */
    ELSE
    DO:
      IF lLHS = ? OR lRHS = ? THEN
        lOK = ?.
      ELSE
        lOk = NO.
      LEAVE or-loop.
    END.
  END. /* or-loop */

  /* If the conditions are still true, we need to process the ANDs */
  IF lOK = YES THEN
  DO:
    /* Loop through them in order from left to right. At this point the only
       stuff left in this string should be ands */
    and-loop:
    DO iAnd = 1 TO NUM-ENTRIES(cCondition,"&":U):
      /* Take the expression and evaluate it */
      cWrkExp = ENTRY(iAnd,cCondition,"&":U).
      lOK = lOK AND evaluateExpression(cWrkExp).

      /* If the expression is now false, leave the loop. */
      IF lOK = FALSE OR
         lOK = ? THEN
        LEAVE and-loop.
    END.
  END.

  CASE lOK:
    WHEN TRUE THEN
      cRetVal = cThen.
    WHEN FALSE THEN
      cRetVal = cElse.
    WHEN ? THEN
      cRetVal = ?.
  END.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-evaluateExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateExpression Procedure 
FUNCTION evaluateExpression RETURNS LOGICAL
  ( INPUT pcExpression AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cOperand1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperand2 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOperator AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue1   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue2   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOneOp    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.
  
  /* Let's provide a quick turnaround for things that we can */
  IF pcExpression = "TRUE":U OR 
     pcExpression = "YES":U THEN 
    RETURN TRUE.   
  IF pcExpression = "FALSE":U OR 
     pcExpression = "NO":U THEN 
    RETURN FALSE.

  /* Now lets figure out the operator that we have to use */
  IF INDEX(pcExpression,">=":U) > 0 THEN
  DO:
    cOperator = "GE":U.
    pcExpression = REPLACE(pcExpression,">=":U,"=":U).
  END.
  IF INDEX(pcExpression,"<=":U) > 0 THEN
  DO:
    cOperator = "LE":U.
    pcExpression = REPLACE(pcExpression,"<=":U,"=":U).
  END.
  IF INDEX(pcExpression,"<>":U) > 0 THEN
  DO:
    cOperator = "NE":U.
    pcExpression = REPLACE(pcExpression,"<>":U,"=":U).
  END.
  IF INDEX(pcExpression,"=":U) = 0 THEN
    cOperator = "LG":U.
  ELSE
    cOperator = "EQ":U.

  /* At this point, the only delimiter in the string should be an = */

  /* Store the operands */
  cOperand1 = ENTRY(1,pcExpression,"=":U).
  IF NUM-ENTRIES(pcExpression,"=":U) = 2 THEN
    cOperand2 = ENTRY(2,pcExpression,"=":U).
  ELSE 
    lOneOp = YES.

  /* Now determine the values of the operands */
  cValue1 = getOperandValue(cOperand1).
  IF NOT lOneOp THEN
    cValue2 = getOperandValue(cOperand2).

  CASE cOperator:
    WHEN "GE":U THEN
      lOk = cValue1 >= cValue2.
    WHEN "LE":U THEN
      lOk = cValue1 <= cValue2.
    WHEN "NE":U THEN
      lOk = cValue1 <> cValue2.
    WHEN "LG":U THEN
      lOk = (cValue1 = "TRUE":U) OR (cValue1 = "YES":U).
    OTHERWISE
      lOk = cValue1 = cValue2.
  END CASE.

  RETURN lOk.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expandTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION expandTokens Procedure 
FUNCTION expandTokens RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Replaces tokens in the string with the values from the session
            parameters.
    Notes:  Takes a string with tokens in the form #<token># and replaces the
            token with a value that is derived from getSessionParam.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToken   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastPos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cString  AS CHARACTER  NO-UNDO.

  /* If the string is blank, then just return */
  IF pcString = "":U THEN 
    RETURN pcString.

  /* Get the position of the first # */
  iLastPos = 1.
  iPos     = INDEX(pcString,"#":U).

  /* Keep looping until we get to the end of the string */
  DO WHILE iPos <= LENGTH(pcString) AND iPos <> 0:
    cRetVal = cRetVal + SUBSTRING(pcString, iLastPos, iPos - iLastPos).
    /* Set the last position */
    iLastPos = iPos + 1.
    /* Find the next # in the string -- this would give us a token in between */
    iPos = INDEX(pcString,"#":U, iLastPos).

    /* If there is another #, we have a token */
    IF iPos <> 0 THEN 
    DO:
      /* Extract the token and look up its value */
      cToken = SUBSTRING(pcString, iLastPos, iPos - iLastPos).
      cString = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 cToken).
      /* If the value of the token is unknow, set it to blank */
      IF cString = ? THEN
         cString = "":U.
      /* Put the value into the return value */
      cRetVal = cRetVal + cString.

      /* Set the last position ahead of this token */
      iLastPos = iPos + 1.

      /* And find the next # */
      iPos = INDEX(pcString,"#":U, iLastPos).

    END.
  END.
  cRetVal = cRetVal + SUBSTRING(pcString, iLastPos).

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandablePropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExpandablePropertyValue Procedure 
FUNCTION getExpandablePropertyValue RETURNS CHARACTER
  ( INPUT pcProperty AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains the value of the expandable property. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrigVal AS CHARACTER  NO-UNDO.

  /* See if there is an original value */
  cOrigVal = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              ";:":U + pcProperty).

  /* See if we have expanded this before. If we have there 
     will be a :: property */
  cRetVal = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "::":U + pcProperty).

  /* We haven't set it up before if cRetVal is unknown, so we 
     expand it from the original path */
  IF cRetVal = ? THEN
  DO:
    cRetVal = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                pcProperty).
    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     "::":U + pcProperty,
                     cRetVal).
  END.

  IF cOrigVal = ? THEN
    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     ";:":U + pcProperty,
                     cRetVal).
    

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  (INPUT pcGroup    AS CHARACTER,
   INPUT pcVariable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the ttValue record that contains the appropriate value.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttValue FOR ttValue.
      
  FIND FIRST bttValue 
    WHERE bttValue.cGroup    = pcGroup
      AND bttValue.cVariable = pcVariable
    NO-ERROR.
  IF NOT AVAILABLE(bttValue) THEN
    RETURN ?.
  ELSE
    RETURN bttValue.cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOperandValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOperandValue Procedure 
FUNCTION getOperandValue RETURNS CHARACTER
  ( INPUT pcOperand AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSet   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cStr   AS CHARACTER  NO-UNDO.

  cStr =  SUBSTRING(pcOperand,1,1).
  IF cStr = "'":U OR
     cStr = '"':U THEN
    ASSIGN
      cValue = SUBSTRING(pcOperand,2,LENGTH(pcOperand) - 2)
      lSet = YES.

  IF pcOperand = "YES":U OR
     pcOperand = "TRUE":U THEN
    ASSIGN
      cValue = pcOperand
      lSet = YES.

  IF NOT lSet THEN
    cValue = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              pcOperand).
  
  RETURN cValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidgetHandle Procedure 
FUNCTION getWidgetHandle RETURNS HANDLE
  ( INPUT pcWidget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle to a widget in the ttWidget table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttWidget FOR ttWidget.

  FIND FIRST bttWidget
    WHERE bttWidget.cWidgetName = pcWidget
    NO-ERROR.
  IF NOT AVAILABLE(bttWidget) THEN
    RETURN ?.
  ELSE
    RETURN bttWidget.hHandle. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-messageBox) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION messageBox Procedure 
FUNCTION messageBox RETURNS INTEGER
  ( INPUT pcMessage AS CHARACTER,
    INPUT pcTokens  AS CHARACTER,
    INPUT pcStyle   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Shows the message specified by cMessage. The value is 
               obtained by a call to getSessionParam.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConstants AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iRetVal    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStyle     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessage   AS CHARACTER  NO-UNDO.

  cConstants = "MB_OK,MB_OKCANCEL,MB_ABORTRETRYIGNORE,MB_YESNOCANCEL,MB_YESNO,MB_RETRYCANCEL"
             + ",MB_ICONHAND,MB_ICONQUESTION,MB_ICONEXCLAMATION,MB_ICONASTERISK,MB_USERICON"
             + ",MB_ICONWARNING,MB_ICONERROR,MB_ICONINFORMATION,MB_ICONSTOP,MB_DEFBUTTON1"
             + ",MB_DEFBUTTON2,MB_DEFBUTTON3,MB_DEFBUTTON4,MB_APPLMODAL,MB_SYSTEMMODAL"
             + ",MB_TASKMODAL,MB_HELP,MB_NOFOCUS,MB_SETFOREGROUND,MB_DEFAULT_DESKTOP_ONLY"
             + ",MB_TOPMOST,MB_RIGHT,MB_RTLREADING,MB_TYPEMASK,MB_ICONMASK,MB_DEFMASK"
             + ",MB_MODEMASK,MB_MISCMASK".
  
  cValues = "{&MB_OK},{&MB_OKCANCEL},{&MB_ABORTRETRYIGNORE},{&MB_YESNOCANCEL},{&MB_YESNO},{&MB_RETRYCANCEL}"
          + ",{&MB_ICONHAND},{&MB_ICONQUESTION},{&MB_ICONEXCLAMATION},{&MB_ICONASTERISK},{&MB_USERICON}"
          + ",{&MB_ICONWARNING},{&MB_ICONERROR},{&MB_ICONINFORMATION},{&MB_ICONSTOP},{&MB_DEFBUTTON1}"
          + ",{&MB_DEFBUTTON2},{&MB_DEFBUTTON3},{&MB_DEFBUTTON4},{&MB_APPLMODAL},{&MB_SYSTEMMODAL}"
          + ",{&MB_TASKMODAL},{&MB_HELP},{&MB_NOFOCUS},{&MB_SETFOREGROUND},{&MB_DEFAULT_DESKTOP_ONLY}"
          + ",{&MB_TOPMOST},{&MB_RIGHT},{&MB_RTLREADING},{&MB_TYPEMASK},{&MB_ICONMASK},{&MB_DEFMASK}"
          + ",{&MB_MODEMASK},{&MB_MISCMASK}".

  cMessage = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              ENTRY(1,pcMessage)).

  IF cMessage = ? THEN
    cMessage = pcMessage.
  ELSE
  DO:
    IF NUM-ENTRIES(pcMessage) = 2 AND 
       ENTRY(2,pcMessage) = "NO":U THEN
    DO:
      cMessage = cMessage + CHR(13) + pcTokens.
    END.
    ELSE
    DO iCount = 1 TO NUM-ENTRIES(pcTokens):
      cMessage = REPLACE(cMessage,"%":U + STRING(iCount),ENTRY(iCount,pcTokens)).
    END.
    cMessage = cMessage + " (" + pcMessage + ")".
  END.

  DO iCount = 1 TO NUM-ENTRIES(pcStyle):
    iPos = LOOKUP(ENTRY(iCount,pcStyle),cConstants).
    IF iPos <> 0 AND iPos <> ? THEN
      iStyle = iStyle + INTEGER(ENTRY(iPos,cValues)).
  END.

  RUN MessageBoxA
    (OUTPUT iRetVal,
     CURRENT-WINDOW:HWND,
     cMessage,
     gcWindowTitle,
     iStyle).


  RETURN iRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL
  ( INPUT pcRecordType AS CHARACTER,
    INPUT piStackLevel AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes the data in the ttNode table and writes it into the appropriate
            temp-table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.

  CASE pcRecordType:
    WHEN "button":U THEN
      hBuffer = BUFFER ttButton:HANDLE.
    WHEN "field":U THEN
      hBuffer = BUFFER ttField:HANDLE.
    WHEN "action":U THEN
      hBuffer = BUFFER ttAction:HANDLE.
    WHEN "page":U THEN
      hBuffer = BUFFER ttPage:HANDLE.
  END.

  writeRecord(hBuffer, piStackLevel).

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeRecord Procedure 
FUNCTION writeRecord RETURNS LOGICAL
  ( INPUT phBuffer AS HANDLE,
    INPUT piStackLevel AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:   Creates a buffer record and populates the contents with the
             data contained in the ttNodes table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hKeyField   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPageNo     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrField  AS HANDLE   NO-UNDO.

  DEFINE VARIABLE iPageNo     AS INTEGER    NO-UNDO.

  iPageNo = INTEGER(getNode("PageNo":U)).

  hPageNo = phBuffer:BUFFER-FIELD("iPageNo":U).

  IF phBuffer:NAME <> "ttPage":U THEN
    hKeyField = phBuffer:BUFFER-FIELD("i":U + SUBSTRING(phBuffer:NAME,3) + "No":U).
  ELSE
    hKeyField = ?.

  /* Go into a transaction */
  DO TRANSACTION:
    /* Create a record */
    phBuffer:BUFFER-CREATE().

    giRecNo = giRecNo + 1.
    hPageNo:BUFFER-VALUE = iPageNo.
    IF VALID-HANDLE(hKeyField) THEN
      hKeyField:BUFFER-VALUE = giRecNo.

    /* Loop through the records in the ttNode table that are not 
       either RecordType or SessionType properties.*/
    FOR EACH ttNode
      WHERE NOT CAN-DO("RecordType,SetupType,PageNo",ttNode.cNode)
        AND ttNode.iNodeLevel > piStackLevel:

      /* Get the handle to a field in the TEMP-TABLE that has 
         the name of this node. If we find
         it we set its value */
      hCurrField = phBuffer:BUFFER-FIELD("c":U + ttNode.cNode) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      IF VALID-HANDLE(hCurrField) THEN
        hCurrField:BUFFER-VALUE = ttNode.cValue.
    END.

    /* Release the buffer so that it gets written */
    phBuffer:BUFFER-RELEASE().
  END.

  FOR EACH ttNode 
    WHERE ttNode.iNodeLevel > piStackLevel + 1:
    DELETE ttNode.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

