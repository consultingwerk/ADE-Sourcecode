&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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
DEFINE VARIABLE ghSO         AS HANDLE NO-UNDO.
DEFINE VARIABLE gcObjectName AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fDataFrame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lDataDriven rRect 
&Scoped-Define DISPLAYED-OBJECTS cType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapName sObject 
FUNCTION getMapName RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMapType sObject 
FUNCTION getMapType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectName sObject 
FUNCTION getObjectName RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObject sObject 
FUNCTION initDataObject RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initFields sObject 
FUNCTION initFields RETURNS LOGICAL
  (plSensitive AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initMapName sObject 
FUNCTION initMapName RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initSmartObject sObject 
FUNCTION initSmartObject RETURNS LOGICAL
  (phObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD storeSMOProperties sObject 
FUNCTION storeSMOProperties RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cDataObject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data Object" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "<SmartDataObject>","<>"
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE cMapName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Column" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.6 BY 1 NO-UNDO.

DEFINE VARIABLE cType AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Column", "Column",
"Function", "Function"
     SIZE 32 BY .71 NO-UNDO.

DEFINE RECTANGLE rRect
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93 BY 4.

DEFINE VARIABLE lDataDriven AS LOGICAL INITIAL no 
     LABEL "Document Name Data" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fDataFrame
     lDataDriven AT ROW 1 COL 3
     cDataObject AT ROW 1.95 COL 15 COLON-ALIGNED
     cType AT ROW 3.05 COL 16.8 NO-LABEL
     cMapName AT ROW 3.91 COL 15 COLON-ALIGNED
     rRect AT ROW 1.38 COL 1
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
         HEIGHT             = 5.62
         WIDTH              = 95.2.
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
/* SETTINGS FOR FRAME fDataFrame
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME fDataFrame:SCROLLABLE       = FALSE
       FRAME fDataFrame:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cDataObject IN FRAME fDataFrame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX cMapName IN FRAME fDataFrame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RADIO-SET cType IN FRAME fDataFrame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX lDataDriven IN FRAME fDataFrame
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fDataFrame
/* Query rebuild information for FRAME fDataFrame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME fDataFrame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cDataObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDataObject sObject
ON VALUE-CHANGED OF cDataObject IN FRAME fDataFrame /* Data Object */
DO:
  ASSIGN cDataObject.
  initMapName().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cMapName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cMapName sObject
ON VALUE-CHANGED OF cMapName IN FRAME fDataFrame /* Column */
DO:
  ASSIGN cMapName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cType sObject
ON VALUE-CHANGED OF cType IN FRAME fDataFrame
DO:
  ASSIGN 
    cType.
  initMapName().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lDataDriven
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lDataDriven sObject
ON VALUE-CHANGED OF lDataDriven IN FRAME fDataFrame /* Document Name Data */
DO:
  ASSIGN lDataDriven.
  IF lDataDriven THEN
  DO:
    initDataObject().
    ASSIGN cDataObject.
    
    IF cDataObject = '':U THEN
    DO:
      MESSAGE "You need to have at least one Data Object present"
              "in the window in order to use this feature."  
      VIEW-AS ALERT-BOX WARNING.         
      lDataDriven  = FALSE.
    END.
    ELSE 
      initMapName().
  END.
  SELF:CHECKED = lDataDriven.
  initFields(lDataDriven). 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields sObject 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  initFields(FALSE).
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
  HIDE FRAME fDataFrame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields sObject 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  initFields(TRUE).
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
  DEFINE VARIABLE hContainer  AS HANDLE NO-UNDO.
  DEFINE VARIABLE hSmart      AS HANDLE NO-UNDO.

  hContainer = DYNAMIC-FUNCTION('getContainerSource':U).
  
  IF VALID-HANDLE(hContainer) THEN
  DO:
    hSmart = DYNAMIC-FUNCTION('getSmartObject':U IN hContainer).  
    initSmartObject(hSmart).
  END.
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapName sObject 
FUNCTION getMapName RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN cMapName:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMapType sObject 
FUNCTION getMapType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN cType:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectName sObject 
FUNCTION getObjectName RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN cDataObject:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObject sObject 
FUNCTION initDataObject RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: find all SDOs and SBOs in the container and add them to the 
           cDataObject list-item-pairs   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectId    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSiblings    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSmo         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSmartObjId  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER    NO-UNDO.
  
  /* Get Context id of current window */
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT cObjectID).
  
  /* Get all SmartObjects of the container */
  RUN adeuib/_uibinfo.p (cObjectId,
                         "":U, 
                         "contains SmartObject return context":U, 
                         OUTPUT cSiblings).
  
  DO WITH FRAME {&FRAME-NAME}:
    cDataObject:LIST-ITEM-PAIRS = ",":U.
    cDataObject:DELETE(1). 
    DO i = 1 TO NUM-ENTRIES(cSiblings):
    
      cSmartObjId = ENTRY(i,cSiblings).
    
      RUN adeuib/_uibinfo.p (cSmartObjID,
                             "":U, 
                             "procedure-handle":U, 
                             OUTPUT cHandle).

      hSmo  = WIDGET-HANDLE(cHandle).
      /* Skip the B2B we are working on */
      IF hSmo <> ghSO THEN
      DO: 
        cObjectType = DYNAMIC-FUNCTION('getObjectType':U IN hSmo).
        IF CAN-DO("SmartDataObject,SmartBusinessObject":U,cObjectType) THEN
        DO:
          cObjectName = DYNAMIC-FUNCTION('getObjectName':U IN hSmo).
          cDataObject:ADD-LAST(cObjectName,cHandle).
          IF cObjectName = gcObjectName THEN
             cdataObject = cHandle.
        END.
      END. /* SDO or SBO */     
    END. /* hSMO <> ghSO */
    ASSIGN 
      cDataObject
      cDataObject:SCREEN-VALUE = cDataObject.
    IF cDataObject:SCREEN-VALUE = ? THEN
       cDataObject:SCREEN-VALUE = cDataObject:ENTRY(1) NO-ERROR.
  END. /* do with frame */

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initFields sObject 
FUNCTION initFields RETURNS LOGICAL
  (plSensitive AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Disable/Enable Fields  
    Notes: Also used to set screen-value or blank the fields when disabled 
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      cDataObject:SENSITIVE = plSensitive
      cType:SENSITIVE = plSensitive
      cMapName:SENSITIVE = plSensitive.
  END.
  
  IF plSensitive THEN
  DO:
    ASSIGN
      cDataObject:SCREEN-VALUE = cDataObject
      cType:SCREEN-VALUE       = cType
      cMapName:SCREEN-VALUE    = cMapName NO-ERROR.
  END.
  ELSE
    ASSIGN
      cDataObject:LIST-ITEM-PAIRS = cDataObject:LIST-ITEM-PAIRS
      cMapName:LIST-ITEMS         = cMapName:LIST-ITEMS.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initMapName sObject 
FUNCTION initMapName RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cEntries   AS CHAR   NO-UNDO.
  DEFINE VARIABLE i          AS INT    NO-UNDO.
  DEFINE VARIABLE cSignature AS CHAR   NO-UNDO.
  DEFINE VARIABLE cMethod    AS CHAR   NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    hSource = WIDGET-HANDLE(cDataObject).
    cMapName:LIST-ITEMS = '':U.
    IF VALID-HANDLE(hSource) THEN
    DO:
      IF cType = 'Column':U THEN
        cMapName:LIST-ITEMS = DYNAMIC-FUNCTION('getDataColumns':U IN hSource).
      ELSE
      DO:
        cEntries = hSource:INTERNAL-ENTRIES.
        DO i = 1 TO NUM-ENTRIES(cEntries):
          cMethod = ENTRY(i,cEntries).
          cSignature = hSource:GET-SIGNATURE(cMethod).  
          IF cSignature <> ? 
          AND ENTRY(1,cSignature) = cType
          AND ENTRY(3,cSignature) = '':U THEN
            cMapname:ADD-LAST(cMethod).   
        END. /* i = 1 to num-entries */
      END.
      cMapName:SCREEN-VALUE = cMapName NO-ERROR.

      IF cMapName:SCREEN-VALUE = ? THEN
        cMapName:SCREEN-VALUE = cMapName:ENTRY(1) NO-ERROR.
     

    END.
  END.
  RETURN TRUE . 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initSmartObject sObject 
FUNCTION initSmartObject RETURNS LOGICAL
  (phObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Read instance properties, initialize widgets and store the sdo handle 
    Notes:  
------------------------------------------------------------------------------*/
  ghSO = phObject.
  
  IF VALID-HANDLE(ghSO) THEN
  DO WITH FRAME {&FRAME-NAME}:
    gcObjectName = DYNAMIC-FUNCTION('getMapObjectProducer':U IN ghSO).
    cType        = DYNAMIC-FUNCTION('getMapTypeProducer':U IN ghSO).
    cMapname     = DYNAMIC-FUNCTION('getMapNameProducer':U IN ghSO).
    
    IF gcObjectName = "":U THEN
      lDataDriven:CHECKED = FALSE.
    ELSE  
      lDataDriven:CHECKED = TRUE.

    initDataObject().
    
    IF cType = "":U THEN
      cType = "column".
    
    ASSIGN cDataObject. 

    initMapName().
    initFields(lDataDriven:CHECKED).    
    

  END. /* valid sdo */

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION storeSMOProperties sObject 
FUNCTION storeSMOProperties RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject AS HANDLE     NO-UNDO.
  IF ldataDriven:CHECKED IN FRAME {&FRAME-NAME} THEN 
  DO: 
    hObject = WIDGET-HANDLE(cDataObject).
    IF VALID-HANDLE(hObject) THEN
    DO:
      gcObjectName = DYNAMIC-FUNCTION('getObjectName':U IN hObject).
      DYNAMIC-FUNCTION('setMapObjectProducer':U IN ghSO,gcObjectName).
      DYNAMIC-FUNCTION('setMapTypeProducer':U IN ghSO,cType).
      DYNAMIC-FUNCTION('setMapNameProducer':U IN ghSO,cMapname).
    END.
  END.
  ELSE DO:
    DYNAMIC-FUNCTION('setMapObjectProducer':U IN ghSO,'':U).
    DYNAMIC-FUNCTION('setMapTypeProducer':U IN ghSO,'':U).
    DYNAMIC-FUNCTION('setMapNameProducer':U IN ghSO,'':U).
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

