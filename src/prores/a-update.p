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
/* a-update.p - converts loaded procedures to current revision level */

{ prores/s-define.i }
{ prores/c-form.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT PARAMETER qbf-b AS LOGICAL NO-UNDO.
/* qbf-b = TRUE for call from a-load.p/a-read.p, FALSE for [dlr]-read.p */

DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-g   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-h   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO.

/*message "[a-update.p]" view-as alert-box.*/

IF qbf-b THEN DO: /*--------------------------------------------------------*/
  /* for joins: place lower alpha entry first */
  DO qbf-i = 1 TO qbf-join#:
    {&FIND_QBF_JOIN} qbf-i.
    IF ENTRY(1,qbf-join.cValue) > ENTRY(2,qbf-join.cValue) THEN
      ASSIGN
        qbf-j = LENGTH(ENTRY(1,qbf-join.cValue))
              + LENGTH(ENTRY(2,qbf-join.cValue))
        SUBSTRING(qbf-join.cValue,1,qbf-j + 1) =
          ENTRY(2,qbf-join.cValue) + "," + ENTRY(1,qbf-join.cValue).
  END.
  IF qbf-join# >= 2 THEN DO: /* alpha sort */
    /* Move indexes 'out of bound' temporarily */
    REPEAT PRESELECT EACH qbf-join USE-INDEX iIndex:
      FIND NEXT qbf-join.
      qbf-join.iIndex = qbf-join.iIndex + 100000.
    END.
    qbf-i = 0.
    /* Reindex joins alphabetically */
    REPEAT PRESELECT EACH qbf-join USE-INDEX cValue:
      FIND NEXT qbf-join.
      ASSIGN
        qbf-i           = qbf-i + 1
        qbf-join.iIndex = qbf-i.
    END.
  END.

  /* for joins: eliminate duplicate entries */
  qbf-i = 1.
  DO qbf-j = 2 TO qbf-join#:
    {&FIND_QBF_JOIN} qbf-i.
    {&FIND_BUF_JOIN} qbf-j.
    IF buf-join.cValue <> ""
      AND  ENTRY(1,qbf-join.cValue) + "," + ENTRY(2,qbf-join.cValue)
        <> ENTRY(1,buf-join.cValue) + "," + ENTRY(2,buf-join.cValue) THEN
      ASSIGN
        qbf-i           = qbf-i + 1
        qbf-join.cValue = buf-join.cValue
        qbf-join.cWhere = buf-join.cWhere.
  END.
  /* Delete duplicate entries */
  FOR EACH qbf-join WHERE qbf-join.iIndex > qbf-i:
    DELETE qbf-join.
  END.
  qbf-join# = qbf-i.

END. /*---------------------------------------------------------------------*/
ELSE DO: /*-----------------------------------------------------------------*/
  ASSIGN
    qbf-d = qbf-db[1]   + "," + qbf-db[2]   + "," + qbf-db[3]   + ","
          + qbf-db[4]   + "," + qbf-db[5]
    qbf-h = qbf-file[1] + "," + qbf-file[2] + "," + qbf-file[3] + ","
          + qbf-file[4] + "," + qbf-file[5].

  /* add db. names to fields */
  DO qbf-i = 1 TO qbf-rc#:
    IF NOT CAN-DO("e*,p*,r*,",qbf-rcc[qbf-i]) THEN NEXT.
    ASSIGN
      qbf-a = CAN-DO("p*,r*",qbf-rcc[qbf-i])
      qbf-c = ENTRY(IF qbf-a THEN 2 ELSE 1,qbf-rcn[qbf-i])
      qbf-j = INDEX(qbf-c,".").
    IF qbf-j = R-INDEX(qbf-c,".") THEN
      ASSIGN
        qbf-c          = ENTRY(LOOKUP(SUBSTRING(qbf-c,1,qbf-j - 1),qbf-h),qbf-d)
                       + "." + qbf-c
        qbf-rcn[qbf-i] = (IF qbf-a THEN ENTRY(1,qbf-rcn[qbf-i]) + "," ELSE "")
                       + qbf-c.
  END.

  /* add db. names to order-by */
  DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
    qbf-j = INDEX(qbf-order[qbf-i],".").
    IF qbf-j <> R-INDEX(qbf-order[qbf-i],".") THEN NEXT.
    qbf-order[qbf-i] = ENTRY(LOOKUP(SUBSTRING(
                       qbf-order[qbf-i],1,qbf-j - 1),qbf-h),qbf-d)
                     + "." + qbf-order[qbf-i].
  END.
END. /*---------------------------------------------------------------------*/

RETURN.
