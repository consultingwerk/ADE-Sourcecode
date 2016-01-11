/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/sec/_sec-obj-hist.p

Description:
    Interface for viewing encryption policies (encryption)

Input-Parameters:
    myEPolicy - _sec-pol-util object

Output-Parameters:
    none
    
History:
    07/22/08  fernando   created

--------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
USING Progress.Security.DB.* .
USING prodict.sec.*.

{prodict/sec/sec-pol.i}
{adecomm/adestds.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER myEPolicy AS CLASS _sec-pol-util.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttFetch NO-UNDO
    FIELD objNum  AS INT
    FIELD objType AS CHAR
    INDEX objNum objNum objType.

DEFINE VARIABLE opt           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cObjType      AS CHARACTER NO-UNDO.

DEFINE BUTTON btn_Ok     LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}.
   DEFINE BUTTON    btn_Help LABEL "&Help" {&STDPH_OKBTN}.

   &GLOBAL-DEFINE   HLP_BTN   &HELP = "btn_Help"
   &GLOBAL-DEFINE   HLP_BTN_NAME btn_Help
   &GLOBAL-DEFINE   CAN_BTN  /* no cancel button */
   &GLOBAL-DEFINE   WIDG_SKIP SKIP({&VM_WIDG})
   &GLOBAL-DEFINE   STATUS NO
   &GLOBAL-DEFINE   BOX_BTN   &BOX = "rect_Btns"
&ELSE
   &GLOBAL-DEFINE   HLP_BTN  /* no help for tty */
   &GLOBAL-DEFINE   HLP_BTN_NAME /* no help for tty */
   &GLOBAL-DEFINE   CAN_BTN /* no cancel button */
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

DEFINE VARIABLE TogTables AS LOGICAL INITIAL YES 
     LABEL "&Tables" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.6 BY .81 NO-UNDO.

DEFINE VARIABLE TogIndex AS LOGICAL INITIAL YES 
     LABEL "&Indexes" 
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 14.6 BY .81 &endif NO-UNDO.

DEFINE VARIABLE TogLobs AS LOGICAL INITIAL NO 
     LABEL "&LOBs" 
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 14.6 BY .81 &ENDIF NO-UNDO.

DEFINE VARIABLE TogAll AS LOGICAL
     LABEL "&Disabled"
     VIEW-AS TOGGLE-BOX
&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN SIZE 18 BY .81 &ENDIF NO-UNDO.

DEFINE QUERY BrowseList FOR ttObjAttrs    SCROLLING.
DEFINE QUERY BrowsePol  FOR ttObjEncPolicyVersions SCROLLING.

DEFINE BROWSE BrowseList
    QUERY BrowseList NO-LOCK DISPLAY
        ttObjAttrs.disp-name COLUMN-LABEL "Object Name" FORMAT "x(65)":U WIDTH 65
        cObjType COLUMN-LABEL "Type" FORMAT "x(4)":U WIDTH 4
    WITH NO-LABELS
    &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
    SIZE 75 BY 8 
    &ELSE
    SIZE 77 BY 9 
    &ENDIF
    FIT-LAST-COLUMN.

DEFINE BROWSE BrowsePol
    QUERY BrowsePol NO-LOCK DISPLAY
        ttObjEncPolicyVersions.pol-version COLUMN-LABEL "Version" FORMAT "zzzzzzzzz9":U
        ttObjEncPolicyVersions.pol-state COLUMN-LABEL "State" FORMAT "X(15)"
        ttObjEncPolicyVersions.pol-cipher COLUMN-LABEL "Cipher" FORMAT "x(20)":U
    WITH NO-ROW-MARKERS SEPARATORS
    &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
    SIZE 50 BY 7
    &ELSE
    SIZE 60 BY 3.4 
    &ENDIF
    FIT-LAST-COLUMN.

/* ************************  Frame Definitions  *********************** */

/* main frame */
DEFINE FRAME ObjList
     BrowseList
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 1 COL 1
       &ELSE AT ROW 1.2 COL 2 WIDGET-ID 2  &ENDIF 
     TogTables
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 2
       &ELSE AT ROW 10.2 COL 2 WIDGET-ID 4 &ENDIF
     TogIndex 
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 14
       &ELSE AT ROW 10.2 COL 15 WIDGET-ID 6 &ENDIF
     TogLobs
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 27
       &ELSE AT ROW 10.2 COL 29 WIDGET-ID 8 &ENDIF
     TogAll
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 9 COL 37
       &ELSE AT ROW 10.2 COL 41 WIDGET-ID 10 &ENDIF
    BrowsePol
      &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT ROW 10 COL 13
      &ELSE AT ROW 11.5 COL 12 WIDGET-ID 14  &ENDIF 
    {prodict/user/userbtns.i}
    WITH 
         VIEW-AS DIALOG-BOX ROW 1 CENTERED
         KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE THREE-D
         TITLE "Encryption Policy History"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_OK WIDGET-ID 100.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME ObjList /* Object Selector */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

&IF '{&WINDOW-SYSTEM}' NE 'TTY':U &THEN
/*----- HELP -----*/

ON CHOOSE OF Btn_Help IN FRAME ObjList /* Help */
OR HELP OF FRAME ObjList
DO: /* Call Help Function (or a simple message). */
    RUN "adecomm/_adehelp.p" ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Encryption_Policy_History_Dialog_Box},
                               INPUT ?).
  
END.
&ENDIF

ON VALUE-CHANGED OF TogAll IN FRAME ObjList
DO:
    RUN refreshObjList.
END.

ON VALUE-CHANGED OF TogIndex IN FRAME ObjList OR
   VALUE-CHANGED OF TogTables IN FRAME ObjList OR
   VALUE-CHANGED OF TogLobs IN FRAME ObjList
DO: 
    RUN refreshObjList.
END.

ON ROW-DISPLAY OF BrowseList IN FRAME ObjList
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

ON VALUE-CHANGED OF BrowseList IN FRAME ObjList
DO:
    DEFINE VARIABLE isNew AS LOGICAL NO-UNDO.

    CLOSE QUERY BrowsePol.
    IF AVAILABLE (ttObjAttrs) THEN DO:
        /* see if this is the first time */
        FIND FIRST ttFetch WHERE ttFetch.objNum = ttObjAttrs.obj-num AND
              ttFetch.objType = ttObjAttrs.obj-type NO-ERROR.

        IF NOT AVAILABLE ttFetch THEN DO:
            /* first time, so create record for this */
            CREATE ttFetch.
            ASSIGN ttFetch.objNum = ttObjAttrs.obj-num 
                   ttFetch.objType = ttObjAttrs.obj-type
                   isNew = YES.
            VALIDATE ttFetch.
        END.

        /*if the first time, we have to retrieve the policy info. */
        IF isNew THEN DO:

            myEpolicy:getPolicyVersions(ttObjAttrs.obj-num, 
                                        ttObjAttrs.obj-type, 
                                        OUTPUT DATASET dsObjAttrs BY-REFERENCE).
        END.
    
        OPEN QUERY BrowsePol FOR EACH ttObjEncPolicyVersions 
            WHERE ttObjEncPolicyVersions.seq-num = ttObjAttrs.seq-num NO-LOCK.

        BrowsePol:SENSITIVE = QUERY BrowsePol:NUM-RESULTS > 0.
        IF NOT BrowsePol:SENSITIVE THEN
            CLOSE QUERY BrowsePol.
&IF '{&WINDOW-SYSTEM}' EQ 'TTY':U &THEN
        /* fix issue with focus on browse after query is open. It looks as if more
           than one thing has focus 
        */
        APPLY 'leave' TO BrowsePol.
&ENDIF
    END.
END.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME ObjList:PARENT eq ?
THEN FRAME ObjList:PARENT = ACTIVE-WINDOW.

RUN populateValues.

/* set the display name as the object name */
FOR EACH ttObjAttrs:
   /* don't want objects with no policy information */
   IF ttObjAttrs.obj-cipher = "" AND NOT ttObjAttrs.has-prev-pol THEN
       DELETE  ttObjAttrs.
   ELSE
      ttObjAttrs.disp-name = ttObjAttrs.obj-name.
END.


IF NOT CAN-FIND (FIRST ttObjAttrs) THEN DO:
   MESSAGE "There are no objects with encryption policy information."
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
   RETURN ERROR.
END.

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME ObjList" 
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

  RUN enable_UI.

  IF QUERY BrowseList:NUM-RESULTS = 0 THEN DO:
      IF CAN-FIND(FIRST ttObjAttrs WHERE obj-cipher NE "") THEN DO: /* must be LOBs */
          ASSIGN  TogLobs = YES.
          DISPLAY TogLobs WITH FRAME ObjList.
          MESSAGE "There are no tables or indexes with encryption currently enabled." SKIP
                  "List will contain LOBs with encryption enabled."
                  VIEW-AS ALERT-BOX WARNING.
      END.
      ELSE DO:
          MESSAGE "There are no objects with encryption currently enabled." SKIP
                  "Do you want to review objects with policies but that have encryption disabled?"
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE opt.
          IF NOT opt THEN DO:
              RUN disable_UI.
              RETURN.
          END.

          ASSIGN  TogAll = YES
                  TogLobs = YES.
          DISPLAY TogAll TogLobs WITH FRAME ObjList.
      END.

      RUN refreshObjList.
  END.

  /* get the first row to display the details  */
  APPLY "VALUE-CHANGED" TO BrowseList.

  WAIT-FOR GO OF FRAME ObjList.
END.
RUN disable_UI.


/* **********************  Internal Procedures  *********************** */

PROCEDURE disable_UI :
  /* Hide all frames */
  HIDE FRAME ObjList.
END PROCEDURE.

PROCEDURE enable_UI :
  DISPLAY BrowseList TogTables TogIndex TogLobs BrowsePol 
      WITH FRAME ObjList.

  /* don't need cancel button */
  HIDE Btn_Cancel IN FRAME ObjList.
  ENABLE BrowseList TogTables TogIndex TogLobs TogAll BrowsePol
       Btn_OK
       &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN Btn_Help &ENDIF
      WITH FRAME ObjList.

  VIEW FRAME ObjList.

  /* default is tables with encryption on */
  OPEN QUERY BrowseList FOR EACH ttObjAttrs WHERE 
      (ttObjAttrs.obj-type = "Table" OR ttObjAttrs.obj-type = "Index")
      AND ttObjAttrs.obj-cipher NE "" NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.


PROCEDURE populateValues:         
    DEF VAR cList AS CHAR NO-UNDO.

    /* populate the dataset */
    myEPolicy:getTableList(INPUT YES, /* get current policy info */
                           OUTPUT DATASET dsObjAttrs BY-REFERENCE).
END.

PROCEDURE refreshObjList:

    DEFINE VARIABLE showTables    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE showIndexes   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE showLobs      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE showAll       AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cTypes        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cFocused      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cQueryStr     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE rRowid        AS ROWID     NO-UNDO.

    ASSIGN showTables = TogTables:SCREEN-VALUE IN FRAME ObjList = "yes"
           showIndexes = TogIndex:SCREEN-VALUE IN FRAME ObjList = "yes"
           showLobs = TogLobs:SCREEN-VALUE IN FRAME ObjList = "yes".

    IF TogAll:SCREEN-VALUE = "yes"  THEN
       showAll = YES.

    IF showTables THEN
       ASSIGN cTypes = "Table".
    IF showIndexes THEN
        ASSIGN cTypes = (IF cTypes = "" THEN "" ELSE cTypes + ",") + "Index".
    IF showLobs THEN
        ASSIGN cTypes = (IF cTypes = "" THEN "" ELSE cTypes + ",") + "CLOB,BLOB".         
    
    BrowseList:FETCH-SELECTED-ROW(1) NO-ERROR.
    /* only keep track of objects that need to be reselected after we reopen the
       query.
    */
    IF AVAILABLE ttObjAttrs THEN DO:
        IF CAN-DO(cTypes,ttObjAttrs.obj-type) THEN
            rRowid = ROWID(ttObjAttrs).
    END.

    CLOSE QUERY BrowseList.

    cQueryStr = "FOR EACH ttObjAttrs WHERE CAN-DO(" 
                + QUOTER(cTypes) + ",ttObjAttrs.obj-type) ".

    IF NOT showAll THEN
       cQueryStr = cQueryStr + 'AND obj-cipher NE "" '.
    
    cQueryStr = cQueryStr + " NO-LOCK" /*+ " INDEXED-REPOSITION" */ .

    QUERY BrowseList:QUERY-PREPARE(cQueryStr).
    QUERY BrowseList:QUERY-OPEN().

    IF rRowid NE ? THEN
       REPOSITION BrowseList TO ROWID rRowid NO-ERROR.

    APPLY "value-changed" TO BrowseList.
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
    /* On tty, we end up with a weird behavior, as if a line in the browse is
       selected, even though the focus in on something else, so this does the trick.
    */
    IF SELF:TYPE NE "Browse" THEN
       APPLY "leave" TO BrowseList.
    APPLY "entry" TO SELF.
&ENDIF

END.
