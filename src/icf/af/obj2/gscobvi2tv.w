&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"ry/obj/rycsoful2o.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
  File: gscobvi2twv.w

  Description:  Object SmartDataViewer 2

  Purpose:      Object SmartDataViewer 2

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000072   UserRef:    
                Date:   10/02/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                Object SmartDataViewer 2

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

&scop object-name       gscobvi2tv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.shutdown_message_text ~
RowObject.container_object RowObject.generic_object ~
RowObject.run_persistent RowObject.runnable_from_menu RowObject.design_only ~
RowObject.template_smartobject RowObject.system_owned RowObject.disabled ~
RowObject.required_db_list RowObject.deployment_type 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS TeShutdownText TeRequiredDBList 
&Scoped-Define DISPLAYED-FIELDS RowObject.shutdown_message_text ~
RowObject.container_object RowObject.generic_object ~
RowObject.run_persistent RowObject.runnable_from_menu RowObject.design_only ~
RowObject.template_smartobject RowObject.system_owned RowObject.disabled ~
RowObject.required_db_list RowObject.deployment_type 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS TeShutdownText TeRequiredDBList ~
fiDepTypeTitle 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hCustomSuperProcedure AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buClear 
     LABEL "&Clear" 
     SIZE 15 BY 1.14 TOOLTIP "Clear selecttion"
     BGCOLOR 8 .

DEFINE VARIABLE fiDepTypeTitle AS CHARACTER FORMAT "X(20)":U INITIAL "Deployment Type" 
      VIEW-AS TEXT 
     SIZE 45.2 BY .62 NO-UNDO.

DEFINE VARIABLE TeRequiredDBList AS CHARACTER FORMAT "X(256)":U INITIAL "Required DB List:" 
      VIEW-AS TEXT 
     SIZE 16.8 BY .62 NO-UNDO.

DEFINE VARIABLE TeShutdownText AS CHARACTER FORMAT "X(256)":U INITIAL "Shutdown Message Text:" 
      VIEW-AS TEXT 
     SIZE 24.4 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buClear AT ROW 15.48 COL 28.2
     RowObject.shutdown_message_text AT ROW 1 COL 28.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2
     RowObject.container_object AT ROW 3 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 25.6 BY .81
     RowObject.generic_object AT ROW 3.76 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 25.6 BY .81
     RowObject.run_persistent AT ROW 4.52 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 25.6 BY .81
     RowObject.runnable_from_menu AT ROW 5.29 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 25.4 BY .81
     RowObject.design_only AT ROW 3 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     RowObject.template_smartobject AT ROW 3.76 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     RowObject.system_owned AT ROW 4.52 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     RowObject.disabled AT ROW 5.29 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     RowObject.required_db_list AT ROW 6.05 COL 28.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2
     TeShutdownText AT ROW 1.1 COL 3.4 NO-LABEL
     TeRequiredDBList AT ROW 6.05 COL 11 NO-LABEL
     RowObject.deployment_type AT ROW 9.86 COL 28.2 NO-LABEL
          VIEW-AS SELECTION-LIST MULTIPLE 
          LIST-ITEM-PAIRS "Server","SRV",
                     "Client","CLN",
                     "Web","WEB" 
          SIZE 45 BY 5.52
          FONT 3
     fiDepTypeTitle AT ROW 9.19 COL 26.2 COLON-ALIGNED NO-LABEL
     SPACE(4.80) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsoful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsoful2o.i}
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
         HEIGHT             = 15.62
         WIDTH              = 77.2.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON buClear IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDepTypeTitle IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiDepTypeTitle:PRIVATE-DATA IN FRAME frMain     = 
                "Deployment Type".

ASSIGN 
       RowObject.required_db_list:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       RowObject.shutdown_message_text:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN TeRequiredDBList IN FRAME frMain
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN TeShutdownText IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME buClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buClear vTableWin
ON CHOOSE OF buClear IN FRAME frMain /* Clear */
DO:
  ASSIGN rowObject.deployment_type:SCREEN-VALUE = "":U.
  {set dataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.generic_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.generic_object vTableWin
ON VALUE-CHANGED OF RowObject.generic_object IN FRAME frMain /* Generic Object */
DO:
  DEFINE VARIABLE hGroupAssign  AS HANDLE   NO-UNDO.
  
  hGroupAssign = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION("linkHandles", "GroupAssign-Source":U))).
  
  IF RowObject.generic_object:SENSITIVE THEN DO:
    {set DataModified TRUE}.
    IF VALID-HANDLE(hGroupAssign) THEN
      RUN genericObject IN hGroupAssign (INPUT RowObject.generic_object:CHECKED).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.shutdown_message_text
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.shutdown_message_text vTableWin
ON VALUE-CHANGED OF RowObject.shutdown_message_text IN FRAME frMain
DO:
  {set dataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.system_owned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.system_owned vTableWin
ON VALUE-CHANGED OF RowObject.system_owned IN FRAME frMain /* System Owned */
DO:
  {set dataModified TRUE}.
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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelCustom Super ProcedureFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_code = "PROCEDURE":U, EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj AND ryc_smartobject.customization_result_obj = 0 BY ryc_smartobject.object_filenameQueryTablesgsc_object_type,ryc_smartobjectBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_extension,ryc_smartobject.object_description,ryc_smartobject.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(70),X(35),X(35),X(70)RowsToBatch200BrowseTitleLookup Custom Super ProcedureViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcFieldNamecustom_smartobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hCustomSuperProcedure ).
       RUN repositionObject IN hCustomSuperProcedure ( 8.05 , 28.20 ) NO-ERROR.
       RUN resizeObject IN hCustomSuperProcedure ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hCustomSuperProcedure ,
             RowObject.required_db_list:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields vTableWin 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN buClear:SENSITIVE = rowObject.deployment_type:SENSITIVE.
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN buClear:SENSITIVE = rowObject.deployment_type:SENSITIVE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logicalObject vTableWin 
PROCEDURE logicalObject :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will disable or enable fields depending on the
               value of the Logical Object field.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plLogicalObject AS LOGICAL    NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF RowObject.DISABLED:SENSITIVE THEN DO:
      IF plLogicalObject THEN
        ASSIGN RowObject.generic_object:CHECKED = FALSE
               RowObject.generic_object:SENSITIVE = FALSE.
      ELSE
        ASSIGN RowObject.generic_object:SENSITIVE = TRUE.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator vTableWin 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

