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
/* r-ft.p - FAST TRACK report link (part 1 of 2) */

&if 0 &then

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i } /* assumes language set swapped in already */

/* Variables used to validate report-name in FAST TRACK */
DEFINE NEW SHARED VARIABLE s_objname AS CHARACTER.
DEFINE NEW SHARED VARIABLE s_objtype AS CHARACTER.
DEFINE NEW SHARED VARIABLE s_status  AS INTEGER.
DEFINE NEW SHARED VARIABLE s_errmsg  AS CHARACTER.
DEFINE NEW SHARED VARIABLE ftn       AS CHARACTER NO-UNDO.

DEFINE VARIABLE ans        AS LOGICAL            NO-UNDO.
DEFINE VARIABLE ff         AS LOGICAL            NO-UNDO.
DEFINE VARIABLE num_order  AS INTEGER            NO-UNDO. /* Number of by */
DEFINE VARIABLE fld_width  AS INTEGER            NO-UNDO. /* Width of data */
DEFINE VARIABLE fld_name   AS CHARACTER          NO-UNDO. /* Name of field */
DEFINE VARIABLE fld_var    AS LOGICAL            NO-UNDO. /* Yes if variable */
DEFINE VARIABLE nam_order  AS CHARACTER EXTENT 5 NO-UNDO. /* Group-names */
DEFINE VARIABLE where_copy AS CHARACTER EXTENT 5 NO-UNDO. /* qbf-where copy */
DEFINE VARIABLE fld_dt     AS CHARACTER          NO-UNDO. /* Data-type */
DEFINE VARIABLE max_lines  AS INTEGER   EXTENT 2 NO-UNDO. /* Lines in hdr/ftr */
DEFINE VARIABLE max_length AS INTEGER   EXTENT 6 NO-UNDO. /* Lngth of hdr/ftr */

DEFINE NEW SHARED VARIABLE label_row  AS INTEGER NO-UNDO. /* Row for labels */
DEFINE NEW SHARED VARIABLE data_row   AS INTEGER NO-UNDO. /* Row for data */
/* Row for aggregate, Number of agg/break */
DEFINE NEW SHARED VARIABLE agg_row   AS INTEGER EXTENT 6 NO-UNDO.
DEFINE            VARIABLE num_agg   AS INTEGER EXTENT 6 NO-UNDO.
/* Row for hdr/footer, Shows if agg is displ on breaks */
DEFINE NEW SHARED VARIABLE hf_row    AS INTEGER EXTENT 2  NO-UNDO.
DEFINE NEW SHARED VARIABLE agg_disp  AS INTEGER EXTENT 30 NO-UNDO.

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

c = "".
IF qbf-r-attr[8] = 1               THEN c = "#25".
IF qbf-file[1] = "" OR qbf-rc# = 0 THEN c = "#26".
IF c <> "" THEN DO:
  /* 25: FAST TRACK does not support Totals Only reports. */
  /*     Report could not be transferred.                 */
  /* 26: Cannot transfer a report to FAST TRACK when no   */
  /*     files or fields defined.                         */
  RUN prores/s-error.p (c).
  RETURN.
END.

ftn = SUBSTRING(qbf-name,1,7).

name_editing:
DO WHILE TRUE:
  FORM
    ftn FORMAT "x(7)"
    HEADER
    qbf-lang[17] FORMAT "x(64)" /*"Report name in FAST TRACK:"*/
    WITH NO-LABELS CENTERED ROW 10 OVERLAY FRAME a.
  UPDATE ftn
    VALIDATE(ftn <> "" AND ftn <> ?,qbf-lang[12]) /*"Enter a name"*/
    WITH FRAME a.

  /*
  IF LENGTH(ftn) > 7 THEN DO:
    ftn = SUBSTRING(ftn,1,7).
    MESSAGE qbf-lang[21] ftn.
    /*"Warning: Name of report in FAST TRACK truncated to"*/
    HIDE MESSAGE.
  END.
  */

  DO i = 1 TO LENGTH(ftn):
    c = SUBSTRING(ftn,i,1).
    IF INDEX('abcdefghijklmnopqrstuvwxyz0123456789_',c) = 0 THEN DO:
      BELL.
      MESSAGE qbf-lang[16].
      /*Report name can only include alphanumeric characters or under-score.*/
      NEXT name_editing.
    END.
  END.
  ASSIGN
    s_objtype = "Report"
    s_objname = ftn.
  RUN ft/agvalnam.p.
  IF s_status <> 0 AND s_status <> 2 THEN DO:
    BELL.
    MESSAGE s_errmsg.
    NEXT name_editing.
  END.
  LEAVE name_editing.
END.
FIND _report WHERE _name = ftn EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE _report THEN DO:
  /* There is already a report named {1} in    */
  /* FAST TRACK.  Do you want to overwrite it? */
  ASSIGN
    c = qbf-lang[9]
    SUBSTRING(c,INDEX(c,"~{1~}"),3) = ftn.
  RUN prores/s-box.p (INPUT-OUTPUT ans,?,?,c).
  IF NOT ans THEN DO:
    MESSAGE qbf-lang[18]. /*Report not transferred to FAST TRACK*/
    PAUSE.
    RETURN.
  END.
  ELSE DO:
    STATUS DEFAULT qbf-lang[10]. /*Overwriting report...*/
    FOR EACH _rlevel OF _report:
      DELETE _rlevel.
    END.
    FOR EACH _ragg   OF _report:
      DELETE _ragg.
    END.
    FOR EACH _repexp OF _report:
      DELETE _repexp.
    END.
    FOR EACH _rgroup OF _report:
      DELETE _rgroup.
    END.
    FOR EACH _row    OF _report:
      DELETE _row.
    END.
    FOR EACH _rqual  OF _report:
      DELETE _rqual.
    END.
    FOR EACH _fdef WHERE _fdef._name = 'R_' + ftn:
      DELETE _fdef.
    END.
    FIND _prog WHERE _prog._type = 'r' AND _prog._name = ftn NO-ERROR.
    IF AVAILABLE _prog THEN DELETE _prog.
    DELETE _report.
  END.
END.
CREATE _report.
ASSIGN
  _report._name   = ftn
  _report._type   = "Display-All"
  _report._totsec = 1
  _report._length = 66
  _report._pagsiz = 0
  _report._outdev = "Terminal"
  _report._canrun = "*".

STATUS DEFAULT qbf-lang[4]. /*Creating break-groups...*/
/* Order-fields, load qbf-order into _rgroup.  */
num_order = 0.
DO i = 1 TO 5 WHILE qbf-order[i] <> "":
  CREATE _rgroup.
  ASSIGN
    num_order         = num_order + 1
    j                 = INDEX(qbf-order[i],".")
    l                 = R-INDEX(qbf-order[i],".")
    k                 = INDEX(qbf-order[i] + " "," DESC ")
    _rgroup._name     = ftn
    _rgroup._secnam   = "Main"
    _rgroup._dbnam    = SUBSTRING(qbf-order[i],1,j - 1)
    _rgroup._filnam   = SUBSTRING(qbf-order[i],j + 1,l - j - 1)
    c                 = SUBSTRING(qbf-order[i],l + 1)
    _rgroup._fldnam   = SUBSTRING(c,1,INDEX(c + " "," ") - 1)
    _rgroup._brksort  = TRUE
    _rgroup._updown   = (k = 0)
    _rgroup._groupid  = i
    _rgroup._grpnam   = SUBSTRING(_rgroup._fldnam,1,3)
    _rgroup._grpnam   = SUBSTRING(_rgroup._grpnam,1,
                        INDEX(_rgroup._grpnam + " "," ") - 1) + STRING(i)
    nam_order[i]      = _rgroup._grpnam
    _rgroup._grptitle = _rgroup._filnam.
END.


/* Files etc, load qbf-file into _rlevel */

STATUS DEFAULT qbf-lang[6]. /*Creating files and where-clauses...*/
CREATE _rlevel.

ASSIGN
  _rlevel._name     = ftn
  _rlevel._secnam   = "Main"
  _rlevel._ftorder  = 1
  _rlevel._hasgrp   = num_order
  _rlevel._Sectitle = "Main".

/* Deal with ASK-option */
DO i = 1 TO 5.
  where_copy[i] = qbf-where[i].
END.

i = 0.
OUTPUT TO VALUE(ftn + ".ask") NO-MAP.
DO m = 1 TO 5:
  IF where_copy[m] = "" THEN NEXT.
  DO WHILE TRUE:
   j = INDEX(where_copy[m],"~{").
   IF j = 0 THEN LEAVE.
   ASSIGN
     k                 = INDEX(where_copy[m],"~}")
     i                 = i + 1
     c                 = SUBSTRING(where_copy[m],j + 2,k - j - 2)
     _rlevel._misc1[1] = _rlevel._misc1[1] + ENTRY(1,c) + ","
     _rlevel._misc1[1] = _rlevel._misc1[1] + ENTRY(2,c) + ","
     _rlevel._misc1[1] = _rlevel._misc1[1]
                       + ENTRY(3,SUBSTRING(c,1,INDEX(c,":") - 1)) + ","
     d                 = SUBSTRING(c,INDEX(c,":") + 1)
     l                 = INDEX(d,",").
     DO WHILE l > 0:
       ASSIGN
         SUBSTRING(d,l,1) = ""
         l                = INDEX(d,",").
     END.
     ASSIGN
       _rlevel._misc1[1] = _rlevel._misc1[1] + d + ","
       SUBSTRING(where_copy[m],j,k - j + 2)
         = (IF ENTRY(3,c) BEGINS qbf-lang[23] /*CONTAINS*/ THEN
             ' "*" + ask' + STRING(i) + ' + "*"'
           ELSE
             "ask" + STRING(i)).
    PUT UNFORMATTED SKIP
      "DEFINE VARIABLE ask" STRING(i) " AS " ENTRY(1,c).
    IF ENTRY(1,c) = "Character" THEN PUT UNFORMATTED ' FORMAT "x(32)"'.
    PUT UNFORMATTED " .".
  END.
END.

IF i > 0 THEN DO:
  _rlevel._include[1] = ftn + ".ask".
  DO j = i + 1 TO 5.
    PUT UNFORMATTED SKIP
      "DEFINE VARIABLE ask" STRING(j) " AS CHARACTER.".
  END.
  PUT UNFORMATTED SKIP
    'FIND FIRST _report WHERE _report._name = "' ftn '" .' SKIP
    'FIND FIRST _rlevel WHERE _rlevel._name = "' ftn '" AND _secnam = "Main" .'
    SKIP
    '~{ prores/r-ftask.i ~}'.

  IF _report._outdev = "TERMINAL" THEN DO:
    BELL.
    MESSAGE '/*' qbf-lang[1].
    MESSAGE qbf-lang[2] '*/'.
    /*  "/* FAST TRACK does not support output to terminal when       */
    /*  prompting for selection data. Output changed to PRINTER. */"  */
    PAUSE.
    HIDE MESSAGE.
    _report._outdev = "PRINTER".
  END.
END.
OUTPUT CLOSE.
/* Remove .ask file if no ask-options was used */
IF i = 0 THEN 
  RUN prores/a-zap.p (ftn + ".ask").

c = "FOR ".
DO i = 1 TO 5 WHILE qbf-file[i] <> "":
  ASSIGN
    _rlevel._rdb  [i] = qbf-db[i]
    _rlevel._rfile[i] = qbf-file[i].
  IF qbf-of[i] BEGINS "OF " THEN
    ASSIGN
      _rlevel._ofdb[i]   = qbf-db[i]
      _rlevel._offile[i] = SUBSTRING(qbf-of[i],4).

  /* Where clause */
  ASSIGN
    d = " " + (IF where_copy[i] = ""   THEN qbf-of[i]
        ELSE IF qbf-of[i] = ""        THEN "WHERE " + where_copy[i]
        ELSE IF qbf-of[i] BEGINS "OF" THEN
             qbf-of[i] + " WHERE " + where_copy[i]
        ELSE "(" + qbf-of[i] + ") AND (" + where_copy[i] + ")")
    d = c + "EACH " + qbf-db[i] + "." + qbf-file[i] + d + " NO-LOCK".
  IF i < 5 AND qbf-file[i + 1] <> "" THEN d = d + ", ".
  _rlevel._recphr = _rlevel._recphr + d.
  /* _rqual */

  ASSIGN
    d = "("
      + (IF qbf-of[i] BEGINS "WHERE" THEN SUBSTRING(qbf-of[i],7) ELSE "")
      + (IF qbf-of[i] BEGINS "WHERE" AND
        where_copy[i] <> "" THEN ") AND (" ELSE "")
      + where_copy[i]
      + ")"
    l = 0.

    DO WHILE d <> "":
      CREATE _rqual.
      ASSIGN
        d               = d + " "
        l               = l + 1
        _rqual._name    = ftn
        _rqual._secnam  = "Main"
        _rqual._ftorder = l
        _rqual._dbnam   = qbf-db[i]
        _rqual._filnam  = qbf-file[i]
        _rqual._filsel  = qbf-file[i]
        j               = INDEX(d," AND ")
        k               = INDEX(d," OR ")
        m               = LENGTH(d)
        c               = d.
      IF j > 0 AND (k = 0 OR j < k) THEN
        ASSIGN
          c             = SUBSTRING(d,1,j - 1)
          d             = SUBSTRING(d,j + 5)
          _rqual._andor = "AND".
      IF k > 0 AND (j = 0 OR k < j) THEN
        ASSIGN
          c             = SUBSTRING(d,1,k - 1)
          d             = SUBSTRING(d,k + 4)
          _rqual._andor = "OR".
      IF j = 0 AND k = 0 THEN d = "".
      IF c = "" THEN NEXT.
      DO WHILE SUBSTRING(c,1,1) = " ".
        SUBSTRING(c,1,1) = "".
      END.
      j = INDEX(c,"(").
      IF j > 0 THEN
        ASSIGN
          _rqual._lparen   = "("
          SUBSTRING(c,j,1) = "".
      j = INDEX(c,")").
      IF j > 0 THEN
        ASSIGN
          _rqual._rparen   = ")"
          SUBSTRING(c,j,1) = "".
      ASSIGN
        j                = INDEX(c + " ", " ")
        k                = INDEX(c + " ", ".")
        _rqual._fldnam   = SUBSTRING(c,k + 1,j - k - 1)
        SUBSTRING(c,1,j) = ""
        j                = INDEX(c + " "," ")
        _rqual._op       = SUBSTRING(c,1,j - 1)
        SUBSTRING(c,1,j) = ""
        _rqual._operand  = c.
    END.
    ASSIGN
      c = ""
      d = "".
END.
_rlevel._recphr = _rlevel._recphr + ".".

/* Calculate number of header-footer-lines + max-length */
STATUS DEFAULT qbf-lang[3]. /*Analyzing headers and footers...*/

DO i = 1 TO 2:   /* 1 = header  2 = footer */
  DO j = 1 TO 3: /* 1 = Left  2 = Center  3 = Right */
    ASSIGN
      l = 0
      m = 0.
    DO k = 1 TO 3: /* 1 = Line 1  2 = Line 2  3 = Line 3  */
      IF qbf-r-head[6 + (i - 1) * 9 + (j - 1) * 3 + k] = "" THEN NEXT.
      ASSIGN
        l = l + 1
        m = LENGTH(qbf-r-head[6 + (i - 1) * 9 + (j - 1) * 3 + k])
        max_length[(i - 1) * 3 + j] =
          MAXIMUM(max_length[(i - 1) * 3 + j],m).
    END.
    max_lines[i] = MAXIMUM(max_lines[i],l).
  END.
END.
/*
message max_lines[1] max_lines[2]. pause.
message max_length[1] max_length[2] max_length[3]. pause.
message max_length[4] max_length[5] max_length[6]. pause.
*/
/* Check how many aggregates are used on each order-level */

DO i = 1 TO qbf-rc#:
  IF qbf-rca[i] > "" THEN DO:
    DO j = 1 TO 59 BY 2:
      ASSIGN
        c = SUBSTRING(qbf-rca[i],j,1)
        k = INTEGER(SUBSTRING(qbf-rca[i],j + 1,1)).
      IF k = 0 THEN LEAVE.
      agg_disp[(k - 1) * 5 + LOOKUP(c,"t,c,x,n,a")] = 1.
    END.
  END.
END.
/*
disp agg_disp with no-labels. pause. return.
*/
/* Make agg_disp more helpful */
DO i = 1 TO 6:
  k = 0.
  DO j = 1 TO 5.
    IF agg_disp[(i - 1) * 5 + j] = 1 THEN
      ASSIGN
        k                         = k + 1
        agg_disp[(i - 1) * 5 + j] = k.
  END.
  num_agg[i] = k.
END.


/* Create rows */
STATUS DEFAULT qbf-lang[8]. /*Creating report-rows...*/
j = 0.

/* Report header */
CREATE _row.
ASSIGN
  j            = j + 1
  _row._name   = ftn
  _row._secnam = ""
  _row._row    = j
  _row._type   = "RH".

/* Start row */
DO i = 1 TO qbf-r-attr[5] - 1:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = ""
    _row._row    = j
    _row._type   = "PH".
END.

/* Page-header */
hf_row[1] = j + 1.
DO i = 1 TO MAXIMUM(max_lines[1],1):
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = ""
    _row._row    = j
    _row._type   = "PH".
END.

/* Lines between header and body */
DO i = 1 TO qbf-r-attr[6]:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = ""
    _row._row    = j
    _row._type   = "PH".
END.

/* Data headers (label and ____) */
label_row = j + 1.
DO i = 1 TO 2:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = "Main"
    _row._row    = j
    _row._type   = "DH".
END.

/* Break Group Header  */
DO i = 1 TO num_order:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = "Main"
    _row._row    = j
    _row._type   = "GH"
    _row._grpnam = nam_order[i].
END.

/* Data section */
data_row = j + 1.
DO i = 1 TO qbf-r-attr[4]:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = "Main"
    _row._row    = j
    _row._type   = "DD".
END.

/* Break Group Summary */
DO i = num_order TO 1 BY -1.
  CREATE _row.
  ASSIGN
    agg_row[i]   = j + 1
    j            = j + 1
    _row._name   = ftn
    _row._secnam = "Main"
    _row._row    = j
    _row._type   = "GS"
    _row._grpnam = nam_order[i].
  DO k = 1 TO num_agg[i] * qbf-r-attr[4]:
    CREATE _row.
    ASSIGN
      j            = j + 1
      _row._name   = ftn
      _row._secnam = "Main"
      _row._row    = j
      _row._type   = "GS"
      _row._grpnam = nam_order[i].
  END.
END.

/* Data Summary */
CREATE _row.
ASSIGN
  agg_row[6]   = j + 1
  j            = j + 1
  _row._name   = ftn
  _row._secnam = "Main"
  _row._row    = j
  _row._type   = "DS".
DO k = 1 TO num_agg[6] * qbf-r-attr[4]:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = "Main"
    _row._row    = j
    _row._type   = "DS".
END.

/* Lines between body and footer */
DO i = 1 TO qbf-r-attr[7]:
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = ""
    _row._row    = j
    _row._type   = "PF".
END.

/* Page -footer */
hf_row[2] = j + 1.
DO i = 1 TO MAXIMUM(1,max_lines[2]):
  CREATE _row.
  ASSIGN
    j            = j + 1
    _row._name   = ftn
    _row._secnam = ""
    _row._row    = j
    _row._type   = "PF".
END.

/* Report summary */
CREATE _row.
ASSIGN
  j            = j + 1
  _row._name   = ftn
  _row._secnam = ""
  _row._row    = j
  _row._type   = "RS".

/*
message qbf-rc# qbf-rcn[1] qbf-rcl[1] qbf-rcf[1] qbf-rcw[1] . pause.
*/
RUN prores/r-ftsub.p.  /* Split because of r-code-size */

ans = FALSE.
RUN prores/s-box.p (INPUT-OUTPUT ans,?,?,"#11").
  /*Do you want to start FAST TRACK?*/
IF ans THEN DO:
  DISPLAY qbf-lang[19] FORMAT "x(64)" WITH ROW 18 CENTERED FRAME ft NO-LABELS.
  /*"Starting FAST TRACK, please wait..."*/
  RUN ft.p.
END.

&endif

RETURN.

/* r-ft.p - end of file */
