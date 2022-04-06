/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*
  Display some interesting session information.
*/

{prodict/user/uservar.i}
{adecomm/commeng.i}  /* Help contexts for common stuff */

DEFINE VARIABLE attrib	AS CHARACTER EXTENT 3 NO-UNDO INITIAL 
[
  "NORMAL", "INPUT", "MESSAGES"
].

FORM 
  SKIP({&TFM_WID})
  attrib[1] FORMAT "x(7)" AT 2
  attrib[2] FORMAT "x(6)" 
  attrib[3] FORMAT "x(10)" 
   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &HELP   = {&HLP_BTN_NAME}
  }
  WITH FRAME clrs 
  NO-LABELS ATTR-SPACE ROW 5 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_OK
  VIEW-AS DIALOG-BOX  TITLE " Video Attribute Settings ".

COLOR DISPLAY NORMAL   attrib[1] WITH FRAME clrs.
COLOR DISPLAY INPUT    attrib[2] WITH FRAME clrs.
COLOR DISPLAY MESSAGES attrib[3] WITH FRAME clrs.


/*==============================Triggers================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame clrs
   or CHOOSE of btn_Help in frame clrs 
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Video_Attribute_Settings_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME clrs
   APPLY "END-ERROR" TO FRAME clrs.

/*============================Mainline Code=============================*/

/* _usrinf2.p will do the real display work.  Use report code to see the
  info in an editor widget. 
*/
RUN adecomm/_report.p 
   (INPUT ?,
    INPUT "Session Information",
    INPUT "Session Information",
    INPUT "",
    INPUT "",
    INPUT "prodict/user/_usrinf2.p",
    INPUT "",
    INPUT {&Session_Information_Dlg_Box}).

/* Because we can't show the color stuff via a file, put up an extra
   little dialog to show that. 
*/
/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME clrs" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    &HELP   = {&HLP_BTN_NAME}
}

DISPLAY 
    attrib[1] attrib[2] attrib[3]
    WITH FRAME clrs.
DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   UPDATE btn_OK {&HLP_BTN_NAME} WITH FRAME clrs.
END.

HIDE FRAME clrs NO-PAUSE.




