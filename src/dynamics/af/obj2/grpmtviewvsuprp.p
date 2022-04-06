&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: grpmtviewvsuprp.p

  Description:  Security group maintenance super proc

  Purpose:      Security group maintenance super proc

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/14/2003  Author:     

  Update Notes: Created from Template rytemcustomsuper.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       grpmtviewvsuprp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
         HEIGHT             = 8.67
         WIDTH              = 56.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/customsuper.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAddOrCopy       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAllFieldNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAllFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDefaultSecGroup AS HANDLE     NO-UNDO.
DEFINE VARIABLE cEntry           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButton          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDefSecGrp       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hSDO             AS HANDLE     NO-UNDO.

{get newRecord cAddOrCopy}.
{get allFieldNames cAllFieldNames}.
{get allFieldHandles cAllFieldHandles}.

ASSIGN hDefaultSecGroup = WIDGET-HANDLE(ENTRY(LOOKUP("default_security_group", cAllFieldNames), cAllFieldHandles)).

IF cAddOrCopy <> "NO":U
THEN DO:
    /* We're adding or copying */
    IF hDefaultSecGroup:CHECKED = YES THEN
        RUN showMessages IN gshSessionManager (INPUT "This security group has been flagged as a default security group.~n~n" +
                                                     "All new users added to the system will be linked to the security group automatically.  " +
                                                     "Please note that existing users have to be linked manually.",
                                               INPUT "INF",
                                               INPUT "&OK",
                                               INPUT "&OK",
                                               INPUT "&OK",
                                               INPUT "Information",
                                               INPUT NO,
                                               INPUT ?,
                                               OUTPUT cButton).
END.
ELSE DO:
    {get DataSource hSDO}.
    IF VALID-HANDLE(hSDO) 
    THEN DO:
        ASSIGN cDefSecGrp = DYNAMIC-FUNCTION("columnValue":U IN hSDO, INPUT "default_security_group":U).
        IF LOGICAL(cDefSecGrp) = NO AND hDefaultSecGroup:CHECKED = YES THEN
            RUN showMessages IN gshSessionManager (INPUT "This security group has been flagged as a default security group.~n~n" +
                                                         "All new users added to the system will be linked to the security group automatically.  " +
                                                         "Please note that existing users have to be linked manually.",
                                                   INPUT "INF",
                                                   INPUT "&OK",
                                                   INPUT "&OK",
                                                   INPUT "&OK",
                                                   INPUT "Information",
                                                   INPUT NO,
                                                   INPUT ?,
                                                   OUTPUT cButton).
        ELSE
            IF LOGICAL(cDefSecGrp) = YES AND hDefaultSecGroup:CHECKED = NO THEN
                RUN showMessages IN gshSessionManager (INPUT "This security group is not flagged as a default security group anymore.~n~n" +
                                                             "Please note that any users linked to this security group have to be unlinked manually if so required.",
                                                       INPUT "INF",
                                                       INPUT "&OK",
                                                       INPUT "&OK",
                                                       INPUT "&OK",
                                                       INPUT "Information",
                                                       INPUT NO,
                                                       INPUT ?,
                                                       OUTPUT cButton).
    END.
END.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

