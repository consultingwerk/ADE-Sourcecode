/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/sec/_sec-gen-key.p

Description:
    Interface for generating new key for encryption policy

Input-Parameters:
    myEPolicy - _sec-pol-util object
    dsObjAttrs - dataset with objects selected by user

Output-Parameters:
    none
    
History:
    10/21/08  fernando   created

                            
--------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{prodict/sec/sec-pol.i}
{adecomm/adestds.i}

DEFINE INPUT PARAMETER myEPolicy AS CLASS prodict.sec._sec-pol-util.
DEFINE INPUT PARAMETER DATASET FOR dsObjAttrs.

DEFINE VARIABLE Committed       AS LOGICAL NO-UNDO.
DEFINE VARIABLE onlyOne         AS LOGICAL NO-UNDO.
DEFINE VARIABLE cObjType        AS CHARACTER NO-UNDO.

DEFINE VARIABLE cCipher AS CHARACTER FORMAT "X(30)":U 
     LABEL "Cip&her".

DEFINE VARIABLE Pass-phrase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pa&ssphrase" 
     VIEW-AS FILL-IN
     SIZE 42 BY 1  NO-UNDO.

DEFINE VARIABLE Verify-pass-phrase AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Verify Passphrase" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN SIZE 76 BY 5
&ELSE SIZE 77 BY 4 &ENDIF .

DEFINE BUTTON Btn_Save 
     LABEL "&Save" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Copy 
     LABEL "Co&py..." 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Revert 
     LABEL "&Revert" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON btn_Commit LABEL "&Commit" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel LABEL "Cancel"  {&STDPH_OKBTN} AUTO-ENDKEY.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.
   DEFINE BUTTON    btn_Help LABEL "&Help" {&STDPH_OKBTN}.

   &GLOBAL-DEFINE   HLP_BTN   &HELP = "btn_Help"
   &GLOBAL-DEFINE   HLP_BTN_NAME btn_Help
   &GLOBAL-DEFINE   CAN_BTN   /* we have one but it's not passed to okrun.i */
   &GLOBAL-DEFINE   WIDG_SKIP SKIP({&VM_WIDG})
   &GLOBAL-DEFINE   STATUS NO
   &GLOBAL-DEFINE   BOX_BTN   &BOX = "rect_Btns"
   &SCOPED-DEFINE   ORIG_OKBOX {&OKBOX}
&ELSE
   &GLOBAL-DEFINE   HLP_BTN  /* no help for tty */
   &GLOBAL-DEFINE   HLP_BTN_NAME /* no help for tty */
   &GLOBAL-DEFINE   CAN_BTN  &CANCEL = "btn_Cancel" /* so btn can be centered */
   &GLOBAL-DEFINE   WIDG_SKIP SKIP /*Often don't need and can't afford blnklin*/
   &GLOBAL-DEFINE   BOX_BTN
&ENDIF

&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN 
   /* Help context defines and the name of the help file */
   {prodict/admnhlp.i}
   &global-define ADM_HELP_FILE "adehelp/admin.hlp"  
&ENDIF

/* main browse */
DEFINE QUERY BrowseList FOR ttObjAttrs SCROLLING.
DEFINE BROWSE BrowseList
    QUERY BrowseList NO-LOCK DISPLAY
    ttObjAttrs.disp-name COLUMN-LABEL "Object Name" FORMAT "x(66)":U WIDTH 66
    cObjType COLUMN-LABEL "Type" FORMAT "x(4)":U WIDTH 4
    WITH NO-LABELS NO-ROW-MARKERS
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
    SIZE 76 BY 9 
&ELSE
    SIZE 77 BY 9
&ENDIF
     FIT-LAST-COLUMN.

/* ************************  Frame Definitions  *********************** */

/* main frame */
DEFINE FRAME Dialog-Frame
     "Hit the Commit button to commit changes" VIEW-AS TEXT
       AT ROW 1 COL 2
     BrowseList AT ROW 2.00 COL 2 WIDGET-ID 2
     cCipher 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 12 COL 15
       &ELSE AT ROW 11.33 COL 20 COLON-ALIGNED &ENDIF WIDGET-ID 4
     Btn_Save 
        &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 12 COL 67
        &ELSE AT ROW 11.77 COL 66 &ENDIF WIDGET-ID 6
     Pass-phrase 
        &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 13 COL 21
        &ELSE AT ROW 12.52 COL 20 &ENDIF COLON-ALIGNED PASSWORD-FIELD WIDGET-ID 8
     Btn_Copy 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 13 COL 67
       &ELSE  AT ROW 12.77 COL 66 &ENDIF WIDGET-ID 10
     Verify-pass-phrase
        &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN  AT ROW 14 COL 21
        &ELSE AT ROW 13.71 COL 20 &ENDIF COLON-ALIGNED PASSWORD-FIELD WIDGET-ID 12
     Btn_Revert 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 14 COL 67
       &ELSE AT ROW 13.77 COL 66 &ENDIF WIDGET-ID 14
     Btn_Commit AT ROW 15.57 COL 2
     Btn_Cancel AT ROW 15.57 COL 14
     &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
       Btn_Help AT ROW 15.57 COL 69 
     &ENDIF
     RECT-1 
      &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 11 COL 2
      &ELSE AT ROW 11 COL 2 &ENDIF WIDGET-ID 16
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
     SPACE(.5) SKIP(1)
&ENDIF
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Generate Encryption Keys"
         DEFAULT-BUTTON Btn_Commit CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.

/*adjust buttons to be in the middle for tty */
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN

  DEFINE VARIABLE eff_frame_width1 AS DECIMAL.  /* effective frame width */

  /* first for the main frame */
  ASSIGN eff_frame_width1 = FRAME Dialog-Frame:WIDTH-CHARS - 
                          FRAME Dialog-Frame:BORDER-LEFT-CHARS - 
                          FRAME Dialog-Frame:BORDER-RIGHT-CHARS.

  /* no help button for tty, and buttons in the middle */
   btn_Commit:COLUMN IN FRAME Dialog-Frame  = (eff_frame_width1 -
                          btn_Commit:WIDTH-CHARS IN FRAME Dialog-Frame -
                          btn_Cancel:WIDTH-CHARS IN FRAME Dialog-Frame -
                           5 ) / 2.
   btn_Cancel:COLUMN IN FRAME Dialog-Frame = btn_Commit:COLUMN IN FRAME Dialog-Frame + 
                            btn_Commit:WIDTH-CHARS IN FRAME Dialog-Frame + 
                                2.5.
&ENDIF

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Generate Encryption Keys */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN

/*----- HELP -----*/

ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME Dialog-Frame
DO: /* Call Help Function (or a simple message). */
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Generate_Encryption_Keys_Dialog_Box},
                               INPUT ?).  
  
END.



&ENDIF

&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN

ON ANY-PRINTABLE OF BrowseList IN FRAME Dialog-Frame
DO:
    DEF VAR ch   AS CHAR NO-UNDO.
    DEF VAR curr AS CHAR NO-UNDO.

    /* simulate search on tty so user can find object taht starts with a given character */
    ch = CHR(LASTKEY).

    BrowseList:FETCH-SELECTED-ROW(1).
    curr = ttObjAttrs.obj-name.

    IF ttObjAttrs.obj-name BEGINS ch THEN DO:
        FIND FIRST ttObjAttrs WHERE obj-name > curr NO-ERROR.

        IF NOT AVAILABLE ttObjAttrs THEN
           FIND FIRST ttObjAttrs WHERE obj-name BEGINS ch NO-ERROR.
    END.
    ELSE
       FIND FIRST ttObjAttrs WHERE obj-name BEGINS ch NO-ERROR.

    IF AVAILABLE ttObjAttrs AND obj-name BEGINS ch THEN DO:
        REPOSITION BrowseList TO ROWID ROWID(ttObjAttrs).
        APPLY "VALUE-CHANGED" TO BrowseList.
    END.
    ELSE
        BrowseList:FETCH-SELECTED-ROW(1).
END.

&ENDIF

ON ROW-DISPLAY OF BrowseList IN FRAME Dialog-Frame
DO:
    CASE ttObjAttrs.obj-type:
        WHEN "TABLE" THEN
            cObjType = "Tbl".
        WHEN "INDEX" THEN
            cObjType = "Idx".
        OTHERWISE
            cObjType = ttObjAttrs.obj-type.
    END CASE.
END.

ON VALUE-CHANGED OF BrowseList IN FRAME Dialog-Frame
DO:
    DO WITH FRAME Dialog-Frame:
        
        cCipher =  ttObjAttrs.obj-cipher.

        DISPLAY cCipher WITH FRAME Dialog-Frame.

        /* if there are changes that can be undone, enable the revert button */
        Btn_Revert:SENSITIVE = (IF ttObjAttrs.disp-name BEGINS "*" THEN YES ELSE NO).
    END.
END.

ON GO OF FRAME Dialog-Frame 
DO:
  DEF VAR answer AS LOGICAL NO-UNDO.

  MESSAGE 'You are about to generate the encryption key for all objects' SKIP
          'on the list. Do you want to proceed?'
       VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.

  IF answer = NO THEN
     RETURN NO-APPLY.

  /* doCommit will return an error when commit doesn't go through, so we return no-apply and 
     let the user decide what to do.
  */
  DO ON ERROR UNDO, RETURN NO-APPLY.
     RUN doCommit.
  END.
END.


ON END-ERROR OF  FRAME Dialog-Frame OR
   CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame 
DO:
    
    DEF VAR answer AS LOGICAL NO-UNDO.

    MESSAGE 'The encryption key for each object on the list has not' SKIP
            'been generated. Are you sure you want to close?'
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.

    IF answer = NO THEN
       RETURN NO-APPLY /* no*/.

END.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME Dialog-Frame:PARENT eq ?
THEN FRAME Dialog-Frame:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* start tracking-changes */
  TEMP-TABLE ttObjAttrs:TRACKING-CHANGES = YES.

  RUN enable_UI.

  /* get the first row to display the details  */
  APPLY "VALUE-CHANGED" TO BrowseList.

  APPLY "ENTRY" TO btn_Commit IN FRAME Dialog-Frame.
  WAIT-FOR GO OF FRAME Dialog-Frame.
END.
RUN disable_UI.

/* if we got here and the user did not save the changes, we return
   error to the caller so that it undoes the transaction, if there is
   one.
*/
IF NOT Committed THEN 
   RETURN ERROR.


/* **********************  Internal Procedures  *********************** */

/* PROCEDURE: disable_UI
 *            Disable widgets
 */
PROCEDURE disable_UI :
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* PROCEDURE: doCommit
 *            Commit changes to the database
 */
PROCEDURE doCommit:
    DEFINE BUFFER bttObjAttrs FOR ttObjAttrs.
    DEFINE VARIABLE answer AS LOGICAL NO-UNDO.

    /* get an exclusive lock on the schema, so that other users get 
       blocked when trying to change any schema info or enc policies
    */
    DO ON STOP UNDO, RETURN ERROR:
        myEPolicy:getDbLock(YES).
    END.

    /* this will mark all of them to get key generate */
    FOR EACH ttObjAttrs:
        ttObjAttrs.obj-genkey = YES.
    END.

    /* now pass the changes to out epolicy object and save them to the db */
    myEPolicy:updatePolicies(INPUT ?, INPUT DATASET dsObjAttrs BY-REFERENCE).

    /* if updatePolicies throws error, we won't get here, will get in the catch block below */
    ASSIGN Committed = YES.

    CATCH e AS PROGRESS.Lang.ProError:
       MESSAGE 'Failed to generate key.' skip e:GetMessage(1)
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       
       DELETE OBJECT e.
       /* we return error which then will get propagated so that we let the user decide what to do */
       RETURN ERROR.
       
    END CATCH.

END PROCEDURE.

/* PROCEDURE: enable_UI
 *            Enable widgets
 */
PROCEDURE enable_UI :
  DISPLAY BrowseList cCipher Pass-phrase Verify-pass-phrase 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-1 BrowseList Btn_Commit Btn_Cancel
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
      WITH FRAME Dialog-Frame.

  VIEW FRAME Dialog-Frame.
  OPEN QUERY BrowseList FOR EACH ttObjAttrs NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.
