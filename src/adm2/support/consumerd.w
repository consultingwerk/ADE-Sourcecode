&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
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
DEFINE VARIABLE attr-list      AS CHARACTER NO-UNDO.
DEFINE VARIABLE orig-layout    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDestinations  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSubscriptions AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSelectors     AS CHARACTER NO-UNDO.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cDomain cPartition iPingInterval cLogFile ~
cShutDown cUser cPassword cClientID lPrompt RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS cDomain cPartition iPingInterval cLogFile ~
cShutDown cUser cPassword cClientID lPrompt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dconsumer AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynbrowser AS HANDLE NO-UNDO.
DEFINE VARIABLE h_pupdsav AS HANDLE NO-UNDO.
DEFINE VARIABLE h_vconsumer AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cPartition AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Partition" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE cClientID AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Client ID" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cLogFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Log File" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE cPassword AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS Password" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE cShutDown AS CHARACTER FORMAT "X(256)":U 
     LABEL "Shutdown" 
     VIEW-AS FILL-IN 
     SIZE 55 BY 1 NO-UNDO.

DEFINE VARIABLE cUser AS CHARACTER FORMAT "X(256)":U 
     LABEL "JMS User" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE iPingInterval AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Ping Interval" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE cDomain AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Publish and Subscribe", "PubSub",
"Point-to-Point", "PTP"
     SIZE 28 BY 2.14 TOOLTIP "Messaging Domain" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 7.71.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 106 BY 14.05.

DEFINE VARIABLE lPrompt AS LOGICAL INITIAL no 
     LABEL "Prompt for JMS Login" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     cDomain AT ROW 1.76 COL 18.6 NO-LABEL
     cPartition AT ROW 4.19 COL 16.2 COLON-ALIGNED
     iPingInterval AT ROW 5.33 COL 16.2 COLON-ALIGNED
     cLogFile AT ROW 6.48 COL 16.2 COLON-ALIGNED
     cShutDown AT ROW 7.62 COL 16.2 COLON-ALIGNED
     cUser AT ROW 1.91 COL 78 COLON-ALIGNED
     cPassword AT ROW 3.05 COL 78 COLON-ALIGNED
     cClientID AT ROW 4.19 COL 78 COLON-ALIGNED
     lPrompt AT ROW 5.33 COL 80
     RECT-1 AT ROW 1.38 COL 2
     RECT-2 AT ROW 9.67 COL 2
     "Destinations" VIEW-AS TEXT
          SIZE 13 BY .62 AT ROW 9.33 COL 4
     "JMS Session" VIEW-AS TEXT
          SIZE 14 BY .62 AT ROW 1.1 COL 4
     SPACE(90.59) SKIP(22.08)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartConsumer Properties".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   Custom                                                               */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON GO OF FRAME gDialog /* SmartConsumer Properties */
DO:

  /* Reassign the attribute values back in the SmartObject. */
  ASSIGN cDomain cPartition iPingInterval cUser cPassword cClientID cLogFile lPrompt cShutDown.

  RUN returnDestinations IN h_dconsumer
    (INPUT  cDomain /* CHARACTER */,
     OUTPUT cDestinations /* CHARACTER */,
     OUTPUT cSelectors /* CHARACTER */,
     OUTPUT cSubscriptions /* CHARACTER */).
                             
  DYNAMIC-FUNCTION('setDomain':U IN p_hSMO, INPUT cDomain) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSpartition':U IN p_hSMO, INPUT cPartition) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSuser':U IN p_hSMO, INPUT cUser) NO-ERROR.
  DYNAMIC-FUNCTION('setJMSpassword':U IN p_hSMO, INPUT cPassword) NO-ERROR.
  DYNAMIC-FUNCTION('setClientID':U IN p_hSMO, INPUT cClientID) NO-ERROR.
  DYNAMIC-FUNCTION('setLogFile':U IN p_hSMO, INPUT cLogFile) NO-ERROR.
  DYNAMIC-FUNCTION('setPingInterval':U IN p_hSMO, INPUT iPingInterval) NO-ERROR.
  DYNAMIC-FUNCTION('setPromptLogin':U IN p_hSMO, INPUT lPrompt) NO-ERROR.
  DYNAMIC-FUNCTION('setDestinations':U IN p_hSMO, INPUT cDestinations) NO-ERROR.
  DYNAMIC-FUNCTION('setSubscriptions':U IN p_hSMO, INPUT cSubscriptions) NO-ERROR.
  DYNAMIC-FUNCTION('setSelectors':U IN p_hSMO, INPUT cSelectors) NO-ERROR.
  DYNAMIC-FUNCTION('setShutDownDest':U IN p_hSMO, INPUT cShutDown) NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* SmartConsumer Properties */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDomain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDomain gDialog
ON VALUE-CHANGED OF cDomain IN FRAME gDialog
DO:
  RUN changeDomain IN h_vconsumer (INPUT cDomain:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&SmartConsumer_Instance_Properties_Dialog_Box} }

/* ***************************  Main Block  *************************** */

{src/adm2/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/support/dconsumer.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch200CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedconsumer':U ,
             OUTPUT h_dconsumer ).
       RUN repositionObject IN h_dconsumer ( 10.86 , 93.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       RUN constructObject (
             INPUT  'adm2/dynbrowser.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'DisplayedFieldsdestinationEnabledFieldsSearchFieldNumDown5CalcWidthnoMaxWidth80HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynbrowser ).
       RUN repositionObject IN h_dynbrowser ( 10.14 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_dynbrowser ( 5.24 , 52.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/support/vconsumer.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_vconsumer ).
       RUN repositionObject IN h_vconsumer ( 15.86 , 7.00 ) NO-ERROR.
       /* Size in AB:  ( 5.19 , 81.00 ) */

       RUN constructObject (
             INPUT  'adm2/pupdsav.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AddFunctionOne-RecordEdgePixels2PanelTypeSaveHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_pupdsav ).
       RUN repositionObject IN h_pupdsav ( 21.57 , 7.00 ) NO-ERROR.
       RUN resizeObject IN h_pupdsav ( 1.57 , 95.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_dynbrowser. */
       RUN addLink ( h_dconsumer , 'Data':U , h_dynbrowser ).

       /* Links to SmartDataViewer h_vconsumer. */
       RUN addLink ( h_dconsumer , 'Data':U , h_vconsumer ).
       RUN addLink ( h_vconsumer , 'Update':U , h_dconsumer ).
       RUN addLink ( h_pupdsav , 'TableIO':U , h_vconsumer ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynbrowser ,
             lPrompt:HANDLE , 'AFTER':U ).
       RUN adjustTabOrder ( h_vconsumer ,
             h_dynbrowser , 'AFTER':U ).
       RUN adjustTabOrder ( h_pupdsav ,
             h_vconsumer , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects gDialog 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN get-SMO-properties.
  RUN createDestinations IN h_dconsumer 
    (INPUT cDestinations,
     INPUT cSelectors,
     INPUT cSubscriptions).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY cDomain cPartition iPingInterval cLogFile cShutDown cUser cPassword 
          cClientID lPrompt 
      WITH FRAME gDialog.
  ENABLE cDomain cPartition iPingInterval cLogFile cShutDown cUser cPassword 
         cClientID lPrompt RECT-1 RECT-2 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SMO-properties gDialog 
PROCEDURE get-SMO-properties :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the properties that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR cJMSPartns AS CHARACTER NO-UNDO.
  DEF VAR cRowIdent  AS CHARACTER NO-UNDO.
  DEF VAR cSub       AS CHARACTER NO-UNDO.
  DEF VAR cValueList AS CHARACTER NO-UNDO.
  DEF VAR ldummy     AS LOGICAL   NO-UNDO.
  DEF VAR iNumDest   AS INTEGER   NO-UNDO. 

  ASSIGN cPartition:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3).
  cJMSPartns = DYNAMIC-FUNCTION('getJMSPartitions':U IN THIS-PROCEDURE).
  ASSIGN cPartition:LIST-ITEMS IN FRAME {&FRAME-NAME} = cJMSPartns.

  DO WITH FRAME {&FRAME-NAME}:   
    /* Get the attributes used in this Instance Attribute dialog-box. */
    cDomain        = DYNAMIC-FUNCTION('getDomain':U IN p_hSMO).
    cPartition     = DYNAMIC-FUNCTION('getJMSpartition':U IN p_hSMO).
    cLogFile       = DYNAMIC-FUNCTION('getLogFile':U IN p_hSMO).
    iPingInterval  = DYNAMIC-FUNCTION('getPingInterval':U IN p_hSMO).
    lPrompt        = DYNAMIC-FUNCTION('getPromptLogin':U IN p_hSMO).
    cUser          = DYNAMIC-FUNCTION('getJMSuser':U IN p_hSMO).
    cPassword      = DYNAMIC-FUNCTION('getJMSpassword':U IN p_hSMO).
    cClientID      = DYNAMIC-FUNCTION('getClientID':U IN p_hSMO).
    cDestinations  = DYNAMIC-FUNCTION('getDestinations':U IN p_hSMO).
    cSubscriptions = DYNAMIC-FUNCTION('getSubscriptions':U IN p_hSMO).
    cSelectors     = DYNAMIC-FUNCTION('getSelectors':U IN p_hSMO).
    cShutDown      = DYNAMIC-FUNCTION('getShutDownDest':U IN p_hSMO).

  END. /* DO WITH FRAME... */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  APPLY "VALUE-CHANGED":U TO cDomain IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

