&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : gopendialog.w
    Purpose     : Open Object Dialog for repository objects.

    Syntax      : 

    Input Parameters:
      phWindow            : Window in which to display the dialog box.
      gcProductModule     : Initial Product Module Code.
      glOpenInAppBuilder  : Open in Appbuilder
      pcTitle             : Title for Dialog Window to be launched

    Output Parameters:
      gcFileName          : The filename selected.
      pressedOK           : TRUE if user successfully choose an object file name.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     :
                  05/24/2002     Updated By           Don Bulua
                  - IZ 2433, Added search on filename with timer, 
                  - Greatly improved query when 'Display Repostiory Data' set to yes.
                  - Modifed batch rows from 20 to 100
                  - IZ:4571 - restuctured adm calls
                  - Added most recent used combo-box displaying filename and description
                  - Save MRU and column sizes as user profiles
                  - Added verification for existence of static files. 
           
    
                  02/25/2002      Updated by          Ross Hunter
                  Allow the reading of Dynamic Viewers (DynView)

                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 2009 Objects the AB can't open are in dialog.
                  Fix: Filter the Object Type combo query and the
                  SDO query with preprocessor gcOpenObjectTypes, which
                  lists the object type codes that the AB knows to open.

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 1940 Long delay in Open Object dialog browser.
                  Fix: Changed rows-to-batch instance property for SDO
                  to 20 (was 200).
                  
                  08/16/2001      created by          Yongjian Gu
                  
                  04/12/2001      Update By           Peter Judge
                  IZ3130: Change delimiter in combos from comma to CHR(3)
                  to avoid issue with non-American numeric formats.
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
DEFINE INPUT  PARAMETER phWindow           AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER gcProductModule    LIKE icfdb.gsc_product_module.product_module_code. 
DEFINE INPUT  PARAMETER glOpenInAppBuilder AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcTitle            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER gcFileName         LIKE icfdb.ryc_smartobject.object_filename. 
DEFINE OUTPUT PARAMETER pressedOK          AS LOGICAL.

/* Local Variable Definitions ---                                       */
/*{af/sup2/afglobals.i} 8/19 */
DEFINE VARIABLE gcOriginalWhere            AS CHARACTER INITIAL "". 
/*DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". */

/* A list of object types to filter on */
DEFINE VARIABLE gcObjectFilterTypes AS CHARACTER  NO-UNDO.

{src/adm2/ttcombo.i}

PROCEDURE SendMessageA EXTERNAL "user32" :
  DEFINE INPUT  PARAMETER hwnd        AS LONG.
  DEFINE INPUT  PARAMETER umsg        AS LONG.
  DEFINE INPUT  PARAMETER wparam      AS LONG.
  DEFINE INPUT  PARAMETER lparam      AS LONG.
  DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.


/* Shared _RyObject and _custom temp-tables. */
{adeuib/ttobject.i}
{adeuib/custwidg.i}

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcOpenObjectTypes         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcsort                    AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFileName Btn_Cancel fiObject ~
coProductModule coObjectType coCombo RECT-1 
&Scoped-Define DISPLAYED-OBJECTS fiFileName fiObject coProductModule ~
coObjectType coCombo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRDMHandle gDialog 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSort gDialog 
FUNCTION setSort RETURNS LOGICAL
  ( pcField  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_bopendialog AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dopendialog AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.05.

DEFINE BUTTON Btn_OK 
     LABEL "&Open" 
     SIZE 15 BY 1.05.

DEFINE VARIABLE coCombo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 85 BY 1 NO-UNDO.

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     LABEL "Type" 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     LABEL "Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 73 BY 1 NO-UNDO.

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE .2 BY .91
     BGCOLOR 7 FGCOLOR 7  NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "x(70)":U 
     LABEL "Object filename" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 81.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiObject AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 123 BY 2.95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     fiFileName AT ROW 14.57 COL 4.2
     Btn_OK AT ROW 14.57 COL 110
     Btn_Cancel AT ROW 15.81 COL 110
     fiObject AT ROW 2.91 COL 1 COLON-ALIGNED NO-LABEL
     coProductModule AT ROW 1.71 COL 49 COLON-ALIGNED
     fiChar AT ROW 14.57 COL 99.2 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     coObjectType AT ROW 2.91 COL 49 COLON-ALIGNED
     coCombo AT ROW 14.57 COL 18 COLON-ALIGNED NO-LABEL NO-TAB-STOP 
     RECT-1 AT ROW 1.29 COL 2
     "Filter:" VIEW-AS TEXT
          SIZE 5.4 BY .62 AT ROW 1 COL 3.6
     "Object filename:" VIEW-AS TEXT
          SIZE 18.6 BY .62 AT ROW 2.1 COL 3.4
     SPACE(103.79) SKIP(14.27)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Open Object"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB gDialog 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX gDialog
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON Btn_OK IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       coObjectType:HIDDEN IN FRAME gDialog           = TRUE.

/* SETTINGS FOR FILL-IN fiChar IN FRAME gDialog
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fiFileName IN FRAME gDialog
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX gDialog
/* Query rebuild information for DIALOG-BOX gDialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX gDialog */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON GO OF FRAME gDialog /* Open Object */
DO:
    APPLY 'CHOOSE' TO Btn_OK.   /* go to search the object file */
   
    IF gcFileName = ? THEN  RETURN NO-APPLY.   /* if no such a file, do not close the dialog */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Open Object */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */ 
  RUN setMRULIST ("","").
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel gDialog
ON CHOOSE OF Btn_Cancel IN FRAME gDialog /* Cancel */
DO:
  ASSIGN gcFileName = ?               /* these values are by default, just reaffirm it. */
         pressedOK = NO.
  RUN setMRULIST ("","").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* Open */
DO:
  RUN OpenObject (fiFilename:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coCombo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coCombo gDialog
ON VALUE-CHANGED OF coCombo IN FRAME gDialog
DO:
   ASSIGN fiFileName:SCREEN-VALUE = SELF:SCREEN-VALUE
          Btn_OK:SENSITIVE        = TRUE.
   
   APPLY "VALUE-CHANGED":U TO fiFilename.
   IF LAST-EVENT:LABEL <> "CURSOR-UP":U 
        AND LAST-EVENT:LABEL <> "CURSOR-DOWN":U THEN 
     APPLY "ENTRY":U TO fiFileName.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType gDialog
ON VALUE-CHANGED OF coObjectType IN FRAME gDialog /* Type */
DO:
  RUN updateBrowserContents.    /* update contents in the browser according to 
                                   the newly-changed object type. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON ENTRY OF coProductModule IN FRAME gDialog /* Module */
DO:
  /* ASSIGN gcSavedModule = SELF:SCREEN-VALUE.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON VALUE-CHANGED OF coProductModule IN FRAME gDialog /* Module */
DO:
  RUN updateBrowserContents.  /* update contents in the browser according to 
                                 the newly-changed Product Module. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON CURSOR-DOWN OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  RUN applyKey in h_bopenDialog ("CURSORDOWN":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON CURSOR-UP OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  RUN applyKey in h_bopenDialog ("CURSORUP":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON F4 OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  DEFINE VARIABLE iretval AS INTEGER NO-UNDO.
 &GLOBAL-DEFINE CB_SHOWDROPDOWN 335
 
 RUN SendMessageA (INPUT  CoCombo:HWND,
                          {&CB_SHOWDROPDOWN},
                          1,   /* True */
                          0,
                   OUTPUT iretval
                   )  NO-ERROR .
 APPLY "ENTRY":U TO coCombo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON PAGE-DOWN OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  RUN applyKey in h_bopenDialog ("PAGEDOWN":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON PAGE-UP OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  RUN applyKey in h_bopenDialog ("PAGEUP":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiFileName gDialog
ON VALUE-CHANGED OF fiFileName IN FRAME gDialog /* Object filename */
DO:
  ASSIGN coCombo:SCREEN-VALUE = SELF:SCREEN-VALUE NO-ERROR.
       
   IF LOOKUP(SELF:SCREEN-VALUE,coCombo:LIST-ITEM-PAIRS,CHR(3)) = 0 THEN
        coCombo:SCREEN-VALUE = ENTRY(2,coCombo:LIST-ITEM-PAIRS,CHR(3)).
   IF SELF:SCREEN-VALUE = "" THEN
      Btn_OK:SENSITIVE = FALSE.
   ELSE
      Btn_OK:SENSITIVE = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObject gDialog
ON VALUE-CHANGED OF fiObject IN FRAME gDialog
DO:
  DEFINE VARIABLE cValue AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE TIMER-INTERVAL 500
  
  DO WHILE TRUE:
    IF cValue <> SELF:SCREEN-VALUE THEN
    DO:
      ETIME(TRUE).
      cValue = SELF:SCREEN-VALUE.
    END.
    PROCESS EVENTS.
    
    IF ETIME >= {&TIMER-INTERVAL} THEN DO:

      RUN updateBrowserContents.  /* update contents in the browser */
      ASSIGN SELF:CURSOR-OFFSET = MAX(1,LENGTH(SELF:SCREEN-VALUE) + 1) NO-ERROR.
      LEAVE.
    END.
  END.
  
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK gDialog 


/* ***************************  Main Block  *************************** */
 
{src/adm2/dialogmn.i} 


/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects gDialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'ry/obj/dopendialog.wDB-AWARE':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch50CheckCurrentChangedyesRebuildOnReposyesServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(NONE)':U ,
             OUTPUT h_dopendialog ).
       RUN repositionObject IN h_dopendialog ( 1.48 , 24.00 ) NO-ERROR.
       /* Size in AB:  ( 2.38 , 18.00 ) */

       RUN constructObject (
             INPUT  'ry/obj/bopendialog.w':U ,
             INPUT  FRAME gDialog:HANDLE ,
             INPUT  'ScrollRemotenoNumDown0CalcWidthnoMaxWidth80FetchOnReposToEndyesDataSourceNamesUpdateTargetNamesLogicalObjectNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_bopendialog ).
       RUN repositionObject IN h_bopendialog ( 4.33 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_bopendialog ( 10.00 , 123.00 ) NO-ERROR.

       /* Links to SmartDataBrowser h_bopendialog. */
       RUN addLink ( h_dopendialog , 'Data':U , h_bopendialog ).
       RUN addLink ( h_bopendialog , 'F2Pressed':U , THIS-PROCEDURE ).
       RUN addLink ( h_bopendialog , 'updateFileName':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_bopendialog ,
             fiObject:HANDLE , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRYObject gDialog 
PROCEDURE createRYObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumns       AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER local_custom FOR _custom.

  DO ON ERROR UNDO, LEAVE:
    
    /* IZ 2342 MRU List doesn't work with dynamics objects. Returns non null when 
       object can't be found. */
    {get QueryPosition cQueryPosition h_dopendialog}. /* any data? */
    IF cQueryPosition = 'NoRecordAvailable':U THEN 
        RETURN "NOT_FOUND":U.

    /*  jep-icf: Copy the repository related field values to _RyObject. The 
        AppBuilder will use _RyObject in processing the OPEN request. */
    cColumns = DYNAMIC-FUNC("colValues" IN h_dopendialog,"object_filename,smartobject_obj,object_type_obj,~
object_type_code,product_module_obj,product_module_code,object_description,object_path,object_extension,~
runnable_from_menu,disabled,run_persistent,run_when,security_smartobject_obj,container_object,~
static_object,generic_object,required_db_list,layout_obj,relative_path,deployment_type,design_only").

    FIND _RyObject WHERE _RyObject.object_filename = ENTRY(2,cColumns,CHR(1)) NO-ERROR.
    IF NOT AVAILABLE _RyObject THEN
      CREATE _RyObject.

    ASSIGN _RyObject.Object_type_obj           = DECIMAL(ENTRY(4,cColumns,CHR(1)))
           _RyObject.Object_type_code          = ENTRY(5,cColumns,CHR(1))
           _RyObject.parent_classes            = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.Object_type_code)
           _RyObject.Object_filename           = ENTRY(2,cColumns,CHR(1))
           _RyObject.smartobject_obj           = DECIMAL(ENTRY(3,cColumns,CHR(1)))
           _RyObject.product_module_obj        = DECIMAL(ENTRY(6,cColumns,CHR(1)))
           _RyObject.product_module_code       = ENTRY(7,cColumns,CHR(1))
           _RyObject.Object_description        = ENTRY(8,cColumns,CHR(1))
           _RyObject.Object_path               = ENTRY(9,cColumns,CHR(1))
           _RyObject.Object_path               = IF _RyObject.Object_path = "":U THEN ENTRY(21,cColumns,CHR(1)) ELSE _RyObject.Object_path
           _RyObject.Object_extension          = ENTRY(10,cColumns,CHR(1))
           _RyObject.runnable_from_menu        = (ENTRY(11,cColumns,CHR(1)) = "Yes":U OR ENTRY(11,cColumns,CHR(1)) = "true":U)
           _RyObject.disabled                  = (ENTRY(12,cColumns,CHR(1)) = "Yes":U OR ENTRY(12,cColumns,CHR(1)) = "true":U)
           _RyObject.Run_persistent            = (ENTRY(13,cColumns,CHR(1)) = "Yes":U OR ENTRY(13,cColumns,CHR(1)) = "true":U)
           _RyObject.Run_when                  = ENTRY(14,cColumns,CHR(1))
           _RyObject.security_smartObject_obj  = DECIMAL(ENTRY(15,cColumns,CHR(1)))
           _RyObject.container_object          = (ENTRY(16,cColumns,CHR(1)) = "Yes":U OR ENTRY(16,cColumns,CHR(1)) = "true":U)
           _RyObject.static_object             = (ENTRY(17,cColumns,CHR(1)) = "Yes":U OR ENTRY(17,cColumns,CHR(1)) = "true":U)
           _RyObject.generic_object            = (ENTRY(18,cColumns,CHR(1)) = "Yes":U OR ENTRY(18,cColumns,CHR(1)) = "true":U)
           _RyObject.Required_db_list          = ENTRY(19,cColumns,CHR(1))
           _RyObject.Layout_obj                = DECIMAL(ENTRY(20,cColumns,CHR(1)))
           _RyObject.design_action             = "OPEN":u
           _RyObject.design_ryobject           = YES 
           _RyObject.deployment_type           = ENTRY(22,cColumns,CHR(1))
           _RyObject.design_only               = (ENTRY(23,cColumns,CHR(1)) = "Yes":U OR ENTRY(23,cColumns,CHR(1)) = "true":U)
           NO-ERROR.
                                                                       /* Object_type_code */
    FIND FIRST local_custom WHERE local_custom._object_type_code = ENTRY(5,cColumns,CHR(1)) NO-ERROR.

    /* If we can't find the local_custom, check if we've got a user defined class */

    IF NOT AVAILABLE local_custom
    THEN DO:
        IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB" IN gshRepositoryManager, INPUT "DynView":U)) > 0 THEN
            FIND FIRST local_custom WHERE local_custom._object_type_code = "SmartDataViewer":U NO-ERROR.
        ELSE
            IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB" IN gshRepositoryManager, INPUT "DynSDO":U)) > 0 THEN
                FIND FIRST local_custom WHERE local_custom._object_type_code = "DynSDO":U NO-ERROR.
            ELSE
                IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB" IN gshRepositoryManager, INPUT "DynBrow":U)) > 0 THEN
                    FIND FIRST local_custom WHERE local_custom._object_type_code = "DynBrow":U NO-ERROR.
    END.

    IF AVAILABLE local_custom THEN
      ASSIGN
           _RyObject.design_template_file   = local_custom._design_template_file
           _RyObject.design_propsheet_file  = local_custom._design_propsheet_file
           _RyObject.design_image_file      = local_custom._design_image_file.
           
           

    RETURN.
  END.  /* DO ON ERROR */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI gDialog  _DEFAULT-DISABLE
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
  HIDE FRAME gDialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI gDialog  _DEFAULT-ENABLE
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
  DISPLAY fiFileName fiObject coProductModule coObjectType coCombo 
      WITH FRAME gDialog.
  ENABLE fiFileName Btn_Cancel fiObject coProductModule coObjectType coCombo 
         RECT-1 
      WITH FRAME gDialog.
  {&OPEN-BROWSERS-IN-QUERY-gDialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE F2Pressed gDialog 
PROCEDURE F2Pressed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'CHOOSE' TO Btn_OK IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject gDialog 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE rRowid              AS ROWID      NO-UNDO.
    DEFINE VARIABLE cProfileData        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCols               AS INTEGER    NO-UNDO.

    /* Parent the dialog-box to the specified window. */
    IF VALID-HANDLE(phWindow) THEN
        ASSIGN FRAME {&FRAME-NAME}:PARENT = phWindow.

    /* override the SDO default dehavoir, don't run query and populate SBO after initializing
     * SDO. It is because we want to do query based on information passed-in, in addition to 
     * SDO's original. Waiting until we specifically order it to do by calling openQuery(). */
    DYNAMIC-FUNCTION('setOpenOnInit' IN h_dopendialog, NO).  

    /* Change combo delimiter to avoid numeric format issues, particularly
     * with non-American formats.                                         */
    ASSIGN coProductModule:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3)
           coObjectType:DELIMITER    IN FRAME {&FRAME-NAME} = CHR(3)
           coCombo:DELIMITER IN FRAME {&FRAME-NAME}         = CHR(3). 
    
    {set HideOnInit YES h_bopendialog}.
    {set HideOnInit YES }.
    {set popupActive NO h_bopendialog}.
    
    RUN SUPER.
    
    ASSIGN
        gcOpenObjectTypes = DYNAMIC-FUNCTION("getObjectTypes":U in h_dopendialog)
        rRowid            = ?.

    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "ObjectMRU":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                              OUTPUT       cProfileData).
    ASSIGN coCombo:LIST-ITEM-PAIRS  = ENTRY(1,cProfileData,CHR(4)) NO-ERROR.
    IF NUM-ENTRIES(cProfileData,CHR(4)) >= 2 THEN
    DO:
       IF VALID-HANDLE(h_bopendialog) THEN
          DYNAMIC-FUNC("setColumnWidth":U IN h_bopendialog, ENTRY(2,cProfileData,CHR(4))).
    END.
  
    RUN populateCombos. /* populate combos */
    IF NUM-ENTRIES(cProfileData,CHR(4)) >= 3 THEN
       ASSIGN coProductModule:SCREEN-VALUE = ENTRY(3,cProfileData,CHR(4)) NO-ERROR.

    RUN showBrowser.    /* construct new query and ask SDO to openQuery(),
                         * show result in the SmartDataBrowser */

    FRAME {&FRAME-NAME}:TITLE = (IF pcTitle = "" OR pcTitle = ?
                                 THEN "Open Object"
                                 ELSE pcTitle ).
    RUN viewObject.
    coCombo:MOVE-TO-BOTTOM().
    
    
END PROCEDURE.    /* end procedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenObject gDialog 
PROCEDURE OpenObject :
/*------------------------------------------------------------------------------
  Purpose:   Opens an object in the AppBuilder
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER cFileName AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE currentProductModule        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectDesc                 AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQueryPosition              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cFullFileName               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPath                       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cExtension                  AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN coObjectType coProductModule.
  
  IF (cFileName <> "" AND cFileName <> ?) THEN    /* only do the search when there is a filename string */
  DO:
     DYNAMIC-FUNC('assignQuerySelection':U IN h_dopendialog,'object_filename':U,cFileName,'EQ':U).
    
    /* open the new query  */
     DYNAMIC-FUNCTION('openQuery':U IN h_dopendialog).
    
    {get QueryPosition cQueryPosition h_dopendialog}. /* any data? */
    IF cQueryPosition = 'NoRecordAvailable':U THEN 
    DO:
        MESSAGE SUBSTITUTE("The Object file  '&1' cannot be found in the repository.",cFileName) SKIP
                "Please verify that the correct file name, product module, and type were specified."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
  
        
        
        /* Reset the query based on filter settings */
        RUN UpdateBrowserContents IN THIS-PROCEDURE.
        
        ASSIGN gcFileName = ?             /* reaffirm output values */
               pressedOK = NO.
    END. /* Available */
    ELSE DO:
       /* Check whether static object exists */
       IF DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"Static_object":U) = "YES":U OR
          DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"Static_object":U) = "TRUE":U THEN
       DO:
         ASSIGN
           cPath         = DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"object_path":U)
           cExtension    = DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"object_extension":U)
           cPath         = trim(cPath) + IF cPath = "" THEN "" ELSE "/":U
           cFullFileName = SEARCH (cPath + cFileName + (IF cExtension > "" THEN "." + cExtension ELSE ""))
           NO-ERROR.
          IF cFullFileName = ? THEN /* Could not find static object */
          DO:
            ASSIGN
              cPath         = DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"relative_path":U)
              cPath         = trim(cPath) + IF cPath = "" THEN "" ELSE "/":U
              cFullFileName = SEARCH (cPath + cFileName + (IF cExtension > "" THEN "." + cExtension ELSE ""))
              NO-ERROR.
            IF cFullFileName = ? THEN /* Could not find static object */
            DO:
               MESSAGE SUBSTITUTE("The static file '&1' cannot be found in your Propath.",
                                  cPath + cFileName + IF NUM-ENTRIES(cFileName,".") > 1 THEN "" ELSE "." + TRIM(cExtension) ) SKIP
                 "Please verify the location of this file."
               VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 
               
               /* Reset the query */
               RUN UpdateBrowserContents IN THIS-PROCEDURE.
               ASSIGN gcFileName = ?             /* reaffirm output values */
                      pressedOK = NO.
               RETURN NO-APPLY.
            END.
          END.
       END.
       
       ASSIGN cObjectDesc    = trim(DYNAMIC-FUNCTION("ColumnStringValue":U IN h_dopendialog,"object_description":U)) 
              gcFileName     = STRING(cFileName)    /* assign valid outputs, GO to close the dialog */
              pressedOK      = YES.
       /* Create the _RyObject record to be later used by AppBuilder to copy data to _P. */
       IF glOpenInAppBuilder THEN
          RUN createRyObject IN THIS-PROCEDURE.
       /* Update the current product module for the user, unles it's "<All>".
          Repository API session super procedure handles this call. */
       ASSIGN currentProductModule =
           ENTRY(LOOKUP(" " + coProductModule:SCREEN-VALUE, coProductModule:LIST-ITEM-PAIRS) - 1, coProductModule:LIST-ITEM-PAIRS) NO-ERROR.
       getRDMHandle().
       IF (currentProductModule <> "<All>":u) AND (currentProductModule <> "") AND VALID-HANDLE(ghRepositoryDesignManager) THEN
            DYNAMIC-FUNCTION("setCurrentProductModule":u IN ghRepositoryDesignManager, currentProductModule) NO-ERROR.
       RUN setMRUList IN THIS-PROCEDURE (trim(cFileName), cObjectDesc).
       APPLY 'GO':U TO FRAME {&FRAME-NAME}. 
    END. /* valid filename found */
  END. /* search if filename string */
  ELSE DO:                    /* doing nothing because there is no object filename to search. */
     ASSIGN gcFileName = ?             /* reaffirm output values */
            pressedOK = NO.
     RETURN NO-APPLY.       
  END.
END.      /* DO WITH {&FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateCombos gDialog 
PROCEDURE populateCombos :
/*------------------------------------------------------------------------------
  Purpose:    populate combo-boxes: Product Module and Object Type,
              based on the information from the repository.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cWhere                      AS CHARACTER                NO-UNDO.        
    DEFINE VARIABLE cField                      AS CHARACTER                NO-UNDO.  
    DEFINE VARIABLE moduleEntry                 AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE typeName                    AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iModuleCount                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cWhereClause                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cEntry                      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE i                           AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hProcedure                  AS HANDLE                   NO-UNDO.
    
    
    DO WITH FRAME {&FRAME-NAME}:
        EMPTY TEMP-TABLE ttComboData.

        CREATE ttComboData.
        ASSIGN ttComboData.cWidgetName        = "coObjectType":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coObjectType:HANDLE
               ttComboData.cForEach           = "FOR EACH gsc_object_type WHERE CAN-DO('" + gcOpenObjectTypes + "', gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
               ttComboData.cBufferList        = "gsc_object_type":U
               ttComboData.cKeyFieldName      = "gsc_object_type.object_type_obj":U
               ttComboData.cDescFieldNames    = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U 
               ttComboData.cDescSubstitute    = "&2  (&1)":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coObjectType:DELIMITER
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               .

        /* Refine query of object types if calling procedure contains procedure OpenObjectFilter */
        IF phWindow:PRIVATE-DATA > "" THEN DO:
           hProcedure = WIDGET-HANDLE(phWindow:PRIVATE-DATA) NO-ERROR.

           IF VALID-HANDLE(hProcedure) AND LOOKUP("getOpenObjectFilter":U,hProcedure:INTERNAL-ENTRIES) > 0  THEN
           DO:
              gcObjectFilterTypes = DYNAMIC-FUNCTION("getOpenObjectFilter":U IN hProcedure).
              IF gcObjectFilterTypes > "" THEN
                 ASSIGN  ttComboData.cForEach  = "FOR EACH gsc_object_type WHERE CAN-DO('" 
                                                 + gcObjectFilterTypes + "'" 
                                                 + " , gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
                         ttComboData.cFlag     = IF NUM-ENTRIES(gcObjectFilterTypes) <= 1 THEN "" ELSE "A".
           END.
           
           IF VALID-HANDLE(hProcedure) AND LOOKUP("getInitialFileName":U,hProcedure:INTERNAL-ENTRIES) > 0  THEN
           DO:
              ASSIGN fiObject:SCREEN-VALUE = DYNAMIC-FUNCTION("getInitialFileName":U IN hProcedure).
           END.
        END.


        /* IZ 3195 cDescFieldNames has both code and description with // seperator in cDescSubstitute. */
        CREATE ttComboData.
        ASSIGN ttComboData.cWidgetName        = "coProductModule":U
               ttComboData.cWidgetType        = "decimal":U
               ttComboData.hWidget            = coProductModule:HANDLE
               ttComboData.cBufferList        = "gsc_product_module":U
               ttComboData.cKeyFieldName      = "gsc_product_module.product_module_obj":U
               ttComboData.cDescFieldNames    = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
               ttComboData.cDescSubstitute    = "&1 // &2":U
               ttComboData.cFlag              = "A":U
               ttComboData.cCurrentKeyValue   = "":U
               ttComboData.cListItemDelimiter = coProductModule:DELIMITER
               ttComboData.cListItemPairs     = "":U
               ttComboData.cCurrentDescValue  = "":U
               ttComboData.cForEach           = "FOR EACH gsc_product_module NO-LOCK":U
                                              + "   WHERE [&FilterList=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U.

        /* build combo list-item pairs */
        RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

        /* and set-up object type combo */
        FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
        ASSIGN coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* Select 1st entry */
        IF coObjectType:NUM-ITEMS > 0 THEN
        DO:
            ASSIGN cEntry = coObjectType:ENTRY(1) NO-ERROR.
            IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
                ASSIGN coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
            ELSE
                /* blank the combo */
                ASSIGN coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
        END.

        /* and set-up product module combo */
        FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
        ASSIGN coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

        /* If no product module passed in, try using the user's current product module.
         * This value comes from the Repository API session super-procedure. */
        getRDMHandle().
        IF (gcProductModule = ? OR gcProductModule = "") AND VALID-HANDLE(ghRepositoryDesignManager) THEN
            ASSIGN gcProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":u IN ghRepositoryDesignManager) NO-ERROR.

        /* display the product module passed in */
        IF (gcProductModule <> ? AND gcProductModule <> "") THEN
        DO:
            /* Because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
             * and the second is the value. gcProductModule (product_module_code // product_module_description)
             * is the description. Look it up in the temple table string list first, then halve the size,
             * which should be its pair location in the drop-down list. Then we retrieve the value, which
             * should be gsc_product_module.product_module_obj, assign the value to the combo. */
            ASSIGN moduleEntry = LOOKUP(gcProductModule, coProductModule:LIST-ITEM-PAIRS)
                   moduleEntry = INTEGER((moduleEntry + 1) / 2)
                   cEntry      = coProductModule:ENTRY(moduleEntry)
                   NO-ERROR.
            IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
            DO:
                ASSIGN coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
                ASSIGN coProductModule.
            END.
        END.
        /* else take the 1st entry, which should not be the case normally, because a valid 
         * gcProductModule should always be passed-in in order to run the dialog box. */
        ELSE
        DO:
            IF coProductModule:NUM-ITEMS > 0 THEN
            DO:
                ASSIGN cEntry = coProductModule:ENTRY(1) NO-ERROR.
                IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
                DO:
                    ASSIGN coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
                    ASSIGN coProductModule.
                END.
                ELSE
                    /* blank the combo */
                    ASSIGN coProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS.            
            END.
        END. /* IF gcProductModule */
    END. /* {&FRAME-NAME} */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMRUList gDialog 
PROCEDURE setMRUList :
/*------------------------------------------------------------------------------
  Purpose:     Adds the most recently opened file to the User profile data
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectDesc AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iPos         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cListItems   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProfileData AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewProfile  AS CHARACTER  NO-UNDO.

/* Maximum number of Most recent items to store and display in combo-box */
&SCOPED-DEFINE MAX_MRU_ITEMS 15

ASSIGN cListitems = coCombo:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME}.


/* If the object is already in the list, put the object at the top of the list */
IF pcObjectName > "" THEN
   cProfileData = pcObjectName + FILL(" ":u, MAX(2,INTEGER((150 - FONT-TABLE:GET-TEXT-WIDTH-P(pcObjectName)) / 3)))
                               + pcObjectDesc + CHR(3) + pcObjectName.
/*   cProfileData = pcObjectName + "  /  ":U + pcObjectDesc + CHR(3) + pcObjectName.*/

IF cListItems > "" THEN
DO:
  DO ipos = 2 TO MIN({&MAX_MRU_ITEMS} * 2,NUM-ENTRIES(cListItems,CHR(3))) BY 2:
     IF ENTRY(iPos,cListItems,CHR(3)) = pcObjectName THEN
       NEXT.
     ELSE
       cProfileData = cProfileData + (IF cProfileData = "" THEN "" ELSE CHR(3))
                          + ENTRY(iPos - 1,cListItems,CHR(3)) + CHR(3) + ENTRY(iPos,cListItems,CHR(3)).
  END.
  /* Ensure the profile data doesn't have more than the maximum number of items allowed */
  IF NUM-ENTRIES(cProfileData,CHR(3)) >  {&MAX_MRU_ITEMS} * 2 THEN
  DO:
    DO iPos = 1 TO {&MAX_MRU_ITEMS} * 2:
       cNewProfile = cNewProfile + (IF cNewProfile = "" THEN "" ELSE CHR(3)) 
                        + ENTRY(iPos,cProfileData,CHR(3)).
    END.
    ASSIGN cProfileData =  cNewProfile.
  END.
END.
IF VALID-HANDLE(h_bopendialog) THEN
   cprofileData = cProfileData + CHR(4) + DYNAMIC-FUNC("getColumnWidth":U IN h_bopendialog)
                               + CHR(4) + coProductModule:SCREEN-VALUE .

RUN setProfileData IN gshProfileManager (INPUT "General":U,        /* Profile type code */
                                         INPUT "DispRepos":U,  /* Profile code */
                                         INPUT "ObjectMRU",     /* Profile data key */
                                         INPUT ?,                 /* Rowid of profile data */
                                         INPUT cProfileData,      /* Profile data value */
                                         INPUT NO,                /* Delete flag */
                                         INPUT "PER":u).          /* Save flag (permanent) */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showBrowser gDialog 
PROCEDURE showBrowser :
/*------------------------------------------------------------------------------
  Purpose:     show result records of the query in the browser
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Force a the product module to populate the browse. */
    APPLY "VALUE-CHANGED":U TO coProductModule IN FRAME {&FRAME-NAME}.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateBrowserContents gDialog 
PROCEDURE updateBrowserContents :
/*------------------------------------------------------------------------------
  Purpose:     when a value in Product Module or Object Type combo-boxes changes, 
               update the object files listed in the bowser based on the new criteria.
  Parameters:  <none>
  Notes:       If the preferences are set to exclude the display of repository objects, the
               query will be slowed down as it will be constructed using an OR connstuct for
               each product module allowed. Otherwise, he query will be constructed here based 
               on the selected product module, object type, and the object filename filter.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFilterSetClause  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilterSetCode    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjects          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cWhere            AS CHARACTER  NO-UNDO.        
    DEFINE VARIABLE iComboCount       AS INTEGER    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN coProductModule coObjectType fiFileName.

       DYNAMIC-FUNCTION("setQueryWhere":U in h_dopendialog,"").
       IF gcObjectFilterTypes > "" AND coObjectType EQ 0 THEN
       DO:
          DO iComboCount = 1 TO NUM-ENTRIES(gcObjectFilterTypes):
             ASSIGN cWhere = cWhere + (IF cWhere = "":U THEN "":U ELSE " OR ":U)
                     + " gsc_object_type.object_type_code = '":U + ENTRY(iComboCount,gcObjectFilterTypes) + "' ":U.
          END.         
          DYNAMIC-FUNCTION('addQueryWhere':U IN h_dopendialog, INPUT cWhere,?,?).
       END.
       ELSE DO:
         IF coObjectType NE 0 THEN
            DYNAMIC-FUNCTION('assignQuerySelection':U IN h_dopendialog,'object_type_obj':U,coObjectType,'EQ':U).
         ELSE DO:
            cObjects = DYNAMIC-FUNCTION("getObjectTypes":U in h_dopendialog).
            DYNAMIC-FUNCTION('addQueryWhere':U IN h_dopendialog, INPUT "LOOKUP(gsc_object_type.object_type_code, '" + cObjects + "') > 0",?,?).  
         END.
       END.

       /* Get the FilterSet for the Session */
       RUN getFilterSetClause IN gshGenManager (INPUT-OUTPUT cFilterSetCode,    /* FilterSetCode        */
                                                INPUT        "GSCPM,RYCSO":U,   /* EntityList           */
                                                INPUT        "":U,              /* BufferList           */
                                                INPUT        "":U,              /* AdditionalParameters */
                                                OUTPUT       cFilterSetClause). /* FilterSetClause      */

       IF fiObject:SCREEN-VALUE > "" THEN
         DYNAMIC-FUNC('assignQuerySelection':U IN h_dopendialog,'object_filename':U,fiObject:SCREEN-VALUE,'BEGINS':U).
       ELSE
         DYNAMIC-FUNC('removeQuerySelection':U IN h_dopendialog,'object_filename':U,'BEGINS':U).

       IF coProductModule NE 0 THEN
       DO:
          DYNAMIC-FUNCTION('assignQuerySelection':U IN h_dopendialog, 'product_module_obj':U, coProductModule,       'EQ':U).
          DYNAMIC-FUNCTION('addQueryWhere':U        IN h_dopendialog, cFilterSetClause,      'gsc_product_module':U, 'AND':U).
       END.
       ELSE
         DYNAMIC-FUNCTION('addQueryWhere':U IN h_dopendialog, cFilterSetClause, 'gsc_product_module':U, 'AND':U).

       IF gcSort > "" THEN
          DYNAMIC-FUNCTION("setQuerySort":U IN  h_dopendialog, gcSort).
       DYNAMIC-FUNCTION('openQuery' IN h_dopendialog).        
    END.  /* end {&FRAME-NAME} */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFileName gDialog 
PROCEDURE updateFileName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER newFileName AS CHARACTER NO-UNDO.
 
IF newFilename > "" THEN
DO:

  fiFileName = newFileName.

  DISPLAY fiFileName WITH FRAME {&FRAME-NAME}.

  APPLY "VALUE-CHANGED":U TO fiFilename.
  ASSIGN fiFileName:CURSOR-OFFSET = length(fiFileName:SCREEN-VALUE) + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRDMHandle gDialog 
FUNCTION getRDMHandle RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
  ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSort gDialog 
FUNCTION setSort RETURNS LOGICAL
  ( pcField  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  gcsort = pcField.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

