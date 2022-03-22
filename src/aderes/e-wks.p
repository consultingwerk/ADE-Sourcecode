/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */
 
/* e-wks.p - output for Lotus 1-2-3 & Symphony */
 
/* dma 12-2-93 */
{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
 
/* dma 12-2-93 */
DEFINE INPUT PARAMETER qbf-s AS CHARACTER NO-UNDO. /* p>rolog, b>ody, e>pilog */
DEFINE INPUT PARAMETER qbf-n AS CHARACTER NO-UNDO. /* field name */
DEFINE INPUT PARAMETER qbf-l AS CHARACTER NO-UNDO. /* field label */
DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* field format */
DEFINE INPUT PARAMETER qbf-p AS INTEGER   NO-UNDO. /* field position */
DEFINE INPUT PARAMETER qbf-t AS INTEGER   NO-UNDO. /* field datatype */
DEFINE INPUT PARAMETER qbf-m AS CHARACTER NO-UNDO. /* left margin */
DEFINE INPUT PARAMETER qbf-b AS LOGICAL   NO-UNDO. /* is first field? */
DEFINE INPUT PARAMETER qbf-e AS LOGICAL   NO-UNDO. /* is last field? */
 
/* dma 12-2-93
message
"qbf-s" qbf-s skip
"qbf-n" qbf-n skip
"qbf-l" qbf-l skip
"qbf-f" qbf-f skip
"qbf-p" qbf-p skip
"qbf-t" qbf-t skip
"qbf-m" qbf-m skip
"qbf-b" qbf-b skip
"qbf-e" qbf-e
view-as alert-box.
 
/*
/* used: */
&GLOBAL-DEFINE s_bof        NULL(2)
 
/* unused: */
&GLOBAL-DEFINE s_eof        CHR(1) NULL
&GLOBAL-DEFINE s_calcmode   CHR(2) NULL
&GLOBAL-DEFINE s_calcorder  CHR(3) NULL
&GLOBAL-DEFINE s_split      CHR(4) NULL
&GLOBAL-DEFINE s_sync       CHR(5) NULL
&GLOBAL-DEFINE s_dimensions CHR(6) NULL
&GLOBAL-DEFINE s_window1    CHR(7) NULL
&GLOBAL-DEFINE s_colw1      CHR(8) NULL
&GLOBAL-DEFINE s_colw       CHR(8) NULL
&GLOBAL-DEFINE s_window2    CHR(9) NULL
&GLOBAL-DEFINE s_colw2      CHR(10) NULL
&GLOBAL-DEFINE s_nrange     CHR(11) NULL
&GLOBAL-DEFINE s_blank      CHR(12) NULL
&GLOBAL-DEFINE s_integer    CHR(13) NULL
&GLOBAL-DEFINE s_number     CHR(14) NULL
&GLOBAL-DEFINE s_label      CHR(15) NULL
&GLOBAL-DEFINE s_formula    CHR(16) NULL
&GLOBAL-DEFINE s_table      CHR(24) NULL
&GLOBAL-DEFINE s_qrange     CHR(25) NULL
&GLOBAL-DEFINE s_prange     CHR(26) NULL
&GLOBAL-DEFINE s_srange     CHR(27) NULL
&GLOBAL-DEFINE s_frange     CHR(28) NULL
&GLOBAL-DEFINE s_krange1    CHR(29) NULL
&GLOBAL-DEFINE s_drange     CHR(32) NULL
&GLOBAL-DEFINE s_krange2    CHR(35) NULL
&GLOBAL-DEFINE s_protect    CHR(36) NULL
&GLOBAL-DEFINE s_footer     CHR(37) NULL
&GLOBAL-DEFINE s_header     CHR(38) NULL
&GLOBAL-DEFINE s_setup      CHR(39) NULL
&GLOBAL-DEFINE s_margins    CHR(40) NULL
&GLOBAL-DEFINE s_labelfmt   CHR(41) NULL
&GLOBAL-DEFINE s_titles     CHR(42) NULL
&GLOBAL-DEFINE s_graph      CHR(45) NULL
&GLOBAL-DEFINE s_ngraph     CHR(46) NULL
&GLOBAL-DEFINE s_calccount  CHR(47) NULL
&GLOBAL-DEFINE s_format     CHR(48) NULL
&GLOBAL-DEFINE s_cursorw12  CHR(49) NULL
&GLOBAL-DEFINE s_window     CHR(50) NULL
&GLOBAL-DEFINE s_string     CHR(51) NULL
&GLOBAL-DEFINE s_lockpass   CHR(55) NULL
&GLOBAL-DEFINE s_locked     CHR(56) NULL
&GLOBAL-DEFINE s_qset       CHR(60) NULL
&GLOBAL-DEFINE s_cquery     CHR(61) NULL
&GLOBAL-DEFINE s_pset       CHR(62) NULL
&GLOBAL-DEFINE s_cprint     CHR(63) NULL
&GLOBAL-DEFINE s_sgraph     CHR(64) NULL
&GLOBAL-DEFINE s_cgraph     CHR(65) NULL
&GLOBAL-DEFINE s_zoom       CHR(66) NULL
&GLOBAL-DEFINE s_nsplit     CHR(67) NULL
&GLOBAL-DEFINE s_nsrows     CHR(68) NULL
&GLOBAL-DEFINE s_nscols     CHR(69) NULL
&GLOBAL-DEFINE s_ruler      CHR(70) NULL
&GLOBAL-DEFINE s_snrange    CHR(71) NULL
&GLOBAL-DEFINE s_acomm      CHR(72) NULL
&GLOBAL-DEFINE s_amacro     CHR(73) NULL
&GLOBAL-DEFINE s_qparse     CHR(74) NULL
&GLOBAL-DEFINE s_wkspass    CHR(75) NULL
&GLOBAL-DEFINE s_hidcol     CHR(100) NULL
&GLOBAL-DEFINE s_hidcol1    CHR(100) NULL
&GLOBAL-DEFINE s_hidcol2    CHR(101) NULL
&GLOBAL-DEFINE s_parse      CHR(102) NULL
&GLOBAL-DEFINE s_rranges    CHR(103) NULL
&GLOBAL-DEFINE s_mranges    CHR(105) NULL
&GLOBAL-DEFINE s_cpi        CHR(150) NULL
*/
 
FIND FIRST qbf-esys.
 
/* dma 12-2-93 */
CASE qbf-s:
  WHEN "p":u THEN
    RUN w_bof.
  WHEN "b":u AND qbf-t = 1 THEN /* character */
    RUN output_char ().
  WHEN "b":u AND qbf-t = 2 THEN /* date */
    RUN output_date.
  WHEN "b":u AND qbf-t = 3 THEN /* logical */
    RUN output_log ().
  WHEN "b":u AND qbf-t = 4 THEN /* integer */
    RUN output_int ().
  WHEN "b":u AND qbf-t = 5 THEN /* decimal */
    RUN output_dec ().
  WHEN "e":u THEN
    RUN w_eof.
END CASE.
 
RETURN.
 
/*--------------------------------------------------------------------------*/
/*
Record Type= BOF
Code=        0 [00h]
Body Length= 2 bytes
 
Usage=
  123/1
  123/1A
  123/2
  SYM/1.0
  SYM/1.1
 
Record Description=
  Beginning of file
 
Body Structure=
  Byte      Description
  0-1       File format revision number
            1028 [0404h]= 123/1, 123/1A
            1029 [0405h]= SYM/1.0
            1030 [0406h]= 123/2, SYM/1.1
*/
PROCEDURE w_bof:
  PUT CONTROL NULL(2) CHR(2) NULL.
  CASE qbf-esys.qbf-type:
    WHEN "123/1":u OR WHEN "123/1A":u THEN
      PUT CONTROL CHR(4) CHR(4).
    WHEN "SYM/1.0":u THEN
      PUT CONTROL CHR(5) CHR(4).
    WHEN "123/2":u OR WHEN "SYM/1.1":u THEN
      PUT CONTROL CHR(6) CHR(4).
  END CASE.
END PROCEDURE. /* w_bof */
 
/*--------------------------------------------------------------------------*/
/*
Record Type= EOF
Code=        1 [01h]
Body Length= 0 bytes
 
Usage=
  123/1
  123/1A
  123/2
  SYM/1.0
  SYM/1.1
 
Record Description=
  End of file
 
Body Structure=
  No record body.
*/
PROCEDURE w_eof:
  PUT CONTROL CHR(1) NULL(3).
END PROCEDURE. /* w_eof */
 
/*
/*--------------------------------------------------------------------------*/
/*
Record Type= INTEGER
Code=        13 [0Dh]
Body Length= 13 bytes
 
Usage=
  123/1
  123/1A
  123/2
  SYM/1.0
  SYM/1.1
 
Record Description=
  Integer number cell.
 
  An integer cell holds a single, signed integer value in the range
  -32768....+32767 (decimal).
 
Body Structure=
  Byte      Description
  0         Format
  1-2       Column
  3-4       Row
  5-6       Signed integer value
*/
PROCEDURE w_integer:
  PUT CONTROL
    CHR(1) NULL
    CHR(7) NULL.
END PROCEDURE. /* w_integer */
*/
/*--------------------------------------------------------------------------*/
 
/*
call this with:
  (if qbf-f = "x(":u + string(length(string("",qbf-f))) + ")":u then 
  qbf-v else string(qbf-v,qbf-f))
*/
 
PROCEDURE output_char:
  DEFINE INPUT PARAMETER qbf_v AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* first character */
  DEFINE VARIABLE qbf_r AS CHARACTER NO-UNDO. /* last character */
  DEFINE VARIABLE qbf_j AS CHARACTER NO-UNDO. /* label prefix */
  ASSIGN
    qbf_l = SUBSTRING(qbf_v,1,1,"CHARACTER":u)
    qbf_r = SUBSTRING(qbf_v,LENGTH(qbf_v,"CHARACTER":u),1,"CHARACTER":u)
    qbf_j = (IF LENGTH(qbf_l,"CHARACTER":u) = 1 THEN "'":u
            ELSE IF qbf_l =  " ":u AND qbf_r <> " ":u THEN "'":u
            ELSE IF qbf_l <> " ":u AND qbf_r =  " ":u THEN '"':u
            ELSE IF qbf_l =  " ":u AND qbf_r =  " ":u THEN "^":u
            ELSE                                           "'":u).
  PUT CONTROL
    CHR(15) NULL
    CHR(LENGTH(qbf_v,"CHARACTER":u) + 2) NULL
    qbf_j qbf_v NULL.
END PROCEDURE. /* output_char */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE output_date:
END PROCEDURE. /* output_date */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE output_log:
  DEFINE INPUT PARAMETER qbf_v AS LOGICAL NO-UNDO.
  CASE qbf_v:
    WHEN TRUE THEN DO:
      PUT CONTROL
        CHR(16) NULL
        CHR(17) NULL /* length */
        CHR(format)
        CHR(col MODULO 255) CHR(INTEGER(TRUNCATE(col / 256,0)))
        CHR(row MODULO 255) CHR(INTEGER(TRUNCATE(row / 256,0))).
      RUN write_float (1).
      PUT CONTROL
        CHR(2) NULL
        CHR(52) CHR(3). /* TRUE = @TRUE = 52 */
    END.
    WHEN FALSE THEN DO:
      PUT CONTROL
        CHR(16) NULL
        CHR(17) NULL /* length */
        CHR(format)
        CHR(col MODULO 255) CHR(INTEGER(TRUNCATE(col / 256,0)))
        CHR(row MODULO 255) CHR(INTEGER(TRUNCATE(row / 256,0))).
      RUN write_float (0).
      PUT CONTROL
        CHR(2) NULL
        CHR(51) CHR(3). /* TRUE = @FALSE = 51 */
    END.
    OTHERWISE DO: /* unknown ? */
      PUT CONTROL
        CHR(16) NULL
        CHR(17) NULL /* length */
        CHR(format)
        CHR(col MODULO 255) CHR(INTEGER(TRUNCATE(col / 256,0)))
        CHR(row MODULO 255) CHR(INTEGER(TRUNCATE(row / 256,0))).
      RUN write_float (?).
      PUT CONTROL
        CHR(2) NULL
        CHR(31) CHR(3). /* ? = @NA = 31 */
    END.
  END CASE.
END PROCEDURE. /* output_log */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE output_int:
  DEFINE INPUT PARAMETER qbf_v AS INTEGER NO-UNDO.
  IF qbf_v < -32768 OR qbf_v > 32767 THEN
    RUN output_float (qbf_v).
  ELSE
  IF qbf_v = ? THEN
    RUN output_log (?).
  ELSE DO:
    PUT CONTROL
      CHR(13) NULL
      CHR(7) NULL /* length */
      CHR(format)
      CHR(col MODULO 255) CHR(INTEGER(TRUNCATE(col / 256,0)))
      CHR(row MODULO 255) CHR(INTEGER(TRUNCATE(row / 256,0))).
    IF qbf_v < 0 THEN qbf_v = qbf_v + 65536.
    IF qbf_v MODULO 256 = 0 THEN
      PUT CONTROL NULL.
    ELSE
      PUT CONTROL CHR(qbf_v MODULO 255).
    qbf_v = (qbf_v - (qbf_v MODULO 256)) / 256.
    IF qbf_v MODULO 256 = 0 THEN
      PUT CONTROL NULL.
    ELSE
      PUT CONTROL CHR(qbf_v MODULO 255).
  END.
END PROCEDURE. /* output_int */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE output_dec:
  DEFINE INPUT PARAMETER qbf_v AS DECIMAL DECIMALS 10 NO-UNDO.
  IF qbf_v = ? THEN
    RUN output_log (?).
  ELSE
  IF qbf_v >= -32768 AND qbf_v <= 32767 AND qbf_v = TRUNCATE(qbf_v,0) THEN 
    RUN output_int (qbf_v).
  ELSE DO:
    PUT CONTROL
      CHR(14) NULL
      CHR(13) NULL /* length */
      CHR(format)
      CHR(col MODULO 255) CHR(INTEGER(TRUNCATE(col / 256,0)))
      CHR(row MODULO 255) CHR(INTEGER(TRUNCATE(row / 256,0))).
    RUN write_float (?).
  END.
END PROCEDURE. /* output_dec */
 
/*--------------------------------------------------------------------------*/
/*
Field Width
in Bits     | 1 |      11     |            52           |
------------+---+-------------+-------------------------+
Variables:  | S |      E      |            F            |
------------+---+-------------+-------------------------+
Bit Number: | 63| 62       52 | 51                    0 |
*/
 
PROCEDURE write_float:
  DEFINE INPUT PARAMETER qbf_d AS DECIMAL DECIMALS 10 NO-UNDO.
 
  DEFINE VARIABLE qbf_s AS LOGICAL NO-UNDO. /* sign */
  DEFINE VARIABLE qbf_m AS DECIMAL NO-UNDO. /* fraction (mantissa) */
  DEFINE VARIABLE qbf_e AS INTEGER NO-UNDO. /* exponent */
 
  DEFINE VARIABLE qbf_i AS DECIMAL NO-UNDO. /* integer part */
  DEFINE VARIABLE qbf_f AS DECIMAL NO-UNDO. /* fractional part */
 
  ASSIGN
    qbf_s = (IF qbf_d < 0 OR qbf_d = ?)
    qbf_d = ABSOLUTE(qbf_d)
    qbf_e = 0
    qbf_m = 0
    qbf_i = TRUNCATE(qbf_d,0)
    qbf_f = qbf_d - qbf_f
  .
 
  IF qbf_d > 0 THEN 
  DO:
    ASSIGN
      qbf_e = LOG(qbf_d,2) - 1023
      qbf_m = qbf_d / qbf_e.
 
    IF E > 0 THEN
      R = (-1)^S * 2^(E - 1023) * (1.F)
    ELSE
      R = (-1)^S * 2^(-1023) * (0.F)
  END.
 
END PROCEDURE. /* write_float */
 
/*--------------------------------------------------------------------------*/
/*
Record Type= EOF
Code=        1 [01h]
Body Length= 0 bytes
 
Usage=
  123/1
  123/1A
  123/2
  SYM/1.0
  SYM/1.1
 
Record Description=
  End of file
 
Body Structure=
  No record body.
*/
PROCEDURE w_eof:
  PUT CONTROL
    CHR(1) NULL  /* cell=   EOF */
    NULL(2).     /* len=    0 */
END PROCEDURE. /* w_eof */
 
/*--------------------------------------------------------------------------*/
*/
/* e-wks.p - end of file */
