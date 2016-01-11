/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-ftsub.p - FAST TRACK report link (part 2 of 2) */

&if FALSE &then

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i } /* assumes language set swapped in already */

/* Variables used to validate report-name in FAST TRACK */
DEFINE SHARED VARIABLE s_objname  AS CHARACTER.
DEFINE SHARED VARIABLE s_objtype  AS CHARACTER.
DEFINE SHARED VARIABLE s_status   AS INTEGER.
DEFINE SHARED VARIABLE s_errmsg   AS CHARACTER.

DEFINE SHARED VARIABLE ftn        AS CHARACTER NO-UNDO.

DEFINE VARIABLE ans        AS LOGICAL            NO-UNDO.
DEFINE VARIABLE ff         AS LOGICAL            NO-UNDO.
DEFINE VARIABLE num_order  AS INTEGER            NO-UNDO. /* number of by */
DEFINE VARIABLE fld_width  AS INTEGER            NO-UNDO. /* Width of data  */
DEFINE VARIABLE fld_name   AS CHARACTER          NO-UNDO. /* NAme of field  */
DEFINE VARIABLE fld_var    AS LOG                NO-UNDO. /* Yes if variable */
DEFINE VARIABLE nam_order  AS CHARACTER EXTENT 5 NO-UNDO. /* Group-names */
DEFINE VARIABLE fld_dt     AS CHARACTER          NO-UNDO. /* Data-type      */
DEFINE VARIABLE max_lines  AS INTEGER   EXTENT 2 NO-UNDO. /* Lines in hdr/ftr */
DEFINE VARIABLE max_length AS INTEGER   EXTENT 6 NO-UNDO. /* Len of hdr/ftr */

DEFINE SHARED VARIABLE label_row AS INTEGER NO-UNDO. /* Row for labels */
DEFINE SHARED VARIABLE data_row  AS INTEGER NO-UNDO. /* Row for data */

DEFINE SHARED VARIABLE agg_row AS INTEGER EXTENT 6 NO-UNDO. /* Row for agg */
DEFINE        VARIABLE num_agg AS INTEGER EXTENT 6 NO-UNDO. /* Num of agg/brk */

/* Row for hdr/footer */
DEFINE SHARED VARIABLE hf_row   AS INTEGER EXTENT 2  NO-UNDO.
/* Shows if agg is displ on breaks */
DEFINE SHARED VARIABLE agg_disp AS INTEGER EXTENT 30 NO-UNDO.

DEFINE VARIABLE c  AS CHARACTER NO-UNDO.
DEFINE VARIABLE d  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i  AS INTEGER   NO-UNDO.
DEFINE VARIABLE j  AS INTEGER   NO-UNDO.
DEFINE VARIABLE k  AS INTEGER   NO-UNDO.
DEFINE VARIABLE l  AS INTEGER   NO-UNDO.
DEFINE VARIABLE ll AS INTEGER   NO-UNDO.
DEFINE VARIABLE m  AS INTEGER   NO-UNDO.
DEFINE VARIABLE n  AS INTEGER   NO-UNDO.
DEFINE VARIABLE o  AS INTEGER   NO-UNDO.

FIND _report WHERE _name = ftn EXCLUSIVE-LOCK NO-ERROR.

/* _fdef  _ragg */

STATUS DEFAULT qbf-lang[5]. /*Creating fields and aggregates...*/

k = qbf-r-attr[1].
DO i = 1 TO qbf-rc#:
  IF qbf-rcc[i] = "c" AND ENTRY(2,qbf-rcn[i]) <> ENTRY(3,qbf-rcn[i]) THEN DO:
    BELL.
    ASSIGN
      c = qbf-lang[22] /*Warning: Starting number {1} used for counter.*/
      SUBSTRING(c,INDEX(c,"~{1~}"),3) = ENTRY(3,qbf-rcn[i]).
    MESSAGE c.
    PAUSE.
    HIDE MESSAGE.
  END.
  IF qbf-rcc[i] = "p" THEN DO:
    BELL.
    MESSAGE qbf-lang[14].
    /*FAST TRACK does not support percent of total, field skipped.*/
    PAUSE.
    HIDE MESSAGE.
    NEXT.
  END.

  /* Calculate data-width */
  CREATE _fdef.
  ASSIGN
    fld_name  = ENTRY(1,qbf-rcn[i])
    fld_dt    = ENTRY(qbf-rct[i],qbf-dtype)
    fld_var   = qbf-rcc[i] <> ""
    fld_width = (IF fld_dt = "character" THEN
                  LENGTH(STRING("A",qbf-rcf[i]))
                ELSE IF CAN-DO("integer,decimal,rowid",fld_dt) THEN
                  LENGTH(STRING(1,qbf-rcf[i]))
                ELSE IF fld_dt = "date" THEN
                  LENGTH(STRING(DATE(10,10,1980),qbf-rcf[i]))
                ELSE IF fld_dt = "logical" THEN
                  LENGTH(STRING(TRUE,qbf-rcf[i]))
                ELSE
                  qbf-rcw[i])
    j         = INDEX(fld_name,".")
    l         = R-INDEX(fld_name,".")
    _fdef._name     = "R_" + ftn
    _fdef._type     = "F"
    _fdef._begcol   = (IF CAN-DO("character,logical",fld_dt) THEN k
                      ELSE k + qbf-rcw[i] - fld_width)
    _fdef._endcol   = _fdef._begcol + fld_width - 1
    _fdef._row      = data_row
    _fdef._dbnam    = (IF fld_var THEN "ftdb" ELSE SUBSTRING(fld_name,1,j - 1))
    _fdef._filnam   = (IF fld_var THEN "_var" ELSE
                      SUBSTRING(fld_name,j + 1,l - j - 1))
    _fdef._fldnam   = SUBSTRING(fld_name,l + 1)
    _fdef._ftlabel  = ""
    _fdef._ftformat = qbf-rcf[i]
    _fdef._bindrec  = 2 * i - 1
    _fdef._changed[1] = fld_var
    _fdef._changed[2] = TRUE.
  CREATE _fdef.
  ASSIGN
    _fdef._name     = "R_" + ftn
    _fdef._type     = "L"
    _fdef._begcol   = k
    _fdef._endcol   = k + qbf-rcw[i] - 1
    _fdef._row      = label_row
    _fdef._dbnam    = (IF fld_var THEN "ftdb" ELSE SUBSTRING(fld_name,1,j - 1))
    _fdef._filnam   = (IF fld_var THEN "_var" ELSE
                      SUBSTRING(fld_name,j + 1,l - j - 1))
    _fdef._fldnam   = SUBSTRING(fld_name,l + 1)
    _fdef._ftlabel  = qbf-rcl[i]
    _fdef._ftformat = ""
    _fdef._bindrec  = 2 * i
    _fdef._changed[1] = TRUE
    _fdef._changed[2] = fld_var.
  CREATE _fdef.
  ASSIGN
    _fdef._name     = "R_" + ftn
    _fdef._type     = "L"
    _fdef._begcol   = k
    _fdef._endcol   = k + qbf-rcw[i] - 1
    _fdef._row      = label_row + 1
    _fdef._dbnam    = ""
    _fdef._filnam   = ""
    _fdef._fldnam   = ""
    _fdef._ftlabel  = FILL("-",qbf-rcw[i])
    _fdef._ftformat = ""
    _fdef._bindrec  = 0
    _fdef._changed[1] = TRUE.
  /* Create _repexp for variables */
  IF fld_var THEN DO:
    CREATE _repexp.
    ASSIGN
      n                 = n + 1
      _repexp._name     = ftn
      _repexp._fldnam   = fld_name
      _repexp._secnam   = "Main"
      _repexp._ftlabel  = qbf-rcl[i]
      _repexp._ftformat = qbf-rcf[i]
      _repexp._datatype = fld_dt
      _repexp._ftorder  = n
      _repexp._exp[1]   = (IF qbf-rcc[i] = "r" THEN
                            fld_name + " + " + ENTRY(2,qbf-rcn[i])
                          ELSE IF qbf-rcc[i] = "c" THEN
                            fld_name + " + " + ENTRY(3,qbf-rcn[i])
                          ELSE
                            SUBSTRING(qbf-rcn[i],INDEX(qbf-rcn[i],",") + 1)
                          ).
    /* Split to 2 lines if longer than 70 */
    IF LENGTH(_repexp._exp[1]) > 70 THEN
      ASSIGN
        m               = R-INDEX(SUBSTRING(_repexp._exp[1],1,70)," ")
        _repexp._exp[2] = SUBSTRING(_repexp._exp[1],m + 1)
        _repexp._exp[1] = SUBSTRING(_repexp._exp[1],1,m).
  END.

  /* _ragg */
  IF qbf-rca[i] > "" THEN DO:
    ff = TRUE.
    DO ll = 1 TO 59 BY 2:
      ASSIGN
        c = SUBSTRING(qbf-rca[i],ll,1)
        m = INTEGER(SUBSTRING(qbf-rca[i],ll + 1,1)).
      IF m = 0 THEN LEAVE.
      CREATE _ragg.
      ASSIGN
        _ragg._name   = ftn
        _ragg._secnam = "Main"
        _ragg._func   = ENTRY(INDEX("tcxna",c),"TOTAL,COUNT,MAX,MIN,AVERAGE")
        _ragg._dbnam  = SUBSTRING(fld_name,1,j - 1)
        _ragg._filnam = SUBSTRING(fld_name,j + 1,l - j - 1)
        _ragg._fldnam = SUBSTRING(fld_name,l + 1).
      IF m < 6 THEN DO:
        FIND FIRST _rgroup
          WHERE _rgroup._name    = ftn
            AND _rgroup._secnam  = "Main"
            AND _rgroup._groupid = m.
        ASSIGN
          _ragg._bydbnam  = _rgroup._dbnam
          _ragg._byfilnam = _rgroup._filnam
          _ragg._byfldnam = _rgroup._fldnam.
      END.    /* m < 6 */
      /* Create _fdef for aggregate */
      CREATE _fdef.
      ASSIGN
        _fdef._name     = "R_" + ftn
        _fdef._type     = "A"
        _fdef._begcol   = (IF CAN-DO("character,logical",fld_dt) THEN k
                          ELSE k + qbf-rcw[i] - fld_width)
        _fdef._endcol   = _fdef._begcol + fld_width - 1
        _fdef._row      = agg_row[m] + qbf-r-attr[4]
                        * (agg_disp[(m - 1) * 5 + INDEX("tcxna",c)] - 1) + 1
        _fdef._dbnam    = SUBSTRING(fld_name,1,j - 1)
        _fdef._filnam   = SUBSTRING(fld_name,j + 1,l - j - 1)
        _fdef._fldnam   = SUBSTRING(fld_name,l + 1)
        _fdef._ftlabel  = ""
        _fdef._ftformat = qbf-rcf[i]
        _fdef._bindrec  = 0
        _fdef._funct    = ENTRY(INDEX("tcxna",c),"TOTAL,COUNT,MAX,MIN,AVERAGE")
        _fdef._changed[1] = TRUE
        _fdef._changed[2] = TRUE.

      IF m < 6 THEN
        _fdef._functby = _rgroup._dbnam + "." + _rgroup._filnam
                       + "." + _rgroup._fldnam.
      o = k + (IF CAN-DO("character,logical",fld_dt)
          THEN 0 ELSE qbf-rcw[i] - fld_width).
      FIND FIRST _fdef
        WHERE _fdef._name   = "R_" + ftn
          AND _fdef._type   = "L"
          AND _fdef._begcol = o
          AND _fdef._row    = agg_row[m] NO-ERROR.

      IF NOT AVAILABLE _fdef THEN DO:
        CREATE _fdef.
        ASSIGN
          _fdef._name       = "R_" + ftn
          _fdef._type       = "L"
          _fdef._begcol     = o
          _fdef._endcol     = _fdef._begcol + fld_width - 1
          _fdef._row        = agg_row[m]
          _fdef._ftlabel    = FILL("-",fld_width)
          _fdef._changed[1] = TRUE.
      END.
    END.    /* All attributes for 1 field */
  END.   /* Not * in attr-list */
  k = k + qbf-rcw[i] + qbf-r-attr[3].
END.    /* All fields */
ASSIGN
  k              = k - qbf-r-attr[3]
  _report._width = (IF ff THEN IF k < 76 THEN 80 ELSE IF k <= 80 THEN 80
                   ELSE 132 ELSE 132)
  ll             = k.

/* Create agg-labels (MAX MIN etc) */
IF ff THEN
  DO i = 1 TO 6: /* 1 / break-group */
    DO j = 1 TO 5: /* 1=total .... */
      IF agg_disp[(i - 1) * 5 + j] = 0 THEN NEXT.
      CREATE _fdef.
      ASSIGN
        _fdef._name       = "R_" + ftn
        _fdef._type       = "L"
        _fdef._begcol     = k + 1
        _fdef._endcol     = k + 6
        _fdef._row        = agg_row[i] + (agg_disp[(i - 1) * 5 + j] - 1)
                          * qbf-r-attr[4] + 1
        _fdef._ftlabel    = ENTRY(j,"TOTAL,COUNT,MAX,MIN,AVG")
        _fdef._changed[1] = TRUE.
    END.
  END.

/* Create fdefs for hdr/footers */
STATUS DEFAULT qbf-lang[7]. /*Creating headers and footers...*/

IF   qbf-r-head[1] <> "" OR qbf-r-head[2] <> "" OR qbf-r-head[3] <> ""
  OR qbf-r-head[4] <> "" OR qbf-r-head[5] <> "" OR qbf-r-head[6] <> "" THEN DO:
  BELL.
  /*FAST TRACK does not support first-only/last-only headers.  Ignored. */
  MESSAGE qbf-lang[21].
  PAUSE.
  HIDE MESSAGE.
END.

DO i = 1 TO 2:  /* 1 = header, 2 = footer */
  DO j = 1 TO 3:  /* 1 = left  2 = center  3 = right */
    DO k = 1 TO 3: /* 1 = row 1  2 = row 2  3 = row 3 */
      c = qbf-r-head[6 + (i - 1) * 9 + (j - 1) * 3 + k].
      IF c = "" THEN NEXT.
      n = (IF j = 1 THEN 1 ELSE
          IF  j = 2 THEN MAXIMUM(1,(ll - max_length[(i - 1) * 3 + j]) / 2)
                    ELSE MAXIMUM(1,(ll - max_length[(i - 1) * 3 + j]))).
      DO WHILE TRUE:
        IF c = "" THEN LEAVE.
        ASSIGN
          l = INDEX(c,qbf-left)
          m = INDEX(c,qbf-right)
          d = "".
        IF l = 0 THEN DO:
          CREATE _fdef.
          ASSIGN
            _fdef._name       = "R_" + ftn
            _fdef._type       = "L"
            _fdef._begcol     = n
            _fdef._endcol     = _fdef._begcol + LENGTH(c)
            _fdef._row        = hf_row[i] + k - 1
            _fdef._ftlabel    = c
            _fdef._changed[1] = TRUE.
          LEAVE.
        END.
        IF l > 0 AND m > 0 AND l < m THEN DO:
          d = SUBSTRING(c,l + 1,m - l - 1).
          IF NOT CAN-DO("TODAY,PAGE,TIME,NOW,USER,VALUE *",d) THEN DO:
            ASSIGN
              d = qbf-lang[15]
              SUBSTRING(d,INDEX(d,"~{1~}"),3) = SUBSTRING(c,l + 1,m - l - 1)
              SUBSTRING(d,INDEX(d,"~{2~}"),3) = SUBSTRING(c,l + 1,m - l - 1).
            BELL.
            /*FAST TRACK does not support {1} in header/footer, {2} skipped.*/
            MESSAGE d.
            PAUSE.
            HIDE MESSAGE.
            SUBSTRING(c,l,m - l + 1) = "".
            NEXT.
          END.
          IF d = "TIME" THEN DO:
            BELL.
            MESSAGE qbf-lang[13].
        /*FAST TRACK does not support TIME in header/footer, replaced by NOW.*/
            PAUSE.
            HIDE MESSAGE.
            d = "NOW".
          END.
          CREATE _fdef.
          ASSIGN
            _fdef._name     = "R_" + ftn
            _fdef._type     = "p"
            _fdef._begcol   = n + l - 1
            _fdef._ftformat = (IF d = "TODAY" THEN "99/99/99"
                          ELSE IF d = "NOW"   THEN "HH:MM:SS"
                          ELSE IF d = "USER"  THEN "xxxxxxxx"
                          ELSE IF d = "PAGE"  THEN ">>9"
                          ELSE IF d = "VALUE" THEN SUBSTRING(d,INDEX(d,";") + 1)
                          ELSE "")
            _fdef._endcol   = _fdef._begcol + LENGTH(_fdef._ftformat) - 1
            _fdef._row      = hf_row[i] + k - 1
            _fdef._ftlabel  = ""
            _fdef._funct    = (IF d = "TODAY" THEN "TODAY"
                          ELSE IF d = "NOW"   THEN "TIME"
                          ELSE IF d = "USER"  THEN 'USERID("FTDB")'
                          ELSE IF d = "PAGE"  THEN "PAGE-NUMBER"
                          ELSE IF d = "VALUE" THEN
                               SUBSTRING(d,7,INDEX(d,";") - 7)
                          ELSE "")
            _fdef._datatype   = (IF d = "PAGE" THEN "INTEGER" ELSE "CHARACTER")
            _fdef._changed[1] = TRUE
            _fdef._changed[2] = TRUE.

          IF SUBSTRING(c,1,l - 1) <> "" THEN DO:
            CREATE _fdef.
            ASSIGN
              _fdef._name     = "R_" + ftn
              _fdef._type     = "L"
              _fdef._begcol   = n
              _fdef._endcol   = _fdef._begcol + LENGTH(SUBSTRING(c,1,l - 1)) - 1
              _fdef._row      = hf_row[i] + k - 1
              _fdef._ftlabel  = SUBSTRING(c,1,l - 1)
              _fdef._changed[1] = TRUE.
          END.
          ASSIGN
            n = n + l + (IF d = "PAGE" THEN 3 ELSE 8) - 1
            c = SUBSTRING(c,m + 1).
        END.
        ELSE DO:
          BELL.
          MESSAGE qbf-lang[20].
          /*Unmatched curly braces in header/footer, report NOT transferred.*/
          PAUSE.
          HIDE MESSAGE.
          RETURN.
        END.
      END.
    END.
  END.
END.

STATUS DEFAULT.

&endif

RETURN.

/* r-ftsub.p - end of file */
