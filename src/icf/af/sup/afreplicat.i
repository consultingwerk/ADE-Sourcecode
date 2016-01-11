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
&scop object-version    010002


/* ICF object identifying preprocessor */
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
         HEIGHT             = 7.33
         WIDTH              = 40.
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

  RUN af/app/afversionp.p (
      INPUT BUFFER {&TABLE-NAME}:HANDLE,
      INPUT "{&TABLE-FLA}",
      INPUT "{&ACTION}"
      ).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


