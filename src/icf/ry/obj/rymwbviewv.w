&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
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
       {"ry/obj/rymwbfullo.i"}.


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
  File: rymwbviewv.w

  Description:  Wizard Browser Viewer

  Purpose:      Wizard Browser Viewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6199   UserRef:    
                Date:   04/07/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttviewv.w

  (v:010002)    Task:        6629   UserRef:    
                Date:   11/09/2000  Author:     Jenny Bond

  Update Notes: Enhance Wizards

--------------------------------------------------------------------------------*/
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

&scop object-name       rymwbviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010108

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcObjectPath AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcObjectName AS CHARACTER    NO-UNDO.

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

DEFINE VARIABLE gcSdoName AS CHARACTER NO-UNDO.

{af/sup2/afttcombo.i}

DEFINE VARIABLE ghLookupField   AS HANDLE       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "ry/obj/rymwbfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.sdo_foreign_fields ~
RowObject.custom_super_procedure RowObject.window_title_field 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.sdo_foreign_fields ~
RowObject.custom_super_procedure RowObject.window_title_field ~
RowObject.generated_date RowObject.generated_time_str 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpmcsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscprcsdfv AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rymwbdatfv AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.object_name AT ROW 3 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify a unique name for the object (no path or extension)"
     RowObject.object_description AT ROW 4 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Specify description for object as it should appear on a menu"
     RowObject.sdo_foreign_fields AT ROW 6.1 COL 26 COLON-ALIGNED FORMAT "X(500)"
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Foreign field pairs for SDO - child (dbprefix),parent (no dbprefix), etc."
     RowObject.custom_super_procedure AT ROW 7.19 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Super procedure to attach to browse at runtime for specific code"
     RowObject.window_title_field AT ROW 8.19 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 46 BY 1 TOOLTIP "Fieldname from SDO to add to window title when browser on a window"
     RowObject.generated_date AT ROW 10.29 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     RowObject.generated_time_str AT ROW 11.43 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19 BY 1
     SPACE(42.80) SKIP(8.38)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "ry/obj/rymwbfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {ry/obj/rymwbfullo.i}
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
         HEIGHT             = 20.05
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN RowObject.generated_date IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_date:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.generated_time_str IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       RowObject.generated_time_str:READ-ONLY IN FRAME frMain        = TRUE.

/* SETTINGS FOR FILL-IN RowObject.sdo_foreign_fields IN FRAME frMain
   EXP-FORMAT                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME




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
             INPUT  'ry/obj/gscprcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscprcsdfv ).
       RUN repositionObject IN h_gscprcsdfv ( 1.00 , 19.40 ) NO-ERROR.
       RUN resizeObject IN h_gscprcsdfv ( 1.10 , 54.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/gscpmcsdfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameproduct_module_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmcsdfv ).
       RUN repositionObject IN h_gscpmcsdfv ( 1.95 , 11.80 ) NO-ERROR.
       RUN resizeObject IN h_gscpmcsdfv ( 1.10 , 62.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSDO NameFieldTooltipSpecify SDO for data source of browser (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(10),X(70),X(35),X(70)RowsToBatch200BrowseTitleLookup SDOViewerLinkedFieldsryc_smartobject.object_filename,gsc_object.object_pathLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(70),X(70)ViewerLinkedWidgets?,?FieldNamesdo_filenameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 5.00 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelLaunch ContainerFieldTooltipContainer to launch for browse actions (no path)KeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE gsc_object.runnable_from_menu = YES,
                     FIRST ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_obj = gsc_object.OBJECT_obj
                     AND ryc_smartobject.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object,ryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object.object_filename,gsc_object_type.object_type_code,gsc_object.object_description,ryc_smartobject.static_objectBrowseFieldDataTypescharacter,character,character,character,logicalBrowseFieldFormatsX(10),X(35),X(15),X(35),YES/NORowsToBatch200BrowseTitleLookup Launch ContainerViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsFieldNamelaunch_containerDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 9.24 , 27.80 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 46.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rymwbdatfv.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'FieldNameselected_fieldsDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rymwbdatfv ).
       RUN repositionObject IN h_rymwbdatfv ( 12.71 , 2.60 ) NO-ERROR.
       RUN resizeObject IN h_rymwbdatfv ( 8.10 , 87.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscprcsdfv ,
             RowObject.object_name:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscpmcsdfv ,
             h_gscprcsdfv , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.object_description:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             RowObject.window_title_field:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_rymwbdatfv ,
             RowObject.generated_time_str:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges vTableWin 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).

  /* Code placed here will execute AFTER standard behavior.    */

  IF LOOKUP("sdo_filename",pcChanges,CHR(1)) > 0 THEN
  DO:
    ASSIGN
      pcChanges = pcChanges + CHR(1) + "sdo_name" + CHR(1) + gcObjectPath + gcObjectName.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */

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

  DEFINE VARIABLE cSdoName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDatasource AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cSelected   AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  {get DataSource hDatasource}.

  ASSIGN
    cSdoName    = DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "sdo_name":U)
    cSelected   = DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "selected_fields":U)
    cSdoName    = REPLACE(cSdoName, "\", "/")
    gcObjectName = SUBSTRING(cSdoName,MAX(1,1 + R-INDEX(cSdoName,"/")))
    gcObjectPath = TRIM(REPLACE(cSdoName, gcObjectName, "")).

  DYNAMIC-FUNCTION('setDataValue' IN h_dynlookup, INPUT gcObjectName) NO-ERROR.
  DYNAMIC-FUNCTION('setDataValue' IN h_rymwbdatfv, INPUT cSelected ) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSdoName vTableWin 
PROCEDURE getSdoName :
/*------------------------------------------------------------------------------
  Purpose:     Pass SDO name to SmartDataField
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER pcSdo   AS CHARACTER    NO-UNDO.

    ASSIGN
      pcSdo = gcObjectPath + gcObjectName.

/*
    ASSIGN
        pcSdo = DYNAMIC-FUNCTION ("getKeyFieldValue":U IN h_dynlookup)
        pcSdo = REPLACE(pcSdo, "\":U, "/":U)
        pcSdo = IF NUM-ENTRIES(pcSdo, "/":U) > 0 THEN ENTRY(NUM-ENTRIES(pcSdo, "/":U), pcSdo, "/":U)
                ELSE "":U.

    EMPTY TEMP-TABLE ttComboData.

    CREATE ttComboData.

    ASSIGN
        ttComboData.cWidgetName = pcSdo
        ttComboData.cWidgetType = "character":U
        ttComboData.hWidget = ?
        ttComboData.cForEach = "FOR EACH gsc_object NO-LOCK WHERE gsc_object.object_filename = '":U + pcSdo + "'":U
        ttComboData.cBufferList = "gsc_object":U
        ttComboData.cKeyFieldName = "gsc_object.object_filename":U
        ttComboData.cDescFieldNames = "gsc_object.object_path,gsc_object.object_filename":U
        ttComboData.cDescSubstitute = "&1/&2":U
        ttComboData.cFlag = "":U
        ttComboData.cCurrentKeyValue = "":U
        ttComboData.cListItemDelimiter = ",":U
        ttComboData.cListItemPairs = "":U
        ttComboData.cCurrentDescValue = "":U.

    RUN af/app/afcobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

    FIND FIRST ttComboData NO-ERROR.

    ttComboData.cListItemPairs = REPLACE(
        REPLACE(ttComboData.cListItemPairs, "\":U, "/":U), "//":u, "/":U).
    pcSdo = IF NUM-ENTRIES(ttComboData.cListItemPairs) > 0 THEN ENTRY(1,ttComboData.cListItemPairs)
            ELSE "":U.
/*
    DYNAMIC-FUNCTION("setDataValue":U IN h_dynlookup, INPUT pcSdo).
*/
    /* RowObject.sdo_name:SCREEN-VALUE IN FRAME {&FRAME-NAME}. */
*/
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

    /* Code placed here will execute PRIOR to standard behavior. */
    SUBSCRIBE TO "lookupComplete":U       IN THIS-PROCEDURE.

    RUN SUPER.

    /* Code placed here will execute AFTER standard behavior.    */

    SUBSCRIBE "sdoSelected":U             IN h_dynlookup.
    SUBSCRIBE "launchContainerSelected":U IN h_dynlookup-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchContainerSelected vTableWin 
PROCEDURE launchContainerSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcNewValue  AS CHARACTER    NO-UNDO.

    ASSIGN
        ghLookupField = h_dynlookup-2.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupComplete vTableWin 
PROCEDURE lookupComplete :
/*------------------------------------------------------------------------------
  Purpose:     After leave of the SDO Name field. populate field selection list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcColumnNames           AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcColumnValues          AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcKeyFieldValue         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcDisplayedFieldValue   AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pcOldFieldValue         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER plLookup                AS LOGICAL      NO-UNDO.
    DEFINE INPUT  PARAMETER phObject                AS HANDLE       NO-UNDO.

    IF  phObject = h_dynlookup THEN DO:
        ASSIGN
            gcObjectPath = REPLACE(TRIM(ENTRY(LOOKUP("gsc_object.object_path", pcColumnNames), pcColumnValues, CHR(1))), "\", "/")
            gcObjectPath = IF SUBSTRING(gcObjectPath, LENGTH(gcObjectPath), 1) = "/" THEN gcObjectPath ELSE gcObjectPath + "/"
            gcObjectName = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_filename", pcColumnNames), pcColumnValues, CHR(1))) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
            ASSIGN
                gcObjectPath = "":U
                gcObjectName = "":U.

        DYNAMIC-FUNCTION('setDataValue' IN h_dynlookup, INPUT gcObjectName) NO-ERROR.
        DYNAMIC-FUNCTION('setDataValue' IN h_rymwbdatfv, INPUT pcKeyFieldValue ) NO-ERROR.
    END.

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
  RUN "ry\obj\gscpmcsdfv.w *RTB-SmObj* ".
  RUN "adm2\dynlookup.w *RTB-SmObj* ".
  RUN "ry\obj\gscprcsdfv.w *RTB-SmObj* ".
  RUN "ry\obj\rymwbdatfv.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sdoSelected vTableWin 
PROCEDURE sdoSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcNewValue  AS CHARACTER    NO-UNDO.

    ASSIGN
        ghLookupField = h_dynlookup.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

