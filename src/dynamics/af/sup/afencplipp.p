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
  File: afencplipp.p

  Description:  Standard Encryption Plip

  Purpose:      Standard Encryption Plip

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        3095   UserRef:    
                Date:   19/10/1999  Author:     Pieter Meyer

  Update Notes: Implement Printing Security.
                1) Modify report definition maintenance suite to maintain new report security options:
                default password, password required, allow password override
                Encrypt data file, allow encrpty override
                Auto delete data file, allow auto delete override
                2) Add new procedures to the standard appserver plip to allow encryption and decryption of a text file using the freeware filecode.exe utility command line options. Provide some flexibility for command line options in the parameters.
                3) Modify the standard report launch objects and printing include files to utilise the above new security options for password secuirty, auto deletion, and scrambling of the data. Refer to the dictionary description for further detail of the implmentation of each of the new fields. Note that the report definition table and the extract log table have new fields to support the new functionality.
                See document af/doc/af_security.doc for more details on how the security has been implemented for testing purposes.

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afencplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

&scop SILENT silent

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 12.33
         WIDTH              = 55.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Encryption PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-encrypt-file Include 
PROCEDURE mip-encrypt-file :
/*------------------------------------------------------------------------------
  Purpose:    This procedure is to encrypt/encode and decrypt/decode a report in the OS.  
  Parameters:  <none>
  Notes:      Please make sure the relevant utility program is on the system
              in the propath.
          NB. The encryption/decryption encodeing/decoding method and/or command
              lines in this procedure may NEVER be used outside of this program
              or copied or taken down for reference.

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_encrypt_file          AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER ip_file_directory        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER ip_file_name             AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER ip_password              AS CHARACTER    NO-UNDO.

    IF SEARCH(ip_file_directory + ip_file_name) = ?
    THEN DO:
        RETURN "File to encrypt/decrypt not found: ":U + ip_file_directory + ip_file_name.
    END.

    RUN mip-encrypt-procedure ( INPUT ip_encrypt_file,
                                INPUT ip_file_directory,
                                INPUT ip_file_name,
                                INPUT ip_password).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-encrypt-procedure Include 
PROCEDURE mip-encrypt-procedure :
/*------------------------------------------------------------------------------
  Purpose:    This procedure is to encrypt/encode and decrypt/decode a file in the OS.  
  Parameters:  <none>
  Notes:      Please make sure the relevant utility program is on the system
              in the propath.
          NB. The encryption/decryption encodeing/decoding method and/or command
              lines in this procedure may NEVER be used outside of this program
              or copied or taken down for reference.

              Filecode.exe
              Encryption/Decryption - Encode/Decode Program
              Options:
              /s    : Source directory
              /f    : Source File()
              /t    : Target directory
              /p    : Password
              /e    : Encrypt
              /d    : Decrypt
              /h    : Hide Code
              /k    : Keep source file date(s)


------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_encrypt_file          AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER ip_file_directory        AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER ip_file_name             AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER ip_password              AS CHARACTER    NO-UNDO. /* ENCODED */

    DEFINE VARIABLE lv_enc_filename                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE lv_enc_command                  AS CHARACTER    NO-UNDO.

    /*check that the encrypt/encode utility is available*/
    ASSIGN
        lv_enc_filename = 'filecode.exe'
        lv_enc_command  = lv_enc_filename
                        + ' /s '
                        + '"' + ip_file_directory + '"'
                        + ' /f '
                        + '"' + ip_file_name      + '"'
                        + ' /p '
                        + '"' + ip_password       + '"'
                        + (if ip_encrypt_file THEN ' /e ' ELSE ' /d ')
                        + ' /h '
                        + ' /k '
                        .

    IF SEARCH(lv_enc_filename) = ?
    THEN DO:
        RETURN "Encryption/Encode utility not found: ":U + lv_enc_filename.
    END.

    OS-COMMAND {&SILENT} VALUE(lv_enc_command).

    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-encrypt-report Include 
PROCEDURE mip-encrypt-report :
/*------------------------------------------------------------------------------
  Purpose:    This procedure is to encrypt/encode and decrypt/decode a report in the OS.  
  Parameters:  <none>
  Notes:      Please make sure the relevant utility program is on the system
              in the propath.
          NB. The encryption/decryption encodeing/decoding method and/or command
              lines in this procedure may NEVER be used outside of this program
              or copied or taken down for reference.

------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_encrypt_file          AS LOGICAL      NO-UNDO.
    DEFINE INPUT PARAMETER ip_file_name             AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE lv_password                     AS CHARACTER    NO-UNDO. /* ENCODED */
    DEFINE VARIABLE lv_rpd_directory                AS CHARACTER    NO-UNDO.

    FIND gsc_global_default NO-LOCK
        WHERE gsc_global_default.default_type = "RPD":U     /* Report Data directory */
        NO-ERROR.
    IF AVAILABLE gsc_global_default
    THEN DO:
        ASSIGN
            lv_rpd_directory = REPLACE( REPLACE(gsc_global_default.default_value, "~\":U,"/":U) + "/":U, "//":U, "/":U ).
    END.
    ELSE DO:
        RETURN "Report Directory not setup ":U.
    END.

    IF SEARCH(lv_rpd_directory + ip_file_name) = ?
    THEN DO:
        RETURN "Report to encrypt/decrypt not found: ":U + lv_rpd_directory + ip_file_name.
    END.

    ASSIGN
        lv_password   = "aStRa":U + "R":U + "SafE":U.
        lv_password   = ENCODE(lv_password).

    RUN mip-encrypt-procedure ( INPUT ip_encrypt_file,
                                INPUT lv_rpd_directory,
                                INPUT ip_file_name,
                                INPUT lv_password).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

