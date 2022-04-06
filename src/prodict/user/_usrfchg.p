/***********************************************************************
* Copyright (C) 2000,2006,2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/* This doesn't compile on Windows, but we don't need it there so
   just ifdef the whole thing out.
*/
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN


/* _usrfchg.p - calls the field editors, which are based on userfchg.i 


   Modified: 06/18/98 D. McMann changed DTYPE_RAW from 6 to 8
             07/14/98 D. McMann Added _Owner to _File finds
             08/03/99 Mario B. reset cursor keyes on stop. Bug# 98-12-04-003
             02/04/03 D. McMann Added support for LOB 
             07/28/03 D. McMann More support for Clobs
             04/09/08 fernando  Datetime support for ORACLE
 */
/*
To make this program visually more appealing, multiple frame
definitions are used and switched between.  This way, if you have short
field names, more are listed on the screen at a time.  This causes some
rather convoluted logic for display/update, since depending on the size
of the data, the ch6, ch4 or ch2 frame must be selected.
*/

{ prodict/user/uservar.i }
{ prodict/dictvar.i }

DEFINE VARIABLE alfa-ord AS LOGICAL INITIAL  TRUE NO-UNDO.
DEFINE VARIABLE answer   AS LOGICAL               NO-UNDO.
DEFINE VARIABLE c        AS CHARACTER             NO-UNDO.
DEFINE VARIABLE can-add  AS LOGICAL               NO-UNDO.
DEFINE VARIABLE can-copy AS LOGICAL               NO-UNDO.
DEFINE VARIABLE glob     AS CHARACTER EXTENT 0512 NO-UNDO.
DEFINE VARIABLE glob#    AS INTEGER               NO-UNDO.
DEFINE VARIABLE gobrowse AS INTEGER               NO-UNDO.
DEFINE VARIABLE hint     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE i        AS INTEGER               NO-UNDO.
DEFINE VARIABLE inbrowse AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE inindex  AS LOGICAL               NO-UNDO. /* idx part */
DEFINE VARIABLE intrans  AS LOGICAL               NO-UNDO.
DEFINE VARIABLE inview   AS LOGICAL               NO-UNDO. /* view part */
DEFINE VARIABLE j        AS INTEGER               NO-UNDO.
DEFINE VARIABLE namxx    AS CHARACTER EXTENT    6 
      	       	     	      	      CASE-SENS   NO-UNDO.
DEFINE VARIABLE odbtyp   AS CHARACTER             NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE qbf#     AS INTEGER   INITIAL   1 NO-UNDO.
DEFINE VARIABLE recache  AS LOGICAL               NO-UNDO.
DEFINE VARIABLE redraw   AS LOGICAL               NO-UNDO.
DEFINE VARIABLE romode   AS LOGICAL               NO-UNDO.
DEFINE VARIABLE rsave    AS RECID     INITIAL   ? NO-UNDO.
DEFINE VARIABLE xc       AS INTEGER               NO-UNDO. /* column-num */
DEFINE VARIABLE xd       AS INTEGER               NO-UNDO. /* frame-down */
DEFINE VARIABLE xl       AS INTEGER   INITIAL   0 NO-UNDO. /* line-num */
DEFINE VARIABLE xm       AS INTEGER   INITIAL   0 NO-UNDO. /* max-length */
DEFINE VARIABLE xr       AS INTEGER   INITIAL   0 NO-UNDO. /* row-num */
DEFINE VARIABLE xs       AS INTEGER               NO-UNDO. /* size-switch */
DEFINE VARIABLE oldname  AS CHAR      CASE-SENS   NO-UNDO. 
DEFINE VARIABLE newname  AS CHAR      CASE-SENS   NO-UNDO.
DEFINE VARIABLE oldtype  AS CHAR                  NO-UNDO. 
DEFINE VARIABLE newtype  AS CHAR                  NO-UNDO.
DEFINE VARIABLE dtype    AS INTEGER               NO-UNDO. /* data type code# */
DEFINE VARIABLE syntax   AS LOGICAL INITIAL yes   NO-UNDO. /* for triggers */

DEFINE NEW SHARED BUFFER dfields FOR _Field.

/* Symbolic constants for dtype values. These match the underlying dtype
   value. */
&global-define 	  DTYPE_CHARACTER   1
&global-define 	  DTYPE_DATE  	    2
&global-define 	  DTYPE_LOGICAL     3
&global-define 	  DTYPE_INTEGER	    4
&global-define 	  DTYPE_DECIMAL	    5
&global-define 	  DTYPE_RAW   	    8
&global-define 	  DTYPE_RECID 	    7
&global-define 	  DTYPE_BLOB 	    18
&global-define 	  DTYPE_CLOB 	    19
&global-define 	  DTYPE_XLOB       20 
&global-define 	  DTYPE_DATETM     34
&global-define 	  DTYPE_DATETMTZ   40


xd = SCREEN-LINES - 8.

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 28 NO-UNDO INITIAL [
  /* 1*/ "This field is used in a View - cannot delete.",
  /* 2*/ "This field is used in an Index - cannot delete.",
  /* 3*/ "Are you sure that you want to delete the field named",
  /* 4*/ "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/DROP COLUMN.",
  /* 5*/ "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/ADD COLUMN.",
  /* 6*/ ?, /* see below */
  /* 7*/ "You can only use Copy on native {&PRO_DISPLAY_NAME} tables.",
  /* 8*/ "Reserved for future expansion.",
  /* 9*/ "You have reached the last field in the table.",
  /*10*/ "You have reached the first field in the table.",
  /*11*/ "This operation is not supported on this table type.",
  /*12*/ "The dictionary is in read-only mode - alterations not allowed.",
  /*13*/ "The field name you supplied is not a legal {&PRO_DISPLAY_NAME} identifier.",
  /*14*/ "Currently Defined Fields",
  /*15*/ "Total Fields",
  /*16*/ "You cannot add fields here for this type of table definition.",
  /*17*/ "You do not have permission to use this option.",
  /*18*/ "There are no fields defined for this table yet.",
  /*19*/ "You haven't yet made changes that need to be undone!",
  /*20*/ "Field added successfully.  You may now add another field.",
  /*21*/ "The field list will be redrawn when you are done adding fields.",
  /*22*/ "Use the cursor-motion keys to select a field, or type its name",
  /*23*/ "This table definition is FROZEN.  No changes allowed.",
  /*24*/ "There are more than 512 fields.  Only 512 will be shown.",
  /*25*/ "Fields are now shown", /* goes with 26 and 27 */
  /*26*/ "alphabetically.",
  /*27*/ "by Order number.",
  /*28*/ "This is a {&PRO_DISPLAY_NAME}/SQL92 table cannot be modified."
].

new_lang[6] = "Are you sure that you want to undo all changes since the "
            + "Field Editor was started?".

/* 
   ********NOTE********
   If this array changes search for QBF_CHANGE to find unobvious
   places that need updating.
   ********************
*/
DEFINE VARIABLE qbf AS CHARACTER EXTENT 15 NO-UNDO INITIAL [
  "NextPage", "PrevPage", "Add",          "Modify",  "Delete",     "Copy", 
  "Triggers", "View-As",  "StringAttrs", "GoIndex", "SwitchTable","Browse", 
  "Order",    "Undo", 	  "Exit"
].

&global-define  NEXT 	   1
&global-define  PREV 	   2
&global-define  ADD	       3
&global-define  MODIFY	   4
&global-define  DELETE	   5
&global-define  COPY 	   6
&global-define  TRIGS	   7
&global-define  VIEWAS	   8
&global-define  STRINGATTR 9
&global-define  GOINDEX	   10
&global-define  SWITCH	   11 
&global-define  BROWSE	   12
&global-define  ORDER	   13
&global-define  UNDO	   14
&global-define  EXIT	   15

&global-define  UP	       16
&global-define  DOWN 	   17
&global-define  TYPEDNAM   18


FORM
  qbf[ 1] /*NextPage*/    FORMAT "x(08)" AT 2
    HELP "See the next page of fields."
  qbf[ 2] /*PrevPage*/    FORMAT "x(08)" AT 15
    HELP "See the previous page of fields."
  qbf[ 3] /*Add*/         FORMAT "x(03)" AT 25
    HELP "Add a new field."
  qbf[ 4] /*Modify*/      FORMAT "x(06)" AT 38
    HELP "Update or Rename a field."
  qbf[ 5] /*Delete*/      FORMAT "x(06)" AT 46
    HELP "Remove a field."
  qbf[ 6] /*Copy*/        FORMAT "x(04)" AT 54
    HELP "Copy fields from another table definition." 
  qbf[ 7] /*Triggers*/    FORMAT "x(08)" AT 60
    HELP "Define or modify triggers." 
  qbf[ 8] /*View-As*/     FORMAT "x(07)" AT 70
    HELP "Add or Update a VIEW-AS phrase for this field." SKIP

  qbf[ 9] /*StringAttrs*/ FORMAT "x(11)" AT 2
    HELP "Edit String Attributes for Label and Other Fields"
  qbf[10] /*GoIndex*/     FORMAT "x(07)" AT 15
    HELP "Go to the Index Editor."
  qbf[11] /*SwitchTable*/ FORMAT "x(11)" AT 25
    HELP "Switch to a different table."
  qbf[12] /*Browse*/      FORMAT "x(06)" AT 38
    HELP "Browse through field definitions for this table."
  qbf[13] /*Order*/       FORMAT "x(05)" AT 46
    HELP "Show fields in alpha or ~"order~" order."
  qbf[14] /*Undo*/        FORMAT "x(04)" AT 54
    HELP "Undo this session's changes to the field structures."
  qbf[15] /*Exit*/        FORMAT "x(04)" AT 60
    HELP "Exit Field Editor."
  HEADER ""  
  WITH FRAME qbf ATTR-SPACE NO-LABELS NO-BOX
  WIDTH 80 CENTERED 
  ROW SCREEN-LINES - 5.


/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/* FORMS START */ /*-------------------------------------------------------*/

FORM
  namxx[1] FORMAT "x(12)" ATTR-SPACE SPACE(0)
  namxx[2] FORMAT "x(12)"
  namxx[3] FORMAT "x(12)" ATTR-SPACE SPACE(0)
  namxx[4] FORMAT "x(12)"
  namxx[5] FORMAT "x(12)" ATTR-SPACE SPACE(0)
  namxx[6] FORMAT "x(12)"
  WITH FRAME ch6 WIDTH 80 NO-LABELS NO-ATTR-SPACE NO-BOX
  ROW 3 COLUMN 1 xd DOWN USE-TEXT.

FORM
  namxx[1] FORMAT "x(18)" ATTR-SPACE SPACE(0)
  namxx[2] FORMAT "x(18)"
  namxx[3] FORMAT "x(18)" ATTR-SPACE SPACE(0)
  namxx[4] FORMAT "x(18)"
  WITH FRAME ch4 WIDTH 80 NO-LABELS NO-ATTR-SPACE NO-BOX
  ROW 3 COLUMN 1 xd DOWN USE-TEXT.

FORM SPACE
  namxx[1] FORMAT "x(32)" SPACE(2)
  namxx[2] FORMAT "x(32)"
  WITH FRAME ch2 WIDTH 80 NO-LABELS ATTR-SPACE NO-BOX
  ROW 3 COLUMN 1 xd DOWN USE-TEXT.

FORM
  c FORMAT "x(80)" SKIP
  WITH FRAME shadow1 NO-BOX NO-LABELS NO-ATTR-SPACE WIDTH 80 
  ROW 2 COLUMN 1 USE-TEXT.

FORM
  c FORMAT "x(80)" SKIP
  WITH FRAME shadow2 NO-BOX NO-LABELS NO-ATTR-SPACE WIDTH 80 
  ROW SCREEN-LINES - 2 COLUMN 1 USE-TEXT.  


/* FORMS END */ /*---------------------------------------------------------*/

FIND _File "_Field" WHERE _File._Owner = "PUB" NO-LOCK.
IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
  MESSAGE new_lang[17] VIEW-AS ALERT-BOX ERROR BUTTONS OK. /* no permission */
  user_path = "".
  RETURN.
END.
ASSIGN
  alfa-ord    = (IF     user_env[19] = "alpha" THEN TRUE
                ELSE IF user_env[19] = "order" THEN FALSE ELSE alfa-ord)
  romode      = NOT CAN-DO(_Can-write,USERID("DICTDB"))
  odbtyp      = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "odbtyp"
                  }.

FIND _File WHERE RECID(_File) = drec_file.

qbf_block:
DO FOR dfields TRANSACTION ON ERROR UNDO,RETRY:

  { prodict/dictgate.i &action=query &dbtype=user_dbtype &dbrec=? &output=c }
  FIND FIRST dfields OF _File NO-ERROR.
  ASSIGN
    can-add  = INDEX(ENTRY(2,c),"n") > 0
    can-copy = INDEX(ENTRY(2,c),"c") > 0
    xs       = 0 /* initially, must be <>2 and <>4 and <>6 */
    i        = LENGTH(new_lang[14])
    c        = FILL("-",INTEGER(39.0 - i / 2)) + " " + new_lang[14] + " "
             + FILL("-",INTEGER(38.5 - i / 2))
    redraw   = TRUE
    recache  = TRUE
    intrans  = FALSE.
  
  /* Allow add and copy of fields if database is ODBC and file type BUFFER */
  /****** 
    (los 1/3/95) comment out for now - until 7.4. The field editor for
    odbc type databases (_odb_fld.p) was never set up for adding and it
    doesn't work. The user will get stuck right away when they try to enter
    a data type. It was decided that for 7.3, user's could create the
    table (actually view) in the sybase database and then suck it in.
    Rather than allowing add and then having it not work in an obvious way,
    we won't let them add at all.  In 7.4 it should be fixed.
*/
  IF CAN-DO(odbtyp, user_dbtype) AND 
     _File._For-Owner = ?        AND
     _File._For-Name  = "NONAME" AND
     _File._For-Type  = "BUFFER" THEN
        ASSIGN can-add  = yes
               can-copy = yes.
  /******/
               
  /*PAUSE 0.*/
  DISPLAY c WITH FRAME shadow1.
  DISPLAY qbf WITH FRAME qbf.

  qbf_loop:
  DO WHILE TRUE ON ERROR UNDO,RETRY:

    IF recache THEN DO:
      ASSIGN
        redraw  = TRUE
        recache = FALSE
        xm      = 0
        glob    = ""
        glob#   = 0.

      IF alfa-ord THEN
      	get_fields_alpha:
        FOR EACH _Field OF _File BY _Field._Field-name:
      	  IF glob# = 512 THEN DO:
      	     MESSAGE new_lang[24].
      	     LEAVE get_fields_alpha.
      	  END.
          ASSIGN
            glob#       = glob# + 1
            glob[glob#] = _Field._Field-name
            xm          = MAXIMUM(xm,LENGTH(_Field._Field-name)).
        END.
      ELSE
      	get_fields_order:
        FOR EACH _Field OF _File BY _Field._Order:
      	  IF glob# = 512 THEN DO:
      	     MESSAGE new_lang[24].
      	     LEAVE get_fields_order.
      	  END.
          ASSIGN
            glob#       = glob# + 1
            glob[glob#] = _Field._Field-name
            xm          = MAXIMUM(xm,LENGTH(_Field._Field-name)).
        END.
    END.

    IF redraw THEN DO:
      ASSIGN
        i  = xs
        xs = (IF xm <= 12 THEN 6 ELSE IF xm <= 18 THEN 4 ELSE 2)
        c  = FILL("-",78 - LENGTH(new_lang[15] + STRING(glob#)))
           + new_lang[15] + ": " + STRING(glob#).
      IF i <> xs THEN xl = 0. /* if switch frames, reset page number to top */
      DISPLAY c WITH FRAME shadow2.

      IF i = xs THEN .
      ELSE IF i  = 2 THEN CLEAR FRAME ch2 ALL NO-PAUSE.
      ELSE IF i  = 4 THEN CLEAR FRAME ch4 ALL NO-PAUSE.
      ELSE IF i  = 6 THEN CLEAR FRAME ch6 ALL NO-PAUSE.

      IF i = xs THEN .
      ELSE IF i  = 2 THEN HIDE  FRAME ch2     NO-PAUSE.
      ELSE IF i  = 4 THEN HIDE  FRAME ch4     NO-PAUSE.
      ELSE IF i  = 6 THEN HIDE  FRAME ch6     NO-PAUSE.

      IF      xs = 2 THEN VIEW  FRAME ch2.
      ELSE IF xs = 4 THEN VIEW  FRAME ch4.
      ELSE IF xs = 6 THEN VIEW  FRAME ch6.

      IF      xs = 2 THEN UP MAXIMUM(0,FRAME-LINE(ch2) - 1) WITH FRAME ch2.
      ELSE IF xs = 4 THEN UP MAXIMUM(0,FRAME-LINE(ch4) - 1) WITH FRAME ch4.
      ELSE IF xs = 6 THEN UP MAXIMUM(0,FRAME-LINE(ch6) - 1) WITH FRAME ch6.

      ASSIGN
        redraw = FALSE
        xl     = (IF xd * xs > glob# OR xl < 0 THEN 0
                 ELSE MINIMUM(xl,TRUNCATE(glob# / xs,0) * xs))
        j      = xl + 1.
      DO i = 1 TO xd:
        ASSIGN
          namxx[1] = (IF j < 513 THEN glob[j    ] ELSE "")
          namxx[2] = (IF j < 512 THEN glob[j + 1] ELSE "")
          namxx[3] = (IF j < 511 THEN glob[j + 2] ELSE "")
      	  namxx[4] = (IF j < 510 THEN glob[j + 3] ELSE "")
      	  namxx[5] = (IF j < 509 THEN glob[j + 4] ELSE "")
      	  namxx[6] = (IF j < 508 THEN glob[j + 5] ELSE "").

        IF      xs = 6 AND j > glob# THEN CLEAR FRAME ch6 NO-PAUSE.
        ELSE IF xs = 4 AND j > glob# THEN CLEAR FRAME ch4 NO-PAUSE.
        ELSE IF xs = 2 AND j > glob# THEN CLEAR FRAME ch2 NO-PAUSE.
        ELSE IF xs = 6 THEN DISPLAY
          namxx[1] WHEN namxx[1] <> INPUT FRAME ch6 namxx[1]
          namxx[2] WHEN namxx[2] <> INPUT FRAME ch6 namxx[2]
          namxx[3] WHEN namxx[3] <> INPUT FRAME ch6 namxx[3]
          namxx[4] WHEN namxx[4] <> INPUT FRAME ch6 namxx[4]
          namxx[5] WHEN namxx[5] <> INPUT FRAME ch6 namxx[5]
          namxx[6] WHEN namxx[6] <> INPUT FRAME ch6 namxx[6]
          WITH FRAME ch6.  
        ELSE IF xs = 4 THEN DISPLAY
          namxx[1] WHEN namxx[1] <> INPUT FRAME ch4 namxx[1]
          namxx[2] WHEN namxx[2] <> INPUT FRAME ch4 namxx[2]
          namxx[3] WHEN namxx[3] <> INPUT FRAME ch4 namxx[3]
          namxx[4] WHEN namxx[4] <> INPUT FRAME ch4 namxx[4]
          WITH FRAME ch4.
        ELSE DISPLAY
          namxx[1] WHEN namxx[1] <> INPUT FRAME ch2 namxx[1]
          namxx[2] WHEN namxx[2] <> INPUT FRAME ch2 namxx[2]
          WITH FRAME ch2.
        j = j + xs.
        IF i = xd THEN .
        ELSE IF xs = 6 THEN DOWN WITH FRAME ch6.
        ELSE IF xs = 4 THEN DOWN WITH FRAME ch4.
        ELSE                DOWN WITH FRAME ch2.
      END.
    END.

    IF inbrowse THEN DO WHILE TRUE:
      IF      xs = 6 THEN DOWN xr - FRAME-LINE(ch6) WITH FRAME ch6.
      ELSE IF xs = 4 THEN DOWN xr - FRAME-LINE(ch4) WITH FRAME ch4.
      ELSE                DOWN xr - FRAME-LINE(ch2) WITH FRAME ch2.

      IF xs = 6 THEN DO:
        IF INPUT FRAME ch6 namxx[xc] = "" THEN xc = 1.
        COLOR DISPLAY MESSAGES namxx[xc] WITH FRAME ch6.
      END.
      ELSE IF xs = 4 THEN DO:
        IF INPUT FRAME ch4 namxx[xc] = "" THEN xc = 1.
        COLOR DISPLAY MESSAGES namxx[xc] WITH FRAME ch4.
      END.
      ELSE DO:
        IF INPUT FRAME ch2 namxx[xc] = "" THEN xc = 1.
        COLOR DISPLAY MESSAGES namxx[xc] WITH FRAME ch2.
      END.

      READKEY.

      IF      xs = 6 THEN COLOR DISPLAY NORMAL namxx[xc] WITH FRAME ch6.
      ELSE IF xs = 4 THEN COLOR DISPLAY NORMAL namxx[xc] WITH FRAME ch4.
      ELSE                COLOR DISPLAY NORMAL namxx[xc] WITH FRAME ch2.

      qbf# = 0.
      IF KEYFUNCTION(LASTKEY) = "CURSOR-RIGHT"
        AND xl + xr * xs - xs + xc < glob# THEN DO:
        xc = xc + 1.
        IF xc <= xs THEN NEXT.
        ASSIGN xc = 1  qbf# = (IF xr = xd THEN {&NEXT} ELSE {&DOWN}).
      END.
      ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-LEFT"
        AND xl + xr * xs - xs + xc > 1 THEN DO:
        xc = xc - 1.
        IF xc > 0 THEN NEXT.
        ASSIGN xc = xs  qbf# = (IF xr = 1 THEN {&PREV} ELSE {&UP}).
      END.
      ELSE IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN"   THEN qbf# = {&NEXT}.
      ELSE IF KEYFUNCTION(LASTKEY) = "PAGE-UP"     THEN qbf# = {&PREV}.
      ELSE IF KEYFUNCTION(LASTKEY) = "GET"         THEN qbf# = {&SWITCH}.
      ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP"
              AND xr <> 1                          THEN qbf# = {&UP}.
      ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-UP"
              AND xr =  1                          THEN qbf# = {&PREV}.
      ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN"
              AND xr <> xd                         THEN qbf# = {&DOWN}.
      ELSE IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN"
              AND xr =  xd                         THEN qbf# = {&NEXT}.
      ELSE IF LASTKEY > 32 AND CHR(LASTKEY) <> ""  THEN ASSIGN
        hint = hint + CHR(LASTKEY)
        qbf# = {&TYPEDNAM}.
      ELSE IF CAN-DO("END-ERROR,RETURN,GO",KEYFUNCTION(LASTKEY)) THEN DO:
        hint = (IF   xs = 6 THEN INPUT FRAME ch6 namxx[xc]
             ELSE IF xs = 4 THEN INPUT FRAME ch4 namxx[xc]
             ELSE                INPUT FRAME ch2 namxx[xc]).
        FIND dfields OF _File WHERE dfields._Field-name = hint.
        ASSIGN
          hint     = ""
          qbf#     = gobrowse
          inbrowse = FALSE.
        DISPLAY qbf[qbf#] WITH FRAME qbf.
        COLOR PROMPT MESSAGES qbf[qbf#] WITH FRAME qbf.
        STATUS DEFAULT.
        IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN NEXT qbf_loop.
      END.
      IF qbf# > 0 THEN LEAVE.
    END.
    ELSE DO:
      ON CURSOR-LEFT BACK-TAB.
      ON CURSOR-RIGHT     TAB.
      _choose:
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE
         ON STOP  UNDO,LEAVE:  /* Added ON STOP BUG# 98-12-04-003 */
        IF qbf# < 1 OR qbf# > {&EXIT} THEN qbf# = 1.
        IF qbf# >= 1 AND qbf# <= {&EXIT} THEN
      	  NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
        CHOOSE FIELD qbf AUTO-RETURN
          GO-ON ("PAGE-UP" "PAGE-DOWN" "PREV-PAGE" "NEXT-PAGE" PF9 PF15)
          WITH FRAME qbf.
        qbf# = FRAME-INDEX.
        IF LASTKEY = -1 OR  
          (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
          AND NOT qbf[qbf#] BEGINS CHR(LASTKEY)) THEN UNDO,RETRY _choose. 
      END.
      ON CURSOR-LEFT  CURSOR-LEFT.
      ON CURSOR-RIGHT CURSOR-RIGHT.
      /* Trap CTRL-BREAK (STOP).  BUG# 98-12-04-003 */
      IF LASTKEY = -1 THEN
	 RETURN.

      /* NOTE: When QBF_CHANGEs this must be updated to match it. */
      i = LOOKUP(KEYFUNCTION(LASTKEY),
        "PAGE-DOWN,PAGE-UP,,,,,,,,GET,,,,,END-ERROR").
      IF CHR(LASTKEY) = "." THEN qbf# = {&EXIT}.
      IF i > 0 THEN qbf# = i.

      /* NOTE: When QBF_CHANGEs this might need updating. */
      IF qbf# = {&MODIFY} OR qbf# = {&DELETE} OR 
      	 qbf# = {&BROWSE} OR qbf# = {&TRIGS}  OR
      	 qbf# = {&VIEWAS} OR qbf# = {&STRINGATTR} THEN DO:
        IF NOT CAN-FIND(FIRST dfields OF _File) THEN DO:
          MESSAGE new_lang[18]. /* no fields to play with */ 
          NEXT qbf_loop.
        END.
        DISPLAY CAPS(qbf[qbf#]) @ qbf[qbf#] WITH FRAME qbf.
        COLOR PROMPT NORMAL qbf[qbf#] WITH FRAME qbf.

      	/* Reset qbf# temporarily to flag that we should go pick
      	   a field first. */
        ASSIGN
          gobrowse = qbf#
          inbrowse = ? /* signal start of inbrowse */
          qbf#     = {&TYPEDNAM}
          hint     = (IF AVAILABLE dfields THEN dfields._Field-name ELSE "").
        STATUS DEFAULT new_lang[22]. /* use cursor keys or type name */
      END.
    END.

    HIDE MESSAGE NO-PAUSE.

    ASSIGN
      c = KEYFUNCTION(LASTKEY)
      i = (
      	  /* NOTE: When QBF_CHANGEs this might need updating. */
          IF qbf# < {&ADD} OR qbf# > {&STRINGATTR} THEN 0
          ELSE IF _File._Frozen   THEN 23  /* sorry, frozen */
          ELSE IF dict_rog        THEN 12  /* sorry, dict in r/o mode */
          ELSE IF romode          THEN 17  /* sorry, r/o to you */
          ELSE IF qbf# = {&ADD} AND NOT can-add THEN 16 /* cant add flds  */
          ELSE IF qbf# = {&COPY} AND NOT can-copy THEN 7 /* cant copy flds */
          ELSE IF qbf# = {&ADD} AND _File._Db-lang > 0 THEN 5 /* sql tbl */
          ELSE 0).
    IF i > 0 THEN DO:
      MESSAGE new_lang[i]. 
      NEXT qbf_loop.
    END.

    IF qbf# = {&NEXT} THEN DO:    /*-------------------- start of NEXT-PAGE */
      i = MINIMUM(xl + xs * xd,TRUNCATE((glob# - 1)/ xs,0) * xs).
      IF i < 512 THEN
      ASSIGN  
        xl     = i
        xr     = 1
        redraw = TRUE.
    END.
    /*---------------------------------------------------- end of NEXT-PAGE */
    ELSE
    IF qbf# = {&PREV} THEN ASSIGN /*-------------------- start of PREV-PAGE */
      xl     = MAXIMUM(0,xl - xs * xd)
      redraw = TRUE.
    /*---------------------------------------------------- end of PREV-PAGE */
    ELSE
    IF qbf# = {&ADD} THEN DO: /*------------------------------ start of ADD */
      ASSIGN
        answer = TRUE
        rsave  = ?.
      PAUSE 0.
      DO WHILE answer ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        RELEASE dfields.
        { prodict/user/userfchg.i fld r/w ? answer }
        answer = FALSE.
        IF AVAILABLE dfields THEN DO:
          ASSIGN
            answer  = KEYFUNCTION(LASTKEY) <> "END-ERROR"
            intrans = TRUE
            redraw  = TRUE
            recache = TRUE.
          MESSAGE new_lang[20]. /* fld added, add nxt */
          MESSAGE new_lang[21]. /* redraw deferred */
        END.
      END.
    END. /*----------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = {&MODIFY} THEN DO: /*------------------------ start of MODIFY */
      IF _File._Db-lang > 1 THEN MESSAGE new_lang[28].
      ELSE DO:
        ASSIGN
        i       = dfields._Order
        oldname = dfields._Field-name
        oldtype = dfields._Data-type
        rsave = ?.
        PAUSE 0.
        { prodict/user/userfchg.i fld r/w ? answer }
        ASSIGN
      	  newname = dfields._Field-name
          newtype = dfields._Data-type
          intrans = intrans OR answer
          redraw  = NOT AVAILABLE dfields
                    OR oldname <> newname
                    OR (NOT alfa-ord AND i <> dfields._Order)
                    /* date/datetime change */
                    OR (user_dbtype = "ORACLE" AND oldtype NE newtype)
          recache = redraw.
      END.
    END. /*-------------------------------------------------- end of MODIFY */
    ELSE
    IF qbf# = {&DELETE} THEN DO: /*------------------------ start of DELETE */
      ASSIGN
        rsave   = ?
        inview  = AVAILABLE dfields
                  AND CAN-FIND(FIRST _View-ref WHERE
                  _View-ref._Ref-Table = _File._File-name
                  AND _View-ref._Base-Col = dfields._Field-name)
        inindex = AVAILABLE dfields
                  AND CAN-FIND(FIRST _Index-field WHERE
                  _Index-field._Field-recid = RECID(dfields)).
      IF _File._Db-lang > 0 THEN MESSAGE new_lang[4]. /* sorry sql table */
      ELSE IF inview  THEN MESSAGE new_lang[1]. /* in view  */
      ELSE IF inindex THEN MESSAGE new_lang[2]. /* in index */
      ELSE DO:
        answer = FALSE.
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,
          new_lang[3] + ' "' + dfields._Field-name + '"?'). /*r-u-sure*/
        IF answer THEN DELETE dfields.
        ASSIGN
          redraw  = answer
          recache = answer
          intrans = intrans OR answer.
      END.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = {&COPY} THEN DO: /*---------------------------- start of COPY */
      ASSIGN
        rsave   = ?
        recache = TRUE
        redraw  = TRUE.
      RUN "prodict/user/_usrfcpy.p".
      IF user_env[9] = "yes" THEN intrans = TRUE.
    END. /*---------------------------------------------------- end of COPY */
    ELSE
    IF qbf# = {&TRIGS} THEN DO: /*----------------------- start of TRIGGERS */
      rsave = ?.
      PAUSE 0.
      RUN "prodict/user/_usrftrg.p"
      	 (INPUT (romode OR dict_rog OR _File._Frozen), 
      	  INPUT _File._File-Name, 
      	  INPUT-OUTPUT syntax,
      	  OUTPUT answer).
      IF answer THEN intrans = TRUE.
    END. /*------------------------------------------------ end of TRIGGERS */
    ELSE
    IF qbf# = {&VIEWAS} THEN DO: /*----------------------- start of VIEWAS  */
      rsave = ?.
      PAUSE 0.
      CASE dfields._Data-type:
	    WHEN "Character"   THEN dtype = {&DTYPE_CHARACTER}.
	    WHEN "Date"        THEN dtype = {&DTYPE_DATE}.
	    WHEN "Logical"     THEN dtype = {&DTYPE_LOGICAL}.
	    WHEN "Integer"     THEN dtype = {&DTYPE_INTEGER}.
	    WHEN "Decimal"     THEN dtype = {&DTYPE_DECIMAL}.
	    WHEN "RECID"       THEN dtype = {&DTYPE_RECID}.
        WHEN "BLOB"        THEN dtype = {&DTYPE_BLOB}.
        WHEN "CLOB"        THEN dtype = {&DTYPE_CLOB}.
        WHEN "DateTime"    THEN dtype = {&DTYPE_DATETM}.
        WHEN "DateTime-TZ" THEN dtype = {&DTYPE_DATETMTZ}.
      END.

      IF dfields._Data-type = "BLOB" THEN DO:
        MESSAGE "View-As statements can not be created for Blob Fields."
          VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE IF dfields._Data-type = "CLOB" THEN DO:
        MESSAGE "View-As statements can not be created for Clob Fields."
          VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE DO:
        RUN "adecomm/_viewas.p"
      	 (INPUT (romode OR dict_rog OR _File._Frozen), INPUT dtype,
      	  INPUT dfields._Data-type, INPUT-OUTPUT dfields._View-as, 
      	  OUTPUT answer).
        IF answer THEN intrans = TRUE.
      END.
    END. /*------------------------------------------------ end of VIEWAS   */
    ELSE
    IF qbf# = {&GOINDEX} THEN /*------------------------- start of GO-INDEX */
      user_path =  "_usrichg".
      /* see qbf#={&EXIT} */
    /*----------------------------------------------------- end of GO-INDEX */
    ELSE
    IF qbf# = {&STRINGATTR} THEN DO: /*---------------- start of STRINGATTR */
      rsave = ?.
      PAUSE 0.
      IF dfields._Data-type = "BLOB" THEN DO:
        MESSAGE "String attributes can not be created for Blob Fields."
          VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE IF dfields._Data-type = "CLOB" THEN DO:
        MESSAGE "String attributes can not be created for Clob Fields."
          VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE DO:
        RUN "adecomm/_fldsas.p"
      	 (INPUT (romode OR dict_rog OR _File._Frozen), BUFFER dfields,
      	  OUTPUT answer).
        IF answer THEN intrans = TRUE.
      END.
    END. /*---------------------------------------------- end of STRINGATTR */
    ELSE
    IF qbf# = {&SWITCH} THEN /*----------------------- start of SWITCH-FILE */
      user_path = "1=,_usrtget,_usrfchg".  /* see qbf#={&EXIT} */
    /*-------------------------------------------------- end of SWITCH-FILE */
    ELSE
    IF qbf# = {&BROWSE} THEN DO: /*------------------------ start of BROWSE */
      rsave = ?.
      PAUSE 0.
      { prodict/user/userfchg.i fld r/o ? answer }
      
      IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
        DISPLAY CAPS(qbf[{&BROWSE}]) @ qbf[{&BROWSE}] WITH FRAME qbf.
        COLOR PROMPT NORMAL qbf[{&BROWSE}] WITH FRAME qbf.
        ASSIGN
          gobrowse = {&BROWSE}
          inbrowse = ? /* signal start of inbrowse */
          qbf#     = {&TYPEDNAM}
          hint     = (IF AVAILABLE dfields THEN dfields._Field-name ELSE "").
        STATUS DEFAULT new_lang[22]. /* use cursor keys or type name */
      END.
    END. /*-------------------------------------------------- end of BROWSE */
    ELSE
    IF qbf# = {&ORDER} THEN DO: /*-------------------- start of ALPHA/ORDER */
      ASSIGN
	recache  = TRUE
	redraw   = TRUE
	alfa-ord = NOT alfa-ord.
      message new_lang[25] (IF alfa-ord THEN new_lang[26] ELSE new_lang[27]).
    END.
    /*-------------------------------------------------- end of ALPHA/ORDER */
    ELSE
    IF qbf# = {&UNDO} THEN DO: /*---------------------------- start of UNDO */
      IF intrans THEN DO:
        ASSIGN
          recache = TRUE
          redraw  = TRUE
          answer  = FALSE.
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,INPUT new_lang[6]). /*undo sess?*/
        IF answer THEN UNDO qbf_block,RETRY qbf_block.
      END.
      ELSE
        MESSAGE new_lang[19]. /* what changes? */
    END. /*---------------------------------------------------- end of UNDO */
    /* no ELSE here! */
    IF qbf# = {&GOINDEX} OR qbf# = {&SWITCH} OR
       qbf# = {&EXIT} THEN DO: /*---------------------------- start of EXIT */
      LEAVE qbf_block.
    END. /*---------------------------------------------------- end of EXIT */
    /*--------------------------------------------------------- end of EXIT */
    ELSE
    IF qbf# = {&UP} THEN DO: /*------------------------- start of CURSOR-UP */
      IF xr = 1 AND xl > 0 THEN DO:
        xl = xl - xs.
        IF      xs = 6 THEN SCROLL DOWN WITH FRAME ch6.
        ELSE IF xs = 4 THEN SCROLL DOWN WITH FRAME ch4.
        ELSE IF xs = 2 THEN SCROLL DOWN WITH FRAME ch2.
      END.
      ELSE
      IF xr > 1 THEN xr = xr - 1.
    END. /*----------------------------------------------- end of CURSOR-UP */
    ELSE
    IF qbf# = {&DOWN} THEN DO: /*--------------------- start of CURSOR-DOWN */
      IF xr = xd AND xl + xr * xs + xc <= glob# THEN DO:
        xl = xl + xs.
        IF      xs = 6 THEN SCROLL UP WITH FRAME ch6.
        ELSE IF xs = 4 THEN SCROLL UP WITH FRAME ch4.
        ELSE IF xs = 2 THEN SCROLL UP WITH FRAME ch2.
      END.
      ELSE
      IF xl + xr * xs + xc <= glob# THEN xr = xr + 1.
    END. /*--------------------------------------------- end of CURSOR-DOWN */

    /* no ELSE here! Navigate amongst the field names by typing. */
    IF qbf# = {&TYPEDNAM} THEN DO: /*------------------ start of TYPED-HINT */
      rsave = RECID(dfields).
      FIND FIRST dfields OF _File
        WHERE dfields._Field-name BEGINS hint NO-ERROR.
      IF NOT AVAILABLE dfields AND hint <> "" THEN DO:
        hint = SUBSTRING(hint,LENGTH(hint),1).
        FIND FIRST dfields OF _File
          WHERE dfields._Field-name BEGINS hint NO-ERROR.
      END.
      IF NOT AVAILABLE dfields AND rsave <> ? THEN
        FIND dfields WHERE RECID(dfields) = rsave.
      IF AVAILABLE dfields THEN
        DO i = 1 TO glob# WHILE glob[i] <> dfields._Field-name: END.
      ELSE
        i = 1.
      IF i >= xl + 1 AND i < xl + xd * xs THEN
        ASSIGN
          xr = TRUNCATE((i - xl + xs - 1) / xs,0)
          xc = i - xl - xr * xs + xs.
      ELSE
        ASSIGN
          redraw = TRUE
          xl     = TRUNCATE((i - 1) / xs,0) * xs
          xr     = 1
          xc     = i - xl - xr * xs + xs.
      /* inbrowse = ? means initial pass to set up position */
      IF inbrowse = ? THEN ASSIGN inbrowse = TRUE hint = "".
    END. /*---------------------------------------------- end of TYPED-HINT */

  END. /* loop end */
END. /* scope end */

HIDE FRAME ch2     NO-PAUSE.
HIDE FRAME ch4     NO-PAUSE.
HIDE FRAME ch6     NO-PAUSE.
HIDE FRAME qbf     NO-PAUSE.
HIDE FRAME shadow1 NO-PAUSE.
HIDE FRAME shadow2 NO-PAUSE.

ASSIGN
  dict_dirty   = dict_dirty OR intrans
  user_env[19] = STRING(alfa-ord,"alpha/order").

RETURN.


&ENDIF


