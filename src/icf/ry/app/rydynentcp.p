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
  File: rydynentcp.p

  Description:  Dynamics Entity Class Procedure

  Purpose:      Dynamics Entity Class Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/06/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p
                Created from Template rydynentcp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynentcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&GLOBAL-DEFINE AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&SCOPED-DEFINE mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

DEFINE VARIABLE ghQuery1                    AS HANDLE                       NO-UNDO.

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
         HEIGHT             = 15.95
         WIDTH              = 64.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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
    DEFINE OUTPUT PARAMETER cDescription        AS CHARACTER            NO-UNDO.

    ASSIGN cDescription = "Dynamics Entity Class PLIP".


    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* objectDescription */

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

&IF DEFINED(EXCLUDE-validateClassData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateClassData Procedure 
PROCEDURE validateClassData :
/*------------------------------------------------------------------------------
  Purpose:     Performs certain customisations for objects belonging to the
               viewer Master Class.
  Parameters:  pcLogicalObjectName -
               pcResultCode        -
               pdUserObj           -
               pcRunAttribute      -
               pdLanguageObj       -
               pdInstanceId        -
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName          AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcResultCode                 AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdUserObj                    AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pcRunAttribute               AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pdLanguageObj                AS DECIMAL      NO-UNDO.
    DEFINE INPUT PARAMETER pdInstanceId                 AS DECIMAL      NO-UNDO.

    DEFINE VARIABLE hObjectBuffer       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hLocalObjectBuffer  AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hEntityBuffer       AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer    AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hEntityField        AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE hAttributeField     AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE iFieldLoop          AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE iInstanceOrder      AS INTEGER                      NO-UNDO.

    IF pdInstanceId EQ 0 THEN
        /* This call has the (intentional) side-effect of repositioning the cache object to this record. */
        DYNAMIC-FUNCTION("isObjectCached":U IN gshRepositoryManager,
                         INPUT pcLogicalObjectName,
                         INPUT pdUserObj,
                         INPUT pcResultCode,
                         INPUT pcRunAttribute,
                         INPUT pdLanguageObj,
                         INPUT NO                   ).      /* If we are here then we are never in design mode */

    /* We set the pdInstanceId even though we may have a value. */
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId)
           pdInstanceId  = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE.

    ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
    hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

    /* Find the associated GSC_ENTITY_MNEMONIC record */
    ASSIGN hEntityBuffer = BUFFER gsc_entity_mnemonic:HANDLE.

    hEntityBuffer:FIND-FIRST(" WHERE ":U + hEntityBuffer:NAME + ".entity_mnemonic_description = ":U + QUOTER(pcLogicalObjectName), NO-LOCK ) NO-ERROR.

    IF hEntityBuffer:AVAILABLE THEN
    DO iFieldLoop = 1 TO hEntityBuffer:NUM-FIELDS:
        ASSIGN hEntityField = hEntityBuffer:BUFFER-FIELD(iFieldLoop).

        /* The attributes of the EntityAttributes group are by definition simply the names of the fields 
         * in the GSC_ENTITY_MNEMONIC table without the underscores.                                     */
        ASSIGN hAttributeField = hAttributeBuffer:BUFFER-FIELD(REPLACE(hEntityField:NAME, "_":U, "":U)) NO-ERROR.

        IF VALID-HANDLE(hAttributeField) THEN        
            ASSIGN hAttributeField:BUFFER-VALUE = hEntityField:BUFFER-VALUE NO-ERROR.
    END.    /* loop through fields */

    DELETE OBJECT hEntityBuffer NO-ERROR.
    ASSIGN hEntityBuffer = ?.

    IF NOT VALID-HANDLE(ghQuery1) THEN
        CREATE QUERY ghQuery1.

    CREATE BUFFER hLocalObjectBuffer FOR TABLE hObjectBuffer BUFFER-NAME "lbObject":U.

    ghQuery1:SET-BUFFERS(hLocalObjectBuffer).
    ghQuery1:QUERY-PREPARE(" FOR EACH ":U + hLocalObjectBuffer:NAME + " WHERE ":U
                           + hLocalObjectBuffer:NAME + ".tContainerRecordIdentifier = ":U + QUOTER(pdInstanceId)
                           + " BY ":U + hLocalObjectBuffer:NAME + ".tLayoutPosition ":U ).
    ghQuery1:QUERY-OPEN().

    ASSIGN iInstanceOrder = 1.

    ghQuery1:GET-FIRST().
    DO WHILE hLocalObjectBuffer:AVAILABLE:
        ASSIGN hLocalObjectBuffer:BUFFER-FIELD("tInstanceOrder":U):BUFFER-VALUE = iInstanceOrder
               iInstanceOrder                                                   = iInstanceOrder + 1.
        ghQuery1:GET-NEXT().
    END.    /* available buffer */
    ghQuery1:QUERY-CLOSE().

    DELETE OBJECT hLocalObjectBuffer NO-ERROR.
    ASSIGN hLocalObjectBuffer = ?.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* validateClassData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

