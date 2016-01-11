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

/* _incload - user interface and defaults setup for loading  AS/400 Incremental df*/

{ as4dict/dictvar.i shared}
{ as4dict/dump/dumpvar.i shared}

DEFINE VARIABLE answer           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE canned           AS LOGICAL        NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base             AS CHARACTER      NO-UNDO.
DEFINE VARIABLE class            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE comma            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE err              AS CHARACTER      NO-UNDO.
DEFINE VARIABLE i                AS INTEGER        NO-UNDO.
DEFINE VARIABLE io-file          AS LOGICAL        NO-UNDO.
DEFINE VARIABLE io-frame         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE io-title         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE is-all           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE is-one           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE is-some          AS LOGICAL        NO-UNDO.
DEFINE VARIABLE Errors_to_File   AS LOGICAL        NO-UNDO.
DEFINE VARIABLE Errors_to_Screen AS LOGICAL        NO-UNDO.
DEFINE VARIABLE allow_null       AS LOGICAL        NO-UNDO INITIAL TRUE.
DEFINE VARIABLE msg-num          AS INTEGER        NO-UNDO INITIAL 0.
DEFINE VARIABLE noload           AS CHARACTER      NO-UNDO.
DEFINE VARIABLE prefix           AS CHARACTER      NO-UNDO.
DEFINE VARIABLE trash            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE dis_trig         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE codepage         AS CHARACTER      NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar             AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#            AS INTEGER        NO-UNDO. 
DEFINE VARIABLE okench           AS LOGICAL        NO-UNDO INITIAL FALSE.

{prodict/misc/filesbtn.i}

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Input File"
  btn_File SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-input
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-Win" &THEN
  &GLOBAL-DEFINE LINEUP 25
  &GLOBAL-DEFINE FILLCH 67
&ELSEIF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
  &GLOBAL-DEFINE LINEUP 25
  &GLOBAL-DEFINE FILLCH 69
&ELSE
  &GLOBAL-DEFINE LINEUP 25
&ENDIF

/* form for .df file input */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Input File" COLON {&LINEUP}
   btn_File  SKIP ({&VM_WIDG})
   user_env[34] {&STDPH_FILL} FORMAT "x(10)" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Database Object Library" COLON {&LINEUP} SKIP    
    errors_to_file VIEW-AS TOGGLE-BOX LABEL "Write Errors to Output File"
        COLON {&LINEUP} SKIP({&VM_WIDG})
    errors_to_screen VIEW-AS TOGGLE-BOX LABEL "Display Errors on Screen"
            COLON {&LINEUP} SKIP({&VM_WIDG}) 
  
  "The Database Object Library is where the objects will be created."
      AT 10 VIEW-AS TEXT SKIP
  "The AS/400 Incremental load will be performing multiple commits and "
      AT 10 VIEW-AS TEXT SKIP
  "all changes will be commited at the end of the load process. "
      AT 10 VIEW-AS TEXT SKIP(1)
  "If when the incremental .df file was generated files were to be "
      AT 10 VIEW-AS TEXT SKIP
  "copied the name of the library where they are copied to will "  AT 10 VIEW-AS TEXT SKIP
  "be displayed at the end of the load process."
      AT 10 VIEW-AS TEXT 
  {prodict/user/userbtns.i}
  WITH FRAME read-df
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM
      "Please enter a Code Page to use for this load." AT 2 SKIP
      codepage {&STDPH_FILL} LABEL "Code Page" AT 2
      {prodict/user/userbtns.i}
      WITH FRAME get-cp
      SIDE-LABELS NO-ATTR-SPACE CENTERED
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX TITLE " Code Page ".
                             
/*===============================Triggers=================================*/

DEFINE VAR msg AS CHAR NO-UNDO INITIAL
   "Can not find a file of this name.  Try again.".

&IF NOT "{&WINDOW-SYSTEM}" = "TTY" &THEN 
/*----- HELP -----*/

on HELP of frame read-input or CHOOSE of btn_Help in frame read-input
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&AS4_Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&AS4_Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

on HELP of frame get-cp or CHOOSE of btn_Help in frame get-cp
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
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

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame read-input
   user_env[2]:screen-value in frame read-input = 
        TRIM(user_env[2]:screen-value in frame read-input).
ON LEAVE OF user_env[2] in frame read-df
   user_env[2]:screen-value in frame read-df = 
        TRIM(user_env[2]:screen-value in frame read-df).
ON LEAVE OF user_env[34] in frame read-df
   user_env[34]:screen-value in frame read-df = 
        TRIM(user_env[34]:screen-value in frame read-df).

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
          
/*============================Mainline code===============================*/
FIND FIRST as4dict.p__Db NO-LOCK.
ASSIGN user_env[34] = as4dict.p__Db.OBJECTLIB.

ASSIGN
  class    = SUBSTRING(user_env[9],1)
  io-file  = TRUE
  io-frame = ""
  is-all   = (user_env[1] = "ALL")
  is-some  = (user_env[1] MATCHES "*,*")
  is-one   = NOT is-all AND NOT is-some
  prefix   = "".
         
IF dict_rog THEN msg-num = 3. /* look but don't touch */

/*-------------------------------------------------------*/ /* Hide message */
IF class = "h" THEN DO:
   HIDE MESSAGE NO-PAUSE.
   MESSAGE "Load completed." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.
/*----------------------------------------------*/ /* LOAD INCREMENTAL DEFINITIONS */
IF class = "d" THEN DO:

  ASSIGN
    base        = PDBNAME(user_dbname)
    user_env[2] = "as4delta.df"
    io-frame    = "df"
    io-title    = "Load AS/400 Incremental"
    user_env[4] = "n"          /* stop on first error - used by _lodsddl.p */
    user_env[8] = user_dbname  /* dbname to load into - used by _lodsddl.p */
    class = "d". /* if class was 's', reassign to run as class 'd' after 
                    input file name default (user_env[2]) */
END.

IF io-frame = "df" THEN
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-df:
    /* Adjust the graphical rectangle and the ok and cancel buttons */
    {adecomm/okrun.i  
        &FRAME  = "FRAME read-df" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
    }
    ASSIGN      
      Errors_to_File = yes.
      Errors_to_Screen = yes.

    UPDATE user_env[2] user_env[34] btn_File 
           Errors_to_file Errors_to_screen 
           btn_OK  btn_Cancel {&HLP_BTN_NAME}.
    ASSIGN user_env[34] = CAPS(user_env[34]).
    IF LAST-EVENT:FUNCTION = "ENDKEY" OR
       LAST-EVENT:FUNCTION = "END-ERROR" THEN UNDO, RETRY.

    user_env[27] = STRING(Errors_to_File).
    user_env[28] = STRING(Errors_to_Screen).    
    { prodict/dictnext.i trash }
    canned = FALSE.
END.

HIDE FRAME read-input NO-PAUSE.
HIDE FRAME read-df    NO-PAUSE.

IF canned THEN do:
  user_path = "".
  user_cancel = yes.
END.
RETURN.

PROCEDURE verify-cp.
  /* Is there a defined codepage? Try to read it in the trailer, if
   * not, ask for it
   */
  ASSIGN codepage = "".
  RUN read-cp. /* read the code page in the file */
  IF NOT okench THEN DO:
    MESSAGE "The .df file is not an AS/400 Incremental File and cannot be loaded using this option." SKIP
            "To load a regular definition file use the Load Definitions menu option. " SKIP
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ASSIGN user_cancel = yes
           user_env[35] = "error".
    RETURN.
  END.
  IF codepage = "" OR codepage = ? THEN 
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
    IF lvar[i] BEGINS "codepage=" OR lvar[i] BEGINS "cpstream" THEN 
      codepage = SUBSTRING(lvar[i],10).
    IF lvar[i] MATCHES "AS4DELTA" THEN
      ASSIGN okench = TRUE.
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

PROCEDURE get-cp.
   /* Prompt for codepage */
   DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME get-cp:
      {adecomm/okrun.i
         &FRAME = "FRAME get-cp"
         &BOX   = "rect_Btns"
         &OK    = "btn_OK"
         {&CAN_BTN}
         {&HLP_BTN}
       }
       ASSIGN codepage = SESSION:STREAM.
       UPDATE codepage btn_OK btn_Cancel {&HLP_BTN_NAME}.
       ASSIGN user_env[10] = codepage.
   END.
END PROCEDURE.







