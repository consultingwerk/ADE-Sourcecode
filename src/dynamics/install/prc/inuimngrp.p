&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
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
/*---------------------------------------------------------------------------------
  File: inuimngrp.p

  Description:  DCU User Interface Manager

  Purpose:      This procedure contains all the code that is used to manage the user interface
                in the DCU

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/07/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       inuimngrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{install/inc/indcuglob.i}
{install/inc/inupgrdtt.i}
/* Install Windows API constants */
{install/inc/inwinapiconst.i}

DEFINE VARIABLE gcWindowTitle  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghSaxParser    AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghSourceProc   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghParentFrame  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghCurrPage     AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcPageName     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ghCurrFrame    AS HANDLE     NO-UNDO.

DEFINE VARIABLE glRTBConnected AS LOGICAL    NO-UNDO.

DEFINE TEMP-TABLE ttSetup NO-UNDO RCODE-INFORMATION
  FIELD dSetupObj        AS DECIMAL      LABEL "dNodeNo":U
  FIELD cSetupType       AS CHARACTER    LABEL "SetupType":U
  FIELD cImageLowRes     AS CHARACTER    LABEL "ImageLowRes":U
  FIELD cImageHiRes      AS CHARACTER    LABEL "ImageHiRes":U
  FIELD cImage256Res     AS CHARACTER    LABEL "Image256Res":U
  FIELD cImageFile       AS CHARACTER    LABEL "ImageFile":U
  FIELD cIconFile        AS CHARACTER    LABEL "IconFile":U
  FIELD cStartPage       AS CHARACTER    LABEL "StartPage":U
  FIELD cSkipButtons     AS CHARACTER    LABEL "SkipButtons":U
  FIELD cVersionNo       AS CHARACTER    LABEL "VersionNo":U
  FIELD cWindowTitle     AS CHARACTER    LABEL "WindowTitle":U
  FIELD dParentObj       AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dSetupObj
  .

DEFINE TEMP-TABLE ttMessage NO-UNDO RCODE-INFORMATION
  FIELD dMessageObj      AS DECIMAL     LABEL "dNodeNo":U 
  FIELD cMessageCode     AS CHARACTER   LABEL "MessageCode":U
  FIELD cMessageDesc     AS CHARACTER   LABEL "MessageDesc":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dMessageObj
  INDEX udx
    dParentObj
    dMessageObj
  INDEX dx01
    cMessageCode
  .

DEFINE TEMP-TABLE ttRegistryKey NO-UNDO RCODE-INFORMATION
  FIELD dRegistryKeyObj  AS DECIMAL     LABEL "dNodeNo":U
  FIELD cKeyName         AS CHARACTER   LABEL "KeyName":U
  FIELD cKeyValue        AS CHARACTER   LABEL "KeyValue":U
  FIELD lExpandTokens    AS LOGICAL     LABEL "ExpandTokens":U
  FIELD dParentObj       AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dRegistryKeyObj
  INDEX udx
    dParentObj
    dRegistryKeyObj
  .

DEFINE TEMP-TABLE ttPath NO-UNDO RCODE-INFORMATION
  FIELD dPathObj         AS DECIMAL     LABEL "dNodeNo":U
  FIELD cPathName        AS CHARACTER   LABEL "PathName":U
  FIELD cPathValue       AS CHARACTER   LABEL "PathValue":U
  FIELD lExpandTokens    AS LOGICAL     LABEL "ExpandTokens":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dPathObj
  INDEX udx
    dParentObj
    dPathObj
  .


DEFINE TEMP-TABLE ttPage NO-UNDO RCODE-INFORMATION
  FIELD dPageObj        AS DECIMAL      LABEL "dNodeNo":U
  FIELD cName           AS CHARACTER    LABEL "Name":U
  FIELD cGroup          AS CHARACTER    LABEL "Group":U
  FIELD cTitle          AS CHARACTER    LABEL "Title":U
  FIELD cProc           AS CHARACTER    LABEL "Proc":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  FIELD cImageLowRes    AS CHARACTER   LABEL "ImageLowRes":U
  FIELD cImageHiRes     AS CHARACTER   LABEL "ImageHiRes":U
  FIELD cImage256Res    AS CHARACTER   LABEL "Image256Res":U
  FIELD cImageFile      AS CHARACTER   LABEL "ImageFile":U
  INDEX pudx IS UNIQUE PRIMARY
    dPageObj
  INDEX udx
    dParentObj
    dPageObj
  INDEX udxPageName 
    cName
  INDEX dx01
    cGroup
    dPageObj
  .

DEFINE TEMP-TABLE ttControl NO-UNDO RCODE-INFORMATION
  FIELD dControlObj     AS DECIMAL      LABEL "dNodeNo":U
  FIELD cType           AS CHARACTER    LABEL "Type":U
  FIELD cDataType       AS CHARACTER    LABEL "DataType":U
  FIELD lPanel          AS LOGICAL      LABEL "Panel":U
  FIELD cName           AS CHARACTER    LABEL "Name":U
  FIELD cLabel          AS CHARACTER    LABEL "Label":U
  FIELD cJustify        AS CHARACTER    LABEL "Justify":U
  FIELD lDefault        AS LOGICAL      LABEL "Default":U
  FIELD cDefaultValue   AS CHARACTER    LABEL "DefaultValue":U
  FIELD cTableVariable  AS CHARACTER    LABEL "TableVariable":U
  FIELD lSiteData       AS LOGICAL      LABEL "SiteData":U
  FIELD cStoreTo        AS CHARACTER    LABEL "StoreTo":U
  FIELD cFieldValue     AS CHARACTER    LABEL "FieldValue":U
  FIELD lExpandTokens    AS LOGICAL     LABEL "ExpandTokens":U
  FIELD lHidden         AS LOGICAL      LABEL "Hidden":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dControlObj
  INDEX udx
    dParentObj
    dControlObj
  INDEX dx01 
    lPanel
  INDEX dx02
    cType
  .

DEFINE TEMP-TABLE ttAction NO-UNDO RCODE-INFORMATION
  FIELD dActionObj      AS DECIMAL      LABEL "dNodeNo":U
  FIELD cEvent          AS CHARACTER    LABEL "Event":U
  FIELD cAction         AS CHARACTER    LABEL "Action":U
  FIELD cActionParam    AS CHARACTER    LABEL "ActionParam":U
  FIELD cActionTarget   AS CHARACTER    LABEL "ActionTarget":U
  FIELD dParentObj      AS DECIMAL      LABEL "dParent":U
  INDEX pudx IS UNIQUE PRIMARY
    dActionObj
  INDEX udx 
    dParentObj
    dActionObj
  .

DEFINE TEMP-TABLE ttWidget NO-UNDO
  FIELD cWidgetName AS CHARACTER
  FIELD hHandle     AS HANDLE
  INDEX pudx IS UNIQUE PRIMARY
    cWidgetName
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

&IF DEFINED(EXCLUDE-setImageFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImageFiles Procedure 
FUNCTION setImageFiles RETURNS LOGICAL
  (INPUT pcImageLowRes AS CHARACTER,
   INPUT pcImageHiRes  AS CHARACTER,
   INPUT pcImage256Res AS CHARACTER,
   INPUT pcImageFile   AS CHARACTER)  FORWARD.

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
         HEIGHT             = 34
         WIDTH              = 68.2.
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

glRTBConnected = DYNAMIC-FUNCTION('isConnected':U, "RTB":U).

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
  RUN eventProc ("CHOOSE":U,SELF:NAME) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    messageBox(RETURN-VALUE,"":U,"MB_OK,MB_ICONWARNING":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkForDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkForDB Procedure 
PROCEDURE checkForDB :
/*------------------------------------------------------------------------------
  Purpose:     Checks to see if the databases exist and if they do, sets
               the following properties:
               1) connect_params_<dbname> - connection parameters for the 
                                            database derived from the database
                                            node.
               2) <dbname>_exists         - Indicates if the database exists
                                            on disk.
               3) <dbname>_does_not_exist - Indicates the opposite of 
                                            <dbname>_exists
  Parameters:  
    pcDBToCheck - The database name to check.
  Notes:       The reason that properties 2 and 3 both get set is that it is 
               not possible to "NOT" a property and have the token expanded.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDBToCheck  AS CHARACTER  NO-UNDO. 

  DEFINE VARIABLE cDBPath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDatabaseConnected  AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER bttDatabase FOR ttDatabase.

  /* Loop through the database list and check to see if the database already
     exists on disk */
  FIND FIRST bttDatabase
    WHERE bttDatabase.cDBName = pcDBToCheck
    NO-ERROR.
  IF AVAILABLE(bttDatabase) THEN
  DO:    
    ASSIGN lDatabaseConnected = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE, pcDBToCheck). 
    
    IF lDatabaseConnected AND 
       glRTBConnected THEN 
    DO:
      cDBPath = PDBNAME(pcDBToCheck).     
      /* Set the database physical name session paramater so that this is shown in the UI as well */
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "path_db_":U + LC(bttDatabase.cDBName), cDBPath).      
      /* Clear the connection parameters as we do not need these if the database is connected already . 
         We cannot get these from the connected database - otherwise we could set these 
         correctly to be shown in the UI as well. 
      */
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "connect_params_":U + LC(bttDatabase.cDBName), 
                       "# Database already connected through SCM tool." + "~n":U + 
                       "# Existing connection will be used.":U).                               
    END.
    ELSE 
    DO:
      cDBPath = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "path_db_":U + LC(bttDatabase.cDBName)).
                                 
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "connect_params_":U + LC(bttDatabase.cDBName),
                       bttDatabase.cConnectParams).    
    END.

    IF cDBPath <> "":U AND
       cDBPath <> ? AND
       SEARCH(cDBPath) <> ? OR 
       /* Database is already connected - which it would be from the SCM tool - 
          we should use this connection */
       (lDatabaseConnected AND glRTBConnected) THEN
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       LC(bttDatabase.cDBName) + "_does_not_exist":U,
                       "NO":U).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       LC(bttDatabase.cDBName) + "_exists":U,
                       "YES":U).
    END.
    ELSE
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       LC(bttDatabase.cDBName) + "_does_not_exist":U,
                       "YES":U).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       LC(bttDatabase.cDBName) + "_exists":U,
                       "NO":U).
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

&IF DEFINED(EXCLUDE-connectDatabase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectDatabase Procedure 
PROCEDURE connectDatabase :
/*------------------------------------------------------------------------------
  Purpose:     Confirms that the database is available and can be connected
               and registers the connection with the connection manager.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDBName AS CHARACTER  NO-UNDO.

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

  cLogicalDB = pcDBName.
    cDBFile    = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "path_db_":U + cLogicalDB).
    lCreate = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                       "db_create_":U + cLogicalDB)).
    lBuild  = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                       "db_build_":U + cLogicalDB)).
    cConnParm = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "connect_params_":U + cLogicalDB).
  
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

  IF NOT glRTBConnected THEN DO:
    IF DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                        cLogicalDB) THEN
        RUN disconnectService IN THIS-PROCEDURE 
          (cLogicalDB) NO-ERROR.
  
    ERROR-STATUS:ERROR = NO.
  
    IF lCreate OR
       lBuild  THEN
      RETURN.  
  END.
  ELSE
  /* As we do not want to be creating new databases from the SCM tool, we 
     force the setting of the lCreate and lBuild variables to be FALSE. */
  ASSIGN 
    lCreate = FALSE
    lBuild  = FALSE. 
  
  /* Always register the service - also when the SCM tool is used */
  RUN registerService IN THIS-PROCEDURE (INPUT BUFFER bttService:HANDLE) /* NO-ERROR */.
  IF ERROR-STATUS:ERROR OR 
    (RETURN-VALUE <> "":U AND
     RETURN-VALUE <> ?) THEN
  DO:
    messageBox("MSG_register_service":U, RETURN-VALUE,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).
    RETURN ERROR.
  END.

  /* We only need to connect to the database if we are not running form the SCM tool, 
     as the database will be connected already */
  IF NOT glRTBConnected THEN
  DO:
    RUN connectService IN THIS-PROCEDURE 
      (cLogicalDB, OUTPUT cEntry) /* NO-ERROR*/ .
    IF ERROR-STATUS:ERROR OR 
      (RETURN-VALUE <> "":U AND
       RETURN-VALUE <> ?) THEN
    DO:
      messageBox("MSG_DB_connect_failed,NO":U, RETURN-VALUE,"MB_OK,MB_ICONWARNING,MB_TASKMODAL":U).    
      RETURN ERROR.
    END.  
  END.

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
  DEFINE INPUT  PARAMETER pdPageObj AS DECIMAL   NO-UNDO.
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

  DEFINE BUFFER bttControl FOR ttControl.

  CREATE WIDGET-POOL gcPageName PERSISTENT.

  /* Get the window width and height in characters */
  RUN getFrameHandle IN ghCurrPage (OUTPUT ghCurrFrame).
  ASSIGN
      hWin = ghParentFrame:WINDOW
      iWinWidth = hWin:WIDTH-CHARS
      iWinHeight = hWin:HEIGHT-CHARS.


  FOR EACH bttControl
    WHERE bttControl.dParentObj = pdPageObj
      AND bttControl.cType      = "BUTTON":U
      AND bttControl.lPanel    
    BY bttControl.cJustify
    BY bttControl.dControlObj:
    iBtnWidth = LENGTH(bttControl.cLabel,"COL":U) + 2.
    IF iBtnWidth < 15 THEN
        iBtnWidth = 15.
    CASE bttControl.cJustify:
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


  FOR EACH bttControl
    WHERE bttControl.dParentObj = pdPageObj
      AND bttControl.cType      = "BUTTON":U
      AND bttControl.lPanel    
    BY bttControl.cJustify
    BY bttControl.dControlObj:
    iBtnWidth = LENGTH(bttControl.cLabel,"COL":U) + 2.
    IF iBtnWidth < 15 THEN
        iBtnWidth = 15.
    CASE bttControl.cJustify:
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
        NAME          = bttControl.cName
        LABEL         = bttControl.cLabel
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

    CASE bttControl.cJustify:
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

  DEFINE VARIABLE hProc          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hLastWidget    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLastWidget    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSkipButtons   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRetVal        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dCurrParentObj AS DECIMAL    NO-UNDO.  
  DEFINE VARIABLE cMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAction        AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttSetup   FOR ttSetup.
  DEFINE BUFFER bttAction  FOR ttAction.
  DEFINE BUFFER bttPage    FOR ttPage.
  DEFINE BUFFER bttControl FOR ttControl.

  /* Deal with moving to a button that will cause a close or a quit */
  IF LAST-EVENT:FUNCTION = "WINDOW-CLOSE":U THEN
    RETURN.

  ASSIGN
    hLastWidget = LAST-EVENT:WIDGET-ENTER
  .

  IF VALID-HANDLE(hLastWidget) AND
     hLastWidget:TYPE = "BUTTON":U THEN
  DO:
    FIND FIRST bttSetup.
    cSkipButtons = bttSetup.cSkipButtons.
    ASSIGN
      cLastWidget = hLastWidget:LABEL
      cLastWidget = REPLACE(cLastWidget,"&","")
    .

    IF CAN-DO(cSkipButtons,cLastWidget) THEN
      RETURN.
  END.


  FIND FIRST bttPage
    WHERE bttPage.cName = gcPageName.

  IF pcObject = gcPageName THEN
    dCurrParentObj = bttPage.dPageObj.
  ELSE
  DO:
    FIND FIRST bttControl
      WHERE bttControl.dParentObj = bttPage.dPageObj
        AND bttControl.cName      = pcObject
      NO-ERROR.
    IF AVAILABLE(bttControl) THEN
      dCurrParentObj = bttControl.dControlObj.
    ELSE
      dCurrParentObj = 0.0.
  END.
    
  IF dCurrParentObj <> 0.0 THEN
  DO:
    FOR EACH bttAction 
       WHERE bttAction.dParentObj = dCurrParentObj
         AND bttAction.cEvent  = pcEvent
       BY bttAction.dParentObj
       BY bttAction.cEvent
       BY bttAction.dActionObj:

      CASE SUBSTRING(bttAction.cAction,1,1):
        WHEN ":":U THEN
          cAction = analyzeCase(bttAction.cAction).
        WHEN "?":U THEN
          cAction = analyzeIf(bttAction.cAction).
        OTHERWISE
          cAction = bttAction.cAction.
      END CASE.

      IF cAction = "":U OR
         cAction = ?    THEN
        NEXT.

      CASE cAction:
        WHEN "QUIT":U THEN
        DO:
          iRetVal = messageBox("MSG_confirm_quit":U, 
                               "":U,
                               "MB_YESNO,MB_ICONQUESTION,MB_TASKMODAL":U).
          IF iRetVal = {&IDYES} THEN
          DO:
            PUBLISH "DCU_Cancel":U.
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
          RUN VALUE(cAction) IN hProc
            (INPUT bttAction.cActionParam) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
          DO:
            IF RETURN-VALUE = "":U OR
               RETURN-VALUE = ? THEN
            DO:
              cMessage = ERROR-STATUS:GET-MESSAGE(1).
              IF cMessage = "" THEN
                RETURN ERROR.
              ELSE
                RETURN ERROR cMessage.
            END.
            ELSE
              RETURN ERROR RETURN-VALUE.
          END.
        END.
    
      END CASE.
    END.
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
      lhFolder = lhServer:BrowseForFolder(hWin:HWND,cTitle,0)
    .
  
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
  RUN initializePage(cPage) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeInstall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeInstall Procedure 
PROCEDURE initializeInstall :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the install.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSourceProc  AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phFrame       AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cRegKeyList           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPathList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBPath               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDumpPath             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicsRoot         AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttSetup FOR ttSetup.

  ASSIGN
    ghSourceProc  = phSourceProc
    ghParentFrame = phFrame
  .

  cDynamicsRoot = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "_framework_directory":U).

  cDynamicsRoot = ENTRY(NUM-ENTRIES(cDynamicsRoot,"/":U),cDynamicsRoot,"/":U).
  
  DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                   "dynamics_rootname":U,
                   cDynamicsRoot).

  /* Set up the Window title for the window */
  gcWindowTitle = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                   "window_title":U).
  IF gcWindowTitle = ? OR
     gcWindowTitle = "":U THEN
    gcWindowTitle = "Progress Dynamics Configuration Utility":U.

  PUBLISH "DCU_SetStatus":U ("Parsing User Interface XML File...").
  RUN loadSetupXML NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    messageBox(RETURN-VALUE, 
               "":U ,
               "MB_OK,MB_ICONERROR":U).
    RETURN ERROR RETURN-VALUE.
  END.

  /* Now make sure that the button justification has the right codes in it */
  FOR EACH ttControl
    WHERE ttControl.cType = "BUTTON":U
      AND ttControl.lPanel:
    CASE ttControl.cJustify:
      WHEN "LEFT":U THEN
        ttControl.cJustify = "A":U.
      WHEN "CENTER":U OR
      WHEN "CENTERED":U THEN
        ttControl.cJustify = "B":U.
      WHEN "RIGHT":U THEN
        ttControl.cJustify = "C":U.
    END CASE.
  END.


  /* Now we need to set the image files as appropriate */
  FIND FIRST bttSetup NO-ERROR.
  IF NOT AVAILABLE(bttSetup) THEN
  DO:
    /* If this happens we're hosed. There'll be no data in
       any of the other tables. */
    messageBox("Setup record not found":U,
               "":U ,
               "MB_OK,MB_ICONERROR":U).
    RETURN ERROR "Setup record not found":U.
  END.

  /* Set the icon file to be used for the window */
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "setup_IconFile":U,
                   bttSetup.cIconFile).

  /* Set a property for the version number as this gets used to 
     derive the value of other properties. */
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "VersionNo":U,
                   bttSetup.cVersionNo).

  /* Set the image files for the left panel */
  setImageFiles(bttSetup.cImageLowRes,
                bttSetup.cImageHiRes,
                bttSetup.cImage256Res,
                bttSetup.cImageFile).

 /* Now we need to set up the expansion list. First we obtain the existing
    value of the expansion list. We need to do this because we're about to
    change the whole thing. */
  cExpList = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                            "expand_list":U).

  IF cExpList = ? THEN
    cExpList = "":U.

  /* Build up a string of registry keys that need to be set up. */
  FOR EACH ttRegistryKey
    BY ttRegistryKey.dRegistryKeyObj:
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     ttRegistryKey.cKeyName,
                     ttRegistryKey.cKeyValue).
    IF ttRegistryKey.lExpandTokens THEN
      cRegKeyList = cRegKeyList + MIN(",":U,cRegKeyList) + ttRegistryKey.cKeyName.
  END.

  /* Set the registry_key property - this gets used by obtainRegistryKeys to figure
     out which properties are registry keys. */
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "registry_keys":U,
                   cRegKeyList).
  
  /* Set the registry key list into the expand_list property and run the property
     expander so that if the registry key values are derived from other key values,
     these are resolved now. */
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "expand_list":U,
                   cRegKeyList).
  /* NOTE: This propertyExpander call ONLY expands the registry key values */
  RUN propertyExpander IN TARGET-PROCEDURE.

  /* Now obtain the values for all the registry keys */
  RUN obtainRegistryKeys IN TARGET-PROCEDURE.

  /* Now loop through all the paths and create a property for each one and 
     add it to the path list. */
  FOR EACH ttPath
    BY ttPath.dPathObj:
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     ttPath.cPathName,
                     ttPath.cPathValue).
    IF ttPath.lExpandTokens THEN
      cPathList = cPathList + MIN(",":U,cPathList) + ttPath.cPathName.
  END.

  /* Create a path for each of the database directories */
  FOR EACH ttDatabase
    BY ttDatabase.dDatabaseObj:
    cDBPath = "path_db_":U + LC(ttDatabase.cDBName).
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     cDBPath,
                     ttDatabase.cDBDir).
    cDumpPath = "path_dbdump_":U + LC(ttDatabase.cDBName).
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     cDumpPath,
                     ttDatabase.cPathDump).
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                     "minimum_version_":U + LC(ttDatabase.cDBName),
                     STRING(ttDatabase.iMinimumVersion)).
    cPathList = cPathList + MIN(",":U,cPathList) + cDBPath + ",":U + cDumpPath.
  END.

  /* Set the path_order property which defines the order in which properties 
     should be expanded for paths */
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "path_order":U,
                   cPathList).
  
  /* Add path_order to the expansion list */
  cExpList = "path_order|setupPaths":U + MIN(",":U,cExpList) + cExpList.

  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "expand_list":U,
                   cExpList).

  /* Run the property expander to re-expand all the properties. */
  RUN propertyExpander IN TARGET-PROCEDURE.

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
  FIND FIRST bttPage NO-LOCK
    WHERE bttPage.cName = pcPageName
    NO-ERROR.

  IF AVAILABLE(bttPage) THEN
  DO:
    IF ghCurrPage <> ? THEN 
    DO:
      RUN eventProc ("DESTROY":U, gcPageName) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        RETURN ERROR.
      APPLY "CLOSE":U TO ghCurrPage. /* Apply close to the current frame */
    END.

    /* If the any of the images are set, use the new images */
    IF bttPage.cImageLowRes <> "":U OR
       bttPage.cImageHiRes  <> "":U OR
       bttPage.cImage256Res <> "":U OR
       bttPage.cImageFile   <> "":U THEN
      setImageFiles(bttPage.cImageLowRes,
                    bttPage.cImageHiRes,
                    bttPage.cImage256Res,
                    bttPage.cImageFile).
    
    /* Run the page's procedure */
    RUN VALUE(bttPage.cProc) PERSISTENT SET ghCurrPage.
    ghCurrPage:ADD-SUPER-PROCEDURE(THIS-PROCEDURE).
    gcPageName = bttPage.cName.

    /* Get the frame's handle */
    RUN getFrameHandle IN ghCurrPage
      (OUTPUT ghCurrFrame) .

    /* Set the window title */
    hWin = ghParentFrame:WINDOW.
    hWin:TITLE = gcWindowTitle + (IF bttPage.cTitle = "":U THEN "":U ELSE " - ":U + bttPage.cTitle).

    RUN initializePageObject IN ghCurrPage (bttPage.dPageObj).


  END. /* IF AVAILABLE(ttPage) */
  ELSE
    messageBox("MSG_page_not_found":U,
               pcPageName,
               "MB_OK,MB_ICONERROR":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializePageObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializePageObject Procedure 
PROCEDURE initializePageObject :
/*------------------------------------------------------------------------------
  Purpose:     Does the standard behavior for initializing the page
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdPageObj   AS DECIMAL    NO-UNDO.
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
  RUN createButtons(pdPageObj, ghParentFrame).

  /* Build the widget list */
  EMPTY TEMP-TABLE ttWidget.
  RUN loadWidgets (ghCurrFrame).

  RUN eventProc ("INITIALIZE":U, gcPageName) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    messageBox(RETURN-VALUE,"":U,"MB_OK,MB_ICONWARNING":U).

  /* Load the values of the fields and their labels */
  RUN loadFieldValues(pdPageObj).
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
  DEFINE INPUT PARAMETER pdPageObj AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cValue  AS CHARACTER  NO-UNDO.
  
  DEFINE BUFFER bttControl  FOR ttControl.

  FOR EACH bttControl
    WHERE bttControl.dParentObj = pdPageObj:

    IF bttControl.cFieldValue <> "":U AND
       bttControl.cFieldValue <> ? THEN
    DO:
      cValue = bttControl.cFieldValue.
    END.
    ELSE
    DO:  
      cValue = bttControl.cDefaultValue.
      IF bttControl.lExpandTokens THEN
        cValue = DYNAMIC-FUNCTION("expandTokens":U IN THIS-PROCEDURE,
                                  cValue).
    END. 

    hWidget = getWidgetHandle(bttControl.cName).

    IF VALID-HANDLE(hWidget) THEN
    DO:
      IF bttControl.lHidden AND
         CAN-SET(hWidget,"HIDDEN":U) THEN
      DO:
        hWidget:HIDDEN = YES.
        hWidget:VISIBLE = NO.
        hWidget:SENSITIVE = NO.
      END.
      IF CAN-SET(hWidget,"LABEL":U) AND
         bttControl.cLabel <> "":U THEN
        hWidget:LABEL = bttControl.cLabel.

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
  Purpose:     This procedure loads the XML file specified by the 
               setup_type_file node and loads the data for the setup type 
               specified in the setup_type node.
               
               The data is loaded into the temp-tables that we defined in the
               definitions section.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSetupFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSetupType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRootNode     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSetupNode    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  /* Obtain the setup type and setup file from the session parameters
     that should have been set by the ICFCONFIG file (ICFSETUP.XML) */
  cSetupFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "setup_type_file":U).
  cSetupType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "setup_type":U).

  IF cSetupFile = ? THEN
    cSetupFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "ICFCONFIG":U).

  IF cSetupType = ? THEN
    cSetupType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "ICFSESSTYPE":U).

  /* Make sure that the SAX parser persistent procedure has been started */
  RUN startProcedure
    ("ONCE|install/prc/insaxparserp.p":U, 
     OUTPUT ghSaxParser) NO-ERROR.

  /* We have to return a special message here because we have not loaded the
     message codes from the XML file yet */
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR "DCUSTARTUPERROR: COULD NOT START SAX PARSER":U.

  /* The parser may have been previously started. Make sure it is reset.
     We don't want old data */
  RUN resetParser IN ghSaxParser.

  /* Associate each of the temp-table buffers that we use for the setup with
     the SAX parser. Note that the temp-tables need to have been defined with
     RCODE-INFORMATION so that we can associate the appropriate fields with
     the correct XML nodes. The XML node is defined in the label and the 
     field name is then mapped accordingly */

  /* setup = ttSetup */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "setup":U,                          
                   INPUT BUFFER ttSetup:HANDLE).

  /* message = ttMessage */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "message":U,
                   INPUT BUFFER ttMessage:HANDLE).

  /* registrykey = ttRegistryKey */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "registrykey":U,
                   INPUT BUFFER ttRegistryKey:HANDLE).

  /* path = ttPath */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "path":U,
                   INPUT BUFFER ttPath:HANDLE).

  /* page = ttPage */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "page":U,
                   INPUT BUFFER ttPage:HANDLE).

  /* control = ttControl */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "control":U,
                   INPUT BUFFER ttControl:HANDLE).

  /* action = ttAction */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "action":U,
                   INPUT BUFFER ttAction:HANDLE).

  /* database = ttDatabase */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "database":U,
                   INPUT BUFFER ttDatabase:HANDLE).

  /* patch = ttPatch */
  DYNAMIC-FUNCTION("associateBuffer":U IN ghSaxParser,
                   "patch":U,
                   INPUT BUFFER ttPatch:HANDLE).
  
  /* Now make the parser parse the document into the temp-tables that we
     associated with each node above. */
  RUN parseDocument IN ghSaxParser
    (cSetupFile) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

  /* Make sure the parser has been reset. */
  RUN resetParser IN ghSaxParser.

  /* The SAX parser scans the entire document. We need to make sure that we only 
     have the setup in the tables that we actually need. If the setup file has been
     formatted as suggested (ie, one setup type per file, this code is a no-op */
  FOR EACH ttSetup 
    WHERE ttSetup.cSetupType <> cSetupType:
    FOR EACH ttMessage 
      WHERE ttMessage.dParentObj = ttSetup.dSetupObj:
      DELETE ttMessage.
    END.
    FOR EACH ttPath
      WHERE ttPath.dParentObj = ttSetup.dSetupObj:
      DELETE ttPath.
    END.
    FOR EACH ttRegistryKey
      WHERE ttRegistryKey.dParentObj = ttSetup.dSetupObj:
      DELETE ttRegistryKey.
    END.
    FOR EACH ttPage
      WHERE ttPage.dParentObj = ttSetup.dSetupObj:
      FOR EACH ttAction
        WHERE ttAction.dParentObj = ttPage.dPageObj:
        DELETE ttAction.
      END.
      FOR EACH ttControl
        WHERE ttControl.dParentObj = ttPage.dPageObj:
        FOR EACH ttAction
          WHERE ttAction.dParentObj = ttControl.dControl:
          DELETE ttAction.
        END.
        DELETE ttControl.
      END.
      DELETE ttPage.
    END.
    FOR EACH ttDatabase
      WHERE ttDatabase.dParentObj = ttSetup.dSetupObj:
      FOR EACH ttPatch
        WHERE ttPatch.dParentObj =  ttDatabase.dDatabaseObj:
        DELETE ttPatch.
      END.
      DELETE ttDatabase.
    END.
    DELETE ttSetup.
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
  DEFINE VARIABLE iLastVersion AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPatchList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hControl     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iWidth       AS INTEGER    NO-UNDO.
    
  DEFINE BUFFER bttPatch FOR ttPatch.
  DEFINE BUFFER bttDatabase  FOR ttDatabase.

  cDB          = ENTRY(1,pcParams).
  cControl     = IF NUM-ENTRIES(pcParams) > 1 THEN ENTRY(2,pcParams) ELSE "":U.
  hControl     = getWidgetHandle(cControl).
  IF NOT VALID-HANDLE(hControl) THEN
    RETURN.

  iLastVersion = INTEGER(obtainDBVersion(cDB)).
  
  hControl:LIST-ITEM-PAIRS = hControl:LIST-ITEM-PAIRS.

  FIND FIRST bttDatabase
    WHERE bttDatabase.cDBName = cDB
    NO-ERROR.
  IF AVAILABLE(bttDatabase) THEN
  DO:
    FOR EACH bttPatch
      WHERE bttPatch.dParentObj  = bttDatabase.dDatabaseObj
        AND bttPatch.iPatchLevel > iLastVersion
      BREAK BY bttPatch.iPatchLevel:
      IF FIRST-OF(bttPatch.iPatchLevel) THEN
      DO:
        hControl:ADD-LAST(bttDatabase.cDBName + STRING(bttPatch.iPatchLevel,"999999"),
                          STRING(bttPatch.iPatchLevel)).
        cPatchList = cPatchList 
                   + MIN(cPatchList,",":U)
                   + STRING(bttPatch.iPatchLevel).
      END.
    END.
  END.

  hControl:SCREEN-VALUE = cPatchList.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processParams Procedure 
PROCEDURE processParams :
/*------------------------------------------------------------------------------
  Purpose:     This procedure copies the data from the ttControl records into
               the ttValue table. It also copies the value of all the database
               session parameters into the ttDatabase records.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInput AS CHARACTER  NO-UNDO. /* Not used */

  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cGroups AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPatchList AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttPage     FOR ttPage.
  DEFINE BUFFER bttControl  FOR ttControl.
  DEFINE BUFFER bttValue    FOR ttValue.
  DEFINE BUFFER bttDatabase FOR ttDatabase.
  DEFINE BUFFER bttPatch    FOR ttPatch.

  /* Loop through all the controls and set all of the controls that have
     a TableVariable node to the appropriate value. */
  FOR EACH bttPage,
      EACH bttControl
        WHERE bttControl.dParentObj = bttPage.dPageObj
          AND bttControl.cTableVariable <> "":U:
    FIND FIRST bttValue 
      WHERE bttValue.cGroup    = bttPage.cGroup
        AND bttValue.cVariable = bttControl.cTableVariable
      NO-ERROR.
    IF NOT AVAILABLE(bttValue) THEN
    DO:
      CREATE bttValue.
      ASSIGN
        bttValue.cGroup    = bttPage.cGroup      
        bttValue.cVariable = bttControl.cTableVariable 
      .
    END.
    ASSIGN
      bttValue.cValue = bttControl.cFieldValue
      bttValue.lSiteData = bttControl.lSiteData
    .
  END.

  /* Make sure that all the things we set as properties are now written into the 
     ttDatabase record. */
  FOR EACH bttDatabase:
    bttDatabase.cDBDir = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                          "path_db_":U + bttDatabase.cDBName).
    bttDatabase.cPathDump = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE,
                                             "path_dbdump_":U + LC(bttDatabase.cDBName)).
    bttDatabase.cConnectParams = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                                  "connect_params_":U + bttDatabase.cDBName).
    bttDatabase.lDBCreate = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                             "db_create_":U + bttDatabase.cDBName)).
    bttDatabase.lDBBuild  = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                             "db_build_":U + bttDatabase.cDBName)).
    cPatchList = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                  "patch_list_":U + bttDatabase.cDBName).


    /* Now make sure that we only apply the patches that we need to */
    FOR EACH bttPatch
      WHERE bttPatch.dParentObj = bttDatabase.dDatabaseObj:
      IF CAN-DO(cPatchList,STRING(bttPatch.iPatchLevel)) THEN
        bttPatch.lApply = YES.
      IF bttDatabase.lDBBuild AND
         bttPatch.lDBBuild THEN
        bttPatch.lApply = YES.
      IF NOT bttPatch.lApply THEN
        DELETE bttPatch.
    END.
  END.

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
               ttControl temp-table for this page and stores the value
               from the screen into the ttControl.cFieldValue field.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInput  AS CHARACTER  NO-UNDO. /* not used */

  DEFINE VARIABLE hWidget AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttPage FOR ttPage.
  DEFINE BUFFER bttControl FOR ttControl.

  FIND FIRST bttPage
    WHERE bttPage.cName = gcPageName.

  FOR EACH bttControl
    WHERE bttControl.dParentObj = bttPage.dPageObj:

    hWidget = getWidgetHandle(bttControl.cName).

    IF VALID-HANDLE(hWidget) THEN
    DO:
      CASE hWidget:TYPE:
        WHEN "BROWSE":U OR
        WHEN "BUTTON":U THEN
        DO:
        END.
        OTHERWISE
        DO:
          bttControl.cFieldValue = STRING(hWidget:INPUT-VALUE).
        END.
      END CASE.
    END.
    IF bttControl.cStoreTo <> "":U THEN
    DO:
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       bttControl.cStoreTo,
                       bttControl.cFieldValue).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "::":U + bttControl.cStoreTo,
                       ?).
      RUN propertyExpander.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showStartPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showStartPage Procedure 
PROCEDURE showStartPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttSetup FOR ttSetup.

  /* Now we need to set the image files as appropriate */
  FIND FIRST bttSetup.
  RUN initializePage(bttSetup.cStartPage).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startUpgradeProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startUpgradeProcess Procedure 
PROCEDURE startUpgradeProcess :
/*------------------------------------------------------------------------------
  Purpose:     This procedure kicks off the upgrade process using the upgrade
               API.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEditor  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hUpgradeAPI       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDCUScriptFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDCUSiteDataFile  AS CHARACTER  NO-UNDO.

  /* First lets see if we need to do the actual upgrade, or if we only
     have to write out the XML files */
  cDCUScriptFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "DCUSCRIPTFILE":U).
  cDCUSiteDataFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "DCUSITEDATAFILE":U).

  IF cDCUScriptFile <> ? AND
     cDCUScriptFile <> "":U THEN
  DO:
    RUN writeXMLFiles(cDCUScriptFile, cDCUSiteDataFile) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
    DO:
      messageBox(RETURN-VALUE,
                 "":U,
                 "MB_OK,MB_ICONERROR,MB_TASKMODAL":U).
      DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                       "ErrorCondition":U,
                       "YES":U).
    END.
    RETURN.
  END.



  /* If the upgrade API is not started, start it. */
  RUN startProcedure IN TARGET-PROCEDURE
    ("ONCE|install/prc/inupgrdapip.p":U, 
     OUTPUT hUpgradeAPI)
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

  /* Provide the temp-tables to the upgrade API so that it doesn't need
     to start from scratch */
  RUN pushTempTables IN hUpgradeAPI
    (INPUT TABLE ttValue,
     INPUT TABLE ttDatabase,
     INPUT TABLE ttPatch).

  /* Now apply the upgrade */
  RUN applyUpgrade IN hUpgradeAPI
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    messageBox(RETURN-VALUE,
               "":U,
               "MB_OK,MB_ICONERROR,MB_TASKMODAL":U).
    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     "ErrorCondition":U,
                     "YES":U).
    RETURN.
  END.
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
    RETURN ERROR.
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
        RETURN ERROR.
      END.
    END.
    ELSE
      RETURN ERROR.
  END.

  RETURN "":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verifyDBVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verifyDBVersion Procedure 
PROCEDURE verifyDBVersion :
/*------------------------------------------------------------------------------
  Purpose:     Determines whether the database version of the database being 
               upraded is valid.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcParams AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDB          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLastVersion AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iMinVersion  AS INTEGER    NO-UNDO.
    define variable cMigrationSourceBranch            as character no-undo.

  cDB          = pcParams.
  iLastVersion = INTEGER(obtainDBVersion(cDB)).
  
    /* Get the migration source branch, for migrations */
    cMigrationSourceBranch = {fnarg getSessionParam 'Migration_Source_Branch'}.
    if cMigrationSourceBranch eq ? then cMigrationSourceBranch = '':u.
  
  /* Get the minimum DB version that we support to figure out if we can
     support it */
  iMinVersion = INTEGER(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                         "minimum_version_":U + cDB)).

    /* Migration paths are carefully defined, so the MinimumVerision and
       DBVersion must match exactly for the migration to proceed. */
    if cMigrationSourceBranch gt '':u and
       (iLastVersion ne iMinVersion or
        iLastVersion eq ? or
        iMinVersion eq ? ) then
    do:
        messageBox("MSG_cannot_migrate":U,
                    cDB + ",":U + STRING(iLastVersion, "999999":U) + ",":U + STRING(iMinVersion, "999999":U),
                    "MB_OK,MB_ICONSTOP,MB_TASKMODAL":U).
        return error.
    end.    /* migrating and MinVer <> DBVersion */
    else
  /* If this database is not greater than the minimum version number */
  IF iLastVersion = ? OR
     iMinVersion = ? OR
     iLastVersion < iMinVersion THEN
  DO:
    messageBox("MSG_invalid_dbversion":U,
               cDB + ",":U + STRING(iLastVersion, "999999":U) + ",":U + STRING(iMinVersion, "999999":U),
               "MB_OK,MB_ICONSTOP,MB_TASKMODAL":U).
    RETURN ERROR.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeXMLFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeXMLFiles Procedure 
PROCEDURE writeXMLFiles :
/*------------------------------------------------------------------------------
  Purpose:     Writes the contents of the appropriate tables to the XML files
               for use by the upgrade process.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDCUScriptFile   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDCUSiteDataFile AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hXMLHlpr                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuff                     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns                      AS LOGICAL    NO-UNDO.

  /* Handles for the script file root node and X-Doc */
  DEFINE VARIABLE hSFDoc                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSFRoot                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSFNode                   AS HANDLE     NO-UNDO.
  
  /* Handles for the site data root node and X-Doc */
  DEFINE VARIABLE hSDDoc                    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDRoot                   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDNode                   AS HANDLE     NO-UNDO.

  /* Start the XML helper API */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afxmlhlprp.p":U, 
                                        OUTPUT hXMLHlpr).

  /* If we have to create a script file document, we'll do that here */
  IF pcDCUScriptFile <> "" AND
     pcDCUScriptFile <> ? THEN
  DO:
    CREATE X-DOCUMENT hSFDoc.

    hSFDoc:ENCODING = "utf-8":U.

    /* Create a table_def node */
    hSFRoot = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                hSFDoc, 
                                "ScriptData":U).
  END.

  /* If we have to create a site data document, lets do that now */
  IF pcDCUSiteDataFile <> "" AND
     pcDCUSiteDataFile <> ? THEN
  DO:
    CREATE X-DOCUMENT hSDDoc.

    hSDDoc:ENCODING = "utf-8":U.

    /* Create a table_def node */
    hSDRoot = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                hSDDoc, 
                                "SiteData":U).
    
  END.

  /* Now that we have the documents created that we need, let's make sure that there really
     is something to do. If the handles are invalid for the X-Docs, we're not going to 
     do anything right now. */
  IF NOT VALID-HANDLE(hSFDoc) AND
     NOT VALID-HANDLE(hSDDoc) THEN
    RETURN. /* Nothing to do */

  /* Now make sure we have afxmlhlprp.p running so we can dump the xml easily */

  /* Now we need to loop through the ttValue table and dump its contents. Only ttValue records
     marked as site specific are dumped into the site data file. */
  hBuff = BUFFER ttValue:HANDLE. 
  FOR EACH ttValue:
    IF VALID-HANDLE(hSFDoc) THEN
    DO:
      hSFNode = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                 hSFRoot, 
                                 "TableVariable":U).
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElemsFromBuffWithOpts":U IN hXMLHlpr,
                       hSFNode, 
                       INPUT hBuff, 
                       "ColumnTag=ColLabel":U,
                       "*":U).

      DELETE OBJECT hSFNode.
    END.

  

    IF VALID-HANDLE(hSDDoc) AND
       ttValue.lSiteData THEN
    DO:
      hSDNode = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                 hSDRoot, 
                                 "TableVariable":U).
      
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElemsFromBuffWithOpts":U IN hXMLHlpr,
                       hSDNode, 
                       INPUT hBuff, 
                       "ColumnTag=ColLabel":U,
                       "*,!lSiteData":U).

      DELETE OBJECT hSDNode.
    END.
  END.
  
  /* We can now dump out the contents of ttDatabase. All records in ttDatabase are dumped for 
     both kinds of files, but we only dump out connection specific information into the site data
     file */
  hBuff = BUFFER ttDatabase:HANDLE. 
  FOR EACH ttDatabase:
    IF VALID-HANDLE(hSFDoc) THEN
    DO:
      hSFNode = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                 hSFRoot, 
                                 "Database":U).
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElemsFromBuffWithOpts":U IN hXMLHlpr,
                       hSFNode, 
                       INPUT hBuff, 
                       "ColumnTag=ColLabel":U,
                       "*":U).

      DELETE OBJECT hSFNode.
    END.

    IF VALID-HANDLE(hSDDoc) THEN
    DO:
      hSDNode = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                 hSDRoot, 
                                 "Database":U).
      
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElemsFromBuffWithOpts":U IN hXMLHlpr,
                       hSDNode, 
                       INPUT hBuff, 
                       "ColumnTag=ColLabel":U,
                       "cDBName,cDBDir,cConnectParams":U).

      DELETE OBJECT hSDNode.
    END.
  END.

  /* Patch information only gets dumped to the script file. */
  IF VALID-HANDLE(hSFDoc) THEN
  DO:
    hBuff = BUFFER ttPatch:HANDLE. 
    FOR EACH ttPatch:
      hSFNode = DYNAMIC-FUNCTION("createElementNode":U IN hXMLHlpr,
                                 hSFRoot, 
                                 "Patch":U).
      /* Create a Node Element for each field in the input buffer */
      DYNAMIC-FUNCTION("buildElemsFromBuffWithOpts":U IN hXMLHlpr,
                       hSFNode, 
                       INPUT hBuff, 
                       "ColumnTag=ColLabel":U,
                       "*":U).

      DELETE OBJECT hSFNode.
    END.
  END.

  /* Now its time to finish the files off an write them to disk */
  IF VALID-HANDLE(hSDDoc) THEN
  DO:
    lAns = hSDDoc:SAVE("FILE",pcDCUSiteDataFile) NO-ERROR.
    DELETE OBJECT hSDRoot.
    DELETE OBJECT hSDDoc.
  END.
  
  IF VALID-HANDLE(hSFDoc) THEN
  DO:
    lAns = hSFDoc:SAVE("FILE",pcDCUScriptFile) NO-ERROR.
    DELETE OBJECT hSFRoot.
    DELETE OBJECT hSFDoc.
  END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-zzdbg_displayTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zzdbg_displayTables Procedure 
PROCEDURE zzdbg_displayTables :
/*------------------------------------------------------------------------------
  Purpose:     Debug procedure for displaying the contents of the temp-tables
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  output to parsed.txt.

  FOR EACH ttSetup:
    DISPLAY
      "*Setup".
    DISPLAY 
      ttSetup       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
  END.
  FOR EACH ttMessage:
    DISPLAY
      "*Message".
    DISPLAY 
      ttMessage       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
  END.
  FOR EACH ttPath:
    DISPLAY
      "*Path".
    DISPLAY 
      ttPath       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
  END.
  FOR EACH ttRegistryKey:
    DISPLAY
      "*RegistryKey".
    DISPLAY 
      ttRegistryKey       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
  END.
  FOR EACH ttDatabase:
    DISPLAY
      "*Database".
    DISPLAY 
      ttDatabase
      WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
    DOWN.
    FOR EACH ttPatch
      WHERE ttPatch.dParentObj = ttDatabase.dDatabaseObj:
      DISPLAY
        "**Patch".
      DISPLAY 
        ttPatch
        WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
      DOWN.
    END.
  END.
  FOR EACH ttPage:
    DISPLAY
      "*Page".
    DISPLAY 
      ttPage
      WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
    DOWN.
    FOR EACH ttAction
      WHERE ttAction.dParentObj = ttPage.dPageObj:
      DISPLAY
        "***Action".
      DISPLAY 
        ttAction
        WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
      DOWN.
    END.
    FOR EACH ttControl 
      WHERE ttControl.dParentObj = ttPage.dPageObj:
      DISPLAY
        "**Control".
      DISPLAY 
        ttControl
        WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
      DOWN.
      FOR EACH ttAction
        WHERE ttAction.dParentObj = ttControl.dControlObj:
        DISPLAY
          "***Action".
        DISPLAY 
          ttAction
          WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
        DOWN.
      END.
    END.
  END.

  output close.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-zzdbg_showAnswers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE zzdbg_showAnswers Procedure 
PROCEDURE zzdbg_showAnswers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  output to answers.txt.

  FOR EACH ttValue:
    DISPLAY
      "*Value".
    DISPLAY 
      ttValue       
      WITH WIDTH 254 DOWN NO-BOX NO-LABEL STREAM-IO.
    DOWN.
  END.
  FOR EACH ttDatabase:
    DISPLAY
      "*Database".
    DISPLAY 
      ttDatabase
      WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
    DOWN.
    FOR EACH ttPatch
      WHERE ttPatch.dParentObj = ttDatabase.dDatabaseObj:
      DISPLAY
        "**Patch".
      DISPLAY 
        ttPatch
        WITH WIDTH 254 DOWN NO-LABEL NO-BOX STREAM-IO.
      DOWN.
    END.
  END.

  output close.
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

&IF DEFINED(EXCLUDE-formatMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formatMessage Procedure 
FUNCTION formatMessage RETURNS CHARACTER
  ( INPUT pcMessage AS CHARACTER,
    INPUT pcTokens  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains a message specified by pcMessage from the ttMessage 
            temp-table and reformats it.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttMessage FOR ttMessage.

  FIND FIRST bttMessage NO-LOCK
    WHERE bttMessage.cMessageCode = pcMessage
    NO-ERROR.
  IF AVAILABLE(bttMessage) THEN
    cMessage = bttMessage.cMessageDesc.
  ELSE
    cMessage = ?.

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
  Purpose:     Shows the message specified by cMessage. The message text is 
               obtained by a call to formatMessage.
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

  IF pcMessage = "":U THEN
    RETURN ?.

  IF NUM-ENTRIES(pcMessage) > 1 AND
     pcTokens = "":U THEN
  DO:
    DO iCount = 2 TO NUM-ENTRIES(pcMessage):
      pcTokens = pcTokens + MIN(",":U,pcTokens) + ENTRY(iCount,pcMessage).
    END.
    pcMessage = ENTRY(1,pcMessage).
  END.

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
  DEFINE VARIABLE cSeqName AS CHARACTER  NO-UNDO.
  DEFINE BUFFER bttDatabase FOR ttDatabase.

  lAns = DYNAMIC-FUNCTION("isConnected":U IN THIS-PROCEDURE,
                          pclDBName).

  IF NOT lAns THEN
    RETURN ?.

  FIND FIRST bttDatabase 
    WHERE bttDatabase.cDBName = pclDBName
    NO-ERROR.
  IF NOT AVAILABLE(bttDatabase) THEN
    RETURN ?.

  /* Create a buffer on the sequence table */
  CREATE BUFFER hBuffer FOR TABLE pclDBName + "._sequence":U.

  /* We're only concerned with the value in the _seq-max field as this
     comes from the delta file. */
  hVersion = hBuffer:BUFFER-FIELD("_seq-max":U).

  IF bttDatabase.cVersionSeq <> "":U AND
     bttDatabase.cVersionSeq <> "":U THEN
    cSeqName = bttDatabase.cVersionSeq.
  ELSE
    cSeqName = "seq_":U + pclDBName + "_DBVersion":U.

  /* We need to find a record with the sequence name seq_<dbname>_DBVersion */
  cQuery = "WHERE _Sequence._Seq-name = " + QUOTER(cSeqName).
  
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

&IF DEFINED(EXCLUDE-setImageFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImageFiles Procedure 
FUNCTION setImageFiles RETURNS LOGICAL
  (INPUT pcImageLowRes AS CHARACTER,
   INPUT pcImageHiRes  AS CHARACTER,
   INPUT pcImage256Res AS CHARACTER,
   INPUT pcImageFile   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the current image file and causes the parent procedure to
            refresh the image.
    Notes:  
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "current_ImageLowRes":U,
                   pcImageLowRes).
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "current_ImageHiRes":U,
                   pcImageHiRes).
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "current_Image256Res":U,
                   pcImage256Res).
  DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE,
                   "current_ImageFile":U,
                   pcImageFile).

  PUBLISH "DCU_SetImage":U.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

