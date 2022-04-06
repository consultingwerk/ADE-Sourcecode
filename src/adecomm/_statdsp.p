/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _statdsp.p

Description:
	Display a message in a status region.

INPUT Parameters
  wFrame	-	The status frame created from _status.p.
  iPos		- 	The status region to display the message in.
  cMessage	-	The message.


INPUT-OUTPUT Parameters

OUTPUT Parameters

Author: Greg O'Connor

Date Created: 08/10/93 

Modification History:

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER wFrame    AS WIDGET    NO-UNDO.
DEFINE INPUT  PARAMETER iPos      AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER cMessage  AS CHARACTER NO-UNDO.

DEFINE VARIABLE wRect1     AS WIDGET NO-UNDO.
DEFINE VARIABLE i          AS INTEGER NO-UNDO.

if not valid-handle(wFrame) then return.

IF iPos > NUM-ENTRIES (wFrame:PRIVATE-DATA) THEN
  RETURN.

ASSIGN
  wRect1 = wFrame:FIRST-CHILD
  wRect1 = (IF wRect1 <> ? THEN wRect1:FIRST-CHILD ELSE wRect1)
  .
DO WHILE wRect1 <> ?:

/*  message  
  INTEGER (ENTRY (i, wFrame2:PRIVATE-DATA )) skip
  STRING (wRect1) skip 
  STRING (wRect1:HANDLE) skip 
  STRING (wRect1:TYPE) skip 
  STRING (wRect1) = ENTRY (i, wFrame2:PRIVATE-DATA ) .
*/


  IF (STRING (wRect1) = ENTRY (iPos, wFrame:PRIVATE-DATA )) THEN DO:
    /*
     * Massage the string. '&' characters are treated like there are in
     * buttons. They get chewed up and turned into "underline the
     * next character".
     */

    &if "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &then

      wRect1:SCREEN-VALUE = replace(cMessage, "&", "&&").

    &else

      i = index(cMessage, "&").

      if i > 0 then
        wRect1:SCREEN-VALUE = 
          replace(SUBSTRING(cMessage,1,i,"CHARACTER":u),"&":u,"&&":u)
        + SUBSTRING(cMessage,i + 1,-1,"CHARACTER":u).
      else
        wRect1:SCREEN-VALUE = cMessage.
    &endif
  END.


wRect1 = wRect1:NEXT-SIBLING.

END.
