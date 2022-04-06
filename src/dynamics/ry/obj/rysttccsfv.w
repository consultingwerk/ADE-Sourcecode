&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"Child Combo SmartDataField Template.

Use this template as a starting point for creating Child Combo SmartDataField Objects - dependant on information from a parent combo"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" sObject _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Static SmartDataField Wizard" sObject _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* Static SmartDataField Wizard
Welcome to the Static SmartDataField Wizard! During the next few steps, the wizard will lead you through all the stages necessary to create this type of object. If you cancel the wizard at any time, then all your changes will be lost. Once the wizard is completed, it is possible to recall parts of the wizard using the LIST option from the section editor. Press Next to proceed.
af/cod/aftemwiziw.w,af/cod/aftemwizpw.w,af/cod/aftemwizew.w 
*/
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
  File: rysttccsfv.w

  Description:  Template Child Combo SmartDataField

  Purpose:      Template Child Combo SmartDataField

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6421   UserRef:    
                Date:   08/08/2000  Author:     Anthony Swindells

  Update Notes: Get combos on SDV's working

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

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

&scop object-name       rysttccsfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{src/adm2/globals.i}

/* Variable to hold pending value for combo - as setdatavalue is run before
   the combo is populated the first time
*/
DEFINE VARIABLE gcPendingValue AS CHARACTER NO-UNDO.

/* Variables to hold container source (viewer) and uib mode for use in many
   procedures. Saves doing a GET each time the procedures are called.
   These variables are populated once during initializeObject.
*/  
DEFINE VARIABLE ghSDV       AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcUIBMode   AS CHARACTER NO-UNDO.

/* Variable to save last parent key information so we only refresh query
   when it really changes
*/
DEFINE VARIABLE gcSaveKey   AS CHARACTER NO-UNDO.

/* Combo temp-table */
{src/adm2/ttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coCombo 
&Scoped-Define DISPLAYED-OBJECTS coCombo 

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
DEFINE VARIABLE coCombo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coCombo AT ROW 1 COL 18.2 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField Template
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
         HEIGHT             = 1.43
         WIDTH              = 69.4.
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartObjectCues" sObject _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* SmartObject,ab,666
Create a SmartDataField Object to represent a SmartDataObject field in a non-standard visualization.

* Creating a SmartDataField Object
1) Add a visualization for the field.
2) Add code for the enableField and disableField procedures.
3) Add code to set the DataModified property when the field value changes.
4) Save and close the object.

*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME coCombo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coCombo sObject
ON VALUE-CHANGED OF coCombo IN FRAME frMain /* Product Module */
DO:
  {set DataModified TRUE}.
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
   ASSIGN coCombo:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
   ASSIGN coCombo:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
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

  {get ContainerSource ghSDV}. /* SDV */    
  {get UIBMode gcUIBMode}.    

  /* subscribe to events via containing viewer as published from master combo */
  IF NOT (gcUIBMode BEGINS "DESIGN":U)  THEN
  DO:
    SUBSCRIBE TO "populateChildCombo":U IN ghSDV.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateChildCombo sObject 
PROCEDURE populateChildCombo :
/*------------------------------------------------------------------------------
  Purpose:     Published from value changed of parent SDF
  Parameters:  input parent key information.
               input modified status YES/NO
  Notes:       Builds and populates the combo.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcKey                    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER plModified               AS LOGICAL      NO-UNDO.

/* If value not changed, then do nothing */
IF pcKey <> "":U AND pcKey <> "0":U AND gcSaveKey = pcKey THEN RETURN.

ASSIGN gcSaveKey = pcKey. /* reset last key value */

DO WITH FRAME {&FRAME-NAME}:

  /* if this was called from a value changed of parent - then ensure modified
     status is set
  */
  IF plModified THEN
    {set DataModified TRUE}.

  /* If no parent information, blank out combo */
  IF pcKey = "":U OR pcKey = "0":U THEN
  DO:
    coCombo:LIST-ITEM-PAIRS = coCombo:DELIMITER.
    coCombo:LIST-ITEM-PAIRS = coCombo:LIST-ITEM-PAIRS NO-ERROR.
    ERROR-STATUS:ERROR = NO.
    RETURN.
  END.

  /* parent info passed in - rebuild combo */
  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.

  ASSIGN
    ttComboData.cWidgetName = "coCombo":U
    ttComboData.cWidgetType = "character":U
    ttComboData.hWidget = coCombo:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product NO-LOCK WHERE gsc_product.product_code = '":U + pcKey + "',":U +
                           "  EACH gsc_product_module NO-LOCK WHERE gsc_product_module.product_obj = gsc_product.product_obj " +
                           " BY gsc_product_module.product_module_code":U
    ttComboData.cBufferList = "gsc_product,gsc_product_module":U
    ttComboData.cKeyFieldName = "gsc_product_module.product_module_code":U
    ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
    ttComboData.cDescSubstitute = "&1 / &2":U
    ttComboData.cFlag = "":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coCombo:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  /* build the combo list items pairs */
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

  FIND FIRST ttComboData WHERE ttComboData.hWidget = coCombo:HANDLE.

  coCombo:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

  /* Assign value to pending value */
  setdatavalue(gcPendingValue).

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

  ASSIGN FRAME {&FRAME-NAME} coCombo.
  IF coCombo = ".":U THEN ASSIGN coCombo = "":U.  /* remove dot for none option */
  RETURN coCombo.

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

ASSIGN gcPendingValue = pcValue.

DEFINE VARIABLE cEntry  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLookup AS INTEGER    NO-UNDO.
DEFINE VARIABLE lSuccess  AS LOGICAL INITIAL TRUE NO-UNDO.

/* IF pcValue = "":U THEN ASSIGN pcValue = ".".  /* for none option */ */

/* lookup value in list of values, and default to 1st entry if not found */
iLookup = coCombo:LOOKUP(pcValue) IN FRAME {&FRAME-NAME}.
IF coCombo:NUM-ITEMS > 0 AND
   (iLookup = ? OR iLookup = 0) THEN ASSIGN iLookup = 1.

IF iLookup <> ? AND iLookup <> 0 THEN
DO:
    cEntry = coCombo:ENTRY(iLookup) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
    DO:
        coCombo:SCREEN-VALUE = cEntry NO-ERROR.
    END.
    ELSE DO:
        /* blank the combo */
        coCombo:LIST-ITEM-PAIRS = coCombo:LIST-ITEM-PAIRS.
        lSuccess = FALSE.
    END.
END.
ELSE DO:
    /* blank the combo */
    coCombo:LIST-ITEM-PAIRS = coCombo:LIST-ITEM-PAIRS.
    lSuccess = FALSE.
END.

ERROR-STATUS:ERROR = NO.

RETURN lSuccess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

