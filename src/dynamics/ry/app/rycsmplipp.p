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
  File: rycsmplipp.p

  Description:  ryc_attribute_value Plip

  Purpose:      Contains procedures for reading/updating ryc_attribute_value into a temp-table
                and  passing temp-table back and forth to calling procedure.

  Parameters:   input-output table for ryc_attribute_value defined like rowobjupd

  History:
  --------
  (v:010000)    Task:        6962   UserRef:    
                Date:   25/01/2001  Author:     Jenny Bond

  Update Notes: Procedures to read/update ryc_page

  (v:010001)    Task:        7748   UserRef:    
                Date:   30/01/2001  Author:     Jenny Bond

  Update Notes: Complete Smart Object Maintenance

  (v:010100)    Task:    90000052   UserRef:    POSSE
                Date:   03/05/2001  Author:     Phil Magnay

  Update Notes: ok

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycsmplipp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{af/sup2/afglobals.i}

&SCOPED-DEFINE ttName ttRycSmartLink
{ry/inc/rycsmttdef.i}
&UNDEFINE ttName

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
         HEIGHT             = 10.19
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

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

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics ryc_smartobject PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

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

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

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

&ENDIF

&IF DEFINED(EXCLUDE-updateRycSmartLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRycSmartLink Procedure 
PROCEDURE updateRycSmartLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttRycSmartLink.

DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO INITIAL "":u.
DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.
DEFINE VARIABLE cUndoRowIds     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hSDO            AS HANDLE       NO-UNDO.

DEFINE BUFFER bttRycSmartLink FOR ttRycSmartLink.

FOR EACH ttRycSmartLink
    WHERE ttRycSmartLink.rowMod = "D":u:
    FIND bttRycSmartLink
        WHERE bttRycSmartLink.rowIdent = ttRycSmartLink.rowIdent 
        AND   bttRycSmartLink.rowMod = "":u NO-ERROR.
    IF  AVAILABLE bttRycSmartLink THEN
        DELETE bttRycSmartLink.
    ELSE DO:
        /***DIAG***/
        MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
            "ERROR-STATUS:GET-MESSAGE(1) " ERROR-STATUS:GET-MESSAGE(1)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.

RUN ry/obj/rycsmfullo.w PERSISTENT SET hSDO ON gshAstraAppserver NO-ERROR.

IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RETURN ERROR cErrorMessage.
END.

RUN initializeObject IN hSDO NO-ERROR.

IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RUN destroyObject IN hSDO.
    RETURN ERROR cErrorMessage.
END.

DYNAMIC-FUNCTION("setCheckCurrentChanged":U IN hSDO, INPUT FALSE).

RUN serverCommit IN hSDO (INPUT-OUTPUT TABLE ttRycSmartLink, OUTPUT cErrorMessage, OUTPUT cUndoRowIds) NO-ERROR.

IF  ERROR-STATUS:ERROR OR RETURN-VALUE <> "":u  THEN DO:
    cErrorMessage = IF cErrorMessage = "":u THEN RETURN-VALUE ELSE cErrorMessage + CHR(3) + RETURN-VALUE.

    IF ERROR-STATUS:ERROR THEN DO iLoop = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorMessage = IF cErrorMessage = "":u THEN ERROR-STATUS:GET-MESSAGE(iLoop)
                        ELSE cErrorMessage + CHR(3) + ERROR-STATUS:GET-MESSAGE(iLoop).
    END.
    RUN destroyObject IN hSDO.
    RETURN ERROR cErrorMessage.
END.

RUN destroyObject IN hSDO.

RETURN cErrorMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

