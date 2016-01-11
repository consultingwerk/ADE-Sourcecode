&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS frmAttributes 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: statusd.w 

  Description: Instance Attributes Dialog for SmartStatus.
               
               The main strategy in this procedure is that all widgets uses the                
               the actual AppBuilder variables.  
               - Values are ASSIGNED on value-changed.                 
                 This means that some values are ASSIGNED on value-changed of 
                 other fields.                 
                  
               The initialization of sensitivity,read-only is divided into 
               several functions in order to not duplicate start-up and 
               value-changed logic.             
               - None of these functions call each other.  
                 This means some value-changed triggers must call several
                 functions. 
                  
               initSDO    - contains SDO dependent objects
               initViewAs - contains ViewAs dependent objects
               initField  - contains changes depending on displayedfields
                            Is called from several valuechanged triggers 
               initOption - Only optionString logic dependin on option toggle                                              
               initGeometry - Height settings depending on 
                              view-as and view-as option 
        
        NOTE: The browsefields button is set in both initSDO and initViewAs.
                               
  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>
          
          
     Modifed:  18 July, 2000
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-Btn YES

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_hSMO  AS HANDLE NO-UNDO.

DEFINE VARIABLE ghFuncLib      AS HANDLE NO-UNDO. 
DEFINE VARIABLE ghSDO          AS HANDLE NO-UNDO.
 
DEFINE VARIABLE lAnswer        AS LOG    NO-UNDO.

DEFINE VARIABLE gcBrowseFields AS CHAR   NO-UNDO.

DEFINE VARIABLE glIsDynamicsRunning AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iHelpTopicId        AS INTEGER     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frmAttributes

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cField lAutoFill cSDO lEnable cTempLocation ~
dWidth dHeight dColumn dRow cDatatype RECT-16 
&Scoped-Define DISPLAYED-OBJECTS cField lAutoFill lEnable cTempLocation ~
dWidth dHeight dColumn dRow 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dispDataType frmAttributes 
FUNCTION dispDataType RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initField frmAttributes 
FUNCTION initField RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initTempLocation frmAttributes 
FUNCTION initTempLocation RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cField AS CHARACTER FORMAT "X(32)":U 
     LABEL "Field&Name" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 43.6 BY 1 NO-UNDO.

DEFINE VARIABLE cDatatype AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datatype" 
     VIEW-AS FILL-IN 
     SIZE 10.6 BY 1 NO-UNDO.

DEFINE VARIABLE cSDO AS CHARACTER FORMAT "X(50)":U 
     LABEL "Data Object" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 43.6 BY 1 NO-UNDO.

DEFINE VARIABLE dColumn AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Column" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dHeight AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Height" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dRow AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Row" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE dWidth AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "&Width" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE cTempLocation AS CHARACTER 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&File", "File",
"&Memptr", "Memptr",
"&Longchar", "Longchar"
     SIZE 17.4 BY 2.57 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.8 BY 4.29.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.8 BY 3.1.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59.8 BY 3.43.

DEFINE VARIABLE lAutoFill AS LOGICAL INITIAL no 
     LABEL "&AutoFill" 
     CONTEXT-HELP-ID 0
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE lEnable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmAttributes
     cField AT ROW 3.24 COL 14.6 COLON-ALIGNED
     lAutoFill AT ROW 7.1 COL 4.2
     cSDO AT ROW 2.1 COL 14.6 COLON-ALIGNED NO-TAB-STOP 
     lEnable AT ROW 8.05 COL 4.2
     cTempLocation AT ROW 7.1 COL 41.6 NO-LABEL
     dWidth AT ROW 11.14 COL 14.6 COLON-ALIGNED
     dHeight AT ROW 12.33 COL 14.6 COLON-ALIGNED
     dColumn AT ROW 11.14 COL 39.8 COLON-ALIGNED
     dRow AT ROW 12.33 COL 39.8 COLON-ALIGNED
     cDatatype AT ROW 4.43 COL 14.6 COLON-ALIGNED NO-TAB-STOP 
     "Geometry" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 10.29 COL 4
     "DataField" VIEW-AS TEXT
          SIZE 10.4 BY .62 AT ROW 1.19 COL 4
     "TempLocation:" VIEW-AS TEXT
          SIZE 14 BY .81 AT ROW 7.1 COL 26.8
     "Properties" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 6.19 COL 4
     RECT-12 AT ROW 1.52 COL 2
     RECT-13 AT ROW 10.57 COL 2
     RECT-16 AT ROW 6.48 COL 2
     SPACE(0.00) SKIP(3.89)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "SmartLOBField Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX frmAttributes
   Custom                                                               */
ASSIGN 
       FRAME frmAttributes:SCROLLABLE       = FALSE
       FRAME frmAttributes:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN cDatatype IN FRAME frmAttributes
   NO-DISPLAY                                                           */
ASSIGN 
       cDatatype:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR FILL-IN cSDO IN FRAME frmAttributes
   NO-DISPLAY                                                           */
ASSIGN 
       cSDO:READ-ONLY IN FRAME frmAttributes        = TRUE.

/* SETTINGS FOR RECTANGLE RECT-12 IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-13 IN FRAME frmAttributes
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX frmAttributes
/* Query rebuild information for DIALOG-BOX frmAttributes
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX frmAttributes */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME frmAttributes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON GO OF FRAME frmAttributes /* SmartLOBField Properties */
DO:     
  RUN saveAttributes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL frmAttributes frmAttributes
ON WINDOW-CLOSE OF FRAME frmAttributes /* SmartLOBField Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cField frmAttributes
ON VALUE-CHANGED OF cField IN FRAME frmAttributes /* FieldName */
DO:
  ASSIGN cField.
  dispDataType().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK frmAttributes 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* ***************************  Main Block  *************************** */
/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

glIsDynamicsRunning = DYNAMIC-FUNCTION("isICFRunning":U IN TARGET-PROCEDURE) = TRUE NO-ERROR.

/* Attach the standard OK/Cancel/Help button bar. */
iHelpTopicId = IF glIsDynamicsRunning 
               THEN {&SmartLOBField_Instance_Properties_Dialog_Box_For_Dynamics}
               ELSE {&SmartLOBField_Instance_Properties_Dialog_Box}.
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = iHelpTopicId}
 
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get context id of procedure */

  DEFINE VARIABLE iRecid      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hHandle     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataobject AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext    AS CHARACTER  NO-UNDO.
   
  /* Get the viewer (current design window) */
  RUN adeuib/_uibinfo.p (?, ?, "PROCEDURE":U, OUTPUT cContext).
  iRecid = INT(cContext) .
  
  /* Get the viewer'S HANDLE */
  RUN adeuib/_uibinfo.p (iRecid,?, "HANDLE":U, OUTPUT cContext).
  hHandle = WIDGET-HANDLE(ccontext).
  
  /* Get the viewer'S Design Dataobject */
  RUN adeuib/_uibinfo.p (iRecid,?,"DataObject":U, OUTPUT cDataObject).
  
  /* Get the handle of the viewer's running design-time DataObject  */
  ghSDO = DYNAMIC-FUNCTION('get-SDO-Hdl' IN getFuncLibHandle(),
                            cDataObject, hHandle).
    
  /* disp the DataObject and list the LargeColumns as Field options */
  DO WITH FRAME {&FRAME-NAME}:
    cSDO:SCREEN-VALUE = cDataObject.
    cField:LIST-ITEMS = {fn getLargeColumns ghSDO}.
  END.

  /* Get the values of the attributes that can be changed  */
  RUN ReadAttributes.

  /* Enable the interface. */         
  RUN enable_UI.  

  ENABLE btn_ok btn_cancel btn_help WITH FRAME {&frame-name}.
  
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}. 
   
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI frmAttributes  _DEFAULT-DISABLE
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
  HIDE FRAME frmAttributes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI frmAttributes  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cField lAutoFill lEnable cTempLocation dWidth dHeight dColumn dRow 
      WITH FRAME frmAttributes.
  ENABLE cField lAutoFill cSDO lEnable cTempLocation dWidth dHeight dColumn 
         dRow cDatatype RECT-16 
      WITH FRAME frmAttributes.
  VIEW FRAME frmAttributes.
  {&OPEN-BROWSERS-IN-QUERY-frmAttributes}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readAttributes frmAttributes 
PROCEDURE readAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFRAME AS HANDLE NO-UNDO.
  
  IF VALID-HANDLE(p_hSMO) THEN
    ASSIGN      
      cField             = DYNAMIC-FUNC("getFieldName":U IN p_hSMO)     
      lEnable            = DYNAMIC-FUNC("getEnableField":U IN p_hSMO) 
      lAutoFill          = DYNAMIC-FUNC("getAutoFill":U IN p_hSMO)       
      cTempLocation      = DYNAMIC-FUNC("getTempLocation":U IN p_hSMO)     
      hFrame             = DYNAMIC-FUNC("getContainerHandle":U IN p_hSMO)
      
      dColumn            = hFrame:COL
      dRow               = hFrame:ROW
      dWidth             = hFrame:WIDTH
      dHeight            = hFrame:HEIGHT
      . 
  dispDataType().
 

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveAttributes frmAttributes 
PROCEDURE saveAttributes :
/*------------------------------------------------------------------------------
  Purpose: Save the attributes    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
   
  DO WITH FRAME {&frame-name}:
    ASSIGN 
      lEnable
      lAutoFill 
      cTempLocation
       
      dColumn
      dRow
      dWidth
      dHeight.
  END.

  DYNAMIC-FUNCTION("setFieldName":U      IN p_hSMO, cField).
  DYNAMIC-FUNCTION("setEnableField":U    IN p_hSMO, lEnable).
  DYNAMIC-FUNCTION("setAutoFill":U       IN p_hSMO, lAutoFill).
  DYNAMIC-FUNCTION("setTempLocation":U   IN p_hSMO, cTempLocation).

  RUN repositionObject IN p_hSMO(dRow, dColumn).
  
  ASSIGN
    hFrame        = DYNAMIC-FUNCTION("getContainerHandle" IN p_hSMO)
    hFrame:HEIGHT = dHeight
    hFrame:WIDTH  = dWidth NO-ERROR.  
  
  /* Notify AppBuilder that size or position values has changed.
     The AB will run resizeObject which will run initializeObject */
  APPLY "END-RESIZE" TO hFrame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dispDataType frmAttributes 
FUNCTION dispDataType RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  cDataType = DYNAMIC-FUNC('columnDataType':U in ghSDO,cField).
  cDataType = CAPS(cDataType).
  DISPLAY cDatatype WITH FRAME {&FRAME-NAME}. 
  initTempLocation().
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle frmAttributes 
FUNCTION getFuncLibHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ghFuncLib) THEN 
  DO:
      ghFuncLib = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(ghFuncLib):
        IF ghFuncLib:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        ghFuncLib = ghFuncLib:NEXT-SIBLING.
      END.
  END.
  RETURN ghFuncLib.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initField frmAttributes 
FUNCTION initField RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Set Field Attributes from data-source  
           Called from value-changed of lFormatDataSource, lLabelDataSource
           and DisplayedField.
    Notes: Fields are assigned on value-changed.
           lFormatDataSource is set to TRUE 
           - on valuechanged of DisplayField   
           - on valuechanged of view-as if not "browse"                                
------------------------------------------------------------------------------*/
 
    ASSIGN
        cDataType    = DYNAMIC-FUNC('columnDataType':U in ghSDO,cField).
        
    DISPLAY 
      cDataType . 
     
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initTempLocation frmAttributes 
FUNCTION initTempLocation RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF cDatatype = 'CLOB' THEN
      cTempLocation:ENABLE('Longchar':U). 
    ELSE 
      cTempLocation:DISABLE('Longchar':U). 
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

