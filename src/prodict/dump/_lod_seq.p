/*********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* History:  
     
     D. McMann  03/11/99 Added _db-recid to can-find for _sequence
    K. McIntosh 06/17/04 Added subtransaction to avoid exceeding
				 max sequences 20030619-003
    K. McIntosh 09/14/04 Fixed error number for max sequences 20040910-010
    fernando    11/13/07 Check _initial value - OE00112332
*/

{ prodict/dump/loaddefs.i }
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE scrap AS CHARACTER NO-UNDO.
define variable dictLoader as OpenEdge.DataAdmin.Binding.IDataDefinitionLoader no-undo.

/* dictLoadOptions - could have options only or be a logger/loader or reader/parser  */

if valid-object(dictLoadOptions) then
do:
    /* the code below use valid-object(dictLoader) as flag to logg data and return */
    dictLoader = dictLoadOptions:Logger.
end.

FIND FIRST wseq.
IF imod <> "a" THEN /* already proven to exist */
  FIND _Sequence
    WHERE _Sequence._Db-recid = drec_db
      AND _Sequence._Seq-name = wseq._Seq-name.

IF imod = "a" THEN crt-blk: DO ON ERROR UNDO, LEAVE: 
  
  IF CAN-FIND(_Sequence WHERE _Sequence._Db-recid = drec_db
                        AND _Sequence._Seq-name = wseq._Seq-name) THEN
  do:   
      if valid-object(dictLoader) and dictLoader:isReader then
      do:   
          /* this is not an error if parsing and the existing field is renamed */
          if dictLoader:SequenceNewName(wseq._Seq-name) = "" then
              ierror = 7. /* "&2 already exists with name &3" */
              
      end. 
      else   
          ierror = 7. /* "&2 already exists with name &3" */  
  end.
  
  if wseq._Seq-Attributes[1] = true then
  do:
      if not can-find(first _tenant) then
      do:
         /* db must be mt enabled to add mt sequence */
         iError = 72.
         RETURN.
      end.     
  end.    
   
  IF ((wseq._Seq-Incr > 0) AND (wseq._Seq-Init >= wseq._Seq-Max)) THEN
      ierror = 57.
  ELSE IF ((wseq._Seq-Incr < 0) AND (wseq._Seq-Init <= wseq._Seq-Min)) THEN
      ierror = 58.
      
  IF ierror > 0 THEN RETURN.
  
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddSequence(iMod,buffer wseq:handle).
      return.
  end.
  
  CREATE _Sequence.
  ASSIGN
    _Sequence._Db-recid = drec_db
    _Sequence._Seq-Attributes[1] = wseq._Seq-Attributes[1]
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
    ierror = 51.
    UNDO crt-blk, LEAVE crt-blk.
  END.
  
END. /*crt-blk*/
ELSE
IF imod = "m" THEN DO: /*---------------------------------------------------*/
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddSequence(iMod,buffer wseq:handle).
      return.
  end.
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
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:RenameSequence(_Sequence._Seq-name,irename).
      return.
  end.  
  _Sequence._Seq-name = irename.
END. /*---------------------------------------------------------------------*/
ELSE
IF imod = "d" THEN DO: /*---------------------------------------------------*/
  if valid-object(dictLoader) and dictLoader:isReader then
  do:
      dictLoader:AddSequence(iMod,buffer wseq:handle).
      return.
  end.
  
  DELETE _Sequence.
END. /*---------------------------------------------------------------------*/

RETURN.

