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
