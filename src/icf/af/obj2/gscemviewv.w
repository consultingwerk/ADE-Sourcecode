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
       {"af/obj2/gscemfullo.i"}.


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
  File: gscemviewv.w

  Description:  Entity Mnemonic SmartDataViewer

  Purpose:      Entity Mnemonic Static SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000020   UserRef:    posse
                Date:   03/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w
      Modified: 22/10/2001            Mark Davies
                Remove word Mnemonic.

  (v:010001)    Task:           0   UserRef:    
                Date:   10/24/2001  Author:  Mark Davies   

  Update Notes: Added check in UpdateMode to enable the browser when not in View mode.

-------------------------------------------------------------------------------*/
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

&scop object-name       gscemviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}

/* temp-table to maintain entity display fields */
{gscedtable.i}

/* PLIP definitions */
{af/sup2/afrun2.i &define-only = YES }

DEFINE VARIABLE ghBrowse                    AS HANDLE     NO-UNDO.  /* Handle to dynamic browser */
DEFINE VARIABLE ghQuery                     AS HANDLE     NO-UNDO.  /* Handle to query on temp table */
DEFINE VARIABLE ghTable                     AS HANDLE     NO-UNDO.  /* Handle to temp table */
DEFINE VARIABLE ghBuffer                    AS HANDLE     NO-UNDO.  /* Handle to temp table buffer */
DEFINE VARIABLE gcSavedTableName            AS CHARACTER  NO-UNDO.  /* saved tablename to see if changed */
DEFINE VARIABLE ghContainerSource           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghDataSource                AS HANDLE     NO-UNDO.
DEFINE VARIABLE glInitialized               AS LOGICAL INITIAL NO NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gscemfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.entity_narration ~
RowObject.entity_mnemonic RowObject.entity_mnemonic_short_desc ~
RowObject.entity_mnemonic_description RowObject.entity_dbname ~
RowObject.table_prefix_length RowObject.entity_mnemonic_label_prefix ~
RowObject.field_name_separator RowObject.table_has_object_field ~
RowObject.auto_properform_strings RowObject.entity_object_field ~
RowObject.auditing_enabled RowObject.deploy_data RowObject.entity_key_field ~
RowObject.version_data RowObject.entity_description_field ~
RowObject.entity_description_procedure RowObject.replicate_key ~
RowObject.scm_field_name 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS buDoNotRemove 
&Scoped-Define DISPLAYED-FIELDS RowObject.entity_narration ~
RowObject.entity_mnemonic RowObject.entity_mnemonic_short_desc ~
RowObject.entity_mnemonic_description RowObject.entity_dbname ~
RowObject.table_prefix_length RowObject.entity_mnemonic_label_prefix ~
RowObject.field_name_separator RowObject.table_has_object_field ~
RowObject.auto_properform_strings RowObject.entity_object_field ~
RowObject.auditing_enabled RowObject.deploy_data RowObject.entity_key_field ~
RowObject.version_data RowObject.entity_description_field ~
RowObject.entity_description_procedure RowObject.replicate_key ~
RowObject.scm_field_name 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buDoNotRemove 
     LABEL "DO NOT REMOVE" 
     SIZE 1.2 BY .29 TOOLTIP "This button will ensure that this is the minimum size for this viewer."
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     RowObject.entity_narration AT ROW 1 COL 102.2 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
          SIZE 41.6 BY 2.95
     RowObject.entity_mnemonic AT ROW 1.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.6 BY 1 TOOLTIP "A unique code for the entity - should match entity dump name"
     RowObject.entity_mnemonic_short_desc AT ROW 2.05 COL 27.4 COLON-ALIGNED
          LABEL "Description"
          VIEW-AS FILL-IN 
          SIZE 55 BY 1 TOOLTIP "A brief description of the entity to help explain its use"
     RowObject.entity_mnemonic_description AT ROW 3.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55 BY 1 TOOLTIP "The actual table name of the entity as defined in the metaschema"
     RowObject.entity_dbname AT ROW 4.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Teh database logical name that this table belongs to"
     RowObject.table_prefix_length AT ROW 4.05 COL 100.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1 TOOLTIP "Length of the table prefix appended to all table names as per the standards"
     RowObject.entity_mnemonic_label_prefix AT ROW 5.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Optional replacement for first word in labels for entity"
     RowObject.field_name_separator AT ROW 5.05 COL 100.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.6 BY 1 TOOLTIP "The basis of identifying what is used to break up field names into words"
     RowObject.table_has_object_field AT ROW 6.05 COL 29.4
          VIEW-AS TOGGLE-BOX
          SIZE 26.6 BY .81 TOOLTIP "Set to NO if this table does not have a unique object id field"
     RowObject.auto_properform_strings AT ROW 6.14 COL 102.4
          VIEW-AS TOGGLE-BOX
          SIZE 27.2 BY .81 TOOLTIP "Tidy up case of character fields automatically yes/no"
     RowObject.entity_object_field AT ROW 6.91 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Optional name of object id field for the entity, if blank assumes ICF standard"
     RowObject.auditing_enabled AT ROW 7.05 COL 102.4
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .81 TOOLTIP "Set to YES to enable auditing of records in this entity"
     RowObject.deploy_data AT ROW 7.86 COL 102.4
          VIEW-AS TOGGLE-BOX
          SIZE 16.8 BY .81 TOOLTIP "Set to YES if data in this table needs to be deployed"
     RowObject.entity_key_field AT ROW 7.95 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Fieldname for unique alternative key, other than object id field"
     RowObject.version_data AT ROW 8.67 COL 102.4
          VIEW-AS TOGGLE-BOX
          SIZE 17.2 BY .81 TOOLTIP "Set to YES if data in this table needs to be versioned"
     RowObject.entity_description_field AT ROW 8.95 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "Fieldname for field to use as description field for the entity"
     RowObject.entity_description_procedure AT ROW 9.95 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55 BY 1 TOOLTIP "Optional procedure to use to derive the description field"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 142.8 BY 18.29.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME frMain
     RowObject.replicate_key AT ROW 12.05 COL 27.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 55 BY 1 TOOLTIP "The join field to the primary replication table being versioned"
     RowObject.scm_field_name AT ROW 12.05 COL 100.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1 TOOLTIP "The unique field for the data that is also used as the object name for SCM"
     buDoNotRemove AT ROW 19 COL 142.2
     "Entity Narration:" VIEW-AS TEXT
          SIZE 14.8 BY .62 AT ROW 1.1 COL 85
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1
         SIZE 142.8 BY 18.29.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gscemfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gscemfullo.i}
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
         HEIGHT             = 18.29
         WIDTH              = 142.8.
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
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       buDoNotRemove:HIDDEN IN FRAME frMain           = TRUE.

/* SETTINGS FOR FILL-IN RowObject.entity_mnemonic_short_desc IN FRAME frMain
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME RowObject.entity_mnemonic_description
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RowObject.entity_mnemonic_description vTableWin
ON LEAVE OF RowObject.entity_mnemonic_description IN FRAME frMain /* Entity Tablename */
DO:
  
  IF SELF:SCREEN-VALUE <> gcSavedTableName THEN
    RUN buildBrowser (INPUT rowobject.entity_mnemonic:SCREEN-VALUE,
                      INPUT SELF:SCREEN-VALUE,
                      INPUT rowobject.entity_object_field:SCREEN-VALUE).
  ASSIGN gcSavedTableName = SELF:SCREEN-VALUE.
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
             INPUT  'DisplayedFieldgsc_entity_mnemonic.entity_mnemonicKeyFieldgsc_entity_mnemonic.entity_mnemonicFieldLabelReplicate EntityFieldTooltipThe entity code of the primary replication table for data versioning, e.g. RYCSOKeyFormatX(8)KeyDatatypecharacterDisplayFormatX(8)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_entity_mnemonic NO-LOCK
                     BY gsc_entity_mnemonic.entity_mnemonicQueryTablesgsc_entity_mnemonicBrowseFieldsgsc_entity_mnemonic.entity_mnemonic,gsc_entity_mnemonic.entity_mnemonic_short_desc,gsc_entity_mnemonic.entity_mnemonic_descriptionBrowseFieldDataTypescharacter,character,characterBrowseFieldFormatsX(8),X(35),X(35)RowsToBatch200BrowseTitleLookup Entity MnemonicsViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOFieldNamereplicate_entity_mnemonicDisplayFieldyesEnableFieldyesHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dynlookup ).
       RUN repositionObject IN h_dynlookup ( 11.00 , 29.40 ) NO-ERROR.
       RUN resizeObject IN h_dynlookup ( 1.00 , 55.60 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dynlookup ,
             RowObject.entity_description_procedure:HANDLE IN FRAME frMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowser vTableWin 
PROCEDURE buildBrowser :
/*------------------------------------------------------------------------------
  Purpose:     Constructs a dynamic data browser on to viewer
  Parameters:  input entity code
               input table name
               input object id field
  Notes:       Used to maintain entity display fields
               This trigger is run whenever the entity table name changes, to
               ensure the fields are correct for the table specified.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEntityCode       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcTableName        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcObjectField      AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hTH                       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cQuery                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hCurField                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBrowseColHdls            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFrame                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lPreviouslyHidden         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dHeight                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWidth                    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE cMode                     AS CHARACTER  NO-UNDO.

frame-block:
DO WITH FRAME {&FRAME-NAME}:

  EMPTY TEMP-TABLE ttDisplayField.

  IF pcTableName <> "":U AND pcEntityCode <> "":U THEN
    RUN af/app/gscedttabp.p ON gshAstraAppserver (INPUT pcEntityCode,
                                                  INPUT pcTableName,
                                                  INPUT pcObjectField,
                                                  OUTPUT TABLE ttDisplayField).

  IF NOT VALID-HANDLE(ghBrowse) THEN
  DO:
    ASSIGN
      ghTable = TEMP-TABLE ttDisplayField:HANDLE
      ghBuffer = ghTable:DEFAULT-BUFFER-HANDLE
      . 
    CREATE QUERY ghQuery.
    ghQuery:ADD-BUFFER(ghBuffer).
    ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ttDisplayfield.display_field_order":U.
    ghQuery:QUERY-PREPARE(cQuery).
    
    /* Get dimensions of containing window */
    {get ContainerSource hContainerSource}.
    {get ContainerHandle hWindow hContainerSource}.
    ASSIGN
      FRAME {&FRAME-NAME}:HEIGHT-PIXELS  = hWindow:HEIGHT-PIXELS - 70
      FRAME {&FRAME-NAME}:WIDTH-PIXELS   = hWindow:WIDTH-PIXELS  - 28.  
    
    /* Create the dynamic browser and size it relative to the containing window */
    
    CREATE BROWSE ghBrowse
     ASSIGN FRAME            = FRAME {&FRAME-NAME}:handle
            ROW              = 13.38
            COL              = 1.1
            WIDTH-CHARS      = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 1.5
            HEIGHT-PIXELS    = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 267
            SEPARATORS       = TRUE
            ROW-MARKERS      = FALSE
            EXPANDABLE       = TRUE
            COLUMN-RESIZABLE = TRUE
            ALLOW-COLUMN-SEARCHING = TRUE
            READ-ONLY        = FALSE
            QUERY            = ghQuery
      /* Set procedures to handle browser events */
      TRIGGERS:   
        ON START-SEARCH
           PERSISTENT RUN startSearch    IN THIS-PROCEDURE.
        ON ROW-LEAVE
           PERSISTENT RUN rowLeave       IN THIS-PROCEDURE.
        ON ANY-PRINTABLE, 
           MOUSE-SELECT-DBLCLICK ANYWHERE
           PERSISTENT RUN setScreenValue IN THIS-PROCEDURE.
      END TRIGGERS.
  
    /* Hide the dynamic browser while it is being constructed */
    ASSIGN
       ghBrowse:VISIBLE   = NO
       ghBrowse:SENSITIVE = NO.
  
    /* Add include flag field first */
    hCurField = ghBuffer:BUFFER-FIELD("cInclude":U).
    hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).
    hField:READ-ONLY = FALSE.
  
    IF VALID-HANDLE(hField) THEN
        cBrowseColHdls = cBrowseColHdls 
                       + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                       + STRING(hField).
    
    /* Add fields to browser using structure of dynamic temp table */
    DO iLoop = 1 TO ghBuffer:NUM-FIELDS:
        hCurField = ghBuffer:BUFFER-FIELD(iLoop).

        /* Ignore object fields and include field */
        IF hCurField:NAME EQ "entity_mnemonic":U OR 
           hCurField:NAME EQ "entity_display_field_obj":U OR 
           hCurField:NAME EQ "cInclude":U THEN NEXT.
  
        hField = ghBrowse:ADD-LIKE-COLUMN(hCurField).
  
        CASE hField:NAME:
          WHEN "display_field_order":U THEN
            hField:READ-ONLY = FALSE.
          WHEN "display_field_label":U THEN
            hField:READ-ONLY = FALSE.
          WHEN "display_field_column_label":U THEN
            hField:READ-ONLY = FALSE.
          WHEN "display_field_format":U THEN
            hField:READ-ONLY = FALSE.
          OTHERWISE
            hField:READ-ONLY = TRUE.
        END CASE.
  
        /* Build up the list of browse columns for use in rowDisplay */
        IF VALID-HANDLE(hField) THEN
            cBrowseColHdls = cBrowseColHdls 
                           + (IF cBrowseColHdls = "":U THEN "":U ELSE ",":U) 
                           + STRING(hField).
    END. /* DO iLoop = 1 TO ghBuffer:NUM-FIELDS */
  
    /* Lock first column of dynamic browser */
    ghBrowse:NUM-LOCKED-COLUMNS = 2.
  
  END. /* valid-handle ghbrowse */
  ELSE
  DO: /* clear modified status on browse columns */
    REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
        hField = ghBrowse:GET-BROWSE-COLUMN(iLoop).
        hField:MODIFIED = NO.
    END.
  END.
  
  /* Hide the dynamic browser while it is being constructed */
  ASSIGN
    ghBrowse:VISIBLE   = NO
    ghBrowse:SENSITIVE = NO.

  /* Open the query for the browser */
  ghQuery:QUERY-CLOSE().
  ghQuery:QUERY-OPEN().

  /* Show the browser */
  ASSIGN
     ghBrowse:VISIBLE   = YES
     ghBrowse:SENSITIVE = YES.

  {get containerSource hContainer}.
  {get containerMode cMode hContainer}.

  IF cMode = "view" THEN
    ghBrowse:READ-ONLY = TRUE.
  ELSE
    ghBrowse:READ-ONLY = FALSE.

END. /* DO WITH FRAME */

RETURN.
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
  
  /* send temp-table of entity display fields to data source (SDO) */
  DO WITH FRAME {&FRAME-NAME}:
    IF VALID-HANDLE(ghBrowse) AND ghBrowse:READ-ONLY = FALSE THEN
      APPLY "row-leave":U TO ghBrowse.
  END.
 
  IF NOT VALID-HANDLE(ghDataSource) THEN
    {get DataSource ghDataSource}.
  IF VALID-HANDLE(ghDataSource)
    THEN RUN sendRelatedData IN ghDataSource ( INPUT TABLE ttDisplayField) NO-ERROR.

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

  DEFINE VARIABLE cMode               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cNewRecord          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcFieldType).

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    
    IF VALID-HANDLE(ghBrowse) THEN APPLY "ENTRY":U TO RowObject.entity_mnemonic_short_desc.
    
    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
    cMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
    IF cMode = "view" AND VALID-HANDLE(ghBrowse) THEN
      ghBrowse:READ-ONLY = TRUE.
    ELSE IF cMode <> "view" AND VALID-HANDLE(ghBrowse) THEN
      ghBrowse:READ-ONLY = FALSE.
  END.  /* do with frame */

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

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcColValues).

  /* Code placed here will execute AFTER standard behavior.    */

  /* Initialise UI objects */
  IF glInitialized THEN /* avoid twice during initialize */
  DO WITH FRAME {&FRAME-NAME}:
      APPLY 'LEAVE':U TO rowobject.entity_mnemonic_description.
  END.

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
DEFINE VARIABLE cMode               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cNewRecord          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

  RUN SUPER.

  cNewRecord = DYNAMIC-FUNCTION('getNewRecord':U).

  DO WITH FRAME {&FRAME-NAME}:
    IF LOOKUP(cNewRecord, "Add,Copy":U) > 0 THEN
      RowObject.entity_mnemonic:SENSITIVE = YES.
    ELSE RowObject.entity_mnemonic:SENSITIVE = NO.  

    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U).
    cMode = DYNAMIC-FUNCTION('getContainerMode':U IN hContainerSource).
    IF cMode = 'Modify':U THEN 
    DO:
      IF DYNAMIC-FUNCTION('getDataValue':U IN h_dynlookup) = '':U THEN
        ASSIGN 
          RowObject.replicate_key:SENSITIVE = NO
          RowObject.scm_field_name:SENSITIVE = NO.
    END.  /* if mode is modify */
  
    IF VALID-HANDLE(ghBrowse) THEN APPLY "ENTRY":U TO RowObject.entity_mnemonic_short_desc.
  
    IF cMode = "view" AND VALID-HANDLE(ghBrowse) THEN
      ghBrowse:READ-ONLY = TRUE.
    ELSE IF cMode <> "view" AND VALID-HANDLE(ghBrowse) THEN
      ghBrowse:READ-ONLY = FALSE.
  
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  <none>
  Notes:       Sets subscriptions to some standard published events.
               Initialises some UI objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinkHandles              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hToolbarSource            AS HANDLE     NO-UNDO.

  /* Get handle of container, then get toolbar source of container to determine the containers toolbar.
     We then subscribe this procedure to toolbar events in the containers toolbar so
     that we can action an OK or CANCEL being pressed in the toolbar. */  

  /* Ignore if running in the AppBuilder */
  &IF DEFINED(UIB_IS_RUNNING) = 0 &THEN

    SUBSCRIBE TO 'lookupDisplayComplete':U IN THIS-PROCEDURE.

  &ENDIF  

  RUN SUPER.

  /* Initialise UI objects */
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN gcSavedTableName = "":U.
      APPLY 'LEAVE':U TO rowobject.entity_mnemonic_description.
      ASSIGN glInitialized = YES.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lookupDisplayComplete vTableWin 
PROCEDURE lookupDisplayComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcFieldNames     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFieldValues    AS CHARACTER  NO-UNDO.  
DEFINE INPUT PARAMETER pcKeyFieldValue  AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER phLookup         AS HANDLE     NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF pcKeyFieldValue = '':U THEN
      ASSIGN 
        RowObject.replicate_key:SENSITIVE = NO
        RowObject.scm_field_name:SENSITIVE = NO.
    ELSE 
      ASSIGN
          RowObject.replicate_key:SENSITIVE = YES
          RowObject.scm_field_name:SENSITIVE = YES.
  END.  /* do with frame */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject vTableWin 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:    Resize the viewer
  Parameters: pd_height AS DECIMAL - the desired height (in rows)
              pd_width  AS DECIMAL - the desired width (in columns)
    Notes:    Used internally. Calls to resizeObject are generated by the
              AppBuilder in adm-create-objects for objects which implement it.
              Having a resizeObject procedure is also the signal to the AppBuilder
              to allow the object to be resized at design time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.

  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.

  /* Get container and window handles */
  {get ContainerSource hContainerSource}.
  {get ContainerHandle hWindow hContainerSource}.

  /* Save hidden state of current frame, then hide it */
  FRAME {&FRAME-NAME}:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = FRAME {&FRAME-NAME}:HIDDEN.                                                           
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Resize frame relative to containing window size */
  FRAME {&FRAME-NAME}:HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS - 70.
  FRAME {&FRAME-NAME}:WIDTH-PIXELS  = hWindow:WIDTH-PIXELS  - 28.

  /* Resize dynamic browser (if exists) relative to current frame */
  IF VALID-HANDLE(ghBrowse) THEN
  DO:
    ghBrowse:WIDTH-CHARS   = FRAME {&FRAME-NAME}:WIDTH-CHARS   - 1.5.
    ghBrowse:HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS - 267.
  END.

  /* Restore original hidden state of current frame */
  APPLY "end-resize":U TO FRAME {&FRAME-NAME}.
  FRAME {&FRAME-NAME}:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowLeave vTableWin 
PROCEDURE rowLeave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE hCol                    AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hField                  AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE lFromDisplayField       AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE cButtonPressed          AS CHARACTER                NO-UNDO.

    IF ghBrowse:CURRENT-ROW-MODIFIED THEN
    DO:
        ASSIGN lFromDisplayField = YES.

        REPEAT iLoop = 1 TO ghBrowse:NUM-COLUMNS:
            ASSIGN hCol   = ghBrowse:GET-BROWSE-COLUMN(iLoop)
                   hField = hCol:BUFFER-FIELD
                   .
            IF lFromDisplayField                     AND
               hField:NAME         EQ "lFromGSCED":U AND
               hField:BUFFER-VALUE EQ NO             THEN
                ASSIGN lFromDisplayField = NO.

            IF hCol:MODIFIED THEN
            DO:
                /* If buff-field-hdl is unknown, this is a calculated field
                 * and cannot be updated */
                IF hField NE ? THEN
                    ASSIGN hField:BUFFER-VALUE = hCol:SCREEN-VALUE.
            END.    /* column modified. */
        END.    /* loop through columns */

        /* If there is not GSC-ENTITY-DISPLAY-FIELD record for this field, then any changes will not be 
         * comitted to the database.                                                                    */
        IF NOT lFromDisplayField THEN
        DO:        
            RUN showMessages IN gshSessionManager (INPUT  "This entity field record will not be updated in the database, since this data does not originate from an entity display field record in the database."
                                                        + "~nTo create default entity display field records, import the entity, making sure that the `Update Display Field List` toggle is checked.",
                                                   INPUT  "WAR",            /* error type */
                                                   INPUT  "&OK",            /* button list */
                                                   INPUT  "&OK",            /* default button */ 
                                                   INPUT  "&OK",            /* cancel button */
                                                   INPUT  "Update Warning", /* error window title */
                                                   INPUT  YES,              /* display if empty */ 
                                                   INPUT  ?,                /* container handle */
                                                   OUTPUT cButtonPressed       ).    /* button pressed */        
            RETURN NO-APPLY.
        END.    /* record not in display field table */
    END.    /* row modified */

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
  RUN "adm2\dynlookup.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setScreenValue vTableWin 
PROCEDURE setScreenValue :
/*------------------------------------------------------------------------------
  Purpose:     Sets screen values for columns in the browser for given UI events
               Also sets modified state
  Parameters:  <none>
  Notes:       For logical columns, the user may mouse-double-click to toggle YES and NO,
               or type 'Y' or 'N'.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCurrentField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCurrentColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType            AS CHARACTER NO-UNDO.

  /* If a record is available in browser */
  IF ghBuffer:AVAILABLE AND NOT ghBrowse:READ-ONLY THEN
  DO:

     /* Get handle and data type of current column and handle of corresponding buffer field in the temp table */
     ASSIGN
        hCurrentColumn      = ghBrowse:CURRENT-COLUMN
        cDataType           = hCurrentColumn:DATA-TYPE
        hCurrentField       = hCurrentColumn:BUFFER-FIELD.

     /* If the current column in the browser is of a logical data type */
     IF cDataType EQ "LOGICAL":U THEN
     DO:
         /* Toggle YES/NO screen value if mouse is double clicked */
         IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U THEN
         DO:
             IF hCurrentColumn:SCREEN-VALUE EQ 'YES' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'NO'.
             ELSE IF hCurrentColumn:SCREEN-VALUE EQ 'NO' THEN
                 ASSIGN
                    hCurrentColumn:SCREEN-VALUE = 'YES'.
         END. /* IF LAST-EVENT:FUNCTION EQ 'mouse-select-dblclick':U */
         ELSE
         /* Process 'Y' key press */
         IF LAST-EVENT:LABEL EQ 'Y' THEN
             hCurrentColumn:SCREEN-VALUE = 'YES'.
         ELSE
         /* Process 'N' key press */
         IF LAST-EVENT:LABEL EQ 'N' THEN
             hCurrentColumn:SCREEN-VALUE = 'NO'.

         /* Assign screen value to temp table buffer */
         hCurrentField:BUFFER-VALUE  = hCurrentColumn:SCREEN-VALUE.

         /* Return without processing the original browser event */
         RETURN NO-APPLY.

     END. /* IF cDataType EQ "LOGICAL":U */

  END. /* IF ghBuffer:AVAILABLE */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startSearch vTableWin 
PROCEDURE startSearch :
/*------------------------------------------------------------------------------
  Purpose:     Implement column sorting
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRow    AS ROWID      NO-UNDO.
  DEFINE VARIABLE cSortBy AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.

  ASSIGN
      hColumn = ghBrowse:CURRENT-COLUMN
      rRow    = ghBuffer:ROWID.

  IF VALID-HANDLE( hColumn ) THEN
  DO:
      ASSIGN
          cSortBy = (IF hColumn:TABLE <> ? THEN
                        hColumn:TABLE + '.':U + hColumn:NAME
                        ELSE hColumn:NAME)
          .
      ASSIGN cQuery = "FOR EACH ":U + ghBuffer:NAME + " NO-LOCK BY ":U + cSortBy.
      ghQuery:QUERY-PREPARE(cQuery).
      ghQuery:QUERY-OPEN().

      IF ghQuery:NUM-RESULTS > 0 THEN
        DO:
          ghQuery:REPOSITION-TO-ROWID(rRow) NO-ERROR.
          ghBrowse:CURRENT-COLUMN = hColumn.
/*           APPLY 'VALUE-CHANGED':U TO ghBrowse. */
        END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).
  
  IF VALID-HANDLE(ghBrowse) THEN DO:
    IF pcMode <> "View":U THEN
      ghBrowse:READ-ONLY = FALSE.
    ELSE
      ghBrowse:READ-ONLY = TRUE.
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

