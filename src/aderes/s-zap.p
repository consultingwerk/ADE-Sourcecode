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
/* s-zap.p - reset current item */

{ aderes/s-system.i }
{ aderes/s-define.i }

{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }
{ aderes/fbdefine.i }

DEFINE INPUT PARAMETER qbf-x AS LOGICAL NO-UNDO.
/* false=use defaults (for file->new), true=zap clean (for file->open) */

DEFINE VARIABLE qbf-a AS LOGICAL NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.

DEFINE BUFFER qbf-ecopy FOR qbf-esys.
DEFINE BUFFER qbf-hcopy FOR qbf-hsys.
DEFINE BUFFER qbf-lcopy FOR qbf-lsys.
DEFINE BUFFER qbf-rcopy FOR qbf-rsys.
 
FOR EACH qbf-section: DELETE qbf-section. END.
CREATE qbf-section.

FOR EACH qbf-where: DELETE qbf-where. END.
FOR EACH qbf-frame: DELETE qbf-frame. END.

ASSIGN
  qbf-section.qbf-sout = "1":u

  qbf-name       = ""
  qbf-module     = ?
  qbf-report     = ?
  qbf-summary    = FALSE
  qbf-detail     = 0
  qbf-governor   = 0
  qbf-govergen   = FALSE

  qbf-sortby     = ""   /* <-- file stuff */
  qbf-tables     = ""
  qbf-rel-choice = "" 

  qbf-rc#        = 0    /* <-- field stuff */
  qbf-rcc        = ""
  qbf-rcf        = ""
  qbf-rcg        = ""
  qbf-rcl        = ""
  qbf-rcn        = ""
  qbf-rcp        = ""
  qbf-rct        = 0
  qbf-rcw        = ?

  qbf-horiz      = 1
  qbf-timing     = ""
  qbf-count      = 0
  qbf-dirty      = FALSE.

/* reports stuff */

FOR EACH qbf-rsys WHERE qbf-rsys.qbf-live:     DELETE qbf-rsys. END.
FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos > 0: DELETE qbf-hsys. END.

CREATE qbf-rsys.

FIND FIRST qbf-rcopy WHERE NOT qbf-rcopy.qbf-live NO-ERROR.
IF AVAILABLE qbf-rcopy THEN    
  ASSIGN
    qbf-rsys.qbf-format      = qbf-rcopy.qbf-format 
    qbf-rsys.qbf-dimen       = qbf-rcopy.qbf-dimen
    qbf-rsys.qbf-live        = TRUE
    qbf-rsys.qbf-origin-hz   = qbf-rcopy.qbf-origin-hz
    qbf-rsys.qbf-page-size   = qbf-rcopy.qbf-page-size
    qbf-rsys.qbf-width       = qbf-rcopy.qbf-width
    qbf-rsys.qbf-space-hz    = qbf-rcopy.qbf-space-hz
    qbf-rsys.qbf-space-vt    = qbf-rcopy.qbf-space-vt
    qbf-rsys.qbf-origin-vt   = qbf-rcopy.qbf-origin-vt
    qbf-rsys.qbf-header-body = qbf-rcopy.qbf-header-body
    qbf-rsys.qbf-body-footer = qbf-rcopy.qbf-body-footer
    qbf-rsys.qbf-page-eject  = qbf-rcopy.qbf-page-eject.
    
ELSE
  ASSIGN
    qbf-rsys.qbf-format      = "Letter":u
    qbf-rsys.qbf-dimen       = "8-1/2 x 11 in":u
    qbf-rsys.qbf-live        = TRUE
    qbf-rsys.qbf-origin-hz   = 1
    qbf-rsys.qbf-page-size   = 60 /* good for laser printers */
    qbf-rsys.qbf-width       = 80
    qbf-rsys.qbf-space-hz    = 1
    qbf-rsys.qbf-space-vt    = 1
    qbf-rsys.qbf-origin-vt   = 1
    qbf-rsys.qbf-header-body = 1
    qbf-rsys.qbf-body-footer = 1
    qbf-rsys.qbf-page-eject  = ""
    . 

/* labels stuff */
FOR EACH qbf-lsys /* WHERE qbf-lsys.qbf-live */ : DELETE qbf-lsys. END.

CREATE qbf-lsys.

/* FIND FIRST qbf-lcopy WHERE NOT qbf-lcopy.qbf-live NO-ERROR.
IF AVAILABLE qbf-lcopy THEN
  ASSIGN 
    qbf-lsys.qbf-live      = TRUE    
    qbf-lsys.qbf-type      = qbf-lcopy.qbf-type
    qbf-lsys.qbf-dimen     = qbf-lcopy.qbf-dimen
    qbf-lsys.qbf-space-hz  = qbf-lcopy.qbf-space-hz
    qbf-lsys.qbf-origin-hz = qbf-lcopy.qbf-origin-hz
    qbf-lsys.qbf-label-wd  = qbf-lcopy.qbf-label-wd
    qbf-lsys.qbf-label-ht  = qbf-lcopy.qbf-label-ht
    qbf-lsys.qbf-space-vt  = qbf-lcopy.qbf-space-vt
    qbf-lsys.qbf-across    = qbf-lcopy.qbf-across
    qbf-lsys.qbf-omit      = qbf-lcopy.qbf-omit
    qbf-lsys.qbf-copies    = qbf-lcopy.qbf-copies
    lbl-custom             = FALSE        /* qbf-lcopy.qbf-  need to determine */ 
    qbf-l-text             = ""
    .
ELSE 
*/
  ASSIGN
    /* qbf-lsys.qbf-live      = TRUE */
    
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

/* data export stuff */
FOR EACH qbf-esys /* WHERE qbf-esys.qbf-live*/ : DELETE qbf-esys. END.

CREATE qbf-esys.

/* 
FIND FIRST qbf-ecopy WHERE NOT qbf-ecopy.qbf-live NO-ERROR.

IF AVAILABLE qbf-ecopy THEN
  ASSIGN
    qbf-esys.qbf-live    = TRUE
    qbf-esys.qbf-base    = qbf-ecopy.qbf-base
    qbf-esys.qbf-dlm-typ = qbf-ecopy.qbf-dlm-typ
    qbf-esys.qbf-fixed   = qbf-ecopy.qbf-fixed
    qbf-esys.qbf-headers = qbf-ecopy.qbf-headers
    qbf-esys.qbf-prepass = qbf-ecopy.qbf-prepass
    qbf-esys.qbf-desc    = qbf-ecopy.qbf-desc
    qbf-esys.qbf-program = qbf-ecopy.qbf-program
    qbf-esys.qbf-type    = qbf-ecopy.qbf-type
    qbf-esys.qbf-lin-beg = qbf-ecopy.qbf-lin-beg
    qbf-esys.qbf-lin-end = qbf-ecopy.qbf-lin-end
    qbf-esys.qbf-fld-dlm = qbf-ecopy.qbf-fld-dlm
    qbf-esys.qbf-fld-sep = qbf-ecopy.qbf-fld-sep
    .
ELSE
*/
  ASSIGN
    /* qbf-esys.qbf-live    = TRUE */
    
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

IF qbf-x THEN RETURN.  /* below this point, set defaults... */

FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos < 0:
  CREATE qbf-hcopy.
  qbf-hcopy.qbf-hpos = ABSOLUTE(qbf-hsys.qbf-hpos).
  DO qbf-i = 1 TO EXTENT(qbf-hsys.qbf-htxt):
    qbf-hcopy.qbf-htxt[qbf-i] = qbf-hsys.qbf-htxt[qbf-i].
  END.
END.

RETURN.

/* s-zap.p - end of file */
