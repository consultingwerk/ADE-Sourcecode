&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"SmartDataField Template.

Use this template as a starting point for creating  SmartDataField Objects. A SmartDataField object represents a single field of a SmartDataObject using a non-standard visualization of your choosing, and can be inserted into a SmartDataField."
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" sObject _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: rysttfcsfv.w

  Description:  Filtered combo SDF Viewer Template

  Purpose:      Filtered combo SDF Viewer Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6621   UserRef:    
                Date:   31/08/2000  Author:     Jenny Bond

  Update Notes: Created from Template rysttcmsfv.w.

  (v:010001)    Task:        6517   UserRef:    
                Date:   04/10/2000  Author:     Jenny Bond

  Update Notes: Make the filed names more generic, so that there is less to change when using
                the template.

  (v:010002)    Task:        7412   UserRef:    
                Date:   28/12/2000  Author:     Claire Dawkins

  Update Notes: Changing object numbers for smart data fields

-------------------------------------------------------------------------------*/
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

&scop object-name       rysttfcsfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{src/adm2/globals.i}

/* Variable to hold pending value for combo - as setdatavalue is run before
   the combo is populated the first time
*/
DEFINE VARIABLE gcPendingValue AS DECIMAL NO-UNDO.

/* Variables to hold container source (viewer) and uib mode for use in many
   procedures. Saves doing a GET each time the procedures are called.
   These variables are populated once during initializeObject.
*/  
DEFINE VARIABLE ghSDV       AS HANDLE    NO-UNDO.
DEFINE VARIABLE gcUIBMode   AS CHARACTER NO-UNDO.

/* Combo temp-table */
{src/adm2/ttcombo.i}

DEFINE VARIABLE gcDataString   AS CHARACTER    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProduct coProdMod 
&Scoped-Define DISPLAYED-OBJECTS coProduct coProdMod 

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
  ( pcValue AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE coProdMod AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE coProduct AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Product" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coProduct AT ROW 1 COL 18.2 COLON-ALIGNED
     coProdMod AT ROW 2.14 COL 18.2 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 72.8 BY 2.33.


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
         HEIGHT             = 2.33
         WIDTH              = 72.8.
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
   NOT-VISIBLE                                                          */
ASSIGN 
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

&Scoped-define SELF-NAME coProdMod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProdMod sObject
ON VALUE-CHANGED OF coProdMod IN FRAME frMain /* Product Module */
DO:
    ASSIGN
        coProdMod.

    {set DataModified TRUE}.

    RUN populateChildren (INPUT TRUE).      /* pass new value onto dependant SDFs
                                               and ensure modified status is set */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProduct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProduct sObject
ON VALUE-CHANGED OF coProduct IN FRAME frMain /* Product */
DO:
    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coProdMod:HANDLE NO-ERROR.

    IF  NOT AVAILABLE ttComboData
    OR  ttComboData.cListItemPairs = ?
    OR  ttComboData.cListItemPairs = "":u THEN RETURN.

    /* Assign full list of values to product module temp table records before filtering product module */
    ASSIGN
        ttComboData.cListItemPairs = gcDataString.

    RUN filterCombo (INPUT coProduct:SCREEN-VALUE). /* Filter child combo by value of parent combo */

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coProdMod:HANDLE NO-ERROR.

    IF NOT AVAILABLE ttComboData THEN RETURN.

    coProdMod:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = 
        IF ttComboData.cListItemPairs = "":u THEN coProdMod:LIST-ITEM-PAIRS ELSE ttComboData.cListItemPairs.
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
    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coProduct:HANDLE NO-ERROR.

    IF  NOT AVAILABLE ttComboData 
    OR  ttComboData.cListItemPairs = ?
    OR  ttComboData.cListItemPairs = "":u THEN RETURN.

    coProduct:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

    FIND FIRST ttComboData NO-LOCK
        WHERE ttComboData.hWidget = coProdMod:HANDLE NO-ERROR.

    /* store all the initial values of the product module in a global variable */
    ASSIGN
        gcDataString = ttComboData.cListItemPairs.

    /*RUN setfilterComboValue (INPUT coProduct:SCREEN-VALUE).     */
    APPLY "VALUE-CHANGED":U TO coProduct IN FRAME {&FRAME-NAME}.
END.

/* Assign value to pending value (solves timing issues) */
setDataValue(gcPendingValue).

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

   ASSIGN
       coProduct:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE
       coProdMod:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
   ASSIGN
       coProduct:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
       coProdMod:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
   {set FieldEnabled TRUE}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterCombo sObject 
PROCEDURE filterCombo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFilterInfo    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cString             AS CHARACTER    NO-UNDO INITIAL "":U.
DEFINE VARIABLE cNewListItemPairs   AS CHARACTER    NO-UNDO INITIAL "":U.
DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.

FIND FIRST ttComboData
    WHERE ttComboData.hWidget = coProdMod:HANDLE IN FRAME {&FRAME-NAME} NO-ERROR.

IF  LENGTH(pcFilterInfo) > 0 THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(ttComboData.cListItemPairs, coProdMod:DELIMITER) BY 2:

        ASSIGN
            cString = ENTRY(iLoop, ttComboData.cListItemPairs, coProdMod:DELIMITER) + coProdMod:DELIMITER +
                      ENTRY(iLoop + 1, ttComboData.cListItemPairs, coProdMod:DELIMITER).

        IF DECIMAL(ENTRY(2, ENTRY(1, cString, coProdMod:DELIMITER), "|":U)) = DECIMAL(pcFilterInfo) THEN
            ASSIGN
                cNewListItemPairs = TRIM(cNewListItemPairs) + TRIM(ENTRY(1, cString, "|":U)) + coProdMod:DELIMITER +
                                    TRIM(ENTRY(2, cString, coProdMod:DELIMITER)) + coProdMod:DELIMITER.

    END.

    ASSIGN
        ttComboData.cListItemPairs  = TRIM(cNewListItemPairs, coProdMod:DELIMITER).

END.
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

DO WITH FRAME {&FRAME-NAME}:

  FIND FIRST ttComboData
       WHERE ttComboData.hWidget = coProduct:HANDLE
       NO-ERROR.
  IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.

  /* set-up appropriate values here for your query, fields to display, etc. */
  ASSIGN
    ttComboData.cWidgetName = "coProduct":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coProduct:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product NO-LOCK BY gsc_product.product_code":U
    ttComboData.cBufferList = "gsc_product":U
    ttComboData.cKeyFieldName = "gsc_product.product_obj":U
    ttComboData.cDescFieldNames = "gsc_product.product_code,gsc_product.product_description":U
    ttComboData.cDescSubstitute = "&1 / &2":U
    ttComboData.cFlag = "":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coProduct:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  FIND FIRST ttComboData
       WHERE ttComboData.hWidget = coProdMod:HANDLE
       NO-ERROR.
  IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.

  /* set-up appropriate values here for your query, fields to display, etc. */
  ASSIGN
    ttComboData.cWidgetName = "coProdMod":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coProdMod:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code":U
    ttComboData.cBufferList = "gsc_product_module":U
    ttComboData.cKeyFieldName = "gsc_product_module.product_module_obj":U
    /* store the product_obj in cListItemDelimiter temporarily to find the info we want to filter on */
    ttComboData.cDescFieldNames = "gsc_product.product_module_code,gsc_product_module.product_module_description,gsc_product_module.product_obj":U
    ttComboData.cDescSubstitute = "&1 / &2 |&3":U
    ttComboData.cFlag = "":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = coProdMod:DELIMITER
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U.

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
  ASSIGN
      coProduct:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3)
      coProdMod:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3).

  {get ContainerSource ghSDV}. /* SDV */    
  {get UIBMode gcUIBMode}.    

  /* subscribe ib containing viewer to events that will populate the combo */
  IF NOT (gcUIBMode BEGINS "DESIGN":U)  THEN DO:
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
    ASSIGN FRAME {&FRAME-NAME} coProdMod.
    PUBLISH "populateChildCombo":U FROM ghSDV (INPUT coProdMod, INPUT plModified).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFilterComboValue sObject 
PROCEDURE setFilterComboValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcKeyValue  AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER plSuccess   AS LOGICAL      NO-UNDO.

DEFINE VARIABLE iLoop   AS INTEGER      NO-UNDO.

plSuccess = NO.

valueLoop:
DO iLoop = 1 TO NUM-ENTRIES(gcDataString, coProduct:DELIMITER IN FRAME {&FRAME-NAME}) BY 2:
    IF DECIMAL(pcKeyValue) = DECIMAL(ENTRY(iLoop + 1, gcDataString, coProduct:DELIMITER)) THEN DO:
        ASSIGN
            coProduct:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2, ENTRY(iLoop, gcDataString, coProduct:DELIMITER), "|":U)
            plSuccess = TRUE.

        APPLY "value-changed":u TO coProduct.

        LEAVE valueLoop.
    END.
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
    ASSIGN FRAME {&FRAME-NAME} coProdMod.

    RETURN coProdMod.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( pcValue AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/

ASSIGN gcPendingValue = pcValue.  /* reset pending value */

DEFINE VARIABLE cEntry      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLookup     AS INTEGER    NO-UNDO.
DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO INITIAL TRUE.

/* lookup value in list of values, and default to 1st entry if not found */
iLookup = coProdMod:LOOKUP(STRING(pcValue)) IN FRAME {&FRAME-NAME}.
IF coProdMod:NUM-ITEMS > 0 AND
   (iLookup = ? OR iLookup = 0) THEN ASSIGN iLookup = 1.
IF iLookup <> ? AND iLookup <> 0 THEN DO:
    cEntry = coProdMod:ENTRY(iLookup) NO-ERROR.
    IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN DO:
        RUN setFilterComboValue (INPUT cEntry, OUTPUT lsuccess).
        ASSIGN
            coProdMod:SCREEN-VALUE = IF lSuccess THEN cEntry
                                     ELSE coProdMod:LIST-ITEM-PAIRS NO-ERROR.


    END.
    ELSE DO:
        /* blank the combo */
        coProdMod:LIST-ITEM-PAIRS = coProdMod:LIST-ITEM-PAIRS.
        coProduct:LIST-ITEM-PAIRS = coProduct:LIST-ITEM-PAIRS.
        lSuccess = FALSE.
    END.
END.
ELSE DO:
    /* blank the combo */
    coProdMod:LIST-ITEM-PAIRS = coProdMod:LIST-ITEM-PAIRS.
    lSuccess = FALSE.
END.

/* Cascade value change to dependant SDF's (if any) */
RUN populateChildren (INPUT FALSE).    /* pass new value onto dependant SDFs */

ERROR-STATUS:ERROR = NO.

RETURN lSuccess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


