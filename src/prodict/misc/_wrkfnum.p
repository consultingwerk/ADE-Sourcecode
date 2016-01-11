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

/* This program resets all _Order fields in a file to multiples
of <fi>, starting with <fb>.
 
    History:  DMcMann 11/16/98 Added _Owner to for each loop to
                               eliminate SQL92 fields
	      Mario B. 11/17/98 Changed renumbering from using a fixed offset
                                of - 10000 for pre-conversion to using * -1 to
				prevent conflicts when a 10000+ Order# exists.
 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE fa  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE fb  AS INTEGER   NO-UNDO.
DEFINE VARIABLE fi  AS INTEGER   NO-UNDO.
DEFINE VARIABLE i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE txt AS CHARACTER NO-UNDO.

ASSIGN
  fa = (user_env[1] = "f")   /* field-name or order */
  fb = INTEGER(user_env[2])  /* base */
  fi = INTEGER(user_env[3]). /* increment */

FORM
  txt FORMAT "x(72)"
  WITH FRAME reseqing SCREEN-LINES - 6 DOWN ROW 2 COLUMN 1 NO-LABELS.

DO TRANSACTION:
  FIND _File WHERE _File._Db-recid = drec_db
    AND _File._File-name = user_filename
    AND (_FILE._OWNER = "PUB" OR _FILE._OWNER = "_FOREIGN").
  FOR EACH _Field OF _File:
    _Field._Order = _Field._Order * -1.
  END.
  i = fb.
  IF fa THEN FOR EACH _Field OF _File BY _Field._Field-name:
    txt = "Changing Order of " + _Field._Field-name + " "
        + "from " + STRING(_Field._Order * -1) + " "
        + "to " + STRING(i) + ".".
    DISPLAY txt WITH FRAME reseqing.
    IF FRAME-LINE(reseqing) = FRAME-DOWN(reseqing) THEN DO:
      UP FRAME-DOWN(reseqing) - 1 WITH FRAME reseqing.
      CLEAR FRAME reseqing ALL NO-PAUSE.
    END.
    ELSE
      DOWN WITH FRAME reseqing.
    ASSIGN
      _Field._Order = i
      i = i + fi.
  END.
  ELSE FOR EACH _Field OF _File BY _Field._Order DESCENDING:
    txt = "Changing Order of " + _Field._Field-name + " "
        + "from " + STRING(_Field._Order * -1) + " "
        + "to " + STRING(i) + ".".
    DISPLAY txt WITH FRAME reseqing.
    IF FRAME-LINE(reseqing) = FRAME-DOWN(reseqing) THEN DO:
      UP FRAME-DOWN(reseqing) - 1 WITH FRAME reseqing.
      CLEAR FRAME reseqing ALL NO-PAUSE. 
    END.
    ELSE
      DOWN WITH FRAME reseqing.
    ASSIGN
      _Field._Order = i
      i = i + fi.
  END.
END.

MESSAGE "Field Order resequencing completed." 
   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
HIDE FRAME reseqing NO-PAUSE.

RETURN.
