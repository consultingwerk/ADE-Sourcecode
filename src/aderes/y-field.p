/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * y-field.p - select fields
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i }

DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-o   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-v   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-x   AS INTEGER   NO-UNDO.

/* save table */
DEFINE TEMP-TABLE qbf-flds NO-UNDO
  FIELD qbf-c AS CHARACTER /* like qbf-rcc[] */
  FIELD qbf-f AS CHARACTER /* like qbf-rcf[] */
  FIELD qbf-g AS CHARACTER /* like qbf-rcg[] */
  FIELD qbf-l AS CHARACTER /* like qbf-rcl[] */
  FIELD qbf-n AS CHARACTER /* ENTRY(1,qbf-rcn[]) */
  FIELD qbf-e AS CHARACTER /* the remaining entries of qbf-rcn - separate to
      	       	     	      keep out of the index */
  FIELD qbf-p AS CHARACTER /* like qbf-rcp[] */
  FIELD qbf-s AS CHARACTER /* like qbf-rcs[] */
  FIELD qbf-t AS INTEGER   /* like qbf-rct[] */
  FIELD qbf-w AS INTEGER   /* like qbf-rcw[] */
  INDEX qbf-flds-index IS PRIMARY qbf-n.

IF qbf-module = "l":u THEN DO: /*-------------------------------------------*/
  qbf-a   = TRUE.

  DO qbf-i = 1 TO EXTENT(qbf-l-text) WHILE qbf-a:
    qbf-a = qbf-l-text[qbf-i] = "".
  END.

  IF qbf-a = ? THEN .
  ELSE IF qbf-a THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"yes-no-cancel":u,
      SUBSTITUTE("Should &1 try to automatically select the fields for the labels?", qbf-product)).

    IF qbf-a THEN DO: 		/* automatically select fields */
      RUN aderes/l-guess.p.
      IF qbf-l-text[1] = "" THEN 
        qbf-dirty = TRUE.
    END.
    ELSE IF qbf-a <> ? THEN DO: /* manually select fields */
      ASSIGN
        qbf-o = ""
        qbf-i = 1.
      RUN aderes/j-field2.p (qbf-tables,"!$#@12345rpcsdnlx":u,
                             "Add/Remove Fields":t32,
                             INPUT-OUTPUT qbf-o,OUTPUT qbf-chg).
      
      IF qbf-o = "" THEN 
        qbf-dirty = TRUE.

      DO WHILE qbf-o <> "":
        ASSIGN
          qbf-l-text[qbf-i] = qbf-l-text[qbf-i]
                            + qbf-left + ENTRY(1,qbf-o) + qbf-right
          qbf-o             = SUBSTRING(qbf-o,INDEX(qbf-o + ",":u,",":u) + 1,
                                -1,"CHARACTER":u)
          qbf-i             = MINIMUM(qbf-i + 1,EXTENT(qbf-l-text)).
      END.
    END.
    ELSE IF qbf-a = ? THEN 
      ASSIGN qbf-module = "r":u
             qbf-dirty  = TRUE.
  END.

  IF qbf-a <> ? AND qbf-module = "l":u THEN DO:
    RUN aderes/l-edit.p (OUTPUT qbf-a).
    qbf-k = TRUE.

    DO qbf-i = 1 TO EXTENT(qbf-l-text) WHILE qbf-k:
      qbf-k = qbf-l-text[qbf-i] = "".
    END.

    IF qbf-a OR qbf-k THEN 
      qbf-dirty = TRUE.
  END.
END.
ELSE DO: /*-----------------------------------------------------------------*/
  /* was: s-column.p - play with fields/calc fields */

  ASSIGN
    qbf-o = ""
    qbf-x = qbf-rc#.
  DO qbf-i = 1 TO qbf-rc#:
    CREATE qbf-flds.
    ASSIGN
      qbf-flds.qbf-c = qbf-rcc[qbf-i]
      qbf-flds.qbf-f = qbf-rcf[qbf-i]
      qbf-flds.qbf-g = qbf-rcg[qbf-i]
      qbf-flds.qbf-l = qbf-rcl[qbf-i]
      qbf-flds.qbf-n = ENTRY(1,qbf-rcn[qbf-i])
      qbf-flds.qbf-e = (IF qbf-rcc[qbf-i] = "" THEN "" ELSE
        SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",":u) + 1,-1,
                  "CHARACTER":u))
      qbf-flds.qbf-p = qbf-rcp[qbf-i]
      qbf-flds.qbf-s = qbf-rcs[qbf-i]
      qbf-flds.qbf-t = qbf-rct[qbf-i]
      qbf-flds.qbf-w = qbf-rcw[qbf-i]
      qbf-o       = qbf-o + (IF qbf-i = 1 THEN "" ELSE ",":u)
                  + ENTRY(1,qbf-rcn[qbf-i]).
  END.

  qbf-v = qbf-o.
  RUN aderes/j-field2.p (qbf-tables,"!$#=@":u,"",
                          INPUT-OUTPUT qbf-o,
      	       	          OUTPUT qbf-chg).
  IF qbf-v = qbf-o THEN RETURN.

  ASSIGN
    qbf-rcc     = ""
    qbf-rcf     = ""
    qbf-rcg     = ""
    qbf-rcl     = ""
    qbf-rcn     = ""
    qbf-rcp     = ""
    qbf-rcs     = ""
    qbf-rct     = 0
    qbf-rcw     = ?
    qbf-rc#     = 0
    qbf-summary = FALSE.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-o) WHILE qbf-rc# < EXTENT(qbf-rcn):
    qbf-v = ENTRY(qbf-i,qbf-o).
    FIND FIRST qbf-flds WHERE qbf-flds.qbf-n = qbf-v NO-ERROR.
    IF AVAILABLE qbf-flds THEN DO:
      /* Field still selected - copy from saved list */
      ASSIGN
        qbf-rc#          = qbf-rc# + 1
        qbf-rcc[qbf-rc#] = qbf-flds.qbf-c
        qbf-rcf[qbf-rc#] = qbf-flds.qbf-f
        qbf-rcg[qbf-rc#] = qbf-flds.qbf-g
        qbf-rcl[qbf-rc#] = qbf-flds.qbf-l
        qbf-rcn[qbf-rc#] = qbf-flds.qbf-n + 
      	       	     	   (IF qbf-flds.qbf-e = "" THEN "" ELSE
      	       	     	    ",":u + qbf-flds.qbf-e)
        qbf-rcp[qbf-rc#] = qbf-flds.qbf-p
        qbf-rcs[qbf-rc#] = qbf-flds.qbf-s
        qbf-rct[qbf-rc#] = qbf-flds.qbf-t
        qbf-rcw[qbf-rc#] = qbf-flds.qbf-w.
       
      /* rename calculated field if it's been moved up/down in the list */ 
      IF qbf-rcc[qbf-rc#] > "" 
        AND ENTRY(1,qbf-rcn[qbf-rc#]) BEGINS "qbf-":u THEN
        SUBSTRING(qbf-rcn[qbf-rc#],5,3,"CHARACTER":u) = 
          STRING(qbf-rc#,"999":u).

      IF INDEX(qbf-rcg[qbf-rc#],"$":u) > 0 THEN
      	qbf-summary = TRUE.
      DELETE qbf-flds.
    END.
    ELSE DO:
      /* Field wasn't selected before - so add it in */

      DEFINE VARIABLE realName AS CHARACTER NO-UNDO.
      DEFINE VARIABLE realTid  AS INTEGER   NO-UNDO.
      DEFINE VARIABLE dtName   AS CHARACTER NO-UNDO.

      ASSIGN
        qbf-j = INDEX(qbf-v,"[":u)
        qbf-j = (IF qbf-j = 0 THEN 0 
          ELSE INTEGER(SUBSTRING(qbf-v,qbf-j + 1,
                                 INDEX(qbf-v,"]":u) - qbf-j - 1,
                                 "CHARACTER":u))).

      /*
       * Get the schema information about the field. INsure that any
       * table alias is taken care of. And we must pass a tempName. Qbf-v
       * is the name of the field that gets stored in the field's
       * datastructure.
       */

      ASSIGN
        realName = qbf-v
        dtName   = ENTRY(1,qbf-v,".":u) + ".":u + ENTRY(2,qbf-v,".":u)
      .

      RUN alias_to_tbname (qbf-v,TRUE,OUTPUT realName).
      RUN adecomm/_y-schem.p (realName,"","",OUTPUT qbf-s).

      ASSIGN
        qbf-rc#          = qbf-rc# + 1
        qbf-rcc[qbf-rc#] = ""
        qbf-rcf[qbf-rc#] = ENTRY(2,qbf-s,CHR(10))
        qbf-rcg[qbf-rc#] = ""
        qbf-rcn[qbf-rc#] = qbf-v
        qbf-rcp[qbf-rc#] = ",,,,,":u
        qbf-rct[qbf-rc#] = INTEGER(ENTRY(1,qbf-s))
        qbf-rcl[qbf-rc#] = ENTRY(3,qbf-s,CHR(10))
                         + (IF qbf-j = 0 THEN ""
                           ELSE "[":u + STRING(qbf-j) + "]":u)
        qbf-dirty        = TRUE
      .

      	/* qbf-rcw is only used by report and is recalc'ed when needed */
        /* qbf-rcs for new field is determined by s-level.p. */
    END.
  END.
END. /*---------------------------------------------------------------------*/

RETURN.

/* y-field.p - end of file */

