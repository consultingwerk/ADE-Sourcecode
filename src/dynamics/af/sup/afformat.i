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
  File: afformat.i

  Description:  format include file

  Purpose:      Standard trigger procedure included in aftrigendw.i to format fields based on
                options defined in the entity mnemonic table.

                Format options will include upper or lowercasing key field infromation, such as
                TLA's, Code fields, etc.

  Parameters:

  History:
  --------
  (v:010000)    Task:         125   UserRef:    
                Date:   31/03/1998  Author:     Anthony Swindells

  Update Notes: Created from template af/sup/afteminclu.i

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afformat.i
&scop object-version    010000

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


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE auto-format-fields Include 
PROCEDURE auto-format-fields :
/*------------------------------------------------------------------------------
  Purpose:     To automatically format fields based on options set-up in the
               entity mnemonic table for any tables passed in the field list.

  Parameters:  ip_fields    Comma seperated list of field names
               ip_domains   Comma seperated list of field domains
               iop_values   Comma seperated list of field values

  Notes:       This procedure will only deal with character fields.

------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER          ip_fields               AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER          ip_domains              AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER   iop_values              AS CHARACTER    NO-UNDO.

DEFINE VARIABLE                 lv_loop                 AS INTEGER      NO-UNDO.

DO lv_loop = 1 TO NUM-ENTRIES(ip_fields):

    CASE ENTRY(lv_loop,ip_domains):
        WHEN "s_data_type" OR 
        WHEN "s_month_flags" OR
        WHEN "s_mnemonic" OR
        WHEN "s_tla" OR
        WHEN "s_type" OR
        WHEN "s_entity_mnemonic" OR
        WHEN "s_initials" OR
        WHEN "s_tla_list" THEN
            ASSIGN ENTRY(lv_loop,iop_values,"|":U) = CAPS(ENTRY(lv_loop,iop_values,"|":U)).
        WHEN "s_program_name" OR 
        WHEN "s_program_procedure" OR 
        WHEN "s_file_name" THEN
            ASSIGN ENTRY(lv_loop,iop_values,"|":U) = LC(ENTRY(lv_loop,iop_values,"|":U)).
    END CASE.
END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


