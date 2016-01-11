&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME gDialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS gDialog 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
/*--------------------------------------------------------------------------
    File        : ryaddfile.w
    Purpose     : AppBuilder's Add to Repository dialog box.

    Syntax      : RUN ry/obj/ryaddfile.w
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
DEFINE INPUT  PARAMETER gcProductModule LIKE icfdb.gsc_product_module.product_module_code. 
DEFINE INPUT  PARAMETER gcFileName      LIKE icfdb.ryc_smartobject.object_filename. 
DEFINE INPUT  PARAMETER gcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

/* Shared _RyObject temp-table. */
{adeuib/ttobject.i}

/* Local Variable Definitions ---                                       */
/*{af/sup2/afglobals.i} 8/19 */
DEFINE VARIABLE gcOriginalWhere             AS CHARACTER INITIAL "".
DEFINE VARIABLE currentProductModule        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE currentObjectType           AS CHARACTER  NO-UNDO.

/*DEFINE VARIABLE fiFileName                 AS CHARACTER INITIAL "". */

/* IZ 2009: jep-icf: Valid object_type_code the AppBuilder can open. */
&GLOBAL-DEFINE gcOpenObjectTypes DynObjc,DynMenc,DynFold,DynBrow,Shell,hhpFile,hhcFile,DatFile,CGIProcedure,SBO,StaticSO,StaticFrame,StaticSDF,StaticDiag,StaticCont,StaticMenc,StaticObjc,StaticFold,StaticSDV,StaticSDB,SDO,JavaScript,CGIWrapper,SmartViewer,SmartQuery,SmartPanel,SmartFrame,SmartBrowser,Procedure,Window,SmartWindow,SmartFolder,SmartDialog

DEFINE VARIABLE gcOpenObjectTypes AS CHARACTER  NO-UNDO.
ASSIGN gcOpenObjectTypes = "{&gcOpenObjectTypes}":U.

{af/sup2/afttcombo.i}

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType toWeb toClient ~
toServer toDesign Btn_OK Btn_Cancel 
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


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14.

DEFINE BUTTON Btn_OK 
     LABEL "OK" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE coObjectType AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     LABEL "Object Type:" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE fcObjectPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relative Path" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "File" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE toClient AS LOGICAL INITIAL no 
     LABEL "Deploy to Client" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.6 BY .81 TOOLTIP "This object will be included in WebClient deployments" NO-UNDO.

DEFINE VARIABLE toDesign AS LOGICAL INITIAL no 
     LABEL "Design Object" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "Indicates this object is only used to design systems, and not required runtime." NO-UNDO.

DEFINE VARIABLE toServer AS LOGICAL INITIAL no 
     LABEL "Deploy to Server" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.2 BY .81 TOOLTIP "This object will be included in Appserver deployments" NO-UNDO.

DEFINE VARIABLE toWeb AS LOGICAL INITIAL no 
     LABEL "Deploy to Web" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.6 BY .81 TOOLTIP "This object will be include in Web deployments" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     fiFileName AT ROW 1 COL 19.8 COLON-ALIGNED
     coProductModule AT ROW 2.1 COL 19.8 COLON-ALIGNED
     coObjectType AT ROW 3.19 COL 19.8 COLON-ALIGNED
     fcObjectPath AT ROW 4.29 COL 19.8 COLON-ALIGNED
     toWeb AT ROW 5.43 COL 21.8
     toClient AT ROW 6.33 COL 21.8
     toServer AT ROW 7.24 COL 21.8
     toDesign AT ROW 5.38 COL 58.2
     Btn_OK AT ROW 1 COL 81
     Btn_Cancel AT ROW 2.19 COL 81
     SPACE(0.00) SKIP(4.72)
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
   L-To-R,COLUMNS                                                       */
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
      
    DEFINE VARIABLE hBrowser                    AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hSDO                        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cModuleWhere                AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cTypeWhere                  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFileNameWhere              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cModuleField                AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cTypeField                  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFileNameField              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE openObjectName              AS CHARACTER  NO-UNDO.
    
    DO WITH FRAME {&FRAME-NAME}:
        
        /* Get the frame values. */
        ASSIGN coObjectType coProductModule fiFileName fcObjectPath.

        /* assign valid outputs, GO to close the dialog */
        ASSIGN gcFileName = STRING(fiFileName)
               pressedOK = YES.

        /* Trim trailing directory slashes (\ or /) and replace remaining ones with
           forward slash for portability with how repository stores paths. */
        ASSIGN fcObjectPath = REPLACE(LC(RIGHT-TRIM(fcObjectPath, '~\/')), "~\", "/").
        
        /* Update the current product module for the user, unless it's "<All>".
           Repository API session super procedure handles this call. */
        ASSIGN currentProductModule =
            ENTRY(LOOKUP(" " + coProductModule:SCREEN-VALUE, coProductModule:LIST-ITEM-PAIRS, 
                         coProductModule:DELIMITER) - 1, 
                         coProductModule:LIST-ITEM-PAIRS, coProductModule:DELIMITER) NO-ERROR.
        getRDMHandle().
        IF (currentProductModule <> "<All>":u) AND (currentProductModule <> "") AND VALID-HANDLE(ghRepositoryDesignManager) THEN
             DYNAMIC-FUNCTION("setCurrentProductModule":u IN ghRepositoryDesignManager, currentProductModule) NO-ERROR.

        IF VALID-HANDLE(ghRepositoryDesignManager) THEN
          ASSIGN currentObjectType = DYNAMIC-FUNCTION("getObjectTypeCodeFromDB":u IN ghRepositoryDesignManager, DECIMAL(coObjectType:SCREEN-VALUE)) NO-ERROR.

        /* Pass back the object info via an _RyObject record. */
        RUN createRyObject IN THIS-PROCEDURE.

        APPLY 'GO' TO FRAME {&FRAME-NAME}.
        RETURN.
    END.    /* DO WITH {&FRAME-NAME} */

END.     /* On */

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
    ASSIGN cDeploymentType = (IF toWeb:CHECKED    = YES THEN "WEB,":U ELSE "":U)
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
            _RyObject.object_path           = fcObjectPath
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
         Btn_Cancel 
      WITH FRAME gDialog.
  VIEW FRAME gDialog.
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

    RUN SUPER.
    
    /* Determine the relative path as best we can. */
    RUN getRelativePath (INPUT gcFileName, OUTPUT fcObjectPath).
    
    /* Determine just the base filename for object filename. */
    RUN adecomm/_osprefx.p (INPUT gcFileName, OUTPUT cSavedPath, OUTPUT gcFileName).
    DISPLAY fcObjectPath WITH FRAME {&FRAME-NAME}.
    
    /* Initialize the object filename display. */
    RUN updateFileName (INPUT gcFileName).
    
    /* Populate combos. */
    RUN populateCombos.
    
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

DEFINE BUFFER ext_object                    FOR gsc_object_type.

DO WITH FRAME {&FRAME-NAME}:

  
  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_description":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_obj":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U
    ttComboData.cDescSubstitute = "&1 (&2)":U
    ttComboData.cFlag = "A":U
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
    ttComboData.cForEach = "FOR EACH gsc_product_module NO-LOCK BY gsc_product_module.product_module_code":U
    ttComboData.cBufferList = "gsc_product_module":U
    ttComboData.cKeyFieldName = "gsc_product_module.product_module_obj":U
    ttComboData.cDescFieldNames = "gsc_product_module.product_module_code,gsc_product_module.product_module_description":U
    ttComboData.cDescSubstitute = "&1 // &2":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = CHR(2)
    ttComboData.cWidgetName = "":U
    ttComboData.cCurrentDescValue = "":U
    .
  
  
   /* build combo list-item pairs */
  RUN af/app/afcobuildp.p (INPUT-OUTPUT TABLE ttComboData).
  
  /* Remove the <All> entry from Product Module and Object Type combos. */
  FOR EACH ttComboData:
      ASSIGN ttComboData.cListItemPairs =
          REPLACE(ttComboData.cListItemPairs, ("<ALL>" + ttComboData.cListItemDelimiter +
                                              "0" + ttComboData.cListItemDelimiter), "").
  END.

        
  /* Filter out object types that extend no object type, or any of Visual, Field, Action,
     Base, or ProgressWidget */
  FIND ttComboData WHERE ttComboData.hWidget = coObjectType:HANDLE.
  /* This loop must be managed carefully because thelist keeps shrinking */
  iEnt = 2.
  Filter-Loop:
  REPEAT:
    IF iEnt GT NUM-ENTRIES(ttComboData.cListItemPairs, ttComboData.cListItemDelimiter) 
        THEN LEAVE Filter-Loop.
    lRemove = FALSE.

    FIND gsc_object_type NO-LOCK 
        WHERE gsc_object_type.object_type_obj = DECIMAL(ENTRY(iEnt, ttComboData.cListItemPairs,
                                                      ttComboData.cListItemDelimiter)).
    IF gsc_object_type.extends_object_type_obj = 0 THEN lRemove = TRUE.
    ELSE DO:
      /* We're not going to check for user defined classes here, as we'd get all classes.  We'll assume these are high level base classes */
      IF LOOKUP(gsc_object_type.object_type_code, "Visual,Field,Action,Base,ProgressWidget":U) > 0
        THEN lRemove = TRUE.

      FIND ext_object NO-LOCK 
          WHERE Ext_object.OBJECT_type_obj = gsc_object_type.extends_object_type_obj.
      IF LOOKUP(ext_object.OBJECT_type_code, "Visual,Field,Action,Base,ProgressWidget":U) > 0
        THEN lRemove = TRUE.
    END.  /* Else extends is not 0 */
    /* Exceptions */

    ASSIGN cChildClasses = DYNAMIC-FUNCTION("getClassChildrenFromDb" IN gshRepositoryManager, INPUT "StaticSO,StaticSDF":U)
           cChildClasses = REPLACE(cChildClasses, CHR(3), ",":U).

    IF LOOKUP(gsc_object_type.object_type_code, cChildClasses) > 0 THEN lRemove = FALSE.

    IF lRemove THEN /* Keep iEnt the same when removing a list-item pair */
      ASSIGN ttComboData.cListItemPairs =
             REPLACE(ttcomboData.cListItemPairs,
                     (ENTRY(iEnt - 1, ttcomboData.cListItemPairs, ttComboData.cListItemDelimiter) +
                      ttComboData.cListItemDelimiter +
                      ENTRY(iEnt, ttcomboData.cListItemPairs, ttComboData.cListItemDelimiter) +
                      ttComboData.cListItemDelimiter), "").
    ELSE iEnt = iEnt + 2.
  END.  /* Do iEnt = 2 to num-entries */
  

  /* and set-up object type combo */
  ASSIGN
    coObjectType:DELIMITER                               = ttComboData.cListItemDelimiter
    coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  
  IF (gcType <> ? AND gcType <> "") THEN
  DO:
     /* Map the _TYPE field with the appropriate repository class */
     CASE gcType:
        WHEN "SmartDataViewer":U     THEN cMappedObjectType = "StaticSDV":U.
        WHEN "SmartViewer":U         THEN cMappedObjectType = "StaticSDV":U.  /* V8 */
        WHEN "SmartDataBrowser":U    THEN cMappedObjectType = "StaticSDB":U.
        WHEN "SmartBrowser":U        THEN cMappedObjectType = "StaticSDB":U.  /* V8 */
        WHEN "SmartDataObject":U     THEN cMappedObjectType = "SDO":U.
        WHEN "SmartBusinessObject":U THEN cMappedObjectType = "SBO":U.
        OTHERWISE
           cMappedObjectType = gcType.
     END CASE.
     /* Check the labels in the list-item-pairs.  The object code is in brackets */
     LIST-ITEM-LOOP:
     DO i = 1 TO NUM-ENTRIES(coObjectType:LIST-ITEM-PAIRS,coObjectType:DELIMITER) BY 2:
        ASSIGN cEntry = ENTRY(i,coObjectType:LIST-ITEM-PAIRS,coObjectType:DELIMITER)
               cEntry = TRIM(SUBSTRING(cEntry,R-INDEX(cEntry,"(":U),-1)) NO-ERROR.
        IF cEntry = "(" + cMappedObjectType + ")" THEN DO:
           coObjectType:SCREEN-VALUE = coObjectType:ENTRY( INT((i + 1) / 2)).
           LEAVE LIST-ITEM-LOOP.
        END.
     END.

  END.

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
         coProductModule:LIST-ITEM-PAIRS  = ttComboData.cListItemPairs.
  
  /* If no product module passed in, try using the user's current product module.
     This value comes from the Repository API session super-procedure. */
  getRDMHandle().
  IF (gcProductModule = ? OR gcProductModule = "") AND VALID-HANDLE(ghRepositoryDesignManager) THEN
      ASSIGN gcProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":u IN ghRepositoryDesignManager) NO-ERROR.

    /* display the product module passed in */
  IF (gcProductModule <> ? AND gcProductModule <> "") THEN
  DO:
      /* Because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
         and the second is the value. gcProductModule (product_module_code // product_module_description)
         is the description. Look it up in the temple table string list first, then halve the size,
         which should be its pair location in the drop-down list. Then we retrieve the value, which
         should be gsc_product_module.product_module_obj, assign the value to the combo. */
      ASSIGN moduleEntry = LOOKUP(gcProductModule, coProductModule:LIST-ITEM-PAIRS,coProductModule:DELIMITER)
             moduleEntry = INTEGER((moduleEntry + 1) / 2)
             cEntry      = coProductModule:ENTRY(moduleEntry) 
             NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
      DO:
        coProductModule:SCREEN-VALUE = cEntry NO-ERROR.
        ASSIGN coProductModule.
      END.
  END.
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

