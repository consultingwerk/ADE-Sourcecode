/* aficfcheck.i
   This piece of code defines the lICFRunning variable and checks to see 
   if ICF is running. The variable is always set to either YES or NO. */
  
&IF DEFINED(NO_VARIABLE_DEF) = 0 &THEN
  DEFINE VARIABLE lICFRunning    AS LOGICAL    NO-UNDO.
&ENDIF

  /* Figure out if ICF is running. We need to know this for all the error
     message returns. */
  lICFRunning = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  IF lICFRunning = ? THEN /* Configuration File Manager has not been started */
    lICFRunning = NO.
