/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * s-exp.p - expression builder
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

&GLOBAL-DEFINE debug           0
&GLOBAL-DEFINE ContinueWorking FALSE

/* qbf-ix will be = qbf-rc# + 1 if we're defining an expression for a new 
   field.  If the field isn't new, default the expression to the current
   value and force the user into freeform mode since we can't recreate 
   the undo path, etc.
*/
DEFINE INPUT  PARAMETER qbf-g  AS CHARACTER NO-UNDO. /* group: s n d l or m */
DEFINE INPUT  PARAMETER qbf-ix AS INTEGER   NO-UNDO. /* index of field */
DEFINE OUTPUT PARAMETER qbf-o  AS CHARACTER NO-UNDO. /* expression string */
DEFINE OUTPUT PARAMETER qbf-d  AS CHARACTER NO-UNDO. /* output datatype */
DEFINE OUTPUT PARAMETER qbf-u  AS CHARACTER NO-UNDO. /* composite fields */

DEFINE VARIABLE qbf-4   AS CHARACTER NO-UNDO. /* 4gl code */
DEFINE VARIABLE qbf-b   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f   AS LOGICAL   NO-UNDO. /* freeform */
DEFINE VARIABLE qbf-h   AS CHARACTER NO-UNDO. /* help messages */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-n   AS INTEGER   NO-UNDO. /* help context */
DEFINE VARIABLE qbf-s   AS CHARACTER NO-UNDO. /* selection list */
DEFINE VARIABLE qbf-x   AS CHARACTER NO-UNDO EXTENT 199.
DEFINE VARIABLE qbf-y   AS CHARACTER NO-UNDO. /* last expr type */
DEFINE VARIABLE sel-st  AS CHARACTER NO-UNDO. /* 4GL selection */  
DEFINE VARIABLE realtbl AS CHARACTER NO-UNDO. 

DEFINE VARIABLE qbf-ht  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-st  AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-4t  AS CHARACTER NO-UNDO.

{ aderes/s-exp.i }

DEFINE VARIABLE qbf-v1 AS CHARACTER               NO-UNDO. /* literal values */
DEFINE VARIABLE qbf-v2 AS DATE                    NO-UNDO. /* literal values */
DEFINE VARIABLE qbf-v3 AS LOGICAL                 NO-UNDO. /* literal values */
DEFINE VARIABLE qbf-v5 AS DECIMAL DECIMALS 10     NO-UNDO. /* literal values */

DEFINE TEMP-TABLE qbf-w NO-UNDO
  FIELD qbf-q AS INTEGER   /* sequence */
  FIELD qbf-t AS CHARACTER /* group/datatype */
  FIELD qbf-p AS INTEGER   /* syntax pattern index */
  FIELD qbf-e AS CHARACTER /* expression */
  FIELD qbf-a AS CHARACTER /* which after_* to use */
  INDEX qbf-w-index IS PRIMARY UNIQUE qbf-q.

DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 9 NO-UNDO. /* misc msg texts */

/*--------------------------------------------------------------------------*/

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} /*AUTO-GO*/.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-un   LABEL "&Undo"  {&STDPH_OKBTN}.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})

  qbf-ht FORMAT "x(50)":u 
    VIEW-AS TEXT AT 2 NO-LABEL
  SKIP({&VM_WID})
  
  qbf-h AT 2
    VIEW-AS EDITOR INNER-CHARS 68 INNER-LINES 3 NO-LABEL
  SKIP({&VM_WIDG})

  qbf-st FORMAT "x(50)":u 
    VIEW-AS TEXT AT 2 NO-LABEL
  SKIP({&VM_WID})
  
  qbf-s AT 2
    VIEW-AS SELECTION-LIST SCROLLBAR-V SCROLLBAR-H
    INNER-CHARS 53 INNER-LINES 8 NO-LABEL

  qbf-un 
  SKIP({&VM_WIDG})

  qbf-4t FORMAT "x(50)":u 
    VIEW-AS TEXT AT 2 NO-LABEL
  
  qbf-4 AT 2
    VIEW-AS EDITOR INNER-CHARS 65 INNER-LINES 5 SCROLLBAR-VERTICAL
    {&STDPH_EDITOR} NO-LABEL

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  qbf-f VIEW-AS TOGGLE-BOX LABEL "&Freeform":t12 AT ROW 3 COLUMN 1 /* moved */

  WITH FRAME qbf%express SIDE-LABELS THREE-D
  /*DEFAULT-BUTTON qbf-Ok*/ CANCEL-BUTTON qbf-ee
  TITLE "Add Field - " VIEW-AS DIALOG-BOX.

ASSIGN
  qbf-f:X IN FRAME qbf%express = qbf-un:X IN FRAME qbf%express
  qbf-f:Y IN FRAME qbf%express = qbf-un:Y IN FRAME qbf%express
			       + qbf-un:HEIGHT-PIXELS IN FRAME qbf%express 
			       + (qbf-un:HEIGHT-PIXELS IN FRAME qbf%express / 2).

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%express" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/*=============================Triggers=================================*/

ON HELP OF FRAME qbf%express OR CHOOSE OF qbf-help IN FRAME qbf%express
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,qbf-n,?).

ON HELP OF qbf-4 DO:
  sel-st = "".
  IF (qbf-4:SELECTION-START <> qbf-4:SELECTION-END ) THEN
    sel-st = TRIM(TRIM(qbf-4:SELECTION-TEXT), ",.;:!? ~"~ '[]()":u).
  RUN adecomm/_adehelp.p ("lgrf":u,"PARTIAL-KEY":u,?,sel-st).
END.

ON WINDOW-CLOSE OF FRAME qbf%express
  APPLY "END-ERROR":u TO SELF.             

ON CHOOSE OF qbf-ok IN FRAME qbf%express
  APPLY "GO":u TO FRAME qbf%express.

ON ALT-N OF FRAME qbf%express
  APPLY "ENTRY":u TO qbf-s IN FRAME qbf%express.

ON ALT-X OF FRAME qbf%express
  APPLY "ENTRY":u TO qbf-4 IN FRAME qbf%express.

ON GO OF FRAME qbf%express DO:
  /* incomplete expression */
  IF qbf-s:SENSITIVE IN FRAME qbf%express AND NOT qbf-f 
    AND qbf-4:SCREEN-VALUE IN FRAME qbf%express > "" THEN DO:
    MESSAGE "Complete the expression."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  
  IF qbf-4:SCREEN-VALUE IN FRAME qbf%express > "" THEN
    qbf-o = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).
END.

ON VALUE-CHANGED OF qbf-f IN FRAME qbf%express DO:
  FIND LAST qbf-w.
  ASSIGN
    qbf-f = (qbf-f:SCREEN-VALUE IN FRAME qbf%express = "yes")
    qbf-un:SENSITIVE IN FRAME qbf%express = (qbf-w.qbf-q > 0) AND NOT qbf-f
    qbf-s:SENSITIVE  IN FRAME qbf%express = TRUE.
  RUN heuristic (FALSE).
  RUN guess_help.
  IF qbf-s:SENSITIVE IN FRAME qbf%express THEN
    APPLY "ENTRY":u TO qbf-s IN FRAME qbf%express.
  ELSE
    APPLY "ENTRY":u TO qbf-4 IN FRAME qbf%express.
END.

ON CHOOSE OF qbf-un IN FRAME qbf%express DO:
  FIND LAST qbf-w.
  IF qbf-w.qbf-q > 0 THEN DELETE qbf-w.
  FIND LAST qbf-w.
  ASSIGN
    qbf-un:SENSITIVE IN FRAME qbf%express   = (qbf-w.qbf-q > 0)
    qbf-s:SENSITIVE IN FRAME qbf%express    = TRUE
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = TRIM(qbf-w.qbf-e).
  RUN heuristic (TRUE).
  RUN guess_help.
  APPLY "ENTRY":u TO qbf-s IN FRAME qbf%express.
END.

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf%express DO:
  &if {&debug} &then
  RUN gronk.
  &endif
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO.
  FIND LAST qbf-w.
  IF qbf-f THEN
    RUN after_fields.
  ELSE
    CASE qbf-w.qbf-a:
      WHEN "i":u THEN RUN after_initial.
      WHEN "m":u THEN RUN after_middle.
      WHEN "a":u THEN RUN after_adding.
      WHEN "f":u THEN RUN after_fields.
    END CASE.
  ASSIGN
    qbf-un:SENSITIVE IN FRAME qbf%express = NOT qbf-f
    qbf-4 = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express)
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = qbf-4
    qbf-4:CURSOR-OFFSET IN FRAME qbf%express = LENGTH(qbf-4,"CHARACTER":u) + 1.
  RUN heuristic (FALSE).
  IF qbf-s:SENSITIVE IN FRAME qbf%express THEN
    APPLY "ENTRY":u TO qbf-s IN FRAME qbf%express.
  ELSE
    APPLY "ENTRY":u TO qbf-4 IN FRAME qbf%express.
END.

/*================================Mainline================================*/

ASSIGN
  qbf-4:RETURN-INSERTED IN FRAME qbf%express = TRUE
  qbf-m[ 1] = "Choose String Expression to build":t64       /* group "s" */
  qbf-m[ 2] = "Choose Date Expression to build":t64         /* group "d" */
  qbf-m[ 3] = "Choose Logical Expression to build":t64      /* group "l" */
  qbf-m[ 4] = "Choose Mathematical Expression to build":t64 /* group "m" */
  qbf-m[ 5] = "Choose Numeric Expression to build":t64      /* group "n" */

  qbf-m[ 6] = "<<":u + "constant value" + ">>":u
  qbf-m[ 7] = "<<":u + "current date"   + " (TODAY)>>":u
  qbf-m[ 8] = "<<":u + "sub-expression" + ">>":u

  qbf-m[ 9] = "You may edit the resulting expression below.  When you are satisfied, press the OK button."
  qbf-ht:SCREEN-VALUE IN FRAME qbf%express = "Instructions:"
  qbf-st:SCREEN-VALUE IN FRAME qbf%express = "Fu&nction/Field:"
  qbf-4t:SCREEN-VALUE IN FRAME qbf%express = "E&xpression:"
  .

CASE qbf-g:
  WHEN "s":u THEN ASSIGN
    FRAME qbf%express:TITLE = FRAME qbf%express:TITLE + "String Function"
    qbf-n                   = {&Add_Calc_Field_Func_Str_Dlg_Box}.
  WHEN "n":u THEN ASSIGN
    FRAME qbf%express:TITLE = FRAME qbf%express:TITLE + "Numeric Function"
    qbf-n                   = {&Add_Calc_Field_Func_Num_Dlg_Box}.
  WHEN "d":u THEN ASSIGN
    FRAME qbf%express:TITLE = FRAME qbf%express:TITLE + "Date Function"
    qbf-n                   = {&Add_Calc_Field_Func_Date_Dlg_Box}.
  WHEN "l":u THEN ASSIGN
    FRAME qbf%express:TITLE = FRAME qbf%express:TITLE + "Logical Function"
    qbf-n                   = {&Add_Calc_Field_Func_Log_Dlg_Box}.
  WHEN "m":u THEN ASSIGN
    FRAME qbf%express:TITLE = FRAME qbf%express:TITLE + "Math"
    qbf-n                   = {&Add_Calc_Field_Func_Math_Dlg_Box}.
  OTHERWISE 
    qbf-n = {&Contents_Main}.          
END CASE.

CREATE qbf-w.
ASSIGN
  qbf-o = (IF qbf-ix > qbf-rc# THEN ""       /* current expression */
    ELSE SUBSTRING(qbf-rcn[qbf-ix],INDEX(qbf-rcn[qbf-ix], ",":u) + 1,-1,
		   "CHARACTER":u))
  qbf-w.qbf-q = 0
  qbf-w.qbf-t = qbf-g
  qbf-w.qbf-p = 0
  qbf-w.qbf-e = qbf-o
  qbf-w.qbf-a = "i":u
  qbf-4:SCREEN-VALUE IN FRAME qbf%express = qbf-o
  qbf-h:READ-ONLY IN FRAME qbf%express = TRUE.

IF qbf-o <> "" THEN
  qbf-f = yes.
RUN heuristic (FALSE).

DISPLAY qbf-f 
  WITH FRAME qbf%express.
ENABLE qbf-h qbf-s qbf-f qbf-4 qbf-ok qbf-ee qbf-help 
  WITH FRAME qbf%express.

DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  qbf-o = "".
  IF qbf-4:SCREEN-VALUE <> "" THEN
    WAIT-FOR GO OF FRAME qbf%express FOCUS qbf-4.
  ELSE
    WAIT-FOR GO OF FRAME qbf%express FOCUS qbf-s.

  IF qbf-o = "" THEN LEAVE.

  FIND LAST qbf-w.
  qbf-d = (IF qbf-w.qbf-t = "m":u THEN "n":u ELSE qbf-w.qbf-t).

  RUN aderes/_scompil.p (INDEX("sdl_n":u,qbf-d),qbf-ix,qbf-o,TRUE, 
			 OUTPUT qbf-b).
  IF qbf-b THEN DO:
    RUN used_fields (OUTPUT qbf-u).
    LEAVE.
  END.
END.

OS-DELETE "qbf_tc.p":u.  /* delete any test compile files */
OS-DELETE "qbf_tc.d":u.  
HIDE FRAME qbf%express NO-PAUSE.

RETURN.

/*--------------------------------------------------------------------------*/

/* This sets up the initial selection list before user has chosen anything
   or after Undo takes us back to initial list.
*/
PROCEDURE before_initial:
  DEFINE INPUT PARAMETER qbf_g AS CHARACTER NO-UNDO. /* group */
  DEFINE VARIABLE qbf_l AS CHARACTER INITIAL "" NO-UNDO. /* new list-items */

  qbf-h:SCREEN-VALUE IN FRAME qbf%express
    = (IF     qbf_g = "s":u THEN qbf-m[1]
      ELSE IF qbf_g = "d":u THEN qbf-m[2]
      ELSE IF qbf_g = "l":u THEN qbf-m[3]
      ELSE IF qbf_g = "m":u THEN qbf-m[4]
      ELSE          /* n */      qbf-m[5]).

  DO qbf-i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf-i] <> "":
    IF ENTRY(1,qbf-x[qbf-i],"|":u) = qbf_g THEN
      qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u)
	    + ENTRY(4,qbf-x[qbf-i],"|":u).
  END.
  RUN aderes/s-vector.p (FALSE,",":u,INPUT-OUTPUT qbf_l).

  IF qbf-s:LIST-ITEMS IN FRAME qbf%express <> qbf_l THEN
    qbf-s:LIST-ITEMS IN FRAME qbf%express = qbf_l.

  FIND LAST qbf-w.
  ASSIGN
    qbf-s:SCREEN-VALUE IN FRAME qbf%express
		= (IF CAN-DO(qbf_l,qbf-y) THEN qbf-y ELSE ENTRY(1,qbf_l))
    qbf-w.qbf-a = "i":u.
END PROCEDURE. /* before_initial */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* The user has chosen something from initial list.  Put initial expression
   into the editor widget.
*/
PROCEDURE after_initial:
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* index into qbf-x */
  DEFINE VARIABLE qbf_q AS INTEGER NO-UNDO. /* seq value */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* datatype */

  FIND LAST qbf-w.
  qbf-y = qbf-s:SCREEN-VALUE IN FRAME qbf%express.
  DO qbf_i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf_i] <> "":
    IF qbf-y = ENTRY(4,qbf-x[qbf_i],"|":u) THEN LEAVE.
  END.
  RUN expand_datatypes (ENTRY(3,qbf-x[qbf_i],"|":u),
			SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),6,-1,
				  "CHARACTER":u),
			OUTPUT qbf_t).
  ASSIGN
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = TRIM(qbf_t)
    qbf_q                                   = qbf-w.qbf-q.

  CREATE qbf-w.
  ASSIGN
    qbf-w.qbf-q = qbf_q + 1
    qbf-w.qbf-t = SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),1,1,"CHARACTER":u)
    qbf-w.qbf-p = qbf_i
    qbf-w.qbf-e = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).
END PROCEDURE. /* after_initial */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE before_adding:
  DEFINE INPUT PARAMETER qbf_g AS CHARACTER NO-UNDO. /* expr type */
  DEFINE VARIABLE qbf_l AS CHARACTER INITIAL "" NO-UNDO. /* new list-items */

  qbf-h:SCREEN-VALUE IN FRAME qbf%express
    = (IF     qbf_g = "s":u THEN qbf-m[1]
      ELSE IF qbf_g = "d":u THEN qbf-m[2]
      ELSE IF qbf_g = "l":u THEN qbf-m[3]
      ELSE          /* n */      qbf-m[5]).

  DO qbf-i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf-i] <> "":
    /*IF INDEX(SUBSTRING(ENTRY(2,qbf-x[qbf-i],"|":u),6),qbf_g) > 0 THEN*/
    IF qbf_g = SUBSTRING(ENTRY(2,qbf-x[qbf-i],"|":u),6,1,"CHARACTER":u) THEN
      qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u)
	    + ENTRY(4,qbf-x[qbf-i],"|":u).
  END.

  RUN aderes/s-vector.p (FALSE,",":u,INPUT-OUTPUT qbf_l).

  IF qbf-s:LIST-ITEMS IN FRAME qbf%express <> qbf_l THEN
    qbf-s:LIST-ITEMS IN FRAME qbf%express = qbf_l.

  FIND LAST qbf-w.
  ASSIGN
    qbf-s:SCREEN-VALUE IN FRAME qbf%express
      = (IF CAN-DO(qbf_l,qbf-y) THEN qbf-y ELSE ENTRY(1,qbf_l))
    qbf-w.qbf-a = "a":u.
END PROCEDURE. /* before_adding */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE after_adding:
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* index into qbf-x */
  DEFINE VARIABLE qbf_q AS INTEGER   NO-UNDO. /* seq value */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* datatype */

  FIND LAST qbf-w.
  qbf-y = qbf-s:SCREEN-VALUE IN FRAME qbf%express.
  DO qbf_i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf_i] <> "":
    IF qbf-y = ENTRY(4,qbf-x[qbf_i],"|":u) THEN LEAVE.
  END.
  qbf_t = REPLACE(ENTRY(3,qbf-x[qbf_i],"|":u), "&1":u,
		  TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express)).

  RUN expand_datatypes (qbf_t, SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),6,-1,
					 "CHARACTER":u),
			OUTPUT qbf_t).
  ASSIGN
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = TRIM(qbf_t)
    qbf_q = qbf-w.qbf-q.

  CREATE qbf-w.
  ASSIGN
    qbf-w.qbf-q = qbf_q + 1
    qbf-w.qbf-t = SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),1,1,"CHARACTER":u)
    qbf-w.qbf-p = qbf_i
    qbf-w.qbf-e = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).
END PROCEDURE. /* after_adding */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* The user has selected a sub-expression so we need to fill the select
   list with possible choices that make sense.
*/
PROCEDURE before_middle:
  DEFINE INPUT PARAMETER qbf_g AS CHARACTER NO-UNDO. /* expr type */
  DEFINE VARIABLE qbf_l        AS CHARACTER NO-UNDO. /* new list-items */

  qbf-h:SCREEN-VALUE IN FRAME qbf%express
    = (IF     qbf_g = "s":u THEN qbf-m[1]
      ELSE IF qbf_g = "d":u THEN qbf-m[2]
      ELSE IF qbf_g = "l":u THEN qbf-m[3]
      ELSE          /* n */      qbf-m[5]).

  DO qbf-i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf-i] <> "":
    /*IF INDEX(SUBSTRING(ENTRY(2,qbf-x[qbf-i],"|":u),1),qbf_g) > 0 THEN*/
    IF qbf_g = SUBSTRING(ENTRY(2,qbf-x[qbf-i],"|":u),1,1,"CHARACTER":u) THEN
      qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u)
	    + ENTRY(4,qbf-x[qbf-i],"|":u).
  END.

  RUN aderes/s-vector.p (FALSE,",":u,INPUT-OUTPUT qbf_l).

  IF qbf-s:LIST-ITEMS IN FRAME qbf%express <> qbf_l THEN
    qbf-s:LIST-ITEMS IN FRAME qbf%express = qbf_l.

  FIND LAST qbf-w.
  ASSIGN
    qbf-s:SCREEN-VALUE IN FRAME qbf%express
		= (IF CAN-DO(qbf_l,qbf-y) THEN qbf-y ELSE ENTRY(1,qbf_l))
    qbf-w.qbf-a = "m":u.
END PROCEDURE. /* before_middle */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* The user has chosen a sub-expression so now the user just has to
   resolve the pieces (which may be another sub-expression in which case
   we'll do before_middle again etc.)
*/
PROCEDURE after_middle:
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* index into qbf-x */
  DEFINE VARIABLE qbf_q AS INTEGER   NO-UNDO. /* seq value */
  DEFINE VARIABLE qbf_4 AS CHARACTER NO-UNDO. /* expression */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* datatype */
  DEFINE VARIABLE qbf_m AS CHARACTER NO-UNDO. /* middle to insert */

  FIND LAST qbf-w.
  qbf-y = qbf-s:SCREEN-VALUE IN FRAME qbf%express.
  DO qbf_i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf_i] <> "":
    IF qbf-y = ENTRY(4,qbf-x[qbf_i],"|":u) THEN LEAVE.
  END.
  RUN expand_datatypes (ENTRY(3,qbf-x[qbf_i],"|":u),
			SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),6,-1,
				  "CHARACTER":u),
			OUTPUT qbf_m).

  ASSIGN
    qbf_m = "(":u + qbf_m + ")":u
    qbf_4 = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express)
    qbf_t = qbf-left
	  + ENTRY(INDEX("sdln":u,
		  SUBSTRING(ENTRY(2,qbf-x[qbf_i],"|":u),1,1,"CHARACTER":u)),
	    "string,date,logical,number":u)
	  + qbf-right.

  IF INDEX(qbf_4,qbf_t) > 0 THEN
    SUBSTRING(qbf_4,INDEX(qbf_4,qbf_t),
	      LENGTH(qbf_t,"CHARACTER":u),"CHARACTER":u) = qbf_m.
  ASSIGN
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = TRIM(qbf_4)
    qbf_q = qbf-w.qbf-q
    qbf_t = qbf-w.qbf-t.

  CREATE qbf-w.
  ASSIGN
    qbf-w.qbf-q = qbf_q + 1
    qbf-w.qbf-t = qbf_t
    qbf-w.qbf-p = qbf_i
    qbf-w.qbf-e = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).
END PROCEDURE. /* after_middle */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* We need to put up the set of fields to pick from plus the picks
   "constant value" and "sub-expression".
*/
PROCEDURE before_fields:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO. /* datatype */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* new list-items */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* db/tbl name */
  DEFINE VARIABLE qbf_y AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE fName AS CHARACTER NO-UNDO.

  IF NOT qbf-f THEN
    qbf_l = (IF qbf_t <> 3 THEN qbf-m[6] ELSE "") /* constant value */
	  + (IF qbf_t = 2 THEN ",":u + qbf-m[7] ELSE ""). /* current date */

  IF qbf_t > 0 THEN DO:
    DO qbf-i = 1 TO EXTENT(qbf-x) WHILE qbf-x[qbf-i] <> "":
      IF ENTRY(2,qbf-x[qbf-i],"|":u) BEGINS 
	SUBSTRING("sdl_n":u,qbf_t,1,"CHARACTER":u) THEN LEAVE.
    END.
    IF qbf-i <= EXTENT(qbf-x) AND qbf-x[qbf-i] <> "" THEN
      qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u) + 
	      qbf-m[8]. /* <<sub-expression>> */
  END.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
    {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-tables)).
    qbf_n = qbf-rel-buf.tname.

    RUN alias_to_tbname (qbf_n, FALSE, OUTPUT realtbl).

    CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(SDBNAME(ENTRY(1,qbf_n,".":u))).

    RUN adecomm/_a-schem.p (ENTRY(1,realtbl,".":u),ENTRY(2,realtbl,".":u),
      (IF      qbf_t = 0 THEN "1,2,3,4,5":u
       ELSE IF qbf_t = 4 OR qbf_t = 5 THEN "4,5":u ELSE STRING(qbf_t)),
      OUTPUT qbf_c,   /* label list (throw-away) */
      OUTPUT qbf_c).  /* name list */

    qbf_n = (IF NOT qbf-hidedb THEN
	      qbf_n + ".":u
	    ELSE IF NUM-ENTRIES(qbf-tables) > 1 THEN
	      ENTRY(2,qbf_n,".":u) + ".":u
	    ELSE "").

    DO qbf-j = 1 TO NUM-ENTRIES(qbf_c):
      ASSIGN
	fName = ENTRY(qbf-j,qbf_c)
	qbf_y = TRUE.

      IF _fieldCheck <> ? THEN DO:
	hook:
	DO ON STOP UNDO hook, RETRY hook:
	  IF RETRY THEN DO:
	    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"error":u,"ok":u,
	      SUBSTITUTE("There is a problem with &1. &2 will use default field security.",_fieldCheck,qbf-product)).
	    _fieldCheck = ?.
	    LEAVE hook.
	  END.

	  RUN VALUE(_fieldCheck) (realtbl, fName, 
				  USERID(ENTRY(1,realtbl,".":u)),
				  OUTPUT qbf_y).
	END.
      END.
      IF qbf_y = FALSE THEN NEXT.

      qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u) + 
	      qbf_n + fName.
    END.
  END.

  /* We're not supporting this yet -dma
  /* prefix calculated fields of correct datatype onto field list */
  qbf_c = (IF qbf_t = 0 THEN "1,2,3,4,5":u
	   ELSE IF qbf_t = 4 OR qbf_t = 5 THEN "4,5":u 
	   ELSE STRING(qbf_t)).
  */

  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-rcc[qbf-i] > "" AND LOOKUP(STRING(qbf-rct[qbf-i]),qbf_c) > 0 THEN 
      qbf_l = ENTRY(1,qbf-rcn[qbf-i]) 
	    + (IF qbf_l = "" THEN "" ELSE ",":u) 
	    + qbf_l.
  END.

  IF qbf-s:LIST-ITEMS IN FRAME qbf%express <> qbf_l THEN
    qbf-s:LIST-ITEMS IN FRAME qbf%express = qbf_l.

  FIND LAST qbf-w.
  ASSIGN
    qbf-s:SCREEN-VALUE IN FRAME qbf%express = ENTRY(1,qbf_l)
    qbf-w.qbf-a                             = "f":u.

  RUN guess_help.
END PROCEDURE. /* before_fields */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* The user has chosen one of the fields or "constant-value" or 
   "sub-expression".
*/
PROCEDURE after_fields:
  DEFINE VARIABLE qbf_1 AS INTEGER   NO-UNDO. /* pos of {character} */
  DEFINE VARIABLE qbf_2 AS INTEGER   NO-UNDO. /* pos of {date}      */
  DEFINE VARIABLE qbf_3 AS INTEGER   NO-UNDO. /* pos of {logical}   */
  DEFINE VARIABLE qbf_5 AS INTEGER   NO-UNDO. /* pos of {decimal}   */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* index into 4gl */
  DEFINE VARIABLE qbf_q AS INTEGER   NO-UNDO. /* sequence value */
  DEFINE VARIABLE qbf_s AS CHARACTER NO-UNDO. /* substitution string */
  DEFINE VARIABLE qbf_v AS CHARACTER NO-UNDO. /* value/scrap */
  DEFINE VARIABLE qbf_m AS LOGICAL   NO-UNDO. /* sub-expression mode? */
  DEFINE VARIABLE qbf_x AS LOGICAL   NO-UNDO. /* scrap */

  ASSIGN
    qbf_m = FALSE
    qbf_v = qbf-s:SCREEN-VALUE IN FRAME qbf%express.
  IF qbf-f THEN DO:
    qbf_i = R-INDEX(qbf_v,"(":u).
    IF qbf_i > 0 THEN 
      qbf_v = ENTRY(1,SUBSTRING(qbf_v,qbf_i + 1,-1,"CHARACTER":u),")":u).

    IF NUM-ENTRIES(qbf-dbs) = 1 AND NUM-ENTRIES(qbf-tables) = 1 THEN DO:
      {&FIND_TABLE_BY_ID} INTEGER(qbf-tables).
      qbf_v = qbf-rel-buf.tname + ".":u + qbf_v.
    END.
    ELSE IF qbf-hidedb THEN
      qbf_v = LDBNAME(1) + ".":u + qbf_v.

    IF   qbf-4:SELECTION-TEXT IN FRAME qbf%express = ""
      OR qbf-4:SELECTION-TEXT IN FRAME qbf%express = ? THEN
      qbf-b = qbf-4:INSERT-STRING(qbf_v) IN FRAME qbf%express.
    ELSE
      qbf-4:SCREEN-VALUE IN FRAME qbf%express
	= SUBSTRING(qbf-4:SCREEN-VALUE IN FRAME qbf%express, 1,
		    qbf-4:SELECTION-START IN FRAME qbf%express - 1,
		    "CHARACTER":u)
	+ qbf_v
	+ SUBSTRING(qbf-4:SCREEN-VALUE IN FRAME qbf%express,
		    qbf-4:SELECTION-END IN FRAME qbf%express, -1,
		    "CHARACTER":u).
    qbf-4 = qbf-4:SCREEN-VALUE IN FRAME qbf%express.
  END.
  ELSE DO:
    CASE qbf_v:
      WHEN qbf-m[7] THEN /* <<current date>> */
	ASSIGN
	  qbf_v = "TODAY":u
	  qbf_s = "2":u.
      WHEN qbf-m[8] THEN DO: /* <<sub-expression>> */
	ASSIGN
	  qbf_v = qbf-left + "*":u + qbf-right.
	ASSIGN
	  qbf_1 = INDEX(qbf-w.qbf-e,qbf-left + "string":u  + qbf-right)
	  qbf_2 = INDEX(qbf-w.qbf-e,qbf-left + "date":u    + qbf-right)
	  qbf_3 = INDEX(qbf-w.qbf-e,qbf-left + "logical":u + qbf-right)
	  qbf_5 = INDEX(qbf-w.qbf-e,qbf-left + "number":u  + qbf-right)
	  qbf_i = MAXIMUM(qbf_1,qbf_2,qbf_3,qbf_5).
	IF qbf_1 > 0 AND qbf_1 < qbf_i THEN qbf_i = qbf_1.
	IF qbf_2 > 0 AND qbf_2 < qbf_i THEN qbf_i = qbf_2.
	IF qbf_3 > 0 AND qbf_3 < qbf_i THEN qbf_i = qbf_3.
	IF qbf_5 > 0 AND qbf_5 < qbf_i THEN qbf_i = qbf_5.
	ASSIGN
	  qbf_s = (IF     qbf_i = qbf_1 THEN "1":u
		  ELSE IF qbf_i = qbf_2 THEN "2":u
		  ELSE IF qbf_i = qbf_3 THEN "3":u
		  ELSE                       "5":u)
	  qbf_v = SUBSTRING("sdlnn":u,INTEGER(qbf_s),1,"CHARACTER":u)
	  qbf_m = TRUE.
      END.
      WHEN qbf-m[6] THEN DO: /* <<constant value>> */
	ASSIGN
	  qbf_1 = INDEX(qbf-w.qbf-e,qbf-left + "string":u  + qbf-right)
	  qbf_2 = INDEX(qbf-w.qbf-e,qbf-left + "date":u    + qbf-right)
	  qbf_3 = INDEX(qbf-w.qbf-e,qbf-left + "logical":u + qbf-right)
	  qbf_5 = INDEX(qbf-w.qbf-e,qbf-left + "number":u  + qbf-right)
	  qbf_i = MAXIMUM(qbf_1,qbf_2,qbf_3,qbf_5).
	IF qbf_1 > 0 AND qbf_1 < qbf_i THEN qbf_i = qbf_1.
	IF qbf_2 > 0 AND qbf_2 < qbf_i THEN qbf_i = qbf_2.
	IF qbf_3 > 0 AND qbf_3 < qbf_i THEN qbf_i = qbf_3.
	IF qbf_5 > 0 AND qbf_5 < qbf_i THEN qbf_i = qbf_5.
	qbf_v = ?.
	CASE qbf_i:
	  WHEN qbf_1 THEN DO:
	    RUN adecomm/_y-strng.p (1,?,?,OUTPUT qbf_v, OUTPUT qbf_x).
	    qbf_s = "1":u.
	  END.
	  WHEN qbf_2 THEN DO:
	    RUN adecomm/_y-date.p (1,?,?,OUTPUT qbf_v, OUTPUT qbf_x).
	    qbf_s = "2":u.
	  END.
	  WHEN qbf_3 THEN DO:
	    RUN adecomm/_y-logic.p (1,?,?,OUTPUT qbf_v).
	    qbf_s = "3":u.
	  END.
	  WHEN qbf_5 THEN DO:
	    RUN adecomm/_y-num.p (1,?,?,OUTPUT qbf_v, OUTPUT qbf_x).
	    qbf_s = "5":u.
	  END.
	END CASE.
      END.
      OTHERWISE DO:
	qbf_i = R-INDEX(qbf_v,"(":u).
	IF qbf_i > 0 THEN 
	  qbf_v = ENTRY(1,SUBSTRING(qbf_v,qbf_i + 1,-1,"CHARACTER":u),")":u).
	IF qbf-hidedb THEN DO:
	  /* qbf_v is be either just field or table.field*/
	  IF NUM-ENTRIES(qbf-tables) = 1 THEN DO:
	    {&FIND_TABLE_BY_ID} INTEGER(qbf-tables).
	    qbf_v = qbf-rel-buf.tname + ".":u + qbf_v.
	  END.
	  ELSE
	    qbf_v = LDBNAME(1) + ".":u + qbf_v.
	END.
	RUN alias_to_tbname (qbf_v, TRUE, OUTPUT realtbl).
	RUN adecomm/_y-schem.p (realtbl,"","",OUTPUT qbf_s).
      END.
    END CASE.
    ASSIGN
      qbf_s = ENTRY(INTEGER(ENTRY(1,qbf_s)),
		qbf-left + "string":u  + qbf-right + ",":u
	      + qbf-left + "date":u    + qbf-right + ",":u
	      + qbf-left + "logical":u + qbf-right + ",":u
	      + qbf-left + "number":u  + qbf-right + ",":u
	      + qbf-left + "number":u  + qbf-right
	      )
      qbf-4 = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express)
      qbf_i = INDEX(qbf-4,qbf_s).
    IF qbf_v <> ? AND qbf_i > 0 AND NOT qbf_m THEN
      SUBSTRING(qbf-4,qbf_i,LENGTH(qbf_s,"CHARACTER":u),"CHARACTER":u) = qbf_v.
  END.

  FIND LAST qbf-w.
  ASSIGN
    qbf-4:SCREEN-VALUE IN FRAME qbf%express = TRIM(qbf-4)
    qbf_v = qbf-w.qbf-t
    qbf_q = qbf-w.qbf-q.
  CREATE qbf-w.
  ASSIGN
    qbf-w.qbf-q = qbf_q + 1
    qbf-w.qbf-t = qbf_v
    qbf-w.qbf-p = 0
    qbf-w.qbf-e = qbf-4
    qbf-w.qbf-a = (IF qbf_m THEN "m":u ELSE "a":u).
END PROCEDURE. /* after_fields */

/*--------------------------------------------------------------------------*/
/* replace substitute parameters (&1, &2, etc.) with {datatype} parameters */

PROCEDURE expand_datatypes:
  DEFINE INPUT  PARAMETER qbf_e AS CHARACTER NO-UNDO. /* 'tute expression */
  DEFINE INPUT  PARAMETER qbf_l AS CHARACTER NO-UNDO. /* datatype list */
  DEFINE OUTPUT PARAMETER qbf_o AS CHARACTER NO-UNDO. /* expanded string */

  ASSIGN
    qbf_o = SUBSTITUTE(qbf_e,
	      "<":u + SUBSTRING(qbf_l, 1,1,"CHARACTER":u) + ">":u,  /* "&1" */
	      "<":u + SUBSTRING(qbf_l, 5,1,"CHARACTER":u) + ">":u,  /* "&2" */
	      "<":u + SUBSTRING(qbf_l, 9,1,"CHARACTER":u) + ">":u,  /* "&3" */
	      "<":u + SUBSTRING(qbf_l,13,1,"CHARACTER":u) + ">":u,  /* "&4" */
	      "<":u + SUBSTRING(qbf_l,17,1,"CHARACTER":u) + ">":u,  /* "&5" */
	      "<":u + SUBSTRING(qbf_l,21,1,"CHARACTER":u) + ">":u,  /* "&6" */
	      "<":u + SUBSTRING(qbf_l,25,1,"CHARACTER":u) + ">":u,  /* "&7" */
	      "<":u + SUBSTRING(qbf_l,29,1,"CHARACTER":u) + ">":u,  /* "&8" */
	      "<":u + SUBSTRING(qbf_l,33,1,"CHARACTER":u) + ">":u   /* "&9" */
	    )
    qbf_o = REPLACE(qbf_o,"<s>":u,qbf-left + "string":u  + qbf-right)
    qbf_o = REPLACE(qbf_o,"<d>":u,qbf-left + "date":u    + qbf-right)
    qbf_o = REPLACE(qbf_o,"<l>":u,qbf-left + "logical":u + qbf-right)
    qbf_o = REPLACE(qbf_o,"<n>":u,qbf-left + "number":u  + qbf-right).
END PROCEDURE. /* expand_datatypes */

/*--------------------------------------------------------------------------*/
/*
Returns a list of dependent fields from the expression.  Since we have
an expert mode, we don't really know that the fields we assume the user
is using are the ones actually being used, so we must test.

Use the output from the XREF on the compile.  For example:

qbf_tc.p: (generated code)
  FIND FIRST demo.customer NO-LOCK NO-ERROR.
  DEFINE VARIABLE qbf-000 AS CHARACTER NO-UNDO.
  qbf-000 = SUBSTRING(demo.customer.Address2,INTEGER(demo.customer.Cust-num),~
  INTEGER(demo.customer.Cust-num)).

qbf_tc.d: (XREF listing)
  qbf_tc.p qbf_tc.p 1 COMPILE qbf_tc.p
  qbf_tc.p qbf_tc.p 1 STRING "customer" 8 LEFT TRANSLATABLE
  qbf_tc.p qbf_tc.p 1 SEARCH demo.customer Cust-num
  qbf_tc.p qbf_tc.p 3 ACCESS demo.customer Address2
  qbf_tc.p qbf_tc.p 3 ACCESS demo.customer Cust-num
  qbf_tc.p qbf_tc.p 3 STRING "cust-num" 8 LEFT TRANSLATABLE

The ACCESS expressions are the fields referenced.

The only glitch - if expression contains an alias, Progress will have
resolved it back to the table name.  So we have to see if this field
is really in there or if it's the alias or if it's both.
*/

PROCEDURE used_fields:
  DEFINE OUTPUT PARAMETER used_flds AS CHARACTER INITIAL "" NO-UNDO.
  DEFINE VARIABLE qbf_c   AS CHARACTER NO-UNDO. /* category from XREF file */
  DEFINE VARIABLE qbf_f   AS CHARACTER NO-UNDO. /* field from XREF file    */
  DEFINE VARIABLE qbf_dt  AS CHARACTER NO-UNDO. /* db.table from XREF file */
  DEFINE VARIABLE qbf_tf  AS CHARACTER NO-UNDO. /* table.field */
  DEFINE VARIABLE qbf_dtf AS CHARACTER NO-UNDO. /* db.table.field */
  DEFINE VARIABLE qbf_af  AS CHARACTER NO-UNDO. /* alias.field */
  DEFINE VARIABLE qbf_daf AS CHARACTER NO-UNDO. /* db.alias.field */
  DEFINE VARIABLE add_it  AS LOGICAL   NO-UNDO. 
  DEFINE VARIABLE any_ali AS LOGICAL   NO-UNDO. /* any aliases? */
  DEFINE VARIABLE has_fld AS LOGICAL   NO-UNDO. /* is field in expression? */

  INPUT FROM "qbf_tc.d":u NO-ECHO NO-MAP.
  REPEAT:
    IMPORT ^ ^ ^ qbf_c qbf_dt qbf_f.
    qbf_dtf = qbf_dt + ".":u + qbf_f.

    IF qbf_c = "ACCESS":u THEN DO:

      /* If there's 1 or more aliases on this table we have to do 
	 some more work - otherwise we've got the field. 
      */
      {&FIND_TABLE_BY_NAME} qbf_dt.
      ASSIGN
	any_ali = FALSE.
	add_it = FALSE.

      FOR EACH qbf-rel-buf2 WHERE qbf-rel-buf2.cansee
			      and qbf-rel-buf2.sid = qbf-rel-buf.tid:
	 any_ali = TRUE.

	 /* By definition the fields of an alias are not unique.  So 
	    the user must qualify fields with at least the table name.
	    If they don't, we assume the real table.  See if alias.field
	    followed by a delimiter (anything not allowed in a name)
	    is in the string.  The only glitch here is if they happen
	    to have this string in a comment or in quotes - we're not
	    going to worry about this.
	 */
	 qbf_af = ENTRY(2, qbf-rel-buf2.tname, ".":u) + ".":u + qbf_f.
	 RUN is_field_in_there (qbf_af, OUTPUT has_fld).
	 IF has_fld THEN DO:
	    /* add this alias.field to the list */
	    qbf_daf = qbf-rel-buf2.tname + ".":u + qbf_f.
	    IF NOT CAN-DO(used_flds, qbf_daf) THEN
	       used_flds = used_flds + (IF used_flds = "" THEN "" ELSE ",":u)
			   + qbf_daf.

	    /* The real table could be in there as well. Again it must
	       be qualified with the table.  If they just put field name
	       and they've already referred to the field qualified by
	       the alias - we assume the alias. (mostly 'cause it's easier!)
	       If we got it last time round, don't bother.
	    */
	    IF NOT add_it THEN DO: 
	      qbf_tf = ENTRY(2,qbf_dt,".":u) + ".":u + qbf_f.
	      RUN is_field_in_there (qbf_tf, OUTPUT has_fld).
	      IF has_fld THEN
		 add_it = TRUE.
	    END.
	 END.
	 ELSE /* alias wasn't in there - must be real tbl */
	    add_it = TRUE. 

	 IF add_it AND NOT CAN-DO(used_flds, qbf_dtf) THEN 
	    used_flds = used_flds + (IF used_flds = "" THEN "" ELSE ",":u)
			+ qbf_dtf.
      END.

      /* If there were no aliases, add db.table.field */
      IF NOT any_ali AND NOT CAN-DO(used_flds, qbf_dtf) THEN
	  used_flds = used_flds + (IF used_flds = "" THEN "" ELSE ",":u)
		      + qbf_dtf.
    END.
  END.
  INPUT CLOSE.
END PROCEDURE. /* used_fields */

/*--------------------------------------------------------------------------*/

/* See if a given field name is in the expression */
PROCEDURE is_field_in_there:
  DEFINE INPUT  PARAMETER p_fname AS CHARACTER NO-UNDO. /* field name */
  DEFINE OUTPUT PARAMETER p_there AS LOGICAL   NO-UNDO INIT NO.

  DEFINE VARIABLE ix      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE nxt_chr AS CHARACTER NO-UNDO. /* next character */
  DEFINE VARIABLE start   AS INTEGER   NO-UNDO INIT 1.
  
  DO WHILE p_there = NO AND start < LENGTH(qbf-o,"CHARACTER":u):
    ix = INDEX(qbf-o, p_fname, start).
    IF ix > 0 THEN
      ASSIGN
	start   = ix + 1
	nxt_chr = SUBSTRING(qbf-o,ix + LENGTH(p_fname,"CHARACTER":u),1,
			    "CHARACTER":u).
    ELSE 
      start = LENGTH(qbf-o,"CHARACTER":u).
    IF ix > 0 AND
       INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":u,nxt_chr) = 0 THEN
      p_there = YES.
  END.
END.

/*--------------------------------------------------------------------------*/
/*
Guess what the next step is.
*/

PROCEDURE heuristic:
  DEFINE INPUT PARAMETER qbf_u AS LOGICAL NO-UNDO. /* undo-ing flag */
  DEFINE VARIABLE qbf_1 AS INTEGER   NO-UNDO. /* pos of {character} */
  DEFINE VARIABLE qbf_2 AS INTEGER   NO-UNDO. /* pos of {date}      */
  DEFINE VARIABLE qbf_3 AS INTEGER   NO-UNDO. /* pos of {logical}   */
  DEFINE VARIABLE qbf_5 AS INTEGER   NO-UNDO. /* pos of {decimal}   */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap */

  IF qbf-f THEN DO:
    RUN before_fields (0).
    RETURN.
  END.

  FIND LAST qbf-w NO-ERROR.

  qbf_c = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).
  IF qbf_c = "" THEN DO:
    RUN before_initial (qbf-w.qbf-t). /* load up expressions */
    RETURN.
  END.

  ASSIGN
    qbf_1 = INDEX(qbf-w.qbf-e,qbf-left + "string":u  + qbf-right)
    qbf_2 = INDEX(qbf-w.qbf-e,qbf-left + "date":u    + qbf-right)
    qbf_3 = INDEX(qbf-w.qbf-e,qbf-left + "logical":u + qbf-right)
    qbf_5 = INDEX(qbf-w.qbf-e,qbf-left + "number":u  + qbf-right)
    qbf_i = MAXIMUM(qbf_1,qbf_2,qbf_3,qbf_5).

  IF qbf_1 > 0 AND qbf_1 < qbf_i THEN qbf_i = qbf_1.
  IF qbf_2 > 0 AND qbf_2 < qbf_i THEN qbf_i = qbf_2.
  IF qbf_3 > 0 AND qbf_3 < qbf_i THEN qbf_i = qbf_3.
  IF qbf_5 > 0 AND qbf_5 < qbf_i THEN qbf_i = qbf_5.

  CASE qbf_i:
    WHEN 0 THEN DO:
      qbf-b = qbf_u.
      &if {&ContinueWorking} &then
      IF NOT qbf-b THEN
	RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b,"question":u,"yes-no":u,
	  "Do you want to continue working with this expression?").
      &endif
      IF qbf-b THEN
	RUN before_adding (qbf-w.qbf-t).
      ELSE DO:
	APPLY "ENTRY":u TO qbf-4 IN FRAME qbf%express.
	ASSIGN
	  qbf-h:SCREEN-VALUE IN FRAME qbf%express = qbf-m[9] /* OK when done */
	  qbf-s:SENSITIVE IN FRAME qbf%express    = FALSE
	  qbf-s:LIST-ITEMS IN FRAME qbf%express   = "".
      END.
    END.
    WHEN qbf_1 THEN DO:
      IF qbf-w.qbf-a = "m":u THEN
	RUN before_middle ("s":u).
      ELSE
	RUN before_fields (1).
      RUN highlight (qbf-left + "string":u + qbf-right).
    END.
    WHEN qbf_2 THEN DO:
      IF qbf-w.qbf-a = "m":u THEN
	RUN before_middle ("d":u).
      ELSE
	RUN before_fields (2).
      RUN highlight (qbf-left + "date":u + qbf-right).
    END.
    WHEN qbf_3 THEN DO:
      IF qbf-w.qbf-a = "m":u THEN
	RUN before_middle ("l":u).
      ELSE
	RUN before_fields (3).
      RUN highlight (qbf-left + "logical":u + qbf-right).
    END.
    WHEN qbf_5 THEN DO:
      IF qbf-w.qbf-a = "m":u THEN
	RUN before_middle ("n":u).
      ELSE
	RUN before_fields (5).
      RUN highlight (qbf-left + "number":u + qbf-right).
    END.
  END CASE.

END PROCEDURE. /* heuristic */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*
This selects the passed string in the 4GL edit area.  If the string is
not present, it moves the insertion point to the end of the edit area.
*/

PROCEDURE highlight:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO.

  IF qbf-4:SCREEN-VALUE IN FRAME qbf%express BEGINS qbf_s THEN
    qbf-b = qbf-4:SET-SELECTION(1,LENGTH(qbf_s,"CHARACTER":u) + 1) 
	      IN FRAME qbf%express.
  ELSE DO:
    ASSIGN
      qbf-4:CURSOR-OFFSET IN FRAME qbf%express = 1
      qbf-b = qbf-4:SEARCH(qbf_s,FIND-NEXT-OCCURRENCE) IN FRAME qbf%express
      qbf_i = qbf-4:CURSOR-OFFSET IN FRAME qbf%express.
    IF qbf-b THEN
      qbf-b = qbf-4:SET-SELECTION(qbf_i - LENGTH(qbf_s,"CHARACTER":u), qbf_i)
	      IN FRAME qbf%express.
    ELSE
      qbf-4:CURSOR-OFFSET IN FRAME qbf%express
	= LENGTH(qbf-4:SCREEN-VALUE IN FRAME qbf%express,"CHARACTER":u).
  END.
END PROCEDURE. /* highlight */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*
Figure out the most appropriate help message by matching the current
4GL code to the function templates, moving in reverse chronological
order until a match is made.
*/

PROCEDURE guess_help:
  DEFINE VARIABLE qbf_4 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_p AS CHARACTER NO-UNDO.

  IF qbf-f THEN DO:
    qbf-h:SCREEN-VALUE IN FRAME qbf%express = qbf-m[9]. /* OK when done */
    RETURN.
  END.

  FIND LAST qbf-w.
  DO WHILE AVAILABLE qbf-w:
    DO WHILE AVAILABLE qbf-w AND qbf-w.qbf-p = 0:
      FIND PREV qbf-w NO-ERROR.
    END.
    IF NOT AVAILABLE qbf-w THEN return.

    qbf_4 = TRIM(qbf-4:SCREEN-VALUE IN FRAME qbf%express).

    DO qbf_i = 6 TO LENGTH(ENTRY(2,qbf-x[qbf-w.qbf-p],"|":u),
			   "CHARACTER":u) BY 4:
      ASSIGN
	qbf_j = (qbf_i - 2) / 4
	qbf_c = SUBSTRING(ENTRY(2,qbf-x[qbf-w.qbf-p],"|":u),qbf_i,1,
			  "CHARACTER":u)
	qbf_p = (IF qbf_c = "s":u THEN qbf-left + "string":u  + qbf-right
	    ELSE IF qbf_c = "d":u THEN qbf-left + "date":u    + qbf-right
	    ELSE IF qbf_c = "l":u THEN qbf-left + "logical":u + qbf-right
	    ELSE                       qbf-left + "number":u  + qbf-right)
	qbf_c = SUBSTITUTE(ENTRY(3,qbf-x[qbf-w.qbf-p],"|":u),
		IF qbf_j = 1 THEN qbf_p ELSE "*":u,
		IF qbf_j = 2 THEN qbf_p ELSE "*":u,
		IF qbf_j = 3 THEN qbf_p ELSE "*":u,
		IF qbf_j = 4 THEN qbf_p ELSE "*":u,
		IF qbf_j = 5 THEN qbf_p ELSE "*":u,
		IF qbf_j = 6 THEN qbf_p ELSE "*":u,
		IF qbf_j = 7 THEN qbf_p ELSE "*":u,
		IF qbf_j = 8 THEN qbf_p ELSE "*":u,
		IF qbf_j = 9 THEN qbf_p ELSE "*":u)
	qbf_c = (IF qbf_c BEGINS "*":u THEN "" ELSE "*":u) + qbf_c 
	      + (IF SUBSTRING(qbf_c,LENGTH(qbf_c,"CHARACTER":u),-1,
			      "CHARACTER":u) = "*":u THEN "" ELSE "*":u).
      &if {&debug} &then
      PUT UNFORMATTED "qbf_c=[":u qbf_c "]":u SKIP.
      &endif

      IF qbf_4 MATCHES qbf_c THEN LEAVE.
      qbf_j = 0.
    END.

    &if {&debug} &then
    OUTPUT CLOSE.
    &endif

    IF qbf_j > 0 THEN DO:
      ASSIGN
	qbf_c = SUBSTRING(ENTRY(2,qbf-x[qbf-w.qbf-p],"|":u),qbf_i + 1,3,
			  "CHARACTER":u)
	qbf-h:SCREEN-VALUE IN FRAME qbf%express = qbf-x[INTEGER(qbf_c)].
      RETURN.
    END.
    FIND PREV qbf-w NO-ERROR.
  END.
END PROCEDURE. /* guess_help */

/*--------------------------------------------------------------------------*/

&if {&debug} &then
  procedure gronk using qbf-w:
    output to gronk append.
    put unformatted string(time,"hh:mm:ss") "--"
      program-name(1) fill("-",62 - LENGTH(program-name(1),"CHARACTER":u)) skip.
    for each qbf-w by qbf-w.qbf-q:
      export qbf-w.
    end.
  end procedure. /* gronk */
&endif

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/* s-exp.p - end of file */

