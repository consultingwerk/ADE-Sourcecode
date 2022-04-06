&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Include _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afttlkctrl.i

  Description:  Dynamic Lookup Contol Temp Table

  Purpose:      Dynamic Lookup Contol Temp Table
                Will only ever contain 1 record.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   17/11/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 dynamic lookups

  (v:010002)    Task:    90000166   UserRef:    
                Date:   25/07/2001  Author:     Mark Davies

  Update Notes: Added new temp-table fields to store label overrides.

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afttlkctrl.i
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE TEMP-TABLE ttLookCtrl  NO-UNDO
FIELD cDisplayedField         AS CHARACTER  /* Name of field to display from query (with table prefix) */
FIELD cKeyField               AS CHARACTER  /* Name of key field to assign value from (with table prefix) */
FIELD cFieldLabel             AS CHARACTER  /* Label for displayed field */
FIELD cKeyFormat              AS CHARACTER  /* Format of key field */
FIELD cKeyDataType            AS CHARACTER  /* Datatype of key field */
FIELD cDisplayFormat          AS CHARACTER  /* Format of displayed field */
FIELD cDisplayDataType        AS CHARACTER  /* Datatype of displayed field */
FIELD cBrowseFields           AS CHARACTER  /* Fields to display in browser, comma list of table.fieldname */
FIELD cBrowseFieldDataTypes   AS CHARACTER  /* Data Types of Fields to display in browser, comma list */
FIELD cBrowseFieldFormats     AS CHARACTER  /* Formats of Fields to display in browser, comma list */
FIELD iRowsToBatch            AS INTEGER    /* Number of rows per Appserver Xfer */
FIELD cViewerLinkedFields     AS CHARACTER  /* Linked Fields to update value of on viewer, comma list of table.fieldname */
FIELD cLinkedFieldDataTypes   AS CHARACTER  /* Data Types of Linked Fields to display in viewer, comma list */
FIELD cLinkedFieldFormats     AS CHARACTER  /* Formats of Linked Fields to display in viewer, comma list */
FIELD cBaseQueryString        AS CHARACTER  /* Base Browser query string (design time) */
FIELD cQueryTables            AS CHARACTER  /* Comma list of query tables (buffers) */
FIELD cPhysicalTableNames     AS CHARACTER  /* comma delimited list of actual DB Tables names of buffers defined that corresponds with cQueryTables */
FIELD cTempTableNames         AS CHARACTER  /* comma delimited list of PLIP names where data for define temp-tables could be retrieved, corresponds with cQueryTables */
FIELD cAllFields              AS CHARACTER  /* Comma list of all selected fields minus duplicates */
FIELD cAllFieldTypes          AS CHARACTER  /* Comma list of all selected fields minus duplicates data types */
FIELD cAllFieldFormats        AS CHARACTER  /* Comma list of all selected fields minus duplicates formats */
FIELD cDisplayValue           AS CHARACTER  /* current screen value of displayed field */
FIELD cKeyValue               AS CHARACTER  /* current value of key field */
FIELD cRowIdent               AS CHARACTER  /* comma list of rowids of current record for reposition */
FIELD iFirstRowNum            AS INTEGER    /* first row number retrieved (if any) */
FIELD iLastRowNum             AS INTEGER    /* last row number retrieved (if reached last) */
FIELD cFirstResultRow         AS CHARACTER  /* first row in result set, as rownum;rowid1,..rowidn */
FIELD cLastResultRow          AS CHARACTER  /* last row in result set, as rownum;rowid1,..rowidn */
FIELD cColumnLabels           AS CHARACTER  /* column label override */
FIELD cColumnFormat           AS CHARACTER  /* column Format override */
.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


