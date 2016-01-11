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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrfcpy.p - Field Update copy subroutine (called from _usrfchg.p) 

   History: D. McMann 07/09/98 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                               to FIND of _File.
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

DEFINE VARIABLE a           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hold        AS CHARACTER NO-UNDO.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE maxpos      AS INTEGER   NO-UNDO.
DEFINE VARIABLE new-name    AS CHARACTER NO-UNDO.
DEFINE VARIABLE o           AS INTEGER   NO-UNDO.
DEFINE VARIABLE canned      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE answer	    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE skip_fld    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE any_copied  AS LOGICAL   NO-UNDO init no.

DEFINE BUFFER   copy_fld  FOR _Field.
DEFINE BUFFER   ref_fld   FOR _Field.  /* extra buf for reference */
DEFINE BUFFER   ref_fil   FOR _File.   

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /* 1*/ "Source Tables",
  /* 2*/ "Fields in",
  /* 3*/ "Copying field",
  /* 4*/ "There are no available tables to copy from.",
  /* 5*/ "There are no fields in the requested table.",
  /* 6*/ "Field copying completed.",
  /* 7*/ "Name is still not unique."
].

FORM
  "This field already exists in the destination" SKIP
  "table.  If you still want to copy it, give it" SKIP
  "a unique name.  Otherwise, press" hold FORMAT "x(10)" SKIP
  "and it will be skipped." SKIP(1)
  new-name FORMAT "x(32)" 
  {prodict/user/userbtns.i}
  WITH FRAME rename-me 
  ROW 7 CENTERED NO-LABELS ATTR-SPACE DEFAULT-BUTTON btn_OK
  VIEW-AS DIALOG-BOX.

FORM SKIP(1)
  "To copy fields from another table," SKIP
  "first you will be allowed to"       SKIP
  "select the table.  Then, mark the"  SKIP
  "fields in that table that you want" SKIP
  "to copy using" hold FORMAT "x(20)" SKIP(1)
  WITH FRAME copy-note OVERLAY ROW 4 COLUMN 2 NO-LABELS NO-ATTR-SPACE
       USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

PAUSE 0.

ASSIGN
  user_env[9] = "no" /* this is the "anything done" flag */
  pik_chosen  = 0
  pik_column  = 38
  pik_count   = 0
  pik_hide    = TRUE
  pik_init    = ""
  pik_list    = ""
  pik_multi   = FALSE
  pik_number  = FALSE
  pik_row     = 4
  pik_title   = new_lang[1] /* Source Tables */
  pik_wide    = FALSE.

FOR EACH _File WHERE _File._Db-recid = drec_db 
                 AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                 AND NOT _File._Hidden
                  BY _File._File-name:
  ASSIGN
    pik_count = pik_count + 1
    pik_list[pik_count] = _File._File-name.
END.

IF pik_count = 0 THEN DO:
  MESSAGE new_lang[4]. /* ain't no files */
  RETURN.
END.

DISPLAY "[" + KBLABEL("RETURN") + "]." @ hold WITH FRAME copy-note.

RUN "prodict/user/_usrpick.p".
IF pik_return = 0 THEN DO:
  HIDE FRAME copy-note NO-PAUSE.
  RETURN.
END.

FIND _File WHERE _File._Db-recid = drec_db 
             AND _File._File-name = pik_first
             AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").

ASSIGN
  pik_column = 38
  pik_hide   = TRUE
  pik_init   = ""
  pik_row    = 4
  pik_title  = new_lang[2] /* Source Fields of */
             + ' "' + _File._File-name + '"'
  pik_wide   = FALSE
  pik_count  = 0
  pik_list   = ""
  pik_chosen = 0
  pik_multi  = TRUE
  pik_number = FALSE.

FOR EACH _Field OF _File BY _Field._Field-name:
  ASSIGN
    pik_count = pik_count + 1
    pik_list[pik_count] = _Field._Field-name.
END.

IF pik_count = 0 THEN DO:
  MESSAGE new_lang[5]. /* ain't no fields */
  HIDE FRAME copy-note NO-PAUSE.
  RETURN.
END.

RUN "prodict/user/_usrpick.p".
HIDE FRAME copy-note NO-PAUSE.
IF pik_return = 0 THEN RETURN.

FIND LAST copy_fld
  WHERE copy_fld._File-recid = drec_file
  USE-INDEX _Field-Position NO-ERROR.
ASSIGN
  user_env[9] = "yes"
  maxpos      = (IF AVAILABLE copy_fld
                THEN TRUNCATE(copy_fld._Order / 10 + 1,0) * 10
                ELSE 10).

/* Adjust the ok and cancel buttons */
{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME rename-me"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}

_copy:
DO TRANSACTION i = 1 TO pik_return:
  FIND copy_fld OF _File
    WHERE copy_fld._Field-name = pik_list[pik_chosen[i]].
  ASSIGN
    o        = (IF CAN-FIND(_Field
               WHERE _Field._File-recid = drec_file
                 AND _Field._Order = copy_fld._Order)
               THEN maxpos
               ELSE copy_fld._Order)
    a        = CAN-FIND(_Field
               WHERE _Field._File-recid = drec_file
                 AND _Field._Field-name = copy_fld._Field-name)
    new-name = copy_fld._Field-name
    maxpos   = TRUNCATE(MAXIMUM(maxpos,o) / 10 + 1,0) * 10
    skip_fld = FALSE
    canned   = FALSE.

  IF a THEN DO:
    DISPLAY "[" + KBLABEL("CLEAR") + "]" @ hold new-name WITH FRAME rename-me.

    /*----- ON CLEAR (SKIP) -----*/
    ON "CLEAR" OF new-name IN FRAME rename-me DO:
      DISPLAY ? @ new-name WITH FRAME rename-me.
      skip_fld = TRUE.
      APPLY "GO" TO FRAME rename-me.
    END.
  
    /*-----GO OF RENAME FRAME -----*/
    ON GO OF FRAME rename-me DO:
      DEFINE VAR nname AS CHAR NO-UNDO.

      if skip_fld THEN 
      	 RETURN.

      nname = new-name:SCREEN-VALUE IN FRAME rename-me.
      RUN "adecomm/_valname.p" (INPUT nname, INPUT no, OUTPUT answer).
      IF NOT answer THEN DO:
      	 APPLY "ENTRY" TO new-name IN FRAME rename-me.
      	 RETURN NO-APPLY.
      END.
  
      IF CAN-FIND(_Field WHERE _Field._File-recid = drec_file
      		  AND _Field._Field-name = nname) THEN DO:
      	message new_lang[7] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
      END.
    END.
  
     canned = TRUE.  /* assume we won't finish -for now */
    DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      SET new-name btn_OK btn_Cancel WITH FRAME rename-me.
      canned = FALSE.
    END.
  END.

  HIDE FRAME rename-me NO-PAUSE.
  IF canned THEN LEAVE _copy.
  IF skip_fld THEN NEXT _copy.

  PAUSE 0.
  MESSAGE new_lang[3] copy_fld._Field-Name.
  CREATE _Field.
  ASSIGN
    _Field._Field-Name   = new-name
    _Field._Order        = o
    _Field._File-recid   = drec_file
    _Field._Data-type    = copy_fld._Data-type
    _Field._Format       = copy_fld._Format
    _Field._Initial      = copy_fld._Initial.
  { prodict/dump/copy_fld.i &from=copy_fld &to=_Field &all=false}

  any_copied = yes.

END. /* for each copy_fld */

PAUSE 0.
IF any_copied THEN
   MESSAGE new_lang[6]. /* all done */
RETURN.


