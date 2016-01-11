&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
  File: aftemgupdb.i

  Description:  Include file for definition of temp-tabl

  Purpose:      Include file for definition of temp-table for use with updateable browser

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         328   UserRef:    
                Date:   14/06/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemgupdb.i
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE TEMP-TABLE tt_field_value
    FIELD field_sequence    AS INTEGER
    FIELD field_data_type1  AS CHARACTER 
    FIELD field_data_type2  AS CHARACTER 
    FIELD field_data_type3  AS CHARACTER 
    FIELD field_data_type4  AS CHARACTER 
    FIELD field_data_type5  AS CHARACTER 
    FIELD field_data_type6  AS CHARACTER 
    FIELD field_data_type7  AS CHARACTER 
    FIELD field_data_type8  AS CHARACTER 
    FIELD field_data_type9  AS CHARACTER 
    FIELD field_data_type10 AS CHARACTER 
    FIELD field_value1      AS CHARACTER LABEL "Value 1":U FORMAT "X(40)"
    FIELD field_value2      AS CHARACTER LABEL "Value 2":U FORMAT "X(40)"
    FIELD field_value3      AS CHARACTER LABEL "Value 3":U FORMAT "X(40)"
    FIELD field_value4      AS CHARACTER LABEL "Value 4":U FORMAT "X(40)"
    FIELD field_value5      AS CHARACTER LABEL "Value 5":U FORMAT "X(40)"
    FIELD field_value6      AS CHARACTER LABEL "Value 6":U FORMAT "X(40)"
    FIELD field_value7      AS CHARACTER LABEL "Value 7":U FORMAT "X(40)"
    FIELD field_value8      AS CHARACTER LABEL "Value 8":U FORMAT "X(40)"
    FIELD field_value9      AS CHARACTER LABEL "Value 9":U FORMAT "X(40)"
    FIELD field_value10     AS CHARACTER LABEL "Value 10":U FORMAT "X(40)"
    INDEX tt_field_value_field_sequence AS UNIQUE PRIMARY
        field_sequence ASCENDING.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


