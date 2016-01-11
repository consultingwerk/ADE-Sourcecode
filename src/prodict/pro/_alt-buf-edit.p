/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/pro/_alt-buf-edit.p

Description:
    Interface for assigning objects to an alternate buffer pool

Input-Parameters:
    myObjAtribObj - _obj-attrib-util object
    dsObjAttrs - dataset with objects selected by user for editing

Output-Parameters:
    none
    
History:
    03/12/09  fernando   created

                            
--------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{prodict/sec/sec-pol.i}
{adecomm/adestds.i}

DEFINE INPUT PARAMETER myObjAtribObj AS CLASS prodict.pro._obj-attrib-util.
DEFINE INPUT PARAMETER DATASET FOR dsObjAttrs.

DEFINE VARIABLE isEditing       AS LOGICAL NO-UNDO.
DEFINE VARIABLE Committed       AS LOGICAL NO-UNDO.
DEFINE VARIABLE onlyOne         AS LOGICAL NO-UNDO.
DEFINE VARIABLE pprompt         AS CHARACTER NO-UNDO.
DEFINE VARIABLE pattern         AS CHARACTER NO-UNDO INITIAL "*".
DEFINE VARIABLE cHelp           AS CHARACTER NO-UNDO.
DEFINE VARIABLE firstUpdate     AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE VARIABLE cObjType        AS CHARACTER NO-UNDO.

/* temp-table for review option */
DEFINE TEMP-TABLE ttReport NO-UNDO
    FIELD obj-name     AS CHAR
    FIELD obj-type     AS CHAR
    FIELD obj-buf-pool AS CHAR
    INDEX obj-name IS UNIQUE obj-name obj-type.

/* temp-table for copy option */
DEFINE TEMP-TABLE ttCopy NO-UNDO
    FIELD seq          AS INT
    FIELD obj-name     AS CHAR
    FIELD obj-type     AS CHAR
    FIELD obj-buf-pool AS CHAR
    INDEX obj-name IS UNIQUE seq obj-name.

DEFINE VARIABLE cbPool AS CHARACTER FORMAT "X(32)":U
    LABEL "Buffer Pool"
     VIEW-AS COMBO-BOX INNER-LINES 3
     DROP-DOWN-LIST SORT
  &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN SIZE 30 BY 1 &ELSE SIZE 42 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE objType AS CHARACTER FORMAT "X(36)":U 
     LABEL "Object Type" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN SIZE 77 BY 5
&ELSE SIZE 78 BY 3.5 &ENDIF .

DEFINE BUTTON Btn_Commit AUTO-GO 
     LABEL "Co&mmit" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Review
     LABEL "Re&view" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Save 
     LABEL "&Save" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Copy 
     LABEL "Co&py..." 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Revert 
     LABEL "&Revert" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Select_Some   LABEL "&Select Some...".
DEFINE BUTTON Btn_Deselect_Some LABEL "&Deselect Some...".

DEFINE BUTTON btn_Ok     LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

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
    WITH NO-LABELS NO-ROW-MARKERS
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
    SIZE 77 BY 9 
&ELSE
    SIZE 78 BY 9
&ENDIF
     FIT-LAST-COLUMN.

/* browse for copy option */
DEFINE QUERY browse-Copy FOR ttCopy.
DEFINE BROWSE browse-Copy
   QUERY browse-Copy NO-LOCK DISPLAY
   ttCopy.obj-name COLUMN-LABEL "Object Name" FORMAT "x(65)":U WIDTH 66
   cObjType COLUMN-LABEL "Type" FORMAT "x(4)":U WIDTH 5
   WITH NO-LABELS MULTIPLE SIZE 77 BY 9 FIT-LAST-COLUMN.

/* ************************  Frame Definitions  *********************** */

/* main frame */
DEFINE FRAME Dialog-Frame
     BrowseList AT ROW 1.95 COL 2 WIDGET-ID 2
     objType  AT ROW 11.5 COL 14 COLON-ALIGNED WIDGET-ID 4 
     cbPool
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 14 COL 3
       &ELSE AT ROW 12.7 COL 14 COLON-ALIGNED &ENDIF WIDGET-ID 6
     Btn_Save 
        &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 12 COL 67
        &ELSE AT ROW 11.7 COL 67 &ENDIF WIDGET-ID 8
     Btn_Copy 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 13 COL 67
       &ELSE  AT ROW 12.7 COL 67 &ENDIF WIDGET-ID 10
     Btn_Revert 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 14 COL 67
       &ELSE AT ROW 13.7 COL 67 &ENDIF WIDGET-ID 12
     Btn_Commit AT ROW 15.57 COL 2
     Btn_Cancel AT ROW 15.57 COL 14
     Btn_Review AT ROW 15.57 COL 26 WIDGET-ID 16
     &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
       Btn_Help AT ROW 15.57 COL 69 
     &ENDIF
     "Objects (* = changed):" VIEW-AS TEXT
          SIZE 35 BY .62 AT ROW 1.24 COL 2 WIDGET-ID 22
     RECT-1 
      &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 11 COL 1
      &ELSE AT ROW 11.4 COL 2 &ENDIF WIDGET-ID 24
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
     SPACE(.5) SKIP(1)
&ENDIF
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Alternate Buffer Pool Maintenance"
         DEFAULT-BUTTON Btn_Commit CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
  BROWSE BrowseList:HELP = KBLABEL("GO") + "=Commit " +
                           KBLABEL("END-ERROR") + "=Cancel " +
                           KBLABEL("F5") + "=Copy " +
                           KBLABEL("F6") + "=Revert " +
                           KBLABEL("F7") + "=Review".
      
&ENDIF

/* frame for copy option */
DEFINE FRAME SelectionCopy
   "If you want to copy the setting from the current object to other object(s),"
   VIEW-AS TEXT AT ROW 1 COL 2
   "select them on the list below." 
   VIEW-AS TEXT AT ROW 1.7 COL 2
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
   SKIP(1)
&ELSE
   SKIP(.5)
&ENDIF
    Btn_Select_Some   AT 15 WIDGET-ID 2
    Btn_Deselect_Some  AT 45 WIDGET-ID 4
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SKIP(.1) &ENDIF
    browse-Copy AT 1 WIDGET-ID 6
   {prodict/user/userbtns.i}
WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
    TITLE "Copy Current Setting To"
    DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 300.

/* frame for select - deselect some */
DEFINE FRAME  obj_patt
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
   SKIP(1)
&ELSE
   SKIP(.5)
&ENDIF
   pprompt  FORMAT "x(40)" NO-LABEL at 2 view-as TEXT
   "Use '*' and '.' for wildcard patterns.":t45 at 2 view-as TEXT 
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
   SKIP(1)
&ELSE
   SKIP(.5)
&ENDIF
   pattern  FORMAT "x(50)"   LABEL "Object Name":t17 at 2
   {prodict/user/userbtns.i}
   with view-as DIALOG-BOX TITLE "Select Objects by Pattern Match"
        SIDE-LABELS CENTERED THREE-D
        DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.

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
                          btn_Review:WIDTH-CHARS IN FRAME Dialog-Frame -
                           5 ) / 2.
   btn_Cancel:COLUMN IN FRAME Dialog-Frame = btn_Commit:COLUMN IN FRAME Dialog-Frame + 
                            btn_Commit:WIDTH-CHARS IN FRAME Dialog-Frame + 
                                2.5.
   btn_Review:COLUMN IN FRAME Dialog-Frame = btn_Cancel:COLUMN IN FRAME Dialog-Frame + 
                            btn_Cancel:WIDTH-CHARS IN FRAME Dialog-Frame + 
                                2.5.
&ENDIF

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame
DO:
  IF isEditing THEN DO:
      MESSAGE 'You are currently editing the setting for an object.' SKIP
              'Either save or cancel the changes.'
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      RETURN NO-APPLY.
  END. 
  
  APPLY "END-ERROR":U TO SELF.
END.

&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN

/*----- HELP -----*/

ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME Dialog-Frame
DO: /* Call Help Function (or a simple message). */
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Alternate_Buffer_Pool_Maintenance_Dialog_Box},
                               INPUT ?).
  
END.

on HELP of frame obj_patt OR CHOOSE of Btn_Help in frame obj_patt
DO:
   IF FRAME obj_patt:TITLE = "Select Objects by Pattern Match" THEN
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	       INPUT {&Select_Objects_by_Pattern_Match},
      	       	     	       INPUT ?).
   ELSE 
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	       INPUT {&Deselect_Objects_by_Pattern_Match},
      	       	     	       INPUT ?).
END.      	       	


&ENDIF

&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN

ON ANY-PRINTABLE OF BrowseList IN FRAME Dialog-Frame
DO:
    DEF VAR ch   AS CHAR NO-UNDO.
    DEF VAR curr AS CHAR NO-UNDO.

    /* simulate search on tty so user can find object that starts with a given character */
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

ON VALUE-CHANGED OF BrowseList IN FRAME Dialog-Frame
DO:
    DO WITH FRAME Dialog-Frame:
        
        ASSIGN objType = ttObjAttrs.obj-type.

        IF ttObjAttrs.area-buf-pool NE "Primary" THEN
           ASSIGN objType = objType + "  (Area Level Pool: Alternate)".

        cbPool = ttObjAttrs.obj-buf-pool.

        DISPLAY objType cbPool WITH FRAME Dialog-Frame.

        /* if there are changes that can be undone, enable the revert button */
        Btn_Revert:SENSITIVE = (IF ttObjAttrs.disp-name BEGINS "*" THEN YES ELSE NO).

        /* only enable copy if there was a change, and not only one object on the lsit */
        IF NOT onlyOne THEN
           Btn_Copy:SENSITIVE = Btn_Revert:SENSITIVE.
    END.
END.

ON VALUE-CHANGED OF cbPool IN FRAME Dialog-Frame
DO:
    RUN StartEdit.                    
    
END.

ON CHOOSE OF Btn_Save IN FRAME Dialog-Frame 
DO:
    DEFINE VARIABLE reverted AS LOGICAL NO-UNDO.

    DO WITH FRAME Dialog-Frame :

        /* if this is the first update to an object, get an exclusive lock on
           the schema, so that other users get blocked when trying to 
           change any schema table.
        */
        IF firstUpdate THEN DO ON STOP UNDO, RETURN NO-APPLY:
            myObjAtribObj:getDbLock(YES).
            firstUpdate = NO.
        END.

        ttObjAttrs.obj-buf-pool = cbPool:SCREEN-VALUE.

        /* signal that this has changes with an asterisk */
        ttObjAttrs.disp-name = "*" + ttObjAttrs.obj-name.

        /* let's see if this changed the record to the previous state, meaning that
           now there are no effective changes to the record
        */
        FIND FIRST bfttObjAttrs WHERE 
            ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        IF AVAILABLE bfttObjAttrs THEN DO:
            IF bfttObjAttrs.obj-buf-pool = ttObjAttrs.obj-buf-pool THEN DO:
                /* same values, so reject the changes that happened until now */
                BUFFER bfttObjAttrs:REJECT-ROW-CHANGES().
                reverted = YES.
            END.
        END.

        /* refresh column in browse in case we added the asterisk above */
        /* fetch record just in case we lost it due to the reject-row-changes above */
        BrowseList:FETCH-SELECTED-ROW(1).
        DISPLAY ttObjAttrs.disp-name WITH BROWSE BrowseList.

        RUN EndEdit.

        IF reverted THEN
            MESSAGE "This reverted the object setting to its original state." SKIP
                    "You can use the 'Revert' button instead."
                    VIEW-AS ALERT-BOX INFO.

    END.            
END.

ON CHOOSE OF Btn_Copy IN FRAME Dialog-Frame 
DO:
   RUN DoCopy.

   /* refresh the browse in case there were changes made */
   BROWSE BrowseList:REFRESH().

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    /* On tty, we end up with a weird behavior, as if a line in the browse is
       selected, even though the focus in on something else, so this does the trick.
    */
    IF SELF:TYPE NE "Browse" THEN
       APPLY "leave" TO BrowseList.
    APPLY "entry" TO SELF.
&ENDIF

    RUN EndEdit.
END.

ON CHOOSE OF Btn_Revert IN FRAME Dialog-Frame 
DO:
    IF INDEX(SELF:LABEL, "Revert") > 0 THEN DO:
        /* we will reject any changes to get the original record before any changes were done */
        FIND FIRST bfttObjAttrs WHERE  ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        IF AVAILABLE bfttObjAttrs THEN DO:
           BUFFER bfttObjAttrs:REJECT-ROW-CHANGES().

            /* refresh column in browse to remove the asterisk */
            /* fetch record since we lost it due to the reject-row-changes */
            BrowseList:FETCH-SELECTED-ROW(1).
            DISPLAY ttObjAttrs.disp-name WITH BROWSE BrowseList.
        END.
    END.

    RUN EndEdit.
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 

  ON F5 OF FRAME Dialog-Frame ANYWHERE DO:
    IF Btn_Copy:SENSITIVE IN FRAME Dialog-Frame THEN
       APPLY "CHOOSE" TO Btn_Copy IN FRAME Dialog-Frame.
    ELSE DO:
        BELL.
        RETURN NO-APPLY.
    END.
  END.
             
  ON F6 OF FRAME Dialog-Frame ANYWHERE DO:
    IF Btn_Revert:SENSITIVE IN FRAME Dialog-Frame THEN
       APPLY "CHOOSE" TO Btn_Revert IN FRAME Dialog-Frame.
    ELSE DO:
        BELL.
        RETURN NO-APPLY.
    END.
  END.

  ON F7 OF FRAME Dialog-Frame ANYWHERE DO:
    IF Btn_Review:SENSITIVE IN FRAME Dialog-Frame THEN
       APPLY "CHOOSE" TO Btn_Review IN FRAME Dialog-Frame.
    ELSE DO:
        BELL.
        RETURN NO-APPLY.
    END.
  END.

&ENDIF

ON GO OF FRAME Dialog-Frame 
DO:
  DEF VAR answer AS LOGICAL NO-UNDO.

  IF isEditing THEN DO:
     APPLY "CHOOSE" TO Btn_Save.
     RETURN NO-APPLY.
  END.

  /* if nothing to commit, return */
  IF NOT btn_Commit:SENSITIVE THEN DO:
     BELL.
     RETURN NO-APPLY.
  END.

  MESSAGE 'You are about to save the changes to the database.' SKIP
          'Do you want to proceed ?'
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
    
    IF isEditing THEN DO:
       APPLY "CHOOSE" TO Btn_Revert.
       RETURN NO-APPLY.
    END.

  /* checkUpdatesBeforeExit will return an error when commit doesn't go through, so we 
     return no-apply and let the user decide what to do.
  */
  DO ON ERROR UNDO, RETURN NO-APPLY:
     RUN checkUpdatesBeforeExit.
  END.

END.

ON CHOOSE OF Btn_Review IN FRAME Dialog-Frame 
DO:
    DEFINE BUFFER bttObjAttrs FOR ttObjAttrs.

    DEF VAR iCount        AS INT      NO-UNDO.
    DEF VAR lUnassigned   AS LONGCHAR NO-UNDO.
    DEF VAR lReport       AS LONGCHAR
        VIEW-AS EDITOR LARGE SCROLLBAR-VERTICAL
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN 
        SIZE 97 BY 15
&ELSE 
        SIZE 77 BY 15 
&ENDIF
        FONT 0 /* fixed font */  NO-UNDO.

    /* now look at the after and before table and see what has really changed */
    FOR EACH bfttObjAttrs:

        FIND FIRST bttObjAttrs WHERE ROWID(bttObjAttrs) = BUFFER bfttObjAttrs:AFTER-ROWID.

        /* should always find it and BUFFER bfttObjAttrs:ROW-STATE = ROW-MODIFIED since we
           only have modified records
        */
        
        IF bttObjAttrs.obj-buf-pool NE bfttObjAttrs.obj-buf-pool THEN DO:
            ASSIGN iCount = iCount + 1.

            IF bttObjAttrs.obj-buf-pool = "Primary" THEN DO:
                lUnassigned = lUnassigned + "  " + bttObjAttrs.obj-name  
                           + " (" + bttObjAttrs.obj-type + ")" + CHR(10).
            END.
            ELSE DO:
                CREATE ttReport.
                ASSIGN ttReport.obj-name = bttObjAttrs.obj-name
                       ttReport.obj-type = bttObjAttrs.obj-type
                       ttReport.obj-buf-pool = bttObjAttrs.obj-buf-pool.
            END.
        END.
        
    END.

    IF iCount > 0 THEN DO:

        lReport =   "Summary of changes to alternate buffer pool" + CHR(10)
                  + "===========================================".

        /* assigned ones */
        FOR EACH ttReport WHERE ttReport.obj-buf-pool NE "Primary" BREAK BY ttReport.obj-buf-pool:
             IF FIRST-OF (ttReport.obj-buf-pool) THEN
                 lReport = lReport + CHR(10) + CHR(10) + 
                           "Assign the following objects to the " + ttReport.obj-buf-pool + 
                           " buffer pool:" + CHR(10).

            lReport = lReport + "  " + ttReport.obj-name 
                      + " (" + ttReport.obj-type + ")" + CHR(10).
            DELETE ttReport.
        END.

        IF lUnassigned NE "" THEN
           lReport = lReport + CHR(10) + CHR(10)
                     + "Assign the following objects to the Primary buffer pool:" +
                      CHR(10) + lUnassigned .

        lReport = lReport + CHR(10) + CHR(10) + "Total number of changes: " + STRING(iCount).

        EMPTY TEMP-TABLE ttReport NO-ERROR.

        /* build a very simple frame and display the report */
        DEFINE BUTTON bClose LABEL "&Close" 
            &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &then SIZE 15 BY 1.14 &ENDIF 
            TOOLTIP "Close window" AUTO-ENDKEY.
        
        DEFINE FRAME frame-report
            lReport NO-LABEL AT ROW 1 COL 1 WIDGET-ID 2 PFCOLOR 0
            bClose 
               &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 16 COL 36
               &ELSE AT ROW 16.4 COL 42 &ENDIF WIDGET-ID 4
            WITH KEEP-TAB-ORDER OVERLAY 
                 SIDE-LABELS NO-UNDERLINE THREE-D CENTERED
                 TITLE "Review changes"
                 VIEW-AS DIALOG-BOX CANCEL-BUTTON bClose DEFAULT-BUTTON bClose
                 &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN  SIZE 99 BY 18
                 &ELSE SIZE 80 BY 18 &ENDIF .
                 
        ON WINDOW-CLOSE OF FRAME frame-report
        DO:
           APPLY 'CHOOSE' TO bClose.
        END.

        DO ON ENDKEY UNDO, LEAVE:
           DISPLAY lReport WITH FRAME frame-report.
           ASSIGN  lReport:READ-ONLY= YES
                   lReport:SENSITIVE = YES.
           UPDATE bClose WITH FRAME frame-report.
        END.
    END.
    ELSE
        MESSAGE "There are no changes to the alternate buffer pool"
        &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN 
        VIEW-AS ALERT-BOX INFO BUTTONS OK &ENDIF .
END.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME Dialog-Frame:PARENT eq ?
THEN FRAME Dialog-Frame:PARENT = ACTIVE-WINDOW.

/* Run time layout for button areas for SelectionCopy and obj_patt frames */
{adecomm/okrun.i  
   &FRAME  = "FRAME SelectionCopy" 
   {&BOX_BTN}
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

{adecomm/okrun.i  
   &FRAME  = "FRAME obj_patt" 
   {&BOX_BTN}
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* start tracking-changes */
  TEMP-TABLE ttObjAttrs:TRACKING-CHANGES = YES.

  RUN populateCombo.

  RUN enable_UI.

  /* get the first row to display the details  */
  APPLY "VALUE-CHANGED" TO BrowseList.

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

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN

/* assign the help string for the widgets on TTY */
PROCEDURE assignHelp:
    IF isEditing THEN
        ASSIGN cHelp = KBLABEL("GO") + "=Save  " +
                       KBLABEL("END-ERROR") + "=Reset"
               cbPool:HELP IN FRAME Dialog-Frame = cHelp
               Btn_Save:HELP = cHelp
               Btn_Review:HELP = cHelp
               Btn_Revert:HELP = cHelp.
    ELSE DO:
        ASSIGN cHelp = BrowseList:HELP IN FRAME Dialog-Frame
               cbPool :HELP    = cHelp
               Btn_Save:HELP     = cHelp
               Btn_Revert:HELP   = cHelp
               Btn_Copy:HELP     = cHelp
               Btn_Cancel:HELP   = cHelp
               Btn_Commit:HELP   = cHelp
               Btn_Review:HELP   = cHelp.
    END.
END PROCEDURE.

&ENDIF

/* PROCEDURE: checkUpdatesBeforeExit
 *            Called when user wants to exit. Check if there are chnages and alert 
 *            to that fact so they get a chance to save them.
 */
PROCEDURE checkUpdatesBeforeExit:
   DEF VAR answer AS LOGICAL NO-UNDO.

   /* if there are any errors trying to save the chnages, we return error */
   IF CAN-FIND (FIRST bfttObjAttrs NO-LOCK) THEN 
   DO ON ERROR UNDO, RETURN ERROR:
       
       /* initialize as the cancel button */
       ASSIGN answer = ?.

       MESSAGE 'You have not saved the current changes to the database.' SKIP
               'The changes will be lost once you exit this utility.' SKIP(1)
               'Do you wish to save the changes before you exit?'
           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.

       IF answer = ? THEN
          RETURN ERROR /*cancel */.
       ELSE IF answer = YES THEN DO:
           /* doCommit will return an error when commit doesn't go through, so we 
             return error. Caller should return no-apply and let the user decide what to do.
           */
           RUN doCommit.
       END.

   END.

END PROCEDURE.

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

    /* check if there are any that haven't been changed */
    FIND FIRST bttObjAttrs WHERE NOT bttObjAttrs.disp-name BEGINS "*" NO-ERROR.
    IF AVAILABLE bttObjAttrs THEN DO:
        MESSAGE "Some of the selected objects have not been changed." SKIP
                "Do you want to proceed?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
        IF answer = NO THEN DO:
            REPOSITION BrowseList TO ROWID ROWID(bttObjAttrs).
            APPLY "VALUE-CHANGED" TO BrowseList IN FRAME Dialog-Frame.
            RETURN ERROR.
        END.
    END.

    /* now pass the changes to our utility object and save them to the db */
    myObjAtribObj:updateSettings(INPUT ?, INPUT DATASET dsObjAttrs BY-REFERENCE).

    /* if updateSettings throws error, we won't get here, will get in the catch block below */
    ASSIGN Committed = YES.

    CATCH e AS PROGRESS.Lang.ProError:
       MESSAGE 'Failed to save changes.' skip e:GetMessage(1)
           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       
       DELETE OBJECT e.
       /* we return error which then will get propagated so that we let the user decide what to do */
       RETURN ERROR.
       
    END CATCH.

END PROCEDURE.

/* PROCEDURE: doCopy
 *            Copy settings from current object to other object(s)
 */
PROCEDURE doCopy:
    DEFINE BUFFER bttObjAttrs FOR ttObjAttrs.

    DEF VAR rRowid   AS ROWID NO-UNDO.

    ON WINDOW-CLOSE OF FRAME SelectionCopy
    DO:
         APPLY "END-ERROR":U TO SELF.
    END.

    ON ROW-DISPLAY OF browse-Copy IN FRAME SelectionCopy
    DO:
        CASE ttCopy.obj-type:
            WHEN "TABLE" THEN
                cObjType = "Tbl".
            WHEN "INDEX" THEN
                cObjType = "Idx".
            OTHERWISE
                cObjType = ttCopy.obj-type.
        END CASE.
    END.

&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN

    ON CHOOSE OF Btn_Help IN FRAME SelectionCopy /* Help */
    OR HELP OF FRAME SelectionCopy
    DO: /* Call Help Function (or a simple message). */
        RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                                   INPUT "CONTEXT", 
                                   INPUT {&Copy_Current_Setting_To},
                                   INPUT ?).  
    END.
&ENDIF

    ON CHOOSE OF Btn_Select_Some IN FRAME SelectionCopy
    DO:
       DEFINE VARIABLE n        AS INT    NO-UNDO.
       DEFINE VARIABLE rrowid   AS ROWID  NO-UNDO.

       ASSIGN n = browse-Copy:FOCUSED-ROW.

       ASSIGN FRAME obj_patt:TITLE = "Select Objects by Pattern Match"
              pprompt = "Enter name of object to select.".

       display pprompt with frame obj_patt.

       do ON ENDKEY UNDO, LEAVE:
          update pattern btn_OK btn_Cancel {&HLP_BTN_NAME}
              with frame obj_patt.

          pattern = TRIM(pattern).
          IF pattern = "*" THEN
             browse-Copy:SELECT-ALL().
          ELSE DO:
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
              /* can't have this since this causes issues with selected rows
                 on multi-select browse on tty - OE00172180 
              */
              browse-Copy:SET-REPOSITIONED-ROW(n,"conditional").
&ENDIF
              /* don't look at the one selected on the main browse, as it's
                 not in browse-Copy - see open query below.
              */
              FOR EACH ttCopy WHERE ttCopy.obj-name NE ttObjAttrs.obj-name AND
                              ttCopy.obj-buf-pool NE ttObjAttrs.obj-buf-pool AND
                              ttCopy.obj-name MATCHES pattern.
                  /* store the rowid of the first row selected so we move
                     focus to it later.
                  */
                  IF rrowid = ? THEN
                      rrowid = ROWID(ttCopy).
                  REPOSITION browse-Copy TO ROWID ROWID(ttCopy).
                  browse-Copy:SELECT-ROW(browse-Copy:FOCUSED-ROW).
              END.

              /* move to the first selected, if any*/
              IF rrowid NE ? THEN
                  REPOSITION browse-Copy TO ROWID rrowid.
          END.

    &IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
        /* On tty Windows, we end up with a weird behavior, as if a line in the browse is
           selected, even though the focus in on something else, so this does the trick.
        */
        IF SELF:TYPE NE "Browse" THEN
           APPLY "leave" TO browse-Copy.
        APPLY "entry" TO SELF.
    &ENDIF

       END.
    END.

    ON CHOOSE OF Btn_Deselect_Some IN FRAME SelectionCopy
    DO:
       DEFINE VAR nRows AS INTEGER NO-UNDO.
       DEFINE VAR i     AS INTEGER NO-UNDO.

       ASSIGN FRAME obj_patt:TITLE = "Deselect Objects by Pattern Match"
              pprompt = "Enter name of object to deselect.".

       display pprompt with frame obj_patt.

       do ON ENDKEY UNDO, LEAVE:
          update pattern btn_OK btn_Cancel {&HLP_BTN_NAME}
               with frame obj_patt.

          pattern = TRIM(pattern).
          nRows = browse-Copy:NUM-SELECTED-ROWS.

          IF nRows > 0 THEN DO:
              IF pattern = "*" THEN
                 browse-Copy:DESELECT-ROWS().
              ELSE DO:
                   rpt-blk:
                   REPEAT i = 1 TO nRows:
                       browse-Copy:FETCH-SELECTED-ROW(i).
                       IF ttCopy.obj-name MATCHES pattern THEN DO:
                            browse-Copy:DESELECT-SELECTED-ROW(i).
                            /* now that we have deselected the row, decrement the counters */
                            ASSIGN i = i - 1
                                   nRows = nRows - 1.
                       END.
                   END.
              END.
          END.
       END.
    END.

    ON GO OF FRAME SelectionCopy
    DO:
        DEF VAR i        AS INT     NO-UNDO.
        DEF VAR j        AS INT     NO-UNDO.
        DEF VAR cPool    AS CHAR    NO-UNDO.

        ASSIGN i = browse-Copy:NUM-SELECTED-ROWS IN FRAME SelectionCopy.
        IF i = 0 THEN DO:
            MESSAGE "Select ay least one object or press Cancel"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            RETURN NO-APPLY.
        END.

        cPool = ttObjAttrs.obj-buf-pool.

        REPEAT j = 1 TO i:
            browse-Copy:FETCH-SELECTED-ROW(j).
            FIND FIRST bttObjAttrs WHERE bttObjAttrs.obj-name = ttCopy.obj-name AND
                bttObjAttrs.obj-type = ttCopy.obj-type.
            /* if the values are different, assign them */
            IF bttObjAttrs.obj-buf-pool NE cPool THEN DO:
                ASSIGN bttObjAttrs.obj-buf-pool = cPool
                       bttObjAttrs.disp-name = "*" + bttObjAttrs.obj-name.

                /* let's see if this changed the record to the previous state, meaning that
                   now there are no effective changes to the record
                */
                FIND FIRST bfttObjAttrs WHERE 
                    ROWID(bfttObjAttrs) = BUFFER bttObjAttrs:BEFORE-ROWID NO-ERROR.
                IF AVAILABLE bfttObjAttrs THEN DO:
                    IF bfttObjAttrs.obj-buf-pool = bttObjAttrs.obj-buf-pool THEN DO:
                        /* same values, so reject the changes that happened until now */
                        BUFFER bfttObjAttrs:REJECT-ROW-CHANGES().
                    END.
                END.
            END.
        END.
    END.

    DO ON ERROR UNDO, LEAVE
       ON STOP UNDO, LEAVE
       ON ENDKEY UNDO, LEAVE: /* trap errors */

        /* check if there is any with a different setting */
        FIND FIRST bttObjAttrs 
             WHERE bttObjAttrs.obj-buf-pool NE
                   ttObjAttrs.obj-buf-pool NO-ERROR.

        IF NOT AVAILABLE bttObjAttrs THEN DO:
           MESSAGE "All objects on the list already have the same setting as"
                   "the current one." 
               VIEW-AS ALERT-BOX INFO.

        END.
        ELSE DO:

            IF NOT CAN-FIND (FIRST ttCopy) THEN DO:
                /* populate the table the first time */
                FOR EACH bttObjAttrs:
                    CREATE ttCopy.
                    ASSIGN ttcopy.seq = bttObjAttrs.seq-num
                           ttCopy.obj-name = bttObjAttrs.obj-name
                           ttCopy.obj-type = bttObjAttrs.obj-type
                           ttCopy.obj-buf-pool = bttObjAttrs.obj-buf-pool.
                    RELEASE ttCopy.
                END.
            END.
            ELSE DO:
                /* make sure the table is up-to-date */
                FOR EACH bttObjAttrs:
                    FIND FIRST ttCopy WHERE ttCopy.obj-name EQ bttObjAttrs.obj-name AND
                               ttCopy.obj-type EQ bttObjAttrs.obj-type.
                    ASSIGN ttCopy.obj-buf-pool = bttObjAttrs.obj-buf-pool.
                    RELEASE ttCopy.
                END.
            END.
    
            /* exclude the currently selected one from the Copy browse */
            FIND ttCopy WHERE ttCopy.obj-name EQ ttObjAttrs.obj-name AND
                ttCopy.obj-type EQ ttObjAttrs.obj-type NO-LOCK.
            rRowid = ROWID(ttCopy).
            RELEASE ttCopy.
    
            /* show only the objects that have different settings */
            OPEN QUERY browse-Copy FOR EACH ttCopy WHERE 
               ROWID(ttCopy) NE rRowid AND 
               ttCopy.obj-buf-pool NE ttObjAttrs.obj-buf-pool.
    
            DISPLAY browse-Copy WITH FRAME SelectionCopy.
    
            ENABLE browse-Copy Btn_Select_Some Btn_Deselect_Some Btn_OK Btn_Cancel
                &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
                WITH FRAME SelectionCopy.
    
            WAIT-FOR GO OF FRAME SelectionCopy.
    
            CLOSE QUERY browse-Copy.
        END.
    END.

    /* we are done one way or the other */
    HIDE FRAME SelectionCopy.

END PROCEDURE.

/* PROCEDURE: enable_UI
 *            Enable widgets
 */
PROCEDURE enable_UI :
  DISPLAY BrowseList cbPool WITH FRAME Dialog-Frame.
  ENABLE RECT-1 BrowseList cbPool Btn_Cancel
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
      /*Btn_Save*/
      WITH FRAME Dialog-Frame.

  VIEW FRAME Dialog-Frame.
  OPEN QUERY BrowseList FOR EACH ttObjAttrs NO-LOCK INDEXED-REPOSITION.

  /* remember that user selected just 1 object, so we don't enable the Copy option */
  IF QUERY BrowseList:NUM-RESULTS = 1 THEN
      ASSIGN onlyOne = YES.

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
  /* assign help */
  RUN assignHelp.
&ENDIF

END PROCEDURE.

/* PROCEDURE: EndEdit
 *            Called when user reset or save changes to current object
 */
PROCEDURE EndEdit:
    
    ASSIGN isEditing = NO
           Btn_Revert:LABEL IN FRAME Dialog-Frame = "&Revert".

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
    RUN assignHelp.
&ENDIF

    DISABLE Btn_Save Btn_Revert WITH FRAME Dialog-Frame.
    ENABLE BrowseList Btn_Cancel WITH FRAME Dialog-Frame.

    /* get values from record */
    APPLY "VALUE-CHANGED" TO BrowseList.
    
    ASSIGN btn_Commit:SENSITIVE = CAN-FIND (FIRST bfttObjAttrs NO-LOCK)
           btn_Review:SENSITIVE = btn_Commit:SENSITIVE.
      
     /* go back to the browse */ 
     APPLY "ENTRY" TO BrowseList.
END PROCEDURE.

/* PROCEDURE: populateCombo
 *            Populate combo-box with pool names
 */
PROCEDURE populateCombo:         
    DEFINE VARIABLE cList         AS CHAR    NO-UNDO.

   ASSIGN cbPool:LIST-ITEMS IN FRAME Dialog-Frame = myObjAtribObj:BufferPoolNames.
 
END PROCEDURE.

/* PROCEDURE: startEdit
 *            Called when user makes a change to the current object
 */
PROCEDURE startEdit:

    ASSIGN isEditing = YES
           Btn_Revert:LABEL IN FRAME Dialog-Frame = "&Reset".

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
    RUN assignHelp.

    APPLY "ENTRY" TO SELF.
&ENDIF


    ENABLE Btn_Save Btn_Revert WITH FRAME Dialog-Frame.
    DISABLE BrowseList Btn_Copy Btn_Commit Btn_Cancel WITH FRAME Dialog-Frame.


END PROCEDURE.
