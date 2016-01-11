/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure: _ablic.p
    Purpose:   Returns AppBuilder license 
    Syntax :   RUN adecomm/_ablic.p (INPUT ShowMsgs, OUTPUT ABLic).
               
    Parameters:
               ShowMsgs - Yes: procedure displays messages.
                           No: procedure doesn't display messages.
                              
               ABLic - = 1 when C/S AppBuilder only
                       = 2 when Webspeed AppBuilder only
                       = 3 when Both
                       
    Author :   Gerry Seidl
    Date   :   04/01/98

    Modified:  10/29/98 jep - Added ShowMsgs parameter and coding.
**************************************************************************/
DEFINE INPUT  PARAMETER ShowMsgs AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER ABLic    AS INTEGER NO-UNDO.

/* Include the file extensions and application names file. */
{adecomm/adefext.i}

DEFINE VARIABLE i-UIB-license AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-WS-license  AS INTEGER    NO-UNDO.
DEFINE VARIABLE cMessage      AS CHARACTER  NO-UNDO.

ASSIGN i-UIB-license = GET-LICENSE ("UIB":U)
       i-WS-license  = GET-LICENSE ("Workshop":U).

IF i-UIB-license NE 0 AND i-WS-license NE 0 THEN DO:
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
     /* licensed so we show the right stuff for the remainder of the      */
     /* session. (Note: When properly licensed, GET-LICENSE returns 0.)   */
   ASSIGN ABLic = (IF i-UIB-license = 0 THEN 1 ELSE 0) +
                  (IF i-WS-license = 0  THEN 2 ELSE 0).

IF ShowMsgs AND cMessage <> "" THEN
DO ON STOP UNDO, LEAVE:
    MESSAGE cMessage
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

RETURN.
