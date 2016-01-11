/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/*----------------------------------------------------------------------------

File: _uibmain.p

Description:
    The main routine for the UIB.  It defines the menu bar.

Input Parameters:
   p_File_list: List of files to open
       "a,b,c"  Open files a, b and c
       ""       Open the UIB with nothing special
       "?,NEW"  Open the UIB and create a new window [ignore the user
                defaults].  This will generally act like the File/New menu-item
                i.e. it will bring up a dialog.

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Modified    : 
    10/10/01 jep-icf  IZ 2101 Run button enabled when editing dynamic objects.
    08/15/01 jep      Added support for ICF development environment. jep-icf
    05/07/99 tsm      Added support for Most Recently Used FileList
    04/07/99 tsm      Added support for various Intl Numeric Formats (in addition
                      to American and European) by using session set-numeric-format
                      method to set format back to user's setting
    02/12/98 dma      Removed Profiler Checkpoints (adeshar/mp*.*), added second
                        parameter to _qssuckr.p calls for remote WebSpeed objects
    02/02/96 gfs      Adjust windows for Windows 95 taskbar
    01/03/96 gfs      Updated profile checkpoints for V8.0A code.
    03/03/05 jep      LIB-MGR initialization and support.
    Feb 95   gfs      Implement new palette and New functionality.
    1/13/95  gfs      Comment out loading of XFTR's
    9/29/94  gfs      Added call to load xftrs
    6/15/94  tullmann Added profiler checkpoints and init
    12/7/93  RPR      Added combo box
----------------------------------------------------------------------------*/
/* ===================================================================== */
/*                      PREPROCESSOR DEFINITIONS                         */
/* ===================================================================== */
&SCOPED-DEFINE start_draw_cursor "CROSS"
&SCOPED-DEFINE end_draw_cursor   "SIZE-SE"
&SCOPED-DEFINE dbgmsg_lvl        0
&SCOPED-DEFINE USE-3D            YES
&GLOBAL-DEFINE WIN95-BTN         YES

/* Define this variable because it is used in many places and we want to 
   check whether or not the hAttrED:FILE-NAME is valid. */
&SCOPED-DEFINE AttrEd adeuib/_attr-ed.w

/* Define a SKIP for alert-boxes that only exists under Motif */
&GLOBAL-DEFINE SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* jep-icf: These contain the location of the components of the status line. */
&GLOBAL-DEFINE STAT-Main 1
&GLOBAL-DEFINE STAT-Page 2
&GLOBAL-DEFINE STAT-Tool 3
&GLOBAL-DEFINE STAT-Lock 4

/* ===================================================================== */
/*                            INCLUDE FILES                              */
/* ===================================================================== */

{adeuib/pre_proc.i}             
{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
{adeuib/uibhlp.i}          /* UIB Help File Preprocessor Directives */
{adm2/support/admhlp.i}    /* ADM Help File Preprocessor Directives */
{adeuib/property.i NEW}    /* Property temp-table Definitions       */
{adeuib/custwidg.i NEW}    /* Custom User Widgets Temp-Table        */
{adeuib/links.i    NEW}    /* ADM links temp-table def              */
{adecomm/adefext.i}
{adeweb/htmwidg.i NEW}     /* Web temp-table definitions            */
{adeuib/vsookver.i}        /* adm versioning                        */
{adeshar/mrudefs.i}        /* MRU Filelist temp table defs          */
{adeuib/peditor.i}         /* Editor support procedures             */

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
/* jep-icf: Moved here from uibmdefs.i for icf support.                  */
{adeuib/sharvars.i NEW}
{adeuib/gridvars.i NEW}
{adeuib/windvars.i NEW}
{adeuib/dialvars.i NEW}    /* Dialog box border variables         */

/* Necessary to launch a dynamic container and clear its cache */
DEFINE NEW GLOBAL SHARED VARIABLE gshRepositoryManager AS HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gshSessionManager    AS HANDLE   NO-UNDO.

/* ===================================================================== */
/*                          OTHER Definitions                            */
/* ===================================================================== */
/* Stores Visible state of OCX Property Editor window when running a procedure or
   for Tools menu calls. */
DEFINE VARIABLE PropEditorVisible AS LOGICAL NO-UNDO.

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF


/* ==================================================================== */
/*                         Function Prototypes                          */
/* ==================================================================== */
FUNCTION GetHelpFile RETURNS CHARACTER
  (INPUT p_HelpID AS CHARACTER) FORWARD.
  
/* Establish if Dynamics is running */
ASSIGN _DynamicsIsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
IF _DynamicsIsRunning = ? THEN _DynamicsIsRunning = NO.
/** Contains definitions for dynamics design-time temp-tables. **/
{destdefi.i}


/* Startup function library */
RUN adeuib/_abfuncs.w PERSISTENT SET _h_func_lib.

/* ==================================================================== */
/*                         Setup Block                                  */
/* ==================================================================== */
/* Put a BLOCK around the UIB setup, so that we can trap stop and errors */
DEF VAR setup_ok AS LOGICAL INITIAL FALSE NO-UNDO.
/* Create a widget-pool to keep everything we create.
   It allows us to clean up if the UIB setup fails.   */
/* Also create a named widget pool to allow dynamic widgets
   that are created by other procedures that are called
   from the AppBuilder and have their own unnamed widget
   pools (such as the Section Editor) to be associated with the
   AB session.  This is necessary to ensure that these widgets
   do not get deleted when the other procedure goes out of
   scope (see bug 20000404-003 for an example).  8/2/00 tomn
*/
CREATE WIDGET-POOL.
CREATE WIDGET-POOL "{&AB_Pool}".

/* jep-icf: Establish license check right away, but don't show any messages. */
RUN adeshar/_ablic.p (INPUT NO /* ShowMsgs */ , OUTPUT _AB_license, OUTPUT _AB_Tools). /* jep-icf */

/* UIB Definitions         */
{adeuib/uibmdefs.i}
/* jep-icf: Moved uibmdefs.i to here from earlier in this code. It's
   creating dynamic widgets that should be in the correct AB widget pool. */

SETUP_BLOCK:
DO ON STOP   UNDO SETUP_BLOCK, LEAVE SETUP_BLOCK
   ON ERROR  UNDO SETUP_BLOCK, LEAVE SETUP_BLOCK:
  
  /* First Thing -- remember the handle of the UIB's main procedure so
     that we can RUN...IN it */
  _h_uib = THIS-PROCEDURE.
  
  /* UIB Internal Procedures - these have been split up to accommodate  */
  /*                           the editor                               */
  {adeuib/uibmproa.i}
  {adeuib/uibmproe.i}
  {adeuib/uibmundo.i}

  /* =================================================================== */
  /*                     START OF EXECUTABLE CODE                        */
  /* =================================================================== */

  /* Save the users value for THREE-D */
  &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
  ASSIGN save_3D = SESSION:THREE-D
         SESSION:THREE-D = YES.
  &ENDIF
  
  /* Startup the UIB - licence check, create windows etc. */
  RUN adeuib/_uibstrt.p 
    (FRAME action_icons:HANDLE, /* Frame in Main Window         */
     MENU m_menubar:HANDLE,     /* Menubar of Main Window       */     
     h-rule-1:HANDLE ). 

  IF RETURN-VALUE = "NO-LICENSE" THEN STOP.
  
  RUN mode-morph ("INIT").
  RUN initialize_uib.                 /* Internal procedure below    */
  IF RETURN-VALUE = "_ABORT" THEN STOP.

  ON WINDOW-MINIMIZED OF _h_menu_win
    /* Hide OCX Property Editor window. */
    RUN show_control_properties (2).

  ON WINDOW-RESTORED OF _h_menu_win
  DO:
    /* Show OCX Property Editor window if need to. */
    RUN show_control_properties (3).
    APPLY "ENTRY" TO _h_menu_win.
  END.

  /* UIB main trigger code */
  {adeuib/uibmtrig.i}

END. /* of SETUP_BLOCK */

/* Bale out if the UIB was not setup. */
IF NOT setup_ok THEN DO:
  /* Restore cursor for the calling program. */
  RUN adecomm/_setcurs.p ("").
  /* Delete any widgets we created */
  DELETE WIDGET-POOL.
  DELETE WIDGET-POOL "{&AB_Pool}".
  /* Restore the users value for THREE-D */
  &IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN 
    SESSION:THREE-D = save_3d.
  &ENDIF
  RETURN.
END.

STOP_BLOCK:
DO ON STOP   UNDO STOP_BLOCK, RETRY STOP_BLOCK
   ON ERROR  UNDO STOP_BLOCK, RETRY STOP_BLOCK:
       
  /* Are we in a retry situation? */
  IF RETRY THEN DO:
      MESSAGE "OK to quit the AppBuilder?" SKIP (1)
              "WARNING: Unsaved work will be lost, but" SKIP
              "the open files may be corrupted. You" SKIP
              "should not save the open files on top of" SKIP
              "their originals." SKIP (1)
              "Press ~"OK~" to quit the AppBuilder, or" SKIP
              "press ~"Cancel~" to continue."
              VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE ldummy.
      IF ldummy THEN DO:
        /* SEW call to close and delete SEW and its children. */
        RUN call_sew ("SE_EXIT":U).
        UNDO STOP_BLOCK, LEAVE STOP_BLOCK.
      END.
  END.
   
&IF {&dbgmsg_lvl} > 0 &THEN
/* ===================================================================== */
/*                              MESSAGE WATCHER                          */
/* ===================================================================== */
msg_watcher:READ-ONLY in frame action_icons = FALSE.

procedure msg_watch.
  DEFINE INPUT PARAMETER intxt   AS CHARACTER      NO-UNDO.
  DEFINE VARIABLE last-msg AS CHAR              NO-UNDO.
  
  /* Make a string LAST-EVENT FUNCTION:LABEL > SELF:TYPE LABEL. */
  last-msg = LAST-EVENT:FUNCTION.
  IF last-msg <> LAST-EVENT:LABEL
    THEN last-msg = last-msg + ":" + LAST-EVENT:LABEL.
  ASSIGN last-msg = /* LAST-EVENT:TYPE + " " + */
                    last-msg + " > " +
                    SELF:TYPE + " " +
                   IF CAN-QUERY(SELF,"LABEL") THEN SELF:LABEL
                                              ELSE STRING(SELF)
         last-msg = last-msg +   " [" + intxt + "]" + CHR(10) 
         msg_watcher:CURSOR-OFFSET IN FRAME action_icons = 1
         ldummy = msg_watcher:INSERT-STRING( last-msg ) IN FRAME action_icons.
end.

&ENDIF

/* Exiting from the UIB */
ON WINDOW-CLOSE OF _h_menu_win
DO:
  DEF VARIABLE save_opt   AS LOGICAL   NO-UNDO.
  DEF VARIABLE cancel     AS LOGICAL   NO-UNDO.
  DEF VARIABLE OK_Close   AS LOGICAL   NO-UNDO.
  DEF VARIABLE h          AS WIDGET    NO-UNDO.

  /* If we're running in a Dynamics session, make sure Dynamics is OK with the session ending */
  IF _DynamicsIsRunning 
  AND (SEARCH("af/sup2/afcnfrmext.p") <> ?
    OR SEARCH("af/sup2/afcnfrmext.r") <> ?)
  THEN DO:
      RUN af/sup2/afcnfrmext.p (OUTPUT OK_Close) NO-ERROR.
      IF OK_Close <> TRUE THEN RETURN NO-APPLY.
  END.

  /* Don't accept this action if the main UIB window (SELF) is disabled
     or if UIB's Stop_Button is sensitive.
     
     [This happens while we are running Tools or user code].
     NOTE: Disabling the window does not disable the WINDOW-CLOSE event
     which is why we have to do this check.
  */
  
  IF SELF:SENSITIVE AND NOT Stop_Button:SENSITIVE THEN
  DO:
    
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
   
    /* Close all windows -- the close action provides the calls to SCM hooks */
    FOR EACH _U WHERE CAN-DO("WINDOW,DIALOG-BOX",_U._TYPE) AND
             _U._STATUS <> "DELETED":
       /* Close the window.  This should delete the widget.  If the widget
          ever comes back not deleted, then the user cancelled, so we
          cancel the exit */
       h = _U._HANDLE.
       RUN wind-close (h).   
       IF VALID-HANDLE(h) THEN RETURN NO-APPLY.
    END.

    /* Now perform a close all for any open Procedure Windows belonging to
       the UIB.
    */
    REPEAT ON STOP UNDO, LEAVE:
      RUN adecomm/_pwexit.p ("_ab.p":U /* PW Parent ID */ ,
                             OUTPUT OK_Close ).
      LEAVE.
    END.
    /* Cancel the close event. */
    IF OK_Close <> TRUE THEN RETURN.

    /* Close all open XML Mapping Tool windows belonging to the AB. */
    REPEAT ON STOP UNDO, LEAVE:
      RUN adexml/_winexit.p ("_ab.p":U /* Parent ID */, OUTPUT OK_Close ).
      LEAVE.
    END.
    /* Cancel the close event. */
    IF OK_Close <> TRUE THEN RETURN.
    
    /* SEW call to close and delete SEW and its children. */
    RUN call_sew ("SE_EXIT":U).

    /* Close down the Character Run Window. FALSE suppresses messages. */
    RUN adeuib/_ttysx.p (FALSE).

    APPLY "U9" TO _h_menu_win.
    /* Return NO-APPLY for the WINDOW-CLOSE event */
    IF SELF eq _h_menu_win THEN RETURN NO-APPLY.
  END.
END.

/* =================================================================== */
/*                             UIB WAITFOR                             */
/* =================================================================== */
 
  /* Reset the cursor because here we have a possibility for user input      */
  RUN adecomm/_setcurs.p (""). 

  /* Establish AppSever Application Service Tables and AppSrvUtils handle */
  {adecomm/appserv.i}
  
  /* Show the current widget and setup for pointer mode */
  RUN display_current.
  RUN choose-pointer. /* Return to pointer mode. */
  /* Make sure everything is sensitized correctly. */
  RUN sensitize_main_window ("WIDGET,WINDOW").
  
  /* Intercept the keyboard endkey events and do nothing.  This
     workaround bug# 93-07-14-057 where the "OK to quit message " screws up if
     we have the DO...ON ENDKEY UNDO STOP_BLOCK, RETRY STOP_BLOCK 
     Regardless, various people feel we should just eat the ENDKEY keystroke. 
     There is also a bug where hitting the END-KEY quickly sends an END-ERROR
     event. (bug 93-09-23-127) We want to catch real errors, but not the case
     of END-ERROR key.  Therefore, on ERROR just retry. */
  DO ON ENDKEY UNDO, RETRY
     ON ERROR  UNDO, RETRY:
    IF RETRY AND NOT CAN-DO ("END-ERROR,END-KEY",LAST-EVENT:FUNCTION)
    THEN LEAVE.

    WAIT-FOR "U9":U OF _h_menu_win FOCUS cur_widg_name.
  END.
END. /* STOP-BLOCK */

/* Let user know we are working on something */
RUN adecomm/_setcurs.p ("WAIT":U).

/* Do custom UIB shutdown -- this file is generally a no-op, but it can
   be used to cleanup custom modifications.  */
RUN adecomm/_adeevnt.p ("UIB", "Shutdown", STRING(THIS-PROCEDURE), 
                        STRING(_h_menu_win), OUTPUT ldummy). 

/* We need to update the filelist before writing preferences, user may 
   have adjusted MRU Entries but not saved settings.  */
RUN adeshar/_mrulist.p ("", "").

RUN adeuib/_putpref.p (save_settings).

/* The value of SESSION:NUMERIC-FORMAT may need resetting (because _putprefs 
   sets it to "AMERICAN"). */      
SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
                  
/* Clean up everything . */
IF VALID-HANDLE(hAttrEd) THEN APPLY "CLOSE" TO hAttrEd.
RUN adeuib/_uibshut.p.

/* Restore the users value for THREE-D */
&IF "{&WINDOW-SYSTEM}" ne "OSF/Motif" &THEN
  SESSION:THREE-D = save_3d.
&ENDIF

/* Restore cursor for the calling program. */
RUN adecomm/_setcurs.p ("").

/* Restore date setting */
ASSIGN SESSION:DATE-FORMAT = _orig_dte_fmt.

/* Delete any widgets created at any time in the uib widget pool. */
DELETE WIDGET-POOL.
DELETE WIDGET-POOL "{&AB_Pool}".

/* ==================================================================== */
/*                    Procedures & Functions                            */
/* ==================================================================== */
PROCEDURE initialize_uib:
  /* Create PROX.PROIDE com object to support ActiveX controls */   
  CREATE "PROX.PROIDE" _h_Controls NO-ERROR.
  IF (ERROR-STATUS:ERROR = TRUE) AND (ERROR-STATUS:NUM-MESSAGES > 0) THEN
  DO ON STOP UNDO, RETRY:
    DEFINE VAR msg_line     AS INTEGER NO-UNDO.
    DEFINE VAR UIB_Continue AS LOGICAL NO-UNDO.
    
    IF NOT RETRY THEN
    DO msg_line = 1 TO ERROR-STATUS:NUM-MESSAGES:
      MESSAGE ERROR-STATUS:GET-MESSAGE(msg_line)
        VIEW-AS ALERT-BOX ERROR TITLE "{&UIB_SHORT_NAME}"  IN WINDOW ACTIVE-WINDOW.
    END.
    MESSAGE "{&UIB_SHORT_NAME}" 
            "encountered errors and cannot support ActiveX controls." SKIP
            "You may encounter further errors if you try to open or run" 
            "procedure files" SKIP
            "containing ActiveX controls."
            SKIP(1)
            "Do you want to continue and start the" "{&UIB_SHORT_NAME}" "anyway?"
      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "{&UIB_SHORT_NAME}" 
              UPDATE UIB_Continue IN WINDOW ACTIVE-WINDOW.
    IF UIB_Continue <> TRUE THEN RETURN "_ABORT".
  END.

  /* Set the help file so dialogs provided by PROX.PROIDE can call with Help
     Context IDs. */
  ASSIGN _h_controls:HelpFile = GetHelpFile("AB":U) NO-ERROR.

  /* Get the current user prefs (we need this before we initialize the
     Custom Widgets, because one preference is the name of the custom file.) */
  CREATE _uib_prefs.
  RUN adeuib/_getpref.p (OUTPUT save_settings).
  IF _suppress_dbname THEN Schema_Prefix = 1.  /* Insert dbfields with Table only */
  /* 99-02-15-020 Here because the menu was already set in mode-morph but
   * the values had not yet been read in from the registry.
   * These are the only two options affected.
   */
  IF _AB_License NE 2 THEN
  ASSIGN mi_grid_snap:CHECKED    = _cur_grid_snap
         mi_grid_display:CHECKED = _cur_grid_visible.
  
  /* Initialize some temp-tables */
  RUN adeuib/_cr_prop.p.            /* Property Temp-Tables */

  /* Initialize the ADE LIB-MGR Object. */
  RUN adecomm/_adeobj.p ("LIB-MGR":U, INPUT-OUTPUT _h_mlmgr).
  
  /* Initialize the ADE WINMENU-MGR Object for active windows. */
  RUN adecomm/_adeobj.p ("WINMENU-MGR":U, INPUT-OUTPUT _h_WinMenuMgr ).

  RUN adeuib/_initpal.p.  /* initialize the palette temp-table */

  RUN adeuib/_cr_cust.p (yes).  /* read custom.txt file */
  IF RETURN-VALUE = "_ABORT" THEN RETURN "_ABORT".

  /* Create object palette window */
  RUN adeuib/_cr_palw.p(MENU mb_toolbox:HANDLE).
  
  /* Set initial states on palette menubar */
  IF _palette_menu THEN 
    ASSIGN MENU-ITEM mi_menu_only:CHECKED IN MENU m_toolbox = yes.
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  IF _palette_top  THEN
    ASSIGN MENU-ITEM mi_top_only:CHECKED IN MENU m_toolbox = yes.
  &ENDIF

  /* Create the widget palette icons (and custom widget extensions). */
  RUN adeuib/_cr_pal.p (no).  

  RUN adeuib/_cr_cmnu.p(MENU m_toolbox:HANDLE). /* create custom menus */
  
  /* Since the palette location can now be saved/restored, we'll see if
   * the palette happens to be in the upper-left corner, if so, we'll adjust
   * the UIB windows, if not leave it.
   */
  IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO: 
    /* special adjustment for Win95 TaskBar */
    DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
    DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

    RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                            OUTPUT TBWIdth,       OUTPUT AutoHide).
    IF NOT AutoHide THEN DO:
      IF TBOrientation = "LEFT":U AND _h_object_win:X <= TBWidth THEN
        ASSIGN _h_object_win:X = TBWidth.
      IF TBOrientation = "LEFT":U AND _h_menu_win:X <= TBWidth THEN
        ASSIGN _h_menu_win:X   = TBWidth.
      IF TBOrientation = "TOP":U THEN DO:
        IF _h_object_win:Y <= TBHeight THEN _h_object_win:Y = TBHeight.
        IF _h_menu_win:Y <= TBHeight   THEN _h_menu_win:Y   = TBHeight.
      END.  /* If TBOrientation is "TOP" */
      IF TBOrientation = "BOTTOM" AND 
         _h_object_win:Y + _h_object_win:HEIGHT-P > 
                                    SESSION:HEIGHT-P - TBHeight THEN
        _h_object_win:Y = _h_object_win:Y - 
                             ((_h_object_win:Y + _h_object_win:HEIGHT-P) -
                                                   (SESSION:HEIGHT-P - TBHeight)).
      IF TBOrientation = "RIGHT" AND
         _h_object_win:X + _h_object_win:WIDTH-P > SESSION:WIDTH-P - TBWidth THEN
        _h_object_win:X = _h_object_win:X - 
                             ((_h_object_win:X + _h_object_win:WIDTH-P) -
                                                    (SESSION:WIDTH-P - TBWidth)).
    END. /* IF NOT AutoHide */
  END. /* IF MS-WIN */

  /* If object palette and menu window overlap move them off of each other.
     This means that we won't let the user specify things so that they will
     overlap */
  IF _h_object_win:X + _h_object_win:WIDTH-PIXELS > _h_menu_win:X AND
     _h_menu_win:X + _h_menu_win:WIDTH-PIXELS > _h_object_win:X AND
     _h_object_win:Y + _h_object_win:HEIGHT-PIXELS > _h_menu_win:Y AND
     _h_menu_win:Y + _h_menu_win:HEIGHT-PIXELS > _h_object_win:Y AND
     _AB_License NE 2 THEN DO:

    /* We have established that they overlap */

    /* Attempt to move the menu_win to the right */
    IF _h_object_win:X + _h_object_win:WIDTH-PIXELS + _h_menu_win:WIDTH-PIXELS + 20 <
       SESSION:WIDTH-PIXELS THEN
      ASSIGN _h_menu_win:X = _h_object_win:X + _h_object_win:WIDTH-P + 20.

    /* Else Attempt to move it to the left */
    ELSE IF _h_menu_win:WIDTH-PIXELS + 20 < _h_object_win:X THEN
      ASSIGN _h_menu_win:X = _h_object_win:X - 20 - _h_menu_win:WIDTH-PIXELS.

    /* Else Attempt to move it above */
    ELSE IF _h_menu_win:HEIGHT-PIXELS + 10 < _h_object_win:Y THEN
      ASSIGN _h_menu_win:Y = _h_object_win:Y - 20 - _h_menu_win:HEIGHT-PIXELS.

    /* We have to do something, so move it below even if it doesn't fit */
    ELSE ASSIGN _h_menu_win:Y = _h_object_win:Y + _h_object_win:HEIGHT-P + 20.
     
  END.  /* If there is an overlap */
  ASSIGN _cur_win_x    = _h_menu_win:X.
  
  /* Create popup menu on the 'New' button */
  RUN adeuib/_cr_npop.p (_h_button_bar[1]).
  
  /***** gfs: commented out so only inline xftrs are supported ******
  IF {&XFTR-FILE} NE ?  OR {&XFTR-FILE} NE "" THEN
    RUN adeuib/_getxftr.p (_h_uib, OUTPUT xPalette). /* Load xftrs */
   */

  /* Assign various handles and items on the screen for later reference:
     We assign the undo-menu-item to its handle value.                */
  ASSIGN _undo-menu-item = m_hEdit:FIRST-CHILD /* jep-icf: remove static MENU-ITEM mi_undo:HANDLE */
         /* Add the UIB's name to the About menu item. */
         mi_About:LABEL = "About {&UIB_NAME}".
  /* jep-icf Note on above _undo-menu-item assignment:
     Because of ICF, the AB's menubar may be different than the static one defined for
     it in uibmdefs.i. So assign _undo-menu-item handle to the first menu item on the
     Edit menu. Undo should be that item regardless of what the menubar is. jep-icf */

  FIND _palette_item WHERE _palette_item._NAME = "POINTER".
    ASSIGN h_wp_pointer = _palette_item._h_up_image.
 
  /* When Full-size, use a window name that has leading spaces so the name appears
     blank on the window, but something is visible on the Windows Task List.
     When we iconize the window, remove the leading spaces. (Bug# 93-09-08-003
     asked for Motif to be 3 spaces more than Windows).
     NOTE: We also set the TITLE of this window when we Show Widget Palette. 
     ****
     In 7.3A the widget palette is resizable.  So we don't want to pad the
     title with spaces if it is big enough to fit.  So we only pad the title
     if the window-width is less than 3 palette items (3 * 36). */

  /* Setup and view the main window */
  CURRENT-WINDOW = _h_menu_win.
  VIEW FRAME action_icons.
  
  IF _DynamicsIsRunning THEN DO:
    CREATE BUTTON hCustomization
      ASSIGN FRAME    = FRAME action_icons:HANDLE
             HEIGHT   = 1.07
             WIDTH    = 16
             COLUMN   = FRAME action_icons:WIDTH - 25
             Y        = _h_button_bar[1]:Y
             LABEL    = "Customization"
             HIDDEN   = TRUE
         TRIGGERS:
           ON CHOOSE PERSISTENT RUN Change_Customization_Parameters.
         END TRIGGERS.
  END.
  
  &IF {&dbgmsg_lvl} > 0 &THEN
    msg_watcher:SENSITIVE IN FRAME action_icons = TRUE.
  &ENDIF

  ASSIGN
       /* Make the current widget info scrollable by changing fill-in formats */
       cur_widg_name:AUTO-RESIZE   = FALSE
       cur_widg_name:FORMAT        = "X(32)":U
       cur_widg_name:SENSITIVE     = YES
       cur_widg_text:AUTO-RESIZE   = FALSE
       cur_widg_text:FORMAT        = "X(256)":U
       cur_widg_text:SENSITIVE     = YES

       /* Setup client data for widget-icons */
       hDrawTool                   = ?.
 
  ASSIGN save_interval                 = SESSION:MULTITASKING-INTERVAL
         SESSION:MULTITASKING-INTERVAL = 1
         _orig_dte_fmt                 = SESSION:DATE-FORMAT.

  VIEW _h_menu_win.
  IF _AB_License NE 2 THEN VIEW _h_object_win.
    
  /* Now go back to menu_window */
  CURRENT-WINDOW = _h_menu_win.

  /* Compute the multipliers needed to convert from tty rows/cols to 
     GUI rows/cols based on the size of the TTY font relative to the PPU
     size (NOTE: We could have used FONT-TABLE:GET-TEXT-HEIGHT-CHAR, but this
     would have been rounded to 2 decimal places.) */
  ASSIGN _tty_row_mult = FONT-TABLE:GET-TEXT-HEIGHT-P (_tty_font) /
                         SESSION:PIXELS-PER-ROW
         _tty_col_mult = FONT-TABLE:GET-TEXT-WIDTH-P ("o":U,_tty_font) /
                         SESSION:PIXELS-PER-COL.

  /* Create the name of the OCX binary cut file. */
  RUN adecomm/_tmpfile.p({&STD_TYP_UIB_CLIP}, {&STD_EXT_UIB_WVX},
                         OUTPUT _control_cut_file).
  
  /* Read in windows sent from the calling routine if any.                   */
  /* If the calling program sends "?,NEW" then  do a FILE/NEW action.        */
  IF p_File_List eq "?,NEW" THEN DO:
    /* Reset the cursor because here we have a possibility for user input    */
    RUN adecomm/_setcurs.p (""). 
    RUN choose_file_new.
  END.
  ELSE IF LENGTH(p_File_List,"CHARACTER":U) > 0 THEN DO:
    DO i = 1 TO NUM-ENTRIES(p_FILE_LIST):
      open_file = ENTRY(i,p_FILE_LIST).
      RUN adeuib/_open-w.p (open_file, "", "OPEN":U).
    END.
  END.
  ELSE DO:
    /* Draw a default window */
    IF _uib_prefs._user_dfltwindow THEN DO:
      FIND FIRST _custom WHERE _custom._type = "Container" NO-ERROR.
      IF AVAILABLE (_custom) THEN DO:
        FILE-INFO:FILE-NAME = TRIM(SUBSTRING(TRIM(_custom._attr),13,-1,"CHARACTER")).
        RUN setstatus ("WAIT":U, "Opening container template...").
        RUN adeuib/_open-w.p (FILE-INFO:PATHNAME, "", "UNTITLED":U).
        RUN display_current.
        APPLY "ENTRY":U TO cur_widg_name IN FRAME action_icons.
        RUN setstatus ("":U, "":U).
      END.
    END.
  END.
  
  ASSIGN SESSION:MULTITASKING-INTERVAL = save_interval.
    
  /* Do custom UIB setup -- this file is generally a no-op, but it can
     be used to initialize custom modifications.  */
  RUN adecomm/_adeevnt.p ("UIB", "Startup", STRING(THIS-PROCEDURE), 
                          STRING(_h_menu_win), OUTPUT ldummy).
  /* [_uibmain.p] remove _uibspcl.p call in 7.4A (wood - 3/3/95) */
  /* RUN adeuib/_uibspcl.p.                                      */

  /* Create menu items for most recently updated file list */
  RUN mru_menu.
  
  /* Assign UIB as current active ADE tool. */
  ASSIGN h_ade_tool = _h_uib.

  /* If we get here, then the UIB was successfully setup */
  setup_ok = yes.
END.  /* initialize_uib */

FUNCTION GetHelpFile RETURNS CHARACTER
  (INPUT p_HelpID AS CHARACTER) :
/*----------------------------------------------------------------------------
PURPOSE:
    Returns the full path and name to a PROGRESS Help File.
SYNTAX
    GetHelpFile( INPUT p_HelpID )
FORWARD
    FUNCTION GetHelpFile RETURNS CHARACTER
        (INPUT p_HelpID AS CHARACTER) FORWARD.
DESCRIPTION:
    
    See adecomm/_adehelp.p for details on how PROGRESS ADE Help File names
    are deteremined.
INPUT PARAMETERS:
    p_HelpID
        A character string identifying the PROGRESS ADE tool whose help
        file full path and name you want returned.
OUTPUT PARAMETERS:
    None.
RETURN VALUE
    Full path and name of a PROGRESS Help File. Returns the name regardless
    of whether the file exists or not. Returns as all lowercase.
SEE ALSO
    adecomm/_adehelp.p
AUTHORS     : John Palazzo
DATE CREATED: 2/11/97
LAST UPDATED: 
----------------------------------------------------------------------------*/

DEFINE VARIABLE HelpFileDir         AS CHARACTER INITIAL "prohelp/":u NO-UNDO.
DEFINE VARIABLE HelpFileName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE HelpFileFullName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE LanguageExtension   AS CHARACTER INITIAL "eng":u NO-UNDO.

DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:

  /* Determine Language Extension */
  IF CURRENT-LANGUAGE <> "?" THEN
      ASSIGN LanguageExtension = 
             LC(SUBSTRING(CURRENT-LANGUAGE,1,3,"CHARACTER":u)).
  
  ASSIGN HelpFileName        = LC((HelpFileDir + p_HelpID + LanguageExtension + ".hlp":u))
         FILE-INFO:FILE-NAME = HelpFileName
         HelpFileFullName    = LC(FILE-INFO:FULL-PATHNAME).

  IF HelpFileFullName = ? THEN
    ASSIGN HelpFileFullName = LC(HelpFileDir + p_HelpID + "eng":u + ".hlp":u).

  RETURN LC(HelpFileFullName).
  
END. /* DO */

END FUNCTION.



