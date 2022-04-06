&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: rycusmngrp.i

  Description:  Customisation Manager Include

  Purpose:      Customisation Manager Include FIle. This file contians all of the code
                which defines the Customisation Manager (referenced by
                gshCustomizationManager) . Client and server-side code is separated by
                means of preprocessors in the relevant procedure.
                rycussrvrp.p: server side customisation manager
                rycusclntp.p: client-side customisation manager

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   04/22/2002  Author:     Peter Judge

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

{ src/adm2/globals.i }

DEFINE VARIABLE gcCustomisationTypesPrioritised     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE gcSessionResultCodes                AS CHARACTER                NO-UNDO.
DEFINE VARIABLE gcSessionCustomisationReferences    AS CHARACTER                NO-UNDO.

/* Defines the NO-RESULT-CODE and DEFAULT-RESULT-CODE result codes. */
{ ry/app/rydefrescd.i }

&SCOPED-DEFINE GET-REFERENCE-ON-SERVER <<REFERENCE-ON-SERVER>>
/* Needed to cache info */

DEFINE VARIABLE gcCacheCustTypesPrioritised AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCacheTypeAPI              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glTypeAPIcached             AS LOGICAL    NO-UNDO.

DEFINE VARIABLE gcCacheSessionCustRefs      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCacheSessionResultCodes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glResultsCached             AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClientResultCodes Include 
FUNCTION getClientResultCodes RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCustomisationTypesPrioritised Include 
FUNCTION getCustomisationTypesPrioritised RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceLanguage Include 
FUNCTION getReferenceLanguage RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceLoginCompany Include 
FUNCTION getReferenceLoginCompany RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceSystem Include 
FUNCTION getReferenceSystem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceUIType Include 
FUNCTION getReferenceUIType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceUser Include 
FUNCTION getReferenceUser RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getReferenceUserCategory Include 
FUNCTION getReferenceUserCategory RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionCustomisationReferences Include 
FUNCTION getSessionCustomisationReferences RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionResultCodes Include 
FUNCTION getSessionResultCodes RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
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
         HEIGHT             = 33.29
         WIDTH              = 72.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

RUN InitializeObject.

/* end of main block */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FetchCustomizationTypes Include 
PROCEDURE FetchCustomizationTypes :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve a comma delimited list of customization types
  Parameters:  INPUT plWithResultCode - If True then only return Customization Types
                                        that have at least one result code, otherwise
                                        return all Customization Types
               OUTPUT cCustomizationTypes - Comma delimited list of customization types
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plWithResultCode    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER cCustomizationTypes AS CHARACTER  NO-UNDO.

  &IF DEFINED(Server-Side) EQ 0 &THEN 
      /* We need to pass the request to the Appserver */
      RUN ry/app/rycusfchcsttypp.p ON gshAstraAppServer
        (INPUT plWithResultCode,
         OUTPUT cCustomizationTypes) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    /* Make a list of customization types */
    FOR EACH ryc_customization_type
             no-lock
             BY ryc_customization_type.customization_type_code:
      IF NOT plWithResultCode OR
        CAN-FIND(FIRST ryc_customization_result 
           WHERE ryc_customization_result.customization_type_obj = 
                 ryc_customization_type.customization_type_obj)
         THEN cCustomizationTypes = cCustomizationTypes + ",":U +
                               ryc_customization_type.customization_type_code.
    END.  /* For each ryc_customization_type */
    cCustomizationTypes = LEFT-TRIM(cCustomizationTypes,",":U).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_LoginComplete Include 
PROCEDURE ICFCFM_LoginComplete :
/*------------------------------------------------------------------------------
  Purpose:     Event procedure which is called when the login has completed. 
               Login must be complete so that we know what the current user, etc,
               are.
  Parameters:  <none>
  Notes:       * The ICFCFM_LoginComplete event is published from afxmlcfgp.p
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iTypeLoop           AS INTEGER                      NO-UNDO.
    DEFINE VARIABLE cReferenceCode      AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cTypeApi            AS CHARACTER                    NO-UNDO.

    DEFINE VARIABLE lSetResultCodeOnApp AS LOGICAL    NO-UNDO.

    /*-----------------------------------------------------------------------------------------  
     *  Set up this session's result codes, so that they are available to a caller.
     *  (i)   Get the customisation types associated with this session.
     *  (ii)  Get the names of the APIs which are used to determine the customization_reference
     *        which is in turn used to,
     *  (iii) Determine the applicable result codes.
     *
     *  We try to parcel off as much of this processing to the server as possible,
     *  although certain references must be determined on the client.
     *---------------------------------------------------------------------------------------*/
    /* (i) */    

    IF glTypeAPIcached = YES THEN
        ASSIGN gcCustomisationTypesPrioritised  = gcCacheCustTypesPrioritised
               cTypeAPI                         = gcCacheTypeAPI
               gcCacheCustTypesPrioritised      = "":U
               gcCacheTypeAPI                   = "":U
               gcSessionResultCodes             = "":U
               gcSessionCustomisationReferences = "":U
               glTypeAPIcached                  = NO.
    ELSE DO:
        /* Retrieve typeAPI from the Appserver */
        ASSIGN gcCustomisationTypesPrioritised  = DYNAMIC-FUNCTION("getSessionParam":U IN TARGET-PROCEDURE, INPUT "CustomizationTypePriority":U)
               gcSessionResultCodes             = "":U
               gcSessionCustomisationReferences = "":U.

        IF gcCustomisationTypesPrioritised EQ ? THEN
            ASSIGN gcCustomisationTypesPrioritised = "":U.

        RUN rycusfapip IN TARGET-PROCEDURE (INPUT gcCustomisationTypesPrioritised, OUTPUT cTypeAPI) NO-ERROR.
    END.

    /* (ii) */
    /* If we are on the client, we first get all of the client-side information that we can.
     * Information which can only be determined on the server will be marked as such, and
     * will be resolved on the server along with any other server-side processing.            */
    DO iTypeLoop = 1 TO NUM-ENTRIES(cTypeApi):
        ASSIGN cReferenceCode = "":U
               cReferenceCode = DYNAMIC-FUNCTION(ENTRY(iTypeLoop, cTypeApi) IN TARGET-PROCEDURE)
               NO-ERROR.

        /* Ensure that there's at least something */
        IF cReferenceCode EQ "":U OR cReferenceCode EQ ? THEN
            ASSIGN cReferenceCode = "{&DEFAULT-RESULT-CODE}":U.

        ASSIGN gcSessionCustomisationReferences = gcSessionCustomisationReferences + (IF NUM-ENTRIES(gcSessionCustomisationReferences) EQ 0 THEN "":U ELSE ",":U)
                                                + cReferenceCode.
    END.    /* loop through gcCustomisationTypesPrioritised */

    /* (iii) */
    /* When running Appserver, we've cached all this stuff already in cacheafter.p.  However, we did not have the cusomization references   *
     * when we did the upfront cache, and assumed they were going to be blank.  If we realise now that they are not blank for this session, *
     * rerun rycusrr2rp to get the correct result codes.                                                                                    */
    IF  glResultsCached = YES
    AND gcSessionCustomisationReferences = "":U THEN /* This is how the stuff was cached server side */ 
        ASSIGN gcSessionCustomisationReferences = gcCacheSessionCustRefs
               gcSessionResultCodes             = gcCacheSessionResultCodes
               glResultsCached                  = NO
               lSetResultCodeOnApp              = NO. /* It was done as part of the caching process */
    ELSE DO:
        /* Get any remaining references and turn those references into result codes. */
        RUN rycusrr2rp IN TARGET-PROCEDURE (INPUT        gcCustomisationTypesPrioritised,
                                            INPUT        cTypeApi,                                                   
                                            INPUT-OUTPUT gcSessionCustomisationReferences,
                                                  OUTPUT gcSessionResultCodes) NO-ERROR.
        ASSIGN lSetResultCodeOnApp = YES.
    END.

    /* If no customisation has been set up, return the DEFAULT code. */
    IF gcSessionResultCodes EQ "":U OR gcSessionResultCodes EQ ? THEN
        ASSIGN gcSessionResultCodes = "{&DEFAULT-RESULT-CODE}":U.

    RUN resolveResultCodes IN gshRepositoryManager ( INPUT NO,      /* plDesignMode */
                                                     INPUT-OUTPUT gcSessionResultCodes ) NO-ERROR.
    RUN setSessionResultCodes IN TARGET-PROCEDURE (INPUT gcSessionResultCodes,
                                                   INPUT lSetResultCodeOnApp). /* If the cache was not accurate, we want to reset the prop on the Appserver */
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject Include 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "ICFCFM_LoginComplete":U ANYWHERE.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PlipShutdown Include 
PROCEDURE PlipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* When shutting this down,. close off any super procedures. */
    IF NUM-ENTRIES(THIS-PROCEDURE:SUPER-PROCEDURES) NE 0 AND THIS-PROCEDURE:SUPER-PROCEDURES NE ? THEN
        RUN killPlips IN gshSessionManager ( INPUT "":U, INPUT REPLACE(THIS-PROCEDURE:SUPER-PROCEDURES, ",":U, CHR(3))) NO-ERROR.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheResultCodes Include 
PROCEDURE receiveCacheResultCodes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcCacheSessionCustRefs    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcCacheSessionResultCodes AS CHARACTER  NO-UNDO.

ASSIGN gcCacheSessionCustRefs    = pcCacheSessionCustRefs
       gcCacheSessionResultCodes = pcCacheSessionResultCodes
       glResultsCached           = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheTypeAPI Include 
PROCEDURE receiveCacheTypeAPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcCustomisationTypesPrioritised AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTypeAPI                       AS CHARACTER  NO-UNDO.

ASSIGN gcCacheCustTypesPrioritised = pcCustomisationTypesPrioritised
       gcCacheTypeAPI              = pcTypeAPI
       glTypeAPIcached             = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rycusfapip Include 
PROCEDURE rycusfapip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcCustomisationType             AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcAPIList                       AS CHARACTER            NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        /* We need to pass the request to the Appserver */
        RUN ry/app/rycusfapip.p ON gshAstraAppServer
          (INPUT pcCustomisationType,
           OUTPUT pcAPIList) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE VARIABLE iTypeLoop               AS INTEGER                  NO-UNDO.
        
        DO iTypeLoop = 1 TO NUM-ENTRIES(pcCustomisationType):
            FIND FIRST ryc_customization_type WHERE
                       ryc_customization_type.customization_type_code = ENTRY(iTypeLoop, pcCustomisationType)
                       NO-LOCK NO-ERROR.
            IF AVAILABLE ryc_customization_type THEN
                ASSIGN pcAPIList = pcAPIList + (IF NUM-ENTRIES(pcAPIList) EQ 0 THEN "":U ELSE ",":U)
                                + ryc_customization_type.API_name.
        END.    /* loop through customisation types */
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rycusrr2rp Include 
PROCEDURE rycusrr2rp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER pcCustomisationType       AS CHARACTER        NO-UNDO.
    DEFINE INPUT        PARAMETER pcCustomisationTypeAPI    AS CHARACTER        NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcReference               AS CHARACTER        NO-UNDO.
    DEFINE       OUTPUT PARAMETER pcResultCode              AS CHARACTER        NO-UNDO.

    &IF DEFINED(server-side) = 0 &THEN
        /* We need to pass the request to the Appserver */
        RUN ry/app/rycusrr2rp.p ON gshAstraAppServer
          (INPUT pcCustomisationType,   
           INPUT pcCustomisationTypeAPI,
           INPUT-OUTPUT pcReference,           
           OUTPUT pcResultCode) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    &ELSE
        DEFINE VARIABLE iReferenceLoop          AS INTEGER                  NO-UNDO.
        DEFINE VARIABLE cReference              AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE cResult                 AS CHARACTER                NO-UNDO.
        DEFINE VARIABLE hCustomizationManager   AS HANDLE                   NO-UNDO.
        
        DEFINE BUFFER rym_customization         FOR rym_customization.
        DEFINE BUFFER ryc_customization_type    FOR ryc_customization_type.
        DEFINE BUFFER ryc_customization_result  FOR ryc_customization_result.
        
        ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U IN TARGET-PROCEDURE, "CustomizationManager":U).
        
        REFERENCE-LOOP:
        DO iReferenceLoop = 1 TO NUM-ENTRIES(pcReference):
            ASSIGN cReference = ENTRY(iReferenceLoop, pcReference).
        
            /* Resolve any server-side references. */
            IF cReference = "{&GET-REFERENCE-ON-SERVER}":U THEN
            DO:
                ASSIGN cReference = "":U
                       cReference = DYNAMIC-FUNCTION(ENTRY(iReferenceLoop, pcCustomisationTypeAPI) IN TARGET-PROCEDURE)
                       NO-ERROR.
                /* Ensure that there's at least something */
                IF cReference EQ "":U OR cReference EQ ? THEN
                    ASSIGN cReference = "{&DEFAULT-RESULT-CODE}":U.
        
                /* Put this reference back into the string. */
                ENTRY(iReferenceLoop, pcReference) = cReference.
            END.    /* get reference on server */
        
            IF cReference NE "{&DEFAULT-RESULT-CODE}":U THEN
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
                    ASSIGN cResult = "{&DEFAULT-RESULT-CODE}":U.
            END.    /* not NONE */
            ELSE
                ASSIGN cResult = "{&DEFAULT-RESULT-CODE}":U.
        
            ASSIGN pcResultCode = pcResultCode + (IF NUM-ENTRIES(pcResultCode) EQ 0 THEN "":U ELSE ",":U)
                                + cResult.
        END.    /* reference loop. */
    &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setClientResultCodes Include 
PROCEDURE setClientResultCodes :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is used to set client result codes for the session.
               If we are on the Appserver, we will only set the 'clientSessionResultCodes'
               parameter for the session.  If we are on the client, we will
               set 'sessionResultCodes' in the session param table, and set the 
               'clientSessionResultCodes' session property.
  Parameters:  <none>
  Notes:       ipSetOnAppserver should always be YES.  The only situation where
               we would pass a NO would be where we've set it on the Appserver already,
               and we KNOW it's right.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcResultCodes    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plSetOnAppserver AS LOGICAL    NO-UNDO.

/* Always set the 'clientSessionResultCodes' property, regardless of where we are */

DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, 
                  INPUT "clientSessionResultCodes":U, 
                  INPUT pcResultCodes,
                  INPUT NOT plSetOnAppserver). /* Set for session only? */

/* If we're on the client, update the session param table with the new result codes */

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
THEN DO:
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE, INPUT "SessionResultCodes", INPUT pcResultCodes).
    ASSIGN gcSessionResultCodes = pcResultCodes.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSessionResultCodes Include 
PROCEDURE setSessionResultCodes :
/*------------------------------------------------------------------------------
  Purpose:     Set the result codes for the current session.  Note, if we're running
               on the client, we need to synch the Appserver as well.  To take care of
               this, we'll run setClientResultCodes.
  Parameters:  <none>
  Notes:       plUpdateAppserver only applies when running in a client session.  By
               default, it should be set to YES to ensure the Appserver is synched
               when the client result codes change.  However, if we have set the
               result codes on the Appserver already, and we KNOW they're in sync with
               what we're setting here, we can pass a NO to prevent an Appserver hit
               from happening.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcResultCodes     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plSetOnAppserver  AS LOGICAL    NO-UNDO.

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN /* we're on the client */
    RUN setClientResultCodes IN TARGET-PROCEDURE (INPUT pcResultCodes,
                                                  INPUT plSetOnAppserver).
ELSE DO:
    DYNAMIC-FUNCTION("setSessionParam":U IN TARGET-PROCEDURE, INPUT "SessionResultCodes", INPUT pcResultCodes).
    ASSIGN gcSessionResultCodes = pcResultCodes.
END.    

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClientResultCodes Include 
FUNCTION getClientResultCodes RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns result codes for client session.  When running Appserver,
            we'll retrieve the result codes for the currently connected client.
            When running client, we simply return the session result codes.
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN /* we're on the client */
      RETURN gcSessionResultCodes.
  ELSE
      RETURN DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                               INPUT "clientSessionResultCodes":U, 
                               INPUT NO). /* Session Only */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCustomisationTypesPrioritised Include 
FUNCTION getCustomisationTypesPrioritised RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the prioritised customisation types for this session.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN gcCustomisationTypesPrioritised.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceLanguage Include 
FUNCTION getReferenceLanguage RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the language.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager, "currentLanguageName", YES).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceLoginCompany Include 
FUNCTION getReferenceLoginCompany RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the login company.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager, "CurrentOrganisationCode", YES).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceSystem Include 
FUNCTION getReferenceSystem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the system.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN "DYNAMICS":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceUIType Include 
FUNCTION getReferenceUIType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the session (UI) type.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getPhysicalSessionType":U IN TARGET-PROCEDURE).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceUser Include 
FUNCTION getReferenceUser RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the user.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN DYNAMIC-FUNCTION("getPropertyList" IN gshSessionManager, "currentUserLogin", YES).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getReferenceUserCategory Include 
FUNCTION getReferenceUserCategory RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current reference for the user category.
    Notes:  * This information can only be retrieved from the server. If we are 
              running on the client, we need to inform the server that it should
              do the work.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cUserCategory           AS CHARACTER                NO-UNDO.
    &IF DEFINED(Server-Side) EQ 0 &THEN
    ASSIGN cUserCategory =  "{&GET-REFERENCE-ON-SERVER}":U.
    &ELSE
    DEFINE VARIABLE cUserLoginName              AS CHARACTER            NO-UNDO.
    DEFINE BUFFER gsm_user              FOR gsm_user.
    DEFINE BUFFER gsm_user_category     FOR gsm_user_category.
    ASSIGN cUserLoginName = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                             INPUT "currentUserLogin":U,
                                             INPUT YES).
    FIND FIRST gsm_user WHERE
               gsm_user.user_login_name = cUserLoginName
               NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_user THEN
        FIND FIRST gsm_user_category WHERE
                   gsm_user_category.user_category_obj = gsm_user.user_category_obj
                   NO-LOCK NO-ERROR.
    IF AVAILABLE gsm_user_category THEN
        ASSIGN cUserCategory = gsm_user_category.user_category_code.
    ELSE
        ASSIGN cUserCategory = "{&NO-RESULT-CODE}":U.
    &ENDIF
    
    RETURN cUserCategory.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionCustomisationReferences Include 
FUNCTION getSessionCustomisationReferences RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the sessionreferences.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN gcSessionCustomisationReferences.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionResultCodes Include 
FUNCTION getSessionResultCodes RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the result codes currently applicable for this session.
    Notes:  
------------------------------------------------------------------------------*/
    RETURN gcSessionResultCodes.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

