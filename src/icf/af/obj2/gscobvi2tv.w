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
       {"af/obj2/gscobful2o.i"}.


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
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscobful2o.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.edShutdownMessageText ~
RowObject.container_object RowObject.lStaticObject ~
RowObject.runnable_from_menu RowObject.lTemplateSmartObject ~
RowObject.run_persistent RowObject.generic_object RowObject.lSystemOwned ~
RowObject.disabled RowObject.required_db_list ~
RowObject.cCustomSuperProcedure RowObject.tooltip_text ~
RowObject.toolbar_image_filename 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS TeShutdownText TeRequiredDBList ~
TeCustomProcedure 
&Scoped-Define DISPLAYED-FIELDS RowObject.edShutdownMessageText ~
RowObject.container_object RowObject.lStaticObject ~
RowObject.runnable_from_menu RowObject.lTemplateSmartObject ~
RowObject.run_persistent RowObject.generic_object RowObject.lSystemOwned ~
RowObject.disabled RowObject.required_db_list ~
RowObject.cCustomSuperProcedure RowObject.tooltip_text ~
RowObject.toolbar_image_filename 
&Scoped-Define DISPLAYED-OBJECTS TeShutdownText TeRequiredDBList ~
TeCustomProcedure 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE TeCustomProcedure AS CHARACTER FORMAT "X(256)":U INITIAL "Custom Super Procedure:" 
      VIEW-AS TEXT 
     SIZE 24 BY .62 NO-UNDO.

DEFINE VARIABLE TeRequiredDBList AS CHARACTER FORMAT "X(256)":U INITIAL "Required DB List:" 
      VIEW-AS TEXT 
     SIZE 16.8 BY .62 NO-UNDO.

DEFINE VARIABLE TeShutdownText AS CHARACTER FORMAT "X(256)":U INITIAL "Shutdown Message Text:" 
      VIEW-AS TEXT 
     SIZE 24.4 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.edShutdownMessageText AT ROW 1 COL 28.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2
     RowObject.container_object AT ROW 3 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY .81
     RowObject.lStaticObject AT ROW 3 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY .81
     RowObject.runnable_from_menu AT ROW 3.81 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 25.4 BY .81
     RowObject.lTemplateSmartObject AT ROW 3.81 COL 54.2
          LABEL "Template"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY .81
     RowObject.run_persistent AT ROW 4.62 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .81
     RowObject.generic_object AT ROW 4.62 COL 54.2
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY .81
     RowObject.lSystemOwned AT ROW 5.43 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 21.6 BY .81
     RowObject.disabled AT ROW 6.24 COL 28.2
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY .81
     RowObject.required_db_list AT ROW 7 COL 28.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2
     RowObject.cCustomSuperProcedure AT ROW 9 COL 28.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 45.2 BY 2
     RowObject.tooltip_text AT ROW 12.14 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.2 BY 1
     RowObject.toolbar_image_filename AT ROW 13.14 COL 26.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.2 BY 1
     TeShutdownText AT ROW 1.1 COL 3.4 NO-LABEL
     TeRequiredDBList AT ROW 7.1 COL 11 NO-LABEL
     TeCustomProcedure AT ROW 9.19 COL 3.8 NO-LABEL
     SPACE(50.40) SKIP(2.29)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscobful2o.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscobful2o.i}
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
         HEIGHT             = 13.14
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       RowObject.cCustomSuperProcedure:RETURN-INSERTED IN FRAME frMain  = TRUE.

ASSIGN 
       RowObject.edShutdownMessageText:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR TOGGLE-BOX RowObject.lTemplateSmartObject IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.required_db_list:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* SETTINGS FOR FILL-IN TeCustomProcedure IN FRAME frMain
   ALIGN-L                                                              */
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

&Scoped-define SELF-NAME RowObject.cCustomSuperProcedure
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.cCustomSuperProcedure vTableWin
ON VALUE-CHANGED OF RowObject.cCustomSuperProcedure IN FRAME frMain
DO:
  {set dataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.edShutdownMessageText
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.edShutdownMessageText vTableWin
ON VALUE-CHANGED OF RowObject.edShutdownMessageText IN FRAME frMain
DO:
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


&Scoped-define SELF-NAME RowObject.lStaticObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.lStaticObject vTableWin
ON VALUE-CHANGED OF RowObject.lStaticObject IN FRAME frMain /* Static Object */
DO:
  {set dataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.lSystemOwned
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.lSystemOwned vTableWin
ON VALUE-CHANGED OF RowObject.lSystemOwned IN FRAME frMain /* System Owned */
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
             INPUT  'DisplayedFieldgsm_multi_media.physical_file_nameKeyFieldgsm_multi_media.multi_media_objFieldLabelToolbar Multi MediaFieldTooltipPress F4 For LookupKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_multi_media NO-LOCK,
                     EACH gsc_multi_media_type NO-LOCK
                     WHERE gsc_multi_media_type.multi_media_type_obj = gsm_multi_media.multi_media_type_obj INDEXED-REPOSITIONQueryTablesgsm_multi_media,gsc_multi_media_typeBrowseFieldsgsc_multi_media_type.multi_media_type_code,gsc_multi_media_type.file_extension,gsm_multi_media.physical_file_name,gsm_multi_media.multi_media_description,gsm_multi_media.creation_dateBrowseFieldDataTypescharacter,character,character,character,dateBrowseFieldFormatsX(10),X(3),X(70),X(35),99/99/9999RowsToBatch200BrowseTitleLookupViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateMultiMediaTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNametoolbar_multi_media_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 11.10 , 28.20 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.cCustomSuperProcedure:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

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

