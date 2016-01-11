/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: dtblrpt.p

Description:
   Detailed table report for both the GUI and character dictionary.
 
Input Parameters:
   p_DbId   - Id of the _Db record corresponding to the current database
   p_PName  - Physical name of the database
   p_DbType - Database type (e.g., PROGRESS)
   p_Order  - "a" - alpha field order
      	      "o" - order# field order
      	      ""  - Ask the user
   p_Tbl    - The table name or "ALL".  
   p_TblAsk - If yes, ask the user if he wants the table name specified or ALL.

NOTE: You can only ask one of the options questions - either ask for field 
      order or ask for table (selected/all)

Author: Tony Lavinio, Laura Stern

Date Created: 10/12/92
99/04/06    mcmann      Added stored procudure support
95/02/07    mcmann      modified to use with PROGRESS/400 data dictionary
94/07/22    gfs         removed MUST-EXIST option from Files dialog
94/01/19    hutegger    report of hidden file printable, even when there are
                        no non-hidden files in the db

----------------------------------------------------------------------------*/

{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* Standard layout defines, colors etc. */
{adecomm/adeintl.i}  /* International support */
{as4dict/as4hlp.i}   /* AS/400 Help Contextx */

DEFINE INPUT PARAMETER p_DbId 	 AS RECID    NO-UNDO.
DEFINE INPUT PARAMETER p_PName 	 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p_DbType  AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER p_Order   AS CHAR     NO-UNDO.
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

DEFINE VAR order_alpha AS CHARACTER INITIAL "o"	       NO-UNDO
      LABEL "&Order Fields"
      VIEW-AS RADIO-SET  
      RADIO-BUTTONS "By Order #",     "o",
      	       	    "Alphabetically", "a".

DEFINE VAR which_tbl   AS CHARACTER  INITIAL "t"       NO-UNDO
      LABEL "&Report on"
      VIEW-AS RADIO-SET  
      RADIO-BUTTONS "Selected Table", "t",
      	       	    "ALL Tables",     "a".

DEFINE BUTTON btn_Ok 	 LABEL "OK"       {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_Cancel LABEL "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_Files  LABEL "&Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 12 by 1 &ENDIF .
   
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   Define button    btn_Help  label "&Help" {&STDPH_OKBTN}.
   Define rectangle rect_Btns {&STDPH_OKBOX}. /* standard button rectangle */
   &global-define   HLP_BTN  &HELP = "btn_Help"
&ELSE
   &global-define   HLP_BTN  
&ENDIF

DEFINE VAR stat AS LOGICAL NO-UNDO.


/*-------------------------------Forms------------------------------------*/
FORM
   SKIP({&TFM_WID})
   
   dev LABEL "&Send Output to"           COLON 17  
   SKIP ({&VM_WID})

   fil NO-LABEL FORMAT "x(60)"           AT    19
       VIEW-AS FILL-IN NATIVE SIZE 30 BY 1   	   {&STDPH_FILL} SPACE(.3)
   btn_Files
   SKIP({&VM_WID})

   app LABEL "&Append to Existing File?" AT    19
       VIEW-AS TOGGLE-BOX 
   SKIP({&VM_WIDG})
   
   siz LABEL "&Page Length" FORMAT ">>9" COLON 17   {&STDPH_FILL}
   "(# Lines, 0 for Continuous)"                   	  
   SKIP({&VM_WIDG})

   order_alpha 	     	      	       	 COLON 17
   which_tbl   AT ROW-OF order_alpha COL 17 COLON-ALIGNED 

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

   IF p_Order = "" THEN
      order_alpha = order_alpha:SCREEN-VALUE.
   IF p_TblAsk THEN
      which_tbl = which_tbl:SCREEN-VALUE.

   ASSIGN 
      dev
      fil
      app
      siz.

   fil = TRIM(fil).
   IF p_Order = "" THEN p_Order = order_alpha.
   IF p_TblAsk AND which_tbl = "a" THEN
      p_Tbl = "ALL".
   
   /* Do it.  If user displays to terminal he will have the option to print
      later.  If going to printer - that's all folks.
   */   
   header_str = "Database: " + p_PName + " (" + p_DbType + ")".
   IF dev = "TERMINAL" THEN
   DO:
      header_str = "Database: " + p_PName + " (" + p_DbType + ")".
      RUN as4dict/_report.p 
	 (INPUT p_DbId, 
	  INPUT header_str,
      	  INPUT "Detailed Table Report",
	  INPUT "",
	  INPUT p_Order,
	  INPUT "as4dict/_dtbldat.p",
	  INPUT p_Tbl,
      	  INPUT {&AS4_Report_Options_Dialog_Box_Detailed_Table_Report}).
   END.
   ELSE DO:
      IF dev = "F" then dev = fil.      
      {as4dict/prtrpt.i
	    &Header = header_str
      	    &Flags  = flags
	    &dev    = dev
	    &app    = app
	    &siz    = siz
	    &Func   = "as4dict/_dtbldat.p 
      	       	      (INPUT p_DbId, INPUT p_Tbl, INPUT p_Order)"}
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
FIND _File "_File" NO-LOCK.
ans = CAN-DO(_Can-read,USERID("DICTDB")).
FIND _File "_Field" NO-LOCK.
ans = ans AND CAN-DO(_Can-read,USERID("DICTDB")).
FIND _File "_Index" NO-LOCK.
ans = ans AND CAN-DO(_Can-read,USERID("DICTDB")).
FIND _File "_Index-field" NO-LOCK.
ans = ans AND CAN-DO(_Can-read,USERID("DICTDB")).
IF NOT ans THEN DO:
  MESSAGE "You do not have permission to use this option."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* "ALL" selected -> print all non-hidden files, if there are non -> error */
IF  p_Tbl = "ALL" THEN DO:
  FIND LAST as4dict.p__File NO-LOCK WHERE as4dict.p__File._Db-recid = 1
     AND  as4dict.p__File._Hidden = "N" 
     AND as4dict.p__File._For-Info <> "PROCEDURE" NO-ERROR.
  IF NOT AVAILABLE as4dict.p__File THEN DO:
    MESSAGE "There are no tables in this database to look at."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.

/* Only one of the optional questions will be visible */
ASSIGN
  order_alpha:HIDDEN IN FRAME options = (IF p_Order = "" THEN no else yes)
  which_tbl:HIDDEN IN FRAME options = (IF p_TblAsk THEN no else yes).

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
  order_alpha WHEN p_Order = ""
  which_tbl   WHEN p_TblAsk
  WITH FRAME options.

ENABLE
  dev siz order_alpha WHEN p_Order = "" which_tbl WHEN p_TblAsk
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
RETURN RETURN-VALUE.

/* _dtblrpt.p -  end of file */



