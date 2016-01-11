&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject NO-UNDO
       {"adeuib/_calcseld.i"}.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/***********************************************************************
* Copyright (C) 2004,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: _newcalcv.w

  Description:  New calculated field viewer

  Purpose:      Prompts for calculated field data to create a new calculated 
                field in the repository

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/17/2004  Author:     

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

&scop object-name       _newcalcv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}
{src/adm2/widgetprto.i}
{src/adm2/ttcombo.i}
{adeuib/sharvars.i}
{destdefi.i}             /* Definitions for dynamics design-time temp-tables. */

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

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cClass cName cModule cDataType cLabel ~
cColumnLabel cFormat cHelp 
&Scoped-Define DISPLAYED-OBJECTS cClass cName cModule cDataType cLabel ~
cColumnLabel cFormat cHelp 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cClass AS CHARACTER FORMAT "X(90)":U 
     LABEL "Class" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cDataType AS CHARACTER FORMAT "X(90)":U 
     LABEL "Data type" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cModule AS CHARACTER FORMAT "X(90)":U 
     LABEL "Product module" 
     CONTEXT-HELP-ID 0
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cHelp AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 45 BY 4 NO-UNDO.

DEFINE VARIABLE cColumnLabel AS CHARACTER FORMAT "X(50)":U 
     LABEL "Column label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cFormat AS CHARACTER FORMAT "X(50)":U 
     LABEL "Format" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cLabel AS CHARACTER FORMAT "X(50)":U 
     LABEL "Label" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE cName AS CHARACTER FORMAT "X(50)":U 
     LABEL "Name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 45 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     cClass AT ROW 1 COL 16 COLON-ALIGNED
     cName AT ROW 2 COL 16 COLON-ALIGNED
     cModule AT ROW 3 COL 16 COLON-ALIGNED
     cDataType AT ROW 4 COL 16 COLON-ALIGNED
     cLabel AT ROW 5 COL 16 COLON-ALIGNED
     cColumnLabel AT ROW 6 COL 16 COLON-ALIGNED
     cFormat AT ROW 7 COL 16 COLON-ALIGNED
     cHelp AT ROW 8 COL 18 NO-LABEL
     "Help:" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 8.05 COL 12.4
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
         HEIGHT             = 11.43
         WIDTH              = 65.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       cHelp:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
               would not function without a data link to the viewer and there
               is no SDO on the container to link it to
------------------------------------------------------------------------------*/
DEFINE VARIABLE cInheritClasses   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.

  RUN SUPER.

  ASSIGN
    cClass:LIST-ITEMS IN FRAME {&FRAME-NAME} = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT 'CalculatedField':U)
    cDataType:LIST-ITEMS IN FRAME {&FRAME-NAME} = 'Character,Decimal,Integer,INT64,Date,DateTime,DateTime-TZ,Logical,BLOB,CLOB,Raw':U
    cClass:SCREEN-VALUE = 'CalculatedField':U.
  
  EMPTY TEMP-TABLE ttComboData.
 
  CREATE ttComboData.
  ASSIGN ttComboData.cWidgetName = "cModule":U
         ttComboData.hWidget = cModule:HANDLE IN FRAME {&FRAME-NAME}
         ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U
         ttComboData.cBufferList = "gsc_product_module":U
         ttComboData.cKeyFieldName = "gsc_product_module.product_module_code":U
         ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
         ttComboData.cDescSubstitute = "&1 / &2":U
         ttComboData.cCurrentKeyValue = "":U
         ttComboData.cListItemDelimiter = CHR(3)
         ttComboData.cListItemPairs = "":U
         ttComboData.cCurrentDescValue = "":U.
 
  RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).
 
  FIND FIRST ttComboData.
  ASSIGN ttComboData.hWidget:DELIMITER       = CHR(3)
         ttComboData.hWidget:LIST-ITEM-PAIRS = ttComboData.cListItemPairs.

  hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.
  RUN retrieveDesignClass IN hRepDesignManager
                        ( INPUT  'CalculatedField':U,
                          OUTPUT cInheritClasses,
                          OUTPUT TABLE ttClassAttribute ,
                          OUTPUT TABLE ttUiEvent,
                          OUTPUT TABLE ttSupportedLink    ) NO-ERROR.

  FOR EACH ttClassAttribute:
    CASE ttClassAttribute.tAttributeLabel:
      WHEN 'Data-Type':U THEN
        cDataType:SCREEN-VALUE = ttClassAttribute.tAttributeValue.
      WHEN 'Format':U THEN
        cFormat:SCREEN-VALUE = ttClassAttribute.tAttributeValue.
      WHEN 'Label':U THEN
        cLabel:SCREEN-VALUE = ttClassAttribute.tAttributeValue.
      WHEN 'ColumnLabel':U THEN
        cColumnLabel:SCREEN-VALUE = ttClassAttribute.tAttributeValue.
      WHEN 'Help':U THEN
        cHelp:SCREEN-VALUE = ttClassAttribute.tAttributeValue.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateCalcData vTableWin 
PROCEDURE validateCalcData :
/*------------------------------------------------------------------------------
  Purpose:     Validates calculated field data entered and returns any errors
  Parameters:  pcError AS CHARACTER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcError AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hRepDesignManager AS HANDLE     NO-UNDO.

  hRepDesignManager = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT 'RepositoryDesignManager':U) NO-ERROR.
  DO WITH FRAME {&FRAME-NAME}:
    IF cClass:SCREEN-VALUE = '':U OR cClass:SCREEN-VALUE = ? THEN
      pcError = pcError + 'The class must be set for the new calculated field.' + CHR(10).

    IF cName:SCREEN-VALUE = '':U THEN
      pcError = pcError + 'The name must be set for the new calculated field.' + CHR(10).

    IF cModule:SCREEN-VALUE = '':U OR cModule:SCREEN-VALUE = ? THEN
      pcError = pcError + 'The product module must be set for the new calculated field.' + CHR(10).

    IF NOT DYNAMIC-FUNCTION('validate-format':U IN _h_func_lib,
                            INPUT cFormat:SCREEN-VALUE,
                            INPUT cDataType:SCREEN-VALUE) THEN
      pcError = pcError + 'The format is invalid for the calculated field data type.':U + CHR(10).

    IF DYNAMIC-FUNCTION('ObjectExists':U IN hRepDesignManager, 
                        INPUT cName:SCREEN-VALUE) THEN
      pcError = pcError + 'An object named ' + cName:SCREEN-VALUE + ' already exists in the repository.':U + CHR(10).
    
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

