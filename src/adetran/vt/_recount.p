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

Procedure:    adetran/vt/_recount.p
Author:       F. Chang/R. Ryan
Created:      1/95
Updated:      9/95
Purpose:      Visual Translator's Recounting facility
Background:   Used as a fail/safe to recalculate VT statistics
              such as 'CurrentStatus'.  Ordinarilly, these statistics
              would/should be calculated concurrently, but sometimes
              these statistics get out of wack when the user stops a
              process in the middle.  This procedure is only run *if*
              a modfication to the translation data and/or glossary
              takes place.
Called By:    vt/_main.p
*/

{adetran/vt/_shrvar.i}
DEFINE INPUT PARAMETER CurWindow   AS WIDGET-HANDLE                NO-UNDO.

DEFINE VARIABLE BaseName           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE DirName            AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE itry               AS INTEGER                      NO-UNDO.
DEFINE VARIABLE tInt               AS INTEGER                      NO-UNDO.
DEFINE VARIABLE tInt1              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE TempName           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE TotRecs            AS INTEGER                      NO-UNDO.
DEFINE VARIABLE TransRecs          AS INTEGER                      NO-UNDO.

DEFINE VARIABLE skipStatCalc       AS LOGICAL    INITIAL NO        NO-UNDO.
DEFINE VARIABLE skipWordCalc       AS LOGICAL    INITIAL YES       NO-UNDO.

DEFINE VARIABLE num_phrases        AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE num_words          AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE num_unique_phrases AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE num_unique_words   AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE iLoc               AS INTEGER    INITIAL 0         NO-UNDO.
DEFINE VARIABLE temp-string        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE temp-string2       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE word-string        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE working-string     AS CHARACTER                    NO-UNDO.

DEFINE TEMP-TABLE WordCount
  FIELD Word AS CHARACTER FORMAT "X(80)"
INDEX Word IS PRIMARY Word
.

  
FORM SKIP(1) SPACE (3)
     "  Computing Statistics ...  " VIEW-AS TEXT
     SPACE (3) SKIP(1)
    WITH FRAME UpdMsg NO-LABEL VIEW-AS DIALOG-BOX THREE-D
    TITLE "Database Maintenance".

FIND FIRST kit.XL_Project NO-LOCK NO-ERROR.

/* Determine if statistics need to be recalcutated */
IF AVAILABLE Kit.XL_Project THEN DO:
  IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 1 THEN DO:
    IF ENTRY(2, Kit.XL_Project.ProjectRevision,CHR(4)) = "Yes":U AND
       tmodFlag = FALSE THEN
      ASSIGN skipStatCalc = YES.

    IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 2 AND
       ENTRY(3, Kit.XL_Project.ProjectRevision,CHR(4)) = "Yes":U THEN
      ASSIGN skipWordCalc = NO.
  END.  /* If there is a second entry on revision dealy */
END.  /* If found project record */

IF NOT skipStatCalc OR NOT skipWordCalc THEN DO:
  RUN adecomm/_setcurs.p ("WAIT":U).
   
  VIEW FRAME UpdMsg IN WINDOW CurWindow.
  APPLY "ENTRY":U TO FRAME UpdMsg.
   

  IF NOT skipStatCalc THEN DO:
    IF AVAILABLE kit.XL_Project THEN DO TRANSACTION:
      FOR EACH kit.XL_GlossEntry NO-LOCK:
        ACCUMULATE RECID(kit.XL_GlossEntry) (COUNT).
      END.
      FOR EACH kit.XL_Instance WHERE kit.XL_Instance.ShortTarg <> "":U NO-LOCK:
        ACCUMULATE RECID(kit.XL_Instance) (COUNT).
      END.
      FIND FIRST kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
      itry = 0.
      DO WHILE NOT AVAILABLE kit.XL_Project AND itry < 10:
        /* Try 10 times silently then give message */
        itry = itry + 1.
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
        PAUSE 1 NO-MESSAGE.
      END.  /* End of  10 silent tries */
      IF NOT AVAILABLE kit.XL_Project THEN
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK.
      ASSIGN kit.XL_Project.GlossaryCount    = ACCUM COUNT RECID(kit.XL_GlossEntry)
             kit.XL_Project.TranslationCount = ACCUM COUNT RECID(kit.XL_Instance).
    END.  /* DO Transaction */
      
    FIND CURRENT kit.XL_Project NO-LOCK NO-ERROR.  /* downgrade lock */

    FOR EACH kit.XL_Instance NO-LOCK BREAK BY kit.XL_Instance.ProcedureName:
      IF FIRST-OF(kit.XL_Instance.ProcedureName) THEN
        ASSIGN TotRecs   = 0
               TransRecs = 0.

      TotRecs = TotRecs + 1.
      IF kit.XL_Instance.TargetPhrase <> "":U THEN
        TransRecs = TransRecs + 1.
      
      IF LAST-OF(kit.XL_Instance.ProcedureName) THEN DO:
        TempName = kit.XL_Instance.ProcedureName.
        RUN adecomm/_osprefx.p (TempName ,OUTPUT DirName, OUTPUT BaseName).
        DirName = RIGHT-TRIM(DirName,"\":U).
        FIND kit.XL_Procedure WHERE
                 kit.XL_Procedure.Directory = DirName AND
                 kit.XL_Procedure.FileName  = BaseName EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE kit.XL_Procedure THEN
          ASSIGN kit.XL_Procedure.CurrentStatus =
                      IF TransRecs = 0            THEN "Untranslated"
                      ELSE IF TransRecs = TotRecs THEN "Translated"
                      ELSE STRING(TransRecs) + " of " + STRING(TotRecs).
      END. /* If last-of xl_instance.ProcedureName */
    END.  /* For each xl_instance */
      
    IF AVAILABLE Kit.XL_Project THEN DO TRANSACTION:
      FIND CURRENT kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
      itry = 0.
      DO WHILE NOT AVAILABLE kit.XL_Project AND itry < 10:
        itry = itry + 1.
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
        PAUSE 1 NO-MESSAGE.
      END.  /* End of 10 silent tries */
      IF NOT AVAILABLE kit.XL_Project THEN
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK.
      
      Kit.XL_Project.ProjectRevision = ENTRY(1, Kit.XL_Project.ProjectRevision, CHR(4)) 
            + CHR(4) + "Yes":U
            + IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 2 THEN
                  ENTRY(3, Kit.XL_Project.ProjectRevision, CHR(4))
              ELSE "":U.
    END.  /* DO TRANSACTION */

    FIND CURRENT kit.XL_Project NO-LOCK NO-ERROR.  /* downgrade lock */
    tModFlag = FALSE.
  END. /* Recalculate stats */

  IF NOT skipWordCalc THEN DO:
    EMPTY TEMP-TABLE WordCount.

    ASSIGN temp-string    = "":U
           word-string    = "":U
           working-string = "":U.
    FOR EACH kit.xl_instance NO-LOCK BY kit.xl_instance.StringKey:
      /* Number of Phrases */
      ASSIGN num_phrases = num_phrases + 1.
      IF NOT COMPARE(temp-string, "=":U, kit.XL_Instance.SourcePhrase, "CAPS":U) THEN DO:
        ASSIGN num_unique_phrases = num_unique_phrases + 1
               working-string     = TRIM(kit.XL_Instance.SourcePhrase).

        DO WHILE TRUE:
          ASSIGN iLoc        = INDEX(working-string," ")
                 word-string = IF iLoc = 0 THEN working-string
                                   ELSE SUBSTRING(working-string,1,iLoc - 1)
                 num_words   = num_words + 1.

           CREATE WordCount.
           ASSIGN WordCount.Word = word-string.
           IF iLoc = 0 THEN LEAVE.
           ASSIGN working-string = TRIM(SUBSTRING(working-string,iLoc + 1)).
         END.  /* Do While True */
       END. /* New phrase */
       ASSIGN temp-string = kit.XL_Instance.SourcePhrase.
     END.  /* For each xl_instance */
          
     ASSIGN num_unique_words = 0.
     FOR EACH WordCount BREAK BY WordCount.Word:
       IF FIRST-OF(WordCount.Word) THEN
            num_unique_words = num_unique_words + 1.
     END.  /* For each WordCount */

     DO TRANSACTION:          
       FIND FIRST kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
       IF AVAILABLE kit.XL_Project THEN DO:
         ASSIGN kit.XL_Project.NumberOfPhrases       = num_phrases
                kit.XL_Project.NumberOfWords         = num_words
                kit.XL_Project.NumberOfUniquePhrases = num_unique_phrases
                kit.XL_Project.NumberOfUniqueWords   = num_unique_words
                temp-string2 = ENTRY(1, kit.XL_Project.ProjectRevision, CHR(4)) +
                                    CHR(4) + "Yes":U + CHR(4) +
                           (IF NUM-ENTRIES(kit.XL_Project.ProjectRevision, CHR(4)) > 2 THEN
                               ENTRY(3, kit.XL_Project.ProjectRevision, CHR(4)) ELSE "NO":U)
                kit.XL_Project.ProjectRevision = IF LENGTH(temp-string2) > 175 
                              THEN SUBSTRING(temp-string2,1,175)  ELSE temp-string2.

         Kit.XL_Project.ProjectRevision = ENTRY(1, Kit.XL_Project.ProjectRevision, CHR(4)) 
              + CHR(4) 
              + IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 1 THEN
                    ENTRY(2, Kit.XL_Project.ProjectRevision, CHR(4)) + CHR(4) + "No":U
                ELSE "":U.
       END.  /* IF AVAILABLE kit.xl_project */
     END. /* DO TRANSACTION */

     FIND CURRENT kit.xl_project NO-LOCK NO-ERROR.  /* downgrade lock */
   END. /* Recalculate word count */

      
   HIDE FRAME UpdMsg .
   RUN adecomm/_setcurs.p ("":U).
   
END. /* Recalculate something */
