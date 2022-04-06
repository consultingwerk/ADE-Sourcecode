&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          kit              PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Pretranslation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Pretranslation 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: adetran/vt/_pretran.w

  Description: Preliminary (automatic) translation procedure
      This is a "batch" process to automatically apply glossary entries to
      untranslated source strings.  This is considered preliminary as we
      believe that good translations require human intervention, however
      this is still a time saver as many translations can be achieved and
      then editted by a human.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: D. Ross Hunter

  Created: 6/18/96
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adetran/vt/vthlp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE hMeter         AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE hTrans         AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode    AS INTEGER                  NO-UNDO.
DEFINE SHARED VARIABLE StopProcessing AS LOGICAL                  NO-UNDO.

DEFINE VARIABLE fnt            AS INTEGER   INITIAL ?             NO-UNDO.
DEFINE VARIABLE fnt-list       AS CHARACTER INITIAL "(Default)"   NO-UNDO.
DEFINE VARIABLE i              AS INTEGER                         NO-UNDO.

DEFINE STREAM excp-log.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Pretranslation

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES XL_GlossEntry

/* Definitions for DIALOG-BOX Pretranslation                            */
&Scoped-define OPEN-QUERY-Pretranslation OPEN QUERY Pretranslation FOR EACH XL_GlossEntry SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Pretranslation XL_GlossEntry
&Scoped-define FIRST-TABLE-IN-QUERY-Pretranslation XL_GlossEntry


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK match-rule BtnCancel BtnHelp ~
Exceptions rs-direct MS-print Landscape pg-sz cb-font RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS match-rule Exceptions rs-direct MS-print ~
Landscape pg-sz cb-font file-name lns 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_files 
     LABEL "&Files..." 
     SIZE 15 BY 1.14.

DEFINE VARIABLE cb-font AS CHARACTER FORMAT "X(256)":U INITIAL "(Default)" 
     LABEL "F&ont" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "(Default)","0" 
     DROP-DOWN-LIST
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE file-name AS CHARACTER FORMAT "X(256)":U INITIAL "pretrans.log" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE lns AS CHARACTER FORMAT "X(256)":U INITIAL "(Lines)" 
      VIEW-AS TEXT 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE pg-sz AS INTEGER FORMAT "  >>9":U INITIAL 66 
     LABEL "Page &Size" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE match-rule AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Translate case-sensitive matches only", 1,
"Use case-insensitive match if necessary", 2,
"Use case-insensitive match and trim phrase if necessary", 3
     SIZE 62 BY 2.52 NO-UNDO.

DEFINE VARIABLE rs-direct AS LOGICAL INITIAL yes 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Output To &Printer", no,
"Output to A &Text File", yes
     SIZE 23 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69 BY 6.43.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69 BY 3.29.

DEFINE VARIABLE Exceptions AS LOGICAL INITIAL no 
     LABEL "&Exceptions Report" 
     VIEW-AS TOGGLE-BOX
     SIZE 42 BY .81 NO-UNDO.

DEFINE VARIABLE Landscape AS LOGICAL INITIAL no 
     LABEL "&Landscape" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .76 NO-UNDO.

DEFINE VARIABLE MS-print AS LOGICAL INITIAL no 
     LABEL "&MS Print Setup Dialog" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .76 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Pretranslation FOR 
      XL_GlossEntry SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Pretranslation
     BtnOK AT ROW 1.48 COL 73
     match-rule AT ROW 1.81 COL 8 NO-LABEL
     BtnCancel AT ROW 2.86 COL 73
     BtnHelp AT ROW 4.76 COL 73
     Exceptions AT ROW 5.71 COL 5
     rs-direct AT ROW 6.91 COL 5 NO-LABEL
     MS-print AT ROW 6.95 COL 38
     Landscape AT ROW 7.71 COL 38
     pg-sz AT ROW 8.81 COL 14 COLON-ALIGNED
     cb-font AT ROW 8.86 COL 46 COLON-ALIGNED
     file-name AT ROW 10.14 COL 3 COLON-ALIGNED NO-LABEL
     btn_files AT ROW 10.19 COL 54
     lns AT ROW 8.81 COL 19.2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 5.29 COL 2
     RECT-2 AT ROW 1.52 COL 2
     SPACE(18.79) SKIP(7.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "PreTranslation"
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Pretranslation
   L-To-R                                                               */
ASSIGN 
       FRAME Pretranslation:SCROLLABLE       = FALSE
       FRAME Pretranslation:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btn_files IN FRAME Pretranslation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN file-name IN FRAME Pretranslation
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lns IN FRAME Pretranslation
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Pretranslation
/* Query rebuild information for DIALOG-BOX Pretranslation
     _TblList          = "kit.XL_GlossEntry"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Pretranslation */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Pretranslation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Pretranslation Pretranslation
ON WINDOW-CLOSE OF FRAME Pretranslation /* PreTranslation */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Pretranslation
ON CHOOSE OF BtnHelp IN FRAME Pretranslation /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("VT":U, "CONTEXT":U, {&PreTranslation_DB}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Pretranslation
ON CHOOSE OF BtnOK IN FRAME Pretranslation /* OK */
DO:
  DEFINE VARIABLE csens-cnt   AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE cs-short    AS CHARACTER CASE-SENSITIVE     NO-UNDO.
  DEFINE VARIABLE cs-strng    AS CHARACTER CASE-SENSITIVE     NO-UNDO.
  DEFINE VARIABLE exist-cnt   AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE flnm        AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE inst-cnt    AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE line2       AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE mlt-cnt     AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE p-exist-cnt AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE p-inst-cnt  AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE p-mlt-cnt   AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE p-trans-cnt AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE p-untr-cnt  AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE prFlag      AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE prt-status  AS LOGICAL                      NO-UNDO.
  DEFINE VARIABLE proc-cnt    AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE time-stamp  AS DECIMAL                      NO-UNDO.
  DEFINE VARIABLE tmp-flnm    AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE tmp-lang    AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE tmp-strng   AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE trans-cnt   AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE untr-cnt    AS INTEGER                      NO-UNDO.
  DEFINE VARIABLE foundROWID  AS ROWID                        NO-UNDO.
  DEFINE VARIABLE foundit     AS LOGICAL                      NO-UNDO.

  ASSIGN match-rule
         Exceptions rs-direct MS-print Landscape pg-sz cb-font file-name
         time-stamp = INT(TODAY) + (TIME / 100000).

  FORM HEADER "Visual Translator PreTranslation Report"
            PAGE-NUMBER(excp-log) AT 68 FORMAT "Page >>>9" SKIP
            line2 FORMAT "X(78)" NO-LABEL SKIP (1)
     WITH FRAME normal-width NO-BOX NO-LABELS PAGE-TOP STREAM-IO.

  FORM HEADER "Visual Translator Manager PreTranslation Report"
            PAGE-NUMBER(excp-log) AT 108 FORMAT "Page >>>9" SKIP
            line2 FORMAT "X(118)" SKIP (1)
     WITH FRAME landscape WIDTH 120 NO-BOX PAGE-TOP NO-LABELS STREAM-IO.

  IF Exceptions THEN DO:
    IF NOT rs-direct THEN /* Output to Printer - change flnm to a
                              temporary filename */
      RUN adecomm/_tmpfile.p ("VT":U, ".tmp":U, OUTPUT flnm).
    ELSE flnm = file-name.
    OUTPUT STREAM excp-log TO VALUE(flnm) PAGE-SIZE VALUE(pg-sz).
    IF Landscape THEN VIEW STREAM excp-log FRAME landscape.
    ELSE VIEW STREAM excp-log FRAME normal-width.
  END.  /* If the user wants an exceptions log */

  FIND FIRST kit.XL_Project NO-LOCK.
  line2 = FILL(" ":U, ((IF Landscape THEN 44 ELSE 24) -
               INTEGER(LENGTH(kit.XL_Project.ProjectName,
                              "CHARACTER":U) / 2))) +
          "Project: " + kit.XL_Project.ProjectName + " " + STRING(TODAY) +
          "  " + STRING(TIME,"HH:MM pm").

  HIDE Frame {&FRAME-NAME}.
  RUN Realize IN hMeter ("PreTranslating...").

  /* Group translations by procedure */
  Procedure-Loop:
  FOR EACH kit.XL_Procedure NO-LOCK TRANSACTION:
    PROCESS EVENTS.  /* See if user wants to abort */
    IF StopProcessing THEN DO:
      RUN HideMe in hMeter.
      LEAVE Procedure-Loop.
    END.

    /* Set filename and procedure count */
    ASSIGN proc-cnt = proc-cnt + 1
           tmp-flnm = (IF kit.XL_Procedure.Directory NE ".":U
                       THEN kit.XL_Procedure.Directory + "~\":U
                       ELSE "":U) + kit.XL_Procedure.FileName.
    RUN SetBar in hMeter (kit.XL_Project.NumberOfProcedures,
                           proc-cnt, tmp-flnm).
    IF Exceptions THEN
      DISPLAY STREAM excp-log tmp-flnm LABEL "Procedure" FORMAT "X(60)"
           WITH FRAME proc SIDE-LABELS NO-BOX STREAM-IO.
    ASSIGN p-inst-cnt  = 0
           p-exist-cnt = 0
           p-trans-cnt = 0
           p-untr-cnt  = 0
           p-mlt-cnt   = 0.

    INSTANCE-LOOP:
    FOR EACH kit.XL_instance
       WHERE kit.XL_instance.ProcedureName = tmp-flnm:
      ASSIGN p-inst-cnt = p-inst-cnt + 1
             inst-cnt   = inst-cnt + 1.

      /* See if a translation already exists */
      IF kit.XL_Instance.TargetPhrase NE "":U THEN DO:
        ASSIGN p-exist-cnt = p-exist-cnt + 1
               exist-cnt   = exist-cnt + 1.
        NEXT INSTANCE-LOOP.
      END.

      /* Try a case-sensitive match first */
      ASSIGN cs-strng = REPLACE(kit.XL_Instance.SourcePhrase, "&":U, "")
             cs-short = SUBSTRING(cs-strng,1,63,"RAW":U)
             tmp-strng = cs-short  /* case-insensitive */
             foundit   = no.

      FOR EACH kit.XL_GlossEntry
        WHERE kit.XL_GlossEntry.ShortSrc BEGINS tmp-strng NO-LOCK:
        IF COMPARE(kit.XL_GlossEntry.SourcePhrase, "=":U, cs-strng, "RAW":U) THEN
        DO:
          foundit = yes.
          LEAVE.
        END.
      END.

      IF AVAILABLE kit.XL_GlossEntry AND foundit = yes THEN
        csens-cnt = csens-cnt + 1.
      ELSE IF match-rule = 2 THEN
      DO:
        foundit = yes.
        /* Now try an insensitive search */
        tmp-strng = cs-strng.
        FIND FIRST kit.XL_GlossEntry WHERE
                   kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(tmp-strng,1,63,"RAW":U) AND
                   kit.XL_GlossEntry.SourcePhrase MATCHES tmp-strng
           NO-LOCK NO-ERROR.
      END.  /* If not found with case sensitive search */
      ELSE IF match-rule = 3 THEN
      DO:
        foundit = yes.
        /* Now try an insensitive search after TRIM has been used */
        tmp-strng = TRIM(cs-strng).
        FIND FIRST kit.XL_GlossEntry WHERE
                   kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(tmp-strng,1,63,"RAW":U) AND
                   kit.XL_GlossEntry.SourcePhrase MATCHES tmp-strng
           NO-LOCK NO-ERROR.
      END. /* If not found with case sensitive or case insensitive search */

      IF AVAILABLE kit.XL_GlossEntry AND foundit THEN DO:
        ASSIGN p-trans-cnt = p-trans-cnt + 1
               trans-cnt   = trans-cnt + 1
               kit.XL_Instance.ShortTarg    = kit.XL_GlossEntry.ShortTarg
               kit.XL_Instance.TargetPhrase = kit.XL_GlossEntry.TargetPhrase.
        IF Exceptions THEN DO:
          /* Are there more translations ? */
          tmp-strng = cs-strng.
          FIND LAST kit.XL_GlossEntry WHERE
                    kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(tmp-strng,1,63,"RAW":U) AND
                    kit.XL_GlossEntry.SourcePhrase MATCHES tmp-strng
               NO-LOCK.
          IF kit.XL_GlossEntry.TargetPhrase NE kit.XL_Instance.TargetPhrase THEN DO:
            ASSIGN mlt-cnt   = mlt-cnt + 1
                   p-mlt-cnt = p-mlt-cnt + 1.
            /* Output the translation */
            IF Landscape THEN
              DISPLAY STREAM excp-log
                      kit.XL_Instance.SourcePhrase FORMAT "X(53)" AT 6
                      "->" kit.XL_Instance.TargetPhrase AT 63 FORMAT "X(53)"
                    WITH FRAME Land-tran NO-BOX NO-LABELS WIDTH 120 STREAM-IO.
            ELSE
              DISPLAY STREAM excp-log
                      kit.XL_Instance.SourcePhrase FORMAT "X(33)" AT 6
                      "->" kit.XL_Instance.TargetPhrase AT 43 FORMAT "X(33)"
                    WITH FRAME tran NO-BOX NO-LABELS STREAM-IO.
            /* Now output the other possibilities (the losers) */
            FOR EACH  kit.XL_GlossEntry WHERE
                    kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(tmp-strng,1,63,"RAW":U) AND
                    kit.XL_GlossEntry.SourcePhrase MATCHES tmp-strng AND
                    kit.XL_GlossEntry.TargetPhrase NE kit.XL_Instance.TargetPhrase
               NO-LOCK:

              IF Landscape THEN
                DISPLAY STREAM excp-log "-" AT 60
                     kit.XL_GlossEntry.TargetPhrase AT 63 FORMAT "X(53)"
                        WITH FRAME Land-loser NO-BOX NO-LABELS WIDTH 120 STREAM-IO.
              ELSE
                DISPLAY STREAM excp-log "-" AT 40
                     kit.XL_GlossEntry.TargetPhrase AT 43 FORMAT "X(33)"
                        WITH FRAME loser NO-BOX NO-LABELS STREAM-IO.
            END.  /* For each loser */
          END. /* There is more than one translation */
        END.  /* There is an exceptions report */
      END.  /* If a match was made */
      ELSE DO:  /* No match (or translation) made */
        IF Exceptions THEN DO:
          ASSIGN p-untr-cnt = p-untr-cnt + 1
                 untr-cnt   = untr-cnt + 1.
          IF LENGTH(kit.XL_Instance.SourcePhrase,"Character":U) >
              (IF Landscape THEN 95 ELSE 55) THEN DO:
            ASSIGN cs-strng = SUBSTRING(kit.XL_Instance.SourcePhrase, 1,
                                 IF Landscape THEN 95 ELSE 55, "CHARACTER":U) + "...":U.
          END.
          ELSE cs-strng = kit.XL_Instance.SourcePhrase.

          IF Landscape THEN
            DISPLAY STREAM excp-log
                       cs-strng FORMAT "X(98)" AT 6 "Untranslated":U
                    WITH FRAME land-untran NO-BOX NO-LABELS WIDTH 120 STREAM-IO.
          ELSE
            DISPLAY STREAM excp-log
                       cs-strng FORMAT "X(58)" AT 6 "Untranslated":U
                    WITH FRAME untran NO-BOX NO-LABELS STREAM-IO.
        END.  /* If an exception report */
      END.  /* No match (or translation) made */
    END.  /* For each string instance of a procedure */
    IF Exceptions THEN
      DISPLAY STREAM excp-log
              "SUMMARY:" AT 8
               p-inst-cnt AT 18  FORMAT ">>,>>9 Strings Total"
                  (100 * p-inst-cnt) / MAX(1, p-inst-cnt)  AT 60 FORMAT ">>9 %" SKIP
               p-exist-cnt AT 18 FORMAT ">>,>>9 Existing Translations"
                  (100 * p-exist-cnt) / MAX(1, p-inst-cnt) AT 60 FORMAT ">>9 %" SKIP
               p-trans-cnt AT 18 FORMAT ">>,>>9 Strings Translated"
                  (100 * p-trans-cnt) / MAX(1, p-inst-cnt) AT 60 FORMAT ">>9 %" SKIP
               p-untr-cnt AT 18  FORMAT ">>,>>9 Strings Untranslated"
                  (100 * p-untr-cnt) / MAX(1, p-inst-cnt)  AT 60 FORMAT ">>9 %" SKIP
               p-mlt-cnt AT 18   FORMAT ">>,>>9 Strings with Multiple Translations"
                  (100 * p-mlt-cnt) / MAX(1, p-inst-cnt)   AT 60 FORMAT ">>9 %" SKIP (1)
          WITH FRAME psummary NO-BOX NO-LABELS STREAM-IO.

  END.  /* For each procedure TRANSACTION */

  RUN HideMe IN hMeter.

  IF Exceptions THEN DO:
    DISPLAY STREAM excp-log SKIP (4)
            "GRAND SUMMARY:" AT 8 SKIP
             inst-cnt AT 18  FORMAT ">>,>>9 Strings Total"
                (100 * inst-cnt) / MAX(1, inst-cnt)  AT 60 FORMAT ">>9 %" SKIP
             exist-cnt AT 18 FORMAT ">>,>>9 Existing Translations"
                (100 * exist-cnt) / MAX(1, inst-cnt) AT 60 FORMAT ">>9 %" SKIP
             trans-cnt AT 18 FORMAT ">>,>>9 Strings Translated"
                (100 * trans-cnt) / MAX(1, inst-cnt) AT 60 FORMAT ">>9 %" SKIP
             untr-cnt AT 18  FORMAT ">>,>>9 Strings Untranslated"
                (100 * untr-cnt) / MAX(1, inst-cnt)  AT 60 FORMAT ">>9 %" SKIP
             mlt-cnt AT 18   FORMAT ">>,>>9 Strings with Multiple Translations"
                (100 * mlt-cnt) / MAX(1, inst-cnt)   AT 60 FORMAT ">>9 %"
        WITH FRAME summary NO-BOX NO-LABELS STREAM-IO.

    OUTPUT STREAM excp-log CLOSE.
  END.  /* If Exceptions */

  MESSAGE SUBSTITUTE("&1 out of &2 files were processed (&3).",
            LEFT-TRIM(STRING(proc-cnt,"zz,zz9":U)),
            LEFT-TRIM(STRING(kit.XL_Project.NumberOfProcedures,"zz,zz9":U)),
            LEFT-TRIM(STRING((100.0 * proc-cnt) / kit.XL_Project.NumberOfProcedures,
                              "zz9%":U))) SKIP
          SUBSTITUTE("&1 out of &2 strings were translated (&3).",
            LEFT-TRIM(STRING(trans-cnt,"z,zzz,zz9":U)),
            LEFT-TRIM(STRING(inst-cnt,"z,zzz,zz9":U)),
            LEFT-TRIM(STRING((100.0 * trans-cnt) / inst-cnt, "zz9%":U))) SKIP
          SUBSTITUTE("&1 strings were already translated.",
            LEFT-TRIM(STRING(exist-cnt,"zzz,zz9":U))) SKIP
          SUBSTITUTE("&1 matches were case-sensitive.",
            LEFT-TRIM(STRING(csens-cnt,"zzz,zz9":U))) SKIP
          SUBSTITUTE("&1 matches were case-insensitive.",
            LEFT-TRIM(STRING(trans-cnt - csens-cnt,"zzz,zz9":U))) SKIP (1)
       VIEW-AS ALERT-BOX INFORMATION.

  IF Exceptions AND NOT rs-direct THEN DO:  /* Output is to the Printer */
    PrFlag = (IF MS-Print:CHECKED THEN 1 ELSE 0) +
             (IF Landscape:CHECKED THEN 2 ELSE 0).
    RUN adecomm/_osprint.p (INPUT CURRENT-WINDOW,
                            INPUT flnm,
                            INPUT fnt,
                            INPUT PrFlag + 
                              (IF SESSION:CPSTREAM = "utf-8":U THEN 512 ELSE 0),
                            INPUT pg-sz,
                            INPUT 0,
                            OUTPUT prt-status).
    OS-DELETE VALUE (flnm).
  END.  /* If output is to the printer */

  /* Indicate that statistics have to be refreshed
   * ProjectRevision contains the revision# CHR(4) refresh? CHR(4) wordCount?
   */
  DO TRANSACTION:
    FIND FIRST Kit.XL_Project EXCLUSIVE-LOCK.
    ASSIGN Kit.XL_Project.ProjectRevision  =
              ENTRY(1, Kit.XL_Project.ProjectRevision,CHR(4)) + CHR(4) + "No":U +
              CHR(4) + (IF NUM-ENTRIES(Kit.XL_Project.ProjectRevision,CHR(4)) > 2 THEN
              ENTRY(3, Kit.XL_Project.ProjectRevision,CHR(4)) ELSE "":U)
           Kit.XL_Project.TranslationCount = Kit.XL_Project.TranslationCount + trans-cnt.
  END.  /* Do Transaction */

  /* Refresh screen if on the data-tab */
  IF trans-cnt > 0 AND CurrentMode = 2 AND VALID-HANDLE(hTrans) THEN
    RUN OpenQuery IN hTrans.
END.  /* On choose of BtnOK */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_files
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_files Pretranslation
ON CHOOSE OF btn_files IN FRAME Pretranslation /* Files... */
DO:
  DEFINE VARIABLE OKPressed AS LOGICAL                    NO-UNDO.

  SYSTEM-DIALOG GET-FILE file-name
         TITLE   "Statistics Text File"
         FILTERS "Log Files (*.log)"  "*.log":U,
                 "Text Files (*.txt)" "*.txt":U,
                 "All Files (*.*)"    "*.*":U
         USE-FILENAME
         UPDATE OKPressed.
  IF OKPressed THEN file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME} = file-name.
  ELSE file-name = file-name:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-font
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-font Pretranslation
ON VALUE-CHANGED OF cb-font IN FRAME Pretranslation /* Font */
DO:
  ASSIGN cb-font
         fnt     = IF SELF:SCREEN-VALUE = "(Default)":U THEN ?
                   ELSE INTEGER(SELF:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Exceptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Exceptions Pretranslation
ON VALUE-CHANGED OF Exceptions IN FRAME Pretranslation /* Exceptions Report */
DO:
  RUN set_sensitivity.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pg-sz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pg-sz Pretranslation
ON LEAVE OF pg-sz IN FRAME Pretranslation /* Page Size */
DO:
  ASSIGN pg-sz.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-direct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-direct Pretranslation
ON VALUE-CHANGED OF rs-direct IN FRAME Pretranslation
DO:
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN rs-direct
           file-name:SENSITIVE = rs-direct
           btn_files:SENSITIVE = file-name:SENSITIVE
           MS-print:SENSITIVE  = NOT file-name:SENSITIVE
           cb-font:SENSITIVE   = NOT file-name:SENSITIVE.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Pretranslation 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  DO i = 1 TO (FONT-TABLE:NUM-ENTRIES - 1):
    fnt-list = fnt-list + ",":U + STRING(i).
  END.
  ASSIGN cb-font:LIST-ITEMS = fnt-list.


  RUN enable_UI.
  RUN set_sensitivity.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Pretranslation  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Pretranslation.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Pretranslation  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-Pretranslation}
  GET FIRST Pretranslation.
  DISPLAY match-rule Exceptions rs-direct MS-print Landscape pg-sz cb-font 
          file-name lns 
      WITH FRAME Pretranslation.
  ENABLE BtnOK match-rule BtnCancel BtnHelp Exceptions rs-direct MS-print 
         Landscape pg-sz cb-font RECT-1 RECT-2 
      WITH FRAME Pretranslation.
  VIEW FRAME Pretranslation.
  {&OPEN-BROWSERS-IN-QUERY-Pretranslation}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_sensitivity Pretranslation 
PROCEDURE set_sensitivity :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN rs-direct:SENSITIVE = Exceptions:CHECKED
           MS-print:SENSITIVE  = Exceptions:CHECKED AND NOT rs-direct
           Landscape:SENSITIVE = Exceptions:CHECKED
           pg-sz:SENSITIVE     = Exceptions:CHECKED
           cb-font:SENSITIVE   = Exceptions:CHECKED AND NOT rs-direct
           file-name:SENSITIVE = Exceptions:CHECKED AND rs-direct
           btn_files:SENSITIVE = Exceptions:CHECKED AND rs-direct.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

