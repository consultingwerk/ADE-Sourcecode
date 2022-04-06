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
  File: rydynsdvcp.p

  Description:  Dynamics SDV Class Procedure

  Purpose:      Dynamics SDV Class Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/20/2002  Author:     Peter Judge

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynsdvcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{ src/adm2/globals.i }

/* temp-table for translations */
{ af/app/aftttranslate.i }

/** This TT links the ttTranslation TT with the cache_Object table.
 *  ----------------------------------------------------------------------- **/
DEFINE TEMP-TABLE ttTransLink       NO-UNDO
    FIELD tRecordIdentifier     AS DECIMAL
    FIELD tWidgetName           AS CHARACTER
    FIELD tWidgetEntry          AS INTEGER
    INDEX idxMain
        tWidgetName
        tWidgetEntry
    .

/* Global query used for generic query processing. */
DEFINE VARIABLE ghQuery1                    AS HANDLE                   NO-UNDO.
DEFINE VARIABLE ghQuery2                    AS HANDLE                   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-replicateUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD replicateUiEvents Procedure 
FUNCTION replicateUiEvents RETURNS LOGICAL
    ( INPUT pdOldInstanceId         AS DECIMAL,
      INPUT pdNewInstanceId         AS DECIMAL   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 15.29
         WIDTH              = 67.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* Make sure that there's a unique value for the TT object IDs. */
IF gsdTempUniqueId EQ 0 OR gsdTempUniqueId EQ ? THEN
    RUN seedTempUniqueID IN gshSessionManager.

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

ASSIGN cDescription = "Dynamic SmartDataViewer Class PLIP".

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

    /** These pre-processors define the behaviour of labels. 
     *  ----------------------------------------------------------------------- **/
    &SCOPED-DEFINE FORCE-NO-LABEL-TYPES TEXT
    &SCOPED-DEFINE WIDGETS-WITH-DELIMITERS SELECTION-LIST,RADIO-SET,COMBO-BOX,SmartDataField

    /** The code from this API moved into a separate include file because of
     *  section editor limits.
     *  ----------------------------------------------------------------------- **/
    { ry/app/rydynsdvvc.i }

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* validateClassData */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-replicateUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION replicateUiEvents Procedure 
FUNCTION replicateUiEvents RETURNS LOGICAL
    ( INPUT pdOldInstanceId         AS DECIMAL,
      INPUT pdNewInstanceId         AS DECIMAL   ) :
/*------------------------------------------------------------------------------
  Purpose:  Replicates UI events from one object to another.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hUiEventBuffer                  AS HANDLE           NO-UNDO.
    DEFINE VARIABLE hReplicateUiEventBuffer         AS HANDLE           NO-UNDO.

    ASSIGN hUiEventBuffer = DYNAMIC-FUNCTION("getCacheUiEventBuffer":U IN gshRepositoryManager).

    CREATE BUFFER hReplicateUiEventBuffer FOR TABLE hUiEventBuffer BUFFER-NAME "replicateUiEvent":U.

    IF NOT VALID-HANDLE(ghQuery2) THEN
        CREATE QUERY ghQuery2.

    ghQuery2:SET-BUFFERS(hUiEventBuffer).
    ghQuery2:QUERY-PREPARE(" FOR EACH ":U + hUiEventBuffer:NAME + " WHERE ":U
                           + hUiEventBuffer:NAME + ".tRecordIdentifier = ":U + QUOTER(pdOldInstanceId) ).
    ghQuery2:QUERY-OPEN().

    ghQuery2:GET-FIRST().
    DO WHILE hUiEventBuffer:AVAILABLE:
        hReplicateUiEventBuffer:BUFFER-CREATE().
        hReplicateUiEventBuffer:BUFFER-COPY(hUiEventBuffer, "tRecordIdentifier":U).
        hReplicateUiEventBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE = pdNewInstanceId.
        hReplicateUiEventBuffer:BUFFER-RELEASE().

        ghQuery2:GET-NEXT().
    END.    /* available UI events */
    ghQuery2:QUERY-CLOSE().

    DELETE OBJECT hReplicateUiEventBuffer NO-ERROR.
    ASSIGN hReplicateUiEventBuffer = ?.

    RETURN TRUE.
END FUNCTION.   /* replicateUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

