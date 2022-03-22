/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 

History:  D. McMann  Adjust frame for data types with long names

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE qbf_draw AS LOGICAL INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf_home AS RECID   INITIAL ?    NO-UNDO.
DEFINE VARIABLE qbf_line AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf_loop AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE qbf_save AS RECID                NO-UNDO.
DEFINE SHARED VARIABLE qbf_rec AS RECID NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO.
ASSIGN
  new_lang[1] =
    "Use the cursor-keys to scroll through the list of index components."
  new_lang[2] = "There are no index key components in this index."
  new_lang[3] = "Press the [" + KBLABEL("END-ERROR")
              + "] key when done browsing.".

FORM
  _Index-field._Index-Seq  FORMAT ">>"       LABEL "Seq"
    ATTR-SPACE SPACE(0)
  _Field._Field-Name       FORMAT "x(25)"    LABEL "Field Name"
    NO-ATTR-SPACE
  _Field._Data-Type        FORMAT "x(11)"     LABEL "Type"
    ATTR-SPACE SPACE(0)
  _Index-field._Ascending  FORMAT "Asc/Desc" LABEL "Asc"
    NO-ATTR-SPACE
  _Index-field._Abbreviate FORMAT "Yes/No"   LABEL "Abbr"
    ATTR-SPACE
  WITH FRAME idx_browse
  OVERLAY ROW 5 COLUMN 27 ATTR-SPACE SCREEN-LINES - 9 DOWN SCROLL 1
  TITLE " Index Browse for ~"" + _Index._Index-name + "~" ".

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

STATUS DEFAULT new_lang[3]. /* press [end-error] when done */

FIND _Index
  WHERE _Index._File-recid = drec_file AND _Index._Index-name = user_env[1].

DO FOR _Index-field:
  FIND FIRST _Index-field OF _Index NO-ERROR.
  IF NOT AVAILABLE _Index-field THEN DO:
    MESSAGE new_lang[2]. /* no key components */
    RETURN.
  END.
  qbf_home = RECID(_Index-field).
END.

DO FOR _Index-field WITH FRAME idx_browse: /* scoping block */

  PAUSE 0.
  VIEW FRAME idx_browse.
  FIND FIRST _Index-field OF _Index NO-ERROR.

  DO WHILE TRUE: /* iterating block */

    IF qbf_draw THEN DO:
      HIDE MESSAGE NO-PAUSE.
      MESSAGE "". /* get to second line */
      MESSAGE COLOR NORMAL new_lang[1]. /* use cursor keys... */
      ASSIGN
        qbf_save = RECID(_Index-field)
        qbf_draw = FALSE
        qbf_line = FRAME-LINE.
      IF qbf_line > 1 THEN DO qbf_loop = 2 TO FRAME-LINE:
        IF AVAILABLE _Index-field THEN
          FIND PREV _Index-field OF _Index NO-ERROR.
        IF NOT AVAILABLE _Index-field THEN qbf_line = qbf_line - 1.
      END.
      UP FRAME-LINE - 1.
      IF NOT AVAILABLE _Index-field THEN
        FIND FIRST _Index-field OF _Index NO-ERROR.
      DO qbf_loop = 1 TO FRAME-DOWN:
        IF AVAILABLE _Index-field THEN DO:
          FIND _Field OF _Index-field.
          DISPLAY _Index-field._Index-Seq _Field._Field-Name _Field._Data-Type
            _Index-field._Ascending _Index-field._Abbreviate.
        END.
        ELSE
          CLEAR NO-PAUSE.
        IF qbf_loop = FRAME-DOWN THEN LEAVE.
        DOWN.
        IF NOT AVAILABLE _Index-field THEN NEXT.
        FIND NEXT _Index-field OF _Index NO-ERROR.
      END.
      FIND _Index-field WHERE RECID(_Index-field) = qbf_save NO-ERROR.
      UP FRAME-DOWN - qbf_line.
    END.

    IF AVAILABLE _Index-field THEN DO:
      FIND _Field OF _Index-field.
      DISPLAY _Index-field._Index-Seq _Field._Field-Name _Field._Data-Type
        _Index-field._Ascending _Index-field._Abbreviate.
      COLOR DISPLAY MESSAGES _Index-field._Index-Seq _Field._Field-Name
        _Field._Data-Type _Index-field._Ascending _Index-field._Abbreviate.
    END.
    READKEY.
    IF AVAILABLE _Index-field THEN COLOR DISPLAY NORMAL
      _Index-field._Index-Seq _Field._Field-Name _Field._Data-Type
      _Index-field._Ascending _Index-field._Abbreviate.

    IF CAN-DO("CURSOR-DOWN,TAB, ",KEYFUNCTION(LASTKEY)) THEN DO:
      FIND NEXT _Index-field OF _Index NO-ERROR.
      IF AVAILABLE _Index-field THEN DO:
        IF FRAME-LINE = FRAME-DOWN THEN
          SCROLL UP.
        ELSE
          DOWN.
      END.
      ELSE
        FIND LAST _Index-field OF _Index NO-ERROR.
      NEXT.
    END.

    IF CAN-DO("CURSOR-UP,BACK-TAB,BACKSPACE",KEYFUNCTION(LASTKEY)) THEN DO:
      FIND PREV _Index-field OF _Index NO-ERROR.
      IF AVAILABLE _Index-field THEN DO:
        IF FRAME-LINE = 1 THEN
          SCROLL DOWN.
        ELSE
          UP.
      END.
      ELSE
        FIND FIRST _Index-field OF _Index NO-ERROR.
      NEXT.
    END.

    IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
      qbf_draw = TRUE.
      DO qbf_loop = 1 TO FRAME-DOWN:
        FIND NEXT _Index-field OF _Index NO-ERROR.
        IF NOT AVAILABLE _Index-field THEN DO:
          FIND LAST _Index-field OF _Index NO-ERROR.
          DOWN FRAME-DOWN - FRAME-LINE.
          LEAVE.
        END.
      END.
      NEXT.
    END.

    IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN DO:
      qbf_draw = TRUE.
      DO qbf_loop = 1 TO FRAME-DOWN:
        FIND PREV _Index-field OF _Index NO-ERROR.
        IF NOT AVAILABLE _Index-field THEN DO:
          FIND FIRST _Index-field OF _Index NO-ERROR.
          UP FRAME-LINE - 1.
          LEAVE.
        END.
      END.
      NEXT.
    END.

    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY))
      AND AVAILABLE _Index-field AND RECID(_Index-field) <> qbf_home THEN DO:
      qbf_draw = TRUE.
      UP FRAME-LINE - 1.
      FIND FIRST _Index-field OF _Index NO-ERROR.
      NEXT.
    END.

    IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
      qbf_draw = TRUE.
      DOWN FRAME-DOWN - FRAME-LINE.
      FIND LAST _Index-field OF _Index NO-ERROR.
      NEXT.
    END.

    IF CAN-DO("END-ERROR,GET",KEYFUNCTION(LASTKEY)) THEN LEAVE.

  END. /* iterating block */
END. /* scoping block */

HIDE MESSAGE NO-PAUSE.
STATUS DEFAULT.
HIDE FRAME idx_browse NO-PAUSE.
RETURN.
