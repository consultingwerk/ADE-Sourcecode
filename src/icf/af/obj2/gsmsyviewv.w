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
       {"af/obj2/gsmsyfullo.i"}.


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
  File: gsmsyviewv.w

  Description:  Session Type Property

  Purpose:      Session Type Property Static SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000035   UserRef:    posse
                Date:   17/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w

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

&scop object-name       gsmsyviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}
{af/sup2/afttcombo.i}

DEFINE VARIABLE ghForeignFieldLookup AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmsyfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.property_value 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define DISPLAYED-FIELDS RowObject.property_value 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS fiPropertyValueLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_gscspdynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmsedynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiPropertyValueLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Property Value:" 
      VIEW-AS TEXT 
     SIZE 14.8 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.property_value AT ROW 3.1 COL 26.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 68.6 BY 4
     fiPropertyValueLabel AT ROW 3.1 COL 9.8 COLON-ALIGNED NO-LABEL
     SPACE(68.60) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmsyfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmsyfullo.i}
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
         HEIGHT             = 6.1
         WIDTH              = 94.2.
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

/* SETTINGS FOR FILL-IN fiPropertyValueLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiPropertyValueLabel:HIDDEN IN FRAME frMain           = TRUE
       fiPropertyValueLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Property Value:".

/* SETTINGS FOR EDITOR RowObject.property_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.property_value:RETURN-INSERTED IN FRAME frMain  = TRUE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDisplayedField AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cField          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLookupField    AS HANDLE       NO-UNDO.

  RUN SUPER.

  /* When adding a new record, the foreign field value needs to be displayed in
     the appropriate lookup field.  */

    /* Get the data source of the viewer */
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
    /* Get the data source of the viewer's data source */
    hDataSource = DYNAMIC-FUNCTION('getDataSource':U IN hDataSource).

    /* Get the displayed field in the lookup that represents the foreign field.
       ghForeignFieldLookup is set in enableFields 
       Extract the field name from the DisplayedField and use it to get the 
       column string value in the data source */
    cDisplayedField = DYNAMIC-FUNCTION('getDisplayedField':U IN ghForeignFieldLookup).
    cField = ENTRY(NUM-ENTRIES(cDisplayedField, '.':U), cDisplayedField, '.':U).
    cValue = DYNAMIC-FUNCTION('columnStringValue':U IN hDataSource, INPUT cField).

    /* Set the screen value of the lookup to the appropriate foreign field value */
    hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN ghForeignFieldLookup).
    ASSIGN hLookupField:SCREEN-VALUE = cValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
             INPUT  'DisplayedFieldgsm_session_type.session_type_codeKeyFieldgsm_session_type.session_type_objFieldLabelSession TypeFieldTooltipEnter Session Type or Press F4 for Session Type LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(20)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_session_type NO-LOCK
                     BY gsm_session_type.session_type_codeQueryTablesgsm_session_typeBrowseFieldsgsm_session_type.session_type_code,gsm_session_type.session_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(20),X(35)RowsToBatch200BrowseTitleLookup Session TypesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListQueryBuilderOrderListQueryBuilderTableOptionListQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNamesession_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmsedynlookup ).
       RUN repositionObject IN h_gsmsedynlookup ( 1.00 , 26.60 ) NO-ERROR.
       RUN resizeObject IN h_gsmsedynlookup ( 1.00 , 68.60 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_session_property.session_property_nameKeyFieldgsc_session_property.session_property_objFieldLabelProperty NameFieldTooltipEnter Session Property or Press F4 for Session Property LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_session_property NO-LOCK
                     BY gsc_session_property.session_property_nameQueryTablesgsc_session_propertyBrowseFieldsgsc_session_property.session_property_name,gsc_session_property.session_property_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(70)|X(70)RowsToBatch200BrowseTitleLookup Session PropertiesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsc_session_property.session_property_name^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoFieldNamesession_property_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscspdynlookup ).
       RUN repositionObject IN h_gscspdynlookup ( 2.05 , 26.60 ) NO-ERROR.
       RUN resizeObject IN h_gscspdynlookup ( 1.00 , 68.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gsmsedynlookup ,
             RowObject.property_value:HANDLE IN FRAME frMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_gscspdynlookup ,
             h_gsmsedynlookup , 'AFTER':U ).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEnabledHandles AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cField          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cForeignField   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDisabledField  AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDisabledLookup AS HANDLE       NO-UNDO.
DEFINE VARIABLE hField          AS HANDLE       NO-UNDO.
DEFINE VARIABLE hLookupField    AS HANDLE       NO-UNDO.
DEFINE VARIABLE iNumLookup      AS INTEGER      NO-UNDO.

  RUN SUPER.

  /* When maintaining Session Type Properties from Session Property Maintenance
     we want to disable the session property lookup, when maintaining Session
     Type Properties from Session Type Maintenance we want to disable the
     session type lookup.  This is done so that the key value is assigned
     appropriately from its foreign field value.  */
  cEnabledHandles = DYNAMIC-FUNCTION('getEnabledHandles':U).
  hDataSource = DYNAMIC-FUNCTION('getDataSource':U).
  IF VALID-HANDLE(hDataSource) THEN DO:
    cForeignField = ENTRY(1, DYNAMIC-FUNCTION('getForeignFields':U IN hDataSource)).

    DO iNumLookup = 1 TO NUM-ENTRIES(cEnabledHandles):
      hField = WIDGET-HANDLE(ENTRY(iNumLookup, cEnabledHandles)).
      IF hField:TYPE = 'PROCEDURE':U THEN
      DO:
        cField = DYNAMIC-FUNCTION('getFieldName':U IN hField).
        /* If field is equal to the foreign field then we want to disable the
           lookup so that the value for the field comes from the foreign field. */
        IF cField = cForeignField THEN 
        DO:
          RUN disableField IN hField.
          hLookupField = DYNAMIC-FUNCTION('getLookupHandle':U IN hField).
          hLookupField:TAB-STOP = FALSE.
          hDisabledLookup = hField.
          hDisabledField = hLookupField.
          ASSIGN ghForeignFieldLookup = hField.
        END.  /* if cField = cForeignField */  
      END.  /* if field is procedure */
    END.  /* do iNumLookup */

    IF hDisabledLookup = h_gsmsedynlookup THEN 
      RUN applyEntry IN h_gscspdynlookup( '':U).
  END.  /* if hDataSource valid */

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

