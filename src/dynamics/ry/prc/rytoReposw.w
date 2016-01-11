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
    File        : rytoReposw.w
    Purpose     : AppBuilder's Save as a dynamic object dialog box.

    Syntax      : RUN ry/prc/rytoReposw.w
                  (INPUT  phWindow,
                   INPUT  gcProductModule,
                   INPUT  gcFileName,
                   INPUT  gcType,
                   OUTPUT pRyObject,
                   OUTPUT p_ok)
    
    Input Parameters:
        phWindow        : Window in which to display the dialog box.
        gcProductModule : Initial Product Module Code.
        gcFileName      : Full filename of object to add.
        gcType          : Initial object type code (may be AppBuilder type)
        pRecid          : RECID of the _P table
    
    Output Parameters:
        pRyObject : RECID of the RyObject Temp-table record with Object info
        p_ok      : TRUE if user successfully choose to add file to repos.

    Description: from cntnrdlg.w - ADM2 SmartDialog Template

    History     : 
                  03/08/2002      Created by          Ross Hunter  (DRH)
                  Created from ry/obj/ryaddfile.w
                  
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
DEFINE INPUT  PARAMETER gcProductModule LIKE gsc_product_module.product_module_code. 
DEFINE INPUT  PARAMETER gcFileName      LIKE ryc_smartobject.object_filename. 
DEFINE INPUT  PARAMETER gcType          AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pRecid          AS RECID        NO-UNDO.
DEFINE OUTPUT PARAMETER pRyObject       AS RECID        NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.


/* Local Variable Definitions ---                                       */
{src/adm2/globals.i}
{adeuib/uniwidg.i }      /* AppBuilder temptable definitions */

/* Handle to the SCM tool super procedure */
DEFINE VARIABLE ghScmTool AS HANDLE   NO-UNDO.

DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcObjectType              AS CHARACTER  NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS ToPrc cObjectType fiFileName fiDesc ~
coProductModule fiRelDirectory fiRootDirectory fiPrcFilename coSuperType ~
coSuperProductModule fiprcFullPath Btn_OK Btn_Cancel buBrowse fiTitle ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS ToPrc cObjectType fiFileName fiDesc ~
coProductModule fiRelDirectory fiRootDirectory fiPrcFilename coSuperType ~
coSuperProductModule fisuperRelDirectory fiprcFullPath fiTitle 

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

DEFINE BUTTON buBrowse 
     LABEL "Browse..." 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE cObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Dynamic Object Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE coProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE coSuperProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE coSuperType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiDesc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrcFilename AS CHARACTER FORMAT "X(256)":U 
     LABEL "File Name" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiprcFullPath AS CHARACTER FORMAT "X(256)":U 
     LABEL "Full Path Name" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiRelDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relative Directory" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiRootDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Root Directory" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE fisuperRelDirectory AS CHARACTER FORMAT "X(256)":U 
     LABEL "Relative Directory" 
     VIEW-AS FILL-IN 
     SIZE 63 BY 1 NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(50)":U INITIAL "Create Custom Super Procedure" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 31 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.8 BY 8.19.

DEFINE VARIABLE ToPrc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 5 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME gDialog
     ToPrc AT ROW 7.52 COL 4
     cObjectType AT ROW 1.24 COL 22 COLON-ALIGNED
     fiFileName AT ROW 2.43 COL 22 COLON-ALIGNED
     fiDesc AT ROW 3.62 COL 22 COLON-ALIGNED
     coProductModule AT ROW 4.81 COL 22 COLON-ALIGNED
     fiRelDirectory AT ROW 6 COL 22 COLON-ALIGNED
     fiRootDirectory AT ROW 8.71 COL 21.2 COLON-ALIGNED
     fiPrcFilename AT ROW 9.91 COL 21.2 COLON-ALIGNED
     coSuperType AT ROW 11.1 COL 21.2 COLON-ALIGNED
     coSuperProductModule AT ROW 12.29 COL 21.2 COLON-ALIGNED
     fisuperRelDirectory AT ROW 13.48 COL 21.2 COLON-ALIGNED
     fiprcFullPath AT ROW 14.67 COL 21.2 COLON-ALIGNED NO-TAB-STOP 
     Btn_OK AT ROW 16.67 COL 30.2
     Btn_Cancel AT ROW 16.67 COL 47.2
     buBrowse AT ROW 8.62 COL 74.2
     fiTitle AT ROW 7.57 COL 5.8 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 7.91 COL 2.4
     SPACE(2.19) SKIP(1.99)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Save As Dynamic Object"
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

ASSIGN 
       fiprcFullPath:READ-ONLY IN FRAME gDialog        = TRUE.

ASSIGN 
       fiRelDirectory:READ-ONLY IN FRAME gDialog        = TRUE.

/* SETTINGS FOR FILL-IN fisuperRelDirectory IN FRAME gDialog
   NO-ENABLE                                                            */
ASSIGN 
       fisuperRelDirectory:READ-ONLY IN FRAME gDialog        = TRUE.

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
ON GO OF FRAME gDialog /* Save As Dynamic Object */
DO:
    APPLY 'CHOOSE' TO Btn_OK.   /* go to search the object file */
   
    IF gcFileName = ? THEN  RETURN NO-APPLY.   /* if no such a file, do not close the dialog */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gDialog gDialog
ON WINDOW-CLOSE OF FRAME gDialog /* Save As Dynamic Object */
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
  RUN validate-save IN THIS-PROCEDURE.
  IF RETURN-VALUE = "ERROR":U THEN
      RETURN NO-APPLY.
  ELSE
      APPLY 'GO':U TO FRAME {&FRAME-NAME}.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buBrowse gDialog
ON CHOOSE OF buBrowse IN FRAME gDialog /* Browse... */
DO:
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.

  RUN getFolder("Directory", OUTPUT cDirectory).

  IF cDirectory <> "" THEN DO:
     ASSIGN fiRootDirectory:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDirectory.
     APPLY "Value-changed":U TO fiRootDirectory.
  END.
  
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coProductModule gDialog
ON VALUE-CHANGED OF coProductModule IN FRAME gDialog /* Product Module */
DO:
    FIND gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = TRIM(ENTRY(1, SELF:SCREEN-VALUE, "/":U)) NO-ERROR.
    IF AVAILABLE gsc_product_module
    THEN DO:
      IF VALID-HANDLE(ghScmTool) AND 
         DYNAMIC-FUNCTION('scmGetCurrentWorkspace' IN ghScmTool) <> "":U THEN 
         /* We have a valid workspace selected */
      DO:        
         /* Get the relative directory from SCM instead of from gsc_product_module  */
         RUN scmGetModuleDir IN ghScmTool (INPUT gsc_product_module.product_module_code,
                                           INPUT "":U, 
                                           OUTPUT fiRelDirectory).
         ASSIGN fiRelDirectory:SCREEN-VALUE = TRIM(REPLACE(fiRelDirectory,"~\":U,"~/":U),"~/":U) NO-ERROR. 
      END.
      ELSE 
      ASSIGN fiRelDirectory:SCREEN-VALUE = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).    
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coSuperProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coSuperProductModule gDialog
ON VALUE-CHANGED OF coSuperProductModule IN FRAME gDialog /* Product Module */
DO:
  FIND gsc_product_module NO-LOCK
    WHERE gsc_product_module.product_module_code = TRIM(ENTRY(1, SELF:SCREEN-VALUE, "/":U)) NO-ERROR.
    IF AVAILABLE gsc_product_module
    THEN DO:
      IF VALID-HANDLE(ghScmTool) AND 
         DYNAMIC-FUNCTION('scmGetCurrentWorkspace' IN ghScmTool) <> "":U THEN 
         /* We have a valid workspace selected */
      DO:        
         /* Get the relative directory from SCM instead of from gsc_product_module  */
         RUN scmGetModuleDir IN ghScmTool (INPUT gsc_product_module.product_module_code, 
                                           INPUT "":U,
                                           OUTPUT fiRelDirectory).
         ASSIGN 
            fiSuperRelDirectory:SCREEN-VALUE = TRIM(REPLACE(fiRelDirectory,"~\":U,"~/":U),"~/":U) NO-ERROR
            . 
      END.
      ELSE 
      ASSIGN fiSuperRelDirectory:SCREEN-VALUE = TRIM(REPLACE(gsc_product_module.relative_path,"~\":U,"~/":U),"~/":U).    
    END.
    
    RUN displayFullPathName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPrcFilename
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPrcFilename gDialog
ON VALUE-CHANGED OF fiPrcFilename IN FRAME gDialog /* File Name */
DO:
  RUN displayFullPathName IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRootDirectory
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRootDirectory gDialog
ON VALUE-CHANGED OF fiRootDirectory IN FRAME gDialog /* Root Directory */
DO:
  RUN displayFullPathName IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToPrc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToPrc gDialog
ON VALUE-CHANGED OF ToPrc IN FRAME gDialog
DO:
  
 IF SELF:CHECKED THEN
    ASSIGN fiPrcFileName:SCREEN-VALUE = fiFileName:SCREEN-VALUE 
                                        + (IF gcType = "SmartDataObject":U 
                                          THEN "logcp.p":U
                                          ELSE "supr.p":U)
           fiRootDirectory:SENSITIVE = TRUE
           fiPrcFilename:SENSITIVE = TRUE 
           buBrowse:SENSITIVE = TRUE .
 ELSE
    ASSIGN fiPrcFileName:SCREEN-VALUE = ""
           fiPrcFullPath:SCREEN-VALUE = ""
           fiRootDirectory:SENSITIVE = FALSE
           fiPrcFilename:SENSITIVE   = FALSE 
           buBrowse:SENSITIVE        = FALSE .
 
  RUN displayFullPathName.
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
  DO ON ERROR UNDO, LEAVE:
    /*  jep-icf: Copy the repository related field values to _RyObject. The 
        AppBuilder will use _RyObject in processing the add file request. */
    FIND _RyObject WHERE _RyObject.object_filename = gcFileName NO-ERROR.
    IF NOT AVAILABLE _RyObject THEN
      CREATE _RyObject.
    ASSIGN  _RyObject.object_type_code      = cObjectType:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            _RyObject.parent_classes        = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.object_type_code)
            _RyObject.object_filename       = fiFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME}
            _RyObject.product_module_code   = TRIM(coProductModule:SCREEN-VALUE)
            _RyObject.object_path           = "":U            
            _RYobject.OBJECT_description    = fiDesc:SCREEN-VALUE 
            _RyObject.design_action         = "OPEN":u
            _RyObject.static_object         = NO
            _RyObject.design_ryobject       = YES
            pRyObject                       = RECID(_RyObject)
            NO-ERROR.
    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFullPathName gDialog 
PROCEDURE displayFullPathName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF toPrc:CHECKED IN FRAME {&FRAME-NAME} THEN
  ASSIGN
    fiPrcFullPath:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
              = (IF fiRootDirectory:SCREEN-VALUE <> "":U 
                 THEN (TRIM(fiRootDirectory:SCREEN-VALUE,"~\":U) + "~/":U ) 
                 ELSE "":U)
               + (IF fiSuperRelDirectory:SCREEN-VALUE <> "":U 
                  THEN (TRIM(fiSuperRelDirectory:SCREEN-VALUE,"~\":U) + "~/":U ) 
                  ELSE "":U)
                + TRIM(fiPrcFilename:SCREEN-VALUE,"~/":U) .
   
ELSE
   ASSIGN fiPrcFullPath:SCREEN-VALUE = "".
           
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
  DISPLAY ToPrc cObjectType fiFileName fiDesc coProductModule fiRelDirectory 
          fiRootDirectory fiPrcFilename coSuperType coSuperProductModule 
          fisuperRelDirectory fiprcFullPath fiTitle 
      WITH FRAME gDialog.
  ENABLE ToPrc cObjectType fiFileName fiDesc coProductModule fiRelDirectory 
         fiRootDirectory fiPrcFilename coSuperType coSuperProductModule 
         fiprcFullPath Btn_OK Btn_Cancel buBrowse fiTitle RECT-2 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFolder gDialog 
PROCEDURE getFolder :
/*------------------------------------------------------------------------------
  Purpose:     Use the COM interface Shell to browse for a folder
  Parameters:  pcTitle   Name of title to appear in browse folder
               pcPath    (OUTPUT) Returned path
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTitle AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPath  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE chServer AS COM-HANDLE NO-UNDO. /* shell application */
  DEFINE VARIABLE chFolder AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE chParent AS COM-HANDLE NO-UNDO.
  DEFINE VARIABLE lvFolder AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lvCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFrame   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWin     AS HANDLE     NO-UNDO.

  hFrame = FRAME {&FRAME-NAME}:HANDLE.
  hWin   = hFrame:WINDOW.
  
  /* create Shell Automation object */
  CREATE 'Shell.Application' chServer.

  IF NOT VALID-HANDLE(chServer) THEN 
      RETURN "":u. /* automation object not present on system */
 
  ASSIGN
      chFolder = chServer:BrowseForFolder(hWin:HWND,pcTitle,3).

  /* see if user has selected a valid folder */
   IF VALID-HANDLE(chFolder) AND chFolder:SELF:IsFolder THEN 
      ASSIGN pcPath   = chFolder:SELF:Path.
   ELSE
      ASSIGN pcPath   = "":U.

  
  
  RELEASE OBJECT chParent NO-ERROR.
  RELEASE OBJECT chFolder NO-ERROR.
  RELEASE OBJECT chServer NO-ERROR.
  
  ASSIGN
    chParent = ?
    chFolder = ?
    chServer = ?
    .
  
  ASSIGN pcPath = TRIM(REPLACE(LC(pcPath),"~\":U,"/":U),"~/":U).
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
    DEFINE VARIABLE cSavedPath      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRootDirectory  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lFileNotFound   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hObjectBuffer   AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cPathedFileName AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cClass          AS CHARACTER  NO-UNDO.
       
    /* Get the handle to the SCM Tool and design manager */
    ASSIGN ghScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, 'PRIVATE-DATA:SCMTool':U) 
           ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U)
           NO-ERROR.
      

    RUN SUPER.
 

    IF gcType = "SmartDataObject":U THEN
    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN fiTitle:SCREEN-VALUE = "Create Data Logic Procedure"
              fiTitle:WIDTH     = FONT-TABLE:GET-TEXT-WIDTH(fiTitle:SCREEN-VALUE) + 1
              toPrc:CHECKED   = YES
              toPrc:SENSITIVE = NO.
    END.
    ASSIGN FILE-INFO:FILE-NAME = gcFilename
           lFileNotFound       = (FILE-INFO:FILE-TYPE = ?).
   
       
    /* Determine just the base filename for object filename. */
    IF NOT lFileNotFound THEN
       RUN adecomm/_osprefx.p (INPUT gcFileName, OUTPUT cSavedPath, OUTPUT gcFileName).
    
    /* Initialize the object filename display. */
    RUN updateFileName (INPUT ENTRY(1,gcFileName,".":U) + IF NUM-ENTRIES(gcFileName,".") = 2 THEN ENTRY(2,gcFileName,".":U) ELSE "").
    
    /* Populate module combs. */
    RUN populateCombos.
        
   ASSIGN 
      cRootDirectory               = DYNAMIC-FUNCTION('getSessionRootDirectory':U IN THIS-PROCEDURE)
      fiRootDirectory:SCREEN-VALUE = cRootDirectory.

    APPLY "VALUE-CHANGED":U TO coProductModule.
    APPLY "VALUE-CHANGED":U TO coSuperProductModule.
    APPLY "VALUE-CHANGED":U TO toPrc.
    APPLY "ENTRY":U TO fiFilename.

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
DEFINE VARIABLE cWhere         AS CHARACTER  NO-UNDO.        
DEFINE VARIABLE cField         AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE moduleEntry    AS INTEGER.
DEFINE VARIABLE typeName       AS INTEGER.
DEFINE VARIABLE cProductList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEntry         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentPM     AS CHARACTER  NO-UNDO.

/* Get list of product modules from repository manager */
IF VALID-HANDLE(ghRepositoryDesignManager) THEN
         cProductList = DYNAMIC-FUNCTION("getproductModuleList":U IN ghRepositoryDesignManager,
                                            INPUT "product_module_Code":U,
                                            INPUT "product_module_code,product_module_description":U,
                                            INPUT "&1 // &2":U,
                                            INPUT CHR(3))   NO-ERROR.
ASSIGN
  coProductModule:DELIMITER IN FRAME {&FRAME-NAME}        = CHR(3)
  coProductModule:LIST-ITEM-PAIRS      = cProductList
  cCurrentPM                           = DYNAMIC-FUNC("getCurrentProductModule":U IN ghRepositoryDesignManager) 
  cCurrentPM                           = IF INDEX(cCurrentPM,"//":U) > 0 THEN SUBSTRING(cCurrentPM,1,INDEX(cCurrentPM,"//":U) - 1)
                                                                         ELSE cCurrentPM
  cCurrentPM                           = IF NUM-ENTRIES(coProductModule:LIST-ITEM-PAIRS,CHR(3)) > 1  
                                            AND  (cCurrentPM = "" OR LOOKUP(cCurrentPM, coProductModule:LIST-ITEM-PAIRS,CHR(3)) = 0)
                                         THEN ENTRY(2,coProductModule:LIST-ITEM-PAIRS,CHR(3)) ELSE cCurrentPM                                                                          
  coProductModule:SCREEN-VALUE         = TRIM(cCurrentPM)
  coSuperProductModule:DELIMITER       = CHR(3)
  coSuperProductModule:LIST-ITEM-PAIRS = cProductList
  coSuperProductModule:SCREEN-VALUE    = coProductModule:SCREEN-VALUE
  NO-ERROR.
  
  /* Display object-type in view-as text fill-in */
  /* If current object is a SDV or SDB then Display Dynamic version */

CASE gcType:
   WHEN "SmartDataViewer":U OR WHEN "SmartViewer":U THEN
      gcObjectType = "DynView".
   WHEN "SmartDataBrowser":U OR WHEN "SmartBrowser":U THEN
      gcObjectType = "DynBrow":U.
   WHEN "SmartDataObject":U  THEN
      gcObjectType = "DynSDO".
   WHEN "SmartBusinessObject":U  THEN
      gcObjectType = "DynSBO".
END CASE.

IF gcObjectType > "" THEN 
DO:
  ASSIGN cObjectType:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT gcObjectType)
         cObjectType:SCREEN-VALUE  =  cOBjectType:ENTRY(1) 
         NO-ERROR.
  IF gcObjectType = "DynSDO":U THEN
     ASSIGN coSuperType:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DLProc":U).
  ELSE
     ASSIGN coSuperType:LIST-ITEMS = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "Procedure":U).
  ASSIGN coSuperType:SCREEN-VALUE = coSuperType:ENTRY(1).

END.
ELSE
  btn_OK:SENSITIVE = FALSE.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate-save gDialog 
PROCEDURE validate-save :
/*------------------------------------------------------------------------------
  Purpose:     Validates all user input before returning
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowser         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDO             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cModuleWhere     AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cTypeWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileNameWhere   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleField     AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cTypeField       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileNameField   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDir             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDesignManager   AS HANDLE     NO-UNDO.

  DEFINE BUFFER b_U FOR _U.

 DO WITH FRAME {&FRAME-NAME}:
   /* Get the frame values. */
   ASSIGN coProductModule fiFileName.
        
   IF ToPrc:CHECKED THEN
   DO:
      /* Ensure the directory exists for the super procedure */
     cDir = TRIM(substring(fiPrcFullPath:SCREEN-VALUE IN FRAME {&FRAME-NAME},1,R-INDEX(fiPrcFullPath:SCREEN-VALUE,"/":U)),"/").
     FILE-INFO:FILE-NAME = cDir NO-ERROR.
     
     IF FILE-INFO:FULL-PATHNAME = ? THEN
     DO:
        MESSAGE "The specified directory '" + cDir + " ' does not exist." 
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY":U TO coProductModule.
      RETURN "ERROR":U.
     END.
     /* Ensure the specified dir is not read-only */
     IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN
     DO:
       MESSAGE "The specified directory '" + cDir + " ' is Read-only." 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
       APPLY "ENTRY":U TO coProductModule.
       RETURN "ERROR":U.
     END.
     /* Ensure the filename is not blank */
     IF fiPrcFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN
     DO:
        MESSAGE "You must specify a File Name for the " + IF gcType = "SmartDataObject":U THEN "data logic procedure." ELSE "custom super procedure."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "ENTRY":U TO coProductModule. 
        RETURN "ERROR":U.
     END.
   END. /* END ToPrc:Checked */


  /* Check whether object name already exists */
  ASSIGN hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  IF VALID-HANDLE(hDesignManager) AND 
     DYNAMIC-FUNCTION("ObjectExists":U IN hDesignManager, INPUT fiFilename )  THEN
  DO:
      MESSAGE fiFilename:SCREEN-VALUE + " already exists in the repository" SKIP
              "Please specify another object name"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY":U TO fiFilename.
      RETURN "ERROR":U.
  END.

   /* Validate the product module */
   IF NOT CAN-FIND(FIRST gsc_product_module 
                   WHERE gsc_product_module.product_module_code = coProductModule:SCREEN-VALUE) THEN
   DO:
      MESSAGE "Invalid Product Module" 
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "ENTRY":U TO coProductModule.
      RETURN "ERROR":U.
   END.
   /* assign valid outputs, GO to close the dialog */
   IF VALID-HANDLE(ghRepositoryDesignManager) THEN 
     DYNAMIC-FUNCTION("setCurrentProductModule":u IN ghRepositoryDesignManager, coProductModule) NO-ERROR.

    /* Pass back the object info via an _RyObject record. */
   RUN createRyObject IN THIS-PROCEDURE.
   IF ERROR-STATUS:ERROR THEN
      RETURN "ERROR":U.
    
   FIND _P WHERE RECID(_P) = pRecid NO-ERROR.
   FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
   FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
    
   IF AVAILABLE _P THEN 
      ASSIGN _P._SAVE-AS-FILE = fiFilename:SCREEN-VALUE.
   IF toPrc:CHECKED AND AVAILABLE _C THEN
   DO:
     FIND gsc_product_module NO-LOCK
          WHERE gsc_product_module.product_module_code = _RyObject.product_module_code NO-ERROR.
     IF gcObjectType = "DynView":U OR gcObjectType = "DynBrow":U /* For DynViewers and DynBrowsers */
     THEN DO:
       IF AVAILABLE gsc_product_module THEN
          ASSIGN
            _P._save-as-path      = gsc_product_module.relative_path
            _P.product_module_obj = gsc_product_module.product_module_obj
            _P.object_path        = gsc_product_module.relative_path
            NO-ERROR.

       IF AVAILABLE(_C) THEN
          ASSIGN     /* get the root directory */
              fiRootDirectory
              _C._CUSTOM-SUPER-PROC       = fiPrcFullPath:SCREEN-VALUE
              _C._CUSTOM-SUPER-PROC-PATH  =  _P.object_path
              _C._CUSTOM-SUPER-PROC-PMOD  = TRIM(coSuperProductModule:SCREEN-VALUE)
              _C._CUSTOM-SUPER-PROC-TYPE  = coSuperType:SCREEN-VALUE
              NO-ERROR. 
     END.
     ELSE IF gcObjectType = "DynSDO":U  THEN
       ASSIGN 
           _C._DATA-LOGIC-PROC         = fiPrcFullPath:SCREEN-VALUE
           _C._DATA-LOGIC-PROC-PATH    = fiSuperRelDirectory:SCREEN-VALUE
           _C._DATA-LOGIC-PROC-PMOD    = TRIM(coSuperProductModule:SCREEN-VALUE) 
            NO-ERROR.
   END. /* End toPrc:Checked */
   ELSE IF AVAILABLE _C THEN
      ASSIGN _C._CUSTOM-SUPER-PROC       = ""
             _C._CUSTOM-SUPER-PROC-PATH  = ""
             _C._CUSTOM-SUPER-PROC-PMOD  = ""
             _C._DATA-LOGIC-PROC         = ""
             _C._DATA-LOGIC-PROC-PATH    = ""
             _C._DATA-LOGIC-PROC-PMOD    = "".

   
   ASSIGN pressedOK = YES.
 END.    /* DO WITH {&FRAME-NAME} */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

