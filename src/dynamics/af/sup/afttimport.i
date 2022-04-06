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
  File: afttimport.i

  Description:  Include file for tt_import temp-table

  Purpose:      Include file for tt_import temp-table

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         839   UserRef:    
                Date:   10/12/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:         878   UserRef:    
                Date:   16/12/1998  Author:     Anthony Swindells

  Update Notes: Update import documentation and temp-table so that the type field may be upto
                15 characters rather than 3.

  (v:010002)    Task:        1007   UserRef:    
                Date:   27/01/1999  Author:     Anthony Swindells

  Update Notes: Change import templates to also be used for  fast data entry business logic and
                also to allow for deletions.
                Added a new field to the end of the temporary table for import_action. Actions
                supported are IMP for Import, ADD for Add, DEL for Delete. ADD and DEL
                indicate fast data entry screen business logic, whereas IMP indicates an
                import situation.

  (v:010003)    Task:        3119   UserRef:    
                Date:   11/10/1999  Author:     Johan Meyer

  Update Notes: Add dynamic query data to afappplipp.i to allow for the load of frequently-used static data tables to be loaded into temp-tables.

  (v:010004)    Task:        3136   UserRef:    
                Date:   12/10/1999  Author:     Johan Meyer

  Update Notes: Add mip-build-datatable and mip-get-data-value to afappplipp.i to facilitate speeding up of data reads for imports. Data gets loaded into a temp table and then the temp-table gets accessed  instead of a db read.

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afttimport.i
&scop object-version    010004

/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

&glob MAX-FIELDS 50     /* Max. supported fields in a single table */

DEFINE TEMP-TABLE tt_import   NO-UNDO
   FIELD import_key           AS CHARACTER FORMAT "X(35)":U
   FIELD import_fla           AS CHARACTER FORMAT "X(5)":U
   FIELD import_type          AS CHARACTER FORMAT "X(15)":U
   FIELD import_record        AS CHARACTER EXTENT {&MAX-FIELDS}
   FIELD import_action        AS CHARACTER FORMAT "X(3)":U
   INDEX id_import_key IS PRIMARY import_key import_fla import_type ASCENDING.

DEFINE TEMP-TABLE tt_datatable
    FIELD tt_table AS CHARACTER
    FIELD tt_key  AS CHARACTER
    FIELD tt_data AS CHARACTER EXTENT {&MAX-FIELDS}
    INDEX idx_main tt_table tt_key.

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
         HEIGHT             = 7.71
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


