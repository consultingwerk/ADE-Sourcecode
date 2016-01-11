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
/* y-format.p - properties, formerly the formats & label */

&GLOBAL-DEFINE WIN95-BTN YES
&GLOBAL-DEFINE SupportJustify FALSE

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/y-define.i }
{ aderes/fbdefine.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT  PARAMETER qbf-p   AS INTEGER NO-UNDO. /* initial */
DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

DEFINE VARIABLE qbf-4gl AS CHARACTER NO-UNDO. /* 4GL expression */
DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-dt  AS CHARACTER NO-UNDO. /* display-only text */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f   AS CHARACTER NO-UNDO. /* format */
DEFINE VARIABLE qbf-h   AS LOGICAL   NO-UNDO. /* hide repeat values? */
DEFINE VARIABLE qbf-l   AS CHARACTER NO-UNDO. /* column-label */
DEFINE VARIABLE qbf-n   AS CHARACTER NO-UNDO. /* field name */
DEFINE VARIABLE qbf-sv  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-t   AS HANDLE    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-x   AS DECIMAL   NO-UNDO. /* column */
DEFINE VARIABLE qbf-y   AS DECIMAL   NO-UNDO. /* row */

DEFINE VARIABLE cnt     AS INTEGER   NO-UNDO. /* # of select list entries */
DEFINE VARIABLE frst    AS INTEGER   NO-UNDO. /* index of 1st fld, select list*/
DEFINE VARIABLE ix      AS INTEGER   NO-UNDO. /* select list entry index */
DEFINE VARIABLE sel-st  AS CHARACTER NO-UNDO. /* 4GL selection */  
DEFINE VARIABLE expchg  AS LOGICAL   NO-UNDO. /* expr was edited */
DEFINE VARIABLE but-nav AS HANDLE    NO-UNDO EXTENT 4. /* navigation button */

DEFINE VARIABLE calc_ix AS INTEGER  NO-UNDO. /* for macro */
&GLOBAL-DEFINE SET_EXPRESSION ~
  qbf-4gl:SCREEN-VALUE IN FRAME qbf%fmt = ~
  (IF calc_ix = 1 OR calc_ix = 2 THEN ~
     ENTRY(2,qbf-rcn[qbf-p]) ~
   ELSE IF calc_ix = 3 THEN ~
     "FROM ":u + ENTRY(2,qbf-rcn[qbf-p]) + " ":u ~
     + "BY ":u  + ENTRY(3,qbf-rcn[qbf-p]) ~
   ELSE IF calc_ix = 8 THEN ~
     ENTRY(2,qbf-rcn[qbf-p]) + "[1 FOR ":u ~
     + SUBSTRING(qbf-rcc[qbf-p],2,-1,"CHARACTER":u) + "]":u ~
   ELSE IF calc_ix > 0 THEN ~
    SUBSTRING(qbf-rcn[qbf-p],INDEX(qbf-rcn[qbf-p],",":u) + 1,-1,"CHARACTER":u) ~
   ELSE ~
     qbf-rcn[qbf-p] ~
   )

&IF {&SupportJustify} &THEN
DEFINE VARIABLE qbf-j AS LOGICAL   NO-UNDO. /* justify text? */
DEFINE VARIABLE qbf-w AS INTEGER   NO-UNDO. /* width of text */
&ENDIF

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

DEFINE BUTTON but-fa LABEL "&Assistant..."  SIZE 15 BY 1.
DEFINE BUTTON but-ed LABEL "&Edit..."       SIZE 11 BY 1.
DEFINE BUTTON but-rn LABEL "Rena&me..."     SIZE 15 BY 1.

DEFINE BUTTON but-ft /*BGCOLOR 8*/
  SIZE-PIXELS &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u
              &THEN 33 BY 25 &ELSE 34 BY 26 &ENDIF
  IMAGE-UP          FILE "adeicon/pvfirst":u
  IMAGE-DOWN        FILE "adeicon/pvfirstd":u
  IMAGE-INSENSITIVE FILE "adeicon/pvfirstx":u.

DEFINE BUTTON but-pv /*BGCOLOR 8*/
  SIZE-PIXELS &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u
              &THEN 33 BY 25 &ELSE 34 BY 26 &ENDIF
  IMAGE-UP          FILE "adeicon/pvback":u
  IMAGE-DOWN        FILE "adeicon/pvbackd":u
  IMAGE-INSENSITIVE FILE "adeicon/pvbackx":u.

DEFINE BUTTON but-nx /*BGCOLOR 8*/
  SIZE-PIXELS &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u
              &THEN 33 BY 25 &ELSE 34 BY 26 &ENDIF
  IMAGE-UP          FILE "adeicon/pvforw":u
  IMAGE-DOWN        FILE "adeicon/pvforwd":u
  IMAGE-INSENSITIVE FILE "adeicon/pvforwx":u.

DEFINE BUTTON but-lt /*BGCOLOR 8*/
  SIZE-PIXELS &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u
              &THEN 33 BY 25 &ELSE 34 BY 26 &ENDIF
  IMAGE-UP          FILE "adeicon/pvlast":u
  IMAGE-DOWN        FILE "adeicon/pvlastd":u
  IMAGE-INSENSITIVE FILE "adeicon/pvlastx":u.

/*---------------------------------------------------------------------------*/

FORM
  SKIP({&TFM_WID})

  qbf-n 
    VIEW-AS COMBO-BOX SIZE 35 BY 1 INNER-LINES 8 
    COLON 12 FORMAT "x(80)":u LABEL "&Name" {&STDPH_FILL}

  but-rn 
  SKIP ({&VM_WID})

  /* The size will be only approximate because of decorations - fix later */
  qbf-f COLON 12 FORMAT "x(80)":u 
    VIEW-AS FILL-IN SIZE 33 BY 1
    LABEL "&Format" {&STDPH_FILL} 
    
  but-fa
  SKIP({&VM_WID})

  qbf-l COLON 12 
    VIEW-AS EDITOR INNER-LINES 2 INNER-CHARS 30 NO-WORD-WRAP 
    SCROLLBAR-V SCROLLBAR-H LABEL "&Label" {&STDPH_FILL}

  qbf-y FORMAT ">>9":u LABEL "&Row" {&STDPH_FILL}
    AT ROW-OF qbf-l + .1 COLUMN 1 SKIP
  qbf-x FORMAT ">>9":u LABEL "&Column" {&STDPH_FILL}
    AT ROW-OF qbf-y + 1 COLUMN 1
  SKIP(.5)

  &IF {&SupportJustify} &THEN
    SKIP
    qbf-j VIEW-AS TOGGLE-BOX LABEL "&Justify Text?"
    SKIP
    qbf-w FORMAT ">>>>":u LABEL "&Width" {&STDPH_FILL}
    SKIP({&VM_WIDG})
  &ENDIF

  qbf-h COLON 12
    VIEW-AS TOGGLE-BOX LABEL "Hide Repeating &Values"
  SKIP(.5)
  
  but-ft AT 1 SPACE(.2)
  but-pv SPACE(.2)
  but-nx SPACE(.2)
  but-lt
  SKIP (.5)

  qbf-dt COLON 12 
    VIEW-AS TEXT FORMAT "x(50)":u LABEL "Data Type"
  SKIP 
  
  qbf-4gl COLON 12 {&STDPH_EDITOR}
    VIEW-AS EDITOR SCROLLBAR-VERTICAL SIZE 52 BY 4 LABEL "Expression"

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help}

  /* repositioned below */
  but-ed AT ROW 1 COLUMN 2

  WITH FRAME qbf%fmt SIDE-LABELS KEEP-TAB-ORDER THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Properties" VIEW-AS DIALOG-BOX.

/*---------------------------------------------------------------------------*/

ON HELP OF FRAME qbf%fmt OR CHOOSE OF qbf-help IN FRAME qbf%fmt
  RUN adecomm/_adehelp.p ("res":u, "CONTEXT":u, {&Properties_Dlg_Box}, ?).

ON HELP OF qbf-4gl DO:
  sel-st = "".
  IF (qbf-4gl:SELECTION-START <> qbf-4gl:SELECTION-END ) THEN
    sel-st = TRIM(TRIM(qbf-4gl:SELECTION-TEXT), ",.;:!? ~"~ '[]()":u).
  RUN adecomm/_adehelp.p ("lgrf":u, "PARTIAL-KEY":u, ?, sel-st).
END.

ON GO OF FRAME qbf%fmt DO:
  RUN save_changes.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.

  IF qbf-module = "f":u AND NOT expchg THEN DO:
    /* Apply the changes directly to the widgets for form mode */
    RUN aderes/f-format.p.
    IF RETURN-VALUE = "error":u THEN
      RETURN NO-APPLY.
    IF RETURN-VALUE = "regen":u THEN
      qbf-chg = TRUE. /* causes U1 to be applied and regen .p after all */
    ELSE
      /* Pretend nothing's changed so we don't break wait-for and 
         regenerate .p.  Since we're faking out caller and returning 
         qbf-chg = false, we have to do this ourselves.
      */
      qbf-dirty = TRUE. 
  END.
  ELSE
    ASSIGN
      qbf-dirty  = TRUE
      qbf-chg    = TRUE
      qbf-redraw = TRUE.
END.

/* change of combo-box value */
ON VALUE-CHANGED OF qbf-n IN FRAME qbf%fmt DO:
    
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = 
      ENTRY(1,qbf-rcn[qbf-i]) THEN LEAVE.
  END.
  
  /* See if they picked the one that was already selected. */
  IF qbf-i = qbf-p THEN 
    RETURN NO-APPLY.

  RUN save_changes.
  
  IF RETURN-VALUE = "error":u THEN DO:
    ASSIGN /* we have to restore combo box value ourselves. */
      qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = ENTRY(1,qbf-rcn[qbf-p]).
    RETURN NO-APPLY.
  END.

  ASSIGN
    ix    = qbf-n:LOOKUP(SELF:SCREEN-VALUE) IN FRAME qbf%fmt
    qbf-p = ix
    .

  RUN prepare_dialog.
END.

ON CHOOSE OF but-ft IN FRAME qbf%fmt DO:
  RUN save_changes.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.
  ASSIGN
    ix    = 1
    qbf-p = 1.
  /* Skip counters and stacked arrays for form view */
  IF qbf-module = "f":u THEN
    DO WHILE CAN-DO("c,e":u,
      SUBSTRING(qbf-rcc[qbf-p],1,1,"CHARACTER":u)) AND qbf-p > 1:
      qbf-p = 1.
    END.
  RUN prepare_dialog.
END.

ON CHOOSE OF but-pv IN FRAME qbf%fmt DO:
  RUN save_changes.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.
  ASSIGN
    ix    = ix - 1
    qbf-p = qbf-p - 1.
  /* Skip counters and stacked arrays for form view */
  IF qbf-module = "f":u THEN
    DO WHILE CAN-DO("c,e":u, 
      SUBSTRING(qbf-rcc[qbf-p],1,1,"CHARACTER":u)) AND qbf-p > 1:
      qbf-p = qbf-p - 1.
    END.
  RUN prepare_dialog.
END.

ON CHOOSE OF but-nx IN FRAME qbf%fmt DO:
  RUN save_changes.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.
  ASSIGN
    ix    = ix + 1
    qbf-p = qbf-p + 1.
  /* Skip counters and stacked arrays for form view */
  IF qbf-module = "f":u THEN
    DO WHILE CAN-DO("c,e":u, 
      SUBSTRING(qbf-rcc[qbf-p],1,1,"CHARACTER":u)) AND qbf-p < qbf-rc#:
      qbf-p = qbf-p + 1.
    END.
  RUN prepare_dialog.
END.

ON CHOOSE OF but-lt IN FRAME qbf%fmt DO:
  RUN save_changes.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.
  ASSIGN
    ix    = cnt
    qbf-p = cnt.
  /* Skip counters and stacked arrays for form view */
  IF qbf-module = "f":u THEN
    DO WHILE CAN-DO("c,e":u,
      SUBSTRING(qbf-rcc[qbf-p],1,1,"CHARACTER":u)) AND qbf-p < qbf-rc#:
      qbf-p = cnt.
    END.
  RUN prepare_dialog.
END.

ON CHOOSE OF but-fa IN FRAME qbf%fmt DO:
  DEFINE VARIABLE qbf_s AS CHARACTER NO-UNDO. /* holds comma-swapped value */
  qbf-f = qbf-f:SCREEN-VALUE IN FRAME qbf%fmt.
  RUN adecomm/_y-build.p (qbf-rct[qbf-p],INPUT-OUTPUT qbf-f).
  IF qbf-f = ? THEN RETURN NO-APPLY.
  qbf_s = qbf-f.
  qbf-f:SCREEN-VALUE IN FRAME qbf%fmt = qbf_s.
  &IF {&SupportJustify} &THEN
    ASSIGN qbf-w = {aderes/s-size.i &type=qbf-rct[qbf-p] 
                                    &format=qbf-f} NO-ERROR.
    ASSIGN
      qbf-w:SCREEN-VALUE IN FRAME qbf%fmt = 
      	 STRING(qbf-w,qbf-w:FORMAT IN FRAME qbf%fmt).
  &ENDIF
END.

ON CHOOSE OF but-ed IN FRAME qbf%fmt DO:
  DEFINE VARIABLE changed AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE calctyp AS CHARACTER NO-UNDO. 
 
  calctyp = SUBSTRING(qbf-rcc[qbf-p],1,1,"CHARACTER":u).
  RUN aderes/s-calc.p (calctyp, qbf-p, OUTPUT changed).

  IF changed THEN 
    ASSIGN
      expchg                              = expchg OR changed
      calc_ix                             = INDEX("rpcsdnlex":u, calctyp)
      /* This is here in case they changed lookup field to a 
         different data type.
      */   
      qbf-f                               = qbf-rcf[qbf-p]
      qbf-f:SCREEN-VALUE IN FRAME qbf%fmt = qbf-f
      qbf-l                               = qbf-rcl[qbf-p]
      qbf-l:SCREEN-VALUE IN FRAME qbf%fmt = qbf-l
      qbf-dt:SCREEN-VALUE IN FRAME qbf%fmt
          = ENTRY(qbf-rct[qbf-p],qbf-dtype)
          + (IF calc_ix = 0 THEN "" 
             ELSE ", ":u + ENTRY(calc_ix + 1,qbf-etype))
      {&SET_EXPRESSION}
      .
END.

ON CHOOSE OF but-rn IN FRAME qbf%fmt DO:
  qbf-sv = qbf-n:SCREEN-VALUE IN FRAME qbf%fmt.

  /* prompt for new name - no duplicates allowed */
  RUN aderes/_renfld.p (qbf-p,qbf-sv,OUTPUT qbf-c,OUTPUT qbf-a).
                       
  IF qbf-sv = qbf-c AND NOT qbf-a THEN 
    RETURN NO-APPLY.

  /* update if used in label view */
  DO qbf-i = 1 TO EXTENT(qbf-l-text):
    IF qbf-l-text[qbf-i] = "" THEN NEXT.

    IF INDEX(qbf-l-text[qbf-i],"~{":u + qbf-sv + "~}":u) > 0 THEN 
      ASSIGN
        qbf-l-text[qbf-i] = REPLACE(qbf-l-text[qbf-i],"~{":u + qbf-sv + "~}":u,
                                                      "~{":u + qbf-c + "~}":u)
        qbf-redraw = IF qbf-module = "l":u THEN TRUE ELSE qbf-redraw.
  END.

  /* update combo-box and qbf-rcn */
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = ENTRY(1,qbf-rcn[qbf-i]) THEN DO:
      ASSIGN
        qbf-a = qbf-n:REPLACE(qbf-c,qbf-n:SCREEN-VALUE IN FRAME qbf%fmt) 
                  IN FRAME qbf%fmt
        qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = qbf-c
        ENTRY(1,qbf-rcn[qbf-i])             = qbf-c
        qbf-dirty                           = TRUE
        .
      LEAVE.
    END.
  END.
END.

ON LEAVE OF qbf-f IN FRAME qbf%fmt DO:
  qbf-f = qbf-f:SCREEN-VALUE IN FRAME qbf%fmt.
  &IF {&SupportJustify} &THEN
    ASSIGN qbf-w = {aderes/s-size.i &type=qbf-rct[qbf-p] 
                                    &format=qbf-f} NO-ERROR.
    ASSIGN
      qbf-w:SCREEN-VALUE IN FRAME qbf%fmt = 
	STRING(qbf-w,qbf-w:FORMAT IN FRAME qbf%fmt).
  &ENDIF
END.

&IF {&SupportJustify} &THEN
ON LEAVE OF qbf-w IN FRAME qbf%fmt DO:
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO.
  ASSIGN
    qbf_c = SUBSTRING(qbf-f:SCREEN-VALUE IN FRAME qbf%fmt,1,1,"CHARACTER":u)
    qbf-f:SCREEN-VALUE IN FRAME qbf%fmt
          = (IF INDEX("xna!9":u,qbf_c) > 0 THEN qbf_c ELSE "x":u)
          + "(":u + STRING(INPUT FRAME qbf%fmt qbf-w) + ")":u.
END.

ON VALUE-CHANGED OF qbf-j IN FRAME qbf%fmt
  ASSIGN
    qbf-w:SENSITIVE IN FRAME qbf%fmt =     INPUT FRAME qbf%fmt qbf-j
    qbf-f:SENSITIVE IN FRAME qbf%fmt = NOT INPUT FRAME qbf%fmt qbf-j.
&ENDIF

ON WINDOW-CLOSE OF FRAME qbf%fmt
  APPLY "END-ERROR":u TO SELF.             

/*--------------------------------------------------------------------------*/

ASSIGN
  qbf-l:RETURN-INSERTED IN FRAME qbf%fmt = TRUE
  qbf-f:WIDTH-PIXELS IN FRAME qbf%fmt    = qbf-n:WIDTH-PIXELS IN FRAME qbf%fmt
  but-fa:COL IN FRAME qbf%fmt            = qbf-f:COL + qbf-f:WIDTH + 1

  qbf-l:WIDTH IN FRAME qbf%fmt    = qbf-n:WIDTH IN FRAME qbf%fmt
  qbf-l:HEIGHT IN FRAME qbf%fmt   = qbf-l:HEIGHT IN FRAME qbf%fmt 
  qbf-4gl:READ-ONLY               = TRUE
  qbf-4gl:WIDTH IN FRAME qbf%fmt  = FRAME qbf%fmt:WIDTH 
                                  - qbf-4gl:COL IN FRAME qbf%fmt 
  but-ed:ROW                      = qbf-4gl:ROW + 1
  but-rn:COL                      = but-fa:COL

  qbf-y:COL                       = but-fa:COL + but-fa:WIDTH - qbf-y:WIDTH
  qbf-t                           = qbf-y:SIDE-LABEL-HANDLE
  qbf-t:COL                       = qbf-y:COL 

  qbf-x:COL                       = qbf-y:COL
  qbf-t                           = qbf-x:SIDE-LABEL-HANDLE
  qbf-t:COL                       = qbf-x:COL 

  but-ft:COL                      = qbf-n:COL
  but-pv:COL                      = but-ft:COL + but-ft:WIDTH + .2
  but-nx:COL                      = but-pv:COL + but-pv:WIDTH + .2
  but-lt:COL                      = but-nx:COL + but-nx:WIDTH + .2
.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%fmt" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* load up selection list */
DO qbf-i = 1 TO qbf-rc#:
  /* Don't show counters and stacked arrays for form view */
  IF qbf-module = "f":u AND CAN-DO("c,e":u, 
    SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) THEN NEXT.

  /* Only show calculated fields for label view */
  IF qbf-module = "l":u AND 
    (qbf-rcc[qbf-i] = "" OR (qbf-rcc[qbf-i] > "" AND
     NOT CAN-DO("s,d,n,l":u,ENTRY(1,qbf-rcc[qbf-i])))) THEN NEXT.

  ASSIGN
    qbf-a = qbf-n:ADD-LAST(ENTRY(1,qbf-rcn[qbf-i])) IN FRAME qbf%fmt
    cnt   = cnt + 1.
  IF frst = 0 THEN 
    frst = qbf-i.
END.

&IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
  qbf-n:INNER-LINES IN FRAME qbf%fmt = cnt.
&ENDIF

/* qbf-p is index into qbf-rcx[]. ix is selection list index. They may
   not match in form mode where some fields aren't displayed in list.  */
ASSIGN
  qbf-index = IF qbf-index = ? THEN 1 ELSE qbf-p /* qbf-index */
  qbf-p     = IF qbf-module = "f":u THEN qbf-index ELSE qbf-p
  qbf-p     = MAXIMUM(qbf-p,frst)
  ix        = qbf-n:LOOKUP(ENTRY(1,qbf-rcn[qbf-p])) IN FRAME qbf%fmt.

ENABLE
  qbf-n qbf-f but-fa qbf-l 
  qbf-h WHEN qbf-module = "r":u
  qbf-y qbf-x
  &IF {&SupportJustify} &THEN
  qbf-j qbf-w
  &ENDIF
  but-ft but-pv but-nx but-lt
  qbf-4gl
  qbf-ok qbf-ee qbf-help
  WITH FRAME qbf%fmt.
  
qbf-a = but-ed:MOVE-AFTER-TAB-ITEM(qbf-4gl:HANDLE IN FRAME qbf%fmt) 
        IN FRAME qbf%fmt.

RUN prepare_dialog.
APPLY "ENTRY":u TO qbf-n IN FRAME qbf%fmt.

DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf%fmt.
END.

HIDE FRAME qbf%fmt NO-PAUSE.
RETURN.

/*--------------------------------------------------------------------------*/

PROCEDURE prepare_dialog:
  ASSIGN
    qbf-n = ENTRY(1,qbf-rcn[qbf-p])

    /* CR's are stored as single exclamations ("!"). Each exclamation
       that the user types is doubled and stored as "!!". So 
       translate back from single and double exclamations to 
       CR's and "!"'s.
    */
    qbf-l = REPLACE(qbf-rcl[qbf-p],"!":u,CHR(10))
    qbf-l = REPLACE(qbf-l,CHR(10) + CHR(10),"!":u)
    qbf-f = qbf-rcf[qbf-p]
    qbf-h = INDEX(qbf-rcg[qbf-p],"&":u) > 0

    &IF {&SupportJustify} &THEN
    qbf-j = FALSE
    qbf-w = { aderes/s-size.i &type=qbf-rct[qbf-p] &format=qbf-f }
    &ENDIF

    but-ft:SENSITIVE IN FRAME qbf%fmt   = ix > 1
    but-pv:SENSITIVE IN FRAME qbf%fmt   = ix > 1
    but-nx:SENSITIVE IN FRAME qbf%fmt   = ix < cnt
    but-lt:SENSITIVE IN FRAME qbf%fmt   = ix < cnt 
    qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = qbf-n
    .
    
  /* default x & y values. */
  CASE qbf-module:
    WHEN "b":u OR WHEN "e":u THEN
      DISABLE qbf-x qbf-y WITH FRAME qbf%fmt.
    WHEN "r":u THEN 
      ASSIGN
        qbf-x = DECIMAL({aderes/strtoe.i &str="ENTRY({&R_COL},qbf-rcp[qbf-p])"})
        qbf-y = DECIMAL({aderes/strtoe.i &str="ENTRY({&R_ROW},qbf-rcp[qbf-p])"})
      	.
    WHEN "f":u THEN 
      ASSIGN
        qbf-x = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_COL},qbf-rcp[qbf-p])"})
        qbf-y = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_ROW},qbf-rcp[qbf-p])"})
      	/* convert to integer row value so user doesn't go bonkers. */
      	qbf-y = (IF qbf-y = 1 THEN 1 
      	       	     	      ELSE INTEGER(((qbf-y - 1) / qbf-fillht) + 1)).
    WHEN "l":u THEN 
      ASSIGN
        qbf-x = DECIMAL({aderes/strtoe.i &str="ENTRY({&L_COL},qbf-rcp[qbf-p])"})
        qbf-y = DECIMAL({aderes/strtoe.i &str="ENTRY({&L_ROW},qbf-rcp[qbf-p])"})
      	.
  END CASE.

  IF (qbf-rct[qbf-p] = 4 OR qbf-rct[qbf-p] = 5)
    AND SESSION:NUMERIC-FORMAT <> "AMERICAN":u THEN 
    RUN adecomm/_convert.p ("A-TO-N":u, qbf-f, 
                            SESSION:NUMERIC-SEPARATOR,
                            SESSION:NUMERIC-DECIMAL-POINT,
                            OUTPUT qbf-f).

  DISPLAY
    qbf-h
    &IF {&SupportJustify} &THEN
    qbf-j
    &ENDIF
    WITH FRAME qbf%fmt.

  ASSIGN
    qbf-n:SCREEN-VALUE IN FRAME qbf%fmt = qbf-n
    qbf-f:SCREEN-VALUE IN FRAME qbf%fmt = qbf-f
    qbf-l:SCREEN-VALUE IN FRAME qbf%fmt = qbf-l
    qbf-x:SCREEN-VALUE IN FRAME qbf%fmt = 
      STRING(qbf-x,qbf-x:FORMAT IN FRAME qbf%fmt)
    qbf-y:SCREEN-VALUE IN FRAME qbf%fmt = 
      STRING(qbf-y,qbf-y:FORMAT IN FRAME qbf%fmt)
    &IF {&SupportJustify} &THEN
    qbf-j:SCREEN-VALUE IN FRAME qbf%fmt = 
      STRING(qbf-j,qbf-j:FORMAT IN FRAME qbf%fmt)
    qbf-w:SCREEN-VALUE IN FRAME qbf%fmt = 
      STRING(qbf-w,qbf-w:FORMAT IN FRAME qbf%fmt)
    &ENDIF

    calc_ix          = INDEX("rpcsdnlex":u,SUBSTRING(qbf-rcc[qbf-p],1,1,
                                                     "CHARACTER":u))
    but-ed:SENSITIVE = (calc_ix > 0)
    but-rn:SENSITIVE = (calc_ix > 0)
    
    qbf-dt:SCREEN-VALUE IN FRAME qbf%fmt
          = ENTRY(qbf-rct[qbf-p],qbf-dtype)
          + (IF calc_ix = 0 THEN "" ELSE ", ":u + ENTRY(calc_ix + 1,qbf-etype))

    {&SET_EXPRESSION} /* sets qbf-4gl */

    /* cannot justify non-character fields */
    &IF {&SupportJustify} &THEN
    qbf-j:SENSITIVE IN FRAME qbf%fmt = qbf-rct[qbf-p] = 1
      AND INDEX("xna!9":u,SUBSTRING(qbf-f,1,1,"CHARACTER":u)) > 0
    qbf-w:SENSITIVE IN FRAME qbf%fmt = FALSE
    &ENDIF
    qbf-f:SENSITIVE IN FRAME qbf%fmt = TRUE

    /* can only hide rep values on non-stacked-array, non-aggregated fields */
    qbf-h:SENSITIVE IN FRAME qbf%fmt = qbf-module = "r":u
      AND (LENGTH(qbf-rcg[qbf-p],"CHARACTER":u) < 2
           AND NOT qbf-rcc[qbf-p] BEGINS "e":u)
    .
END PROCEDURE. /* prepare_dialog */

/*--------------------------------------------------------------------------*/

PROCEDURE save_changes:
  DEFINE VARIABLE room   AS DECIMAL NO-UNDO. /* available space */
  DEFINE VARIABLE wid    AS DECIMAL NO-UNDO. /* field width w/ label */
  DEFINE VARIABLE badfmt AS LOGICAL NO-UNDO.
  DEFINE VARIABLE junk   AS INTEGER NO-UNDO.

  /* Do some validation - make sure we have latest input from the user. */
  ASSIGN 
   INPUT FRAME qbf%fmt qbf-x  /* col */
   INPUT FRAME qbf%fmt qbf-y  /* row */
   qbf-l = qbf-l:SCREEN-VALUE IN FRAME qbf%fmt 	/* label */
   qbf-f = qbf-f:SCREEN-VALUE IN FRAME qbf%fmt.	/* format */

  IF (qbf-rct[qbf-p] = 4 OR qbf-rct[qbf-p] = 5)
     AND SESSION:NUMERIC-FORMAT <> "AMERICAN":u THEN 
    RUN adecomm/_convert.p ("N-TO-A":u,qbf-f,
                            SESSION:NUMERIC-SEPARATOR,
                            SESSION:NUMERIC-DECIMAL-POINT,
                            OUTPUT qbf-f).
  IF (qbf-x = 0 AND qbf-y > 0) OR
     (qbf-x > 0 AND qbf-y = 0) THEN DO:
    IF qbf-y = 0 THEN DO:
      MESSAGE "If the Column is non-zero, then the Row must be also.":t63
      	VIEW-AS ALERT-BOX ERROR BUTTON OK.
      APPLY "ENTRY":u TO qbf-y IN FRAME qbf%fmt.
    END.                 
    ELSE DO:
      MESSAGE "If the Row is non-zero, then the Column must be also.":t63
      	VIEW-AS ALERT-BOX ERROR BUTTON OK.
      APPLY "ENTRY":u TO qbf-x IN FRAME qbf%fmt.
    END.
    RETURN "error":u.
  END.

  IF qbf-f = "" THEN 
    RUN adecomm/_s-alert.p (INPUT-OUTPUT badfmt, "error":u, "ok":u,
      "Please supply a format for this field.").
  ELSE
    RUN adecomm/_chkfmt.p (qbf-rct[qbf-p],ENTRY(1,qbf-rcn[qbf-p]),
                           "junk":u, qbf-f, OUTPUT junk, OUTPUT badfmt).
  IF badfmt THEN DO:
    APPLY "ENTRY":u TO qbf-f IN FRAME qbf%fmt.
    RETURN "error":u.
  END.

  IF qbf-module = "f":u THEN DO:
    ASSIGN
      wid = qbf-x + FONT-TABLE:GET-TEXT-WIDTH(qbf-l,0) + 7 /* fudge factor */
      room = MAX(def-win-wid, qbf-win:WIDTH).
    IF wid > room THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        SUBSTITUTE("Given this column position and label, this field will not fit in the form.  It is &1 characters too wide.",
        TRUNCATE(wid - room,0) + 1)).
        
      RETURN "error":u.
    END.
    IF qbf-y > {&MAX-FORM-ROW} THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
        SUBSTITUTE("The maximum row allowed in Form View is &1.", {&MAX-FORM-ROW})).
      RETURN "error":u.  
    END.
  END.

  /* work-around for contiguous linefeeds - change to blanks */
  qbf-i = INDEX(qbf-l,CHR(10) + CHR(10)).
  DO WHILE qbf-i > 0:
    ASSIGN
      SUBSTRING(qbf-l,qbf-i + 1,0,"CHARACTER":u) = " ":u
      qbf-i = INDEX(qbf-l,CHR(10) + CHR(10)).
  END.
  /* CR's are stored as single exclamations ("!"). Exclamations
     that the user types are doubled and stored as "!!". 
  */
  qbf-rcl[qbf-p] = REPLACE(REPLACE(qbf-l,"!":u,"!!":u),CHR(10),"!":u).

  ASSIGN
    qbf-rcf[qbf-p] = qbf-f
    &IF {&SupportJustify} &THEN
    qbf-j          = INPUT FRAME qbf%fmt qbf-j
    &ENDIF
    qbf-h          = INPUT FRAME qbf%fmt qbf-h
    qbf-i          = INDEX(qbf-rcg[qbf-p],"&":u).

  IF qbf-i > 0 AND NOT qbf-h THEN 
    SUBSTRING(qbf-rcg[qbf-p],qbf-i,1,"CHARACTER":u) = "".
  IF qbf-i = 0 AND qbf-h THEN 
    qbf-rcg[qbf-p] = qbf-rcg[qbf-p] + "&":u.

  /* Set the row and column for this view */
  IF qbf-module = "f":u AND qbf-y <> 0 THEN 
      qbf-y = (qbf-y - 1) * qbf-fillht + 1.
  qbf-i = INDEX("r_f_l":u,qbf-module).

  IF qbf-i > 0 THEN
    /* We don't really have to worry about numtoa (European format) since
       numbers should be integers but it won't hurt.
    */
    ASSIGN
      ENTRY(qbf-i,qbf-rcp[qbf-p]) = 
      	 (IF qbf-x = 0 THEN "" ELSE {aderes/numtoa.i &num="qbf-x"})
      qbf-i = qbf-i + 1
      ENTRY(qbf-i,qbf-rcp[qbf-p]) = 
      	 (IF qbf-y = 0 THEN "" ELSE {aderes/numtoa.i &num="qbf-y"}).

END PROCEDURE. /* save_changes */

/*
/*--------------------------------------------------------------------------*/
PROCEDURE create_button:
  DEFINE INPUT  PARAMETER qbf-j AS INTEGER   NO-UNDO. /* button # */

  CREATE BUTTON but-nav[qbf-j]
    ASSIGN
      FRAME          = qbf%fmt
      AUTO-RESIZE    = TRUE
      HEIGHT-PIXELS  = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN 25 ELSE 26
      WIDTH-PIXELS   = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN 33 ELSE 34
      BGCOLOR        = 8
      VISIBLE        = FALSE
      SENSITIVE      = TRUE.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE load_image:
  DEFINE INPUT  PARAMETER qbf-j AS INTEGER   NO-UNDO. /* button # */
  DEFINE INPUT  PARAMETER qbf-u AS CHARACTER NO-UNDO. /* up */
  DEFINE INPUT  PARAMETER qbf-d AS CHARACTER NO-UNDO. /* down */
  DEFINE INPUT  PARAMETER qbf-i AS CHARACTER NO-UNDO. /* insensitive */

  ASSIGN
    qbf-a = but-nav[qbf-j]:LOAD-IMAGE-UP(qbf-u)
    qbf-a = but-nav[qbf-j]:LOAD-IMAGE-DOWN(qbf-d)
    qbf-a = but-nav[qbf-j]:LOAD-IMAGE-INSENSITIVE(qbf-i)
    .
END PROCEDURE.
*/

/* y-format.p - end of file */

