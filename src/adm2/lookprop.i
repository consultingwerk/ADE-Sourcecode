&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
/*--------------------------------------------------------------------------
    File        : lookprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/lookprop.i}

    Description :

    Modified    : 08/11/2000
    Modified    : 10/25/2001         Mark Davies (MIP)
                  1. Remove references to KeyFieldValue and SavedScreenValue
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DisplayedField,KeyField,FieldLabel,FieldTooltip,KeyFormat,KeyDatatype,DisplayFormat,DisplayDatatype,~
BaseQueryString,QueryTables,BrowseFields,BrowseFieldDataTypes,BrowseFieldFormats,RowsToBatch,BrowseTitle,ViewerLinkedFields,LinkedFieldDataTypes,LinkedFieldFormats,ViewerLinkedWidgets,ColumnLabels,ColumnFormat,SDFFileName,SDFTemplate,LookupImage,ParentField,ParentFilterQuery,MaintenanceObject,MaintenanceSDO

  /* Custom instance definition file */

  {src/adm2/custom/lookupdefscustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/lookprto.i}
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpDisplayedField     /* Name of field to display from query (with table prefix) */
  &GLOBAL-DEFINE xpKeyField           /* Name of key field to assign value from (with table prefix) */
  &GLOBAL-DEFINE xpFieldLabel         /* Label for displayed field */
  &GLOBAL-DEFINE xpFieldTooltip       /* Tooltip for displayed field */
  &GLOBAL-DEFINE xpKeyFormat          /* Format of key field */
  &GLOBAL-DEFINE xpKeyDataType        /* Datatype of key field */
  &GLOBAL-DEFINE xpDisplayFormat      /* Format of displayed field */
  &GLOBAL-DEFINE xpDisplayDataType    /* Datatype of displayed field */

  &GLOBAL-DEFINE xpBaseQueryString    /* Base Browser query string (design time) */
  &GLOBAL-DEFINE xpQueryTables        /* Comma list of query tables (buffers) */
  &GLOBAL-DEFINE xpBrowseFields       /* Fields to display in browser, comma list of table.fieldname */
  &GLOBAL-DEFINE xpBrowseFieldDataTypes /* Data Types of Fields to display in browser, comma list */
  &GLOBAL-DEFINE xpBrowseFieldFormats /* Formats of Fields to display in browser, comma list */
  &GLOBAL-DEFINE xpRowsToBatch        /* Number of rows per appserver xfer, default = 200 */
  &GLOBAL-DEFINE xpBrowseTitle        /* Title for lookup browser */
  &GLOBAL-DEFINE xpViewerLinkedFields /* Linked Fields to update value of on viewer, comma list of table.fieldname */
  &GLOBAL-DEFINE xpLinkedFieldDataTypes /* Data Types of Linked Fields to display in viewer, comma list */
  &GLOBAL-DEFINE xpLinkedFieldFormats  /* Formats of Linked Fields to display in viewer, comma list */
  &GLOBAL-DEFINE xpViewerLinkedWidgets /* Linked Field corresponding widget names to update value of on viewer, comma list, ? if no widget */
  
  /* WIP properties */
  &GLOBAL-DEFINE xpLabelHandle
  &GLOBAL-DEFINE xpLookupHandle
  &GLOBAL-DEFINE xpLookupImage
  &GLOBAL-DEFINE xpButtonHandle
  &GLOBAL-DEFINE xpBrowseWindowProcedure
  &GLOBAL-DEFINE xpBrowseProcedure
  &GLOBAL-DEFINE xpBrowseContainer
  &GLOBAL-DEFINE xpBrowseObject
  &GLOBAL-DEFINE xpStarting
  &GLOBAL-DEFINE xpModify

  &GLOBAL-DEFINE xpCurrentQueryString /* Current Browser query string (filters, etc.) */
  &GLOBAL-DEFINE xpRowIdent           /* comma list of rowids for current record */
  
  /* Lookup Enhancements - MAD (MIP) */
  &GLOBAL-DEFINE xpColumnLabels        /* Browser Column Override Labels */
  &GLOBAL-DEFINE xpColumnFormat        /* Browser Column Override Froamt */
  &GLOBAL-DEFINE xpSDFFileName         /* SmartDataField File Name */
  &GLOBAL-DEFINE xpSDFTemplate         /* SmartDataField Template File Name */
  &GLOBAL-DEFINE xpLookupImage         /* The image file name to be used for the lookup button (binoculars) */
  &GLOBAL-DEFINE xpParentField         /* The field/widget name of the parent object that this lookup is dependant on */
  &GLOBAL-DEFINE xpParentFilterQuery   /* The filter query to be used to filter on parent information */
  &GLOBAL-DEFINE xpMaintenanceObject   /* The logical object name of the object to launch for lookup data maintenance */
  &GLOBAL-DEFINE xpMaintenanceSDO      /* The SDO name to be launched prior to launching the maintenance object */
  
  {src/adm2/fieldprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  /* Lookup property field definitions */
  ghADMProps:ADD-NEW-FIELD('DisplayedField':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyField':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldLabel':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldTooltip':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyFormat':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyDataType':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayFormat':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayDataType':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryTables':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseFields':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseFieldDataTypes':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseFieldFormats':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('RowsToBatch':U, 'INTEGER':U, 0, ?, 200).  /* Rows per AppServer xfer */
  ghADMProps:ADD-NEW-FIELD('BrowseTitle':U, 'CHARACTER':U, 0, ?, 'Lookup':U).
  ghADMProps:ADD-NEW-FIELD('ViewerLinkedFields':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ViewerLinkedWidgets':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LinkedFieldDataTypes':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LinkedFieldFormats':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BaseQueryString':U, 'CHARACTER':U, 0, ?, '':U).
  
  ghADMProps:ADD-NEW-FIELD('LabelHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LookupHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LookupImage':U, 'CHARACTER':U, 0, ?, 'adeicon/select.bmp':U).
  ghADMProps:ADD-NEW-FIELD('ButtonHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BrowseWindowProcedure':U, 'CHARACTER':U, 0, ?, 'ry/uib/rydyncontw.w':U).
  ghADMProps:ADD-NEW-FIELD('BrowseProcedure':U, 'CHARACTER':U, 0, ?, 'ry/obj/rydynbrowb.w':U).
  ghADMProps:ADD-NEW-FIELD('BrowseContainer':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BrowseObject':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('Starting':U, 'LOG':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('Modify':U, 'LOG':U, 0, ?, no).

  ghADMProps:ADD-NEW-FIELD('CurrentQueryString':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('RowIdent', 'CHARACTER', 0, ?, '':U).

  ghADMProps:ADD-NEW-FIELD('ColumnLabels':U,  'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ColumnFormat':U,  'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SDFFileName', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SDFTemplate', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LookupImage', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ParentField', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ParentFilterQuery', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MaintenanceObject', 'CHARACTER', 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MaintenanceSDO', 'CHARACTER', 0, ?, '':U).

&ENDIF

  {src/adm2/custom/lookpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


