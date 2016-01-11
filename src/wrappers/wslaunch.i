/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
  File: wslaunch.i

  Description: Invoke a Web service that is bound to a Dynamics session

  Purpose:     This include should be used to invoke a web service that is bound 
               to a Dynamics Session.
               

  Parameters: {&ServiceName}     Logical Web Service Name that is defined in Dynamics Repository
              {&ConnectParams}   Connection parameters  
                                 e.g "WSDLUserID nick -WSDLPassword new0327"
                                 e.g "WSDLUserID %DynUserID -WSDLPassword new0327"
              {&SubstituteList}  Substitute List for connection parameters 
                                 e.g if the connection parameters or the connection string specified in 
                                     Dynamics repository was like this -
                                 "-WSDLUser %WSDLUser -WSDLPassword %WSDLPassword" then 
                                     subsitute parm needs to be like this:
                                 "%WSDLUser" + CHR(3) + "5aaaaa" + CHR(1) + "%WSDLPassword" + CHR(3) + "5bbbbb"
              {&WSDisconnect}    Specifies whether to disconnect the Web Service after the call
                                 - By default if the service is already connected then it is not 
                                   disconnected and if the service was connected by this include 
                                   then it disconnects.
              {&PortType}        WebService Port Type name
              {&Operation}       WebService Operation Name    
              {&Plist}           Parameter list for operation innvocation specified in {&Operation}
              {&DefineVars}      YES = define the variables you need but take no other action
              {&WSRunError}      What to do when an error occurs when the {&Operation} cannot be found
                                 in the {&ServiceName}. 
              
                            
   RULES:
   1. Required logical arguments must be passed in unquoted as YES or NO. Other text
      arguments must be single quoted literals, e.g. 'text' or unquoted variables, 
      and if the literals require spaces, they should be double quoted then single
      quoted, e.g. "'text'".
   2. The only exception to the above rule is for the parameter list, which does not
      support a variable and so only double quotes must be used.

   Following use of the include file, the following variable values will be defined and available:
   lRunErrorStatus        Stored value of the ERROR-STATUS:ERROR after running an IP } needed when
   cErrorMessage          Error message text caused by an internal procedure failing to tun in the PLIP

   Example:
  
   DEFINE VARIABLE ctemp AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE czip AS CHARACTER  INITIAL "03060" NO-UNDO.
   DEFINE VARIABLE cPass AS CHARACTER  NO-UNDO.
   ASSIGN cPass = "%WSDLPassword" + CHR(3) + "5aaaaa".
  
   {wslaunch.i &ServiceName = 'Temp'
               &ConnectParams = "'-WSDLUser %DynUserId -WSDLPassword %WSDLPassword'"
               &SubstituteList = cPass
               &PortType = 'TemperaturePortType'
               &Operation = 'getTemp'
               &Plist = "(input czip, output ctemp)"
               &WSRunError = "MESSAGE lRunErrorStatus SKIP cErrorMessage"
               &WSDisconnect = YES}
  
   OR 
   
   {wslaunch.i &ServiceName = 'Temp'
               &PortType = 'TemperaturePortType'
               &Operation = 'getTemp'
               &Plist = "(input czip, output ctemp)"
               &WSRunError = "MESSAGE lRunErrorStatus SKIP cErrorMessage"}
               
               
  History:
  --------
  Created: 04/28/2004     Sunil S Belgaonkar

---------------------------------------------------------------------------*/
&SCOPED-DEFINE DefinedNow FALSE

&IF DEFINED(ServiceName) = 0 &THEN
  &SCOPED-DEFINE ServiceName ''     /* Default to no ServiceName */
&ENDIF
  
&IF DEFINED(ConnectParams) = 0 &THEN
  &SCOPED-DEFINE ConnectParams ''   /* Default to no Connection Parameters */
&ENDIF

&IF DEFINED(SubstituteList) = 0 &THEN
  &SCOPED-DEFINE SubstituteList ''  /* Default to no Substitution list */
&ENDIF

&IF DEFINED(PortType) = 0 &THEN
  &SCOPED-DEFINE PortType ''        /* Default to no PortType */
&ENDIF

&IF DEFINED(Operation) = 0 &THEN
  &SCOPED-DEFINE Operation ''       /* Default to no Operation */
&ENDIF

/* If no DefineVars is specified, then we want to define variables and run 
   else do what is specified in DefineVars */
&IF DEFINED(DefineVars) = 0 &THEN
  &SCOPED-DEFINE DefineVars TRUE  
  &SCOPED-DEFINE DefinedNow TRUE
&ENDIF


&IF {&DefineVars} = TRUE &THEN
  DEFINE VARIABLE hServiceHandle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cServiceHandle      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPortType           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lConnected          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lConnectedNow       AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE lRunErrorStatus     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cErrorMessage       AS CHARACTER NO-UNDO.
&ENDIF

/* Reset the DefineVars */
&IF {&DefinedNow} = TRUE &THEN
  &SCOPED-DEFINE DefineVars FALSE  /* Default to not merely defining variables */
&ENDIF

&IF {&DefineVars} = FALSE &THEN

  ASSIGN ERROR-STATUS:ERROR = NO
         lRunErrorStatus = FALSE 
         cErrorMessage   = ''.
  
  /* Validations */
  IF ({&ServiceName} = "":U ) THEN
    ASSIGN lRunErrorStatus = TRUE
           cErrorMessage   = "WebService Service Name must be specified".
  ELSE IF ({&PortType} = "":U) THEN
    ASSIGN lRunErrorStatus = TRUE
           cErrorMessage   = "WebService Port Type must be specified".
  ELSE IF ({&Operation} = "":U) THEN
      ASSIGN lRunErrorStatus = TRUE
             cErrorMessage   = "WebService Operation must be specified".

  /* If validations are successful, try to get Webservice handle */
  IF (NOT lRunErrorStatus) THEN
  DO:
    /* Check if already connected */
    ASSIGN hServiceHandle = ?
           lConnected     = DYNAMIC-FUNCTION('isConnected':U IN TARGET-PROCEDURE, 
                                              INPUT {&ServiceName}).
    IF (lConnected) THEN
      ASSIGN hServiceHandle = WIDGET-HANDLE(DYNAMIC-FUNCTION('getServiceHandle':U IN TARGET-PROCEDURE, INPUT {&ServiceName})) NO-ERROR.
    
    /* If not connected, connect now */
    IF NOT VALID-HANDLE(hServiceHandle) THEN
    DO:
      RUN connectServiceWithParams IN TARGET-PROCEDURE
         (INPUT {&ServiceName},
          INPUT {&ConnectParams},
          INPUT {&SubstituteList},
          OUTPUT cServiceHandle) NO-ERROR.

      IF ((NOT ERROR-STATUS:ERROR) AND (RETURN-VALUE = "":U)) THEN
        ASSIGN hServiceHandle = WIDGET-HANDLE(cServiceHandle).
    END.

    &IF DEFINED(WSDisconnect) = 0 &THEN
      &SCOPED-DEFINE WSDisconnect (NOT lConnected)
    &ENDIF

    /* Handle any errors */
    IF (ERROR-STATUS:ERROR OR NOT VALID-HANDLE(hServiceHandle) OR RETURN-VALUE > "":U) THEN
      ASSIGN lRunErrorStatus = TRUE
             cErrorMessage   = RETURN-VALUE.
  END.

  /* Set the PortType */
  IF (NOT lRunErrorStatus) THEN
  DO:
    RUN VALUE({&PortType}) SET hPortType ON SERVER hServiceHandle NO-ERROR.

    /* Handle any errors */
    IF (ERROR-STATUS:ERROR OR NOT VALID-HANDLE(hPortType)) THEN
      ASSIGN lRunErrorStatus = TRUE
             cErrorMessage   = ERROR-STATUS:GET-MESSAGE(1).
  END.
  
  /* Perform the operation */
  IF (NOT lRunErrorStatus) THEN 
  DO:
    RUN VALUE({&Operation}) IN hPortType {&Plist} NO-ERROR.

    /* Handle any errors */
    IF (ERROR-STATUS:ERROR) THEN
      ASSIGN lRunErrorStatus = TRUE
             cErrorMessage   = ERROR-STATUS:GET-MESSAGE(1).
  END.
  
  /* Irrespective of errors we want to delete the handle */
  IF VALID-HANDLE(hPortType) THEN
    DELETE PROCEDURE hPortType.

  /* Disconnect */
  IF (NOT lRunErrorStatus AND {&WSDisconnect} = TRUE) THEN
  DO:
    RUN DisconnectService IN TARGET-PROCEDURE (INPUT {&ServiceName}) NO-ERROR.

    /* Handle any errors */
    IF (ERROR-STATUS:ERROR OR RETURN-VALUE > "":U) THEN
      ASSIGN lRunErrorStatus = TRUE
             cErrorMessage   = 'Could not Disconnect the WebService'.
  END.
  
  /* If there are errors, do the specified */
  IF (lRunErrorStatus) THEN
  DO:
    &IF "{&WSRunError}":U <> "":U &THEN
      {&WSRunError}
      . 
    &ENDIF
  END.
&ENDIF

&IF DEFINED(WSRunError) <> 0 &THEN
  &UNDEFINE WSRunError
&ENDIF
&IF DEFINED(DefineVars) <> 0 &THEN
  &UNDEFINE DefineVars
&ENDIF
&IF DEFINED(DefinedNow) <> 0 &THEN
  &UNDEFINE DefinedNow
&ENDIF
