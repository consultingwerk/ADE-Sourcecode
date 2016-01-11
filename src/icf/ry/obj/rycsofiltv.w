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

  (v:010004)    Task:           0   UserRef:    
                Date:   04/11/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed parent filter query for Object Name

-----------------------------------------------------------------------------*/
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

DEFINE VARIABLE glNoClear AS LOGICAL    NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS buApply fiDisplayRepository 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectNodekey vTableWin 
FUNCTION getObjectNodekey RETURNS CHARACTER
  ( pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
     SIZE 1.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjType AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>9.999999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 1.6 BY 1 TOOLTIP "Lave this field here. Used to assign the object type." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     buApply AT ROW 2.1 COL 129
     fiDisplayRepository AT ROW 1 COL 68.6 COLON-ALIGNED NO-LABEL
     fiObjType AT ROW 1 COL 72.2 NO-LABEL
     SPACE(68.40) SKIP(1.05)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE 
         DEFAULT-BUTTON buApply.


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
         HEIGHT             = 2.24
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
  DEFINE VARIABLE hLookup         AS HANDLE     NO-UNDO.
  
  RUN leaveLookup IN h_FileName.
  RUN leaveLookup IN h_ObjectType.
  ASSIGN fiObjType.
  
  
  {get LookupHandle hLookup h_ObjectType}.
  
  {get DataValue cProductModule hProductModule}.
  {get DataValue cComboKeyValue h_ObjectType}.
  {get DataValue cLookupKeyValue h_FileName}.
  
  /* If an object name was specified, but no object type, or they
     were different, change to that object type */
  IF cLookupKeyValue <> "":U AND 
     DECIMAL(fiObjType) <> DECIMAL(cComboKeyValue) THEN DO:
    {set DataValue STRING(fiObjType,'->>>>>>>>>>>>>>>>>9.999999999':U) h_ObjectType}. 
    {get DataValue cComboKeyValue h_ObjectType}.
  END.
   
  cFilterString = "":U.
   
  IF DECIMAL(cProductModule) <> 0 THEN
    cFilterString = "ryc_smartobject.product_module_obj,":U + cProductModule + ",=":U.

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
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object_type.object_type_codeKeyFieldgsc_object_type.object_type_objFieldLabelObject TypeFieldTooltipPress F4 For LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(30)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK, FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = gsc_object_type.class_smartobject_obj OUTER-JOIN BY gsc_object_type.object_type_code INDEXED-REPOSITIONQueryTablesgsc_object_type,ryc_smartobjectBrowseFieldsgsc_object_type.object_type_code,gsc_object_type.object_type_description,ryc_smartobject.object_filename,ryc_smartobject.object_descriptionBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(15)|X(35)|X(70)|X(35)RowsToBatch200BrowseTitleLookup Object TypeViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatX(30)SDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNameobject_type_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_ObjectType ).
       RUN repositionObject IN h_ObjectType ( 1.00 , 16.20 ) NO-ERROR.
       RUN resizeObject IN h_ObjectType ( 1.00 , 55.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelObject NameFieldTooltipPress F4 to Lookup an Object NameKeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH ryc_smartobject NO-LOCK WHERE ryc_smartobject.customization_result_obj = 0, FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj AND [EXCLUDE_REPOSITORY_PRODUCT_MODULES], FIRST gsc_object_type NO-LOCK WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj  BY ryc_smartobject.object_filename INDEXED-REPOSITIONQueryTablesryc_smartobject,gsc_product_module,gsc_object_typeBrowseFieldsryc_smartobject.object_filename,ryc_smartobject.object_extension,ryc_smartobject.object_path,gsc_object_type.object_type_code,gsc_object_type.object_type_descriptionBrowseFieldDataTypescharacter,character,character,character,characterBrowseFieldFormatsX(70)|X(35)|X(70)|X(15)|X(35)RowsToBatch200BrowseTitleLookup SmartObjectViewerLinkedFieldsgsc_object_type.object_type_objLinkedFieldDataTypesdecimalLinkedFieldFormats->>>>>>>>>>>>>>>>>9.999999999ViewerLinkedWidgetsfiObjTypeColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldobject_type_obj,object_type_objParentFilterQueryIF DECIMAL(~'&1~') <> 0 THEN ryc_smartobject.object_type_obj = DECIMAL(~'&1~') ELSE TRUEMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNameobject_filenameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_FileName ).
       RUN repositionObject IN h_FileName ( 2.05 , 16.20 ) NO-ERROR.
       RUN resizeObject IN h_FileName ( 1.00 , 54.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dyncombo.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_product_module.product_module_code,gsc_product_module.product_module_descriptionKeyFieldgsc_product_module.product_module_objFieldLabelProduct ModuleFieldTooltipSelect option from listKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(10)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_product_module
                     WHERE [EXCLUDE_REPOSITORY_PRODUCT_MODULES] NO-LOCK BY gsc_product_module.product_module_code INDEXED-REPOSITIONQueryTablesgsc_product_moduleSDFFileNameSDFTemplateParentFieldfiDisplayRepositoryParentFilterQueryIF ~'&1~'  EQ ~'NO~' THEN
                     NOT ( gsc_product_module.product_module_code BEGINS "RY":U  OR
                     gsc_product_module.product_module_code BEGINS "RV":U  OR
                     gsc_product_module.product_module_code BEGINS "ICF":U OR
                     gsc_product_module.product_module_code BEGINS "AF":U  OR
                     gsc_product_module.product_module_code BEGINS "GS":U  OR
                     gsc_product_module.product_module_code BEGINS "AS":U  OR
                     gsc_product_module.product_module_code BEGINS "RTB":U   )
                     ELSE TRUEDescSubstitute&1 / &2ComboDelimiterListItemPairsInnerLines5ComboFlagAFlagValue0BuildSequence1SecurednoCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesFieldNameproduct_module_objDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT hProductModule ).
       RUN repositionObject IN hProductModule ( 1.00 , 92.20 ) NO-ERROR.
       RUN resizeObject IN hProductModule ( 1.05 , 50.00 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_ObjectType ,
             buApply:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_FileName ,
             h_ObjectType , 'AFTER':U ).
       RUN adjustTabOrder ( hProductModule ,
             h_FileName , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cDisplayRepository AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE rRowid             AS ROWID      NO-UNDO.
    DEFINE VARIABLE hContainerSource   AS HANDLE     NO-UNDO.

    {get ContainerSource hContainerSource}.

    SUBSCRIBE TO "LookupDisplayComplete":U IN THIS-PROCEDURE.
    SUBSCRIBE TO "lookupComplete":U IN THIS-PROCEDURE.

    SUBSCRIBE TO "refreshFilter":U IN hContainerSource.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFieldList        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldValues      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKeyFieldValue    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcScreenValue      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSavedScreenValue AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plFromBrowser      AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER phLookupHandle     AS HANDLE     NO-UNDO.

IF phLookupHandle = h_ObjectType AND 
   pcScreenValue <> pcSavedScreenValue THEN DO:
  IF glNoClear = FALSE THEN
    RUN assignNewValue IN h_FileName (INPUT "":U, INPUT "":U, INPUT FALSE).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupDisplayComplete vTableWin 
PROCEDURE LookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcKeyFieldValue AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLookupFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLookupValues  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phLookupHandle  AS HANDLE     NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF phLookupHandle = h_FileName THEN DO:
        glNoClear = TRUE.
        RUN assignNewValue IN h_ObjectType (INPUT fiObjType:SCREEN-VALUE, INPUT "":U, INPUT FALSE).
        glNoClear = FALSE.
    END.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshFilter vTableWin 
PROCEDURE refreshFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectNodeKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iTime          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLookup        AS HANDLE     NO-UNDO.

  IF pcObjectName = "":U THEN
    RETURN.
  RUN assignNewValue IN h_ObjectType (INPUT "0":U,"":U,FALSE).
  RUN assignNewValue IN h_FileName (pcObjectName,"":U,FALSE).
  
  APPLY "CHOOSE":U TO buApply IN FRAME {&FRAME-NAME}.
  
  /* Give it some time to finish */
  DO iTime = 1 TO 1000:
    PROCESS EVENTS.
  END.

  {get ContainerSource hContainer}.
  IF NOT VALID-HANDLE(hContainer) THEN
    RETURN.

  hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN hContainer).

  IF NOT VALID-HANDLE(hTreeViewOCX) THEN
    RETURN.

  /* First Expand the Object Type */
  {get LookupHandle hLookup h_ObjectType}.
  cObjectType = hLookup:SCREEN-VALUE.
  cObjectNodeKey = getObjectNodekey(cObjectType).

  IF cObjectNodeKey = "":U THEN
    RETURN.
  RUN tvNodeEvent IN hContainer (INPUT "EXPAND":U, INPUT cObjectNodeKey).

  /* First Expand the 'Objects' Node */
  cObjectNodeKey = getObjectNodekey("Objects").
  IF cObjectNodeKey = "":U THEN
    RETURN.
  RUN tvNodeEvent IN hContainer (INPUT "EXPAND":U, INPUT cObjectNodeKey).

  /* Now find the object */
  cObjectNodeKey = getObjectNodekey(pcObjectName).
  IF cObjectNodeKey = "":U THEN
    RETURN.
  
  /* Select the object node */
  RUN tvNodeSelected IN hContainer (INPUT cObjectNodeKey).
  DYNAMIC-FUNCTION("selectNode" IN hTreeViewOCX, cObjectNodeKey).
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectNodekey vTableWin 
FUNCTION getObjectNodekey RETURNS CHARACTER
  ( pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTreeViewOCX   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable         AS HANDLE     NO-UNDO.
  
  {get ContainerSource hContainer}.
  
  IF VALID-HANDLE(hContainer) THEN DO:
    hTreeViewOCX = DYNAMIC-FUNCTION("getTreeViewOCX":U IN hContainer).

    IF VALID-HANDLE(hTreeViewOCX) THEN
      {get TreeDataTable hTable hTreeViewOCX}.  
    IF NOT VALID-HANDLE(hTable) THEN
      RETURN "":U.
    
    ASSIGN hBuf = hTable:DEFAULT-BUFFER-HANDLE.
    hBuf:FIND-FIRST("WHERE node_label = '" + pcObjectName + "'":U) NO-ERROR.
    IF hBuf:AVAILABLE THEN
      RETURN hBuf:BUFFER-FIELD("node_key":U):BUFFER-VALUE.
  END.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

