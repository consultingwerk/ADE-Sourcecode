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

Procedure:    adetran/vt/_proccnt.p
Author:       Ross Hunter
Created:      12/95 
Updated:      
Purpose:      Visual Translator's Procedure counting
Background:   
Called By:    vt/_main.p
*/

{adetran/vt/_shrvar.i}

DEFINE VARIABLE TotRecs   AS INTEGER                                  NO-UNDO.
DEFINE VARIABLE TransRecs AS INTEGER                                  NO-UNDO.
DEFINE VARIABLE tmp-flnm  AS CHARACTER                                NO-UNDO.

RUN adecomm/_setcurs.p ("WAIT":U).

/* Determine if statistics need to be recalcutated */
FIND FIRST kit.XL_Project NO-LOCK NO-ERROR.
IF AVAILABLE Kit.XL_Project THEN DO:
  IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 1 THEN DO:
    IF ENTRY(2, Kit.XL_Project.ProjectRevision,CHR(4)) = "Yes":U AND
       tModFlag = FALSE THEN DO:
      RUN adecomm/_setcurs.p ("":U).
      RETURN.
    END.  /* If no need to update */
  END.  /* If there is a second entry on revision dealy */
END.  /* If found project record */

FOR EACH kit.XL_Procedure WHERE kit.XL_Procedure.Modified EXCLUSIVE-LOCK:
  ASSIGN TotRecs   = 0
         TransRecs = 0
         tmp-flnm  = (IF kit.XL_Procedure.Directory NE ".":U AND 
                         kit.XL_Procedure.Directory NE "":U THEN
                         kit.XL_Procedure.Directory + "~\":U ELSE "":U) +
                       kit.XL_Procedure.FileName.
  FOR EACH kit.XL_Instance WHERE kit.XL_Instance.ProcedureName = tmp-flnm NO-LOCK:
    ASSIGN TotRecs   = TotRecs + 1
           TransRecs = TransRecs + (IF kit.XL_Instance.TargetPhrase <> "":U
                                    THEN 1 ELSE 0).
  END. /* For each instance of a string in the procedure */

  ASSIGN kit.XL_Procedure.CurrentStatus =
             IF TransRecs = 0 THEN "Untranslated":U
             ELSE IF TransRecs = TotRecs THEN "Translated":U
             ELSE STRING(TransRecs) + " of ":U + STRING(TotRecs)
         kit.XL_Procedure.Modified = NO.
END.  /* For each modified procedure */ 
tModFlag = FALSE.
RUN adecomm/_setcurs.p ("":U).



