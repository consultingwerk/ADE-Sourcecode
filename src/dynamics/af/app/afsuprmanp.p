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
  File: afsuprmanp.p

  Description:  Manager Load As Super Procedure

  Purpose:      Manager Load As Super Procedure: this procedure will add the specified
                manager as a super procedure of this procedure. This allows us to run internal
                procedures in a manager procedure across the AppServer boundary, without
                having to restart the manager every time we run an IP.

  Parameters:

  History:
  --------
  (v:010000)    Task:        7547   UserRef:    
                Date:   17/01/2001  Author:     Peter Judge

  Update Notes: Created from Template rytemplipp.p

  (v:010001)    Task:        7704   UserRef:    
                Date:   24/01/2001  Author:     Peter Judge

  Update Notes: AF2/ Add new AstraGen Manager

  (v:010002)    Task:        7806   UserRef:    
                Date:   01/02/2001  Author:     Peter Judge

  Update Notes: AF2/BUG/ Manager Super Procedure:
                - getInternalEntries adds extra characters
                - call to getPeriodObj uses incorrect path

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsuprmanp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addSuperProcedure Procedure 
FUNCTION addSuperProcedure RETURNS LOGICAL
    ( INPUT phProcedure       AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntries Procedure 
FUNCTION getInternalEntries RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeAllExcept) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeAllExcept Procedure 
FUNCTION removeAllExcept RETURNS LOGICAL
  ( INPUT phProcedure       AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeSuperProcedure Procedure 
FUNCTION removeSuperProcedure RETURNS LOGICAL
    ( INPUT phProcedure       AS HANDLE )  FORWARD.

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
         HEIGHT             = 10.48
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ON CLOSE OF THIS-PROCEDURE
DO:
    DYNAMIC-FUNCTION("removeAllExcept":U, INPUT ?).

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    { ry/app/ryplipkill.i }

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAsSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAsSuperProcedure Procedure 
PROCEDURE setAsSuperProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Sets the given manager as  asuper procedure
  Parameters:  pcUseThisManager - a comma-delimited list of managers to work with.
               pcAction         - ADD, REMOVE, REPLACE
  Notes:       * ADD: all managers specified are added to this procedure's super
                      procedure stack
               * REMOVE: all managers specified are removed from this procedure's
                      super procedure stack
               * REPLACE: this works in one of 2 ways -
                      (i) if there is only one manager specified, remove all other
                          entries and add that manager, if it exists.
                      (ii) If there are 2 or more managers specified, the first entry
                          will in the list will be added, and the others removed.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcUseThisManager             AS CHARACTER    NO-UNDO.
    DEFINE INPUT PARAMETER pcAction                     AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE hManagerUsed            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iManagerLoop            AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cManagerName            AS CHARACTER                NO-UNDO.

    IF pcAction = "":U THEN
        ASSIGN pcAction = "ADD":U.

    DO iManagerLoop = 1 TO NUM-ENTRIES(pcUsethisManager):
        ASSIGN cManagerName = ENTRY(iManagerLoop, pcUseThisManager).
        ASSIGN hManagerUsed = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT cManagerName).

        IF NOT VALID-HANDLE(hManagerUsed) THEN
        CASE cManagerName:
            WHEN "FIN":U         THEN ASSIGN hManagerUsed = gshFinManager.
            WHEN "GEN":U         THEN ASSIGN hManagerUsed = gshGenManager.
            WHEN "SESSION":U     THEN ASSIGN hManagerUsed = gshSessionManager.
            WHEN "SECURITY":U    THEN ASSIGN hManagerUsed = gshSecurityManager.
            WHEN "PROFILE":U     THEN ASSIGN hManagerUsed = gshProfileManager.
            WHEN "REPOSITORY":U  THEN ASSIGN hManagerUsed = gshRepositoryManager.
            WHEN "TRANSLATION":U THEN ASSIGN hManagerUsed = gshTranslationManager.
            WHEN "WEB":U         THEN ASSIGN hManagerUsed = gshWebManager.
            WHEN "AGN":U         THEN ASSIGN hManagerUsed = gshAgnManager.
            OTHERWISE
            DO:
                ASSIGN hManagerUsed = SESSION:FIRST-PROCEDURE.

                PROCDURE-SEARCH-LOOP:
                DO WHILE VALID-HANDLE(hManagerUsed):
                    IF hManagerUsed:FILE-NAME EQ cManagerName                          OR
                       hManagerUsed:FILE-NAME EQ REPLACE(cManagerName, ".p":U, ".r":U) THEN
                        LEAVE PROCDURE-SEARCH-LOOP.
                    ASSIGN hManagerUsed = hManagerUsed:NEXT-SIBLING.
                END.    /* PROCDURE-SEARCH-LOOP: walk the proceduretry */

                /* If there is a valid handle, check that the file-name matches that
                 * which we're searching. If not, set the handle to an invalid value. */
                IF VALID-HANDLE(hManagerUsed)                                      AND
                   hManagerUsed:FILE-NAME NE cManagerName                          AND
                   hManagerUsed:FILE-NAME NE REPLACE(cManagerName, ".p":U, ".r":U) THEN
                    ASSIGN hManagerUsed = ?.
            END.    /* otherwise */
        END CASE.   /* use this manager */

        IF VALID-HANDLE(hManagerUsed) THEN
        CASE pcAction:
            WHEN "ADD":U     THEN DYNAMIC-FUNCTION("addSuperProcedure":U,    INPUT hManagerUsed).
            WHEN "REMOVE":U  THEN DYNAMIC-FUNCTION("removeSuperProcedure":U, INPUT hManagerUsed).
            WHEN "REPLACE":U THEN
            DO:
                IF iManagerLoop EQ 1 THEN
                DO:
                    /* If there is only one entry in the list, remove all other
                     * entries and add that manager, if it exists.
                     * If there are 2 or more managers specified, the first entry
                     * will in the list will be added, and the others removed.
                     * ---------------------------------------------------------- */
                    IF NUM-ENTRIES(pcUseThisManager) > 1 THEN
                        DYNAMIC-FUNCTION("addSuperProcedure":U, INPUT hManagerUsed).
                    ELSE
                        DYNAMIC-FUNCTION("removeAllExcept":U, INPUT hManagerUsed).
                END.    /* first interation */
                ELSE
                    DYNAMIC-FUNCTION("removeSuperProcedure":U, INPUT hManagerUsed).
            END.    /* replace */
        END CASE.   /* action */
    END.    /* loop through manager list */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addSuperProcedure Procedure 
FUNCTION addSuperProcedure RETURNS LOGICAL
    ( INPUT phProcedure       AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds the specified procedure to this procedure's super procedure stack.
    Notes:  
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(phProcedure)                                         AND
        LOOKUP(STRING(phProcedure), THIS-PROCEDURE:SUPER-PROCEDURES) = 0 THEN
        THIS-PROCEDURE:ADD-SUPER-PROCEDURE(phProcedure).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntries) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntries Procedure 
FUNCTION getInternalEntries RETURNS CHARACTER:
/*------------------------------------------------------------------------------
  Purpose:  Returns the internal entries of this procedure, and of all super
            procedures running.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iProcedureLoop              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hSuperProcedure             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSuperProcedures            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cInternalEntries            AS CHARACTER            NO-UNDO.

    ASSIGN cInternalEntries = THIS-PROCEDURE:INTERNAL-ENTRIES
           cSuperProcedures = THIS-PROCEDURE:SUPER-PROCEDURES
           .
    DO iProcedureLoop = 1 TO NUM-ENTRIES(cSuperProcedures):
        ASSIGN hSuperProcedure = WIDGET-HANDLE(ENTRY(iProcedureLoop, cSuperProcedures)) NO-ERROR.
        IF VALID-HANDLE(hSuperProcedure) THEN
            ASSIGN cInternalEntries = cInternalEntries + MIN(",":U, cInternalEntries) + hSuperProcedure:INTERNAL-ENTRIES.
    END.    /* loop through super procedures */

    RETURN cInternalEntries.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeAllExcept) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeAllExcept Procedure 
FUNCTION removeAllExcept RETURNS LOGICAL
  ( INPUT phProcedure       AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Removes all super procedures from this procedures super procedure
            stack except the procedure specified. Will remove all procedures if
            the procedure handle is invalid.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iProcedureLoop              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE hSuperProcedure             AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cSuperProcedures            AS CHARACTER            NO-UNDO.

    ASSIGN cSuperProcedures = THIS-PROCEDURE:SUPER-PROCEDURES.

    DO iProcedureLoop = 1 TO NUM-ENTRIES(cSuperProcedures):
        ASSIGN hSuperProcedure = WIDGET-HANDLE(ENTRY(iProcedureLoop, cSuperProcedures)) NO-ERROR.

        IF phProcedure <> hSuperProcedure THEN
            DYNAMIC-FUNCTION("removeSuperProcedure":U, INPUT hSuperProcedure).
    END.    /* loop through super procedures */

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeSuperProcedure Procedure 
FUNCTION removeSuperProcedure RETURNS LOGICAL
    ( INPUT phProcedure       AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Deletes the specified procedure from this procedures super procedure
            stack.
    Notes:  
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(phProcedure)                                        AND
       LOOKUP(STRING(phProcedure), THIS-PROCEDURE:SUPER-PROCEDURES) > 0 THEN
        THIS-PROCEDURE:REMOVE-SUPER-PROCEDURE(phProcedure).

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

