/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* useriadd - user index creation program */

/*
INPUT:
index name in user_env[1].
OUTPUT:
The settings of the index fields are placed in user_env[4...].  This is
in accordance with the what was once ???_idx.p's expectations.

History:  D. McMann 07/29/03  Adjusted frame for data types with long name

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE i        AS INTEGER                NO-UNDO.
DEFINE VARIABLE max-key  AS INTEGER   INITIAL 16   NO-UNDO.
DEFINE VARIABLE p_count  AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_cursor AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_delid  AS INTEGER   INITIAL 2000 NO-UNDO.
DEFINE VARIABLE p_dir    AS LOGICAL                NO-UNDO.
DEFINE VARIABLE p_flag   AS INTEGER   EXTENT  2000 NO-UNDO.
DEFINE VARIABLE p_flag#  AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_help   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE p_scrap  AS CHARACTER              NO-UNDO.
DEFINE VARIABLE p_init   AS INTEGER   INITIAL ?    NO-UNDO.
DEFINE VARIABLE p_key    AS CHARACTER EXTENT  3    NO-UNDO.
DEFINE VARIABLE p_line   AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_mark   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE p_name   AS CHARACTER EXTENT  2000 NO-UNDO.
DEFINE VARIABLE p_recid  AS INTEGER   INITIAL 1    NO-UNDO.
DEFINE VARIABLE p_redraw AS LOGICAL   INITIAL TRUE NO-UNDO.
  /* frame line of first non indexed field */
DEFINE VARIABLE p_top    AS INTEGER   INITIAL 2    NO-UNDO.
DEFINE VARIABLE p_typed  AS CHARACTER              NO-UNDO.
/* total number of fields in the table */
DEFINE VARIABLE p_total  AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_current AS INTEGER  INITIAL 0    NO-UNDO.
/*array with the fields chosen by the user*/ 
DEFINE VARIABLE p_chosen AS CHARACTER EXTENT  16   NO-UNDO.
/*max number of lines in the upper part of the list*/
DEFINE VARIABLE p_maxl   AS INTEGER   INITIAL 10   NO-UNDO. 
DEFINE VARIABLE j        AS INTEGER                NO-UNDO.
/*flag keeps track if the last line in the uuper part of 
  the list is the last field chosen*/
DEF VAR flag AS INT INITIAL 0. 

user_env[4] = "".

FOR EACH _Field
  WHERE _Field._File-recid = drec_file
    AND (_Extent = 0 OR user_env[2] matches "*w*")
    AND (_Data-type = "character" OR NOT user_env[2] matches "*w*")
    AND (_Data-type <> "BLOB" AND _Data-type <> "CLOB" AND _Data-type <> "XLOB")
    BY _Field-name:
  ASSIGN
    p_count = p_count + 1
    p_name[p_count] = STRING(_Field-name,"x(26)") + STRING(_Data-type,"x(11)").
END.
IF p_count = 0 THEN RETURN.
ASSIGN p_total = p_count.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  /* 1*/ "Use",
  /* 2*/ "to add component",
  /* 3*/ "to remove component",
  /* 4*/ "to save",
  /* 5*/ "to undo",
  /* 6*/ "Type ~"y~" for an ascending component, or ~"n~" for descending",
  /* 7*/ ?, /* see below */
  /* 8*/ "You cannot add any more components to this index.",
  /* 9*/ ""
].
new_lang[7] = "Do you want this to be an ascending index component?  "
            + "Answering ~"no~" will make it a descending index component.".

FORM
  p_mark FORMAT "x(46)"
  HEADER "Num Field Name                       Type Asc?"
  WITH FRAME pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  SCREEN-LINES - 7 DOWN ROW 3 COLUMN 2
  TITLE " Adding Index ~"" + user_env[1] + "~" ".

FORM
  "Use the cursor-motion keys"               SKIP /*row#4*/
  "to navigate, or type field"               SKIP /*row#5*/
  "name and hilite will move."               SKIP /*row#6*/
  " "                                        SKIP /*row#7*/
  "As you select fields to be"               SKIP /*row#8*/
  "key components, they are"                 SKIP /*row#9*/
  "moved above the dividing"                 SKIP /*row#10*/
  "line.  Use"       p_key[1] FORMAT "x(15)" SKIP /*row#11*/
  "to select fields."                        SKIP /*row#12*/
  "To set asc/desc, use +/-"                 SKIP /*row#13*/
  "keys."                                    SKIP /*row#14*/
  " "                                        SKIP /*row#15*/
  "To unselect fields, move"                 SKIP /*row#16*/
  "hilite above dividing line"               SKIP /*row#17*/
  "and"              p_key[2] FORMAT "x(22)" SKIP /*row#18*/
  "When done, press" p_key[3] FORMAT "x(9)"  SKIP /*row#19*/
  WITH FRAME note OVERLAY NO-LABELS NO-ATTR-SPACE ROW 3 COLUMN 52 USE-TEXT.

FORM
  SPACE(29) /* this must match width of frame 'note' exactly */
  WITH FRAME cover OVERLAY NO-BOX NO-ATTR-SPACE
  (SCREEN-LINES - 21) DOWN ROW 21 COLUMN 52.
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

PAUSE 0.
DISPLAY FILL("-",80) @ p_mark WITH FRAME pick.
DOWN WITH FRAME pick.
DISPLAY
  "[" + KBLABEL("RETURN") + "]"  @ p_key[1]
  "[" + KBLABEL("RETURN") + "]." @ p_key[2]
  "[" + KBLABEL("GO")     + "]." @ p_key[3]
  WITH FRAME note.
IF SCREEN-LINES > 21 THEN VIEW FRAME cover.

DO WHILE TRUE WITH FRAME pick:

  p_recid = MAXIMUM(MINIMUM(p_count,p_recid),1).

  IF p_redraw THEN DO:
    ASSIGN
      p_line   = MAXIMUM(p_top,FRAME-LINE)
      p_cursor = p_recid - (IF p_init = ? THEN p_line ELSE p_init) + p_top.
    UP p_line - p_top.
    IF p_cursor < 1 THEN ASSIGN
      p_cursor = 1
      p_line   = p_top
      p_recid  = 1.
    DO WHILE TRUE:
      IF p_cursor > p_count THEN
        CLEAR NO-PAUSE.
      ELSE
        DISPLAY "   " + p_name[p_cursor] @ p_mark.
      p_cursor = p_cursor + 1.
      IF FRAME-LINE < FRAME-DOWN THEN DOWN. ELSE LEAVE.
    END.
    p_line = (IF p_init = ? THEN p_line ELSE p_init).
    UP FRAME-DOWN - p_line.
    ASSIGN
      p_init   = ?
      p_redraw = FALSE.
  END.

  /*Use [RET] to add components, [GO] when done, [END-ERR] to undo.*/
  /*Use [RET] to remove component, [GO] when done, [END-ERR] to undo.*/
  ASSIGN
    p_mark = p_help
    p_help = new_lang[1]
           + " [" + KBLABEL("RETURN") + "]"
           + " " + new_lang[IF FRAME-LINE >= p_top THEN 2 ELSE 3]
           + ", [" + KBLABEL("GO") + "] "
           + new_lang[4]
           + ", [" + KBLABEL("END-ERROR") + "] "
           + new_lang[5] + ".".
  IF p_mark <> p_help THEN DO:
    user_status = p_help.
    STATUS DEFAULT user_status.
  END.
  IF FRAME-LINE >= p_top THEN DISPLAY "   " + p_name[p_recid] @ p_mark.
  
  COLOR DISPLAY MESSAGES p_mark.
  READKEY.
  COLOR DISPLAY NORMAL   p_mark.
  PAUSE 0.

  IF CAN-DO("+,=,-",CHR(LASTKEY)) AND FRAME-LINE < p_top THEN .
  ELSE
  IF p_count > 0 AND (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY > 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(p_typed) > 0) THEN DO:
    IF FRAME-LINE < p_top THEN DOWN p_top - FRAME-LINE.
    p_typed = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
              THEN SUBSTRING(p_typed,1,LENGTH(p_typed) - 1)
              ELSE p_typed + CHR(LASTKEY)).
    IF p_typed = "" OR p_name[p_recid] BEGINS p_typed THEN NEXT.
    DO p_line = p_recid TO p_count:
      IF p_name[p_line] BEGINS p_typed THEN LEAVE.
    END.
    IF p_line > p_count THEN DO:
      DO p_line = 1 TO p_recid:
        IF p_name[p_line] BEGINS p_typed THEN LEAVE.
      END.
      IF p_line > p_recid THEN p_line = p_count + 1.
    END.
    IF p_line > p_count THEN DO:
      p_typed = CHR(LASTKEY).
      DO p_line = 1 TO p_count:
        IF p_name[p_line] BEGINS p_typed THEN LEAVE.
      END.
    END.
    IF p_line <= p_count THEN ASSIGN
      p_recid  = p_line
      p_redraw = TRUE.
    NEXT.
  END.
  p_typed = "". /* if keyfunction, reset keys to null string */

  IF CAN-DO("=,+,-",CHR(LASTKEY)) AND p_top > 2 AND FRAME-LINE < p_top THEN DO:
    DISPLAY SUBSTRING(INPUT p_mark,1,41)
      + STRING(CHR(LASTKEY) = "-","no/yes") @ p_mark.
  END.
  ELSE
  IF CAN-DO("RETURN",KEYFUNCTION(LASTKEY)) THEN _return: DO:
    /* only one component allowed in word index */
   IF p_count > 0 AND FRAME-LINE >= p_top AND
      ((p_total - p_count) = max-key  OR (user_env[2] matches "*w*" AND p_top > 2))
      THEN DO:
      MESSAGE new_lang[8]. /* too many parts */
      LEAVE _return.
    END.
    IF p_top > 2 AND FRAME-LINE < p_top THEN DO:    /* <-- delete component */
      ASSIGN
        p_scrap = SUBSTRING(INPUT p_mark,4,37).
       /* check if user has chosen <p_maxl> field or less*/
        IF (p_total - p_count) <= p_maxl THEN DO:
            ASSIGN p_top   = p_top - 1.
            DISPLAY "" @ p_mark.
            SCROLL FROM-CURRENT UP.
            DO WHILE FRAME-LINE < p_top - 1:
                DISPLAY STRING(FRAME-LINE,"Z9") + SUBSTRING(INPUT p_mark,3) @ p_mark.
                DOWN 1.
            END.
            DOWN 1. /* skip over ---- line */
        END.
        /*User has chosen more than <p_maxl> fields*/
        ELSE DO:
            /* Should never happen, but if there was a blank line left,
                  remove it from top part of the list*/ 
            IF p_scrap = "" THEN flag = 1.
            /*if we don't need to scroll down */
            IF flag = 0 THEN DO:
                DO i = 1 TO max-key:
                   IF TRIM(substring(p_chosen[i],1,37)) = TRIM(p_scrap)  THEN LEAVE.
                END.

                DO j = (i + 1) TO max-key:
                   DISPLAY STRING(j - 1,"Z9") + " " + p_chosen [j] @ p_mark.
                   DOWN 1.
                   IF FRAME-LINE = (p_top - 1) THEN LEAVE.
                END.
            END.
            ELSE DO:
                /*we need to scroll down what's above p_top */
                UP FRAME-LINE - 1.
                p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).
                IF p_current = 1 THEN p_current = p_current + 1.
                IF (p_total - p_count) = (p_maxl + 1) THEN
                    i = 1.
                ELSE
                    ASSIGN i = (p_current - 1 ).
                DO j = i  TO max-key:
                    IF  TRIM(substring(p_chosen[j],1,37)) <> TRIM(p_scrap) THEN DO:
                       DISPLAY STRING(i ,"Z9") + " " + p_chosen [j] @ p_mark.
                       DOWN 1.
                    END.
                    ELSE i = i - 1.  /* decrease i as we skipped the deleted field */
                    IF FRAME-LINE = (p_top - 1) THEN LEAVE.
                    ASSIGN    i = i + 1.
                 END.
            END.
            /* DOWN 1.*/
            UP 1.
            IF FRAME-LINE = (p_top - 2) THEN DO:
              p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).               
              /*keep flaf if user is seeing the last field chosen. */
              IF p_current = (p_total - p_count - 1) THEN flag = 1.
              ELSE flag = 0. 
            END.
            DOWN 2.
        END.
      /*SCROLL FROM-CURRENT DOWN.*/

       /*search through p_chosen to find the line and delete it. then re-arrange the array */
        DO i = 1 TO max-key:
            /*found the line*/
            IF TRIM(substring(p_chosen[i],1,37)) = TRIM(p_scrap) THEN DO:
               /* rearrange the array*/
               DO j = i TO max-key:
                   IF p_chosen[j] = "" THEN LEAVE.
                   IF j = max-key THEN 
                        p_chosen[max-key] = "". /* item maxkey is always blank when deleting */
                   ELSE
                   p_chosen[j] = p_chosen[ j + 1].
               END.
           END.
        END.

   /* to avoid including blank lines in the lower part of the list*/ 
     IF p_scrap <> ""  THEN DO:
     /* now re-insert this field into the lower part of the list */
      DO i = 2000 TO p_delid BY -1:
        IF p_name[i] = p_scrap THEN LEAVE.
      END.
      DO WHILE i > p_delid:
        p_name[i] = p_name[i - 1].
        i = i - 1.
      END.
      DO i = p_count TO 1 BY -1:
        p_name[i + 1] = p_name[i].
        IF p_name[i] < p_scrap THEN LEAVE.
      END.
      ASSIGN
        p_delid       = p_delid + 1
        p_count       = p_count + 1
        p_name[i + 1] = p_scrap
        p_redraw      = TRUE
        p_recid       = 1.
      /*DOWN p_top - FRAME-LINE.*/
     END. /* if p_scrap <> "" */
    END. /* delete component */
    ELSE
    IF p_count > 0 AND FRAME-LINE >= p_top THEN DO:    /* <-- add component */
      /* don't ask about asc/dec on word index */
      IF NOT user_env[2] matches "*w*" THEN
      DO:
        user_status = new_lang[6].
        STATUS DEFAULT user_status. /* use +/- for asc/desc key */
        PUT CURSOR ROW FRAME-LINE + 5 COLUMN 45.
        READKEY PAUSE 0.
        PUT CURSOR OFF.
        p_dir = ?.
        IF CAN-DO("y,a,=,+,RETURN,GO",KEYFUNCTION(LASTKEY)) THEN p_dir = TRUE.
        IF CAN-DO("n,d,-",KEYFUNCTION(LASTKEY)) THEN p_dir = FALSE.
      END.
      ELSE
      p_dir = TRUE.

      IF p_dir = ? AND KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
        user_status = "".
        STATUS DEFAULT user_status.
        p_dir = TRUE.
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT p_dir,?,?,new_lang[7]).
      END.
      user_status = p_help.
      STATUS DEFAULT user_status.
      IF p_dir = ? OR KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _return.
      flag = 1. /*it is always scrolled down to the last field chosen*/  
      IF (p_total - p_count) < p_maxl THEN DO:
         p_top = p_top + 1.
         UP FRAME-LINE - p_top + 2.
         DISPLAY STRING(p_top - 2,"Z9") + " " + p_name[p_recid] + " "
         + STRING(p_dir,"yes/no") @ p_mark.
         ASSIGN p_chosen [p_total - p_count + 1] = SUBSTRING(INPUT p_mark,4,50).
            
         DOWN.
         DISPLAY FILL("-",80) @ p_mark.
         DOWN.
      END.
      ELSE DO:
         UP FRAME-LINE - p_top + 2.
         /*if last line is the last field*/
              
         p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).
         IF p_current = (p_total - p_count) THEN DO:
             j = (p_total - p_count) - p_maxl + 2.
         END.
         ELSE DO :
             p_current = (p_total - p_count).
             j = (p_total - p_count) - p_maxl + 2.
         END.
         UP FRAME-LINE - 1.
         DO i = j TO p_current:
            DISPLAY STRING(i ,"Z9") + " " + p_chosen [i] @ p_mark.
            DOWN 1.
         END.
         DISPLAY STRING(p_current + 1,"Z9") + " " + p_name[p_recid] + " "
          + STRING(p_dir,"yes/no") @ p_mark.
         ASSIGN p_chosen [p_total - p_count + 1] = SUBSTRING(INPUT p_mark,4,50).

         DOWN 2. /* skip to p_top line*/
      END.
      
      /* now remove this field from the lower part of the list */
      ASSIGN
        p_name[p_delid]     = p_name[p_recid]
        p_delid             = p_delid - 1
        p_name[p_count + 1] = ""
        p_count             = p_count - 1.
      DO i = p_recid TO p_count + 1:
        p_name[i] = p_name[i + 1].
      END.
    END.
    ASSIGN
      p_recid  = MINIMUM(p_recid,p_count)
      p_redraw = TRUE.
    DOWN p_top - FRAME-LINE.
  END.
  ELSE
  IF CAN-DO("CURSOR-DOWN,TAB, ",KEYFUNCTION(LASTKEY))
    AND (FRAME-LINE < p_top OR p_recid < p_count) THEN DO:
    IF FRAME-LINE >= p_top AND p_count > 0 THEN p_recid = p_recid + 1.
    IF FRAME-LINE = FRAME-DOWN THEN DO:
      UP FRAME-LINE - p_top.
      SCROLL FROM-CURRENT UP.
      DOWN FRAME-DOWN - FRAME-LINE.
    END.
    ELSE  DO:
       /* when above the top line */
       p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).
       
       IF FRAME-LINE = (p_top - 2) THEN DO:
         /*keep flag if user is seeing the last field chosen. */
         IF p_current = (p_total - p_count) THEN flag = 1.
         ELSE flag = 0. 

         IF p_current <> max-key AND p_chosen[p_current + 1] <> "" THEN DO:
           UP FRAME-LINE - 1.
           DO i = ( p_current - p_maxl + 2) TO max-key:
               DISPLAY STRING(i,"Z9") + " " + p_chosen [i] @ p_mark.
               IF FRAME-LINE = (p_top - 1) OR i = p_current + 1 THEN LEAVE.
               DOWN 1.
           END.
         END.
         ELSE   
             IF (FRAME-LINE < p_top OR p_count > 0 )  THEN DOWN. 
       END.
       ELSE
           IF (FRAME-LINE < p_top OR p_count > 0 )  THEN DOWN. 
    END.
    IF FRAME-LINE = p_top - 1 THEN DOWN 1.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) THEN DO:
    IF FRAME-LINE = (p_top - 2 ) THEN DO:
        p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).
        IF p_current = (p_total - p_count) THEN flag = 1.
        ELSE flag = 0. 
    END.

    IF p_recid > 1 THEN DO:
      p_recid = p_recid - 1.
      IF FRAME-LINE = p_top THEN
        SCROLL FROM-CURRENT DOWN.
      ELSE
        UP.
    END.
    ELSE IF p_top > 2 THEN DO:
      IF FRAME-LINE > 1 THEN UP 1.
      IF FRAME-LINE = p_top - 1 THEN UP 1.
      /*check if we need to scroll up*/
      IF FRAME-LINE = 1 THEN 
      DO:
          p_current = INTEGER(SUBSTRING(INPUT p_mark,1,3)).
          IF (p_total - p_count) > p_maxl AND ( p_current <> 1) THEN 
          DO:
            DO i = ( p_current - 1) TO max-key:
                DISPLAY STRING(i,"Z9") + " " + p_chosen [i] @ p_mark.
                DOWN 1.
                IF FRAME-LINE = (p_top - 1) OR i = (i + 8) THEN LEAVE.
            END.
            UP FRAME-LINE - 1.
            flag = 0 . /* the p_maxl line is not the last field chosen */
          END.
      END.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    IF FRAME-LINE < p_top THEN DOWN p_top - FRAME-LINE.
    ASSIGN
      p_recid  = p_recid + FRAME-DOWN - p_top
      p_redraw = TRUE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN DO:
    IF FRAME-LINE < p_top THEN DOWN p_top - FRAME-LINE.
    ASSIGN
      p_recid  = p_recid - FRAME-DOWN - p_top
      p_redraw = TRUE.
  END.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
    IF FRAME-LINE < p_top THEN DOWN p_top - FRAME-LINE.
    ASSIGN
      p_recid  = 1
      p_redraw = TRUE.
    UP FRAME-LINE - p_top.
  END.
  ELSE
  IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    IF FRAME-LINE < p_top THEN DOWN p_top - FRAME-LINE.
    ASSIGN
      p_recid  = p_count
      p_redraw = TRUE.
    DOWN FRAME-DOWN - FRAME-LINE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "GO" AND p_top > 2 THEN DO:
 
    DO i = 1 TO max-key:
      ASSIGN 
        p_mark = p_chosen[i]
        user_env[i + 3] 
          = SUBSTRING(p_mark,1,INDEX(p_mark," ") - 1) + ","
          + STRING(SUBSTRING(p_mark,39,1) = "y","+/-").
        
        IF p_mark = "" THEN DO: 
           USER_env[i + 3] = "".
           LEAVE.
        END.
    END.
    LEAVE.
  END.
  ELSE
  IF CAN-DO("GO,END-ERROR",KEYFUNCTION(LASTKEY)) THEN DO:
    user_env[1] = "".
    LEAVE.
  END.

  p_line = 1.
END.

HIDE FRAME note  NO-PAUSE.
HIDE FRAME pick  NO-PAUSE.
HIDE FRAME cover NO-PAUSE.
user_status = ?.
STATUS DEFAULT.
RETURN.
