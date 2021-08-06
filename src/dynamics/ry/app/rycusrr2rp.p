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
  File: rycusrr2rp.p

  Description:  Reference to Result Code Procedure

  Purpose:      Reference to Result Code Procedure, used in the CustomizationManager.

  Parameters:   pcReference             -
                pcCustomisationType     -
                pcCustomisationTypeAPI  -
                pcResultCode            -
    
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/23/2002  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p                

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycusrr2rp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    YES

DEFINE INPUT        PARAMETER pcCustomisationType       AS CHARACTER        NO-UNDO.
DEFINE INPUT        PARAMETER pcCustomisationTypeAPI    AS CHARACTER        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcReference               AS CHARACTER        NO-UNDO.
DEFINE       OUTPUT PARAMETER pcResultCode              AS CHARACTER        NO-UNDO.

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

&SCOPED-DEFINE GET-REFERENCE-ON-SERVER <<REFERENCE-ON-SERVER>>

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE iReferenceLoop          AS INTEGER                  NO-UNDO.
DEFINE VARIABLE cReference              AS CHARACTER                NO-UNDO.
DEFINE VARIABLE cResult                 AS CHARACTER                NO-UNDO.
DEFINE VARIABLE hCustomizationManager   AS HANDLE                   NO-UNDO.

DEFINE BUFFER rym_customization         FOR rym_customization.
DEFINE BUFFER ryc_customization_type    FOR ryc_customization_type.
DEFINE BUFFER ryc_customization_result  FOR ryc_customization_result.

ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, "CustomizationManager":U).

REFERENCE-LOOP:
DO iReferenceLoop = 1 TO NUM-ENTRIES(pcReference):
    ASSIGN cReference = ENTRY(iReferenceLoop, pcReference).

    /* Resolve any server-side references. */
    IF cReference = "{&GET-REFERENCE-ON-SERVER}":U THEN
    DO:
        ASSIGN cReference = "":U
               cReference = DYNAMIC-FUNCTION(ENTRY(iReferenceLoop, pcCustomisationTypeAPI) IN hCustomizationManager)
               NO-ERROR.
        /* Ensure that there's at least something */
        IF cReference EQ "":U OR cReference EQ ? THEN
            ASSIGN cReference = "{&NO-RESULT-CODE}":U.

        /* Put this reference back into the string. */
        ENTRY(iReferenceLoop, pcReference) = cReference.
    END.    /* get reference on server */

    IF cReference NE "{&NO-RESULT-CODE}":U THEN
    DO:
        /* By now we should have a valid reference code. */
        FIND FIRST ryc_customization_type WHERE
                   ryc_customization_type.customization_type_code = ENTRY(iReferenceLoop, pcCustomisationType)
                   NO-LOCK NO-ERROR.
        IF AVAILABLE ryc_customization_type THEN
            FIND FIRST rym_customization WHERE
                       rym_customization.customization_type_obj  = ryc_customization_type.customization_type_obj AND
                       rym_customization.customization_reference = cReference
                       NO-LOCK NO-ERROR.
        IF AVAILABLE rym_customization THEN
        DO:
            FIND FIRST ryc_customization_result WHERE
                       ryc_customization_result.customization_result_obj = rym_customization.customization_result_obj
                       NO-LOCK.
            ASSIGN cResult = ryc_customization_result.customization_result_code.
        END.    /* avail customization type */
        ELSE
            ASSIGN cResult = "{&NO-RESULT-CODE}":U.
    END.    /* not NONE */
    ELSE
        ASSIGN cResult = "{&NO-RESULT-CODE}":U.

    ASSIGN pcResultCode = pcResultCode + (IF NUM-ENTRIES(pcResultCode) EQ 0 THEN "":U ELSE ",":U)
                        + cResult.
END.    /* reference loop. */

RETURN.
/* EOF */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


