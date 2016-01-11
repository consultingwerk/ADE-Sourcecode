&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

/*------------------------------------------------------------------------
File       : _cihttp.w
Purpose    : 4GL wrapper for Crescent OCX for HTTP.  
     
Description: To use this in a procedure, do the following:

             1: Start this persistent an make it a super procedure.
             ------------------------------------------------------            
             DEF VAR hProc AS HANDLE NO-UNDO.
             RUN "adeweb/_cihttp.w" PERSISTENT SET hProc.
             THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc).
             ------------------------------------------------------ 
           
             2: Set required attributes.
             ------------------------------------------------------
             DYNAMIC-FUNCTION("setBROKERURL", _BrokerURL).  /* mandatory*/
             
             DYNAMIC-FUNCTION("setBROWSER", _Browser). /* if needed*/
             ------------------------------------------------------
  
             3: Create the procedures that are needed.
                The naming convention is to use the same name as 
                the ocx.event.   
                Run postdata or getdata on connection.
                
                Parameter1 is the procedure to run and 
                parameter2 is optional parameters.
                 
                Read data on file closed from the tempfile or an 
                attribute.
             ------------------------------------------------------             
             PROCEDURE OCX.HTTPServerConnection :
               RUN postdata("webutil/_proc.p",
                            "?param=something").                                                  
             END.
             PROCEDURE OCX.FileClosed :                             
               
               RUN SUPER NO-ERROR. /* If you want to use the deafult error 
                                      handleing */
               
               IF ERROR-STATUS:ERROR - FaLSE THEN 
               DO:  /**
                 if parseurl = true you can :
                 dynamic-function("getHTMLPageTextWithoutTags").                             
                 or                               
                 input from value (dynamic-function("getLocalFileName")).                                                                                                                        
                 */
               END.
               APPLY "CLOSE" TO THIS PROCEDURE.            
             
             END.                          
             -------------------------------------------------------
              
             4: Run connectServer and 
                use a WAIT-FOR to be able to receive the events.
                Destroy the ocx procedure when your finished. 
                
              NOTE that this makes it impossible to call this from a function.
              I have tried do while loops, but the necessary events will not 
              be detected. PROCESS EVENTS does not solve this because that is 
              also an input blocking statement.                                     
             ------------------------------------------------------- 
             RUN connectServer.
             
             WAIT-FOR CLOSE OF THIS-PROCEDURE.
             
             RUN destroyObject.  
             -------------------------------------------------------
Author     : Haavard Danielsen
Created    : April 1998

Note       : The gTargetHdl variable is logged in the procedures that is 
             run from the target-procedure (GetData, PostData, ConnectServer)
             so that the OCX events know which handle to talk to.  
             
             The localfile is deleted on destroy UNLESS setlocalfilename is 
             used to set the file.   
------------------------------------------------------------------------*/
/*       This .W file was created with the Progress AppBuilder.         */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/* Local Variable Definitions ---                                       */


/** Set this to TARGET-PROCEDURE in all procedures in order to 
    make OCX.events find the right target */
DEFINE VARIABLE gTargetHdl         AS HANDLE    NO-UNDO.

DEFINE VARIABLE gBrokerURL         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gWebBrowser        AS CHARACTER NO-UNDO.
DEFINE VARIABLE gRunProcedure      AS CHARACTER NO-UNDO.
DEFINE VARIABLE gErrorNumber       AS INTEGER   NO-UNDO.
DEFINE VARIABLE gErrorText         AS CHARACTER NO-UNDO.
DEFINE VARIABLE gParseIncomingData AS LOG       NO-UNDO.
DEFINE VARIABLE gLocalFileName     AS CHAR      NO-UNDO.
DEFINE VARIABLE gLocalSet          AS LOG       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getErrorNumber C-Win 
FUNCTION getErrorNumber RETURNS CHARACTER
  ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHostName C-Win 
FUNCTION getHostName RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHTMLPageTextWithoutTags C-Win 
FUNCTION getHTMLPageTextWithoutTags RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHTMLPageTextWithTags C-Win 
FUNCTION getHTMLPageTextWithTags RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLocalFileName C-Win 
FUNCTION getLocalFileName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRemotePath C-Win 
FUNCTION getRemotePath RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getURL C-Win 
FUNCTION getURL RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWSAErrorText C-Win 
FUNCTION getWSAErrorText RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD HtmlError2Message C-Win 
FUNCTION HtmlError2Message RETURNS CHARACTER
  (ppage as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrokerURL C-Win 
FUNCTION setBrokerURL RETURNS LOGICAL
  ( pURL as CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLocalFileName C-Win 
FUNCTION setLocalFileName RETURNS CHARACTER
  (pFile AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParseIncomingData C-Win 
FUNCTION setParseIncomingData RETURNS LOGICAL
  ( pParse as log)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWebBrowser C-Win 
FUNCTION setWebBrowser RETURNS LOGICAL
  (pBrowse AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD TextWithoutTag C-Win 
FUNCTION TextWithoutTag RETURNS CHARACTER
  (pText AS CHAR, /* HTML text */
   pTag  AS CHAR, /* Tag without < > or </ > */
   pNum  AS INT)  /* Number (2 = Get the second text with this tag ) */
    FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD url-encode C-Win 
FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS 
         AT COL 1 ROW 1
         SIZE 39.86 BY 2.19.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Window"
         HEIGHT             = 2.19
         WIDTH              = 39.86
         MAX-HEIGHT         = 34.35
         MAX-WIDTH          = 204.86
         VIRTUAL-HEIGHT     = 34.35
         VIRTUAL-WIDTH      = 204.86
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,                                                          */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME        = FRAME DEFAULT-FRAME:HANDLE
       ROW          = 1.46
       COLUMN       = 4
       HEIGHT       = 1.15
       WIDTH        = 4.57
       HIDDEN       = no
       SENSITIVE    = yes.
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {DE90AEA3-1461-11CF-858F-0080C7973784} type: CIHTTP */

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.FileClosed
PROCEDURE CtrlFrame.CIHTTP.FileClosed .
/*------------------------------------------------------------------------------
  Purpose:     This event fires when the GET or POST has completed.
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  RUN OCX.FileCLosed IN gTargetHdl NO-ERROR.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.HTTPServerConnection
PROCEDURE CtrlFrame.CIHTTP.HTTPServerConnection .
/*------------------------------------------------------------------------------
  Purpose:     Connection was made to HTTP server, so now submit URL request.
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
  RUN OCX.HTTPServerConnection IN gTargetHdl. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame C-Win OCX.WSAError
PROCEDURE CtrlFrame.CIHTTP.WSAError .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    error_number
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAMETER pErrNum AS INT. 
 
 gErrorNumber = pErrNum.

 chCtrlFrame:CIHTTP:CleanupConnection.

 RUN adeweb/_wsaerr.p (pErrNum, OUTPUT gErrorText).
  
 RUN OCX.WSAError IN gTargetHdl (pErrNUm) NO-ERROR. 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */


/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

RUN control_load.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectServer C-Win 
PROCEDURE connectServer :
/*------------------------------------------------------------------------------
  Purpose:     Connect to a Web server. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR lScrap AS  LOG     NO-UNDO.
  DEF VAR lResult AS INTEGER NO-UNDO.
  
  IF gbrokerURL = "":U THEN   
    RUN adeuib/_uibinfo.p(?,"SESSION","BrokerURL", OUTPUT gBrokerURL).
 
  IF gbrokerURL = "":U THEN 
  DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, 
                            "error":U, 
                            "ok":U,
    "The WebSpeed Broker URL is blank.  Make sure it is set in Preferences.^^This operation will be aborted.").
    RETURN ERROR.
  END.
    
  RUN adecomm/_setcurs.p ("WAIT":U).
 
  /* Generate Localfilename if NOT setLocalfilename has been called */         
  IF gLocalSet = FALSE THEN 
    RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT gLocalFileName).
           
  /* Connect to Web server and pass URL. */
  ASSIGN
    chCtrlFrame:CIHTTP:LocalFileName     = gLocalFileName
    chCtrlFrame:CIHTTP:ParseURL          = TRUE
    chCtrlFrame:CIHTTP:ParseINCOMINGdata = gParseIncomingData
    chCtrlFrame:CIHTTP:URL               = gBrokerURL 
    gTargetHdl                           = TARGET-PROCEDURE 
    lResult = chCtrlFrame:CIHTTP:ConnectToHTTPServer.
     
  RUN adecomm/_setcurs.p ("":U).
 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "_cihttp.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "_cihttp.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject C-Win 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN disable_ui.
  IF gLocalSet = FALSE THEN 
    OS-DELETE VALUE(gLocalFileName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetData C-Win 
PROCEDURE GetData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pProc      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pParam     AS CHARACTER NO-UNDO.
 
  RUN TransferData IN gTargetHdl (pProc, pParam, "GET":U). 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.FileClosed C-Win 
PROCEDURE OCX.FileClosed :
/*------------------------------------------------------------------------------
  Purpose:    Default OCX.FileClosed with some error handling                                
  Parameters:  <none>
  Notes:      Only tested with _sdoinfo.p as backend   
------------------------------------------------------------------------------*/
  DEFINE VAR htmText  AS CHAR NO-UNDO.
  DEFINE VAR ErrorMsg AS CHAR NO-UNDO.  
  DEFINE VAR CValue   AS CHAR NO-UNDO.
  
  ASSIGN
    htmText   = DYNAMIC-FUNCTION("GetHTMLPageTextWithTags")
    cValue   = "":U.
 
   /* If msgOpen error from the agent etc, tell the user to look in log file */ 
   IF ENTRY(1,htmtext,chr(10)) = "<HTML>":U  
   OR NUM-ENTRIES(htmtext,chr(10)) < 3 THEN
   DO:
     MESSAGE 
       "An error occured on the agent." SKIP 
       "Check the agents log file."      
     VIEW-AS ALERT-BOX ERROR.           
     RETURN ERROR. 
   END. 
   ELSE            
   DO:
     cValue = ENTRY(3,htmText,CHR(10)).  
     
     /*  
     If the agent uses -weblogerror errors is returned from logic in _sdoinfo.p
     otherwise errors will be returned as HTML text starting with   
     content-type= html/text  
     */
    
     IF cValue BEGINS "ERROR:":U 
     OR cValue BEGINS "Content-type" THEN
     DO: 
       /* If error is from web-disp it contains tags */ 
       ASSIGN 
         ErrorMsg = DYNAMIC-FUNCTION("GetHTMLPageTextWithoutTags")
         ErrorMsg = SUBSTR(htmtext,INDEX(htmText,cValue) 
                           + LENGTH(cValue,"CHARACTER":U) + 1)
         ErrorMsg = IF ErrorMsg = "":U 
                    THEN "An error occured on the agent."    
                      
                       /***  
                         + CHR(10)
                         + "Most likely when " + pProc + " was started." 
                       ***/ 
                         + CHR(10) 
                         + "Check the agents log file."      
                     ELSE ErrorMsg
         .                
    
       MESSAGE 
           ErrorMsg
         VIEW-AS ALERT-BOX 
       ERROR.  
       RETURN ERROR. 
     END.     
     ELSE
     IF cValue = "<HTML>":U THEN
     DO:
       HTMLError2Message("":U).
       RETURN ERROR.
     END.  
   END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OCX.WSAError C-Win 
PROCEDURE OCX.WSAError :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  There are a function WSAError in abfuncs.w that does this.  
          But this procedure shall NOT have sharvars.i 
          and in the future(?) it will be used by all procedure that uses
          OCX to communicate with the server.   
          Which means that THIS will make the one in _abfuncs.w 
          obsolete.  
          At that point we might consider moving the _wsaerr.p stuff in here. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pErrNum AS INTEGER. 
  
  MESSAGE
    gErrorText 
    VIEW-AS ALERT-BOX ERROR.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostData C-Win 
PROCEDURE PostData :
/*------------------------------------------------------------------------------
  Purpose:     Post data to the web
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pProc      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pParam    AS CHARACTER NO-UNDO.

  RUN TransferData IN gTargetHdl (pProc, pParam, "POST":U). 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TransferData C-Win 
PROCEDURE TransferData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pProc     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pParam    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pMode     AS CHARACTER NO-UNDO.
      
  pParam = IF pParam BEGINS "?" 
           THEN pParam
           ELSE "?" + pPARAM  .
  
  ASSIGN
    chCtrlFrame:CIHTTP:URL = "http://":U 
                            + chCtrlFrame:CIHTTP:HostName
                            + chCtrlFrame:CIHTTP:RemotePath      
                            + "/" + pProc
                            + pParam
    chCtrlFrame:CIHTTP:URL = REPLACE(chCtrlFrame:CIHTTP:URL," ":U,"%20":U)
    gTargetHdl             = TARGET-PROCEDURE
    . 
  
  CASE pMode:  
    WHEN "GET":U THEN  
     chCtrlFrame:CIHTTP:GET.
    WHEN "POST":U THEN  
     chCtrlFrame:CIHTTP:POST.
    OTHERWISE 
      MESSAGE "Invalid mode" pMode "used in internal procedure SendData in"
              THIS-PROCEDURE:FILE-NAME
             VIEW-AS ALERT-BOX ERROR. 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getErrorNumber C-Win 
FUNCTION getErrorNumber RETURNS CHARACTER
  ( ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN STRING(gErrorNumber). 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHostName C-Win 
FUNCTION getHostName RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN chCtrlFrame:CIHTTP:HostName. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHTMLPageTextWithoutTags C-Win 
FUNCTION getHTMLPageTextWithoutTags RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN chCtrlFrame:CIHTTP:HTMLPageTextWithoutTags.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHTMLPageTextWithTags C-Win 
FUNCTION getHTMLPageTextWithTags RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN chCtrlFrame:CIHTTP:HTMLPageTextWithTags.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLocalFileName C-Win 
FUNCTION getLocalFileName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gLocalFileName.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRemotePath C-Win 
FUNCTION getRemotePath RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN chCtrlFrame:CIHTTP:RemotePath. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getURL C-Win 
FUNCTION getURL RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN chCtrlFrame:CIHTTP:URL.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWSAErrorText C-Win 
FUNCTION getWSAErrorText RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gErrorTEXT.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION HtmlError2Message C-Win 
FUNCTION HtmlError2Message RETURNS CHARACTER
  (ppage as char): /* HTML text set to blank to use 
                      the HTMLTextWithTags attribute */
/*------------------------------------------------------------------------------
  Purpose: Make a Progress 4GL error of 
           an error generated by HTMLerror.                           
    Notes: It is up to the TARGET-PROCEDURE to call this whenever necessary.
           For example if the first parameter to GetData or PageData is a 
           non existent procedure the error is returned as an HTML page.  
           Usually it is enough to check if the incoming page has an 
           <HTML> tag, but since that may not always be true the logic is left to be 
           done in the TARGET-PROCEDURE.
------------------------------------------------------------------------------*/
  IF pPage = "" THEN 
    ASSIGN pPage = getHtmlPageTextWithTags().  
    
 MESSAGE
   TextWithoutTag(pPage,"P",1)
      
   VIEW-AS ALERT-BOX
   ERROR
   TITLE TextWithoutTag(pPage,"TITLE",1).
        
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrokerURL C-Win 
FUNCTION setBrokerURL RETURNS LOGICAL
  ( pURL as CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gBrokerURL = pURL.
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLocalFileName C-Win 
FUNCTION setLocalFileName RETURNS CHARACTER
  (pFile AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    gLocalFileName = pFile
    gLocalSet      = TRUE.
     
  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParseIncomingData C-Win 
FUNCTION setParseIncomingData RETURNS LOGICAL
  ( pParse as log) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gParseIncomingData = pParse. 
  RETURN true.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWebBrowser C-Win 
FUNCTION setWebBrowser RETURNS LOGICAL
  (pBrowse AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gWebBrowser = pBrowse.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION TextWithoutTag C-Win 
FUNCTION TextWithoutTag RETURNS CHARACTER
  (pText AS CHAR, /* HTML text */
   pTag  AS CHAR, /* Tag without < > or </ > */
   pNum  AS INT)  /* Number (2 = Get the second text with this tag ) */
   :
/*------------------------------------------------------------------------------
  Purpose: Get the textpart of a tag in an HTML file  
    Notes: Should be possible to run recursive to get tag within tag, but that's
           never tested though.      
------------------------------------------------------------------------------*/
  DEF VAR iStartPos AS INTEGER NO-UNDO.
  DEF VAR iEndPos   AS INTEGER NO-UNDO.
  DEF VAR cStartTag  AS CHAR   NO-UNDO. 
  DEF VAR cEndTag    AS CHAR   NO-UNDO. 
 
  DEF VAR i         AS INTEGER NO-UNDO.
  
  /* Make sure pNum = 1 when pNum is unimportant */
  IF pNum = 0 OR pNum = ? THEN pNum = 1.
  
  ASSIGN 
    cStartTag  = "<":U + pTag + ">":U
    cEndTag    = "</":U + pTag + ">":U        
    iStartPos  = 1. 
    
  /* Find thge right Tag */
  DO i = 1 to pNum:
    ASSIGN 
     pText      = SUBSTR(pText,iStartpos)
     iStartPos  = INDEX(pText,cStartTag) + LENGTH(cStartTag,"CHARACTER":U)    
     iEndPos    = INDEX(pText,cEndTag)
    . 
  END.
    
  RETURN IF iStartpos > 1 and iStartpos < iEndpos 
         THEN SUBSTR(pText,iStartpos,iEndpos - iStartpos)
         ELSE "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION url-encode C-Win 
FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hx          AS CHARACTER NO-UNDO INITIAL "0123456789ABCDEF":U.
  DEFINE VARIABLE encode-list AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iValue      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE c           AS INTEGER   NO-UNDO.

  DEFINE VARIABLE url_unsafe  AS CHARACTER NO-UNDO
    INITIAL " <>~"#%{}|~\^~~[]`":U.
  DEFINE VARIABLE url_reserved AS CHARACTER NO-UNDO
    INITIAL "~;/?:@=&":U.
 
  /* Don't bother with blank input */
  IF LENGTH(p_value) = 0 THEN RETURN "".

  /* What kind of encoding should be used? */
  CASE p_enctype:
    WHEN "query":U THEN              /* QUERY_STRING name=value parts */
      encode-list = url_unsafe + url_reserved + "+":U.
    WHEN "cookie":U THEN             /* Persistent Cookies */
      encode-list = url_unsafe + " ,~;":U.
    WHEN "default":U OR WHEN "" THEN /* Standard URL encoding */
      encode-list = url_unsafe.
    OTHERWISE
      encode-list = url_unsafe + p_enctype.   /* user specified ... */
  END CASE.

  /* Loop through entire input string */
  ASSIGN iValue = 0.
  DO WHILE TRUE:
    ASSIGN
      iValue = iValue + 1  /* Next character */
      /* ASCII value of character */
      c = ASC(SUBSTRING(p_value, iValue, 1, "RAW":U)).
    IF c <= 31 OR c >= 127 OR INDEX(encode-list, CHR(c)) > 0 THEN DO:
      /* Replace character with %hh hexidecimal triplet */
      SUBSTRING(p_value, iValue, 1, "RAW":U) = "%":U +
        SUBSTRING(hx, INTEGER(TRUNCATE(c / 16, 0)) + 1, 1, "RAW":U) + /* high */
        SUBSTRING(hx, c MODULO 16 + 1, 1, "RAW":U).             /* low digit */
      ASSIGN iValue = iValue + 2.   /* skip over hex triplet just inserted */
    END.
    IF iValue = LENGTH(p_value,"RAW") THEN LEAVE.
  END.

  RETURN p_value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

