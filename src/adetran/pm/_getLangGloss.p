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

Procedure:    adetran/pm/_getLangGloss.p
Author:       SLK
Created:      6/95
Purpose:      Returns character lists that correspond to glossary names
              which contain the language as a source/target.  
              This information is used to construct list-items
              for various calling procedures.  
Called By:    common/_impstr.w
              common/_expstr.w
Parameters:   pGlossaryList        (INPUT/char)       list of glossary names
              pLanguageName        (INPUT/char)       language name
              pSrcTarg             (INPUT/char)       should be source/target
              pExistsInGlossaryList (OUTPUT/char)     list of glossary names
              pErrorStatus (output/log)               success of the operation
*/

DEFINE INPUT  PARAMETER pGlossaryList           AS CHARACTER       NO-UNDO.  
DEFINE INPUT  PARAMETER pLanguageName           AS CHARACTER       NO-UNDO.
DEFINE INPUT  PARAMETER pSourceTarget           AS CHARACTER       NO-UNDO.
DEFINE OUTPUT PARAMETER pExistsInGlossaryList   AS CHARACTER       NO-UNDO.
DEFINE OUTPUT PARAMETER pErrorStatus            AS LOGICAL         NO-UNDO.

DEFINE VARIABLE iCnt                            AS INTEGER         NO-UNDO.
DEFINE VARIABLE cCurGlossaryName                AS CHARACTER       NO-UNDO.
DEFINE VARIABLE cCurSourceLanguage              AS CHARACTER       NO-UNDO.
DEFINE VARIABLE cCurTargetLanguage              AS CHARACTER       NO-UNDO.
DEFINE VARIABLE lExistsInGlossary               AS LOGICAL         NO-UNDO.


/* If we are not given the glossary list or the language to look of, return */
IF    pGlossaryList = "":U OR pLanguageName  = "":U THEN RETURN.

/* If the user did not define or defined a incorrect type for source/target,
 * assume target
 */
IF pSourceTarget <> "SOURCE":U AND pSourceTarget <> "TARGET":U THEN 
   pSourceTarget =  "TARGET".

DO iCnt = 1 TO NUM-ENTRIES(pGlossaryList):
   ASSIGN 
      cCurGlossaryName    = ENTRY(iCnt, pGlossaryList).
   FIND FIRST xlatedb.XL_Glossary WHERE
      xlatedb.XL_Glossary.GlossaryName = cCurGlossaryName
   NO-LOCK NO-ERROR.
   IF AVAILABLE xlatedb.XL_Glossary THEN
   DO:
      ASSIGN
         cCurSourceLanguage  = 
            ENTRY(1, xlatedb.XL_Glossary.GlossaryType, "/":U) 
         cCurTargetLanguage  = 
            ENTRY(2, xlatedb.XL_Glossary.GlossaryType, "/":U).
         lExistsInGlossary = 
          IF (pSourceTarget = "SOURCE" AND cCurSourceLanguage = pLanguageName)
             OR (pSourceTarget = "TARGET" AND cCurTargetLanguage = pLanguageName)
          THEN YES
          ELSE NO.
   END.
   ELSE ASSIGN lExistsInGlossary = NO.

   IF lExistsInGlossary THEN
   ASSIGN
      pExistsInGlossaryList = 
         IF    pExistsInGlossaryList = ? 
            OR pExistsInGlossaryList = "":U THEN 
            cCurGlossaryName
         ELSE
            pExistsInGlossaryList + ",":U + cCurGlossaryName.
END. /* cycle through the glossary list */
