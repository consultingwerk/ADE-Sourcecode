&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2005,2013 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------
    File        : _abrunwb.p
    Purpose     : Run webbrowser using Appbuilder preferences 

    Syntax      : 

    Description : 
Input Parameter : Procedure name and/or any data that can be added to the URL  
    Author(s)   : Haavard Danielsen
    Created     : 4/16/1998
    Notes       : By calling _abprefs.p this procedure is able to 
                  run either using the Appbuilder shared variables 
                  or getting the data from the ini file or registry.  
                  
                  The OCX is used to add missing parts to the URL  
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT PARAMETER pProc AS CHAR NO-UNDO.
 
DEFINE VARIABLE WebBrowser     AS CHARACTER NO-UNDO.
DEFINE VARIABLE WebBroker      AS CHARACTER NO-UNDO.
DEFINE VARIABLE NewBrowser     AS LOG       NO-UNDO.
DEFINE VARIABLE WebPreferences AS CHARACTER NO-UNDO.

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



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COL 1 ROW 1
         SIZE 44.86 BY 2.15.


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
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 2.15
         WIDTH              = 44.86
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

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
       ROW          = 1.27
       COLUMN       = 1
       HEIGHT       = 1.15
       WIDTH        = 4.57
       HIDDEN       = no
       SENSITIVE    = yes.
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {DE90AEA3-1461-11CF-858F-0080C7973784} type: CIHTTP */

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

RUN adecomm/_setcurs.p("WAIT":U).

RUN adeuib/_abprefs.p ("WebBrowser,WebBroker,OpenNewBrowser",
                        OUTPUT WebPreferences ).
ASSIGN 
  WebBrowser  = ENTRY(1,WebPreferences,CHR(3)).

IF NUM-ENTRIES(WebPreferences,CHR(3)) >= 3 THEN
  ASSIGN 
      WebBroker   = ENTRY(2,WebPreferences,CHR(3))
      NewBrowser  = ENTRY(3,WebPreferences,CHR(3)) = "TRUE":U.
  
IF WebBrowser = "":U THEN 
DO:
  MESSAGE 
    "No WebBrowser has been specified." skip
    "Please specify a WebBrowser in the Appbuilder Preferences."
  VIEW-AS ALERT-BOX ERROR.
  RETURN. 
END.

IF WebBroker = "":U THEN 
DO:
  MESSAGE 
    "No Broker URL has been specified." skip
    "Please specify a URL in the Appbuilder Preferences."
  VIEW-AS ALERT-BOX ERROR.
  RETURN.  
END.

RUN control_load.

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
IF PROCESS-ARCHITECTURE = 32 THEN DO:
/* The control has logic to add missing parts to the URL */  
    ASSIGN
      chCtrlFrame:CIHTTP:ParseURL  = TRUE    
      chCtrlFrame:CIHTTP:URL       = WebBroker.

    RUN adeweb/_runbrws.p (WebBrowser,
                           chCtrlFrame:CIHTTP:URL + "/":U + pProc,
                           NewBrowser).

    RUN adecomm/_setcurs.p("":U).
 END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

IF PROCESS-ARCHITECTURE = 32 THEN DO:
OCXFile = SEARCH( "_abrunwb.wrx":U ).
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
ELSE MESSAGE "_abrunwb.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".
END.
ELSE DO:
    MESSAGE " WebTools only runs in the 32-bit Windows GUI client."
        VIEW-AS ALERT-BOX.
    /*STOP.*/
    RETURN.
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

