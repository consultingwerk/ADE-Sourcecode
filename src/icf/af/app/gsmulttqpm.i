&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
  File: gsmulttqpm.i

  Description:  Temp table for user allocation query parameters

  Purpose:      Definition for temp-table used to store query parameters which
                are to be used to construct several types of query depending
                upon a given security type.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000011   UserRef:    POSSE
                Date:   15/03/2001  Author:     Phillip Magnay

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

DEFINE TEMP-TABLE ttQueryParams      NO-UNDO
    FIELD cKeyField                  AS CHARACTER  /* Name of key field to assign value from (with table prefix) */
    FIELD cKeyFieldLabel             AS CHARACTER  /* Label for displayed field */
    FIELD cKeyFormat                 AS CHARACTER  /* Format of key field */
    FIELD cKeyDataType               AS CHARACTER  /* Datatype of key field */
    FIELD cKeyValue                  AS CHARACTER  /* Current value of key field */
    FIELD cBrowseFields              AS CHARACTER  /* Fields to display in browser, comma-delimited list of table.fieldname */
    FIELD cBrowseFieldLabels         AS CHARACTER  /* Labels of Fields to Display in Browser, CHR(3)-delimited list */
    FIELD cBrowseFieldDataTypes      AS CHARACTER  /* Data Types of Fields to display in browser, comma-delimited list */
    FIELD cBrowseFieldFormats        AS CHARACTER  /* Formats of Fields to display in browser, CHR(3)-delimited list */
    FIELD cBrowseFieldValuesIfNull   AS CHARACTER  /* Values of Fields if values returned are null, CHR(3)-delimited list */
    FIELD cAllFields                 AS CHARACTER  /* Comma list of all selected fields minus duplicates */
    FIELD cAllFieldTypes             AS CHARACTER  /* Comma list of all selected fields minus duplicates data types */
    FIELD cAllFieldFormats           AS CHARACTER  /* Comma list of all selected fields minus duplicates formats */
    FIELD iRowsToBatch               AS INTEGER    /* Number of rows per Appserver Xfer */
    FIELD cBaseQueryString           AS CHARACTER  /* Base Browser query string (design time) */
    FIELD cQueryTables               AS CHARACTER  /* Comma list of query tables (buffers) */
    FIELD cRowIdent                  AS CHARACTER  /* comma list of rowids of current record for reposition */
    FIELD iFirstRowNum               AS INTEGER    /* first row number retrieved (if any) */
    FIELD iLastRowNum                AS INTEGER    /* last row number retrieved (if reached last) */
    FIELD cFirstResultRow            AS CHARACTER  /* first row in result set, as rownum;rowid1,..rowidn */
    FIELD cLastResultRow             AS CHARACTER  /* last row in result set, as rownum;rowid1,..rowidn */
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
         HEIGHT             = 10.57
         WIDTH              = 47.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


