/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/* prohelp/function.p */

DEFINE VARIABLE i           AS INTEGER INITIAL 1.
DEFINE VARIABLE ttl         AS CHARACTER FORMAT "x(78)".
DEFINE VARIABLE line        AS CHARACTER FORMAT "x(78)".
DEFINE VARIABLE file        AS CHARACTER FORMAT "x(8)".
DEFINE VARIABLE in-key      AS CHARACTER.
DEFINE VARIABLE disp-arr    AS CHARACTER FORMAT "x(14)" EXTENT 64 NO-UNDO.
DEFINE VARIABLE func-arr1   AS CHARACTER FORMAT "x(14)" EXTENT 64 NO-UNDO.
DEFINE VARIABLE func-arr2   AS CHARACTER FORMAT "x(14)" EXTENT 64 NO-UNDO.
DEFINE VARIABLE first-a1    AS CHARACTER.
DEFINE VARIABLE first-a2    AS CHARACTER.
DEFINE VARIABLE func-name   AS CHARACTER.
DEFINE VARIABLE last-a1     AS CHARACTER.
DEFINE VARIABLE last-a2     AS CHARACTER.
DEFINE VARIABLE func-page   AS INTEGER INITIAL 1.
DEFINE VARIABLE key-pressed AS CHARACTER.
DEFINE VARIABLE funcs       AS CHARACTER EXTENT 128 NO-UNDO.
DEFINE VARIABLE nxt-prmt    AS INTEGER.
DEFINE VARIABLE array-max   AS INTEGER INITIAL 128 NO-UNDO.
DEFINE VARIABLE page-max    AS INTEGER INITIAL 64.
DEFINE VARIABLE hb          AS INTEGER.
DEFINE VARIABLE lb          AS INTEGER.
DEFINE VARIABLE bseek       AS INTEGER.
DEFINE VARIABLE last-one    AS INTEGER.
DEFINE VARIABLE lookfunc    AS CHARACTER.
DEFINE VARIABLE more-row    AS INTEGER INIT 19. /* three more than percol */
DEFINE VARIABLE percol      AS INTEGER INIT 16.
DEFINE VARIABLE numcol      AS INTEGER INIT 4.
DEFINE VARIABLE cInputFrom  AS CHARACTER NO-UNDO.

func-arr1 = "".
func-arr2 = "".
funcs     = "".
ASSIGN cInputFrom = SEARCH("prohelp/indata/funclist.txt").
IF cInputFrom = ? THEN
DO:
    MESSAGE "The procedure 'prohelp/indata/funclist.txt' required for this option was not found" 
            VIEW-AS ALERT-BOX.
    RETURN.
END.

LOAD-ARRAYS:
DO:
    INPUT FROM VALUE(cInputFrom) NO-ECHO.
    array1:
    REPEAT i = 1 to page-max:
       SET func-arr1[i].
    END.
    array2:
    REPEAT i = 1 to page-max:
       SET func-arr2[i].
    END.
    INPUT CLOSE.
END.
last-one = i - 1.

DO i = 1 TO page-max:
   funcs[i] = func-arr1[i].
   funcs[i + page-max] = func-arr2[i].
END.

first-a1 = func-arr1[01].
first-a2 = func-arr2[01].
last-a1  = func-arr1[page-max].
last-a2  = func-arr2[last-one].

STATUS DEFAULT "Select function with cursor keys"
	     + " then press " + KBLABEL("GO") + " for explanation".

{prohelp/aform-fn.i
    &title = " P R O G R E S S   F U N C T I O N S "}

func-page = 1.

REPEAT:
   IF func-page = 1 THEN DO:
      {prohelp/adisp.i &array = "func-arr1" &pagenum = "1"}
   END.
   ELSE
   IF func-page = 2 THEN DO:
      {prohelp/adisp.i &array = "func-arr2" &pagenum = "2"}
   END.

   CHOOSE FIELD disp-arr KEYS in-key NO-ERROR WITH FRAME disp-arr.

   COLOR DISPLAY NORMAL disp-arr WITH FRAME disp-arr.
   PAUSE 0.
   key-pressed = KEYFUNCTION(LASTKEY).

   IF ( key-pressed = "GO" OR key-pressed = "RETURN" ) AND FRAME-VALUE = ""
   THEN DO:
      BELL.
      MESSAGE "Cursor is not positioned on a function name".
      PAUSE 1 NO-MESSAGE.
      NEXT.
   END.

   lookfunc = TRIM(FRAME-VALUE).

   IF lookfunc <> "" THEN DO:
      hb = last-one + page-max.    /*  THIS IS A BINARY SEARCH */
      lb = 1.                      /*  THROUGH THE funcs ARRAY */
      DO WHILE TRUE:
	 bseek = (hb + lb) / 2.
	 IF lookfunc > funcs[bseek] THEN
	     lb = bseek + 1.
	 ELSE IF lookfunc < funcs[bseek] THEN
	     hb = bseek - 1.
	 ELSE IF lookfunc = funcs[bseek] THEN
	     LEAVE.
      END.
      nxt-prmt = bseek.

      IF nxt-prmt > page-max THEN
	 nxt-prmt = nxt-prmt - page-max.
   END.
   ELSE
	nxt-prmt = page-max.

   IF in-key <> "" AND key-pressed <> "GO" AND key-pressed <> "RETURN"
   THEN DO:
      IF func-page = 1 THEN DO:
	  IF in-key >= first-a1 AND in-key <= last-a1 THEN DO:
	      MESSAGE "No functions begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key > last-a1 AND in-key < SUBSTR(first-a2 , 1 , LENGTH(in-key))
	    THEN DO:
	      MESSAGE "No functions begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key > last-a1 THEN DO:
	      func-page = 2.
	      NEXT.
	  END.
      END.
      IF func-page = 2 THEN DO:
	  IF in-key >= first-a2 AND in-key <= last-a2 THEN DO:
	      MESSAGE "No functions begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key < first-a2 AND in-key > SUBSTR(last-a1 , 1 , LENGTH(in-key))
	   THEN DO:
	      MESSAGE "No functions begin with" CAPS(in-key).
	      PAUSE 2 NO-MESSAGE.
	      in-key = "".
	      NEXT.
	  END.
	  IF in-key < first-a2 THEN DO:
	      func-page = 1.
	      NEXT.
	  END.
      END.
      IF in-key < first-a1 OR in-key > last-a2 THEN DO:
	  MESSAGE "No functions begin with" CAPS(in-key).
	  PAUSE 2 NO-MESSAGE.
	  in-key = "".
	  NEXT.
      END.
   END.

   IF key-pressed = "PAGE-DOWN" and func-page = 1
    THEN func-page = 2.
   ELSE IF key-pressed = "CURSOR-RIGHT" THEN DO:
      IF func-page = 2 THEN NEXT.
      NEXT-PROMPT disp-arr[nxt-prmt - ((numcol - 1) * percol)]
	WITH FRAME disp-arr.
      func-page = 2.
   END.
   ELSE IF key-pressed = "CURSOR-LEFT" OR key-pressed = "BACKSPACE" THEN DO:
      IF func-page = 1 THEN NEXT.
      NEXT-PROMPT disp-arr[nxt-prmt + ((numcol - 1) * percol)]
	WITH FRAME disp-arr.
      func-page = 1.
   END.
   ELSE IF key-pressed = "CURSOR-DOWN" THEN DO:
      IF nxt-prmt = page-max THEN nxt-prmt = 0.
      NEXT-PROMPT disp-arr[nxt-prmt + 1] WITH FRAME disp-arr.
   END.
   ELSE IF key-pressed = "CURSOR-UP" THEN DO:
      IF nxt-prmt = 1 AND func-page = 2 THEN nxt-prmt = last-one + 1.
      IF nxt-prmt = 1 THEN nxt-prmt = page-max + 1.
      NEXT-PROMPT disp-arr[nxt-prmt - 1] WITH FRAME disp-arr.
   END.
   ELSE IF key-pressed = "PAGE-UP" and func-page = 2 then func-page = 1.
   ELSE IF key-pressed = "HOME" THEN DO:
      IF func-page = 1 AND nxt-prmt = 1 THEN DO:
	 func-page = 2.
	 NEXT-PROMPT disp-arr[last-one] WITH FRAME disp-arr.
      END.
      ELSE DO:
	 func-page = 1.
	 NEXT-PROMPT disp-arr[1] WITH FRAME disp-arr.
      END.
   END.
   ELSE IF key-pressed = "GO"    OR
      key-pressed = "RETURN"
   THEN DO:

	IF SUBSTRING(FRAME-VALUE,1,1) LE "d" THEN
	  file = "func-a-d".

	ELSE IF SUBSTRING(FRAME-VALUE,1,1) LE "i" THEN
	  file = "func-e-i".

	ELSE IF SUBSTRING(FRAME-VALUE,1,1) LE "l" THEN
	  file = "func-j-l".

	ELSE IF SUBSTRING(FRAME-VALUE,1,1) LE "p" THEN
	  file = "func-m-p".

	ELSE file = "func-q-z".

       INPUT FROM VALUE(SEARCH("prohelp/indata/" + file)) NO-ECHO.

	func-name = FRAME-VALUE.
	outer:
	REPEAT:
	    REPEAT ON ENDKEY UNDO, NEXT outer:
		IMPORT ttl.
		IF ttl EQ func-name THEN LEAVE.
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
