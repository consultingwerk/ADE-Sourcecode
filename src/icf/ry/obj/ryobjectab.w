&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" wiWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" wiWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wiWin 
/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
  File: ryobjectab.w

  Description:  Supports calling code to create _RyObject "open" record for AB.

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/17/2001  Author:     John Palazzo

  Update Notes: Created from Template rysttbconw.w
                IZ 2342 : MRU List doesn't work with dynamic objects.
                Fix     : Part of fix for this issue.
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

&scop object-name       ryobjectab.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* object identifying preprocessor */
&glob   astra2-staticSmartWindow yes

{af/sup2/afglobals.i}

/* Shared _RyObject and _custom temp-tables. */
{adeuib/ttobject.i}
{adeuib/custwidg.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buFind fiFileName 
&Scoped-Define DISPLAYED-OBJECTS fiFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wiWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dopendialog AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buFind 
     LABEL "&Find" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Filename" 
     VIEW-AS FILL-IN 
     SIZE 56 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buFind AT ROW 1 COL 77.8
     fiFileName AT ROW 1.05 COL 19 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.8 BY 2.91.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wiWin ASSIGN
         HIDDEN             = YES
         TITLE              = "RyObject Manager"
         HEIGHT             = 2.91
         WIDTH              = 91.8
         MAX-HEIGHT         = 28.81
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 28.81
         VIRTUAL-WIDTH      = 146.2
         SHOW-IN-TASKBAR    = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wiWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wiWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
                                                                        */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
THEN wiWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wiWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON END-ERROR OF wiWin /* RyObject Manager */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wiWin wiWin
ON WINDOW-CLOSE OF wiWin /* RyObject Manager */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buFind
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buFind wiWin
ON CHOOSE OF buFind IN FRAME frMain /* Find */
DO:
    DEFINE VARIABLE cError  AS CHARACTER  NO-UNDO.

    ASSIGN fiFileName.
    RUN getRyObject (INPUT-OUTPUT fiFilename, OUTPUT cError).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wiWin 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wiWin  _ADM-CREATE-OBJECTS
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
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'AppServiceAstraASUsePromptASInfoForeignFieldsRowsToBatch20CheckCurrentChangedyesRebuildOnReposnoServerOperatingModeNONEDestroyStatelessnoDisconnectAppServernoObjectNamedopendialogUpdateFromSourcenoToggleDataTargetsyesOpenOnInitnoPromptOnDeleteyesPromptColumns(ALL)':U ,
             OUTPUT h_dopendialog ).
       RUN repositionObject IN h_dopendialog ( 1.95 , 4.20 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRYObject wiWin 
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
    
    cColumns = DYNAMIC-FUNC("colValues" IN h_dopendialog,"object_filename,smartobject_obj,object_type_obj,~
object_type_code,product_module_obj,product_module_code,object_description,object_path,object_extension,~
runnable_from_menu,disabled,run_persistent,run_when,security_smartobject_obj,container_object,~
physical_smartobject_obj,static_object,generic_object,required_db_list,layout_obj,deployment_type,design_only").
    
    FIND _RyObject WHERE _RyObject.object_filename = ENTRY(2,cColumns,CHR(1)) NO-ERROR.
    IF NOT AVAILABLE _RyObject THEN 
      CREATE _RyObject.

    ASSIGN _RyObject.Object_type_code          = ENTRY(5,cColumns,CHR(1))
           _RyObject.parent_classes            = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.Object_type_code)
           _RyObject.Object_filename           = ENTRY(2,cColumns,CHR(1))
           _RyObject.smartobject_obj           = DECIMAL(ENTRY(3,cColumns,CHR(1)))
           _RyObject.Object_type_obj           = DECIMAL(ENTRY(4,cColumns,CHR(1)))           
           _RyObject.product_module_obj        = DECIMAL(ENTRY(6,cColumns,CHR(1)))
           _RyObject.product_module_code       = ENTRY(7,cColumns,CHR(1))
           _RyObject.Object_description        = ENTRY(8,cColumns,CHR(1))
           _RyObject.Object_path               = ENTRY(9,cColumns,CHR(1))
           _RyObject.Object_extension          = ENTRY(10,cColumns,CHR(1))
           _RyObject.runnable_from_menu        = (ENTRY(11,cColumns,CHR(1)) = "Yes":U OR ENTRY(11,cColumns,CHR(1)) = "true":U)
           _RyObject.disabled                  = (ENTRY(12,cColumns,CHR(1)) = "Yes":U OR ENTRY(12,cColumns,CHR(1)) = "true":U)
           _RyObject.Run_persistent            = (ENTRY(13,cColumns,CHR(1)) = "Yes":U OR ENTRY(13,cColumns,CHR(1)) = "true":U)
           _RyObject.Run_when                  = ENTRY(14,cColumns,CHR(1))
           _RyObject.security_smartObject_obj  = DECIMAL(ENTRY(15,cColumns,CHR(1)))
           _RyObject.container_object          = (ENTRY(16,cColumns,CHR(1)) = "Yes":U OR ENTRY(16,cColumns,CHR(1)) = "true":U)
           _RyObject.physical_smartObject_obj  = DECIMAL(ENTRY(17,cColumns,CHR(1)))
           _RyObject.static_object             = (ENTRY(18,cColumns,CHR(1)) = "Yes":U OR ENTRY(18,cColumns,CHR(1)) = "true":U)
           _RyObject.generic_object            = (ENTRY(19,cColumns,CHR(1)) = "Yes":U OR ENTRY(19,cColumns,CHR(1)) = "true":U)
           _RyObject.Required_db_list          = ENTRY(20,cColumns,CHR(1))
           _RyObject.Layout_obj                = DECIMAL(ENTRY(21,cColumns,CHR(1)))
           _RyObject.design_action             = "OPEN":u
           _RyObject.design_ryobject           = YES 
           _RyObject.deployment_type           = ENTRY(21,cColumns,CHR(1))
           _RyObject.design_only               = (ENTRY(22,cColumns,CHR(1)) = "Yes":U OR ENTRY(22,cColumns,CHR(1)) = "true":U)
           NO-ERROR.
                                                                           /* Object_type_code */
    FIND FIRST local_custom WHERE local_custom._object_type_code = ENTRY(5,cColumns,CHR(1)) NO-ERROR.

    IF NOT AVAILABLE local_custom 
    THEN DO:
        IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynView":U)) > 0 THEN
            FIND FIRST local_custom WHERE local_custom._object_type_code = "SmartDataViewer":U NO-ERROR.
        ELSE
            IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynSDO":U)) > 0 THEN
                FIND FIRST local_custom WHERE local_custom._object_type_code = "DynSDO":U NO-ERROR.
            ELSE
                IF LOOKUP(_RyObject.object_type_code, DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "DynBrow":U)) > 0 THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wiWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wiWin)
  THEN DELETE WIDGET wiWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wiWin  _DEFAULT-ENABLE
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
  DISPLAY fiFileName 
      WITH FRAME frMain IN WINDOW wiWin.
  ENABLE buFind fiFileName 
      WITH FRAME frMain IN WINDOW wiWin.
  VIEW FRAME frMain IN WINDOW wiWin.
  {&OPEN-BROWSERS-IN-QUERY-frMain}
  VIEW wiWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wiWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRyObject wiWin 
PROCEDURE getRyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  pObjectName - obejct_filename to get for an open in the AppBuilder
               pError      - Blank if no problem messages. Currently always "".
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT-OUTPUT PARAMETER pcObjectName       AS CHARACTER.
DEFINE OUTPUT       PARAMETER pError            AS CHARACTER.

DEFINE VARIABLE cQueryPosition AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelativePath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cExtension     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lStatic        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFullPath      AS CHARACTER  NO-UNDO.

ASSIGN pcObjectName = REPLACE(pcObjectName,"~\":U,"/":U)
       cObjectName  = pcObjectName.
 

DYNAMIC-FUNC('assignQuerySelection':U IN h_dopendialog, 'ryc_smartobject.object_filename':U, cObjectName, "EQ":U).
/* do the new query and update the browser */
{fn OpenQuery h_dopendialog} .
{get QueryPosition cQueryPosition h_dopendialog}. /* any data? */

IF cQueryPosition = "NoRecordAvailable":U THEN
DO:
   /* Check if the object is registered under the last entry */
   IF NUM-ENTRIES(cObjectName,"/") > 1 THEN
   DO:
      ASSIGN cObjectName = ENTRY(NUM-ENTRIES(cObjectName,"/":U),cObjectName,"/":U).
      DYNAMIC-FUNC('assignQuerySelection':U IN h_dopendialog, 'ryc_smartobject.object_filename':U, cObjectName, "EQ":U).
      {fn OpenQuery h_dopendialog} .
      {get QueryPosition cQueryPosition h_dopendialog}. /* any data? */
   END. /* If we found a "/":U in the object name */

   IF cQueryPosition = "NoRecordAvailable":U THEN
   DO:
      IF NUM-ENTRIES(cObjectName,".") > 1 THEN
      DO:
         ASSIGN cObjectName = ENTRY(1,cObjectName,".":U).
         DYNAMIC-FUNC('assignQuerySelection':U IN h_dopendialog, 'ryc_smartobject.object_filename':U, cObjectName, "EQ":U).
         {fn OpenQuery h_dopendialog} .
         {get QueryPosition cQueryPosition h_dopendialog}. /* any data? */
      END.  /* If we found an extension in the object name */
   END.  /* If we haven't found a match yet */
END.  /* If we can't find it in the repository with the first query */

IF cQueryPosition <> "NoRecordAvailable":U THEN DO:
  ASSIGN pcObjectName = cObjectName.
  /* Check whether the object is static and exists */
  ASSIGN lStatic = DYNAMIC-FUNC('columnValue' IN h_dopendialog, 'static_object':U)
         cRelativePath = DYNAMIC-FUNC('columnValue' IN h_dopendialog, 'object_path':U)
         cExtension    = DYNAMIC-FUNC('columnValue' IN h_dopendialog, 'object_extension':U)
         cFullPath     = cRelativePath + (IF cRelativePath = "" THEN "" ELSE "/") + cObjectName + IF NUM-ENTRIES(cObjectName,".") > 1 THEN "" ELSE "." + cExtension 
         NO-ERROR.
         IF lStatic AND SEARCH(cFullPath) = ? THEN
            perror = "Static Object not found":U.
  /* Create the _RyObject record to be later used by AppBuilder to copy data to _P. */
  
  IF perror = "" THEN  DO:
     RUN createRyObject IN THIS-PROCEDURE.
     ASSIGN pError = RETURN-VALUE.
  END.
END.
ELSE pError = "Object Not found".

RUN exitObject.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

