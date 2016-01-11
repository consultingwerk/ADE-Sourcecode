&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*---------------------------------------------------------------------------------
  File: afmessagep.p

  Description:  Interpret Astra Message
  
  Purpose:      Interpret Astra Message
                Perform translation and interpretation of Astra error messages.

  Parameters:   INPUT CHR(3) delimited list of messages
                INPUT Comma delimited list of button labels
                INPUT Message Title
                OUTPUT CHR(3) delimited list of formatted summary message text
                OUTPUT CHR(3) delimited list of formatted full message text
                OUTPUT Comma delimited list of button labels (translated)
                OUTPUT Message title (translated)
                OUTPUT Logical flag indicating whether to update error log YES/NO
                OUTPUT Logical flag for whether to suppress display of error

  History:
  --------
  (v:010000)    Task:        5958   UserRef:    
                Date:   08/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra Error Handling

  (v:010001)    Task:        6010   UserRef:    
                Date:   14/06/2000  Author:     Anthony Swindells

  Update Notes: fix translation

  (v:010002)    Task:    90000149   UserRef:    
                Date:   24/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Fix Security Manager.
                Was not checking property values using chr(3)

  (v:010003)    Task:        6193   UserRef:    
                Date:   28/06/2000  Author:     Robin Roos

  Update Notes: Verify trigger errors for validation

  (v:010004)    Task:        6468   UserRef:    
                Date:   12/09/2000  Author:     Jenny Bond

  Update Notes: When translating phrases, if no gsc_error record, use session language.
                Error messages and no buttons when doing a substitute on a message which
                has a word with an '&', e.g., &Description (fixed by P. Judge).

  (v:010005)    Task:        6683   UserRef:    
                Date:   12/09/2000  Author:     Peter Judge

  Update Notes: AF2/ BUG/ Message translation:
                - when an element of a error include is blank, a translation is attempted, and
                the translated element is 'replace'd - this causes a Progress error.

  (v:010006)    Task:        6813   UserRef:    
                Date:   05/10/2000  Author:     Jenny Bond

  Update Notes: Extra error message at end of list.

  (v:010007)    Task:        6791   UserRef:    
                Date:   12/10/2000  Author:     Marcia Bouwman

  Update Notes: fix button translation

  (v:010008)    Task:    90000031   UserRef:    
                Date:   22/03/2001  Author:     Anthony Swindells

  Update Notes: removal of Astra 1

-------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afmessagep.p
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 5.14
         WIDTH              = 43.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE INPUT PARAMETER  pcMessageList         AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcButtonList          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcMessageTitle        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcSummaryList         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFullList            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcNewButtonList       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcNewTitle            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plUpdateErrorLog      AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plSuppressDisplay     AS LOGICAL    NO-UNDO.

/* MESSAGE "afmessagep.p pcMessageList=" pcMessageList SKIP "pcButtonList=" pcButtonList SKIP "pcMessageTitle=" pcMessageTitle SKIP "chr3entries=" NUM-ENTRIES(pcMessageList, CHR(3)). */

DEFINE VARIABLE iEntries                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iMessageLoop                  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAmpersandEntry               AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cCleanMessage                 AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cFullMessage                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage1                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage2                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTable                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProg1                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProg2                        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProg12                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cErrorGroup                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cErrorCode                    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iErrorCode                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cErrorInclude                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyList                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dLanguageObj                  AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE dUserObj                      AS DECIMAL INITIAL 0 NO-UNDO.
DEFINE VARIABLE cOriginalText                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTranslatedText               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ipos1                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE ipos2                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE ilen                          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCode                         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cCode                         AS CHARACTER  NO-UNDO.

/* remove trailing NL characters which are sometimes added by the ADM */
ASSIGN pcMessageList = TRIM(pcMessageList,"~n":U).

cPropertyList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj,currentLanguageObj":U,
                                                INPUT NO).

ASSIGN dUserObj     = DECIMAL(ENTRY(1,cPropertyList,CHR(3))) NO-ERROR.
ASSIGN dLanguageObj = DECIMAL(ENTRY(2,cPropertyList,CHR(3))) NO-ERROR.

/* get records where we may need to read language from */
FIND FIRST gsm_user NO-LOCK
     WHERE gsm_user.USER_obj = dUserObj
     NO-ERROR.

FIND FIRST gsc_global_control NO-LOCK NO-ERROR.

ASSIGN plUpdateErrorLog = NO NO-ERROR.

message-loop:
DO iMessageLoop = 1 TO NUM-ENTRIES(pcMessageList, CHR(3)):
  ASSIGN
    cFullMessage = ENTRY(iMessageLoop, pcMessageList, CHR(3))
    .    
CASE NUM-ENTRIES(cFullMessage, CHR(4)):
    WHEN 3 THEN   /* standard ADM2 */
    DO:
      ASSIGN
        cMessage  = ENTRY(1,cFullMessage, CHR(4))
        cfield    = ENTRY(2,cFullMessage, CHR(4))
        ctable    = ENTRY(3,cFullMessage, CHR(4))
        cprog1    = "":U
        cprog2    = "":U
        .
    END.
    WHEN 5 THEN   /* Astra enhanced ADM2 */
    DO:
      ASSIGN
        cMessage  = ENTRY(1,cFullMessage, CHR(4))
        cfield    = ENTRY(2,cFullMessage, CHR(4))
        ctable    = ENTRY(3,cFullMessage, CHR(4))
        cprog1    = ENTRY(4,cFullMessage, CHR(4))
        cprog2    = ENTRY(5,cFullMessage, CHR(4))
        .
    END.
    OTHERWISE   /* unsupported */
    DO:
      ASSIGN
        cMessage  = ENTRY(1,cFullMessage, CHR(4))
        cfield    = "":U
        ctable    = "":U
        cprog1    = "":U
        cprog2    = "":U
        .
    END.
  END CASE.
  
  IF cfield = "?":U THEN ASSIGN cField = "":U.
  IF ctable = "?":U THEN ASSIGN ctable = "":U.

  /* now see if actual message part is structured with caret delimiters */
  CASE NUM-ENTRIES(cMessage, "^":U):
    WHEN 3 THEN   /* old Astra 1 way */
    DO:
      ASSIGN
        cErrorGroup   = ENTRY(1,cMessage, "^":U)      
        cErrorCode    = ENTRY(2,cMessage, "^":U)      
        cProg12       = ENTRY(3,cMessage, "^":U)     
        cErrorInclude = "":U
        .
    END.
    WHEN 4 THEN   /* new Astra way */
    DO:
      ASSIGN
        cErrorGroup   = ENTRY(1,cMessage, "^":U)      
        cErrorCode    = ENTRY(2,cMessage, "^":U)      
        cProg12       = ENTRY(3,cMessage, "^":U)     
        cErrorInclude = ENTRY(4,cMessage, "^":U)
        .
    END.
    OTHERWISE   /* not Astra structured - must be hard-coded */
    DO:
      ASSIGN
        cErrorGroup   = "":U      
        cErrorCode    = "":U      
        cProg12       = "":U     
        cErrorInclude = "":U
        .
    END.
  END CASE.

  IF cProg12 = "?":U THEN ASSIGN cProg12 = "":U.
  IF cErrorInclude = "?":U THEN ASSIGN cErrorInclude = "":U.
  
  /* hard-coded message with insertion codes */
  IF cErrorGroup = "?":U THEN
  DO:
    ASSIGN
      cMessage = cErrorCode
      cErrorGroup   = "":U      
      cErrorCode    = "":U 
      .     
  END.

  ASSIGN plSuppressDisplay = NO.
  IF NUM-ENTRIES(cErrorGroup,"|":U) = 2 THEN  /* old Astra way of adding |suppress to error code */
  DO:
    ASSIGN
      plSuppressDisplay = ENTRY(2,cErrorGroup,"|":U) = "suppress":U
      cErrorGroup = ENTRY(1,cErrorGroup,"|":U)
      .
  END.
  
  ASSIGN cErrorCode  = TRIM(cErrorCode)
         cErrorGroup = TRIM(cErrorGroup)
         .

  /* make gsc_error not available so that hard coded messages do not get over written with the previous loop's error record */
  FIND gsc_error NO-LOCK
      WHERE gsc_error.ERROR_obj = -1 NO-ERROR.

  /* now we have bits, read message file if appropriate */
  ASSIGN 
    iErrorCode = INTEGER(cErrorCode) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    ASSIGN iErrorCode = 0.
  ERROR-STATUS:ERROR = FALSE.
  
  IF cErrorGroup <> "":U AND iErrorCode <> 0 THEN
  DO:
    /* look for error in logged in language */
    FIND FIRST gsc_error NO-LOCK
         WHERE gsc_error.error_group  = cErrorGroup
           AND gsc_error.error_number = iErrorCode
           AND gsc_error.LANGUAGE_obj = dLanguageObj
         NO-ERROR.

    /* If unsuccessful, get user language and try this */
    IF NOT AVAILABLE gsc_error AND AVAILABLE gsm_user THEN
    DO:
      FIND FIRST gsc_error NO-LOCK
           WHERE gsc_error.error_group  = cErrorGroup
             AND gsc_error.error_number = iErrorCode
             AND gsc_error.LANGUAGE_obj = gsm_user.LANGUAGE_obj
           NO-ERROR.
    END.

    /* If unsuccessful, get system language from gsc_global_control */
    IF NOT AVAILABLE gsc_error AND AVAILABLE gsc_global_control THEN
    DO:
      FIND FIRST gsc_error NO-LOCK
           WHERE gsc_error.error_group  = cErrorGroup
             AND gsc_error.error_number = iErrorCode
             AND gsc_error.LANGUAGE_obj = gsc_global_control.DEFAULT_language_obj
           NO-ERROR.
    END.
    
    /* If unsuccessful, get message in any language */
    IF NOT AVAILABLE gsc_error THEN
    DO:
      FIND FIRST gsc_error NO-LOCK
           WHERE gsc_error.error_group  = cErrorGroup
             AND gsc_error.error_number = iErrorCode
           NO-ERROR.
    END.
  END.  /* if error group and error code specified */

  IF AVAILABLE gsc_error THEN
  DO:
    ASSIGN
      cMessage1 = gsc_error.ERROR_summary_description
      cMessage2 = gsc_error.ERROR_full_description
      . 
    IF gsc_error.UPDATE_error_log THEN  
      ASSIGN plUpdateErrorLog = YES.
  END.
  ELSE
  DO:
      /* Replace all the ampersand characters (&), if they are not to be used for substitution */
      ASSIGN cCleanMessage = "":U.
      DO iEntries = 1 TO NUM-ENTRIES(cMessage, "&":U):
          ASSIGN cAmpersandEntry = ENTRY(iEntries, cMessage, "&":U).

          IF iEntries                                                       >= 2 AND
             LOOKUP(SUBSTRING(cAmpersandEntry, 1, 1), "1,2,3,4,5,6,7,8,9":U) = 0 THEN
              ASSIGN cCleanMessage = cCleanMessage + cAmpersandEntry.
          ELSE
              ASSIGN cCleanMessage = cCleanMessage + (IF cCleanMessage = "":U THEN "":U ELSE " & ":U) + cAmpersandEntry.
      END.    /* loop through word */

      ASSIGN
          cMessage1 = cCleanMessage
          cMessage2 = cCleanMessage
           .

  END.  /*  n/a error */

  /* See if can work out error group and code from standard Progress Message */
  IF cErrorGroup = "":U AND iErrorCode = 0 THEN
  DO:
    ASSIGN
      ipos1 = R-INDEX(cMessage1, "(":U) + 1  
      ipos2 = R-INDEX(cMessage1, ")":U) - 1   
      ilen = (ipos2 - ipos1) + 1
      .
    IF ipos1 > 1 AND iLen > 0 THEN
    DO:
      ASSIGN 
        cCode = SUBSTRING(cMessage1, ipos1, ilen)
        iCode = 0.
      ASSIGN iCode = INTEGER(cCode) NO-ERROR.
      ASSIGN iErrorCode = iCode.
      IF iErrorCode <> 0 THEN ASSIGN cErrorGroup = "PSC":U.
    END.
  END.

  /* Translate insertion codes */
  DO iloop = 1 TO NUM-ENTRIES(cErrorInclude, "|":U):
    ASSIGN cOriginalText = ENTRY(iloop, cErrorInclude, "|":U).

    IF cOriginalText <> "":U THEN
    DO:
        cTranslatedText = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                           INPUT cOriginalText,
                                           INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).
        ASSIGN cErrorInclude = REPLACE(cErrorInclude, cOriginalText, cTranslatedText).
    END.    /* original text blank */
  END.

  /* Do substitutions (even if hard coded message - for cmessage1 and cmessage2) */
  ASSIGN
    cMessage1 = SUBSTITUTE(cMessage1,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 1 THEN ENTRY(1,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 2 THEN ENTRY(2,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 3 THEN ENTRY(3,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 4 THEN ENTRY(4,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 5 THEN ENTRY(5,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 6 THEN ENTRY(6,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 7 THEN ENTRY(7,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 8 THEN ENTRY(8,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 9 THEN ENTRY(9,cErrorInclude,"|":U) ELSE "":U
                           )
    cMessage2 = SUBSTITUTE(cMessage2,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 1 THEN ENTRY(1,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 2 THEN ENTRY(2,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 3 THEN ENTRY(3,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 4 THEN ENTRY(4,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 5 THEN ENTRY(5,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 6 THEN ENTRY(6,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 7 THEN ENTRY(7,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 8 THEN ENTRY(8,cErrorInclude,"|":U) ELSE "":U,
                           IF NUM-ENTRIES(cErrorInclude,"|":U) >= 9 THEN ENTRY(9,cErrorInclude,"|":U) ELSE "":U
                           )
    .

  /* rebuild error message using translated text in nice format (keep in synch, i.e. summary and full have some no. of messages) */  
  IF cProg12 = "":U AND cProg1 <> "":U THEN
    ASSIGN cProg12 = cProg1 + (IF cProg2 <> "":U THEN (":":U + cProg2) ELSE "":U).
  
  ASSIGN pcFullList = pcFullList + (IF pcSummaryList <> "":U THEN CHR(3) ELSE "":U) +
         TRIM(cMessage2) + CHR(10) + CHR(10) +
         "*** Error: ":U + 
         IF cErrorGroup = "":U THEN "":U ELSE (CAPS(TRIM(cErrorGroup)) + "-":U + TRIM(STRING(iErrorCode)) + " ":U) +
         IF cTable <> "":U THEN ("Table: ":U + TRIM(LC(cTable)) + " ":U) ELSE "":U +
         IF cField <> "":U THEN ("Field: ":U + TRIM(LC(cField)) + " ":U) ELSE "":U +
         IF cProg12 <> "":U THEN ("Program: ":U + TRIM(LC(cProg12))) ELSE "":U
         . 
  ASSIGN pcSummaryList = pcSummaryList + (IF pcSummaryList <> "":U THEN CHR(3) ELSE "":U) +
         TRIM(cMessage1) + IF (cErrorGroup <> "PSC":U AND cErrorGroup <> "":U) THEN (" (":U + CAPS(TRIM(cErrorGroup)) + ":":U + TRIM(STRING(iErrorCode)) + ")":U) ELSE "":U. 

END.  /* message-loop */

/* Translate title */
ASSIGN pcNewTitle = pcMessageTitle.
pcNewTitle = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                              INPUT pcMessageTitle,
                              INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).

/* Translate buttons */
ASSIGN pcNewButtonList = pcButtonList.


DO iloop = 1 TO NUM-ENTRIES(pcButtonList):
  ASSIGN cOriginalText = ENTRY(iloop, pcButtonList).

  IF cOriginalText <> "":U THEN
  DO:
      cTranslatedText = DYNAMIC-FUNCTION("translatePhrase":U IN gshTranslationManager,
                                         INPUT cOriginalText,
                                         INPUT IF AVAILABLE gsc_error THEN gsc_error.LANGUAGE_obj ELSE dLanguageObj).
      ASSIGN pcNewButtonList = REPLACE(pcNewButtonList, cOriginalText, cTranslatedText).
  END.  /* original text not blank */
END.

/* done */

/* MESSAGE "pcSummaryList=" pcSummaryList. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


