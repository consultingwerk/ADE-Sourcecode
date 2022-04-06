&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_wiz12.w
Author:       R. Ryan
Created:      1/95
Updated:      9/95
                07/98 SLK LARGE editor
Purpose:      Persistent procedure that reads/writes
              XL_CustomFilter which pertain to user-supplied
              values.
Called By:    adetran/pm/_wizard.w

*/

DEFINE INPUT PARAMETER parentframe  AS WIDGET-HANDLE                 NO-UNDO.
DEFINE SHARED VARIABLE pMatchCase   AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE        Tmp_FileName AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE        Return_Status AS LOGICAL                      NO-UNDO.
DEFINE STREAM tmpSTREAM.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Mode12

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CustomFilters MatchCase 
&Scoped-Define DISPLAYED-OBJECTS CustomFilters MatchCase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE CustomFilters AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL LARGE
     SIZE 30.2 BY 5.67 NO-UNDO.

DEFINE VARIABLE MatchCase AS LOGICAL INITIAL no 
     LABEL "&Match case":L 
     VIEW-AS TOGGLE-BOX
     SIZE 30.2 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode12
     CustomFilters AT ROW 1.19 COL 1.8 NO-LABEL
     MatchCase AT ROW 7 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.69
         SIZE 32.86 BY 8.15
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 10
         WIDTH              = 82
         MAX-HEIGHT         = 23.14
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.14
         VIRTUAL-WIDTH      = 114.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Mode12
   L-To-R                                                               */
ASSIGN 
       CustomFilters:RETURN-INSERTED IN FRAME Mode12  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MatchCase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MatchCase C-Win
ON VALUE-CHANGED OF MatchCase IN FRAME Mode12 /* Match case */
DO:
  pMatchCase = self:checked.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       frame {&frame-name}:hidden    = true
       frame {&frame-name}:frame     = ParentFrame
       pMatchCase = CAN-FIND(FIRST xlatedb.XL_CustomFilter WHERE
             xlatedb.XL_CustomFilter.RecType = "USER" AND
             xlatedb.XL_CustomFilter.Filter = "X-INIT|CS":U)
       MatchCase:checked             = pMatchCase.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK: run GetDB.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
DEFINE VARIABLE byte-cnt AS INTEGER                                    NO-UNDO.
   DEFINE VARIABLE firstRec AS LOGICAL                                    NO-UNDO.

   DO WITH FRAME {&FRAME-NAME}:
      /* OUTPUT the records into a ascii file and <editor>:READ-FILE() */
     RUN adecomm/_tmpfile.p (INPUT "w12", INPUT ".dat", OUTPUT tmp_FileName).
     OUTPUT STREAM tmpStream TO VALUE( Tmp_FileName ) NO-ECHO.
     DO TRANSACTION:
        ASSIGN firstRec = TRUE.
        EDIT-BUILD:
        FOR EACH xlatedb.XL_CustomFilter WHERE
           xlatedb.XL_CustomFilter.RecType = "USER" AND
           xlatedb.XL_CustomFilter.FILTER NE "X-INIT":U NO-LOCK:
           IF xlatedb.XL_CustomFilter.Filter = "X-INIT|CS":U THEN NEXT.
           PUT STREAM tmpStream UNFORMATTED
              IF firstRec THEN xlatedb.XL_CustomFilter.Filter
                 ELSE CHR(10) + xlatedb.XL_CustomFilter.Filter.
           ASSIGN firstRec = FALSE.
        END. /* each CustomFilter */

        OUTPUT STREAM tmpStream CLOSE.
        ASSIGN
          Return_Status = CustomFilters:READ-FILE( Tmp_FileName )
          customFilters:MODIFIED     = NO.
        OS-DELETE VALUE( Tmp_FileName ).
      END. /* TRANSACTION */
   END. /* DO WITH FRAME */
END PROCEDURE. /* GetDB */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetStats C-Win 
PROCEDURE GetStats :
DEFINE OUTPUT PARAMETER pSelected AS INTEGER                      NO-UNDO.
DEFINE VARIABLE         i         AS INTEGER                      NO-UNDO.
DEFINE VARIABLE         n-e       AS INTEGER                      NO-UNDO.
DEFINE VARIABLE         ThisMessage AS CHARACTER                NO-UNDO.
DEFINE VARIABLE         ErrorStatus AS LOGICAL                  NO-UNDO.
   DEFINE VARIABLE         InputLine       AS CHARACTER                NO-UNDO.
   DEFINE VARIABLE         Return_Status   AS LOGICAL                  NO-UNDO.
   DEFINE VARIABLE         tmp_FileName    AS CHARACTER                NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  n-e = NUM-ENTRIES(CustomFilters:SCREEN-VALUE, CHR(10)) NO-ERROR.
  IF n-e <> ? THEN
  DO:
  IF n-e > 120 THEN pSelected = n-e.  /* This may not be totally accurate
                                         but it is fast                   */
  ELSE DO: /* This is more accurate */
    DO i = 1 TO n-e:
      IF ENTRY(i,CustomFilters:SCREEN-VALUE,CHR(10)) <> "" THEN
        pSelected = pSelected + 1.
    END.  /* DO i = 1 to n-e */
  END.  /* ELSE DO */
  END. /* NOT UNKNOWN */
  ELSE
      DO:

         /* SAVE the FILE, read back only correct# of bytes, then process as usual */
         RUN adecomm/_tmpfile.p (INPUT "w12", INPUT ".dat", OUTPUT tmp_FileName).
         ASSIGN
             Return_Status = CustomFilters:SAVE-FILE( Tmp_FileName ).
         INPUT STREAM tmpStream FROM VALUE( Tmp_FileName ) NO-ECHO.
         DO TRANSACTION:
             EDIT_BUILD_FROMFILE:
             REPEAT:
                 IMPORT STREAM tmpStream UNFORMATTED InputLine.
                 IF InputLine <> "":U THEN pSelected = pSelected + 1.
             END.  /* REPEAT IMPORT */
         END. /* DO TRANSACTION */
         INPUT STREAM tmpStream CLOSE.
         OS-DELETE VALUE( Tmp_FileName ).
      END. /* Large data */
END.  /* DO with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe C-Win 
PROCEDURE HideMe :
frame {&frame-name}:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize C-Win 
PROCEDURE Realize :
enable all with frame {&frame-name}.
frame {&frame-name}:hidden = false.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetDB C-Win 
PROCEDURE SetDB :
/* No limit to the number of filters - LARGE editor
 */
   IF CustomFilters:MODIFIED IN FRAME {&FRAME-NAME} THEN
   DO WITH FRAME {&FRAME-NAME}:
     DEFINE VARIABLE i           AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE prcss       AS LOGICAL                                NO-UNDO.
     DEFINE VARIABLE ThisMessage AS CHARACTER                              NO-UNDO.
     DEFINE VARIABLE tmp-fltr    AS CHARACTER                              NO-UNDO.
     DEFINE VARIABLE byte-cnt    AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE j           AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE tmp_FileName AS CHARACTER                             NO-UNDO.
     DEFINE VARIABLE InputLine   AS CHARACTER                              NO-UNDO.
     DEFINE VARIABLE strCustomFilters AS CHARACTER                        NO-UNDO.
     DEFINE VARIABLE vModified    AS LOGICAL                               NO-UNDO.
     DEFINE VARIABLE Return_Status AS LOGICAL                              NO-UNDO.

     ASSIGN byte-cnt = CustomFilters:LENGTH.
     /* Carry on as usual unless real big */
     IF byte-cnt <= 20000 THEN
     DO:
        ASSIGN strCustomFilters = CustomFilters:SCREEN-VALUE.
        DO TRANSACTION:
          FOR EACH xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "USER":U EXCLUSIVE-LOCK:
            DELETE xlatedb.XL_CustomFilter.
          END.

          CREATE xlatedb.XL_CustomFilter.   /* Indicate that this has been looked at */
          ASSIGN xlatedb.XL_CustomFilter.RecType = "USER":U
                 xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.
          IF pMatchCase THEN xlatedb.XL_CustomFilter.Filter  =
            xlatedb.XL_CustomFilter.Filter + "|CS".

          /*  Add a new record per line (i.e.<cr>) */
          DO I = 1 TO NUM-ENTRIES(strCustomFilters, CHR(10)):
            tmp-fltr = ENTRY(i,strCustomFilters,CHR(10)).
            IF tmp-fltr <> "" AND tmp-fltr <> CHR(10) THEN DO:
              FIND FIRST xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "USER" AND
                   xlatedb.XL_CustomFilter.Filter = tmp-fltr NO-LOCK NO-ERROR.

              IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN DO:
                CREATE xlatedb.XL_CustomFilter NO-ERROR.
                ASSIGN xlatedb.XL_CustomFilter.RecType = "USER"
                       xlatedb.XL_CustomFilter.Filter  =
                         IF SUBSTRING(tmp-fltr, LENGTH(tmp-fltr),1) = CHR(10) THEN
                            SUBSTRING(tmp-fltr, 1, LENGTH(tmp-fltr) - 1)
                         ELSE tmp-fltr.
              END. /* IF filter isn't already defined */
            END. /* If a valid filter */
          END.  /* DO i = 1 to NUM-ENTRIES */
        END. /* DO TRANSACTION */
     END.  /* NOT TooBigFlag */
     ELSE
     DO:
       /* SAVE the FILE, read back only correct# of bytes, then process as usual */
       RUN adecomm/_tmpfile.p (INPUT "w12", INPUT ".dat", OUTPUT tmp_FileName).
       ASSIGN
          Return_Status = CustomFilters:SAVE-FILE( Tmp_FileName ).
       INPUT STREAM tmpStream FROM VALUE( Tmp_FileName ) NO-ECHO.
       DO TRANSACTION:
          FOR EACH xlatedb.XL_CustomFilter WHERE
                      xlatedb.XL_CustomFilter.RecType = "USER":U EXCLUSIVE-LOCK:
             DELETE xlatedb.XL_CustomFilter.
          END. /* FOR EACH XL_CustomFilter */
          CREATE xlatedb.XL_CustomFilter.   /* Indicate that this has been looked at */
          ASSIGN xlatedb.XL_CustomFilter.RecType = "USER":U
                 xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.
          IF pMatchCase THEN xlatedb.XL_CustomFilter.Filter  =
            xlatedb.XL_CustomFilter.Filter + "|CS".

          EDIT_BUILD_FROMFILE:
          REPEAT:
              IMPORT STREAM tmpStream UNFORMATTED InputLine.
              ASSIGN byte-cnt = LENGTH(InputLine,"RAW":U)
                     tmp-fltr = InputLine + CHR(10).
              /*  Add a new record per line (i.e.<cr>) */
              IF tmp-fltr <> "" AND tmp-fltr <> CHR(10) THEN
              DO:
                 FIND FIRST xlatedb.XL_CustomFilter WHERE
                      xlatedb.XL_CustomFilter.RecType = "USER" AND
                      xlatedb.XL_CustomFilter.Filter = tmp-fltr NO-LOCK NO-ERROR.

                 IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN
                 DO:
                   CREATE xlatedb.XL_CustomFilter NO-ERROR.
                   ASSIGN xlatedb.XL_CustomFilter.RecType = "USER"
                          xlatedb.XL_CustomFilter.Filter  =
                         IF SUBSTRING(tmp-fltr, LENGTH(tmp-fltr),1) = CHR(10) THEN
                            SUBSTRING(tmp-fltr, 1, LENGTH(tmp-fltr) - 1)
                         ELSE tmp-fltr.
                 END. /* IF filter isn't already defined */
              END. /* If a valid filter */
          END.  /* REPEAT IMPORT */
       END. /* DO TRANSACTION */
       INPUT STREAM tmpStream CLOSE.
       OS-DELETE VALUE( Tmp_FileName ).
     END.  /* TooBigFlag */
  END.  /* If the editor has been modified */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

