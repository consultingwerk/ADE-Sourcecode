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
                called to initialize it. The ADM2 procedure is left running after the 
                call is complete;
                
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
                
                phCallParmTT:
                (optional - pass ? if not used) The handle to a temp-table that could be 
                either of the temp-tables defined in adm2/calltables.i or a temp-table that 
                was previously created by a call to one of the setupTTFrom functions. 
                The output values from the call are written back into this table after 
                the call has been invoked. If this parameter is not specified, and there are 
                parameters to the procedure or function, the parameters have to be 
                specified in the phCallParmTH parameter.
                
                phCallParmTH:
                (optional - pass ? if not used) The same as phCallParmTT except that a 
                TABLE-HANDLE is passed to support AppServer calls. The table is passed 
                as an INPUT-OUTPUT parameter so that the return values can be returned 
                to the client.

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   03/15/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters */
DEFINE INPUT        PARAMETER pcCallName             AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcTarget               AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER pcTargetFlags          AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER phCallParmTT           AS HANDLE  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phCallParmTH.

/* The following create widget-pool is done to resolve the issue 4758. 
   If this widget-pool is not created, the ADMProps temp-table is not deleted 
   and this creates a memory leak */
CREATE WIDGET-POOL. 


/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       calltable.p
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/caller.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE hTT          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hProc        AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCallType    AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCallNo      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSignature   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lKill        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFail        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
DEFINE VARIABLE iTableType   AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTableHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE lTableHandle AS LOGICAL    NO-UNDO.

lFail = NO.
hProc = ?.
hTT = ?.
iTableType = 0.

/* Unless we find out otherwise, the call type has to be PROCEDURE. We
   can only be making a FUNCTION call type if we are calling into a
   handle */
iCallType = PROCEDURE-CALL-TYPE.


/* Figure out where we should be looking for the table. First look at the
   table-handle. If it is valid, then the table-handle is the right handle
   to use, otherwise we try and use the handle to the temp-table. */
IF VALID-HANDLE(phCallParmTH) THEN
  hTableHandle = phCallParmTH.
ELSE IF VALID-HANDLE(phCallParmTT) THEN
  hTableHandle = phCallParmTT.
ELSE 
  hTableHandle = ?.
  
IF hTableHandle <> ? THEN
DO:
  /* First we need to figure out if the table type that we have received in
     is one that the API recognizes. */
  iTableType = DYNAMIC-FUNCTION("determineTableType":U IN THIS-PROCEDURE,
                                hTableHandle).

  /* If the table type is unknown, we need to return an error */
  IF iTableType = ? THEN
    RETURN "Invalid Parameter Table":U.

END.

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

/* Now it's time to set up the temp-table. */
CASE iTableType:
  WHEN 1 OR
  WHEN 2 THEN
  DO:
    hTT = DYNAMIC-FUNCTION("setupTTFromTable":U IN THIS-PROCEDURE,
                           "calltable":U,
                           "":U,
                           hTableHandle).

    IF NOT VALID-HANDLE(hTT) THEN
      RETURN "Unable to create temp-table in setupTTFromTable".
  END.
  WHEN 3 OR
  WHEN 4 THEN
  DO:
    IF NOT VALID-HANDLE(hProc) THEN
      RETURN "No persistent procedure available for setupTTFromSig".

    hTT = DYNAMIC-FUNCTION("setupTTFromSig":U IN THIS-PROCEDURE,
                           hProc,
                           pcCallName,
                           "":U,
                           hTableHandle).

    IF NOT VALID-HANDLE(hTT) THEN
      RETURN "Unable to create temp-table in setupTTFromSig".
  END.
  WHEN 99 THEN   /* 99 means we got a pre-structured temp-table */
  DO:
    hTT = hTableHandle.
  END.
  WHEN 0  THEN  /* Set up a blank temp-table */
  DO:
    hTT = DYNAMIC-FUNCTION("setupTTFromString":U IN THIS-PROCEDURE,
                           "calltablett":U,
                           "":U,
                           "":U).
    IF NOT VALID-HANDLE(hTT) THEN
      RETURN "Unable to create temp-table in setupTTFromString".
  END.
END CASE.

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
  /* If the table type is between 1 and 4 we need to put the return values
     back in the table to return it. */
  IF iTableType > 0 AND
     iTableType < 5 THEN
    RUN setValuesInTable IN THIS-PROCEDURE
      (INPUT hTT,
       INPUT hTableHandle).

  cMessage = "":U.
  hTT:DEFAULT-BUFFER-HANDLE:FIND-FIRST().

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

/* We're done with the call at this point. Time to clean it up.
   If the user passed in type 99 table, we cannot let cleanupCall
   delete the table handle as we still have to pass it back to the
   client. */
RUN cleanupCall (iCallNo, (IF iTableType = 99 THEN "!T,*":U ELSE "*":U)).


/* Here we need to delete the input-output temp-table object, otherwise
   we cause a memory leak. This deletion is deferred until after the temp-table
   is on the wire. */
IF VALID-HANDLE(phCallParmTH) THEN
  DELETE OBJECT phCallParmTH.

IF VALID-HANDLE(ghAdmProps) THEN
    DELETE OBJECT ghAdmProps NO-ERROR.

IF cMessage = "":U THEN
  RETURN.
ELSE
  RETURN cMessage.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


