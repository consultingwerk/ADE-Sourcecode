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
 * l-edit.p - label-purpose editor
 */

&GLOBAL-DEFINE WIN95-BTN YES
&GLOBAL-DEFINE UseFormat FALSE

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/l-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i  }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER lRet AS LOGICAL NO-UNDO. /* changes made */

DEFINE VARIABLE qbf-a    AS LOGICAL      NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c    AS CHARACTER    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i    AS INTEGER      NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k    AS INTEGER      NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l    AS LOGICAL      NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-o    LIKE qbf-l-text NO-UNDO. /* original layout */
DEFINE VARIABLE refName  AS CHARACTER    NO-UNDO.

DEFINE VARIABLE v_begin  AS CHARACTER    NO-UNDO. /* original layout */
DEFINE VARIABLE v_editor AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_error  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE v_field  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_format AS CHARACTER    NO-UNDO.

FIND FIRST qbf-lsys.
DEFINE BUTTON qbf-ok    LABEL "OK"                {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee    LABEL "Cancel"            {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help  LABEL "&Help"             {&STDPH_OKBTN}.
DEFINE BUTTON qbf-ins   LABEL "Insert &Field...":c16 {&STDPH_FILL}.
DEFINE BUTTON qbf-rest  LABEL "&Restore Layout":c16  {&STDPH_FILL}.
DEFINE BUTTON qbf-clear LABEL "&Clear All":c16       {&STDPH_FILL}.

/* standard button rectangle */
DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.

FORM
  SKIP({&TFM_WID})
  v_editor AT 2 
    VIEW-AS EDITOR INNER-CHARS 50 INNER-LINES 12 
    SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL NO-WORD-WRAP {&STDPH_EDITOR}

  SPACE({&HFM_WID}) qbf-ins SKIP({&VM_WID})
  qbf-rest AT COLUMN-OF qbf-ins ROW 1
  qbf-clear AT COLUMN-OF qbf-ins ROW 1 SKIP(8)

  {adecomm/okform.i
     &BOX    = rect_btns
     &STATUS = no
     &OK     = qbf-ok
     &CANCEL = qbf-ee
     &HELP   = qbf-help}

  WITH FRAME fr_label NO-LABELS NO-ATTR-SPACE OVERLAY THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee SCROLLABLE
  VIEW-AS DIALOG-BOX TITLE "Label Layout".

/* ----------------------------------------------------------------------- */

ON HELP OF FRAME fr_label OR CHOOSE OF qbf-help IN FRAME fr_label
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,{&Label_Layout_Dlg_Box},?).

ON GO OF FRAME fr_label DO:
  ASSIGN    
    qbf-l-text = ""
    v_error    = FALSE
    qbf-c      = ""
    .

  IF v_begin <> v_editor:SCREEN-VALUE THEN
    ASSIGN
      lRet       = TRUE
      qbf-redraw = TRUE
      qbf-dirty  = TRUE
      .

  v_editor = REPLACE(v_editor:SCREEN-VALUE IN FRAME fr_label,"~~":u,"").

  IF v_editor > "" THEN DO:
    DO qbf-i = 1 TO MINIMUM(NUM-ENTRIES(v_editor,CHR(10)),
                            EXTENT(qbf-l-text)):
      ASSIGN
        qbf-c             = qbf-c + CHR(10) 
                          + REPLACE(qbf-o[qbf-i],"~~":u,"")
        qbf-l-text[qbf-i] = ENTRY(qbf-i,v_editor,CHR(10)).
    END.

    REPEAT: 
      RUN validate_label (yes,OUTPUT v_error).
    
      IF v_error THEN DO:
        qbf-c = "".
     
        IF NOT qbf-l THEN
          RETURN NO-APPLY.
      END.
      ELSE LEAVE.
    END.
  END.
 
  DO qbf-i = EXTENT(qbf-l-text) TO 1 BY -1:
    IF qbf-l-text[qbf-i] > "" THEN LEAVE.
  END.

  IF qbf-i > qbf-lsys.qbf-label-ht THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"ok":u,
      SUBSTITUTE("Your label height is &1, but you have &2 lines defined.  Some information will not fit with the label height you have defined, and will not be displayed or printed.",
      qbf-lsys.qbf-label-ht, qbf-i)).
END.

ON CHOOSE OF qbf-ins IN FRAME fr_label DO:
  /* are we inside another field? naughty, naughty */
  ASSIGN
    qbf-i = v_editor:CURSOR-LINE IN FRAME fr_label
    qbf-c = ENTRY(qbf-i,v_editor:SCREEN-VALUE IN FRAME fr_label,CHR(10))
    qbf-k = v_editor:CURSOR-CHAR IN FRAME fr_label
    qbf-l = FALSE
    .

  /* look to the right for a right-brace */
  DO qbf-i = qbf-k TO LENGTH(qbf-c,"CHARACTER":u) 
    WHILE qbf-k > 1 AND qbf-k <= LENGTH(qbf-c,"CHARACTER":u):
    IF SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u) = qbf-left THEN LEAVE.
    IF SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u) = qbf-right THEN DO:
      qbf-l = TRUE. 
      LEAVE.
    END.
  END.

  /* look to the left for a left-brace */
  DO qbf-i = (qbf-k - 1) TO 1 BY -1 WHILE qbf-k > 1:
    IF SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u) = qbf-right THEN LEAVE.
    IF SUBSTRING(qbf-c,qbf-i,1,"CHARACTER":u) = qbf-left THEN DO:
      qbf-l = TRUE. 
      LEAVE.
    END.
  END.

  IF qbf-l THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u, 
      "You may not insert a field within another field.  Move the insertion point and select INSERT FIELD again.").
    LEAVE.
  END.

  ASSIGN
    qbf-c   = ""
    v_field = "".

  RUN aderes/j-field1.p (qbf-tables,"$#@!12345sdnl":u,"Insert Field":t32,"",
                         INPUT-OUTPUT v_field,INPUT-OUTPUT qbf-c).

  IF v_field = "" THEN 
    RETURN NO-APPLY.

  IF NUM-ENTRIES(v_field,".":u) = 3 
    AND ENTRY(2,v_field,".":u) = "Calc Field" THEN
    v_field = ENTRY(3,v_field,".":u).

  &IF {&UseFormat} &THEN
    RUN alias_to_tbname(v_field,TRUE,OUTPUT refName).
    RUN adecomm/_y-schem.p (refName,"","",OUTPUT v_format).
    v_field = qbf-left + v_field + "~;":u 
            + ENTRY(2, v_format, CHR(10)) + qbf-right.
  &ELSE
    v_field = qbf-left + v_field + qbf-right.
  &ENDIF

  ASSIGN
    qbf-l    = v_editor:INSERT-STRING(v_field) IN FRAME fr_label
    /*v_editor = v_editor:SCREEN-VALUE IN FRAME fr_label*/
    qbf-rest:SENSITIVE IN FRAME fr_label  = TRUE 
    qbf-clear:SENSITIVE IN FRAME fr_label = TRUE 
    .
    
  APPLY "ENTRY":u TO v_editor IN FRAME fr_label.
END.

ON CHOOSE OF qbf-ee IN FRAME fr_label OR END-ERROR OF FRAME fr_label 
  RUN restore_label.

ON CHOOSE OF qbf-rest IN FRAME fr_label DO:
  RUN restore_label.
  RUN init_label.
END.

ON CHOOSE OF qbf-clear IN FRAME fr_label DO:
  ASSIGN
    v_editor = ""
    v_editor:SCREEN-VALUE IN FRAME fr_label = "".
END.

ON WINDOW-CLOSE OF FRAME fr_label
  APPLY "END-ERROR":u TO SELF.             

/* ----------------------------------------------------------------------- */

ASSIGN
  /* put run-time adjustment for screen resolution & font here, 
     before frame is visible */
  v_editor:WIDTH-CHARS IN FRAME fr_label   =
    v_editor:WIDTH-CHARS IN FRAME fr_label - shrink-hor-2

  qbf-rest:ROW IN FRAME fr_label           = qbf-ins:ROW IN FRAME fr_label
                                           + qbf-ins:HEIGHT IN FRAME fr_label
                                           + {&VM_WID}
  qbf-clear:ROW IN FRAME fr_label          = qbf-rest:ROW IN FRAME fr_label
                                           + qbf-ins:HEIGHT IN FRAME fr_label
                                           + {&VM_WID}
                                           
  qbf-ins:COLUMN IN FRAME fr_label         = v_editor:COLUMN IN FRAME fr_label
                                           + v_editor:WIDTH IN FRAME fr_label
                                           + 1
  qbf-rest:COLUMN IN FRAME fr_label        = qbf-ins:COLUMN IN FRAME fr_label
  qbf-clear:COLUMN IN FRAME fr_label       = qbf-ins:COLUMN IN FRAME fr_label
                                             
  qbf-ins:WIDTH-PIXELS IN FRAME fr_label    = qbf-rest:WIDTH-PIXELS 
                                               IN FRAME fr_label
  qbf-clear:WIDTH-PIXELS IN FRAME fr_label = qbf-rest:WIDTH-PIXELS 
                                               IN FRAME fr_label
  FRAME fr_label:VIRTUAL-WIDTH             = 
    FRAME fr_label:VIRTUAL-WIDTH - shrink-hor-2
  .

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i
   &FRAME = "FRAME fr_label"
   &BOX   = "rect_btns"
   &OK    = "qbf-ok"
   &HELP  = "qbf-help"
}

&IF {&OKBOX} &THEN
ASSIGN
  FRAME fr_label:HEIGHT           = FRAME fr_label:HEIGHT + 1
  rect_btns:ROW IN FRAME fr_label = rect_btns:ROW IN FRAME fr_label + 1
  qbf-ok:ROW IN FRAME fr_label    = qbf-ok:ROW IN FRAME fr_label + 1
  qbf-ee:ROW IN FRAME fr_label    = qbf-ok:ROW IN FRAME fr_label
  qbf-help:ROW IN FRAME fr_label  = qbf-ok:ROW IN FRAME fr_label
  .
&ENDIF

RUN original. /* store away inital label state */

v_editor:RETURN-INSERT IN FRAME fr_label = TRUE.

RUN init_label. /* load label text array into editor widget */
v_begin = v_editor:SCREEN-VALUE IN FRAME fr_label.

ENABLE v_editor qbf-ins qbf-rest qbf-clear qbf-ok qbf-ee qbf-help 
  WITH FRAME fr_label.

RUN validate_label (no, OUTPUT v_error).

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME fr_label FOCUS v_editor IN FRAME fr_label.
END.

HIDE FRAME fr_label NO-PAUSE.

RETURN.

/* ----------------------------------------------------------------------- */

PROCEDURE original:
  DO qbf-i = 1 TO EXTENT(qbf-l-text):
    qbf-o[qbf-i] = qbf-l-text[qbf-i].
  END.
END PROCEDURE.

/* ----------------------------------------------------------------------- */

PROCEDURE init_label:
  DEFINE VARIABLE empty AS INTEGER NO-UNDO.

  v_editor = "".

  DO qbf-i = 1 TO EXTENT(qbf-l-text):
    v_editor = (IF qbf-i = 1 THEN "" ELSE v_editor + CHR(10))
             + qbf-l-text[qbf-i].
    IF qbf-l-text[qbf-i] = "" THEN
      empty = empty + 1.
  END.

  v_editor:SCREEN-VALUE IN FRAME fr_label = 
    (IF empty = EXTENT(qbf-l-text) THEN "" ELSE v_editor).
END PROCEDURE.

/* ----------------------------------------------------------------------- */

PROCEDURE restore_label:
  /* restore qbf-l-text to its original state */
  DO qbf-i = 1 TO EXTENT(qbf-l-text):
    qbf-l-text[qbf-i] = qbf-o[qbf-i].
  END.
END PROCEDURE.

/* ----------------------------------------------------------------------- */

PROCEDURE validate_label:
  DEFINE INPUT  PARAMETER v_prompt AS LOGICAL NO-UNDO. /* prompt to fix */
  DEFINE OUTPUT PARAMETER v_error  AS LOGICAL NO-UNDO.

  DEFINE VARIABLE v_line    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE v_text    AS CHARACTER NO-UNDO.

  DO WHILE TRUE:  
    RUN aderes/l-verify.p (TRUE, OUTPUT v_line, OUTPUT v_text).
    IF v_line = 0 THEN LEAVE.
 
    ASSIGN
      qbf-l   = TRUE
      v_error = TRUE.

    RUN highlight (v_line, v_text). 

    IF v_prompt THEN DO:
      qbf-l = FALSE.

      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"yes-no":u, 
        "The highlighted field is not available.^^Press YES if you want the program to automatically delete the field or NO if you want to correct the error yourself.").
    END.

    IF qbf-l THEN DO:
      SUBSTRING(qbf-l-text[v_line], 
                v_editor:CURSOR-CHAR IN FRAME fr_label
                  - LENGTH(v_text,"RAW":u),
                LENGTH(v_text,"RAW":U),"RAW":u) = "".

      RUN original.   /* reset 'original' label state */
      RUN init_label.
    END.
    
    IF v_prompt THEN LEAVE.
  END.
END PROCEDURE.

/* ----------------------------------------------------------------------- */

PROCEDURE highlight:
  DEFINE INPUT PARAMETER qbf-t AS INTEGER   NO-UNDO. /* error line # */
  DEFINE INPUT PARAMETER qbf-s AS CHARACTER NO-UNDO. /* error text */

  DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

  IF v_editor:SCREEN-VALUE IN FRAME fr_label BEGINS qbf-s THEN
    qbf-l = v_editor:SET-SELECTION(1,LENGTH(qbf-s,"RAW":u) + 1) 
              IN FRAME fr_label.
  ELSE DO:
    ASSIGN
      /*v_editor:CURSOR-OFFSET IN FRAME fr_label = 1*/
      v_editor:CURSOR-LINE IN FRAME fr_label = qbf-t
      qbf-l = v_editor:SEARCH(qbf-s, FIND-NEXT-OCCURRENCE) IN FRAME fr_label
      qbf-i = v_editor:CURSOR-OFFSET IN FRAME fr_label.

    IF qbf-l THEN
      qbf-l = v_editor:SET-SELECTION(qbf-i - LENGTH(qbf-s,"RAW":u), qbf-i)
                IN FRAME fr_label.
    ELSE
      v_editor:CURSOR-OFFSET IN FRAME fr_label
        = LENGTH(v_editor:SCREEN-VALUE IN FRAME fr_label,"RAW":u).
  END.
END PROCEDURE. /* highlight */

/* l-edit.p - end of file */

