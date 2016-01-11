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
/*------------------------------------------------------------------------
  File: adeuib/usrlistl.i
  Description: Assigns the labels for the userlist
    To be used by _advprop.w and _coledit.p

  Input Parameters:
      {1} _U or _BC
      {2} frame name
  Output Parameters:
      <none>

  Author: SLK

  Copied from _advprop.w
  Created: 06/01/98 
  Modified: 
------------------------------------------------------------------------*/

/* Change the label of the Custom Lists. */
IF _U._TYPE ne "TEXT":U THEN DO:
  FIND _P WHERE _P._WINDOW-HANDLE eq _U._WINDOW-HANDLE.
  userNames = _P._LISTS.
  /* Shorten "long" names */
  DO i = 1 TO {&MaxUserLists}:
    ch = ENTRY(i,userNames).
    IF LENGTH(ch, "CHARACTER") > 15  
    THEN ENTRY(i,userNames) = SUBSTRING(ch,1,12,"CHARACTER") + "...".
  END.

  ASSIGN 
   {1}._USER-LIST[1]:LABEL IN FRAME {2} = "~{&&" + ENTRY(1, userNames) + "}"
   {1}._USER-LIST[2]:LABEL IN FRAME {2} = "~{&&" + ENTRY(2, userNames) + "}"
   {1}._USER-LIST[3]:LABEL IN FRAME {2} = "~{&&" + ENTRY(3, userNames) + "}"
   {1}._USER-LIST[4]:LABEL IN FRAME {2} = "~{&&" + ENTRY(4, userNames) + "}"
   {1}._USER-LIST[5]:LABEL IN FRAME {2} = "~{&&" + ENTRY(5, userNames) + "}"
   {1}._USER-LIST[6]:LABEL IN FRAME {2} = "~{&&" + ENTRY(6, userNames) + "}"
   .

   /* Double check the true length of Lists 3 and 6 (which may still overlap
      the edge of the frame.  First compute the maximum width for these 
      toggles. */
   _WIDTH-P = FRAME {2}:WIDTH-P - FRAME {2}:BORDER-LEFT-P - 
              FRAME {2}:BORDER-RIGHT-P - 
              {1}._USER-LIST[3]:X IN FRAME {2} -
              1 /* for good luck */.
   IF {1}._USER-LIST[3]:WIDTH-P IN FRAME {2} > _WIDTH-P 
   THEN {1}._USER-LIST[3]:WIDTH-P IN FRAME {2} = _WIDTH-P.
   IF {1}._USER-LIST[6]:WIDTH-P IN FRAME {2} > _WIDTH-P 
   THEN {1}._USER-LIST[6]:WIDTH-P IN FRAME {2} = _WIDTH-P.
END.
