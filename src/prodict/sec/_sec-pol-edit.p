/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/sec/_sec-pol-edit.p

Description:
    Interface for editing and saving encryption policies (encryption)

Input-Parameters:
    myEPolicy - _sec-pol-util object
    dsObjAttrs - dataset with objects selected by user for editing

Output-Parameters:
    none
    
History:
    07/01/08  fernando   created

                            
--------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{prodict/sec/sec-pol.i}
{adecomm/adestds.i}

DEFINE INPUT PARAMETER myEPolicy AS CLASS prodict.sec._sec-pol-util.
DEFINE INPUT PARAMETER DATASET FOR dsObjAttrs.

DEFINE VARIABLE isEditing       AS LOGICAL NO-UNDO.
DEFINE VARIABLE Committed       AS LOGICAL NO-UNDO.
DEFINE VARIABLE onlyOne         AS LOGICAL NO-UNDO.
DEFINE VARIABLE currdefCipher   AS CHAR    NO-UNDO.
DEFINE VARIABLE cipherChanged   AS LOGICAL NO-UNDO.
DEFINE VARIABLE hFakeCipher     AS HANDLE  NO-UNDO.
DEFINE VARIABLE isCurrDisabled  AS LOGICAL NO-UNDO.
DEFINE VARIABLE pprompt         AS CHARACTER NO-UNDO.
DEFINE VARIABLE pattern         AS CHARACTER NO-UNDO INITIAL "*".
DEFINE VARIABLE cHelp           AS CHARACTER NO-UNDO.
DEFINE VARIABLE firstUpdate     AS LOGICAL   NO-UNDO INITIAL YES.
DEFINE VARIABLE cObjType        AS CHARACTER NO-UNDO.

/* temp-table for review option */
DEFINE TEMP-TABLE ttReport NO-UNDO
    FIELD obj-name    AS CHAR
    FIELD obj-type    AS CHAR
    FIELD old-cipher  AS CHAR
    FIELD new-cipher  AS CHAR
    INDEX obj-name IS UNIQUE obj-name obj-type new-cipher.

/* temp-table for copy option */
DEFINE TEMP-TABLE ttCopy NO-UNDO
    FIELD seq         AS INT
    FIELD obj-name    AS CHAR
    FIELD obj-type    AS CHAR
    FIELD obj-cipher  AS CHAR
    FIELD obj-genkey  AS LOGICAL
    INDEX obj-name IS UNIQUE seq obj-name.

DEFINE VARIABLE TogEnabled AS LOGICAL INITIAL no 
     LABEL "&Encryption enabled" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .81 NO-UNDO.

DEFINE VARIABLE TogGenKey AS LOGICAL INITIAL no 
     LABEL "New encr&yption key" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .81 NO-UNDO.

DEFINE VARIABLE objType AS CHARACTER FORMAT "X(6)":U 
     LABEL "Object Type" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1 NO-UNDO.

DEFINE VARIABLE cbCipher AS CHARACTER FORMAT "X(30)":U 
     LABEL "Cip&her" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
  &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN SIZE 30 BY 1 &ELSE SIZE 42 BY 1 &ENDIF NO-UNDO.

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
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN SIZE 77 BY 7
&ELSE SIZE 78 BY 5.5 &ENDIF .

DEFINE BUTTON Btn_Commit AUTO-GO 
     LABEL "Co&mmit" 
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 11 BY .95 &ENDIF .

DEFINE BUTTON Btn_Review
     LABEL "&Review" 
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


DEFINE BUTTON Btn_Select_Some LABEL "&Select Some...".
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
     BrowseList AT ROW 1.95 COL 1 WIDGET-ID 2
     TogEnabled AT ROW 11.90 COL 4 WIDGET-ID 10
     TogGenKey AT ROW 11.90 COL 29 WIDGET-ID 12
     objType   AT ROW 11.60 COL 56 WIDGET-ID 36
     cbCipher 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 14 COL 14
       &ELSE AT ROW 13.33 COL 20 COLON-ALIGNED &ENDIF WIDGET-ID 14
     Btn_Save 
        &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 14 COL 67
        &ELSE AT ROW 12.77 COL 66 &ENDIF WIDGET-ID 18
     Pass-phrase AT ROW 14.52 COL 20 COLON-ALIGNED PASSWORD-FIELD WIDGET-ID 20
     Btn_Copy 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 15 COL 67
       &ELSE  AT ROW 13.77 COL 66 &ENDIF WIDGET-ID 22
     Verify-pass-phrase AT ROW 15.71 COL 20 COLON-ALIGNED PASSWORD-FIELD WIDGET-ID 24
     Btn_Revert 
       &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 16 COL 67
       &ELSE AT ROW 14.77 COL 66 &ENDIF WIDGET-ID 26
     Btn_Commit AT ROW 17.57 COL 2
     Btn_Cancel AT ROW 17.57 COL 14
     Btn_Review AT ROW 17.57 COL 26 WIDGET-ID 32
     &IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
       Btn_Help AT ROW 17.57 COL 69 
     &ENDIF
     "Objects (* = changed policy):" VIEW-AS TEXT
          SIZE 35 BY .62 AT ROW 1.24 COL 2 WIDGET-ID 34
     RECT-1 
      &IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN AT ROW 11 COL 1
      &ELSE AT ROW 11.5 COL 1 &ENDIF WIDGET-ID 36
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
     SPACE(.5) SKIP(1)
&ENDIF
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Edit Encryption Policy"
         DEFAULT-BUTTON Btn_Commit CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
  BROWSE BrowseList:HELP = KBLABEL("GO") + "=Commit  " +
                           KBLABEL("END-ERROR") + "=Cancel  " +
                           KBLABEL("F5") + "=Copy  " +
                           KBLABEL("F6") + "=Revert  " +
                           KBLABEL("F7") + "=Review".
      
&ENDIF

/* frame for copy option */
DEFINE FRAME SelectionCopy
   "If you want to copy the settings from the encryption policy of the current"
   VIEW-AS TEXT AT ROW 1 COL 2
   "object to other object(s), select them on the list below." 
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
    TITLE "Copy Encryption Policy Settings To"
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

ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Edit Encryption Policy */
DO:
  IF isEditing THEN DO:
      MESSAGE 'You are currently editing an encryption policy.' SKIP
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
                               INPUT {&Edit_Encryption_Policy_Dialog_Box1},
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
        
        ASSIGN isCurrDisabled = NO.

        /* remember if encryption is currently disabled for this object */
        FIND FIRST bfttObjAttrs WHERE ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        IF AVAILABLE bfttObjAttrs THEN DO:
            IF bfttObjAttrs.obj-cipher = "" THEN
                isCurrDisabled = YES.
        END.
        ELSE IF ttObjAttrs.obj-cipher = "" THEN
            isCurrDisabled = YES.

        ASSIGN objType = ttObjAttrs.obj-type
               TogGenKey = ttObjAttrs.obj-genkey.

        IF ttObjAttrs.obj-cipher = "" THEN DO:
            ASSIGN cbCipher:SENSITIVE = NO
                   hFakeCipher:HIDDEN = NO
                   togEnabled = NO
                   TogGenKey:SENSITIVE = NO.
        END.
        ELSE DO:
            ASSIGN cbCipher:SENSITIVE = YES
                   cbCipher =  ttObjAttrs.obj-cipher
                   togEnabled = YES
                   hFakeCipher:HIDDEN = YES.

            DISPLAY cbCipher WITH FRAME Dialog-Frame.

            RUN enableGenKey.
        END.

        DISPLAY objType togEnabled TogGenKey WITH FRAME Dialog-Frame.

        /* if there are changes that can be undone, enable the revert button */
        Btn_Revert:SENSITIVE = (IF ttObjAttrs.disp-name BEGINS "*" THEN YES ELSE NO).

        /* only enable copy if there was a change, and not only one object on the lsit */
        IF NOT onlyOne THEN
           Btn_Copy:SENSITIVE = Btn_Revert:SENSITIVE.

    END.
END.

ON VALUE-CHANGED OF TogEnabled IN FRAME Dialog-Frame 
DO:
    DEFINE VARIABLE savedCipher AS CHAR NO-UNDO.

    RUN StartEdit.                    

    DO WITH FRAME Dialog-Frame:
    
        IF SELF:SCREEN-VALUE = "no" THEN DO:
            ASSIGN cbCipher:SENSITIVE = NO
                   hFakeCipher:HIDDEN = NO
                   TogGenKey:SENSITIVE = NO
                   TogGenKey:SCREEN-VALUE = "NO".
        END.
        ELSE DO:
            ASSIGN cbCipher:SENSITIVE = YES
                   hFakeCipher:HIDDEN = YES.
              
            /* if this is enabling encryption, use the default, otherwise,
               use the value in the record, unless it got changed by the user
               while editing, in which case we leave it as the last value
               selected.
            */
            savedCipher = cbCipher.
            IF NOT cipherChanged AND ttObjAttrs.obj-cipher = "" THEN
                cbCipher = currdefCipher.
            ELSE IF cbCipher NE cbCipher:SCREEN-VALUE THEN
                cbCipher = cbCipher:SCREEN-VALUE.

            DISPLAY cbCipher WITH FRAME Dialog-Frame.
            /* revert it back */
            cbCipher = savedCipher.
    
            /* this handles an implicit genkey for an object that is not saved yet */
            RUN enableGenKey.
        END.
    END.
END.

ON VALUE-CHANGED OF TogGenKey IN FRAME Dialog-Frame OR
   VALUE-CHANGED OF cbCipher IN FRAME Dialog-Frame 
DO:
    DEFINE VARIABLE origCipher AS CHAR NO-UNDO.

    RUN StartEdit.

    IF SELF:NAME = "cbcipher" THEN DO:
        
        /* when changing ciphers, try to keep the implict genkey setting, which is set when
           changing ciphers. So if this is the first cipher changed, check against the value in 
           the ttObjAttrs record. If not the first change, we have a before-image record,
           and we check against it. But if the user si changing it back and forth, and it
           ends up going back to the original value, there is no change at all.
        */
        FIND FIRST bfttObjAttrs WHERE ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        IF AVAILABLE bfttObjAttrs AND  bfttObjAttrs.obj-cipher NE "" THEN
            origCipher = bfttObjAttrs.obj-cipher.
        ELSE IF NOT AVAILABLE bfttObjAttrs AND ttObjAttrs.obj-cipher NE "" THEN
            origCipher = ttObjAttrs.obj-cipher.
        ELSE
            origCipher = cbCipher:SCREEN-VALUE.

        IF origCipher NE cbCipher:SCREEN-VALUE THEN DO:
            /* implicit generate */
            ASSIGN TogGenKey = YES
                   TogGenKey:SENSITIVE IN FRAME  Dialog-Frame = NO.
            DISPLAY TogGenKey WITH FRAME  Dialog-Frame.
        END.
        ELSE DO:
            ASSIGN TogGenKey = ttObjAttrs.obj-genkey.
            /* genkey should not be enabled if user is enabling encryption on an
               object that has encryption off at this point.
            */
            TogGenKey:SENSITIVE IN FRAME  Dialog-Frame = NOT isCurrDisabled.
    
            DISPLAY TogGenKey WITH FRAME  Dialog-Frame.
        END.

        DISPLAY TogGenKey WITH FRAME  Dialog-Frame.

        ASSIGN cipherChanged = YES.
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
        /* to fix focus issue on tty */
        APPLY "ENTRY" TO SELF.
&ENDIF
    END.
END.

ON CHOOSE OF Btn_Save IN FRAME Dialog-Frame 
DO:
    DEFINE VARIABLE reverted AS LOGICAL NO-UNDO.

    DO WITH FRAME Dialog-Frame :

        /* if this is the first update to a policy, get an exclusive lock on
           the schema, so that other users get blocked when trying to 
           change any schema info or enc policies.
        */
        IF firstUpdate THEN DO ON STOP UNDO, RETURN NO-APPLY:
            myEPolicy:getDbLock(YES).
            firstUpdate = NO.
        END.

        IF togEnabled:SCREEN-VALUE = "yes" THEN DO:
           ASSIGN ttObjAttrs.obj-cipher = cbCipher:SCREEN-VALUE.

           /* if an implicity gen-key, don't need to update it. The rationale is that if there is a
              before-image record and have different cipher, this is the implict genkey case,
              so we don't want to save that in the record.
           */
           FIND FIRST bfttObjAttrs WHERE ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
           IF NOT TogGenKey:SENSITIVE AND TogGenKey:SCREEN-VALUE = "yes" THEN
               ttObjAttrs.obj-genkey = NO.
           ELSE IF AVAILABLE bfttObjAttrs AND 
               bfttObjAttrs.obj-cipher EQ ttObjAttrs.obj-cipher THEN
                  ttObjAttrs.obj-genkey = TogGenKey:SCREEN-VALUE = "yes".

           /* remember the last cipher that was saved */
           IF cipherChanged THEN
              ASSIGN currdefCipher = cbCipher:SCREEN-VALUE.
        END.
        ELSE
           ASSIGN ttObjAttrs.obj-cipher = ""
                  ttObjAttrs.obj-genkey = NO.

        /* signal that this has changes with an asterisk */
        ttObjAttrs.disp-name = "*" + ttObjAttrs.obj-name.

        /* let's see if this changed the record to the previous state, meaning that
           now there are no effective changes to the record
        */
        FIND FIRST bfttObjAttrs WHERE 
            ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        IF AVAILABLE bfttObjAttrs THEN DO:
            IF bfttObjAttrs.obj-cipher = ttObjAttrs.obj-cipher 
                AND bfttObjAttrs.obj-genkey = ttObjAttrs.obj-genkey THEN DO:
                /* same values, so reject the changes that happened until now */
                BUFFER bfttObjAttrs:REJECT-ROW-CHANGES().
                ASSIGN reverted = YES.
            END.
        END.

        /* refresh column in browse in case we added the asterisk above */
        /* fetch record just in case we lost it due to the reject-row-changes above */
        BrowseList:FETCH-SELECTED-ROW(1).
        DISPLAY ttObjAttrs.disp-name WITH BROWSE BrowseList.

        RUN EndEdit.
        IF reverted THEN
            MESSAGE "This reverted the policy for this object to its original state." SKIP
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

    DEF VAR iCount     AS INT      NO-UNDO.
    DEF VAR lDisable   AS LONGCHAR NO-UNDO.
    DEF VAR lGen       AS LONGCHAR NO-UNDO.
    DEF VAR lReport    AS LONGCHAR
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
        
        IF bttObjAttrs.obj-cipher NE bfttObjAttrs.obj-cipher THEN DO:
            ASSIGN iCount = iCount + 1.

            IF bttObjAttrs.obj-cipher = "" THEN DO:
                lDisable = lDisable + "  " + bfttObjAttrs.obj-name  
                           + " (" + bfttObjAttrs.obj-type + ")" + CHR(10).
            END.
            ELSE DO:
                CREATE ttReport.
                ASSIGN ttReport.obj-name = bfttObjAttrs.obj-name
                       ttReport.obj-type = bfttObjAttrs.obj-type
                       ttReport.old-cipher = bfttObjAttrs.obj-cipher 
                       ttReport.new-cipher = bttObjAttrs.obj-cipher.
            END.
        END.
        ELSE IF bttObjAttrs.obj-genkey NE bfttObjAttrs.obj-genkey THEN DO:
            ASSIGN iCount = iCount + 1
                   lGen = lGen + "  " + bfttObjAttrs.obj-name 
                          + " (" + bfttObjAttrs.obj-type + ")" + CHR(10).
        END.
        
    END.

    IF iCount > 0 THEN DO:

        lReport =   "Summary of changes to encryption policies" + CHR(10)
                  + "=========================================".

        /* first all newly enabled policies */
        FOR EACH ttReport WHERE ttReport.old-cipher = "" BREAK BY ttReport.new-cipher:
            IF FIRST-OF (new-cipher) THEN
                lReport = lReport + CHR(10) + CHR(10) + "Enable encryption with cipher '" + 
                          ttReport.new-cipher + "' for objects:" + CHR(10).
              
            lReport = lReport + "  " + ttReport.obj-name 
                      + " (" + ttReport.obj-type + ")" + CHR(10).
            DELETE ttReport.
        END.

        IF lDisable NE "" THEN
           lReport = lReport + CHR(10) + CHR(10)
                     + "Disable encryption for objects:" + CHR(10) + lDisable .

        IF lGen NE "" THEN
           lReport = lReport + CHR(10) + CHR(10) 
            + "Generate new key for objects:" + CHR(10) + lGen.

        /* first all newly enabled policies */
        FOR EACH ttReport BREAK BY ttReport.new-cipher:
            IF FIRST-OF (new-cipher) THEN
                lReport = lReport + CHR(10) + CHR(10) 
                          + "Change encryption policy to cipher '" + 
                          ttReport.new-cipher + "' for objects:" + CHR(10).
              
            lReport = lReport + "  " + ttReport.obj-name + " (" + ttReport.obj-type + ")".
            DELETE ttReport.
        END.

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
        MESSAGE "There are no changes to the current encryption policies"
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

/* We create a fake widget to put on top of the cipher combo-box so that
   when encryption is disabled for an object, we don't display anything.
*/        
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
CREATE FILL-IN hFakeCipher
   ASSIGN
&ELSE
CREATE COMBO-BOX hFakeCipher
   ASSIGN
      SUBTYPE = "SIMPLE"
&ENDIF
      FRAME =  cbCipher:FRAME:HANDLE
      X = cbCipher:X
      Y = cbCipher:Y
      WIDTH = cbCipher:WIDTH
      HIDDEN = YES.

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
               cbCipher:HELP IN FRAME Dialog-Frame = cHelp
               togEnabled :HELP = cHelp
               TogGenKey:HELP = cHelp
               Btn_Save:HELP = cHelp
               Btn_Review:HELP = cHelp
               Btn_Revert:HELP = cHelp.
    ELSE
        ASSIGN cHelp = BrowseList:HELP IN FRAME Dialog-Frame
               cbCipher:HELP = cHelp
               togEnabled :HELP = cHelp
               TogGenKey:HELP = cHelp
               Btn_Revert:HELP = cHelp
               Btn_Copy:HELP = cHelp
               Btn_Review:HELP = cHelp
               Btn_Cancel:HELP = cHelp
               Btn_Commit:HELP = cHelp.
END PROCEDURE.

&ENDIF

/* PROCEDURE: checkUpdatesBeforeExit
 *            Called when user wants to exit. Check if there are chnages and alert to that fact
 *            so they get a chance to save them.
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

    /* now pass the changes to out epolicy object and save them to the db */
    myEPolicy:updatePolicies(INPUT ?, INPUT DATASET dsObjAttrs BY-REFERENCE).

    /* if updatePolicies throws error, we won't get here, will get in the catch block below */
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

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 

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
                              NOT (ttCopy.obj-cipher EQ ttObjAttrs.obj-cipher AND
                                   ttCopy.obj-genkey EQ ttObjAttrs.obj-genkey) AND
                              ttCopy.obj-name MATCHES pattern.
                  /* store the rowid of the first row selected so we move
                     focus to it later - OE00172180.
                  */
                  IF rrowid = ? THEN
                      rrowid = ROWID(ttCopy).
                  REPOSITION browse-Copy TO ROWID ROWID(ttCopy).
                  browse-Copy:SELECT-ROW(browse-Copy:FOCUSED-ROW).
              END.

              /* move to the first selected, if any - OE00172180 */
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
        DEF VAR i AS INT NO-UNDO.
        DEF VAR j AS INT NO-UNDO.
        DEF VAR newcipherVal AS CHAR NO-UNDO.
        DEF VAR newgenkeyVal AS LOGICAL NO-UNDO.

        ASSIGN i = browse-Copy:NUM-SELECTED-ROWS IN FRAME SelectionCopy.
        IF i = 0 THEN DO:
            MESSAGE "Select ay least one object or press Cancel"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            RETURN NO-APPLY.
        END.

        ASSIGN newcipherVal = ttObjAttrs.obj-cipher
               newgenkeyVal = ttObjAttrs.obj-genkey.

        REPEAT j = 1 TO i:
            browse-Copy:FETCH-SELECTED-ROW(j).
            FIND FIRST bttObjAttrs WHERE bttObjAttrs.obj-name = ttCopy.obj-name AND
                bttObjAttrs.obj-type = ttCopy.obj-type.
            /* if the values are different, assign them */
            IF bttObjAttrs.obj-cipher NE newcipherVal OR
               bttObjAttrs.obj-genkey NE newgenkeyVal THEN DO:
                ASSIGN bttObjAttrs.obj-cipher = newcipherVal
                       bttObjAttrs.obj-genkey = newgenkeyVal
                       bttObjAttrs.disp-name = "*" + bttObjAttrs.obj-name.

                /* let's see if this changed the record to the previous state, meaning that
                   now there are no effective changes to the record
                */
                FIND FIRST bfttObjAttrs WHERE 
                    ROWID(bfttObjAttrs) = BUFFER bttObjAttrs:BEFORE-ROWID NO-ERROR.
                IF AVAILABLE bfttObjAttrs THEN DO:
                    IF bfttObjAttrs.obj-cipher = bttObjAttrs.obj-cipher 
                        AND bfttObjAttrs.obj-genkey = bttObjAttrs.obj-genkey THEN DO:
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
             WHERE bttObjAttrs.obj-cipher NE ttObjAttrs.obj-cipher OR
                   bttObjAttrs.obj-genkey NE ttObjAttrs.obj-genkey NO-ERROR.

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
                           ttCopy.obj-cipher = bttObjAttrs.obj-cipher
                           ttCopy.obj-genkey = bttObjAttrs.obj-genkey.
                END.
            END.
            ELSE DO:
                /* otherwise make sure it is up-to-date */
                FOR EACH bttObjAttrs:
                    FIND FIRST ttCopy WHERE ttcopy.seq = bttObjAttrs.seq-num.
                    ASSIGN ttCopy.obj-cipher = bttObjAttrs.obj-cipher
                           ttCopy.obj-genkey = bttObjAttrs.obj-genkey.
                END.
    
            END.
    
            /* exclude the currently selected one from the Copy browse */
            FIND ttCopy WHERE ttCopy.obj-name EQ ttObjAttrs.obj-name AND
                ttCopy.obj-type EQ ttObjAttrs.obj-type NO-LOCK.
            rRowid = ROWID(ttCopy).
            RELEASE ttCopy.
    
            /* only display the ones that have different settings from the current one */
            OPEN QUERY browse-Copy FOR EACH ttCopy WHERE ROWID(ttCopy) NE rRowid AND
                      (ttCopy.obj-cipher NE ttObjAttrs.obj-cipher OR
                      ttCopy.obj-genkey NE ttObjAttrs.obj-genkey).
    
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
  DISPLAY BrowseList TogEnabled TogGenKey cbCipher Pass-phrase Verify-pass-phrase 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-1 BrowseList TogEnabled Btn_Cancel
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
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

/* PROCEDURE: enableGenKey
 *            Deal with enabling the genket toggle-box - handles the implict case
 */
PROCEDURE enableGenKey:

    IF NOT isCurrDisabled THEN DO:
        /* when the user changes the cipher, we carry an implicit genkey so then we check
           the genkey toggle-box just to signal that the key will get generated.
           As the user starts enabling/disabling it before commiting the changes, we then try to
           keep the implicit case consistent.
           If there is a before-image and the cipher is the same, then it's not the implicit case,
           so we don't set the implict genkey.
        */
        FIND FIRST bfttObjAttrs WHERE ROWID(bfttObjAttrs) = BUFFER ttObjAttrs:BEFORE-ROWID NO-ERROR.
        /* if changing cipher, there is an implicit generate key action */
        IF (AVAILABLE bfttObjAttrs AND bfttObjAttrs.obj-cipher NE ""
            AND bfttObjAttrs.obj-cipher NE cbCipher:SCREEN-VALUE IN FRAME Dialog-Frame ) OR
            (NOT AVAILABLE bfttObjAttrs AND ttObjAttrs.obj-cipher NE "" AND 
             ttObjAttrs.obj-cipher NE cbCipher:SCREEN-VALUE IN FRAME Dialog-Frame) THEN DO:
            ASSIGN TogGenKey:SENSITIVE IN FRAME Dialog-Frame = NO
                   TogGenKey:SCREEN-VALUE = "yes".
    
           IF NOT isEditing THEN
              ASSIGN TogGenKey = YES.
        END.
        ELSE
            ASSIGN TogGenKey:SENSITIVE = YES.
    END.
    ELSE
       TogGenKey:SENSITIVE = NO.

END.

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
    
    ASSIGN cipherChanged = NO
           btn_Commit:SENSITIVE = CAN-FIND (FIRST bfttObjAttrs NO-LOCK)
           btn_Review:SENSITIVE = btn_Commit:SENSITIVE.
      
     /* go back to the browse */ 
     APPLY "ENTRY" TO BrowseList.
END PROCEDURE.

/* PROCEDURE: populateCombo
 *            Populate combo-box with cipher names
 */
PROCEDURE populateCombo:         
    DEFINE VARIABLE cList         AS CHAR    NO-UNDO.

    cList = myEPolicy:CipherNames NO-ERROR.
    IF NOT (cList = ? OR cList = "") THEN DO:
       ASSIGN cbCipher:LIST-ITEMS IN FRAME Dialog-Frame = cList
              cbCipher = myEPolicy:DefaultCipher
              currdefCipher = cbCipher.
    END.
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
