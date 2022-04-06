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
  File: rymbdatfv2.w

  Description:  Property Sheet Browser Data Field

  Purpose:      Property Sheet Browser Data Field

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6199   UserRef:    
                Date:   04/07/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttdatfv.w

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

&scop object-name       rymbdatfv2.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE ttFieldList NO-UNDO
FIELD fieldNumber             AS INTEGER
FIELD fieldName               AS CHARACTER
FIELD fieldEnabled            AS LOGICAL
FIELD fieldExcluded           AS LOGICAL  
INDEX key1 AS PRIMARY fieldNumber
INDEX key2 fieldName
INDEX key3 fieldEnabled.

DEFINE VARIABLE ghContainerSource         AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSdoName                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSetValue                AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS seAvailable seSelected buAdd buDelete buUp ~
buDown 
&Scoped-Define DISPLAYED-OBJECTS seAvailable seSelected fiAvailable ~
fiSelected 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL

  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     IMAGE-UP FILE "ry/img/next.gif":U
     LABEL "" 
     SIZE 4.4 BY 1.14 TOOLTIP "Add to selected fields"
     BGCOLOR 8 .

DEFINE BUTTON buDelete 
     IMAGE-UP FILE "ry/img/prev.gif":U
     LABEL "" 
     SIZE 4.4 BY 1.14 TOOLTIP "Delete from selected fields"
     BGCOLOR 8 .

DEFINE BUTTON buDown 
     IMAGE-UP FILE "ry/img/down.gif":U
     LABEL "&Add Enabled" 
     SIZE 4.4 BY 1.14 TOOLTIP "Move selected field down"
     BGCOLOR 8 .

DEFINE BUTTON buUp 
     IMAGE-UP FILE "ry/img/up.gif":U
     LABEL "&Add Enabled" 
     SIZE 4.4 BY 1.14 TOOLTIP "Move selected field up"
     BGCOLOR 8 .

DEFINE VARIABLE fiAvailable AS CHARACTER FORMAT "X(256)":U INITIAL "Available Fields:" 
      VIEW-AS TEXT 
     SIZE 25.2 BY .62 NO-UNDO.

DEFINE VARIABLE fiSelected AS CHARACTER FORMAT "X(256)":U INITIAL "Selected Fields:" 
      VIEW-AS TEXT 
     SIZE 39.4 BY .62 NO-UNDO.

DEFINE VARIABLE seAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 40 BY 7.24
     FONT 3 NO-UNDO.

DEFINE VARIABLE seSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 40 BY 7.24 TOOLTIP "Double-click an item to toggle between Enabled and Disabled."
     FONT 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     seAvailable AT ROW 1.86 COL 1.8 NO-LABEL
     seSelected AT ROW 1.86 COL 47.2 NO-LABEL
     buAdd AT ROW 2.43 COL 42.4
     buDelete AT ROW 3.91 COL 42.4
     buUp AT ROW 5.38 COL 42.4
     buDown AT ROW 6.81 COL 42.4
     fiAvailable AT ROW 1.19 COL 1.8 NO-LABEL
     fiSelected AT ROW 1.19 COL 45.2 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField
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
         HEIGHT             = 8.48
         WIDTH              = 87.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/field.i}

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

/* SETTINGS FOR FILL-IN fiAvailable IN FRAME frMain
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fiSelected IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       seAvailable:PRIVATE-DATA IN FRAME frMain     = 
                "no-resize".

ASSIGN 
       seSelected:PRIVATE-DATA IN FRAME frMain     = 
                "no-resize".

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

&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd sObject
ON CHOOSE OF buAdd IN FRAME frMain
DO:

  {set DataModified TRUE}.

  IF seAvailable:SCREEN-VALUE = "":U OR seAvailable:SCREEN-VALUE = ? 
    THEN RETURN NO-APPLY.

  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNewSelected            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue               AS CHARACTER  NO-UNDO.

  ASSIGN
    cNewSelected = "":U
    iEntry = LOOKUP(seAvailable:SCREEN-VALUE, seAvailable:LIST-ITEMS)
    .

  IF iEntry > 1 THEN
    ASSIGN cNewValue = ENTRY(iEntry - 1, seAvailable:LIST-ITEMS).
  ELSE IF NUM-ENTRIES(seAvailable:LIST-ITEMS) > 1 THEN
    ASSIGN cNewValue = ENTRY(2, seAvailable:LIST-ITEMS).
  ELSE cNewValue = "":U.

  item-loop:
  DO iLoop = 1 TO NUM-ENTRIES(seAvailable:LIST-ITEMS):
    IF iLoop = iEntry THEN NEXT item-loop.

    ASSIGN cNewSelected = cNewSelected + (IF cNewSelected <> "":U THEN ",":U ELSE "":U)
                          + ENTRY(iLoop, seAvailable:LIST-ITEMS).

  END.

  seSelected:ADD-LAST(seAvailable:SCREEN-VALUE).
  seAvailable:LIST-ITEMS = cNewSelected.
  seAvailable:SCREEN-VALUE = cNewValue.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDelete sObject
ON CHOOSE OF buDelete IN FRAME frMain
DO:

  {set DataModified TRUE}.

  IF seSelected:SCREEN-VALUE = "":U OR seSelected:SCREEN-VALUE = ? 
    THEN RETURN NO-APPLY.

  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cNewSelected            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewValue               AS CHARACTER  NO-UNDO.

  ASSIGN
    cNewSelected = "":U
    iEntry = LOOKUP(seSelected:SCREEN-VALUE, seSelected:LIST-ITEMS)
    .

  IF iEntry > 1 THEN
    ASSIGN cNewValue = ENTRY(iEntry - 1, seSelected:LIST-ITEMS).
  ELSE IF NUM-ENTRIES(seSelected:LIST-ITEMS) > 1 THEN
    ASSIGN cNewValue = ENTRY(2, seSelected:LIST-ITEMS).
  ELSE cNewValue = "":U.

  item-loop:
  DO iLoop = 1 TO NUM-ENTRIES(seSelected:LIST-ITEMS):
    IF iLoop = iEntry THEN NEXT item-loop.

    ASSIGN cNewSelected = cNewSelected + (IF cNewSelected <> "":U THEN ",":U ELSE "":U)
                          + ENTRY(iLoop, seSelected:LIST-ITEMS).

  END.

  seAvailable:ADD-LAST(seSelected:SCREEN-VALUE).
  seSelected:LIST-ITEMS = cNewSelected.
  seSelected:SCREEN-VALUE = cNewValue.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDown sObject
ON CHOOSE OF buDown IN FRAME frMain /* Add Enabled */
DO:

  {set DataModified TRUE}.

  IF seSelected:SCREEN-VALUE = "":U OR seSelected:SCREEN-VALUE = ?
    THEN RETURN NO-APPLY.

  DEFINE VARIABLE cSaveValue            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNewItems             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER      NO-UNDO.

  ASSIGN
    seselected
    cSaveValue = seSelected:SCREEN-VALUE
    iEntry = LOOKUP(seSelected:SCREEN-VALUE, seSelected:LIST-ITEMS)
    .

  IF iEntry >= NUM-ENTRIES(seSelected:LIST-ITEMS) THEN RETURN NO-APPLY.

  ASSIGN cNewItems = "":U.
  item-loop:
  DO iLoop = 1 TO NUM-ENTRIES(seSelected:LIST-ITEMS):
    IF (iLoop > (iEntry + 1)) OR (iLoop < iEntry) THEN
    DO:
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iLoop,seSelected:LIST-ITEMS).      
    END.
    ELSE IF iLoop = iEntry THEN NEXT item-loop.
    ELSE
    DO:
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iLoop,seSelected:LIST-ITEMS).      
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iEntry,seSelected:LIST-ITEMS).      
    END.
  END.

  seSelected:LIST-ITEMS = cNewItems.
  seSelected:SCREEN-VALUE = cSaveValue.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUp sObject
ON CHOOSE OF buUp IN FRAME frMain /* Add Enabled */
DO:

  {set DataModified TRUE}.

  IF seSelected:SCREEN-VALUE = "":U OR 
     seSelected:SCREEN-VALUE = ? THEN RETURN NO-APPLY.

  DEFINE VARIABLE cSaveValue            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNewItems             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iLoop                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iEntry                AS INTEGER      NO-UNDO.

  ASSIGN
    seSelected
    cSaveValue = seSelected:SCREEN-VALUE
    iEntry = LOOKUP(seSelected:SCREEN-VALUE, seSelected:LIST-ITEMS)
    .

  IF iEntry <= 1 THEN RETURN NO-APPLY.

  ASSIGN cNewItems = "":U.
  item-loop:
  DO iLoop = 1 TO NUM-ENTRIES(seSelected:LIST-ITEMS):
    IF (iLoop < (iEntry - 1)) OR (iLoop > iEntry) THEN
    DO:
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iLoop,seSelected:LIST-ITEMS).      
    END.
    ELSE IF iLoop = iEntry THEN NEXT item-loop.
    ELSE
    DO:
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iEntry,seSelected:LIST-ITEMS).      
      cNewItems = cNewItems + (IF cNewItems <> "":U THEN ",":U ELSE "":U)
                  + ENTRY(iLoop,seSelected:LIST-ITEMS).      
    END.
  END.

  seSelected:LIST-ITEMS = cNewItems.
  seSelected:SCREEN-VALUE = cSaveValue.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected sObject
ON MOUSE-SELECT-DBLCLICK OF seSelected IN FRAME frMain
DO:

  {set DataModified TRUE}.

  DEFINE VARIABLE cValue AS CHARACTER.

  ASSIGN cValue = seSelected:SCREEN-VALUE.

  IF INDEX(cValue,"/Enabled":U) > 0 THEN
    cValue = REPLACE(cValue,"/Enabled":U,"/Disabled":U).    
  ELSE
    cValue = REPLACE(cValue,"/Disabled":U,"/Enabled":U).    

  seSelected:LIST-ITEMS = REPLACE(seSelected:LIST-ITEMS, SELF:SCREEN-VALUE, cValue).

  seSelected:SCREEN-VALUE = cValue NO-ERROR.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField sObject 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   Disable the field   
  Parameters:  <none>
  Notes:    SmartDataField:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    buAdd:SENSITIVE = FALSE
    buDelete:SENSITIVE = FALSE
    buUp:SENSITIVE = FALSE
    buDown:SENSITIVE = FALSE
    seAvailable:SENSITIVE = FALSE
    seSelected:SENSITIVE = FALSE
    .

END.

{set FieldEnabled FALSE}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField sObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataField:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  ASSIGN
    buAdd:SENSITIVE = TRUE
    buDelete:SENSITIVE = TRUE
    buUp:SENSITIVE = TRUE
    buDown:SENSITIVE = TRUE
    seAvailable:SENSITIVE = TRUE
    seSelected:SENSITIVE = TRUE
    .

END.

{set FieldEnabled TRUE}.

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

  DO WITH FRAME {&FRAME-NAME}:
    fiAvailable:SCREEN-VALUE = "Available Fields:".
    fiSelected:SCREEN-VALUE = "Selected Fields:".
  END.

  {set DataModified TRUE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/

DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cEntry                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lEnabled                      AS LOGICAL    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  ASSIGN gcSetValue = "":U.

  item-loop:
  DO iLoop = 1 TO NUM-ENTRIES(seSelected:LIST-ITEMS):

    ASSIGN
      cEntry = ENTRY(iLoop, seSelected:LIST-ITEMS)
      cField = TRIM(ENTRY(1, cEntry, "/":U))
      lEnabled = TRIM(ENTRY(2, cEntry, "/":U)) = "Enabled":U
      .

    FIND FIRST ttFieldList
         WHERE ttFieldList.fieldName = cField
         NO-ERROR.

    ASSIGN gcSetValue = gcSetValue + (IF gcSetValue <> "":U THEN CHR(3) ELSE "":U) +
                        STRING(iLoop) + CHR(4) +
                        STRING(cField) + CHR(4) +
                        STRING(lEnabled).


  END.  /* item-loop */

END.

RETURN gcSetValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL

  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/
  /* save value set */
  ASSIGN gcSetValue = pcValue.

  DEFINE VARIABLE cSdoName                      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSdoInclude                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLine                         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cEntry                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cField                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iPosn1                        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iPosn2                        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iLoop                         AS INTEGER      NO-UNDO.
  IF NOT VALID-HANDLE(ghContainerSource) THEN
  DO:
    {get ContainerSource ghContainerSource}.
  END.

  RUN getSdoName IN ghContainerSource (OUTPUT cSdoName).  

  FIND FIRST ryc_smartobject WHERE ryc_smartobject.object_filename = csdoname NO-LOCK NO-ERROR.
  IF AVAIL ryc_smartobject THEN 
  DO:
    csdoname = ryc_smartobject.object_path + csdoname.
    /* add extension if required */
    IF INDEX(csdoname,".":U) = 0 THEN
      ASSIGN csdoname = csdoname + ".w":U.
  END.
           
  /* Read fields from SDO */
  IF /* cSdoName <> gcSdoName */ TRUE THEN
  DO:
    EMPTY TEMP-TABLE ttFieldList.
    ASSIGN cSdoInclude = REPLACE(cSdoName, ".w":U,".i":U).
    cSdoInclude = SEARCH(cSdoInclude).   
    IF cSdoInclude <> ? THEN
    DO:
      ASSIGN iLoop = 0.
      INPUT FROM VALUE(cSdoInclude) NO-ECHO.
      import-loop:
      REPEAT:
          IMPORT UNFORMATTED cLine.
          ASSIGN
            iPosn1 = INDEX(cLine, 'FIELD ')
            iPosn2 = INDEX(cLine,' ', iPosn1 + 6)
            .
          IF iPosn1 > 1 AND iPosn2 > iPosn1 THEN
            ASSIGN cField = TRIM(SUBSTRING(cLine, (iPosn1 + 6), iPosn2 - (iPosn1 + 6))).      
          ELSE
            ASSIGN cField = "":U.

          IF cField <> "":U THEN
          DO:
            ASSIGN iLoop = iLoop + 1.
            CREATE ttFieldList.
            ASSIGN
              ttFieldList.fieldNumber = iLoop
              ttFieldList.fieldName = cField
              ttFieldList.fieldEnabled = NO
              ttFieldList.fieldExcluded = YES
              .
            RELEASE ttFieldList. 
          END.
      END.
      INPUT CLOSE.
    END.
  END.  /* sdo name changed */
  ELSE
  FOR EACH ttFieldList:
    ASSIGN ttFieldList.fieldExcluded = YES.
  END.

  /* update temp-table with values read from input parameter */
  value-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcValue,CHR(3)):
    ASSIGN cEntry = ENTRY(iLoop, pcValue, CHR(3)).
    FIND FIRST ttFieldList
         WHERE ttFieldList.fieldName = ENTRY(2, cEntry, CHR(4))
         NO-ERROR.
    IF NOT AVAILABLE ttFieldList THEN NEXT value-loop.

    ASSIGN
      ttFieldList.fieldNumber = INTEGER(ENTRY(1, cEntry, CHR(4)))
      ttFieldList.fieldName = ENTRY(2, cEntry, CHR(4))
      ttFieldList.fieldEnabled = ENTRY(3, cEntry, CHR(4)) = "YES":U
      ttFieldList.fieldExcluded = NO
      .
  END.

  /* now refresh the selection lists to show these details */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
       seAvailable:LIST-ITEMS = "":U
       seSelected:LIST-ITEMS = "":U
       .

    FOR EACH ttFieldList BY ttFieldList.fieldNumber:
      IF ttFieldList.fieldExcluded = YES THEN
        seAvailable:ADD-LAST(ttFieldList.fieldName + " /":U + (IF ttFieldList.fieldEnabled THEN "Enabled":U ELSE "Disabled":U)).
      ELSE 
        seSelected:ADD-LAST(ttFieldList.fieldName + " /":U + (IF ttFieldList.fieldEnabled THEN "Enabled":U ELSE "Disabled":U)).
    END.
  END.

  /* Reset saved SDO name to check when changed */
  ASSIGN gcSdoName = cSdoName.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

