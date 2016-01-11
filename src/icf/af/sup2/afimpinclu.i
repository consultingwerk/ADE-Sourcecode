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
  File: afimpinclu.i

  Description:  Include file for tt_import temp table.

  Purpose:      Include file for tt_import temp table.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7259   UserRef:    
                Date:   07/12/2000  Author:     Marcia Bouwman

  Update Notes: Created from Template ryteminclu.i

  (v:010001)    Task:        7518   UserRef:    
                Date:   08/02/2001  Author:     Peter Judge

  Update Notes: AF2/ Added importFieldsChanged field. This field contains a list of all of the fields
                changed, and is mainly used for MOD actions.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

&glob MAX-FIELDS 50     /* Max. supported fields in a single table */

DEFINE TEMP-TABLE ttImport   NO-UNDO
   FIELD importKey           AS CHARACTER FORMAT "X(35)":U
   FIELD importFla           AS CHARACTER FORMAT "X(5)":U
   FIELD importType          AS CHARACTER FORMAT "X(15)":U
   FIELD importRecord        AS CHARACTER EXTENT {&MAX-FIELDS}
   FIELD importAction        AS CHARACTER FORMAT "X(3)":U
   FIELD importFieldsChanged AS CHARACTER
   INDEX idImportKey IS PRIMARY importKey importFla importType ASCENDING.

DEFINE TEMP-TABLE ttDatatable
    FIELD ttTable AS CHARACTER
    FIELD ttKey  AS CHARACTER
    FIELD ttData AS CHARACTER EXTENT {&MAX-FIELDS}
    INDEX idxMain ttTable ttKey.

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
         HEIGHT             = 11.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


