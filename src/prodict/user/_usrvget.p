/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrvget.p - select views */

/*
INPUT:
user_env[1] MATCHES "*o*":
If this program sees an "o" (for "optional") in user_env[1], then it returns
immediately if a filename is currently set (other than "ALL").

user_env[1] MATCHES "*a*":
If this program sees an "a" (for "all"), then "ALL" is a valid choice.

user_env[1] MATCHES "*s*":
If this program sees an "s" (for "some"), then [Return] marks (or unmarks)
names, and the list of _View-names is returned in user_env[1] (Not for
Views!)  Otherwise, one file must be chosen.  "ALL" is also a valid
choice.

OUTPUT:
user_env[1] contains the filename selected, or 'ALL'.

History: Added _Owner to _File finds 07/14/98 D. McMann

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 4 NO-UNDO INITIAL [
  /*  1*/ "There are no views defined in this database.",
  /*  2*/ "You do not have permission to select views.",
  /*3,4*/ "Press the", "key to end."
].

FORM
  "  Please select a view from the following list.  " SKIP
  WITH ROW 3 CENTERED FRAME v-one.

FORM
  "  Please select a view from the  "  SKIP
  "  list or ~"ALL~" for all views.  " SKIP
  WITH ROW 3 CENTERED FRAME v-all.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE l AS LOGICAL NO-UNDO.

IF NOT CAN-FIND(FIRST DICTDB._View) THEN i = 1. /* I can't see any views */

DO FOR DICTDB._File:
  FIND _File "_View" WHERE _File._Owner = "PUB" NO-LOCK.
  l = CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File "_View-ref" WHERE _File._Owner = "PUB" NO-LOCK.
  l = l AND CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File "_View-col" WHERE _File._Owner = "PUB" NO-LOCK.
  l = l AND CAN-DO(_Can-read,USERID("DICTDB")).
  IF NOT l THEN i = 2. /* You're not supposed to see any views */
END.

IF i > 0 THEN DO:
  MESSAGE new_lang[i] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  ASSIGN
    user_path   = ""
    user_env[1] = "".
  RETURN.
END.

IF user_env[1] MATCHES "*a*" THEN
  VIEW FRAME v-all.
ELSE
  VIEW FRAME v-one.
ASSIGN
  l          = TRUE
  pik_column = 20
  pik_row    = (IF user_env[1] MATCHES "*a*" THEN 7 ELSE 6)
  pik_multi  = user_env[1] MATCHES "*s*"
  pik_count  = 0.
IF user_env[1] MATCHES "*a*" THEN ASSIGN
  pik_count = pik_count + 1
  pik_list[pik_count] = "ALL".
FOR EACH DICTDB._View:
  ASSIGN
    l = FALSE
    pik_count = pik_count + 1
    pik_list[pik_count] = DICTDB._View._View-name.
END.

user_status = new_lang[3] + " [" + KBLABEL("END-ERROR") + "] " + new_lang[4].
STATUS DEFAULT user_status.
RUN "prodict/user/_usrpick.p".
user_status = ?.
STATUS DEFAULT.

user_env[1] = (IF pik_first = ? THEN "" ELSE pik_first).
IF pik_return > 1 AND user_env[1] MATCHES "*s*" THEN
  DO i = 2 TO pik_return:
    user_env[1] = user_env[1] + "," + pik_list[pik_chosen[i]].
  END.

IF user_env[1] = "" THEN user_path = "".
HIDE FRAME v-all NO-PAUSE.
HIDE FRAME v-one NO-PAUSE.
RETURN.

