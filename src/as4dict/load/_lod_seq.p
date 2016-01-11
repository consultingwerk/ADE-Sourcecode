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
/* as4dict/load/_lod_seq.p */

{ as4dict/dictvar.i shared }
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE scrap AS CHARACTER NO-UNDO.

FIND FIRST wseq.
IF imod <> "a" THEN /* already proven to exist */
  FIND as4dict.p__Seq
    WHERE  as4dict.p__Seq._Seq-name = wseq._Seq-name.

IF imod = "a" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(as4dict.p__Seq WHERE as4dict.p__Seq._Seq-name = wseq._Seq-name) THEN
    ierror = 7. /* "&2 already exists with name &3" */

     
  IF ierror > 0 THEN RETURN.
  CREATE as4dict.p__Seq.
  ASSIGN
    as4dict.p__Seq._Db-recid = 1
    as4dict.p__Seq._Seq-Name = CAPS(wseq._Seq-Name)
    as4dict.p__Seq._Seq-Init = wseq._Seq-Init
    as4dict.p__Seq._Seq-Incr = wseq._Seq-Incr
    as4dict.p__Seq._Seq-Min  = wseq._Seq-Min
    as4dict.p__Seq._Seq-Max  = (if wseq._Seq-Max = 0 then ? else wseq._Seq-Max)
    as4dict.p__Seq._Cycle-Ok = wseq._Cycle-Ok
    as4dict.p__Seq._Seq-Misc[1] = wseq._Seq-Misc[1]
    as4dict.p__Seq._Seq-Misc[2] = wseq._Seq-Misc[2]
    /* Set CURRENT-VALUE (stored in seq-num) to Seq-Min, otherwise it will
       default to 0 */
    as4dict.p__Seq._Seq-Num = wseq._Seq-Min.       
    
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  IF as4dict.p__Seq._Seq-Name <> wseq._Seq-Name THEN
    as4dict.p__Seq._Seq-Name = wseq._Seq-Name.
  IF as4dict.p__Seq._Seq-Init <> wseq._Seq-Init THEN
    as4dict.p__Seq._Seq-Init = wseq._Seq-Init.
  IF as4dict.p__Seq._Seq-Min  <> wseq._Seq-Min THEN
    as4dict.p__Seq._Seq-Min  = wseq._Seq-Min.
  IF as4dict.p__Seq._Seq-Max  <> wseq._Seq-Max THEN
    as4dict.p__Seq._Seq-Max  = wseq._Seq-Max.
  IF as4dict.p__Seq._Seq-Incr <> wseq._Seq-Incr THEN
    as4dict.p__Seq._Seq-Incr = wseq._Seq-Incr.
  IF as4dict.p__Seq._Cycle-Ok <> wseq._Cycle-Ok THEN
    as4dict.p__Seq._Cycle-Ok = wseq._Cycle-Ok.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "r" THEN DO: /*---------------------------------------------------*/
  IF CAN-FIND(FIRST as4dict.p__Seq WHERE as4dict.p__Seq._Seq-name = irename) THEN
    ierror = 7. /* "&2 already exists with name &3" */
  IF ierror > 0 THEN RETURN.
  as4dict.p__Seq._Seq-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  DELETE as4dict.p__Seq.
END. /*---------------------------------------------------------------------*/

RETURN.
