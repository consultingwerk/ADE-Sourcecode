/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _y-build.p

Description:
    Format Assistant - Helps the user enter a format for a variable.

ADE Tools That use this:
    UIB - called from property sheets for fill-ins (adeuib/_prpfill.p)
    
Input Parameters:
    iipType: dataType of variable 
              1-character 2-date 3-logical 4-integer 5-decimal 7-recid 
              34-datetime 40-datetime-tz 41-INT64
    
Input-Output Parameters:
    ciopFormat: the resulting format

Author: Tony Lavinio

Modified:
  wood  10-05-93  Added standard header to file.
  ryan  06-06-94  Sliding dec format eliminated, leading zeros option
                  boxes changed to radio-set, added support for European
                  format
  tsm   04/12/99  Added support for various Intl Numeric Formats (in addition
                  to American and European).  Check session numeric-decimal-point 
                  and numeric-separator to determine if adecomm/_convert is 
                  called rather than checking if European or American.  And 
                  changed call to adecomm/_convert to support converting from 
                  American to non-American (A-TO-N) and non-American to American 
                  (N-TO-A), rather than American to European and vice versa. 
                  Used session numeric-decimal-point and numeric-separator to set
                  standard formats and to create and display the format based 
                  on user's choices.     
  tsm   06/01/99  Set "Use Thousands Separator" toggle box based on whether
                  SESSION:NUMERIC-SEPARATOR is in the format instead of ","          
            

Test Code: -----------------------------------------------------------------
  def var test as char initial "->>,>>9.99" no-undo.
  run adecomm/_y-build.p (1, INPUT-OUTPUT test).
  message "OUTPUT:" test.
----------------------------------------------------------------------------*/

/* _y-build.p - format assistant */
&GLOBAL-DEFINE WIN95-BTN YES
{ adecomm/adestds.i }
{ adecomm/commeng.i }
{ adecomm/oeideservice.i}

DEFINE INPUT        PARAMETER iipType    AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER ciopFormat AS CHARACTER NO-UNDO.

DEFINE VARIABLE new_format AS CHARACTER NO-UNDO. 
DEFINE VARIABLE caption    AS CHARACTER NO-UNDO.                 

DEFINE VARIABLE qbf-c      AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-h      AS HANDLE    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i      AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-t1     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t2     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t3     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t4     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t5     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t6     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t7     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t8     AS CHARACTER VIEW-AS TEXT.
DEFINE VARIABLE qbf-t9     AS CHARACTER VIEW-AS TEXT.

DEFINE RECTANGLE rect-1 {&STDPH_OKBOX}.
DEFINE BUTTON bOk       {&STDPH_OKBTN} LABEL "   OK   ":c8 AUTO-GO.
DEFINE BUTTON bCancel   {&STDPH_OKBTN} LABEL " Cancel ":c8 AUTO-ENDKEY.
DEFINE BUTTON bHelp     {&STDPH_OKBTN} LABEL "&Help".
DEFINE BUTTON qbf-df    {&STDPH_OKBTN} LABEL "&Standard":c9.

DEFINE VARIABLE counter    AS INTEGER NO-UNDO. 
DEFINE VARIABLE lError     AS LOGICAL NO-UNDO. 

DEFINE VARIABLE isInt64    AS LOGICAL NO-UNDO INITIAL FALSE.

DEFINE VARIABLE notAmerican  AS LOGICAL  NO-UNDO.
DEFINE VARIABLE frameHandle as handle   NO-UNDO.

IF iipType = 7 THEN iipType = 4. /*  7 is recid */

IF iipType = 41 THEN
    ASSIGN isInt64 = TRUE
           iipType = 4.  /*41 is INT64, it will behave like integers*/

caption = "Format":U.

/*--------------------------------------------------------------------------*/
/* character */

DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO. /* string variable */
DEFINE VARIABLE in-qbf-i AS LOGICAL INITIAL FALSE NO-UNDO.  /* A flag */

FORM
  SKIP({&TFM_WID})
  "Character &Format:":t18 AT 4 VIEW-AS TEXT SKIP
  new_Format FORMAT "x(9999)" NO-LABEL VIEW-AS FILL-IN SIZE 30 BY 1
  {&STDPH_FILL} AT 4

  qbf-i FORMAT ">>>>9":u NO-LABEL
        VIEW-AS FILL-IN SIZE 6 BY 1 {&STDPH_FILL} AT ROW 3.5 COL 4
  "&Width":t12 VIEW-AS TEXT SIZE 8 BY 1 AT ROW 3.5 COL 12 SKIP (.5)
  qbf-s VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "Allow Any &Character","X",
    "&Allow Letters and Numbers Only","N",
    "Allow &Letters Only","A",
    "Allow Letters and Con&vert to Caps","!",
    "Allow &Numbers Only","9"  AT 15

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  WITH FRAME qbf%char 
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
     TITLE caption
     VIEW-AS DIALOG-BOX
  &else
     no-box
  &endif 
     NO-LABELS THREE-D
     DEFAULT-BUTTON bOk  .

  {adecomm/okrun.i  
     &FRAME  = "frame qbf%char" 
     &BOX    = "rect-1"
     &OK     = "bOK" 
     &OTHER  = "qbf-df"
     &HELP   = "bHelp" }

ON "Alt-F" OF FRAME qbf%char ANYWHERE
  APPLY "ENTRY" TO NEW_FORMAT IN FRAME qbf%char.
  
ON "Alt-W" OF FRAME qbf%char ANYWHERE
  APPLY "ENTRY" TO qbf-i IN FRAME qbf%char.
  
ON WINDOW-CLOSE OF FRAME qbf%char
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%char OR CHOOSE OF bHelp IN FRAME qbf%char
  RUN adecomm/_adehelp.p ("comm", "CONTEXT", 
                          {&Numeric_Format_Char_Dlg_Box}, ?).

ON ENTRY OF qbf-i IN FRAME qbf%char
  ASSIGN in-qbf-i = TRUE.
  
ON LEAVE OF qbf-i IN FRAME qbf%char DO:              
  ASSIGN in-qbf-i = FALSE.
  IF INTEGER(qbf-i:screen-value) > 4096 THEN DO:
      /*
      ** Note: 16k is an arbitrary limit to detect when a format is too large
      ** for the UIB/Results to handle without increasing the -s parm
      */
      MESSAGE qbf-i:screen-value "is too large for a character format." VIEW-AS ALERT-BOX WARNING.
      ASSIGN
        qbf-i:SCREEN-VALUE = STRING(qbf-i)
        qbf-i:AUTO-ZAP     = True.
      RETURN NO-APPLY.
  END.
    
  IF qbf-i <> INPUT FRAME qbf%char qbf-i THEN
    APPLY "VALUE-CHANGED" TO qbf-s IN FRAME qbf%char.
END.

ON VALUE-CHANGED OF qbf-s IN FRAME qbf%char
  ASSIGN
    qbf-s = qbf-s:SCREEN-VALUE IN FRAME qbf%char
    qbf-i = MAXIMUM(INPUT FRAME qbf%char qbf-i,1)
    new_Format:SCREEN-VALUE IN FRAME qbf%char
          = (IF qbf-i < 4 THEN
              FILL(qbf-s,qbf-i)
            ELSE
              qbf-s + "(":u + STRING(INPUT FRAME qbf%char qbf-i) + ")":u
            ).

ON LEAVE OF new_Format IN FRAME qbf%char DO:
  /* These lines are necessary to avoid the necessity of clicking twice in
     bHelp and qbf-s.                                                      */
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%char THEN RETURN. 
  IF LAST-EVENT:WIDGET-ENTER = qbf-s:HANDLE IN FRAME qbf%char THEN RETURN. 

  IF SELF:MODIFIED THEN DO:
    RUN adecomm/_chkfmt.p (1, "", "", SELF:SCREEN-VALUE, 
                           OUTPUT counter, OUTPUT lError).

    IF counter > 4096 THEN DO:
      /*
      ** Note: 16k is an arbitrary limit to detect when a format is too large
      ** for the UIB/Results to handle without increasing the -s parm
      */
      MESSAGE new_format:screen-value "is too large for a character format." VIEW-AS ALERT-BOX WARNING.
      ASSIGN
         new_format:SCREEN-VALUE = new_format
         new_format:AUTO-ZAP     = True.
      RETURN NO-APPLY.
    END.
     
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      new_Format:AUTO-ZAP = True.
      RETURN NO-APPLY.  
    END.
    new_Format = SELF:SCREEN-VALUE.
    RUN explore_charformat (new_Format).
  END.
END.

ON CHOOSE OF qbf-df IN FRAME qbf%char
  ASSIGN
    new_Format:SCREEN-VALUE IN FRAME qbf%char = "x(8)":u
    qbf-i:SCREEN-VALUE IN FRAME qbf%char      = 
      STRING(8,qbf-i:FORMAT IN FRAME qbf%char)
    qbf-s:SCREEN-VALUE IN FRAME qbf%char      = "x":u.

ON GO OF FRAME qbf%char OR CHOOSE OF bOk IN FRAME qbf%char DO:
  IF in-qbf-i THEN APPLY "LEAVE" TO qbf-i IN FRAME qbf%char.
  APPLY "LEAVE" TO new_Format IN FRAME qbf%char.
  ciopFormat = new_Format:SCREEN-VALUE IN FRAME qbf%char.
END.


/*--------------------------------------------------------------------------*/
/* date */

DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO. /* date variable */

FORM
  SKIP({&TFM_WID})
  qbf-t9 FORMAT "x(13)":u AT 4 VIEW-AS TEXT SKIP (.2)
  new_Format FORMAT "x(256)" NO-LABEL VIEW-AS FILL-IN SIZE 30 BY 1
    {&STDPH_FILL} AT 4

  SKIP(.3)

  qbf-d VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "99/99/99":u	,"99/99/99":u	 ,
    "99-99-99":u	,"99-99-99":u	 ,
    "99.99.99":u	,"99.99.99":u	 ,
    "99/99/9999":u	,"99/99/9999":u	 ,
    "99-99-9999":u	,"99-99-9999":u	 ,
    "99.99.9999":u	,"99.99.9999":u	 ,
    "999999":u		,"999999":u		 ,
    "99999999":u	,"99999999":u	 AT 25

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  WITH FRAME qbf%date 
  &if DEFINED(IDE-IS-RUNNING) = 0  &then
     TITLE caption
     VIEW-AS DIALOG-BOX
  &else
     no-box
  &endif 
     NO-LABELS THREE-D DEFAULT-BUTTON bOk.
  {adecomm/okrun.i  
    &FRAME  = "frame qbf%date" 
    &BOX    = "rect-1"
    &OK     = "bOK" 
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

ON ALT-D OF FRAME qbf%date
   APPLY "ENTRY":u TO new_Format IN FRAME qbf%date.

/*--------------------------------------------------------------------------*/

ON WINDOW-CLOSE OF FRAME qbf%date
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%date OR CHOOSE OF bhelp IN FRAME qbf%date
  RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", 
                            {&Numeric_Format_Date_Dlg_Box}, ?).

ON VALUE-CHANGED OF qbf-d IN FRAME qbf%date
  new_Format:SCREEN-VALUE IN FRAME qbf%date = 
    TRIM(qbf-d:SCREEN-VALUE IN FRAME qbf%date).

ON CHOOSE OF qbf-df IN FRAME qbf%date
  ASSIGN
    new_Format:SCREEN-VALUE IN FRAME qbf%date = "99/99/99":u
    qbf-d:SCREEN-VALUE IN FRAME qbf%date      = "99/99/99":u.

ON LEAVE OF new_Format IN FRAME qbf%date DO:
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%date THEN RETURN. 
  IF LAST-EVENT:WIDGET-ENTER = qbf-d:HANDLE IN FRAME qbf%date THEN RETURN. 

  IF SELF:MODIFIED THEN DO:
    RUN adecomm/_chkfmt.p (2, "", "", SELF:SCREEN-VALUE, 
                           OUTPUT counter, OUTPUT lError).
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      new_Format:AUTO-ZAP = True.
      RETURN NO-APPLY.  
    END.
    new_Format = SELF:SCREEN-VALUE.
  END.
END.

ON GO OF FRAME qbf%date OR CHOOSE OF bOk IN FRAME qbf%date DO:
  APPLY "LEAVE" TO new_Format IN FRAME qbf%date.
  ciopFormat = TRIM(new_Format:SCREEN-VALUE IN FRAME qbf%date).
END.

/*--------------------------------------------------------------------------*/
/* datetime */

DEFINE VARIABLE qbf-inc-tm     AS LOGICAL   NO-UNDO. /* include time variable */
DEFINE VARIABLE qbf-tm         AS CHARACTER NO-UNDO. /* datetime variable */
DEFINE VARIABLE qbf-dec-pl-sec AS INTEGER   NO-UNDO. /* decimal places for seconds */
DEFINE VARIABLE qbf-12-hr      AS LOGICAL   NO-UNDO. /* 12 hour format */

FORM
  SKIP({&TFM_WID})
  qbf-t9 FORMAT "x(20)":u AT 4 VIEW-AS TEXT SKIP (.2)
  new_Format FORMAT "x(256)" NO-LABEL VIEW-AS FILL-IN SIZE 33 BY 1
    {&STDPH_FILL} AT 4 SKIP (.3)

  qbf-d VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "99/99/99":u	,"99/99/99":u	 ,
    "99-99-99":u	,"99-99-99":u	 ,
    "99.99.99":u	,"99.99.99":u	 ,
    "99/99/9999":u	,"99/99/9999":u	 ,
    "99-99-9999":u	,"99-99-9999":u	 ,
    "99.99.9999":u	,"99.99.9999":u	 ,
    "999999":u		,"999999":u		 ,
    "99999999":u	,"99999999":u	 AT 10

  qbf-inc-tm LABEL "Include time" VIEW-AS TOGGLE-BOX AT 35 SKIP(.2)

  qbf-tm VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "HH":u       ,"HH":u       ,
    "HH:MM":u    ,"HH:MM":u    ,
    "HH:MM:SS":u ,"HH:MM:SS":u  AT ROW 4.6 COL 35 SKIP(.2)

  "Decimal places for seconds:" AT 35 

  qbf-dec-pl-sec FORMAT "9" VIEW-AS COMBO-BOX SIZE-CHARS 10 BY 1 LIST-ITEMS 0,1,2,3 AT 35 SKIP(.2)

  qbf-12-hr LABEL "12 hour format (AM/PM)" VIEW-AS TOGGLE-BOX AT 35

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  WITH FRAME qbf%datetime 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
  VIEW-AS DIALOG-BOX
  TITLE caption
&else
  no-box 
&endif
  NO-LABELS THREE-D
  DEFAULT-BUTTON bOk. 
  
  {adecomm/okrun.i  
    &FRAME  = "frame qbf%datetime" 
    &BOX    = "rect-1"
    &OK     = "bOK" 
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

ON ALT-D OF FRAME qbf%datetime
   APPLY "ENTRY":u TO new_Format IN FRAME qbf%datetime.

/*--------------------------------------------------------------------------*/

ON WINDOW-CLOSE OF FRAME qbf%datetime
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%datetime OR CHOOSE OF bhelp IN FRAME qbf%datetime
  RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", 
                            {&Numeric_Format_DateTime_Dlg_Box}, ?).

ON VALUE-CHANGED OF qbf-d IN FRAME qbf%datetime
  RUN setNewFormat4DateTime.

ON CHOOSE OF qbf-df IN FRAME qbf%datetime DO:
  ASSIGN
      qbf-d:SCREEN-VALUE = "99/99/9999":u
      qbf-inc-tm:CHECKED = TRUE
      qbf-tm:SCREEN-VALUE = "HH:MM:SS":u
      qbf-dec-pl-sec:SCREEN-VALUE = '3'
      qbf-12-hr:CHECKED = FALSE.
  RUN setNewFormat4DateTime.
  APPLY "VALUE-CHANGED" TO qbf-inc-tm.
END.

ON LEAVE OF new_Format IN FRAME qbf%datetime DO:
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%datetime THEN RETURN. 
  IF LAST-EVENT:WIDGET-ENTER = qbf-d:HANDLE IN FRAME qbf%datetime THEN RETURN. 

  IF SELF:MODIFIED THEN DO:
    RUN adecomm/_chkfmt.p (34, "", "", SELF:SCREEN-VALUE, 
                           OUTPUT counter, OUTPUT lError).
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      new_Format:AUTO-ZAP = True.
      RETURN NO-APPLY.  
    END.
    new_Format = SELF:SCREEN-VALUE.
  END.
END.

ON GO OF FRAME qbf%datetime OR CHOOSE OF bOk IN FRAME qbf%datetime DO:
  APPLY "LEAVE" TO new_Format IN FRAME qbf%datetime.
  ciopFormat = TRIM(new_Format:SCREEN-VALUE IN FRAME qbf%datetime).
END.

/*--------------------------------------------------------------------------*/
/* datetime-tz */

DEFINE VARIABLE qbf-inc-tz AS LOGICAL    NO-UNDO. /* Include Time Zone */

FORM
  SKIP({&TFM_WID})
  qbf-t9 FORMAT "x(20)":u AT 4 VIEW-AS TEXT SKIP (.2)
  new_Format FORMAT "x(256)" NO-LABEL VIEW-AS FILL-IN SIZE 45 BY 1
    {&STDPH_FILL} AT 4 SKIP (.3)

  qbf-d VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "99/99/99":u	,"99/99/99":u	 ,
    "99-99-99":u	,"99-99-99":u	 ,
    "99.99.99":u	,"99.99.99":u	 ,
    "99/99/9999":u	,"99/99/9999":u	 ,
    "99-99-9999":u	,"99-99-9999":u	 ,
    "99.99.9999":u	,"99.99.9999":u	 ,
    "999999":u		,"999999":u		 ,
    "99999999":u	,"99999999":u	 AT 10

  qbf-inc-tm LABEL "Include time" VIEW-AS TOGGLE-BOX AT 35 SKIP(.2)

  qbf-tm VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "HH":u       ,"HH":u       ,
    "HH:MM":u    ,"HH:MM":u    ,
    "HH:MM:SS":u ,"HH:MM:SS":u  AT ROW 4.6 COL 35 SKIP(.2)

  "Decimal places for seconds:" AT 35 

  qbf-dec-pl-sec FORMAT "9" VIEW-AS COMBO-BOX SIZE-CHARS 10 BY 1 LIST-ITEMS 0,1,2,3 AT 35 SKIP(.2)

  qbf-12-hr LABEL "12 hour format (AM/PM)" VIEW-AS TOGGLE-BOX AT 35 SKIP(.2)

  qbf-inc-tz LABEL "Include time zone" VIEW-AS TOGGLE-BOX AT 35

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  WITH FRAME qbf%datetimetz 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
  VIEW-AS DIALOG-BOX
  TITLE caption
&else
  no-box 
&endif
  NO-LABELS 
  THREE-D
  DEFAULT-BUTTON bOk .

  {adecomm/okrun.i  
    &FRAME  = "frame qbf%datetimetz" 
    &BOX    = "rect-1"
    &OK     = "bOK" 
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

ON ALT-D OF FRAME qbf%datetimetz
   APPLY "ENTRY":u TO new_Format IN FRAME qbf%datetimetz.

/*--------------------------------------------------------------------------*/

ON WINDOW-CLOSE OF FRAME qbf%datetimetz
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%datetimetz OR CHOOSE OF bhelp IN FRAME qbf%datetimetz
  RUN "adecomm/_adehelp.p" ("comm", "CONTEXT", 
                            {&Numeric_Format_DateTimeTz_Dlg_Box}, ?).

ON VALUE-CHANGED OF qbf-d IN FRAME qbf%datetimetz
  RUN setNewFormat4DateTimeTZ.

ON CHOOSE OF qbf-df IN FRAME qbf%datetimetz DO:
  ASSIGN
      qbf-d:SCREEN-VALUE = "99/99/9999":u
      qbf-inc-tm:CHECKED = TRUE
      qbf-tm:SCREEN-VALUE = "HH:MM:SS":u
      qbf-dec-pl-sec:SCREEN-VALUE = '3'
      qbf-12-hr:CHECKED = FALSE
      qbf-inc-tz:CHECKED = TRUE.
  RUN setNewFormat4DateTimeTZ.
  APPLY "VALUE-CHANGED" TO qbf-inc-tm.
END.

ON LEAVE OF new_Format IN FRAME qbf%datetimetz DO:
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%datetimetz THEN RETURN. 
  IF LAST-EVENT:WIDGET-ENTER = qbf-d:HANDLE IN FRAME qbf%datetimetz THEN RETURN. 

  IF SELF:MODIFIED THEN DO:
    RUN adecomm/_chkfmt.p (40, "", "", SELF:SCREEN-VALUE, 
                           OUTPUT counter, OUTPUT lError).
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      new_Format:AUTO-ZAP = True.
      RETURN NO-APPLY.  
    END.
    new_Format = SELF:SCREEN-VALUE.
  END.
END.

ON GO OF FRAME qbf%datetimetz OR CHOOSE OF bOk IN FRAME qbf%datetimetz DO:
  APPLY "LEAVE" TO new_Format IN FRAME qbf%datetimetz.
  ciopFormat = TRIM(new_Format:SCREEN-VALUE IN FRAME qbf%datetimetz).
END.

/*--------------------------------------------------------------------------*/
/* logical */

DEFINE VARIABLE qbf-l1 AS CHARACTER NO-UNDO. /* logical (true) variable */
DEFINE VARIABLE qbf-l2 AS CHARACTER NO-UNDO. /* logical (false) variable */

 
FORM
  SKIP({&TFM_WID})
  qbf-t1 FORMAT "x(18)":u  AT 10 VIEW-AS TEXT SKIP
  new_Format FORMAT "x(256)" VIEW-AS FILL-IN SIZE 30 BY 1 {&STDPH_FILL} AT 10
 
  qbf-t2 FORMAT "x(32)":u  AT 10 VIEW-AS TEXT SKIP
  qbf-l1 FORMAT "x(30)":u  AT 10
  SKIP(.5)
  qbf-t3 FORMAT "x(32)":u  AT 10 VIEW-AS TEXT SKIP
  qbf-l2 FORMAT "x(30)":u  AT 10

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  WITH FRAME qbf%logi 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
  VIEW-AS DIALOG-BOX
  TITLE caption
&else
  no-box 
&endif
  NO-LABELS THREE-D
  DEFAULT-BUTTON bOk. 

  {adecomm/okrun.i  
    &FRAME  = "frame qbf%logi" 
    &BOX    = "rect-1"
    &OK     = "bOK" 
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

                               
ON ALT-L OF FRAME qbf%logi
   APPLY "ENTRY":u TO new_format IN FRAME qbf%logi.

ON ALT-T OF FRAME qbf%logi
   APPLY "ENTRY":u TO qbf-l1     IN FRAME qbf%logi.

ON ALT-F OF FRAME qbf%logi
   APPLY "ENTRY":u TO qbf-l2     IN FRAME qbf%logi.

/*--------------------------------------------------------------------------*/

ON WINDOW-CLOSE OF FRAME qbf%logi
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%logi OR CHOOSE OF bHelp IN FRAME qbf%logi
  RUN adecomm/_adehelp.p ("comm", "CONTEXT", 
      	       	     	  {&Numeric_Format_Logical_Dlg_Box}, ?).

ON ENTRY,LEAVE OF qbf-l1 IN FRAME qbf%logi, qbf-l2 iN FRAME qbf%logi
  new_Format:SCREEN-VALUE IN FRAME qbf%logi =
    qbf-l1:SCREEN-VALUE IN FRAME qbf%logi + "/":u + 
    qbf-l2:SCREEN-VALUE IN FRAME qbf%logi.
 
ON CHOOSE OF qbf-df IN FRAME qbf%logi
  ASSIGN
    new_Format:SCREEN-VALUE IN FRAME qbf%logi = "yes/no":u
    qbf-l1:SCREEN-VALUE IN FRAME qbf%logi     = "yes":u
    qbf-l2:SCREEN-VALUE IN FRAME qbf%logi     = "no":u
  .

ON LEAVE OF new_Format IN FRAME qbf%logi DO:
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%logi THEN RETURN. 
  IF LAST-EVENT:WIDGET-ENTER = qbf-l1:HANDLE IN FRAME qbf%logi THEN RETURN. 

  IF SELF:MODIFIED THEN DO:
     RUN adecomm/_chkfmt.p (3, "", "", SELF:SCREEN-VALUE, 
                            OUTPUT counter, OUTPUT lError).
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      new_Format:AUTO-ZAP = True.
      RETURN NO-APPLY.  
    END.
    ASSIGN
      new_Format          = SELF:SCREEN-VALUE 
      qbf-l1:screen-value = if num-entries(new_format,"/":U) > 1 then
                            entry(1,new_format,"/":U) else new_format
      qbf-l2:screen-value = if num-entries(new_format,"/":U) > 1 then
                            entry(2,new_format,"/":U) else new_format.
  END.
END.

ON GO OF FRAME qbf%logi OR CHOOSE OF bOk IN FRAME qbf%logi DO:
  APPLY "LEAVE" TO new_Format IN FRAME qbf%logi.
  ciopFormat = TRIM(new_Format:SCREEN-VALUE IN FRAME qbf%logi).
END.

/*--------------------------------------------------------------------------*/
/* integer/decimal */

DEFINE VARIABLE dec_separator as char no-undo.
DEFINE VARIABLE tho_separator as char no-undo.
DEFINE VARIABLE conv_fmt      as char no-undo.

DEFINE VARIABLE qbf-na AS LOGICAL   NO-UNDO.  /* use leading ***'s */
DEFINE VARIABLE qbf-nb AS LOGICAL   NO-UNDO.  /* show zero as '' (not '0') */
DEFINE VARIABLE qbf-nc AS LOGICAL   NO-UNDO.  /* use thousands separator */
DEFINE VARIABLE qbf-nd AS INTEGER   NO-UNDO.  /* number of decimal places */
DEFINE VARIABLE qbf-nl AS CHARACTER NO-UNDO.  /* leading text string */
DEFINE VARIABLE qbf-nn AS INTEGER   NO-UNDO.  /* total number of digits */
DEFINE VARIABLE qbf-np AS INTEGER   NO-UNDO. /* Positive/Negative handling */
                        
DEFINE VARIABLE qbf-ns AS LOGICAL   NO-UNDO.  /* sliding decimal format */
DEFINE VARIABLE qbf-nt AS CHARACTER NO-UNDO.  /* trailing text string */
DEFINE VARIABLE qbf-nz AS LOGICAL   NO-UNDO.  /* suppress leading zeros */
DEFINE VARIABLE qbf-zr AS INTEGER   NO-UNDO.  /* Zero radio-set */

ASSIGN
  dec_separator = SESSION:NUMERIC-DECIMAL-POINT
  tho_separator = SESSION:NUMERIC-SEPARATOR.

/* Determine whether the numeric format is non-American and sets notAmerican
   variable which is used to determine whether to call _convert.p or not */
IF tho_separator NE "," OR dec_separator NE "." THEN notAmerican = yes.
ELSE notAmerican = no.

FORM
  SKIP({&TFM_WID})
  qbf-t4 FORMAT "x(18)":u  AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  new_Format FORMAT "x(256)" AT 2 VIEW-AS FILL-IN SIZE 30 BY 1 {&STDPH_FILL} 
     SKIP({&VM_WIDG})
  qbf-nn FORMAT ">>9":u VIEW-AS FILL-IN {&STDPH_FILL} AT 2
  qbf-t5 FORMAT "x(30)":u VIEW-AS TEXT SKIP({&VM_WID})
  qbf-nd FORMAT ">>9":u VIEW-AS FILL-IN {&STDPH_FILL} AT 2 
  qbf-t6 FORMAT "x(30)":u VIEW-AS TEXT SKIP({&VM_WID})
  qbf-nc VIEW-AS TOGGLE-BOX LABEL "&Use Thousand's Separator ///":t30 
   AT 2 SKIP({&VM_WIDG}) 
  qbf-zr VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "Suppress Leading Zeros":t30   ,1,
    "Show As Zero":t30             ,2,
    "Show As Asterisk":t30         ,3
    AT 2 SKIP (.75)
  qbf-t7 FORMAT "x(24)":u VIEW-AS TEXT AT 2 SKIP({&VM_WID})
  qbf-nl FORMAT "x(30)":u VIEW-AS FILL-IN  {&STDPH_FILL} AT 2 SKIP({&VM_WID})
  qbf-t8 FORMAT "x(24)":u VIEW-AS TEXT AT 2 SKIP({&VM_WID})
  qbf-nt FORMAT "x(30)":u VIEW-AS FILL-IN  {&STDPH_FILL} AT 2 

  {adecomm/okform.i
    &BOX    = "rect-1"
    &STATUS =  no
    &OK     = "bOk"
    &CANCEL = "bCancel"
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

  qbf-np VIEW-AS RADIO-SET VERTICAL RADIO-BUTTONS
    "Show Leading Sign Always"	          , 01,
    "Show Leading Sign on Negatives Only"   , 02,
    "Show Trailing Sign Always"	          , 03,
    "Show Trailing Sign on Negatives Only"  , 04,
    "Show Negative Numbers in Parentheses"  , 05,
    "Show Negatives With Trailing 'CR'"     , 06,
    "Show Negatives With Trailing 'DB'"     , 07,
    "Show Negatives With Trailing 'DR'"     , 08,
    "Show Negatives With Trailing 'cr '"    , 09,
    "Show Negatives With Trailing 'db '"    , 10,
    "Show Negatives With Trailing 'dr '"    , 11,
    "Allow Positive Numbers Only"           , 12   
    &IF LOOKUP("{&OPSYS}" , "MSDOS,WIN32":u) = 0
    &THEN 
       SIZE 42 by 13.5 
    &ELSE
       SIZE 42 by 12                                
    &ENDIF
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
      AT ROW-OF new_Format COLUMN 40 
    &ELSE
      AT ROW-OF new_Format - .5 COLUMN 40
    &ENDIF

  WITH FRAME qbf%numb 
&if DEFINED(IDE-IS-RUNNING) = 0  &then
  VIEW-AS DIALOG-BOX
  TITLE caption
&else
  no-box 
&endif
  NO-LABELS SCROLLABLE THREE-D
  DEFAULT-BUTTON bOk. 

ASSIGN qbf-t5:HEIGHT IN FRAME qbf%numb = qbf-nn:HEIGHT
       qbf-t6:HEIGHT IN FRAME qbf%numb = qbf-nd:HEIGHT.


  {adecomm/okrun.i  
    &FRAME  = "frame qbf%numb" 
    &BOX    = "rect-1"
    &OK     = "bOK" 
    &OTHER  = "qbf-df"
    &HELP   = "bHelp" }

ON ALT-F OF FRAME qbf%numb
   APPLY "ENTRY":u TO new_Format IN FRAME qbf%numb.

ON ALT-N OF FRAME qbf%numb
   APPLY "ENTRY":u TO qbf-nn     IN FRAME qbf%numb.

ON ALT-D OF FRAME qbf%numb
   APPLY "ENTRY":u TO qbf-nd     IN FRAME qbf%numb.

ON ALT-L OF FRAME qbf%numb
   APPLY "ENTRY":u TO qbf-nl     IN FRAME qbf%numb.

ON ALT-T OF FRAME qbf%numb
   APPLY "ENTRY":u TO qbf-nt     IN FRAME qbf%numb.

ON WINDOW-CLOSE OF FRAME qbf%numb
  APPLY "END-ERROR" TO SELF.             

ON HELP OF FRAME qbf%numb OR CHOOSE OF bHelp IN FRAME qbf%numb
  RUN adecomm/_adehelp.p ("comm", "CONTEXT", 
      	       	     	  {&Numeric_Format_Number_Dlg_Box}, ?).

/*--------------------------------------------------------------------------*/

ON LEAVE OF new_Format IN FRAME qbf%numb DO: 
  RUN check_numb_format.
  IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
END.

ON 
  VALUE-CHANGED OF qbf-nc IN FRAME qbf%numb
  OR VALUE-CHANGED OF qbf-zr IN FRAME qbf%numb
  OR VALUE-CHANGED OF qbf-np IN FRAME qbf%numb 
DO:
/*message "before assign" qbf-np qbf-np:screen-value view-as alert-box.*/
  ASSIGN
    qbf-nc = INPUT FRAME qbf%numb qbf-nc
    qbf-nn = INPUT FRAME qbf%numb qbf-nn
    qbf-np = INTEGER(qbf-np:screen-value)
    qbf-zr = INTEGER(qbf-zr:screen-value)
    qbf-nz = IF qbf-zr = 1 THEN True ELSE False
    qbf-nb = IF qbf-zr = 2 THEN True ELSE False
    qbf-na = IF qbf-zr = 3 THEN True ELSE False.
  RUN construct_format (OUTPUT new_Format).
  DISPLAY new_Format WITH FRAME qbf%numb.
END.


ON LEAVE OF qbf-nd IN FRAME qbf%numb 
  OR LEAVE OF qbf-nn IN FRAME qbf%numb 
  OR LEAVE OF qbf-nl IN FRAME qbf%numb
  OR LEAVE OF qbf-nt IN FRAME qbf%numb DO:


  DEFINE VARIABLE qbf_c   AS CHARACTER CASE-SENSITIVE NO-UNDO.
  define variable i       as integer    no-undo.
  define variable badChar as logical    no-undo. 
  define variable TestDigits as integer no-undo.    
                   
  if integer(qbf-nn:screen-value) > 256 then do:      
    message "The format cannot exceed 256 characters," skip
    "including punctuation characters." view-as alert-box warning. 
    assign
      qbf-nn:screen-value = "256"
      qbf-nn:auto-zap     = true.
    return no-apply.
  end.


  IF    qbf-nn = INPUT FRAME qbf%numb qbf-nn
    AND qbf-nd = INPUT FRAME qbf%numb qbf-nd
    AND qbf-nl = INPUT FRAME qbf%numb qbf-nl
    AND qbf-nt = INPUT FRAME qbf%numb qbf-nt THEN RETURN.

  /* If user changed the number of decimal digits, reset the total
     digits based on how much this grew or shrunk from previous 
     value.
  */
  IF SELF = qbf-nd:HANDLE IN FRAME qbf%numb THEN 
    ASSIGN
      qbf-nn = MIN(qbf-nn + (INPUT FRAME qbf%numb qbf-nd - qbf-nd), 50)
      qbf-nn:SCREEN-VALUE IN FRAME qbf%numb = STRING(qbf-nn,">>>9":u).

  ASSIGN
    qbf-nn = INPUT FRAME qbf%numb qbf-nn
    qbf-nd = INPUT FRAME qbf%numb qbf-nd
    qbf-nl = INPUT FRAME qbf%numb qbf-nl
    qbf-nt = INPUT FRAME qbf%numb qbf-nt.

  /*
   * Check the leading and trailing strings for "bad" characters.
   */

  badChar = false.
  do i = 1 to LENGTH(qbf-nl,"CHARACTER":u):

    qbf_c = SUBSTRING(qbf-nl,i,1,"CHARACTER":u).
    if index("+-<>,.*zZ01923456789", qbf_c) > 0 then do:
        badChar = true.
        leave.
    end.

  end.
  
  qbf-nl = qbf-nl + " ". /* used as separator */
  
  if badChar = true then do:
      message "The Leading Text String" qbf-nl "contains the" skip
              "character" qbf_c ". This character is not allowed" skip
              "in a leading text string."
      view-as alert-box.
      return no-apply.

  end.

  badChar = false.
  DO i = 1 to LENGTH(qbf-nt,"CHARACTER":u):

    qbf_c = SUBSTRING(qbf-nt,i,1,"CHARACTER":u).
    IF INDEX("+-<>,.*zZ01923456789", qbf_c) > 0 then do:

       badChar = true.
       leave.
    END.
  END.

  IF iipType = 4 THEN DO:
    IF isInt64 THEN
    DO:
        IF qbf-nn > 18 THEN DO:
           MESSAGE "INT64 values cannot have more than 18 digits."
                VIEW-AS ALERT-BOX ERROR.
           RETURN NO-APPLY.
       END.
    END.
    ELSE IF qbf-nn > 10 THEN
    DO:
        MESSAGE "Integer values cannot have more than 10 digits."
            VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
  END. /*IF iipType = 4 THEN DO*/
  ELSE IF iipType = 5 AND qbf-nn > 50 THEN DO:
    MESSAGE "Decimal values cannot have more than 50 digits."
        VIEW-AS ALERT-BOX ERROR.
    RETURN NO-APPLY.
  END.
  
  if badChar = true then do:

      message "The Trailing Text String" qbf-nl "contains the" skip
              "character" qbf_c ". This character is not allowed" skip
              "in a trailing text string."
      view-as alert-box.
      return no-apply.

  end.

  IF SELF = qbf-nn:HANDLE IN FRAME qbf%numb THEN 
    IF qbf-nn < qbf-nd THEN
      ASSIGN
      	qbf-nd = qbf-nn
        qbf-nd:SCREEN-VALUE IN FRAME qbf%numb = STRING(qbf-nd,">>>9":u).

  RUN construct_format (OUTPUT qbf_c).
  new_Format:SCREEN-VALUE IN FRAME qbf%numb = qbf_c.
END.

ON CHOOSE OF qbf-df IN FRAME qbf%numb DO:

  IF iipType = 4 THEN  /* integer */
    new_Format:SCREEN-VALUE = IF notAmerican THEN "->":U + tho_separator + ">>>":U + tho_separator + ">>9":U
                              ELSE "->,>>>,>>9":U.
  ELSE  /* decimal */
    new_Format:SCREEN-VALUE = IF notAmerican THEN "->>":U + tho_separator + ">>9":U + dec_separator + "99":U
                              ELSE "->>,>>9.99":U.
  ASSIGN
    qbf-nc:screen-value      = STRING(TRUE)   
    qbf-nd:screen-value      = STRING((IF iipType = 4 THEN 0 ELSE 2))
    qbf-nl:screen-value      = ""
    qbf-nn:screen-value      = STRING(7)
    qbf-np:screen-value      = STRING(2)
    qbf-nt:screen-value      = ""
    qbf-nz                   = new_Format:screen-value BEGINS ">" OR
                               new_Format:screen-value BEGINS "Z"
    qbf-zr                   = 1
    qbf-zr:screen-value      = string(qbf-zr)
    qbf-nt                   = "".
END.

ON GO OF FRAME qbf%numb OR CHOOSE OF bOk IN FRAME qbf%numb DO:
  RUN check_numb_format.
  IF RETURN-VALUE = "error" THEN RETURN NO-APPLY.
  ciopFormat = TRIM(new_Format:SCREEN-VALUE IN FRAME qbf%numb).
END.

ON VALUE-CHANGED OF qbf-inc-tm IN FRAME qbf%datetime
DO:
    ASSIGN
        qbf-inc-tm
        qbf-tm
        qbf-tm:SENSITIVE = qbf-inc-tm = TRUE
        qbf-dec-pl-sec:SENSITIVE = qbf-inc-tm = TRUE AND qbf-tm = "HH:MM:SS"
        qbf-12-hr:SENSITIVE = qbf-inc-tm = TRUE.
    RUN setNewFormat4DateTime.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-tm IN FRAME qbf%datetime
DO:
    ASSIGN
        qbf-tm
        qbf-dec-pl-sec:SENSITIVE = qbf-tm = "HH:MM:SS".
    RUN setNewFormat4DateTime.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-dec-pl-sec IN FRAME qbf%datetime
DO:
    RUN setNewFormat4DateTime.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-12-hr IN FRAME qbf%datetime
DO:
    RUN setNewFormat4DateTime.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-inc-tm IN FRAME qbf%datetimetz
DO:
    ASSIGN
        qbf-inc-tm
        qbf-tm
        qbf-tm:SENSITIVE = qbf-inc-tm = TRUE
        qbf-dec-pl-sec:SENSITIVE = qbf-inc-tm = TRUE AND qbf-tm = "HH:MM:SS"
        qbf-12-hr:SENSITIVE = qbf-inc-tm = TRUE
        qbf-inc-tz:SENSITIVE = qbf-inc-tm = TRUE.
    RUN setNewFormat4DateTimeTZ.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-tm IN FRAME qbf%datetimetz
DO:
    ASSIGN
        qbf-tm
        qbf-dec-pl-sec:SENSITIVE = qbf-tm = "HH:MM:SS".
    RUN setNewFormat4DateTimeTZ.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-dec-pl-sec IN FRAME qbf%datetimetz
DO:
    RUN setNewFormat4DateTimeTZ.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-12-hr IN FRAME qbf%datetimetz
DO:
    RUN setNewFormat4DateTimeTZ.
    RETURN.
END.

ON VALUE-CHANGED OF qbf-inc-tz IN FRAME qbf%datetimetz
DO:
    RUN setNewFormat4DateTimeTZ.
    RETURN.
END.

/*-- main ----------------------------*/

ASSIGN qbf-i:WIDTH IN FRAME qbf%char = qbf-i:WIDTH IN FRAME qbf%char + .5.

/* used to define on choose of cancel and apply in dialoginit.i */
&SCOPED-DEFINE CANCEL-EVENT U2

new_Format = ciopFormat. /* Copy INPUT-OUTPUT parameter into local variable */
CASE iipType:
  WHEN 1 THEN DO: /* character ---------------------------------------------*/
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%char:handle"}
     dialogService:View().
     &endif
    
    
    IF new_Format = ? OR new_Format = "" THEN new_Format = "x(8)":u.
    ASSIGN
      qbf-i = LENGTH(STRING("",new_Format),"RAW":u)
      qbf-i:SCREEN-VALUE IN FRAME qbf%char = STRING(qbf-i,">>>>9":u)
    &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%char:THREE-D = SESSION:THREE-D
    &ENDIF  
      .
     
    IF INDEX("xna!9":u,SUBSTRING(new_Format,1,1,"CHARACTER":u)) > 0 THEN
      qbf-s:SCREEN-VALUE IN FRAME qbf%char = SUBSTRING(new_Format,1,1,
                                                       "CHARACTER":u).

    ENABLE new_Format qbf-i qbf-s bOk bCancel qbf-df bHelp WITH FRAME qbf%char.
    APPLY "ENTRY" TO qbf-i IN FRAME qbf%char.
    new_Format:SCREEN-VALUE IN FRAME qbf%char = new_Format.
    
    {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%char}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%char.
        &ELSE
        WAIT-FOR GO OF FRAME qbf%char or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
        &endif      
    END.
    HIDE FRAME qbf%char NO-PAUSE.
  END.
  WHEN 2 THEN DO: /* date --------------------------------------------------*/
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%date:handle"}
     dialogService:View().
     &endif
    IF new_Format = ? OR new_Format = "" THEN new_Format = "99/99/99":u.
    RUN date_settings (OUTPUT qbf-d,OUTPUT qbf-i).

    ASSIGN
      qbf-d = "99/99/99,99-99-99,99.99.99,":u
            + (IF qbf-d MATCHES "..y":u THEN
                "99/99/9999,99-99-9999,99.99.9999":u
              ELSE IF qbf-d MATCHES "y..":u THEN
                "9999/99/99,9999-99-99,9999.99.99":u
              ELSE
                "99/9999/99,99-9999-99,99.9999.99":u)
            + ",999999,99999999":u
      qbf-t9 = "&Date Format:":t13

      &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%date:THREE-D = SESSION:THREE-D
      &endif

      qbf-h  = qbf-d:HANDLE IN FRAME qbf%date
      qbf-c  = ""
      .
 
    /* interweave qbf-d values to create new radio-set values, i.e.
       "label1,value1,label2,value2..." */ 
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-d):
      qbf-c = qbf-c + (IF qbf-i > 1 THEN ",":u ELSE "")
            + ENTRY(qbf-i,qbf-d) + ",":u + ENTRY(qbf-i,qbf-d).
    END.
    qbf-h:RADIO-BUTTONS = qbf-c.

    DISPLAY qbf-t9
      WITH FRAME qbf%date.

    ENABLE new_Format qbf-d bOk bCancel qbf-df bHelp WITH FRAME qbf%date.
    APPLY "ENTRY" TO qbf-d IN FRAME qbf%date.

    IF LOOKUP(new_Format,qbf-d) > 0 THEN
      qbf-d:SCREEN-VALUE IN FRAME qbf%date = new_Format.

    new_Format:SCREEN-VALUE IN FRAME qbf%date = new_Format.
    {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%date}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%date.
        &ELSE
        WAIT-FOR GO OF FRAME qbf%date or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
        &endif      
    END.
    HIDE FRAME qbf%date NO-PAUSE.
  END.
  WHEN 34 THEN DO: /* datetime ---------------------------------------------*/
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%datetime:handle"}
     dialogService:View().
     &endif
    IF new_Format = ? OR new_Format = "" THEN new_Format = "99/99/99 HH:MM:SS":u.
    RUN date_settings (OUTPUT qbf-d,OUTPUT qbf-i).

    ASSIGN
      qbf-d = "99/99/99,99-99-99,99.99.99,":u
            + (IF qbf-d MATCHES "..y":u THEN
                "99/99/9999,99-99-9999,99.99.9999":u
              ELSE IF qbf-d MATCHES "y..":u THEN
                "9999/99/99,9999-99-99,9999.99.99":u
              ELSE
                "99/9999/99,99-9999-99,99.9999.99":u)
            + ",999999,99999999":u
      qbf-t9 = "&DateTime Format:":t20
        &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%datetime:THREE-D = SESSION:THREE-D
        &endif
      qbf-h  = qbf-d:HANDLE IN FRAME qbf%datetime
      qbf-c  = ""
      .

    /* interweave qbf-d values to create new radio-set values, i.e.
       "label1,value1,label2,value2..." */ 
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-d):
      qbf-c = qbf-c + (IF qbf-i > 1 THEN ",":u ELSE "")
            + ENTRY(qbf-i,qbf-d) + ",":u + ENTRY(qbf-i,qbf-d).
    END.
    qbf-h:RADIO-BUTTONS = qbf-c.

    /* determine time values from new_Format */
    ASSIGN
        qbf-tm = IF new_Format MATCHES "*HH:MM:SS*"
                 THEN "HH:MM:SS"
                 ELSE IF new_Format MATCHES "*HH:MM*"
                      THEN "HH:MM"
                      ELSE IF new_Format MATCHES "*HH*"
                           THEN "HH"
                           ELSE ""
        qbf-inc-tm = qbf-tm > ""
        qbf-dec-pl-sec = IF new_Format MATCHES "*HH:MM:SS.SSS*"
                         THEN 3
                         ELSE IF new_Format MATCHES "*HH:MM:SS.SS*"
                              THEN 2
                              ELSE IF new_Format MATCHES "*HH:MM:SS.S*"
                                   THEN 1
                                   ELSE 0
        qbf-12-hr = new_Format MATCHES "*AM*".

    DISPLAY qbf-t9 qbf-inc-tm qbf-tm qbf-dec-pl-sec qbf-12-hr
      WITH FRAME qbf%datetime.

    ENABLE new_Format qbf-d qbf-inc-tm bOk bCancel qbf-df bHelp WITH FRAME qbf%datetime.
        
    APPLY "ENTRY" TO qbf-d IN FRAME qbf%datetime.

    IF LOOKUP(ENTRY(1,new_Format," "),qbf-d) > 0 THEN
      qbf-d:SCREEN-VALUE IN FRAME qbf%datetime = ENTRY(1,new_Format," ").

    RUN setNewFormat4DateTime.
    APPLY "VALUE-CHANGED":U TO qbf-inc-tm IN FRAME qbf%datetime.

    {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%datetime}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%datetime.
        &ELSE
        WAIT-FOR GO OF FRAME qbf%datetime or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
        &endif
    END.
    HIDE FRAME qbf%datetime NO-PAUSE.
  END.
  WHEN 40 THEN DO: /* datetimetz -------------------------------------------*/
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%datetimetz:handle"}
     dialogService:View().
     &endif
   
    IF new_Format = ? OR new_Format = "" THEN new_Format = "99/99/99 HH:MM:SS":u.
    RUN date_settings (OUTPUT qbf-d,OUTPUT qbf-i).

    ASSIGN
      qbf-d = "99/99/99,99-99-99,99.99.99,":u
            + (IF qbf-d MATCHES "..y":u THEN
                "99/99/9999,99-99-9999,99.99.9999":u
              ELSE IF qbf-d MATCHES "y..":u THEN
                "9999/99/99,9999-99-99,9999.99.99":u
              ELSE
                "99/9999/99,99-9999-99,99.9999.99":u)
            + ",999999,99999999":u
      qbf-t9 = "&DateTime-TZ Format:":t20
        &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%datetimetz:THREE-D = SESSION:THREE-D
        &endif
      qbf-h  = qbf-d:HANDLE IN FRAME qbf%datetimetz
      qbf-c  = ""
      .

    /* interweave qbf-d values to create new radio-set values, i.e.
       "label1,value1,label2,value2..." */ 
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-d):
      qbf-c = qbf-c + (IF qbf-i > 1 THEN ",":u ELSE "")
            + ENTRY(qbf-i,qbf-d) + ",":u + ENTRY(qbf-i,qbf-d).
    END.
    qbf-h:RADIO-BUTTONS = qbf-c.

    /* determine time values from new_Format */
    ASSIGN
        qbf-tm = IF new_Format MATCHES "*HH:MM:SS*"
                 THEN "HH:MM:SS"
                 ELSE IF new_Format MATCHES "*HH:MM*"
                      THEN "HH:MM"
                      ELSE IF new_Format MATCHES "*HH*"
                           THEN "HH"
                           ELSE ""
        qbf-inc-tm = qbf-tm > ""
        qbf-dec-pl-sec = IF new_Format MATCHES "*HH:MM:SS.SSS*"
                         THEN 3
                         ELSE IF new_Format MATCHES "*HH:MM:SS.SS*"
                              THEN 2
                              ELSE IF new_Format MATCHES "*HH:MM:SS.S*"
                                   THEN 1
                                   ELSE 0
        qbf-12-hr = new_Format MATCHES "*AM*"
        qbf-inc-tz = new_Format MATCHES "*+HH:MM*".

    DISPLAY qbf-t9 qbf-inc-tm qbf-tm qbf-dec-pl-sec qbf-12-hr qbf-inc-tz
      WITH FRAME qbf%datetimetz.

    ENABLE new_Format qbf-d qbf-inc-tm bOk bCancel qbf-df bHelp WITH FRAME qbf%datetimetz.

    APPLY "ENTRY" TO qbf-d IN FRAME qbf%datetimetz.

    IF LOOKUP(ENTRY(1,new_Format," "),qbf-d) > 0 THEN
      qbf-d:SCREEN-VALUE IN FRAME qbf%datetimetz = ENTRY(1,new_Format," ").

    RUN setNewFormat4DateTimeTZ.
    APPLY "VALUE-CHANGED":U TO qbf-inc-tm.
    {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%datetimetz}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
           &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%datetimetz.
            &ELSE
        WAIT-FOR GO OF FRAME qbf%datetimetz  or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
            &endif
    END.
    HIDE FRAME qbf%datetimetz NO-PAUSE.
  END.
  WHEN 3 THEN DO: /* logical -----------------------------------------------*/
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%logi:handle"}
     dialogService:View().
     &endif
    IF new_Format = ? OR new_Format = "" OR
    NUM-ENTRIES(new_Format,"/":U) NE 2 THEN
       new_Format = "yes/no":u.

    ASSIGN
      qbf-t1 = "&Logical Format:":t18
      qbf-t2 = "Display This When &TRUE:":t32
      qbf-t3 = "Display This When &FALSE:":t32
        &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%logi:THREE-D = SESSION:THREE-D
        &endif
      .
    
    DISPLAY qbf-t1 qbf-t2 qbf-t3
         WITH FRAME qbf%logi.

    ENABLE new_Format qbf-l1 qbf-l2 bOk bCancel qbf-df bHelp 
      WITH FRAME qbf%logi.

    APPLY "ENTRY" TO qbf-l1 IN FRAME qbf%logi.

    IF NUM-ENTRIES(new_Format,"/":u) = 2 THEN
      ASSIGN
        qbf-l1:SCREEN-VALUE IN FRAME qbf%logi     = ENTRY(1,new_Format,"/":u)
        qbf-l2:SCREEN-VALUE IN FRAME qbf%logi     = ENTRY(2,new_Format,"/":u)
        new_Format:SCREEN-VALUE IN FRAME qbf%logi = new_Format
      .

     {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%logi}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
           &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%logi.
           &ELSE
        WAIT-FOR GO OF FRAME qbf%logi or "u2" of this-procedure.       
             
        if cancelDialog THEN UNDO, LEAVE.  
            &endif 
    END.
    HIDE FRAME qbf%logi NO-PAUSE.
  END.
  WHEN 4 OR WHEN 5 THEN DO: /* integer/decimal -----------------------------*/
     &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    {adeuib/ide/dialoginit.i "frame qbf%numb:handle"}
     dialogService:View().
     &endif
   IF new_Format = ? OR new_Format = "" THEN DO:
      IF iipType = 4 THEN  /* integer */
        new_Format = IF notAmerican THEN "->":U + tho_separator + ">>>":U + tho_separator + ">>9":U
                     ELSE "->,>>>,>>9":U.
      ELSE  /* decimal */
        new_Format = IF notAmerican THEN "->>":U + tho_separator + ">>9":U + dec_separator + "99":U
                     ELSE "->>,>>9.99":U.
    END.  /* if new_format = ? or "" */                    
                
    RUN explore_format (new_Format).

    ASSIGN
      /* qbf-nc VIEW-AS TOGGLE-BOX LABEL "Use thousand's separator ///":t32 */
      qbf-c  = qbf-nc:LABEL IN FRAME qbf%numb
      qbf-i  = INDEX(qbf-c,"///":u)
      qbf-t4 = "Number &Format:":t18
      qbf-t5 = "Total &Number of Digits:":t30
      qbf-t6 = "Number of &Decimal Places:":t30
      qbf-t7 = "&Leading Text String:":t24
      qbf-t8 = "&Trailing Text String:":t24
        &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%numb:THREE-D = SESSION:THREE-D
        &endif
      .
       
     IF qbf-i > 0 THEN
      ASSIGN
        SUBSTRING(qbf-c,qbf-i,3,"CHARACTER":u) = "'":u + tho_separator + "'":u
        qbf-nc:LABEL IN FRAME qbf%numb         = qbf-c.
  

    ASSIGN
      qbf-nn:SCREEN-VALUE IN FRAME qbf%numb     = STRING(qbf-nn,">>>9":u)
      qbf-nn:WIDTH IN FRAME qbf%numb            = qbf-nn:WIDTH IN FRAME qbf%numb + .5
      qbf-nd:SCREEN-VALUE IN FRAME qbf%numb     = STRING(qbf-nd,">>>9":u)
      qbf-nd:WIDTH IN FRAME qbf%numb            = qbf-nd:WIDTH IN FRAME qbf%numb + .5
      new_Format:SCREEN-VALUE IN FRAME qbf%numb = new_Format
        &if defined(IDE-IS-RUNNING) = 0 &THEN
      FRAME qbf%numb:THREE-D = SESSION:THREE-D
        &endif
      .

    DISPLAY qbf-nc qbf-zr qbf-nl qbf-nt qbf-np 
            qbf-t4 qbf-t5 qbf-t6 qbf-t7 qbf-t8
      WITH FRAME qbf%numb.
    
    IF iipType EQ 5 THEN    
      ENABLE
        new_Format qbf-nn qbf-nd qbf-nc qbf-zr qbf-nl qbf-nt qbf-np
        bOk bCancel qbf-df bHelp
      WITH FRAME qbf%numb.
    ELSE 
      ENABLE
        new_Format qbf-nn qbf-nc qbf-zr qbf-nl qbf-nt qbf-np
        bOk bCancel qbf-df bHelp
      WITH FRAME qbf%numb.

     APPLY "ENTRY":U TO qbf-nn IN FRAME qbf%numb.

    {adeuib/ide/dialogstart.i bok bcancel caption "in frame qbf%numb}.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
           &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME qbf%numb.
           &ELSE
        WAIT-FOR GO OF FRAME qbf%numb or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
           &endif 
    END.                                
    
    HIDE FRAME qbf%numb NO-PAUSE.
  END.
END CASE.

RETURN.
/*--- Procedures --------------------------------------------------------------*/

PROCEDURE check_numb_format:
  DEFINE VAR h_fmt AS WIDGET-HANDLE.

  h_fmt = new_Format:HANDLE IN FRAME qbf%numb.
  IF LAST-EVENT:WIDGET-ENTER = bHelp:HANDLE IN FRAME qbf%numb THEN RETURN. 

  IF h_fmt:MODIFIED THEN DO:
    /*
    ** First, make sure if you are checking the format against the compiler
    ** that the format is back in American notation.
    */
    IF notAmerican THEN 
      RUN adecomm/_convert.p ("N-TO-A", h_fmt:SCREEN-VALUE, tho_separator, dec_separator, 
        OUTPUT conv_fmt).
    ELSE
      conv_fmt = h_fmt:SCREEN-VALUE.
      
    RUN adecomm/_chkfmt.p (4, "", "", conv_fmt, 
                           OUTPUT counter, OUTPUT lError).
    IF (lError) THEN DO:
      APPLY "ENTRY" TO new_Format.
      h_fmt:AUTO-ZAP = True.
      RETURN "error".
    END.

    new_Format = h_fmt:SCREEN-VALUE.
    RUN explore_format (new_Format).
  
    ASSIGN
      qbf-nn:SCREEN-VALUE IN FRAME qbf%numb = STRING(qbf-nn,">>>9":u)
      qbf-nd:SCREEN-VALUE IN FRAME qbf%numb = STRING(qbf-nd,">>>9":u) 
      .

    DISPLAY
      qbf-nc qbf-zr qbf-nl qbf-nt qbf-np 
      WITH FRAME qbf%numb.
  END.

  RETURN "".
END.

PROCEDURE setNewFormat4DateTime:
    DO WITH FRAME qbf%datetime:
        ASSIGN
            qbf-inc-tm
            qbf-tm
            qbf-dec-pl-sec
            qbf-12-hr.
        IF qbf-inc-tm THEN DO:
            new_Format = qbf-h:SCREEN-VALUE + " " + qbf-tm.
            IF qbf-tm = "HH:MM:SS" AND qbf-dec-pl-sec > 0 THEN
                new_Format = new_Format + "." + FILL("S",qbf-dec-pl-sec).
            IF qbf-12-hr THEN
                new_Format = new_Format + " AM".
        END.
        ELSE
            new_Format = qbf-h:SCREEN-VALUE.
        DISPLAY new_Format.
    END.
END PROCEDURE.

PROCEDURE setNewFormat4DateTimeTZ:
    DO WITH FRAME qbf%datetimetz:
        ASSIGN
            qbf-inc-tm
            qbf-tm
            qbf-dec-pl-sec
            qbf-12-hr
            qbf-inc-tz.
        IF qbf-inc-tm THEN DO:
            new_Format = qbf-h:SCREEN-VALUE + " " + qbf-tm.
            IF qbf-tm = "HH:MM:SS" AND qbf-dec-pl-sec > 0 THEN
                new_Format = new_Format + "." + FILL("S",qbf-dec-pl-sec).
            IF qbf-12-hr THEN
                new_Format = new_Format + " AM ".
            IF qbf-inc-tz THEN
                new_Format = new_Format + "+HH:MM".
        END.
        ELSE
            new_Format = qbf-h:SCREEN-VALUE.
        DISPLAY new_Format.
    END.
END PROCEDURE.


PROCEDURE explore_charformat: 
  DO WITH FRAME qbf%char:
  DEFINE INPUT PARAMETER qbf_f AS CHARACTER NO-UNDO. /* format to analyze */

  CASE SUBSTRING(TRIM(qbf_f),1,1,"CHARACTER":u):
    WHEN "n":u THEN qbf-s = "n":u.
    WHEN "a":u THEN qbf-s = "a":u.
    WHEN "!":u THEN qbf-s = "!":u.
    WHEN "9":u THEN qbf-s = "9":u.
    OTHERWISE qbf-s = "x".
  END CASE.
  
  ASSIGN
    qbf-s:SCREEN-VALUE = qbf-s
    qbf-i              = counter
    qbf-i:SCREEN-VALUE = STRING(qbf-i).
  END.
END.

PROCEDURE explore_format:
  DEFINE INPUT PARAMETER qbf_f AS CHAR CASE-SENSITIVE NO-UNDO. /* format to analyze */

  DEFINE VARIABLE qbf_c AS CHARACTER CASE-SENSITIVE NO-UNDO. /* format */
  DEFINE VARIABLE qbf_i AS INTEGER                  NO-UNDO. /* loop   */
  DEFINE VARIABLE qbf_s AS INTEGER                  NO-UNDO. /* state  */


  ASSIGN
    qbf_c  = new_Format
    qbf-nb = TRUE
    qbf-nd = 0
    qbf-nl = ""
    qbf-nn = 0
    qbf-nt = ""
    qbf-nz = qbf_f BEGINS ">":u OR new_Format BEGINS "Z":u

    qbf-np = if qbf_f matches "*cr":u then 9
             else if qbf_f matches "*CR":u then 6
             else if qbf_f matches "*db":u then 10
             else if qbf_f matches "*DB":u then 7
             else if qbf_f matches "*dr":u then 11
             else if qbf_f matches "*DR":u then 8
             else if qbf_f matches "*(*)":u then 5
             else if qbf_f matches "+*":u then 1
             else if qbf_f matches "-*":u then 2
             else if qbf_f matches "*+":u then 3
             else if qbf_f matches "*-":u then 4
             else 12.
              
  /* strip off what we know is part of the format */
  CASE qbf-np:
    WHEN 5 THEN
      qbf_f = SUBSTRING(qbf_f,2,LENGTH(qbf_f,"CHARACTER":u) - 2,"CHARACTER":u).
    WHEN 1 OR WHEN 2 THEN
      qbf_f = SUBSTRING(qbf_f,2,-1,"CHARACTER":u).
    WHEN 3 OR WHEN 4 THEN
      qbf_f = SUBSTRING(qbf_f,1,LENGTH(qbf_f,"CHARACTER":u) - 1,"CHARACTER":u).
    WHEN 12 THEN
      .
    OTHERWISE
      qbf_f = SUBSTRING(qbf_f,1,LENGTH(qbf_f,"CHARACTER":u) - 2,"CHARACTER":u).
  END CASE.

  DO qbf_i = 1 TO LENGTH(qbf_f,"CHARACTER":u):
    CASE qbf_s:
      WHEN 0 OR WHEN 1 THEN DO:
        IF   SUBSTRING(qbf_f,qbf_i,2,"CHARACTER":u) = "9":u + dec_separator 
          OR SUBSTRING(qbf_f,qbf_i,2,"CHARACTER":u) = "9":u THEN 
          qbf-nb = FALSE.

        IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) = ">":u OR
           SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) = "Z":u THEN 
          qbf-nz  = TRUE.
        IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) = tho_separator THEN 
          qbf_s = 1.
        ELSE
        IF INDEX("9Z*>":u,SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u)) > 0 THEN
          ASSIGN
            qbf_s  = 1
            qbf-nn = qbf-nn + 1.
        ELSE
        IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) = dec_separator THEN 
          qbf_s = 2.
        ELSE
        IF qbf_s = 1 THEN qbf_s = 9.
        IF qbf_s = 0 AND SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) <> "(":u THEN
          qbf-nl = qbf-nl + SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u).
        IF qbf_s = 9 THEN 
          qbf_i = qbf_i - 1. /* backup one and try again */
      END.
      WHEN 2 THEN DO:
        IF INDEX("9Z<":u,SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u)) > 0 THEN 
          qbf-nd = qbf-nd + 1.
        ELSE
        IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) <> tho_separator THEN 
          qbf_s = 9.
        IF qbf_s = 9 THEN qbf_i = qbf_i - 1. /* backup one and try again */
      END.
      WHEN 9 THEN DO:
        IF SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u) <> ")":u THEN
          qbf-nt = qbf-nt + SUBSTRING(qbf_f,qbf_i,1,"CHARACTER":u).
      END.
    END CASE.
  END.

  IF qbf-np = 12
    AND qbf-nl MATCHES "*(":u
    AND qbf-nt BEGINS ")":u THEN
    ASSIGN
      qbf-nl = SUBSTRING(qbf-nl,1,LENGTH(qbf-nl,"CHARACTER":u) - 1,
                         "CHARACTER":u)
      qbf-nt = SUBSTRING(qbf-nt,2,-1,"CHARACTER":u)
      qbf-np = 5.

  /* Always set the number of decimal places to 0 for INTEGERs */
  IF iipType eq 4 THEN qbf-nd = 0.
  
  ASSIGN
  
    qbf-nz = INDEX(qbf_f,">":U) > 0
    qbf-na = INDEX(qbf_f,"*":U) > 0
    qbf-nn = MIN(qbf-nn + qbf-nd,50)
    qbf-nc = INDEX(qbf_f,SESSION:NUMERIC-SEPARATOR) > 0
    qbf-zr = if qbf-na then 3 else
             if qbf-nz then 1 else 2.
END PROCEDURE. /* explore_format */

/*--------------------------------------------------------------------------*/

PROCEDURE construct_format:
  DEFINE OUTPUT PARAMETER qbf_f AS CHARACTER INITIAL "" NO-UNDO.
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* fill character */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_w AS INTEGER   NO-UNDO. /* number width */

  ASSIGN
    qbf_w = MAXIMUM(qbf-nn - qbf-nd,0)
    qbf_c = (IF qbf-na THEN "*":u ELSE STRING(qbf-nz,">/9":u)).
  IF qbf-nc THEN
    DO qbf_i = 1 TO qbf_w:
      qbf_f = (IF qbf_i < qbf_w AND qbf_i MODULO 3 = 0 THEN tho_separator
              ELSE "")
            + qbf_c
            + qbf_f.
    END.
  ELSE
    qbf_f = FILL(qbf_c,qbf_w).
  IF qbf_w > 0 AND NOT qbf-nb THEN 
    SUBSTRING(qbf_f,LENGTH(qbf_f,"CHARACTER":u),1,"CHARACTER":u) = "9":u.
  qbf_f = qbf-nl
        + ENTRY(qbf-np,"+,-,,,(,,,,,,,":U)
        + qbf_f
        + (IF qbf-nd = 0 THEN "" ELSE
          dec_separator + FILL(STRING(qbf-ns,"</9":u),qbf-nd))
        + (if qbf-np = 3 then "+" else
           if qbf-np = 4 then "-" else
           if qbf-np = 5 then ")" else
           if qbf-np = 6 then "CR" else
           if qbf-np = 7 then "DB" else
           if qbf-np = 8 then "DR" else
           if qbf-np = 9 then "cr" else
           if qbf-np = 10 then "db" else
           if qbf-np = 11 then "dr" else "")
        + qbf-nt.

END PROCEDURE. /* construct_format */

/*--------------------------------------------------------------------------*/
       /* + ENTRY(qbf-np, ",,+,-,),CR,DB,DR,cr,db,dr,":U) */

/* returns -d <mdy> setting and -yy <nnnn> setting */

PROCEDURE date_settings:
  DEFINE OUTPUT PARAMETER qbf_m AS CHARACTER         NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_y AS INTEGER INITIAL ? NO-UNDO.

  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* scrap */

  DO qbf_i = 1900 TO 2000 WHILE qbf_y = ?:
    IF LENGTH(STRING(DATE(1,1,qbf_i)),"CHARACTER":u) = 8
      AND LENGTH(STRING(DATE(1,1,qbf_i + 99)),"CHARACTER":u) = 8
      THEN qbf_y = qbf_i.
  END.
  DO qbf_i = 1000 TO 1900 WHILE qbf_y = ?:
    IF LENGTH(STRING(DATE(1,1,qbf_i)),"CHARACTER":u) = 8
      AND LENGTH(STRING(DATE(1,1,qbf_i + 99)),"CHARACTER":u) = 8
      THEN qbf_y = qbf_i.
  END.
  DO qbf_i = 2000 TO 9900 WHILE qbf_y = ?:
    IF LENGTH(STRING(DATE(1,1,qbf_i)),"CHARACTER":u) = 8
      AND LENGTH(STRING(DATE(1,1,qbf_i + 99)),"CHARACTER":u) = 8
      THEN qbf_y = qbf_i.
  END.

  /*
  qbf_m = ENTRY(LOOKUP(STRING(DATE(2,1,qbf_y + 3)),
          "01/02/03,01/03/02,02/01/03,02/03/01,03/01/02,03/02/01":u),
          "dmy,dym,mdy,myd,ydm,ymd":u).
  */
  qbf_m = SESSION:DATE-FORMAT.
END PROCEDURE. /* date_settings */

/*--------------------------------------------------------------------------*/

/* _y-build.p - end of file */

