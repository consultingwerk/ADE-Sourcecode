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
/* e-edit.p - enter control codes for data export and printing */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/e-table.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT        PARAMETER qbf-t AS CHARACTER NO-UNDO. /* title */
DEFINE INPUT-OUTPUT PARAMETER qbf-s AS CHARACTER NO-UNDO. /* entry-list */

DEFINE VARIABLE qbf-y AS CHARACTER NO-UNDO EXTENT 16.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* help context */
DEFINE VARIABLE qbf-l AS HANDLE    NO-UNDO. /* last fillin */

DEFINE BUTTON qbf-ok   LABEL "OK"                   {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"               {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"                {&STDPH_OKBTN}.
DEFINE BUTTON qbf-xt   LABEL "Pick &ASCII Code..."  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

/* Multi-Line text display. */
DEFINE VARIABLE qbf-instructions AS CHARACTER NO-UNDO
                             VIEW-AS EDITOR INNER-CHARS 75 INNER-LINES 8 NO-BOX.

ASSIGN qbf-instructions =
"When entering codes, these methods may be used:" + CHR(10) +
"   'x'  - literal character enclosed in single quotes." + CHR(10) +
'   ^x   - interpreted as control-character.' + CHR(10) +
'   ##h  - one or two hex digits followed by the letter "h".' + CHR(10) +
'   ###o - one, two or three octal digits and the letter "o".' + CHR(10) +
'   ###  - one, two or three digits, a decimal number.' + CHR(10) +
'   xxx  - control symbol - click "Pick ASCII Code" for details.'
.

/* Dialog layout:
____ ____ ____ ____  ____ ____ ____ ____
____ ____ ____ ____  ____ ____ ____ ____

[  OK  ] [Cancel] [Pick ASCII Code] [Help]
*/

FORM
  SKIP({&TFM_WID})
  SPACE(2) qbf-instructions SKIP
  SPACE(2)
  qbf-y[ 1] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 2] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 3] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 4] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 5] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 6] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 7] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[ 8] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1) 
  SKIP
  
  SPACE(2)
  qbf-y[ 9] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[10] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[11] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[12] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[13] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[14] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[15] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SPACE(1)
  qbf-y[16] FORMAT "x(4)":u {&STDPH_FILL} AUTO-RETURN VIEW-AS FILL-IN SKIP(.5)

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &OTHER  = "SPACE ({&HM_DBTNG}) qbf-xt"
    &HELP   = qbf-help }

  WITH FRAME qbf-new NO-LABELS NO-ATTR-SPACE WIDTH 90
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee TITLE qbf-t VIEW-AS DIALOG-BOX.

/* remove accelerator prefix from title */
IF INDEX(qbf-t,"&":u) > 0 THEN 
  SUBSTRING(qbf-t,INDEX(qbf-t,"&":u),1,"CHARACTER":u) = "".

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-new" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

CASE qbf-t:
  WHEN "record start"     THEN qbf-j = {&Record_Start_Dlg_Box}.
  WHEN "record end"       THEN qbf-j = {&Record_End_Dlg_Box}.
  WHEN "field delimiters" THEN qbf-j = {&Field_Delimiters_Dlg_Box}.
  WHEN "field separators" THEN qbf-j = {&Field_Separators_Dlg_Box}.
  OTHERWISE                    qbf-j = {&Contents_Main}.
END CASE.

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf-new OR CHOOSE OF qbf-help IN FRAME qbf-new
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,qbf-j,?).

ON ENTRY OF qbf-y IN FRAME qbf-new
  qbf-l = SELF.

ON LEAVE OF qbf-y IN FRAME qbf-new DO:
  DEFINE VARIABLE qbf_b AS INTEGER.

  qbf-l = SELF.

  IF FRAME-VALUE <> "nul":u THEN
    RUN input_to_storage (FRAME-VALUE, OUTPUT qbf_b).

  /* scan for double-byte characters */
  DO qbf-i = 1 TO LENGTH(FRAME-VALUE,"CHARACTER":u):
    IF SUBSTRING(FRAME-VALUE,qbf-i,1,"CHARACTER":u) <>
      SUBSTRING(FRAME-VALUE,qbf-i,1,"RAW":u) THEN DO:
      qbf_b = 0.
      LEAVE.
    END.
  END.

  IF FRAME-VALUE = "nul":u OR qbf_b = 0 THEN DO:
    MESSAGE SUBSTITUTE('"&1" is not an allowed code.',FRAME-VALUE)
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.

  IF qbf_b < 0 THEN DO:
    MESSAGE SUBSTITUTE('"&1" is an unknown code.',FRAME-VALUE)
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

ON CHOOSE OF qbf-xt IN FRAME qbf-new
  OR MOUSE-MENU-CLICK OF qbf-y IN FRAME qbf-new DO:
  IF qbf-l:TYPE <> "FILL-IN":u THEN RETURN NO-APPLY.

  RUN aderes/e-table.p (OUTPUT qbf-i).

  IF qbf-i <> ? AND qbf-i <> 0 THEN
    qbf-l:SCREEN-VALUE = ENTRY(qbf-i + 1,qbf-ascii).
  APPLY "ENTRY":u TO qbf-l.
  APPLY "TAB":u TO qbf-l.
END.

ON GO OF FRAME qbf-new DO:
  DEFINE VARIABLE qbf_b AS INTEGER NO-UNDO.
  qbf-s = "".
  
  DO qbf-i = 1 TO EXTENT(qbf-y):
    qbf-y[qbf-i] = INPUT FRAME qbf-new qbf-y[qbf-i].
    IF qbf-y[qbf-i] = "" THEN NEXT.
    
    RUN input_to_storage (qbf-y[qbf-i],OUTPUT qbf_b).
    
    qbf-s = qbf-s + (IF qbf-s = "" THEN "" ELSE ",":u) + STRING(qbf_b).
  END.
END.

ON WINDOW-CLOSE OF FRAME qbf-new
  APPLY "END-ERROR":u TO SELF.             

/*--------------------------------------------------------------------------*/

ASSIGN
  qbf-y                                 = ""
  qbf-xt:Y IN FRAME qbf-new             = qbf-ok:Y IN FRAME qbf-new
  qbf-xt:WIDTH IN FRAME qbf-new         = 25
  .

DO qbf-i = 1 TO MINIMUM(EXTENT(qbf-y),NUM-ENTRIES(qbf-s)):
  IF ENTRY(qbf-i,qbf-s) <> "" THEN
    RUN storage_to_input (INTEGER(ENTRY(qbf-i,qbf-s)),OUTPUT qbf-y[qbf-i]).
END.

ASSIGN qbf-instructions:READ-ONLY IN FRAME qbf-new = TRUE.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE qbf-y qbf-ok qbf-ee qbf-xt qbf-help qbf-instructions WITH FRAME qbf-new.
END.

HIDE FRAME qbf-new NO-PAUSE.
RETURN.

/*--------------------------------------------------------------------------*/

PROCEDURE storage_to_input:
  DEFINE INPUT  PARAMETER qbf_b AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_c AS CHARACTER NO-UNDO.
  IF qbf_b >= 0 THEN
    qbf_c = (IF qbf_b = 44 THEN "','":u ELSE ENTRY(qbf_b + 1,qbf-ascii)).
END PROCEDURE.

/*--------------------------------------------------------------------------*/

PROCEDURE input_to_storage:
  DEFINE INPUT  PARAMETER qbf_c AS CHARACTER          NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_b AS INTEGER INITIAL -1 NO-UNDO.

  DEFINE VARIABLE qbf_0to7 AS CHARACTER INITIAL "01234567":u         NO-UNDO.
  DEFINE VARIABLE qbf_0to9 AS CHARACTER INITIAL "0123456789":u       NO-UNDO.
  DEFINE VARIABLE qbf_0tof AS CHARACTER INITIAL "0123456789abcdef":u NO-UNDO.

  qbf_b = ?. /* ? means no value present, < 0 means error */

  IF qbf_c = "" THEN .
  ELSE IF qbf_c BEGINS "'":u THEN 
    qbf_b = ASC(SUBSTRING(qbf_c,2,1,"CHARACTER":u)).
  ELSE IF LOOKUP(qbf_c, qbf-ascii) > 0 THEN /* no can-do: wildcards confuse */
    qbf_b = LOOKUP(qbf_c, qbf-ascii) - 1.
  ELSE IF qbf_c BEGINS "^":u
    AND ASC(CAPS(SUBSTRING(qbf_c,2,1,"CHARACTER":u))) >= 64
    AND ASC(CAPS(SUBSTRING(qbf_c,2,1,"CHARACTER":u))) <= 95 THEN
    qbf_b = ASC(CAPS(SUBSTRING(qbf_c,2,1,"CHARACTER":u))) - 64.
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 2
    AND SUBSTRING(qbf_c,2,1,"CHARACTER":u) = "h":u
    AND INDEX(qbf_0tof,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0 THEN
    qbf_b = INDEX(qbf_0tof,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) - 1.
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 3
    AND SUBSTRING(qbf_c,3,1,"CHARACTER":u) = "h":u
    AND INDEX(qbf_0tof,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0tof,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) > 0 THEN
    qbf_b = (INDEX(qbf_0tof,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) - 1) * 16
          + INDEX(qbf_0tof,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) - 1.
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 2
    AND SUBSTRING(qbf_c,2,1,"CHARACTER":u) = "o":u
    AND INDEX(qbf_0to7,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0 THEN
    qbf_b = INTEGER(SUBSTRING(qbf_c,1,1,"CHARACTER":u)).
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 3
    AND SUBSTRING(qbf_c,3,1,"CHARACTER":u) = "o":u
    AND INDEX(qbf_0to7,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0to7,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) > 0 THEN
    qbf_b = INTEGER(SUBSTRING(qbf_c,1,1,"CHARACTER":u)) * 8
          + INTEGER(SUBSTRING(qbf_c,2,1,"CHARACTER":u)).
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 4
    AND SUBSTRING(qbf_c,4,1,"CHARACTER":u) = "o":u
    AND INDEX("0123":u,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0to7,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0to7,SUBSTRING(qbf_c,3,1,"CHARACTER":u)) > 0 THEN
    qbf_b = INTEGER(SUBSTRING(qbf_c,1,1,"CHARACTER":u)) * 64
          + INTEGER(SUBSTRING(qbf_c,2,1,"CHARACTER":u)) * 8
          + INTEGER(SUBSTRING(qbf_c,3,1,"CHARACTER":u)).
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 1
    AND INDEX(qbf_0to9,qbf_c) > 0 THEN qbf_b = INTEGER(qbf_c).
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 2
    AND INDEX(qbf_0to9,SUBSTRING(qbf_c,1,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0to9,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) > 0 THEN
    qbf_b = INTEGER(qbf_c).
  ELSE IF LENGTH(qbf_c,"CHARACTER":u) = 3
    AND INDEX("012":u,SUBSTRING(qbf_c,1,1,"CHARACTER":u))  > 0
    AND INDEX(qbf_0to9,SUBSTRING(qbf_c,2,1,"CHARACTER":u)) > 0
    AND INDEX(qbf_0to9,SUBSTRING(qbf_c,3,1,"CHARACTER":u)) > 0
    AND INTEGER(qbf_c) <= 255 THEN
    qbf_b = INTEGER(qbf_c).
  ELSE
    qbf_b = -1.
END PROCEDURE.

/* e-edit.p - end of file */


