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


/* History:  
     
     D. McMann  03/11/99 Added _db-recid to can-find for _sequence

*/

{ prodict/dump/loaddefs.i }
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE scrap AS CHARACTER NO-UNDO.

FIND FIRST wseq.
IF imod <> "a" THEN /* already proven to exist */
  FIND _Sequence
    WHERE _Sequence._Db-recid = drec_db
      AND _Sequence._Seq-name = wseq._Seq-name.

IF imod = "a" THEN crt-blk: DO ON ERROR UNDO, LEAVE: 
  
  IF CAN-FIND(_Sequence WHERE _Sequence._Db-recid = drec_db
     AND _Sequence._Seq-name = wseq._Seq-name) THEN
     ierror = 7. /* "&2 already exists with name &3" */
      
  IF ierror > 0 THEN RETURN.
  CREATE _Sequence.
  ASSIGN
    _Sequence._Db-recid = drec_db
    _Sequence._Seq-Name = wseq._Seq-Name
    _Sequence._Seq-Init = wseq._Seq-Init
    _Sequence._Seq-Incr = wseq._Seq-Incr
    _Sequence._Seq-Min  = wseq._Seq-Min
    _Sequence._Seq-Max  = wseq._Seq-Max
    _Sequence._Cycle-Ok = wseq._Cycle-Ok
    _Sequence._Seq-Misc[1] = wseq._Seq-Misc[1]
    _Sequence._Seq-Misc[2] = wseq._Seq-Misc[2]
    _Sequence._Seq-Misc[3] = wseq._Seq-Misc[3]
    _Sequence._Seq-Misc[4] = wseq._Seq-Misc[4]
    _Sequence._Seq-Misc[5] = wseq._Seq-Misc[5]
    _Sequence._Seq-Misc[6] = wseq._Seq-Misc[6]
    _Sequence._Seq-Misc[7] = wseq._Seq-Misc[7]
    _Sequence._Seq-Misc[8] = wseq._Seq-Misc[8] NO-ERROR.
  
  IF ERROR-STATUS:ERROR THEN DO:
    ierror = 35.
    UNDO crt-blk, LEAVE crt-blk.
  END.
  
END. /*crt-blk*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  IF _Sequence._Seq-Name <> wseq._Seq-Name THEN
    _Sequence._Seq-Name = wseq._Seq-Name.
  IF _Sequence._Seq-Init <> wseq._Seq-Init THEN
    _Sequence._Seq-Init = wseq._Seq-Init.
  IF _Sequence._Seq-Min  <> wseq._Seq-Min THEN
    _Sequence._Seq-Min  = wseq._Seq-Min.
  IF _Sequence._Seq-Max  <> wseq._Seq-Max THEN
    _Sequence._Seq-Max  = wseq._Seq-Max.
  IF _Sequence._Seq-Incr <> wseq._Seq-Incr THEN
    _Sequence._Seq-Incr = wseq._Seq-Incr.
  IF _Sequence._Cycle-Ok <> wseq._Cycle-Ok THEN
    _Sequence._Cycle-Ok = wseq._Cycle-Ok.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST _Sequence WHERE _Sequence._Db-recid = drec_db
    AND _Sequence._Seq-name = irename) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF ierror > 0 THEN RETURN.
  _Sequence._Seq-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  DELETE _Sequence.
END. /*---------------------------------------------------------------------*/

RETURN.

