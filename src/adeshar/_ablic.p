/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure: _ablic.p
    Purpose:   Returns AppBuilder license information.
    Syntax :   RUN adecomm/_ablic.p (INPUT ShowMsgs, OUTPUT ABLic, OUTPUT ABTools).
               
    Parameters:

        ShowMsgs - Yes: procedure displays messages.
                    No: procedure doesn't display messages.
                        
        ABLic    - = 1 when C/S AppBuilder only
                   = 2 when Webspeed AppBuilder only
                   = 3 when Both
                   
                   Note: A license for Enable-ICF extends the existing
                   license AppBuilder or Workshop product and is not
                   itself currently handled as a product. Thus the
                   Enable-ICF license has no affect on the value of ABLic.
                 
        ABTools  - Comma-delimited list that indicates the tool products
                   enabled for the session. The list contains one or more of
                   the following strings:
                   
                   UIB - Product is enabled for C/S AppBuilder
                   Workshop - Product is enabled for WebSpeed Workshop
                   Enable-ICF - Product is enabled for ICF AppBuilder
                   
    Author :   Gerry Seidl
    Date   :   04/01/98

    Modified:  11/15/01 jep-icf - Removed formal ICF get-license check and
                                  re-enabled WebSpeed Workshop. IZ 2845.
    Modified:  09/24/01 jep-icf - Enabled check on dyn function IsICFRunning.
    Modified:  08/19/01 jep-icf - ICF support of Enable-ICF license checking.
    Modified:  10/29/98 jep - Added ShowMsgs parameter and coding.
**************************************************************************/
DEFINE INPUT  PARAMETER ShowMsgs AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER ABLic    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER ABTools  AS CHARACTER NO-UNDO.

/* Include the file extensions and application names file. */
{adecomm/adefext.i}

DEFINE VARIABLE i-UIB-license AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-WS-license  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-ICF-license AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lFound-ICFDir AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lIsICFRunning AS LOGICAL    NO-UNDO.

ASSIGN i-UIB-license = GET-LICENSE ("UIB":U)
       i-WS-license  = GET-LICENSE ("Workshop":U).
       
/* Currently there is no GET-LICENSE checking for ICF. We simply
   determine if the framework is active and running by checking to see
   if the session IsICFRunning dynamic function returns Yes. If it does,
   we are in the ICF environment and we enable ICF. If return value
   from session function call isn't = YES, then ICF isn't running. */
ASSIGN lIsICFRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
ASSIGN lIsICFRunning = (lIsICFRunning = YES) NO-ERROR.
ASSIGN i-ICF-license = (IF lIsICFRunning THEN 0 ELSE 1) NO-ERROR.

IF i-UIB-license NE 0 AND i-WS-license NE 0 THEN
DO:
  /* Neither tool is licensed */
  IF i-UIB-license = 2 OR i-WS-license = 2 THEN
    /* Something has expired.  Doesn't matter which, it is all one tool */
    cMessage = "Your copy of the " + "{&UIB_NAME}" + " is past it's expiration date.".
  ELSE  /* If  no license is available and nothing has expired then they 
           just don't have a license                                    */
    cMessage = "A license for the " + "{&UIB_NAME}" + " is not available.".

  /* Either way, they can't run */
  ASSIGN ABLic = ?.
END.   /* Niether tool has a valid license */
ELSE /* Set the shared variable _AB-license to indicate what has been     */
DO:
     /* licensed so we show the right stuff for the remainder of the      */
     /* session. (Note: When properly licensed, GET-LICENSE returns 0.)   */
   ASSIGN ABLic = (IF i-UIB-license = 0 THEN 1 ELSE 0) +
                  (IF i-WS-license = 0  THEN 2 ELSE 0).
END.

/* Build the list of tool products currently enabled. jep-icf */
ASSIGN ABTools = (IF i-UIB-license = 0 THEN "UIB"         ELSE "") + "," +
                 (IF i-WS-license  = 0 THEN "Workshop"    ELSE "") + "," +
                 (IF i-ICF-license = 0 THEN "ENABLE-ICF"  ELSE "").
/* Remove trailing and leading commas. List may contain double-commas in middle;
   that's ok. jep-icf */
ASSIGN ABTools = TRIM(ABTools, ',').

IF ShowMsgs AND cMessage <> "" THEN
DO ON STOP UNDO, LEAVE:
    MESSAGE cMessage
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

RETURN.
