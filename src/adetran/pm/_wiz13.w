&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

Procedure:    adetran/pm/_wiz13.w
Author:       S. Kuenzig
Created:      11/96 
Updated:      07/98 SLK Added editor LARGE
Purpose:      Persistent procedure that reads/writes 
              XL_CustomFilter which pertain to special
              values.
Called By:    adetran/pm/_wizard.w

*/

DEFINE INPUT PARAMETER parentframe                AS WIDGET-HANDLE     NO-UNDO.
DEFINE SHARED VARIABLE NoAlphaCharacterMatch      AS CHARACTER         NO-UNDO.
DEFINE SHARED VARIABLE pSingleCharacterString     AS LOGICAL           NO-UNDO.
DEFINE SHARED VARIABLE pNoAlphaCharacter          AS LOGICAL           NO-UNDO.
DEFINE SHARED VARIABLE singleCharacterStringMatch AS CHARACTER         NO-UNDO.  
DEFINE        VARIABLE i                          AS INTEGER           NO-UNDO.
DEFINE        VARIABLE Return_Status              AS LOGICAL           NO-UNDO.
DEFINE        VARIABLE Tmp_FileName               AS CHARACTER         NO-UNDO.
DEFINE STREAM tmpStream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Mode13

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS SpecialFilters SingleCharacterString ~
NoAlphaCharacter 
&Scoped-Define DISPLAYED-OBJECTS SpecialFilters SingleCharacterString ~
NoAlphaCharacter 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE SpecialFilters AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL LARGE
     SIZE 30.14 BY 5.12
     FONT 4 NO-UNDO.

DEFINE VARIABLE NoAlphaCharacter AS LOGICAL INITIAL no 
     LABEL "&No Alpha Characters":L 
     VIEW-AS TOGGLE-BOX
     SIZE 31.14 BY .65 NO-UNDO.

DEFINE VARIABLE SingleCharacterString AS LOGICAL INITIAL no 
     LABEL "&Single Character Strings":L 
     VIEW-AS TOGGLE-BOX
     SIZE 31.14 BY .65 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Mode13
     SpecialFilters AT ROW 1.81 COL 1.86 NO-LABEL
     SingleCharacterString AT ROW 7 COL 1.86
     NoAlphaCharacter AT ROW 7.62 COL 1.86
     "WildCardExpressions" VIEW-AS TEXT
          SIZE 22 BY .54 AT ROW 1.31 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 44.86 ROW 2.65
         SIZE 32.86 BY 7.62
         FONT 4.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 9.23
         WIDTH              = 82
         MAX-HEIGHT         = 27.69
         MAX-WIDTH          = 146.14
         VIRTUAL-HEIGHT     = 27.69
         VIRTUAL-WIDTH      = 146.14
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



/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Mode13
   L-To-R                                                               */
ASSIGN 
       SpecialFilters:RETURN-INSERTED IN FRAME Mode13  = TRUE.

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


&Scoped-define SELF-NAME NoAlphaCharacter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NoAlphaCharacter C-Win
ON VALUE-CHANGED OF NoAlphaCharacter IN FRAME Mode13 /* No Alpha Characters */
DO:
  pNoAlphaCharacter = self:checked.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SingleCharacterString
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SingleCharacterString C-Win
ON VALUE-CHANGED OF SingleCharacterString IN FRAME Mode13 /* Single Character Strings */
DO:
  pSingleCharacterString = self:checked.
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
       SingleCharacterString:checked = pSingleCharacterString
       NoAlphaCharacter:checked      = pNoAlphaCharacter.

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
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  run GetDb.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetDB C-Win 
PROCEDURE GetDB :
   DEFINE VARIABLE byte-cnt AS INTEGER                                 NO-UNDO.
   DEFINE VARIABLE firstRec AS LOGICAL                                 NO-UNDO.

   /* activate the toggle and remove special no alpha and single char */
   DO WITH FRAME {&FRAME-NAME}: 
      ASSIGN SpecialFilters:SCREEN-VALUE="":U.
      /* OUTPUT the records into a ascii file and <editor>:READ-FILE() */
     RUN adecomm/_tmpfile.p (INPUT "w12", INPUT ".dat", OUTPUT tmp_FileName).
     OUTPUT STREAM tmpStream TO VALUE( Tmp_FileName ) NO-ECHO.
     DO TRANSACTION:
        ASSIGN firstRec = TRUE.
        EDIT-BUILD:
        FOR EACH xlatedb.XL_CustomFilter WHERE
           xlatedb.XL_CustomFilter.RecType = "SPECIAL":U AND
           xlatedb.XL_CustomFilter.FILTER NE "X-INIT":U NO-LOCK:

           /* Single Character */
           IF xlatedb.XL_CustomFilter.FILTER = singleCharacterStringMatch  THEN
              SingleCharacterString:CHECKED = True.
           ELSE
           DO:
              PUT STREAM tmpStream UNFORMATTED xlatedb.XL_CustomFilter.Filter.
              IF NOT firstRec THEN PUT STREAM tmpStream UNFORMATTED CHR(10).
              ELSE ASSIGN firstRec = FALSE.
           END. /* Not Single Character */
        END. /* each CustomFilter */

        OUTPUT STREAM tmpStream CLOSE.
        ASSIGN
          Return_Status = SpecialFilters:READ-FILE( Tmp_FileName )
          specialFilters:MODIFIED     = NO
           NoAlphaCharacter:CHECKED = IF CAN-FIND(FIRST xlatedb.XL_CustomFilter WHERE
                                      xlatedb.XL_CustomFilter.RecType = "NOALPHA":U) THEN 
                                         TRUE
                                      ELSE
                                         FALSE.
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
DEFINE VARIABLE         ThisMessage       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE         ErrorStatus       AS LOGICAL            NO-UNDO.
   DEFINE VARIABLE         InputLine       AS CHARACTER                NO-UNDO.
   DEFINE VARIABLE         Return_Status   AS LOGICAL                  NO-UNDO.
   DEFINE VARIABLE         tmp_FileName    AS CHARACTER                NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  n-e = NUM-ENTRIES(SpecialFilters:SCREEN-VALUE, CHR(10)) NO-ERROR.
  IF n-e <> ? THEN 
  DO:
  
  /* TooBig */
  IF n-e > 120 THEN pSelected = n-e.  /* This may not be totally accurate
                                         but it is fast                   */
  ELSE DO: /* This is more accurate */
    DO i = 1 TO n-e:
      IF ENTRY(i,SpecialFilters:SCREEN-VALUE,CHR(10)) <> "" THEN
        pSelected = pSelected + 1.
    END.  /* DO i = 1 to n-e */
  END.  /* ELSE DO */
  END.  /* NOT UNKNOWN */
  ELSE
     DO:
        /* SAVE the FILE, read back only correct# of bytes, then process as usual */
        RUN adecomm/_tmpfile.p (INPUT "wiz13":U, INPUT ".dat", OUTPUT tmp_FileName).
        ASSIGN
           Return_Status = SpecialFilters:SAVE-FILE( Tmp_FileName ).
        INPUT STREAM tmpStream FROM VALUE( Tmp_FileName ) NO-ECHO.
        DO TRANSACTION:
          EDIT_BUILD_FROMFILE:
          REPEAT:
             IMPORT STREAM tmpStream UNFORMATTED InputLine.
             IF InputLine <> "" THEN pSelected = pSelected + 1.
          END. /* REPEAT IMPORT */
        END. /* DO TRANSACTION */
        INPUT STREAM tmpStream CLOSE.
        OS-DELETE VALUE( Tmp_FileName ).
     END.  /* TooBigFlag */

  IF SingleCharacterString:CHECKED THEN pSelected = pSelected + 1.
  IF NoAlphaCharacter:CHECKED THEN pSelected = pSelected + 1.
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

   IF    SpecialFilters:MODIFIED IN FRAME {&FRAME-NAME} 
      OR SingleCharacterSTring:MODIFIED IN FRAME {&FRAME-NAME}
      OR NoAlphaCharacter:MODIFIED IN FRAME {&FRAME-NAME} THEN 
   DO WITH FRAME {&FRAME-NAME}:
     DEFINE VARIABLE i           AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE prcss       AS LOGICAL                                NO-UNDO.
     DEFINE VARIABLE ThisMessage AS CHARACTER                              NO-UNDO.
     DEFINE VARIABLE tmp-fltr    AS CHARACTER                              NO-UNDO.
     DEFINE VARIABLE byte-cnt    AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE j           AS INTEGER                                NO-UNDO.
     DEFINE VARIABLE tmp_FileName AS CHARACTER                            NO-UNDO.
     DEFINE VARIABLE InputLine AS CHARACTER                            NO-UNDO.
     DEFINE VARIABLE strSpecialFilters AS CHARACTER                        NO-UNDO.
     DEFINE VARIABLE vModified AS LOGICAL                            NO-UNDO.
     DEFINE VARIABLE Return_Status AS LOGICAL                            NO-UNDO.

     ASSIGN byte-cnt = SpecialFilters:LENGTH.
     IF byte-cnt <= 20000 THEN 
     DO:
       ASSIGN strSpecialFilters = SpecialFilters:SCREEN-VALUE.
       DO TRANSACTION:
          FOR EACH xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "SPECIAL":U EXCLUSIVE-LOCK:
            DELETE xlatedb.XL_CustomFilter.
          END. 
          FOR EACH xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "NOALPHA":U EXCLUSIVE-LOCK:
            DELETE xlatedb.XL_CustomFilter.
          END.           
          CREATE xlatedb.XL_CustomFilter. /* Indicate that this has been looked at */
          ASSIGN xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                 xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.

          /* Add a new record per line (i.e.<cr>) */
          DO i = 1 TO NUM-ENTRIES(strSpecialFilters, CHR(10)):
             ASSIGN tmp-fltr = ENTRY(i,strSpecialFilters,CHR(10)) NO-ERROR.
             IF tmp-fltr <> "" AND tmp-fltr <> CHR(10) THEN 
             DO:
                FIND FIRST xlatedb.XL_CustomFilter WHERE
                       xlatedb.XL_CustomFilter.RecType = "SPECIAL" 
                   AND xlatedb.XL_CustomFilter.Filter = tmp-fltr 
                NO-LOCK NO-ERROR. 
                IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN 
                DO:
                   CREATE xlatedb.XL_CustomFilter NO-ERROR.
                   ASSIGN xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                          xlatedb.XL_CustomFilter.Filter  = 
                         IF SUBSTRING(tmp-fltr, LENGTH(tmp-fltr),1) = CHR(10) THEN
                            SUBSTRING(tmp-fltr,1, LENGTH(tmp-fltr) - 1)
                         ELSE tmp-fltr.
                END. /* IF filter isn't already defined */
             END. /* If a valid filter */
           END. /* DO i = 1 TO NUM-ENTRIES */

           /* single char */
           IF SingleCharacterString:CHECKED THEN
           DO:
               FIND FIRST xlatedb.XL_CustomFilter WHERE
                      xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                  AND xlatedb.XL_CustomFilter.Filter = singleCharacterStringMatch 
               NO-LOCK NO-ERROR. 
               IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN 
               DO:
                   CREATE xlatedb.XL_CustomFilter NO-ERROR.
                   ASSIGN xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                          xlatedb.XL_CustomFilter.Filter  = singleCharacterStringMatch.
               END. /* IF filter isn't already defined */
           END. /* single char */
           
           /* No Alpha */
           IF NoAlphaCharacter:CHECKED THEN 
           DO:
              FIND FIRST xlatedb.XL_CustomFilter WHERE
                 xlatedb.XL_CustomFilter.RecType = "NOALPHA":U 
              NO-LOCK NO-ERROR. 
           
              IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN
              DO:
                 CREATE xlatedb.XL_CustomFilter NO-ERROR.
                 ASSIGN xlatedb.XL_CustomFilter.RecType = "NOALPHA":U
                        xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.
              END. /* IF filter isn't already defined */
           END. /* No Alpha */
        END. /* DO TRANSACTION */
     END. /* NOT TooBigFlag */
     ELSE
     DO:
       /* SAVE the FILE, read back only correct# of bytes, then process as usual */
       RUN adecomm/_tmpfile.p (INPUT "wiz13":U, INPUT ".dat", OUTPUT tmp_FileName).
       ASSIGN
          Return_Status = SpecialFilters:SAVE-FILE( Tmp_FileName ).
       INPUT STREAM tmpStream FROM VALUE( Tmp_FileName ) NO-ECHO.
       DO TRANSACTION:
          FOR EACH xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "SPECIAL":U EXCLUSIVE-LOCK:
            DELETE xlatedb.XL_CustomFilter.
          END. 
          FOR EACH xlatedb.XL_CustomFilter WHERE
                   xlatedb.XL_CustomFilter.RecType = "NOALPHA":U EXCLUSIVE-LOCK:
            DELETE xlatedb.XL_CustomFilter.
          END.           
          CREATE xlatedb.XL_CustomFilter. /* Indicate that this has been looked at */
          ASSIGN xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                 xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.

          EDIT_BUILD_FROMFILE:
          REPEAT:
             IMPORT STREAM tmpStream UNFORMATTED InputLine.
             ASSIGN byte-cnt = LENGTH(InputLine,"RAW":U)
                    tmp-fltr = InputLine + CHR(10).
             /* Add a new record per line (i.e.<cr>) */
             IF tmp-fltr <> "":U AND tmp-fltr <> CHR(10) THEN
             DO:
                FIND FIRST xlatedb.XL_CustomFilter WHERE
                       xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                   AND xlatedb.XL_CustomFilter.Filter = tmp-fltr NO-LOCK NO-ERROR.
                IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN 
                DO:
                   CREATE xlatedb.XL_CustomFilter NO-ERROR.
                   ASSIGN 
                      xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                      xlatedb.XL_CustomFilter.Filter  = 
                         IF SUBSTRING(tmp-fltr, LENGTH(tmp-fltr),1) = CHR(10) THEN
                            SUBSTRING(tmp-fltr, 1, LENGTH(tmp-fltr) - 1)
                         ELSE tmp-fltr.
                END. /* IF filter isn't already defined */
              END. /* If a valid filter */
           END. /* REPEAT import */
           /* single char */
           IF SingleCharacterString:CHECKED THEN
           DO:
               FIND FIRST xlatedb.XL_CustomFilter WHERE
                      xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                  AND xlatedb.XL_CustomFilter.Filter = singleCharacterStringMatch 
               NO-LOCK NO-ERROR. 
               IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN 
               DO:
                   CREATE xlatedb.XL_CustomFilter NO-ERROR.
                   ASSIGN xlatedb.XL_CustomFilter.RecType = "SPECIAL":U
                          xlatedb.XL_CustomFilter.Filter  = singleCharacterStringMatch.
               END. /* IF filter isn't already defined */
           END. /* single char */
           
           /* No Alpha */
           IF NoAlphaCharacter:CHECKED THEN 
           DO:
              FIND FIRST xlatedb.XL_CustomFilter WHERE
                 xlatedb.XL_CustomFilter.RecType = "NOALPHA":U 
              NO-LOCK NO-ERROR. 
           
              IF NOT AVAILABLE xlatedb.XL_CustomFilter THEN
              DO:
                 CREATE xlatedb.XL_CustomFilter NO-ERROR.
                 ASSIGN xlatedb.XL_CustomFilter.RecType = "NOALPHA":U
                        xlatedb.XL_CustomFilter.Filter  = "X-INIT":U.
              END. /* IF filter isn't already defined */
           END. /* No Alpha */
        END. /* DO TRANSACTION */
        INPUT STREAM tmpStream CLOSE.
        OS-DELETE VALUE( Tmp_FileName ).
     END.  /* TooBigFlag */
   END.  /* If the editor has been modified */
END PROCEDURE. /* SetDB */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

