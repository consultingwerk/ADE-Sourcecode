/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrpfed.p - .pf editor */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

{prodict/user/userpfed.i NEW} /* Contains arg_xxx variables and pf_file */

DEFINE STREAM pf.
DEFINE VARIABLE canned	  AS LOGICAL   INITIAL TRUE    NO-UNDO.
DEFINE VARIABLE arg_int	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE arg_log	  AS LOGICAL		       NO-UNDO.
DEFINE VARIABLE c	  AS CHARACTER		       NO-UNDO.
DEFINE VARIABLE go_list	  AS CHARACTER		       NO-UNDO.
DEFINE VARIABLE i	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE k	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE lin	  AS CHARACTER		       NO-UNDO.
DEFINE VARIABLE p_down	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE p_draw	  AS LOGICAL   INITIAL TRUE    NO-UNDO.
DEFINE VARIABLE p_flow	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE p_init	  AS INTEGER   INITIAL ?       NO-UNDO.
DEFINE VARIABLE p_line	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE p_ptr	  AS INTEGER   INITIAL 1       NO-UNDO.
DEFINE VARIABLE p_spot	  AS INTEGER		       NO-UNDO.
DEFINE VARIABLE pf_name	  AS CHARACTER		       NO-UNDO.
DEFINE VARIABLE tru_txt	  AS CHARACTER		       NO-UNDO.
DEFINE VARIABLE comment   AS CHARACTER EXTENT {&COMM#} NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER                 NO-UNDO.
{prodict/misc/filesbtn.i}

&IF "{&OPSYS}" <> "MSDOS" and "{&OPSYS}" <> "WIN32" &THEN
    &SCOPED-DEFINE SLASH /
&ELSE
    &SCOPED-DEFINE SLASH ~~~\
&ENDIF

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /*1,2*/ "Last update: Date", "Time",
  /*  3*/ "Please enter a file name."
].

form
    skip(1)
  pf_name
    at 3
    label "Parameter file"
    format "x(50)" skip
  k
    at 3
    label " Reading line "
    skip(1)
  with frame lreading 
       width 70
       row 5 centered
       overlay
       side-labels USE-TEXT VIEW-AS DIALOG-BOX THREE-D
       TITLE "Reading in pf file".
       

form
    skip(1)
  pf_file
    at 3
    label "Parameter file"
    format "x(50)" skip
  k
    at 3
    label " Writing line "
    skip(1)
  with frame lwriting 
       width 70
       row 5 centered
       overlay
       side-labels USE-TEXT VIEW-AS DIALOG-BOX THREE-D.

FORM SKIP({&TFM_WID})
  pf_file {&STDPH_FILL} LABEL "&Parameter File" FORMAT "x(80)" AT 2 
	VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File
  {prodict/user/userbtns.i}
  WITH FRAME pf_name
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Parameter File Name".

FORM
  "Enter comments to be included in the parameter file." SKIP(1)
  arg_comm[ 1] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 2] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 3] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 4] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 5] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 6] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 7] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 8] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[ 9] FORMAT "x({&COMM_LEN})" SKIP
  arg_comm[10] FORMAT "x({&COMM_LEN})" SKIP
  {prodict/user/userbtns.i}
  WITH FRAME comments 
  CENTERED ATTR-SPACE NO-LABELS 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE ' Parameter File "' + pf_file + '" '.

FORM
  arg_nam[p_ptr] FORMAT "x({&PNAME_LEN})" NO-ATTR-SPACE
  arg_val[p_ptr] FORMAT "x({&VAL_CHARS})" HELP "Enter value"
  WITH FRAME pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE 
  p_down DOWN ROW 3 COLUMN 1 TITLE " " + pf_file + " ".

FORM
  arg_int FORMAT ">>>,>>>,>>9" HELP "Enter ? to leave blank"
  WITH FRAME pick_int OVERLAY NO-LABELS ATTR-SPACE NO-BOX
  ROW 3 + FRAME-LINE(pick) COLUMN {&VAL_START}.

FORM
  arg_log FORMAT "yes/no" HELP "Enter ~"yes~" to set, else ~"no~""
  WITH FRAME pick_log OVERLAY NO-LABELS ATTR-SPACE NO-BOX
  ROW 3 + FRAME-LINE(pick) COLUMN {&VAL_START}.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
/* This is the only interactive frame that is used in GUI environment */
on HELP of frame pf_name
   or CHOOSE of btn_Help in frame pf_name
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Parameter_File_Name_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


ON GO OF FRAME pf_name
DO:
  IF pf_file:SCREEN-VALUE IN FRAME pf_name = "" THEN DO:
    MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
  ELSE DO:
    DEF VAR d AS CHAR NO-UNDO.
    DEF VAR f AS CHAR NO-UNDO.

    ASSIGN pf_file.
    IF R-INDEX(pf_file,"{&SLASH}") > 0 THEN DO: /* has a slash */
      ASSIGN f = SUBSTRING(pf_file,R-INDEX(pf_file,"{&SLASH}") + 1,-1,"CHARACTER":U) /* filename  */
             d = SUBSTRING(pf_file,1,R-INDEX(pf_file,"{&SLASH}") - 1).               /* directory */
      FILE-INFO:FILE-NAME = d.
      IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
        MESSAGE "The directory specified does not exist." VIEW-AS ALERT-BOX ERROR. /* bad directory */
        APPLY "ENTRY" TO pf_file.
        RETURN NO-APPLY.
      END.
      IF INDEX(FILE-INFO:FILE-TYPE,"D") = 0 THEN DO:
        MESSAGE d "is not a valid directory." VIEW-AS ALERT-BOX ERROR. /* bad directory */
        APPLY "ENTRY" TO pf_file.
        RETURN NO-APPLY.
      END.
    END.
    ELSE f = pf_file.
  END.     
END.

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame pf_name DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT pf_file:handle in frame pf_name /*Fillin*/,
        INPUT "Find Parameter File"  /*Title*/,
        INPUT "*.pf"               /*Filter*/,
        INPUT no                 /*Must exist*/).
END.
/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF pf_file in frame pf_name
   pf_file:screen-value in frame pf_name = 
        TRIM(pf_file:screen-value in frame pf_name).

ON WINDOW-CLOSE OF FRAME pf_name
   APPLY "END-ERROR" TO FRAME pf_name.


/*============================Mainline code===============================*/

/* the PROGRESS default truth for logicals */
tru_txt = STRING(TRUE).  /* will automatically match language */

/* Translate the arg_nam array into: 
   arg_lst - all parm names (-B) strung out in a comma delimited list
   arg_nam - array of arg name/description pairs (e.g., -B   Buffers)
   arg_typ - array of argument data types (l, c, n)
   arg_val - array of values - the default value is set here.
*/
DO WHILE arg_nam[args# + 1] <> "":
  ASSIGN
    args#          = args# + 1
    arg_lst        = arg_lst + (IF args# = 1 THEN "" ELSE ",")
                   + ENTRY(1,arg_nam[args#])
    arg_typ[args#] = ENTRY(3,arg_nam[args#])
    arg_nam[args#] = "-" + STRING(ENTRY(1,arg_nam[args#]),"x({&PKEY_LEN})")
                   + ENTRY(2,arg_nam[args#])
    arg_val[args#] = (IF arg_typ[args#] = "l" THEN "no" ELSE "").
END.

SESSION:IMMEDIATE-DISPLAY = yes.

/* Determine the parameter file name */
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
      &FRAME  = "FRAME pf_name" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
  SET pf_file btn_File btn_OK btn_Cancel {&HLP_BTN_NAME} WITH FRAME pf_name.
  canned = FALSE.
END.
HIDE FRAME pf_name.
iF canned THEN RETURN.
canned = TRUE.  /* reset */

ASSIGN
  pf_name = SEARCH(pf_file)
  go_list = "*-UP,*-DOWN,*TAB,GO,END-ERROR,HOME,MOVE,END".

/* Read an existing file into the arg_comm and arg_xxx arrays. */
IF pf_name <> ? THEN DO:
  PAUSE 0.
  DISPLAY pf_name WITH FRAME lreading.
  run adecomm/_setcurs.p ("WAIT").
  IF OPSYS = "UNIX" THEN
    INPUT STREAM pf THROUGH VALUE(SEARCH("quoter")) "<" VALUE(pf_name) NO-MAP.
  ELSE DO:
    RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
    RUN "prodict/misc/osquoter.p" (pf_name,?,?,tmpfile).
    INPUT STREAM pf FROM VALUE(tmpfile) NO-ECHO NO-MAP.
  END.
  REPEAT:
    k = k + 1.
    DISPLAY k WITH FRAME lreading.
    IMPORT STREAM pf lin.
    /* '##' lines are purged */
    IF lin BEGINS "# " AND NOT lin BEGINS "##" AND arg_comm# < {&COMM#} THEN 
      ASSIGN
        arg_comm# = arg_comm# + 1
        arg_comm[arg_comm#] = SUBSTRING(lin,3).
    IF INDEX(lin,"#") > 0 THEN lin = SUBSTRING(lin,1,INDEX(lin,"#") - 1).
    lin = TRIM(lin).
    DO WHILE SUBSTRING(lin,1,1) = "-":
      ASSIGN
        c   = SUBSTRING(lin,2,INDEX(lin + " "," ") - 2)
        lin = TRIM(SUBSTRING(lin,LENGTH(c) + 2))
        i   = LOOKUP(TRIM(c),arg_lst).
      IF i >= 1 AND i <= args# THEN DO:
        arg_val[i] = tru_txt.
        IF arg_typ[i] <> "l" THEN ASSIGN
          arg_val[i] = SUBSTRING(lin,1,INDEX(lin + " "," ") - 1)
          lin        = TRIM(SUBSTRING(lin,LENGTH(arg_val[i]) + 1)).
      END.
    END.
  END.
  INPUT STREAM pf CLOSE.
  IF OPSYS <> "UNIX" THEN OS-DELETE VALUE(tmpfile).
  run adecomm/_setcurs.p ("").
  HIDE FRAME lreading NO-PAUSE.
END.

ASSIGN
  pf_file = (IF pf_name = ? THEN pf_file ELSE pf_name)
  p_ptr   = 1
  p_down  = MINIMUM(args#,SCREEN-LINES - 8).

/* This is the UI section - allowing users to modify values */
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  DO WHILE TRUE WITH FRAME pick:
  
    p_ptr = MINIMUM(args#,MAXIMUM(p_ptr,1)).
  
    IF p_draw THEN DO:
      ASSIGN
	p_line = MAXIMUM(1,FRAME-LINE)
	p_spot = p_ptr - (IF p_init = ? THEN p_line ELSE p_init) + 1.
      UP p_line - 1.
      IF p_spot < 1 THEN ASSIGN
	p_spot = 1
	p_line = 1
	p_ptr  = 1.
      DO p_flow = p_spot TO p_spot + p_down - 1:
	IF p_flow > args# THEN DO:
	  CLEAR NO-PAUSE.
	END.
	ELSE DO:
	  DISPLAY
	    arg_nam[p_flow] @ arg_nam[p_ptr]
	    arg_val[p_flow] @ arg_val[p_ptr].
	END.
	IF p_flow < p_spot + p_down - 1 THEN DOWN 1.
      END.
      p_line = (IF p_init = ? THEN p_line ELSE p_init).
      UP p_down - p_line.
      ASSIGN
	p_init = ?
	p_draw = FALSE.
    END.
  
    DISPLAY arg_nam[p_ptr].
    IF arg_typ[p_ptr] = "c" THEN UPDATE arg_val[p_ptr]
      EDITING:
	READKEY.
	APPLY (IF CAN-DO(go_list,KEYFUNCTION(LASTKEY))
	  THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
      END.
    IF arg_typ[p_ptr] = "n" THEN DO WITH FRAME pick_int:
      arg_int = (IF arg_val[p_ptr] = "" THEN ? ELSE INTEGER(arg_val[p_ptr])).
      PAUSE 0.
      UPDATE arg_int EDITING:
	READKEY.
	APPLY (IF CAN-DO(go_list,KEYFUNCTION(LASTKEY))
	  THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
	END.
      HIDE NO-PAUSE.
      arg_val[p_ptr] = (IF arg_int = ? THEN "" ELSE STRING(arg_int)).
    END.
    IF arg_typ[p_ptr] = "l" THEN DO WITH FRAME pick_log:
      arg_log = arg_val[p_ptr] = tru_txt.
      PAUSE 0.
      UPDATE arg_log EDITING:
	READKEY.
	APPLY (IF CAN-DO(go_list,KEYFUNCTION(LASTKEY))
	  THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
	END.
      HIDE NO-PAUSE.
      arg_val[p_ptr] = STRING(arg_log).
    END.
    DISPLAY arg_val[p_ptr] WITH FRAME pick.
  
    IF CAN-DO("RETURN,CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
      AND p_ptr < args# THEN DO:
      p_ptr = p_ptr + 1.
      IF FRAME-LINE = FRAME-DOWN THEN
	SCROLL UP.
      ELSE
	DOWN.
    END.
    ELSE
    IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND p_ptr > 1 THEN DO:
      p_ptr = p_ptr - 1.
      IF FRAME-LINE = 1 THEN
	SCROLL DOWN.
      ELSE
	UP.
    END.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN ASSIGN
      p_ptr  = p_ptr + p_down
      p_draw = TRUE.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
      p_ptr  = p_ptr - p_down
      p_draw = TRUE.
    ELSE
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND p_ptr > 1 THEN DO:
      ASSIGN
	p_ptr  = 1
	p_draw = TRUE.
      UP FRAME-LINE - 1.
    END.
    ELSE
    IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
      ASSIGN
	p_ptr  = args#
	p_draw = TRUE.
      DOWN p_down - FRAME-LINE.
    END.
    ELSE
    IF CAN-DO("GO,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.
  
    p_line = 1.
  END.
  
  HIDE FRAME pick NO-PAUSE.
  IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
  
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
         {adecomm/okrun.i  
            &FRAME  = "FRAME comments" 
            &BOX    = "rect_Btns"
            &OK     = "btn_OK" 
            {&CAN_BTN}
            {&HLP_BTN}
         }
         UPDATE TEXT(arg_comm[1 FOR {&COMM#}]) 
      	        btn_OK btn_Cancel {&HLP_BTN_NAME}
      	       	WITH FRAME comments. 
         canned = FALSE.
    END.
    HIDE FRAME comments NO-PAUSE.
    arg_comm# = 0.
    DO i = 1 TO {&COMM#}:
      IF arg_comm[i] <> "" THEN arg_comm# = arg_comm# + 1.
    END.
  END.
&ELSE
   RUN "prodict/gui/_guipfed.p" (OUTPUT canned).
&ENDIF

IF NOT canned THEN DO:
  /* Write new values out to parameter file */
  k = 0.
  PAUSE 0.
  DISPLAY pf_file WITH FRAME lwriting.
  run adecomm/_setcurs.p ("WAIT").
  OUTPUT STREAM pf TO VALUE(pf_file) NO-ECHO NO-MAP.

  IF arg_comm# > 0 THEN DO:
    PUT STREAM pf UNFORMATTED
      "##" FILL("-",{&COMM_LEN} + 4) SKIP
      "## " new_lang[1] /* date */ " " STRING(TODAY)
        " " new_lang[2] /* time */ " " STRING(TIME,"HH:MM:SS") SKIP.
    DO i = 1 TO {&COMM#}:
      IF arg_comm[i] <> "" THEN PUT STREAM pf UNFORMATTED "# " arg_comm[i] SKIP.
    END.
    PUT STREAM pf UNFORMATTED "##" FILL("-",{&COMM_LEN} + 4) SKIP.
  END.
  DO i = 1 TO args#:
    IF (arg_typ[i] = "l" AND arg_val[i] = "no") OR arg_val[i] = "" THEN NEXT.
    IF arg_typ[i] = "l" THEN arg_val[i] = "".
    k = k + 1.
    DISPLAY k WITH FRAME lwriting.
    PUT STREAM pf UNFORMATTED 
      "-" STRING(ENTRY(i,arg_lst),"x({&PKEY_LEN})") arg_val[i].
    IF LENGTH(arg_val[i]) > 50 THEN DO:
      PUT STREAM pf UNFORMATTED SKIP SPACE(55).
      k = k + 1.
    END.
    ELSE
      PUT STREAM pf UNFORMATTED 
      	 FILL(" ", 80 - {&PNAME_LEN} - LENGTH(arg_val[i]) - 3).
    PUT STREAM pf UNFORMATTED 
      "#" SUBSTRING(LC(arg_nam[i]),{&PKEY_LEN} + 1,{&PDESC_LEN} + 1) SKIP.
  END.
  OUTPUT STREAM pf CLOSE.
  run adecomm/_setcurs.p ("").
  HIDE FRAME lwriting NO-PAUSE.
END.

SESSION:IMMEDIATE-DISPLAY = no.
RETURN.




