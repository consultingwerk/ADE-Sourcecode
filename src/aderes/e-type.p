/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

  File: e-type.p - set standard export type properties

  Description: 

  Input Parameters:

  Output Parameters:      <none>

  Author: Greg O'Connor

  Created: 08/15/93 - 12:17 pm

-----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE INPUT  PARAMETER qbf-admin  AS INTEGER   NO-UNDO. /* 0=user, 1=admin */ 
DEFINE OUTPUT PARAMETER lRet       AS LOGICAL   NO-UNDO. /* all OK? */

FIND FIRST qbf-esys NO-ERROR.
/* see e-define.i for information on qbf-e-cat contents and structure */

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d  AS CHARACTER NO-UNDO. /* formats to delete */
DEFINE VARIABLE qbf-e  AS CHARACTER NO-UNDO EXTENT 64. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-s  AS CHARACTER NO-UNDO. /* selection list */
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO. /* 1st 5 deletions */
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO. /* initial value */

DEFINE VARIABLE qbf-mo AS INTEGER   NO-UNDO. /* month */
DEFINE VARIABLE qbf-dy AS INTEGER   NO-UNDO. /* day */
DEFINE VARIABLE qbf-yr AS INTEGER   NO-UNDO. /* year */
DEFINE VARIABLE token  AS CHARACTER NO-UNDO. 

DEFINE BUTTON qbf-ok   LABEL "OK"      {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"   {&STDPH_OKBTN}.
DEFINE BUTTON qbf-del  LABEL "&Delete" {&STDPH_OKBTN}.
DEFINE BUTTON qbf-set  LABEL "&Reset"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})

  qbf-s AT 2 VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL
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
  DEFAULT-BUTTON qbf-Ok CANCEL-BUTTON qbf-ee KEEP-TAB-ORDER
  TITLE "Standard Export":t32 VIEW-AS DIALOG-BOX.

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf-area" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help"
}
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

ON HELP OF FRAME qbf-area OR CHOOSE OF qbf-help IN FRAME qbf-area
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Export_Types_Dlg_Box},?).

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf-area
  APPLY "GO":u TO FRAME qbf-area.
  
ON VALUE-CHANGED OF qbf-s IN FRAME qbf-area
  qbf-del:SENSITIVE IN FRAME qbf-area = TRUE.
  
ON CHOOSE OF qbf-del IN FRAME qbf-area DO:
  qbf-c = qbf-s:SCREEN-VALUE IN FRAME qbf-area.

  /* IF qbf-s:LOOKUP(qbf-c) IN FRAME qbf-area > 0 THEN DO: */ 
  IF qbf-s <> ? THEN DO:
    RUN adecomm/_delitem.p (qbf-s:HANDLE in FRAME qbf-area, qbf-c, 
                            OUTPUT qbf-i).

    ASSIGN 
      qbf-d = qbf-d + (IF qbf-d = "" THEN "" ELSE CHR(10)) + qbf-c
      qbf-set:SENSITIVE IN FRAME qbf-area = TRUE.
  END.
END.

ON CHOOSE OF qbf-set IN FRAME qbf-area
  RUN build_list.

ON GO OF FRAME qbf-area DO:
  /* admin rebuild if changes made - dma */
  IF qbf-admin = 1 AND qbf-d > "" THEN DO:

    ASSIGN
      qbf-a      = ?
      qbf-redraw = FALSE.
    
    IF NUM-ENTRIES(qbf-d, CHR(10)) > 5 THEN DO:
      qbf-t = "".
      DO qbf-i = 1 TO 5:
        qbf-t = qbf-t + (IF qbf-i > 1 THEN CHR(10) ELSE "")
              + ENTRY(qbf-i, qbf-d, CHR(10)).
      END.
      qbf-t = qbf-t + " ...":u.
    END.
    ELSE
      qbf-t = qbf-d.

    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"question":u,"ok-cancel":u,
      SUBSTITUTE("The following standard export formats will be deleted from the configuration file:^^&1^^Do you want to continue?",
      qbf-t)).
      
    IF qbf-a THEN DO:
      /* store initial list */
      DO qbf-i = 1 TO EXTENT(qbf-e-cat):
         qbf-e[qbf-i] = qbf-e-cat[qbf-i].
      END.
    
      /* zap deleted entries */
     DO qbf-i = 1 TO NUM-ENTRIES(qbf-d, CHR(44)):
        qbf-c = ENTRY(qbf-i, qbf-d, CHR(44)). 
        
        DO qbf-j = 1 TO EXTENT(qbf-e):
        
          IF LOOKUP("l=":u + qbf-c, qbf-e[qbf-j], "|":u) > 0 THEN DO:
            qbf-e[qbf-j] = "".

            LEAVE.
          END.
        END.
      END.

      ASSIGN
        qbf-j     = 0
        qbf-e-cat = "".
        
      /* rebuild and pack list, omitting gaps */
      DO qbf-i = 1 TO EXTENT(qbf-e):
        IF qbf-e[qbf-i] <> "" THEN
          ASSIGN
            qbf-j            = qbf-j + 1
            qbf-e-cat[qbf-j] = qbf-e[qbf-i].
      END.
      
	  /* rebuild configuration file */
      HIDE FRAME qbf-area NO-PAUSE.
      RUN adecomm/_setcurs.p ("WAIT").
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
      
      /* reset default export format */
      qbf-esys.qbf-base    = ?     /* b= */
      qbf-esys.qbf-dlm-typ = "*":u /* d= */
      qbf-esys.qbf-fixed   = FALSE /* f= */
      qbf-esys.qbf-headers = FALSE /* h= */
      qbf-esys.qbf-prepass = FALSE /* i= */
                                   /* l= */
      qbf-esys.qbf-program = ""    /* p= */
      qbf-esys.qbf-type    = ""    /* t= */
      qbf-esys.qbf-lin-beg = ""    /* 1= */
      qbf-esys.qbf-lin-end = ""    /* 2= */
      qbf-esys.qbf-fld-dlm = ""    /* 3= */
      qbf-esys.qbf-fld-sep = ""    /* 4= */
      .
      
    DO qbf-i = 1 TO EXTENT(qbf-e-cat) 
      WHILE qbf-e-cat[qbf-i] <> "" AND qbf-s = "":
      RUN return_name (qbf-i, OUTPUT qbf-c).
      IF qbf-s:SCREEN-VALUE IN FRAME qbf-area = qbf-c THEN
        qbf-s = qbf-e-cat[qbf-i].
    END.
   
    /* update global page size variables */
    IF qbf-s <> "" THEN DO:
      IF qbf-v <> qbf-s:SCREEN-VALUE THEN
        ASSIGN
          lRet       = TRUE
          qbf-redraw = TRUE
          qbf-dirty  = TRUE.
        
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-s, "|":u):
        ASSIGN
          qbf-c = ENTRY(qbf-i, qbf-s, "|":u)
          token = SUBSTRING(qbf-c,3,-1,"CHARACTER":u)
          .
       
        CASE SUBSTRING(qbf-c,1,2,"CHARACTER":u):
          WHEN "b=":u THEN 
            ASSIGN
              qbf-mo            = INTEGER(ENTRY(1,token,"~/"))
              qbf-dy            = INTEGER(ENTRY(2,token,"~/"))
              qbf-yr            = INTEGER(ENTRY(3,token,"~/"))
              qbf-esys.qbf-base = IF qbf-mo = ? THEN ?
                                  ELSE DATE(qbf-mo,qbf-dy,qbf-yr).
          WHEN "d=":u THEN 
            qbf-esys.qbf-dlm-typ = token.
          WHEN "f=":u THEN 
            qbf-esys.qbf-fixed   = (qbf-c MATCHES "*y":u).
          WHEN "h=":u THEN 
            qbf-esys.qbf-headers = (qbf-c MATCHES "*y":u).
          WHEN "i=":u THEN 
            qbf-esys.qbf-prepass = (qbf-c MATCHES "*y":u).
          WHEN "p=":u THEN 
            qbf-esys.qbf-program = token +
              (IF CAN-DO(qbf-esys.qbf-program, "u-export":u) THEN "":u 
               ELSE ".p":u).
          WHEN "t=":u THEN 
            qbf-esys.qbf-type    = token.
          WHEN "1=":u THEN 
            qbf-esys.qbf-lin-beg = token.
          WHEN "2=":u THEN 
            qbf-esys.qbf-lin-end = token.
          WHEN "3=":u THEN 
            qbf-esys.qbf-fld-dlm = token.
          WHEN "4=":u THEN 
            qbf-esys.qbf-fld-sep = token.
          WHEN "l=":u THEN 
            qbf-esys.qbf-desc    = token.
        END CASE.
      END.
    END.
  END. /* end-user */
END.

ON WINDOW-CLOSE OF FRAME qbf-area
  APPLY "END-ERROR":u TO SELF.             

/*--------------------------------------------------------------------------*/

IF qbf-admin = 1 THEN
  ASSIGN
    qbf-s:MULTIPLE IN FRAME qbf-area    = TRUE
    qbf-del:SENSITIVE IN FRAME qbf-area = TRUE.
 
RUN build_list.

/* hide DELETE button for end-users */
IF qbf-admin = 0 THEN
  ASSIGN
    qbf-v                             = qbf-esys.qbf-desc
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
   
DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME qbf-area.
END.

HIDE FRAME qbf-area NO-PAUSE.

RETURN.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
PROCEDURE build_list:
  ASSIGN
    qbf-d = ""
    qbf-s:LIST-ITEMS IN FRAME qbf-area = "".
  
  DO qbf-i = 1 TO EXTENT(qbf-e-cat) WHILE qbf-e-cat[qbf-i] <> "":
    RUN return_name (qbf-i, OUTPUT qbf-c).
    IF qbf-c > "" THEN
      qbf-a = qbf-s:ADD-LAST(qbf-c) IN FRAME qbf-area.
      
    /* setup for scroll-to-item */
    IF qbf-s = "" AND LOOKUP("l=":u + STRING(qbf-esys.qbf-desc), 
                             qbf-e-cat[qbf-i], "|":u) > 0
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
  DEFINE OUTPUT PARAMETER qbf_o AS CHARACTER NO-UNDO. /* 'l=' value */

  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO.

  DO qbf_j = 1 TO NUM-ENTRIES(qbf-e-cat[qbf_i], "|":u) WHILE qbf_o = "":
    IF ENTRY(qbf_j, qbf-e-cat[qbf_i], "|":u) BEGINS "l=":u THEN
      qbf_o = SUBSTRING(ENTRY(qbf_j,qbf-e-cat[qbf_i],"|":u),3,-1,"CHARACTER":u).
  END.
END PROCEDURE. /* return_name */

/* e-type.p - end of file */

