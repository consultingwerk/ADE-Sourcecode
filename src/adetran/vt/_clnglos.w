&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          kit              PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Gloss-Clnup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Gloss-Clnup 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _clnglos.w

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
  Updated: 11/96 SLK Changed for FONT
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE hGloss         AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE hMeter         AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode    AS INTEGER                  NO-UNDO.
DEFINE SHARED VARIABLE StopProcessing AS LOGICAL                  NO-UNDO.
DEFINE SHARED VARIABLE tModFlag       AS LOGICAL			NO-UNDO.

DEFINE TEMP-TABLE tt-si NO-UNDO
       FIELD str-info AS CHARACTER
       FIELD shrt-str AS CHARACTER
    INDEX si IS PRIMARY shrt-str.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Gloss-Clnup

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES kit.XL_GlossEntry

/* Definitions for DIALOG-BOX Gloss-Clnup                               */
&Scoped-define OPEN-QUERY-Gloss-Clnup OPEN QUERY Gloss-Clnup FOR EACH kit.XL_GlossEntry SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Gloss-Clnup kit.XL_GlossEntry
&Scoped-define FIRST-TABLE-IN-QUERY-Gloss-Clnup kit.XL_GlossEntry


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BtnOK BtnCancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.12.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65 BY 4.77.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Gloss-Clnup FOR 
      kit.XL_GlossEntry SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Gloss-Clnup
     BtnOK AT ROW 1.35 COL 68
     BtnCancel AT ROW 2.58 COL 68
     RECT-1 AT ROW 1.23 COL 2
     "The Glossary Cleanup utility removes from the" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 1.46 COL 4
          FONT 4
     "designated glossary all of the entries that do not" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 2.19 COL 4
          FONT 4
     "correspond to extracted phrases in the project." VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 2.92 COL 4
          FONT 4
     "Before proceeding, it is a good idea to export the" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 3.62 COL 4
          FONT 4
     "glossary to a file so that entries can be restored at" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 4.35 COL 4
          FONT 4
     "a later time if necessary." VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 5.04 COL 4
          FONT 4
     SPACE(17.28) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Glossary Cleanup"
         DEFAULT-BUTTON BtnOK.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Gloss-Clnup
   L-To-R                                                               */
ASSIGN 
       FRAME Gloss-Clnup:SCROLLABLE       = FALSE
       FRAME Gloss-Clnup:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Gloss-Clnup
/* Query rebuild information for DIALOG-BOX Gloss-Clnup
     _TblList          = "kit.XL_GlossEntry"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Gloss-Clnup */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Gloss-Clnup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Gloss-Clnup Gloss-Clnup
ON WINDOW-CLOSE OF FRAME Gloss-Clnup /* Glossary Cleanup */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Gloss-Clnup
ON CHOOSE OF BtnOK IN FRAME Gloss-Clnup /* OK */
DO:
  DEFINE VARIABLE gloss-cnt     AS INTEGER   INITIAL 0          NO-UNDO.
  DEFINE VARIABLE process-cnt   AS INTEGER   INITIAL 0          NO-UNDO.
  DEFINE VARIABLE need-to-count AS LOGICAL   INITIAL TRUE       NO-UNDO.
  DEFINE VARIABLE remove-cnt    AS INTEGER   INITIAL 0          NO-UNDO.
  DEFINE VARIABLE tmp-short-str AS CHARACTER                    NO-UNDO.
  DEFINE VARIABLE tmp-strng     AS CHARACTER                    NO-UNDO.

  FORM SKIP (1) SPACE (3)
    "  Building temporary tables ... " VIEW-AS TEXT
    SPACE (3) SKIP (1)
    WITH FRAME updmsg NO-LABEL VIEW-AS DIALOG-BOX THREE-D
    TITLE "Please wait ...".
  
  RUN adecomm/_setcurs.p ("WAIT":U).
  VIEW FRAME updmsg IN WINDOW Current-Window.
  APPLY "ENTRY" TO FRAME UpdMsg.
  RUN adecomm/_setcurs.p ("WAIT":U).

  /* Count the glossary entries for this glossary if statistic not current */
  FOR EACH kit.XL_GlossENTRY NO-LOCK:
      gloss-cnt = gloss-cnt + 1.
  END.

  /* Build temp-table without &'s */
  FOR EACH kit.XL_Instance NO-LOCK:
    ASSIGN tmp-strng     = REPLACE(kit.XL_Instance.SourcePhrase,"&":U,"":U)
           tmp-short-str = SUBSTRING(tmp-strng, 1, 63, "RAW":U).
    IF NOT CAN-FIND(tt-si WHERE tt-si.shrt-str = tmp-short-str AND
                                tt-si.str-info MATCHES tmp-strng) THEN DO:
      CREATE tt-si.
      ASSIGN tt-si.shrt-str = tmp-short-str
             tt-si.str-info = tmp-strng.
    END.
  END.
    
  HIDE Frame UpdMsg.
  HIDE Frame {&FRAME-NAME}.
  RUN adecomm/_setcurs.p ("":U).
  RUN Realize IN hMeter ("Cleaning Glossary...").

  /* Check each gloss entry */
  Glossary-Loop:
  FOR EACH kit.XL_GlossEntry EXCLUSIVE-LOCK TRANSACTION:
    process-cnt = process-cnt + 1.
    IF process-cnt MOD 25 = 1 THEN DO:  /* Time to check events */
      PROCESS EVENTS.  /* See if user wants to abort */
      IF StopProcessing THEN DO:
        RUN HideMe in hMeter.
        LEAVE Glossary-Loop.
      END.
      RUN SetBar in hMeter (gloss-cnt, process-cnt,
                             kit.XL_GlossEntry.ShortSrc).
    END.

    IF NOT CAN-FIND(tt-si WHERE
           tt-si.shrt-str = kit.XL_GlossEntry.ShortSrc AND 
           tt-si.str-info MATCHES kit.XL_GlossEntry.SourcePhrase)
    THEN DO:
      DELETE kit.XL_GlossEntry.
      remove-cnt = remove-cnt + 1.
    END.
  END.  /* For each GlossDet TRANSACTION */
  RUN HideMe IN hMeter.

  IF remove-cnt > 0 THEN
    tModFlag = yes.
  
  MESSAGE SUBSTITUTE("&1 out of &2 glossary entries were processed (&3).",
            LEFT-TRIM(STRING(process-cnt,"zz,zz9":U)),
            LEFT-TRIM(STRING(gloss-cnt,"zz,zz9":U)),
            LEFT-TRIM(STRING((100.0 * process-cnt) / gloss-cnt,
                              "zz9%":U))) SKIP
          SUBSTITUTE("&1 glossary entries were removed (&2).",
            LEFT-TRIM(STRING(remove-cnt,"z,zzz,zz9":U)),
            LEFT-TRIM(STRING((100.0 * remove-cnt) / gloss-cnt, "zz9%":U))) SKIP
          SUBSTITUTE("&1 glossary entries remain.",
            LEFT-TRIM(STRING(gloss-cnt - remove-cnt,"zzz,zz9":U))) SKIP (1)
       VIEW-AS ALERT-BOX INFORMATION.
  DO TRANSACTION:                   
    FIND kit.XL_Project EXCLUSIVE-LOCK.
    ASSIGN kit.XL_Project.GlossaryCount = gloss-cnt - remove-cnt.
  END.
  /* Refresh Screen if Glossary Tab */
  IF remove-cnt > 0 AND CurrentMode = 3 AND VALID-HANDLE(hGloss) THEN
    RUN OpenQuery IN hGloss.
END.  /* On choose of BtnOK */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Gloss-Clnup 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Gloss-Clnup _DEFAULT-DISABLE
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
  HIDE FRAME Gloss-Clnup.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Gloss-Clnup _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Gloss-Clnup}
  GET FIRST Gloss-Clnup.
  ENABLE RECT-1 BtnOK BtnCancel 
      WITH FRAME Gloss-Clnup.
  VIEW FRAME Gloss-Clnup.
  {&OPEN-BROWSERS-IN-QUERY-Gloss-Clnup}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


