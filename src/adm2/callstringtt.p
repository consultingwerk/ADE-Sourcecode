&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*---------------------------------------------------------------------------------
  File: callstring.p

  Description:  Caller for string parameters

  Purpose:      Caller for string parameters

  Parameters:   pcCallName:
                The name of an external or internal procedure or function to be invoked.
                
                pcTarget:
                (optional - pass "" or ? if not used) The name of a manager procedure,
                the filename of a relatively or absolutely pathed procedure, or an integer
                value that evaluates to a procedure handle.
                If the value of this parameter is "" or ?, it is assumed that pcCallName
                contains the name of a procedure that is to be run non-persistently.
                
                pcTargetFlags:
                (optional - pass "" if not used) This parameter may be any combination 
                of P, A, S or K. The flags are only used to invoke the persistent 
                procedure defined in pcTarget.
                
                P(ersistent) - indicates that a new instance of the procedure should
                be instantiated persistently and left running;
                
                A(DM2) - indicates that a new instance of an ADM2 procedure should
                be invoked persistently and the initializeObject internal procedure
                called to initialize it. The ADM2 procedure is left running after the call is
                complete;
                
                S(ingle) - indicates that a new instance of the procedure should be
                instantiated if a running version is not found and left running; and
                
                K(ill) - indicates that if a procedure was instantiated during the call, it
                should be deleted before control is returned.
                
                The default value for this parameter (ie, if nothing is specified) is to 
                apply the behavior of the S parameter. In other words, a persistent procedure 
                will be started if it is not found by walking the procedure stack and it will 
                be left running after the call is complete.
                
                P and S are mutually exclusive.
                
                Any of P, A or S may be specified and combined with each other and K to have
                the procedure shut down. Thus PK instructs the caller to instantiate
                a new instance of the procedure persistently and delete it when it is
                complete. PAK results in the instantiation of a new instance of an ADM2
                procedure that should be deleted after the call is successful.
                
                pcCallParmString:
                (optional - pass "" or ? if not used) A string that contains the parameters
                to be passed to the procedure or function that is being invoked. The
                string is a comma-separated list of parameters. Each parameter is a
                string consisting of space-delimited values in the form "<mode>
                <datatype> <parameter>" where:
                
                <mode> is one of INPUT, OUTPUT, INPUT-OUTPUT or
                OUTPUT-APPEND.
                
                <datatype> is one of  CHARACTER, DATE, LOGICAL, INTEGER,
                DECIMAL, or HANDLE.
                
                <parameter> is the name of either a property that was previously set
                using setPropertyList or setSessionParam, or a single quoted constant.
                
                If a property is specified, the procedure will attempt to evaluate the
                property value by calling getPropertyList. If no property is available,
                or Dynamics is not running, a call is made to getSessionParam for
                the property value. If neither call succeeds, the unknown value is
                passed.If the mode of the parameter is either OUTPUT or
                INPUT-OUTPUT, the property that is specified will contain the output
                value from the call after the call is complete.
                
                pcHandlesToSkip:
                (optional - pass "" if not used) By default the call wrapper will do 
                a DELETE OBJECT on any tables that are listed in phCallTableHandle01 
                through 64 before returning. This avoids memory leaks caused by the 
                duplication of temp-tables. In some cases this behavior may be undesirable, 
                such as when the table being returned is a dynamic temp-table that should 
                be retained in the cache on the server. This parameter allows a 
                comma-separated list of numbers between 1 and 64 corresponding to the 
                handles below. If a number is found in the list, the corresponding handle 
                will not be deleted in the procedure prior to control returning to the 
                caller. As this is a CAN-DO list, an * would indicate that none of the 
                handles should be deleted.
                
                phCallTableHandle01 - 64:
                TABLE-HANDLE containing either a static or dynamic temp-table that
                was passed in from the client side.
                

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/15/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
/* The following create widget-pool is done to resolve the issue 4758. 
   If this widget-pool is not created, the ADMProps temp-table is not deleted 
   and this creates a memory leak */
CREATE WIDGET-POOL. 

/* ***************************  Definitions  ************************** */
{src/adm2/caller.i}

/* Parameters */
DEFINE INPUT  PARAMETER pcCallName       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTarget         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTargetFlags    AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcCallParmString AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcHandlesToSkip  AS CHARACTER  NO-UNDO.
{src/adm2/calltthdr.i}  /* TABLE-HANDLE definitions */



/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       callstringtt.p
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
         HEIGHT             = 25.1
         WIDTH              = 57.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hTT        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hProc      AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCallType  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCallNo    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSignature AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lKill      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFail      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMessage   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.

lFail = NO.
hProc = ?.

/* Unless we find out otherwise, the call type has to be PROCEDURE. We
   can only be making a FUNCTION call type if we are calling into a
   handle */
iCallType = PROCEDURE-CALL-TYPE.

/* Is there a target procedure that we need to run this in? If so,
   make sure that either it is running or we instantiate it. */
IF pcTarget <> "":U AND
   pcTarget <> ? THEN
DO:
  RUN setupCallProcedure IN THIS-PROCEDURE
    (pcCallName, 
     pcTarget, 
     pcTargetFlags,
     OUTPUT hProc, 
     OUTPUT lKill, 
     OUTPUT iCallType).

  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

END.

/* We need to get the call string converted into a temp-table. */
hTT = DYNAMIC-FUNCTION("setupTTFromString":U IN THIS-PROCEDURE,
                       "callstringtt":U,
                       "":U,
                       pcCallParmString).

IF hTT = ? THEN 
  RETURN "INVALID PARAMETER STRING":U.

/* The following call ensures that the temp-table handle is appropriately
   passed into the callee */
RUN mapArrayToBuffer (INPUT hTT).

/* At this point we have all we need to invoke the call. */
RUN invokeCall IN THIS-PROCEDURE
  (INPUT pcCallName,      /* call to be made */
   INPUT hProc,           /* handle to persistent procedure to call in */
   INPUT iCallType,       /* Call type */
   INPUT hTT,             /* Handle to parameters temp-table */
   INPUT NO,              /* Not to be invoked persistent */
   INPUT ?,               /* Handle to AppServer */
   INPUT NO,              /* Not asynch */
   INPUT "":U,            /* No asynch handler */
   INPUT ?,               /* No asynch handler context */
   OUTPUT iCallNo).       /* Call number */

/* Find the first record in the temp-table and check that the error value 
   was not set. */
hTT:DEFAULT-BUFFER-HANDLE:FIND-FIRST().
IF NOT hTT:DEFAULT-BUFFER-HANDLE:AVAILABLE OR
   (hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("errReturnValue":U):BUFFER-VALUE <> ? AND
    hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("errReturnValue":U):BUFFER-VALUE <> "":U) THEN
   cMessage = hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("errReturnValue":U):BUFFER-VALUE.
ELSE
DO:
  /* Now lets sort out the parameters that came back. setPropertiesFromTable
     moves the values of the properties into the session parameters or property
     lists, whatever is appropriate. */
  RUN setPropertiesFromTable IN THIS-PROCEDURE
    (INPUT hTT).

  RUN mapBufferToArray (INPUT hTT).
  
  cMessage = "":U.

  IF hTT:DEFAULT-BUFFER-HANDLE:AVAILABLE AND
     hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("callReturnValue":U):BUFFER-VALUE <> ? AND
     hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("callReturnValue":U):BUFFER-VALUE <> "":U THEN
   cMessage = hTT:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("callReturnValue":U):BUFFER-VALUE.

END.

/* If we don't need the target procedure, now's the time to whack it. */
IF lKill THEN
DO:
  APPLY "CLOSE":U TO hProc.
  IF VALID-HANDLE(hProc) THEN
    DYNAMIC-FUNCTION("killProc":U IN THIS-PROCEDURE,
                    INPUT hProc).
  IF VALID-HANDLE(hProc) THEN
    DELETE PROCEDURE hProc.
END.

/* We're done with the call at this point. Time to clean it up. */
RUN cleanupCall (iCallNo, "*":U).

{src/adm2/callttftr.i}

IF cMessage = "":U THEN
  RETURN.
ELSE
  RETURN cMessage.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


