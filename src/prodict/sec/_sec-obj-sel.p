/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/sec/_sec-obj-sel.p

Description:
    Interface for choosing objects for various tasks on encryption 
    policies (encryption)

Input-Parameters:
    myEPolicy - _sec-pol-util object
    dsObjAttrs - dataset with objects selected by user

Output-Parameters:
    none
    
History:
    07/01/08  fernando   created

--------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
USING Progress.Security.DB.* .
USING prodict.sec.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{prodict/sec/sec-pol.i}
{adecomm/adestds.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER myEPolicy AS CLASS _sec-pol-util.
DEFINE OUTPUT PARAMETER DATASET FOR dsObjAttrs.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE CipherListAvailable AS LOGICAL   NO-UNDO.
DEFINE VARIABLE numPrevSelected     AS INTEGER   NO-UNDO.
DEFINE VARIABLE pprompt             AS CHARACTER NO-UNDO.
DEFINE VARIABLE pattern             AS CHARACTER NO-UNDO INITIAL "*".
DEFINE VARIABLE cHeader             AS CHARACTER NO-UNDO EXTENT 2 FORMAT "X(77)".
DEFINE VARIABLE cHelp               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjType            AS CHARACTER NO-UNDO.

DEFINE VARIABLE msg                 AS CHARACTER NO-UNDO EXTENT 5 INITIAL
    ["Cannot change the object encryption policy until its encrypted",
     "data has been updated. Refer to the proutil epolicy utility.",
     "Objects that cannot have the encryption policy changed until its encrypted",
     "data is updated were not selected. Refer to the proutil epolicy utility.",
     "Select at least one object or press Cancel"
    ].

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


/* ***********************  Control Definitions  ********************** */

DEFINE BUTTON Btn_Select_Some 
     LABEL "&Select Some..." .

DEFINE BUTTON Btn_Deselect_Some 
     LABEL "&Deselect Some...". 

DEFINE VARIABLE Cipher AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 17 BY 1 
&ELSE SIZE 25 BY 1 &ENDIF
    NO-UNDO.

DEFINE RECTANGLE Rect1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 76 BY 4.
&ELSE SIZE 77 BY 3.33 &ENDIF.

/*DEFINE VARIABLE TogTables AS LOGICAL INITIAL YES 
     LABEL "&Tables" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.6 BY .81 NO-UNDO. */

DEFINE VARIABLE TogIndex AS LOGICAL INITIAL YES 
     LABEL "Show &Indexes" 
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 17.6 BY .81 &endif NO-UNDO.

DEFINE VARIABLE TogLobs AS LOGICAL INITIAL NO 
     LABEL "Show &LOBs" 
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 15.6 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE TogAllEnc AS LOGICAL INITIAL YES 
     LABEL "E&nabled"
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 21 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE TogAllNonEnc AS LOGICAL INITIAL YES 
     LABEL "Di&sabled"
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 14 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE TogCipher AS LOGICAL INITIAL NO 
     LABEL "Filter Ci&pher" 
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 16 BY .81 &ENDIF NO-UNDO.

DEFINE QUERY BrowseList FOR ttObjAttrs SCROLLING.

DEFINE BROWSE BrowseList
    QUERY BrowseList NO-LOCK DISPLAY
        ttObjAttrs.disp-name COLUMN-LABEL "Object Name" FORMAT "x(65)":U WIDTH 65
        cObjType COLUMN-LABEL "Type" FORMAT "x(4)":U WIDTH 4
    WITH NO-LABELS MULTIPLE
    &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
    SIZE 76 BY 9 
    &ELSE
    SIZE 77 BY 9 
    &ENDIF
    FIT-LAST-COLUMN.

/* ************************  Frame Definitions  *********************** */

/* frame for select / deselect some */
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

/* don't want box for this one */
&UNDEFINE OKBOX
&GLOBAL-DEFINE OKBOX NO

/* main frame */
DEFINE FRAME ObjSelFrame
     cHeader[1] NO-LABEL VIEW-AS TEXT
          SIZE 75 BY .62 
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 2
          &ELSE AT ROW 1 COL 2 WIDGET-ID 30 &ENDIF          
&IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN          
    cHeader[2] NO-LABEL VIEW-AS TEXT
         SIZE 75 BY .62  AT ROW 2 COL 2
&ENDIF
     Btn_Select_Some 
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 15
       &ELSE AT ROW 2 COL 20 WIDGET-ID 8 &ENDIF
     Btn_Deselect_Some
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 4 COL 45
       &ELSE AT ROW 2 COL 38  WIDGET-ID 8 &ENDIF
     BrowseList
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 5 COL 1
       &ELSE AT ROW 3.2 COL 2 WIDGET-ID 2  &ENDIF 
     Rect1
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 14 COL 1
         &ELSE AT ROW 12.65 COL 2 WIDGET-ID 34 &ENDIF 
     TogIndex 
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 2
       &ELSE AT ROW 12.80 COL 3 WIDGET-ID 16 &ENDIF
     TogLobs
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 2
       &ELSE AT ROW 13.80 COL 3 WIDGET-ID 18 &ENDIF
    "Show Encryption:" VIEW-AS TEXT
         SIZE 18 BY .62 
         &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 20
         &ELSE AT ROW 12.80 COL 29 WIDGET-ID 28 &ENDIF       
     TogAllEnc
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 37
       &ELSE AT ROW 12.80 COL 47 WIDGET-ID 20 &ENDIF
     TogAllNonEnc
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 15 COL 49
       &ELSE AT ROW 12.80 COL 60 WIDGET-ID 22 &ENDIF
     TogCipher
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 37
       &ELSE AT ROW 13.80 COL 47 WIDGET-ID 24 &ENDIF
     Cipher
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 16 COL 54
       &ELSE AT ROW 14.80 COL 49 COLON-ALIGNED &ENDIF NO-LABEL WIDGET-ID 26
    {prodict/user/userbtns.i}
    WITH 
         VIEW-AS DIALOG-BOX ROW 1 CENTERED
         KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Object Selector"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.

/* revert to original value */
&UNDEFINE OKBOX
&GLOBAL-DEFINE OKBOX {&ORIG_OKBOX}

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME ObjSelFrame /* Object Selector */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
/*----- HELP -----*/

ON CHOOSE OF Btn_Help IN FRAME ObjSelFrame /* Help */
OR HELP OF FRAME ObjSelFrame
DO: /* Call Help Function (or a simple message). */
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Encryption_Policies_Object_Selector_Dialog_Box1},
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

ON ROW-DISPLAY OF BrowseList
DO:
    /* to save space, make the obj type shorter */
    CASE ttObjAttrs.obj-type:
        WHEN "TABLE" THEN
            cObjType = "Tbl".
        WHEN "INDEX" THEN
            cObjType = "Idx".
        OTHERWISE
            cObjType = ttObjAttrs.obj-type.
    END CASE.
END.

ON GO OF FRAME ObjSelFrame
DO:
    DEFINE VARIABLE nRows  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i      AS INTEGER NO-UNDO.

    /* make sure there is at least one object selected */
    nRows = BrowseList:NUM-SELECTED-ROWS NO-ERROR.
    IF nRows <= 0 THEN DO:
        MESSAGE msg[5]
         VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN NO-APPLY.
    END.
    
   REPEAT i = 1 TO nRows:
       BrowseList:FETCH-SELECTED-ROW(i).
       /* make sure we never let objects with 'previous' policy go through */
       IF NOT ttObjAttrs.has-prev-pol THEN
          ASSIGN ttObjAttrs.obj-selected = YES.
   END.

   /* only leave the selected ones */
   FOR EACH ttObjAttrs WHERE ttObjAttrs.obj-selected = NO.
       DELETE ttObjAttrs.
   END.
END.

ON VALUE-CHANGED OF TogCipher IN FRAME ObjSelFrame
DO:
    /* this toggle controls whether the cipher combo-box is enabled or not */
    IF SELF:SCREEN-VALUE IN FRAME ObjSelFrame = "no" THEN DO:
        ASSIGN Cipher:SENSITIVE = NO.
        RUN refreshObjList.
    END.
    ELSE DO:
        ASSIGN Cipher:SENSITIVE = YES.
        APPLY 'value-changed' TO cipher.
    END.

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    /* don't show it if can't pick cipher */
    Cipher:HIDDEN = NOT Cipher:SENSITIVE.
&ENDIF

END.

ON VALUE-CHANGED OF TogAllEnc IN FRAME ObjSelFrame
DO:
    IF SELF:SCREEN-VALUE IN FRAME ObjSelFrame = "no" THEN DO:
        /* if hiding objects with encryption enabled, warn user if he has selected
           such objects since they will be automatically deselected.
        */
        RUN confirmBeforeShowChange(INPUT SELF).
        IF RETURN-VALUE = "NO-APPLY" THEN DO:
            SELF:SCREEN-VALUE = "yes".
            APPLY "ENTRY" TO SELF.
            RETURN NO-APPLY.
        END.

        ASSIGN TogCipher:SENSITIVE = NO
               Cipher:SENSITIVE = NO
               TogCipher = NO
               TogCipher:SCREEN-VALUE = "no".

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
       /* don't show it if can't pick cipher */
        Cipher:HIDDEN = NOT TogCipher:SENSITIVE.
&ENDIF


        /* don't let both to be unchecked */
        IF TogAllNonEnc:SCREEN-VALUE = "no" THEN DO:
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
            /* on GUI, the toggle remains de-selected, so change it manually */
            ASSIGN TogAllNonEnc:SCREEN-VALUE = "YES".
&ENDIF
            APPLY "value-changed" TO TogAllNonEnc.
            RETURN.
        END.
    END.
    ELSE
        ASSIGN TogCipher:SENSITIVE = YES.
    RUN refreshObjList.
END.

ON VALUE-CHANGED OF TogAllNonEnc IN FRAME ObjSelFrame
DO:
    IF SELF:SCREEN-VALUE IN FRAME ObjSelFrame = "no" THEN DO:
        /* if hiding objects with encryption disabled, warn user if he has selected
           such objects since they will be automatically deselected.
        */
        RUN confirmBeforeShowChange(INPUT SELF).
        IF RETURN-VALUE = "NO-APPLY" THEN DO:
            SELF:SCREEN-VALUE = "yes".
            APPLY "ENTRY" TO SELF.
            RETURN NO-APPLY.
        END.

        /* don't let both to be unchecked */
        IF TogAllEnc:SCREEN-VALUE = "no" THEN DO:
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
            /* on GUI, the toggle remains de-selected, so change it manually */
           ASSIGN TogAllEnc:SCREEN-VALUE = "YES".
&ENDIF
           APPLY "value-changed" TO TogAllEnc.
           RETURN.
        END.
    END.

    RUN refreshObjList.
END.

ON END-ERROR OF FRAME ObjSelFrame OR
   CHOOSE OF Btn_Cancel IN FRAME ObjSelFrame
DO:
    DEFINE VARIABLE answer AS LOGICAL NO-UNDO.
    DEFINE VARIABLE nRows  AS INTEGER NO-UNDO.

    /* ask for confirmation if user tried to cancel and there are objects selected */
    nRows = BrowseList:NUM-SELECTED-ROWS NO-ERROR.
    IF nRows > 0 THEN DO:
        MESSAGE "There are objects selected. Are you sure you want to close this window ?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    
        IF NOT answer THEN
            RETURN NO-APPLY.
    END.

    EMPTY TEMP-TABLE ttObjAttrs NO-ERROR.
END.

ON VALUE-CHANGED OF Cipher IN FRAME ObjSelFrame
DO:
    /* if changing the cipher for the objects to be shown, warn user if he has selected
       objects with other cuphers since they will be automatically deselected.
    */
    RUN confirmBeforeShowChange(INPUT SELF).
    IF RETURN-VALUE = "NO-APPLY" THEN DO:
        APPLY "ENTRY" TO SELF.
        /* put original value back */
        cipher:SCREEN-VALUE = cipher.
        RETURN NO-APPLY.
    END.

    /* save current value in case we need to return no-apply (above) */
    cipher = cipher:SCREEN-VALUE.

    RUN refreshObjList.
END.

ON VALUE-CHANGED OF TogIndex IN FRAME ObjSelFrame OR
   /*VALUE-CHANGED OF TogTables IN FRAME ObjSelFrame OR*/
   VALUE-CHANGED OF TogLobs IN FRAME ObjSelFrame
DO: 
    IF SELF:SCREEN-VALUE = "no" THEN DO:

        /* if hiding objects with specific type, warn user if he has selected
           such objects since they will be automatically deselected.
        */
       RUN confirmBeforeShowChange(INPUT SELF).
       IF RETURN-VALUE = "NO-APPLY" THEN DO:
           SELF:SCREEN-VALUE = "yes".
           APPLY "ENTRY" TO SELF.
           RETURN NO-APPLY.
       END.
    END.

    RUN refreshObjList.
    
END.

ON CHOOSE OF Btn_Select_Some IN FRAME ObjSelFrame
DO:
   DEFINE VARIABLE n             AS INT    NO-UNDO.
   DEFINE VARIABLE filterCipher  AS CHAR   NO-UNDO.
   DEFINE VARIABLE cTypes        AS CHAR   NO-UNDO.
   DEFINE VARIABLE rrowid        AS ROWID  NO-UNDO.

   ASSIGN n = BrowseList:FOCUSED-ROW.

   ASSIGN FRAME obj_patt:TITLE = "Select Objects by Pattern Match"
          pprompt = "Enter name of object to select.".

   display pprompt with frame obj_patt.
 
   do ON ENDKEY UNDO, LEAVE:
      update pattern btn_OK btn_Cancel {&HLP_BTN_NAME}
          with frame obj_patt.

      pattern = TRIM(pattern).
      IF pattern = "*" THEN
         BrowseList:SELECT-ALL().
      ELSE DO:
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
          /* can't have this since this causes issues with selected rows
             on multi-select browse on tty - OE00172180 
          */
          BrowseList:SET-REPOSITIONED-ROW(n,"conditional").
&ENDIF
          /* get the objects that are displayed now */
          RUN getCurrentOptions(OUTPUT cTypes, OUTPUT filterCipher).
          
          FOR EACH ttObjAttrs WHERE ttObjAttrs.obj-name MATCHES pattern.
              /* Let's avoid repositioning to a record that we know it's
                 not been displayed, or the reposition will fail!
              */
              IF CAN-DO(cTypes,ttObjAttrs.obj-type) THEN DO:
                 /* check if the user has cipher filter */

                 /* if no cipher filtered, or only encrypted or
                     a specific cipher or disabled
                 */
                 IF filterCipher = ? 
                    OR (filterCipher = "ALL" AND ttObjAttrs.obj-cipher NE "")
                    OR CAN-DO(filterCipher,ttObjAttrs.obj-cipher) THEN DO:
                     /* store the rowid of the first row selected so we move
                        focus to it later - OE00172180.
                     */
                     IF rrowid = ? THEN
                        rrowid = ROWID(ttObjAttrs).
                    REPOSITION BrowseList TO ROWID ROWID(ttObjAttrs).
                    BrowseList:SELECT-ROW(BrowseList:FOCUSED-ROW).
                 END.
              END.
          END.

          /* move to the first selected, if any - OE00172180 */
          IF rrowid NE ? THEN
              REPOSITION BrowseList TO ROWID rrowid.
      END.
    
      /* make sure we don't select objects with 'previous' policy */
      RUN check-multi-selected.

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    /* On tty Windows, we end up with a weird behavior, as if a line in the browse is
       selected, even though the focus in on something else, so this does the trick.
    */
    IF SELF:TYPE NE "Browse" THEN
       APPLY "leave" TO BrowseList.
    APPLY "entry" TO SELF.
&ENDIF

   END.
END.

ON CHOOSE OF Btn_Deselect_Some IN FRAME ObjSelFrame
DO:
   DEFINE VAR nRows AS INTEGER NO-UNDO.
   DEFINE VAR i     AS INTEGER NO-UNDO.

   ASSIGN FRAME obj_patt:TITLE = "Deselect Objects by Pattern Match"
          pprompt = "Enter name of object to deselect.".
     
   display pprompt with frame obj_patt.
 
   do ON ENDKEY UNDO, LEAVE:
      update pattern btn_OK btn_Cancel {&HLP_BTN_NAME}
           with frame obj_patt.
      
      nRows = BrowseList:NUM-SELECTED-ROWS.
     
      IF nRows > 0 THEN DO:
          pattern = TRIM(pattern).
          IF pattern = "*" THEN
             BrowseList:DESELECT-ROWS().
          ELSE DO:
               rpt-blk:
               REPEAT i = 1 TO nRows:
                   BrowseList:FETCH-SELECTED-ROW(i).
                   IF ttObjAttrs.obj-name MATCHES pattern THEN DO:
                        BrowseList:DESELECT-SELECTED-ROW(i).
                        /* now that we have deselected the row, decrement the counters */
                        ASSIGN i = i - 1
                               nRows = nRows - 1.
                   END.
               END.
          END.
      END.
   END.
END.

/* when selecting with CTRL + mouse click */
ON MOUSE-EXTEND-UP OF BrowseList IN FRAME ObjSelFrame
DO:
    IF BrowseList:FOCUSED-ROW-SELECTED THEN DO:
        IF ttObjAttrs.has-prev-pol THEN DO:

           BrowseList:DESELECT-FOCUSED-ROW().

           MESSAGE msg[1] SKIP msg[2]
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
    END.
END.

/* to handle selection with mouse dragging on GUI */
ON mouse-select-down OF BrowseList IN FRAME ObjSelFrame
DO:
    /* keep track of how many rows are selected now, so that if the user
       drags the mouse to select multiple rows, we know if he has selected
       one row or multiple rows, so that we do the right thing in the
       mouse-select-up trigger.
    */
    numPrevSelected = BrowseList:NUM-SELECTED-ROWS.
END.

/* to handle selection with mouse dragging on GUI */
ON mouse-select-up OF BrowseList IN FRAME ObjSelFrame
DO:
    DEF VAR i AS INT NO-UNDO.
    DEF VAR j AS INT NO-UNDO.
    DEF VAR dispMsg AS LOGICAL NO-UNDO.

    i = BrowseList:NUM-SELECTED-ROWS.

    IF i = numPrevSelected THEN DO:
        /* if the user is selecting a row with an object that has a 'previous'
           policy, don't let it be selected.
        */
        IF BrowseList:FOCUSED-ROW-SELECTED THEN DO:
            IF ttObjAttrs.has-prev-pol THEN DO:
    
               BrowseList:DESELECT-FOCUSED-ROW().
    
               MESSAGE msg[1] SKIP msg[2]
                   VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
        END.
    END.
    ELSE IF i > numPrevSelected THEN DO:
        RUN check-multi-selected.
    END.
END.

ON VALUE-CHANGED OF BrowseList IN FRAME ObjSelFrame
DO:
    /* only check this when there are rows selected. When there is no row
       selected, i.e. you had selected one row, and now you deselected that
       only selected row, the available record is the first one in the
       browse, and if that happens to have a previous policy, we will
       display the message althought that is not the table that got
       deselected.
    */
    IF BrowseList:NUM-SELECTED-ROWS > 0 AND AVAILABLE ttObjAttrs THEN DO:
        IF ttObjAttrs.has-prev-pol THEN DO:
            BrowseList:DESELECT-FOCUSED-ROW().
            MESSAGE msg[1] SKIP msg[2]
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
        END.
    END.
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
  ON F5 OF FRAME ObjSelFrame ANYWHERE DO:
     APPLY "CHOOSE" TO Btn_Select_Some IN FRAME ObjSelFrame.
  END.

  ON F6 OF FRAME ObjSelFrame ANYWHERE DO:
     APPLY "CHOOSE" TO Btn_Deselect_Some IN FRAME ObjSelFrame.
  END.

  ON F7 OF FRAME ObjSelFrame ANYWHERE DO:
     APPLY "ENTRY" TO TogIndex IN FRAME ObjSelFrame.
  END.
             
&ENDIF

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME ObjSelFrame:PARENT eq ?
THEN FRAME ObjSelFrame:PARENT = ACTIVE-WINDOW.

RUN populateValues.

IF NOT CAN-FIND (FIRST ttObjAttrs) THEN DO:
   IF myEPolicy:EncryptionEnabledOnly THEN
       MESSAGE "There are no objects with encryption currently enabled."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
   ELSE
       MESSAGE "There are no objects that can have encryption policies~nmaintained through this client."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN ERROR.
END.
ELSE DO:
    
    /* if all objects have a previous policy, can't select any */
    IF NOT CAN-FIND (FIRST ttObjAttrs WHERE NOT has-prev-pol) THEN DO:
       IF myEPolicy:EncryptionEnabledOnly THEN DO:
          MESSAGE "All objects with encryption enabled have a policy in transition." SKIP
                  "You must complete the transition before generating the encryption" SKIP
                  "key for any given object. Refer to the proutil epolicy utility."
              VIEW-AS ALERT-BOX INFO.
       END.
       ELSE DO:
           MESSAGE "All encryptable objects have a policy in transition." SKIP
                   "You must complete the transition before updating the policy" SKIP
                   "for any given object. Refer to the proutil epolicy utility." SKIP
               VIEW-AS ALERT-BOX INFO.
       END.
       RETURN ERROR.
    END.

    /* if only selecting from enabled ones, check if only LOBS are selectable */
    IF myEPolicy:EncryptionEnabledOnly THEN DO:
       DEFINE VARIABLE opt AS LOGICAL NO-UNDO.

       IF NOT CAN-FIND (FIRST ttObjAttrs WHERE NOT has-prev-pol AND 
                        (obj-type = "Table" OR obj-type = "Index"))  THEN DO:
           MESSAGE "There are no tables or indexes with encryption enabled or" SKIP
                   "that do not have a policy in transition. " SKIP 
                   "Do you want to view LOB fields?"
                   VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE opt.
           IF NOT opt THEN
              RETURN ERROR.

           /* turn on the lobs toggle-box */
           togLobs = YES.
       END.
    END.
END.

&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
/* assign help for all elements */
ASSIGN cHelp = KBLABEL("GO") + "=OK " +
                             KBLABEL("END-ERROR") + "=Cancel  " +
                             KBLABEL("F5") + "/"  +
                             KBLABEL("F6") + "=Select/Deselect Some  " +
                             KBLABEL("F7") + "=Focus to Filter"
        BROWSE BrowseList:HELP = cHelp
        Btn_Select_Some:HELP = cHelp
        Btn_Deselect_Some:HELP = cHelp
        TogIndex:HELP = cHelp
        TogLobs:HELP = cHelp
        TogAllNonEnc:HELP = cHelp
        TogAllEnc:HELP = cHelp
        TogCipher:HELP = cHelp
        Cipher:HELP = cHelp
        Btn_OK:HELP = cHelp
        Btn_Cancel:HELP = cHelp.
      
&ENDIF

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
ASSIGN cHeader[1] = "Select one or more objects with the [SPACEBAR] key."
       cHeader[2] = "Press [" + KBLABEL("GO") + "] to go to the next screen.".
&ELSE
ASSIGN cHeader[1] = "Select one or more objects and hit the OK button to go to the next screen.".
&ENDIF

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME obj_patt" 
   {&BOX_BTN}
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

{adecomm/okrun.i  
   &FRAME  = "FRAME ObjSelFrame" 
   &OKBOX  = NO
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* set the display name as the object name */
  FOR EACH ttObjAttrs:
      ttObjAttrs.disp-name = ttObjAttrs.obj-name.
  END.

  /* if only selecting from objects that have encryption currently
     enabled, adjust the toggle-boxes values.
  */
  IF myEPolicy:EncryptionEnabledOnly THEN DO:
     ASSIGN TogAllEnc = YES
            TogAllNonEnc = NO.
  END.

  RUN enable_UI.

  WAIT-FOR GO OF FRAME ObjSelFrame.
END.

RUN disable_UI.


/* **********************  Internal Procedures  *********************** */

/* Check if any one of the selected objects has a 'previous' policy and 
   de-select it.
*/
PROCEDURE check-multi-selected.

    DEF VAR i       AS INT NO-UNDO.
    DEF VAR numS    AS INT NO-UNDO.
    DEF VAR dispMsg AS LOGICAL NO-UNDO.

    numS = BrowseList:NUM-SELECTED-ROWS IN FRAME ObjSelFrame.

    REPEAT i = 1 TO numS:
        BrowseList:FETCH-SELECTED-ROW(i).
        IF ttObjAttrs.has-prev-pol THEN DO:
            IF NOT dispMsg THEN
                dispMsg = YES.

            BrowseList:DESELECT-SELECTED-ROW(i).
            /* now that we have deselected the row, decrement the counters */
            ASSIGN i = i - 1
                   numS = numS - 1.
        END.
    END.

    IF dispMsg THEN
        MESSAGE msg[3] SKIP msg[4]
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.

END.

/* If user is changing the objects to be display, let user know that any selected
   objects that are not going to be displayed will be deselected.
*/   
PROCEDURE confirmBeforeShowChange:
    DEFINE INPUT  PARAMETER hObj AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE answer  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cType   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCipher AS CHARACTER NO-UNDO INIT ?.
    DEFINE VARIABLE nRows   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i       AS INTEGER   NO-UNDO.

    /* the object we get here is what is getting changed */
    IF hObj:NAME = "TogIndex" THEN
       ASSIGN cType = "Index".
    ELSE IF hObj:NAME = "TogLobs" THEN
            ASSIGN cType = "CLOB,BLOB".
    ELSE IF hObj:NAME = "Cipher" THEN DO:
        /* we are moving to a cipher, so check if any one of the selected rows has a
          different cipher.
        */
        cCipher = "!" + cipher:SCREEN-VALUE IN FRAME ObjSelFrame + ",*".
    END.
    ELSE IF hObj:NAME = "TogAllEnc" THEN
        cCipher = "ALL".
    ELSE IF hObj:NAME = "TogAllNonEnc" THEN
        cCipher = "".

    nRows = BrowseList:NUM-SELECTED-ROWS.

    IF nRows > 0 THEN DO:
       rpt-blk:
       REPEAT i = 1 TO nRows:
           BrowseList:FETCH-SELECTED-ROW(i).
           /* if type is being turned off and objects with that type were selected,
              or want all objects with a valid cipher and object select does not have a
              policy with a encryption cipher
              or not the "diplay all" case and cipher is the one it going to be hidden
              then warn user that those objects will get deselected.
           */
           IF (cType NE "" AND CAN-DO(cType, ttObjAttrs.obj-type)) 
               OR (cCipher EQ "ALL" AND ttObjAttrs.obj-cipher NE "")
               OR (cCipher NE ? AND CAN-DO(cCipher, ttObjAttrs.obj-cipher)) THEN DO:
               MESSAGE "You have selected objects which will get deselected"
                   SKIP "when changing this setting. Do you want to continue?"
                   VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE answer.

               IF NOT answer THEN DO:
                  RETURN "NO-APPLY".
               END.
               LEAVE rpt-blk. /* get out of loop */
           END.
       END.
    END.

    RETURN "".
END.

PROCEDURE disable_UI :
  /* Hide all frames */
  HIDE FRAME ObjSelFrame.
END PROCEDURE.

PROCEDURE enable_UI :

  DISPLAY cHeader[1] 
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
          cHeader[2]
&ENDIF
          BrowseList /*TogTables*/
          TogIndex TogLobs TogAllNonEnc TogAllEnc  TogCipher Cipher Rect1
      WITH FRAME ObjSelFrame.
  ENABLE BrowseList Btn_Select_Some Btn_Deselect_Some /*TogTables*/ TogIndex
         TogLobs TogAllNonEnc TogAllEnc TogCipher Btn_OK Btn_Cancel
         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
      WITH FRAME ObjSelFrame.

  IF NOT CipherListAvailable THEN
    DISABLE TogCipher WITH FRAME ObjSelFrame.

  IF myEPolicy:EncryptionEnabledOnly THEN
      DISABLE TogAllNonEnc TogAllEnc WITH FRAME ObjSelFrame.

&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    Cipher:HIDDEN = YES.
&ENDIF

  VIEW FRAME ObjSelFrame.

  RUN refreshObjList.

END PROCEDURE.


PROCEDURE populateValues:         
    DEF VAR cList AS CHAR NO-UNDO.

    /* populate the dataset */
    myEPolicy:getTableList(INPUT YES, /* get current policy info */
                           OUTPUT DATASET dsObjAttrs BY-REFERENCE).

    cList = myEPolicy:CipherNames NO-ERROR.
    IF NOT (cList = ? OR cList = "") THEN DO:
       ASSIGN cipher:LIST-ITEMS IN FRAME ObjSelFrame = cList
              CipherListAvailable = TRUE
              cipher = myEPolicy:DefaultCipher.
    END.
END.

PROCEDURE refreshObjList:
    DEFINE VARIABLE filterCipher  AS CHAR      NO-UNDO.
    DEFINE VARIABLE cTypes        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE nRows         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cFocused      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cQueryStr     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE needtoSelect  AS LOGICAL   NO-UNDO.

    RUN getCurrentOptions(OUTPUT cTypes, OUTPUT filterCipher).

    /*mantain selected rows */
    nRows = BrowseList:NUM-SELECTED-ROWS IN FRAME ObjSelFrame.
    
    IF nRows > 0 THEN DO:

       REPEAT i = 1 TO nRows:
           BrowseList:FETCH-SELECTED-ROW(i).
           /* only keep track of objects that need to be reselected after we reopen the
              query.
           */
           IF CAN-DO(cTypes,ttObjAttrs.obj-type) THEN DO:
               IF filterCipher = ?
                  OR (filterCipher = "ALL" AND ttObjAttrs.obj-cipher NE "")
                  OR CAN-DO(filterCipher,ttObjAttrs.obj-cipher) THEN
              ASSIGN ttObjAttrs.obj-selected = YES.
           END.
       END.
    END.

    CLOSE QUERY BrowseList.

    /* build query based on the options the user selected on what objects to be displayed */
    IF CAN-FIND(FIRST ttObjAttrs WHERE obj-selected = YES) THEN
       ASSIGN needToSelect = YES
              cQueryStr = "PRESELECT ".
    ELSE
        cQueryStr = "FOR ".

    cQueryStr = cQueryStr + "EACH ttObjAttrs WHERE CAN-DO(" 
                + QUOTER(cTypes) + ",ttObjAttrs.obj-type) ".

    IF filterCipher EQ "ALL" THEN
        cQueryStr = cQueryStr + 'AND obj-cipher NE "" '.
    ELSE IF filterCipher NE ? THEN DO:
        
        cQueryStr = cQueryStr + 'AND (obj-cipher = ' + QUOTER(ENTRY(1,filterCipher)).
        IF NUM-ENTRIES(filterCipher) > 1 THEN
            cQueryStr = cQueryStr + ' OR obj-cipher = ' + QUOTER(ENTRY(2,filterCipher)).
        cQueryStr = cQueryStr + ")". /* close the AND */
    END.
    
    cQueryStr = cQueryStr + " NO-LOCK" /*+ (IF NOT needToSelect THEN " INDEXED-REPOSITION" ELSE "")*/ .

    QUERY BrowseList:QUERY-PREPARE(cQueryStr).
    QUERY BrowseList:QUERY-OPEN().

    IF CAN-FIND(FIRST ttObjAttrs WHERE obj-selected = YES) THEN DO:
       FOR EACH ttObjAttrs WHERE obj-selected = YES:
           /* try to re-select the rows */
           REPOSITION BrowseList TO ROWID ROWID(ttObjAttrs) NO-ERROR.
           IF NOT ERROR-STATUS:ERROR THEN
              BrowseList:SELECT-ROW(BrowseList:FOCUSED-ROW).
           ASSIGN obj-selected = NO.
       END.
    END.

    /* if no objects are available, can't select/deselect all */
    ASSIGN  Btn_Select_Some:SENSITIVE = QUERY BrowseList:NUM-RESULTS > 0
            Btn_Deselect_Some:SENSITIVE = Btn_Select_Some:SENSITIVE.


&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    /* On tty Windows, we end up with a weird behavior, as if a line in the browse is
       selected, even though the focus in on something else, so this does the trick.
    */
    IF SELF:TYPE NE "Browse" THEN
       APPLY "leave" TO BrowseList.
    APPLY "entry" TO SELF.
&ENDIF

END.

PROCEDURE getCurrentOptions:
    DEFINE OUTPUT PARAMETER cTypes       AS CHAR.
    DEFINE OUTPUT PARAMETER filterCipher AS CHAR.

    /*DEFINE VARIABLE showTables  AS LOGICAL NO-UNDO.*/
    DEFINE VARIABLE showIndexes   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE showLobs      AS LOGICAL   NO-UNDO.

    ASSIGN /*showTables = TogTables:SCREEN-VALUE IN FRAME ObjSelFrame = "yes"*/
           showIndexes = TogIndex:SCREEN-VALUE IN FRAME ObjSelFrame = "yes"
           showLobs = TogLobs:SCREEN-VALUE IN FRAME ObjSelFrame = "yes".

    IF Cipher:SENSITIVE THEN DO:
        IF TogAllNonEnc:SCREEN-VALUE = "yes"  THEN
           filterCipher = "," + Cipher:SCREEN-VALUE.
        ELSE
            filterCipher = Cipher:SCREEN-VALUE.
    END.
    ELSE IF TogAllEnc:SCREEN-VALUE = "yes" AND TogAllNonEnc:SCREEN-VALUE = "no" THEN
        filterCipher = "ALL". /* means all valid ciphers */
    ELSE  IF TogAllEnc:SCREEN-VALUE = "no" AND TogAllNonEnc:SCREEN-VALUE = "yes" THEN
        filterCipher = "". /* means cipher not enabled (or null_null_null) */
    ELSE /*if both are yes, we leave filterCipher as ? which means no cipher filter */
        filterCipher = ?.
    
    ASSIGN cTypes = "Table".
    IF showIndexes THEN
        ASSIGN cTypes = cTypes + ",Index".
    IF showLobs THEN
        ASSIGN cTypes = cTypes + ",CLOB,BLOB".

END.
