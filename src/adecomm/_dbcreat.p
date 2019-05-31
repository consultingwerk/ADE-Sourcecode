/*********************************************************************
* Copyright (C) 2005,2018 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dbcreat.p

Description:   
   Put up a dialog box to get parameters for creating a new database.
   Then create the database by calling prodb.  This routine will display
   any necessary error messages to the user.

Input Parameter:
   p_olddb   - Suggested name of database to copy from.  The user can 
               change this.  This should be either "Sports", "empty", or
               some other physical db name.  Or it can be the null string.
  
Input-Output Parameter:
   p_newdb   - On input, this can be the suggested name of the new database or
               it can be the null string.  On output, if a new database was
               created successfully, this is set to the name of the new 
               database.

               It is set to ? if an error occurred or if the user pressed
               Cancel.

Author: Laura Stern

Date Created: 01/27/92

Modified on 10/6/95 by gfs - Added initial value to radio-set.
            04/12/00 DLM   - Added longer db name support
            05/26/05 KSM   - Added support for NEW-INSTANCE option of the 
                             CREATE DATABASE statement
            10/18/05 KSM   - Fixed setting of lNewInstance 20050621-024
            10/21/05 KSM   - Removed usage of SEARCH function to check 
                             DLC NE ?.  Search only works for propath
                             20050621-023.
            10/27/05 KSM   - Added Sports2000 to list of databases to create
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* standard form layout, color and font defines */

DEFINE STREAM dbStream.

Define INPUT               PARAMETER p_olddb as char.
Define INPUT-OUTPUT PARAMETER p_newdb as char NO-UNDO.

Define var sysdb as char NO-UNDO INITIAL "Empty"
   view-as radio-set
   radio-buttons "An &EMPTY Database",                 "Empty",
                 "A Copy of the &SPORTS Database",     "Sports",
                 "A Copy of the S&ports2000 Database", "sports2000",
                 "A Copy of the Spo&rts2020 Database", "sports2020",
                 "A Copy of Some &Other Database",     "Other".

Define var otherdb as char    NO-UNDO.
Define var lReplace as logical NO-UNDO INIT NO view-as TOGGLE-BOX.

DEFINE VARIABLE lNewInstance AS LOGICAL     NO-UNDO
                            INITIAL TRUE VIEW-AS TOGGLE-BOX.
DEFINE VARIABLE lChanging    AS LOGICAL     NO-UNDO.

DEFINE VARIABLE lDbInDlc     AS LOGICAL     NO-UNDO.

DEFINE VARIABLE cDlc         AS CHARACTER   NO-UNDO INITIAL ?.
DEFINE VARIABLE cDlcDbs      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDb          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSlash       AS CHARACTER   NO-UNDO.

/* Buttons */
Define button btn_Filen  label "&Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF .
Define button btn_Fileo  label "Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF .
Define button btn_Ok          label "OK"       {&STDPH_OKBTN}.
Define button btn_Cancel label "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   Define button    btn_Help  label "&Help" {&STDPH_OKBTN}.
   Define rectangle rect_Btns {&STDPH_OKBOX}. /* standard button rectangle */
   &global-define   HLP_BTN  &HELP = "btn_Help"
&ELSE
   &global-define   HLP_BTN  
&ENDIF

Define var stat        as logical NO-UNDO. 
Define var p_newdb_lbl as char format "x(35)" no-undo
  init "&New Physical Database Name:".

FORM 
   SKIP({&TFM_WID})  
   p_newdb_lbl  NO-LABEL VIEW-AS TEXT            AT 2  SKIP({&VM_WID})
   p_newdb      NO-LABEL                                at 4   
                      format "x({&PATH_WIDG})" {&STDPH_FILL}
                      view-as fill-in size 37 by 1            SPACE(.3)
   btn_Filen                                                                     SKIP({&VM_WID})
   "(.db extension can be omitted)":t34 
                      view-as TEXT                    at 4   SKIP({&VM_WIDG}) 

   "Start with:":t17 view-as TEXT                         at 2   SKIP({&VM_WID})
   sysdb               NO-LABEL                                  at 2   SKIP({&VM_WID})

   otherdb      NO-LABEL                                 at 4   
                      format "x({&PATH_WIDG})" {&STDPH_FILL}
                      view-as fill-in native size 37 by 1     SPACE(.3)
   btn_Fileo                                                                      SKIP({&VM_WIDG})  

   lReplace     LABEL "&Replace If Exists"       at 2
   lNewInstance LABEL "New &Instance"
   {adecomm/okform.i
      &BOX    = rect_btns
      {&HLP_BTN}
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
   }

   with frame dbcreate 
   SIDE-LABELS CENTERED 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Create Database" view-as DIALOG-BOX.

IF SESSION:DISPLAY-TYPE = "GUI" THEN DO:
  cSlash = "~\".
  GET-KEY-VALUE SECTION "Startup" KEY "DLC" VALUE cDlc.
  cDlc = RIGHT-TRIM(cDlc,cSlash).
END.
ELSE cSlash = "/".

IF cDlc EQ ? THEN
  ASSIGN cDlc = OS-GETENV("DLC")
         cDlc = RIGHT-TRIM(cDlc,cSlash).

IF cDlc NE ? THEN DO:
  INPUT STREAM dbStream FROM OS-DIR(cDlc) NO-ATTR-LIST.
  db-blk:
  REPEAT ON ERROR UNDO db-blk, LEAVE db-blk:
    IMPORT STREAM dbStream cDb.
    IF NUM-ENTRIES(cDb,".") > 1 AND
       ENTRY(NUM-ENTRIES(cDb,"."),cDb,".") = "db" THEN
      cDlcDbs = cDlcDbs + (IF cDlcDbs NE "" THEN "," ELSE "") +
                SUBSTRING(cDb,1,R-INDEX(cDb,".") - 1).
  END.
  INPUT STREAM dbStream CLOSE.
END. /* DLC Not ? */

/* Associate text widget with fill-in label to enable mnemonic (Nordhougen 07/26/95) */
ASSIGN
  p_newdb:SIDE-LABEL-HANDLE IN FRAME dbcreate = p_newdb_lbl:HANDLE
  p_newdb:LABEL IN FRAME dbcreate = p_newdb_lbl.

/*============================ Internal Procedures =================================*/

Procedure Get_Db_Name:
   Define INPUT PARAMETER h_name  as widget-handle NO-UNDO.
   Define INPUT PARAMETER p_exist as logical       NO-UNDO. /* must exist */

   Define var name       as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.
   Define var d_title    as char    NO-UNDO init "Find Database File".

   name = TRIM(h_name:screen-value).
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      if p_exist then
               system-dialog GET-FILE 
            name 
            filters            "*.db" "*.db"
            default-extension  ".db"
            title                d_title 
            must-exist
            update             picked_one.
      else
               system-dialog GET-FILE 
            name 
            filters            "*.db" "*.db"
            default-extension  ".db"
            title                d_title 
            update             picked_one.
   &ELSE
      run adecomm/_filecom.p
          ( INPUT "*.db",  /* p_Filter */
            INPUT "",            /* p_Dir */
            INPUT "",            /* p_Drive */
            INPUT no,           /* File Open */
            INPUT d_title,
            INPUT (if p_exist then "MUST-EXIST" else ""), /* Dialog Options */
            INPUT-OUTPUT name,
               OUTPUT picked_one). 
   &ENDIF

   if picked_one then
      h_name:screen-value = name.
end.

FUNCTION dlcDb RETURNS LOGICAL
        ( INPUT pcDbName AS CHARACTER ):

  DEFINE VARIABLE cDb AS CHARACTER NO-UNDO.

  DEBUGGER:SET-BREAK().
  cDb = pcDbName.
  IF NUM-ENTRIES(cDb,".") > 1 THEN
    cDb = SUBSTRING(cDb,1,R-INDEX(cDb,".") - 1).

  RETURN (cDb BEGINS cDlc OR
          CAN-DO(cDlcDbs,cDb)).

END FUNCTION.

/*============================== Triggers ====================================*/

/*-----------HIT of OK BUTTON---------*/
on choose of btn_OK in frame dbcreate OR GO of frame dbcreate
do:
   Define var err as integer NO-UNDO.

   assign
     input frame dbcreate p_newdb
     input frame dbcreate sysdb
     input frame dbcreate lReplace.
   
   p_newdb = TRIM(p_newdb).
   p_newdb:screen-value in frame dbcreate = p_newdb.

   if sysdb = "Other" then
      assign p_olddb = TRIM(input frame dbcreate otherdb).
   else
      assign p_olddb = sysdb.

   if p_olddb = "" or p_newdb = "" then 
   do:
      message "You must specify a database name for both" SKIP
                     "the source and the destination databases."
               view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_newdb in frame dbcreate.
      return NO-APPLY.
   end.

   run adecomm/_setcurs.p ("WAIT").
   IF lReplace THEN DO:
     IF lNewInstance THEN
       CREATE DATABASE p_newdb FROM p_olddb NEW-INSTANCE REPLACE NO-ERROR.
     ELSE CREATE DATABASE p_newdb FROM p_olddb REPLACE NO-ERROR.
   END.
   ELSE DO:
     IF lNewInstance THEN
       CREATE DATABASE p_newdb FROM p_olddb NEW-INSTANCE NO-ERROR.
     ELSE CREATE DATABASE p_newdb FROM p_olddb NO-ERROR.
   END.

   run adecomm/_setcurs.p ("").

   if error-status:get-message(1) = "" then
      return.

   message error-status:get-message(1) view-as alert-box error buttons ok.
   p_newdb = ?.  /* flag that error occured. */
   return NO-APPLY.  /* let user cancel out after seeing error */
end.


/*-----HIT of CANCEL, ENDKEY-----*/
on ENDKEY,END-ERROR of frame dbcreate  /* or cancel which is auto-endkey */
   p_newdb = ?.

/*----- WINDOW-CLOSE-----*/
on WINDOW-CLOSE of frame dbcreate
do:
   p_newdb = ?.
   apply "END-ERROR" to frame dbcreate.
end.

/*-----SELECTION of a sysdb RADIO-ITEM-----*/
on value-changed of sysdb in frame dbcreate
do:
/*    DEBUGGER:INITIATE().  */
/*    DEBUGGER:SET-BREAK(). */
   lDbInDlc = dlcDb(otherdb:SCREEN-VALUE IN FRAME dbcreate).

   /* Either hide or enable the "other" fill-in field based on the
      radio button selection. */
   if sysdb:screen-value in frame dbcreate = "Other" then
   do:
     ASSIGN &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
              otherdb:VISIBLE IN FRAME dbcreate        = TRUE
              btn_Fileo:VISIBLE IN FRAME dbcreate      = TRUE
            &ELSE
              otherdb:SENSITIVE IN FRAME dbcreate      = TRUE
              btn_Fileo:SENSITIVE IN FRAME dbcreate    = TRUE
            &ENDIF
            lNewInstance:SENSITIVE IN FRAME dbcreate = (NOT lDbInDlc = TRUE)
            lNewInstance:CHECKED IN FRAME dbcreate   = (lDbInDlc = TRUE)
            lNewInstance                             = (lDbInDlc = TRUE).
      IF NOT (lChanging = TRUE) THEN 
       apply "entry" to otherdb in frame dbcreate. 
     lChanging = FALSE.
   end.
   else
     ASSIGN otherdb:screen-value in frame dbcreate = ""
            &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
              otherdb:VISIBLE IN FRAME dbcreate        = FALSE
              btn_Fileo:VISIBLE IN FRAME dbcreate      = FALSE
            &ELSE
              otherdb:SENSITIVE IN FRAME dbcreate      = FALSE
              btn_Fileo:SENSITIVE IN FRAME dbcreate    = FALSE
            &ENDIF
            lNewInstance:SENSITIVE IN FRAME dbcreate = FALSE
            lNewInstance:CHECKED IN FRAME dbcreate   = TRUE
            lNewInstance                             = TRUE.
end.


/*----- HIT of New FILE BUTTON -----*/
on choose of btn_Filen in frame dbcreate
   run Get_Db_Name (INPUT p_newdb:HANDLE in frame dbcreate, INPUT no).
   

/*----- HIT of Other FILE BUTTON -----*/
ON CHOOSE OF btn_Fileo IN FRAME dbcreate DO:
  RUN Get_Db_Name 
        ( INPUT otherdb:HANDLE IN FRAME dbcreate, 
          INPUT TRUE ).
  APPLY "VALUE-CHANGED" TO sysdb IN FRAME dbcreate.
END.

ON LEAVE OF otherdb IN FRAME dbcreate DO:
  APPLY "VALUE-CHANGED" TO sysdb IN FRAME dbcreate.
  APPLY "ENTRY" TO Btn_Fileo IN FRAME dbcreate.
END.

ON VALUE-CHANGED OF otherdb IN FRAME dbcreate DO:
  lChanging = TRUE.

  APPLY "VALUE-CHANGED" TO sysdb IN FRAME dbcreate.
END.

/*----- HELP -----*/
on HELP of frame dbcreate
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      OR choose of btn_Help in frame dbcreate
   &ENDIF
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
                                               INPUT {&Create_Database},
                                               INPUT ?).


/*============================= Mainline code ==============================*/

/* "Other" database name fill-in starts insensitive by default */
assign
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      otherdb:hidden in frame dbcreate = yes
      btn_Fileo:hidden in frame dbcreate = yes
      otherdb:sensitive in frame dbcreate = yes
      btn_Fileo:sensitive in frame dbcreate = yes.
   &ELSE
      otherdb:sensitive in frame dbcreate = no
      btn_Fileo:sensitive in frame dbcreate = no.
   &ENDIF

/* Set defaults based on input parms */
if p_olddb = "empty" or p_olddb = "" or p_olddb = ? then
   sysdb:screen-value in frame dbcreate = "empty".
else if p_olddb = "sports" then
   sysdb:screen-value in frame dbcreate = "sports".
else
do:
   assign
      otherdb:screen-value in frame dbcreate = p_olddb
      sysdb:screen-value in frame dbcreate = "other"
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
               otherdb:hidden in frame dbcreate = no
               btn_Fileo:hidden in frame dbcreate = no.
      &ELSE
               otherdb:sensitive in frame dbcreate = yes
               btn_Fileo:sensitive in frame dbcreate = yes.
      &ENDIF
end.

assign
   p_newdb:screen-value in frame dbcreate = p_newdb
   lReplace:screen-value in frame dbcreate = "no".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME  = "frame dbcreate" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   &CANCEL = "btn_Cancel"
   {&HLP_BTN}
}

/* Since the "otherdb" field isn't enabled to start, in order to get
   the tab order right, we can't use update.  Instead enable and reset
   tab position for "otherdb" and btn_Fileo.  Other widgets will be pushed
   down in the tab chain.
*/  

enable p_newdb 
       btn_Filen
       sysdb 
       lReplace
       lNewInstance
       btn_Ok
       btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
                btn_Help
       &ENDIF
       with frame dbcreate.

APPLY "VALUE-CHANGED" TO sysdb IN FRAME dbcreate.
assign
   stat = otherdb:move-after-tab-item(sysdb:HANDLE) in frame dbcreate
   stat = btn_Fileo:move-after-tab-item(otherdb:HANDLE) in frame dbcreate.

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   Wait-for choose of btn_OK in frame dbcreate OR
                  GO of frame dbcreate
                  FOCUS p_newdb.
end.

hide frame dbcreate.
return.

