&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _session.w

  Description: List connected databases (and let the user add/remove some).

    Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 08/09/93 -  7:37 am
  
  Modified on 11/06/96 gfs - Added adjustment to dialog for win95 font
              08/01/97 gfs - Updated attribute list
              01/23/98 gfs - Updated attribute list for v9
              12/07/98 gfs - Additional attr update for v9
              05/25/99 tsm - Added NUMERIC-DECIMAL-POINT and 
                             NUMERIC-SEPARATOR for v9.1
              06/11/99 tsm - Added CONTEXT-HELP-FILE for v9.1
              09/24/99 gfs - Added some other missing attrs.           
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{ adecomm/commeng.i}   /* Help contexts */
{ adecomm/adestds.i}   /* Standard layout defines, colors etc. */
{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED STREAM rpt.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS attr-list Btn_Close b_Print b_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close AUTO-GO 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Print 
     LABEL "&Print" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE attr-list AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 54 BY 13.81
     FONT 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f
     attr-list AT ROW 1.57 COL 3 NO-LABEL
     Btn_Close AT ROW 15.76 COL 4
     b_Print AT ROW 15.76 COL 21.4
     b_Help AT ROW 15.76 COL 39.4
     SPACE(4.30) SKIP(0.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "Session Attributes":L
         DEFAULT-BUTTON Btn_Close.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f
   UNDERLINE                                                            */
ASSIGN 
       FRAME f:SCROLLABLE       = FALSE.

/* SETTINGS FOR SELECTION-LIST attr-list IN FRAME f
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON Btn_Close IN FRAME f
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help f
ON CHOOSE OF b_Help IN FRAME f /* Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Session_Attributes}, ? ).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Print f
ON CHOOSE OF b_Print IN FRAME f /* Print */
DO:
  RUN Print_Attrs.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f 


/* ***************************  Main Block  *************************** */

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Set Delimiter for the selection list. We cannot use ',' since
 * several numeric parameters are decimals and would mess up the
 * entries when using European format
 */
ASSIGN attr-list:DELIMITER = ";".

/* Get session Attributes. */
RUN get_attributes.

/* This adjustment is for when we are running with MS Sans Serif 8
 * as the default font
 */
IF SESSION:PIXELS-PER-COLUMN = 5 THEN
  ASSIGN FRAME {&FRAME-NAME}:WIDTH = FRAME {&FRAME-NAME}:WIDTH + 13
         attr-list:WIDTH           = attr-list:WIDTH + 14
         b_help:COLUMN             = b_help:COLUMN + 6
         b_print:COLUMN            = b_print:COLUMN + 6
         btn_close:COLUMN          = btn_Close:COLUMN + 6.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f  _DEFAULT-DISABLE
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
  HIDE FRAME f.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f  _DEFAULT-ENABLE
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
  ENABLE attr-list Btn_Close b_Print b_Help 
      WITH FRAME f.
  {&OPEN-BROWSERS-IN-QUERY-f}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get_attributes f 
PROCEDURE get_attributes :
/* -----------------------------------------------------------
  Purpose:    Populate a list with the session attributes
              in the form "Attribute = value"     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE fproc  AS HANDLE NO-UNDO.
  DEFINE VARIABLE lproc  AS HANDLE NO-UNDO.
  DEFINE VARIABLE fchild AS HANDLE NO-UNDO.
  DEFINE VARIABLE lchild AS HANDLE NO-UNDO.
  
  ASSIGN fproc  = SESSION:FIRST-PROCEDURE
         lproc  = SESSION:LAST-PROCEDURE
         fchild = SESSION:FIRST-CHILD
         lchild = SESSION:LAST-CHILD.
           
  attr-list:LIST-ITEMS IN FRAME {&FRAME-NAME} =
    "APPL-ALERT-BOXES       = " + STRING(SESSION:APPL-ALERT-BOXES) + 
   ";BATCH-MODE             = " + STRING(SESSION:BATCH-MODE) + 
   ";CHARSET                = " + SESSION:CHARSET + 
   ";CONTEXT-HELP-FILE      = " + (IF SESSION:CONTEXT-HELP-FILE NE ? THEN SESSION:CONTEXT-HELP-FILE ELSE "?") +
   ";CPCASE                 = " + (IF SESSION:CPCASE NE ? THEN SESSION:CPCASE ELSE "?") + 
   ";CPCOLL                 = " + (IF SESSION:CPCOLL NE ? THEN SESSION:CPCOLL ELSE "?") +
   ";CPINTERNAL             = " + (IF SESSION:CPINTERNAL NE ? THEN SESSION:CPINTERNAL ELSE "?") + 
   ";CPLOG                  = " + (IF SESSION:CPLOG NE ? THEN SESSION:CPLOG ELSE "?") +
   ";CPPRINT                = " + (IF SESSION:CPPRINT NE ? THEN SESSION:CPPRINT ELSE "?") +
   ";CPRCODEIN              = " + (IF SESSION:CPRCODEIN NE ? THEN SESSION:CPRCODEIN ELSE "?") +
   ";CPRCODEOUT             = " + (IF SESSION:CPRCODEOUT NE ? THEN SESSION:CPRCODEOUT ELSE "?") + 
   ";CPSTREAM               = " + (IF SESSION:CPSTREAM NE ? THEN SESSION:CPSTREAM ELSE "?") +
   ";CPTERM                 = " + (IF SESSION:CPTERM NE ? THEN SESSION:CPTERM ELSE "?") +   
   ";DATA-ENTRY-RETURN      = " + STRING(SESSION:DATA-ENTRY-RETURN) + 
   ";DATE-FORMAT            = " + STRING(SESSION:DATE-FORMAT) + 
   ";DEBUG-ALERT            = " + (IF SESSION:DEBUG-ALERT THEN "TRUE" ELSE "FALSE") + 
   ";DISPLAY-TYPE           = " + SESSION:DISPLAY-TYPE  + 
   ";FIRST-ASYNC-REQUEST    = " + (IF SESSION:FIRST-ASYNC-REQUEST NE ? THEN STRING(SESSION:FIRST-ASYNC-REQUEST) ELSE "?") +
   ";FIRST-CHILD            = " + STRING(SESSION:FIRST-CHILD) + (IF CAN-QUERY(fchild,"TYPE") THEN " [" + fchild:TYPE + "]" ELSE "") +
   ";FIRST-PROCEDURE        = " + (IF VALID-HANDLE(fproc) THEN fproc:FILE-NAME ELSE "<none>") +
   ";FIRST-SERVER           = " + (IF SESSION:FIRST-SERVER NE ? THEN STRING(SESSION:FIRST-SERVER) ELSE "?") +
   ";FIRST-SOCKET           = " + (IF SESSION:FIRST-SOCKET NE ? THEN STRING(SESSION:FIRST-SOCKET) ELSE "?") +
   ";FRAME-SPACING          = " + STRING(SESSION:FRAME-SPACING) + 
   ";GET-PRINTERS()         = " + (IF SESSION:GET-PRINTERS() NE ? THEN STRING(SESSION:GET-PRINTERS()) ELSE "<none>") + 
   ";HEIGHT-CHARS           = " + STRING(SESSION:HEIGHT-CHARS) + 
   ";HEIGHT-PIXELS          = " + STRING(SESSION:HEIGHT-PIXELS) + 
   ";IMMEDIATE-DISPLAY      = " + STRING(SESSION:IMMEDIATE-DISPLAY) + 
   ";LAST-ASYNC-REQUEST     = " + (IF SESSION:LAST-ASYNC-REQUEST NE ? THEN STRING(SESSION:LAST-ASYNC-REQUEST) ELSE "?") +
   ";LAST-CHILD             = " + STRING(SESSION:LAST-CHILD) + (IF CAN-QUERY(lchild,"TYPE") THEN " [" + lchild:TYPE + "]" ELSE "") +
   ";LAST-PROCEDURE         = " + (IF VALID-HANDLE(lproc) THEN lproc:FILE-NAME ELSE "<none>") +
   ";LAST-SERVER            = " + (IF SESSION:LAST-SERVER NE ? THEN STRING(SESSION:LAST-SERVER) ELSE "?") +
   ";LAST-SOCKET            = " + (IF SESSION:LAST-SOCKET NE ? THEN STRING(SESSION:LAST-SOCKET) ELSE "?") +
   ";MULTITASKING-INTERVAL  = " + STRING(SESSION:MULTITASKING-INTERVAL) +
   ";NUMERIC-DECIMAL-POINT  = " + SESSION:NUMERIC-DECIMAL-POINT +
   ";NUMERIC-FORMAT         = " + SESSION:NUMERIC-FORMAT +
   ";NUMERIC-SEPARATOR      = " + SESSION:NUMERIC-SEPARATOR +
   ";OLE-INVOKE-LOCALE      = " + (IF SESSION:OLE-INVOKE-LOCALE NE ? THEN STRING(SESSION:OLE-INVOKE-LOCALE) ELSE "?") +
   ";OLE-NAMES-LOCALE       = " + (IF SESSION:OLE-NAMES-LOCALE NE ? THEN STRING(SESSION:OLE-NAMES-LOCALE) ELSE "?") +
   ";PARAMETER              = " + SESSION:PARAMETER +
   ";PIXELS-PER-COLUMN      = " + STRING(SESSION:PIXELS-PER-COLUMN) + 
   ";PIXELS-PER-ROW         = " + STRING(SESSION:PIXELS-PER-ROW).

attr-list:LIST-ITEMS IN FRAME {&FRAME-NAME} = attr-list:LIST-ITEMS IN FRAME {&FRAME-NAME} +
   ";PRINTER-CONTROL-HANDLE = " + STRING(SESSION:PRINTER-CONTROL-HANDLE) +
   ";PRINTER-HDC            = " + (IF SESSION:PRINTER-HDC = ? THEN "?" ELSE STRING(SESSION:PRINTER-HDC)) +
   ";PRINTER-NAME           = " + (IF SESSION:PRINTER-NAME NE ? THEN SESSION:PRINTER-NAME ELSE "?") +
   ";PRINTER-PORT           = " + (IF SESSION:PRINTER-PORT NE ? THEN SESSION:PRINTER-PORT ELSE "?") + 
   ";REMOTE                 = " + (IF SESSION:REMOTE THEN "TRUE" ELSE "FALSE") +
   ";STREAM                 = " + SESSION:STREAM + 
   ";SUPER-PROCEDURES       = " + (IF SESSION:SUPER-PROCEDURES = "" THEN "<none>" ELSE SESSION:SUPER-PROCEDURES) +
   ";SUPPRESS-WARNINGS      = " + STRING(SESSION:SUPPRESS-WARNINGS) + 
   ";SYSTEM-ALERT-BOXES     = " + STRING(SESSION:SYSTEM-ALERT-BOXES) + 
   ";TEMP-DIRECTORY         = " + SESSION:TEMP-DIRECTORY + 
   ";THREE-D                = " + STRING(SESSION:THREE-D) +
   ";TIME-SOURCE            = " + SESSION:TIME-SOURCE + 
   ";TOOLTIPS               = " + (IF SESSION:TOOLTIPS THEN "TRUE" ELSE "FALSE") +
   ";TYPE                   = " + SESSION:TYPE +
   ";V6DISPLAY              = " + STRING(SESSION:V6DISPLAY) + 
   ";WAIT-STATE             = " + (IF SESSION:GET-WAIT-STATE() = "" THEN "<none>" ELSE SESSION:GET-WAIT-STATE()) +
   ";WIDTH-CHARS            = " + STRING(SESSION:WIDTH-CHARS) + 
   ";WIDTH-PIXELS           = " + STRING(SESSION:WIDTH-PIXELS) + 
   ";WINDOW-SYSTEM          = " + SESSION:WINDOW-SYSTEM +
   ";WORK-AREA-HEIGHT-PIXELS= " + STRING(SESSION:WORK-AREA-HEIGHT-PIXELS) +
   ";WORK-AREA-WIDTH-PIXELS = " + STRING(SESSION:WORK-AREA-WIDTH-PIXELS) +
   ";WORK-AREA-X            = " + STRING(SESSION:WORK-AREA-X) +
   ";WORK-AREA-Y            = " + STRING(SESSION:WORK-AREA-Y) +
   ";YEAR-OFFSET            = " + STRING(SESSION:YEAR-OFFSET).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Print_Attrs f 
PROCEDURE Print_Attrs :
/*------------------------------------------------------------------------------
  Purpose:     Print attributes 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Print Dialog routine. Largely stolen from adecomm/_report.p */
  
  DEFINE VARIABLE dev     AS CHARACTER   NO-UNDO
     VIEW-AS RADIO-SET
     RADIO-BUTTONS "Printer", "PRINTER", "File", "F"
     INIT "PRINTER".
  DEFINE VARIABLE fil     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE app     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE siz     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE stat    AS LOGICAL     NO-UNDO.
  
  DEFINE BUTTON btn_OK     LABEL "OK"     {&STDPH_OKBTN} AUTO-GO.
  DEFINE BUTTON btn_Cancel LABEL "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.
  DEFINE BUTTON btn_Files  LABEL "&Files...".
  DEFINE BUTTON btn_Help   LABEL "&Help"  {&STDPH_OKBTN}.
  
  DEFINE RECTANGLE rect_Btns {&STDPH_OKBOX}. /* standard button rectangle */
  
  &GLOBAL-DEFINE   HLP_BTN  &HELP = "btn_Help"
  
  FORM
     SKIP({&TFM_WID})
  
     dev LABEL "&Send Output to"           COLON 17
     SKIP ({&VM_WID})
  
     fil NO-LABEL FORMAT "x(60)"           AT    19
         VIEW-AS FILL-IN NATIVE SIZE 30 BY 1         {&STDPH_FILL} SPACE(.3)
     btn_Files
     SKIP({&VM_WID})
  
     app LABEL "&Append to Existing File?" AT    19
         VIEW-AS TOGGLE-BOX
     SKIP({&VM_WIDG})
  
     siz LABEL "&Page Length" FORMAT ">>9" COLON 17   {&STDPH_FILL}
     "(# Lines, 0 for Continuous)"
  
     {adecomm/okform.i
        &BOX    = rect_btns
        &STATUS = no
        &OK     = btn_OK
        &CANCEL = btn_Cancel
        {&HLP_BTN}
     }
  
     WITH frame prt_options
        SIDE-LABELS
        DEFAULT-BUTTON btn_Ok CANCEL-BUTTON btn_Cancel
        VIEW-AS DIALOG-BOX TITLE "Print Options".
     
  ON HELP of FRAME prt_options OR choose of btn_Help in frame prt_options
    RUN adecomm/_adehelp.p ("comm":u,"CONTEXT":u,{&Print_Options},?).
  
  ON WINDOW-CLOSE OF FRAME prt_options
    apply "END-ERROR" to frame prt_options.
  
  ON GO OF FRAME prt_OPTIONS DO:
    DEFINE VARIABLE h_datetime AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER                  NO-UNDO.  
    DEFINE VARIABLE attrs      AS CHARACTER FORMAT "X(70)" NO-UNDO.
      
    ASSIGN dev fil app siz.
  
    fil = TRIM(fil).
    IF dev <> "PRINTER" THEN DO:
       IF NOT app THEN DO:
         FILE-INFO:FILE-NAME = fil.
         IF fil = "" OR fil = ? OR INDEX(FILE-INFO:FILE-TYPE,"D") > 0 THEN DO:
           MESSAGE "Please enter a valid filename." VIEW-AS ALERT-BOX ERROR.
           APPLY "ENTRY" TO fil.
           RETURN NO-APPLY.
         END.
         IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
           DEF VAR choice AS LOGICAL INITIAL NO.
           MESSAGE fil "already exists. Overwrite?" VIEW-AS ALERT-BOX QUESTION 
             BUTTONS YES-NO UPDATE choice.
           IF NOT choice THEN DO:
             APPLY "ENTRY" TO fil.
             RETURN NO-APPLY.
           END.
         END.
       END.
       /* open the file to make sure we have permission */
       IF fil BEGINS "|" THEN
         OUTPUT THROUGH VALUE(SUBSTRING(fil,2,-1,"character":u))
                                 PAGE-SIZE VALUE(siz).
       ELSE IF app THEN
         OUTPUT TO VALUE(fil) PAGE-SIZE VALUE(siz) APPEND.
       ELSE
         OUTPUT TO VALUE(fil) PAGE-SIZE VALUE(siz).
       OUTPUT CLOSE.
         dev = fil.
    END.
    /* Header with Page specification */
    FORM HEADER
        h_datetime FORMAT "x(17)" SPACE(7) "Session Attributes"
        "Page" AT 70 PAGE-NUMBER (rpt) FORMAT "ZZ9" SKIP
        WITH FRAME page_head_paged
        PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.
  
    /* Header for continuous output (no page #) */
    FORM HEADER
        h_datetime FORMAT "x(17)" SPACE(7) "Session Attributes" SKIP
        WITH FRAME page_head_cont
        PAGE-TOP NO-LABELS NO-BOX NO-ATTR-SPACE NO-UNDERLINE USE-TEXT STREAM-IO.
    
    FORM attrs NO-LABEL WITH FRAME detail DOWN CENTERED USE-TEXT STREAM-IO.
  
    RUN adecomm/_setcurs.p ("WAIT").
    DO ON STOP UNDO, LEAVE:
      IF dev BEGINS "|"
      THEN OUTPUT STREAM rpt
        THROUGH VALUE(SUBSTRING(dev,2,-1,"character":u))
          PAGE-SIZE VALUE(siz).
      ELSE IF dev = "PRINTER"
        THEN OUTPUT STREAM rpt TO PRINTER.
      ELSE IF app
        THEN OUTPUT STREAM rpt TO VALUE(dev) PAGE-SIZE VALUE(siz) APPEND.
      ELSE OUTPUT STREAM rpt TO VALUE(dev) PAGE-SIZE VALUE(siz).
  
      ASSIGN h_datetime = STRING(TODAY) + " " + STRING(TIME,"HH:MM:SS").
  
      IF siz = 0 THEN
        VIEW STREAM rpt FRAME page_head_cont.
      else       
        VIEW STREAM rpt FRAME page_head_paged.
      
      /* The actual report ... */
      DO i = 1 to NUM-ENTRIES(attr-list:LIST-ITEMS IN FRAME {&FRAME-NAME},";"):
        DISPLAY STREAM rpt ENTRY(i,attr-list:LIST-ITEMS IN FRAME {&FRAME-NAME},";") @ attrs WITH FRAME detail.   
        DOWN STREAM rpt WITH FRAME detail.
      END. 
  
      OUTPUT STREAM rpt CLOSE.
    END.
    RUN adecomm/_setcurs.p ("").
   
  END.
  
   /*----- VALUE-CHANGED of DEVICE RADIO SET -----*/
  ON VALUE-CHANGED OF dev IN FRAME prt_options
  DO:
    /* Default to continuous output for terminal, 60 for printer. */
    ASSIGN dev = SELF:SCREEN-VALUE.
    IF dev = "F" /* file */ THEN DO:
      ASSIGN
        siz:SCREEN-VALUE IN FRAME prt_options    = "0"
        fil:SENSITIVE IN FRAME prt_options       = yes
        btn_Files:SENSITIVE IN FRAME prt_options = yes
        app:SENSITIVE IN FRAME prt_options       = yes
        .
      APPLY "ENTRY" TO fil IN FRAME prt_options.
    END.
    ELSE 
      ASSIGN
        siz:SCREEN-VALUE    IN FRAME prt_options = "60"
        fil:SENSITIVE       IN FRAME prt_options = no
        fil:SCREEN-VALUE    IN FRAME prt_options = ""
        btn_Files:SENSITIVE IN FRAME prt_options = no
        app:SENSITIVE       IN FRAME prt_options = no
        app:SCREEN-VALUE    IN FRAME prt_options = "no"
        .
  END.
    
  /*----- HIT of FILE BUTTON -----*/
  ON CHOOSE OF btn_Files IN FRAME prt_options
  DO:
    DEFINE VARIABLE name       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE picked_one AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE d_title    AS CHARACTER  NO-UNDO INITIAL "Report File".
   
    ASSIGN name = TRIM(fil:screen-value in FRAME prt_options).
    SYSTEM-DIALOG GET-FILE 
      name 
      filters            "*" "*"
      default-extension  ""
      title              d_title 
      update             picked_one.
   
    IF picked_one THEN
         fil:SCREEN-VALUE IN FRAME prt_options = name.
  END.
  
  /*=======Mainline for Print processing=========*/
  
  {adecomm/okrun.i  
     &FRAME = "frame prt_options" 
     &BOX   = "rect_Btns"
     &OK    = "btn_OK" 
     &CANCEL = "btn_Cancel"   /* to center for TTY mode */
     {&HLP_BTN}
  }
  
  /* Printer is default so adjust file and files button accordingly */
  ASSIGN
    app:SCREEN-VALUE IN FRAME prt_options    = "no"
    fil:SCREEN-VALUE IN FRAME prt_options    = ""
    fil:SENSITIVE IN FRAME prt_options       = no
    btn_Files:SENSITIVE IN FRAME prt_options = no
    app:SENSITIVE IN FRAME prt_options       = no
    .
  
  ASSIGN
    dev = "Printer"
    siz = 60.
  DISPLAY dev siz WITH FRAME prt_options.
  
  ENABLE
     dev
     siz
     btn_Ok 
     btn_Cancel
     btn_Help
     WITH frame prt_options.
  
  /* Reset tab-order for things that will be enabled later. */
  ASSIGN
    stat = fil:MOVE-AFTER-TAB-ITEM(dev:HANDLE IN FRAME prt_options) 
    stat = app:MOVE-AFTER-TAB-ITEM(btn_Files:HANDLE IN FRAME prt_options)
    stat = btn_Files:MOVE-AFTER-TAB-ITEM(fil:HANDLE IN FRAME prt_options) .
  
  DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
    WAIT-FOR CHOOSE OF btn_OK IN FRAME prt_options OR 
           GO     OF frame prt_options FOCUS dev.
  END.
  HIDE FRAME prt_options.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

