&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: visuald.w 

  Description: Instance Properties Dialog for SmartMessageProducer SmartObjects.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  History:
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE attr-list   AS CHARACTER NO-UNDO.
DEFINE VARIABLE orig-layout AS CHARACTER NO-UNDO.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cDomain cPartition iPingInterval cUser ~
cPassword cClientID lPrompt iPriority dTimeToLive cPersistency cMessageType ~
RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS cDomain cPartition iPingInterval cUser ~
cPassword cClientID lPrompt iPriority dTimeToLive cPersistency cMessageType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cMessageType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Message Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE cPartition AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Partition" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE cPersistency AS CHARACTER FORMAT "X(256)":U 
     LABEL "Persistency" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "PERSISTENT","NON_PERSISTENT","NON_PERSISTENT_ASYNC","UNKNOWN" 
     DROP-DOWN-LIST
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE cClientID AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Client ID" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cPassword AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Password" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cUser AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS User" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE dTimeToLive AS DECIMAL FORMAT ">>>>>>9.99":U INITIAL 0 
     LABEL "Time To Live" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE iPingInterval AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Ping Interval" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE iPriority AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Priority" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE cDomain AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Publish and Subscribe", "PubSub",
"Point-to-Point", "PTP"
     SIZE 28 BY 2.14 TOOLTIP "Messaging Domain" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.33.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.48.

DEFINE VARIABLE lPrompt AS LOGICAL INITIAL no 
     LABEL "Prompt for JMS Login" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     cDomain AT ROW 1.76 COL 17.4 NO-LABEL
     cPartition AT ROW 4.19 COL 15 COLON-ALIGNED
     iPingInterval AT ROW 5.33 COL 15 COLON-ALIGNED
     cUser AT ROW 1.91 COL 62.8 COLON-ALIGNED
     cPassword AT ROW 3.05 COL 62.8 COLON-ALIGNED
     cClientID AT ROW 4.19 COL 62.8 COLON-ALIGNED
     lPrompt AT ROW 5.33 COL 64.8
     iPriority AT ROW 7.91 COL 17 COLON-ALIGNED
     dTimeToLive AT ROW 9.05 COL 17 COLON-ALIGNED
     cPersistency AT ROW 7.91 COL 52 COLON-ALIGNED
     cMessageType AT ROW 9.05 COL 52 COLON-ALIGNED
     RECT-1 AT ROW 1.38 COL 2
     RECT-2 AT ROW 7.19 COL 2
     "Domain:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 2.43 COL 8.4
     "Message Delivery Defaults" VIEW-AS TEXT
          SIZE 27 BY .62 AT ROW 6.91 COL 4
     "JMS Session" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 1.1 COL 4
     SPACE(75.39) SKIP(9.08)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartProducer Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   Custom                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* SmartProducer Properties */
DO:     
  /* Reassign the attribute values back in the SmartObject. */
  ASSIGN cDomain cPartition iPingInterval cUser cPassword cClientID lPrompt
    cMessageType iPriority dTimeToLive cPersistency.
         
  DYNAMIC-FUNCTION('setDomain':U IN p_hSMO, INPUT cDomain) NO-ERROR.
  DYNAMIC-FUNCTION('setClientID':U IN p_hSMO, INPUT cClientID) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSpartition':U IN p_hSMO, INPUT cPartition) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSuser':U IN p_hSMO, INPUT cUser) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSpassword':U IN p_hSMO, INPUT cPassword) NO-ERROR.
  DYNAMIC-FUNCTION('setPingInterval':U IN p_hSMO, INPUT iPingInterval) NO-ERROR.
  DYNAMIC-FUNCTION('setPromptLogin':U IN p_hSMO, INPUT lPrompt) NO-ERROR.
  DYNAMIC-FUNCTION('setMessageType':U IN p_hSMO, INPUT cMessageType) NO-ERROR.
  DYNAMIC-FUNCTION('setPriority':U IN p_hSMO, INPUT iPriority) NO-ERROR.
  DYNAMIC-FUNCTION('setTimeToLive':U IN p_hSMO, INPUT dTimeToLive) NO-ERROR.
  DYNAMIC-FUNCTION('setPersistency':U IN p_hSMO, INPUT cPersistency) NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* SmartProducer Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartProducer_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  /* Enable the interface. */         
  RUN enable_UI.  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
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
  DISPLAY cDomain cPartition iPingInterval cUser cPassword cClientID lPrompt 
          iPriority dTimeToLive cPersistency cMessageType 
      WITH FRAME Attribute-Dlg.
  ENABLE cDomain cPartition iPingInterval cUser cPassword cClientID lPrompt 
         iPriority dTimeToLive cPersistency cMessageType RECT-1 RECT-2 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR ldummy      AS LOGICAL   NO-UNDO.
  DEF VAR cJMSPartns  AS CHARACTER NO-UNDO.
  DEF VAR cTypes      AS CHARACTER NO-UNDO.

  ASSIGN cPartition:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3).
  cJMSPartns = DYNAMIC-FUNCTION('getJMSPartitions':U IN THIS-PROCEDURE).
  ASSIGN cPartition:LIST-ITEMS IN FRAME {&FRAME-NAME} = cJMSPartns.

  cTypes = DYNAMIC-FUNCTION('getSupportedMessageTypes':U IN p_hSMO).
  ASSIGN cMessageType:LIST-ITEMS IN FRAME {&FRAME-NAME} = cTypes.

  DO WITH FRAME {&FRAME-NAME}:   
    /* Get the attributes used in this Instance Attribute dialog-box. */
    cDomain       = DYNAMIC-FUNCTION('getDomain':U IN p_hSMO).
    cClientID     = DYNAMIC-FUNCTION('getClientID':U IN p_hSMO).
    cPartition    = DYNAMIC-FUNCTION('getJMSpartition':U IN p_hSMO).
    cUser         = DYNAMIC-FUNCTION('getJMSuser':U IN p_hSMO).
    cPassword     = DYNAMIC-FUNCTION('getJMSpassword':U IN p_hSMO).
    iPingInterval = DYNAMIC-FUNCTION('getPingInterval':U IN p_hSMO).
    lPrompt       = DYNAMIC-FUNCTION('getPromptLogin':U IN p_hSMO).
    cMessageType  = DYNAMIC-FUNCTION('getMessageType':U IN p_hSMO).
    iPriority     = DYNAMIC-FUNCTION('getPriority':U IN p_hSMO).
    dTimeToLive   = DYNAMIC-FUNCTION('getTimeToLive':U IN p_hSMO).
    cPersistency  = DYNAMIC-FUNCTION('getPersistency':U IN p_hSMO).

  END. /* DO WITH FRAME... */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

