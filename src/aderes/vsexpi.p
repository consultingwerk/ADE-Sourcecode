/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _vsexpi.p
*
*    Set export view format.
*
*  Input Parameters
*
*    newView    The view type to set.  Codes are defined in results.l.
*
*  Output Parameters
*
*    lRet       false=OK, true=error
*    oldView    old view to restore
*/

{ aderes/e-define.i }
{ aderes/s-define.i }
{ aderes/s-system.i }

DEFINE INPUT  PARAMETER newView      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER lRet         AS LOGICAL   NO-UNDO. /* true=error */
DEFINE OUTPUT PARAMETER oldView      AS CHARACTER NO-UNDO.

DEFINE VARIABLE found  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE prefix AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO.
DEFINE VARIABLE suffix AS CHARACTER NO-UNDO.
DEFINE VARIABLE token  AS CHARACTER NO-UNDO.

FIND FIRST qbf-esys /*WHERE qbf-esys.qbf-live*/ NO-ERROR.
IF AVAILABLE qbf-esys THEN 
  ASSIGN
    oldView              = qbf-esys.qbf-type
    qbf-esys.qbf-base    = ?
    qbf-esys.qbf-type    = ""
    qbf-esys.qbf-desc    = ""
    qbf-esys.qbf-dlm-typ = ""
    qbf-esys.qbf-fixed   = FALSE
    qbf-esys.qbf-fld-dlm = ""
    qbf-esys.qbf-fld-sep = ""
    qbf-esys.qbf-headers = FALSE
    qbf-esys.qbf-prepass = FALSE
    qbf-esys.qbf-program = ""
    qbf-esys.qbf-lin-beg = ""
    qbf-esys.qbf-lin-end = ""
    qbf-esys.qbf-type    = ""
    qbf-esys.qbf-width   = 0
    .
ELSE DO:
  CREATE qbf-esys.
  /*qbf-esys.qbf-live = TRUE.*/
END.

DO qbf-i = 1 TO EXTENT(qbf-e-cat):
  DO qbf-j = 1 TO NUM-ENTRIES(qbf-e-cat[qbf-i],"|":u):
    token = ENTRY(qbf-j,qbf-e-cat[qbf-i],"|":u).
    IF token BEGINS "t=":u THEN DO:
      IF token = "t=":u + newView THEN 
        found = TRUE.
      LEAVE.
    END.
  END.
  IF found THEN LEAVE.
END.

IF qbf-i > EXTENT(qbf-e-cat) THEN DO:
  MESSAGE "Export format &1 could not be found."
    VIEW-AS ALERT-BOX ERROR.
  lRet = TRUE.
  RETURN.
END.

DO qbf-j = 1 TO NUM-ENTRIES(qbf-e-cat[qbf-i],"|":u):
  ASSIGN
    token  = ENTRY(qbf-j,qbf-e-cat[qbf-i],"|":u)
    prefix = SUBSTRING(token,1,2,"CHARACTER":u)
    suffix = SUBSTRING(token,3,-1,"CHARACTER":u)
    .

  CASE prefix:
    WHEN "b=":u THEN qbf-esys.qbf-base    = (IF suffix = "?":u THEN ?
                                             ELSE DATE(suffix)).
    WHEN "d=":u THEN qbf-esys.qbf-dlm-typ = suffix.
    WHEN "f=":u THEN qbf-esys.qbf-fixed   = (suffix MATCHES "*y":u).
    WHEN "h=":u THEN qbf-esys.qbf-headers = (suffix MATCHES "*y":u).
    WHEN "i=":u THEN qbf-esys.qbf-prepass = (suffix MATCHES "*y":u).
    WHEN "p=":u THEN qbf-esys.qbf-program = suffix +
        (IF CAN-DO(qbf-esys.qbf-program,"u-export":u) THEN "":u ELSE ".p":u).
    WHEN "t=":u THEN qbf-esys.qbf-type    = suffix.
    WHEN "1=":u THEN qbf-esys.qbf-lin-beg = suffix.
    WHEN "2=":u THEN qbf-esys.qbf-lin-end = suffix.
    WHEN "3=":u THEN qbf-esys.qbf-fld-dlm = suffix.
    WHEN "4=":u THEN qbf-esys.qbf-fld-sep = suffix.
    WHEN "l=":u THEN qbf-esys.qbf-desc    = suffix.
  END CASE.
END.

/*
message
  qbf-esys.qbf-base    skip
  qbf-esys.qbf-type    skip
  qbf-esys.qbf-desc    skip
  qbf-esys.qbf-dlm-typ skip
  qbf-esys.qbf-fixed   skip
  qbf-esys.qbf-fld-dlm skip
  qbf-esys.qbf-fld-sep skip
  qbf-esys.qbf-headers skip
  qbf-esys.qbf-prepass skip
  qbf-esys.qbf-program skip
  qbf-esys.qbf-lin-beg skip
  qbf-esys.qbf-lin-end skip
  qbf-esys.qbf-type    skip
  qbf-esys.qbf-width   skip
  view-as alert-box.
*/

/* vsexpi.p - end of file */

