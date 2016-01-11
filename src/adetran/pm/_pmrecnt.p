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

Procedure:    adetran/pm/_pmrecnt.p
Author:       F. Chang
Created:      1/95
Updated:      9/95
                3/97 SLK 
Purpose:      Translation Manager Recounting facility
Background:   Used as a fail/safe to recalculate PM statistics
Called By:    pm/_pmmain.p
*/

DEFINE INPUT PARAMETER CurWindow AS WIDGET-HANDLE        NO-UNDO.

FORM SKIP(1) SPACE (3)
     "  Computing Statistics ...  " VIEW-AS TEXT
     SPACE (3) SKIP(1)
    WITH FRAME updmsg NO-LABEL VIEW-AS DIALOG-BOX three-d
    TITLE "Database Maintenance".

DEFINE SHARED VARIABLE s_Glossary AS CHARACTER           NO-UNDO.
DEFINE VARIABLE tInt              AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE num_words         AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE num_unique_phrase AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE num_unique_word   AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE i                 AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE iLoc              AS INTEGER INITIAL 0   NO-UNDO.
DEFINE VARIABLE temp-string       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE temp-string2      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE working-string    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE word-string       AS CHARACTER           NO-UNDO.

DEFINE TEMP-TABLE WordCount
  FIELD Word AS CHARACTER FORMAT "X(80)"
INDEX Word IS PRIMARY Word.
.

/* *** 11/99 tomn: We do this test in _pmstats.p before calling this routine...
/* Find out if statistics need to be updated */
FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
IF AVAILABLE xlatedb.XL_Project THEN DO:
  IF NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision, CHR(4)) > 1 THEN DO:
    IF ENTRY(2, xlatedb.XL_Project.ProjectRevision, CHR(4)) = "Yes":U
      THEN RETURN.
  END.  /* If there is more than 1 entry */
END.  /* If found the project record */
*** */

VIEW FRAME updmsg IN WINDOW CurWindow.
APPLY "entry" TO FRAME UpdMsg.

run adecomm/_setcurs.p ("wait").

FOR EACH WordCount:
   DELETE WordCount.
END.

ASSIGN
   temp-string    = "":U
   working-string = "":U
   word-string    = "":U.
FOR EACH xlatedb.xl_string_info NO-LOCK BY xlatedb.xl_string_info.KeyOfString:
  ASSIGN working-string = TRIM(xlatedb.XL_String_Info.Original_string)
         num_unique_phrase = num_unique_phrase + 
           (IF COMPARE(temp-string, "=":U, xlatedb.XL_String_Info.Original_string, "CAPS":U)
            THEN 0 ELSE 1)
         temp-string = xlatedb.XL_String_Info.Original_string.

  DO WHILE TRUE:
    ASSIGN
        iLoc = INDEX(working-string," ")
        word-string = IF iLoc = 0 THEN
                         working-string
                      ELSE
                         SUBSTRING(working-string,1,iLoc - 1)
        num_words = num_words + 1.

    CREATE WordCount.
    ASSIGN WordCount.Word = word-string.
    IF iLoc = 0 THEN LEAVE.
    ASSIGN working-string = TRIM(SUBSTRING(working-string,iLoc + 1)).
  END.
END.

FOR EACH WordCount BREAK BY WordCount.Word:
  IF FIRST-OF(WordCount.Word) THEN 
  num_unique_word = num_unique_word + 1.
END.

FOR EACH xlatedb.XL_Glossary EXCLUSIVE-LOCK:
  ASSIGN xlatedb.XL_Glossary.GlossaryCount = 0.
  FOR EACH xlatedb.XL_GlossDet WHERE
      xlatedb.XL_Glossary.GlossaryName = xlatedb.XL_GlossDet.GlossaryName NO-LOCK:
    xlatedb.XL_Glossary.GlossaryCount = xlatedb.XL_Glossary.GlossaryCount + 1.
  END.
END.

FIND FIRST xlatedb.XL_Project EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE xlatedb.XL_Project THEN DO:
  FOR EACH xlatedb.XL_Instance NO-LOCK:
    ACCUMULATE RECID(xlatedb.xl_instance) (COUNT).
  END.
  ASSIGN xlatedb.XL_Project.NumberOfPhrases       = ACCUM
                                            COUNT RECID(xlatedb.xl_instance)
         xlatedb.XL_Project.NumberOfWords         = num_words
         xlatedb.XL_Project.NumberOfUniquePhrases = num_unique_phrase
         xlatedb.XL_Project.NumberOfUniqueWords   = num_unique_word
           temp-string2 = ENTRY(1, xlatedb.XL_Project.ProjectRevision, CHR(4)) +
                          CHR(4) + "Yes":U + CHR(4) +
               (IF NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision, CHR(4)) > 2 THEN
                   ENTRY(3, xlatedb.XL_Project.ProjectRevision, CHR(4)) ELSE "NO":U)
  xlatedb.XL_Project.ProjectRevision = IF LENGTH(temp-string2) > 175 
                  THEN SUBSTRING(temp-string2,1,175)  ELSE temp-string2.
END.

HIDE FRAME updmsg.

run adecomm/_setcurs.p ("").
