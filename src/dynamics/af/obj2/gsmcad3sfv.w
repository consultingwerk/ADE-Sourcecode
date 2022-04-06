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
  File: gsmcadcsfv.w

  Description:  Category Combo

  Purpose:      Category Combo

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000011   UserRef:    posse
                Date:   13/03/2001  Author:     Haavard Danielsen

  Update Notes: Created from Template rysttdcsfv.w

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

&scop object-name       gsmcad3sfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

/* Variable to hold pending value for combo - as setdatavalue is run before
   the combo is populated the first time
*/
DEFINE VARIABLE gdPendingValue  AS DECIMAL  NO-UNDO.

/* Variables to hold container source (viewer) and uib mode for use in many
   procedures. Saves doing a GET each time the procedures are called.
   These variables are populated once during initializeObject.
*/  
DEFINE VARIABLE ghSDV       AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcUIBMode   AS CHARACTER NO-UNDO.

/* Combo temp-table */
{af/sup2/afttcombo.i}

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
FUNCTION getDataValue RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pdValue AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coCombo AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Category" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coCombo AT ROW 1 COL 11.8 COLON-ALIGNED
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
         HEIGHT             = 1.43
         WIDTH              = 64.6.
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME coCombo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coCombo sObject
ON VALUE-CHANGED OF coCombo IN FRAME frMain /* Category */
DO:
  {set DataModified TRUE}.

  RUN populateChildren (INPUT TRUE).      /* pass new value onto dependant SDFs
                                             and ensure modified status is set
                                          */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildCombo sObject 
PROCEDURE buildCombo :
/*------------------------------------------------------------------------------
  Purpose:     This is published from the smartviewer containing the smartdatafield 
               to populate the combo with the evaluated list item pairs - if the
               query was succesful.
               This will be done as part of initilizing the container viewer. 
  Parameters:  input combo temp-table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               Note: if SDF is dependant on data from another SDF, then this
               procedure can not be used.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttComboData.

DO WITH FRAME {&FRAME-NAME}:
  FIND FIRST ttComboData WHERE ttComboData.hWidget = coCombo:HANDLE.
  IF NOT AVAILABLE ttComboData THEN RETURN.

  coCombo:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

END.

/* Assign value to pending value (solves timing issues) */
setDataValue(gdPendingValue).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getComboQuery sObject 
PROCEDURE getComboQuery :
/*------------------------------------------------------------------------------
  Purpose:     This routine is published from the viewer and is used to pass the query
               required by this combo back to the viewer for building. Once built,
               the query will be returned into the procedure buildCombo.
  Parameters:  input-output combo temp table
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               Note: if SDF is dependant on data from another SDF, then this
               procedure can not be used.
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttComboData.

DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource  AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValueList        AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  {get ContainerSource hContainerSource}.
  {get DataSource hDataSource hContainerSource}.

  IF VALID-HANDLE(hDataSource)
  THEN DO:
    ASSIGN 
      cValueList = DYNAMIC-FUNCTION("getUpdatableTableInfo":U IN gshGenManager, INPUT hDataSource).
    IF NUM-ENTRIES(cValueList,CHR(4)) > 0
    THEN DO:
      ASSIGN
        cValueList = ENTRY(1, cValueList, CHR(4)).
    END.
  END.

  FIND FIRST ttComboData
       WHERE ttComboData.hWidget = coCombo:HANDLE
       NO-ERROR.
  IF NOT AVAILABLE ttComboData
  THEN CREATE ttComboData.

  /* set-up appropriate values here for your query, fields to display, etc. */
  ASSIGN
    ttComboData.cWidgetName = "coCombo":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coCombo:HANDLE
    ttComboData.cForEach = "FOR EACH gsm_category NO-LOCK WHERE gsm_category.related_entity_mnemonic = '" + cValueList + 
                           "' BY gsm_category.category_type BY gsm_category.category_group BY gsm_category.category_subgroup":U
    ttComboData.cBufferList = "gsm_category":U
    ttComboData.cKeyFieldName = "gsm_category.category_obj":U
    ttComboData.cDescFieldNames = "gsm_category.category_type,gsm_category.category_group,gsm_category.category_subgroup,gsm_category.category_description":U
    ttComboData.cDescSubstitute = "&4 (&1 &2 &3)":U
    ttComboData.cFlag = "":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coCombo:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

END.

RETURN.
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

  /* subscribe ib containing viewer to events that will populate the combo */
  IF NOT (gcUIBMode BEGINS "DESIGN":U)  THEN
  DO:
    SUBSCRIBE TO "getComboQuery":U IN ghSDV.
    SUBSCRIBE TO "buildCombo":U IN ghSDV.
  END.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateChildren sObject 
PROCEDURE populateChildren :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will update any SDF's dependant on key information
               from this SDF.
               The dependant SDF must have been created from the appropriate 
               child SmartDataField template and contain a procedure called
               populateChildCombo, which it subscribes to in the viewer.
  Parameters:  Input modified status flag YES/NO
  Notes:       This in turns does a publish of receiveForeignFields1 which will
               be run in the SDFs dependant on key information from the current
               value of this SDF.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plModified AS LOGICAL NO-UNDO.

  IF NOT (gcUIBMode BEGINS "DESIGN":U)  THEN
  DO:
    ASSIGN FRAME {&FRAME-NAME} coCombo.
    PUBLISH "populateChildCombo":U FROM ghSDV (INPUT coCombo, INPUT plModified).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/
  ASSIGN FRAME {&FRAME-NAME} coCombo.

  RETURN coCombo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pdValue AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/

ASSIGN gdPendingValue = pdValue.  /* reset pending value */

DEFINE VARIABLE cEntry    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLookup   AS INTEGER    NO-UNDO.
DEFINE VARIABLE lSuccess  AS LOGICAL INITIAL TRUE NO-UNDO.

/* IF pdValue = "":U THEN ASSIGN pdValue = ".".  /* for none option */ */

/* lookup value in list of values, and default to 1st entry if not found */
iLookup = coCombo:LOOKUP(STRING(pdValue)) IN FRAME {&FRAME-NAME}.
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

/* Cascade value change to dependant SDF's (if any) */
RUN populateChildren (INPUT FALSE).    /* pass new value onto dependant SDFs */

ERROR-STATUS:ERROR = NO.

RETURN lSuccess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

