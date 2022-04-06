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
  File: afdbintrap.p

  Description:  Procedure to call the database intranet

  Purpose:      This procedure will launch Internet Explorer and the AstraGen database
                intranet.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         510   UserRef:    Astra
                Date:   29/07/1998  Author:     Alec Tucker

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdbintrap.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

&GLOB DONTRUN-WINFUNC
{af/sup/windows.i}

    DEFINE VARIABLE lv_result AS LOGICAL NO-UNDO INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 1.99
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    RUN mip-create-process
        ( INPUT  "c:\program files\plus!\microsoft internet\iexplore.exe g:\gs\dev\gs\htm\AstraGen-Index.htm":U,
          INPUT  "":U,
          INPUT  1,
          OUTPUT lv_result ).

    IF NOT lv_result THEN
        MESSAGE "Failed to launch database intranet".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-create-process Procedure 
PROCEDURE mip-create-process :
/*------------------------------------------------------------------------------
  Purpose:     To launch an external process
  Parameters:  ip_command_line      - eg "notepad.exe"
               ip_current_directory - Default directory for the process
               ip_show_window       - 0 (Hidden) / 1 (Normal) / 2 (Minimised) / 3 (Maximised)
               op_result            - 0 (Failure) / Non-zero (Handle of new process)

  Notes:       Uses the CreateProcess API function
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER ip_command_line         AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER ip_current_directory    AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER ip_show_window          AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAMETER op_result               AS INTEGER      NO-UNDO.


    DEFINE VARIABLE lv_startup_info_pointer  AS MEMPTR   NO-UNDO.

    SET-SIZE(  lv_startup_info_pointer     ) = 68.
    PUT-LONG(  lv_startup_info_pointer,  1 ) = 68.
    PUT-LONG(  lv_startup_info_pointer, 45 ) = 1.   /* = STARTF_USESHOWWINDOW */
    PUT-SHORT( lv_startup_info_pointer, 49 ) = ip_show_window.

    DEFINE VARIABLE lv_process_information_pointer  AS MEMPTR   NO-UNDO.

    SET-SIZE( lv_process_information_pointer ) = 16.

    DEFINE VARIABLE lv_current_directory_pointer    AS MEMPTR   NO-UNDO.

    IF ip_current_directory <> "":U THEN
      DO:
        SET-SIZE(   lv_current_directory_pointer    ) = 256.
        PUT-STRING( lv_current_directory_pointer, 1 ) = ip_current_directory.
      END.

    DEFINE VARIABLE lv_result AS INTEGER    NO-UNDO.

    RUN CreateProcess{&A} IN hpApi
     ( 0,
       ip_command_line,
       0,
       0,
       0,
       0,
       0,
       IF ip_current_directory = "":U
          THEN 0
          ELSE GET-POINTER-VALUE( lv_current_directory_pointer ),
       GET-POINTER-VALUE( lv_startup_info_pointer ),
       GET-POINTER-VALUE( lv_process_information_pointer ),
       OUTPUT lv_result
     ).


    DEFINE VARIABLE lv_process_handle   AS INTEGER  NO-UNDO.
    ASSIGN
        lv_process_handle = GET-LONG( lv_process_information_pointer, 1 ).

    SET-SIZE( lv_startup_info_pointer        ) = 0.
    SET-SIZE( lv_process_information_pointer ) = 0.
    SET-SIZE( lv_Current_directory_pointer   ) = 0.

    ASSIGN
        op_result = lv_process_handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


