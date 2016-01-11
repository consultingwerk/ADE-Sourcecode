/*********************************************************************
* Copyright (C) 2008-2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _encrpt.p

Description:
   Encryption Policy report for both the GUI and character dictionary.
 
Input Parameters:
   p_RepId   - Id of the report
   p_LName  - Logical name of the database
   p_Tbl    - The table name or "ALL".  
   p_TblAsk - If yes, ask the user if he wants the table name specified or ALL.

Author: Fernando de Souza

Date Created: 10/27/08


----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* Standard layout defines, colors etc. */
{adecomm/adeintl.i}  /* International support */

{ prodict/misc/misc-funcs.i }
{ prodict/sec/sec-pol.i }

DEFINE INPUT PARAMETER p_RepId 	 AS INT      NO-UNDO.
DEFINE INPUT PARAMETER p_LName 	 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl 	 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p_TblAsk  AS LOGICAL  NO-UNDO.

DEFINE NEW SHARED STREAM rpt.  /* used by prtrpt.i */

DEFINE VAR ans         AS LOGICAL      	     	       NO-UNDO.
DEFINE VAR header_str  AS CHAR 	       	     	       NO-UNDO.
DEFINE VAR app         AS LOGICAL   INITIAL FALSE      NO-UNDO.
DEFINE VAR dev         AS CHAR 	       	     	       NO-UNDO
   VIEW-AS RADIO-SET
   RADIO-BUTTONS "Terminal","TERMINAL","Printer","PRINTER","File","F"
   INITIAL "TERMINAL".
DEFINE VAR fil         AS CHAR                         NO-UNDO.
DEFINE VAR siz         AS INTEGER   INITIAL 0          NO-UNDO.

DEFINE VAR which_tbl   AS CHARACTER  INITIAL "t"       NO-UNDO
      LABEL "&Report on"
      VIEW-AS RADIO-SET  
      RADIO-BUTTONS "Selected Table", "t",
      	       	    "ALL Tables",     "a".

DEFINE BUTTON btn_Ok 	 LABEL "OK"       {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel LABEL "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_Files  LABEL "&Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF .
   
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   Define button    btn_Help  label "&Help" {&STDPH_OKBTN}.
   Define rectangle rect_Btns {&STDPH_OKBOX}. /* standard button rectangle */
   &global-define   HLP_BTN  &HELP = "btn_Help"
&ELSE
   &global-define   HLP_BTN  
&ENDIF

DEFINE VAR stat AS LOGICAL NO-UNDO.
Define variable  Dlg_ShortH     as integer   NO-UNDO. /* Short Height of Dialog */

DEF VAR myEPolicyCache AS prodict.sec._sec-pol-util NO-UNDO.
DEF VAR lStopped       AS LOGICAL                   NO-UNDO.

/*-------------------------------Forms------------------------------------*/
FORM
   SKIP({&TFM_WID})
   
   dev LABEL "&Send Output to"           COLON 17  
   SKIP ({&VM_WID})

   fil NO-LABEL FORMAT "x({&PATH_WIDG})"           AT    19
       VIEW-AS FILL-IN NATIVE SIZE 30 BY 1   	   {&STDPH_FILL} SPACE(.3)
   btn_Files
   SKIP({&VM_WID})

   app LABEL "&Append to Existing File?" AT    19
       VIEW-AS TOGGLE-BOX 
   SKIP({&VM_WIDG})
   
   siz LABEL "&Page Length" FORMAT ">>9" COLON 17   {&STDPH_FILL}
   "(# Lines, 0 for Continuous)":t35                   	  
   SKIP({&VM_WIDG})

   which_tbl  COLON 17 

   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      {&HLP_BTN}
   }

   WITH FRAME options 
      SIDE-LABELS 
      DEFAULT-BUTTON btn_Ok CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX TITLE "Report Options".


/*-----------------------------Triggers------------------------------------*/

/*----- OK or GO -----*/
ON GO OF FRAME OPTIONS  
DO:
   DEFINE VARIABLE flags AS CHARACTER.
  
   IF p_TblAsk THEN
      which_tbl = which_tbl:SCREEN-VALUE.

   ASSIGN 
      dev
      fil
      app
      siz.

   fil = TRIM(fil).
   IF p_TblAsk AND which_tbl = "a" THEN
      p_Tbl = "ALL".
   
   /* Do it.  If user displays to terminal he will have the option to print
      later.  If going to printer - that's all folks.
   */   
   header_str = "Database: " + p_LName.
   IF dev = "TERMINAL" THEN
   DO:
      RUN adecomm/_report.p 
    	 (INPUT p_RepId, 
    	  INPUT header_str,
          INPUT "Detailed Encryption Policy Report",
    	  INPUT "",
    	  INPUT "",
    	  INPUT "adecomm/_encpdat.p",
    	  INPUT p_Tbl,
          INPUT {&Detailed_Encryption_Policy_Report_Dialog_Box}).
   END.
   ELSE DO:

      IF dev = "F" then DO:
        ASSIGN dev = fil.  
        IF NOT app THEN DO:
          FILE-INFO:FILE-NAME = fil.
          IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
            DEF VAR choice AS LOGICAL INITIAL NO.
            MESSAGE fil "already exists. Overwrite?" VIEW-AS ALERT-BOX QUESTION 
              BUTTONS YES-NO UPDATE choice.
            IF NOT choice THEN DO:
              APPLY "ENTRY" TO fil.
              RETURN NO-APPLY.
            END.
          END.
        END.
      END.
      {adecomm/prtrpt.i
	    &Header = header_str
        &Flags  = flags
	    &dev    = dev
	    &app    = app
	    &siz    = siz
	    &Func   = "adecomm/_encpdat.p 
      	       	      (INPUT p_RepId, INPUT p_Tbl)"}
   END.
END.

/*----- VALUE-CHANGED of DEVICE RADIO SET -----*/
ON VALUE-CHANGED OF dev IN FRAME options
DO:
   /* Default to continuous output for terminal, 60 for printer */
   dev = SELF:SCREEN-VALUE.
   IF dev = "F" /* file */ THEN DO:
      ASSIGN
	 siz:SCREEN-VALUE IN FRAME options = "0"
	 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	    fil:VISIBLE IN FRAME options = yes
	    btn_Files:VISIBLE IN FRAME options = yes
	    app:VISIBLE IN FRAME options = yes
	 &ELSE
	    fil:SENSITIVE IN FRAME options = yes
	    btn_Files:SENSITIVE IN FRAME options = yes
	    app:SENSITIVE IN FRAME options = yes
	 &ENDIF
      	 .
      APPLY "ENTRY" TO fil IN FRAME options.
   END.
   ELSE DO:
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
	 ASSIGN
	    fil:VISIBLE IN FRAME options = no
	    btn_Files:VISIBLE IN FRAME options = no
	    app:VISIBLE IN FRAME options = no.
      &ELSE
	 ASSIGN
	    fil:SENSITIVE IN FRAME options = no
	    fil:SCREEN-VALUE IN FRAME options = ""
	    btn_Files:SENSITIVE IN FRAME options = no
	    app:SENSITIVE IN FRAME options = no.
      &ENDIF
      IF dev = "TERMINAL" THEN
	 siz:SCREEN-VALUE IN FRAME options = "0".
      ELSE IF dev = "PRINTER" THEN  
	 siz:SCREEN-VALUE IN FRAME options = "60".
   END.
END.

/*----- HIT of FILE BUTTON -----*/
on choose of btn_Files in frame options
do:
   Define var name       as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.
   Define var d_title    as char    NO-UNDO init "Report File".

   name = TRIM(fil:screen-value in frame options).
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      system-dialog GET-FILE 
		    name 
		    filters            "*" "*"
		    default-extension  ""
		    title 	       d_title 
		    /*must-exist*/
		    update             picked_one.
   &ELSE
      run adecomm/_filecom.p
	  ( INPUT "" /* p_Filter */, 
	    INPUT "" /* p_Dir */ , 
	    INPUT "" /* p_Drive */ ,
	    INPUT no /* File Open */ ,
	    INPUT d_title ,
            INPUT "" /* Dialog Options */ ,
	    INPUT-OUTPUT name,
   	    OUTPUT picked_one ). 
   &ENDIF

   if picked_one then
      fil:screen-value in frame options = name.
end.

ON HELP OF FRAME options
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    OR CHOOSE OF btn_Help IN FRAME options
  &ENDIF
  RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", {&Report_Options}, ?).

/*-------------------------------Mainline code-----------------------------*/
/* Check for privileges */

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to use this option."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

/* we will try to instantiate the sec-pol-util object now so that if
   there are any errors, we will get them now and get out.
*/
DO TRANSACTION ON ERROR UNDO, LEAVE
               ON STOP  UNDO, LEAVE:

   lStopped = YES.

   /* this will acquire a schema lock for us on the DICTDB database */
   myEPolicyCache = NEW prodict.sec._sec-pol-util().

   lStopped = NO.

   CATCH ae AS PROGRESS.Lang.AppError:
       MESSAGE ae:GetMessage(1) 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       DELETE OBJECT ae.

       /* set this to zero so we get out below */
       p_RepId = 0.
   END CATCH.
   FINALLY:
      IF VALID-OBJECT(myEPolicyCache) THEN
         DELETE OBJECT myEPolicyCache NO-ERROR.
   END FINALLY. 
END.

/* if we got a stop condition (such as a canceled lock), stop it now */
IF lStopped THEN
    RETURN.

IF p_RepId = 2 THEN DO:
    ASSIGN
      which_tbl:HIDDEN IN FRAME options = (IF p_TblAsk THEN no else yes).
    
    IF which_tbl:HIDDEN THEN DO:
        /* Set the dialog size values and shorten the dialog height. */
        /*  Add a small margin {&VM_OKBOX} in pixels to short and full height to
           ensure dialog is large enough for the widgets, particularly on Windows XP. */
        assign Dlg_ShortH = FRAME options:HEIGHT-PIXELS -
                            (FRAME options:HEIGHT-PIXELS
                             - btn_Ok:Y IN FRAME options)
               Dlg_ShortH = Dlg_ShortH + {&VM_OKBOX}
               . /* END ASSIGN */

       btn_Ok:Y = which_tbl:Y.
       btn_Cancel:Y = which_tbl:Y.
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       btn_Help:Y = which_tbl:Y.
       &ENDIF
       
       ASSIGN FRAME options:HEIGHT-PIXELS = Dlg_ShortH NO-ERROR.
    END.
    /* "File" related fields start insensitive or hidden by default */
    ASSIGN
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
        fil:hidden IN FRAME options = yes
        btn_Files:hidden IN FRAME options = yes
        app:hidden IN FRAME options = yes
        fil:sensitive IN FRAME options = yes
        btn_Files:sensitive IN FRAME options = yes
        app:sensitive IN FRAME options = yes
      &ELSE
        fil:sensitive IN FRAME options = no
        btn_Files:sensitive IN FRAME options = no
        app:sensitive IN FRAME options = no
      &ENDIF
      .
    
    /* Run time layout for button area. */
    {adecomm/okrun.i  
      &FRAME  = "frame options" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      &Cancel = "btn_Cancel"
      {&HLP_BTN} }
    
    DISPLAY
      dev
      siz
      which_tbl   WHEN p_TblAsk
      WITH FRAME options.
    
    ENABLE
      dev siz which_tbl WHEN p_TblAsk
      btn_Ok btn_Cancel
      &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
        btn_Help
      &ENDIF
      WITH FRAME options.
    
    /* Reset tab-order for things that will be enabled later. */
    ASSIGN
      stat = fil:MOVE-AFTER-TAB-ITEM(dev:HANDLE IN FRAME options)
      stat = btn_Files:MOVE-AFTER-TAB-ITEM(fil:HANDLE IN FRAME options)
      stat = app:MOVE-AFTER-TAB-ITEM(btn_Files:HANDLE IN FRAME options).
    
    /* If user choose print and there's a problem with the printer, 
       Progress may generate a STOP condition - so trap that so
       we don't get kicked out of the whole application.  */
    DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON STOP UNDO, LEAVE:
      WAIT-FOR CHOOSE of btn_OK in FRAME options OR GO of FRAME options FOCUS dev.
    END.
    
    HIDE FRAME options.
END.
ELSE IF p_RepId = 1 THEN DO:
      header_str = "Database: " + p_LName.

      RUN adecomm/_report.p 
      (INPUT p_RepId, /*p_DbId,*/ 
       INPUT header_str,
       INPUT "Quick Encryption Policy Report",
       INPUT "'Current' policies",
       INPUT "",
       INPUT "adecomm/_encpdat.p",
       INPUT "ALL",
       INPUT {&Quick_Encryption_Policy_Report_Dialog_Box}).

END.

RETURN.


/* _secprpt.p -  end of file */
