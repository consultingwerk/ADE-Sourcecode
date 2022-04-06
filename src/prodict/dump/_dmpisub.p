/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights*
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dmpisub.p - subroutine of _dmpincr.p ------------------------------------

History:
    Mario B     10/19/99    Several Bug Fixes and support for AREAS.  Added
                            warnings mechanisim.  BUG#'s  19981112-011,
                            19990915-022, 19970814-029 (re-opened & re-fixed).
                20000926-011 Needed to add parameters to FileAreaMatch call
    vap         01/29/02     Added batch-mode support (IZ# 1525)
    fernando    02/27/2007   Added case for critical field change - OE00147106
                            
-----------------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }
{ prodict/dump/dumpvars.i SHARED }

DEFINE INPUT        PARAMETER which   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER missing AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER answer  AS LOGICAL   NO-UNDO.

DEFINE        VARIABLE c     AS CHARACTER NO-UNDO.
DEFINE        VARIABLE ix    AS INTEGER   NO-UNDO.
DEFINE        VARIABLE name  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE fname AS CHARACTER NO-UNDO.
DEFINE        VARIABLE type  AS CHARACTER NO-UNDO.
DEFINE        VARIABLE i     AS INTEGER   NO-UNDO.

FUNCTION fileAreaMatch RETURNS LOGICAL (INPUT db1FileNo AS INT,
                                        INPUT db2FileNo AS INT,
                                        INPUT db1recid  AS RECID,
                                        INPUT db2recid  AS RECID) IN h_dmputil.
                                        
/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 23 NO-UNDO INITIAL [
  /* 1*/ "<deleted>",
  /* 2*/ ? /* see below */ ,
  /* 3*/ "Does this mean you want to abort this program?",
  /* 4*/ "Table:",
  /* 5*/ "Field:",
  /* 6*/ "does not exist.",
  /* 7*/ "If it is renamed, please choose",
  /* 8*/ "the new name from the list of",
  /* 9*/ "unmatched names shown here.",
  /*10*/ "Otherwise, select ~"<deleted>~".",
  /*11*/ "Sequence:",
  /*12*/ "WARNING: ",
  /*13*/ " and ",
  /*14*/ " are in different AREAS.",
  /*15*/ "The incremental dump utility cannot be used to change database",
  /*16*/ "AREAS.  Create AREAS with the ""PROSTRCT"" utility and move",
  /*17*/ "tables with the ""proutil tablemove"" utility.  See the",
  /*18*/ "Progress Database Administration Guide and Reference for details.",
  /*19*/ "A ""RENAME TABLE"" statement has been written to the",
  /*20*/ "incremental .df file for these tables without regard for AREA.",
  /*21*/ "will be dropped and recreated.",
  /*22*/ "Otherwise, select ~"<recreated>~".",
  /*23*/ "<recreated>"
].

new_lang[2] = "You pressed [" + KBLABEL("END-ERROR") + "] or Cancel.".

FORM
  new_lang[4]  FORMAT "x(6)"
     name      FORMAT "x(32)" SKIP
  new_lang[6]  FORMAT "x(32)" SKIP(1)
  new_lang[7]  FORMAT "x(32)" SKIP
  new_lang[8]  FORMAT "x(32)" SKIP
  new_lang[9]  FORMAT "x(32)" SKIP
  new_lang[10] FORMAT "x(30)"
  WITH FRAME t-help NO-LABELS NO-ATTR-SPACE ROW 3 COLUMN 1 USE-TEXT.

FORM
  new_lang[4] FORMAT "x(6)"
    DICTDB._File._File-name   FORMAT "x(32)" SKIP
  new_lang[5] FORMAT "x(6)"
    DICTDB._Field._Field-name FORMAT "x(32)" SKIP
  new_lang[6]                             FORMAT "x(32)" SKIP(1)
  new_lang[7]                      FORMAT "x(32)" SKIP
  new_lang[8]                      FORMAT "x(32)" SKIP
  new_lang[9]                      FORMAT "x(32)" SKIP
  new_lang[10]                      FORMAT "x(30)"
  WITH FRAME f-help NO-LABELS NO-ATTR-SPACE ROW 3 COLUMN 1 USE-TEXT.

FORM
  new_lang[11] FORMAT "x(9)"
     name      FORMAT "x(28)" SKIP
  new_lang[6]  FORMAT "x(32)" SKIP(1)
  new_lang[7]  FORMAT "x(32)" SKIP
  new_lang[8]  FORMAT "x(32)" SKIP
  new_lang[9]  FORMAT "x(32)" SKIP
  new_lang[10] FORMAT "x(30)"
  WITH FRAME s-help NO-LABELS NO-ATTR-SPACE ROW 3 COLUMN 1 USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

ASSIGN
  answer      = FALSE
  pik_row     = 5
  pik_column  = 42
  pik_count   = 1
  pik_list[1] = new_lang[1]. /* <deleted> */

PAUSE 0.

IF which = "t" THEN _file: DO:
  FOR EACH table-list WHERE table-list.t2-name = ?:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = table-list.t1-name.
  END.
  IF pik_count = 1 THEN LEAVE _file.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    DISPLAY
      new_lang[4] 
      missing @ name
      new_lang[6] new_lang[7] 
      new_lang[8] new_lang[9] 
      new_lang[10]
      WITH FRAME t-help.
    RUN "prodict/user/_usrpick.p".
  &ELSE
    pik_text = new_lang[4] + " " + missing.
    DO ix = 6 TO 10:
      pik_text = pik_text + "~n" + new_lang[ix].
    END.
    ASSIGN
      pik_text = pik_text + c
      pik_help = {&Resolve_Mismatched_Table_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF

  IF pik_return = 0 THEN DO:
    MESSAGE new_lang[2] SKIP new_lang[3]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF answer THEN answer = ?.
    IF answer = ? THEN LEAVE _file.
  END.
  IF pik_chosen[1] = 1 THEN pik_first = ?.
  FIND FIRST table-list WHERE table-list.t1-name = pik_first NO-ERROR.
  IF AVAILABLE table-list THEN
  DO:
     ASSIGN
       table-list.t2-name = missing
       missing            = ?
       which              = "table_check," + table-list.t1-name + "," +
                             table-list.t2-name.
  END.
END.

/* 02/01/29 vap (IZ# 1525) */
IF which BEGINS "table_check" AND
   NUM-ENTRIES(which) EQ 3 THEN DO:
   FIND DICTDB._File WHERE
        DICTDB._File._File-name = ENTRY(2, which) NO-ERROR.
   FIND DICTDB2._File WHERE
        DICTDB2._File._File-name = ENTRY(3, which) NO-ERROR.
   IF NOT fileAreaMatch(INPUT DICTDB._File._File-number,
                        INPUT DICTDB2._File._File-number,
                        INPUT DICTDB._File._Db-recid,
                        INPUT DICTDB2._File._Db-recid) THEN
   DO:
     s_errorsLogged = TRUE.
     OUTPUT STREAM err-log TO {&errFileName} APPEND NO-ECHO.
     PUT STREAM err-log UNFORMATTED new_lang[12] +
     '"' + LDBNAME("DICTDB") + "." + DICTDB._File._File-name + '"' +
     new_lang[13] +
     '"' + LDBNAME("DICTDB2") + "." + DICTDB2._File._File-name + '"' +
     new_lang[14]                                                   SKIP.
     DO i = 15 to 19:
        PUT STREAM err-log UNFORMATTED new_lang[i]                  SKIP.
     END.
     PUT STREAM err-log UNFORMATTED new_lang[20]                    SKIP(1).
     OUTPUT STREAM err-log CLOSE.
   END.
END.  /* check table area */
/* 02/01/29 vap (IZ# 1525) */

IF which = "f" THEN _field: DO:
  FOR EACH field-list WHERE
      field-list.f2-name   = ?:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = field-list.f1-name.
  END.
  IF pik_count = 1 THEN LEAVE _field.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    DISPLAY
      new_lang[4]
      user_env[19] @ DICTDB._File._File-name /* this is a hack */
      new_lang[5]
      missing @ DICTDB._Field._Field-name
      new_lang[6] new_lang[7] 
      new_lang[8] new_lang[9] 
      new_lang[10] 
      WITH FRAME f-help.
    RUN "prodict/user/_usrpick.p".
  &ELSE         
    pik_text = new_lang[4] + " " + user_env[19] + ", " + 
                     new_lang[5] + " " + missing.
    DO ix = 6 TO 10:
      pik_text = pik_text + "~n" + new_lang[ix].
    END.
    ASSIGN
      pik_text = pik_text + c
      pik_help = {&Resolve_Mismatched_Field_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF

  IF pik_return = 0 THEN DO:
    MESSAGE new_lang[2] SKIP new_lang[3]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF answer THEN answer = ?.
    IF answer = ? THEN LEAVE _field.
  END.
  IF pik_chosen[1] = 1 THEN pik_first = ?.
  FIND FIRST field-list WHERE field-list.f1-name = pik_first NO-ERROR.
  IF AVAILABLE field-list THEN ASSIGN
    field-list.f2-name = missing
    missing            = ?.
END.

/* Added to fix OE00147106 */
IF which = "fc" THEN _field: DO: /* critical field change */

  pik_list[1] = new_lang[23]. /* <recreated> */
  FOR EACH field-list WHERE
      field-list.f2-name   = ?:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = field-list.f1-name.
  END.
  IF pik_count = 1 THEN LEAVE _field.

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    DISPLAY
      new_lang[4]
      user_env[19] @ DICTDB._File._File-name /* this is a hack */
      new_lang[5]
      missing @ DICTDB._Field._Field-name
      new_lang[21] @ new_lang[6]
      new_lang[7] 
      new_lang[8] new_lang[9] 
      new_lang[22] @  new_lang[10]
      WITH FRAME f-help.
    RUN "prodict/user/_usrpick.p".
  &ELSE         
    pik_text = new_lang[4] + " " + user_env[19] + ", " + 
               new_lang[5] + " " + missing + 
               "~n" + new_lang[21].

    DO ix = 7 TO 9:
      pik_text = pik_text + "~n" + new_lang[ix].
    END.
    pik_text = pik_text + "~n" + new_lang[22].

    ASSIGN
      pik_text = pik_text + c
      pik_help = {&Resolve_Mismatched_Field_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF

  IF pik_return = 0 THEN DO:
    MESSAGE new_lang[2] SKIP new_lang[3]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF answer THEN answer = ?.
    IF answer = ? THEN LEAVE _field.
  END.
  IF pik_chosen[1] = 1 THEN pik_first = ?.
  FIND FIRST field-list WHERE field-list.f1-name = pik_first NO-ERROR.
  IF AVAILABLE field-list THEN DO:
      ASSIGN field-list.f2-name = missing.
      /* fix the original field-list record so that we consider it a new
         field 
      */
      FIND FIRST field-list WHERE field-list.f1-name = missing.
      ASSIGN field-list.f2-name = ?.
  END.
END.

IF which = "s" THEN _seq: DO:
  FOR EACH seq-list WHERE seq-list.s2-name = ?:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = seq-list.s1-name.
  END.
  IF pik_count = 1 THEN LEAVE _seq.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    DISPLAY
      new_lang[11]
      missing @ name
      new_lang[6] new_lang[7] 
      new_lang[8] new_lang[9] 
      new_lang[10]
      WITH FRAME s-help.
    RUN "prodict/user/_usrpick.p".
  &ELSE
    pik_text = new_lang[4] + " " + missing.
    DO ix = 6 TO 10:
      pik_text = pik_text + "~n" + new_lang[ix].
    END.
    ASSIGN
      pik_text = pik_text + c
      pik_help = {&Resolve_Mismatched_Sequence_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF

  IF pik_return = 0 THEN DO:
    MESSAGE new_lang[2] SKIP new_lang[3]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF answer THEN answer = ?.
    IF answer = ? THEN LEAVE _seq.
  END.
  IF pik_chosen[1] = 1 THEN pik_first = ?.
  FIND FIRST seq-list WHERE seq-list.s1-name = pik_first NO-ERROR.
  IF AVAILABLE seq-list THEN ASSIGN
    seq-list.s2-name = missing
    missing            = ?.
END.

HIDE FRAME t-help NO-PAUSE.
HIDE FRAME f-help NO-PAUSE.
HIDE FRAME s-help NO-PAUSE.
RETURN.


