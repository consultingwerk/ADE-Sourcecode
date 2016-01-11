/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _asetvar.p
*
*    Runtime initialization of critical internal data structures.
*
*    This file is also used by the TTY to GUI RESULTS Converter.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/a-define.i }
{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/y-define.i }
{ aderes/s-output.i }
   
FOR EACH qbf-rel-whr:
  DELETE qbf-rel-whr.
END.

FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos < 0:
  DELETE qbf-hsys.
END.

/* report stuff */
FOR EACH qbf-rsys WHERE NOT qbf-rsys.qbf-live:
  DELETE qbf-rsys.
END.

CREATE qbf-rsys.
ASSIGN
  qbf-u-hook  = ?

  /* reset caches */
  qbf-rel-whr# = 0
  qbf-printer# = 0

  /* export & label defaults */
  qbf-e-cat = ""
  qbf-l-cat = ""
  qbf-p-cat = ""

  /* report defaults */
  qbf-rsys.qbf-format      = "Letter":u
  qbf-rsys.qbf-dimen       = "8-1/2 x 11 in":u
  qbf-rsys.qbf-live        = FALSE
  qbf-rsys.qbf-origin-hz   = 1
  qbf-rsys.qbf-page-size   = 60     /* good for laser printers */
  qbf-rsys.qbf-width       = 80
  qbf-rsys.qbf-space-hz    = 1
  qbf-rsys.qbf-space-vt    = 1
  qbf-rsys.qbf-origin-vt   = 1
  qbf-rsys.qbf-header-body = 1
  qbf-rsys.qbf-body-footer = 1

  qbf-dtype   = "character,date,logical,integer,decimal,raw,rowid":u
  qbf-etype   = ",":u
              + "Running Total"    + ",":u
              + "Percent of Total" + ",":u
              + "Count Func"       + ",":u
              + "String Expr"      + ",":u
              + "Date Expr"        + ",":u
              + "Numeric Expr"     + ",":u
              + "Logical Expr"     + ",":u
              + "Stacked Array"    + ",":u
              + "Lookup Field"
              /*"12345678901234567890"*/
  .

/* commented out until enhancement(s) okayed

/* label stuff */
FOR EACH qbf-lsys WHERE NOT qbf-lsys.qbf-live:
  DELETE qbf-lsys.
END.              

CREATE qbf-lsys.
ASSIGN
  qbf-lsys.qbf-live      = FALSE  
  qbf-lsys.qbf-type      = "Default layout"
  qbf-lsys.qbf-dimen     = "3-1/2""x15/16"""
  qbf-lsys.qbf-space-hz  = 0
  qbf-lsys.qbf-origin-hz = 0
  qbf-lsys.qbf-label-wd  = 35
  qbf-lsys.qbf-label-ht  = 5
  qbf-lsys.qbf-space-vt  = 1
  qbf-lsys.qbf-across    = 1
  qbf-lsys.qbf-omit      = TRUE
  qbf-lsys.qbf-copies    = 1
  lbl-custom             = FALSE
  qbf-l-text             = ""
  .                      

/* export stuff */
FOR EACH qbf-esys WHERE NOT qbf-esys.qbf-live:
  DELETE qbf-esys.
END.

CREATE qbf-esys.
ASSIGN
  qbf-esys.qbf-live    = FALSE  
  qbf-esys.qbf-base    = ?
  qbf-esys.qbf-dlm-typ = "*":u
  qbf-esys.qbf-fixed   = FALSE
  qbf-esys.qbf-headers = FALSE
  qbf-esys.qbf-prepass = FALSE
  qbf-esys.qbf-desc    = "PROGRESS Export"
  qbf-esys.qbf-program = "e-pro.p"
  qbf-esys.qbf-type    = "PROGRESS"
  qbf-esys.qbf-lin-beg = ""
  qbf-esys.qbf-lin-end = "32,13,10"
  qbf-esys.qbf-fld-dlm = "34"
  qbf-esys.qbf-fld-sep = "32"
    .

end-of enhancement bypass - jms 06/06/95 */

/* _asetvar.p - end of file */

