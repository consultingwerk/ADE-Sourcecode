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
    File        : brsprop.i
    Purpose     : Basic Property definition include file for 
                  SmartDataBrowse Objects

    Syntax      : {src/adm2/brsprop.i}

    Description :

    Modified    : August 18, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/browserdefscustom.i}
  
/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/browsed.w
&ENDIF


&IF "{&xcInstanceProperties}":U NE "":U &THEN
  &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}ScrollRemote,~
NumDown,CalcWidth,MaxWidth,FetchOnReposToEnd  
/* SearchField is added as a property for non-DB browsers.
   ForeignFields is added for DB Browsers. */
&IF DEFINED(INTERNAL-TABLES) EQ 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}SearchField
&ELSEIF "{&INTERNAL-TABLES}":U NE "RowObject":U &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}ForeignFields
&ENDIF

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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */



  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/brsprto.i}
  &ENDIF
&ENDIF

  &GLOB xpSeparatorFGColor
  &GLOB xpBrowseHandle        
  &GLOB xpBrowseInitted   
  &GLOB xpCalcWidth
  &GLOB xpMaxWidth 
  &GLOB xpModifiedFields
  &GLOB xpNumDown
  &GLOB xpSearchField
  &GLOB xpSearchHandle
  &GLOB xpApplyActionOnExit
  &GLOB xpApplyExitOnAction
  &GLOB xpScrollRemote
  &GLOB xpQueryRowObject
  &GLOB xpVisibleRowids
  &GLOB xpVisibleRowReset
  &GLOB xpFolderWindowToLaunch
  &GLOB xpFetchOnReposToEnd
  &GLOB xpPopupActive
  &GLOB xpMovableHandle
  &GLOB xpSortableHandle
  &GLOB xpSavedColumnData
  &GLOB xpDefaultColumnData
  &GLOB xpSeparators
  &GLOB xpBrowseColumnBGColors
  &GLOB xpBrowseColumnFGColors
  &GLOB xpBrowseColumnLabelBGColors
  &GLOB xpBrowseColumnLabelFGColors
  &GLOB xpBrowseColumnLabelFonts
  &GLOB xpBrowseColumnLabels
  &GLOB xpBrowseColumnWidths
  &GLOB xpTooltip
   
  {src/adm2/dvisprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('SeparatorFGColor':U, 'INTEGER':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BrowseHandle':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('BrowseInitted':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('CalcWidth':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('MaxWidth':U, 'DECIMAL':U, 0, ?, 80).
  ghADMProps:ADD-NEW-FIELD('ModifiedFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('NumDown':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('SearchField':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SearchHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ActionEvent':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ApplyActionOnExit':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('ApplyExitOnAction':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('ScrollRemote':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('QueryRowObject':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('VisibleRowids':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('VisibleRowReset':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('FolderWindowToLaunch':U, 'CHAR':U, 0, ?, '':U). 
  ghADMProps:ADD-NEW-FIELD('FetchOnReposToEnd':U, 'LOGICAL':U, 0, ?,YES).
  ghADMProps:ADD-NEW-FIELD('PopupActive':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('ColumnsMovable':U, 'LOGICAL':U ,0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('ColumnsSortable':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('MovableHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('SortableHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('SavedColumnData':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('DefaultColumnData':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('Separators':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnBGColors':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnFGColors':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnLabelBGColors':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnLabelFGColors':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnLabelFonts':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnLabels':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnWidths':U,'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnFormats':U,'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('BrowseColumnFonts':U,'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('Tooltip':U,'CHARACTER':U).

&ENDIF

  {src/adm2/custom/brspropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


