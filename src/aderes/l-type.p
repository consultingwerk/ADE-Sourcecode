/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * l-type.p - set standard label types properties
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/l-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT  PARAMETER qbf-admin  AS INTEGER NO-UNDO. /* 0=user, 1=admin */ 
DEFINE OUTPUT PARAMETER lRet       AS LOGICAL NO-UNDO.

FIND FIRST qbf-lsys NO-ERROR.

/* see l-define.i for information on qbf-l-cat contents and structure */

DEFINE VARIABLE qbf-a AS LOGICAL             NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER           NO-UNDO. /* initial value */

DEFINE BUTTON qbf-ok   LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"   {&STDPH_OKBTN}.
DEFINE BUTTON qbf-del  LABEL "&Delete" {&STDPH_OKBTN}.
DEFINE BUTTON qbf-set  LABEL "&Reset"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns             {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})

  qbf-s AT 2 
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL
    SCROLLBAR-HORIZONTAL INNER-CHARS 55 INNER-LINES 10 SORT
  SKIP({&TFM_WID})
  
  qbf-del AT 2 SPACE({&HM_BTN}) 
  
  qbf-set

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = no
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help }

  WITH FRAME qbf-area NO-ATTR-SPACE NO-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee KEEP-TAB-ORDER
  TITLE "Standard Label":t32 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-area" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help"
}
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME qbf-area OR CHOOSE OF qbf-help IN FRAME qbf-area
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Label_Types_Dlg_Box},?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf-area
  APPLY "GO":u TO FRAME qbf-area.

ON CHOOSE OF qbf-del IN FRAME qbf-area DO:
  qbf-c = qbf-s:SCREEN-VALUE IN FRAME qbf-area.
  
/*  IF qbf-s:LOOKUP(qbf-c) IN FRAME qbf-area > 0 THEN DO: */

  IF qbf-s <> ? THEN DO:
    RUN adecomm/_delitem.p (qbf-s:HANDLE in FRAME qbf-area, qbf-c, 
                            OUTPUT qbf-i).

    qbf-d = qbf-d + (IF qbf-d = "" THEN "" ELSE CHR(10)) + qbf-c.
    qbf-set:SENSITIVE IN FRAME qbf-area = TRUE.
  END.
END.

ON CHOOSE OF qbf-set IN FRAME qbf-area
  RUN build_list.

ON GO OF FRAME qbf-area DO:
  /* admin rebuild if changes made - dma */
  IF qbf-admin = 1 AND qbf-d > "" THEN DO:
    ASSIGN
      qbf-a = ?
      lRet  = FALSE.
    
    IF NUM-ENTRIES(qbf-d, CHR(10)) > 5 THEN DO:
      qbf-t = "".
      DO qbf-i = 1 TO 5:
        qbf-t = qbf-t + (IF qbf-i > 1 THEN CHR(10) ELSE "")
              + ENTRY(qbf-i, qbf-d, CHR(10)).
      END.
      qbf-t = qbf-t + " ...":u.
    END.
    ELSE qbf-t = qbf-d.

    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"ok-cancel":u,
      SUBSTITUTE("The following standard label size types will be deleted from the configuration file:^^&1^^Do you want to continue?",
      qbf-t)).

    IF qbf-a THEN DO:
      /* store initial list */
      DO qbf-i = 1 TO EXTENT(qbf-l-cat):
        qbf-l[qbf-i] = qbf-l-cat[qbf-i].
      END.
    
      /* zap deleted entries */
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-d, CHR(44)):
        qbf-c = SUBSTRING(ENTRY(qbf-i, qbf-d, CHR(44)), 1,
                          R-INDEX(ENTRY(qbf-i,qbf-d,CHR(44)),"(":u) - 2,
                          "CHARACTER":u).

        DO qbf-j = 1 TO EXTENT(qbf-l):
          IF LOOKUP("c=":u + qbf-c, qbf-l[qbf-j]) > 0 THEN DO:
            qbf-l[qbf-j] = "".
            LEAVE.
          END.
        END.
      END.
      
      ASSIGN
        qbf-j     = 0
        qbf-l-cat = "".
        
      /* rebuild and pack list, omitting gaps */
      DO qbf-i = 1 TO EXTENT(qbf-l):
        IF qbf-l[qbf-i] <> "" THEN
          ASSIGN
            qbf-j            = qbf-j + 1
            qbf-l-cat[qbf-j] = qbf-l[qbf-i].
      END.
      
     /* rebuild configuration file */
      HIDE FRAME qbf-area NO-PAUSE.
      RUN adecomm/_setcurs.p ("WAIT":u).
      _configDirty = true.
      RUN aderes/_awrite.p (0).
      RUN adecomm/_setcurs.p ("").
    END.
    ELSE RETURN NO-APPLY.
  END. /* administrator */

  ELSE IF qbf-admin = 0 THEN DO:
    ASSIGN
      qbf-a = TRUE
      qbf-s = ""
      .
      
    DO qbf-i = 1 TO EXTENT(qbf-l-cat) 
      WHILE qbf-l-cat[qbf-i] <> "" AND qbf-s = "":
      RUN return_name (qbf-i,OUTPUT qbf-c).
      
      IF qbf-s:SCREEN-VALUE IN FRAME qbf-area = qbf-c THEN 
        qbf-s = qbf-l-cat[qbf-i].
    END.

    /* update global page size variables */
    IF qbf-s <> "" THEN DO:
      IF qbf-v <> qbf-s:SCREEN-VALUE THEN
        ASSIGN
          lRet       = TRUE
          qbf-redraw = TRUE
          qbf-dirty  = TRUE
          .
          
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-s):
        qbf-c = ENTRY(qbf-i, qbf-s).
        CASE SUBSTRING(qbf-c,1,2,"CHARACTER":u):
          WHEN "c=":u THEN qbf-lsys.qbf-type      = 
            SUBSTRING(qbf-c,3,-1,"CHARACTER":u).
          WHEN "d=":u THEN qbf-lsys.qbf-dimen     = 
            SUBSTRING(qbf-c,3,-1,"CHARACTER":u).
          WHEN "a=":u THEN qbf-lsys.qbf-across    = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
          WHEN "h=":u THEN qbf-lsys.qbf-label-ht  = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
          WHEN "l=":u THEN qbf-lsys.qbf-space-vt  = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
          WHEN "s=":u THEN qbf-lsys.qbf-space-hz  = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
          WHEN "w=":u THEN qbf-lsys.qbf-label-wd  = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
          WHEN "x=":u THEN qbf-lsys.qbf-origin-hz = 
            INTEGER(SUBSTRING(qbf-c,3,-1,"CHARACTER":u)).
        END CASE.
      END.
      /* set any defaults for specifications that are missing. (los) */
      IF INDEX(qbf-s, "a=":u) = 0 THEN
      	qbf-lsys.qbf-across = 1.
      IF INDEX(qbf-s, "l=":u) = 0 THEN
      	qbf-lsys.qbf-space-vt = 1.
      IF INDEX(qbf-s, "s=":u) = 0 THEN
      	qbf-lsys.qbf-space-hz = 0.
      IF INDEX(qbf-s, "x=":u) = 0 THEN
      	qbf-lsys.qbf-origin-hz = 0.
    END.
  END. /* end-user */
END.

ON END-ERROR OF FRAME qbf-area
  APPLY "CHOOSE":u TO qbf-ee IN FRAME qbf-area.

ON WINDOW-CLOSE OF FRAME qbf-area
  APPLY "END-ERROR":u TO SELF.             

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

IF qbf-admin = 1 THEN
  ASSIGN
    qbf-s:MULTIPLE IN FRAME qbf-area    = TRUE
    qbf-del:SENSITIVE IN FRAME qbf-area = TRUE.
  
RUN build_list.

/* hide DELETE button for end-users */
IF qbf-admin = 0 THEN
  ASSIGN
    qbf-v                             = qbf-lsys.qbf-type + " (":u
                                      + qbf-lsys.qbf-dimen + ")":u
    qbf-i                             = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(0)

    &IF {&OKBOX} &THEN
      rect_btns:Y IN FRAME qbf-area   = rect_btns:Y IN FRAME qbf-area
                                      - qbf-del:HEIGHT-PIXELS IN FRAME qbf-area
                                      - ({&TFM_WID} * qbf-i)
    &ELSE
      FRAME qbf-area:RULE-ROW         = FRAME qbf-area:RULE-ROW
                                      - qbf-del:HEIGHT-PIXELS IN FRAME qbf-area
                                      - ({&TFM_WID} * qbf-i)
    &ENDIF

    qbf-ok:Y IN FRAME qbf-area        = qbf-ok:Y IN FRAME qbf-area
                                      - qbf-del:HEIGHT-PIXELS IN FRAME qbf-area
                                      - ({&TFM_WID} * qbf-i)
    qbf-ee:Y IN FRAME qbf-area        = qbf-ok:Y IN FRAME qbf-area
    qbf-help:Y IN FRAME qbf-area      = qbf-ok:Y IN FRAME qbf-area
    FRAME qbf-area:HEIGHT-PIXELS      = FRAME qbf-area:HEIGHT-PIXELS
                                      - qbf-del:HEIGHT-PIXELS IN FRAME qbf-area
                                      - ({&TFM_WID} * qbf-i)
    qbf-del:VISIBLE IN FRAME qbf-area = FALSE
    qbf-set:VISIBLE IN FRAME qbf-area = FALSE
    .

ENABLE qbf-s qbf-ok qbf-ee qbf-help WITH FRAME qbf-area.

DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-area.
  
  IF qbf-a <> TRUE THEN NEXT.
  ELSE LEAVE.
END.

HIDE FRAME qbf-area NO-PAUSE.

RETURN.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
PROCEDURE build_list:
  ASSIGN
    qbf-d                              = ""
    qbf-s:LIST-ITEMS IN FRAME qbf-area = "".
  
  DO qbf-i = 1 TO EXTENT(qbf-l-cat) WHILE qbf-l-cat[qbf-i] <> "":
    RUN return_name (qbf-i,OUTPUT qbf-c).
    IF qbf-c > "" THEN
      qbf-a = qbf-s:ADD-LAST(qbf-c) IN FRAME qbf-area.
      
    /* setup for scroll-to-item */
    IF (LOOKUP("c=":u + qbf-lsys.qbf-type, qbf-l-cat[qbf-i]) > 0
      AND LOOKUP("d=":u + qbf-lsys.qbf-dimen, qbf-l-cat[qbf-i]) > 0) 
      OR qbf-i = 1
      THEN qbf-s = qbf-c.
  END.

  /* sort selection list, since Motif can't do VIEW-AS SELECTION-LIST SORT */
  &IF "{&WINDOW-SYSTEM}":u = "OSF/Motif":u &THEN
  qbf-c = qbf-s:LIST-ITEMS IN FRAME qbf-area.
  RUN aderes/_lstsort.p (INPUT-OUTPUT qbf-c).
  qbf-s:LIST-ITEMS IN FRAME qbf-area = qbf-c.
  &ENDIF

  IF qbf-s <> "" THEN DO:
    IF qbf-admin = 1 THEN
      qbf-s:SCREEN-VALUE IN FRAME qbf-area = qbf-s:ENTRY(1) IN FRAME qbf-area.
    ELSE
    ASSIGN
      qbf-s:SCREEN-VALUE IN FRAME qbf-area = qbf-s
      qbf-a = qbf-s:SCROLL-TO-ITEM(qbf-s) IN FRAME qbf-area.
  END.

  qbf-set:SENSITIVE IN FRAME qbf-area = FALSE.
END PROCEDURE.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
PROCEDURE return_name:
  DEFINE INPUT  PARAMETER qbf_i AS INTEGER   NO-UNDO. /* export array */
  DEFINE OUTPUT PARAMETER qbf_o AS CHARACTER NO-UNDO. /* 'c=' value */

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_d AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO.

  ASSIGN
    qbf_c = ""
    qbf_d = "".
  DO qbf_j = 1 TO NUM-ENTRIES(qbf-l-cat[qbf_i]) WHILE qbf_c = "" OR qbf_d = "":
    IF ENTRY(qbf_j, qbf-l-cat[qbf_i]) BEGINS "c=":u THEN
      qbf_c = SUBSTRING(ENTRY(qbf_j, qbf-l-cat[qbf_i]),3,-1,"CHARACTER":u).
    ELSE
    IF ENTRY(qbf_j,qbf-l-cat[qbf_i]) BEGINS "d=":u THEN
      qbf_d = SUBSTRING(ENTRY(qbf_j, qbf-l-cat[qbf_i]),3,-1,"CHARACTER":u).
  END.
  qbf_o = (IF     qbf_c =  "" AND qbf_d =  "" THEN ""
          ELSE IF qbf_c <> "" AND qbf_d =  "" THEN qbf_c
          ELSE IF qbf_c =  "" AND qbf_d <> "" THEN qbf_d
          ELSE qbf_c + " (":u + qbf_d + ")":u).
END PROCEDURE. /* return_name */

/* l-type.p - end of file */

