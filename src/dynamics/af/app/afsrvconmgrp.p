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
  File: afsrvconmgrp.p

  Description:  Service Connection Manager Template

  Purpose:      Service Connection Manager Template.
                This procedure provides an example and a basis from which to build a
                service connection manager procedure. This program is not intended to
                run as is and requires modification to support a proper service.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000027   UserRef:    
                Date:   26/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

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

&scop object-name       afsrvconmgrp.p
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
  (INPUT pcParams AS CHARACTER )  FORWARD.

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

  DEFINE VARIABLE cConnectString        AS CHARACTER  NO-UNDO.

  /* TODO: Write the code that will connect a service to the session.
  
     Obtain the connection parameters as follows: */
  cConnectString = DYNAMIC-FUNCTION('getConnectionString':U IN THIS-PROCEDURE,
                                    INPUT pcServiceName ).
  /* With a database that could be as simple as
     CONNECT VALUE(cConnectString) NO-ERROR.
     
     With an AppServer, you need to create a server object and make the
     connection:
     CREATE SERVER hServer.
     hServer:CONNECT(cConnectString). 
     
     When you're done, make sure that you set the service handle field
     for the service record if applicable:
     DYNAMIC-FUNCTION('setServiceHandle':U IN THIS-PORCEDURE,
                      INPUT pcServiceName,
                      INPUT STRING(hServer)). */


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

  /* TODO: Write the code that will disconnect a service from the session.
  
     With a database that could be as simple as
     DISCONNECT VALUE(pcServiceName).
     
     With an AppServer, you need to obtain the handle to the server, disconnect
     the server and delete the server handle. 
     
     Make sure that you also set the handle to the ? value. 
      DYNAMIC-FUNCTION('setServiceHandle':U IN THIS-PORCEDURE,
                       INPUT pcServiceName,
                       INPUT ?). */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether the requested service type is connected.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns    AS LOGICAL    NO-UNDO.

  /* TODO: write some code that will determine whether a particular service
     has already been connected.
      
     With a database service type, this could be as easy as:
     lAns = CONNECTED(pcServiceName).
     
     With an AppServer, you will need to check the CONNECTED() method
     on the AppServer handle:
     hServer = WIDGET-HANDLE(DYNAMIC-FUNCTION('getServiceHandle':U IN THIS-PROCEDURE,
                                              INPUT pcServiceName)).
     IF VALID-HANDLE(hServer) THEN                                         
       lAns = hServer:CONNECTED().
     */

  RETURN lAns.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseConnectionParams Procedure 
FUNCTION parseConnectionParams RETURNS CHARACTER
  (INPUT pcParams AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Parses pcParams and returns the connection string.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString AS CHARACTER  NO-UNDO.

  /* TODO: Write some code that will take the contents of pcParams and 
     convert it to an appropriate connection parameter string */

  RETURN cConnectString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

