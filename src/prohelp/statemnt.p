/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* prohelp/statemnt.p */

DEFINE VARIABLE i           AS INTEGER INITIAL 1.
DEFINE VARIABLE ttl         AS CHARACTER FORMAT "x(78)".
DEFINE VARIABLE line        AS CHARACTER FORMAT "x(78)".
DEFINE VARIABLE file        AS CHARACTER FORMAT "x(8)".
DEFINE VARIABLE in-key      AS CHARACTER.
DEFINE VARIABLE disp-arr    AS CHARACTER FORMAT "x(20)" EXTENT 48 NO-UNDO.
DEFINE VARIABLE stmt-arr1   AS CHARACTER FORMAT "x(20)" EXTENT 48 NO-UNDO.
DEFINE VARIABLE stmt-arr2   AS CHARACTER FORMAT "x(20)" EXTENT 48 NO-UNDO.
DEFINE VARIABLE stmt-arr3   AS CHARACTER FORMAT "x(20)" EXTENT 48 NO-UNDO.
DEFINE VARIABLE first-a1    AS CHARACTER.
DEFINE VARIABLE first-a2    AS CHARACTER.
DEFINE VARIABLE first-a3    AS CHARACTER.
DEFINE VARIABLE stmt-name   AS CHARACTER.
DEFINE VARIABLE last-a1     AS CHARACTER.
DEFINE VARIABLE last-a2     AS CHARACTER.
DEFINE VARIABLE last-a3     AS CHARACTER.
DEFINE VARIABLE stmt-page   AS INTEGER INITIAL 1.
DEFINE VARIABLE key-pressed AS CHARACTER.
DEFINE VARIABLE stmts       AS CHARACTER EXTENT 144 NO-UNDO.
DEFINE VARIABLE nxt-prmt    AS INTEGER.
DEFINE VARIABLE array-max   AS INTEGER INITIAL 144 NO-UNDO.
DEFINE VARIABLE hb          AS INTEGER.
DEFINE VARIABLE lb          AS INTEGER.
DEFINE VARIABLE bseek       AS INTEGER.
DEFINE VARIABLE last-one    AS INTEGER.
DEFINE VARIABLE lookstmt    AS CHARACTER.
DEFINE VARIABLE more-row    AS INTEGER INIT 19.
DEFINE VARIABLE percol      AS INTEGER INIT 16.
DEFINE VARIABLE numcol      AS INTEGER INIT 3.
DEFINE VARIABLE cInputFrom  AS CHARACTER NO-UNDO.

stmt-arr1 = "".
stmt-arr2 = "".
stmt-arr3 = "".
stmts     = "".
ASSIGN cInputFrom = SEARCH("prohelp/indata/stmtlist.txt").
IF cInputFrom = ? THEN
DO:
    MESSAGE "The procedure 'prohelp/indata/stmtlist.txt' required for this option was not found" 
            VIEW-AS ALERT-BOX.
    RETURN.
END.

LOAD-ARRAYS:
DO:
    INPUT FROM VALUE(cInputFrom) NO-ECHO.
    array1:
    REPEAT i = 1 to 48:
       SET stmt-arr1[i].
    END.
    array2:
    REPEAT i = 1 to 48:
       SET stmt-arr2[i].
    END.
    array3:
    REPEAT i = 1 to 48:
       SET stmt-arr3[i].
    END.
    INPUT CLOSE.
END.
last-one = i - 1.

DO i = 1 TO 48:
   stmts[i] = stmt-arr1[i].
   stmts[i + 48] = stmt-arr2[i].
   stmts[i + 96] = stmt-arr3[i].
END.

first-a1 = stmt-arr1[01].
first-a2 = stmt-arr2[01].
first-a3 = stmt-arr3[01].
last-a1  = stmt-arr1[48].
last-a2  = stmt-arr2[48].
last-a3  = stmt-arr3[last-one].

STATUS DEFAULT "Select statement with cursor keys"
	     + " then press " + KBLABEL("GO") + " for explanation".

{prohelp/aform-st.i
    &title = " P R O G R E S S   S T A T E M E N T S "}

stmt-page = 1.

REPEAT:
   IF stmt-page = 1 THEN DO:
      {prohelp/sdisp.i &array = "stmt-arr1" &pagenum = "1"}
   END.
   ELSE
   IF stmt-page = 2 THEN DO:
      {prohelp/sdisp.i &array = "stmt-arr2" &pagenum = "2"}
   END.
   ELSE
   IF stmt-page = 3 THEN DO:
      {prohelp/sdisp.i &array = "stmt-arr3" &pagenum = "3"}
   END.

   CHOOSE FIELD disp-arr KEYS in-key NO-ERROR WITH FRAME disp-arr.
   COLOR DISPLAY NORMAL disp-arr WITH FRAME disp-arr.
   PAUSE 0.
   key-pressed = KEYFUNCTION(LASTKEY).
   IF ( key-pressed = "GO" OR key-pressed = "RETURN" ) AND FRAME-VALUE = ""
   THEN DO:
      BELL.
      MESSAGE "Cursor is not positioned on a statement name".
      PAUSE 1 NO-MESSAGE.
      NEXT.
   END.

   DO i = LENGTH(FRAME-VALUE) TO 1 BY -1             /* THESE LINES STRIP */
	  WHILE SUBSTRING(FRAME-VALUE,i,1) = "":     /* OFF TRAILING BLANKS */
   END.                                              /* FROM */

   lookstmt = SUBSTRING(FRAME-VALUE,1,i).            /* FRAME-VALUE */
   IF lookstmt <> "" THEN DO:
       IF stmt-page = 1 THEN DO:
	    hb = 48.
	    lb = 1.
       END.
       ELSE
       IF stmt-page = 2 THEN DO:
	    hb = 96.
	    lb = 49.
       END.
       ELSE
       IF stmt-page = 3 THEN DO:
	    hb = last-one + 96.
	    lb = 97.
       END.

      bseek = 0.
      DO WHILE TRUE:                           /* THIS IS A BINARY SEARCH */
	 bseek = (hb + lb) / 2.                 /* THROUGH THE STMTS ARRAY */
	 IF lookstmt > stmts[bseek] THEN DO:
	     lb = bseek + 1.
	     IF lookstmt = stmts[lb] THEN DO:
		 bseek = lb.
		 LEAVE.
	     END.
	 END.
	 ELSE IF lookstmt < stmts[bseek] THEN DO:
	     hb = bseek - 1.
	     IF lookstmt = stmts[hb] THEN DO:
		 bseek = hb.
		 LEAVE.
	     END.
	 END.
	 ELSE IF lookstmt = stmts[bseek] THEN
	     LEAVE.
      END.
      nxt-prmt = bseek.
      IF nxt-prmt > 96 THEN
	 nxt-prmt = nxt-prmt - 96.
      ELSE
      IF nxt-prmt > 48 THEN
	nxt-prmt = nxt-prmt - 48.
   END.
   ELSE
	nxt-prmt = 48.
   IF in-key <> "" AND key-pressed <> "GO" AND key-pressed <> "RETURN"
   THEN DO:
      IF stmt-page = 1 THEN DO:
	  IF in-key >= first-a1 AND in-key <= last-a1 THEN DO:
	      MESSAGE "No statements begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.

	  IF in-key > last-a1 AND in-key < SUBSTR(first-a2,1,LENGTH(in-key))
	   THEN DO:
	      MESSAGE "No statements begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.

	  IF in-key > last-a1 THEN DO:
	      stmt-page = 2.
	      NEXT.
	  END.
      END.
      IF stmt-page = 2 THEN DO:

	  IF in-key >= first-a2 AND in-key <= last-a2 THEN DO:
	      MESSAGE "No statements begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key > last-a2 THEN DO:
	      stmt-page = 3.
	      NEXT-PROMPT disp-arr[1] WITH FRAME disp-arr.
	      NEXT.
	  END.
	  IF in-key < first-a2 THEN DO:
	      stmt-page = 1.
	      NEXT.
	  END.
      END.
      IF stmt-page = 3 THEN DO:

	  IF in-key >= first-a3 AND in-key <= last-a3 THEN DO:
	      MESSAGE "No statements begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key < first-a2 THEN DO:
	      stmt-page = 1.
	      NEXT.
	  END.
	  ELSE
	  IF in-key < first-a3 AND in-key > last-a2 THEN DO:
	      in-key = "".
	      NEXT.
	  END.
	  ELSE
	  IF in-key < first-a3 THEN DO:
	      stmt-page = 2.
	      NEXT.
	  END.
      END.

      IF in-key < first-a1 OR in-key > last-a3 THEN DO:
	  MESSAGE "No statements begin with" CAPS(in-key).
	  PAUSE 2 NO-MESSAGE.
	  in-key = "".
	  NEXT.
      END.
   END.

   IF key-pressed = "PAGE-DOWN" THEN DO:
     stmt-page = stmt-page + 1.
     IF stmt-page = 3 THEN
	NEXT-PROMPT disp-arr[1] WITH FRAME disp-arr.
   END.
   ELSE IF key-pressed = "CURSOR-RIGHT" THEN DO:
      IF stmt-page = 3 THEN NEXT.
      NEXT-PROMPT disp-arr[nxt-prmt - ((numcol - 1) * percol)]
	WITH FRAME disp-arr.
      stmt-page = stmt-page + 1 .
   END.
   ELSE IF key-pressed = "CURSOR-LEFT" OR key-pressed = "BACKSPACE" THEN DO:
      IF stmt-page = 1 THEN NEXT.
	NEXT-PROMPT disp-arr[nxt-prmt + percol].
	stmt-page = stmt-page - 1.
   END.
   ELSE IF key-pressed = "CURSOR-DOWN" THEN DO:
      IF nxt-prmt >= 96 THEN
	 nxt-prmt = nxt-prmt - 96.
      ELSE
      IF nxt-prmt >= 48 THEN
	 nxt-prmt = nxt-prmt - 48.
      NEXT-PROMPT disp-arr[nxt-prmt + 1] WITH FRAME disp-arr.
   END.
   ELSE IF key-pressed = "CURSOR-UP" THEN DO:
      IF nxt-prmt >= 96 THEN
	 nxt-prmt = nxt-prmt - 96.
      ELSE
      IF nxt-prmt >= 48 THEN
	 nxt-prmt = nxt-prmt - 48.
      IF nxt-prmt = 1 THEN
	 nxt-prmt = nxt-prmt + 1.

      NEXT-PROMPT disp-arr[max(1 , nxt-prmt - 1)] WITH FRAME disp-arr.
   END.
   ELSE IF key-pressed = "PAGE-UP" THEN
    stmt-page = stmt-page - 1.
   ELSE IF key-pressed = "HOME" THEN DO:
      IF stmt-page = 1 AND nxt-prmt = 1 THEN DO:
	 stmt-page = 2.
	 NEXT-PROMPT disp-arr[48] WITH FRAME disp-arr.
      END.
      IF stmt-page = 2 AND nxt-prmt = 48 THEN DO:
	 stmt-page = 3.
	 NEXT-PROMPT disp-arr[last-one] WITH FRAME disp-arr.
      END.
      ELSE DO:
	 stmt-page = 1.
	 NEXT-PROMPT disp-arr[1] WITH FRAME disp-arr.
      END.
   END.
   ELSE IF key-pressed = "GO"    OR
      key-pressed = "RETURN"
   THEN DO:

	IF SUBSTRING(FRAME-VALUE,1,1) LE "e" THEN
	  file = "stat-a-e".

	ELSE IF SUBSTRING(FRAME-VALUE,1,1) LE "o" THEN
	  file = "stat-f-o".

	ELSE file = "stat-p-z".

       INPUT FROM VALUE(SEARCH("prohelp/indata/" + file)) NO-ECHO.

	stmt-name = FRAME-VALUE.
	outer:
	REPEAT:
	    REPEAT ON ENDKEY UNDO, NEXT outer:
		IMPORT ttl.
		IF ttl EQ stmt-name THEN LEAVE.
	    END.
	    REPEAT ON ENDKEY UNDO, LEAVE outer
		WITH FRAME windy NO-LABELS 19 DOWN
		TITLE "  " + ttl + "  " NO-ATTR-SPACE CENTERED:
		IMPORT line.
		DISPLAY line format "x(76)". /* views the frame field */
	    END.
	END.

	INPUT CLOSE.
	HIDE FRAME windy.
	in-key = "".
	NEXT.
    END.

END.

STATUS DEFAULT.
