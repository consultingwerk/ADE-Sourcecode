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
       {"ry/obj/rycsofullo.i"}.


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
  File: rycsofiltv.w

  Description:  SmartObject TreeView Filter Viewer

  Purpose:      SmartObject TreeView Filter Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000001   UserRef:    
                Date:   08/30/2001  Author:     Mark Davies

  Update Notes: Created from Template rysttviewv.w
                SmartObject TreeView Filter Viewer

  Modified: Mark Davies (MIP)     09/25/2001
            Replace references to KeyFieldValue by DataValue

  (v:100001)    Task:           0   UserRef:    
                Date:   10/29/2001  Author:     Mark Davies (MIP)

  Update Notes: Replace Static Combo with two dynamic combo boxes for product and product module.

  (v:010002)    Task:           0   UserRef:    
                Date:   11/07/2001  Author:     Mark Davies (MIP)

  Update Notes: Added code to clear object name when changing object type.

  (v:010003)    Task:           0   UserRef:    
                Date:   02/05/2002  Author:     Mark Davies (MIP)

  Update Notes: Enable combo fields on initialization.

------------------------------------------------------------------------------*/
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

&scop object-name       rycsofiltv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rycsofullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDisplayRepository buApply 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE hProductModule AS HANDLE NO-UNDO.
DEFINE VARIABLE h_FileName AS HANDLE NO-UNDO.
DEFINE VARIABLE h_ObjectType AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buApply 
     LABEL "&Apply" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiDisplayRepository AS CHARACTER FORMAT "X(3)":U 
     VIEW-AS FILL-IN 
     SIZE 4.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjType AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.2 BY 1 TOOLTIP "Lave this field here. Used to assign the object type." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiDisplayRepository AT ROW 2.24 COL 71 COLON-ALIGNED NO-LABEL
     fiObjType AT ROW 2.14 COL 79 NO-LABEL
     buApply AT ROW 2.1 COL 129
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         DEFAULT-BUTTON buApply.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rycsofullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rycsofullo.i}
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
         HEIGHT             = 2.38
         WIDTH              = 143.
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

/* SETTINGS FOR FILL-IN fiDisplayRepository IN FRAME frMain
   NO-DISPLAY                                                           */
ASSIGN 
       fiDisplayRepository:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN fiObjType IN FRAME frMain
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fiObjType:HIDDEN IN FRAME frMain           = TRUE
       fiObjType:PRIVATE-DATA IN FRAME frMain     = 
                "NOLOOKUPS".

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

&Scoped-define SELF-NAME buApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buApply vTableWin
ON CHOOSE OF buApply IN FRAME frMain /* Apply */
DO:
  DEFINE VARIABLE cComboKeyValue  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProductModule  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLookupKeyValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cComboDispValue AS CHARACTER  NO-UNDO.
  
  ASSIGN fiObjType.

  {get DataValue cProductModule hProductModule}.
  {get DataValue cComboKeyValue h_ObjectType}.
  {get DataValue cLookupKeyValue h_FileName}.
  {get CurrentDescValue cComboDispValue h_ObjectType}.
  
  /* If an object name was specified, but no object type, or they
     were different, change to that object type */
  IF cLookupKeyValue <> "":U AND 
     DECIMAL(fiObjType) <> DECIMAL(cComboKeyValue) THEN DO:
    {set DataValue STRING(fiObjType,'>>>>>>>>>>>>>>9.999999999':U) h_ObjectType}. 
    {get DataValue cComboKeyValue h_ObjectType}.
  END.
   
  cFilterString = "":U.
   
  IF cProductModule NE "0":U THEN
    cFilterString = "gsc_object.product_module_obj,":U + cProductModule + ",=":U.

  IF cLookupKeyValue <> "":U THEN
    ASSIGN cFilterString = IF cFilterString <> "":U THEN cFilterString + CHR(1) ELSE cFilterString
           cFilterString = cFilterString + "object_filename," + cLookupKeyValue + ",BEGINS":U.

  IF DECIMAL(cComboKeyValue) <> 0 THEN
    ASSIGN cFilterString = IF cFilterString <> "":U THEN cFilterString + CHR(1) ELSE cFilterString
           cFilterString = cFilterString + "object_type_obj," + cComboKeyValue + ",=":U.
  
  SESSION:SET-WAIT-STATE("general":U).
  PUBLISH "filterDataAvailable" FROM THIS-PROCEDURE (INPUT cFilterString).
  SESSION:SET-WAIT-STATE("":U).

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
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct ModuleFieldTooltipSelect a Product Module from the listKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_product_module NO-LOCK INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldfiDisplayRepositoryParentFilterQueryIF ~'&1~'  EQ ~'NO~' THEN
                     NOT ( gsc_product_module.product_module_code BEGINS "RY":U  OR
                     gsc_product_module.product_module_code BEGINS "RV":U  OR
                     gsc_product_module.product_module_code BEGINS "ICF":U OR
                     gsc_product_module.product_module_code BEGINS "AF":U  OR
                     gsc_product_module.product_module_code BEGINS "GS":U  OR
                     gsc_product_module.product_module_code BEGINS "AS":U  OR
                     gsc_product_module.product_module_code BEGINS "RTB":U   )
                     ELSE TRUEDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines5ComboFlagAFlagValue0BuildSequence1SecurednoFieldNameproduct_module_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 1.05 , 92.20 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.00 , 51.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_code,gsc_object_type.object_type_descriptionKeyFieldgsc_object_type.object_type_objFieldLabelObject TypeFieldTooltipSelect an object typeKeyFormat>>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(256)DisplayDatatypeCHARACTERBaseQueryStringFOR EACH gsc_object_type NO-LOCK BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_typeSDFFileNameSDFTemplateParentFieldParentFilterQueryDescSubstitute&1 / &2CurrentKeyValueComboDelimiterListItemPairsCurrentDescValueInnerLines0ComboFlagAFlagValue0BuildSequence0SecurednoFieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ObjectType ).
       RUN repositionObject IN h_ObjectType ( 1.05 , 17.80 ) NO-ERROR.
       RUN resizeObject IN h_ObjectType ( 1.00 , 52.40 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelObject NameFieldTooltipPress F4 for a list of SmartObjectsKeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK,
                     FIRST gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_obj = gsc_object.object_type_obj  BY gsc_object.object_filename INDEXED-REPOSITIONQueryTablesgsc_object,gsc_object_typeBrowseFieldsgsc_object.object_filename,gsc_object.object_extension,gsc_object.object_path,gsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(35),X(35),X(70),X(15),X(35)RowsToBatch200BrowseTitleSmartObject LookupViewerLinkedFieldsgsc_object_type.object_type_objLinkedFieldDataTypesdecimalLinkedFieldFormats>>>>>>>>>>>>>>>>>9.999999999ViewerLinkedWidgetsfiObjTypeColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldobject_type_obj,object_type_objParentFilterQueryIF ~'&1~' <> ~'0~' THEN gsc_object.object_type_obj = DECIMAL(~'&1~') ELSE TRUEMaintenanceObjectMaintenanceSDOFieldNameobject_filenameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_FileName ).
       RUN repositionObject IN h_FileName ( 2.05 , 17.60 ) NO-ERROR.
       RUN resizeObject IN h_FileName ( 1.00 , 52.40 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( hProductModule ,
             fiObjType:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_ObjectType ,
             hProductModule , 'AFTER':U ).
       RUN adjustTabOrder ( h_FileName ,
             h_ObjectType , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE comboValueChanged vTableWin 
PROCEDURE comboValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcKeyFieldValue        AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcScreenValue            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phCombo                  AS HANDLE     NO-UNDO. 

  DYNAMIC-FUNCTION("setDataValue":U IN h_FileName,"":U).
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiObjType:SCREEN-VALUE = "0":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDisplayRepository          AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE rRowid                      AS ROWID                NO-UNDO.

    SUBSCRIBE TO "comboValueChanged":U IN THIS-PROCEDURE.

    RUN SUPER.

    RUN displayFields IN TARGET-PROCEDURE (?).
    RUN enableField IN h_FileName.  
    RUN enableField IN h_ObjectType.  
    RUN enableField IN hProductModule.  

    /* Determine whether the user wants to display repository data. */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cDisplayRepository).
    ASSIGN fiDisplayRepository:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cDisplayRepository.
    RUN RefreshChildDependancies IN hProductModule (INPUT "fiDisplayRepository":U).
    
    RETURN.
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
  RUN "ry\obj\gscpmprdfv.w *RTB-SmObj* ".
  RUN "adm2\dyncombo.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

