&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"src/adm2/support/dynbrwfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
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
/*------------------------------------------------------------------------

  File: dynbvewiv.w

  Description: from viewer.w - Template for SmartDataViewer objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Local Variable Definitions ---                                       */


DEFINE VARIABLE gcObjectPath    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcObjectName    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE gcProductModule AS CHARACTER    NO-UNDO.

DEFINE VARIABLE hContainer      AS HANDLE       NO-UNDO.

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{src/adm2/globals.i}

DEFINE VARIABLE gcSdoName AS CHARACTER NO-UNDO.

{src/adm2/ttcombo.i}

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
&Scoped-define DATA-FIELD-DEFS "adm2/support/dynbrwfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.custom_super_procedure 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-FIELDS RowObject.object_name ~
RowObject.object_description RowObject.custom_super_procedure 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject


/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectFilename vTableWin 
FUNCTION getObjectFilename RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dynlookup-2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gscpmcsdfv2 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_rymbdatfv2 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.48.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 3.81.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 9.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RowObject.object_name AT ROW 2.91 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.object_description AT ROW 4.1 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RowObject.custom_super_procedure AT ROW 7.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     RECT-1 AT ROW 1.24 COL 2
     RECT-2 AT ROW 7.19 COL 2
     RECT-3 AT ROW 11.48 COL 2
     "Browser Information" VIEW-AS TEXT
          SIZE 21 BY .62 AT ROW 1 COL 4
     "Browser Defaults" VIEW-AS TEXT
          SIZE 16 BY .62 AT ROW 6.95 COL 4
     "Field Selection" VIEW-AS TEXT
          SIZE 15 BY .62 AT ROW 11.24 COL 3
     SPACE(72.60) SKIP(8.48)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "adm2/support/dynbrwfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {src/adm2/support/dynbrwfullo.i}
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
         HEIGHT             = 20.29
         WIDTH              = 92.2.
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
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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
             INPUT  'ry/obj/gscpmcsdfv2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FieldNameproduct_module_codeDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscpmcsdfv2 ).
       RUN repositionObject IN h_gscpmcsdfv2 ( 1.71 , 12.00 ) NO-ERROR.
       RUN resizeObject IN h_gscpmcsdfv2 ( 1.10 , 62.20 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'DisplayedFieldryc_smartobject.object_filenameKeyFieldryc_smartobject.object_filenameFieldLabelSDO NameFieldTooltipSpecify SDO for data source of browser (no path)KeyFormatX(70)KeyDatatypecharacterDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object_type NO-LOCK
                     WHERE gsc_object_type.object_type_code = "SDO",
                     EACH ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj,
                     FIRST gsc_object NO-LOCK
                     WHERE gsc_object.OBJECT_obj = ryc_smartobject.OBJECT_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object_type,ryc_smartobject,gsc_object,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,ryc_smartobject.object_filename,gsc_object.object_description,gsc_object.object_pathBrowseFieldDataTypescharacter,character,character,characterBrowseFieldFormatsX(10),X(70),X(35),X(70)RowsToBatch200BrowseTitleLookup SDOViewerLinkedFieldsryc_smartobject.object_filename,gsc_object.object_pathLinkedFieldDataTypescharacter,characterLinkedFieldFormatsX(70),X(70)ViewerLinkedWidgets?,?ColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamesdo_nameDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 5.29 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'DisplayedFieldgsc_object.object_filenameKeyFieldgsc_object.object_filenameFieldLabelLaunch ContainerFieldTooltipContainer to launch browse actions (no path)KeyFormatX(35)KeyDatatypecharacterDisplayFormatX(35)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_object NO-LOCK
                     WHERE gsc_object.runnable_from_menu = YES,
                     FIRST ryc_smartobject NO-LOCK
                     WHERE ryc_smartobject.OBJECT_obj = gsc_object.OBJECT_obj
                     AND ryc_smartobject.OBJECT_type_obj = gsc_object.OBJECT_type_obj,
                     FIRST gsc_object_type NO-LOCK
                     WHERE gsc_object_type.OBJECT_type_obj = ryc_smartobject.OBJECT_type_obj,
                     FIRST gsc_product_module NO-LOCK
                     WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj
                     BY ryc_smartobject.OBJECT_filenameQueryTablesgsc_object,ryc_smartobject,gsc_object_type,gsc_product_moduleBrowseFieldsgsc_product_module.product_module_code,gsc_object.object_filename,gsc_object_type.object_type_code,gsc_object.object_description,ryc_smartobject.static_objectBrowseFieldDataTypescharacter,character,character,character,logicalBrowseFieldFormatsX(10),X(35),X(15),X(35),YES/NORowsToBatch200BrowseTitleLookup Launch ContainerViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamelaunch_containerDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup-2 ).
       RUN repositionObject IN h_dynlookup-2 ( 8.86 , 28.00 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup-2 ( 1.00 , 50.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'ry/obj/rymbdatfv2.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'FieldNameselected_fieldsDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_rymbdatfv2 ).
       RUN repositionObject IN h_rymbdatfv2 ( 12.24 , 3.40 ) NO-ERROR.
       RUN resizeObject IN h_rymbdatfv2 ( 8.10 , 87.20 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gscpmcsdfv2 ,
             RowObject.object_name:HANDLE IN FRAME F-Main , 'BEFORE':U ).
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.object_description:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjustTabOrder ( h_dynlookup-2 ,
             RowObject.custom_super_procedure:HANDLE IN FRAME F-Main , 'AFTER':U ).
       RUN adjustTabOrder ( h_rymbdatfv2 ,
             h_dynlookup-2 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE collectChanges vTableWin 
PROCEDURE collectChanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER pcChanges AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcInfo    AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE cobjectFullPath AS CHARACTER NO-UNDO.
 
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT-OUTPUT pcChanges, INPUT-OUTPUT pcInfo).

  /* Code placed here will execute AFTER standard behavior.    */

  IF LOOKUP("sdo_filename",pcChanges,CHR(1)) > 0 THEN
  DO:
    RUN adecomm/_osmush.p (INPUT gcObjectPath, INPUT gcObjectName,
                           OUTPUT cobjectFullPath).
    ASSIGN
      pcChanges = pcChanges + CHR(1) + "sdo_name" + CHR(1) + cobjectFullPath.
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
  HIDE FRAME F-Main.
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
  DEFINE VARIABLE hDatasource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSelected   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataset    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectPath AS CHARACTER  NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  {get DataSource hDatasource}.

  
  ASSIGN
    cSdoName    = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "sdo_name":U))
    cSelected   = TRIM(DYNAMIC-FUNCTION("columnStringValue":U IN hDataSource, "selected_fields":U)).
  IF VALID-HANDLE(gshGenManager) THEN DO:
    RUN getRecordDetail IN gshGenManager ( INPUT "FOR EACH gsc_object WHERE gsc_object.object_filename = '" + csdoname + "' NO-LOCK ":U,
                                           OUTPUT cDataset ).
    
    ASSIGN cObjectPath = "":U.
    IF cDataset = "":U OR cDataset = ? THEN 
      ASSIGN cObjectPath = "":U.
    ELSE
      ASSIGN cObjectPath = ENTRY(LOOKUP("gsc_object.object_path":U, cDataSet, CHR(3)) + 1 , cDataSet, CHR(3)) NO-ERROR.
    
    IF cObjectPath <> "":U THEN
    DO:
        /* Put sdo's object path and it's name together. */
        RUN adecomm/_osfmush.p (INPUT cObjectPath, INPUT cSdoName, OUTPUT cSdoName).
        ASSIGN
           cSdoName     = REPLACE(cSdoName, "~\", "/")
           gcObjectName = SUBSTRING(cSdoName,MAX(1,1 + R-INDEX(cSdoName,"/")))
           gcObjectPath = TRIM(REPLACE(cSdoName, gcObjectName, "")).
   
       DYNAMIC-FUNCTION('setDataValue' IN h_dynlookup, INPUT gcObjectName) NO-ERROR.
       DYNAMIC-FUNCTION('setDataValue' IN h_rymbdatfv2, INPUT cSelected ) NO-ERROR.
    END.
  END. /* Running Dynamics */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSdoName vTableWin 
PROCEDURE getSdoName :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcSdo   AS CHARACTER    NO-UNDO.

    ASSIGN
      pcSdo = gcObjectPath + gcObjectName.

    /* add extension if required */
    IF INDEX(gcObjectName,".":U) = 0 THEN
      ASSIGN pcSDO = pcSDO + ".w":U.

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
      
      SUBSCRIBE TO "lookupComplete":U       IN THIS-PROCEDURE.

      RUN SUPER.
      
     {get ContainerSource hContainer}.

      IF VALID-HANDLE(hContainer) THEN
        ASSIGN gcProductModule = DYNAMIC-FUNCTION("getProductModule" IN hContainer).

      DYNAMIC-FUNCTION('setDataValue':U IN h_gscpmcsdfv2, INPUT gcProductModule ).

      RUN enableFields.
      RUN enableField IN h_dynlookup.
      RUN enableField IN h_dynlookup-2.

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
  Purpose:     
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
            gcObjectPath = REPLACE(TRIM(ENTRY(LOOKUP("gsc_object.object_path", pcColumnNames), pcColumnValues, CHR(1))), "~\", "/")
            gcObjectPath = IF SUBSTRING(gcObjectPath, LENGTH(gcObjectPath), 1) = "/" THEN gcObjectPath ELSE gcObjectPath + "/"
            gcObjectName = TRIM(ENTRY(LOOKUP("ryc_smartobject.object_filename", pcColumnNames), pcColumnValues, CHR(1))) NO-ERROR.
              
        IF ERROR-STATUS:ERROR THEN
            ASSIGN
                gcObjectPath = "":U
                gcObjectName = "":U.
      
        DYNAMIC-FUNCTION('setDataValue' IN h_dynlookup, INPUT gcObjectName) NO-ERROR.
        DYNAMIC-FUNCTION('setDataValue' IN h_rymbdatfv2, INPUT pcKeyFieldValue ) NO-ERROR.
   
    END.

    RETURN.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectFilename vTableWin 
FUNCTION getObjectFilename RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object name to a caller.
    Notes:  * used for validation
------------------------------------------------------------------------------*/
    RETURN rowObject.object_name:INPUT-VALUE IN FRAME {&FRAME-NAME}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

