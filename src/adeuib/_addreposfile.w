&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : _addreposfile.w
    Purpose     : AppBuilder's Add to Repository dialog box.

    Syntax      : RUN adeuib/_addreposfile.w
                  (INPUT  phWindow,
                   INPUT  gcProductModule,
                   INPUT  gcFileName,
                   INPUT  gcType,
                   OUTPUT p_ok)

    Input Parameters:
        phWindow        : Window in which to display the dialog box.
        gcProductModule : Initial Product Module Code.
        gcFileName      : Full filename of object to add.
        gcType          : Initialo object type code (may be AppBuilder type)

    Output Parameters:
        p_ok      : TRUE if user successfully choose to add file to repos.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     :

                  11/20/2001      Updated by          John Palazzo (jep)
                  IZ 3195 Description missing from PM list.
                  Fix: Added description to PM list: "code // description".

                  11/18/2001      Updated by          John Palazzo
                  IZ 2513 Error when trying to save structured include
                  Updated the FORMAT for coObjectType so code can extract
                  object type obj and codes correctly. Make database call
                  to FIND gsc_object_type using obj id. Should be replaced
                  with AppServer-aware call instead of straight db search.

                  11/10/2001      created by          John Palazzo
                  Based on gopendialog.w file.
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
DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
define input  parameter gcProductModule as character    no-undo.
define input  parameter gcFilename      as character    no-undo.
DEFINE INPUT  PARAMETER gcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

/* Shared _RyObject temp-table. */
{adeuib/ttobject.i}
{adeuib/sharvars.i}

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcOriginalWhere             AS CHARACTER INITIAL "".
DEFINE VARIABLE currentProductModule        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE currentObjectType           AS CHARACTER  NO-UNDO.

/*DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". */

/* IZ 2009: jep-icf: Valid object_type_code the AppBuilder can open. */
&GLOBAL-DEFINE gcOpenObjectTypes DynObjc,DynMenc,DynFold,DynBrow,Shell,hhpFile,hhcFile,DatFile,CGIProcedure,SBO,StaticSO,StaticFrame,StaticSDF,StaticDiag,StaticCont,StaticMenc,StaticObjc,StaticFold,StaticSDV,StaticSDB,SDO,JavaScript,CGIWrapper,SmartViewer,SmartQuery,SmartPanel,SmartFrame,SmartBrowser,Procedure,Window,SmartWindow,SmartFolder,SmartDialog

DEFINE VARIABLE gcOpenObjectTypes AS CHARACTER  NO-UNDO.
ASSIGN gcOpenObjectTypes = "{&gcOpenObjectTypes}":U.

/* DEF taken from {af/sup2/afttcombo.i}*/
DEFINE TEMP-TABLE ttComboData NO-UNDO
FIELD hWidget               AS HANDLE           /* Handle of widget, e.g. coCompany:HANDLE */
FIELD cWidgetName           AS CHARACTER        /* Name of widget, e.g. coCompany */
FIELD cWidgetType           AS CHARACTER        /* Data Type of widget, e.g. DECIMAL, INTEGER, CHARACTER, DATE, etc. */
FIELD cForEach              AS CHARACTER        /* FOR EACH statement used to retrieve the data, e.g. FOR EACH gsm_user NO-LOCK BY gsm_user.user_login_name */
FIELD cBufferList           AS CHARACTER        /* comma delimited list of buffers used in FOR EACH, e.g. gsm_user */
FIELD cKeyFieldName         AS CHARACTER        /* name of key field as table.fieldname, e.g. gsm_user.user_obj */
FIELD cDescFieldNames       AS CHARACTER        /* comma delimited list of description fields as table.fieldname, e.g. gsm_user.user_login_name */
FIELD cDescSubstitute       AS CHARACTER        /* Substitution string to use when description contains multiple fields, e.g. &1 / &2 */
FIELD cFlag                 AS CHARACTER        /* Flag (N/A) N = <None>, A = <All> to include extra empty entry to indicate none or all */
FIELD cCurrentKeyValue      AS CHARACTER        /* currently selected key field value */
FIELD cListItemDelimiter    AS CHARACTER        /* Delimiter for list item pairs, e.g. , */
FIELD cListItemPairs        AS CHARACTER        /* Found list item pairs */
FIELD cCurrentDescValue     AS CHARACTER        /* If specified cCurrentKeyValue is valid, this field will contain corresponding list-item pair description */
    INDEX keyIndex IS PRIMARY hWidget
    INDEX key2 cWidgetName.

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME gDialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType toWeb toClient ~
toServer toDesign Btn_OK Btn_Cancel buHelp 
&Scoped-Define DISPLAYED-OBJECTS fiFileName coProductModule coObjectType ~
fcObjectPath toWeb toClient toServer toDesign 

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
&IF DEFINED(EXCLUDE-isAbstractClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isAbstractClass Procedure
FUNCTION isAbstractClass RETURNS LOGICAL 
	(input pcClass as character) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buHelp 
     LABEL "Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Object type" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE fcObjectPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relative path" 
     VIEW-AS FILL-IN 
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "File" 
     VIEW-AS FILL-IN 
     SIZE 79 BY 1 NO-UNDO.

DEFINE VARIABLE toClient AS LOGICAL INITIAL no 
     LABEL "Deploy to client" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.6 BY .81 TOOLTIP "This object will be included in WebClient deployments" NO-UNDO.

DEFINE VARIABLE toDesign AS LOGICAL INITIAL no 
     LABEL "Design object" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "Indicates this object is only used to design systems, and not required runtime." NO-UNDO.

DEFINE VARIABLE toServer AS LOGICAL INITIAL no 
     LABEL "Deploy to server" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.2 BY .81 TOOLTIP "This object will be included in Appserver deployments" NO-UNDO.

DEFINE VARIABLE toWeb AS LOGICAL INITIAL no 
     LABEL "Deploy to web" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "This object will be include in Web deployments" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     fiFileName AT ROW 1 COL 20 COLON-ALIGNED
     coProductModule AT ROW 2.19 COL 20 COLON-ALIGNED
     coObjectType AT ROW 3.38 COL 20 COLON-ALIGNED
     fcObjectPath AT ROW 4.57 COL 20 COLON-ALIGNED
     toWeb AT ROW 6 COL 22
     toClient AT ROW 6.95 COL 22
     toServer AT ROW 7.91 COL 22
     toDesign AT ROW 6 COL 66
     Btn_OK AT ROW 9.1 COL 22.2
     Btn_Cancel AT ROW 9.1 COL 41.2
     buHelp AT ROW 9.1 COL 84
     SPACE(3.39) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Register in Repository"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
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
   NOT-VISIBLE FRAME-NAME Custom                                        */
ASSIGN 
       FRAME gDialog:SCROLLABLE       = FALSE
       FRAME gDialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fcObjectPath IN FRAME gDialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiFileName IN FRAME gDialog
   NO-ENABLE                                                            */
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
ON GO OF FRAME gDialog /* Register in Repository */
DO:
    APPLY 'CHOOSE' TO Btn_OK.   /* go to search the object file */

    IF gcFileName = ? THEN  RETURN NO-APPLY.   /* if no such a file, do not close the dialog */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Register in Repository */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK gDialog
ON CHOOSE OF Btn_OK IN FRAME gDialog /* OK */
DO:
    RUN validateObject in target-procedure.
    IF RETURN-VALUE > "" THEN
       RETURN NO-APPLY.

    /* Set the session wide current product module */
    IF (currentProductModule <> "<All>":u) AND (currentProductModule <> "") THEN
         DYNAMIC-FUNCTION("setCurrentProductModule":u IN ghRepositoryDesignManager, currentProductModule) NO-ERROR.

    ASSIGN currentObjectType = coObjectType:SCREEN-VALUE
           gcFileName        = STRING(fiFileName)   /* assign valid outputs, GO to close the dialog */
           pressedOK         = YES
           NO-ERROR.

    /* Pass back the object info via an _RyObject record. */
    RUN createRyObject IN target-PROCEDURE.

    APPLY 'GO' TO FRAME {&FRAME-NAME}.
    RETURN.

END.     /* On */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buHelp gDialog
ON CHOOSE OF buHelp IN FRAME gDialog /* Help */
DO:
  IF VALID-HANDLE(gshSessionManager) THEN
  DO:
    RUN contextHelp IN gshSessionManager
      (INPUT THIS-PROCEDURE, INPUT FOCUS).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coObjectType gDialog
ON VALUE-CHANGED OF coObjectType IN FRAME gDialog /* Object type */
DO:
    self:Tooltip = self:screen-value.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON VALUE-CHANGED OF coProductModule IN FRAME gDialog /* Product module */
DO:
  ASSIGN SELF:TOOLTIP = ENTRY(SELF:LOOKUP(SELF:SCREEN-VALUE) * 2 - 1, SELF:LIST-ITEM-PAIRS,SELF:DELIMITER).
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRyObject gDialog 
PROCEDURE createRyObject :
/*------------------------------------------------------------------------------
  Purpose:     Create an _RyObject record that the AB uses to handle repository
               object information when processing an OPEN object request.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProductModuleCode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDeploymentType    AS CHARACTER NO-UNDO.

  DO ON ERROR UNDO, LEAVE WITH FRAME {&FRAME-NAME}:

    /*  IZ 3195 Storing only Product Module Code. It's in currentProductModule as
        follows: "pm_Code // pm_Description". So it must get the code only. */
    ASSIGN cProductModuleCode = TRIM(ENTRY(1, currentProductModule, '/':u)) NO-ERROR.
    ASSIGN cDeploymentType =   (IF toWeb:CHECKED    = YES THEN "WEB,":U ELSE "":U)
                             + (IF toClient:CHECKED = YES THEN "CLN,":U ELSE "":U)
                             + (IF toServer:CHECKED = YES THEN "SRV":U ELSE "":U)
           cDeploymentType = RIGHT-TRIM(cDeploymentType, ",":U).

    /*  jep-icf: Copy the repository related field values to _RyObject. The
        AppBuilder will use _RyObject in processing the add file request. */
    FIND _RyObject WHERE _RyObject.object_filename = gcFileName NO-ERROR.
    IF NOT AVAILABLE _RyObject THEN
    CREATE _RyObject.
    ASSIGN  _RyObject.object_type_code      = currentObjectType
            _RyObject.parent_classes        = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.object_type_code)
            _RyObject.object_filename       = gcFileName
            _RyObject.product_module_code   = cProductModuleCode
            _RyObject.object_path           = fcObjectPath:SCREEN-VALUE
            _RyObject.design_action         = "OPEN":u
            _RyObject.design_ryobject       = YES
            _RyObject.deployment_type       = cDeploymentType
            _RyObject.design_only           = toDesign:CHECKED.

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
  DISPLAY fiFileName coProductModule coObjectType fcObjectPath toWeb toClient 
          toServer toDesign 
      WITH FRAME gDialog.
  ENABLE coProductModule coObjectType toWeb toClient toServer toDesign Btn_OK 
         Btn_Cancel buHelp 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRelativePath gDialog 
PROCEDURE getRelativePath :
/*------------------------------------------------------------------------------
  Purpose:     Given a filename, returns the propath relative path.
  Parameters:  pFullFilename
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFullFilename   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pRelativePath   AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cFilename        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSavedPath       AS CHARACTER  NO-UNDO.

    RUN adecomm/_relfile.p
        (INPUT pFullFilename, INPUT NO /* plCheckRemote */,
         INPUT "" /* pcOptions */, OUTPUT pRelativePath).
    RUN adecomm/_osprefx.p
        (INPUT pRelativePath, OUTPUT pRelativePath, OUTPUT cFilename).
    /* Trim trailing directory slashes (\ or /) and replace remaining ones with
       forward slash for portability with how repository stores paths. */
    ASSIGN pRelativePath = REPLACE(LC(RIGHT-TRIM(pRelativePath, '~\/')), "~\", "/").
    RETURN.

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

    DEFINE VARIABLE cSavedPath       AS CHARACTER  NO-UNDO.

    IF VALID-HANDLE(gshRepositoryManager) THEN
        ASSIGN gcOpenObjectTypes = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT gcOpenObjectTypes)
               gcOpenObjectTypes = REPLACE(gcOpenObjectTypes, CHR(3), ",":U).

    /* Parent the dialog-box to the specified window. */
    IF VALID-HANDLE(phWindow) THEN
        ASSIGN FRAME {&FRAME-NAME}:PARENT = phWindow.

    {set Hideoninit YES}.
    RUN SUPER.

    getRDMHandle().
    /* Determine the relative path as best we can. */
    RUN getRelativePath (INPUT gcFileName, OUTPUT fcObjectPath).
    ASSIGN fcObjectPath:SCREEN-VALUE = REPLACE(LC(RIGHT-TRIM(fcObjectPath, '~\/')), "~\", "/").
              .
    /* Determine just the base filename for object filename. */
    RUN adecomm/_osprefx.p (INPUT gcFileName, OUTPUT cSavedPath, OUTPUT gcFileName).
    DISPLAY fcObjectPath WITH FRAME {&FRAME-NAME}.

    /* Initialize the object filename display. */
    RUN updateFileName (INPUT gcFileName).

    /* Populate combos. */
    RUN populateCombos.
    RUN viewObject IN THIS-PROCEDURE.
END PROCEDURE.    /* end procedure */

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
DEFINE VARIABLE cWhere                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE moduleEntry                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEnt                        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lRemove                     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cChildClasses               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i                           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMappedObjectType           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDisplayRepository          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cWhereClause                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rRowID                      AS ROWID      NO-UNDO.
DEFINE VARIABLE cProfileData                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProductModule              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDefaultProductModule       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProductModuleObj           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelativePath               AS CHARACTER  NO-UNDO.
define variable cObjectTypeCode as character no-undo.

DO WITH FRAME {&FRAME-NAME}:
  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "character":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type NO-LOCK " + 
                           " WHERE gsc_object_type.extends_object_type_obj <> 0 " + 
                           " BY gsc_object_type.object_type_code":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_code":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U
    ttComboData.cDescSubstitute = "&2 (&1)":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = CHR(2)
    ttComboData.cListItemPairs = "":U
    ttComboData.cCurrentDescValue = "":U
    .

  /* IZ 3195 cDescFieldNames has both code and description with // seperator in cDescSubstitute. */
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coProductModule":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coProductModule:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK WHERE [&FilterSet=|&EntityList=GSCPM] BY gsc_product_module.product_module_code":U
    ttComboData.cBufferList = "gsc_product_module":U
    ttComboData.cKeyFieldName = "gsc_product_module.product_module_obj":U
    ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description,gsc_product_module.relative_path":U
    ttComboData.cDescSubstitute = "&1 // &2 (&3)":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = CHR(2)
    ttComboData.cWidgetName = "":U
    ttComboData.cCurrentDescValue = "":U.

   /* build combo list-item pairs */
  RUN af/app/afcobuildp.p (INPUT-OUTPUT TABLE ttComboData).

    /* Exclusions */
    ASSIGN cChildClasses = DYNAMIC-FUNCTION("getClassChildrenFromDb" IN gshRepositoryManager, INPUT "StaticSO,StaticSDF":U)
           cChildClasses = REPLACE(cChildClasses, CHR(3), ",":U).

  /* Filter out object types that extend no object type, or any of Visual, Field, Action,
     Base, or ProgressWidget */
  FIND ttComboData WHERE ttComboData.hWidget = coObjectType:HANDLE.
  
  Filter-Loop:
  do iEnt = 2 to num-entries(ttComboData.cListItemPairs, ttComboData.cListItemDelimiter) by 2.
    cObjectTypeCode = entry(iEnt, ttComboData.cListItemPairs, ttComboData.cListItemDelimiter).
    
    /* abstract classes can't have objects created for them. */    
    lRemove = dynamic-function('isAbstractClass':u in target-procedure, cObjectTypeCode)
              or can-do(cChildClasses, cObjectTypeCode).

    if lRemove then
        assign entry(iEnt, ttComboData.cListItemPairs,ttComboData.cListItemDelimiter) = '?':u    /* value*/
               entry(iEnt - 1, ttComboData.cListItemPairs,ttComboData.cListItemDelimiter) = '?':u. /* label */
  END.  /* Do iEnt = 2 to num-entries */
  
  /* and set-up object type combo */
  ASSIGN
    ttComboData.cListItemPairs = replace(ttComboData.cListItemPairs, ttComboData.cListItemDelimiter + '?', '')
    ttComboData.cListItemPairs = replace(ttComboData.cListItemPairs, '?':u + ttComboData.cListItemDelimiter, '')
    coObjectType:DELIMITER                              = ttComboData.cListItemDelimiter
    coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
    
   /* Map the _TYPE field with the appropriate repository class */
  CASE gcType:
    WHEN "SmartDataViewer":U     THEN cMappedObjectType = "StaticSDV":U.
    WHEN "SmartViewer":U         THEN cMappedObjectType = "StaticSDV":U.  /* V8 */
    WHEN "SmartDataBrowser":U    THEN cMappedObjectType = "StaticSDB":U.
    WHEN "SmartBrowser":U        THEN cMappedObjectType = "StaticSDB":U.  /* V8 */
    WHEN "SmartDataObject":U     THEN cMappedObjectType = "SDO":U.
    WHEN "SmartBusinessObject":U THEN cMappedObjectType = "SBO":U.
    WHEN "DataLogicProcedure":U  THEN cMappedObjectType = "DLProc":U.
    WHEN "" OR WHEN ?            THEN cMappedObjectType = "Procedure":U.
    OTHERWISE cMappedObjectType = gcType.
  END CASE.

  /* Check the labels in the list-item-pairs.  The object code is in brackets */
  coObjectType:screen-value = cMappedObjectType.
  APPLY "VALUE-CHANGED":U TO coObjectType.

  /* else select 1st entry */
   IF coObjectType:SCREEN-VALUE =  ? AND coObjectType:NUM-ITEMS > 0 THEN
   DO:
     cEntry = coObjectType:ENTRY(1) NO-ERROR.
     IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
     DO:
       coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
     END.
     ELSE
     DO:
       /* blank the combo */
       coObjectType:LIST-ITEM-PAIRS = coObjectType:LIST-ITEM-PAIRS.
     END.
   END.

  /* and set-up product module combo */
  FIND FIRST ttComboData WHERE ttComboData.hWidget = coProductModule:HANDLE.
  ASSIGN coProductModule:DELIMITER        = ttComboData.cListItemDelimiter.
         coProductModule:LIST-ITEM-PAIRS  = REPLACE(ttComboData.cListItemPairs,"(?)":U,"( )":U).

   /* Try to determine whether any existing product module has the same relative path as the current static file */
  Module-Loop:
  DO i = 1 TO NUM-ENTRIES(coProductModule:LIST-ITEM-PAIRS,coProductModule:DELIMITER) BY 2:
      ASSIGN cProductModule = ENTRY(i,coProductModule:LIST-ITEM-PAIRS,coProductModule:DELIMITER)
             cRelativePath  = TRIM(SUBSTRING(cProductModule,R-INDEX(cProductModule,"(":U) + 1, - 1))
             cRelativePath  = RIGHT-TRIM(cRelativePath,")")
             cRelativePath  = IF cRelativePath = ?  THEN "" ELSE cRelativePath
             NO-ERROR.
      IF cRelativePath = fcObjectPath:SCREEN-VALUE THEN
      DO:
         ASSIGN cDefaultProductModule = cProductModule
                cProductModuleObj     =  ENTRY(i + 1,coProductModule:LIST-ITEM-PAIRS,coProductModule:DELIMITER).
         IF cProductModule = gcProductModule THEN
           LEAVE Module-Loop.
      END.
  END.

  IF cDefaultProductModule = "" OR cDefaultProductModule = ? THEN
  DO:
     ASSIGN btn_OK:SENSITIVE = FALSE.
     MESSAGE "No product modules are defined (or exists) with a relative directory of ~n'" + fcObjectPath:SCREEN-VALUE + "' or they might " +
             "be excluded because of an active session filter set.~n~n"
             "You must move/copy this file to a directory that is defined as a relative ~ndirectory for a specific product module. Alternatively, " +
             "update the filter ~nset to include your product module or set the session's filter set to ~n<None> from the 'Preferences' window " +
             "if the product module exists."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
  END.

  /* display the product module passed in */
  IF (cProductModuleObj <> ? AND cProductModuleObj <> "") THEN
     ASSIGN coProductModule:SCREEN-VALUE = cProductModuleObj
            coProductModule NO-ERROR.
  /* else take the 1st entry, which should not be the case normally, because a valid
     gcProductModule should always be passed-in in order to run the dialog box. */
  ELSE DO:
    IF coProductModule:NUM-ITEMS > 0 THEN
    DO:
      cEntry = coProductModule:ENTRY(1) NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
      DO:
        coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
        ASSIGN coProductModule.
      END.
      ELSE
      DO:
        /* blank the combo */
        coProductModule:LIST-ITEM-PAIRS = coProductModule:LIST-ITEM-PAIRS.
      END.
    END.
  END. /* IF gcProductModule */
  APPLY "VALUE-CHANGED":U TO coProductModule.
END. /* {&FRAME-NAME} */

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

    ASSIGN fiFileName = newFileName.
    DISPLAY fiFileName WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateObject gDialog 
PROCEDURE validateObject :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectFileName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcRelativePath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcRootDir          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcRelPathSCM       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcFullPath         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcObject           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcFile             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCalcError            AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN coObjectType coProductModule fiFileName fcObjectPath.   /* Get the frame values. */
     /* Update the current product module for the user, unless it's "<All>".
         Repository API session super procedure handles this call. */

      ASSIGN currentProductModule =
          ENTRY(LOOKUP(" " + coProductModule:SCREEN-VALUE, coProductModule:LIST-ITEM-PAIRS,
                       coProductModule:DELIMITER) - 1,
                       coProductModule:LIST-ITEM-PAIRS, coProductModule:DELIMITER) NO-ERROR.

     /* Check physical file is stored in same relative directory as module */
        RUN calculateObjectPaths IN gshRepositoryManager
                  ("",  /* ObjectName */          0.0, /* Object Obj */
                   "",  /* Object Type */         TRIM(ENTRY(1,currentProductModule,"/")),  /* Product Module Code */
                   "", /* Param */                "",
                   OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                   OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                   OUTPUT cCalcObject,            OUTPUT cCalcFile,
                   OUTPUT cCalcError).

         IF cCalcError > "" THEN
         DO:
           MESSAGE cCalcError VIEW-AS ALERT-BOX.
           RETURN "error".
         END.

    IF cCalcRelPathSCM > "" THEN
       cCalcRelativePath = cCalcRelPathSCM.

     /* Check physical file is stored in same relative directory as module */
     ASSIGN cObjectFileName = REPLACE(fiFileName, "~\", "/")
            cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
    IF R-INDEX(cObjectFileName,".") > 0
       AND SEARCH(cCalcRelativePath
                   + (IF cCalcRelativePath > "" THEN "~/":U ELSE "")
                   + cObjectFileName ) = ? THEN
    DO:
       MESSAGE  cObjectFileName + " is not located in the '"
                       + (IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                         THEN cCalcRelativePath
                         ELSE "default")
                       + "' directory. " + CHR(10)
                       + "The file must be located in the same directory as the product module's relative path.":U
          VIEW-AS ALERT-BOX WARNING.
       RETURN "ERROR":U.


    END.
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

&IF DEFINED(EXCLUDE-isAbstractClass) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isAbstractClass Procedure
FUNCTION isAbstractClass RETURNS LOGICAL
	( input pcClass as character ):
/*------------------------------------------------------------------------------
    Purpose: Determines whether a class (object type) is abstract and so
             cannot have any objects built against it.             
    Notes:   * This code doesn't take custom classes into consideration.
------------------------------------------------------------------------------*/
    define variable xcAbstractClasses as character no-undo.
    
    xcAbstractClasses = 'Base,AppServer,DataQuery,DataView,Query,Data,WebVisual,':u
                      + 'Visual,Container,DataVisual,Browser,Viewer,DynContainer,TVController,':u
                      + 'Field,Folder,Toolbar,Panel,TreeView,Messaging,Consumer,Producer,MsgHandler,':u
                      + 'XML,B2B,Router,DynamicObject,ProgressWidget,FieldWidget':u.

    return can-do(xcAbstractClasses, pcClass).
END FUNCTION.    /* isAbstractClass */
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF