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
/* c-map.p - maps qbf-join into qbf-schema for a-join.p */

{ prores/c-form.i }
{ prores/c-merge.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO.

&SCOPED-DEFINE debug FALSE

/*message "[c-map.p]" view-as alert-box.*/

/* Clear out anything hanging around in qbf-schema such as description 
   or pointers from previous instance of this program being run. */
FOR EACH qbf-schema:
  ASSIGN
    qbf-schema.cValue = ENTRY(1,qbf-schema.cValue) + ",":U
                      + ENTRY(2,qbf-schema.cValue) + ",":U
    qbf-schema.cSort  = qbf-schema.cValue.
END.

FOR EACH qbf-join:
  /* Search on ENTRY(1,qbf-join.cValue) into qbf-schema.*/
  ASSIGN
    qbf-c = ENTRY(1,qbf-join.cValue)
    qbf-c = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1) + ",":U
          + SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1) + ",":U.
  FIND FIRST qbf-schema WHERE qbf-schema.cSort BEGINS qbf-c NO-ERROR.
  IF AVAILABLE qbf-schema THEN
    qbf-schema.cValue = qbf-schema.cValue + STRING(qbf-join.iIndex) + ",".
  ELSE IF {&debug} THEN DO:
    /*
    MESSAGE "[c-map.p] qbf-schema.cSort #1" skip
      "qbf-c" qbf-c skip
      "index" qbf-schema.iindex skip
      "sort" qbf-schema.cSort skip
      view-as alert-box.
    */
    NEXT.
  END.
  
  /* Search on ENTRY(2,qbf-join.cValue) into qbf-schema.*/
  ASSIGN
    qbf-c = ENTRY(2,qbf-join.cValue)
    qbf-c = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1) + ",":U
          + SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1) + ",":U.
  /*FIND FIRST buf-schema WHERE buf-schema.cValue BEGINS qbf-c.*/
  FIND FIRST buf-schema WHERE buf-schema.cSort BEGINS qbf-c NO-ERROR.
  IF AVAILABLE buf-schema THEN
    buf-schema.cValue = buf-schema.cValue + STRING(qbf-join.iIndex) + ",".
  ELSE IF {&debug} THEN DO:
    MESSAGE "[c-map.p] buf-schema.cSort #2" skip
      "qbf-c" qbf-c skip
      "index" buf-schema.iindex skip
      "sort" buf-schema.cSort skip
      view-as alert-box.
    NEXT.
  END.

END.

RETURN.

/* c-map.p - end of file */
