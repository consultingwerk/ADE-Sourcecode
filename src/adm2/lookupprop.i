&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/
/*--------------------------------------------------------------------------
    File        : lookupprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/lookupprop.i}

    Description :

    Modified    : 09/07/2004
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DisplayedField,KeyField,FieldLabel,FieldTooltip,KeyFormat,KeyDatatype,DisplayFormat,DisplayDatatype,~
BaseQueryString,QueryTables,BrowseFields,BrowseFieldDataTypes,BrowseFieldFormats,RowsToBatch,BrowseTitle,~
ViewerLinkedFields,LinkedFieldDataTypes,LinkedFieldFormats,ViewerLinkedWidgets,ColumnLabels,ColumnFormat,~
SDFFileName,SDFTemplate,LookupImage,ParentField,ParentFilterQuery,MaintenanceObject,MaintenanceSDO,CustomSuperProc,~
PhysicalTableNames,TempTables,QueryBuilderJoinCode,QueryBuilderOptionList,QueryBuilderOrderList,QueryBuilderTableOptionList,~
QueryBuilderTuneOptions,QueryBuilderWhereClauses,PopupOnAmbiguous,PopupOnUniqueAmbiguous,PopupOnNotAvail,BlankOnNotAvail,MappedFields,UseCache,SuperProcedure


  /* Custom instance definition file */

  {src/adm2/custom/lookupdefscustom.i}

&ENDIF

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
         HEIGHT             = 4.43
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

  /* Include the file which defines prototypes for all of the super
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/lookupprto.i}
  &ENDIF
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpBrowseFields       /* Fields to display in browser, comma list of table.fieldname */
  &GLOBAL-DEFINE xpBrowseFieldDataTypes /* Data Types of Fields to display in browser, comma list */
  &GLOBAL-DEFINE xpBrowseFieldFormats /* Formats of Fields to display in browser, comma list */
  &GLOBAL-DEFINE xpRowsToBatch        /* Number of rows per appserver xfer, default = 200 */
  &GLOBAL-DEFINE xpBrowseTitle        /* Title for lookup browser */
  &GLOBAL-DEFINE xpViewerLinkedFields /* Linked Fields to update value of on viewer, comma list of table.fieldname */
  &GLOBAL-DEFINE xpLinkedFieldDataTypes /* Data Types of Linked Fields to display in viewer, comma list */
  &GLOBAL-DEFINE xpLinkedFieldFormats  /* Formats of Linked Fields to display in viewer, comma list */
  
  &GLOBAL-DEFINE xpLookupHandle
  &GLOBAL-DEFINE xpLookupImage
  &GLOBAL-DEFINE xpButtonHandle
  &GLOBAL-DEFINE xpBrowseWindowProcedure
  &GLOBAL-DEFINE xpBrowseProcedure
  &GLOBAL-DEFINE xpBrowseContainer
  &GLOBAL-DEFINE xpBrowseObject
  &GLOBAL-DEFINE xpStarting
  &GLOBAL-DEFINE xpRowIdent           /* comma list of rowids for current record */
  &GLOBAL-DEFINE xpColumnLabels                /* Browser Column Override Labels */
  &GLOBAL-DEFINE xpColumnFormat                /* Browser Column Override Froamt */
  &GLOBAL-DEFINE xpLookupImage                 /* The image file name to be used for the lookup button (binoculars) */
  &GLOBAL-DEFINE xpMaintenanceObject           /* The logical object name of the object to launch for lookup data maintenance */
  &GLOBAL-DEFINE xpMaintenanceSDO              /* The SDO name to be launched prior to launching the maintenance object */
  &GLOBAL-DEFINE xpMappedFields                /* Mapped Fields from SDO to viewer linked widgets. */
  /* Auto Browse Popup Properties */
  &GLOBAL-DEFINE xpPopupOnNotAvail             /* Popup Lookup Browse on leave of modified field when value does not uniquely identify a record - providing field value was modified. */
  &GLOBAL-DEFINE xpBlankOnNotAvail             /* Blank invalid values for lookups rather than leaving the invalid value in the field - providing field value was modified. */

  {src/adm2/lookupfieldprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* Lookup property field definitions */
  ghADMProps:ADD-NEW-FIELD('BlankOnNotAvail':U,            'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('BrowseFields':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseFieldDataTypes':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseFieldFormats':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BrowseWindowProcedure':U, 'CHARACTER':U, 0, ?, 'ry/uib/rydyncontw.w':U).
  ghADMProps:ADD-NEW-FIELD('BrowseProcedure':U, 'CHARACTER':U, 0, ?, 'ry/obj/rydynbrowb.w':U).
  ghADMProps:ADD-NEW-FIELD('BrowseContainer':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BrowseObject':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowsToBatch':U, 'INTEGER':U, 0, ?, 200).  /* Rows per AppServer xfer */
  ghADMProps:ADD-NEW-FIELD('BrowseTitle':U, 'CHARACTER':U, 0, ?, 'Lookup':U).
  ghADMProps:ADD-NEW-FIELD('ButtonHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ColumnLabels':U,                'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ColumnFormat':U,                'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LookupHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LookupImage':U, 'CHARACTER':U, 0, ?, 'adeicon/select.bmp':U).
  ghADMProps:ADD-NEW-FIELD('LookupImage':U,                 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LinkedFieldDataTypes':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LinkedFieldFormats':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MaintenanceObject':U,           'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MaintenanceSDO':U,              'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('MappedFields':U,                'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PopupOnAmbiguous':U,           'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('PopupOnUniqueAmbiguous':U,     'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('PopupOnNotAvail':U,            'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('RowIdent':U,                    'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('Starting':U, 'LOG':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ViewerLinkedFields':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ViewerLinkedWidgets':U, 'CHARACTER':U, 0, ?, '':U).
  
&ENDIF

  {src/adm2/custom/lookpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


