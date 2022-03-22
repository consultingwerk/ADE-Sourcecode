/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _widttrig.i

Description: 
    Triggers for Adjust SQL Width browser.  These triggers are defined in this
    include so that they could be part of _dcttran.p and thus use its wait-for
    and thus be non-modal.  
    
Author: Mario Brunetti
Date Created: 03/10/99 
    Modified: 05/28/99 Mario B. Cleaned up closing of window, added help token.
              07/01/99 Mario B. Fine tuning + add SwitchTable button
	      07/28/99 Mario B. Support for array data types. BUG 19990716-033.
	      10/14/99 Mario B. 2k width limit now 31995. BUG 19990825-005.
              11/15/99 Mario B. fix END-ERROR key in char mode. Bug 19990625-027
----------------------------------------------------------------------------*/

/*================================ Triggers ================================*/

/*----- Hit of OK Button -----*/
/* This is in here as a reminder that the OK button is AUTO-GO in this      *
 * case. So, if we APPPLY "GO" as is done elsewhere, we will be getting     *
 * 2 go events.                                                             */

   
/*----- END-ERROR or CANCEL of frm-width -----*/
ON END-ERROR OF FRAME frm-width OR CHOOSE OF s_btn_Close IN FRAME frm-width 
DO:
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      RUN prodict/gui/_closqlw.p.  
      {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_WIDTH}}  
      RUN adedict/_brwgray.p (INPUT NO).
   &ELSE
      /* This is to prevent undoing of "save" subtransactions if the user *
       * saves, then modifies other rows, then cancels.  Not pretty, but  *
       * necessary because of the differences betwen GUI and TTY          *
       * dictionary architectures.                                        */
      s_ExitNoSave = YES.
      APPLY "GO" TO FRAME frm-width.
   &ENDIF
   RETURN NO-APPLY.
END.

/*----- Go -----*/
ON GO OF FRAME frm-width
DO:
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      IF NOT s_ExitNoSave THEN  /* See above comment on cancel trigger. */
   &ENDIF
      run prodict/gui/_savwidt.p.  /* always runs for GUI, conditional TTY */
   IF RETURN-VALUE = "error" then
      RETURN NO-APPLY.   

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      RUN prodict/gui/_closqlw.p.
      {adedict/delwin.i &WIN = s_win_Width &Obj = {&OBJ_WIDTH}}
      RUN adedict/_brwgray.p (INPUT NO).       
   &ENDIF
END.

/*------ Hit OF SAVE Button -----*/
ON CHOOSE OF s_btn_Save IN FRAME frm-width
DO:
   run prodict/gui/_savwidt.p.
   if RETURN-VALUE = "error" then
      RETURN NO-APPLY.   
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
      run adedict/_objsel.p (INPUT {&OBJ_TBL}).  /* Causes Refresh */
   &ENDIF
   ASSIGN
      s_btn_Close:LABEL IN FRAME frm-width = "Close"
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
         rowsModified = NO
      &ENDIF
      .
END.

/*------- Row Leave -------*/
ON ROW-LEAVE of BROWSE brw-width
DO:
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   IF s_ExitNoSave THEN LEAVE.  /* So that trigger won't fire on F4 */
   &ENDIF
   IF brw-width:CURRENT-ROW-MODIFIED IN FRAME frm-width THEN
   DO:
      ASSIGN
         s_btn_Close:LABEL IN FRAME frm-width = "Cancel"
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
            rowsModified = YES
         &ENDIF	    
	 .
   
      IF INT(w_Field._Width:SCREEN-VALUE IN BROWSE brw-width) > 31995 THEN
      DO:
         MESSAGE "SQL-92 client cannot access fields that have" SKIP
                 "width values greater than 31995."             SKIP
         VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Value Out of Range".
         RETURN NO-APPLY.
      END.
   END.   
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
/*----- Hit of Help Button -----*/
ON CHOOSE OF s_btn_Help IN FRAME frm-width
RUN adecomm/_adehelp.p("dict", "context", {&Adjust_Field_Width_Dialog_Box}, ?).

/*----- HIT of NEXT button -----*/
ON CHOOSE OF s_btn_Next IN FRAME frm-width
DO:
   run adedict/_nextobj.p ({&OBJ_TBL}, true).
END.

/*----- HIT of PREV button -----*/
ON CHOOSE OF s_btn_Prev IN FRAME frm-width
DO:
   run adedict/_nextobj.p ({&OBJ_TBL}, false).
END.
&ENDIF

