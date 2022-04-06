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
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*---------------------------------------------------------------------------------
  File: ryplipshut.i

  Description:  standard include for plipShutdown

  Purpose:      standard include for plipShutdown in a Astra 2 plip

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6065   UserRef:    
                Date:   20/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in main block.
  
-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryplipshut.i
&scop object-version    000000


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
         HEIGHT             = 6.76
         WIDTH              = 44.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    /* get rid of entry in Astra 2 session manager */
    IF VALID-HANDLE(gshSessionManager) THEN
    DO:
      RUN killProcedure IN gshSessionManager (INPUT THIS-PROCEDURE:FILE-NAME
                                             ,INPUT "":U
                                             ,INPUT "":U
                                             ,INPUT "":U
/* MJS 04/02/2002                            ,INPUT (IF SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U THEN YES ELSE NO) */
                                             ,INPUT SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U
                                             ).
    END.

    /* Notify user if required */
    &IF "{&mip-notify-user-on-plip-close}":U = "yes":U &THEN

        DEFINE VARIABLE cSubject          AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cEmail            AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cPlipDescription  AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cFailed           AS CHARACTER NO-UNDO.

        IF LOOKUP( "objectDescription":U, THIS-PROCEDURE:INTERNAL-ENTRIES ) <> 0 THEN
          RUN objectDescription IN THIS-PROCEDURE (OUTPUT cPlipDescription).
        ELSE
          ASSIGN cPlipDescription = "":U.

        ASSIGN
            cSubject = "PLIP Shutdown - ":U + lv_this_object_name + " - ":U + cPlipDescription + " !":U
            cEmail = cSubject + CHR(10) + CHR(10) + STRING(TODAY) + " @ ":U + STRING(TIME,"HH:MM:SS":U)
            .
        RUN notifyUser IN gshSessionManager (INPUT 0,
                                             INPUT "":U,
                                             INPUT "email":U,
                                             INPUT cSubject,
                                             INPUT cEmail,
                                             OUTPUT cFailed).
    &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


