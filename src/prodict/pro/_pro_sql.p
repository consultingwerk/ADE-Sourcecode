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

/* sql_fld - field editor for Progress/SQL files */

/*
dfields is NOT AVAILABLE to create, otherwise contains record to
UPDATE (you ain't spoz'ta create with Progress/SQL files).

When you come into this routine, the field name is already set on the
form.
*/

DEFINE INPUT  PARAMETER ronly AS CHARACTER            NO-UNDO.
DEFINE INPUT  PARAMETER junk2 AS RECID                NO-UNDO.
DEFINE OUTPUT PARAMETER junk3 AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE SHARED BUFFER dfields FOR _Field.
DEFINE VARIABLE fld_val AS CHARACTER EXTENT 4 NO-UNDO.
DEFINE VARIABLE foreign AS LOGICAL            NO-UNDO.
DEFINE VARIABLE i       AS INTEGER            NO-UNDO.
DEFINE VARIABLE inindex AS LOGICAL            NO-UNDO.
DEFINE VARIABLE inview  AS LOGICAL            NO-UNDO.
DEFINE VARIABLE j       AS INTEGER            NO-UNDO.

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 2 NO-UNDO INITIAL [
  /* 1*/ "Cannot delete PROGRESS/SQL fields.  Use ALTER TABLE/DROP COLUMN.",
  /* 2*/ "Cannot create PROGRESS/SQL fields.  Use ALTER TABLE/ADD COLUMN."
].

FORM
  dfields._Field-name LABEL "  Field-Name" FORMAT "x(32)"
    VALIDATE(KEYWORD(dfields._Field-name) = ?,
      "This name conflicts with a PROGRESS reserved keyword.") SPACE
  dfields._Data-type  LABEL    "Data-Type" FORMAT "x(9)"  SKIP

  dfields._Format     LABEL "      Format" FORMAT "x(30)" SPACE(3)
  dfields._Extent     LABEL    "   Extent" FORMAT ">>>>"  SKIP

  dfields._Label      LABEL "       Label" FORMAT "x(30)" SPACE(4)
  foreign         NO-LABEL  FORMAT "  Length:/Decimals:" NO-ATTR-SPACE SPACE(0)
  dfields._Decimals NO-LABEL               FORMAT ">>>>9" SKIP

  dfields._Col-label  LABEL "Column-label" FORMAT "x(30)" SPACE(3)
  dfields._Order      LABEL    "    Order" FORMAT ">>>9"  SKIP

  dfields._Initial    LABEL "     Default" FORMAT "x(30)" SPACE(3)
  dfields._Mandatory  LABEL    " Not Null" FORMAT "yes/no" "(Mandatory)" SKIP

  inview             LABEL "Component of-> View" inindex LABEL "Index" SPACE(9)
  dfields._Fld-case   LABEL "Case-sensitive" FORMAT "yes/no" SKIP

/*dfields._Valexp     LABEL "Valexp"       FORMAT "x(70)" SKIP*/
  fld_val[1]         LABEL "Valexp"       FORMAT "x(63)" SKIP
  fld_val[2]         LABEL "      "       FORMAT "x(63)" SKIP
  fld_val[3]         LABEL "      "       FORMAT "x(63)" SKIP
  fld_val[4]         LABEL "      "       FORMAT "x(63)" SKIP
  dfields._Valmsg     LABEL "Valmsg"       FORMAT "x(63)" SKIP
  dfields._Help       LABEL "  Help"       FORMAT "x(63)" SKIP
  dfields._Desc       LABEL "  Desc"       FORMAT "x(70)" SKIP
  HEADER ""
  WITH FRAME sql_fld NO-BOX ATTR-SPACE OVERLAY SIDE-LABELS
  ROW (SCREEN-LINES - 18) COLUMN 1.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

IF NOT AVAILABLE dfields THEN
  FIND FIRST dfields
    WHERE dfields._File-recid= drec_file
    USING FRAME sql_fld _Field-name NO-ERROR.

IF NOT AVAILABLE dfields THEN DO:
  MESSAGE new_lang[2]. /* cannot create */
  { prodict/user/userpaus.i }
  HIDE MESSAGE NO-PAUSE.
  RETURN.
END.

ASSIGN
  inindex = CAN-FIND(FIRST _Index-field OF dfields)
  inview  = CAN-FIND(FIRST _View-ref
            WHERE _View-ref._Ref-Table = user_filename
              AND _View-ref._Base-Col = dfields._Field-name).

{ prodict/dictsplt.i
  &src=dfields._Valexp &dst=fld_val &num=4 &len=63 &chr=" " }

DISPLAY
  inview inindex
  (dfields._Data-type = "character") @ foreign
  dfields._Field-name
  dfields._Data-type
  dfields._Format
  dfields._Label
  dfields._Col-label
  dfields._Initial
  dfields._Extent
  dfields._Decimals
  dfields._Order
  dfields._Mandatory
  dfields._Fld-case
/*dfields._Valexp*/
  fld_val[1 FOR 4]
  dfields._Valmsg
  dfields._Help
  dfields._Desc
  WITH FRAME sql_fld.
NEXT-PROMPT dfields._Format WITH FRAME sql_fld.

IF ronly = "r/o" THEN DO:
  { prodict/user/userpaus.i }
  HIDE FRAME sql_fld NO-PAUSE.
  RETURN.
END.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  SET
  /*dfields._Field-name*/
  /*dfields._Data-type*/
    dfields._Format
    dfields._Label
    dfields._Col-label
    dfields._Initial
  /*dfields._Extent*/
  /*dfields._Decimals*/
  /*dfields._Order*/
  /*dfields._Mandatory*/
    dfields._Fld-case WHEN NOT inindex AND INPUT dfields._Data-type = "character"
  /*dfields._Valexp*/
    TEXT(fld_val[1 FOR 4])
    dfields._Valmsg
    dfields._Help
    dfields._Desc
    WITH FRAME sql_fld.

  ASSIGN
    dfields._Valexp = fld_val[1] + " " + fld_val[2] + " "
                   + fld_val[3] + " " + fld_val[4]
    dfields._Valexp = (IF dfields._Valexp = "" THEN ? ELSE dfields._Valexp).
END.

HIDE FRAME sql_fld NO-PAUSE.
RETURN.
