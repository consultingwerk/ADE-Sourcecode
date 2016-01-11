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

/*

File:   prodict/user/_usrload 

Describtion:
    user interface and defaults setup for loading

Input:
  user_env[1] = "ALL" or comma-separated list of files
  user_env[4] = if user_env[9] = "h"
                    then "error" or ""  to signal the needed message
                    else insignificant
  user_env[9] = type of load (e.g. .df or .d)
                "d" = load file definitions
                "f" = load data file contents
                "h" = hide message, puts up completed message and returns
                "k" = load sequence values
                "u" = load user file contents
                "v" = load view file contents
                "4" = AS/400 definitions
                "4t" = AS/400 trigger definitions
                "s" = load sequence def's

Output:
  user_env[1] = same as IN
  user_env[2] = physical file or directry name for some input
  user_env[4] = "y" or "n" - stop on first error (if class = "d","4" or "s")
              = error% (if class = "f")
  user_env[5] = comma separated list of "y" (yes) or "n" (no) which
                corresponds to file list in user_env[1], indicating for each,
                whether triggers should be disabled when the load is done.
                (only used for load data file contents, "f").
  user_env[8] = dbname (if class = "d" or "4" or "s")
  user_env[10]= user specified code page
  user_env[15]= user wants to commit even if errors are found.

History:
    D. McMann   01/03/13 Added option to commit even if error present.
    D. McMann   00/06/08 Added check for non table records on load of data
    D. McMann   00/04/12 Added support for long path names
    D. McMann   98/07/09 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                         to _File FINDS
    D. McMann   98/06/25 Added check for trailer to begine either cpstream or codepage for
                         backwards compatibility with new .df trailer.
    laurief     98/06/09 Added code to utilize user_env[6] as a flag to turn
                         errors to screen on/off.
    tomn        96/04   Moved instances of okrun.i outside of DO blocks at
                        end of Main section (update statements); Undoing of
                        block would cause frame width to increase each time
                        
    tomn        96/04   Removed extraneous ENDKEY/END-ERROR traps (using
                        LAST-EVENT:FUNCTION statement) after UPDATE statements
                        at end of Main section (already handled by enclosing
                        DO block)

    hutegger    95/05   changed "h" behaviour to message "Load aborted"
                        in case an error occured

*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE class    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comma    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
DEFINE VARIABLE io-file    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE io-frame   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-title   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE is-all     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-one     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-some    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE stop_flg   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE commit_flg AS LOGICAL    NO-UNDO.
DEFINE VARIABLE msg-num  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE noload   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE prefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trash    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dis_trig AS CHARACTER  NO-UNDO.
DEFINE VARIABLE codepage AS CHARACTER  NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar     AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#    AS INT            NO-UNDO.  
DEFINE VARIABLE cr       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE do-screen AS LOGICAL NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-file AS LOGICAL NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-screen AS LOGICAL NO-UNDO INIT TRUE.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE VARIABLE warntxt  AS CHARACTER  NO-UNDO VIEW-AS EDITOR NO-BOX 
 INNER-CHARS 64 INNER-LINES 5.
&ENDIF
/* To support fill-in label mnemonic (Nordhougen 07/26/95) */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
DEFINE VARIABLE idir_lbl AS CHARACTER  NO-UNDO FORMAT "X(55)"
  INIT "&Input Directory (if different from current directory):". 
&ENDIF

{prodict/misc/filesbtn.i}

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "&Input File"
  btn_File SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-input
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
  &GLOBAL-DEFINE LINEUP 12
  &GLOBAL-DEFINE FILLCH 67
&ELSEIF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
  &GLOBAL-DEFINE LINEUP 12
  &GLOBAL-DEFINE FILLCH 69
&ELSE
  &GLOBAL-DEFINE LINEUP 15
&ENDIF

/* form for .df file input */
/* Note that spaces were added to some of the string literals so that
   the strings would not be cut off under Korean Windows 95 */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "&Input File" COLON {&LINEUP}
  btn_File  SKIP ({&VM_WIDG})
    stop_flg VIEW-AS TOGGLE-BOX LABEL "Stop If Error Found in Definition"
        COLON {&LINEUP} SKIP({&VM_WIDG})    
    err-to-file VIEW-AS TOGGLE-BOX LABEL "Output Errors to File"
        COLON {&LINEUP} SKIP({&VM_WIDG})
    err-to-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to Screen"
        COLON {&LINEUP} SKIP({&VM_WIDG})
    commit_flg VIEW-AS TOGGLE-BOX LABEL "Commit Even If Errors Found in Definition"
        COLON {&LINEUP} SKIP({&VM_WIDG})
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  warntxt AT 2 NO-LABEL SKIP ({&VM_WIDG})
  &ELSE
    "Warning: If a .df file was generated by an incremental dump it"
      AT 2 VIEW-AS TEXT SKIP
    "may contain DROP statements which will cause data to be deleted."
      AT 2 VIEW-AS TEXT SKIP(1)
   "If you select to commit even with errors, your database could be " 
      AT 2 VIEW-AS TEXT SKIP 
   "corrupted." AT 2 VIEW-AS TEXT SKIP
  &ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME read-df
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

cr = CHR(10).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ASSIGN warntxt:SCREEN-VALUE =
"Warning: If a .df file was generated by an incremental dump it" + cr +
"may contain DROP statements which will cause data to be deleted." + cr + cr +
"If you select to commit even with errors, your database could" + cr +
"be corrupted.". 
warntxt:READ-ONLY = yes.   
&ENDIF

/* form for .d file input */
&GLOBAL-DEFINE DFILE-SPEECH   "Specify an acceptable error percentage.  When this limit is reached,      " AT 2 VIEW-AS TEXT SKIP  "loading will stop.  Enter 0 if any error should stop the load; enter      " AT 2 VIEW-AS TEXT SKIP  "100 if the load should not stop for any error.          "                                       AT 2     VIEW-AS TEXT SKIP ({&VM_WIDG})

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL "&Input File"
  btn_File  SKIP ({&VM_WIDG})
  {&DFILE-SPEECH}
  i {&STDPH_FILL} FORMAT ">>9" LABEL "&Acceptable Error Percentage" AT 2                    
     VALIDATE(i >= 0 AND i <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL " Display Errors to &Screen"
      AT 2 SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-file
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".


FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    idir_lbl NO-LABEL VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
          SIZE {&FILLCH} BY 1 NO-LABEL SKIP({&VM_WIDG})
  &ELSE
     user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 50 BY 1
                LABEL "Input Directory" SKIP
    "(Leave blank for current directory)" VIEW-AS TEXT AT 19 SKIP ({&VM_WIDG})
  &ENDIF
  {&DFILE-SPEECH}
  i {&STDPH_FILL} FORMAT ">>9" AT 2 LABEL "&Acceptable Error Percentage"                     
     VALIDATE(i >= 0 AND i <= 100,
     "Percentage must be between 0 and 100 inclusive.") SKIP({&VM_WIDG})
  do-screen VIEW-AS TOGGLE-BOX LABEL "Output Errors to &Screen"
      AT 2 SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-d-dir
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ". 
  
/* For MSW, associate text widget with fill-in to enable mnemonic (Nordhougen 07/26/95) */
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ASSIGN
  user_env[2]:SIDE-LABEL-HANDLE IN FRAME read-d-dir = idir_lbl:HANDLE
  user_env[2]:LABEL IN FRAME read-d-dir = idir_lbl.
&ENDIF

FORM
  "Please enter a Code Page to use for this load." AT 2 SKIP
  codepage {&STDPH_FILL} LABEL "&Code Page" AT 2
  {prodict/user/userbtns.i}
  WITH FRAME get-cp SIDE-LABELS NO-ATTR-SPACE CENTERED
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Code Page ".

/*=============================Triggers===============================*/

DEFINE VAR msg AS CHAR NO-UNDO INITIAL
   "Can not find a file of this name.  Try again.".

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame read-input or CHOOSE of btn_Help in frame read-input
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Stuff_Dlg_Box},
                             INPUT ?).

on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

on HELP of frame read-d-file
   or CHOOSE of btn_Help in frame read-d-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ?).
on HELP of frame read-d-dir
   or CHOOSE of btn_Help in frame read-d-dir
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Some_Dlg_Box},
                             INPUT ?).
                             
on HELP of frame get-cp or CHOOSE of btn_Help in frame get-cp
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT",
                             INPUT {&Code_Page_Dlg_Box},
                              INPUT ?).

&ENDIF

/*----- ON GO or OK -----*/
ON GO OF FRAME read-df
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-df.
    RETURN NO-APPLY.
  END.
  IF io-file THEN 
    user_env[2]:SCREEN-VALUE = SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df).
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-df.
  run verify-cp.
END.

ON GO OF FRAME read-d-file
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-file) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-file.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-d-file.
  run verify-cp.
END.

ON GO OF FRAME read-d-dir
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-dir) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-dir.
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME read-input
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-input) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-input.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-input.
  run verify-cp.
END.
/*----- ON WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame read-input
   apply "END-ERROR" to frame read-input.
on WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.
on WINDOW-CLOSE of frame read-d-file
   apply "END-ERROR" to frame read-d-file.
on WINDOW-CLOSE of frame read-d-dir
   apply "END-ERROR" to frame read-d-dir.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame read-input
   user_env[2]:screen-value in frame read-input = 
        TRIM(user_env[2]:screen-value in frame read-input).
ON LEAVE OF user_env[2] in frame read-df
   user_env[2]:screen-value in frame read-df = 
        TRIM(user_env[2]:screen-value in frame read-df).
ON LEAVE OF user_env[2] in frame read-d-file
   user_env[2]:screen-value in frame read-d-file = 
        TRIM(user_env[2]:screen-value in frame read-d-file).
ON LEAVE OF user_env[2] in frame read-d-dir
   user_env[2]:screen-value in frame read-d-dir = 
        TRIM(user_env[2]:screen-value in frame read-d-dir).

/*-----On value change of flags --*/
ON VALUE-CHANGED OF stop_flg IN FRAME read-df DO:
  IF SELF:screen-value = "yes" THEN DISABLE commit_flg WITH FRAME read-df.
  ELSE ENABLE commit_flg WITH FRAME read-df.
  RETURN.
END.
ON VALUE-CHANGED OF commit_flg IN FRAME read-df DO:
  IF SELF:screen-value = "yes" THEN DISABLE stop_flg WITH FRAME read-df.
  ELSE ENABLE stop_flg WITH FRAME read-df.
  RETURN.
END.

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame read-input DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-input /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-file /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.

 
/*=======================Internal Procedures==========================*/

PROCEDURE verify-cp.
  /* Is there a defined codepage? Try to read it in the trailer, if
   * not, ask for it
   */
  ASSIGN codepage = "".
  RUN read-cp. /* read the code page in the file */
  IF codepage = "" OR codepage = ? OR codepage = "(no conversion)" THEN
  DO:
     MESSAGE "There is no Code Page defined in this input file." view-as
        ALERT-BOX ERROR BUTTONS OK.
     RUN get-cp. /* prompt for it */
  END.
  ELSE user_env[10] = codepage.
END PROCEDURE.

PROCEDURE read-cp.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  DEFINE VARIABLE i     AS INT            NO-UNDO.

  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  SEEK INPUT TO SEEK(INPUT) - 11. /* position to beginning of last line */

  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.

  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
    i = (IF LASTKEY > 47 AND LASTKEY < 58 
          THEN i * 10 + LASTKEY - 48
          ELSE ?).
    READKEY PAUSE 0.
  END.

  IF i > 0 then run get_psc. /* get it */
  ELSE RUN find_psc. /* look for it */
  INPUT CLOSE.
  DO i = 1 TO lvar#:
    IF lvar[i] BEGINS "cpstream=" OR lvar[i] BEGINS "codepage" THEN
       codepage = TRIM(SUBSTRING(lvar[i],10,-1,"character":U)).
  END.
END PROCEDURE.

PROCEDURE get-cp.
   /* Prompt for codepage */
   DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME get-cp:
       ASSIGN codepage = SESSION:STREAM.
       UPDATE codepage btn_OK btn_Cancel {&HLP_BTN_NAME}.
       ASSIGN user_env[10] = codepage.
   END.
END PROCEDURE.

PROCEDURE get_psc:
  /* using the byte count, we scoot right down there and look for
   * the beginning of the trailer ("PSC"). If we don't find it, we
   * will go and look for it.
   */
   
  DEFINE VARIABLE rc AS LOGICAL INITIAL no.
  _psc:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SEEK INPUT TO i. /* skip to beginning of "PSC" in file */
    READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc. /* not there!*/
    READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
    READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
    ASSIGN rc = yes. /* found it! */
    RUN read_bits (INPUT i). /* read trailer bits */
  END.
  IF NOT rc THEN RUN find_psc. /* look for it */
END PROCEDURE.

PROCEDURE find_psc:
  /* If the bytecount at the end of the file is wrong, we will jump
   * back the maximum number of bytes in a trailer and start looking
   * from there. If we still don't find it then tough luck.
   * NOTE: Variable p holds the number of bytes to roll back. AS of
   * 7/21/94, the max size of a trailer (.d) is 204 bytes, if you add
   * anything to this trailer, you must change this number to reflect
   * the number of bytes you added. I'll use 256 to add a little padding. (gfs)
   */
  DEFINE VARIABLE p AS INTEGER INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INTEGER.             /* last char position */
  
  SEEK INPUT TO END.
  ASSIGN l = SEEK(INPUT). /* EOF */
  SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,l). /* take p, or size of file */
  IF SEEK(INPUT) = ? THEN RETURN.
  _scan:
  REPEAT ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    READKEY PAUSE 0.
    p = SEEK(INPUT). /* save off where we are looking */
    IF LASTKEY = ASC("P") THEN DO:
       READKEY PAUSE 0.
       IF LASTKEY <> ASC("S") THEN NEXT.
       ELSE DO: /* found "PS" */
         READKEY PAUSE 0.
         IF LASTKEY <> ASC("C") THEN NEXT.
         ELSE DO: /* found "PSC"! */
           RUN read_bits (INPUT p - 1).
           LEAVE.
         END. /* IF "C" */
       END. /* IF "S" */    
    END. /* IF "P" */
    ELSE IF p >= l THEN LEAVE _scan. /* at EOF, so give up */
  END. /* repeat */
END.

PROCEDURE read_bits:
  /* reads trailer given a starting position 
   */ 
  DEFINE INPUT PARAMETER i as INTEGER. /* "SEEK TO" location */
    
  SEEK INPUT TO i.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    lvar# = lvar# + 1.
  END.
END PROCEDURE. 

/*==========================Mainline code=============================*/
{adecomm/okrun.i
  &FRAME = "FRAME get-cp"
  &BOX   = "rect_Btns"
  &OK    = "btn_OK"
  {&CAN_BTN}
  {&HLP_BTN}
  }

ASSIGN
  class    = SUBSTRING(user_env[9],1,-1,"character")
  io-file  = TRUE
  io-frame = ""
  is-all   = (user_env[1] = "ALL")
  is-some  = (user_env[1] MATCHES "*,*")
  is-one   = NOT is-all AND NOT is-some
  prefix   = "".
           /*(IF OPSYS = "UNIX" THEN "./"
             ELSE IF CAN-DO("MSDOS,OS2",OPSYS) THEN ".~\"
             ELSE "")*/

IF dict_rog THEN msg-num = 3. /* look but don't touch */

/*Fernando: 20020129-017 Capture what is the last message the client issued when starting 
 the load process. 
 user_msg_count holds the next to the last posiiton on the message queue*/
IF class <> "h" AND user_msg_count = 0 THEN DO:
  ASSIGN user_msg_count = 1.
  REPEAT:
    /* user_msg_count is always pointing to the next possible message */
    IF _msg(user_msg_count) > 0 THEN
        ASSIGN user_msg_count = user_msg_count + 1.
    ELSE
        LEAVE.
  END.
END.
ELSE  IF class = "h":U THEN DO:
     /*if there was a message from the client after the load process started, 
     search for error number 151  (ERROR_ROLLBACK) and write to the error log file.
     The error would be the first entry in message queue.
     If _msg(user_msg_count) is 0, it means that no new messages were issued
     since the load started */
     IF  _msg(user_msg_count) > 0 AND _msg(1) = {&ERROR_ROLLBACK} THEN
     DO:
         ASSIGN user_env[4] = "error".
         
         IF (user_env[6] = "f" OR user_env[6] = "b") THEN
         DO:
         
             OUTPUT TO VALUE (LDBNAME("DICTDB") + ".e") APPEND.
             PUT UNFORMATTED TODAY " " STRING(TIME,"HH:MM") " : "
                "Load of " user_env[2] " into database " 
                LDBNAME("DICTDB") " was unsuccessful." SKIP " All the changes were backed out..." 
                SKIP " Progress error numbers (" _msg(1) ") " .
                IF _msg(2) > 0 THEN 
                     PUT UNFORMATTED "and (" _msg(2) ")." SKIP(1).
                 ELSE PUT UNFORMATTED "."  SKIP(1) . 
             OUTPUT CLOSE.
         END.
     END.
END. /*ELSE IF CLASS = "h" */

/*-------------------------------------------------*/ /* Hide message */
IF class = "h" THEN DO:
  /* Fernando: gives the user time to see the error message that the 
     client issued instead of flashing the messages */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
     HIDE MESSAGE NO-PAUSE.
  &ENDIF
  
   /* Fernando: 20020129-017 Also, if there was an error that backed out the changes, 
   do not display the message */
   if user_env[4] <> "error" THEN
      MESSAGE "Load completed." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   ELSE
      MESSAGE "Load aborted." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     
   /* Fernando: 20020129-017 make sure variable is set to sero */
   ASSIGN user_msg_count = 0.
   RETURN.
END.
/*----------------------------------------*/ /* LOAD FILE DEFINITIONS */
IF class = "d" OR class begins "4" or class = "s" THEN DO:
  IF msg-num = 0 THEN DO FOR DICTDB._File i = 1 TO 4:
    FIND DICTDB._File
      WHERE DICTDB._File._File-name = ENTRY(i,"_Db,_File,_Field,_Index")
        AND DICTDB._File._Owner = "PUB".
    IF   NOT CAN-DO(_Can-read,  USERID("DICTDB"))
      OR NOT CAN-DO(_Can-write, USERID("DICTDB"))
      OR NOT CAN-DO(_Can-delete,USERID("DICTDB"))
      OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.
  END.
  ASSIGN
    base        = PDBNAME(user_dbname)
    user_env[2] = (IF class = "s" THEN "_seqdefs.df"
                  ELSE IF class = "4t" THEN "_trgdefs.df"
                  ELSE
                  ((IF base = "" OR base = ? THEN user_dbname ELSE base) 
                                                                 + ".df"))
    io-frame    = "df"
    io-title    = (IF class = "s" THEN "Load Sequence Definitions"
                   ELSE IF class = "4" THEN "Load AS/400 Definitions File"
                   ELSE IF class = "4t" THEN "Load Database Triggers"
                   ELSE "Load Data Definitions")
    user_env[4] = "n"          /* stop on first error - used by _lodsddl.p */
    user_env[8] = user_dbname  /* dbname to load into - used by _lodsddl.p */
    class = "d". /* if class was 's', reassign to run as class 'd' after 
                    input file name default (user_env[2]) */
END.

/*--------------------------------------*/ /* LOAD DATA FILE CONTENTS */
ELSE IF class = "f" THEN DO FOR DICTDB._File:

  /* read-only status is relevant only for PROGRESS-db's */
  /* schemaholders can be in read-only mode and still    */
  /* allow data to be loaded!                            */
  IF dict_rog 
    AND msg-num = 3
    AND user_dbtype <> "PROGRESS"
    THEN ASSIGN msg-num = 0. 

  noload = "u".
  { prodict/dictgate.i &action=undumpload
    &dbtype=user_dbtype &dbrec=drec_db &output=noload
  }

  FIND DICTDB._File  WHERE DICTDB._FIle._File-name = "_File"
                       AND DICTDB._File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 4.
  RELEASE DICTDB._File.
  IF NOT is-all AND NOT is-some THEN
    FIND DICTDB._File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
                        AND (_Owner = "PUB" OR _Owner = "_FOREIGN").
  ASSIGN
    user_env[2] = prefix + (IF is-all OR is-some THEN "" ELSE
                  (IF DICTDB._File._Dump-name = ?
                  THEN DICTDB._File._File-name ELSE DICTDB._File._Dump-name)
                + ".d")
    user_env[4] = "0"
    io-file     = NOT is-all AND NOT is-some /* read from file/dir */
    io-frame    = "d"
    io-title    = "Load Data Contents for"
                + " " + (IF is-all THEN "All Tables" /*allfiles*/
                  ELSE  IF is-some THEN "Some Tables" /*somefiles*/
                  ELSE "Table ~"" + user_env[1] + "~"")
    base        = (IF is-one OR is-some THEN user_env[1] ELSE "")
    user_env[1] = ""
    comma       = ""
    i           = 1.

  /* If user had selected ALL, fill base array with list of files.  
     Otherwise, it is already set to file list.
  */
  IF is-all THEN FOR EACH DICTDB._File
    WHERE DICTDB._File._File-number > 0
      AND DICTDB._File._Db-recid = drec_db
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      AND NOT DICTDB._File._Hidden
      AND DICTDB._File._Tbl-Type <> "V"
      AND CAN-DO(DICTDB._File._Can-create,USERID(user_dbname))
      AND (noload = "" OR NOT CAN-DO(noload,DICTDB._File._For-type))
    BY DICTDB._File._File-name:
    IF DICTDB._File._Owner = "_FOREIGN" AND DICTDB._File._For-Type <> "TABLE" THEN
        NEXT.
    base = base + (IF base = "" THEN "" ELSE ",") + DICTDB._File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  user_env[5] = "".
  DO i = 1 TO NUM-ENTRIES(base):
    err = ?.
    dis_trig = "y".
    FIND DICTDB._File
      WHERE _Db-recid = drec_db AND _File-name = ENTRY(i,base)
        AND (_Owner = "PUB" OR _Owner = "_FOREIGN").   
    IF DICTDB._File._Owner = "_FOREIGN" AND DICTDB._File._For-type <> "TABLE" THEN DO:
      MESSAGE 'The file "' DICTDB._File._File-name  '" does not have a foreign' SKIP
              'type of "TABLE". It is therefore being skipped' SKIP
              VIEW-AS ALERT-BOX WARNING.
      NEXT.
    END.
    IF NOT CAN-DO(DICTDB._File._Can-create,USERID(user_dbname)) THEN
      err = DICTDB._File._File-name
        + " will not be loaded due to insufficient privileges.".
    ELSE
    IF noload <> "" AND CAN-DO(noload,DICTDB._File._For-type) THEN
      err = "".
        /*SUBSTITUTE("&1 is a &2 &3 and cannot be dumped.",
          DICTDB._File._File-name,user_dbtype,DICTDB._File._For-type).*/
    ELSE DO:
      {prodict/dump/ltrigchk.i &OK = answer}
      IF NOT answer THEN DO:
         MESSAGE "You do not have privileges to load table" DICTDB._File._File-name 
                 SKIP
                 "with triggers disabled.  Do you want to load this table" SKIP
                 "anyway even though the triggers will fire?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.
         IF answer = no THEN
            err = "".  /* don't do this table but no more messages */
         ELSE IF answer = yes THEN DO:
            err = ?.   /* include this table in load */
            dis_trig = "n".
         END.
         ELSE DO:    /* cancel the load operation */
            user_path = "".
            RETURN.
         END.
      END.
    END.

    IF err = ? THEN
      ASSIGN
        user_env[1] = user_env[1] + comma + DICTDB._File._File-name
        user_env[5] = user_env[5] + comma + dis_trig
        comma       = ",".
    ELSE IF err <> "" THEN DO:
      MESSAGE err SKIP "Do you want to continue?"
         VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
      IF answer = FALSE THEN DO:
        user_path = "".
        RETURN.
      END.
    END.

  END.

  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND NUM-ENTRIES(user_env[1]) = 1 THEN DO:
    FIND DICTDB._File
      WHERE DICTDB._File._Db-recid = drec_db
        AND DICTDB._File._File-name = user_env[1]
        AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").
    ASSIGN
      is-some     = FALSE
      is-all      = FALSE
      is-one      = TRUE
      user_env[2] = prefix + (IF DICTDB._File._Dump-name = ?
                    THEN DICTDB._File._File-name ELSE DICTDB._File._Dump-name)
                  + ".d"
      io-file     = TRUE
      io-title    = "Load Data Contents for Table ~"" + user_env[1] + "~""
      base        = user_env[1].
  END.

END.

/*-----------------------------------------------*/ /* LOAD SEQ VALS */
ELSE IF class = "k" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_Sequence".
  IF NOT CAN-DO(_Can-write,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_seqvals.d"
    io-title    = "Load Sequence Current Values".
END.

/*--------------------------------------*/ /* LOAD USER FILE CONTENTS */
ELSE IF class = "u" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_User".
  IF NOT CAN-DO(_Can-write, USERID("DICTDB"))
    OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_user.d"
    io-title    = "Load User Table Contents".
END.

/*--------------------------------------*/ /* LOAD VIEW FILE CONTENTS */
ELSE IF class = "v" THEN DO FOR DICTDB._File:
  FIND DICTDB._File "_View".
  IF NOT CAN-DO(_Can-write, USERID("DICTDB"))
    OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 4.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 2.
  ASSIGN
    user_env[2] = prefix + "_view.d"
    io-title    = "Load SQL Views".
END.

IF msg-num > 0 THEN DO:
  MESSAGE (
    IF msg-num = 1 THEN
      "Cannot load User information for non-PROGRESS database."
    ELSE IF msg-num = 2 THEN
      "Cannot load View information for non-PROGRESS database."
    ELSE IF msg-num = 3 THEN
      "The dictionary is in read-only mode - alterations not allowed."
    ELSE
      "You do not have permission to use this option.")
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

PAUSE 0.

/* if filename contains the .db, then remove it */
IF INDEX(user_env[2],".db") > 0 THEN
        SUBSTRING(user_env[2],INDEX(user_env[2],".db"),3,"RAW") = "".

IF io-frame = "df" THEN DO:
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
   &FRAME  = "FRAME read-df" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
  }


  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-df:
     ENABLE stop_flg err-to-file err-to-screen commit_flg &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN warntxt &ENDIF WITH FRAME read-df.
   ASSIGN
      stop_flg = user_env[4] BEGINS "y".
    
    UPDATE user_env[2] btn_File stop_flg err-to-file err-to-screen commit_flg
      btn_OK btn_Cancel {&HLP_BTN_NAME}.

    ASSIGN user_env[15] = STRING(commit_flg)
           user_env[4] = STRING(stop_flg).

    { prodict/dictnext.i trash }
    canned = FALSE.
        user_env[6] = 
         IF (err-to-file AND NOT err-to-screen) THEN "f" 
         ELSE IF (err-to-file AND err-to-screen) THEN "b" 
         ELSE IF (NOT err-to-file AND err-to-screen) THEN "s"
         ELSE "f".
    
  END.
END.

ELSE IF io-frame = "d" THEN DO:
 IF NOT io-file THEN DO:
    {adecomm/okrun.i  
     &FRAME  = "FRAME read-d-dir" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
    }

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-dir:
      ENABLE user_env[2] i do-screen btn_OK btn_Cancel.
      ASSIGN
        i      = INTEGER(user_env[4]).

      UPDATE user_env[2] i do-screen btn_OK btn_Cancel  {&HLP_BTN_NAME}.
      user_env[6] = (IF do-screen THEN "s" ELSE "f").

      RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
      DISPLAY user_env[2].
      user_env[4] = STRING(i).

      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  END.
  
  ELSE DO:
    {adecomm/okrun.i  
     &FRAME  = "FRAME read-d-file" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
    }

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-file:
      ENABLE user_env[2] btn_File i do-screen btn_OK btn_Cancel.
      ASSIGN
        i      = INTEGER(user_env[4]).


     UPDATE user_env[2] btn_File i do-screen btn_OK btn_Cancel  {&HLP_BTN_NAME}.

      DISPLAY user_env[2].
      user_env[4] = STRING(i).

      user_env[6] = (IF do-screen THEN "s" ELSE "f").

      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  END.
END.

ELSE DO:
 {adecomm/okrun.i  
   &FRAME  = "FRAME read-input" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
  }

  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-input:

    UPDATE user_env[2] btn_File btn_OK btn_Cancel {&HLP_BTN_NAME}.

    { prodict/dictnext.i trash }
    canned = FALSE.
  END.
END.

HIDE FRAME read-input NO-PAUSE.
HIDE FRAME read-df    NO-PAUSE.
HIDE FRAME read-d-file NO-PAUSE.
HIDE FRAME read-d-dir NO-PAUSE.
IF canned THEN
  user_path = "".
RETURN.

/*====================================================================*/


