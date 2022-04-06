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
  File: afbldclicp.p

  Description:  Build User Profile client cache temp-tab

  Purpose:      Build client cache temp-table of user profile values for
                current logged in user.
                Run from buildClientCache in Profile Manager.

  Parameters:   Input comma delimited list of profile type to build cache for
                output cached temp-table

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   05/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra 2 Profile Manager and Translation Manager / update supporting
                files

  (v:010002)    Task:        6030   UserRef:    
                Date:   20/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

  (v:010003)    Task:        6111   UserRef:    
                Date:   21/06/2000  Author:     Robin Roos

  Update Notes: remove unnecessary messages

  (v:010004)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers
  
  (v:010005)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in main block.

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afbldclicp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

{af/app/afttprofiledata.i}

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
         HEIGHT             = 6.38
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


  DEFINE INPUT PARAMETER  pcProfileTypeCodes            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE FOR ttProfileData.
/*                                                                */
/* MESSAGE "afbldclicp.p pcProfileTypeCodes=" pcProfileTypeCodes. */

  EMPTY TEMP-TABLE ttProfileData.

  DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cUserObj                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dUserObj                  AS DECIMAL INITIAL 0 NO-UNDO.

  cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO).
  ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

  IF dUserObj <> 0 THEN
  profiletypeloop:
  FOR EACH gsc_profile_type NO-LOCK:

    IF gsc_profile_type.SERVER_profile_type = YES
    AND (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
      NEXT profiletypeloop.

    IF pcProfileTypeCodes <> "":U AND
       LOOKUP(gsc_profile_type.profile_type_code, pcProfileTypeCodes) = 0 THEN
      NEXT profiletypeloop.

    /* loop around profile codes for profie type */
    FOR EACH gsc_profile_code NO-LOCK
       WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj:

      FOR EACH gsm_profile_data NO-LOCK
         WHERE gsm_profile_data.USER_obj = dUserObj
           AND gsm_profile_data.profile_type_obj = gsc_profile_code.profile_type_obj
           AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj:

        CREATE ttProfileData.
        BUFFER-COPY gsm_profile_data TO ttProfileData
             ASSIGN cProfileTypeCode = gsc_profile_type.profile_type_code
                    cProfileCode = gsc_profile_code.profile_code
                    cAction = "NON":U
        .
      END.  /* each profile data */

      /* ensure at least one record exists for the user and profile type / code in the cache */
      IF NOT CAN-FIND(FIRST ttProfileData
                      WHERE ttProfileData.USER_obj = dUserObj
                        AND ttProfileData.cProfileTypeCode = gsc_profile_type.profile_type_code
                        AND ttProfileData.cProfileCode = gsc_profile_code.profile_code) THEN
      DO:
        CREATE ttProfileData.
        ASSIGN
          ttProfileData.cProfileTypeCode = gsc_profile_type.profile_type_code
          ttProfileData.cProfileCode = gsc_profile_code.profile_code
          ttProfileData.USER_obj = dUserObj
          ttProfileData.profile_type_obj = gsc_profile_code.profile_type_obj
          ttProfileData.profile_code_obj = gsc_profile_code.profile_code_obj
          ttProfileData.profile_data_key = "":U
          ttProfileData.CONTEXT_id = gscSessionID          
          ttProfileData.profile_data_value = "":U
          ttProfileData.cAction = "NON":U
          .
      END.

    END. /* each profile code */

  END. /* profile type loop */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


