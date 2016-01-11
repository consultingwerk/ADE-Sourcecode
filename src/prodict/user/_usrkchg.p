/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/* userkchg - Sequence Editor */
/* HISTORY:
   
   Modified on 07/08/94 by gfs      Fixed 94-06-28-033
               08/08/02 D. McMann  Eliminated any sequences whose name begins "$" - Peer Direct
               05/25/06 fernando   Support for 64-bit sequences    
*/
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/*
+----------------------------------++------------------------------------------+
| 12345678901234567890123456789012 ||                                          |
| 12345678901234567890123456789012 || Name: x(32)___________________________   |
| 12345678901234567890123456789012 ||                                          |
| 12345678901234567890123456789012 || Initial Value: ->,>>>,>>>,>>>,>>>,>>>,>>9|
| 12345678901234567890123456789012 ||  Increment By: ->,>>>,>>>,>>>,>>>,>>>,>>9|
| 12345678901234567890123456789012 ||   Upper Limit: ->,>>>,>>>,>>>,>>>,>>>,>>9|
| 12345678901234567890123456789012 || Current Value: ->,>>>,>>>,>>>,>>>,>>>,>>9|
| 12345678901234567890123456789012 ||                                          |
| 12345678901234567890123456789012 || Cycle at Limit: no                       |
| 12345678901234567890123456789012 ||                                          |
| 12345678901234567890123456789012 ||DataServer Name: ->,>>>,>>>,>>9           |
| 12345678901234567890123456789012 ||          Owner: ->,>>>,>>>,>>9           |
+----------------------------------++-1234567890123456789012345678901234567890-+

   [Next] [Prev] [>NextPage] [<PrevPage] [First] [Last] [Add] [Modify]
   [Delete] [Undo] [Exit]

Modified: 07/14/98 D. McMann Added _Owner to _File finds
          01/11/00 D. McMann Added display of b_seq._seq-name to NEXT & PREV
                             19990820-003
          07/01/02 D. McMann Added assignment of dict_dirty for on-line schema add.
          05/25/06 fernando  Added support for 64-bit sequences
*/
&IF "{&WINDOW-SYSTEM}" = "TTY"
&THEN
DEFINE BUFFER b_Seq FOR _Sequence.

DEFINE VARIABLE answer    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i         AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE j         AS INTEGER               NO-UNDO.
DEFINE VARIABLE in_trans  AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE qbf#      AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE qbf#list  AS CHARACTER             NO-UNDO.
DEFINE VARIABLE redraw    AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE adding    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE limit     AS INT64                 NO-UNDO.
DEFINE VARIABLE large_seq AS LOGICAL               NO-UNDO.
DEFINE VARIABLE curr_value AS CHARACTER            NO-UNDO.
DEFINE VARIABLE c_not_largeseq AS CHARACTER        NO-UNDO.
DEFINE VARIABLE ctemp          AS CHARACTER            NO-UNDO.

/* Recid of sequence whose properties are showing (disp) and recid of
   the selected sequence in the list (rec). */
DEFINE VARIABLE qbf_disp AS RECID   INITIAL ?     NO-UNDO.
DEFINE VARIABLE qbf_rec  AS RECID                 NO-UNDO.

/* qbf_was is where the selection was before the last function was executed.*/
DEFINE VARIABLE qbf_was  AS INTEGER INITIAL 2     NO-UNDO.


DEFINE VARIABLE qbf AS CHARACTER EXTENT 11 NO-UNDO INITIAL [
  "Next", "Prev",   ">NextPage", "<PrevPage", "First", "Last",
  "Add",  "Modify", "Delete",   "Undo",    "Exit"
].

&global-define  NEXT         1
&global-define  PREV         2
&global-define  NEXTPG        3
&global-define  PREVPG        4
&global-define  FIRST        5
&global-define  LAST         6
&global-define  ADD          7
&global-define  MODIFY        8
&global-define  DELETE        9
&global-define  UNDO        10
&global-define  EXIT        11

FORM
  b_Seq._Seq-Name NO-LABEL
  WITH FRAME seq-browse ROW 2 COLUMN 1 12 DOWN ATTR-SPACE
  TITLE " Sequence Names ".

FORM SKIP(1)
  b_Seq._Seq-Name  AT 2     LABEL "Name"            SKIP(1)
  b_Seq._Seq-Init  COLON 15 LABEL "Initial Value" 
                            FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9" SKIP
  b_Seq._Seq-Incr  COLON 15 LABEL "Increment By"  
                            FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9" SKIP
  limit            COLON 15 LABEL "Upper Limit"   
                            FORMAT "->,>>>,>>>,>>>,>>>,>>>,>>9" SKIP
  curr_value      COLON 15 LABEL "Current Value" FORMAT "X(26)" SKIP(1)
  b_Seq._Cycle-Ok  COLON 16 LABEL "Cycle at limit"  SKIP(1)
  b_Seq._Seq-misc[1]   COLON 16 LABEL "DataServer Name" SKIP
  b_Seq._Seq-misc[2]   COLON 16 LABEL "Owner"           SKIP
  WITH FRAME seq-detail ROW 2 COLUMN 37 SIDE-LABELS
  TITLE " Sequence Attributes ".

FORM
  qbf[ 1] /*Next*/          FORMAT "x(4)":u
    HELP "Look at the next sequence."
  qbf[ 2] /*Prev*/          FORMAT "x(4)":u
    HELP "Look at the previous sequence."
  qbf[ 3] /*NextPage*/      FORMAT "x(9)":u
    HELP "Look at the next set of sequences."
  qbf[ 4] /*PrevPage*/      FORMAT "x(9)":u
    HELP "Look at the previous set of sequence."
  qbf[ 5] /*First*/         FORMAT "x(5)":u
    HELP "Look at the first sequence."
  qbf[ 6] /*Last*/          FORMAT "x(4)":u 
    HELP "Look at the last sequence." 
  qbf[ 7] /*Add*/        FORMAT "x(03)":u
    HELP "Add a new sequence."
  qbf[ 8] /*Modify*/     FORMAT "x(06)":u
    HELP "Update or Rename a sequence."
  qbf[ 9] /*Delete*/     FORMAT "x(06)":u
    HELP "Remove a sequence."
  qbf[10] /*Undo*/       FORMAT "x(04)":u
    HELP "Undo this session's changes to the sequence structures."
  qbf[11] /*Exit*/       FORMAT "x(04)":u
    HELP "Exit sequence Editor."
  HEADER ""
  WITH FRAME qbf ATTR-SPACE NO-LABELS NO-BOX 
  ROW SCREEN-LINES - 4 CENTERED.

DEFINE VARIABLE capab    AS CHARACTER NO-UNDO.

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /* 1*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 2*/ "You do not have permission to use this option.",
  /* 3*/ "Are you sure that you want to remove the definition for sequence ",
  /* 4*/ "Undo all changes since entering the sequence editor?",
  /* 5*/ "You have reached the last sequence in the table.",
  /* 6*/ "You have reached the first sequence in the table.",
  /* 7*/ "That sequence name is already used or is not a valid identifier.",
  /* 8*/ "You haven't yet made changes that need to be undone!",
  /* 9*/ "This function is inappropriate when there are no sequences.",
  /*10*/ "A sequence with this name already exists in this database",
  /*11*/ "This function is not supported for this database type",
  /*12*/ "has an invalid value"
].

/*===============================Triggers===================================*/

/*----- LEAVE of NAME FIELD -----*/
on leave of b_Seq._Seq-Name in frame seq-detail
do:
   Define var okay as logical.
   Define var name as char.

   name = TRIM (SELF:screen-value). 

   /* If editing and the name hasn't been changed from what it started as,
      do nothing. */ 
   if NOT adding AND LC(b_Seq._Seq-Name) = LC(name) then
      return.

   RUN "adecomm/_valname.p":u (INPUT name, INPUT no, OUTPUT okay).
   IF NOT okay THEN 
      return NO-APPLY.
   ELSE
      SELF:SCREEN-VALUE = name.  /* Reset the trimmed value */

   /* Make sure there isn't already an object with this name. */
   IF CAN-FIND (_Sequence where _Sequence._Seq-Name = name) THEN DO:
      message new_lang[10].  /* Duplicate name */
      RETURN NO-APPLY.
   END.

   HIDE MESSAGE NO-PAUSE.
   /* message to let the user know that 64-bit sequence support is not on */
   IF c_not_largeseq NE "" THEN
      MESSAGE c_not_largeseq.

end.

/*----- LEAVE of INITIAL VALUE -----*/
on leave of b_Seq._Seq-Init in frame seq-detail
do:
    Define var iValue as int64 NO-UNDO.
    DEFINE VAR IntVal AS INTEGER NO-UNDO.

    /* large_seq can be ? for pre-101b dbs */
    IF large_seq NE YES THEN DO:
        intVal = INT(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        iValue = int64(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.

   HIDE MESSAGE NO-PAUSE.
   /* message to let the user know that 64-bit sequences support is not on */
   IF c_not_largeseq NE "" THEN
      MESSAGE c_not_largeseq.
end.

/*----- LEAVE of LIMIT -----*/
on leave of limit in frame seq-detail
do:
    Define var iValue as int64 NO-UNDO.
    DEFINE VAR IntVal AS INTEGER NO-UNDO.

    /* large_seq can be ? for pre-101b dbs */
    IF large_seq NE YES THEN DO:
        intVal = INT(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        iValue = int64(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.

   HIDE MESSAGE NO-PAUSE.
   /* message to let the user know that 64-bit sequences support is not on */
   IF c_not_largeseq NE "" THEN
      MESSAGE c_not_largeseq.
end.

/*----- LEAVE of INCREMENT -----*/
on leave of b_Seq._Seq-Incr in frame seq-detail
do:
   Define var incr as DECIMAL NO-UNDO.
   Define var iValue as int64 NO-UNDO.
   DEFINE VAR IntVal AS INTEGER NO-UNDO.

   incr = DECIMAL(b_Seq._Seq-Incr:SCREEN-VALUE).

   if incr = 0 then
   do:
      message "Increment can be negative or positive but not 0.".
      return NO-APPLY.
   end.

    /* large_seq can be ? for pre-101b dbs */
    IF large_seq NE YES THEN DO:
        intVal = INT(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.
    ELSE DO:
        iValue = int64(SELF:SCREEN-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1).
            RETURN NO-APPLY.
        END.
    END.

   if incr < 0 then
      limit:LABEL in frame seq-detail = "Lower Limit".
   else 
      limit:LABEL in frame seq-detail = "Upper Limit".
  
   HIDE MESSAGE NO-PAUSE.
   /* message to let the user know that 64-bit sequences support is not on */
   IF c_not_largeseq NE "" THEN
      MESSAGE c_not_largeseq.

end.


/*----- ON GO -----*/
ON GO of FRAME seq-detail 
do:
   Define var incr as int64 NO-UNDO.
   Define var lmt  as int64 NO-UNDO.
   Define var init as int64 NO-UNDO.

   do ON ERROR UNDO, LEAVE:
      assign
         incr = input frame seq-detail b_Seq._Seq-Incr
         init = input frame seq-detail b_Seq._Seq-Init
         lmt  = input frame seq-detail limit.
   
      if incr > 0 then
      do:
         if lmt <= init then
         do:
            message "The upper limit must be greater than the initial value.".
            apply "ENTRY":u to b_Seq._Seq-Init in FRAME seq-detail.
            RETURN NO-APPLY.
         end.
      end.
      else /* _Seq-Incr < 0 */
      do:
         if lmt >= init then
         do:
            message "The lower limit must be less than the initial value.".
            apply "ENTRY":u to b_Seq._Seq-Init in FRAME seq-detail.
            return NO-APPLY.
         end.
      end.
      return.
   end.
   return NO-APPLY.  /* an error occurred on assign */
end.



/*==========================Internal Procedures=============================*/

/*-------------------------------------------------------------------
   Add or modify a sequence and perform all necessary validation.

   Output Parameter: 
      p_Okay - Set to true if transaction was successful.
-------------------------------------------------------------------*/
    
PROCEDURE Add_Modify:

   DEFINE OUTPUT PARAMETER p_Okay AS LOGICAL NO-UNDO.

   DO ON ERROR UNDO,RETRY ON ENDKEY UNDO, LEAVE:
      if adding then
      do:   /*--------- creating new sequence ---------*/
               CREATE b_Seq.
               ASSIGN
                  b_Seq._Db-recid = drec_db
                  limit = b_Seq._Seq-Max
                  limit:LABEL in FRAME seq-detail = "Upper Limit".

               DISPLAY "" @ b_Seq._Seq-Name
                 b_Seq._Seq-Init 
                       b_Seq._Seq-Incr
                       limit
                 b_Seq._Cycle-Ok
                   "" @ curr_value
                       WITH FRAME seq-detail.
         SET
            b_Seq._Seq-Name
            b_Seq._Seq-Init 
                  b_Seq._Seq-Incr
            limit
            b_Seq._Cycle-Ok
            WITH FRAME seq-detail.
         ASSIGN dict_dirty = TRUE.
      end.
      else do:  /*--------- updateing existing sequence ---------*/
               if b_Seq._Seq-Incr > 0 then 
                  ASSIGN
                     limit:LABEL in FRAME seq-detail = "Upper Limit"
                     limit = b_Seq._Seq-Max.
               else
                  ASSIGN
                     limit:LABEL in FRAME seq-detail = "Lower Limit"
                     limit = b_Seq._Seq-Min.

        IF INDEX(capab,"m":u) <> 0 
          THEN DO:
            IF INDEX(capab,"r":u) <> 0 
              THEN UPDATE
                b_Seq._Seq-Name
                b_Seq._Seq-Init 
                b_Seq._Seq-Incr
                limit
                b_Seq._Cycle-Ok
                WITH FRAME seq-detail.
              ELSE UPDATE
                b_Seq._Seq-Init 
                b_Seq._Seq-Incr
                limit
                b_Seq._Cycle-Ok
                WITH FRAME seq-detail.
            END.
           ELSE DO:     /* modifying anything but name not allowed */
            IF INDEX(capab,"r":u) <> 0 
              THEN UPDATE
                b_Seq._Seq-Name
                WITH FRAME seq-detail.
          /*  ELSE no modification is alowed at all */
            END.
                  
      end.

      if b_Seq._Seq-Incr > 0 then
               ASSIGN
                  b_Seq._Seq-Max = limit
            b_Seq._Seq-Min = b_Seq._Seq-Init.
      else 
               ASSIGN
                  b_Seq._Seq-Min = limit
            b_Seq._Seq-Max = b_Seq._Seq-Init.
   
      p_Okay = true.
     dict_dirty = TRUE.

      return.
   END.

   p_Okay = false.
END.


/*==============================Mainline Code=============================*/

FIND _File "_Sequence":u WHERE _File._Owner = "PUB" NO-LOCK.
IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
  MESSAGE new_lang[7] VIEW-AS ALERT-BOX ERROR BUTTONS OK.  /* No permission */
  user_path = "".
  RETURN.
END.

/* check if this db supports 64-bit sequences 
   just care about large_seq really.
   
   
   Pass the DICTDB name since that for non-OE schemas, we will know if
   it is turned on of it's on for the schema holder.
*/
RUN prodict/user/_usrinf3.p 
      (INPUT  LDBNAME("DICTDB"),
       INPUT  "PROGRESS",
       OUTPUT cTemp, 
       OUTPUT cTemp,
       OUTPUT large_seq,
       OUTPUT answer).

/* dbs running with pre-10.01B servers will have no knowledge of 64-bit sequences,
   so don't need to display message (in which case large_seq = ?)
*/
IF large_seq NE NO THEN
   ASSIGN c_not_largeseq = "".
ELSE 
   ASSIGN c_not_largeseq = "64-bit sequences support not enabled".

DO WITH FRAME seq-detail:
    /* alter format if 64-bit sequences support it not turned on */
    /* don't resize fill-in */
    IF large_seq NE YES THEN
        ASSIGN b_Seq._Seq-Init:AUTO-RESIZE = NO
               b_Seq._Seq-Incr:AUTO-RESIZE = NO
               limit:AUTO-RESIZE = NO
               b_Seq._Seq-Init:FORMAT = "->,>>>,>>>,>>9"
               b_Seq._Seq-Incr:FORMAT = "->,>>>,>>>,>>9"
               limit:FORMAT = "->,>>>,>>>,>>9".
END.

{prodict/dictgate.i
    &action = "query"
    &output = "capab"
    &dbrec  = "?"
    &dbtype = "user_dbtype"
    }
assign capab = ENTRY(10,capab).
IF INDEX(capab,"s":u) = 0 
  THEN DO:
    MESSAGE
      "This DataServer does not support sequences"
      view-as alert-box.
    RETURN.
    END.
   
/* There is an entry in qbf#list for each available option.  If there is
   some reason that an option is unavailable, store the message # (new_lang
   index) there which will be displayed when that option is chosen.
*/
qbf#list = "0,0,0,0,0,0,":u
         + ( IF dict_rog THEN "1":u ELSE
            (IF NOT CAN-DO(_Can-create ,USERID("DICTDB":u)) THEN "2":u ELSE
            (IF INDEX(capab,"a":u) = 0 THEN "11":u ELSE "0":u)))
         + ",":u +
           ( IF dict_rog THEN "1":u ELSE
            (IF NOT CAN-DO(_Can-write,USERID("DICTDB":u)) THEN "2":u ELSE 
            (IF (INDEX(capab,"m":u) = 0 AND INDEX(capab,"r":u) = 0 )THEN "11":u ELSE "0":u)))
         + ",":u +
           ( IF dict_rog THEN "1":u ELSE
            (IF NOT CAN-DO(_Can-delete,USERID("DICTDB":u)) THEN "2":u ELSE 
            (IF INDEX(capab,"d":u) = 0 THEN "11":u ELSE "0":u)))
         + ",0,0":u.

PAUSE 0.
VIEW FRAME seq-browse.
VIEW FRAME seq-detail.

/* message to let the user know that 64-bit sequences support is not on */
IF c_not_largeseq NE "" THEN
   MESSAGE c_not_largeseq.

qbf_block:
DO TRANSACTION ON ERROR UNDO,RETRY:

  qbf_inner:
  DO WHILE TRUE WITH FRAME seq-browse:

    qbf_rec = RECID(b_Seq).

    IF redraw THEN DO:
      DISPLAY qbf WITH FRAME qbf.

      ASSIGN
        qbf_disp = ?
        redraw   = FALSE.

      IF qbf_rec <> ? THEN 
        /* This doesn't make any sense - this record should already be
                 in the buffer - but w.o it things don't work right! */
        FIND b_Seq WHERE RECID(b_Seq) = qbf_rec NO-ERROR.
      ELSE DO:
              FIND FIRST b_Seq where b_Seq._Db-recid = drec_db 
                                 AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
              qbf_rec = RECID(b_Seq).
      END.

      /* Display the list of sequences. j will end up being the current
               iteration (FRAME-LINE) and i is a fudge factor for when you
         run off the top of the list.
      */
      ASSIGN
        j = (IF FRAME-LINE = 0 THEN 1 ELSE FRAME-LINE)
        i = 3.
      UP j - 1.
      IF j > 1 THEN DO i = 2 TO j WHILE AVAILABLE b_Seq:
        FIND PREV b_Seq where b_Seq._Db-recid = drec_db
                          AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      END.
      IF NOT AVAILABLE b_Seq THEN DO:
        FIND FIRST b_Seq where b_Seq._Db-recid = drec_db
                           AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
        j = i - 2.
      END.

      DO i = 1 TO FRAME-DOWN(seq-browse):
        /* This avoids displays when the value we want is already there */
        IF INPUT FRAME seq-browse b_Seq._Seq-Name =
                (IF AVAILABLE b_Seq THEN b_Seq._Seq-Name ELSE "")
        THEN .
        ELSE IF AVAILABLE b_Seq THEN
          DISPLAY b_Seq._Seq-Name WITH FRAME seq-browse.
        ELSE
          CLEAR FRAME seq-browse NO-PAUSE.  
        COLOR DISPLAY
          VALUE(IF RECID(b_Seq) = qbf_rec AND RECID(b_Seq) <> ?
          THEN "MESSAGES":u ELSE "NORMAL":u) b_Seq._Seq-Name.
        DOWN.
        IF AVAILABLE b_Seq THEN FIND NEXT b_Seq 
                where b_Seq._Db-recid = drec_db 
                  AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      END.
      IF qbf_rec <> ? THEN
              /* Reset the b_Seq buffer to the one that's highlit. */
        FIND b_Seq WHERE RECID(b_Seq) = qbf_rec 
                     AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      UP FRAME-DOWN - j + 1.
    END.
   
    /* Reset the selection indicator. qbf_was is where the selection was
       before the last function was executed.  This tells us which item
       to clear the color on and then we can reset the selection to 
       FRAME-LINE.
    */       
    IF qbf_was <> FRAME-LINE THEN DO:
      i = FRAME-LINE.
      DOWN qbf_was - i.
      COLOR DISPLAY NORMAL b_Seq._Seq-Name.
      DOWN i - qbf_was.
      IF qbf_rec <> ? THEN COLOR DISPLAY MESSAGES b_Seq._Seq-Name.
      qbf_was = FRAME-LINE.  
    END.
    /* Display info on the first sequence. */
    IF AVAILABLE b_Seq AND qbf_disp <> RECID(b_Seq) THEN DO:
      if b_Seq._Seq-Incr < 0 then
               limit:LABEL in frame seq-detail = "Lower Limit".
      else 
               limit:LABEL in frame seq-detail = "Upper Limit".

      /* get current value of sequence, for Progress db only */
      IF INDEX(capab,"n":u) = 0 THEN DO:
          ASSIGN curr_value = ""
                 /* if sequence was just created, this will fail so need to specify NO-ERROR */
                 curr_value = TRIM(STRING(DYNAMIC-CURRENT-VALUE(b_Seq._Seq-Name, "DICTDB"),"->,>>>,>>>,>>>,>>>,>>>,>>9")) NO-ERROR.
      END.

      DISPLAY
        b_Seq._Seq-Name  
              b_Seq._Seq-Init  
        b_Seq._Seq-Incr
        (if b_Seq._Seq-Incr > 0 then b_Seq._Seq-Max else b_Seq._Seq-Min)
                  @ limit
        b_Seq._Cycle-Ok
        (IF INDEX(capab,"n":u) = 0 THEN curr_value ELSE "n/a") @ curr_value
        (IF INDEX(capab,"n":u) = 0 THEN "n/a" ELSE b_Seq._Seq-misc[1])
                  @ b_Seq._Seq-misc[1]
        (IF INDEX(capab,"o":u) = 0 THEN "n/a" ELSE b_Seq._Seq-misc[2])
                  @ b_Seq._Seq-misc[2]
        WITH FRAME seq-detail.
    END.
    qbf_disp = RECID(b_Seq).

    /* Allow the user to select from the list of options (from qbf array) */
    ON CURSOR-LEFT BACK-TAB.
    ON CURSOR-RIGHT     TAB.

    _choose:
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf# > {&EXIT} THEN qbf# = qbf# - {&EXIT}. 
      IF qbf# >= 1 AND qbf# <= {&EXIT} THEN
        NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
      CHOOSE FIELD qbf PAUSE (IF qbf_disp = RECID(b_Seq) THEN ? ELSE 0)
        NO-ERROR AUTO-RETURN
        GO-ON ("CURSOR-UP" "CURSOR-DOWN" "PAGE-DOWN" "PAGE-UP") 
        WITH FRAME qbf.
      qbf# = FRAME-INDEX.

      /* If key is an ascii character but does not match the first letter of
               any function, do nothing and retry.  If the user presses ".",
               FRAME-INDEX will be the current index value (so we will
               execute the highlit function).
      */
      IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY)  AND CHR(LASTKEY) <> ".":u 
        AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN UNDO,RETRY _choose.
   
    END.

    ON CURSOR-LEFT  CURSOR-LEFT.
    ON CURSOR-RIGHT CURSOR-RIGHT.

    /* Map function keys to sequence editor options. */
    i = LOOKUP(KEYFUNCTION(LASTKEY),
        "CURSOR-DOWN,CURSOR-UP,PAGE-DOWN,PAGE-UP,,,,,,,END-ERROR":u).
    IF i > 0 THEN DO:
      COLOR DISPLAY NORMAL qbf[qbf#] WITH FRAME qbf. 
      qbf# = i.
    END.
                  
    HIDE MESSAGE NO-PAUSE.
    /* message to let the user know that 64-bit sequences support is not on */
    IF c_not_largeseq NE "" THEN
       MESSAGE c_not_largeseq.

    /* Only add, undo and exit are appropriate when there are no sequences. */
    IF (NOT AVAILABLE b_Seq AND
        qbf# <> {&ADD} AND qbf# <> {&UNDO} AND qbf# <> {&EXIT}) THEN
    DO:
      MESSAGE new_lang[9]. /* inappropriate function */
      NEXT.
    END.

    IF ENTRY(qbf#,qbf#list) <> "0":u THEN DO:
      MESSAGE new_lang[INTEGER(ENTRY(qbf#,qbf#list))]. /* not allowed */

      NEXT.
    END.

    redraw = qbf# > 2.

    IF qbf# = {&NEXT} THEN DO: /*----------------------------- start of NEXT */
      FIND NEXT b_Seq where b_Seq._Db-recid = drec_db
                        AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      IF NOT AVAILABLE b_Seq THEN DO:
        FIND LAST b_Seq where b_Seq._Db-recid = drec_db 
                          AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
        MESSAGE new_lang[5].  /* last sequence */
      END.
      ELSE DO:
        IF FRAME-LINE = FRAME-DOWN THEN DO:
                /* subtract 1 since when we scroll up the selection indicator goes
                   with it. This will cause the highlight fixup code to be executed
                   to reset the highlight to the last line.
                */
          qbf_was = qbf_was - 1. 
          SCROLL UP.
              END.
        ELSE
          DOWN.
        DISPLAY b_Seq._Seq-Name WITH FRAME seq-browse.
      END.
    END. /*---------------------------------------------------- end of NEXT */
    ELSE
    IF qbf# = {&PREV} THEN DO: /*---------------------------- start of PREV */
      FIND PREV b_Seq where b_Seq._Db-recid = drec_db 
                        AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      IF NOT AVAILABLE b_Seq THEN DO:
        FIND FIRST b_Seq where b_Seq._Db-recid = drec_db 
                           AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
        MESSAGE new_lang[6].  /* first sequence */
      END.
      ELSE DO:
        IF FRAME-LINE = 1 THEN DO:
                /* add 1 since when we scroll down the selection indicator goes
                   with it. This will cause the highlight fixup code to be executed
                   to reset the highlight to the first line.
                */
                qbf_was = qbf_was + 1.
          SCROLL DOWN.
        END.
        ELSE
          UP.
        DISPLAY b_Seq._Seq-Name WITH FRAME seq-browse.
      END.
    END. /*---------------------------------------------------- end of PREV */
    ELSE
    IF qbf# = {&NEXTPG} THEN DO: /*---------------------- start of NEXTPAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE b_Seq:
        FIND NEXT b_Seq where b_Seq._Db-recid = drec_db 
                          AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      END.
      IF NOT AVAILABLE b_Seq THEN DO:
        DOWN FRAME-DOWN - FRAME-LINE.
        FIND LAST b_Seq where b_Seq._Db-recid = drec_db 
                          AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      END.
    END. /*------------------------------------------------ end of NEXTPAGE */
    ELSE
    IF qbf# = {&PREVPG} THEN DO: /*---------------------- start of PREVPAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE b_Seq:
        FIND PREV b_Seq where b_Seq._Db-recid = drec_db 
                          AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      END.
      IF NOT AVAILABLE b_Seq THEN DO:
        FIND FIRST b_Seq where b_Seq._Db-recid = drec_db
                           AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
        UP FRAME-LINE - 1.
      END.
    END. /*------------------------------------------------ end of PREVPAGE */
    ELSE
    IF qbf# = {&FIRST} THEN DO: /*-------------------------- start of FIRST */
      FIND FIRST b_Seq where b_Seq._Db-recid = drec_db 
                         AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      qbf_rec = RECID(b_Seq).
      UP FRAME-LINE - 1.
    END. /*--------------------------------------------------- end of FIRST */
    ELSE
    IF qbf# = {&LAST} THEN DO: /*---------------------------- start of LAST */
      FIND LAST b_Seq where b_Seq._Db-recid = drec_db 
                        AND NOT b_Seq._Seq-name BEGINS "$" NO-ERROR.
      qbf_rec = RECID(b_Seq).
      DOWN FRAME-DOWN - FRAME-LINE.
    END. /*--------------------------------------------------- end of LAST */
    ELSE
    IF qbf# = {&ADD} THEN DO: /*------------------------------ start of ADD */
      COLOR DISPLAY NORMAL b_Seq._Seq-Name.
      adding = TRUE.
      RUN ADD_MODIFY (OUTPUT answer).
      HIDE MESSAGE NO-PAUSE.
      /* message to let the user know that 64-bit sequences support is not on */
      IF c_not_largeseq NE "" THEN
         MESSAGE c_not_largeseq.

      IF answer THEN DO:
              DOWN FRAME-DOWN - FRAME-LINE.
              in_trans = TRUE.
      END.
    END. /*----------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = {&MODIFY} THEN DO: /*------------------------ start of MODIFY */
      adding = false.
      RUN ADD_MODIFY (OUTPUT answer).
      HIDE MESSAGE NO-PAUSE.
      /* message to let the user know that 64-bit sequences support is not on */
      IF c_not_largeseq NE "" THEN
         MESSAGE c_not_largeseq.

      IF answer THEN DO:
               ASSIGN
            redraw   = b_Seq._Seq-Name ENTERED
            in_trans = TRUE.
      END.
    END. /*-------------------------------------------------- end of MODIFY */
    ELSE
    IF qbf# = {&DELETE} THEN DO ON ERROR UNDO,LEAVE: /*---- start of DELETE */
      answer = FALSE. /* are you sure... delete? */
      RUN "prodict/user/_usrdbox.p":u
        (INPUT-OUTPUT answer,?,?,
          new_lang[3] + b_Seq._Seq-Name + '"?').
      IF answer THEN DELETE b_Seq.
      in_trans = in_trans OR answer.
      dict_dirty = TRUE.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = {&UNDO} THEN DO: /*---------------------------- start of UNDO */
      IF in_trans THEN DO:
        answer = FALSE. /* undo session? */
        RUN "prodict/user/_usrdbox.p":u
          (INPUT-OUTPUT answer,?,?,new_lang[4]).
        in_trans = NOT answer.
        IF answer THEN UNDO qbf_block,RETRY qbf_block.
      END.
      ELSE
        MESSAGE new_lang[8].  /* No changes were made! */
    END. /*---------------------------------------------------- end of UNDO */
    ELSE
    IF qbf# = {&EXIT} THEN /*-------------------------------- start of EXIT */
      LEAVE qbf_inner.
    /*--------------------------------------------------------- end of EXIT */

  END. /* iterating block (qbf_inner) */

END. /* scoping block (qbf_block) */


HIDE FRAME qbf        NO-PAUSE.
HIDE FRAME seq-browse NO-PAUSE.
HIDE FRAME seq-detail NO-PAUSE.
RETURN.

&ENDIF

