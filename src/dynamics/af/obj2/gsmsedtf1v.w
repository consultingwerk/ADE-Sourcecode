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
  File: gsmsedtf1v.w

  Description:  Session Type Physical Session List SDF

  Purpose:      Static SmartDataField to maintain the session type physical session list

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000026   UserRef:    posse
                Date:   17/04/2001  Author:     Tammy St Pierre

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

&scop object-name       gsmsedtf1v.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

DEFINE TEMP-TABLE ttTypeList NO-UNDO
  FIELD typeCode     AS CHARACTER
  FIELD typeDesc     AS CHARACTER
  FIELD typeExcluded AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS seAvailable seSelected buAdd buDelete 
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

DEFINE VARIABLE fiAvailable AS CHARACTER FORMAT "X(256)":U INITIAL "Available physical session types:" 
      VIEW-AS TEXT 
     SIZE 35.6 BY .62 NO-UNDO.

DEFINE VARIABLE fiSelected AS CHARACTER FORMAT "X(256)":U INITIAL "Selected types (double-click to toggle):" 
      VIEW-AS TEXT 
     SIZE 39.4 BY .62 TOOLTIP "Double click on selection list to toggle enabled status of field" NO-UNDO.

DEFINE VARIABLE seAvailable AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 40 BY 7.24
     FONT 3 NO-UNDO.

DEFINE VARIABLE seSelected AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 40 BY 7.24
     FONT 3 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     seAvailable AT ROW 1.86 COL 1.8 NO-LABEL
     seSelected AT ROW 1.86 COL 47.2 NO-LABEL
     buAdd AT ROW 3.67 COL 42.4
     buDelete AT ROW 5.14 COL 42.4
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
         HEIGHT             = 11.38
         WIDTH              = 96.2.
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


&Scoped-define SELF-NAME seAvailable
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seAvailable sObject
ON MOUSE-SELECT-DBLCLICK OF seAvailable IN FRAME frMain
DO:
  APPLY "CHOOSE":U TO buAdd.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME seSelected
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL seSelected sObject
ON MOUSE-SELECT-DBLCLICK OF seSelected IN FRAME frMain
DO:
  APPLY "CHOOSE":U TO buDelete.
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
    fiAvailable:SCREEN-VALUE = "Available physical session types:".
    fiSelected:SCREEN-VALUE = "Selected types (double-click to toggle):".
  END.

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
DEFINE VARIABLE cSetValue   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:  
    DO iLoop = 1 TO NUM-ENTRIES(seSelected:LIST-ITEMS):
      FIND FIRST ttTypeList WHERE ttTypeList.typeDesc = ENTRY(iLoop, seSelected:LIST-ITEMS) NO-ERROR.
      IF AVAILABLE ttTypeList THEN
        cSetValue = cSetValue + (IF cSetValue <> '':U THEN ',':U ELSE '':U) + ttTypeList.typeCode.
    END.  /* do iLoop */
  END.  /* do with frame */

  RETURN cSetValue.

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
DEFINE VARIABLE cTypes      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTypeCodes  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER      NO-UNDO.
DEFINE VARIABLE iNumTypes   AS INTEGER      NO-UNDO.

  EMPTY TEMP-TABLE ttTypeList.

  ASSIGN 
    cTypeCodes = 'APP,WBC,GUI,CUI,WBS,JOC,AOC,BTC':U
    cTypes = 'AppServer,WebClient,GUI Client,Character Client,WebSpeed,Java Open Client,ActiveX Open Client,Batch':U.

  DO iNumTypes = 1 TO NUM-ENTRIES(cTypeCodes):
    CREATE ttTypeList.
    ASSIGN ttTypeList.typeCode = ENTRY(iNumTypes, cTypeCodes)
           ttTypeList.typeDesc = ENTRY(iNumTypes, cTypes)
           ttTypeList.typeExcluded = YES.
  END.  /* do iNumTypes */

  valueLoop:
  DO iLoop = 1 TO NUM-ENTRIES(pcValue):
    FIND FIRST ttTypeList WHERE ttTypeList.typeCode = ENTRY(iLoop, pcValue) NO-ERROR.
    IF NOT AVAILABLE ttTypeList THEN NEXT valueLoop.
    ASSIGN ttTypeList.typeExcluded = NO.
  END.  /* do iLoop */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
      seAvailable:LIST-ITEMS = '':U
      seSelected:LIST-ITEMS = '':U.

    FOR EACH ttTypeList:
      IF ttTypeList.typeExcluded THEN
        seAvailable:ADD-LAST(ttTypeList.typeDesc).
      ELSE seSelected:ADD-LAST(ttTypeList.typeDesc).
    END.  /* for each ttTypeList */
  END.  /* do with frame */

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

