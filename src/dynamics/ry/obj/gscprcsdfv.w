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
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gscprcsdfv.w

  Description:  Product combo SDF

  Purpose:      Product combo smartdatafield

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6421   UserRef:    
                Date:   04/08/2000  Author:     Anthony Swindells

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

&scop object-name       gscprcsdfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{af/sup2/afglobals.i}

/* variable to hold pending value for combo - as setdatavalue is run before
   the combo is populated the first time
*/
DEFINE VARIABLE gcPendingValue AS CHARACTER NO-UNDO.

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
     LABEL "Product" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x","x"
     DROP-DOWN-LIST
     SIZE 46 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     coCombo AT ROW 1 COL 7.6 COLON-ALIGNED
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
         HEIGHT             = 1.38
         WIDTH              = 58.2.
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
ON VALUE-CHANGED OF coCombo IN FRAME frMain /* Product */
DO:
  {set DataModified TRUE}.
  RUN populateChildren (INPUT TRUE).      /* pass new value onto dependant SDFs */
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
  Purpose:     This is run from the smartviewer containing smartdatafield to pass
               back the temp-table containing our query - ready built. We initially
               created our entry in the temp-table in getComboQuery in this procedure
               which passed the query to the viewer.
  Parameters:  <none>
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

/* Assign value to pending value */
setdatavalue(gcPendingValue).

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
  Purpose:     This routine is run from the viewer and is used to pass the query
               required by this combo back to the viewer for building. Once built,
               the query will be returned into the procedure buildcombo.
  Parameters:  <none>
  Notes:       This is designed to facilitate all combo queries being built with
               a single appserver hit.
               Note: if SDF is dependant on data from another SDF, then this
               procedure can not be used.
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttComboData.

DO WITH FRAME {&FRAME-NAME}:

  FIND FIRST ttComboData
       WHERE ttComboData.cWidgetName = "coCombo":U
       NO-ERROR.
  IF NOT AVAILABLE ttComboData THEN CREATE ttComboData.

  ASSIGN
    ttComboData.cWidgetName = "coCombo":U
    ttComboData.cWidgetType = "character":U
    ttComboData.hWidget = coCombo:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product NO-LOCK BY gsc_product.product_code":U
    ttComboData.cBufferList = "gsc_product":U
    ttComboData.cKeyFieldName = "gsc_product.product_code":U
    ttComboData.cDescFieldNames = "gsc_product.product_code,gsc_product.product_description":U
    ttComboData.cDescSubstitute = "&1 / &2":U
    ttComboData.cFlag = "":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
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

  {get ContainerSource ghSDV}. /* SDV */    
  {get UIBMode gcUIBMode}.    

  /* Code placed here will execute PRIOR to standard behavior. */
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
  Purpose:     This procedure is published from the containing viewer and is 
               used to send foreign field information to child SDF's that must
               be reset based on the current value of this SDF.
               The standard Astra viewer supports upto 5 levels of SDF
               dependance, hence the 1 at the end of this procedure name.
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

ASSIGN gcPendingValue = pcValue.  /* reset pending value */

DEFINE VARIABLE cEntry    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLookup   AS INTEGER    NO-UNDO.
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

/* Cascade value change to dependant SDF's */
RUN populateChildren (INPUT FALSE).    /* pass new value onto dependant SDFs */

ERROR-STATUS:ERROR = NO.

RETURN lSuccess.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

