/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* y-const.i - shell for constant-entry routines */
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{aderes/reshlp.i}    /* RESULTS help  */
{adecomm/commeng.i}  /* Help contexts */

/*
Used in _y-date.p, _y-num.p and _y-strng.p, which are called by
y-where.p (where-builder) and s-exp.p (expression builder).

Parameters are:
  DefaultFormat - format to use when pi_fmt = ?
  DataType      - datatype & modifiers for def var stmt
  InitialValue  - initial value
  PackageOne    - how to convert value to canonical 4gl string for return
  PackageTwo    - same, but for two values
  Message       - "Enter <datatype> Value" string
  Function      - DECIMAL, DATE or STRING - to convert CHARACTER to {&DataType}
*/

OUTPUT TO TERMINAL. /* needed for RESULTS use */

DEFINE INPUT  PARAMETER pi_mode AS INTEGER             NO-UNDO. /* 1,2 or >2 */
DEFINE INPUT  PARAMETER pi_fmt  AS CHARACTER           NO-UNDO. /* format */
DEFINE INPUT  PARAMETER pi_text AS CHARACTER           NO-UNDO. /* Message */
DEFINE OUTPUT PARAMETER po_out  AS CHARACTER INITIAL ? NO-UNDO. /* value */
DEFINE OUTPUT PARAMETER po_inclusive AS LOGICAL INITIAL YES NO-UNDO. 
/*
pi_mode =  1 -> get a single value from the user
        =  2 -> get two values - upper and lower range limits
        =  3 -> get a list of values for in-list function
        =  4 -> get a list of values for not-in-list function
        =  5 -> same as pi_mode = 1, for RESULTS Ask At Run Time
If the pi_mode number is negative, then support the ask-at-run-time mode.
*/

DEFINE VARIABLE qbf-h  AS INTEGER     NO-UNDO. /* help define */
DEFINE VARIABLE qbf-i  AS INTEGER     NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l  AS LOGICAL     NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s  AS CHARACTER   NO-UNDO. /* selection-list */
DEFINE VARIABLE v_text AS CHARACTER   NO-UNDO. /* text */
DEFINE VARIABLE v_more AS CHARACTER   NO-UNDO. /* more text */
DEFINE VARIABLE v_one  AS {&DataType} NO-UNDO. /* value holder */
DEFINE VARIABLE v_two  AS {&DataType} NO-UNDO. /* 2nd value holder */

DEFINE BUTTON qbf-ok   LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"   {&STDPH_OKBTN}. 
DEFINE BUTTON qbf-ad   LABEL "&Add"    {&STDPH_OKBTN}.
DEFINE BUTTON qbf-ch   LABEL "&Change" {&STDPH_OKBTN}.
DEFINE BUTTON qbf-rm   LABEL "&Remove" {&STDPH_OKBTN}.

DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
define variable WtitleConstant as character initial "Enter Constant":t32.
define variable WtitleConstantRange as character initial "Enter Constant":t32.
define variable WtitleListConstant as character initial "Enter List of Constants":t32.

FORM
  SKIP({&TFM_WID})
  SPACE(1) v_text FORMAT "x(50)":u VIEW-AS TEXT SKIP
  SPACE(1) v_one  FORMAT "{&DefaultFormat}":u  SKIP({&VM_WIDG})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf%one NO-LABELS NO-ATTR-SPACE THREE-D WIDTH 55
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  &if DEFINED(IDE-IS-RUNNING) = 0 &then
  TITLE WtitleConstant  VIEW-AS DIALOG-BOX
   &else
        NO-BOX
   &endif 
  .

FORM
  SKIP({&TFM_WID})
  SPACE(1) v_text FORMAT "x(50)":u VIEW-AS TEXT SKIP
  SPACE(1) v_one  FORMAT "{&DefaultFormat}":u SKIP({&VM_WIDG})
  SPACE(1) v_more FORMAT "x(50)":u VIEW-AS TEXT SKIP
  SPACE(1) v_two  FORMAT "{&DefaultFormat}":u SKIP({&VM_WIDG})
  SPACE(1) po_inclusive VIEW-AS TOGGLE-BOX LABEL "&Inclusive"

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf%two NO-LABELS NO-ATTR-SPACE THREE-D WIDTH 55
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  &if DEFINED(IDE-IS-RUNNING) = 0 &then
  TITLE WtitleConstantRange VIEW-AS DIALOG-BOX
   &else
        NO-BOX
   &endif
  .

/*
Enter a value:
<____________________>

          +------------------------+
          |    "xxxxxxxx"          |
[_Add__]  | OR "xxxxxxx"           |
          | OR "xxxxx"             |
[Change]  | OR "xxxxxxxxxx"        |
          | OR "xxxx"              |
[Remove]  | OR "xxxxxxxxxxx"       |
          | OR "xxxxxxxx"          |
          +------------------------+

[__OK__] [Cancel] [Help]
*/
FORM
  SKIP({&TFM_WID}) SPACE(1)
  v_text FORMAT "x(50)":u VIEW-AS TEXT SKIP({&VM_WID}) SPACE(1) 
  v_one  FORMAT "{&DefaultFormat}":u SKIP({&VM_WID}) SPACE(1) 
  qbf-ad at 4 SPACE ({&HM_BTN}) 
  qbf-ch SPACE ({&HM_BTN}) 
  qbf-rm SKIP({&VM_WID}) SPACE(1) 

  qbf-s  VIEW-AS SELECTION-LIST INNER-CHARS 48 INNER-LINES 8
    SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL

  SKIP({&TFM_WID}) SPACE(1) 
  po_inclusive VIEW-AS TOGGLE-BOX LABEL "&Inclusive"

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf%thr NO-LABELS NO-ATTR-SPACE THREE-D WIDTH 55
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  &if DEFINED(IDE-IS-RUNNING) = 0 &then
  TITLE WtitleListConstant VIEW-AS DIALOG-BOX
   &else
        NO-BOX
   &endif
  .

ON GO OF FRAME qbf%thr OR CHOOSE OF qbf-ok IN FRAME qbf%thr DO:
  IF qbf-s:LOOKUP(INPUT FRAME qbf%thr v_one) = 0 AND
    (IF "{&Function}":u <> "date":u THEN
       INPUT FRAME qbf%thr v_one <> {&InitialValue} 
     ELSE
       INPUT FRAME qbf%thr v_one <> "") THEN
    qbf-l = qbf-s:ADD-LAST(v_one:SCREEN-VALUE IN FRAME qbf%thr) 
                  IN FRAME qbf%thr.

  ASSIGN
    po_out       = qbf-s:LIST-ITEMS IN FRAME qbf%thr
    po_Inclusive = IF po_Inclusive:SCREEN-VALUE IN FRAME qbf%thr = "yes" 
                   THEN TRUE ELSE FALSE
    v_one:SCREEN-VALUE IN FRAME qbf%thr = ENTRY(1, po_out)
    qbf-ch:SENSITIVE IN FRAME qbf%thr = qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
    qbf-rm:SENSITIVE IN FRAME qbf%thr = qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?    .
    /* this gets out of format-checking when v_one is blank? */
END.

ON CHOOSE OF qbf-ad IN FRAME qbf%thr DO:
  RUN is_new_value (OUTPUT qbf-l).
  IF qbf-l THEN DO:
    qbf-l = qbf-s:ADD-LAST(v_one:SCREEN-VALUE IN FRAME qbf%thr) 
      IN FRAME qbf%thr.
    ASSIGN 
      v_one:SCREEN-VALUE IN FRAME qbf%thr = 
        (IF "{&Function}":u = "date":u THEN "" ELSE STRING({&InitialValue}))
      qbf-ch:SENSITIVE IN FRAME qbf%thr = 
        qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
      qbf-rm:SENSITIVE IN FRAME qbf%thr = 
        qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?.
  END.
  APPLY "ENTRY":u TO v_one IN FRAME qbf%thr. 
END.

ON CHOOSE OF qbf-ch IN FRAME qbf%thr DO:
  RUN is_new_value (OUTPUT qbf-l).
  IF qbf-l THEN
    ASSIGN
      qbf-l = (IF qbf-s:SCREEN-VALUE IN FRAME qbf%thr = ? THEN
        qbf-s:ADD-LAST(v_one:SCREEN-VALUE IN FRAME qbf%thr) IN FRAME qbf%thr
        ELSE
          qbf-s:REPLACE(v_one:SCREEN-VALUE IN FRAME qbf%thr,
          qbf-s:SCREEN-VALUE IN FRAME qbf%thr) IN FRAME qbf%thr)
          v_one:SCREEN-VALUE IN FRAME qbf%thr = STRING({&InitialValue})
      qbf-ch:SENSITIVE IN FRAME qbf%thr = 
        qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
      qbf-rm:SENSITIVE IN FRAME qbf%thr = 
        qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
      .
  APPLY "ENTRY":u TO v_one IN FRAME qbf%thr.
END.

ON CHOOSE OF qbf-rm IN FRAME qbf%thr DO:
  IF qbf-s:SCREEN-VALUE <> ? THEN
    qbf-l = qbf-s:DELETE(qbf-s:SCREEN-VALUE).

  IF v_one:SCREEN-VALUE <> ? THEN
    v_one:SCREEN-VALUE = "".
  ASSIGN 
    qbf-ch:SENSITIVE IN FRAME qbf%thr = 
      qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
    qbf-rm:SENSITIVE IN FRAME qbf%thr = 
      qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?.

  APPLY "ENTRY":u TO v_one.
END.

ON VALUE-CHANGED OF qbf-s IN FRAME qbf%thr DO:
  v_one:SCREEN-VALUE IN FRAME qbf%thr = qbf-s:SCREEN-VALUE IN FRAME qbf%thr.
  ASSIGN qbf-ch:SENSITIVE IN FRAME qbf%thr = qbf-s:SCREEN-VALUE NE ""
         qbf-rm:SENSITIVE IN FRAME qbf%thr = qbf-s:SCREEN-VALUE NE "".
  APPLY "ENTRY":u TO v_one IN FRAME qbf%thr.
END.

/*---------------------------------------------------------------------------*/
 
IF pi_fmt <> ? THEN DO:
  ASSIGN
    pi_fmt = REPLACE(REPLACE(pi_fmt,"%":u,"":u),",":u,"":u) 
    v_one:FORMAT IN FRAME qbf%one = pi_fmt
    v_one:FORMAT IN FRAME qbf%two = pi_fmt        
    
    v_two:FORMAT IN FRAME qbf%two = pi_fmt
    v_one:FORMAT IN FRAME qbf%thr = pi_fmt

    /* This prevents the g,p,j,y descenders from getting chopped off */
    v_one:HEIGHT IN FRAME qbf%one = 1
    v_one:HEIGHT IN FRAME qbf%two = 1
    v_two:HEIGHT IN FRAME qbf%two = 1
    v_one:HEIGHT IN FRAME qbf%thr = 1

    v_one:WIDTH IN FRAME qbf%one = MIN(v_one:WIDTH IN FRAME qbf%one, 50)
    v_one:WIDTH IN FRAME qbf%two = MIN(v_one:WIDTH IN FRAME qbf%two, 50)
    v_two:WIDTH IN FRAME qbf%two = MIN(v_two:WIDTH IN FRAME qbf%two, 50)
    v_one:WIDTH IN FRAME qbf%thr = MIN(v_one:WIDTH IN FRAME qbf%thr, 50).
END.
ELSE IF "{&DataType}" BEGINS "CHAR":U THEN
   ASSIGN v_one:FORMAT IN FRAME qbf%one = "X(250)":U
          v_one:FORMAT IN FRAME qbf%two = "X(250)":U
          v_one:FORMAT IN FRAME qbf%thr = "X(250)":U
          v_two:FORMAT IN FRAME qbf%two = "X(250)":U.

pi_mode = ABSOLUTE(pi_mode).

CASE ENTRY(1,"{&DataType}":u," ":u):
  WHEN "DATE":u    THEN
    ASSIGN qbf-h = {&Enter_Constant_Date}
           v_one:COLUMN IN FRAME qbf%one = 18
           v_one:COLUMN IN FRAME qbf%two = 18
           v_one:COLUMN IN FRAME qbf%thr = 18
           v_two:COLUMN IN FRAME qbf%two = 18.
  WHEN "DECIMAL":u THEN
    ASSIGN qbf-h = {&Enter_Constant_Number}
           v_one:COLUMN IN FRAME qbf%one = 18
           v_one:COLUMN IN FRAME qbf%two = 18
           v_one:COLUMN IN FRAME qbf%thr = 18
           v_two:COLUMN IN FRAME qbf%two = 18.
  OTHERWISE
    ASSIGN qbf-h = {&Enter_Constant_String}
           v_one:WIDTH IN FRAME qbf%one = 50
           v_one:WIDTH IN FRAME qbf%two = 50
           v_one:WIDTH IN FRAME qbf%thr = 50
           v_two:WIDTH IN FRAME qbf%two = 50.
END CASE.

IF pi_mode = 1 OR pi_mode = 5 THEN DO: /*-------------*/ 
  ASSIGN
    v_text = (IF pi_text = ? THEN TRIM("{&Message}":t55) + ":":u ELSE pi_text)

    v_one                           = {&InitialValue}
    v_text:FORMAT IN FRAME qbf%one  = "x(":u 
                                    + STRING(LENGTH(v_text,"RAW":U) + 1) 
                                    + ")":u
    v_text:SCREEN-VALUE IN FRAME qbf%one = v_text
    qbf-i                           = v_text:X IN FRAME qbf%one
                                    + MAXIMUM(
                                        v_text:WIDTH-PIXELS IN FRAME qbf%one,
                                        v_one:WIDTH-PIXELS IN FRAME qbf%one 
                                    + 10,
      /* This is based on the postion of the cancel button
      ** plus the width of that button plus the magin expressed
      ** in PPU and then convert into pixels
      ** assumption is cancel button is 1 PPU high */
      qbf-help:x + qbf-help:width-pixels 
                + (qbf-help:height-pixels * {&VM_OKBOX} * 2)).
/*
    FRAME qbf%one:WIDTH-PIXELS      = qbf-i. */
    
  IF pi_mode = 5 THEN 
    ASSIGN 
      FRAME qbf%one:TITLE = "Ask At Run Time Prompt":t32
      qbf-h               = {&Ask_At_Run_Time_Prompt_Dlg_Box}.    

  &if DEFINED(IDE-IS-RUNNING) = 0 &then    
  ASSIGN FRAME qbf%thr:PARENT = ACTIVE-WINDOW.
  &else  
  {adeuib/ide/dialoginit.i "FRAME qbf%one:handle}
   &endif
  /* Run time layout for button area.  This defines eff_frame_width */
  {adecomm/okrun.i  
     &FRAME = "FRAME qbf%one" 
     &BOX   = "rect_btns"
     &OK    = "qbf-ok"
     &HELP  = "qbf-help" }

  ON HELP OF FRAME qbf%one OR CHOOSE OF qbf-help IN FRAME qbf%one
    RUN adecomm/_adehelp.p (IF pi_mode = 5 THEN "res":u ELSE "comm":u, 
                            "CONTEXT":u, qbf-h, ?).

  ON WINDOW-CLOSE OF FRAME qbf%one
    APPLY "END-ERROR":u TO SELF.

  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    v_one:WIDTH IN FRAME qbf%one = v_one:WIDTH IN FRAME qbf%one + 1.
    
     &if DEFINED(IDE-IS-RUNNING) <> 0 &then   
     &scoped-define CANCEL-EVENT U3
     {adeuib/ide/dialogstart.i qbf-ok qbf-ee WtitleConstant}
     display v_one
               WITH FRAME qbf%one.
     enable v_one qbf-ok qbf-ee qbf-help   
               WITH FRAME qbf%one.
     WAIT-FOR GO OF FRAME qbf%one or choose of qbf-ok or "{&CANCEL-EVENT}" of this-procedure focus v_one.   
     if cancelDialog then undo, leave.  
     assign FRAME qbf%one v_one.
     &undefine CANCEL-EVENT

     &else
    UPDATE
      v_one qbf-ok qbf-ee qbf-help 
      WITH FRAME qbf%one.
    &endif   
    &IF "{&DataType}" EQ "CHARACTER" &THEN
    IF v_one = ? THEN v_one = "".
    &ENDIF
    po_out = {&PackageOne}.
  END.
END.
ELSE IF pi_mode = 2 THEN DO: /*----------------------------------------*/
  ASSIGN
    v_text = (IF pi_text = ? THEN
               TRIM("Enter &Lower Bound":t40) + ":":u
             ELSE
               ENTRY(1,pi_text,CHR(10))
             )
    v_more = (IF pi_text = ? THEN
               TRIM("and &Upper Bound":t40)   + ":":u
             ELSE
               ENTRY(2,pi_text,CHR(10))
             )
    v_one                          = {&InitialValue}
    v_two                          = {&InitialValue}
    v_text:FORMAT IN FRAME qbf%two = "x(":u 
                                   + STRING(LENGTH(v_text,"RAW":U) + 1) 
                                   + ")":u
    v_more:FORMAT IN FRAME qbf%two = "x(":u 
                                   + STRING(LENGTH(v_more,"RAW":U) + 1) 
                                   + ")":u
    v_text:SCREEN-VALUE  IN FRAME qbf%two = v_text
    v_more:SCREEN-VALUE  IN FRAME qbf%two = v_more
    qbf-i                          = v_text:X IN FRAME qbf%two
                                   + MAXIMUM(
                                       v_text:WIDTH-PIXELS IN FRAME qbf%two,
                                       v_more:WIDTH-PIXELS IN FRAME qbf%two,
                                       v_one:WIDTH-PIXELS IN FRAME qbf%two + 10,
      /* This is based on the postion of the help button
      ** plus the widht of that button plus the magin expressed
      ** in PPU and then convert into pixels
      ** assumption is help button is 1 PPU high */
      qbf-help:X + qbf-help:WIDTH-PIXELS 
                 + (qbf-help:HEIGHT-PIXELS * {&VM_OKBOX} * 2)).
/*
    FRAME qbf%two:WIDTH-PIXELS     = qbf-i. */
  &if DEFINED(IDE-IS-RUNNING) = 0 &then    
  ASSIGN FRAME qbf%two:PARENT = ACTIVE-WINDOW.
  &else  
  {adeuib/ide/dialoginit.i "FRAME qbf%two:handle}
   &endif
  /* Run time layout for button area.  This defines eff_frame_width */
  {adecomm/okrun.i  
    &FRAME = "FRAME qbf%two" 
    &BOX   = "rect_btns"
    &OK    = "qbf-ok"
    &HELP  = "qbf-help" }

  ON ALT-L OF FRAME qbf%two
    APPLY "ENTRY":u TO v_one IN FRAME qbf%two.

  ON ALT-U OF FRAME qbf%two
    APPLY "ENTRY":u TO v_two IN FRAME qbf%two.

  ON HELP OF FRAME qbf%two OR CHOOSE OF qbf-help IN FRAME qbf%two 
    RUN adecomm/_adehelp.p ("comm":u, "CONTEXT":u, {&Enter_Constant_Range}, ?).

  ON WINDOW-CLOSE OF FRAME qbf%two
    APPLY "END-ERROR" TO SELF.

  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    ASSIGN v_one:WIDTH IN FRAME qbf%two = v_one:WIDTH IN FRAME qbf%two + 1
           v_two:WIDTH IN FRAME qbf%two = v_two:WIDTH IN FRAME qbf%two + 1.
    &if DEFINED(IDE-IS-RUNNING) <> 0 &then   
     &scoped-define CANCEL-EVENT U5
     {adeuib/ide/dialogstart.i  qbf-ok qbf-ee  WtitleConstantRange}
     display v_one v_two po_Inclusive WITH FRAME qbf%two.
     enable v_one v_two po_Inclusive qbf-ok qbf-ee qbf-help WITH FRAME qbf%two.
     WAIT-FOR GO OF FRAME qbf%two or choose of qbf-ok or "{&CANCEL-EVENT}" of this-procedure focus v_one.   
     if cancelDialog then undo, leave.  
     assign FRAME qbf%two v_one  FRAME qbf%two v_two FRAME qbf%two po_Inclusive.
     &undefine CANCEL-EVENT
     &else       
    UPDATE
      v_one v_two po_Inclusive qbf-ok qbf-ee qbf-help 
      WITH FRAME qbf%two.
    &endif
    &IF "{&DataType}" EQ "CHARACTER" &THEN
    IF v_one = ? THEN v_one = "?":U.
    IF v_two = ? THEN v_two = "?":U.
    &ENDIF

    IF v_one > v_two THEN DO:
      MESSAGE "The Lower Bound may not be greater than the Upper Bound."
              VIEW-AS ALERT-BOX ERROR.
      UNDO, RETRY.
    END.
    IF NOT po_Inclusive AND v_one = v_two THEN DO:
      MESSAGE "The Lower Bound may not be equal to the Upper Bound," SKIP
              "unless inclusive is checked." VIEW-AS ALERT-BOX ERROR.
      UNDO, RETRY.
    END.
    
    ASSIGN
      po_Inclusive = IF po_Inclusive:SCREEN-VALUE IN FRAME qbf%two = "yes" 
                     THEN TRUE ELSE FALSE
      po_out       = {&PackageTwo}.
  END.
END.
ELSE DO: /*-----------------------------------------------------------------*/
  ASSIGN
/*  FRAME qbf%thr:WIDTH                = v_one:WIDTH-CHARS IN FRAME qbf%thr
                                       + 20 */
    std_fillin_bgcolor                 = IF SESSION:THREE-D THEN ? ELSE 8

    /* This is based on the position of the help button plus the width of
       that button plus the margin expressed in PPU and then converted 
       into pixels.  Assumption is help button is 1 PPU high. */
    qbf-i = MAXIMUM(
            v_text:WIDTH-PIXELS IN FRAME qbf%thr,
            v_one:WIDTH-PIXELS IN FRAME qbf%thr + 10,
            qbf-s:WIDTH-PIXELS IN FRAME qbf%thr,
            qbf-rm:X + qbf-help:WIDTH-PIXELS 
              + (qbf-help:HEIGHT-PIXELS * {&VM_OKBOX} * 2))

/*    FRAME qbf%thr:WIDTH-PIXELS         = qbf-i 
                                       + (qbf-s:X IN FRAME qbf%thr * 2) */
    v_one:FORMAT IN FRAME qbf%thr = REPLACE(v_one:FORMAT IN FRAME qbf%thr,"!":U,
                                            "X":U).

  &if DEFINED(IDE-IS-RUNNING) = 0 &then    
  ASSIGN FRAME qbf%thr:PARENT = ACTIVE-WINDOW.
  &else  
  {adeuib/ide/dialoginit.i "FRAME qbf%thr:handle}
   &endif
  /* Run time layout for button area.  This defines eff_frame_width */
  {adecomm/okrun.i  
     &FRAME = "FRAME qbf%thr" 
     &BOX   = "rect_btns"
     &OK    = "qbf-ok"
     &HELP  = "qbf-help" }

  /* do this after okrun.i, since this will realize frame qbf%thr, making
     it impossible to set three-d */
  ASSIGN
/*  qbf-s:INNER-CHARS IN FRAME qbf%thr   = v_one:WIDTH-CHARS IN FRAME qbf%thr */
    v_text                               = (IF pi_text = ? 
                                            THEN TRIM("{&Message}":t55) + ":":u 
                                            ELSE pi_text)
    v_text:FORMAT IN FRAME qbf%thr       = "x(":u 
                                         + STRING(LENGTH(v_text,"RAW":U) + 1) 
                                         + ")":u
    v_text:SCREEN-VALUE IN FRAME qbf%thr = v_text
    v_one                                = {&InitialValue}
    .

  ON HELP OF FRAME qbf%thr OR CHOOSE OF qbf-help IN FRAME qbf%thr
    RUN adecomm/_adehelp.p ("comm":u, "CONTEXT":u, {&Enter_Constants_List}, ?).

  ON WINDOW-CLOSE OF FRAME qbf%thr
    APPLY "END-ERROR" TO SELF.

  po_out = ?.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    ASSIGN v_one:WIDTH IN FRAME qbf%thr = v_one:WIDTH IN FRAME qbf%thr + 1.
    
     &if DEFINED(IDE-IS-RUNNING) <> 0 &then   
      &scoped-define CANCEL-EVENT U5
     {adeuib/ide/dialogstart.i  qbf-ok qbf-ee WtitleListConstant}
     display  v_one qbf-ad qbf-ch WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
              qbf-rm WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?  
              
               WITH FRAME qbf%thr.
     enable  v_one qbf-ad qbf-ch WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
              qbf-rm WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?  
              qbf-s qbf-ok qbf-ee qbf-help po_Inclusive
               WITH FRAME qbf%thr.
     WAIT-FOR GO OF FRAME qbf%thr or choose of qbf-ok or "{&CANCEL-EVENT}" of this-procedure focus v_one.   
     if cancelDialog then undo, leave.  
     assign FRAME qbf%thr v_one. 
     &undefine CANCEL-EVENT
    &else
    UPDATE
      v_one qbf-ad qbf-ch WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ?
                   qbf-rm WHEN qbf-s:SCREEN-VALUE IN FRAME qbf%thr NE ? 
                   qbf-s qbf-ok qbf-ee qbf-help po_Inclusive
      WITH FRAME qbf%thr.
    &endif  
    po_out = REPLACE(po_out,",":u,CHR(10)).
  END.

  DO qbf-i = 1 TO NUM-ENTRIES(po_out,CHR(10)):
    ASSIGN
      v_one        = {&Function}(ENTRY(qbf-i,po_out,CHR(10)))
      po_Inclusive = IF po_Inclusive:SCREEN-VALUE IN FRAME qbf%thr = "yes" 
                     THEN TRUE ELSE FALSE
      ENTRY(qbf-i,po_out,CHR(10)) = {&PackageOne}.
  END.
END. /*---------------------------------------------------------------------*/

HIDE FRAME qbf%one NO-PAUSE.
HIDE FRAME qbf%two NO-PAUSE.
HIDE FRAME qbf%thr NO-PAUSE.

/*---------------------------------------------------------------------------*/
PROCEDURE is_new_value:
  DEFINE OUTPUT PARAMETER qbf_o AS LOGICAL INITIAL FALSE NO-UNDO.
  DEFINE VARIABLE qbf_v AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE qbf_s AS WIDGET-HANDLE NO-UNDO.

  ASSIGN
    qbf_v = v_one:SCREEN-VALUE IN FRAME qbf%thr
    qbf_s = qbf-s:HANDLE IN FRAME qbf%thr
    qbf_o = (qbf_s:LOOKUP(qbf_v) = 0 OR qbf_s:LOOKUP(qbf_v) = ?)
            AND qbf_v <> ?
            AND qbf_v <> "".

END PROCEDURE. /* is_new_value */

/* y-const.i - end of file */

