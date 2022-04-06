/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}
{adecomm/commeng.i}  /* Help contexts */

DEFINE BUTTON bOK LABEL "OK" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON bCancel LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON bHelp LABEL "Help" {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rHeavyRule {&STDPH_OKBOX}.
&ENDIF

DEFINE VARIABLE db-list AS CHARACTER INITIAL ""
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 70 BY 9 NO-UNDO.

DEFINE VARIABLE db_lname AS CHARACTER FORMAT "X(80)":U
     LABEL "Logical Name" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE db_pname AS CHARACTER FORMAT "X(80)":U
     LABEL "Physical Name" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

DEFINE VARIABLE db_type AS CHARACTER FORMAT "X(80)":U
     LABEL "Database Type" 
     VIEW-AS FILL-IN 
     SIZE 50 BY 1 NO-UNDO.

/* ************************  Frame Definitions  *********************** */
DEFINE FRAME frDisconnect
   SKIP({&TFM_WID})
   db_lname AT 2 SKIP
   db_pname AT 2 SKIP
   db_type AT 2 SKIP
   db-list AT 2 NO-LABEL
   {adecomm/okform.i
      &BOX    = "rHeavyRule"
      &STATUS = "no"
      &OK     = "bOK"
      &CANCEL = "bCancel"
      &HELP   = "bHelp"}

    WITH VIEW-AS DIALOG-BOX SIDE-LABELS 
         TITLE "Disconnect..." DEFAULT-BUTTON bOK CANCEL-BUTTON bCancel.

/* Use ade standards dialog includes -- this also makes WINDOW-CLOSE act
   like END-ERROR. */
   
/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP ""

PAUSE 0 BEFORE-HIDE.

/* WINDOW-CLOSE event will issue END-ERROR to the frame */
ON WINDOW-CLOSE OF FRAME frDisconnect APPLY "END-ERROR":U TO SELF.


 
/* ************************  Control Triggers  ************************ */
ON HELP OF FRAME frDisconnect OR CHOOSE OF bHelp IN FRAME frDisconnect
  RUN adecomm/_adehelp.p (INPUT "comm", INPUT "CONTEXT", 
                          INPUT ?, INPUT ?).

ON GO of frame frDisconnect
DO:
  ASSIGN db-list.
  IF db-list <> "" AND db-list <> ? THEN
    DISCONNECT VALUE(db-list) NO-ERROR.
END.

ON VALUE-CHANGED OF db-list IN FRAME frDisconnect RUN show-dbinfo.

/* **********************  Internal Procedures  *********************** */
PROCEDURE initialize-dblist.
  def var i as integer.
  DO WITH FRAME frDisconnect:
    ASSIGN db-list:SCREEN-VALUE = ""
           db-list:LIST-ITEMS   = "".
    DO i = 1 to NUM-DBS:
      IF db-list:ADD-LAST(LDBNAME(i)) THEN.
    END.
    IF NUM-DBS > 0 THEN db-list:SCREEN-VALUE = LDBNAME(1).
  END.
  RUN show-dbinfo.
END PROCEDURE.

PROCEDURE show-dbinfo.
  db_lname = db-list:SCREEN-VALUE IN FRAME frDisconnect.
  IF db_lname eq "" OR db_lname eq ? THEN DO:
    ASSIGN db_lname = "n/a"
           db_pname = "n/a"
           db_type  = "n/a".
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    bOK:SENSITIVE = FALSE.
&ENDIF
  END.
  ELSE DO:
    ASSIGN db_pname = PDBNAME(db_lname)
           db_type  = DBTYPE (db_lname).
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    bOK:SENSITIVE = TRUE.
&ENDIF
  END.
  DISPLAY db_lname db_pname db_type WITH FRAME frDisconnect.
END PROCEDURE.

/*********************************** Main ************************************/
/* Run time layout for button area. */
{adecomm/okrun.i  
    &FRAME = "FRAME frDisconnect" 
    &BOX   = "rHeavyRule"
    &OK    = "bOK" 
    &CANCEL= "bCancel"
    &HELP  = "bHelp"
}

RUN initialize-dblist.

/* Restore the current-window if it is an icon.                         */
/* Otherwise the dialog box will be hidden                              */
IF CURRENT-WINDOW:WINDOW-STATE = WINDOW-MINIMIZED 
THEN CURRENT-WINDOW:WINDOW-STATE = WINDOW-NORMAL.

DO ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
ENABLE db-list &if "{&WINDOW-SYSTEM}" = "TTY" &then bOK &endif bCancel
	bHelp {&WHEN_HELP} WITH FRAME frDisconnect.
VIEW FRAME frDisconnect.
WAIT-FOR CHOOSE of bOK in FRAME frDisconnect OR
	GO of frame frDisconnect OR WINDOW-CLOSE OF FRAME frDisconnect
	FOCUS bOK.
END.
HIDE FRAME frDisconnect.
