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
{src/adm2/globals.i}

/* Replace control character function call */
{af/sup2/afxmlreplctrl.i}

/* ttNode table and manipulation include */
{af/sup2/afttnode.i}

/* Patch list temp-table */
{install/inc/inttpatchlist.i}

/* Install Windows API constants */
{install/inc/inwinapiconst.i}

DEFINE STREAM sLogFile.

DEFINE VARIABLE giRecNo       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghCurrPage    AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcPageName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCurrFrame   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSourceProc  AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcWindowTitle AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glStreamOpen  AS LOGICAL    NO-UNDO.

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

DEFINE TEMP-TABLE ttPatches NO-UNDO
  FIELD cPatchDB         AS CHARACTER
  FIELD cPatchLevel      AS CHARACTER
  FIELD lApply           AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
    cPatchDB
    cPatchLevel
  .

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

&IF DEFINED(EXCLUDE-deriveDBTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deriveDBTable Procedure 
FUNCTION deriveDBTable RETURNS CHARACTER
  ( INPUT pcDBName AS CHARACTER,
    INPUT pcFile   AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-formatMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formatMessage Procedure 
FUNCTION formatMessage RETURNS CHARACTER
  ( INPUT pcMessage AS CHARACTER,
    INPUT pcTokens  AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-obtainDBVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainDBVersion Procedure 
FUNCTION obtainDBVersion RETURNS CHARACTER
  ( INPUT pclDBName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showStatus Procedure 
FUNCTION showStatus RETURNS LOGICAL
  ( INPUT pcStatus AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-applyUpgrade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyUpgrade Procedure 
PROCEDURE applyUpgrade :
/*------------------------------------------------------------------------------
  Purpose:     This procedure loops through all the records in the ttPatchList
               table and applies the change that the patch requires to the
               database it affects.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSiteNo      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalReverse  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalDivision AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBTable     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPathDump    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPathDF      AS CHARACTER  NO-UNDO.


  DEFINE BUFFER bttPatchList FOR ttPatchList.

  /* Loop through all the patches in the patch list.     
     If the update stage > 6 we can't run these updates now. These  are reserved
     for the "In Session" patch runner */
  FOR EACH bttPatchList
    WHERE bttPatchList.iUpdateWhen < 7 
    BREAK BY bttPatchList.cPatchDB
          BY bttPatchList.cPatchLevel
          BY bttPatchList.iUpdateWhen
          BY bttPatchList.iSeq
    ON ERROR UNDO, LEAVE:


    IF FIRST-OF(bttPatchList.cPatchDB) THEN
    DO:
      DELETE ALIAS VALUE("DICTDB":U).
      CREATE ALIAS VALUE("DICTDB":U) FOR DATABASE VALUE(bttPatchList.cPatchDB).
      cPathDump = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "path_":U + bttPatchList.cPatchDB + "_dump":U).
      cPathDump = REPLACE(cPathDump,"~\":U, "/":U).
      cPathDF   = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "path_":U + bttPatchList.cPatchDB + "_dfd":U).
      cPathDF   = REPLACE(cPathDF,"~\":U, "/":U).
    END.

    IF FIRST-OF(bttPatchList.cPatchLevel) THEN
    DO:
      showStatus(SUBSTITUTE("Updating database &1 to level &2",bttPatchList.cPatchDB,bttPatchList.cPatchLevel)).
    END.

    showStatus(bttPatchList.cDescription).


    /* If this is not a site number record, there is a file name that we need to find
       in one of the directories. Use the API in the configuration file manager that
       will find the file */
    IF bttPatchList.cFileType <> "s":U THEN
    DO:
      IF bttPatchList.cFileType = "d":U THEN
        cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                                 bttPatchList.cFileName + "/.":U).
      ELSE
    END.
    
    IF NOT lError THEN
    DO:
      /* Now figure out what to do with this record. */
      CASE bttPatchList.cFileType:
        WHEN "d":U THEN  /* Data load */
        DO:
          RUN prodict/load_d.p (INPUT "ALL":U, INPUT cPathDump) NO-ERROR. 
        END.
        WHEN "df":U THEN /* DF file for database schema */
        DO:
          cFile = cPathDF + (IF SUBSTRING(cPathDF,LENGTH(cPathDF)) = "/":U THEN "":U ELSE "/":U)
                + bttPatchList.cFileName.
          IF SEARCH(cFile) = ? THEN
          DO:
            cMessage = formatMessage("MSG_file_not_found":U, bttPatchList.cFileName).
            lError = YES.
          END.
          ELSE
            RUN prodict/load_df.p (INPUT cFile) NO-ERROR.
        END.
        WHEN "p":U THEN /* Procedure to run */
        DO:
          cFile = DYNAMIC-FUNCTION("findFile":U IN THIS-PROCEDURE,
                         bttPatchList.cFileName).

          IF cFile = ? THEN
          DO:
            cMessage = formatMessage("MSG_file_not_found":U, bttPatchList.cFileName).
            lError = YES.
          END.
          ELSE
            RUN VALUE(cFile) NO-ERROR.
        END.
        WHEN "s":U THEN  /* Set the site number */
        DO:
          RUN setSiteNumber IN THIS-PROCEDURE.
        END.                                                  
      END.
      IF ERROR-STATUS:ERROR THEN 
      DO:
        ERROR-STATUS:ERROR = NO.
        lError = YES.
        IF RETURN-VALUE <> ? AND
           RETURN-VALUE <> "":U THEN
          cMessage = RETURN-VALUE.

      END.
      IF LAST-OF(bttPatchList.cPatchLevel) THEN
        showStatus(SUBSTITUTE("Completed updating database &1 to level &2",bttPatchList.cPatchDB,bttPatchList.cPatchLevel)).
    END.

    IF lError THEN
    DO:
      IF NOT bttPatchList.lUpdateMandatory THEN
        showStatus("WARNING: " + cMessage).
      ELSE
      DO:
        showStatus("ERROR: " + cMessage).
        RETURN ERROR cMessage.
      END.
    END.

    ASSIGN
      bttPatchList.lApplied = YES
    .
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cDB + "_does_not_exist":U,
                       "NO":U).
    END.
    ELSE
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       cDB + "_does_not_exist":U,
                       "YES":U).
    END.
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
  DEFINE VARIABLE hWin         AS HANDLE   NO-UNDO.
  DEFINE VARIABLE iWinWidth    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iWinHeight   AS INTEGER  NO-UNDO.

  DEFINE BUFFER bttButton FOR ttButton.

  CREATE WIDGET-POOL gcPageName PERSISTENT.

  /* Get the window width and height in characters */
  RUN getFrameHandle IN ghCurrPage (OUTPUT ghCurrFrame).
  ASSIGN
      hWin = ghParentFrame:WINDOW
      iWinWidth = hWin:WIDTH-CHARS
      iWinHeight = hWin:HEIGHT-CHARS.
  FOR EACH bttButton 
    WHERE bttButton.iPageNo = piPageNo
    BY bttButton.iPageNo
    BY bttButton.cButtonJustify
    BY bttButton.iButtonNo:
    iBtnWidth = LENGTH(bttButton.cButtonLabel,"COL":U) + 2.
    IF iBtnWidth < 15 THEN
        iBtnWidth = 15.
    CASE bttButton.cButtonJustify:
      WHEN "A":U THEN
          iLeft = iLeft + iBtnWidth + 2.
      WHEN "B":U THEN
          iCenter = iCenter + iBtnWidth + 2.
      WHEN "C":U THEN
          iRight = iRight + iBtnWidth + 2.
    END CASE.
  END.

  ASSIGN
      iStartLeft = 3
      iStartRight = iWinWidth - iRight
      iStartCenter = (iWinWidth - iCenter) / 2.


  FOR EACH bttButton 
    WHERE bttButton.iPageNo = piPageNo
    BY bttButton.iPageNo
    BY bttButton.cButtonJustify
    BY bttButton.iButtonNo:
    iBtnWidth = LENGTH(bttButton.cButtonLabel,"COL":U) + 2.
    IF iBtnWidth < 15 THEN
        iBtnWidth = 15.
    CASE bttButton.cButtonJustify:
      WHEN "A":U THEN
        ASSIGN
          iBtnPos = iStartLeft.
      WHEN "B":U THEN
        ASSIGN
          iBtnPos = iStartCenter.
      WHEN "C":U THEN
        ASSIGN
          iBtnPos = iStartRight.
    END CASE.

    CREATE BUTTON hButton IN WIDGET-POOL gcPageName
      ASSIGN
/*        DEFAULT       = bttButton.cDefault = "YES":U
        AUTO-GO       = bttButton.cDefault = "YES":U */
        NAME          = bttButton.cButtonName
        LABEL         = bttButton.cButtonLabel
        /*
        X             = iBtnPos
        Y             = 332
        WIDTH-PIXELS  = iBtnWidth
        HEIGHT-PIXELS = 24
        */
        ROW           = iWinHeight - .15
        COL           = iBtnPos
        WIDTH-CHARS   = iBtnWidth
        FRAME         = phFrame
        SENSITIVE     = TRUE
        VISIBLE       = TRUE
        HIDDEN        = FALSE
        TRIGGERS:
          ON CHOOSE
            PERSISTENT RUN btnChoose IN THIS-PROCEDURE.
        END TRIGGERS.

        CASE bttButton.cButtonJustify:
          WHEN "A":U THEN
            ASSIGN
              iStartLeft = iStartLeft + hButton:WIDTH-CHARS + 2.
          WHEN "B":U THEN
            ASSIGN
              iStartCenter = iStartCenter + hButton:WIDTH-CHARS + 2.
          WHEN "C":U THEN
            ASSIGN
              iStartRight = iStartRight + hButton:WIDTH-CHARS + 2.
        END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DCU_WriteLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_WriteLog Procedure 
PROCEDURE DCU_WriteLog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcStatus AS CHARACTER  NO-UNDO.

  IF glStreamOpen THEN
  DO:
    pcStatus = "[":U + STRING(TODAY,"99/99/9999":U) + " ":U + STRING(TIME,"HH:MM:SS":U) + "]  ":U
            + pcStatus.
    PUT STREAM sLogFile UNFORMATTED
      pcStatus SKIP.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decidePatchList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE decidePatchList Procedure 
PROCEDURE decidePatchList :
/*------------------------------------------------------------------------------
  Purpose:     This procedure reads the contents of the ttPatchList table and
               adds ryt_dbupdate_status records that may be needed to update
               the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDBsToSetup AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrDB     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBuildNew   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPatchList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBuildNew   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDB         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVersion    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDelete     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPatchNo    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttPatches   FOR ttPatches.
  DEFINE BUFFER bttPatchList FOR ttPatchList.
  DEFINE BUFFER bttValue     FOR ttValue.

  /* Get the list of database to set up as this affects the name of the
     page group. */
  cDBsToSetup = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "dbs_to_setup":U).
  IF cDBsToSetup = "":U OR
     cDBsToSetup = ? THEN
    RETURN.

  /* Loop through all the databases that we have to setup. */
  DO iCount = 1 TO NUM-ENTRIES(cDBsToSetup):
    cCurrDB   = ENTRY(iCount,cDBsToSetup).

    /* Get the values we need for this database. */
    cBuildNew  = getFieldValue(cCurrDB, "LoadDBSchema":U).
    cPatchList = getFieldValue(cCurrDB, "PatchList":U).

    IF cBuildNew = "YES":U OR 
       cBuildNew = "TRUE":U THEN
      lBuildNew = YES.
    ELSE
      lBuildNew = NO.

    /* If the patch list is blank or unknown, and we are building a new
       database, make sure we have marked only the last patches as needing 
       to be applied. */
    IF (cPatchList = "":U OR
       cPatchList = ?) AND
       lBuildNew THEN
    DO:
      FOR EACH bttPatches
        WHERE bttPatches.cPatchDB = cCurrDB
          BY bttPatches.cPatchLevel DESCENDING:
        ASSIGN
          bttPatches.lApply = YES
          cPatchNo          = bttPatches.cPatchLevel
        .
        LEAVE.
      END.
    END.

    /* cPatchList contains the SCREEN-VALUE of the selection list
       for the patches to be applied. We need to loop through
       the patch list and make sure that all the records in the 
       bttPatches table are marked to be loaded. */
    DO iCount2 = 1 TO NUM-ENTRIES(cPatchList,CHR(3)).
      cDB      = ENTRY(1,ENTRY(iCount2,cPatchList,CHR(3)),CHR(4)).
      cVersion = ENTRY(2,ENTRY(iCount2,cPatchList,CHR(3)),CHR(4)).
      FIND bttPatches 
        WHERE bttPatches.cPatchDB    = cDB
          AND bttPatches.cPatchLevel = cVersion
        NO-ERROR.
      IF AVAILABLE(bttPatches) THEN
        ASSIGN
          bttPatches.lApply = YES
        .
    END.

    /* Now we know what patches need to be applied, we need to loop through
       and figure out what records are relevant. */
    FOR EACH bttPatches
      WHERE bttPatches.cPatchDB = cCurrDB:
      FOR EACH bttPatchList
        WHERE bttPatchList.cPatchDB    = bttPatches.cPatchDB
          AND bttPatchList.cPatchLevel = bttPatches.cPatchLevel:
        lDelete = NO.
        /* If the bttPatches record is not lApply this record 
           should be deleted */
        IF NOT bttPatches.lApply THEN
          lDelete = YES.

        IF lBuildNew AND 
          NOT lNewDB THEN
          lDelete = YES.

        IF NOT lBuildNew AND
          NOT lExistingDB THEN
          lDelete = YES.

        IF lDelete THEN
          DELETE bttPatchList.
      END.
      /* We're finished with this record. We're not going to use this
         record again at this point, so whack it. */
      DELETE bttPatches.
    END.

    /* If this is an existing database, add a record to the patch list so that 
       we can assign the new site numbers */
    IF NOT lBuildNew AND
       cCurrDB = "ICFDB":U THEN
    DO:
      CREATE ttPatchList.
      ASSIGN
        ttPatchList.iSeq             = 0
        ttPatchList.cPatchDB         = "ICFDB":U
        ttPatchList.cPatchLevel      = "":U
        ttPatchList.cStage           = "":U
        ttPatchList.iUpdateWhen      = 1
        ttPatchList.cFileType        = "s":U
        ttPatchList.cFileName        = "":U
        ttPatchList.cDescription     = "Applying sequences to ICFDB":U
        ttPatchList.lRerunnable      = YES
        ttPatchList.lNewDB           = NO
        ttPatchList.lExistingDB      = YES
        ttPatchList.lUpdateMandatory = YES
        ttPatchList.lApplied         = NO
      .
    END.
  END.

  /* For testing... 
  OUTPUT TO patchlist.log.
  FOR EACH ttPatchList:
    EXPORT ttPatchList.
  END.
  OUTPUT CLOSE.
  */
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
        DO:
          PUBLISH "DCU_Quit":U.
        END.
        ELSE
          RETURN.
      END.
      WHEN "FINISH":U THEN
        PUBLISH "DCU_Quit":U.
      OTHERWISE
      DO:
        CASE bttAction.cActionTarget:
          WHEN "CONTAINER":U THEN
            hProc = ghSourceProc.
          WHEN "FRAME":U THEN
            hProc = ghCurrPage.
          WHEN "":U THEN
            hProc = THIS-PROCEDURE.
          OTHERWISE
            hProc = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                     bttAction.cActionTarget).
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
  
  /* Set up the Window title for the window */
  gcWindowTitle = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "window_title":U).
  IF gcWindowTitle = ? OR
     gcWindowTitle = "":U THEN
    gcWindowTitle = "Progress Dynamics Configuration Utility":U.

  SUBSCRIBE TO "DCU_WriteLog":U ANYWHERE.

 /* This is just here for debugging purposes. 
  OUTPUT TO initialize.log.
  FOR EACH ttPatchList:
    EXPORT ttPatchList.
  END.
  OUTPUT CLOSE.
 */

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
        cValue = DYNAMIC-FUNCTION("expandTokens":U IN THIS-PROCEDURE,
                                  cValue).
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

  DEFINE BUFFER bttPatchList FOR ttPatchList.
  DEFINE BUFFER bttPatches   FOR ttPatches.

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
    /* If the name of this node is "setup" and the setuptype attribute matches the
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

  /* Make sure each patchlist record has the correct iUpdateWhen set */
  FOR EACH bttPatchList:
    bttPatchList.iUpdateWhen = LOOKUP(bttPatchList.cStage,
     "PreDelta,Delta,PostDelta,PreDataLoad,DataLoad,PostDataLoad,PreADOLoad,ADOLoad,PostADOLoad":U).

    /* Check to see if there is an existing patch record for this patch level.
       If not, create it */
    FIND bttPatches
      WHERE bttPatches.cPatchDB    = bttPatchList.cPatchDB
        AND bttPatches.cPatchLevel = bttPatchList.cPatchLevel
      NO-ERROR.
    IF NOT AVAILABLE(bttPatches) THEN
    DO:
      CREATE bttPatches.
      ASSIGN
        bttPatches.cPatchDB    = bttPatchList.cPatchDB
        bttPatches.cPatchLevel = bttPatchList.cPatchLevel
        bttPatches.lApply      = NO
      .
    END.
  END.

  /* Now make sure that the button justification has the right codes in it */
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

&IF DEFINED(EXCLUDE-obtainICFSeqVals) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainICFSeqVals Procedure 
PROCEDURE obtainICFSeqVals :
/*------------------------------------------------------------------------------
  Purpose:     Obtains the sequence values for the ICFDB database
               and populates the UI with the data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcInput AS CHARACTER  NO-UNDO. /* not used */

DEFINE VARIABLE iSite AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSess AS INTEGER    NO-UNDO.

RUN install/prc/inicfdbgetseqp.p
  (OUTPUT iSite,
   OUTPUT iObj1,
   OUTPUT iObj2,
   OUTPUT iSess).

DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_site":U,
                 STRING(iSite)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_seq1":U,
                 STRING(iObj1)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_seq2":U,
                 STRING(iObj2)).
DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                 "icfdb_sess":U,
                 STRING(iSess)).

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
  DEFINE VARIABLE iLastVersion AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iMinVersion  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPatchList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hControl     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iWidth       AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttPatches FOR ttPatches.

  cDB          = ENTRY(1,pcParams).
  cControl     = IF NUM-ENTRIES(pcParams) > 1 THEN ENTRY(2,pcParams) ELSE "":U.
  iLastVersion = INTEGER(obtainDBVersion(cDB)).
  hControl     = getWidgetHandle(cControl).

  IF NOT VALID-HANDLE(hControl) THEN
    RETURN.

  /* Get the minimum DB version that we support to figure out if we can
     support it */
  iMinVersion = INTEGER(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                         "minimum_":U + cDB + "_version":U)).

  /* If this database is not greater than the minimum version number */
  IF iLastVersion = ? OR
     iMinVersion = ? OR
     iMinVersion > iLastVersion THEN
  DO:
    messageBox("MSG_invalid_dbversion":U,
               cDB + ",":U + STRING(iLastVersion, "999999":U) + ",":U + STRING(iMinVersion, "999999":U),
               "MB_OK,MB_ICONSTOP,MB_TASKMODAL":U).
    RETURN.
  END.


  hControl:LIST-ITEM-PAIRS = hControl:LIST-ITEM-PAIRS.
  hControl:DELIMITER = CHR(3).

  FOR EACH bttPatches
    WHERE bttPatches.cPatchDB = cDB
      AND INTEGER(bttPatches.cPatchLevel) > iLastVersion:
    hControl:ADD-LAST(bttPatches.cPatchDB + bttPatches.cPatchLevel,
                      bttPatches.cPatchDB + CHR(4) + bttPatches.cPatchLevel).
    cPatchList = cPatchList 
               + (IF cPatchList = "":U THEN "":U ELSE CHR(3))
               + bttPatches.cPatchDB + CHR(4) + bttPatches.cPatchLevel.
END.
  hControl:SCREEN-VALUE = cPatchList.
    
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
  DEFINE VARIABLE lBuild     AS LOGICAL    NO-UNDO.
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
            lBuild = hControl:SCREEN-VALUE = "YES":U.
          WHEN 4 THEN
            cDBFile = hControl:SCREEN-VALUE.
          WHEN 5 THEN
            cConnParm = hControl:SCREEN-VALUE.
        END CASE.
      END.
    END CASE.
  END.

  IF lCreate THEN
  DO:
    lBuild = YES.
    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     "load":U + cLogicalDB,
                     "YES":U).
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
      cDbFilename = REPLACE(cDbFile,"/":U,"~\":U)
      cDbPAth     = SUBSTRING(cDbFilename,1,R-INDEX(cDbFilename,"~\":U) - 1)
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
      iCount = messageBox("MSG_confirm_overwrite":U, cDBPath,"MB_YESNO,MB_ICONQUESTION,MB_TASKMODAL":U).
      lOK = iCount = {&IDYES}.
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
        messageBox("MSG_DB_creation_failed,NO)", cError,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
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
    messageBox("MSG_register_service":U, RETURN-VALUE,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
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
  DEFINE INPUT  PARAMETER pcInput AS CHARACTER  NO-UNDO. /* Not used */

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

  /* Add the patches that have to be applied to the ryt_dbupdate_status
     table in the ICFDB database */
  RUN decidePatchList.

  /* Open the log file and put everything in there as we go */
  OUTPUT STREAM sLogFile TO dcu.log UNBUFFERED.  
  glStreamOpen = YES.
  PUBLISH "DCU_StartStatus":U.
  RUN applyUpgrade NO-ERROR.
  PUBLISH "DCU_EndStatus":U.
  glStreamOpen = NO.
  OUTPUT STREAM sLogFile CLOSE.

  IF ERROR-STATUS:ERROR OR 
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN
  DO:
    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     "errorCondition":U,
                     "YES":U).
    RETURN.
  END.

  /* Now write the contents of the patch list to the user's repository */
  RUN install/prc/inrytupdstatp.p (INPUT TABLE ttPatchList).
  
    

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
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGroupType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrAttrib AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcStack) > 1 THEN
    cGroupType = ENTRY(NUM-ENTRIES(pcStack) - 1,pcStack).

  IF NUM-ENTRIES(pcStack) = 2 AND
     cGroupType = "patches":U THEN
  DO:
    cRecordType = "patches":U.
    setNode("RecordType":U,cRecordType,2,NO).
  END.


  /* If we're at the top of the stack, put the name in the node table */
  IF NUM-ENTRIES(pcStack) = 1 THEN
    setNode("SetupType":U,pcStack,NUM-ENTRIES(pcStack),NO).

  /* If we're on level 3 we're going into a page node. */
  IF NUM-ENTRIES(pcStack) = 3 THEN
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

    /* Loop through all the attributes on the node and set
       a property for the element */
    DO iCount2 = 1 TO NUM-ENTRIES(hNode:ATTRIBUTE-NAMES):
      cCurrAttrib = ENTRY(iCount2, hNode:ATTRIBUTE-NAMES).
      setNode(cCurrAttrib, hNode:GET-ATTRIBUTE(cCurrAttrib),NUM-ENTRIES(pcStack),NO).
    END.
    
    /* If the text has nothing in it, skip it */
    IF hNode:SUBTYPE = "TEXT":U THEN
    DO:
      cTest = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
      cTest = REPLACE(cTest, CHR(13), "":U).
      cTest = TRIM(cTest).
      IF cTest = "" THEN
        NEXT.
    END.

    /* When we hit level 4, we know what kind of records these are,
       and we need to make sure that they get appropriately set. */
    IF NUM-ENTRIES(pcStack) = 4 THEN
    DO:
      IF cGroupType <> "patches":U THEN
      DO:
        cRecordType = ENTRY(1,pcStack).
        setNode("RecordType":U,cRecordType,NUM-ENTRIES(pcStack),NO).
      END.
    END.

    /* Set a node value for this node */
    IF hNode:SUBTYPE = "TEXT":U THEN
      setNode(ENTRY(1,pcStack),hNode:NODE-VALUE,NUM-ENTRIES(pcStack),YES).

    /* Go down lower if need be */
    RUN recurseNodes(hNode,hNode:NAME + ",":U + pcStack).

    
    /* If this is level 3 on the stack, we can write out this data
       to the appropriate files */
    cRecordType = getNode("RecordType":U).
    IF NUM-ENTRIES(pcStack) = 4 AND
       cGroupType = "patches":U THEN
      writeNode("patch":U,NUM-ENTRIES(pcStack)).

    IF NUM-ENTRIES(pcStack) = 3 AND
       CAN-DO("button,action,field":U, cRecordType) THEN
      writeNode(cRecordType,NUM-ENTRIES(pcStack)).
    IF NUM-ENTRIES(pcStack) = 2 AND
       cGroupType <> "patches":U THEN
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

&IF DEFINED(EXCLUDE-setSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSiteNumber Procedure 
PROCEDURE setSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     Sets the site number and sequence numbers in the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE iSite AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj1 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iObj2 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSess AS INTEGER    NO-UNDO.


iSite = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                         "icfdb_site":U).
iObj1 = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                         "icfdb_seq1":U).
iObj2 = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                         "icfdb_seq2":U).
iSess = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                         "icfdb_sess":U).

RUN install/prc/inicfdbsetseqp.p
  (INPUT iSite,
   INPUT iObj1,
   INPUT iObj2,
   INPUT iSess).


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
  Parameters:  
    pcParamString - 2 entries separated by comma
      entry 1 - name of widget to be tested
      entry 2 - YES/TRUE (optional) indicates whether a blank file name
                is permitted. Default is no/false.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParamString AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hWidget   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOutDir   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iResult   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cWidget   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBlank    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBlank    AS LOGICAL    NO-UNDO.

  cWidget = ENTRY(1,pcParamString).
  IF NUM-ENTRIES(pcParamString) > 1 THEN
    ASSIGN
      cBlank = ENTRY(2,pcParamString)
      lBlank = CAN-DO("YES,TRUE":U,cBlank)
    .
  ELSE
    lBlank = NO.

  hWidget = getWidgetHandle(cWidget).

  IF NOT VALID-HANDLE(hWidget) THEN
    RETURN.

  cPath = hWidget:SCREEN-VALUE.

  IF (lBlank = NO AND
      cPath = "":U) OR 
     cPath = ? THEN
  DO:
    messageBox("MSG_blank_path":U, hWidget:LABEL,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR "MSG_blank_path":U.
  END.
  ELSE IF cPath = "":U THEN
    cPath = ".":U.

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

&IF DEFINED(EXCLUDE-deriveDBTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deriveDBTable Procedure 
FUNCTION deriveDBTable RETURNS CHARACTER
  ( INPUT pcDBName AS CHARACTER,
    INPUT pcFile   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   This procedure extracts the name of a dump file from the
             file name that comes in as an input parameter and converts 
             tries to find the database table that the dump file is for.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDump   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns    AS LOGICAL    NO-UNDO.

  cRetVal = ?.

  /* Extract the dump name from the file. */
  cDump = REPLACE(pcFile,"~\":U,"/":U).
  cDump = ENTRY(NUM-ENTRIES(pcFile,"/":U),pcFile,"/":U).
  IF SUBSTRING(cDump,LENGTH(cDump) - 1) = ".d":U THEN
    cDump = SUBSTRING(cDump,1,LENGTH(cDump) - 2).

  /* Construct the string version of the database table we want to work with */
  cTable = pcDBName + (IF pcDBName <> "":U THEN ".":U ELSE "":U)
         + "_File".

  CREATE BUFFER hBuffer FOR TABLE cTable.

  cWhere = "WHERE _Dump-name = ":U + TRIM(QUOTER(cDump)) NO-ERROR.
  lAns = hBuffer:FIND-UNIQUE(cWhere, NO-LOCK).
  IF NOT lAns OR
     NOT hBuffer:AVAILABLE THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    cWhere = "WHERE _Dump-name = ":U + TRIM(QUOTER(cDump + ".d":U)) NO-ERROR.
    lAns = hBuffer:FIND-UNIQUE(cWhere, NO-LOCK).
  END.

  IF hBuffer:AVAILABLE THEN
  DO:
    cRetVal = hBuffer:BUFFER-FIELD("_File-name":U):BUFFER-VALUE.
    hBuffer:BUFFER-RELEASE().
  END.

  DELETE OBJECT hBuffer.
  hBuffer = ?.
  ERROR-STATUS:ERROR = NO.

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

&IF DEFINED(EXCLUDE-formatMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatMessage Procedure 
FUNCTION formatMessage RETURNS CHARACTER
  ( INPUT pcMessage AS CHARACTER,
    INPUT pcTokens  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains a message from a property and re-formats.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

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
    cMessage = cMessage + " (" + ENTRY(1,pcMessage) + ")".
  END.
  
  RETURN cMessage.   /* Function return value. */

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

  cMessage = formatMessage(pcMessage,pcTokens).

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

&IF DEFINED(EXCLUDE-obtainDBVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainDBVersion Procedure 
FUNCTION obtainDBVersion RETURNS CHARACTER
  ( INPUT pclDBName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the version number from the database sequences.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hVersion AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQuery   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVersion AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns     AS LOGICAL    NO-UNDO.

  lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                          pclDBName).

  IF NOT lAns THEN
    RETURN ?.

  /* Create a buffer on the sequence table */
  CREATE BUFFER hBuffer FOR TABLE pclDBName + "._sequence":U.

  /* We're only concerned with the value in the _seq-max field as this
     comes from the delta file. */
  hVersion = hBuffer:BUFFER-FIELD("_seq-max":U).

  /* We need to find a record with the sequence name seq_<dbname>_DBVersion */
  cQuery = "WHERE _Sequence._Seq-name = 'seq_":U 
         + pclDBName 
         + "_DBVersion'":U.
  
  hBuffer:FIND-FIRST(cQuery, NO-LOCK) NO-ERROR.
  IF ERROR-STATUS:ERROR OR
     ERROR-STATUS:NUM-MESSAGES > 0 THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    cVersion = "000000":U.
  END.
  ELSE
    cVersion = STRING(hVersion:BUFFER-VALUE,"999999":U).

  /* Release the record and delete the buffer object */
  hBuffer:BUFFER-RELEASE().
  DELETE OBJECT hBuffer.
  hBuffer = ?.

  RETURN cVersion.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showStatus Procedure 
FUNCTION showStatus RETURNS LOGICAL
  ( INPUT pcStatus AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  PUBLISH "DCU_SetStatus":U FROM THIS-PROCEDURE (INPUT pcStatus).

  RUN DCU_WriteLog(pcStatus).

  RETURN FALSE.   /* Function return value. */

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
    WHEN "patch":U THEN
      hBuffer = BUFFER ttPatchList:HANDLE.
    OTHERWISE 
      RETURN FALSE.
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

  IF phBuffer:NAME <> "ttPatchList":U THEN
  DO:
    iPageNo = INTEGER(getNode("PageNo":U)).

    hPageNo = phBuffer:BUFFER-FIELD("iPageNo":U).
  END.

  CASE phBuffer:NAME:
    WHEN "ttPage":U THEN
    DO:
      hKeyField = ?.
    END.
    WHEN "ttPatchList":U THEN
    DO:
      hKeyField = phBuffer:BUFFER-FIELD("iSeq":U).
    END.
    OTHERWISE
      hKeyField = phBuffer:BUFFER-FIELD("i":U + SUBSTRING(phBuffer:NAME,3) + "No":U).
  END.

  /* Go into a transaction */
  DO TRANSACTION:
    /* Create a record */
    phBuffer:BUFFER-CREATE().

    giRecNo = giRecNo + 1.
    IF VALID-HANDLE(hPageNo) THEN
      hPageNo:BUFFER-VALUE = iPageNo.
    IF VALID-HANDLE(hKeyField) THEN
      hKeyField:BUFFER-VALUE = giRecNo.

    /* Loop through the records in the ttNode table that are not 
       either RecordType or SessionType properties.*/
    FOR EACH ttNode
      WHERE NOT CAN-DO("RecordType,SetupType,PageNo":U,ttNode.cNode):
      
      /* Get the handle to a field in the TEMP-TABLE that has 
         the name of this node. If we find
         it we set its value */
      hCurrField = phBuffer:BUFFER-FIELD("c":U + ttNode.cNode) NO-ERROR.
      IF NOT VALID-HANDLE(hCurrField) THEN
        hCurrField = phBuffer:BUFFER-FIELD("l":U + ttNode.cNode) NO-ERROR.
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

