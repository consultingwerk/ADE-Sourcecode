/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE answer AS LOGICAL            NO-UNDO.
DEFINE VARIABLE c      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i      AS INTEGER            NO-UNDO.
DEFINE VARIABLE j      AS INTEGER            NO-UNDO.

DEFINE VARIABLE msg    AS CHARACTER EXTENT 9 NO-UNDO.

DEFINE VARIABLE thread AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /* 1*/ "1=,_usrtget,_usrtchg,_usrfchg",
  /* 2*/ "1=,_usrtget,_usrfchg",
  /* 3*/ "1=,_usrtget,_usrichg",
  /* 4*/ "_usrkchg",  
  /* 5*/ "1=,_usrtget,_guisqlw",
  /* 6*/ "", /* this MUST be "" */
  /* 7*/ "*R"
].

/* if nothing worthwhile posted in this transaction, then just return. */
IF NOT dict_dirty THEN DO:
  user_trans = "".
  RETURN.
END.

DISPLAY
  " M. Modify Existing Table " @ msg[1] HELP "Update Existing Table" SKIP
  " F. Field Editor "          @ msg[2] HELP "Field Editor" SKIP
  " I. Index Editor "          @ msg[3] HELP "Index Editor" SKIP
  " S. Sequence Editor "       @ msg[4] HELP "Sequence Editor" SKIP  
  " Q. Adjust Field Width "    @ msg[5] HELP "Field Width Browser" SKIP
  "---------------------------" NO-ATTR-SPACE SKIP
  " A. Apply Changes "         @ msg[6] HELP "Apply Changes to Database" SKIP
  " U. Undo Changes "          @ msg[7] HELP "Undo Recent Changes" SKIP
  WITH COLOR DISPLAY VALUE(menu-fg) NO-LABELS
  ATTR-SPACE ROW 3 CENTERED WITH FRAME mod-scheme.

FORM
  c FORMAT "x(63)" SKIP
  WITH FRAME instr j DOWN ROW 14 CENTERED NO-LABELS NO-ATTR-SPACE.

c = 'Once you leave this menu, all schema changes to database "'
  + user_dbname
  + '" will be applied.  This may take some time.  If you wish, you can '
  + 'select another change from this menu and include it in the '
  + 'transaction.  Selecting "Apply Changes" will apply the changes to '
  + 'your database.'.

{ prodict/dictsplt.i &src=c &dst=msg &num=9 &len=63 &chr=" " }

j = 0.
DO i = 9 TO 1 BY -1 WHILE j = 0:
  IF msg[i] <> "" THEN j = i.
END.
DO i = 1 TO j:
  DISPLAY msg[i] @ c WITH FRAME instr.
  DOWN WITH FRAME instr.
END.

ON CURSOR-UP BACK-TAB.
ON CURSOR-DOWN    TAB.
NEXT-PROMPT msg[6] WITH FRAME mod-scheme.

answer = FALSE.
DO WHILE NOT answer:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    CHOOSE FIELD msg[1 FOR 7] COLOR VALUE(menu-bg)
      AUTO-RETURN GO-ON(".") WITH FRAME mod-scheme.
  END.
  ASSIGN
    j         = (IF CHR(LASTKEY) = "." OR KEYFUNCTION(LASTKEY) = "END-ERROR"
                THEN 7 ELSE FRAME-INDEX)
    c         = SUBSTRING(INPUT FRAME mod-scheme msg[j],7)
    user_path = thread[j].
  IF user_path = "*R" THEN
    MESSAGE "Are you sure that you want to undo your work?" 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
  ELSE
    answer = TRUE.
  IF answer = ? THEN answer = FALSE.
END.

ON CURSOR-UP   CURSOR-UP.
ON CURSOR-DOWN CURSOR-DOWN.

PAUSE 0.
HIDE FRAME mod-scheme.
HIDE FRAME instr.

user_trans = (IF user_path = ""   THEN "*"
         ELSE IF user_path = "*R" THEN ""
         ELSE                     "_usrtrax").

IF user_trans = "*" THEN DO:
  { prodict/user/userhdr.i c }
END.
ELSE DO:
  { prodict/user/userhdr.i user_hdr }
END.

RETURN.
