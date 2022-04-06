/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* _usrquot.p - support for quoter w/o import into PROGRESS */

/*
user_env[1] = "1" -> Convert each line of input file to one field of input.
            = "d" -> Convert fields in each line of input file by a delimiter.
            = "c" -> Convert fields in each line of input file by columns.
            = "m" -> Like "c", but just create include file to do conversion.


Modified by Gerry Seidl on 6/13/94 - Bug 94-06-01-011. Removed SEARCH for unix
                                     which was supplying the full path.
                                     
Modified by Gerry Seidl on 7/7/94 - Bug 94-06-27-069 & 
                                        94-06-27-049 &
                                        94-06-27-041 &
                                        94-06-27-079 &
                                        94-06-27-080
                                        
Modified by Gerry Seidl on 11/11/94 - Rewrote GO for c and m frames. Changed
                                      SET to ENABLE and used W-F.
                                      
Tom Nordhougen     07/19/95     Added support for mnemonics for the "Files..."
                                button and the "Output File" fill-in label for
                                the m frame.                                      
                                        
hutegger    03/97   widened quoter-c frame and adjusted quoter-make frame
                    to new font on Win32 stuff     
D. McMann   04/13/00 Added support for long path names    
D. McMann   06/05/00  Added check for return error from osquoter.p       
D. McMann   06/09/03 Changed assignment statement to include each individual 
                     array element for frames quoter-c and quoter-m 

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

&GLOBAL-DEFINE NUMFLDS 24
DEFINE VARIABLE delim-char  AS CHARACTER INITIAL ?             NO-UNDO.
DEFINE VARIABLE c           AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE msg         AS CHARACTER EXTENT 9              NO-UNDO.
DEFINE VARIABLE column-list AS CHARACTER INITIAL ?             NO-UNDO.
DEFINE VARIABLE i           AS INTEGER                         NO-UNDO.
DEFINE VARIABLE l           AS INTEGER EXTENT {&NUMFLDS} {&STDPH_FILL}
			       FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE quoter-file AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE source-file AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE target-file AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE u           AS INTEGER EXTENT {&NUMFLDS} {&STDPH_FILL} 
			       FORMAT ">>>9" NO-UNDO.
DEFINE VARIABLE q-mode      AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE canned      AS LOGICAL   INITIAL TRUE          NO-UNDO.
DEFINE VARIABLE sf-lbl      AS CHAR FORMAT "X(12)" INIT "&Input File:".
DEFINE VARIABLE tf-lbl      AS CHAR FORMAT "X(16)" INIT "For&matted File:".
DEFINE VARIABLE msgQuot1    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 72 INNER-LINES 2 NO-UNDO.
DEFINE VARIABLE msgQuot2    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 72 INNER-LINES 2 NO-UNDO.
DEFINE VARIABLE msgQuot3    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 72 INNER-LINES 2 NO-UNDO.
DEFINE VARIABLE msgQuot4    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 72 INNER-LINES 2 NO-UNDO.
DEFINE VARIABLE msgQuot5    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 56 INNER-LINES 1 NO-UNDO.
DEFINE VARIABLE msgQuot6    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 60 INNER-LINES 1 NO-UNDO.
DEFINE VARIABLE msgQuot7    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 56 INNER-LINES 2 NO-UNDO.
DEFINE VARIABLE msgQuot8    AS CHAR VIEW-AS EDITOR NO-BOX INNER-CHARS 74 INNER-LINES 2 NO-UNDO.

{prodict/misc/filesbtn.i &NAME = btn_File_Source}
{prodict/misc/filesbtn.i &NAME = btn_File_Target}
{prodict/misc/filesbtn.i &NAME = btn_File_Quoter}

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

msg[9] = (IF user_env[1] = "1"
         THEN "IMPORT field."
         ELSE "IMPORT field1 field2 field3 ....").


&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE LINEUP-1 15
  &GLOBAL-DEFINE FILLCH-1 35
&ELSE
  &GLOBAL-DEFINE LINEUP-1 16
  &GLOBAL-DEFINE FILLCH-1 40
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   msgQuot1 NO-LABEL AT 2 SKIP({&VM_WIDG})
&ELSE
  "Your input file will be copied to a new file, formatted with" AT 2 VIEW-AS TEXT SKIP
  "quotes around each line." 	AT 2 VIEW-AS TEXT SKIP({&VM_WIDG})
&ENDIF
  source-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-1} BY 1
         LABEL "&Input File" COLON {&LINEUP-1}
  btn_File_Source SKIP({&VM_WIDG})
  target-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-1} BY 1
         LABEL "For&matted File" COLON {&LINEUP-1}
  btn_File_Target
  {prodict/user/userbtns.i}
  WITH FRAME quoter-1 
  SIDE-LABELS CENTERED THREE-D
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Quote Entire Lines".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot1:SCREEN-VALUE =
  "Your input file will be copied to a new file, formatted with " +
  "quotes around each line.".
msgQuot1:READ-ONLY = yes.
&ENDIF

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE LINEUP-q 20
  &GLOBAL-DEFINE FILLCH-q 35
&ELSE
  &GLOBAL-DEFINE LINEUP-q 22
  &GLOBAL-DEFINE FILLCH-q 41
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  msgQuot2 NO-LABEL AT 2 SKIP({&VM_WIDG})
&ELSE
  "Your input file will be copied to a new file, formatted with" AT 2 VIEW-AS TEXT SKIP
  "quotes around each delimited field." 	AT 2 VIEW-AS TEXT SKIP({&VM_WIDG})
&ENDIF
  source-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-q} BY 1
         LABEL "&Input File" COLON {&LINEUP-q}
  btn_File_Source SKIP({&VM_WIDG})
  target-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-q} BY 1
         LABEL "For&matted File" COLON {&LINEUP-q}
  btn_File_Target SKIP({&VM_WIDG})
  delim-char  FORMAT "x" LABEL "&Delimiting character" 
	{&STDPH_FILL} COLON {&LINEUP-q}
	VALIDATE(delim-char <> '"' AND delim-char <> " ",
	        "Blanks and quotes are not allowed as delimiters.")
  {prodict/user/userbtns.i}
  WITH FRAME quoter-d 
  SIDE-LABELS CENTERED ATTR-SPACE THREE-D
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Quote By Delimiter".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot2:SCREEN-VALUE =
  "Your input file will be copied to a new file, formatted with " +
  "quotes around each delimited field.".
msgQuot2:READ-ONLY = yes.
&ENDIF

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE FILLCH-c 38
  &GLOBAL-DEFINE LINEUP-c 17
  &GLOBAL-DEFINE WIDTH-C 86
&ELSE
  &GLOBAL-DEFINE FILLCH-c 40
  &GLOBAL-DEFINE LINEUP-c 18
  &GLOBAL-DEFINE WIDTH-C 80
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  msgQuot3 NO-LABEL AT 2 SKIP ({&VM_WIDG})
&ELSE
  "Your input file will be copied to a new file, formatted with" AT 2 VIEW-AS TEXT SKIP
  "quotes around each column-defined field."   AT 2 VIEW-AS TEXT SKIP({&VM_WIDG})
&ENDIF
  source-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-c} BY 1
         LABEL "&Input File" COLON {&LINEUP-c}
  btn_File_Source SKIP({&VM_WIDG})
  target-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH-c} BY 1
         LABEL "For&matted File" COLON {&LINEUP-c}
  btn_File_Target SKIP({&VM_WIDG})
   &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    msgQuot6 NO-LABELS AT 2 SKIP({&VM_WID})
   &ELSE
    "Enter the starting and ending columns for each field in the input:" AT 2
      SKIP(1)
   &ENDIF
  {prodict/user/userquot.i}
  {prodict/user/userbtns.i}
  WITH FRAME quoter-c 
  WIDTH {&WIDTH-C}
  SIDE-LABELS NO-LABELS /* This is intentional; it causes default to be 
                           NO-LABEL, but allows explicit labels to appear as
                           side labels.  */  
  CENTERED THREE-D
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Quote By Column Ranges".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot3:SCREEN-VALUE =
  "Your input file will be copied to a new file, formatted with " +
  "quotes around each column-defined field.". 
ASSIGN msgQuot6:SCREEN-VALUE =
    "Enter the starting and ending columns for each field in the input:". 
msgQuot3:READ-ONLY = yes.
msgQuot6:READ-ONLY = yes.
&ENDIF

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE FILLCH-m 39
  &GLOBAL-DEFINE LINEUP-m  2
&ELSE
  &GLOBAL-DEFINE FILLCH-m 40
  &GLOBAL-DEFINE LINEUP-m  2
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  msgQuot4 NO-LABEL AT 2 SKIP ({&VM_WIDG})
&ELSE  
  "A quoter command will be created from the columns you list below."
      	       	     	      	       	     	AT 2 VIEW-AS TEXT
  "The command will be stored into a new file that can be used as an"
      	       	     	      	       	     	AT 2 VIEW-AS TEXT
  "include file." AT 2 VIEW-AS TEXT SKIP({&VM_WIDG})
&ENDIF
  quoter-file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN 
    SIZE {&FILLCH-m} BY 1 AT {&LINEUP-m} 
    LABEL "&Output File"
  btn_File_Quoter SKIP({&VM_WIDG})
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    msgQuot5 NO-LABEL AT 2 SKIP({&VM_WID})
  &ELSE
  "Enter the starting and ending columns for each field:" AT 2 SKIP(1)
  &ENDIF
  {prodict/user/userquot.i}
  {prodict/user/userbtns.i}
  WITH FRAME quoter-m
  SIDE-LABELS NO-LABELS /* This is intentional; it causes default to be 
                           NO-LABEL, but allows explicit labels to appear as
                           side labels.  */
  CENTERED THREE-D
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  SCROLLABLE
  VIEW-AS DIALOG-BOX TITLE "Quoter Include File".
  
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot4:SCREEN-VALUE =
  "A quoter command will be created from the columns you list below. " +
  "The command will be stored into a new file that can be used as an " +
  "include file.".
ASSIGN msgQuot5:SCREEN-VALUE =
  "Enter the starting and ending columns for each field:".
msgQuot4:READ-ONLY = yes.
msgQuot5:READ-ONLY = yes.
&ENDIF

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  &GLOBAL-DEFINE FILLCH-done 35
&ELSE
  &GLOBAL-DEFINE FILLCH-done 41
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  msgQuot7 NO-LABELS AT 2 SKIP({&VM_WIDG})
&ELSE
  "If there were no errors, your new formatted file may be" AT 2  SKIP 
  "used for {&PRO_DISPLAY_NAME} input."	AT 2  SKIP({&VM_WIDG})
&ENDIF

  "For example:"     	      	   AT 2  SKIP({&VM_WID})
    "INPUT FROM"                   AT 6 
      c FORMAT "x({&FILLCH-done})"                   SKIP
    "REPEAT:"			   AT 6	 SKIP
      "CREATE filename."	   AT 8	 SKIP
      msg[9] FORMAT "x(32)"        AT 8  SKIP
    "END."	      	           AT 6	 SKIP
    "INPUT CLOSE."	           AT 6
   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &HELP   = {&HLP_BTN_NAME}} /*No cancel button*/
  WITH FRAME quoter-done THREE-D
  NO-LABELS CENTERED NO-ATTR-SPACE 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Ok
  USE-TEXT VIEW-AS DIALOG-BOX TITLE "Quoter Formatting Completed.".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot7:SCREEN-VALUE =
  "If there were no errors, your new formatted file may be " +
  "used for {&PRO_DISPLAY_NAME} input.".
msgQuot7:READ-ONLY = yes.
&ENDIF

FORM
  SKIP({&TFM_WID})
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  msgQuot8 NO-LABELS AT 2 SKIP ({&VM_WIDG})
&ELSE
  "Your new include file may be used in several types of {&PRO_DISPLAY_NAME} statements." 
		 AT 2 SKIP({&VM_WIDG})
&ENDIF
  "UNIX only:"                                        TO 14 
    "INPUT THROUGH"                                   AT 16 
      msg[1] FORMAT "x({&FILLCH-done})"                     SKIP
    "REPEAT:"                                	      AT 16 SKIP
      msg[9] FORMAT "x(32)"     	      	             AT 18 SKIP(1)

  "UNIX:"                                             TO 14
    "UNIX SILENT"       	                           AT 16 
      msg[2] FORMAT "x(50)"                           AT 30 SKIP
  "DOS:"                                              TO 14
    "DOS SILENT"                                      AT 16 
      msg[3] FORMAT "x(50)"                           AT 30 SKIP
   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &HELP   = {&HLP_BTN_NAME}} /*No cancel button*/
  WITH FRAME quoter-make THREE-D
  NO-LABELS CENTERED SCROLLABLE
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Ok
  USE-TEXT VIEW-AS DIALOG-BOX TITLE "Include File Created".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ASSIGN msgQuot8:SCREEN-VALUE =
  "Your new include file may be used in several types of {&PRO_DISPLAY_NAME} statements.".
msgQuot8:READ-ONLY = yes.
&ENDIF

/*========================Internal Procedures=============================*/

/*---------------------------------------------
   See if the output file already exists and
   ask the user if he wants to overwrite it.
   Return "error" if user made a mistake.
----------------------------------------------*/
PROCEDURE Check_Output_File:
  DEFINE INPUT PARAMETER p_File AS WIDGET-HANDLE.
  DEFINE VAR answer AS LOGICAL NO-UNDO. 

  IF (p_File:SCREEN-VALUE) = "" THEN DO:
    MESSAGE "Output file not specified."
      VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
      APPLY "ENTRY" TO p_File.
      RETURN "error".
    END.

  IF SEARCH(p_File:SCREEN-VALUE) <> ? THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP 
	     "~"" + p_File:SCREEN-VALUE + "~"." SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO p_File.
      RETURN "error".
    END.
  END.
  RETURN "".
END.

/*---------------------------------------------
   Make sure the input file already exists
   and that it doesn't equal the output file.
   Return "error" if user made a mistake.
----------------------------------------------*/
PROCEDURE Check_Input_File:
  DEFINE INPUT PARAMETER p_File  AS WIDGET-HANDLE.
  DEFINE INPUT PARAMETER p_OFile AS WIDGET-HANDLE.
  DEFINE VAR answer AS LOGICAL NO-UNDO. 

  IF (p_File:SCREEN-VALUE) = "" THEN DO:
    MESSAGE "Input file not specified."
      VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
    APPLY "ENTRY" TO p_File.
    RETURN "error".
  END.

  IF SEARCH(p_File:SCREEN-VALUE) = ? THEN DO:
    answer = FALSE.
    MESSAGE "Input file not found with the name:" SKIP 
	     "~"" + p_File:SCREEN-VALUE + "~"."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO p_File.
    RETURN "error".
  END.

  IF p_OFile:SCREEN-VALUE <> "" AND
     SEARCH(p_File:SCREEN-VALUE) = SEARCH(p_OFile:SCREEN-VALUE) THEN DO:
    MESSAGE "The input file cannot be the same as the output file."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO p_File.
    RETURN "error".
  END.
   
  RETURN "".
END.

PROCEDURE chk-arrays:
   DEF VAR ctr        AS INT.
   DEF VAR err-none   AS INT INITIAL 0. /* 0=none, >0=some */
   DEF VAR err-inv    AS INT INITIAL 0. /* 0=ok, 1=bad */
  
   REPEAT ctr = 1 to {&NUMFLDS}:
        IF l[ctr] > u[ctr] THEN err-inv = 1.
        IF l[ctr] NE 0 AND u[ctr] <> 0 then err-none = 1.
   END.
   IF err-none = 0 THEN DO:
        MESSAGE "You haven't entered any ranges."
            VIEW-AS ALERT-BOX ERROR BUTTONS ok.
        RETURN "error".
   END.
   IF err-inv = 1 THEN DO:
        MESSAGE "You have entered one or more invalid ranges."
            VIEW-AS ALERT-BOX ERROR BUTTONS ok.
        RETURN "error".
   END.
END.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN 
/*----- HELP -----*/
on HELP of frame quoter-1
   or CHOOSE of btn_Help in frame quoter-1
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Quote_Entire_Lines_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame quoter-d
   or CHOOSE of btn_Help in frame quoter-d
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Quote_By_Delimiter_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame quoter-c
   or CHOOSE of btn_Help in frame quoter-c
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Quote_By_Column_Ranges_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame quoter-m
   or CHOOSE of btn_Help in frame quoter-m
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Quoter_Include_File_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame quoter-done
   or CHOOSE of btn_Help in frame quoter-done
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Quoter_Conversion_Completed_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame quoter-make
   or CHOOSE of btn_Help in frame quoter-make
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Include_File_Created_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


/*---- on GO or OK -----*/
ON GO OF FRAME quoter-1
DO:
   RUN Check_Input_File (INPUT source-file:HANDLE IN FRAME quoter-1,
      	       	     	 INPUT target-file:HANDLE IN FRAME quoter-1).
   IF RETURN-VALUE = "error" THEN
      RETURN NO-APPLY.
   RUN Check_Output_File (INPUT target-file:HANDLE IN FRAME quoter-1).
   IF RETURN-VALUE = "error" THEN
      RETURN NO-APPLY.
END.

ON GO OF FRAME quoter-d
DO:
   RUN Check_Input_File (INPUT source-file:HANDLE IN FRAME quoter-d,
      	       	     	 INPUT target-file:HANDLE IN FRAME quoter-d).
   IF RETURN-VALUE = "error" THEN
      RETURN NO-APPLY.
   RUN Check_Output_File (INPUT target-file:HANDLE IN FRAME quoter-d).
   IF RETURN-VALUE = "error" THEN
      RETURN NO-APPLY.
END.

ON GO of FRAME quoter-c DO:
   assign source-file target-file
     l[ 1] u[ 1]   l[ 2] u[ 2]   l[ 3] u[ 3]   l[ 4] u[ 4]   l[ 5] u[ 5]
     l[ 6] u[ 6]   l[ 7] u[ 7]   l[ 8] u[ 8]   l[ 9] u[ 9]   l[10] u[10]
     l[11] u[11]   l[12] u[12]   l[13] u[13]   l[14] u[14]   l[15] u[15]
     l[16] u[16]   l[17] u[17]   l[18] u[18]   l[19] u[19]   l[20] u[20]
     l[21] u[21]   l[22] u[22]   l[23] u[23]   l[24] u[24].
    
   /* ASSIGN source-file target-file l u.*/
   RUN Check_Input_File (INPUT source-file:HANDLE IN FRAME quoter-c,
      	       	     	 INPUT target-file:HANDLE IN FRAME quoter-c).
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.      	       	     	 
   RUN Check_Output_File (INPUT target-file:HANDLE IN FRAME quoter-c).
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
   RUN chk-arrays. /* check l & u for bad or missing ranges */
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
END.

ON GO of FRAME quoter-m DO:
   ASSIGN quoter-file 
     l[ 1] u[ 1]   l[ 2] u[ 2]   l[ 3] u[ 3]   l[ 4] u[ 4]   l[ 5] u[ 5]
     l[ 6] u[ 6]   l[ 7] u[ 7]   l[ 8] u[ 8]   l[ 9] u[ 9]   l[10] u[10]
     l[11] u[11]   l[12] u[12]   l[13] u[13]   l[14] u[14]   l[15] u[15]
     l[16] u[16]   l[17] u[17]   l[18] u[18]   l[19] u[19]   l[20] u[20]
     l[21] u[21]   l[22] u[22]   l[23] u[23]   l[24] u[24].

   RUN Check_Output_File (INPUT quoter-file:HANDLE IN FRAME quoter-m).
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
   RUN chk-arrays. /* check l & u for bad or missing ranges */
   IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
END.

/*----- WINDOW CLOSE -----*/
ON WINDOW-CLOSE OF FRAME quoter-1
   APPLY "END-ERROR" TO FRAME quoter-1.
ON WINDOW-CLOSE OF FRAME quoter-d
   APPLY "END-ERROR" TO FRAME quoter-d.
ON WINDOW-CLOSE OF FRAME quoter-c
   APPLY "END-ERROR" TO FRAME quoter-c.
ON WINDOW-CLOSE OF FRAME quoter-m
   APPLY "END-ERROR" TO FRAME quoter-m.
ON WINDOW-CLOSE OF FRAME quoter-done
   APPLY "END-ERROR" TO FRAME quoter-done.
ON WINDOW-CLOSE OF FRAME quoter-make
   APPLY "END-ERROR" TO FRAME quoter-make.

/*----- HIT of FILE BUTTONS -----*/
ON CHOOSE OF btn_File_Source in frame quoter-1 DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT source-file:handle in frame quoter-1 /*Fillin*/,
	INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Target in frame quoter-1 DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT target-file:handle in frame quoter-1 /*Fillin*/,
	INPUT "Find Formatted File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Source in frame quoter-d DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT source-file:handle in frame quoter-d /*Fillin*/,
	INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Target in frame quoter-d DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT target-file:handle in frame quoter-d /*Fillin*/,
	INPUT "Find Formatted File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Source in frame quoter-c DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT source-file:handle in frame quoter-c /*Fillin*/,
	INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Target in frame quoter-c DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT target-file:handle in frame quoter-c /*Fillin*/,
	INPUT "Find Formatted File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON CHOOSE OF btn_File_Quoter in frame quoter-m DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT quoter-file:handle in frame quoter-m /*Fillin*/,
	INPUT "Find Output File"  /*Title*/,
        INPUT "*.i"               /*Filter*/,
        INPUT no                /*Must exist*/).
END.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF source-file in frame quoter-1
   source-file:screen-value in frame quoter-1 = 
        TRIM(source-file:screen-value in frame quoter-1).
ON LEAVE OF target-file in frame quoter-1
   target-file:screen-value in frame quoter-1 = 
        TRIM(target-file:screen-value in frame quoter-1).
ON LEAVE OF source-file in frame quoter-d
   source-file:screen-value in frame quoter-d = 
        TRIM(source-file:screen-value in frame quoter-d).
ON LEAVE OF target-file in frame quoter-d
   target-file:screen-value in frame quoter-d = 
        TRIM(target-file:screen-value in frame quoter-d).
ON LEAVE OF source-file in frame quoter-c
   source-file:screen-value in frame quoter-c = 
        TRIM(source-file:screen-value in frame quoter-c).
ON LEAVE OF target-file in frame quoter-c
   target-file:screen-value in frame quoter-c = 
        TRIM(target-file:screen-value in frame quoter-c).
ON LEAVE OF quoter-file in frame quoter-m
   quoter-file:screen-value in frame quoter-m = 
        TRIM(quoter-file:screen-value in frame quoter-m).

/*============================Mainline code===============================*/

q-mode = user_env[1].

IF q-mode = "1" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
     ENABLE msgQuot1 WITH FRAME quoter-1.
  &ENDIF
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-1" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
  UPDATE source-file btn_File_Source target-file btn_File_Target
      	 btn_OK btn_Cancel {&HLP_BTN_NAME}
      	 WITH FRAME quoter-1.
  canned = FALSE.
END.
ELSE
IF q-mode = "d" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ENABLE msgQuot2 WITH FRAME quoter-d.
  &ENDIF
  delim-char = " ".
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-d" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
  UPDATE source-file btn_File_Source target-file btn_File_Target delim-char 
      	 btn_OK btn_Cancel {&HLP_BTN_NAME}
      	 WITH FRAME quoter-d.
  canned = FALSE.
END.
ELSE
IF q-mode = "c" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ENABLE msgQuot3 msgQuot6 WITH FRAME quoter-c.
  &ENDIF
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-c" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
  ENABLE source-file btn_File_Source target-file btn_File_Target
    l[ 1] u[ 1]   l[ 2] u[ 2]   l[ 3] u[ 3]   l[ 4] u[ 4]   l[ 5] u[ 5]
    l[ 6] u[ 6]   l[ 7] u[ 7]   l[ 8] u[ 8]   l[ 9] u[ 9]   l[10] u[10]
    l[11] u[11]   l[12] u[12]   l[13] u[13]   l[14] u[14]   l[15] u[15]
    l[16] u[16]   l[17] u[17]   l[18] u[18]   l[19] u[19]   l[20] u[20]
    l[21] u[21]   l[22] u[22]   l[23] u[23]   l[24] u[24]
    btn_OK btn_Cancel {&HLP_BTN_NAME}
    WITH FRAME quoter-c.    
    WAIT-FOR GO OF FRAME quoter-c.
   canned = FALSE.
END.
ELSE
IF q-mode = "m" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ENABLE msgQuot4 msgQuot5 msgQuot8 WITH FRAME quoter-m.
  &ENDIF
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-m" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }

  ENABLE quoter-file btn_File_Quoter
    l[ 1] u[ 1]   l[ 2] u[ 2]   l[ 3] u[ 3]   l[ 4] u[ 4]   l[ 5] u[ 5]
    l[ 6] u[ 6]   l[ 7] u[ 7]   l[ 8] u[ 8]   l[ 9] u[ 9]   l[10] u[10]
    l[11] u[11]   l[12] u[12]   l[13] u[13]   l[14] u[14]   l[15] u[15]
    l[16] u[16]   l[17] u[17]   l[18] u[18]   l[19] u[19]   l[20] u[20]
    l[21] u[21]   l[22] u[22]   l[23] u[23]   l[24] u[24]
    btn_OK btn_Cancel {&HLP_BTN_NAME}
    WITH FRAME quoter-m.  	 
    WAIT-FOR GO OF FRAME quoter-m.
    canned = FALSE.
END.

IF canned THEN ASSIGN
  q-mode    = ""
  user_path = "".

IF q-mode = "c" OR q-mode = "m" THEN DO:
  column-list = "".
  DO i = 1 TO {&NUMFLDS}:
    IF l[i] = 0 OR u[i] = 0 THEN NEXT.
    column-list = column-list
                + (IF column-list = "" THEN "" ELSE ",")
                + STRING(l[i])
                + (IF l[i] = u[i] THEN "" ELSE "-" + STRING(u[i])).
  END.
END.

IF q-mode = "1" OR q-mode = "d" OR q-mode = "c" THEN DO:
  RUN "prodict/misc/osquoter.p"
    (source-file,delim-char,column-list,target-file).
  IF RETURN-VALUE = "error" THEN
    RETURN.
END.

IF q-mode = "m" THEN DO:
  IF CAN-DO("MSDOS,WIN32",OPSYS) THEN c = "quoter -c ".
  ELSE IF OPSYS = "UNIX"  THEN c = "quoter -c ".
  OUTPUT TO VALUE(quoter-file) NO-ECHO NO-MAP.
  PUT UNFORMATTED c '"' column-list '"' SKIP.
  OUTPUT CLOSE.
END.

HIDE FRAME quoter-1 NO-PAUSE.
HIDE FRAME quoter-d NO-PAUSE.
HIDE FRAME quoter-c NO-PAUSE.
HIDE FRAME quoter-m NO-PAUSE.

IF q-mode = "1" OR q-mode = "d" OR q-mode = "c" THEN DO:
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ENABLE msgQuot7 WITH FRAME quoter-done.
  &ENDIF
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-done" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&HLP_BTN}
  }
  DISPLAY '"' + target-file + '".' @ c msg[9]
    WITH FRAME quoter-done.
  DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    UPDATE btn_OK {&HLP_BTN_NAME} WITH FRAME quoter-done.
  END.
END.

IF q-mode = "m" THEN DO:
  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
    &FRAME  = "FRAME quoter-make" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&HLP_BTN}
  }
  DISPLAY
    msg[9]
    '"' + quoter-file + '".'                                    @ msg[1]
    "~{ " + quoter-file + " ~} input-file >output-file."        @ msg[2]
    "~{ " + quoter-file + " ~} input-file >output-file."        @ msg[3]
    "~{ " + quoter-file + " ~} input-file >output-file."        @ msg[4]
    "~{ " + quoter-file + " ~} input-file >output-file."        @ msg[5]
    "~{ " + quoter-file + " ~} /OUTPUT=output-file input-file." @ msg[6]
    WITH FRAME quoter-make.
  DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
      ENABLE msgQuot8 WITH FRAME quoter-make.
    &ENDIF
    UPDATE btn_OK {&HLP_BTN_NAME} WITH FRAME quoter-make.
  END.
END.

HIDE FRAME quoter-done NO-PAUSE.
HIDE FRAME quoter-make NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.
