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
  File: afreplicat.i

  Description:  Astra Replicate Trigger Include

  Purpose:      Astra Replicate Trigger Include

  Parameters:   {af/sup/afreplicat.i  &TABLE-NAME   = "ryc_attribute_value"
                &TABLE-FLA    = "rycav"
                &TABLE-OBJ    = "attribute_value_obj"
                &OLD-BUFFER   = "lb_old"
                &ACTION       = "WRITE"
                &PRIMARY-FLA  = "rycso"
                &PRIMARY-KEY  = "smartobject_obj"
                }
                &VERSION-DATA = "YES":U

  History:
  --------
  (v:010000)    Task:        5461   UserRef:    9.1
                Date:   13/04/2000  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        5512   UserRef:    
                Date:   19/04/2000  Author:     Robin Roos

  Update Notes: Pass paremeter to afreplicat.p  which indicates whether a write operation is NEW

  (v:010003)    Task:        7435   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: fix RVDB connect issues

  (v:010002)    Task:    90000021   UserRef:    
                Date:   02/14/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afreplicat.i
&scop object-version    000000


/* ICF object identifying preprocessor */
&glob   mip-structured-include  yes

{src/adm2/globals.i}

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
         HEIGHT             = 12.24
         WIDTH              = 40.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* SCM Version control on if primary-fla is passed in */

  /* DO NOTHING IF NO RTB CONNECTED */
  IF CONNECTED("RTB":U)
  THEN DO:

    IF "{&PRIMARY-FLA}" <> "":U
    THEN
    DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

      IF SEARCH("rtb/prc/ryreplicat.p":U) <> ?
      OR SEARCH("rtb/prc/ryreplicat.r":U) <> ?
      THEN DO:

        RUN rtb/prc/ryreplicat.p (
            INPUT BUFFER {&TABLE-NAME}:HANDLE,

        &IF DEFINED(OLD-BUFFER) <> 0
        &THEN
          INPUT BUFFER {&OLD-BUFFER}:HANDLE,
        &ELSE
          INPUT ?,
        &ENDIF

          INPUT "{&TABLE-NAME}",
          INPUT "{&TABLE-FLA}",
          INPUT "{&TABLE-PK}",
          INPUT "{&ACTION}",
          INPUT NEW {&TABLE-NAME},
          INPUT "{&PRIMARY-FLA}",
          INPUT "{&PRIMARY-KEY}"
          ).

      END.

    END.

  END.

/* See if data versioning required and possible and do it */
IF TRIM("{&VERSION-DATA}") = "YES":U
THEN
DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

  ERROR-STATUS:ERROR = NO.
  
  RUN versionData IN gshRIManager
    (INPUT BUFFER {&TABLE-NAME}:HANDLE, 
     INPUT "{&TABLE-FLA}", 
     INPUT "{&ACTION}") NO-ERROR.

  IF ERROR-STATUS:ERROR OR 
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN
    RETURN ERROR RETURN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


