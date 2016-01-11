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
