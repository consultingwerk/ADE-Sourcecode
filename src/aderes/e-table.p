/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* e-table.p - ascii code picker */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER qbf-e AS INTEGER INITIAL ? NO-UNDO.

&GLOBAL-DEFINE Size SIZE-CHAR 14 BY 1 
&GLOBAL-DEFINE row1 2 
&GLOBAL-DEFINE row2 18 
&GLOBAL-DEFINE row3 34 
&GLOBAL-DEFINE row4 50 

DEFINE VARIABLE qbf-t1 AS CHARACTER NO-UNDO.

/*DEFINE BUTTON qbf-00 LABEL "nul  0 (00h)":u {&Size}.*/
DEFINE BUTTON qbf-01 LABEL "soh  1 (01h)":u {&Size}.
DEFINE BUTTON qbf-02 LABEL "stx  2 (02h)":u {&Size}.
DEFINE BUTTON qbf-03 LABEL "etx  3 (03h)":u {&Size}.
DEFINE BUTTON qbf-04 LABEL "eot  4 (04h)":u {&Size}.
DEFINE BUTTON qbf-05 LABEL "enq  5 (05h)":u {&Size}.
DEFINE BUTTON qbf-06 LABEL "ack  6 (06h)":u {&Size}.
DEFINE BUTTON qbf-07 LABEL "bel  7 (07h)":u {&Size}.
DEFINE BUTTON qbf-08 LABEL "bs   8 (08h)":u {&Size}.
DEFINE BUTTON qbf-09 LABEL "ht   9 (09h)":u {&Size}.
DEFINE BUTTON qbf-10 LABEL "lf  10 (0Ah)":u {&Size}.
DEFINE BUTTON qbf-11 LABEL "vt  11 (0Bh)":u {&Size}.
DEFINE BUTTON qbf-12 LABEL "ff  12 (0Ch)":u {&Size}.
DEFINE BUTTON qbf-13 LABEL "cr  13 (0Dh)":u {&Size}.
DEFINE BUTTON qbf-14 LABEL "so  14 (0Eh)":u {&Size}.
DEFINE BUTTON qbf-15 LABEL "si  15 (0Fh)":u {&Size}.
DEFINE BUTTON qbf-16 LABEL "dle 16 (10h)":u {&Size}.
DEFINE BUTTON qbf-17 LABEL "dc1 17 (11h)":u {&Size}.
DEFINE BUTTON qbf-18 LABEL "dc2 18 (12h)":u {&Size}.
DEFINE BUTTON qbf-19 LABEL "dc3 19 (13h)":u {&Size}.
DEFINE BUTTON qbf-20 LABEL "dc4 20 (14h)":u {&Size}.
DEFINE BUTTON qbf-21 LABEL "nak 21 (15h)":u {&Size}.
DEFINE BUTTON qbf-22 LABEL "syn 22 (16h)":u {&Size}.
DEFINE BUTTON qbf-23 LABEL "etb 23 (17h)":u {&Size}.
DEFINE BUTTON qbf-24 LABEL "can 24 (18h)":u {&Size}.
DEFINE BUTTON qbf-25 LABEL "em  25 (19h)":u {&Size}.
DEFINE BUTTON qbf-26 LABEL "sub 26 (1Ah)":u {&Size}.
DEFINE BUTTON qbf-27 LABEL "esc 27 (1Bh)":u {&Size}.
DEFINE BUTTON qbf-28 LABEL "fs  28 (1Ch)":u {&Size}.
DEFINE BUTTON qbf-29 LABEL "gs  29 (1Dh)":u {&Size}.
DEFINE BUTTON qbf-30 LABEL "rs  30 (1Eh)":u {&Size}.
DEFINE BUTTON qbf-31 LABEL "us  31 (1Fh)":u {&Size}.

DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
DEFINE RECTANGLE qbf-r1    SIZE-PIXELS 2 BY 45.
DEFINE RECTANGLE qbf-r2    SIZE-PIXELS 2 BY 45.
DEFINE RECTANGLE qbf-r3    SIZE-PIXELS 2 BY 45.

FORM
  SKIP({&TFM_WID})
  qbf-t1 AT {&Row1} FORMAT "x(60)" VIEW-AS TEXT SKIP(.5)

  qbf-01 AT {&Row1} qbf-09 AT {&Row2} qbf-17 AT {&Row3} qbf-25 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-02 AT {&Row1} qbf-10 AT {&Row2} qbf-18 AT {&Row3} qbf-26 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-03 AT {&Row1} qbf-11 AT {&Row2} qbf-19 AT {&Row3} qbf-27 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-04 AT {&Row1} qbf-12 AT {&Row2} qbf-20 AT {&Row3} qbf-28 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-05 AT {&Row1} qbf-13 AT {&Row2} qbf-21 AT {&Row3} qbf-29 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-06 AT {&Row1} qbf-14 AT {&Row2} qbf-22 AT {&Row3} qbf-30 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-07 AT {&Row1} qbf-15 AT {&Row2} qbf-23 AT {&Row3} qbf-31 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-08 AT {&Row1} qbf-16 AT {&Row2} qbf-24 AT {&Row3} qbf-26             

  /*qbf-00 AT {&Row1}
                    qbf-08 AT {&Row2} qbf-16 AT {&Row3} qbf-24 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-01 AT {&Row1} qbf-09 AT {&Row2} qbf-17 AT {&Row3} qbf-25 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-02 AT {&Row1} qbf-10 AT {&Row2} qbf-18 AT {&Row3} qbf-26 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-03 AT {&Row1} qbf-11 AT {&Row2} qbf-19 AT {&Row3} qbf-27 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-04 AT {&Row1} qbf-12 AT {&Row2} qbf-20 AT {&Row3} qbf-28 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-05 AT {&Row1} qbf-13 AT {&Row2} qbf-21 AT {&Row3} qbf-29 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-06 AT {&Row1} qbf-14 AT {&Row2} qbf-22 AT {&Row3} qbf-30 AT {&Row4} SKIP 
    ({&VM_WID})
  qbf-07 AT {&Row1} qbf-15 AT {&Row2} qbf-23 AT {&Row3} qbf-31 AT {&Row4} */

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ee                     
    &HELP   = qbf-help }

  qbf-r1 AT ROW-OF qbf-09 COLUMN 17
  qbf-r2 AT ROW-OF qbf-09 COLUMN 33
  qbf-r3 AT ROW-OF qbf-09 COLUMN 49

  WITH FRAME qbf%code NO-LABELS NO-ATTR-SPACE OVERLAY THREE-D
  TITLE "ASCII Codes":t32 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%code" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ee" 
   &HELP  = "qbf-help" }

/*--------------------------------------------------------------------------*/

ON HELP OF FRAME qbf%code OR CHOOSE OF qbf-help IN FRAME qbf%code
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Control_Codes_Dlg_Box},?).

ASSIGN
  qbf-t1:SCREEN-VALUE IN FRAME qbf%code  = 
    "Pick ASCII code by selecting corresponding button:":l60
  qbf-r1:HEIGHT-PIXELS IN FRAME qbf%code = qbf-08:Y IN FRAME qbf%code
                                  + qbf-08:HEIGHT-PIXELS IN FRAME qbf%code
                                  - qbf-09:Y IN FRAME qbf%code
  qbf-r2:HEIGHT-PIXELS IN FRAME qbf%code = 
    qbf-r1:HEIGHT-PIXELS IN FRAME qbf%code
  qbf-r3:HEIGHT-PIXELS IN FRAME qbf%code = 
    qbf-r1:HEIGHT-PIXELS IN FRAME qbf%code.

ON CHOOSE OF /*qbf-00,*/
  qbf-01, qbf-02, qbf-03, qbf-04, qbf-05, qbf-06, qbf-07, qbf-08,
  qbf-09, qbf-10, qbf-11, qbf-12, qbf-13, qbf-14, qbf-15, qbf-16,
  qbf-17, qbf-18, qbf-19, qbf-20, qbf-21, qbf-22, qbf-23, qbf-24,
  qbf-25, qbf-26, qbf-27, qbf-28, qbf-29, qbf-30, qbf-31 IN FRAME qbf%code DO:
  qbf-e = INTEGER(TRIM(SUBSTRING(SELF:LABEL,5,2,"CHARACTER":u))).
  APPLY "GO":u TO FRAME qbf%code.
END.

ON WINDOW-CLOSE OF FRAME qbf%code
  APPLY "END-ERROR":u TO SELF.

/*--------------------------------------------------------------------------*/

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  UPDATE
    qbf-01 qbf-02 qbf-03 qbf-04 qbf-05 qbf-06 qbf-07 qbf-08
    qbf-09 qbf-10 qbf-11 qbf-12 qbf-13 qbf-14 qbf-15 qbf-16
    qbf-17 qbf-18 qbf-19 qbf-20 qbf-21 qbf-22 qbf-23 qbf-24
    qbf-25 qbf-26 qbf-27 qbf-28 qbf-29 qbf-30 qbf-31 
    qbf-ee qbf-help
    WITH FRAME qbf%code.
END.

HIDE FRAME qbf%code NO-PAUSE.
RETURN.

/* e-table.p - end of file */

