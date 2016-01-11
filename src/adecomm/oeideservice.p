&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : oeideservice.p
    Purpose     : Methods to interact with the OpenEdge IDE

    Syntax      :

    Description :

    Author(s)   : egarcia
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOPED-DEFINE BUFFER_SIZE         1024
&SCOPED-DEFINE NO_EMBEDDED_WINDOWS NO
DEFINE NEW GLOBAL SHARED VARIABLE OEIDE_ABEmbedded AS LOGICAL NO-UNDO INITIAL TRUE.
DEFINE SHARED VARIABLE cLinkedResources  AS CHARACTER.

DEFINE TEMP-TABLE ttLinkedFile NO-UNDO
    FIELD windowHandle         AS HANDLE
    FIELD projectName          AS CHARACTER
    FIELD fileName             AS CHARACTER
    FIELD linkedFile           AS CHARACTER
    FIELD syncTimeStamp        AS DATETIME
    INDEX linkedFile   IS PRIMARY UNIQUE linkedFile
    INDEX windowHandle IS UNIQUE windowHandle
    INDEX fileName     IS UNIQUE fileName   
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

&IF DEFINED(EXCLUDE-displayEmbeddedWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD displayEmbeddedWindow Procedure 
FUNCTION displayEmbeddedWindow RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProjectName Procedure 
FUNCTION getProjectName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideView Procedure 
FUNCTION hideView RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEmbeddedWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEmbeddedWindow Procedure 
FUNCTION setEmbeddedWindow RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewTitle Procedure 
FUNCTION setViewTitle RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          viewTitle   AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showView Procedure 
FUNCTION showView RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          mode        AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openEditor Procedure 
FUNCTION openEditor RETURNS LOGICAL
         (cProjectName  AS CHARACTER,
          cFileName     AS CHARACTER,
          cLinkedFile   AS CHARACTER,
          hWindowHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD saveEditor Procedure 
FUNCTION saveEditor RETURNS LOGICAL
         (cProjectName  AS CHARACTER,
          cFileName     AS CHARACTER,
          ask_file_name AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeEditor Procedure 
FUNCTION closeEditor RETURNS LOGICAL
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          saveChanges  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findAndSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findAndSelect Procedure 
FUNCTION findAndSelect RETURNS LOGICAL
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          cText        AS CHARACTER,
          activateEditor AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLinkedFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createLinkedFile Procedure 
FUNCTION createLinkedFile RETURNS CHARACTER
         (user_chars   AS CHARACTER,
          extension    AS CHARACTER)  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{adecomm/oeideservice.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-emptyLinkedTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyLinkedTable Procedure 
PROCEDURE emptyLinkedTable :
/*------------------------------------------------------------------------------
  Purpose: Removes records from the ttLinkedFile temp-table
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE ttLinkedFile.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeLinkedFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeLinkedFiles Procedure 
PROCEDURE removeLinkedFiles :
/*------------------------------------------------------------------------------
  Purpose: Removes the linked files temp-table
  Parameters:
  Notes: 
    This procedure is used from _server.p to ensure that the linked files
    are removed when the session is re-started or closed.
------------------------------------------------------------------------------*/
FOR EACH ttLinkedFile:
    OS-DELETE VALUE(ttLinkedFile.linkedFile).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLinkedFileName Procedure 
PROCEDURE getLinkedFileName :
/*------------------------------------------------------------------------------
  Purpose: Returns the file name of the linked file for a given window
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow           AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER pcLinkedFile      AS CHARACTER  NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.windowHandle = phWindow NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    pcLinkedFile = ttLinkedFile.linkedFile.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSyncTimeStamp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSyncTimeStamp Procedure 
PROCEDURE getSyncTimeStamp :
/*------------------------------------------------------------------------------
  Purpose: Returns the timestamp of a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER timeStamp       AS DATETIME   NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    timeStamp = ttLinkedFile.syncTimeStamp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSyncTimeStamp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSyncTimeStamp Procedure 
PROCEDURE setSyncTimeStamp :
/*------------------------------------------------------------------------------
  Purpose: Sets the timestamp of a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER timeStamp    AS DATETIME   NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    ttLinkedFile.syncTimeStamp = timeStamp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addWindow Procedure 
PROCEDURE addWindow :
/*------------------------------------------------------------------------------
  Purpose: Adds a 4GL window to the specified view
  Parameters:
    Notes:  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER viewId      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER secondaryId AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER hWindow     AS HANDLE     NO-UNDO.

DEFINE VARIABLE wHwnd AS INTEGER       NO-UNDO.
DEFINE VARIABLE lVisible AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

&IF "{&NO_EMBEDDED_WINDOWS}" EQ "YES" &THEN
    RETURN.
&ENDIF
IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                             secondaryId BEGINS "PropertiesWindow":U) THEN RETURN.
IF NOT VALID-HANDLE(hWindow) THEN RETURN.

DEFINE VARIABLE iParentWindow AS INTEGER    NO-UNDO.

RUN getViewHwnd (viewId, secondaryId, OUTPUT iParentWindow).

IF iParentWindow <> 0 THEN
    ASSIGN hWindow:IDE-WINDOW-TYPE = 1 /* virtual desktop */ 
           hWindow:IDE-PARENT-HWND = iParentWindow.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayWindow Procedure 
PROCEDURE displayWindow :
/*------------------------------------------------------------------------------
  Purpose: Compound procedure to show and embed 
           the specified window into the view in virtual desktop mode 
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER viewId      AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER secondaryId AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER hWindow     AS HANDLE     NO-UNDO.

&IF "{&NO_EMBEDDED_WINDOWS}" EQ "YES" &THEN
    RETURN.
&ENDIF
IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                             secondaryId BEGINS "PropertiesWindow":U) THEN RETURN.
IF NOT VALID-HANDLE(hWindow) THEN RETURN.

DEFINE VARIABLE iParentWindow AS INTEGER    NO-UNDO.

showView(viewId, secondaryId, {&VIEW_ACTIVATE}).
RUN getViewHwnd (viewId, secondaryId, OUTPUT iParentWindow).

IF iParentWindow <> 0 THEN
    ASSIGN hWindow:IDE-WINDOW-TYPE = 1 /* virtual desktop */ 
           hWindow:IDE-PARENT-HWND = iParentWindow.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEditorModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEditorModified Procedure 
PROCEDURE setEditorModified :
/*------------------------------------------------------------------------------
  Purpose: Sets the timestamp of the linked file associated with a window 
           to unknown
  Parameters:
  Notes: 
  - A sendRequest is issued to tell the OpenEdge IDE Editor that the file 
  has been modified so the Save button in the IDE will be enabled, and a check for 
  changes would be performed before the editor is closed.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow     AS HANDLE     NO-UNDO.

DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.windowHandle = phWindow NO-ERROR.
IF AVAILABLE ttLinkedFile AND ttLinkedFile.syncTimeStamp <> ? THEN
DO:
    ttLinkedFile.syncTimeStamp = ?.    
    RUN sendRequest("IDE setEditorModified ":U 
                  + QUOTER(ttLinkedFile.projectName) + " "
                  + QUOTER(ttLinkedFile.fileName), FALSE, OUTPUT cResult).
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unlinkEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unlinkEditor Procedure 
PROCEDURE unlinkEditor :
/*------------------------------------------------------------------------------
  Purpose: Removes a ttLinkedFile record and the linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    DELETE ttLinkedFile.
OS-DELETE VALUE(pcLinkedFile).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFileNameOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFileNameOfFile Procedure 
PROCEDURE getFileNameOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the file associated with a given linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFileName   AS CHARACTER  NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    pcFileName = ttLinkedFile.fileName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkedFileOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLinkedFileOfFile Procedure 
PROCEDURE getLinkedFileOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the file name of the linked file associated with a file 
           opened in the AppBuilder
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFileName    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.fileName = pcFileName NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    pcLinkedFile = ttLinkedFile.linkedFile.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindowOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWindowOfFile Procedure 
PROCEDURE getWindowOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the window associated with a linked file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWindow    AS HANDLE     NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    phWindow = ttLinkedFile.windowHandle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWindowOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setWindowOfFile Procedure 
PROCEDURE setWindowOfFile :
/*------------------------------------------------------------------------------
  Purpose: Associates a window with a linked file name
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcLinkedFile AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phWindow     AS HANDLE     NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = pcLinkedFile NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    ttLinkedFile.windowHandle = phWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFileOfWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFileOfWindow Procedure 
PROCEDURE setFileOfWindow :
/*------------------------------------------------------------------------------
  Purpose: Associates a file to the window handle specified
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phWindow     AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pcFileName   AS CHARACTER  NO-UNDO.

FIND ttLinkedFile WHERE ttLinkedFile.windowHandle = phWindow NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    ttLinkedFile.fileName = pcFileName.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getViewHwnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getViewHwnd Procedure 
PROCEDURE getViewHwnd :
/*------------------------------------------------------------------------------
  Purpose: Returns the Windows hwnd value of the specified view
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER viewId       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER secondaryId  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER iResult     AS INTEGER    NO-UNDO.

IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                             secondaryId BEGINS "PropertiesWindow":U) THEN RETURN.

DEFINE VARIABLE cResult AS CHARACTER  NO-UNDO.

    RUN sendRequest("IDE getViewHwnd ":U 
                    + viewId + " " 
                    + QUOTER(secondaryId), TRUE, OUTPUT cResult).
    iResult = INTEGER(cResult) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProjectOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProjectOfFile Procedure 
PROCEDURE getProjectOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the project associated with a file
  Parameters:
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFullPathName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcProjectName AS CHARACTER  NO-UNDO.

IF pcFullPathName = "" OR pcFullPathName = ? THEN
DO:
    pcProjectName = "".
    RETURN.
END.
    
FIND ttLinkedFile WHERE ttLinkedFile.fileName = pcFullPathName NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    pcProjectName = ttLinkedFile.projectName.
ELSE
DO:
    DEFINE VARIABLE cCurrentProjectName AS CHARACTER   NO-UNDO.
    cCurrentProjectName = getProjectName().
    RUN sendRequest("IDE getProjectOfFile ":U 
                    + QUOTER(cCurrentProjectName) + " "    
                    + QUOTER(pcFullPathName), TRUE, OUTPUT pcProjectName).
END.                    

IF pcProjectName = "FALSE":U THEN
    pcProjectName = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActiveProjectOfFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActiveProjectOfFile Procedure 
PROCEDURE getActiveProjectOfFile :
/*------------------------------------------------------------------------------
  Purpose: Returns the project associated with a file for the AppBuilder session
  Parameters:
  Notes: Returns blank if the project cannot be used as a resource 
  in the current AppBuilder session.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFullPathName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcProjectName AS CHARACTER  NO-UNDO.

IF pcFullPathName = "" OR pcFullPathName = ? THEN
DO:
    pcProjectName = "".
    RETURN.
END.
    
FIND ttLinkedFile WHERE ttLinkedFile.fileName = pcFullPathName NO-ERROR.
IF AVAILABLE ttLinkedFile THEN
    pcProjectName = ttLinkedFile.projectName.
ELSE
DO:
    DEFINE VARIABLE cCurrentProjectName AS CHARACTER   NO-UNDO.
    cCurrentProjectName = getProjectName().
    RUN sendRequest("IDE getActiveProjectOfFile ":U 
                    + QUOTER(cCurrentProjectName) + " "    
                    + QUOTER(pcFullPathName), TRUE, OUTPUT pcProjectName).
END.                    

IF pcProjectName = "FALSE":U THEN
    pcProjectName = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-asyncRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE asyncRequest Procedure 
PROCEDURE asyncRequest :
/*------------------------------------------------------------------------------
  Purpose: Executes IDE commands ignoring its response
  Parameters:
        INPUT   pcCommand IDE command to be send to the OEIDE
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcCommand AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

    RUN sendRequest(pcCommand, FALSE, OUTPUT cResult).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendRequest Procedure 
PROCEDURE sendRequest :
/*------------------------------------------------------------------------------
  Purpose: Executes IDE commands 
  Parameters:
        INPUT   pcCommand IDE command to be send to the OEIDE
        INPUT   plWait    Wait for response from the OEIDE
        OUTPUT  pcResult  String returned from the OEIDE.
                It cannot be unknown.
                The string TRUE and FALSE may be returned from the OEIDE.
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCommand AS CHARACTER   NO-UNDO.
DEFINE INPUT PARAMETER plWait    AS LOGICAL     NO-UNDO.
DEFINE OUTPUT PARAMETER pcResult AS CHARACTER   NO-UNDO INITIAL "FALSE":U.

DEFINE VARIABLE hSocket AS HANDLE      NO-UNDO.
DEFINE VARIABLE mBuffer AS MEMPTR      NO-UNDO.
DEFINE VARIABLE mReadBuffer AS MEMPTR  NO-UNDO.
DEFINE VARIABLE lStatus AS LOGICAL     NO-UNDO.

   IF pcCommand = ? THEN RETURN.
   IF NOT plWait THEN
       pcResult = "TRUE":U.
   
   CREATE SOCKET hSocket.
   
   lStatus = hSocket:CONNECT("-H localhost -S ":U + OS-GETENV("OEA_PORT":U)) NO-ERROR.
   IF NOT lStatus THEN RETURN.
   
   pcCommand = pcCommand + "~n".
   SET-SIZE(mBuffer)      = 0.
   SET-SIZE(mBuffer)      = LENGTH(pcCommand) + 1.
   PUT-STRING(mBuffer, 1) = pcCommand.
   
   lStatus = hSocket:WRITE(mBuffer, 1, LENGTH(pcCommand)).
   SET-SIZE(mBuffer) = 0.
   IF NOT lStatus THEN RETURN.       

   IF plWait THEN
   DO:
        SET-SIZE(mReadBuffer)      = {&BUFFER_SIZE}.
        IF hSocket:CONNECTED() THEN
        DO:
            lStatus = NOT hSocket:READ(mReadBuffer, 1, {&BUFFER_SIZE} - 1, READ-AVAILABLE) NO-ERROR.
            IF hSocket:BYTES-READ > 0 OR lStatus THEN
                pcResult = "".                
                
            DO WHILE hSocket:BYTES-READ > 0:                
                PUT-BYTE(mReadBuffer, hSocket:BYTES-READ + 1) = 0.
                pcResult = pcResult + GET-STRING(mReadBuffer, 1).
                IF hSocket:GET-BYTES-AVAILABLE() <= 0 THEN
                    LEAVE.
                lStatus = NOT hSocket:READ(mReadBuffer, 1, {&BUFFER_SIZE} - 1, READ-AVAILABLE) NO-ERROR.
            END.
            
        END.
        SET-SIZE(mReadBuffer) = 0.        
   END.

   hSocket:DISCONNECT() NO-ERROR.
   DELETE OBJECT hSocket.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createUntitledFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createUntitledFile Procedure 
PROCEDURE createUntitledFile :
/*------------------------------------------------------------------------------
  Purpose: Creates an untitled file using the input file name as the source.
  Parameters:
        INPUT-OUTPUT pcFileName Source for the content of the untitled file.                
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER pcFileName AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cBaseFileName     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUntitledFileName AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER     NO-UNDO.
DEFINE VARIABLE cFileExt          AS CHARACTER   NO-UNDO.

/* Use the file extension of the specified file name unless it is .tmp. */
i = R-INDEX(pcFileName, ".").
IF i > 0 THEN
DO:
    cFileExt = SUBSTRING(pcFileName, i).
    IF cFileExt = ".tmp":U THEN
        cFileExt = "".
END.    

i = 0.
cBaseFileName = OS-GETENV("ECLIPSE_ROOT") + "Untitled".
FILE-INFO:FILE-NAME = cBaseFileName + STRING(i) + cFileExt.
DO WHILE FILE-INFO:FULL-PATHNAME <> ?:
    i = i + 1.
    FILE-INFO:FILE-NAME = cBaseFileName + STRING(i) + cFileExt.
END.
cUntitledFileName = FILE-INFO:FILE-NAME.
FILE-INFO:FILE-NAME = pcFileName.
IF FILE-INFO:FULL-PATHNAME <> ? THEN
    OS-COPY VALUE(FILE-INFO:FULL-PATHNAME) VALUE(cUntitledFileName).
ELSE
DO:
    OUTPUT TO VALUE(cUntitledFileName).
    OUTPUT CLOSE.
END.    

pcFileName = REPLACE(cUntitledFileName, "~\", "/").  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Win32APIs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Win32APIs Procedure 
PROCEDURE Win32APIs :
END PROCEDURE.

PROCEDURE FindWindowA EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER lpClassName    AS LONG.
  DEFINE INPUT  PARAMETER lpWindowName   AS CHARACTER.
  DEFINE RETURN PARAMETER hWnd           AS LONG.
END.

PROCEDURE FindWindowByClassName EXTERNAL "USER32.DLL" ORDINAL 228:
  DEFINE INPUT  PARAMETER lpClassName  AS CHARACTER.
  DEFINE INPUT  PARAMETER lpWindowName AS LONG.
  DEFINE RETURN PARAMETER hWnd         AS LONG.
END.

PROCEDURE GetParent EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER hWnd           AS LONG.
  DEFINE RETURN PARAMETER rhWnd          AS LONG.
END.

PROCEDURE SetParent EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER hWndChild      AS LONG.
  DEFINE INPUT  PARAMETER hWndParent     AS LONG.
  DEFINE RETURN PARAMETER rhWnd          AS LONG.
END.

PROCEDURE SetWindowPos EXTERNAL "user32.dll":
  DEFINE INPUT PARAMETER hWnd            AS LONG.
  DEFINE INPUT PARAMETER hWndInsertAfter AS LONG.
  DEFINE INPUT PARAMETER x               AS LONG.
  DEFINE INPUT PARAMETER y               AS LONG.
  DEFINE INPUT PARAMETER cx              AS LONG.
  DEFINE INPUT PARAMETER cy              AS LONG.
  DEFINE INPUT PARAMETER wflags          AS LONG.   
  DEFINE RETURN PARAMETER rc             AS LONG.
END.

PROCEDURE GetWindowRect EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER  hWnd          AS LONG.
  DEFINE OUTPUT PARAMETER  lpRect        AS MEMPTR.
END.

PROCEDURE SetWindowPosition:
    DEFINE INPUT PARAMETER iParentWindow AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER hNewWindow    AS HANDLE     NO-UNDO.
    DEFINE INPUT PARAMETER hOldWindow    AS HANDLE     NO-UNDO.

&IF "{&NO_EMBEDDED_WINDOWS}" <> "YES" &THEN    
IF OEIDE_ABEmbedded THEN
DO: /* OEIDE_ABEmbedded */
DEFINE VARIABLE iNewWindow    AS INTEGER    NO-UNDO.
DEFINE VARIABLE rc            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iXpos         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iYpos         AS INTEGER    NO-UNDO.
DEFINE VARIABLE wrect         AS MEMPTR     NO-UNDO.

IF hNewWindow:TYPE <> "WINDOW":U THEN hNewWindow = hNewWindow:WINDOW.
IF hOldWindow:TYPE <> "WINDOW":U THEN hOldWindow = hOldWindow:WINDOW.

SET-SIZE(wrect) = 16. /* 4 INTEGERS at 4 bytes each */
RUN GetParent( INPUT hNewWindow:HWND, OUTPUT iNewWindow).

ASSIGN iXpos = hOldWindow:X
       iYpos = hOldWindow:Y.

IF iParentWindow > 0 THEN
DO:
    RUN GetWindowRect(iParentWindow, OUTPUT wrect).
    ASSIGN iXpos = iXpos - GET-LONG(wrect, 1)
           iYpos = iYpos - GET-LONG(wrect, 5).
END.

RUN SetWindowPos( INPUT iNewWindow,
                       INPUT  0,
                       INPUT  iXpos,
                       INPUT  iYpos,
                       INPUT  0,
                       INPUT  0,
                       INPUT  1,
                       OUTPUT rc ).
SET-SIZE(wrect) = 0.
END. /* OEIDE_ABEmbedded */
&ENDIF
        
END PROCEDURE.    

PROCEDURE SetWindowPositionXY:
    DEFINE INPUT PARAMETER iParentWindow AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER hNewWindow    AS HANDLE     NO-UNDO.    
    DEFINE INPUT PARAMETER iXpos         AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER iYpos         AS INTEGER    NO-UNDO.

&IF "{&NO_EMBEDDED_WINDOWS}" <> "YES" &THEN    
IF OEIDE_ABEmbedded THEN
DO: /* OEIDE_ABEmbedded */
DEFINE VARIABLE iNewWindow    AS INTEGER    NO-UNDO.
DEFINE VARIABLE rc            AS INTEGER    NO-UNDO.
DEFINE VARIABLE wrect         AS MEMPTR     NO-UNDO.

SET-SIZE(wrect) = 16. /* 4 INTEGERS at 4 bytes each */
RUN GetParent( INPUT hNewWindow:HWND, OUTPUT iNewWindow).

IF iParentWindow > 0 THEN
DO:
    RUN GetWindowRect(iParentWindow, OUTPUT wrect).
    ASSIGN iXpos = iXpos - GET-LONG(wrect, 1)
           iYpos = iYpos - GET-LONG(wrect, 5).
END.

RUN SetWindowPos( INPUT iNewWindow,
                       INPUT  0,
                       INPUT  iXpos,
                       INPUT  iYpos,
                       INPUT  0,
                       INPUT  0,
                       INPUT  1,
                       OUTPUT rc ).
SET-SIZE(wrect) = 0.
END. /* OEIDE_ABEmbedded */
&ENDIF
        
END PROCEDURE.    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-displayEmbeddedWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION displayEmbeddedWindow Procedure 
FUNCTION displayEmbeddedWindow RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Compound function to show and set the title of a view and embed 
            the specified window into the view
    Notes:  
------------------------------------------------------------------------------*/
    IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                                 secondaryId BEGINS "PropertiesWindow":U) THEN RETURN TRUE.
    showView(viewId, secondaryId, {&VIEW_ACTIVATE}).
    setViewTitle(viewId, secondaryId, hWindow:TITLE).
    setEmbeddedWindow(viewId, secondaryId, hWindow).
    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProjectName Procedure 
FUNCTION getProjectName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the project associated with the Progress session
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

  cResult = OS-GETENV("ECLIPSE_PROJECT":U).
  IF cResult > "" THEN
      RETURN cResult.
  ELSE
      RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideView Procedure 
FUNCTION hideView RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Hides the specified view
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO. 
  
    IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                                 secondaryId BEGINS "PropertiesWindow":U) THEN RETURN TRUE.  
  RUN sendRequest("IDE hideView ":U 
                  + viewId + " " 
                  + QUOTER(secondaryId), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEmbeddedWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEmbeddedWindow Procedure 
FUNCTION setEmbeddedWindow RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          hWindow     AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the given 4GL window as an embedded window in the specified
            view
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lVisible AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE wHwnd AS INTEGER       NO-UNDO.
    DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.  
  
&IF "{&NO_EMBEDDED_WINDOWS}" EQ "YES" &THEN  
    RETURN TRUE.
&ENDIF    
    IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                                 secondaryId BEGINS "PropertiesWindow":U) THEN RETURN TRUE.
    IF hWindow:HWND = ? THEN
    DO:
        lVisible = hWindow:VISIBLE.
        hWindow:VISIBLE = TRUE.
        hWindow:VISIBLE = lVisible.
    END.                                     
    RUN GetParent (hWindow:HWND, OUTPUT wHwnd).
    RUN sendRequest("IDE setEmbeddedWindow ":U 
                + viewId + " " 
                + QUOTER(secondaryId) + " " 
                + STRING(wHwnd), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setViewTitle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewTitle Procedure 
FUNCTION setViewTitle RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          viewTitle   AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Sets the title of the specified view
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.
  
IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                             secondaryId BEGINS "PropertiesWindow":U) THEN RETURN TRUE.
                               
  RUN sendRequest("IDE setViewTitle ":U 
                  + viewId + " " 
                  + QUOTER(secondaryId) + " " 
                  + QUOTER(viewTitle), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showView Procedure 
FUNCTION showView RETURNS LOGICAL
         (viewId      AS CHARACTER,
          secondaryId AS CHARACTER,
          mode        AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  Displays the specified view in the IDE
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.
  
  IF NOT OEIDE_ABEmbedded AND (secondaryId BEGINS "DesignView":U OR
                               secondaryId BEGINS "PropertiesWindow":U) THEN RETURN TRUE.  
  IF mode = ? OR mode <= 0 OR mode > 3 THEN /* mode values are 1, 2, 3 */
      mode = {&VIEW_ACTIVATE}.              /* Default value */
  RUN sendRequest("IDE showView ":U 
                  + viewId + " " 
                  + QUOTER(secondaryId) + " " 
                  + STRING(mode), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openEditor Procedure 
FUNCTION openEditor RETURNS LOGICAL
         (cProjectName  AS CHARACTER,
          cFileName     AS CHARACTER,
          cLinkedFile   AS CHARACTER,
          hWindowHandle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Open an OEIDE Editor instance.
    Notes:  
	- cLinkedFile can be blank. In which cause the editor is not linked.
	- For dialog-boxes, hWindowHandle corresponds to the FRAME widget. 
	  (The _P._WINDOW-HANDLE field points to the FRAME widget.)
------------------------------------------------------------------------------*/
DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

IF cLinkedFile = "UNTITLED":U THEN
DO:
    IF cProjectName = ? THEN cProjectName = getProjectName().
    RUN createUntitledFile(INPUT-OUTPUT cFileName).
END.    
IF hWindowHandle <> ? THEN /* A .w file is being opened. */
DO:
    /* Check if file is already linked to an OEIDE Editor instance */    
    FIND ttLinkedFile WHERE ttLinkedFile.linkedFile = cLinkedFile NO-ERROR.
    IF NOT AVAILABLE ttLinkedFile THEN
    DO:
        CREATE ttLinkedFile.        
        ASSIGN ttLinkedFile.projectName  = cProjectName
               ttLinkedFile.fileName     = cFileName
               ttLinkedFile.linkedFile   = cLinkedFile.
        FILE-INFO:FILE-NAME = cLinkedFile.
        ASSIGN ttLinkedFile.syncTimeStamp = DATETIME(FILE-INFO:FILE-MOD-DATE, FILE-INFO:FILE-MOD-TIME).               
    END.
    ASSIGN ttLinkedFile.windowHandle = hWindowHandle.
END.
  
RUN sendRequest("IDE openEditor ":U 
                  + QUOTER(cProjectName) + " "
                  + QUOTER(cfileName) + " " 
                  + QUOTER(cLinkedFile), FALSE, OUTPUT cResult).
RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION saveEditor Procedure 
FUNCTION saveEditor RETURNS LOGICAL
         (cProjectName  AS CHARACTER,
          cFileName     AS CHARACTER,
          ask_file_name AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Tells the OpenEdge IDE to perform a save operation on the 
           OpenEdge IDE Editor
    Notes: 
    - A Save or Save Ass dialog is used dependeding on the ask_file_name 
    parameter 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

/*
  IF hWindowHandle <> ? THEN /* A .w file is being opened. */
  DO:
      FIND ttLinkedFile WHERE ttLinkedFile.windowHandle = hWindowHandle NO-ERROR.
      IF NOT AVAILABLE ttLinkedFile THEN
          CREATE ttLinkedFile.

      ASSIGN ttLinkedFile.windowHandle = hWindowHandle
             ttLinkedFile.projectName  = cProjectName
             ttLinkedFile.fileName     = cFileName
             ttLinkedFile.linkedFile   = cLinkedFile.
      FILE-INFO:FILE-NAME = cLinkedFile.         
      ASSIGN ttLinkedFile.syncTimeStamp = DATETIME(FILE-INFO:FILE-MOD-DATE, FILE-INFO:FILE-MOD-TIME).
  END.
*/
  
  RUN sendRequest("IDE saveEditor ":U 
                  + QUOTER(cProjectName) + " "
                  + QUOTER(cfileName) + " "
                  + (IF ask_file_name THEN "SAVEAS":U ELSE "SAVE":U), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeEditor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeEditor Procedure 
FUNCTION closeEditor RETURNS LOGICAL
         (cProjectName  AS CHARACTER,
          cFileName     AS CHARACTER,
          lSaveChanges  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Closes OEIDE Editor instance for the specified file name
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

  RUN sendRequest("IDE closeEditor ":U 
                  + QUOTER(cProjectName) + " "
                  + QUOTER(cFileName) + " "
                  + (IF lSaveChanges THEN "TRUE":U ELSE "FALSE":U), FALSE, OUTPUT cResult).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findAndSelect) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findAndSelect Procedure 
FUNCTION findAndSelect RETURNS LOGICAL
         (projectName  AS CHARACTER,
          fileName     AS CHARACTER,
          cText        AS CHARACTER,
          activateEditor AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Finds and select the specified text in the OEIDE Editor
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cResult AS CHARACTER   NO-UNDO.

    FIND ttLinkedFile WHERE ttLinkedFile.fileName = fileName NO-ERROR.
    
    /* TODO - findAndSelect sometimes get fileName with slashes instead of backslashes */
    IF NOT AVAILABLE ttLinkedFile THEN
    DO: 
        fileName = REPLACE(fileName, "/", "~\").
        FIND ttLinkedFile WHERE ttLinkedFile.fileName = fileName NO-ERROR.
    END.    
    IF NOT AVAILABLE ttLinkedFile THEN RETURN FALSE.
    
    RUN sendRequest("IDE findAndSelect ":U 
                  + QUOTER(getProjectName()) + " "
                  + QUOTER(fileName) + " "
                  + QUOTER(cText) + " "
                  + (IF activateEditor THEN "TRUE" ELSE "FALSE"), FALSE, OUTPUT cResult).
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLinkedFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createLinkedFile Procedure 
FUNCTION createLinkedFile RETURNS CHARACTER
         (user_chars   AS CHARACTER,
          extension    AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Creates an available temporary file in the linked_resources area.
    Notes:  The return parameter is a complete name that includes the path.
    
    This code is based on adecomm/_tmpfile.p.
------------------------------------------------------------------------------*/

define VAR name           as character no-undo.

define var base           as integer.
define var check_name     as character.

/*
 * Loop until we find a name that hasn't been used. In theory, if the
 * temp directory gets filled, this could be an infinite loop. But, the
 * likelihood of that is low.
 */
check_name = "something":U.
 
do while check_name <> ?:
  /* Take the lowest 5 digits (change the format so that everything works out to have exactly 5
     characters. */
  ASSIGN
    base = ( TIME * 1000 + ETIME ) MODULO 100000
    name = STRING(base,"99999":U).
  
  /* Add in the extension and directory into the name. */
  name = cLinkedResources + "/" + "p":U + name + user_chars + extension.

  check_name = SEARCH(name).
  
END.
/* Creates the linked file */
OUTPUT TO VALUE(name).
OUTPUT CLOSE.

name = REPLACE(name, "~\", "/").
name = REPLACE(name, "//", "/").
       
RETURN name.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
