&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afcobuildp.p

  Description:  Generic Combo/Selection List Data Build

  Purpose:      Generic Combo/Selection List Data Build.
                To populate list item pairs generically for combo boxes and selection lists.
                This routine should be run server side.
                Copes with multiple combo's / selection lists at once.

  Parameters:   input-output temp-table of widget information for data to build
                Table is updated with list item pairs built.

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   29/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6010   UserRef:    
                Date:   13/06/2000  Author:     Anthony Swindells

  Update Notes: Astra 2 Login Window

  (v:010002)    Task:        6421   UserRef:    
                Date:   07/08/2000  Author:     Anthony Swindells

  Update Notes: Get combos on SDV's working

  (v:010003)    Task:        6610   UserRef:    
                Date:   25/10/2000  Author:     Peter Judge

  Update Notes: BUG/ Error checking only caters for default (comma) delimiter

  (v:010004)    Task:        7415   UserRef:    
                Date:   28/12/2000  Author:     Anthony Swindells

  Update Notes: Fix issues with European format decimals

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcobuildp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

/* input-output temp-table for combo boxes / selection lists whose list items pairs
   need to be built
*/
{src/adm2/globals.i}
{src/adm2/ttcombo.i}

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttComboData.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 13.19
         WIDTH              = 61.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN adm2/cobuildp.p ON gshAstraAppserver (INPUT-OUTPUT TABLE ttComboData).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


