&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscerfiltv.w

  Description:  Error Filter Viewer

  Purpose:      Error Filter Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000033   UserRef:    
                Date:   22/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttsimpv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscerfiltv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcSavedLanguage                AS CHARACTER  NO-UNDO.

{af/sup2/afttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiErrorGroup buRefresh coLanguage 
&Scoped-Define DISPLAYED-OBJECTS fiErrorGroup coLanguage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh browser to only show data for selected Language (plus existing filters)"
     BGCOLOR 8 .

DEFINE VARIABLE coLanguage AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Language" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 47.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiErrorGroup AS CHARACTER FORMAT "X(256)":U 
     LABEL "Error group" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiErrorGroup AT ROW 1 COL 14.6 COLON-ALIGNED
     buRefresh AT ROW 2.1 COL 65.4
     coLanguage AT ROW 2.14 COL 14.6 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 2.86
         WIDTH              = 82.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buRefresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRefresh sObject
ON CHOOSE OF buRefresh IN FRAME frMain /* Refresh */
DO:

DEFINE VARIABLE hBrowser                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSDO                        AS HANDLE     NO-UNDO.
DEFINE VARIABLE cLinkHandles                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cManualAddQueryWhere        AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cQueryString                AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cQueryColumns               AS CHARACTER  NO-UNDO.        

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN coLanguage fiErrorGroup.


  /* Assumes a user1 link from viewer to browser */
  hBrowser = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'user1-Target')) NO-ERROR.
  IF VALID-HANDLE(hBrowser) THEN
    hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN hBrowser, 'data-source')) NO-ERROR.

  IF VALID-HANDLE(hSDO) THEN
  DO:
    IF coLanguage <> 0 THEN
      ASSIGN
        cField = "language_obj":U /* can also add table name if required here */
        cWhere = cField + " = '":U + STRING(coLanguage) + "'":U. 
    IF fiErrorGroup <> "":U THEN
      ASSIGN
        cField = "error_group":U /* can also add table name if required here */
        cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " AND ":U)
               + cField + " BEGINS '":U + fiErrorGroup + "'":U  .

    IF cField = '':U THEN 
    DO:
      RUN updateAddQueryWhere IN hSDO (INPUT '':U, INPUT 'language_obj':U).
      RUN updateAddQueryWhere IN hSDO (INPUT '':U, INPUT 'error_group':U).
    END.  /* if no criteria is chosen */
    ELSE RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField). 
    DYNAMIC-FUNCTION('openQuery' IN hSDO).

  END.

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage sObject
ON ENTRY OF coLanguage IN FRAME frMain /* Language */
DO:
  ASSIGN gcSavedLanguage = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage sObject
ON RETURN OF coLanguage IN FRAME frMain /* Language */
DO:
  APPLY 'CHOOSE':U TO buRefresh.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coLanguage sObject
ON VALUE-CHANGED OF coLanguage IN FRAME frMain /* Language */
DO:
  IF gcSavedLanguage <> SELF:SCREEN-VALUE THEN
  DO:
    ASSIGN gcSavedLanguage = SELF:SCREEN-VALUE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiErrorGroup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiErrorGroup sObject
ON RETURN OF fiErrorGroup IN FRAME frMain /* Error group */
DO:
  APPLY 'CHOOSE':U TO buRefresh.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  RUN populateCombos.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos sObject 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cEntry                          AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coLanguage":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coLanguage:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_language NO-LOCK BY gsc_language.language_code":U
    ttComboData.cBufferList = "gsc_language":U
    ttComboData.cKeyFieldName = "gsc_language.language_obj":U
    ttComboData.cDescFieldNames = "gsc_language.language_code":U
    ttComboData.cDescSubstitute = "&1":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  /* build combo list-item pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

  /* and set-up combos */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coLanguage":U.
  coLanguage:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* Select 1st entry */
  IF coLanguage:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coLanguage:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coLanguage:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE
    DO:
      /* blank the combo */
      coLanguage:LIST-ITEM-PAIRS = coLanguage:LIST-ITEM-PAIRS.
    END.
  END.

END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

