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
  File: afglobals.i

  Description:  ICF Global Shared Variables

  Purpose:      ICF Global Shared Variables
                The global shared variables available within the Astra environment. Only 6
                are supported, 1 for the Astra Appserver partition, 1 for the Astra
                Session Manager, 1 for the Security Manager, 1 for the Profile
                Manager, 1 for the Repository Manager and 1 for the Client Session ID.
                These are used extensively in Astra so are shared variables for
                performance reasons. All other system wide information must be obtained
                from the Session Manager.
                NOTE: Shared variables do not span the client / server boundary. On the
                client these are set-up in afstartupp.p and on the server in the agent
                as_startup.p
                Also note if we include the guts of a procedure as an internal
                procedure for shared client/server code, we sometime need to
                ensure the shared variables are not redefined.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   02/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010001)    Task:        6018   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Add new procedure to session manager to retrieve global control data as a
                temp-table.

  (v:010002)    Task:        6065   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Integrate Astra1 & Astra 2

  (v:010003)    Task:        6057   UserRef:    
                Date:   24/06/2000  Author:     Pieter Meyer

  Update Notes: WEB - FrameWork Design Changes

  (v:010005)    Task:        6574   UserRef:    
                Date:   25/08/2000  Author:     Johan Meyer

  Update Notes: Add handle definitions for AstraFin and AstraGen generic plips.

  (v:010006)    Task:        7547   UserRef:    
                Date:   10/01/2001  Author:     Peter Judge

  Update Notes: BUG/ Remove full pathname from afproducts.i

  (v:010007)    Task:        7704   UserRef:    
                Date:   24/01/2001  Author:     Peter Judge

  Update Notes: AF2/ Add new AstraGen Manager

  (v:010009)    Task:    90000031   UserRef:    
                Date:   22/03/2001  Author:     Anthony Swindells

  Update Notes: removal of Astra 1

-----------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afglobals.i
&scop object-version    010001


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
         HEIGHT             = 5.57
         WIDTH              = 64.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

&IF DEFINED(shared-variables) = 0 &THEN
  {src/adm2/globals.i}
  {af/sup/afproducts.i} /* Installed products include - used to conditionally include/exclude code */

  &GLOBAL-DEFINE shared-variables

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


