/*********************************************************************
* Copyright (C) 2000,2007-2008 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*

File:   prodict/ora/_usrload 

Describtion:
    user interface and defaults setup for loading data to an Oracle Database

Input:
  user_env[1] = "ALL" or comma-separated list of files
  user_env[9] = "f" = load data file contents
                
Output:
  user_env[1] = same as IN
  user_env[2] = physical file or directry name for some input
  user_env[4] = "y" or "n" - stop on first error (if class = "d","4" or "s")
              = error% (if class = "f")
  user_env[5] = comma separated list of "y" (yes) or "n" (no) which
                corresponds to file list in user_env[1], indicating for each,
                whether triggers should be disabled when the load is done.
                (only used for load data file contents, "f").
  user_env[10]= user specified code page

History:
    D. McMann   02/08/00 Copied from user/_usrload.p for the Oracle Bulk Load.  Needed to copy 
                         because Oracle can not handle an acceptable percent for errors.  
    D. McMann   04/13/00 Added support for long path names
    D. McMann   03/19/03 Added block for loading lobs.
    fernando    06/20/07 Support for large files
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE class    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comma    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i        AS INT64      NO-UNDO.
DEFINE VARIABLE j        AS INTEGER    NO-UNDO.
DEFINE VARIABLE err      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-file  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE io-frame AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-title AS CHARACTER  NO-UNDO.
DEFINE VARIABLE is-all   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-one   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-some  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-lob   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE stop_flg AS LOGICAL    NO-UNDO.
DEFINE VARIABLE msg-num  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE noload   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE prefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trash    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dis_trig AS CHARACTER  NO-UNDO.
DEFINE VARIABLE codepage AS CHARACTER  NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar     AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#    AS INT            NO-UNDO.  
DEFINE VARIABLE cr       AS CHARACTER      NO-UNDO.
DEFINE VARIABLE loblist  AS CHARACTER      NO-UNDO.
DEFINE VARIABLE do-screen AS LOGICAL       NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-file AS LOGICAL     NO-UNDO INIT FALSE.
DEFINE VARIABLE err-to-screen AS LOGICAL   NO-UNDO INIT TRUE.
DEFINE VARIABLE base_lchar    AS LONGCHAR  NO-UNDO.
DEFINE VARIABLE cEntry        AS CHARACTER NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE VARIABLE warntxt  AS CHARACTER  NO-UNDO VIEW-AS EDITOR NO-BOX 
 INNER-CHARS 64 INNER-LINES 2.
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

cr = CHR(10).

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL "&Input File"
  btn_File  SKIP ({&VM_WIDG})
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
on WINDOW-CLOSE of frame read-d-file
   apply "END-ERROR" to frame read-d-file.
on WINDOW-CLOSE of frame read-d-dir
   apply "END-ERROR" to frame read-d-dir.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame read-input
   user_env[2]:screen-value in frame read-input = 
        TRIM(user_env[2]:screen-value in frame read-input).
ON LEAVE OF user_env[2] in frame read-d-file
   user_env[2]:screen-value in frame read-d-file = 
        TRIM(user_env[2]:screen-value in frame read-d-file).
ON LEAVE OF user_env[2] in frame read-d-dir
   user_env[2]:screen-value in frame read-d-dir = 
        TRIM(user_env[2]:screen-value in frame read-d-dir).

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame read-input DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-input /*Fillin*/,
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
  
  DEFINE VARIABLE tempi AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE j     AS INTEGER          NO-UNDO.

  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  i = SEEK(INPUT) - 11.
  SEEK INPUT TO i. /* position to possible beginning of last line */

  /*   Now we need to deal with a large offset, which is a variable size
       value in the trailer, for large values.
       Now go back one character at a time until we find a new line or we have
       gone back too far.
       For the non-large offset format, the previous char will be a
       newline character, so we will  detect that right away and read the
       value as usual. Unless the file has CRLF (Windows), in which case
       we will go back 1 character to read the value properly - to
       account for the extra byte.
       For larger values, we will read as many digits as needed.
       The loop below could stop after 10 digits, but I am letting it go
       up to 50 to try to catch a bad value.
  */
  DO WHILE LASTKEY <> 13 AND j <= 50:
     ASSIGN j = j + 1
            i = i - 1.
     SEEK INPUT TO i.
     READKEY PAUSE 0.
  END.

  /* now we can start reading it */
  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.

  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
     IF LASTKEY > 47 AND LASTKEY < 58 THEN DO:
          /* check if can fit the value into an int64 type. We need
             to manipulate it with a decimal so that we don't get fooled
             by a value that overflows. This is so that we catch a
             bad offset in the file.
           */
          ASSIGN tempi = i /* first move it to a decimal */
                 tempi = tempi * 10 + LASTKEY - 48. /* get new value */
          i = INT64(tempi) NO-ERROR. /* see if it fits into an int64 */
          
          /* check if the value overflows becoming negative or an error happened. 
             If so, something is wrong (too many digits or invalid values),
             so forget this.
          */
          IF  i < 0 OR
              ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
              ASSIGN i = 0.
              LEAVE. /* we are done with this */
          END.

     END.
     ELSE 
          ASSIGN i = ?. /* bad character */

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
  DEFINE VARIABLE p AS INT64 INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INT64.             /* LAST char position */
  
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
  DEFINE INPUT PARAMETER pi as INT64. /* "SEEK TO" location */
    
  SEEK INPUT TO pi.
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
  prefix   = ""
  loblist  = ?.  

IF user_env[1] NE "" THEN
  ASSIGN is-some  = (user_env[1] MATCHES "*,*").
ELSE DO:
  ASSIGN is-some  = (user_longchar MATCHES "*,*").
END.

ASSIGN   
  is-all   = (user_env[1] = "ALL")
  is-one   = NOT is-all AND NOT is-some.

IF dict_rog THEN msg-num = 3. /* look but don't touch */

/*--------------------------------------*/ /* LOAD DATA FILE CONTENTS */
DO FOR DICTDB._File:

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

  IF is-one OR is-some THEN DO:
      /* if user_env[1] is "", then value is in user_longchar */
      IF user_env[1] NE "" THEN
          base_lchar = user_env[1].
      ELSE
          base_lchar = user_longchar.
  END.
  ELSE
      base_lchar = "".


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
    user_env[1] = ""
    user_longchar = ""
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
    base_lchar = base_lchar + (IF base_lchar = "" THEN "" ELSE ",") + DICTDB._File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  ASSIGN user_env[5] = ""
         j = NUM-ENTRIES(base_lchar).

  DO i = 1 TO j:
    err = ?.
    dis_trig = "y".
    cEntry = ENTRY(i,base_lchar).
    FIND DICTDB._File
      WHERE _Db-recid = drec_db AND _File-name = cEntry
        AND (_Owner = "PUB" OR _Owner = "_FOREIGN").

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

    IF err = ? THEN DO:
      FIND FIRST DICTDB._Field OF DICTDB._File WHERE DICTDB._Field._Dtype > 17 NO-LOCK NO-ERROR.
      IF AVAILABLE DICTDB._Field THEN
        ASSIGN loblist = (IF loblist = ? THEN DICTDB._File._File-name ELSE loblist + "," + DICTDB._File._File-name). 
      ELSE
        ASSIGN
          user_longchar = user_longchar + comma + DICTDB._File._File-name
          user_env[5] = user_env[5] + comma + dis_trig
          comma       = ",".
    END.
    ELSE IF err <> "" THEN DO:
      MESSAGE err SKIP "Do you want to continue?"
         VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
      IF answer = FALSE THEN DO:
        user_path = "".
        RETURN.
      END.
    END.    
  END.
  IF NUM-ENTRIES(loblist) > 0 AND NUM-ENTRIES(loblist) < NUM-ENTRIES(base_lchar) THEN DO:
    ASSIGN answer = FALSE.
    MESSAGE "The Bulk Insert Utility can not be used when LOB fields" SKIP
             "are part of a table definition." SKIP(1)
              loblist "contain LOB fields and will not be loaded." SKIP
              "Do you want to load the remaining files?" SKIP(1)
               VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
    IF answer = FALSE THEN DO:
      user_path = "".
      RETURN.
    END.   
  END.
  ELSE IF NUM-ENTRIES(loblist) > 0 AND NUM-ENTRIES(loblist) = NUM-ENTRIES(base_lchar) THEN DO: 
    MESSAGE "The Bulk Insert Utility can not be used to load " SKIP
             loblist "because LOB fields are present." SKIP
             "Use the Data Admin/Data Dictionary data load. " SKIP(1)
         VIEW-AS ALERT-BOX ERROR.
       ASSIGN user_path = "".
       RETURN.
  END.

  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND NUM-ENTRIES(base_lchar) = 1 THEN DO:

    ASSIGN user_env[1] = user_longchar
           user_longchar = "".
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
      base_lchar  = user_env[1].
  END.

END.
IF io-frame = "d" THEN DO:
 IF NOT io-file THEN DO:
    {adecomm/okrun.i  
     &FRAME  = "FRAME read-d-dir" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
    }

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-dir:
      ENABLE user_env[2]  
             do-screen btn_OK btn_Cancel.     

      UPDATE user_env[2]              
             do-screen 
             btn_OK 
             btn_Cancel
            {&HLP_BTN_NAME}.
            user_env[6] = (IF do-screen THEN "s" ELSE "f").

      RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
      DISPLAY user_env[2].     

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
      ENABLE user_env[2] btn_File 
             do-screen btn_OK btn_Cancel.

     UPDATE user_env[2] btn_File            
            do-screen btn_OK btn_Cancel  {&HLP_BTN_NAME}.

      DISPLAY user_env[2].
     
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
HIDE FRAME read-d-file NO-PAUSE.
HIDE FRAME read-d-dir NO-PAUSE.
IF canned THEN
  user_path = "".
RETURN.

/*====================================================================*/


