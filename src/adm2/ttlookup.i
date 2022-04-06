&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: ttlookup.i

  Description:  Lookup data build temp-table

  Purpose:      Lookup data build temp-table

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   13/11/2000  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010002)    Task:    90000166   UserRef:    
                Date:   24/07/2001  Author:     Mark Davies

  Update Notes: Add new field to lookup temp-table to indicate if more than one record could be found for lookup query.

  Modified    : 11/08/2001          Mark Davies (MIP)
                Moved out of ICF structure
  Modified    : 05/09/2002        Mark Davies (MIP)
                Added new field to ttLookup called hViewer to contain the
                handle a lookup is on. Issue #4525
  Modified    : 05/10/2002        Mark Davies (MIP)
                Added a field called lRefreshQuery to ttLookup temp-table to 
                indicate if a lookup query needs to be refreshed before attempting
                to display the values. Fixed issue #2793
------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ttlookup.i
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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
         HEIGHT             = 5.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttLookup NO-UNDO
FIELD hWidget                 AS HANDLE           /* Handle of lookup SDF */
FIELD hViewer                 AS HANDLE           /* Handle if the viewer that the lookup is on */
FIELD cWidgetName             AS CHARACTER        /* Name of external field */
FIELD cWidgetType             AS CHARACTER        /* Data Type of external field, e.g. DECIMAL, INTEGER, CHARACTER, DATE, etc. */
FIELD cForEach                AS CHARACTER        /* FOR EACH statement used to retrieve the data */
FIELD cBufferList             AS CHARACTER        /* comma delimited list of buffers used in FOR EACH */
FIELD cPhysicalTableNames     AS CHARACTER        /* comma delimited list of actual DB Tables names of buffers defined that corresponds with cBufferList */
FIELD cTempTableNames         AS CHARACTER        /* comma delimited list of PLIP names where data for define temp-tables could be retrieved, corresponds with cBufferList */
FIELD cFieldList              AS CHARACTER        /* comma delimited list of fields to return */
FIELD cDataTypeList           AS CHARACTER        /* comma delimited list of fields to return data types */
FIELD cFoundDataValues        AS CHARACTER        /* Found list of data values CHR(1) delimited (empty if not found) */
FIELD cRowIdent               AS CHARACTER        /* comma list of rowids for current record */
FIELD lMoreFound              AS LOGICAL          /* YES if more than one record could be found for the lookup query */
FIELD lRefreshQuery           AS LOGICAL          /* If No then the values to be displayed could be found in the DataSource */
FIELD cScreenValue            AS CHARACTER        /* The screen value of the lookup at time of leave the field. Used to check for ambiguous finds */
FIELD lPopupOnAmbiguous       AS LOGICAL          /* Popup Lookup Browse on leave of modified field when ambiguous - providing field value was modified., i.e. partially entered some data and no record could be uniquely identified. */
FIELD lPopupOnUniqueAmbiguous AS LOGICAL          /* Popup Lookup Browse on leave of modified field when unique find is ambiguous - providing field value was modified. i.e. entered John and John exists but other entries beginning with John, e.g. Johnson also exist. */
FIELD lUseCache               AS LOGICAL          /* When this is set to FALSE and the SDF Cache manager is running then we will not use the cached information */
INDEX keyIndex IS PRIMARY hWidget cWidgetName
INDEX keyCont  hViewer
INDEX keyDouble hViewer lRefreshQuery
INDEX key2 cWidgetName hWidget
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


