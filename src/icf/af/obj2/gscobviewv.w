&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
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
  File: gscobviewv.w

  Description:  Object Viewer

  Purpose:      Object Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000035   UserRef:    
                Date:   28/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rysttviewv.w

                Note that this viewer relies on a calculated field in the SDO called
                security_object_filename. The notes in the changeSecurityObject
                internal procedure describe why this is done.

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

&scop object-name       gscobviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
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
&Scoped-Define ENABLED-FIELDS RowObject.object_filename ~
RowObject.object_path RowObject.object_description ~
RowObject.runnable_from_menu RowObject.disabled RowObject.run_persistent ~
RowObject.container_object RowObject.generic_object RowObject.run_when ~
RowObject.static_object RowObject.required_db_list 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS buReadFromRCode 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_filename ~
RowObject.object_path RowObject.object_description ~
RowObject.runnable_from_menu RowObject.disabled RowObject.run_persistent ~
RowObject.container_object RowObject.generic_object RowObject.run_when ~
RowObject.static_object RowObject.required_db_list 
&Scoped-Define DISPLAYED-OBJECTS fiSecDesc fiPhysDesc 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-3 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscotdcs2v AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpmprdfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buReadFromRCode 
     LABEL "&Read from File" 
     SIZE 16.8 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiPhysDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiSecDesc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.6 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_filename AT ROW 4.33 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55.6 BY 1
     RowObject.object_path AT ROW 5.33 COL 13.4
          VIEW-AS FILL-IN 
          SIZE 55.6 BY 1
     RowObject.object_description AT ROW 6.33 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55.6 BY 1
     RowObject.runnable_from_menu AT ROW 7.38 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 25.4 BY .81
     RowObject.disabled AT ROW 8.19 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 13.2 BY .81
     RowObject.run_persistent AT ROW 9 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .81
     RowObject.container_object AT ROW 9.76 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY .81
     RowObject.generic_object AT ROW 10.52 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY .81
     RowObject.run_when AT ROW 11.38 COL 23.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Only One Instance","ONE",
                     "No Transaction Active","NOT",
                     "Anytime","ANY",
                     "No Other Programs Can Run","NOR"
          DROP-DOWN-LIST
          SIZE 56.4 BY 1
     fiSecDesc AT ROW 12.43 COL 48.2 COLON-ALIGNED NO-LABEL
     RowObject.static_object AT ROW 13.48 COL 25.8
          VIEW-AS TOGGLE-BOX
          SIZE 18.6 BY .81
     fiPhysDesc AT ROW 14.24 COL 47.8 COLON-ALIGNED NO-LABEL
     RowObject.required_db_list AT ROW 15.29 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 38.8 BY 1
     buReadFromRCode AT ROW 15.29 COL 64.6
     SPACE(0.80) SKIP(0.00)
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
         HEIGHT             = 15.48
         WIDTH              = 81.2.
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

/* SETTINGS FOR FILL-IN fiPhysDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiSecDesc IN FRAME frMain
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN RowObject.object_path IN FRAME frMain
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

&Scoped-define SELF-NAME buReadFromRCode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buReadFromRCode vTableWin
ON CHOOSE OF buReadFromRCode IN FRAME frMain /* Read from File */
DO:
  RUN getRCodeInfo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.static_object
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.static_object vTableWin
ON VALUE-CHANGED OF RowObject.static_object IN FRAME frMain /* Logical Object */
DO:
  DEFINE VARIABLE dProdModuleObj    AS DECIMAL      NO-UNDO.

  IF RowObject.static_object:CHECKED THEN
  DO:
    {set DataValue "'0':U" h_dynlookup-2}.
    {set DataModified YES h_dynlookup-2}.
    /* Run changedProductModule to update the object path when logical object
       is turned off */
    dProdModuleObj = DYNAMIC-FUNCTION('getDataValue':U IN h_gscpmprdfv).
    RUN changedProductModule(INPUT dProdModuleObj).
  END.  /* if checked */
  ELSE RowObject.object_path:SCREEN-VALUE = '':U.

  DYNAMIC-FUNCTION('setDataModified':U, 
     INPUT TRUE).
  RUN enableFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RowObject.object_filename
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.object_filename vTableWin
ON LEAVE OF RowObject.object_filename IN FRAME frMain /* Object Filename */
DO:
  RUN changeSecurityObject.
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
             INPUT  'af/obj2/gscotdcs2v.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscotdcs2v ).
       RUN repositionObject IN h_gscotdcs2v ( 1.00 , 11.80 ) NO-ERROR.
       RUN resizeObject IN h_gscotdcs2v ( 1.05 , 70.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscpmprdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_module_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmprdfv ).
       RUN repositionObject IN h_gscpmprdfv ( 2.05 , 6.60 ) NO-ERROR.
       RUN resizeObject IN h_gscpmprdfv ( 2.33 , 75.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSecurity ObjectFieldTooltipKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK,
                     FIRST gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,ryc_smartobject.object_path,ryc_smartobject.container_object,ryc_smartobject.disabled,ryc_smartobject.generic_object,ryc_smartobject.static_object,ryc_smartobject.runnable_from_menu,ryc_smartobject.run_persistent,ryc_smartobject.run_whenBrowseFieldDataTypescharacter,character,character,character,character,logical,logical,logical,logical,logical,logical,characterBrowseFieldFormatsX(10),X(15),X(35),X(35),X(70),YES/NO,YES/NO,YES/NO,YES/NO,YES/NO,YES/NO,X(3)RowsToBatch200BrowseTitleLookup Security ObjectViewerLinkedFieldsryc_smartobject.object_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiSecDescFieldNamesecurity_object_filenameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-3 ).
       RUN repositionObject IN h_dynlookup-3 ( 12.43 , 25.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-3 ( 1.00 , 24.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.smartobject_objFieldLabelPhysical ObjectFieldTooltipKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.generic_object = YES,
                     FIRST gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj,
                     FIRST gsc_product_module NO-LOCK WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.object_filenameQueryTablesryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object_type.object_type_code,ryc_smartobject.object_filename,ryc_smartobject.object_description,ryc_smartobject.object_path,ryc_smartobject.container_object,ryc_smartobject.disabled,ryc_smartobject.generic_object,ryc_smartobject.static_object,ryc_smartobject.runnable_from_menu,ryc_smartobject.run_persistent,ryc_smartobject.run_whenBrowseFieldDataTypescharacter,character,character,character,character,logical,logical,logical,logical,logical,logical,characterBrowseFieldFormatsX(10),X(15),X(35),X(35),X(70),YES/NO,YES/NO,YES/NO,YES/NO,YES/NO,YES/NO,X(3)RowsToBatch200BrowseTitleLookup Physical ObjectViewerLinkedFieldsryc_smartobject.object_descriptionLinkedFieldDataTypescharacterLinkedFieldFormatsX(35)ViewerLinkedWidgetsfiPhysDescFieldNamephysical_smartobject_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 14.24 , 25.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 24.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscotdcs2v ,
             RowObject.object_filename:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscpmprdfv ,
             h_gscotdcs2v , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-3 ,
             RowObject.run_when:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             RowObject.static_object:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changedProductModule vTableWin 
PROCEDURE changedProductModule :
/*------------------------------------------------------------------------------
  Purpose:     Gets the relative path for the current product module in order 
               to set the object path appropriately
  Parameters:  pdProdModuleObj AS DECIMAL
  Notes:       Called from value-changed of the logical object toggle and 
               from value-changed of the product module combo in the product
               module SmartDataField
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdProdModuleObj AS DECIMAL NO-UNDO.

DEFINE VARIABLE cRelativePath   AS CHARACTER    NO-UNDO.

   /* Runs procedure on the AppServer to get the relative path for the
      current product module */
   RUN af/sup2/gscpmrelpp.p ON gshAstraAppServer 
     (INPUT pdProdModuleObj, OUTPUT cRelativePath).

   /* If this is not a logical object then update the object path for the 
      changed product module */
   IF RowObject.static_object:CHECKED IN FRAME {&FRAME-NAME} THEN
     ASSIGN 
       RowObject.object_path:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
         TRIM(REPLACE(cRelativePath, '~\':U, '/':U), '/':U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeSecurityObject vTableWin 
PROCEDURE changeSecurityObject :
/*------------------------------------------------------------------------------
  Purpose:     If we're adding a record, we need to default the value of the 
               security_smartobject_obj to the value of the object_obj for the current
               record. This procedure is called from the leave trigger on the 
               object_filename control.

  Notes:       This procedure combines with some others in the SDO to workaround
               a complicated chicken-and-egg situation.

               The security_smartobject_obj field on the ryc_smartobject table needs to be
               defaulted to the value of the smartobject_obj field when a record
               is added. IOW, an object is the security object for itself.

               The problem is that we have no idea what the smartobject_obj field 
               value is until the ryc_smartobject record gets created on the database,
               and that only happens when the transaction is committed.

               We could assume that a zero security_smartobject_obj means that the
               value of the security_smartobject_obj should be defaulted. The 
               problem is that a zero security_smartobject_obj means that there
               is no security on this object. There is thus no way of 
               distinguishing between a zero security_smartobject_obj that means
               no security and a zero security_smartobject_obj that means 
               "default security to this object number".

               To work around this, we base the Security Object prompt on a 
               calculated field in the SDO called "security_object_filename". 
               The SDO takes care of determining the security_smartobject_obj
               based on matching the filename.

               In this procedure we need to determine if the user is in Add 
               mode so that we can default the value of the 
               security_object_filename to the same as the object_filename.
               That way, if the user edits the security_object_filename and
               clears the contents, we know that they want a zero 
               security_smartobject_obj, otherwise we figure out in the SDO if 
               the filename matches the new object_filename, and apply the
               new object_obj to the security_smartobject_obj field.

------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cMode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScreenVal  AS CHARACTER  NO-UNDO.

  /* Get the container source and store the mode that we are in */
  {get ContainerSource hContainer}.
  {get ContainerMode cMode hContainer}.

  /* If we're in "ADD" mode we need to get the screen value of the
     object_filename field and set the value of the dynamic lookup.
     We then set DataModified in the lookup */ 
  IF cMode = "ADD":U THEN
  DO WITH FRAME {&FRAME-NAME}:
    cScreenVal = RowObject.object_filename:SCREEN-VALUE.
    {set DataValue cScreenVal h_dynlookup-3}.
    {set DataModified YES h_dynlookup-3}.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields vTableWin 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.

  RUN SUPER( INPUT pcColValues).

  RUN enableFields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override of enableFields. We use this procedure to make 
               sure that the Physical Object lookup is only enabled when the
               static_object field is set to no.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lEnable   AS LOGICAL      NO-UNDO.

  RUN SUPER.

  DO WITH FRAME {&FRAME-NAME}:
    lEnable = NOT RowObject.static_object:CHECKED.
    IF lEnable THEN
      RUN enableField IN h_dynlookup-2.
    ELSE
      RUN disableField IN h_dynlookup-2.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRCodeInfo vTableWin 
PROCEDURE getRCodeInfo :
/*------------------------------------------------------------------------------
  Purpose:     Determines if the procedure file actually exists on disk, points
               the RCODE-INFO handle at the file, and retrieves the list of 
               connected databases, and puts it in the required databases field.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileName       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cSearchFile     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMessageText    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDBList         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cReturn         AS CHARACTER    NO-UNDO.


  DO WITH FRAME {&FRAME-NAME}:
    /* Build up the relative filename from the prompts */
    cPath = INPUT RowObject.object_path.
    cFile = INPUT RowObject.object_filename.
    cFileName = cPath + (IF cPath <> "":U THEN "/":U ELSE "":U) + cFile.

    /* The following code makes sure that we have a .r file. We cannot apply
       the RCODE-INFO handle against a non-rcode file */

    /* If the second to last character is a period we can assume it's a file. */
    IF SUBSTRING(cFileName,LENGTH(cFileName) - 1,1) = "." THEN                        
    DO:
      /* Replace the extension with .r */
      cFileName = SUBSTRING(cFileName,1,LENGTH(cFileName) - 1) + "r".
      /* Get the full path name to the rcode file */
      cSearchFile = SEARCH(cFileName).
      /* If the path is valid point the r-code info handle at the file and get the DB-REFERENCES */
      IF cSearchFile <> "" AND                                                          
        cSearchFile <> ? THEN                                                           
      DO:
        RCODE-INFO:FILE-NAME = cSearchFile.                                             
        cDBList = RCODE-INFO:DB-REFERENCES.

        /* If we have a valid dblist, populate the required DBList field and 
           set DataModified so we go into update mode. */
        IF cDBList <> ? THEN                                                          
        DO:
          RowObject.required_db_list:SCREEN-VALUE = cDBList.                          
          {set DataModified YES}.                                                     
        END.                                                                          
      END.                                                                            
    END.                                                                              
  END.


  /* Lets tell the user what happened:
     If the Search File is ? we didn't find the file. */
  IF cSearchFile = ? OR
     cSearchFile = "" THEN
  DO:
    cMessageText = {af/sup2/aferrortxt.i "'AF'" "'19'" "'ryc_smartobject'" "'required_db_list'" "'R-CODE'" "cFileName + '. Required Database List not read. Note that if this is a logical object, this is expected behavior.'"}.
    RUN showMessages IN gshSessionManager (cMessageText,"INF":U,"OK":U,"OK":U,"OK":U,"R-Code file not found",NO,THIS-PROCEDURE,OUTPUT cReturn).
  END.
  /* If the DBList is unknown and we *did* find the file, then the R-Code file
     must be invalid */
  ELSE IF cDBList = ? THEN
  DO:
    cMessageText = {af/sup2/aferrortxt.i "'AF'" "'39'" "'ryc_smartobject'" "'required_db_list'" "'Database List'" "' File ' + cFileName + ' is not a valid R-Code file. The Required Database List could not be read.'"}.
    RUN showMessages IN gshSessionManager (cMessageText,"INF":U,"OK":U,"OK":U,"OK":U,"Invalid R-Code file",NO,THIS-PROCEDURE,OUTPUT cReturn).
  END.
  /* If we get this far down, we succeeded and read the r-code file for the DB list
     so tell the user that the DBList has been read because it may be that the list 
     of required databases is blank and the user would never know that we have read 
     the R-Code file. */
  ELSE
  DO:
    cMessageText = {af/sup2/aferrortxt.i "'AF'" "'108'" "'ryc_smartobject'" "'required_db_list'" "'read of the required DB list'" "'File: ' + cFileName "}.
    RUN showMessages IN gshSessionManager (cMessageText,"INF":U,"OK":U,"OK":U,"OK":U,"",NO,THIS-PROCEDURE,OUTPUT cReturn).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  /* The product module SmartDataField publishes changedProductModule from the 
     product module's value-changed trigger */
  SUBSCRIBE TO 'changedProductModule':U IN h_gscpmprdfv.

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
  RUN "af\obj2\gscotdcs2v.w *RTB-SmObj* ".
  RUN "ry\obj\gscpmprdfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

