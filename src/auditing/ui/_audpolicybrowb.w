&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bTableWin 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adm2\src\browser.w

  Description: SmartDataBrowser Object

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{auditing/include/_aud-std.i}

{src/adm2/widgetprto.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS TableIO-Target,Data-Target,Update-Source

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "auditing/sdo/_audpolicysdo.i"

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES rowObject

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table rowObject._Audit-policy-name ~
rowObject._Audit-policy-description rowObject._Audit-policy-active 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH rowObject NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table rowObject
&Scoped-define FIRST-TABLE-IN-QUERY-br_table rowObject


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-br_table 
       MENU-ITEM m_Activate_Policies LABEL "&Activate Policies"
       MENU-ITEM m_Deactivate_Policies LABEL "&Deactivate Policies"
       MENU-ITEM m_Export_Policy LABEL "&Export Policy"
       MENU-ITEM m_Import_Policy LABEL "&Import Policy"
       RULE
       MENU-ITEM m_Report_Conflicts LABEL "&Report Conflicts"
       MENU-ITEM m_Report_Merge LABEL "Report Effective &Settings".


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE TEMP-TABLE RowObject NO-UNDO
    {{&DATA-FIELD-DEFS}}
    {src/adm2/robjflds.i}.

DEFINE QUERY br_table FOR 
      rowObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table bTableWin _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      rowObject._Audit-policy-name FORMAT "X(35)":U WIDTH 40
      rowObject._Audit-policy-description FORMAT "X(70)":U WIDTH 89.4
      rowObject._Audit-policy-active COLUMN-LABEL "Active" FORMAT "YES/NO":U
            WIDTH 22.6
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN NO-AUTO-VALIDATE NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 158 BY 7.14
         TITLE "Available Audit Policies" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 22.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataBrowser
   Data Source: "auditing/sdo/_audpolicysdo.w"
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW bTableWin ASSIGN
         HEIGHT             = 7.38
         WIDTH              = 158.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW bTableWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN 
       br_table:POPUP-MENU IN FRAME F-Main             = MENU POPUP-MENU-br_table:HANDLE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "rowObject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > _<SDO>.rowObject._Audit-policy-name
"rowObject._Audit-policy-name" ? ? "character" ? ? ? ? ? ? no "?" no no "40" yes no no "U" "" ""
     _FldNameList[2]   > _<SDO>.rowObject._Audit-policy-description
"rowObject._Audit-policy-description" ? ? "character" ? ? ? ? ? ? no "?" no no "89.4" yes no no "U" "" ""
     _FldNameList[3]   > _<SDO>.rowObject._Audit-policy-active
"rowObject._Audit-policy-active" "Active" ? "logical" ? ? ? ? ? ? no ? no no "22.6" yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-END OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  APPLY "END":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CTRL-HOME OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  APPLY "HOME":U TO BROWSE {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CURSOR-DOWN OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {&BROWSE-NAME}:SELECT-NEXT-ROW() NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
      APPLY "value-changed" TO {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON CURSOR-UP OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {&BROWSE-NAME}:SELECT-PREV-ROW() NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN
      APPLY "value-changed" TO {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON DEFAULT-ACTION OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsdefault.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON END OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsend.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON HOME OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brshome.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-EXTEND-UP OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  /* If user is deselecting the current row and that's the only row selected,
     reselect the row. We have to always keep a row selected, in case they
     delete a record. We are using a multiple-selection browse and ADM2 doesn't
     support multiple-selection browses so we have to do all the job.
  */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN
     {&BROWSE-NAME}:SELECT-FOCUSED-ROW() NO-ERROR.
  ELSE IF {&BROWSE-NAME}:NUM-SELECTED-ROWS = 1 AND 
      NOT {&BROWSE-NAME}:FOCUSED-ROW-SELECTED THEN DO:
      /* user deselected a row but there is another row which is
         selected and has no focus - move focus to that row 
      */
      {&BROWSE-NAME}:FETCH-SELECTED-ROW(1).
      {&BROWSE-NAME}:QUERY:REPOSITION-TO-ROWID({&BROWSE-NAME}:QUERY:GET-BUFFER-HANDLE(1):ROWID).
      APPLY "value-changed" TO {&BROWSE-NAME}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON MOUSE-SELECT-CLICK OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  /* since this is a multiple-selection browse, and we handle the case where
     the user may have tried to deselect all rows with the mouse, we need
     to apply value-changed to the browse when the user selects on a row ,
     just so we are sure we are displaying the same record in the smartviewer
  */
  APPLY "value-changed" TO {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-END OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsoffnd.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON OFF-HOME OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsoffhm.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-ENTRY OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON ROW-LEAVE OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON SCROLL-NOTIFY OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
  {src/adm2/brsscrol.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table bTableWin
ON VALUE-CHANGED OF br_table IN FRAME F-Main /* Available Audit Policies */
DO:
DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.

    /* if selecting multiple rows, don't change the record seen in the viewer */
    IF {&BROWSE-NAME}:NUM-SELECTED-ROWS > 1 THEN DO:
        ASSIGN hDataSource = DYNAMIC-FUNCTION('getDataSource').

        /* fetch first selected row and reposition to it */
        {&BROWSE-NAME}:FETCH-SELECTED-ROW(1).
        
        {&BROWSE-NAME}:QUERY:REPOSITION-TO-ROWID({&BROWSE-NAME}:QUERY:GET-BUFFER-HANDLE(1):ROWID).

        /* publish this so we display the info from the first row selected 
           in the smartviewer
        */
        PUBLISH 'dataAvailable' FROM hDataSource ("DIFFERENT":U).
        
        RETURN.
    END.

  {src/adm2/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Activate_Policies
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Activate_Policies bTableWin
ON CHOOSE OF MENU-ITEM m_Activate_Policies /* Activate Policies */
DO:
DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

    ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

    /* even though the container will eventually call a function in this procedure
       we need to call the function in the caller that checks for uncommitted data 
    */
    IF VALID-HANDLE (hContainerSource) THEN
       RUN doActivatePolicies IN hContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Deactivate_Policies
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Deactivate_Policies bTableWin
ON CHOOSE OF MENU-ITEM m_Deactivate_Policies /* Deactivate Policies */
DO:
DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

    ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
    
    /* even though the container will eventually call a function in this procedure
       we need to call the function in the caller that checks for uncommitted data 
    */
    IF VALID-HANDLE (hContainerSource) THEN
       RUN doDeactivatePolicies IN hContainerSource.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Export_Policy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Export_Policy bTableWin
ON CHOOSE OF MENU-ITEM m_Export_Policy /* Export Policy */
DO:

DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

   ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

   IF VALID-HANDLE(hContainerSource) THEN
      RUN doExportPolicy IN hContainerSource.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Import_Policy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Import_Policy bTableWin
ON CHOOSE OF MENU-ITEM m_Import_Policy /* Import Policy */
DO:
  
DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

    ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

    IF VALID-HANDLE (hContainerSource) THEN
       RUN doImportPolicy IN hContainerSource.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Report_Conflicts
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Report_Conflicts bTableWin
ON CHOOSE OF MENU-ITEM m_Report_Conflicts /* Report Conflicts */
DO:
DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

   ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

   IF VALID-HANDLE(hContainerSource) THEN
      RUN doReportConflicts IN hContainerSource.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Report_Merge
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Report_Merge bTableWin
ON CHOOSE OF MENU-ITEM m_Report_Merge /* Report Effective Settings */
DO:
DEFINE VARIABLE hContainerSource  AS HANDLE  NO-UNDO.

   ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).

   IF VALID-HANDLE(hContainerSource) THEN
      RUN doReportMerge IN hContainerSource.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME POPUP-MENU-br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL POPUP-MENU-br_table bTableWin
ON MENU-DROP OF MENU POPUP-MENU-br_table
DO:
DEFINE VARIABLE hContainerSource AS HANDLE  NO-UNDO.
DEFINE VARIABLE lReadOnly        AS LOGICAL NO-UNDO INIT NO.

    ASSIGN hContainerSource  = DYNAMIC-FUNCTION('getContainerSource').

    IF VALID-HANDLE (hContainerSource) THEN DO:

        ASSIGN lReadOnly = DYNAMIC-FUNCTION('isCurrentDbReadOnly':U IN hContainerSource) NO-ERROR.

        IF lReadOnly THEN
           ASSIGN MENU-ITEM m_Activate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = NO
                  MENU-ITEM m_Deactivate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = NO
                  MENU-ITEM m_Import_Policy:SENSITIVE IN MENU POPUP-MENU-br_table = NO.
       ELSE
           ASSIGN MENU-ITEM m_Activate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = YES
                       MENU-ITEM m_Deactivate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = YES
                       MENU-ITEM m_Import_Policy:SENSITIVE IN MENU POPUP-MENU-br_table = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bTableWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN initializeObject.        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activatePolicies bTableWin 
PROCEDURE activatePolicies :
/*------------------------------------------------------------------------------
  Purpose:     Set the active flag of the selected policies in the browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* retrun message if no policies are selected */
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    RETURN 'You must select at least one policy in the browse'.
END.

/* ask for confirmation */
MESSAGE "Are you sure you want to activate the selected policies?" SKIP
    "(Note that you must commit this change afterwards for it to become effective)"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE choice AS LOGICAL.

IF choice THEN DO:
   RUN setActiveFlag(YES).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adjustReposition bTableWin 
PROCEDURE adjustReposition :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* if there are records and nothing is selected in the browse, make sure
     we select the first row in the viewport since this is what the user will
     see in the smartviewer. The browse is a multiple-selection browse and
     we don't want to leave no row selected.
  */
  IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN
     {&BROWSE-NAME}:SELECT-ROW(1) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPopupMenu bTableWin 
PROCEDURE createPopupMenu :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

 /* don't run super - we don't need any of the menu items and sub-menus that
    adm2 creates for column size control, etc*/
                    
 /* RUN SUPER.*/

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deactivatePolicies bTableWin 
PROCEDURE deactivatePolicies :
/*------------------------------------------------------------------------------
  Purpose:     Turns the active flag off of the selected policies in the browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* return a message if no policies are selected */
IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN DO:
    RETURN 'You must select at least one policy in the browse'.
END.

MESSAGE "Are you sure you want to deactivate the selected policies?" SKIP
    "(Note that you must commit this change afterwards for it to become effective)"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE choice AS LOGICAL.

IF choice THEN DO:
   RUN setActiveFlag(NO).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSelectedPolicies bTableWin 
PROCEDURE getSelectedPolicies :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-separated list with the name of the selected policies 
               in the browse
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cList AS CHAR NO-UNDO.

DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

DEFINE VARIABLE hQuery       AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer      AS HANDLE  NO-UNDO.
DEFINE VARIABLE cValue       AS CHAR    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    ASSIGN hQuery = {&BROWSE-NAME}:QUERY
           hBuffer = hQuery:GET-BUFFER-HANDLE(1).

    DO iCount = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        {&BROWSE-NAME}:FETCH-SELECTED-ROW(iCount).
        IF iCount = 1 THEN DO:
            ASSIGN cValue = hBuffer::_Audit-policy-name
                   cList = cValue.
        END.
        ELSE DO:
            ASSIGN cValue = hBuffer::_Audit-policy-name
                   cList = cList + "," + cValue.
        END.
        
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition bTableWin 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER( INPUT pcState).

  /* Code placed here will execute AFTER standard behavior.    */

  /* if there are records and nothing is selected in the browse, make sure
     we select the first row in the viewport since this is what the user will
     see in the smartviewer. The browse is a multiple-selection browse and
     we don't want to leave no row selected.
  */
  IF pcState = "OnlyRecord":U OR pcstate = "FirstRecord":U THEN DO:
      IF {&BROWSE-NAME}:NUM-SELECTED-ROWS IN FRAME {&FRAME-NAME} = 0 THEN
         {&BROWSE-NAME}:SELECT-ROW(1) NO-ERROR.
  END.
  ELSE {&BROWSE-NAME}:SELECT-FOCUSED-ROW() NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshPopuMenu bTableWin 
PROCEDURE refreshPopuMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER isReadOnly AS LOGICAL NO-UNDO.

   IF isReadOnly THEN DO:
       ASSIGN MENU-ITEM m_Activate_Policies:SENSITIVE  IN MENU POPUP-MENU-br_table = NO
              MENU-ITEM m_Deactivate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = NO
              MENU-ITEM m_Import_Policy:SENSITIVE IN MENU POPUP-MENU-br_table = NO.
   END.
   ELSE DO:
       ASSIGN MENU-ITEM m_Activate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = YES
                   MENU-ITEM m_Deactivate_Policies:SENSITIVE IN MENU POPUP-MENU-br_table = YES
                   MENU-ITEM m_Import_Policy:SENSITIVE IN MENU POPUP-MENU-br_table = YES.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setActiveFlag bTableWin 
PROCEDURE setActiveFlag :
/*------------------------------------------------------------------------------
  Purpose:     Sets the active flag of the selected policies. We fetch the records from the
               datasource and update the 'active' field.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER isActive AS LOGICAL NO-UNDO.

DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

DEFINE VARIABLE hQuery       AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer      AS HANDLE  NO-UNDO.
DEFINE VARIABLE hDataSource  AS HANDLE  NO-UNDO.

ASSIGN hDataSource = DYNAMIC-FUNCTION('getDataSource':U)
       hQuery      = DYNAMIC-FUNCTION('getDataHandle':U IN hDataSource)
       hBuffer     = hQuery:GET-BUFFER-HANDLE(1) NO-ERROR.

DO WITH FRAME {&FRAME-NAME}:
    DO iCount = 1 TO {&BROWSE-NAME}:NUM-SELECTED-ROWS:
        {&BROWSE-NAME}:FETCH-SELECTED-ROW(iCount).
         DYNAMIC-FUNCTION("updateRow":U IN hDataSource, ?, 
                 "_audit-policy-active" + CHR(1) + STRING(isActive)).

    END.
    {&BROWSE-NAME}:REFRESH().
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

