/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
  File: launch.i

  Description: Run business logic persistent include

  Purpose:     This include will be used to run any persistent business logic
               procedures (PLIPs) instead of the progress run statement.
               This include wraps the original Astra include
               af/sup2/afrun2.i which encapsulates calls to launchProcedure 
               in the Session Manager and physically does the run of the 
               internal procedure if specified.

  Parameters: {&PLIP}            Physical procedure (PLIP) name, e.g. 'ac/app/actaxplipp.p'
              {&IProc}           Internal procedure name, e.g. 'calculateTax' or
                                 left undefined to just actually start the PLIP
              {&PList}           Parameter List, e.g. "(INPUT cTaxCode, INPUT tDate, INPUT dCalcAmount, OUTPUT cTaxAmount)"
                                 or left undefined for no parameters
              {&OnApp}           Run on Appserver flag 'YES', 'NO', or 'APPSERVER', default = 'YES'
              {&Partition}       Appserver partition, Astra = default, e.g. 'Astra'
              {&Perm}            Run permanently YES/NO, default = NO (do not let agent kill it)
              {&AutoKill}        Auto kill plip after run YES/NO, default = NO
              {&NewInstance}     New instance YES/NO, default = NO (use running instance if any)
              {&Define-only}     YES = define the variables you need but take no other action
              {&AutoKillOnError} Auto kill plip if error occurs when running YES/NO, default = NO.
                                 If AutoKill is YES, this value will automatically be YES.             
              {&PlipRunError}    What to do when an error occurs when the {&IProc} cannot be found
                                 in the {&PLIP}. The following default behaviour occurs when this
                                 parameter is left blank: when running on a client side connection,
                                 the error is messaged, but not when running server side. 
                                 This parameter must contain all of the required logic needed when
                                 the above error occurs, since it is all that executes.
              {&dynCall}         Run using dynamic call wrapper.  Note this option can only be selected
                                 when running Appserver (&OnApp) = YES, and when {&AutoKill} = YES.  Note when
                                 running like this, parameters are not specified using {&PList}, but are specified
                                 individually, using {&mode1} {&parm1} {&dataType1} {&mode2} {&parm2} {&dataType2}...etc
                                 
              {&mode1} - {&mode64}          When running using dynamic call wrapper, parameter 1 -> 64 mode : INPUT INPUT-OUTPUT or OUTPUT
              {&parm1} - {&parm64}          When running using dynamic call wrapper, the name of the variable or field storing parameter 1 -> 64.
                                            When passing constants, put in single quotes, example 'Pass this string in'.
              {&dataType1} - {&dataType64}  When running using dynamic call wrapper, the data type for parameter 1 -> 64 : BUFFER TABLE-HANDLE CHARACTER DECIMAL etc...
                            
   RULES:
   1. Required logical arguments must be passed in unquoted as YES or NO. Other text
      arguments must be single quoted literals, e.g. 'text' or unquoted variables, 
      and if the literals require spaces, they should be double quoted then single
      quoted, e.g. "'text'".
   2. The only exception to the above rule is for the parameter list, which does not
      support a variable and so only double quotes must be used.
   3. The internal procedure may be ommitted if required so the developer can manually run
      procedures in the PLIP and the PLIP is handle is simply made available in hPlip.
   4. If the onApp parameter is not specified it will default to 'YES' which will run on
      Appserver if Appserver connected, otherwise run locally. Passing in 'APPSERVER' will
      cause the procedure to fail if the appserver is not connected.
   5. If the OnApp parameter is not NO, then a partition may be specified and will be connected
      if not already connected. If no partition is specified it will default to the 'Astra'
      Appserver partition and will run on the gshAstraAppserver handle.
   6. If the Perm parameter is passed in as YES, then the procedure will not be killed when the
      agent disconnects, leaving it running for other connections. This is not the norm.
   7. If AutoKill is set to YES, then following the run of the internal procedure in the persistent
      procedure, the PLIP will be automatically closed. This is useful when running routines on 
      Appserver to ensure the connection does not remain bound.      
   8. If NewInstance is set to YES, then it will not check for an already running instance of the
      PLIP to use and will simply run a new version.
   9. If AutoKill is set to YES, and an error occurs when attempting to run an IP in the procedure,
      the procedure will be automatically closed, for the reasons specified in (7) above.
  10. The dynamic call wrapper can only be used when running on the Appserver, and &autokill has been set to yes.
      In other cases, the persistent procedure handle needs to be available after call has been invoked, which is not
      going to be true in this case.  When using the dynamic call wrapper, specify your parameters as follows:
      &mode1 = INPUT  &parm1 = cCharVarName &dataType1 = CHARACTER
      &mode2 = OUTPUT &parm2 = hTableHandle &dataType2 = TABLE-HANDLE etc.
  
   Following use of the include file, the following variable values will be defined and available:
   hPlip                  Handle of plip run
   lRunErrorStatus        Stored value of the ERROR-STATUS:ERROR after running an IP } needed when
   cRunReturnValue        Stored value of the RETURN-VALUE after running an IP       } AutoKill is YES
   cErrorMessage          Error message text caused by an internal procedure failing to tun in the PLIP

   If the run failed for any reason, the handle will be invalid and any errors
   will have been displayed if possible.

  History:
  --------
  Created: 11/08/2001     Mark Davies (MIP)
           Combined ICF/Dynamics afrun2.i and aflaunch.i

  (v:010001)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED".

---------------------------------------------------------------------------*/
/* Set-up defaults */
&IF DEFINED(OnApp) = 0 &THEN
  &SCOPED-DEFINE OnApp 'YES'        /* Default to run on Appserver if can */
&ENDIF
&IF DEFINED(Partition) = 0 AND {&OnApp} <> "NO" &THEN
  &SCOPED-DEFINE Partition 'Astra'  /* Default to Astra Appserver partition */
&ENDIF
&IF DEFINED(Partition) = 0 AND {&OnApp} = "NO" &THEN
  &SCOPED-DEFINE Partition ''       /* Default to no partition */
&ENDIF
&IF DEFINED(Perm) = 0 &THEN
  &SCOPED-DEFINE Perm NO            /* Default to not permanent */
&ENDIF
&IF DEFINED(AutoKill) = 0 &THEN
  &SCOPED-DEFINE AutoKill NO        /* Default to not killed automatically */
&ENDIF
&IF DEFINED(AutoKillOnError) = 0 &THEN
&IF {&AutoKill} = YES &THEN
    &SCOPED-DEFINE AutoKillOnError YES
&ELSE
    &SCOPED-DEFINE AutoKillOnError NO
&ENDIF
&ENDIF
&IF DEFINED(NewInstance) = 0 &THEN
  &SCOPED-DEFINE NewInstance NO     /* Default to new instance */
&ENDIF
&IF DEFINED(define-only) = 0 &THEN
  &SCOPED-DEFINE define-only FALSE  /* Default to not merely defining variables */
&ENDIF

&IF DEFINED(afrun2-variables) = 0 &THEN
    DEFINE VARIABLE lRunErrorStatus     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cRunReturnValue     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE hPlip               AS HANDLE    NO-UNDO.
    DEFINE VARIABLE cErrorMessage       AS CHARACTER NO-UNDO.

    &GLOBAL-DEFINE afrun2-variables YES
&ENDIF

&IF NOT {&define-only} &THEN

    /* Ensure handle is invalid to start with. */
    ASSIGN hPlip = ?.

    IF VALID-HANDLE(gshSessionManager) THEN
      RUN launchProcedure IN gshSessionManager (INPUT  {&PLIP},
                                                INPUT  NOT {&NewInstance},
                                                INPUT  {&OnApp},
                                                INPUT  {&Partition},
                                                INPUT  {&Perm},
                                                OUTPUT hPlip).

    /* Report an error if the PLIP failed to start (or we couldn't get it's handle)
     * or if the IP we specified doesn't exist in the PLIP.
     *
     * Use getInternalEntryExists function because the PLIP may be running on the
     * AppServer, in which case the :INTERNAL-ENTRIES attribute will be ?.
     * ----------------------------------------------------------------------- */
    IF NOT VALID-HANDLE(hPlip) OR
        {&IProc} <> "":U      THEN
    DO:
      IF VALID-HANDLE(gshSessionManager) AND 
         DYNAMIC-FUNCTION("getInternalEntryExists":U IN gshSessionManager, hPlip, {&IProc}) = NO THEN DO:
        /* Always kill the PLIP when autokill specified, otherwise the agent will remain bound. */
        IF ({&AutoKillOnError} = YES OR {&AutoKill} = YES) AND
           VALID-HANDLE(gshSessionManager) THEN
            RUN killPlips IN gshSessionManager (INPUT "":U, INPUT STRING(hPlip)).

        ASSIGN hPlip         = ?
               cErrorMessage = "Could not run procedure in PLIP specified. ":U 
                             + "The PLIP " + {&PLIP} + " could not be run.":U
               .
        /* We allow for the error generated to be passed back to a calling procedure.
         * We may (should) want to do this if the procedure we are running the PLIP
         * from is also running on the AppServer partition. If we don't specify this
         * parameter, the message will merely be written into the AppServer log, and
         * we will not know that it occurred.
         *
         * showWarningMessages is used in place of showMessages because the former
         * doesn't have an input blocking statement in it. The input blocking statment
         * causes problems when afrun2.i is run from a function.
         * ----------------------------------------------------------------------- */
        &IF "{&PlipRunError}":U <> "":U &THEN
        {&PlipRunError}
        . /* This full stop is here in case anyone forgets to put one in. */
        &ELSE
        IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND VALID-HANDLE(gshSessionManager) THEN
            RUN showWarningMessages IN gshSessionManager (INPUT cErrorMessage,
                                                          INPUT "ERR":U,
                                                          INPUT "Business Logic Run (afrun2.i)").
        &ENDIF
      END.
    END.    /* Can't run */

    IF VALID-HANDLE(hPlip) AND {&IProc} <> "":U THEN
    DO:
        ASSIGN lRunErrorStatus = FALSE
               cRunReturnValue = "":U.

        DO ON STOP UNDO, LEAVE:
            RUN VALUE({&IProc}) IN hPlip {&PList} NO-ERROR.
        END.

        /* This stores the ERROR-STATUS and RETURN-VALUE resulting from the run statement */
        ASSIGN lRunErrorStatus = ERROR-STATUS:ERROR
               cRunReturnValue = TRIM(RETURN-VALUE)
               .

        /*Fix for OE00025321. We set the error-status:error value in a flag, but the error message is never saved,
          so the error message will be overriden by the error message returned by killplip.
          If killplips does not fail, we have error-status:error = yes, but the error message is lost. So now we
          store the error message in a variable.*/
        IF lRunErrorStatus AND cRunReturnValue = "" THEN
            ASSIGN cRunReturnValue = ERROR-STATUS:GET-MESSAGE(1).

        IF {&AutoKill} = YES AND VALID-HANDLE(gshSessionManager) THEN
            RUN killPlips IN gshSessionManager (INPUT "":U, STRING(hPlip)).

        /* The Autokill raises the ERROR-STATUS and clears the RETURN-VALUE. Set them again so that they are
         * available to the procedure or function that used afrun2
         * If killPlip raised ERROR-STATUS, but RUN VALUE() didn't, don't clear ERROR-STATUS, i.e.
         * ------------------------------------------------------------------------------------------------- */
        IF ERROR-STATUS:ERROR = FALSE THEN
            ASSIGN ERROR-STATUS:ERROR = lRunErrorStatus.

        /* This will override the RETURN-VALUE of killPlip (if it had any), with RETURN-VALUE of RUN VALUE() Statement */
        IF cRunReturnValue <> "":U AND VALID-HANDLE(gshSessionManager) THEN
            RUN setReturnValue IN gshSessionManager(INPUT cRunReturnValue).
    END.    /* PLIP valid &  */
&ENDIF /* NOT define-only */

&IF DEFINED(PlipRunError) <> 0 &THEN
  &UNDEFINE PlipRunError
&ENDIF
&IF DEFINED(define-only) <> 0 &THEN
  &UNDEFINE define-only
&ENDIF
&IF DEFINED(NewInstance) <> 0 &THEN
  &UNDEFINE NewInstance
&ENDIF
&IF DEFINED(AutoKillOnError) <> 0 &THEN
  &UNDEFINE AutoKillOnError
&ENDIF
&IF DEFINED(Perm) <> 0 &THEN
&UNDEFINE Perm
&ENDIF
&IF DEFINED(Partition) <> 0 &THEN
&UNDEFINE Partition
&ENDIF
&IF DEFINED(PLIP) <> 0 &THEN
&UNDEFINE PLIP
&ENDIF
&IF DEFINED(IProc) <> 0 &THEN
&UNDEFINE IProc
&ENDIF
&IF DEFINED(OnApp) <> 0 &THEN
&UNDEFINE OnApp
&ENDIF
&IF DEFINED(PList) <> 0 &THEN
&UNDEFINE PList
&ENDIF
&IF DEFINED(AutoKill) <> 0 &THEN
&UNDEFINE AutoKill
&ENDIF
