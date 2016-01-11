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
DEFINE INPUT  PARAMETER gcFileName      LIKE icfdb.gsc_object.object_filename. 
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
&GLOBAL-DEFINE gcOpenObjectTypes DynObjc,DynMenc,DynFold,DynBrow,Shell,hhpFile,hhcFile,DatFile,CGIProcedure,SBO,StaticSO,StaticFrame,StaticSDF,StaticDiag,StaticCont,StaticMenc,StaticObjc,StaticFold,StaticSDV,StaticSDB,SDO,JavaScript,CGIWrapper,SmartViewer,SmartQuery,SmartPanel,SmartFrame,SmartBrowser,Container,Procedure,Window,SmartWindow,SmartFolder,SmartDialog

{af/sup2/afttcombo.i}

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
&Scoped-Define ENABLED-OBJECTS coProductModule coObjectType Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS fiFileName coProductModule coObjectType ~
fcObjectPath 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0.00
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS DECIMAL FORMAT "-999999999999999999999.999999999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEM-PAIRS "x",0.00
     DROP-DOWN-LIST
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE fcObjectPath AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     fiFileName AT ROW 1.48 COL 27 COLON-ALIGNED NO-LABEL
     coProductModule AT ROW 2.81 COL 27 COLON-ALIGNED NO-LABEL
     coObjectType AT ROW 4.19 COL 27 COLON-ALIGNED NO-LABEL
     fcObjectPath AT ROW 5.62 COL 27 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 4.14 COL 96.6
     Btn_Cancel AT ROW 5.48 COL 96.6
     "Product Module:" VIEW-AS TEXT
          SIZE 25 BY 1.14 AT ROW 2.71 COL 3
     "File:" VIEW-AS TEXT
          SIZE 23 BY 1.14 AT ROW 1.38 COL 3
     "Object Type:" VIEW-AS TEXT
          SIZE 21 BY 1.14 AT ROW 4.1 COL 3
     "Relative Path:" VIEW-AS TEXT
          SIZE 23 BY 1.14 AT ROW 5.52 COL 3
     SPACE(87.39) SKIP(0.57)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Add to Repository"
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
ON GO OF FRAME gDialog /* Add to Repository */
DO:
    APPLY 'CHOOSE' TO Btn_OK.   /* go to search the object file */
   
    IF gcFileName = ? THEN  RETURN NO-APPLY.   /* if no such a file, do not close the dialog */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Add to Repository */
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
            ENTRY(LOOKUP(" " + coProductModule:SCREEN-VALUE, coProductModule:LIST-ITEM-PAIRS) - 1, coProductModule:LIST-ITEM-PAIRS) NO-ERROR.
        IF (currentProductModule <> "<All>":u) AND (currentProductModule <> "") THEN
             DYNAMIC-FUNCTION("setCurrentProductModule":u, currentProductModule) NO-ERROR.

        /* ryreposobp.p Repository API session super procedure handles this call. */
        ASSIGN currentObjectType = DYNAMIC-FUNCTION("ObjectTypeCode":u, DECIMAL(coObjectType:SCREEN-VALUE)) NO-ERROR.

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
  
  DO ON ERROR UNDO, LEAVE:
  
    /*  IZ 3195 Storing only Product Module Code. It's in currentProductModule as 
        follows: "pm_Code // pm_Description". So it must get the code only. */
    ASSIGN cProductModuleCode = TRIM(ENTRY(1, currentProductModule, '/':u)) NO-ERROR.

    /*  jep-icf: Copy the repository related field values to _RyObject. The 
        AppBuilder will use _RyObject in processing the add file request. */
    FIND _RyObject WHERE _RyObject.object_filename = gcFileName NO-ERROR.
    IF NOT AVAILABLE _RyObject THEN
      CREATE _RyObject.
    ASSIGN  _RyObject.object_filename       = gcFileName
            _RyObject.product_module_code   = cProductModuleCode
            _RyObject.object_type_code      = currentObjectType
            _RyObject.object_path           = fcObjectPath
            _RyObject.design_action         = "OPEN":u
            _RyObject.design_ryobject       = YES.

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
  DISPLAY fiFileName coProductModule coObjectType fcObjectPath 
      WITH FRAME gDialog.
  ENABLE coProductModule coObjectType Btn_OK Btn_Cancel 
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
DEFINE VARIABLE moduleEntry                 AS INTEGER.
DEFINE VARIABLE typeName                    AS INTEGER.

DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cEntry                          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                               AS INTEGER.

  EMPTY TEMP-TABLE ttComboData.
  CREATE ttComboData.
  ASSIGN
    ttComboData.cWidgetName = "coObjectType":U
    ttComboData.cWidgetType = "decimal":U
    ttComboData.hWidget = coObjectType:HANDLE
    ttComboData.cForEach = "FOR EACH gsc_object_type WHERE CAN-DO('{&gcOpenObjectTypes}', gsc_object_type.object_type_code) NO-LOCK BY gsc_object_type.object_type_code":U
    ttComboData.cBufferList = "gsc_object_type":U
    ttComboData.cKeyFieldName = "gsc_object_type.object_type_obj":U
    ttComboData.cDescFieldNames = "gsc_object_type.object_type_description, gsc_object_type.object_type_code":U
    ttComboData.cDescSubstitute = "&1 (&2)":U
    ttComboData.cFlag = "A":U
    ttComboData.cCurrentKeyValue = "":U
    ttComboData.cListItemDelimiter = ",":U
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
    ttComboData.cListItemDelimiter = ",":U
    ttComboData.cListItemPairs = "":U
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

  /* and set-up object type combo */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coObjectType":U.
  coObjectType:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.

  /* display the object type passed in */
  IF (gcType <> ? AND gcType <> "") THEN
  DO:
      gcType = gcType + " (" + gcType + ")".
      ASSIGN typeName  = LOOKUP(gcType, coObjectType:LIST-ITEM-PAIRS).
      ASSIGN typeName = INTEGER((typeName + 1) / 2).
      cEntry = coObjectType:ENTRY(typeName) NO-ERROR.
      IF cEntry <> ? AND NOT ERROR-STATUS:ERROR THEN
      DO:
          coObjectType:SCREEN-VALUE = cEntry NO-ERROR.
          ASSIGN coObjectType.
      END.
  END.
  /* else select 1st entry */
  ELSE DO:
      IF coObjectType:NUM-ITEMS > 0 THEN
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
  END.

  /* and set-up product module combo */
  FIND FIRST ttComboData WHERE ttComboData.cWidgetName = "coProductModule":U.
  coProductModule:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ttComboData.cListItemPairs.
  
  /* If no product module passed in, try using the user's current product module.
     This value comes from the Repository API session super-procedure. */
  IF (gcProductModule = ? OR gcProductModule = "") THEN
      ASSIGN gcProductModule = DYNAMIC-FUNCTION("getCurrentProductModule":u) NO-ERROR.

  /* display the product module passed in */
  IF (gcProductModule <> ? AND gcProductModule <> "") THEN
  DO:
      /* Because we take list-item-pairs, for each combo drop-down list pair, the first is the description,
         and the second is the value. gcProductModule (product_module_code // product_module_description)
         is the description. Look it up in the temple table string list first, then halve the size,
         which should be its pair location in the drop-down list. Then we retrieve the value, which
         should be gsc_product_module.product_module_obj, assign the value to the combo. */
      ASSIGN moduleEntry = LOOKUP(gcProductModule, coProductModule:LIST-ITEM-PAIRS).
      ASSIGN moduleEntry = INTEGER((moduleEntry + 1) / 2).
      cEntry = coProductModule:ENTRY(moduleEntry) NO-ERROR.
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

