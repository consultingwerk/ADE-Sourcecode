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
/*
 * r-header.p - get header/footer definitions from user
 */

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i  }
{ adecomm/adestds.i }
{ aderes/reshlp.i   }

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO. /* TRUE = changed */

DEFINE VARIABLE hdr-ftr AS LOGICAL   NO-UNDO. /* header/footer exists */
DEFINE VARIABLE list-1  AS CHARACTER NO-UNDO. /* qbf-s w/o VALUE function */
DEFINE VARIABLE list-2  AS CHARACTER NO-UNDO. /* qbf-s w/ VALUE function */
DEFINE VARIABLE qbf-a   AS HANDLE    NO-UNDO EXTENT 10.
DEFINE VARIABLE qbf-b   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-f   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l   AS INTEGER   NO-UNDO. /* last position */
DEFINE VARIABLE qbf-q   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-p   AS CHARACTER NO-UNDO. /* word "Position" for box */
DEFINE VARIABLE qbf-e   AS CHARACTER NO-UNDO. /* editor widget */
DEFINE VARIABLE qbf-m   AS CHARACTER NO-UNDO. /* editor widget label text */
DEFINE VARIABLE qbf-s   AS CHARACTER NO-UNDO. /* selection list */
DEFINE VARIABLE qbf-y   AS CHARACTER NO-UNDO. /* selection list label text */
DEFINE VARIABLE qbf-t   AS CHARACTER NO-UNDO EXTENT 10. /* title */
DEFINE VARIABLE sel-st  AS CHARACTER NO-UNDO. /* 4GL selection */  
DEFINE VARIABLE refName AS CHARACTER NO-UNDO.
DEFINE VARIABLE wt-ictn AS INTEGER   NO-UNDO. /* starting wt-header count */
DEFINE VARIABLE wt-octn AS INTEGER   NO-UNDO. /* ending wt-header count */

DEFINE BUTTON qbf-b1    IMAGE FILENAME "adeicon/header1":u.
DEFINE BUTTON qbf-b2    IMAGE FILENAME "adeicon/header2":u.
DEFINE BUTTON qbf-b3    IMAGE FILENAME "adeicon/header3":u.
DEFINE BUTTON qbf-b4    IMAGE FILENAME "adeicon/header4":u.
DEFINE BUTTON qbf-b5    IMAGE FILENAME "adeicon/header5":u.
DEFINE BUTTON qbf-b6    IMAGE FILENAME "adeicon/header6":u.
DEFINE BUTTON qbf-b7    IMAGE FILENAME "adeicon/header7":u.
DEFINE BUTTON qbf-b8    IMAGE FILENAME "adeicon/header8":u.
DEFINE BUTTON qbf-b9    IMAGE FILENAME "adeicon/header9":u.
DEFINE BUTTON qbf-b0    IMAGE FILENAME "adeicon/header0":u.

DEFINE RECTANGLE qbf-r1 SIZE-PIXELS 137 BY 157 NO-FILL.
DEFINE RECTANGLE qbf-r2 SIZE-PIXELS  31 BY  25 NO-FILL EDGE-PIXELS 4.

DEFINE BUTTON qbf-ok    LABEL "OK"             {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee    LABEL "Cancel"         {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help  LABEL "&Help"          {&STDPH_OKBTN}.
DEFINE BUTTON qbf-clear LABEL "&Clear All":c16 {&STDPH_FILL}.

/* standard button rectangle */
DEFINE RECTANGLE rect_btns            {&STDPH_OKBOX}.

/* copy of qbf-hsys (see r-define.i) -dma */
DEFINE WORK-TABLE wt-header
  FIELD hpos AS INTEGER
  FIELD htxt AS CHARACTER EXTENT 8  /* up to 8 header/footer lines */
  FIELD hgen AS CHARACTER EXTENT 8  /* space for generated code */
  FIELD hwid AS INTEGER   EXTENT 8  /* width of generated code */
  FIELD hmax AS INTEGER.            /* max width of generated code */

ASSIGN
  qbf-t[ 1] = "Left Header":t32
  qbf-t[ 2] = "Center Header":t32
  qbf-t[ 3] = "Right Header":t32
  qbf-t[ 4] = "Left Footer":t32
  qbf-t[ 5] = "Center Footer":t32
  qbf-t[ 6] = "Right Footer":t32
  qbf-t[ 7] = "First-Page-Only Header":t32
  qbf-t[ 8] = "Last-Page-Only Footer":t32
  qbf-t[ 9] = "Cover Page Text":t32
  qbf-t[10] = "Final Page Text":t32

  qbf-y    = "&Function List:":t72
  qbf-p    = " ":u + TRIM("Position":t16) + " ":u
  qbf-m    = "&&Layout - &1:":t50.

/* positions in frame are approximate and are altered below */
FORM
  SKIP({&TFM_WID})
  qbf-p FORMAT "x(16)":u AT 1 VIEW-AS TEXT

  qbf-m FORMAT "x(50)":u AT 24 VIEW-AS TEXT 
  SKIP({&VM_WID})

  qbf-e VIEW-AS EDITOR INNER-CHARS 49 INNER-LINES 8
    SCROLLBAR-HORIZONTAL NO-WORD-WRAP NO-LABELS {&STDPH_EDITOR}
  SKIP({&VM_WID})

  qbf-clear AT 1
  SKIP(.2)

  qbf-y FORMAT "x(72)":u AT 2 VIEW-AS TEXT 
  SKIP({&VM_WID})

  qbf-s AT 2 
    VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 72 INNER-LINES 5
    SCROLLBAR-V

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help }

  /* anywhere! (moved & resized below) */
  qbf-r1 AT ROW  1 COLUMN  2
  qbf-r2 AT ROW  1 COLUMN  2
  qbf-b9 AT ROW  1 COLUMN  1
  qbf-b7 AT ROW  1 COLUMN  1
  qbf-b1 AT ROW  1 COLUMN  1
  qbf-b2 AT ROW  1 COLUMN  1
  qbf-b3 AT ROW  1 COLUMN  1
  qbf-b4 AT ROW  1 COLUMN  1
  qbf-b5 AT ROW  1 COLUMN  1
  qbf-b6 AT ROW  1 COLUMN  1
  qbf-b8 AT ROW  1 COLUMN  1
  qbf-b0 AT ROW  1 COLUMN  1

  WITH FRAME qbf%input SCROLLABLE NO-LABELS OVERLAY NO-ATTR-SPACE THREE-D
  CANCEL-BUTTON qbf-ee 
  TITLE "Headers and Footers":t32 VIEW-AS DIALOG-BOX.

/*--------------------------------------------------------------------------*/
/* Set up the help trigger. The edit widget must be included. This
 * overrides its default behavior, which is to bring up 4GL language
 * support for the contents of the widget
 */
ON HELP OF FRAME qbf%input OR 
  CHOOSE OF qbf-help IN FRAME qbf%input OR F1 OF qbf-e
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Headers_and_Footers_Dlg_Box},?).

ON HELP OF qbf-e IN FRAME qbf%input DO:
  sel-st = "".
  IF (qbf-e:SELECTION-START <> qbf-e:SELECTION-END ) THEN
    sel-st = TRIM(TRIM(qbf-e:SELECTION-TEXT), ",.;:!? ~"~ '[]()":u).
  RUN adecomm/_adehelp.p ("lgrf":u,"PARTIAL-KEY":u,?,sel-st).
END.

ON CHOOSE OF qbf-b1 IN FRAME qbf%input RUN switch_em (1, OUTPUT qbf-q).
ON CHOOSE OF qbf-b2 IN FRAME qbf%input RUN switch_em (2, OUTPUT qbf-q).
ON CHOOSE OF qbf-b3 IN FRAME qbf%input RUN switch_em (3, OUTPUT qbf-q).
ON CHOOSE OF qbf-b4 IN FRAME qbf%input RUN switch_em (4, OUTPUT qbf-q).
ON CHOOSE OF qbf-b5 IN FRAME qbf%input RUN switch_em (5, OUTPUT qbf-q).
ON CHOOSE OF qbf-b6 IN FRAME qbf%input RUN switch_em (6, OUTPUT qbf-q).
ON CHOOSE OF qbf-b7 IN FRAME qbf%input RUN switch_em (7, OUTPUT qbf-q).
ON CHOOSE OF qbf-b8 IN FRAME qbf%input RUN switch_em (8, OUTPUT qbf-q).
ON CHOOSE OF qbf-b9 IN FRAME qbf%input RUN switch_em (9, OUTPUT qbf-q).
ON CHOOSE OF qbf-b0 IN FRAME qbf%input RUN switch_em (10, OUTPUT qbf-q).

ON ALT-L OF FRAME qbf%input
  APPLY "ENTRY":u TO qbf-e IN FRAME qbf%input.

ON ALT-F OF FRAME qbf%input
  APPLY "ENTRY":u TO qbf-s IN FRAME qbf%input.

ON GO OF FRAME qbf%input DO:
  RUN switch_em (0, OUTPUT qbf-q).

  IF NOT qbf-q THEN RETURN NO-APPLY.
  /* For some reason, if I do a RETURN-ERROR from the switch_em internal   
     procedure, then NO-APPLY does not get done, so the action gets applied 
     anyway.  This means I have to pass a flag up to get the NO-APPLY to 
     work.  This should probably be changed to use ERROR-STATUS and a 
     RETURN failure code, or else this is a 4GL bug. */
  
  /* look for changed header/footer */
  check-loop:
  FOR EACH wt-header:
    wt-octn = wt-octn + 1.
          
    FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = wt-header.hpos NO-ERROR.

    IF AVAILABLE qbf-hsys THEN
    DO qbf-i = 1 TO 8:         
      IF wt-header.htxt[qbf-i] <> qbf-hsys.qbf-htxt[qbf-i] THEN LEAVE.
    END.

    IF NOT AVAILABLE qbf-hsys OR (AVAILABLE qbf-hsys AND qbf-i <= 8) THEN
      ASSIGN
        qbf-redraw = TRUE
        lRet       = TRUE
	qbf-dirty  = TRUE.
  END.

  /* to handle when one or more of the input fields is cleared */
  IF wt-ictn <> wt-octn THEN
    ASSIGN
      qbf-redraw = TRUE
      lRet       = TRUE
      qbf-dirty  = TRUE.
      
  FOR EACH qbf-hsys: DELETE qbf-hsys. END.

  /* header/footer existed coming in and all have been deleted, so return. */
  IF hdr-ftr AND NOT CAN-FIND(FIRST wt-header) THEN DO:
    ASSIGN
      qbf-redraw = TRUE
      lRet       = TRUE
      qbf-dirty  = TRUE.
    RETURN.
  END.

  /* purge empty header/footers */
  FOR EACH wt-header:
    DO qbf-i = 1 TO EXTENT(wt-header.htxt):
      IF TRIM(wt-header.htxt[qbf-i]) <> "" THEN LEAVE.
    END.
    IF qbf-i > EXTENT(wt-header.htxt) THEN DELETE wt-header.
  END.
     
  /* copy wt-header to permanent qbf-hsys storage */
  FOR EACH wt-header:
    CREATE qbf-hsys.
    ASSIGN
      qbf-hsys.qbf-hpos = wt-header.hpos
      qbf-hsys.qbf-hmax = wt-header.hmax
      .
    DO qbf-i = 1 TO 8:
      ASSIGN
        qbf-hsys.qbf-htxt[qbf-i] = wt-header.htxt[qbf-i]
        qbf-hsys.qbf-hgen[qbf-i] = wt-header.hgen[qbf-i]
        qbf-hsys.qbf-hwid[qbf-i] = wt-header.hwid[qbf-i] 
        .
    END.
  END.
END.

ON CHOOSE OF qbf-clear IN FRAME qbf%input DO:
  RUN adecomm/_setcurs.p ("WAIT":u). 
  FOR EACH wt-header:
    DELETE wt-header.
  END.

  ASSIGN
    qbf-e      = ""
    qbf-e:SCREEN-VALUE IN FRAME qbf%input = "".
  
  DO qbf-i = 1 TO 10:
    qbf-q = qbf-a[qbf-i]:LOAD-IMAGE("adeicon/header":u
          + STRING(IF qbf-i < 10 THEN qbf-i ELSE 0)).
  END.
  RUN adecomm/_setcurs.p ("":u). 
END.

ON DEFAULT-ACTION OF qbf-s IN FRAME qbf%input DO:
  DEFINE VARIABLE qbf_f AS CHARACTER NO-UNDO. /* insertion format */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* index */
  DEFINE VARIABLE qbf_s AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* insertion text */

  qbf_i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF qbf_i = 0 THEN RETURN NO-APPLY.

  CASE qbf_i:
    WHEN 0 THEN RETURN NO-APPLY.
    WHEN 1 THEN qbf_t = qbf-left + "TODAY":u + qbf-right.
    WHEN 2 THEN qbf_t = qbf-left + "TIME":u  + qbf-right.
    WHEN 3 THEN qbf_t = qbf-left + "NOW":u   + qbf-right.
    WHEN 4 THEN qbf_t = qbf-left + "COUNT":u + qbf-right.
    WHEN 5 THEN qbf_t = qbf-left + "PAGE":u  + qbf-right.
    WHEN 6 THEN qbf_t = qbf-left + "USER":u  + qbf-right.
    WHEN 7 THEN DO: /* value */
      qbf_t = "".
      RUN aderes/j-field1.p (qbf-tables,"$#@!sdnl12345":u,"Insert Field":t32,
                             "",INPUT-OUTPUT qbf_t,INPUT-OUTPUT qbf-c).

      IF qbf_t = "" THEN RETURN NO-APPLY.

      RUN alias_to_tbname (qbf_t,TRUE,OUTPUT refName).
      RUN adecomm/_y-schem.p (refName,"","",OUTPUT qbf_f).
      qbf_t = SUBSTITUTE("&1VALUE &2~;&3&4":u,
                         qbf-left,qbf_t,ENTRY(2,qbf_f,CHR(10)),qbf-right).
    END.
  END CASE.

  qbf_s = qbf-e:INSERT-STRING(qbf_t) IN FRAME qbf%input.
  APPLY "ENTRY":u TO qbf-e IN FRAME qbf%input.
  RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF FRAME qbf%input 
  OR CHOOSE OF qbf-ee IN FRAME qbf%input DO:
  lRet = FALSE.
  APPLY "END-ERROR":u TO SELF.
END.

/*----------------------------- Main Code Block ------------------------------------*/

ASSIGN
  qbf-e:RETURN-INSERTED IN FRAME qbf%input = TRUE
  list-1 = SUBSTITUTE(
         "&1TODAY&2 ":u  + "Today's date":t50
       + ",&1TIME&2  ":u + "Time report started":t50
       + ",&1NOW&2   ":u + "Current time":t50
       + ",&1COUNT&2 ":u + "Records listed so far":t50
       + ",&1PAGE&2  ":u + "Current page number":t50
       + ",&1USER&2  ":u + "User running report":t50
       ,qbf-left,qbf-right,"expression":t16,"format":t16)
  list-2 = list-1 + SUBSTITUTE(
         ",&1VALUE <&3>~;<&4>&2 ":u + "to insert variables":t35
        ,qbf-left,qbf-right,"expression":t16,"format":t16)

  /* set button positions and size bounding rectangle */
  qbf-r1:Y IN FRAME qbf%input      = qbf-p:HEIGHT-PIXELS IN FRAME qbf%input / 2 
                                   + qbf-p:Y

  qbf-p:COL IN FRAME qbf%input     = qbf-r1:COL + .5
  qbf-p:WIDTH-PIXELS IN FRAME qbf%input = 
    FONT-TABLE:GET-TEXT-WIDTH-PIXELS(qbf-p)

  qbf-b9:X IN FRAME qbf%input      = qbf-r1:X IN FRAME qbf%input + 6
  qbf-b9:Y IN FRAME qbf%input      = qbf-p:HEIGHT-PIXELS IN FRAME qbf%input 
                                   + qbf-p:Y + 4
  qbf-b7:X IN FRAME qbf%input      = qbf-b9:X IN FRAME qbf%input + 2
                                   + qbf-b9:WIDTH-PIXELS IN FRAME qbf%input
  qbf-b7:Y IN FRAME qbf%input      = qbf-b9:Y IN FRAME qbf%input
  qbf-b1:X IN FRAME qbf%input      = qbf-b9:X IN FRAME qbf%input
  qbf-b1:Y IN FRAME qbf%input      = qbf-b9:Y IN FRAME qbf%input + 2
                                   + qbf-b9:HEIGHT-PIXELS IN FRAME qbf%input
  qbf-b2:X IN FRAME qbf%input      = qbf-b7:X IN FRAME qbf%input
  qbf-b2:Y IN FRAME qbf%input      = qbf-b1:Y IN FRAME qbf%input
  qbf-b3:X IN FRAME qbf%input      = qbf-b7:X IN FRAME qbf%input + 2
                                   + qbf-b7:WIDTH-PIXELS IN FRAME qbf%input
  qbf-b3:Y IN FRAME qbf%input      = qbf-b1:Y IN FRAME qbf%input
  qbf-b4:X IN FRAME qbf%input      = qbf-b9:X IN FRAME qbf%input
  qbf-b4:Y IN FRAME qbf%input      = qbf-b1:Y IN FRAME qbf%input + 2
                                   + qbf-b1:HEIGHT-PIXELS IN FRAME qbf%input
  qbf-b5:X IN FRAME qbf%input      = qbf-b7:X IN FRAME qbf%input
  qbf-b5:Y IN FRAME qbf%input      = qbf-b4:Y IN FRAME qbf%input
  qbf-b6:X IN FRAME qbf%input      = qbf-b3:X IN FRAME qbf%input
  qbf-b6:Y IN FRAME qbf%input      = qbf-b4:Y IN FRAME qbf%input
  qbf-b8:X IN FRAME qbf%input      = qbf-b7:X IN FRAME qbf%input
  qbf-b8:Y IN FRAME qbf%input      = qbf-b4:Y IN FRAME qbf%input + 2
                                   + qbf-b4:HEIGHT-PIXELS IN FRAME qbf%input
  qbf-b0:X IN FRAME qbf%input      = qbf-b3:X IN FRAME qbf%input
  qbf-b0:Y IN FRAME qbf%input      = qbf-b8:Y IN FRAME qbf%input

  qbf-r1:HEIGHT-PIXELS IN FRAME qbf%input = qbf-b0:Y IN FRAME qbf%input + 6
                                   + qbf-b0:HEIGHT-PIXELS IN FRAME qbf%input
                                   - qbf-r1:Y IN FRAME qbf%input
  qbf-r1:WIDTH-PIXELS IN FRAME qbf%input  = qbf-b0:X IN FRAME qbf%input + 6
                                   + qbf-b0:WIDTH-PIXELS IN FRAME qbf%input
                                   - qbf-r1:X IN FRAME qbf%input
  .

ASSIGN
  qbf-r2:WIDTH-PIXELS IN FRAME qbf%input  =
                                   qbf-b9:WIDTH-PIXELS IN FRAME qbf%input + 4
  qbf-r2:HEIGHT-PIXELS IN FRAME qbf%input =
                                   qbf-b9:HEIGHT-PIXELS IN FRAME qbf%input + 4

  qbf-m:COL IN FRAME qbf%input     = qbf-r1:COL IN FRAME qbf%input
                                   + qbf-r1:WIDTH IN FRAME qbf%input + 1
  qbf-e:HEIGHT IN FRAME qbf%input  = qbf-e:HEIGHT IN FRAME qbf%input
  qbf-e:COL IN FRAME qbf%input     = qbf-m:COL IN FRAME qbf%input
  qbf-clear:COL IN FRAME qbf%input = qbf-e:COL IN FRAME qbf%input 
  qbf-clear:ROW IN FRAME qbf%input = qbf-e:ROW IN FRAME qbf%input 
                                   + qbf-e:HEIGHT IN FRAME qbf%input
                                   + ({&VM_WID})
  
  qbf-s:HEIGHT IN FRAME qbf%input  = qbf-s:HEIGHT IN FRAME qbf%input
  qbf-s:WIDTH IN FRAME qbf%input   = qbf-s:WIDTH IN FRAME qbf%input 
                                   - shrink-hor-2
  qbf-y:WIDTH IN FRAME qbf%input   = qbf-s:WIDTH IN FRAME qbf%input
  
  FRAME qbf%input:VIRTUAL-WIDTH    = FRAME qbf%input:VIRTUAL-WIDTH 
                                   - shrink-hor-2
  qbf-e:WIDTH IN FRAME qbf%input   = FRAME qbf%input:WIDTH
                                   - qbf-e:COL IN FRAME qbf%input
  qbf-m:WIDTH IN FRAME qbf%input   = qbf-e:WIDTH IN FRAME qbf%input
  .

ASSIGN
  qbf-a[ 1] = qbf-b1:HANDLE IN FRAME qbf%input
  qbf-a[ 2] = qbf-b2:HANDLE IN FRAME qbf%input
  qbf-a[ 3] = qbf-b3:HANDLE IN FRAME qbf%input
  qbf-a[ 4] = qbf-b4:HANDLE IN FRAME qbf%input
  qbf-a[ 5] = qbf-b5:HANDLE IN FRAME qbf%input
  qbf-a[ 6] = qbf-b6:HANDLE IN FRAME qbf%input
  qbf-a[ 7] = qbf-b7:HANDLE IN FRAME qbf%input
  qbf-a[ 8] = qbf-b8:HANDLE IN FRAME qbf%input
  qbf-a[ 9] = qbf-b9:HANDLE IN FRAME qbf%input
  qbf-a[10] = qbf-b0:HANDLE IN FRAME qbf%input
  .

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME qbf%input" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* load header/footer temp-table */
FOR EACH qbf-hsys:
  CREATE wt-header.
  ASSIGN
    wt-header.hpos = qbf-hsys.qbf-hpos
    wt-header.hmax = qbf-hsys.qbf-hmax
    hdr-ftr        = TRUE
    wt-ictn        = wt-ictn + 1
    .
    
  DO qbf-i = 1 TO 8:
    ASSIGN
      wt-header.htxt[qbf-i] = qbf-hsys.qbf-htxt[qbf-i]
      wt-header.hgen[qbf-i] = qbf-hsys.qbf-hgen[qbf-i]
      wt-header.hwid[qbf-i] = qbf-hsys.qbf-hwid[qbf-i]
      .
  END.
  
END.

/* load images and set colors */
DO qbf-i = 1 TO 10:
  FIND FIRST wt-header WHERE wt-header.hpos = qbf-i NO-ERROR.
  
  IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN
    qbf-q = qbf-a[qbf-i]:LOAD-IMAGE("adeicon/header":u
          + STRING(IF qbf-i < 10 THEN qbf-i ELSE 0) 
          + (IF AVAILABLE wt-header THEN "x":u ELSE "")).
  ELSE
    ASSIGN
      qbf-a[qbf-i]:FGCOLOR = (IF AVAILABLE wt-header THEN 15 ELSE 0)
      qbf-a[qbf-i]:BGCOLOR = (IF AVAILABLE wt-header THEN  1 ELSE 7).
END.

DISPLAY qbf-y qbf-p WITH FRAME qbf%input.
ENABLE
  qbf-b9 qbf-b7
  qbf-b1 qbf-b2 qbf-b3
  qbf-b4 qbf-b5 qbf-b6
         qbf-b8 qbf-b0
  qbf-e qbf-clear qbf-s qbf-ok qbf-ee qbf-help
  WITH FRAME qbf%input.

RUN switch_em (1, OUTPUT qbf-q). /* set initial mode */

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf%input FOCUS qbf-e IN FRAME qbf%input.
END.

HIDE FRAME qbf%input NO-PAUSE.

RETURN.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROCEDURE switch_em:
  DEFINE INPUT  PARAMETER qbf_n AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_l AS LOGICAL NO-UNDO. /* all OK */

  DEFINE VARIABLE qbf_a         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE qbf_i         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_m         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf_t         AS CHARACTER NO-UNDO.
     
  ASSIGN
    qbf_i = NUM-ENTRIES(RIGHT-TRIM(qbf-e:SCREEN-VALUE IN FRAME qbf%input), 
                        CHR(10))
    qbf_l = (qbf_i <= 8).

  IF qbf_i > 8 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_a,"warning":u,"ok":u, 
      SUBSTITUTE("The &1 has &2 lines, &3 more than the maximum of 8.  Remove the extra &4 before continuing.",
      qbf-t[qbf-l],qbf_i, qbf_i - 8,
      "line" + (IF qbf_i - 8 > 1 THEN "s" ELSE ""))). 

    APPLY "ENTRY":u TO qbf-e IN FRAME qbf%input.
    RETURN.
  END.

  IF qbf_n <> qbf-b THEN DO:
    /* This fails when using VALUE function, because we're determining width 
       based on the VALUE expression, NOT the display format. Need to fix. -dma
    /* check for header exceeding page width */
    FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

    DO qbf_m = 1 TO qbf_i:
      IF LENGTH(ENTRY(qbf_m, qbf-e:SCREEN-VALUE IN FRAME qbf%input, 
                      CHR(10)),"RAW":u) > qbf-rsys.qbf-width THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf_a,"warning":u,"ok":u, 
          SUBSTITUTE("Header/footer text cannot exceed the page width.  Reduce the number of characters on line &1 of &2.",
          qbf_m,qbf-t[qbf_n])).
          
        qbf_l = FALSE.
        RETURN.
      END.
    END.
    */

    RELEASE wt-header.
    IF qbf-b > 0 THEN DO:
      FIND FIRST wt-header WHERE wt-header.hpos = qbf-b NO-ERROR.
      IF NOT AVAILABLE wt-header THEN 
        CREATE wt-header.
    END.

    qbf_t = RIGHT-TRIM(qbf-e:SCREEN-VALUE IN FRAME qbf%input).
    IF AVAILABLE wt-header AND (qbf_t = "" OR qbf_t = ?) THEN 
      DELETE wt-header.
    IF AVAILABLE wt-header THEN DO:
      ASSIGN
        wt-header.htxt = ""
        wt-header.hpos = qbf-b
        qbf_m          = NUM-ENTRIES(qbf_t,CHR(10)).

      DO qbf_i = 1 TO MINIMUM(qbf_m,EXTENT(wt-header.htxt)):
        wt-header.htxt[qbf_i] = ENTRY(qbf_i, qbf_t, CHR(10)).
      END.
    END.

    IF qbf-b > 0 THEN DO:
      IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN
        qbf_a = qbf-a[qbf-b]:LOAD-IMAGE("adeicon/header":u
              + STRING(IF qbf-b < 10 THEN qbf-b ELSE 0) 
              + (IF AVAILABLE wt-header THEN "x":u ELSE "")).
      ELSE
        ASSIGN
          qbf-a[qbf-b]:FGCOLOR = (IF AVAILABLE wt-header THEN 15 ELSE 0)
          qbf-a[qbf-b]:BGCOLOR = (IF AVAILABLE wt-header THEN  1 ELSE 7).
    END.
    
    IF qbf_n > 0 THEN DO:
      FIND FIRST wt-header WHERE wt-header.hpos = qbf_n NO-ERROR.
      qbf_t = "".
      IF AVAILABLE wt-header THEN DO:
        DO qbf_m = EXTENT(wt-header.htxt) TO 1 BY -1
          WHILE wt-header.htxt[qbf_m] = "":
        END.
        DO qbf_i = 1 TO qbf_m:
          qbf_t = qbf_t + (IF qbf_i = 1 THEN "" ELSE CHR(10))
                + wt-header.htxt[qbf_i].
        END.
      END.
      ASSIGN
        qbf-e:SCREEN-VALUE IN FRAME qbf%input = qbf_t
        qbf-b                                 = qbf_n
        qbf-r2:X IN FRAME qbf%input           = qbf-a[qbf-b]:X - 2
        qbf-r2:Y IN FRAME qbf%input           = qbf-a[qbf-b]:Y - 2
        qbf-q = qbf-r2:MOVE-TO-TOP() IN FRAME qbf%input
        qbf-m:SCREEN-VALUE IN FRAME qbf%input = SUBSTITUTE(qbf-m,qbf-t[qbf_n])
        qbf-s:LIST-ITEMS IN FRAME qbf%input   = ""
        qbf-s:LIST-ITEMS IN FRAME qbf%input   = IF qbf_n > 6 THEN 
                                                  list-1 ELSE list-2
        .
    END.
  END.

  /* set last position */
  qbf-l = qbf_n.
  APPLY "ENTRY":u TO qbf-e IN FRAME qbf%input.
END PROCEDURE.

/* r-header.p - end of file */

