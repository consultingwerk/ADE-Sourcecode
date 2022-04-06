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
  File: afdbconmgrp.p

  Description:  Database Service Type Manager

  Purpose:      Database Service Type Manager
                This procedure is the service type manager for Databases.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/22/2001  Author:     

  Update Notes: Created from Template afsrvconmgrp.p

  (v:010001)    Task:    90000132   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: fixes

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afdbconmgrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

/* Connection Manager specific Preprocessors */
/* TODO: Modify the following preprocessors for your Service Type */
&SCOPED-DEFINE ServiceType    Database
&SCOPED-DEFINE RequiresHandle NO
/* &SCOPED-DEFINE ServiceTypeFields */
/* &SCOPED-DEFINE ServiceTypeIndexes */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getConnectionString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getConnectionString Procedure 
FUNCTION getConnectionString RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseConnectionParams Procedure 
FUNCTION parseConnectionParams RETURNS CHARACTER
  ( INPUT pcParams AS CHARACTER )  FORWARD.

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
         HEIGHT             = 14.52
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{af/sup2/afsrvtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ON "CLOSE":U OF THIS-PROCEDURE
DO :
  RUN plipShutdown.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-connectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectService Procedure 
PROCEDURE connectService :
/*------------------------------------------------------------------------------
  Purpose:     Connects a physical service for a given service name
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle      AS CHARACTER  NO-UNDO.
  
  RUN connectServiceWithParams( INPUT pcServiceName, 
                                INPUT "":U, 
                                INPUT "":U, 
                                OUTPUT pchandle).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectServiceWithParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectServiceWithParams Procedure 
PROCEDURE connectServiceWithParams :
/*------------------------------------------------------------------------------
  Purpose:     Connects a physical service for a given service name
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
               
               Retrives the connection string and appends anything in the 
               parameter list to the end of the connection string. It then invokes 
               substituteParam to substitute arguments in the connection string 
               with values from the substitution list.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParameterList    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSubstitutionList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal               AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cConnectString        AS CHARACTER  NO-UNDO.
    
  /* If the database is connected, don't go any further. 
     The user should have called isConnected() before trying to connect
     the database again. */
  IF isConnected(pcServiceName) THEN
    RETURN.
    
  /* We need to know if ICF is running for the ERROR conditions. */
  {aficfcheck.i}
    
  /* Obtain the connection parameters to the service */
  cConnectString = DYNAMIC-FUNCTION('getConnectionString':U IN THIS-PROCEDURE,
                                    INPUT pcServiceName ).
    
  /* Now append the parameter list to the connection string */
  IF ( pcParameterList > "":U ) THEN
    ASSIGN cConnectString = cConnectString + " ":U + pcParameterList.

  /* Now invoke the substitute param to substitute list */
  RUN substituteParams IN TARGET-PROCEDURE (INPUT cConnectString, 
                       INPUT pcSubstitutionList,
                       OUTPUT cConnectString).
    
  /* Now try and connect the databases using the string. */
  ERROR-STATUS:ERROR = NO.
  CONNECT VALUE(cConnectString) NO-ERROR.
    
  /* If there are errors, get the error list */
  IF ERROR-STATUS:ERROR OR
     ERROR-STATUS:NUM-MESSAGES > 0 THEN
  DO:
    cRetVal = DYNAMIC-FUNCTION("buildErrorList":U IN THIS-PROCEDURE).
    RETURN cRetVal.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disconnectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectService Procedure 
PROCEDURE disconnectService :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for disconnecting a
               physical service.
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal               AS CHARACTER  NO-UNDO.

  IF NOT isConnected(pcServiceName) THEN
    RETURN. 

  /* We need to know if ICF is running for the ERROR conditions. */
  {aficfcheck.i}
  
  /* Disconnect the database */
  DISCONNECT VALUE(pcServiceName) NO-ERROR.

  /* If there are errors, get the error list */
  IF ERROR-STATUS:ERROR OR
     ERROR-STATUS:NUM-MESSAGES > 0 THEN
  DO:
    cRetVal = DYNAMIC-FUNCTION("buildErrorList":U IN THIS-PROCEDURE).
    RETURN cRetVal.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttService FOR ttService.

  FOR EACH bttService:
    RUN disconnectService(bttService.cServiceName).
  END.

  DELETE OBJECT THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getConnectionString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConnectionString Procedure 
FUNCTION getConnectionString RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override. We need to make sure that the string has a -ld.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  cConnectString = SUPER( INPUT pcServiceName ).

  iEntry = LOOKUP("-ld":U, cConnectString, " ":U).

  IF iEntry = 0 THEN /* There is no -ld defined in the string */
    cConnectString = cConnectString + " -ld ":U + pcServiceName.

  RETURN cConnectString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether the requested service type is connected.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns    AS LOGICAL    NO-UNDO.

  /* Check if the database is connected */
  lAns = CONNECTED(pcServiceName).
     
  RETURN lAns.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseConnectionParams Procedure 
FUNCTION parseConnectionParams RETURNS CHARACTER
  ( INPUT pcParams AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Parses pcParams and returns the connection string.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString AS CHARACTER  NO-UNDO.

  /* At this stage, the database does not need any special connection parsing
     done. */
  cConnectString = pcParams.

  RETURN cConnectString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

