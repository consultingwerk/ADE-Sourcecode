&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS F-Frame-Win 
/************************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights  *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
*                                                                       *
*************************************************************************/
/************************************************************************

  File:     calendar.w

  Description: Smart Calendar Control

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE COLOR-Hilight      AS INTEGER NO-UNDO INITIAL 15.
DEFINE VARIABLE COLOR-Hilight-Text AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE COLOR-Title        AS INTEGER NO-UNDO INITIAL 1.

DEFINE VARIABLE lResult     AS LOGICAL NO-UNDO.
DEFINE VARIABLE lInFrame    AS LOGICAL NO-UNDO.
DEFINE VARIABLE cWeekFormat AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iDay       AS INTEGER NO-UNDO.
DEFINE VARIABLE iMonth     AS INTEGER NO-UNDO.
DEFINE VARIABLE iYear      AS INTEGER NO-UNDO.
DEFINE VARIABLE iDayOfWeek AS INTEGER NO-UNDO.
DEFINE VARIABLE iFormatNo  AS INTEGER NO-UNDO INITIAL 1.

DEFINE VARIABLE CalendarDate AS DATE NO-UNDO INITIAL TODAY.

DEFINE VARIABLE cDateValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cItemList  AS CHARACTER NO-UNDO.

DEFINE VARIABLE hHandle    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hLastDay   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hSelection AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE haViewDay  AS WIDGET-HANDLE NO-UNDO EXTENT 42.

DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.

DEFINE VARIABLE iaViewDay AS INTEGER FORMAT "ZZ" INITIAL 0 EXTENT 42 NO-UNDO VIEW-AS TEXT.

DEFINE VARIABLE clDayName AS CHARACTER NO-UNDO EXTENT 7 INITIAL 
["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"].

DEFINE VARIABLE clMonthName AS CHARACTER NO-UNDO EXTENT 12 INITIAL 
["January","February","March","April","May","June","July",
 "August","September","October","November","December"].

DEFINE VARIABLE clDayText AS CHARACTER NO-UNDO EXTENT 31 INITIAL 
["st","nd","rd","th","th","th","th","th","th","th",
 "th","th","th","th","th","th","th","th","th","th",
 "st","nd","rd","th","th","th","th","th","th","th",
 "st"
].

DEFINE VARIABLE x AS INTEGER NO-UNDO INITIAL 1.
DEFINE VARIABLE y AS INTEGER NO-UNDO.

DEFINE RECTANGLE RECT-S EDGE-PIXELS 1 SIZE-PIXELS 1 BY 1.

DEFINE BUTTON BUTTON-1 SIZE-PIXELS 1 BY 1.

/*
   Date Formats. Field codes that are not recognised appear literally in the 
   Resulting format (including blanks). You can add more formats as required or
   reduce the number of formats to speed things up a little. Format codes are
   as follows: 

   "fd"   FullDay (Monday, Tuesday, etc)
   "ad"   Abbreviated Day (Mon, Tue, etc)
   "fm"   Full Month (January, February, etc)
   "am"   Abbreviated Month (Jan, Feb, etc)
   "n"    Numeric day (1,2, etc)
   "nx"   Numeric day extended (1st, 2nd, etc)
   "d"    Single Digit day (1,2,7,30,)
   "dd"   Double Digit day (01, 02, 07, 30, etc)
   "m"    Single digit Month (1,2,7,12, etc)
   "mm"   Double digit Month (01,02,07,12, etc)
   "yy"   Decade Only
   "yyyy" Full Year
   */

&SCOPED-DEFINE MAX-EXTENTS 9 

/* This is the main array - At run-time, one of the formats below is copied
   into this array, based upon the SESSION date format. You can modify or
   add any series of formats that you like, or add your own selection logic.
*/
DEFINE VARIABLE caFormat AS CHARACTER NO-UNDO EXTENT {&MAX-EXTENTS} INITIAL
[  "fd, ,nx, ,fm, ,yyyy",
   ""
].

/* This is a smaller, European version */
DEFINE VARIABLE caEuroFormat AS CHARACTER NO-UNDO EXTENT {&MAX-EXTENTS} INITIAL
[  "fd, ,nx, ,fm, ,yyyy",    /* Monday 6th July 2000 */
   "fd, ,fm, ,nx, ,yyyy",    /* Monday July 6th 2000 */
   "fm, ,nx, ,yyyy",         /* July 6th 2000 */
   "nx, ,fm, ,yyyy",         /* 6th July 2000 */
   "d,/,m,/,yy",             /* 6/7/00 */
   "dd,/,mm,/,yy",           /* 6/7/00 */
   "d,/,m,/,yyyy",           /* 6/7/2000 */
   "dd,/,mm,/,yyyy",         /* 06/07/2000 */
   ""
].

/* A smaller American version */
DEFINE VARIABLE caUSAFormat AS CHARACTER NO-UNDO EXTENT {&MAX-EXTENTS} INITIAL
[  "fd, ,nx, ,fm, ,yyyy",    /* Monday 6th July 2000 */
   "fd, ,fm, ,nx, ,yyyy",    /* Monday July 6th 2000 */
   "fm, ,nx, ,yyyy",         /* July 6th 2000 */
   "nx, ,fm, ,yyyy",         /* 6th July 2000 */
   "m,/,d,/,yy",             /* 7/6/00 */
   "mm,/,dd,/,yy",           /* 07/06/00 */
   "m,/,d,/,yyyy",           /* 7/6/2000 */
   "mm,/,dd,/,yyyy",         /* 07/06/2000 */
   ""
].

/* A smaller dmy (Swedish) version */
DEFINE VARIABLE caSwedFormat AS CHARACTER NO-UNDO EXTENT {&MAX-EXTENTS} INITIAL
[  "fd, ,nx, ,fm, ,yyyy",    /* Monday 6th July 2000 */
   "fd, ,fm, ,nx, ,yyyy",    /* Monday July 6th 2000 */
   "fm, ,nx, ,yyyy",         /* July 6th 2000 */
   "nx, ,fm, ,yyyy",         /* 6th July 2000 */
   "yy,/,m,/,d",             /* 00/7/6 */
   "yy,/,mm,/,dd",           /* 00/07/06 */
   "yyyy,/,m,/,d",            /* 2000/7/6 */
   "yyyy,/,mm,/,dd",          /* 2000/07/06 */
   ""
].

/* This large list is commented out. Smaller versions are defined above.

DEFINE VARIABLE caFormat AS CHARACTER NO-UNDO EXTENT {&MAX-EXTENTS} INITIAL
[  "fd, ,nx, ,fm, ,yyyy",    /* Monday 6th July 2000 */
   "fd, ,n, ,fm, ,yyyy",     /* Monday 6 July 2000  */
   "fd, ,fm, ,nx, ,yyyy",    /* Monday July 6th 2000 */
   "fd, ,fm, ,n, ,yyyy",     /* Monday July 6 2000  */

   "ad, ,nx, ,fm, ,yyyy",    /* Mon 6th July 2000 */
   "ad, ,n, ,fm, ,yyyy",     /* Mon 6 July 2000  */
   "ad, ,fm, ,nx, ,yyyy",    /* Mon July 6th 2000 */
   "ad, ,fm, ,n, ,yyyy",     /* Mon July 6 2000  */

   "nx, ,fm, ,yyyy",        /* 6th July 2000 */
   "n, ,fm, ,yyyy",         /* 6 July 2000  */
   "fm, ,nx, ,yyyy",        /* July 6th 2000 */
   "fm, ,n, ,yyyy",         /* July 6 2000  */

   "nx, ,am, ,yyyy",        /* 6th Jul 2000 */
   "n, ,am, ,yyyy",         /* 6 Jul 2000  */
   "am, ,nx, ,yyyy",        /* Jul 6th 2000 */
   "am, ,n, ,yyyy",         /* Jul 6 2000  */

   "d,/,am,/,yyyy",         /* 6/Jul/2000  */
   "am,/,d,/,yyyy",         /* Jul/6/2000  */

   "d,-,am,-,yyyy",         /* 6-Jul-2000  */
   "am,-,d,-,yyyy",         /* Jul-6-2000  */

   "d,/,m,/,yy",          /* dd/mm/yy */
   "d,/,m,/,yyyy",        /* dd/mm/yyyy */
   "dd,/,mm,/,yy",        /* dd/mm/yy */
   "dd,/,mm,/,yyyy",      /* dd/mm/yyyy */

   "d,-,m,-,yy",          /* dd-mm-yy */
   "d,-,m,-,yyyy",        /* dd-mm-yyyy */
   "dd,-,mm,-,yy",        /* dd-mm-yy */
   "dd,-,mm,-,yyyy",      /* dd-mm-yyyy */

   "m,/,d,/,yy",          /* dd/mm/yy */
   "m,/,d,/,yyyy",        /* dd/mm/yyyy */
   "mm,/,dd,/,yy",        /* dd/mm/yy */
   "mm,/,dd,/,yyyy",      /* dd/mm/yyyy */

   "m,-,d,-,yy",          /* dd-mm-yy */
   "m,-,d,-,yyyy",        /* dd-mm-yyyy */
   "mm,-,dd,-,yy",        /* dd-mm-yy */
   "mm,-,dd,-,yyyy",      /* dd-mm-yyyy */

   ""
].
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS CB-MONTH CB-YEAR CB-FORMAT RECT-44 
&Scoped-Define DISPLAYED-OBJECTS CB-MONTH CB-YEAR CB-FORMAT TEXT-3 TEXT-4 ~
TEXT-5 TEXT-6 TEXT-7 TEXT-1 TEXT-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFirstDayOfWeek F-Frame-Win 
FUNCTION setFirstDayOfWeek RETURNS LOGICAL
   ( pcFirstDayOfWeek AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_spin AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE CB-FORMAT AS CHARACTER FORMAT "X(256)":U INITIAL "<Return Format>" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "<Return Format>" 
     DROP-DOWN-LIST
     SIZE 33.6 BY 1 NO-UNDO.

DEFINE VARIABLE CB-MONTH AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "January","February","March","April","May","June","July","August","September","October","November","December" 
     DROP-DOWN-LIST
     SIZE 24.2 BY 1 NO-UNDO.

DEFINE VARIABLE CB-YEAR AS INTEGER FORMAT "9999":U INITIAL 0 
     VIEW-AS FILL-IN NATIVE 
     SIZE 9.2 BY 1 NO-UNDO.

DEFINE VARIABLE TEXT-1 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-2 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-3 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-4 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-5 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-6 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE VARIABLE TEXT-7 AS CHARACTER FORMAT "X(256)":U INITIAL "XX" 
     LABEL "" 
      VIEW-AS TEXT 
     SIZE 4 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-44
     EDGE-PIXELS 999  NO-FILL 
     SIZE 33.6 BY 7.

DEFINE RECTANGLE RECT-99
     EDGE-PIXELS 0  
     SIZE 33.2 BY .95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     CB-MONTH AT ROW 1.19 COL 1.8 NO-LABEL
     CB-YEAR AT ROW 1.19 COL 26.2 NO-LABEL
     CB-FORMAT AT ROW 9.57 COL 1.8 NO-LABEL
     TEXT-3 AT ROW 2.62 COL 12.2
     TEXT-4 AT ROW 2.62 COL 16.8
     TEXT-5 AT ROW 2.62 COL 21.2
     TEXT-6 AT ROW 2.62 COL 26.2
     TEXT-7 AT ROW 2.62 COL 31
     TEXT-1 AT ROW 2.62 COL 3.4
     TEXT-2 AT ROW 2.62 COL 7.6
     RECT-99 AT ROW 2.43 COL 2
     RECT-44 AT ROW 2.38 COL 1.8
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         NO-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 35.2 BY 9.67
         FONT 4.

DEFINE FRAME FRAME-A
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         NO-LABELS NO-UNDERLINE NO-VALIDATE 
         AT COL 2.2 ROW 3.43
         SIZE 32.8 BY 5.86
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: 
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW F-Frame-Win ASSIGN
         HEIGHT             = 9.67
         WIDTH              = 35.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB F-Frame-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}
{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW F-Frame-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* REPARENT FRAME */
ASSIGN FRAME FRAME-A:FRAME = FRAME F-Main:HANDLE.

/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Custom                                                   */
ASSIGN 
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX CB-FORMAT IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX CB-MONTH IN FRAME F-Main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN CB-YEAR IN FRAME F-Main
   ALIGN-L                                                              */
ASSIGN 
       CB-YEAR:READ-ONLY IN FRAME F-Main        = TRUE.

/* SETTINGS FOR RECTANGLE RECT-99 IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       RECT-99:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN TEXT-1 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-2 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-3 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-4 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-5 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-6 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FILL-IN TEXT-7 IN FRAME F-Main
   NO-ENABLE ALIGN-L LABEL ":"                                          */
/* SETTINGS FOR FRAME FRAME-A
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME FRAME-A:HIDDEN           = TRUE
       FRAME FRAME-A:SENSITIVE        = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME FRAME-A
/* Query rebuild information for FRAME FRAME-A
     _Query            is NOT OPENED
*/  /* FRAME FRAME-A */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FRAME-A
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A F-Frame-Win
ON ENTRY OF FRAME FRAME-A
ANYWHERE
DO:
  ASSIGN lInFrame = TRUE. 

  IF VALID-HANDLE(hLastDay) THEN 
      ASSIGN hLastDay:BGCOLOR = COLOR-Hilight
             hLastDay:FGCOLOR = COLOR-Hilight-Text.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A F-Frame-Win
ON LEAVE OF FRAME FRAME-A
DO:
  ASSIGN lInFrame = FALSE. 

  IF VALID-HANDLE(hLastDay) THEN 
      ASSIGN hLastDay:BGCOLOR = ?
             hLastDay:FGCOLOR = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A F-Frame-Win
ON MOUSE-SELECT-DBLCLICK OF FRAME FRAME-A
ANYWHERE
DO:
  RUN _assignDay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A F-Frame-Win
ON MOUSE-SELECT-DOWN OF FRAME FRAME-A
ANYWHERE
DO:
    IF SELF:TYPE = "FRAME":U THEN RETURN.

    /* Selects a day by giving it "focus". Focus is mimiced by making the
       rectangle surrounding the day a bit wider. The rectangle is moved
       over the selected day-text widget. The format string is updated to
       reflect the selected date. (The full list of formats is updated only
       when the user selects a new format).
    */
    IF SELF:NAME = "iaViewDay" AND SELF:SCREEN-VALUE <> ""
    THEN DO:
        IF VALID-HANDLE(hLastDay) 
        THEN 
            ASSIGN hLastDay:BGCOLOR = ?
                   hLastDay:FGCOLOR = ?. 

        ASSIGN SELF:WIDTH-PIXELS = FONT-TABLE:GET-TEXT-WIDTH-PIXELS("99",4) + 1
               SELF:BGCOLOR = IF lInFrame THEN COLOR-Hilight ELSE ?
               SELF:FGCOLOR = IF lInFrame THEN COLOR-Hilight-Text ELSE ?
               hLastDay = SELF:HANDLE
               hSelection:HIDDEN = TRUE
               hSelection:WIDTH-PIXELS = SELF:WIDTH-PIXELS + 4
               hSelection:X = SELF:X - 2
               hSelection:Y = SELF:Y - 2
               hSelection:HIDDEN = FALSE
               iDay = INT(SELF:SCREEN-VALUE) 
               CalendarDate = DATE(iMonth,iDay,iYear)
               x = iFormatNo
               NO-ERROR.

        Run _BuildString.

        CB-FORMAT:REPLACE(cDateValue,iFormatNo) IN FRAME {&FRAME-NAME}.
    END.
END.

/* When focus is within frame-a, these triggers will move the day selection in the
   same way as clicking with a mouse pointer.
*/
ON "CURSOR-LEFT" OF FRAME FRAME-A ANYWHERE
DO: 
    Run _SelectDay(INT(hLastDay:SCREEN-VALUE) - 1).    
END.

ON "CURSOR-RIGHT"  OF FRAME FRAME-A ANYWHERE
DO: 
    Run _SelectDay(INT(hLastDay:SCREEN-VALUE) + 1).    
END.

ON "CURSOR-UP" OF FRAME FRAME-A ANYWHERE
DO: 
    Run _SelectDay(INT(hLastDay:SCREEN-VALUE) - 7).    
END.

ON "CURSOR-DOWN" OF FRAME FRAME-A ANYWHERE
DO: 
    Run _SelectDay(INT(hLastDay:SCREEN-VALUE) + 7).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FRAME-A F-Frame-Win
ON RETURN OF FRAME FRAME-A
ANYWHERE
DO:
    RUN _AssignDay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-FORMAT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FORMAT F-Frame-Win
ON ENTRY OF CB-FORMAT IN FRAME F-Main
DO:
  RUN _SetFormat.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FORMAT F-Frame-Win
ON RETURN OF CB-FORMAT IN FRAME F-Main
DO:
    RUN _AssignDay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-FORMAT F-Frame-Win
ON VALUE-CHANGED OF CB-FORMAT IN FRAME F-Main
DO:
  ASSIGN iFormatNo = LOOKUP(SELF:SCREEN-VALUE,SELF:LIST-ITEMS).
  RUN _SetFormat. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-MONTH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-MONTH F-Frame-Win
ON RETURN OF CB-MONTH IN FRAME F-Main
DO:
  RUN _AssignDay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-MONTH F-Frame-Win
ON VALUE-CHANGED OF CB-MONTH IN FRAME F-Main
OR VALUE-CHANGED OF CB-YEAR
DO:
  RUN _SetDay.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-YEAR
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-YEAR F-Frame-Win
ON RETURN OF CB-YEAR IN FRAME F-Main
DO:
  RUN _AssignDay IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK F-Frame-Win 


/* ***************************  Main Block  *************************** */

FORM RECT-S AT ROW 1 COLUMN 1 BUTTON-1 SKIP(.1)
     SPACE iaViewDay[1 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 SKIP(.3)
     SPACE iaViewDay[8 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 SKIP(.3)
     SPACE iaViewDay[15 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 SKIP(.3)
     SPACE iaViewDay[22 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 SKIP(.3)
     SPACE iaViewDay[29 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 SKIP(.3)
     SPACE iaViewDay[36 for 7] VIEW-AS TEXT SIZE 3.6 BY .63 
  WITH FRAME FRAME-A.

ASSIGN RECT-S:HIDDEN = TRUE.

FRAME {&FRAME-NAME}:PRIVATE-DATA = "nolookups":U.
CB-YEAR:PRIVATE-DATA = "nolookups".

&IF DEFINED(UIB_IS_RUNNING) <> 0 
&THEN
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects F-Frame-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'af/obj2/afspinnerv.w':U ,
             INPUT  FRAME F-Main:HANDLE ,
             INPUT  'SpinStyle':U + 'Standard Combo Vertical' + 'LinkName':U + '' + 'ButtonIncrement':U + '1' + 'ButtonMinimum':U + '1' + 'ButtonMaximum':U + '9999' + 'SpinSpeed':U + '0' + 'SpinAccel':U + '10' + 'SpinKeys':U + 'yes' + 'AutoPosition':U + 'yes' + 'MouseCursor':U + '' + 'BufferFlush':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_spin ).
       RUN repositionObject IN h_spin ( 1.29 , 32.40 ) NO-ERROR.
       /* Size in AB:  ( 0.81 , 3.80 ) */

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_spin ,
             CB-MONTH:HANDLE IN FRAME F-Main , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI F-Frame-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  HIDE FRAME FRAME-A.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI F-Frame-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY CB-MONTH CB-YEAR CB-FORMAT TEXT-3 TEXT-4 TEXT-5 TEXT-6 TEXT-7 TEXT-1 
          TEXT-2 
      WITH FRAME F-Main.
  ENABLE CB-MONTH CB-YEAR CB-FORMAT RECT-44 
      WITH FRAME F-Main.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  FRAME FRAME-A:SENSITIVE = NO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject F-Frame-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hText AS HANDLE EXTENT 7 NO-UNDO. 
   ASSIGN
     hText[1]  = text-1:HANDLE IN FRAME f-main
     hText[2]  = text-2:HANDLE
     hText[3]  = text-3:HANDLE
     hText[4]  = text-4:HANDLE
     hText[5]  = text-5:HANDLE
     hText[6]  = text-6:HANDLE
     hText[7]  = text-7:HANDLE.
  
  /* Dispatch standard ADM method.                             */
  RUN SUPER.

  IF NOT getUIBMode() BEGINS "Design":U THEN 
  DO:   

      /* setFirstDayOfWeek may have set this already, otherwise we use 
         the numeric-format; US = Sunday Europe = Monday */
      IF cWeekFormat = "":U THEN 
         cWeekFormat = IF SESSION:NUMERIC-FORMAT = 'American':U 
                       THEN 'Sunday':U 
                       ELSE 'Monday':U. 

      /* Show the 2 first characters of each day as day column label. */ 
      DO x = 1 TO 7:
         hText[x]:SCREEN-VALUE = SUBSTR(
                               clDayName[IF cWeekFormat BEGINS 'S':U 
                                         THEN x 
                                         ELSE IF x = 7 THEN 1 
                                              ELSE x + 1],
                                       1,2).
      END.
      
      /* Default the date format according to the session format */
      DO x = 1 TO {&MAX-EXTENTS}:
         ASSIGN caFormat[x] = IF SESSION:DATE-FORMAT = "mdy":U 
                              THEN caUsaFormat[x]
                              ELSE IF SESSION:DATE-FORMAT = "ymd":U 
                              THEN caSwedFormat[x]
                              ELSE caEuroFormat[x].
      END.
      ASSIGN 
         hContainer = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles':U, 'Container-Source':U))
         iYear  = YEAR(TODAY)
         iMonth = MONTH(TODAY)
         iDay   = DAY(TODAY) 
         hSelection = RECT-S:HANDLE IN FRAME FRAME-A
         hSelection:WIDTH-PIXELS  = iaViewDay[1]:WIDTH-PIXELS + 4
         hSelection:HEIGHT-PIXELS = iaViewDay[1]:HEIGHT-PIXELS + 4
         CalendarDate = TODAY
         CB-YEAR:LIST-ITEMS IN FRAME {&FRAME-NAME} = STRING(YEAR(TODAY) - 20)
         COLOR-Hilight = COLOR-OF("Hilight":U)
         COLOR-Hilight-Text = COLOR-OF("HilightText":U)
         COLOR-Title = COLOR-OF("ActiveTitle":U)
         RECT-99:BGCOLOR = COLOR-Title
         TEXT-1:BGCOLOR = COLOR-Title
         TEXT-2:BGCOLOR = COLOR-Title
         TEXT-3:BGCOLOR = COLOR-Title
         TEXT-4:BGCOLOR = COLOR-Title
         TEXT-5:BGCOLOR = COLOR-Title
         TEXT-6:BGCOLOR = COLOR-Title
         TEXT-7:BGCOLOR = COLOR-Title
         TEXT-1:FGCOLOR = COLOR-Hilight-Text
         TEXT-2:FGCOLOR = COLOR-Hilight-Text
         TEXT-3:FGCOLOR = COLOR-Hilight-Text
         TEXT-4:FGCOLOR = COLOR-Hilight-Text
         TEXT-5:FGCOLOR = COLOR-Hilight-Text
         TEXT-6:FGCOLOR = COLOR-Hilight-Text
         TEXT-7:FGCOLOR = COLOR-Hilight-Text
         CB-YEAR:BGCOLOR = COLOR-Hilight
         CB-YEAR:FGCOLOR = COLOR-Hilight-Text
      NO-ERROR.

      RUN _SetHandles.

      RUN setNewDate.

      RECT-99:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.

      ENABLE ALL WITH FRAME FRAME-A.

      APPLY "LEAVE" TO FRAME FRAME-A.

      RUN setFieldHandle IN h_Spin (CB-YEAR:HANDLE).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldHandle F-Frame-Win 
PROCEDURE setFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     Set handle for update widget.
  Parameters:  Widget Handle
  Notes:       After a valid handle is passed, updates the widget screen value
               with the selected date, whenever the date changes.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-handle AS HANDLE NO-UNDO.

IF VALID-HANDLE(ip-handle) 
AND CAN-SET(ip-handle,"SCREEN-VALUE":U) 
AND CAN-DO("CHARACTER,DATE",ip-handle:DATA-TYPE) 
THEN DO:
    ASSIGN hHandle = ip-handle 

           CalendarDate = DATE(hHandle:SCREEN-VALUE) NO-ERROR.

    IF CalendarDate = ? THEN CalendarDate = TODAY.

    ELSE RUN setNewDate.
END.    

APPLY "entry":U TO FRAME frame-a.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNewDate F-Frame-Win 
PROCEDURE setNewDate :
/*------------------------------------------------------------------------------
  Purpose:     Initialise to a new date
  Parameters:  <none>
  Notes:       CalendarDate holds the date.
------------------------------------------------------------------------------*/

  ASSIGN CB-YEAR = YEAR(CalendarDate) 
         CB-YEAR:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(CalendarDate))
         CB-MONTH:SCREEN-VALUE = ENTRY(MONTH(CalendarDate),CB-MONTH:LIST-ITEMS)
         iDay = DAY(CalendarDate).

  APPLY "VALUE-CHANGED" TO CB-MONTH IN FRAME {&FRAME-NAME}.

  RUN _SetFormat.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject F-Frame-Win 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       The frame containing the days is hidden first, and viewed when
               the main frame is in view. This makes the redisplay much cleaner.
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  ASSIGN FRAME FRAME-A:HIDDEN = TRUE.

  /* Dispatch standard ADM method.                             */
  RUN SUPER .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN FRAME FRAME-A:HIDDEN = getUIBMode() BEGINS "Design":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _AssignDay F-Frame-Win 
PROCEDURE _AssignDay PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Set the Linked Field Date, if specified
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(hContainer)
THEN
    RUN _dateDialogSelected IN hContainer NO-ERROR.

IF VALID-HANDLE(hHandle) AND hHandle:SENSITIVE 
THEN
    ASSIGN hHandle:SCREEN-VALUE = IF hHandle:DATA-TYPE = "DATE" 
                                  THEN STRING(CalendarDate,hHandle:FORMAT)
                                  ELSE cDateValue 
           NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _BuildString F-Frame-Win 
PROCEDURE _BuildString PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Build date string from format entry (current value x)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN cDateValue = "".

DO y = 1 TO NUM-ENTRIES(caFormat[x]):
    CASE ENTRY(y,caFormat[x]):
        WHEN "fd"   THEN ASSIGN cDateValue = cDateValue + clDayName[WEEKDAY(CalendarDate)].
        WHEN "ad"   THEN ASSIGN cDateValue = cDateValue + SUBSTRING(clDayName[WEEKDAY(CalendarDate)],1,3).
        WHEN "fm"   THEN ASSIGN cDateValue = cDateValue + clMonthName[iMonth].
        WHEN "am"   THEN ASSIGN cDateValue = cDateValue + SUBSTRING(clMonthName[iMonth],1,3).
        WHEN "n"    THEN ASSIGN cDateValue = cDateValue + TRIM(STRING(iDay,"Z9")).
        WHEN "nx"   THEN ASSIGN cDateValue = cDateValue + TRIM(STRING(iDay,"Z9")) + clDayText[iDay].
        WHEN "d"    THEN ASSIGN cDateValue = cDateValue + TRIM(STRING(iDay,"Z9")).
        WHEN "dd"   THEN ASSIGN cDateValue = cDateValue + STRING(iDay,"99").
        WHEN "m"    THEN ASSIGN cDateValue = cDateValue + TRIM(STRING(iMonth,"Z9")).
        WHEN "mm"   THEN ASSIGN cDateValue = cDateValue + STRING(iMonth,"99").
        WHEN "yy"   THEN ASSIGN cDateValue = cDateValue + SUBSTRING(STRING(iYear,"9999"),3,2).
        WHEN "yyyy" THEN ASSIGN cDateValue = cDateValue + STRING(iYear,"9999").
        OTHERWISE ASSIGN cDateValue = cDateValue + ENTRY(y,caFormat[x]).
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _SelectDay F-Frame-Win 
PROCEDURE _SelectDay PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Select the appropriate array element for a particular day.
  Parameters:  <none>
  Notes:       Scans each array element looking for a match.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER sel_day AS INTEGER NO-UNDO.

DO x = 1 to 42:
    IF VALID-HANDLE(haViewDay[x]) AND INT(haViewDay[x]:SCREEN-VALUE) = sel_day 
    THEN DO:
        APPLY "MOUSE-SELECT-DOWN" TO haViewDay[x].

        LEAVE.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _SetDay F-Frame-Win 
PROCEDURE _SetDay PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     After choosing a new date, this assigns days into array elements
               so that they appear under the correct weekday.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN iYear  = INT(CB-YEAR:SCREEN-VALUE IN FRAME {&FRAME-NAME})
         iMonth = LOOKUP(CB-MONTH:SCREEN-VALUE,CB-MONTH:LIST-ITEMS)
         iDay   = IF iDay = 0 THEN DAY(TODAY) ELSE iDay
         CalendarDate  = DATE(iMonth,1,iYear)
         iaViewDay = 0 
     
         /* Progress returns 1-7 (Sun->Sat)from the WEEKDAY function. 
            However, if the numeric format is not american then we put
            Monday first. So we handle that difference here.
         */
         iDayOfWeek = IF cWeekFormat BEGINS 'S':u
                      THEN WEEKDAY(CalendarDate)
                      ELSE IF WEEKDAY(CalendarDate) = 1 THEN 7
                           ELSE WEEKDAY(CalendarDate) - 1       
  
         NO-ERROR.
 
  /* Starting from day 1, we just keep adding 1 until the month changes */
  DO X = 1 TO 31:
    ASSIGN 
      iaViewDay[iDayOfWeek] = X 
      iDayOfWeek            = iDayOfWeek + 1 
      CalendarDate          = CalendarDate + 1.
    IF MONTH(CalendarDate) <> iMonth THEN 
      LEAVE.
  END.

  /* Ensure iDay <= number of days in the month */ 
  IF iDay > x THEN iDay = x.

  DISPLAY iaViewDay WITH FRAME FRAME-A. 
  
  Run _SelectDay(iDay).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _SetFormat F-Frame-Win 
PROCEDURE _SetFormat PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Build All Format Lists
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN cItemList = "". 

DO x = 1 TO {&MAX-EXTENTS}:

    IF caFormat[x] = "" THEN LEAVE.

    Run _BuildString.

    ASSIGN cItemList = cItemList + IF cItemList = "" THEN cDateValue ELSE "," + cDateValue. 
END.

ASSIGN CB-FORMAT:LIST-ITEMS IN FRAME {&FRAME-NAME} = cItemList
       CB-FORMAT:SCREEN-VALUE = ENTRY(iFormatNo,CB-FORMAT:LIST-ITEMS). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _SetHandles F-Frame-Win 
PROCEDURE _SetHandles PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Moves handles of static "day" widgets into array
  Parameters:  <none>
  Notes:       For Static array widgets, the expression 
                  widget-name[n]:<attribute|method>
               is only valid when "n" is a numeric constant. e.g. not a variable.
               This assignment process means that we can process the array easily
               in other parts of this procedure.
------------------------------------------------------------------------------*/
ASSIGN haViewDay[1] = iaViewDay[1]:HANDLE IN FRAME FRAME-A
       haViewDay[2] = iaViewDay[2]:HANDLE
       haViewDay[3] = iaViewDay[3]:HANDLE
       haViewDay[4] = iaViewDay[4]:HANDLE
       haViewDay[5] = iaViewDay[5]:HANDLE
       haViewDay[6] = iaViewDay[6]:HANDLE
       haViewDay[7] = iaViewDay[7]:HANDLE
       haViewDay[8] = iaViewDay[8]:HANDLE
       haViewDay[9] = iaViewDay[9]:HANDLE
       haViewDay[10] = iaViewDay[10]:HANDLE
       haViewDay[11] = iaViewDay[11]:HANDLE
       haViewDay[12] = iaViewDay[12]:HANDLE
       haViewDay[13] = iaViewDay[13]:HANDLE
       haViewDay[14] = iaViewDay[14]:HANDLE
       haViewDay[15] = iaViewDay[15]:HANDLE
       haViewDay[16] = iaViewDay[16]:HANDLE
       haViewDay[17] = iaViewDay[17]:HANDLE
       haViewDay[18] = iaViewDay[18]:HANDLE
       haViewDay[19] = iaViewDay[19]:HANDLE
       haViewDay[20] = iaViewDay[20]:HANDLE
       haViewDay[21] = iaViewDay[21]:HANDLE
       haViewDay[22] = iaViewDay[22]:HANDLE
       haViewDay[23] = iaViewDay[23]:HANDLE
       haViewDay[24] = iaViewDay[24]:HANDLE
       haViewDay[25] = iaViewDay[25]:HANDLE
       haViewDay[26] = iaViewDay[26]:HANDLE
       haViewDay[27] = iaViewDay[27]:HANDLE
       haViewDay[28] = iaViewDay[28]:HANDLE
       haViewDay[29] = iaViewDay[29]:HANDLE
       haViewDay[30] = iaViewDay[30]:HANDLE
       haViewDay[31] = iaViewDay[31]:HANDLE
       haViewDay[32] = iaViewDay[32]:HANDLE
       haViewDay[33] = iaViewDay[33]:HANDLE
       haViewDay[34] = iaViewDay[34]:HANDLE
       haViewDay[35] = iaViewDay[35]:HANDLE
       haViewDay[36] = iaViewDay[36]:HANDLE
       haViewDay[37] = iaViewDay[37]:HANDLE
       haViewDay[38] = iaViewDay[38]:HANDLE
       haViewDay[39] = iaViewDay[39]:HANDLE
       haViewDay[40] = iaViewDay[40]:HANDLE
       haViewDay[41] = iaViewDay[41]:HANDLE
       haViewDay[42] = iaViewDay[42]:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFirstDayOfWeek F-Frame-Win 
FUNCTION setFirstDayOfWeek RETURNS LOGICAL
   ( pcFirstDayOfWeek AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF {fn getObjectInitialized} THEN
  DO:
    MESSAGE 'Cannot adjust week after object has been initialized.'
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN FALSE.
  END.

  IF NOT (pcFirstDayOfWeek BEGINS 'S':U OR pcFirstDayOfWeek BEGINS 'M':U) THEN
  DO:
    MESSAGE "First day of week must be 'Sunday' or 'Monday'"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN FALSE.
  END.

  cWeekFormat = pcFirstDayOfWeek.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

