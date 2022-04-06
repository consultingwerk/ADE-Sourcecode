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
  File: rydynsdfcp.p

  Description:  Dynamics Field Class Object Proc

  Purpose:      Dynamics Field Class Object Procedure.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/02/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p
                Created from Template rydynsdfcp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynsdfcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO


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
         HEIGHT             = 14.29
         WIDTH              = 54.6.
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

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* killPlip */

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

    ASSIGN cDescription = "Dynamics Field Class Object Procedure".

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

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* plipSetup */

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

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* plipShutdown */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateClassData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateClassData Procedure 
PROCEDURE validateClassData :
/*------------------------------------------------------------------------------
  Purpose:     Performs certain customisations for objects belonging to the
               Field classes (DynLookups DynCombos etc).
  Parameters:  phObjectBuffer      -
               pcLogicalObjectName -
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

    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSdfAttributeBuffer         AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hField                      AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSdfField                   AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hSDO                        AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cKeyFieldName               AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldFormat                AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cFieldDataType              AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE lLocalField                 AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dContainerInstanceId        AS DECIMAL              NO-UNDO.

    DEFINE BUFFER rycso_SDO         FOR ryc_smartObject.

    /** TEMPORARY FIX ** TEMPORARY FIX ** TEMPORARY FIX ** TEMPORARY FIX ** 
     *  For performance reasons, only perform these checks in a DynaWeb environment.
     *  ----------------------------------------------------------------------- **/
    IF SESSION:CLIENT-TYPE NE "WEBSPEED":U THEN RETURN.

    /* We do nothing for Master SDFs as yet. */
    IF pdInstanceId EQ 0 THEN
        RETURN.

    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT pdInstanceId).

    /** We need to ensure that the KeyFormat and KeyDataType of the SDF match 
     *  that of the underlying field.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hSdfAttributeBuffer  = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
           dContainerInstanceId = hObjectBuffer:BUFFER-FIELD("tContainerRecordIdentifier":U):BUFFER-VALUE.
    hSdfAttributeBuffer:FIND-FIRST(" WHERE ":U + hSdfAttributeBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdInstanceId) ) NO-ERROR.

    ASSIGN hSdfField = hSdfAttributeBuffer:BUFFER-FIELD("LocalField":U) NO-ERROR.
    IF VALID-HANDLE(hSdfField) THEN
        ASSIGN lLocalField = hSdfField:BUFFER-VALUE.
    ELSE
        ASSIGN lLocalField = NO.

    /** We need to ensure that the KeyFormat and KeyDataType match those of 
     *  the underlying field, as represented by the FieldName field.
     *  ----------------------------------------------------------------------- **/
    ASSIGN hSdfField = hSdfAttributeBuffer:BUFFER-FIELD("FieldName":U) NO-ERROR.
    IF VALID-HANDLE(hSdfField) THEN
        ASSIGN cKeyFieldName = hSdfField:BUFFER-VALUE.

    IF cKeyFieldName NE ? AND cKeyFieldName NE "":U THEN
    DO:
        /* Don't bother starting the SDO is this is a local field. */
        IF NOT lLocalField THEN
        DO:
            /* The SDO will translate the FieldName into the TableName.FieldName
             * which will be used to retrieve the underlying DataField.          */
            ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT dContainerInstanceId).
    
            FIND FIRST rycso_SDO WHERE
                       rycso_SDO.smartObject_obj = DECIMAL(hObjectBuffer:BUFFER-FIELD("tSdoSmartObjectObj":U):BUFFER-VALUE)
                       NO-LOCK NO-ERROR.
            IF AVAILABLE rycso_SDO THEN
            DO:
                RUN startDataObject IN gshRepositoryManager ( INPUT rycso_SDO.object_filename, OUTPUT hSdo ) NO-ERROR.

                /* Get the field name as it is in the DB.
                 * We do this because the field may be an assigned field. In this case we
                 * need to know the name of the underlying field.                         */
                ASSIGN cKeyFieldName = DYNAMIC-FUNCTION("columnDbColumn":U IN hSdo, INPUT cKeyFieldName).

                /* Get rid of the [] for array fields. */
                ASSIGN cKeyFieldName = REPLACE(cKeyFieldName, "[":U, "":U)
                       cKeyFieldName = REPLACE(cKeyFieldName, "]":U, "":U).
            END.    /* avialable SDO */
        END.    /* not a local field (ie. comes from an SDO. */

        /* Get the underlying field from the Repository. */
        DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                         INPUT cKeyFieldName, INPUT ?, INPUT ?, INPUT NO).

        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).
        /* There is no guarantee that the underlying field has an associated
         * Repository object, although it should have.                       */
        IF hObjectBuffer:AVAILABLE THEN
        DO:
            ASSIGN hAttributeBuffer = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE.
            hAttributeBuffer:FIND-FIRST(" WHERE ":U + hAttributeBuffer:NAME + ".tRecordIdentifier = ":U
                                        + QUOTER(hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE) ).

            /* Data Type */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("DATA-TYPE":U) NO-ERROR.
            ASSIGN hSdfField = hSdfAttributeBuffer:BUFFER-FIELD("KeyDataType":U) NO-ERROR.

            IF VALID-HANDLE(hField) AND VALID-HANDLE(hSdfField) THEN
            DO:
                ASSIGN cFieldDataType = hField:BUFFER-VALUE.
                IF cFieldDataType NE ? AND cFieldDataType NE "":U THEN
                    ASSIGN hSdfField:BUFFER-VALUE = cFieldDataType.
            END.    /* valid DATA-TYPE field */
            
            /* Format */
            ASSIGN hField = hAttributeBuffer:BUFFER-FIELD("FORMAT":U) NO-ERROR.
            ASSIGN hSdfField = hSdfAttributeBuffer:BUFFER-FIELD("KeyFormat":U) NO-ERROR.
            IF VALID-HANDLE(hField) AND VALID-HANDLE(hSdfField) THEN
            DO:
                ASSIGN cFieldFormat = hField:BUFFER-VALUE.
                IF cFieldFormat NE ? AND cFieldFormat NE "":U THEN
                    ASSIGN hSdfField:BUFFER-VALUE = cFieldFormat.
            END.    /* valid FORMAT field */
        END.    /* avialable in repository */

        /* Clean up after ourselves, like we were taught to. */
        IF VALID-HANDLE(hSdo) THEN
            RUN destroyObject IN hSDO NO-ERROR.

        IF VALID-HANDLE(hSdo) THEN
            DELETE OBJECT hSDO NO-ERROR.

        ASSIGN hSDO = ?.        
    END.    /* there is an underlying key field */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* validateClassData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

