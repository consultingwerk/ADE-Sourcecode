/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
  File: aflaunch.i

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

   Following use of the include file, the following variable values will be defined and available:
   hPlip                  Handle of plip run
   lRunErrorStatus        Stored value of the ERROR-STATUS:ERROR after running an IP } needed when
   cRunReturnValue        Stored value of the RETURN-VALUE after running an IP       } AutoKill is YES
   cErrorMessage          Error message text caused by an internal procedure failing to tun in the PLIP

   If the run failed for any reason, the handle will be invalid and any errors
   will have been displayed if possible.

  History:
  --------
  (v:010000)    Task:    90000133   UserRef:    
                Date:   05/11/2001  Author:     Bruce Gruenbaum

---------------------------------------------------------------------------*/
 &IF DEFINED(PLIP) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&PLIP}
  &SCOPED-DEFINE PLIP {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(IProc) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&IProc}
  &SCOPED-DEFINE IProc {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(OnApp) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&OnApp}
  &SCOPED-DEFINE OnApp {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(PList) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&PList}
  &SCOPED-DEFINE PList {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(AutoKill) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&AutoKill}
  &SCOPED-DEFINE AutoKill {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(Partition) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&Partition}
  &SCOPED-DEFINE Partition {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(Perm) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&Perm}
  &SCOPED-DEFINE Perm {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(AutoKillOnError) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&AutoKillOnError}
  &SCOPED-DEFINE AutoKillOnError {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(NewInstance) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&NewInstance}
  &SCOPED-DEFINE NewInstance {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(define-only) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&define-only}
  &SCOPED-DEFINE define-only {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF
&IF DEFINED(PlipRunError) <> 0 &THEN
  &SCOPED-DEFINE AFWRK {&PlipRunError}
  &SCOPED-DEFINE PlipRunError {&AFWRK}
  &UNDEFINE AFWRK
&ENDIF

{launch.i}
