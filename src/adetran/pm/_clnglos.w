&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          xlatedb          PROGRESS
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
{adetran/pm/tranhelp.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VARIABLE _hGloss        AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE _hMeter        AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode    AS INTEGER                  NO-UNDO.
DEFINE SHARED VARIABLE StopProcessing AS LOGICAL                  NO-UNDO.
DEFINE SHARED VARIABLE s_Glossary     AS CHARACTER                NO-UNDO.
DEFINE        VARIABLE gloss-list     AS CHARACTER                NO-UNDO.

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
&Scoped-define INTERNAL-TABLES xlatedb.XL_Glossary

/* Definitions for DIALOG-BOX Gloss-Clnup                               */
&Scoped-define OPEN-QUERY-Gloss-Clnup OPEN QUERY Gloss-Clnup FOR EACH xlatedb.XL_Glossary SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Gloss-Clnup xlatedb.XL_Glossary
&Scoped-define FIRST-TABLE-IN-QUERY-Gloss-Clnup xlatedb.XL_Glossary


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BtnOK GlossaryName BtnCancel BtnHelp 
&Scoped-Define DISPLAYED-OBJECTS GlossaryName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp
     LABEL "&Help":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.125.

DEFINE VARIABLE GlossaryName AS CHARACTER FORMAT "x(30)" 
     LABEL "Glossary Name" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "(None)" 
     SIZE 23 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 51 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Gloss-Clnup FOR 
      xlatedb.XL_Glossary SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Gloss-Clnup
     BtnOK AT ROW 1.48 COL 56
     GlossaryName AT ROW 1.95 COL 25 COLON-ALIGNED
     BtnCancel AT ROW 2.71 COL 56
     BtnHelp AT ROW 3.95 COL 56
     RECT-1 AT ROW 1.48 COL 2
     SPACE(18.39) SKIP(1.94)
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
     _TblList          = "xlatedb.XL_Glossary"
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


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Gloss-Clnup
ON CHOOSE OF BtnHelp IN FRAME Gloss-Clnup /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("tran":U, "context":U, {&Glossary_Cleanup_DB}, ?).
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
  DEFINE VARIABLE tmp-lang      AS CHARACTER                    NO-UNDO.
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

  ASSIGN GlossaryName
         s_Glossary = GlossaryName.

  FIND FIRST xlatedb.XL_Project.
  FIND xlatedb.XL_Glossary 
       WHERE xlatedb.XL_Glossary.GlossaryName = s_Glossary NO-LOCK.
  ASSIGN tmp-lang = ENTRY(2, xlatedb.XL_Glossary.GlossaryType, "/":U).
  
  /* Count the glossary entries for this glossary if statistic not current */
  need-to-count = yes.
  IF NUM-ENTRIES(xlatedb.XL_Project.ProjectRevision, CHR(4)) > 1 THEN DO:
    IF ENTRY(2, xlatedb.XL_Project.ProjectRevision, CHR(4)) = "Yes":U THEN
      need-to-count = False.
  END.
  
  IF need-to-count THEN DO:
    FOR EACH xlatedb.XL_GlossDet WHERE
             xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK:
      gloss-cnt = gloss-cnt + 1.
    END.
  END.  /* If need to count */
  ELSE gloss-cnt = xlatedb.XL_Glossary.GlossaryCount.

  /* Build temp-table without &'s */
  FOR EACH xlatedb.XL_String_Info NO-LOCK:
    ASSIGN tmp-strng     =
                     REPLACE(xlatedb.XL_string_info.original_string,"&":U,"":U)
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
  RUN Realize IN _hMeter ("Cleaning Glossary...").

  /* Check each gloss entry */
  Glossary-Loop:
  FOR EACH xlatedb.XL_GlossDet WHERE
           xlatedb.XL_GlossDet.GlossaryName = s_Glossary
      EXCLUSIVE-LOCK TRANSACTION:
    process-cnt = process-cnt + 1.
    IF process-cnt MOD 25 = 1 THEN DO:  /* Time to check events */
      PROCESS EVENTS.  /* See if user wants to abort */
      IF StopProcessing THEN DO:
        RUN HideMe in _hMeter.
        LEAVE Glossary-Loop.
      END.
      RUN SetBar in _hMeter (gloss-cnt, process-cnt,
                             xlatedb.XL_GlossDet.ShortSrc).
    END.

    IF NOT CAN-FIND(FIRST tt-si WHERE
                    tt-si.shrt-str = xlatedb.XL_GlossDet.ShortSrc AND
                    tt-si.str-info MATCHES xlatedb.XL_GlossDet.SourcePhrase)
    THEN DO:
      DELETE xlatedb.XL_GlossDet.
      remove-cnt = remove-cnt + 1.
    END.
  END.  /* For each GlossDet TRANSACTION */
  RUN HideMe IN _hMeter.
  
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
    FIND xlatedb.XL_Glossary
         WHERE xlatedb.XL_Glossary.GlossaryName = s_Glossary EXCLUSIVE-LOCK.
    ASSIGN xlatedb.XL_Glossary.GlossaryCount = gloss-cnt - remove-cnt.
  END.
  /* Refresh glossary tab if showing */
  IF remove-cnt > 0 AND CurrentMode = 3 AND VALID-HANDLE(_hGloss) THEN
    RUN OpenQuery IN _hGloss.
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

  /* make sure that at least one glossary exists. */
  FIND FIRST xlatedb.XL_glossary NO-LOCK NO-ERROR.
  IF NOT AVAILABLE xlatedb.XL_Glossary THEN DO:
    MESSAGE "The Glossary Cleanup utility requires that" SKIP
            "at least one glossary is defined." VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  FOR EACH xlatedb.XL_glossary NO-LOCK BY xlatedb.XL_Glossary.GlossaryName:
    Gloss-List = Gloss-List + ",":U + xlatedb.XL_Glossary.GlossaryName.
  END.
  ASSIGN Gloss-List                = LEFT-TRIM(Gloss-List, ",":U)
         GlossaryName:LIST-ITEMS   = Gloss-List
         GlossaryName:SCREEN-VALUE = IF LOOKUP(s_Glossary,Gloss-List) > 0
                                     THEN s_Glossary
                                     ELSE GlossaryName:ENTRY(1)
         GlossaryName.
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
  DISPLAY GlossaryName 
      WITH FRAME Gloss-Clnup.
  ENABLE RECT-1 BtnOK GlossaryName BtnCancel BtnHelp 
      WITH FRAME Gloss-Clnup.
  VIEW FRAME Gloss-Clnup.
  {&OPEN-BROWSERS-IN-QUERY-Gloss-Clnup}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


