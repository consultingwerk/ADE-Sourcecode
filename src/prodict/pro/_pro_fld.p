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

/* pro_fld - field editor for Progress files */

/*
dfields is NOT AVAILABLE to create, otherwise contains record to
UPDATE.

When you come into this routine, the field name is already set on the
form.
*/

/* Modification History:
     D. McMann 03/31/98 Added display of _Field-rpos
     DLM       07/13/98 Added _Owner to _File Find
     DLM       11/16/98 Added missed _Owner for pick list
     Mario B.  11/16/98 Added trigger to check for duplicate order numbers
     
*/     

DEFINE INPUT  PARAMETER ronly   AS CHARACTER             NO-UNDO.
DEFINE INPUT  PARAMETER junk2   AS RECID                 NO-UNDO.
DEFINE OUTPUT PARAMETER changed AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE SHARED BUFFER dfields FOR _Field.

DEFINE VARIABLE answer   AS LOGICAL            NO-UNDO.
DEFINE VARIABLE c        AS CHARACTER          NO-UNDO.
DEFINE VARIABLE copied   AS LOGICAL            NO-UNDO.
DEFINE VARIABLE i        AS INTEGER            NO-UNDO.
DEFINE VARIABLE inindex  AS LOGICAL            NO-UNDO.
DEFINE VARIABLE inother  AS LOGICAL            NO-UNDO.
DEFINE VARIABLE inview   AS LOGICAL            NO-UNDO.
DEFINE VARIABLE j        AS INTEGER            NO-UNDO.
DEFINE VARIABLE neworder AS INTEGER            NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  /* 1*/ "This field is used in a View or Index - cannot delete.",
  /* 2*/ "This field is used in a View - cannot rename.",
  /* 3*/ "This name is already used by a different field in this file",
  /* 4*/ "There is a field in these tables", /* make sure 4..6 fit in the */
  /* 5*/ "with the same name, pick one to", /* frame format 'x(31)'      */
  /* 6*/ ?, /*see below*/                   /* frame name 'frm_top'      */
  /* 7*/ "You must enter a field name here",
  /* 8*/ "create new field",
  /* 9*/ "Attempt to add with same name as existing field - switching to MODIFY"
].
new_lang[6] = "copy, or press [" + KBLABEL("END-ERROR") + "].".

FORM
  dfields._Field-name LABEL "  Field-Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a PROGRESS reserved keyword.") SPACE
  dfields._Data-type  LABEL "   Data-Type" FORMAT "x(9)"
    HELP "Data types: Character DAte DEcimal Integer Logical REcid" SKIP

  dfields._Format     LABEL "      Format" FORMAT "x(30)" SPACE(3)
  dfields._Extent     LABEL "      Extent" FORMAT ">>>>"  SKIP

  dfields._Label      LABEL "       Label" FORMAT "x(30)" SPACE(3)
  dfields._Decimals   LABEL "    Decimals" FORMAT ">>>>9" SKIP
  
  dfields._Col-label  LABEL "Column-label" FORMAT "x(30)" SPACE(3)
  dfields._Order      LABEL "       Order" FORMAT ">>>>9"  SKIP

  dfields._Initial    LABEL "     Initial" FORMAT "x(30)" SPACE(3)
  dfields._Mandatory  LABEL "   Mandatory" FORMAT "yes/no" "(Not Null)" SKIP

  inview              LABEL "Component of-> View" inindex LABEL "Index" 
  dfields._Field-rpos LABEL "Position" FORMAT ">>>>9" 
  dfields._Fld-case   LABEL "Case-sensitive" FORMAT "yes/no" SKIP

  dfields._Valexp     LABEL "Valexp"       VIEW-AS EDITOR
                                                                          INNER-CHARS 63 INNER-LINES 4
                                                                          BUFFER-LINES 4 SKIP
  dfields._Valmsg     LABEL "Valmsg"       FORMAT "x(63)" SKIP
  dfields._Help       LABEL "  Help"       FORMAT "x(63)" SKIP
  dfields._Desc       LABEL "  Desc"       FORMAT "x(70)" SKIP
  HEADER ""
  WITH FRAME pro_fld NO-BOX ATTR-SPACE OVERLAY SIDE-LABELS
  ROW (SCREEN-LINES - 19) COLUMN 1 SCROLLABLE.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

FORM
  new_lang[4] FORMAT "x(37)" SKIP
  new_lang[5] FORMAT "x(37)" SKIP
  new_lang[6] FORMAT "x(37)" SKIP
  WITH FRAME frm_top OVERLAY NO-ATTR-SPACE NO-LABELS
  ROW pik_row - 5 COLUMN pik_column.


IF NOT AVAILABLE dfields THEN DO:
  CLEAR FRAME pro_fld NO-PAUSE.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    PROMPT-FOR _Field-name WITH FRAME pro_fld.
    IF INPUT FRAME pro_fld _Field-name = "" THEN DO:
      MESSAGE new_lang[7]. /* nothing entered! */
      UNDO,RETRY.
    END.
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    HIDE FRAME pro_fld NO-PAUSE.
    RETURN.
  END.
  FIND FIRST dfields WHERE dfields._File-recid = drec_file
    AND dfields._field-name = INPUT FRAME pro_fld _Field-name NO-ERROR.
  IF AVAILABLE dfields THEN MESSAGE new_lang[9].
END.

copied = FALSE.
IF AVAILABLE dfields THEN DO: /*---------------------------------------------*/
  ASSIGN
    inindex    = CAN-FIND(FIRST _Index-field OF dfields)
    inview     = CAN-FIND(FIRST _View-ref
                 WHERE _View-ref._Ref-Table = user_filename
                   AND _View-ref._Base-Col = dfields._Field-name)
    neworder   = dfields._Order.
END. /*---------------------------------------------------------------------*/
ELSE DO: /*-----------------------------------------------------------------*/
  FIND LAST _Field USE-INDEX _Field-Position
    WHERE _Field._File-recid = drec_file NO-ERROR.
  ASSIGN
    inindex    = FALSE
    inview     = FALSE
    inother    = CAN-FIND(FIRST _Field
                 WHERE _Field._Field-name =
                 INPUT FRAME pro_fld dfields._Field-name)
    neworder   = (IF AVAILABLE _Field THEN _Field._Order + 10 ELSE 10)
    pik_column = 40
    pik_row    = SCREEN-LINES - 10
    pik_hide   = TRUE
    pik_init   = ""
    pik_title  = ""
    pik_list   = ""
    pik_wide   = FALSE
    pik_multi  = FALSE
    pik_number = FALSE
    pik_count  = 1
    pik_list[1] = "<<" + new_lang[8] + ">>". /* <<create new field>> */

  IF inother THEN
    FOR EACH _Field
      WHERE _Field._Field-name = INPUT FRAME pro_fld dfields._Field-name:
        FOR EACH _File OF _Field
          WHERE _File._Db-recid = drec_db AND RECID(_File) <> drec_file
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
          BY _File._File-name:
          ASSIGN
            pik_count = pik_count + 1
            pik_list[pik_count] = _File._File-name.
        END.
    END.

  /* since we can't tell if a field is in another (non-progress)
  schema, we have to wait until we attempt the join above to eliminate
  those candidates.  hence, the following test: */
  IF pik_count <= 1 THEN inother = FALSE.

  IF inother THEN _in-other: DO:
    PAUSE 0.
    DISPLAY new_lang[4 FOR 3] WITH FRAME frm_top.
    RUN "prodict/user/_usrpick.p".
    HIDE FRAME frm_top NO-PAUSE.
    IF pik_return = 0 OR pik_first BEGINS "<<" THEN LEAVE _in-other.
    FIND _File WHERE _File._Db-recid = drec_db AND _File._File-name = pik_first
                 AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    FIND _Field OF _File WHERE _Field._Field-name =
      INPUT FRAME pro_fld dfields._Field-name.
    ASSIGN
      copied     = TRUE.

    DISPLAY
      _Field._Field-name @ dfields._Field-name /*match case*/
      _Field._Data-type  @ dfields._Data-type
      _Field._Format     @ dfields._Format
      _Field._Label      @ dfields._Label
      _Field._Col-label  @ dfields._Col-label
      _Field._Initial    @ dfields._Initial
      _Field._Extent     @ dfields._Extent
      _Field._Decimals   @ dfields._Decimals
      neworder           @ dfields._Order
      _Field._Mandatory  @ dfields._Mandatory
      _Field._Fld-case   @ dfields._Fld-case
      _Field._Field-rpos @ dfields._Field-rpos
      _Field._Valmsg     @ dfields._Valmsg
      _Field._Help       @ dfields._Help
      _Field._Desc       @ dfields._Desc
      WITH FRAME pro_fld.

    /* Can't seem to do @ on a view-as editor widget so: */
    dfields._Valexp:screen-value in frame pro_fld = _Field._Valexp.
  END.

  CREATE dfields.
  dfields._File-recid = drec_file.
END. /*---------------------------------------------------------------------*/

DISPLAY inview inindex WHEN copied WITH FRAME pro_fld.

NEXT-PROMPT dfields._Data-type WITH FRAME pro_fld.
IF NEW dfields THEN DO:
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    SET
      dfields._Field-name
        VALIDATE(NOT CAN-FIND(_Field
          WHERE _Field._File-recid = drec_file
            AND _Field._Field-name = INPUT dfields._Field-name),
        "")
      dfields._Data-type
        VALIDATE(dfields._Data-type <> ?,"")
      WITH FRAME pro_fld.
    IF dfields._Data-type = ? THEN UNDO,RETRY.
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    IF NEW dfields THEN DELETE dfields.
    HIDE FRAME pro_fld NO-PAUSE.
    RETURN.
  END.
END.

IF NOT copied THEN DISPLAY
  dfields._Field-name /*match case*/
  dfields._Data-type
  dfields._Format
  dfields._Label
  dfields._Col-label
  dfields._Initial
  dfields._Extent
  dfields._Decimals
  neworder @ dfields._Order
  dfields._Mandatory
  dfields._Fld-case
  dfields._Field-rpos
  dfields._Valexp
  dfields._Valmsg
  dfields._Help
  dfields._Desc
  WITH FRAME pro_fld.

IF ronly = "r/o" THEN DO:
  { prodict/user/userpaus.i }
  HIDE FRAME pro_fld NO-PAUSE.
  RETURN.
END.

NEXT-PROMPT dfields._Format WITH FRAME pro_fld.
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  /* Dis-allow duplicate order numbers */
  ON LEAVE OF dfields._Order
  DO:
      IF CAN-FIND(FIRST _Field WHERE
                        _Field._File-recid = drec_file AND
                        _Field._Order = INPUT dfields._Order AND
			_Field._Order <> dfields._Order) THEN
      DO:
	 MESSAGE "Order number" TRIM(INPUT dfields._Order) "already exists." 
	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	 /* set order number back to its current value */
	 dfields._Order:SCREEN-VALUE = STRING(neworder).
         RETURN NO-APPLY.
      END.
  END.

  SET
    dfields._Field-name WHEN NOT INPUT dfields._Field-name BEGINS "_"
  /*dfields._Data-type WHEN NEW dfields*/
    dfields._Format
    dfields._Label
    dfields._Col-label
    dfields._Initial
    dfields._Extent    WHEN NEW dfields
    dfields._Decimals  WHEN INPUT dfields._Data-type = "decimal"
    dfields._Order
    dfields._Mandatory
    dfields._Fld-case WHEN INPUT dfields._Data-type = "character"
                        AND (NEW dfields OR NOT inindex)
    dfields._Valexp
    dfields._Valmsg
    dfields._Help
    dfields._Desc
    WITH FRAME pro_fld.

  IF dfields._Field-name ENTERED AND NOT NEW dfields AND inview THEN DO:
    MESSAGE new_lang[2]. /* sorry, used in view */
    UNDO,RETRY.
  END.

  ASSIGN
    dfields._Valexp = (IF TRIM(dfields._Valexp) = "" 
                                           THEN ? 
                                           ELSE TRIM(dfields._Valexp)).
  changed = TRUE.
END.
IF KEYFUNCTION(LASTKEY) = "END-ERROR" AND NEW dfields THEN DELETE dfields.

HIDE FRAME pro_fld NO-PAUSE.
RETURN.
