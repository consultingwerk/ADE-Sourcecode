/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trgains.p
Purpose:      ASSIGN database trigger for XL_Instance table.
Background:   Updates XL_Procedure.CurrentStatus to refect what percentage
    	      of the procedure has been translated.

	      XL_Procedure.CurrentStatus is assigned as follows:

	      "Untranslated"	:   No translations
	      "Translated"  	:   All possible translations completed
	      Trans/TotTrans	:   3/4 (3 of 4 translations completed)
	      
Author:       F. Chang/R. Ryan
Created:      01/95 
Updated:      11/95 :	J. Palazzo
*/

TRIGGER PROCEDURE FOR ASSIGN OF kit.XL_Instance.TargetPhrase. 
  define buffer bufInst for kit.XL_Instance.
  define var TotRecs    as integer   no-undo.
  define var TransRecs  as integer   no-undo.
  define var Dir        as character no-undo.
  define var File_Name  as character no-undo.
  
  run adecomm/_osprefx.p
    (input  kit.XL_Instance.ProcedureName, output Dir, output File_Name).
  if Dir = "" then assign Dir = ".":u.
  
  find kit.XL_Procedure where kit.XL_Procedure.directory = Dir and
    	    	    	       kit.XL_Procedure.filename  = File_Name
    	    	    	 EXCLUSIVE-LOCK no-error.
    
  if avail kit.XL_Procedure then do: 
    assign TotRecs   = 0  
      	   TransRecs = 0.
      
    for each bufInst where bufInst.ProcedureName = kit.XL_Instance.ProcedureName
                     no-lock:
      assign TotRecs = TotRecs + 1. 
      if bufInst.TargetPhrase <> "" then  assign TransRecs = TransRecs + 1.
    end.
    
    assign kit.XL_Procedure.CurrentStatus =
                  if TransRecs = 0            then "Untranslated":u
                  else if TransRecs = TotRecs then "Translated":u
                  else string(TransRecs) + " of ":u + string(TotRecs).
  end.
