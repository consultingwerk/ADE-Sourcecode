/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
DEFINE VARIABLE user-prog  AS CHARACTER FORMAT  "x(60)".

DEFINE VARIABLE cmd AS CHARACTER EXTENT 15 INITIAL [
  "prohelp/_rcntmsg.p",
  "prohelp/_msgs.p",
  "prohelp/_keybrd.p",
  "prohelp/statemnt.p",
  "prohelp/function.p",
  "prohelp/operator.p",
  "prohelp/keyword.p",
  "prohelp/spec.p",
  "prohelp/endsess.p",
  "",
  "",
  "prohelp/dirlist.p",
  "",
  "",
  ""
].

DISPLAY SKIP(1)
  "1.  Recent Messages"                   @ cmd[ 1] SKIP
  "2.  Any Messages"                      @ cmd[ 2] SKIP
  "3.  Keyboard"                          @ cmd[ 3] SKIP
  "4.  Statements"                        @ cmd[ 4] SKIP
  "5.  Functions"                         @ cmd[ 5] SKIP
  "6.  Operators"                         @ cmd[ 6] SKIP
  "7.  Keywords"                          @ cmd[ 7] SKIP
  "8.  Design Limits"                     @ cmd[ 8] SKIP
  "9.  Ending a PROGRESS Session"         @ cmd[ 9] SKIP(1)
  "d.  Access the DICTIONARY"             @ cmd[10] SKIP
  "e.  Escape to the Operating System"    @ cmd[11] SKIP
  "f.  List the Filenames in a Directory" @ cmd[12] SKIP
  "p.  Access the Procedure Library"      @ cmd[13] SKIP
  "q.  Quit to the operating system"      @ cmd[14] SKIP
  "r.  Run a PROGRESS program"            @ cmd[15] SKIP
  WITH FRAME f-cmd NO-LABELS ATTR-SPACE CENTERED
  TITLE " P R O G R E S S   H E L P ".

getchoice:
REPEAT:

  IF RETRY THEN DO:
    HIDE FRAME u-prog.
    VIEW FRAME f-cmd.
  END.
  STATUS DEFAULT
    "Enter selection or press " + KBLABEL("END-ERROR") + " to exit".

  MESSAGE "Use " + KBLABEL("STOP") + " anytime to return immediately.".
  CHOOSE FIELD cmd AUTO-RETURN GO-ON(".") WITH FRAME f-cmd.
  HIDE MESSAGE NO-PAUSE.

  IF CHR(LASTKEY) = "." THEN LEAVE.
  IF FRAME-INDEX > 0 THEN DO:
    STATUS DEFAULT.
    HIDE ALL NO-PAUSE.

    IF cmd[FRAME-INDEX] <> "" THEN RUN VALUE(cmd[FRAME-INDEX]).
    ELSE IF FRAME-INDEX = 10 THEN DICTIONARY.
    ELSE IF FRAME-INDEX = 11 THEN OS-COMMAND.
    ELSE IF FRAME-INDEX = 13 THEN MESSAGE "This option was removed in 10.1C" VIEW-AS ALERT-BOX.
    ELSE IF FRAME-INDEX = 14 THEN QUIT.
    ELSE IF FRAME-INDEX = 15 THEN DO ON ERROR UNDO getchoice,RETRY getchoice:
      HIDE ALL.
      UPDATE user-prog AUTO-RETURN
        WITH NO-LABEL CENTERED FRAME u-prog
        TITLE "Enter the name of the PROGRESS program to be run".
      HIDE FRAME u-prog.
      IF SEARCH(user-prog) <> ? THEN DO:
        HIDE FRAME u-prog.
        RUN VALUE(user-prog).
        MESSAGE "Press any key to return to PROGRESS help".
        READKEY.
        HIDE ALL NO-PAUSE.
      END.
      ELSE DO:
        MESSAGE "Could not find" user-prog.
        PAUSE.
        HIDE MESSAGE.
      END.
      VIEW FRAME f-cmd.
      NEXT getchoice.
    END.

    inner:
    DO ON ENDKEY UNDO inner,LEAVE inner:
      HIDE ALL.
    END.  /* inner */
    HIDE ALL NO-PAUSE.

    VIEW FRAME f-cmd.
    NEXT getchoice.
  END.
  ELSE DO:
    BELL.
    MESSAGE "Invalid choice, please try again".
  END.
END. /* getchoice */

STATUS DEFAULT.
HIDE FRAME f-cmd NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.

