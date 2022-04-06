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
  File: rycatfiltv.w

  Description:  Attribute Filter Viewer

  Purpose:      Attribute Filter Viewer

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

&scop object-name       rycatfiltv.w
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
&Scoped-Define ENABLED-OBJECTS coGroup buRefresh coDataType 
&Scoped-Define DISPLAYED-OBJECTS coGroup coDataType 

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

DEFINE VARIABLE coDataType AS INTEGER FORMAT "->>9":U INITIAL 0 
     LABEL "Data type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<All>",0,
                     "Character",1,
                     "Date",2,
                     "Logical",3,
                     "Integer",4,
                     "Decimal",5,
                     "Recid",7,
                     "Raw",8,
                     "Rowid",9,
                     "Handle",10,
                     "Memptr",11,
                     "Com-handle",14
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE coGroup AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Attribute group" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coGroup AT ROW 1 COL 19 COLON-ALIGNED
     buRefresh AT ROW 1.91 COL 71.8
     coDataType AT ROW 2.05 COL 19 COLON-ALIGNED
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
         HEIGHT             = 2.14
         WIDTH              = 88.
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

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    coGroup
    coDataType
    .
  /* Assumes a user1 link from viewer to browser */
  hBrowser = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN THIS-PROCEDURE, 'user1-Target')) NO-ERROR.
  IF VALID-HANDLE(hBrowser) THEN
    hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles' IN hBrowser, 'data-source')) NO-ERROR.

  IF VALID-HANDLE(hSDO) THEN
  DO:
    IF coDataType <> 0 THEN DO:
      ASSIGN
        cField = "ryc_attribute.data_type":U
        cWhere = cField + " = ":U + STRING(coDataType)
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.
    ELSE
    DO:
      ASSIGN
        cField = "ryc_attribute.data_type":U
        cWhere = "":U   /* get rid of criteria */
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
    END.
    
    IF coGroup > 0 THEN
    DO:
      ASSIGN
        cField = "ryc_attribute.attribute_group_obj":U
        cWhere = cField + " = ":U + QUOTER(coGroup)
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
      {fnarg setUserProperty "'AttributeGroupObj':U, coGroup" hSDO}.
    END.
    ELSE
    DO:
      ASSIGN
        cField = "ryc_attribute.attribute_group_obj":U
        cWhere = "":U   /* get rid of criteria */
        .
      RUN updateAddQueryWhere IN hSDO (INPUT cWhere, INPUT cField).
      {fnarg setUserProperty "'AttributeGroupObj':U, ''" hSDO}.
    END.

    DYNAMIC-FUNCTION('openQuery' IN hSDO).

  END.

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects sObject  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    ttComboData.cWidgetName = "coGroup":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coGroup:HANDLE
    ttComboData.cForEach = "FOR EACH ryc_attribute_group NO-LOCK BY ryc_attribute_group.attribute_group_name":U
    ttComboData.cBufferList = "ryc_attribute_group":U
    ttComboData.cKeyFieldName = "ryc_attribute_group.attribute_group_obj":U
    ttComboData.cDescFieldNames = "ryc_attribute_group.attribute_group_name":U
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
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coGroup":U.
  coGroup:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* Select 1st entry */
  IF coGroup:NUM-ITEMS > 0 THEN
  DO:
    cEntry = coGroup:ENTRY(1) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
      coGroup:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE
    DO:
      /* blank the combo */
      coGroup:LIST-ITEM-PAIRS = coGroup:LIST-ITEM-PAIRS.
    END.
  END.

  ASSIGN coDataType:SCREEN-VALUE = coDataType:ENTRY(1).
END. /* {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

