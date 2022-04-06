&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Include _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* ICF Update Version Notes Wizard
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
  File: afproducts.i

  Description:  Installed products include file

  Purpose:      Include file that contains pre-processors for installed products, namely
                'ICF' and 'astragen'. This is then included in aftrigproc.i to get it into all
                triggers, plus aflocalvar.i to get into all objects.
                This can then be checked in various programs that are also used in ICF
                to see if AstraGen is defined, and if not, exclude certain code that would
                not compile due to missing tables.
                When exported to the af-dev workspace, this include should be modified
                to take out the definition of the 'astragen' preprocessor so that the programs
                will then compile for 'ICF'.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         409   UserRef:    ICF
                Date:   06/07/1998  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:    90000067   UserRef:    
                Date:   24/04/2001  Author:     Anthony Swindells

  Update Notes: Remove RTB dependancy, so code does not break if RTB not connected / in
                use. Added SCMTool pre-processor to point at RTB so that this can be
                checked in various places to ensure code compiles without RTB.

  (v:010002)    Task:    90000152   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: yadayada

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afproducts.i
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

&glob   icf           yes

/* Pre-processor for SCM tool in use. Whereever code is inserted that directly
   references the SCM tool, this pre-processor will be checked to ensure the
   code compiles if the tool is not present (by simply removing this
   pre-processor)
*/
&glob   scmTool         NONE

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
         HEIGHT             = 27.81
         WIDTH              = 46.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


