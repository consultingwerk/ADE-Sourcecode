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
  File: gscedtable.i

  Description:  Temp Table for gsc_entity_display_field

  Purpose:      Temp Table for gsc_entity_display_field used in GSCEM viewer and sdo
                to maintain display fields child table, via an updatable browser on the
                entity viewer.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000163   UserRef:    
                Date:   18/07/2001  Author:     Anthony Swindells

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

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
         HEIGHT             = 8.14
         WIDTH              = 45.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* temp-table of entity display fields for a specific entity.
   Used in entity mnemonic viewer and sdo to maintain list of display fields
   for the entity in the child table gsc_entity_display_field.
*/

DEFINE TEMP-TABLE ttDisplayField NO-UNDO LIKE gsc_entity_display_field RCODE-INFORMATION
    FIELD iOrder        AS INTEGER                  FORMAT ">>>>>9"         LABEL "Schema Order"
    FIELD cLabel        AS CHARACTER                FORMAT "X(28)"          LABEL "Schema Label"
    FIELD cColLabel     AS CHARACTER                FORMAT "X(28)"          LABEL "Schema Column Label"
    FIELD cFormat       AS CHARACTER                FORMAT "X(28)"          LABEL "Schema Format"
    FIELD cInclude      AS LOGICAL      INITIAL NO  FORMAT "YES/NO":U       LABEL "Include"
    FIELD lFromGSCED    AS LOGICAL      INITIAL NO  FORMAT "YES/NO":U       LABEL "From Disp Field?"
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


