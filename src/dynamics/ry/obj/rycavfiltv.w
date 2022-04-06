&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycavfiltv.w

  Description:  Attribute Value Filter Viewer

  Purpose:      Attribute Value Filter Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7754   UserRef:    
                Date:   30/01/2001  Author:     Anthony Swindells

  Update Notes: Attribute Maintenance Suite

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

&scop object-name       rycavfiltv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartObject yes

{af/sup2/afglobals.i}

{af/sup2/afttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coObjectType buRefresh fiContainer ~
ToAllContainers fiSmartObject ToAllSmartObjects 
&Scoped-Define DISPLAYED-OBJECTS coObjectType fiContainer ToAllContainers ~
fiSmartObject ToAllSmartObjects 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buRefresh 
     LABEL "&Refresh" 
     SIZE 15 BY 1.14 TOOLTIP "Refresh browser to only show data for selected group/type -plus existing filte"
     BGCOLOR 8 .

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 47.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiContainer AS CHARACTER FORMAT "X(256)":U 
     LABEL "Container" 
     VIEW-AS FILL-IN 
     SIZE 47.6 BY 1 TOOLTIP "Specify a single container object name or blank for 0" NO-UNDO.

DEFINE VARIABLE fiSmartObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "SmartObject" 
     VIEW-AS FILL-IN 
     SIZE 47.6 BY 1 TOOLTIP "Specify a single object name or blank for 0" NO-UNDO.

DEFINE VARIABLE ToAllContainers AS LOGICAL INITIAL no 
     LABEL "All" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 TOOLTIP "Tick to select all containers" NO-UNDO.

DEFINE VARIABLE ToAllSmartObjects AS LOGICAL INITIAL no 
     LABEL "All" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.2 BY .81 TOOLTIP "Tick to select all objects" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coObjectType AT ROW 1.19 COL 23.4 COLON-ALIGNED
     buRefresh AT ROW 1.19 COL 74.2
     fiContainer AT ROW 2.24 COL 23.4 COLON-ALIGNED
     ToAllContainers AT ROW 2.33 COL 74.2
     fiSmartObject AT ROW 3.29 COL 23.4 COLON-ALIGNED
     ToAllSmartObjects AT ROW 3.38 COL 74.2
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
         HEIGHT             = 4.1
         WIDTH              = 89.8.
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
   NOT-VISIBLE Size-to-Fit                                              */
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
DEFINE VARIABLE dContainer                  AS DECIMAL    NO-UNDO.        
DEFINE VARIABLE dSmartObject                AS DECIMAL    NO-UNDO.        

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    coObjectType
    fiContainer
    fiSmartObject
    toAllContainers
    toAllSmartObjects
    .

  /* Assumes a user1 link from viewer to browser */
  hBrowser = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'user1-Target')) NO-ERROR.
  IF VALID-HANDLE(hBrowser) THEN
    hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN hBrowser, 'data-source')) NO-ERROR.

  IF VALID-HANDLE(hSDO) THEN
  DO:
    IF coObjectType > 0 THEN
    DO:
      ASSIGN
        cField = "ryc_attribute_value.object_type_obj":U
        cWhere = cField + " = ":U + QUOTER(STRING(coObjectType))
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.
    ELSE
    DO:
      ASSIGN
        cField = "ryc_attribute_value.object_type_obj":U
        cWhere = "":U   /* get rid of criteria */
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.

    IF fiContainer <> "":U THEN
      RUN ry/app/rycsogobjp.p ON gshAstraAppserver (INPUT fiContainer, OUTPUT dContainer).
    ELSE ASSIGN dContainer = 0.

    IF fiSmartObject <> "":U THEN
      RUN ry/app/rycsogobjp.p ON gshAstraAppserver (INPUT fiSmartObject, OUTPUT dSmartObject).
    ELSE ASSIGN dSmartObject = 0.

    IF dContainer <> 0 OR toAllContainers = NO THEN
    DO:
      ASSIGN
        cField = "ryc_attribute_value.container_smartobject_obj":U
        cWhere = cField + " = ":U + QUOTER(STRING(dContainer))
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.
    ELSE
    DO:
      ASSIGN
        cField = "ryc_attribute_value.container_smartobject_obj":U
        cWhere = "":U   /* get rid of criteria */
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.

    IF dSmartObject <> 0 OR toAllSmartObjects = NO THEN
    DO:
      ASSIGN
        cField = "ryc_attribute_value.smartobject_obj":U
        cWhere = cField + " = ":U + QUOTER(STRING(dSmartObject))
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.
    ELSE
    DO:
      ASSIGN
        cField = "ryc_attribute_value.smartobject_obj":U
        cWhere = "":U   /* get rid of criteria */
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.

    DYNAMIC-FUNCTION('openQuery' IN hSDO).

  END.

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContainer sObject
ON LEAVE OF fiContainer IN FRAME frMain /* Container */
DO:
  IF SELF:SCREEN-VALUE <> "":U THEN
    ASSIGN toAllContainers:SCREEN-VALUE = "no":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSmartObject sObject
ON LEAVE OF fiSmartObject IN FRAME frMain /* SmartObject */
DO:
  IF SELF:SCREEN-VALUE <> "":U THEN
    ASSIGN toAllSmartObjects:SCREEN-VALUE = "no":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToAllContainers
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToAllContainers sObject
ON VALUE-CHANGED OF ToAllContainers IN FRAME frMain /* All */
DO:
  IF SELF:SCREEN-VALUE = "yes":U THEN
    ASSIGN fiContainer:SCREEN-VALUE = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToAllSmartObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToAllSmartObjects sObject
ON VALUE-CHANGED OF ToAllSmartObjects IN FRAME frMain /* All */
DO:
  IF SELF:SCREEN-VALUE = "yes":U THEN
    ASSIGN fiSmartObject:SCREEN-VALUE = "":U.
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
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_obj":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_code, gsc_object_type.object_type_description":U
    ttComboData.cDescSubstitute = "&1 / &2":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  /* build combo list-item pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

  /* and set-up combos */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
  coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* Select 1st entry */
  IF coObjectType:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coObjectType:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE
    DO:
      /* blank the combo */
      coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
    END.
  END.

END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

