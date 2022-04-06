/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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

History:
   kmcintos  June 6, 2005  Fixed indexing problem with WordCount temp-table and 
                           added PhraseCount table, and logic to correctly 
                           ascertain number of words and unique phrases 
                           20050523-003.
   kmcintos  July 26, 2005 Changed EMPTY TEMP-TABLE statements to 
                           FOR EACH DELETEs 20050523-003.
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
DEFINE VARIABLE iCount            AS INTEGER             NO-UNDO.

DEFINE TEMP-TABLE WordCount
  FIELD KeyOfWord AS CHARACTER
  FIELD Word      AS CHARACTER FORMAT "X(80)"
INDEX KeyOfWord IS PRIMARY KeyOfWord CASE-SENSITIVE.


DEFINE TEMP-TABLE PhraseCount
  FIELD KeyOfPhrase AS CHARACTER
  FIELD Phrase      AS CHARACTER
  INDEX KeyOfPhrase IS PRIMARY KeyOfPhrase CASE-SENSITIVE.

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
FOR EACH PhraseCount:
  DELETE PhraseCount.
END.

ASSIGN working-string = "":U
       word-string    = "":U.

FOR EACH xlatedb.xl_string_info NO-LOCK BY xlatedb.xl_string_info.KeyOfString:
  CREATE PhraseCount.
  ASSIGN PhraseCount.KeyOfPhrase = 
                ENCODE(CAPS(xlatedb.XL_String_Info.Original_string))
         PhraseCount.Phrase      = xlatedb.XL_String_Info.Original_string.
END. /* For Each xl_string_info */

FOR EACH PhraseCount NO-LOCK BREAK BY KeyOfPhrase:
  IF FIRST-OF(PhraseCount.KeyOfPhrase) THEN DO:
    ASSIGN num_unique_phrase = num_unique_phrase + 1
           working-string    = TRIM(PhraseCount.Phrase).
         
    DO iLoc = 1 TO NUM-ENTRIES(working-string," "):
      ASSIGN word-string = ENTRY(iLoc,working-string," ")
             num_words   = num_words + 1.

      CREATE WordCount.
      ASSIGN WordCount.KeyOfWord = ENCODE(CAPS(word-string))
             WordCount.Word      = word-string.
    END.
  END. /* If First-Of */
END.

FOR EACH WordCount BREAK BY KeyOfWord:
  IF FIRST-OF(WordCount.KeyOfWord) THEN
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
