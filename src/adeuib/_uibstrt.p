/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _uibstrt.p

Description:
    Startup the UIB; initialize everything and create windows etc.
    This is called only once, when the UIB is first initialized.
   
Input Parameters:
   h_menu_frame   : Handle of h_menu_frame in _h_menu_win
   h_menubar      : HANDLE of the UIB menubar
   h_m_rule       : HANDLE of the horizontal rule in the main window

Output Parameters:
  <none>

Return-Value:
   NO-LICENSE     : returned if the user does not have a UIB license.
Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

Modified:
  9/30/93 wood     Walk _h_menu_frame widgets to make sure buttons fit in frame
  1/31/94 wood     Create widget palette widgets dynamically    
  6/13/94 ryan     Added _{&ADEICON-DIR} to bitmap palette to speed up access.
  6/14/94 tullmann Added profiler checkpoints
  6/26/94 ryan     took out work-around for fully qualified icon names for Unix
  8/17/94 tullmann Added small window support for 640x480 screens.
  1/27/95 gfs      Palette changes for 7.4 RoadRunner.
  2/10/95 gfs      Move object palette item creation to adeuib/_cr_pal.p
  2/14/95 gfs      Moved creation of palette window to adeuib/_cr_palw.p  
  12/6/96 gfs      Removed hardcoded BGCOLOR=8 and make frame three-d. This all 
                   was done so that a change to the 3D color in Windows95 would 
                   show through
  1/22/98 gfs      added MAX-BUTTON set to "no" to UIB Main Window
  1/23/98 gfs      Make UIB main window a drag & drop target
  04/1/98 gfs      Moved license check to adeshar/_ablic.p
  4/17/98 gfs      Workshop icon appears if Webspeed-only.
  4/05/99 tsm      Added setting of _numeric_decimal and _numeric_separator to
                   support various Intl numeric formats (in addition to 
                   American and European)
  5/14/99 tsm      Removed _numeric_format in support of various Intl
                   numeric formats
  9/30/99 jep      Set the advanced/color editor dialog box help file name with
                   call to procedure SetEdHelpFile defined in adecomm/peditor.i.
  8/15/01 jep      ICF development environment support. jep-icf
                   Use _AB_Tools to see if Enable-ICF is true and make window
                   changes and status bar changes based on that.
---------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER h_menu_frame    AS WIDGET NO-UNDO. 
DEFINE INPUT  PARAMETER h_menubar       AS WIDGET NO-UNDO.
DEFINE INPUT  PARAMETER h_m_rule        AS WIDGET NO-UNDO.

{adecomm/oeideservice.i}
{adeuib/timectrl.i}    /* Controls profiler                   */
{adeshar/mpdecl.i &timer="UIB_startup"} /* Declare timer for profiler */

{adecomm/adefext.i}    /* ADE Preprocessor - defines UIB_NAME */
{adeuib/uniwidg.i}     /* universal widgets                   */
{adeuib/sharvars.i}    /* Most common shared variables        */
{adeuib/windvars.i}    /* Window Creation Variables           */
{adeuib/custwidg.i}    /* Custom Widget Definitions           */
{adecomm/adestds.i}    /* ADE standards - defines adeicon/    */

&SCOPED-DEFINE DATASERVER YES
{prodict/dictvar.i NEW}
&UNDEFINE DATASERVER

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

/* Local Variables */
DEFINE VARIABLE h             AS WIDGET                     NO-UNDO.
DEFINE VARIABLE idummy        AS INTEGER                    NO-UNDO.
DEFINE VARIABLE ldummy        AS LOGICAL                    NO-UNDO.
DEFINE VARIABLE i             AS INTEGER                    NO-UNDO.
DEFINE VARIABLE j             AS INTEGER                    NO-UNDO.
DEFINE VARIABLE non           AS LOGICAL                    NO-UNDO. /* any non-PRO dbs? */
DEFINE VARIABLE org           AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE status-boxes  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE cText         AS CHARACTER INITIAL "12345678901234567890" NO-UNDO. 
DEFINE VARIABLE chars-per-col AS DECIMAL   INITIAL 1.0                    NO-UNDO.

/* ===================================================================== */
/*                             LICENSE CHECK                             */
/* ===================================================================== */
RUN adeshar/_ablic.p (INPUT YES /* ShowMsgs */ , OUTPUT _AB_license, OUTPUT _AB_Tools). /* jep-icf */
IF _AB_license = ? THEN 
  RETURN "NO-LICENSE":U. /* The AB is not licensed */
/* jep-icf: AB License check has additional _AB_Tools parameter. */

/* ====================================================================== */
/*            Setup environment and compute some globals                  */
/* =====================================================================  */
PAUSE 0 BEFORE-HIDE.

RUN adecomm/_setcurs.p ("WAIT").  /* Set the cursor pointer in all windows */

/* Make sure we have a decent DICTDB */
IF DBTYPE("DICTDB") = "PROGRESS" AND DBVERSION("DICTDB") <> "9" THEN
  DELETE ALIAS "DICTDB".

cache_dirty = ?. /* flag to dictgues that this is first time */
RUN "prodict/_dctsget.p". /* build db cache */
IF NUM-DBS > 0 THEN DO:   /* Stolen code from prodict/_dctgues.p */
  org = LDBNAME("DICTDB").

  DO i = 1 TO cache_db# WHILE NOT non:
    non = NOT cache_db_t[i] BEGINS "PROGRESS".
  END.

  /* start optional code */
  IF non AND org <> ? AND DBTYPE("DICTDB") = "PROGRESS" THEN DO:
    DO i = 1 TO cache_db# WHILE cache_db_l[i] <> LDBNAME("DICTDB"):
      /* empty loop */
    END.
    RUN "prodict/_dctscnt.p" (INPUT cache_db_l[i], OUTPUT j).
    IF j = 0 THEN DELETE ALIAS "DICTDB".
  END.
  /* end optional code */

  DO i = 1 TO cache_db# WHILE LDBNAME("DICTDB") = ?:
    IF CAN-DO("PROGRESS/V5,PROGRESS/V6,PROGRESS/V7,PROGRESS/V8",cache_db_t[i])
      OR NOT CAN-DO(GATEWAYS,cache_db_t[i]) THEN NEXT.
    CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cache_db_s[i]) NO-ERROR.
    RUN "prodict/_dctscnt.p" (INPUT cache_db_l[i], OUTPUT j).
    IF j = 0 THEN
      DELETE ALIAS "DICTDB".
  END.
END.

/* If we don't have a DICTDB and we do have a connected DB, use the 1st */
IF LDBNAME("DICTDB") = ? AND NUM-DBS > 0 AND cache_db# > 0 THEN DO:
  CREATE ALIAS DICTDB FOR DATABASE VALUE(cache_db_s[1]).
END.

ASSIGN SESSION:SYSTEM-ALERT-BOXES = yes
       SESSION:DATA-ENTRY-RETURN  = no
       CURRENT-WINDOW             = DEFAULT-WINDOW
       _numeric_decimal           = SESSION:NUMERIC-DECIMAL-POINT
       _numeric_separator         = SESSION:NUMERIC-SEPARATOR.

/* Establish UIB temporary file name. */
IF _comp_temp_file = ? THEN
    RUN adecomm/_tmpfile.p
        ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT _comp_temp_file).

RUN adeshar/_dialbdr.p.  /* Compute the size of dialog-box borders */

/* Create the menu window containing the bar menu and the icon pallette  */
CREATE WINDOW _h_menu_win
         ASSIGN MENUBAR        = h_menubar
                MAX-BUTTON     = no
                DROP-TARGET    = yes
                THREE-D        = yes    
                RESIZE         = FALSE
                SCROLL-BARS    = FALSE
                HEIGHT-P       = (h_menu_frame:HEIGHT-PIXELS)
                MESSAGE-AREA   = FALSE
                STATUS-AREA    = FALSE
                TITLE          = "{&UIB_NAME}"
                HIDDEN         = YES.   

ASSIGN 
  _h_menu_win:WIDTH-P   = (h_menu_frame:WIDTH-PIXELS) 
  _h_menu_win:HEIGHT-P  = (h_menu_frame:HEIGHT-PIXELS) 
  _h_menu_win:X         = &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
                          10 + {&init_palette_width} + 25
                          &ELSE
                          {&init_palette_width} + IF
                          SESSION:WIDTH-PIXELS / SESSION:WIDTH-CHARS < 7.25
                          THEN 15 ELSE (IF SESSION:WIDTH-PIXELS = 640 AND
                               SESSION:PIXELS-PER-COLUMN = 8 THEN 14 ELSE 30)
                          &ENDIF
  _h_menu_win:Y         = &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 30
                          &ELSE 0 &ENDIF
  NO-ERROR.

  IF OEIDEIsRunning THEN
  DO:
    RUN displayWindow IN hOEIDEService ("com.openedge.pdt.oestudio.views.OEAppBuilderView", "DesignView_" + getProjectName(), _h_menu_win).
  END.

/* jep-icf: Adjust width to account for extra ICF status bar boxes user and company. */
IF CAN-DO(_AB_Tools,"Enable-ICF") THEN
DO:
  /* jep-icf: Since the status box displays text, add an appropriate amount to the main window
     taking into account the window's font. */
  ASSIGN chars-per-col = FONT-TABLE:GET-TEXT-WIDTH(cTEXT, _h_menu_win:FONT) / LENGTH(cText) NO-ERROR.
  ASSIGN _h_menu_win:WIDTH    = _h_menu_win:WIDTH + (17 * chars-per-col) + (25 * chars-per-col) NO-ERROR.
  ASSIGN h_menu_frame:WIDTH-P = _h_menu_win:WIDTH-P NO-ERROR.
END.

/* Shorten the Menu bar if it is too big */
IF _h_menu_win:X + _h_menu_win:WIDTH-P > SESSION:WIDTH-PIXELS
THEN _h_menu_win:WIDTH-P = SESSION:WIDTH-PIXELS - _h_menu_win:X.
                 
/* Do some run time layout on this window. */
IF h_menu_frame:WIDTH-PIXELS < _h_menu_win:WIDTH-PIXELS       
THEN h_menu_frame:WIDTH-PIXELS = _h_menu_win:WIDTH-PIXELS.

ASSIGN ldummy                 = _h_menu_win:LOAD-ICON( {&ADEICON-DIR} + 
                                (IF _AB_License = 2 THEN "workshp%":U ELSE "uib%":U) +
                                "{&icon-ext}" )                          
       h_m_rule:WIDTH-PIXELS  = h_menu_frame:WIDTH-PIXELS -
                                h_menu_frame:BORDER-LEFT-PIXELS -
                                h_menu_frame:BORDER-RIGHT-PIXELS .

        
/* jep-icf: Override AppBuilder titlebar icon for ICF. */
IF CAN-DO(_AB_Tools,"Enable-ICF") THEN
    _h_menu_win:LOAD-ICON("adeicon/icfdev.ico":U) NO-ERROR.

                                
/* Walk the widget tree to make sure all widgets fit in the frame -- this
 * (hopefully) will solve any problem of font changes. This is a last-ditch
 * check of widget sizing. It could be smarter (i.e. I could resize the
 * frame proportionately) but maybe later. 
 * REF: Bug #93-09-23-025 7.2C P1  UI1: UIB aborts running on ALRODT box 
 */
ASSIGN h = h_menu_frame:FIRST-CHILD        /* The Field Group */
       h = h:FIRST-CHILD.                  /* The grandchild */
DO WHILE h NE ?:            
  IF h:X + h:WIDTH-P >= h_menu_frame:WIDTH-P 
  THEN h:WIDTH-P = h_menu_frame:WIDTH-P - h:X - 1. 
  IF h:Y + h:HEIGHT-P >= h_menu_frame:HEIGHT-P 
  THEN h:HEIGHT-P = h_menu_frame:HEIGHT-P - h:Y - 1.
  /* jep-icf: Size toolbar rectangle to equal the frame width. */
  IF (h:NAME = "tbrect":u) THEN
    ASSIGN h:WIDTH-P = h_menu_frame:WIDTH-P NO-ERROR.
  h = h:NEXT-SIBLING.
END.

/* Add a Status Bar to the main window.  Enlarge the window to accomodate this. */
ASSIGN status-boxes = "30,4,12,3":U.  

/* jep-icf: Add status boxes for icf information user and company. */
IF CAN-DO(_AB_Tools,"Enable-ICF") THEN
  ASSIGN status-boxes = status-boxes + ",17,25":U.

RUN adecomm/_status.p (INPUT _h_menu_win,
                       INPUT status-boxes,
                       INPUT False,
                       INPUT 4, /* font */
                       OUTPUT _h_status_line, OUTPUT idummy).              

  ASSIGN _h_menu_win:HEIGHT-P   = _h_menu_win:HEIGHT-P + _h_status_line:HEIGHT-P.
  ASSIGN _h_status_line:Y       = _h_menu_win:HEIGHT-P - _h_status_line:HEIGHT-P.
  ASSIGN _h_status_line:VISIBLE = YES NO-ERROR. /* suppress widget doesn't fit errors. */

     /* The following line is not strictly necessary, but solved a bug where
      *setting HEIGHT-P on a hidden window causes the width to shrink to 100.
      * WmTWood 9/2/93 - Bug #93-09-03-034  SETTING HEIGHT-P ON HIDDEN WINDOW 
      * _h_menu_win:WIDTH-P = _h_menu_win:MAX-WIDTH-P   
      * This bug was fixed 01/28/94 so this line can be removed 
      */

/* Profiler Checkpoint */
{adeshar/mp.i &timer="UIB_startup" &mp-macro="stotal"
              &infostr="[_uibstrt.p] Before run of create_palette" }

/* Profiler Checkpoint */
{adeshar/mp.i &timer="UIB_startup" &mp-macro="stotal"
              &infostr="[_uibstrt.p] After run of create_palette" }
  
/* Initialize for the creation of the first window or dialog.  */
/* Draw it at a location determined by the palette positions.  */  
/* Note that _cur_win_x is set in _uibmain.p.                  */   
ASSIGN _cur_win_y = _h_menu_win:Y + _h_menu_win:HEIGHT-PIXELS +
                    &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 80
                    &ELSE SESSION:PIXELS-PER-ROW * 2 &ENDIF .

/* Do some "corrections" for windows version on a smaller screen. */
&IF "{&WINDOW-SYSTEM}" <> "OSF/Motif" &THEN
ASSIGN _cur_win_rows = IF SESSION:HEIGHT-CHARS < 22 THEN 11
                       ELSE IF SESSION:HEIGHT-CHARS < 24 THEN 14
                       ELSE IF SESSION:HEIGHT-CHARS < 27 THEN 16
                       ELSE 22
       _cur_win_cols = IF SESSION:WIDTH-CHARS < 100 THEN 74 ELSE 82 NO-ERROR.
&ENDIF


/* Set the advanced/color editor dialog box help file name. */
/* adecomm/peditor.i */
RUN SetEdHelpFile.

/* Advanced/Color Editor support procedures. */
{adecomm/peditor.i}
