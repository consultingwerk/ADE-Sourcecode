&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"adeuib/_calcseld.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/*---------------------------------------------------------------------------------
  File: _calcself.w

  Description:  Calculated field selector filter viewer

  Purpose:      Allows the user to select filter criteria for the 
                calculated field selector

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/14/2004  Author:     

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       _calcself.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/widgetprto.i}
{src/adm2/ttcombo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "adeuib/_calcseld.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rShowCalc cModule cObject 
&Scoped-Define DISPLAYED-OBJECTS rShowCalc cModule cObject 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cModule AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE cObject AS CHARACTER FORMAT "X(50)":U 
     LABEL "Object filename" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE rShowCalc AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Show all calculated fields", "All",
"Show SDO entity calculated fields", "SDO"
     SIZE 49 BY 1.91 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     rShowCalc AT ROW 1 COL 21.4 NO-LABEL
     cModule AT ROW 3 COL 18.6 COLON-ALIGNED
     cObject AT ROW 4 COL 18.6 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "adeuib/_calcseld.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" NO-UNDO  
      ADDITIONAL-FIELDS:
          {adeuib/_calcseld.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 4.14
         WIDTH              = 75.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
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

&Scoped-define SELF-NAME cModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cModule vTableWin
ON VALUE-CHANGED OF cModule IN FRAME frMain /* Product module */
DO:
  DEFINE VARIABLE hFilterTarget AS HANDLE     NO-UNDO.

  hFilterTarget = DYNAMIC-FUNCTION('linkHandles':U,
     INPUT 'CalcFilter-Target':U).

  DO WITH FRAME {&FRAME-NAME}:
  
    IF cModule:SCREEN-VALUE = ? OR cModule:SCREEN-VALUE = '0':U THEN
      DYNAMIC-FUNCTION('removeQuerySelection':U IN hFilterTarget,
                       INPUT 'tProductModule':U,
                       INPUT 'EQ':U).
    ELSE 
      DYNAMIC-FUNCTION('assignQuerySelection':U IN hFilterTarget,
                   INPUT 'tProductModule',
                   INPUT cModule:SCREEN-VALUE,
                   INPUT 'EQ':U).
   END.  /* do with frame */

   DYNAMIC-FUNCTION('openQuery':U IN hFilterTarget).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cObject vTableWin
ON VALUE-CHANGED OF cObject IN FRAME frMain /* Object filename */
DO:
  
  DEFINE VARIABLE hFilterTarget AS HANDLE     NO-UNDO.

  hFilterTarget = DYNAMIC-FUNCTION('linkHandles':U,
     INPUT 'CalcFilter-Target':U).

  DO WITH FRAME {&FRAME-NAME}:

    IF cObject:SCREEN-VALUE > '':U THEN
      DYNAMIC-FUNCTION('assignQuerySelection':U IN hFilterTarget,
                       INPUT 'tName':U,
                       INPUT cObject:SCREEN-VALUE,
                       INPUT 'BEGINS':U).
    ELSE 
      DYNAMIC-FUNCTION('removeQuerySelection':U IN hFilterTarget,
                       INPUT 'tName':U,
                       INPUT 'BEGINS':U).
   END.  /* do with frame */

   DYNAMIC-FUNCTION('openQuery':U IN hFilterTarget).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rShowCalc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rShowCalc vTableWin
ON VALUE-CHANGED OF rShowCalc IN FRAME frMain
DO:
  DEFINE VARIABLE hFilterTarget AS HANDLE     NO-UNDO.
  
  SESSION:SET-WAIT-STATE('GENERAL':U).
  hFilterTarget = DYNAMIC-FUNCTION('linkHandles':U,
     INPUT 'CalcFilter-Target':U).
  RUN recreatettRecs IN hFilterTarget (INPUT SELF:SCREEN-VALUE).
  SESSION:SET-WAIT-STATE('':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       The product module combo needs to be populated directly, it 
               would not function without a data link to the viewer and
               having a data link to the viewer refreshed the product module
               when it should not have.
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFilterTarget AS HANDLE     NO-UNDO.

  RUN SUPER.

  hFilterTarget = DYNAMIC-FUNCTION('linkHandles':U,
     INPUT 'CalcFilter-Target':U).

  rShowCalc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION('getShowCalc':U IN hFilterTarget).

  EMPTY TEMP-TABLE ttComboData.
 
  CREATE ttComboData.
  ASSIGN ttComboData.cWidgetName = "fiProductModule":U
         ttComboData.hWidget = cModule:HANDLE IN FRAME {&FRAME-NAME}
         ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U
         ttComboData.cBufferList = "gsc_product_module":U
         ttComboData.cKeyFieldName = "gsc_product_module.product_module_code":U
         ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
         ttComboData.cDescSubstitute = "&1 / &2":U
         ttComboData.cCurrentKeyValue = "":U
         ttComboData.cListItemDelimiter = CHR(3)
         ttComboData.cListItemPairs = "":U
         ttComboData.cCurrentDescValue = "":U
         ttComboData.cFlag = "N":U.
 
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
 
  FIND FIRST ttComboData.
  ASSIGN ttComboData.hWidget:DELIMITER       = CHR(3)
         ttComboData.hWidget:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

