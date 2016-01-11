/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _fbprop.p - Frame property dialog box for the Form and Browse Views.

   Output Parameter:
      p_ok - TRUE if user made changes, FALSE if they cancelled out.
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/y-define.i }
{ aderes/fbdefine.i }
{ aderes/_fdefs.i }
{ aderes/s-menu.i }
{ adecomm/adestds.i }
{ aderes/reshlp.i }

DEFINE OUTPUT PARAMETER p_ok AS LOGICAL NO-UNDO. 

DEFINE VARIABLE fr_list AS CHARACTER NO-UNDO
  VIEW-AS SELECTION-LIST SINGLE INNER-LINES 3 INNER-CHARS 40 SCROLLBAR-H.

DEFINE VARIABLE cnt      AS INTEGER   NO-UNDO.
DEFINE VARIABLE flags    AS CHARACTER NO-UNDO.
DEFINE VARIABLE fr_bht   AS INTEGER   NO-UNDO. /* browse height */
DEFINE VARIABLE fr_ix    AS INTEGER   NO-UNDO. /* index into qbf-frame arrays */
DEFINE VARIABLE fr_ro    AS LOGICAL   NO-UNDO. /* read only */
DEFINE VARIABLE fr_row   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-type   AS INTEGER   NO-UNDO.
DEFINE VARIABLE init_ix  AS INTEGER   NO-UNDO. /* index of initial selected frame */
DEFINE VARIABLE ix       AS INTEGER   NO-UNDO.
DEFINE VARIABLE nam_lst  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE qbf-l    AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE stat     AS LOGICAL   NO-UNDO.

DEFINE BUTTON qbf-ok   LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON qbf-ee   LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON qbf-help LABEL "&Help"  {&STDPH_OKBTN}.
/* standard button rectangle */
DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.

/* List of original read-only states based on read-only flag and
   master-detail state, one for each frame. Probably only 
   need 2 but make it 10 for safety.  An array is easier than comma 
   separated list and slightly simpler than a temp table.
   Also keep original browse heights.
*/
DEFINE VARIABLE updateable AS LOGICAL NO-UNDO EXTENT 10. 
DEFINE VARIABLE browseht   AS INTEGER NO-UNDO EXTENT 10.

&GLOBAL-DEFINE FORM_UPDATEABLE (INDEX(qbf-frame.qbf-fflg[fr_ix],"r":u) = 0 AND ~
      	       	     	      	NUM-ENTRIES(qbf-section.qbf-stbl) = 1)

FORM
   SKIP({&TFM_WID})
   "Selected frame will be moved to the front." 
      	    AT 10    VIEW-AS TEXT SIZE 45 BY 1
   SKIP({&VM_WID})

   fr_list  COLON 8  LABEL "&Frames"			  
   SKIP({&VM_WIDG})

   fr_row   COLON 8  LABEL "&Row"           FORMAT ">9":u {&STDPH_FILL}
     VALIDATE(fr_row > 0,"Row must be at least 1.")
   fr_ro    AT 33    LABEL "Read-&Only"     VIEW-AS TOGGLE-BOX
   fr_bht   AT ROW-OF fr_ro COL-OF fr_ro - 5        
      	       	     LABEL "&Browse Height" FORMAT ">9":u  {&STDPH_FILL}

   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = qbf-ok
      &CANCEL = qbf-ee
      &HELP   = qbf-help}

   WITH FRAME fr_prop SIDE-LABELS THREE-D
   DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee KEEP-TAB-ORDER
   TITLE "Frame Properties" VIEW-AS DIALOG-BOX.

/*============================Triggers====================================*/

h-type = IF qbf-module = "b":u THEN
           {&Browse_Frame_Properties_Dlg_Box}
         ELSE 
           {&Form_Frame_Properties_Dlg_Box}.

ON HELP OF FRAME fr_prop OR CHOOSE OF qbf-help IN FRAME fr_prop
  RUN adecomm/_adehelp.p ("res":u,"CONTEXT":u,h-type,?).

ON DEFAULT-ACTION OF fr_list IN FRAME fr_prop 
  APPLY "GO":u TO FRAME fr_prop.

ON GO OF FRAME fr_prop DO:
   DEFINE VARIABLE new_updateable AS LOGICAL NO-UNDO.
   DEFINE VARIABLE dlghdl 	  AS HANDLE  NO-UNDO.

   RUN Check_Row.
   IF RETURN-VALUE = "error":u THEN
     RETURN NO-APPLY.  
   
   RUN Save_Current.
   
   qbf-frame.qbf-fflg[fr_ix] = qbf-frame.qbf-fflg[fr_ix] + "t":u.

   /* If updateable status has changed or browse height has changed,
      we'll have to regen the .p. 
      Otherwise, let's just apply the changes to the objects.
   */
   cnt = 0.
   FOR EACH qbf-section:
     FIND FIRST qbf-frame 
       WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.

     cnt = cnt + 1.
     IF qbf-module = "f":u THEN DO:
       new_updateable = {&FORM_UPDATEABLE}.
       IF updateable[cnt] <> new_updateable THEN DO:
         ASSIGN
           qbf-dirty = TRUE
           p_ok      = TRUE.
         RUN Status_Mod.
         RETURN.
       END.
     END.
     ELSE DO: /* browse view */
       IF browseht[cnt] <> qbf-frame.qbf-fbht THEN DO:
         ASSIGN
           qbf-dirty = TRUE
           p_ok      = TRUE.
         RUN Status_Mod.
         RETURN.
       END.
     END.

     /* Set the row and possibly resize. */
     RUN aderes/_fbresiz.p (qbf-frame.qbf-frow[fr_ix], qbf-section.qbf-shdl).

     IF INDEX(qbf-frame.qbf-fflg[fr_ix], "t":u) > 0 THEN 
       stat = qbf-section.qbf-shdl:MOVE-TO-TOP().
   END.

   /* Fake out RunDirty to think that we didn't make any changes so
      we don't apply U1 and go through regen loop.  
   */
   ASSIGN
     p_ok      = FALSE
     qbf-dirty = TRUE.
   RUN Status_Mod.
END.

/*-----LEAVE of ROW-----*/
ON LEAVE OF fr_row IN FRAME fr_prop DO:
  DEFINE VARIABLE junk   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE maxrow AS DECIMAL NO-UNDO.

  RUN Check_Row.
  IF RETURN-VALUE = "error":u THEN
    RETURN NO-APPLY.  
END.

/*-----LEAVE of BROWSE HEIGHT-----*/
ON LEAVE OF fr_bht IN FRAME fr_prop DO:
  /* Browse object must be at least 2 down. */
  IF INTEGER(SELF:SCREEN-VALUE) < 2 THEN DO:
    MESSAGE "2 is the minimum browse height allowed."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

/*-----VALUE CHANGED of FRAME LIST-----*/
ON VALUE-CHANGED OF fr_list IN FRAME fr_prop DO:
  DEFINE VARIABLE ix AS INTEGER NO-UNDO.

  /* Store the values from the previously selected list entry */
  RUN Save_Current.

  /* Display attributes for the frame just selected. */
  ix = fr_list:LOOKUP(SELF:SCREEN-VALUE).
  RUN Show_Frame_Props (ENTRY(ix, nam_lst)).
END.

/*-----WINDOW CLOSE-----*/
ON WINDOW-CLOSE OF FRAME fr_prop
  APPLY "END-ERROR":u TO SELF.             

/*=========================Internal Procedures============================*/

/*------------------------------------------------------------------------
   Display properties for the currently selected frame in the dialog box 
------------------------------------------------------------------------*/
PROCEDURE Show_Frame_Props:
  DEFINE INPUT PARAMETER p_fname AS CHARACTER NO-UNDO. /* frame name */

  /* This keeps the qbf-section and qbf-frame buffers in sync 
     with the last entry selected.
  */
  FIND FIRST qbf-section WHERE qbf-section.qbf-sfrm = p_fname.
  FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl.
  IF NOT fr_ro:HIDDEN IN FRAME fr_prop THEN
    fr_ro:SCREEN-VALUE IN FRAME fr_prop = 
      (IF INDEX(qbf-frame.qbf-fflg[fr_ix], "r":u) > 0 THEN "yes" ELSE "no").
  IF NOT fr_bht:HIDDEN IN FRAME fr_prop THEN
    fr_bht:SCREEN-VALUE = STRING(qbf-frame.qbf-fbht).

  /*fr_row:SCREEN-VALUE = STRING(qbf-frame.qbf-frow[fr_ix]).*/
  fr_row:SCREEN-VALUE = STRING(MAXIMUM(qbf-frame.qbf-frow[fr_ix] 
                                       - {&FB_MINROW} + 1, 1)).
END.

/*------------------------------------------------------------------------
   Save frame properties in temp table for currently selected frame.
------------------------------------------------------------------------*/
PROCEDURE Save_Current:
   DEFINE VARIABLE nrow AS DECIMAL NO-UNDO. /* new row value */
   DEFINE VARIABLE junk AS LOGICAL NO-UNDO.

   ASSIGN
     flags  = ""
     qbf-frame.qbf-frow[fr_ix] = INTEGER(fr_row:SCREEN-VALUE IN FRAME fr_prop)
                               + (IF lGlbToolbar THEN {&FB_MINROW} - 1 ELSE 0)
     .

   /* this is handled by VALIDATE in FORM statement -dma
   IF nrow <> qbf-frame.qbf-frow[fr_ix] THEN DO:
     RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u, 
       SUBSTITUTE("Row must be at least &1 based on your current view options.^^Row has been reset to &1.",
       nrow)).
   */       

   IF NOT fr_ro:HIDDEN IN FRAME fr_prop THEN
      qbf-frame.qbf-fflg[fr_ix] = flags + 
      	       	     	 (IF fr_ro:SCREEN-VALUE IN FRAME fr_prop = "yes":u
      	       	     	    THEN "r":u ELSE "").
   IF NOT fr_bht:HIDDEN IN FRAME fr_prop THEN
      qbf-frame.qbf-fbht = INTEGER(fr_bht:SCREEN-VALUE IN FRAME fr_prop).
END.

/*------------------------------------------------------------------------
   Check the row. It may not be good even if user never changed it 
   because the window may have been resized and we don't let them 
   put it on a row beyond the bottom of the window.
------------------------------------------------------------------------*/
PROCEDURE Check_Row:
  DEFINE VARIABLE junk   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE maxrow AS DECIMAL NO-UNDO.

  /* 4 is a fudge factor to account for title height and whatever? */
  maxrow = ROUND((qbf-win:HEIGHT 
            - (IF lGlbStatus THEN wGlbStatus:HEIGHT ELSE 0) - 4),1).
            
  IF INTEGER(fr_row:SCREEN-VALUE IN FRAME fr_prop) > maxrow THEN DO:
     RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l, "error":u, "ok":u,
       SUBSTITUTE("The largest appropriate row value is &1.",
         STRING(TRUNCATE(maxrow, 0)))).
     RETURN "error":u.
  END.
  RETURN "ok":u.
END.

/*------------------------------------------------------------------------
   Update status bar 'dirty' indicator.
------------------------------------------------------------------------*/
PROCEDURE Status_Mod:
  DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.

  qbf-c = (IF qbf-module = "f":u THEN "Form" ELSE "Browse") + " View (mod)". 

  RUN adecomm/_statdsp.p (wGlbStatus, 2, qbf-c).
END PROCEDURE.

/*===========================Mainline Code================================*/

ASSIGN
  fr_ix = (IF qbf-module = "f":u THEN {&F_IX} ELSE {&B_IX})
  fr_list:DELIMITER IN FRAME fr_prop = CHR(10).

/* Run time layout for button area.  This defines eff_frame_width */
{adecomm/okrun.i  
   &FRAME = "FRAME fr_prop" 
   &BOX   = "rect_btns"
   &OK    = "qbf-ok" 
   &HELP  = "qbf-help" }

/* Create qbf-frame records for each frame (section) if they're not 
   there already just to simplify things. */
ASSIGN
  cnt     = 0
  init_ix = 1.
  
FOR EACH qbf-section:
  FIND FIRST qbf-frame 
    WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
  IF NOT AVAILABLE qbf-frame THEN DO:
    CREATE qbf-frame.
    ASSIGN
      qbf-frame.qbf-ftbl        = qbf-section.qbf-stbl
      qbf-frame.qbf-frow[fr_ix] = qbf-section.qbf-shdl:ROW
      qbf-frame.qbf-fbht        = 
        (IF qbf-detail = 0 THEN {&BRW_HT_1} ELSE {&BRW_HT_2}).
  END.
  ELSE DO:
    /* get info from actual frame if we don't have it yet */
    IF qbf-frame.qbf-frow[fr_ix] = 0 THEN
      qbf-frame.qbf-frow[fr_ix] = qbf-section.qbf-shdl:ROW.
    IF qbf-frame.qbf-fbht = 0 THEN
      qbf-frame.qbf-fbht = 
        (IF qbf-detail = 0 THEN {&BRW_HT_1} ELSE {&BRW_HT_2}).

      /* Get rid of the "t" (top) flag since it will get reset at the end 
      	 and we don't want it to end up on more than one record.
      	 Remember which frame it was though so we can select it to start.
      */
      ix = INDEX(qbf-frame.qbf-fflg[fr_ix], "t":u).
      IF ix > 0 THEN
      	 ASSIGN
      	   init_ix = cnt + 1
      	   fr_list = qbf-section.qbf-shdl:TITLE
      	   SUBSTRING(qbf-frame.qbf-fflg[fr_ix],ix,1,"CHARACTER":u) = "".
   END.
   /* keep track of original updateable (read-only) status or
      browse height depending on the view.
   */
   cnt             = cnt + 1.
   IF qbf-module = "f":u THEN 
     updateable[cnt] = {&FORM_UPDATEABLE}.
   ELSE
     browseht[cnt] = qbf-frame.qbf-fbht.

   /* Add titles to list and keep a corresponding list of frame names. */
   stat = fr_list:ADD-LAST(qbf-section.qbf-shdl:TITLE) IN FRAME fr_prop.
   nam_lst = nam_lst 
           + (IF nam_lst <> "" THEN ",":u ELSE "") + qbf-section.qbf-sfrm.
END.

RUN Show_Frame_Props (ENTRY(init_ix,nam_lst)).

ASSIGN
  fr_list:SCREEN-VALUE IN FRAME fr_prop = 
     (IF fr_list = "" THEN fr_list:ENTRY(1) IN FRAME fr_prop ELSE fr_list)
  fr_ro:HIDDEN IN FRAME fr_prop        = (qbf-module <> "f":u)
  fr_bht:HIDDEN IN FRAME fr_prop       = (qbf-module <> "b":u)
  /*fr_bht:WIDTH IN FRAME fr_prop        = 5*/
  fr_bht:COL                           = fr_list:COL   IN FRAME fr_prop +
                                         fr_list:WIDTH IN FRAME fr_prop -
                                         fr_bht:WIDTH  IN FRAME fr_prop - 3
  /*fr_row:WIDTH IN FRAME fr_prop        = 5*/
  .

DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  SET fr_list 
    fr_row 
    fr_ro  WHEN qbf-module = "f":u
    fr_bht WHEN qbf-module = "b":u
    qbf-ok qbf-ee qbf-Help 
    WITH FRAME fr_prop.
END.

/* _fbprop.p - end of file */


