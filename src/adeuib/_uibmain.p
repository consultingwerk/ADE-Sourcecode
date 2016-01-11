/***********************************************************************
* Copyright (C) 2007-2012 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
 
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
    10/24/11 rkamboj  Replaced http://www.progress.com/services/techsupport link 
                      with "http://progresslink.progress.com/supportlink"
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
{adecomm/oeideservice.i}
{adeuib/pre_proc.i}             
{adecomm/adestds.i}        /* Standared ADE Preprocessor Directives */
{adeuib/uibhlp.i}          /* UIB Help File Preprocessor Directives */
{src/adm2/support/admhlp.i} /* ADM Help File Preprocessor Directives */
{adeuib/property.i NEW}    /* Property temp-table Definitions       */
{adeuib/custwidg.i NEW}    /* Custom User Widgets Temp-Table        */
{adeuib/links.i    NEW}    /* ADM links temp-table def              */
{adecomm/adefext.i}
{adeweb/htmwidg.i NEW}     /* Web temp-table definitions            */
{adeuib/vsookver.i}        /* adm versioning                        */
{adeshar/mrudefs.i}        /* MRU Filelist temp table defs          */
{adeuib/peditor.i}         /* Editor support procedures             */
{adeweb/web_file.i} 

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
/* jep-icf: Moved here from uibmdefs.i for icf support.                  */
{adeuib/sharvars.i NEW}
{adeuib/gridvars.i NEW}
{adeuib/windvars.i NEW}
{adeuib/dialvars.i NEW}    /* Dialog box border variables         */

/* Necessary to launch a dynamic container and clear its cache */
DEFINE NEW GLOBAL SHARED VARIABLE OEIDE_ABSecEd   AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE gshRepositoryManager AS HANDLE   NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gshSessionManager    AS HANDLE   NO-UNDO.

/* ===================================================================== */
/*                          OTHER Definitions                            */
/* ===================================================================== */
/* Stores Visible state of OCX Property Editor window when running a procedure or
   for Tools menu calls. */
DEFINE VARIABLE PropEditorVisible AS LOGICAL NO-UNDO.
DEFINE VARIABLE IDEIntegrated     AS LOGICAL NO-UNDO.
DEFINE VARIABLE IDENotInEditor    AS LOGICAL NO-UNDO.
DEFINE VARIABLE IDEClient         AS HANDLE  NO-UNDO.
DEFINE VARIABLE IDEEnterWindow    AS HANDLE  NO-UNDO.
DEFINE VARIABLE IDEOpenUntitled   AS LOGICAL NO-UNDO.
/* Used by getContext and setContext  */
define variable fContext          as character no-undo extent.
define variable WidgetAction      as character no-undo.
define variable SetFocustoUI      as logical   no-undo initial yes.
/*      orig_y      is the original Y coordinate of the down frame box       */
DEFINE VARIABLE ghRepositoryDesignManager AS HANDLE     NO-UNDO.
DEFINE VARIABLE orig_y                    AS INTEGER    NO-UNDO.
define variable cur-widget-parent         as recid no-undo.
define variable cur-widget-type           as character no-undo.
&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF


/* ==================================================================== */
/*                         Function Prototypes                          */
/* ==================================================================== */
function createContextMenu returns handle 
    () forward.

function GetHelpFile returns character
  (input p_HelpID as character) forward.

function setContext returns logical 
    (pcContext as char extent) forward.
    
function getContext returns char extent 
    ( ) forward.
 function getOpenDialogHwnd returns integer 
    ( ) in hOEIDEService. 
function findWidgetName return character 
         (WidgetParentrecId as recid) forward.    
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

DEFINE NEW GLOBAL SHARED VARIABLE OEIDE_Parameters AS CHARACTER NO-UNDO. 
 
SETUP_BLOCK:
DO ON STOP   UNDO SETUP_BLOCK, LEAVE SETUP_BLOCK
   ON ERROR  UNDO SETUP_BLOCK, LEAVE SETUP_BLOCK:
  
  IF OEIDEisRunning THEN
  DO:       
    IF p_File_List = "" THEN
    DO:  
       if num-entries(OEIDE_Parameters) > 1 then 
       do:
           if entry(2,OEIDE_Parameters) = "UNTITLED":U then
           do: 
               assign
                   IDEOpenUntitled = true 
                   p_File_List = entry(1,OEIDE_Parameters).
           end.
       end.    
       if p_File_List = "" then
           assign p_File_List = OEIDE_Parameters.
       
       OEIDE_Parameters = "".
    end. 
       /* Start Section Editor proxy */
    IF NOT VALID-HANDLE(OEIDE_ABSecEd) THEN
         RUN adeuib/_oeidesync.w PERSISTENT SET hSecEd.
    
    if valid-handle(hOEIDEService) then    
       run getIsIDEIntegrated in hOEIDEService (output IDEIntegrated).

  END. /* OEIDEisRunning  */
  
  /* First Thing -- remember the handle of the UIB's main procedure so
     that we can RUN...IN it */
  _h_uib = THIS-PROCEDURE. 
  
  /* undo, cut paste procedures are also used by _sanitiz.p */ 
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
      if OEIDEisRunning then 
      ldummy = ShowMessageInIDE("OK to quit the AppBuilder? ~n~n"  
                              + "WARNING: Unsaved work will be lost, but the open files may be corrupted.~n"
                              + "You should not save the open files on top of their originals.~n" 
                              + "Press ~"OK~" to quit the AppBuilder, or press ~"Cancel~" to continue.",
                                "Question",?,"OK-CANCEL",ldummy).
      else        
          MESSAGE
              "OK to quit the AppBuilder?" SKIP (1)
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



/* **********************  Internal Procedures  *********************** */
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
         OR SEARCH("af/sup2/afcnfrmext.r") <> ?) THEN 
    DO:
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
         ASSIGN 
           h  = _U._HANDLE
           _h_win = _U._HANDLE.
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
      IF OK_Close <> TRUE THEN 
          RETURN.

      /* Close all open XML Mapping Tool windows belonging to the AB. */
      REPEAT ON STOP UNDO, LEAVE:
          RUN adexml/_winexit.p ("_ab.p":U /* Parent ID */, OUTPUT OK_Close ).
          LEAVE.
      END.
      /* Cancel the close event. */
      IF OK_Close <> TRUE THEN 
          RETURN.
    
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
  IF OEIDEisRunning THEN
      /* Start uib proxy  TODO only start when integrated.. */
      RUN initializeIDEClient.
    
  /* Intercept the keyboard endkey events and do nothing.  This
     workaround bug# 93-07-14-057 where the "OK to quit message " screws up if
     we have the DO...ON ENDKEY UNDO STOP_BLOCK, RETRY STOP_BLOCK 
     Regardless, various people feel we should just eat the ENDKEY keystroke. 
     There is also a bug where hitting the END-KEY quickly sends an END-ERROR
     event. (bug 93-09-23-127) We want to catch real errors, but not the case
     of END-ERROR key.  Therefore, on ERROR just retry. */
  DO ON ENDKEY UNDO, RETRY
         ON ERROR  UNDO, RETRY:
      IF RETRY AND NOT CAN-DO ("END-ERROR,END-KEY",LAST-EVENT:FUNCTION) THEN 
          LEAVE.
    
      /** Tell PDS that the appbuilder is started - once only - not on retry  
          Maybe this should have been outside the DO block, but we want to be as close to wait as possible 
          (also visually, so that future code is added before this  ... )*/ 
      if RETRY = false and OEIDEIsRunning then 
          run appbuilderConnection in hOEIDEService.
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
if valid-handle(IDEClient) then run destroyObject in IDEClient.
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

{adeuib/uibdel.i}  /* common delete code moved out */

PROCEDURE apply_leave:
/*------------------------------------------------------------------------------
        Purpose: called from IDE to de-focus the window when the design 
                 looses focus in the IDE. 
                 This ensures that entry fires when clicking back in designer 
                                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/
    IDENotInEditor = true.
END PROCEDURE.

  
PROCEDURE initialize_uib:
  /* Create PROX.PROIDE com object to support ActiveX controls */   
  CREATE "PROX.PROIDE" _h_Controls NO-ERROR.
  IF (ERROR-STATUS:ERROR = TRUE) AND (ERROR-STATUS:NUM-MESSAGES > 0) THEN
  DO ON STOP UNDO, RETRY:
    DEFINE VAR msg_line     AS INTEGER NO-UNDO.
    DEFINE VAR UIB_Continue AS LOGICAL NO-UNDO.
    IF NOT RETRY THEN
    DO msg_line = 1 TO ERROR-STATUS:NUM-MESSAGES:
      if OEIDEIsRunning then
        ShowMessageInIDE(ERROR-STATUS:GET-MESSAGE(msg_line),
                         "Error","{&UIB_SHORT_NAME}","OK",YES). 
      else  
      MESSAGE ERROR-STATUS:GET-MESSAGE(msg_line)
        VIEW-AS ALERT-BOX ERROR TITLE "{&UIB_SHORT_NAME}"  IN WINDOW ACTIVE-WINDOW.
    END.
    if OEIDEIsRunning then 
    UIB_Continue = ShowMessageInIDE("{&UIB_SHORT_NAME}" + 
                     "encountered errors and cannot support ActiveX controls. ~n
                     You may encounter further errors if you try to open or run 
                     procedure files ~n containing ActiveX controls. ~n 
                     Do you want to continue and start the " + "{&UIB_SHORT_NAME}" + " anyway? ",
                     "Warning","{&UIB_SHORT_NAME}","OK",YES). 
    else
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
  if ideIntegrated then
  do:
      run LoadIDEPreferences.
  end.
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
/*  if valid-handle(hOEIDEService) then*/
/*      run adeuib/_oeidepalette.p.    */
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
  
  hide _h_object_win.
  
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
  
  if not IDEIntegrated then
  do:
    VIEW _h_menu_win.
    IF _AB_License NE 2 THEN VIEW _h_object_win.
  end.
  else if valid-handle(_h_object_win) then
    _h_object_win:hidden = true.
      
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
      RUN adeuib/_open-w.p (open_file, "", if IDEOpenUntitled 
                                           then "UNTITLED":U 
                                           else "OPEN":U).
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


/*****************************************************************************
  The majority of the methods used to implemented in two include files
  uibmproa.i uibmproe.i due to size limitations in the section editor. 
  The split was alphabetical... 
  The comments below are from uibmproa.i and is included for sentimental 
  reasons more than historical. They do NOT represent the actual history as 
  we stopped adding comments in headers for fixes around 2001 as it simply was 
  unpractical with the amount if changes that we were doing at this time. 
****************************************************************************/    

/*---- OLD HISTORY START -----------------------------------------------------------
 File: uibmproa.i

Description:
   The internal procedures of the main routine of the UIB 
   (beginning with a-d).

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Date Modified: 1/25/94 (RPR)
               6/14/94 (tullmann) Added profiler checkpoints
               12/16/94 GFS       changed uib_enable/disable to disable/enable_widgets
               02/01/95 GFS       New palette support for RoadRunner.
               03/05/95 JEP       LIB-MGR support.
               01/31/96 PAL       Added support for tab editor.
               01/24/97 GFS       Added designFrame triggers & OCX support
               01/24/97 SLK       Added custom OCX support
               03/09/98 SLK       Added support for V8 on V9 containers, viceversa
               01/19/99 JEP       Code changes for bug fix 98-12-28-020.
               04/07/99 TSM       Added support for various Intl Numeric formats (in
                                  addition to American and European) by using
                                  session set-numeric-format method when changing
                                  format back to user's setting
               04/21/99 TSM       Added choose_file_print procedure for
                                  File/Print option
               05/07/99 TSM       Added support for Most Recently Used FileList
                                  when files are opened
               05/17/99 TSM       Added support for Save All option
               05/20/99 XBO       Added support for New ADM2 class option
               05/27/99 TSM       Changed filters parameter in call to _fndfile.p
                                  because it now needs list-item pairs rather
                                  than list-items to support new image formats
               06/02/99 JEP       Added Code References Window support.
               06/16/99 TSM       Changed call to abprint to always send filename
                                  rather than tempfilename so that Untitled will
                                  print in header for unsaved files
               06/24/99 TSM       Changed MRU File List code to allow remotes files
                                  to be opened from the broker url used when they
                                  were saved and not the current Broker URL
               08/08/00 JEP       Assign _P recid to newly created _TRG records.
               04/26/01 JEP       IZ 993 - Check Syntax support for WebSpeed V2 files.
               08/06/01 JEP       IZ 1508 : AppBuilder Memory Leak w/Section Editors
               08/19/01 JEP       jep-icf Minor change to remove static menubar
                                  reference in disable_widgets procedure for ICF.
               09/18/01 JEP       jep-icf Added procedures choose_open and
                                  choose_object_open to support File->Open Object
                                  so objects outside of repository can be opened.
               09/18/01 JEP       jep-icf disable OpenObject_Button in disable_widgets.
               10/01/01 JEP       IZ 1611 <Local> field support for SmartDataFields.
               10/10/01 JEP-ICF   IZ 2101 Run button enabled when editing dynamic objects.
                                  Renamed h_button_bar to _h_button_bar (new shared).
               11/07/01 JEP-ICF   IZ 2342 MRU List doesn't work with dynamics objects.
                                  Fix : Update to procedure choose_mru_file.
 
 ---- OLD HISTORY END -----------------------------------------------------------*/

/***********************  Internal Procedures  *********************** */

PROCEDURE AddXFTR :
/*------------------------------------------------------------------------------
  Purpose:     Add XFTR from Extentions Palette
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER xftrName AS CHAR NO-UNDO.
  
    DEFINE BUFFER x_P FOR _P.
  
    FIND _U WHERE _U._HANDLE EQ _h_win NO-ERROR.
    IF NOT AVAILABLE (_U) THEN DO:
        if OEIDEIsRunning then
         ShowMessageInIDE("No design window is available.",
                          "Error",?,"OK",YES).
        else              
        MESSAGE "No design window is available." VIEW-AS ALERT-BOX
            ERROR BUTTONS OK.
        RETURN.
    END.
    FIND _XFTR WHERE _XFTR._name = xftrName.
    FIND x_P WHERE x_P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.
    CREATE _TRG.
    ASSIGN
        _TRG._pRECID    = (IF AVAIL(x_P) THEN RECID(x_P) ELSE ?)
        _TRG._xRECID    = RECID(_XFTR)
        _TRG._tEVENT    = ?
        _TRG._tLocation = _XFTR._defloc
        _TRG._tSECTION  = "_XFTR"
        _TRG._tSPECIAL  = ?
        _TRG._tOFFSET   = 0
        _TRG._STATUS    = "NORMAL"
        _TRG._wRECID    = RECID(_U)
        /*_XFTR._wRECID   = RECID(_U)*/.
    IF _xftr._read    NE ? THEN
    DO ON STOP UNDO, LEAVE:
      RUN VALUE(_xftr._read) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.
    IF _xftr._realize NE ? THEN
    DO ON STOP UNDO, LEAVE:
      RUN VALUE(_xftr._realize) (INTEGER(RECID(_TRG)), INPUT-OUTPUT _TRG._tCode).
    END.

END PROCEDURE.


PROCEDURE Add_palette_custom_widget_defs :
/*------------------------------------------------------------------------------
  Purpose:  Add OCX control to Palette    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_acontp.w.
END PROCEDURE. /* Add_palette_custom_widget_defs */


PROCEDURE Add_submenu_custom_widget_def :
/*------------------------------------------------------------------------------
  Purpose:   Add OCX control to Submenu  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_prvcont.w.
END PROCEDURE. /* Add_submenu_custom_widget_def */


PROCEDURE BrowseKBase :
/*------------------------------------------------------------------------------
  Purpose:  Browse the PROGRESS KnowledgeBase via Web Browser   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _WebBrowser NE ? AND _WebBrowser NE "" THEN
      RUN WinExec ( _WebBrowser + " http://progresslink.progress.com/supportlink":U, 1).
    /* RUN WinExec ( _WebBrowser + " http://www.progress.com/services/techsupport":U, 1). */
  ELSE
  do:
    if OEIDEIsRunning then
        ShowMessageInIDE("Please define your web browser in Preferences",
                        "Error",?,"OK",YES).
    else  
    MESSAGE "Please define your web browser in Preferences" VIEW-AS ALERT-BOX ERROR.
  end.
END PROCEDURE. /* BrowseKBase */


PROCEDURE call_coderefs :
/*------------------------------------------------------------------------------
  Purpose: Sends events to the Code References Window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcCommand  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE runCommand  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE runParams   AS CHARACTER NO-UNDO.

  DO ON STOP UNDO, LEAVE:

    IF NOT VALID-HANDLE(_h_CodeRefs) THEN
    DO:
      RUN adeuib/_coderefs.w PERSISTENT SET _h_CodeRefs.
      RUN initializeObject IN _h_CodeRefs.
    END.
    ELSE
    DO:
      RUN restoreWindow IN _h_CodeRefs.
    END.

    IF NUM-ENTRIES(pcCommand , ":":U) > 1 THEN
      ASSIGN runCommand = ENTRY(1, pcCommand, ":":U)
             runParams  = ENTRY(2, pcCommand, ":":U).
    ELSE
      ASSIGN runCommand = pcCommand.

    RUN VALUE(runCommand) IN _h_CodeRefs (INPUT runParams).

  END. /* DO ON STOP */

END PROCEDURE. /*  call_coderefs */


PROCEDURE call_run :
/*------------------------------------------------------------------------------
  Purpose:  run or debug a file.
  Parameters:  pc_Mode is RUN or DEBUG.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pc_Mode AS CHAR NO-UNDO.

  DEFINE VARIABLE cBroker        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE choice         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOldTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOptions       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyBroker   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxyCompile  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProxyName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProxySaved    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRCodeFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSaveFile      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTitleWin      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCancel        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRemote        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lScrap         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE ok2run         AS LOGICAL   NO-UNDO INITIAL YES.
  DEFINE VARIABLE orig_temp_file AS CHARACTER NO-UNDO.

  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    /* Does the user want to be asked about running TTY windows in MS-WIN ?*/
    IF NOT (_cur_win_type OR (OPSYS = "WIN32":U)) AND NOT {&NA-Run-TTY-in-GUI} THEN DO:
      choice = "_RUN":U.
      RUN adeuib/_advisor.w (
          INPUT "PROGRESS cannot directly test character layouts " +
                "from inside Windows." + CHR(10) + CHR(10) +
                "However, you can test this file using the Windows " +
                "graphical user interface instead.",
          INPUT "&Run. Run the file with a graphical interface,_RUN," +
                "&Cancel. Do not run. Return to the UIB.,_CANCEL" ,
          INPUT TRUE,
          INPUT "{&UIB_SHORT_NAME}",
          INPUT {&Advisor_Run_TTY_on_GUI},
          INPUT-OUTPUT choice,
          OUTPUT {&NA-Run-TTY-in-GUI}).
      /* Does the user still want to run? */
      ok2run = (choice EQ "_RUN":U).
    END.

    /* Is the file missing any links, or is it OK to RUN? */
    IF ok2run THEN
      RUN adeuib/_advsrun.p (_h_win, "RUN":U, OUTPUT ok2run).

    IF ok2run THEN DO:
      /* SEW call to store current trigger code for specific window. */
      RUN call_sew ("SE_STORE_WIN").

      APPLY "ENTRY":U TO _h_button_bar[5].  /* Kludge to get consistent behavior.  */
      /* Set the cursor in windows. */
      RUN setstatus ("WAIT":U, IF pc_mode EQ "RUN":U THEN "Running file..."
                               ELSE "Debugging file...").
      RUN-BLK:
      DO ON STOP  UNDO RUN-BLK, LEAVE RUN-BLK
         ON ERROR UNDO RUN-BLK, LEAVE RUN-BLK:

        FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
        FIND _U WHERE _U._HANDLE        EQ _h_win.
        ASSIGN web-tmp-file = "".

        IF _P._TYPE BEGINS "WEB":U OR
          (_P._TYPE eq "SmartDataObject":U AND _P._BROKER-URL ne "") OR
          (_P._TYPE eq "SmartDataObject":U AND _P._SAVE-AS-FILE eq ? AND
           _remote_file) OR
          CAN-FIND(FIRST _TRG WHERE _TRG._pRECID   eq RECID(_P)
                                AND _TRG._tSECTION eq "_PROCEDURE":U
                                AND _TRG._tEVENT   eq "process-web-request":U) THEN
        DO:

          /* Save file before running. */
          IF NOT _P._FILE-SAVED THEN DO:
            /* Using _U._HANDLE:TITLE because it's more reliable than
               _P._SAVE-AS-FILE, especially if the file is untitled. */
            ASSIGN
              hTitleWin = (IF (_U._TYPE = "DIALOG-BOX") THEN
                             _U._HANDLE:PARENT ELSE _U._HANDLE)
              cFileName = TRIM((IF _P._SAVE-AS-FILE EQ ? THEN
                                  SUBSTRING(hTitleWin:TITLE,
                                  INDEX(hTitleWin:TITLE,"-":U) + 1,
                                  -1, "CHARACTER":U)
                                ELSE _P._SAVE-AS-FILE))
              .
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
              SUBSTITUTE("&1 has changes which must be saved before running.",
                cFileName)).
            LEAVE RUN-BLK.
          END.

          cBroker = IF _P._BROKER-URL EQ "" THEN _BrokerURL ELSE _P._BROKER-URL.

          RUN adeweb/_webcom.w (RECID(_P), cBroker, cRelName, "RUN":U,
                                OUTPUT cRelName, INPUT-OUTPUT cTempFile).
          IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
              SUBSTITUTE("&1 could not be run for the following reason:^^&2",
              _p._save-as-file,
              SUBSTRING(RETURN-VALUE,INDEX(RETURN-VALUE,CHR(10)),-1,
                        "CHARACTER":U))).
            LEAVE RUN-BLK.
          END.
          lRemote = TRUE.
        END. /* Web object */
        ELSE DO:
          RUN disable_widgets.
          /* Enable the Stop_Button only when running graphical design windows. */
          IF _cur_win_type = TRUE THEN
            RUN uib-stopbutton (Stop_Button, TRUE /* p_Sensitive */ ).
          IF (NOT _P.static_object) AND _P.container_object THEN
            RUN launch_object (INPUT RECID(_P)).
          ELSE DO:
            /* Each object needs a unique temporary file so the debugger
               can differentiate between the objects and maintain separate
               breakpoint lists. */
            IF _P._comp_temp_file = ? OR _P._comp_temp_file = "":U THEN
              IF _P._save-as-file = ? OR _P._save-as-file = "" THEN
                RUN adecomm/_uniqfil.p("Untitled", {&STD_EXT_UIB}, OUTPUT _P._comp_temp_file).
              ELSE
                RUN adecomm/_uniqfil.p(_P._save-as-file, {&STD_EXT_UIB}, OUTPUT _P._comp_temp_file).
            /* Store the original comp_temp_file name to reset it after
               calling gen4gl because comp_temp_file is used by many other
               generic functions of the AppBulder and should not include
               filenames for those functions. */
            ASSIGN
              orig_temp_file  = _comp_temp_file
              _comp_temp_file = _P._comp_temp_file.

            RUN adeshar/_gen4gl.p (pc_Mode).

            _comp_temp_file = orig_temp_file.

          END.  /* else static object */
        END.

        SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

        /* Disable the Stop_Button only when running graphical design windows. */
        IF _cur_win_type = TRUE AND _P._broker-url = "" AND NOT lRemote THEN
          RUN uib-stopbutton (Stop_Button, FALSE /* p_Sensitive */ ).

        IF NOT lRemote THEN
          RUN enable_widgets.

      END. /* RUN-BLK: DO....*/

      RUN setstatus ("":U, "":U).

      /* If Syntax Error, call SEW to show error. */
      IF _err_recid <> ? THEN DO:
        RUN call_sew ("SE_ERROR":U).
        ASSIGN _err_recid = ?.
      END.
    END. /* IF ok2run...*/
  END. /* IF _h_win...*/
END PROCEDURE. /* call_run */


PROCEDURE call_sew :
/*------------------------------------------------------------------------------
  Purpose: called by UIB to trigger events for Section Editor Window.
           If the section editor is not running, then don't bother processing the
           call UNLESS the user wants to start up the section editor.  There are
           two cases where the Section Editor should be started: (1) if the user
           wants to start it, or (2) if an error has been found.     
  Parameters:  p_secommand  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_secommand AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lOEIDEOpen AS LOGICAL    NO-UNDO.

  IF p_secommand = "SE_OEOPEN" THEN
     ASSIGN p_secommand = "SE_OPEN" lOEIDEOpen = TRUE.

  /* Get the Section Editor for the current window. */
  RUN call_sew_getHandle (INPUT _h_win, INPUT p_secommand, INPUT-OUTPUT hSecEd).
  IF NOT VALID-HANDLE( hSecEd ) THEN RETURN.

  CASE p_secommand :
    WHEN "SE_OPEN":U THEN
    DO:   
      IF _h_win EQ ? THEN RUN report-no-win.
      ELSE DO:
        
        IF _h_cur_widg NE ? THEN
        DO:
            
            FIND _U WHERE _U._HANDLE = _h_cur_widg no-error.
            if not avail _U then
            do:
                 IF _h_cur_widg:TYPE = "WINDOW":U THEN
                 _h_cur_widg = _h_cur_widg:FIRST-CHILD.
                 FIND first _U WHERE _U._HANDLE = _h_cur_widg.  
                  
            end.
            RUN SecEdWindow IN hSecEd ("_CONTROL", RECID(_U), ?, IF lOEIDEOpen THEN "SE_OEOPEN" ELSE "").
             /* Codedit can rename widgets, so redisplay the current widget
                in case its name has changed.  Also it could change numeric
                format.
            */
            SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
            RUN display_current.
            
        END.
        ELSE DO:
            /* If no current widget, go to main block for window */
            FIND _U WHERE _U._HANDLE = _h_win.
            RUN SecEdWindow IN hSecEd
                            ("_CUSTOM":U, RECID(_U), "_MAIN-BLOCK":U, IF lOEIDEOpen THEN "SE_OEOPEN" ELSE "").
          
        END.
      END. /* IF _h_win ne ? ... */

    END. /* WHEN "SE_OPEN" */

    WHEN "SE_ERROR":U THEN
    DO:
        /* Show the error (it is stored in _err_recid) */
        RUN SecEdWindow IN hSecEd (?, ?, ?, p_secommand).
    END.

    WHEN "SE_CHECK_CURRENT_WINDOW":U THEN
    DO:
      /* If user was in the Section Editor, ensure the current design
         window is the same as the one being edited in the Section Editor.
         Fixes 19981020-031. See also 20000604-003. - jep */
      RUN check_UIB_current_window IN hSecEd.
    END. /* WHEN "SE_CHECK_CURRENT_WINDOW" */

    OTHERWISE /* All other Section Editor commands */
      RUN SecEdWindow IN hSecEd (se_section, se_recid, se_event, p_secommand).
   
  END CASE.
  RETURN.

END PROCEDURE. /* call_sew */


PROCEDURE call_sew_getHandle :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle to the design window's Section Editor procedure.
          Starts a Section Editor window as needed.    

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAM ph_win      AS HANDLE    NO-UNDO.
  DEFINE INPUT        PARAM psecommand  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAM phSecEd     AS HANDLE    NO-UNDO.

  DEFINE VARIABLE hWindow    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lAddToMenu AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cHandle    AS CHARACTER NO-UNDO.

  DEFINE BUFFER x_P FOR _P.

  /* Get the procedure record to retrieve its section editor handle. */
  FIND x_P WHERE x_P._WINDOW-HANDLE = ph_win NO-ERROR.
  ASSIGN phSecEd = x_P._hSecEd NO-ERROR.

  /* If the procedure's section editor handle isn't valid (probably
     has not been assigned a value yet) and the current AB setting
     for single section editor is Yes, then set the procedure's section
     editor handle to the current section editor handle. We don't do
     this for multiple section editors because we want to create a
     new section editor anyways. -jep */
  IF NOT VALID-HANDLE(phSecEd) AND NOT _multiple_section_ed THEN
  DO:
    ASSIGN phSecEd = hSecEd. /* Current global setting. */
    ASSIGN x_P._hSecEd = hSecEd NO-ERROR.
  END.

  /* If we don't yet have a valid section editor handle, we need one. */
  IF NOT VALID-HANDLE(phSecEd) THEN
  DO:
    /* If OEIDEIsRunning the _oeidesync.w should be used instead of the 
       standard section editor.
     */
    IF OEIDEIsRunning THEN
        RUN adeuib/_oeidesync.w PERSISTENT SET phSecEd.
    ELSE
        RUN adeuib/_semain.w PERSISTENT SET phSecEd.
    ASSIGN x_P._hSecEd = phSecEd NO-ERROR.
    ASSIGN lAddToMenu  = TRUE.
  END.

  /* Try adding a Section Editor entry to AB's Window menu only for
     SE_OPEN and SE_ERROR, since they are the only ones which can create
     section editor's. -jep */
  IF NOT OEIDEIsRunning AND CAN-DO("SE_OPEN,SE_ERROR":U, psecommand ) THEN
  DO:
    RUN GetAttribute IN phSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
    hWindow = WIDGET-HANDLE(cHandle).
    IF VALID-HANDLE(hWindow) AND hWindow:VISIBLE = FALSE THEN
      ASSIGN lAddToMenu = TRUE.

    IF VALID-HANDLE(_h_WinMenuMgr) AND lAddToMenu THEN /* dma */
      RUN WinMenuAddItem IN _h_WinMenuMgr ( _h_WindowMenu, hWindow:TITLE, _h_uib ).
  END.

  RETURN.

END PROCEDURE. /* call_sew_getHandle */


PROCEDURE call_sew_setHandle :
/*------------------------------------------------------------------------------
  Purpose: Set the default hSecEd handle to the handle of the SE parented to
           the design window that has focus.     
 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phSecEd AS HANDLE NO-UNDO.

  ASSIGN hSecEd = phSecEd.
  PUBLISH "AB_call_sew_setHandle":u FROM THIS-PROCEDURE.

  RETURN.
END PROCEDURE. /* call_sew_getHandle */


PROCEDURE Center-l-to-r :
/*------------------------------------------------------------------------------
  Purpose: Align fields down the center    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_align.p ("c-l-to-r", ?).
END PROCEDURE.  /* Center-l-to-r */


PROCEDURE Center-t-to-b :
/*------------------------------------------------------------------------------
  Purpose:   Align across the center  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN adeuib/_align.p (?, "c-t-to-b").
END PROCEDURE.  /* Center-t-to-b */


PROCEDURE changewidg :
/*------------------------------------------------------------------------------
  Purpose:     Change the currently selected widget, frame and window.  
               This procedure is like curwidg, except it takes an input 
               parameter: the new widget.     

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_self AS WIDGET NO-UNDO.
  DEFINE INPUT PARAMETER deselect_others AS LOGICAL NO-UNDO.

  /* Has anything changed? */
  IF h_self NE _h_cur_widg THEN DO:
    /* If requested (esp. if the curent widget is a SmartObject or a Menu item)
       then deselect all the other wigets. */
    IF deselect_others THEN DO:
      FOR EACH _U WHERE _U._SELECTEDib:
        ASSIGN _U._SELECTEDib      = FALSE
               _U._HANDLE:SELECTED = FALSE.
      END.
    END.
    IF h_self NE ? THEN RUN curframe (h_self).
    _h_cur_widg = h_self.
  END.
  /* Occasionally, this routine is called by a routine that has changed
     _h_cur_widg itself.  Really, the caller wants to change the
     displayed widget.  So handle this to. */
  IF _h_cur_widg NE h_display_widg THEN RUN display_current.
END PROCEDURE. /* changewidg */


PROCEDURE Change_Customization_Parameters :
/*------------------------------------------------------------------------------
  Purpose: Change the session parameters for controling Dynamics customizations    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCustomizationTypes      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomPriorities        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCustomizationReferences AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCodelist                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPriority                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReferenceCode           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResCode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cResultCodes             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTypeAPI                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTypeList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCustomizationManager    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPriority                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTypeLoop                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lok                      AS LOGICAL    NO-UNDO.

  hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U).

  IF gcResultCodes = ? THEN DO:  /* Haven't run this before, so get system information */
    cCustomPriorities = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                         INPUT "CustomizationTypePriority":U).
    /* If no customizations have been specified, then cCodeList (List of ResultCodes
       in the right selection list of the rycusmodw.w window) is blank  */
    IF cCustomPriorities = ? OR cCustomPriorities = "":U THEN cCodeList = "":U.
    ELSE DO:
      RUN rycusfapip IN hCustomizationManager ( INPUT cCustomPriorities, OUTPUT cTypeAPI ) NO-ERROR.

      /* Build the list of references */
      IF VALID-HANDLE(hCustomizationManager) THEN DO:
        DO iTypeLoop = 1 TO NUM-ENTRIES(cTypeApi):
          ASSIGN cReferenceCode = "":U
                 cReferenceCode = DYNAMIC-FUNCTION(ENTRY(iTypeLoop, cTypeApi) IN hCustomizationManager)
                 NO-ERROR.

          /* Ensure that there's at least something */
          IF cReferenceCode EQ "":U OR cReferenceCode EQ ? THEN
              ASSIGN cReferenceCode = "DEFAULT-RESULT-CODE":U.

          ASSIGN cCustomizationReferences = cCustomizationReferences +
                           (IF NUM-ENTRIES(cCustomizationReferences) EQ 0 THEN "":U ELSE ",":U)
                           + cReferenceCode.
        END.    /* loop through gcCustomisationTypesPrioritised */
      END.  /* If valid customization manager handle */

      /* Determine the result codes from the references */
      RUN rycusrr2rp IN hCustomizationManager
                              ( INPUT        cCustomPriorities,
                                INPUT        cTypeApi,
                                INPUT-OUTPUT cCustomizationReferences,
                                OUTPUT       cResultCodes              ) NO-ERROR.

      cCodeList = "":U.
      DO iTypeLoop = 1 TO NUM-ENTRIES(cCustomPriorities):
        cResCode = ENTRY(iTypeLoop, cResultCodes).
        cCodeList = cCodeList + "|" + ENTRY(iTypeLoop, cCustomPriorities) + "|":U +
                    ENTRY(iTypeLoop, cCustomPriorities) + CHR(4) +
                    IF cResCode EQ "DEFAULT-RESULT-CODE":U THEN "Default":U ELSE cResCode.
      END.
      cCodeList = LEFT-TRIM(cCodeList, "|":U).
    END. /* Else some customizations have been specified */
  END.  /* IF haven't run before */
  ELSE cCodeList = gcResultCodes.

  /* Make a complete list of customization types for the left selection list */
  RUN FetchCustomizationTypes IN hCustomizationManager
      (INPUT  YES,
       OUTPUT cTypeList).

  IF cTypeList NE "" THEN DO:
    DO iTypeLoop = 1 TO NUM-ENTRIES(cTypeList):
      cCustomizationTypes = cCustomizationTypes + "|":U +
                             ENTRY(iTypeLoop,cTypeList) + "|":U +
                             ENTRY(iTypeLoop,cTypeList) + CHR(4).
    END.
    cCustomizationTypes = LEFT-TRIM(cCustomizationTypes,"|":U).
  END.
  ELSE cCustomizationTypes = "":U.
  /* Call the customization Priority Editor */
  RUN ry/prc/rycusmodw.w (
    INPUT "Customization Priority Editor|Available|Selected", /* Window Title */
    INPUT "|":U, /* Delimiter  */
    INPUT YES,   /* Use images */
    INPUT YES,   /* Allow Sort */
    INPUT YES,
    INPUT YES,   /* List Item Pairs (Not List Items) */
    INPUT cCustomizationTypes,
    INPUT-OUTPUT cCodeList,
    OUTPUT lok).
  IF lok THEN DO: /* The user did not cancel, save the changes */
    gcResultCodes = "":U.  /* Setup for next time */

    /* If no customisation has been set up, return the DEFAULT code. */
    IF cCodeList EQ "":U OR cCodeList EQ ? THEN
        ASSIGN cResultCodes = "{&DEFAULT-RESULT-CODE}":U
               hCustomization:HIDDEN = YES.
    ELSE DO:
      cResultCodes = "":U.
      DO iTypeLoop = 2 TO NUM-ENTRIES(cCodeList,"|":U) BY 2:
        cResultCodes = cResultCodes + ",":U +
                     ENTRY(2, ENTRY(iTypeLoop, cCodeList, "|":U), CHR(4)).
        gcResultCodes = gcResultCodes + "|":U +
                     ENTRY(1, ENTRY(iTypeLoop, cCodeList, "|":U), CHR(4)) +
                     "|":U + ENTRY(iTypeLoop, cCodeList, "|":U).
      END.
      ASSIGN cResultCodes  = LEFT-TRIM(cResultCodes,",":U)
             gcResultCodes = LEFT-TRIM(gcResultCodes,"|":U)
             hCustomization:HIDDEN    = NO
             hCustomization:SENSITIVE = YES.
    END.

    RUN setSessionResultCodes IN hCustomizationManager
            (INPUT cResultCodes,
             INPUT YES). /* If the cache was not accurate, we want to reset
                                            the prop on the Appserver */
  END.

END PROCEDURE.  /* Change_Customization_Parameters */

PROCEDURE change_grid_display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    _cur_grid_visible = SELF:CHECKED.
    run refresh_grid_display.
END. /* change_grid_display */

PROCEDURE refresh_grid_display :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define buffer b_U for _u.
  FOR EACH b_U WHERE CAN-DO("DIALOG-BOX,FRAME", b_U._TYPE) AND b_U._HANDLE <> ?:
    ASSIGN  b_U._HANDLE:GRID-VISIBLE = _cur_grid_visible.
  END.
END.  

PROCEDURE change_grid_snap :
    _cur_grid_snap = SELF:CHECKED.
    run refresh_grid_snap.
END. 

PROCEDURE refresh_grid_snap :
/*------------------------------------------------------------------------------
  Purpose: Change grid snapping, but only on Graphical frames     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define buffer b_U for _u.
   define buffer b_L for _L.
  FOR EACH b_U WHERE CAN-DO("DIALOG-BOX,FRAME", b_U._TYPE) AND b_U._HANDLE <> ?,
       EACH b_L WHERE RECID(b_L) = b_U._lo-recid:
    IF b_L._WIN-TYPE THEN b_U._HANDLE:GRID-SNAP = _cur_grid_snap.
  END.
END PROCEDURE. /* change_grid_snap */


PROCEDURE change_grid_units :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR changed    AS LOGICAL                             NO-UNDO.

   /* This uses the current values for grid setup */
   RUN adeuib/_edtgrid.p ("Grid Units", OUTPUT changed).
   IF changed THEN  
       run refresh_grid_units.
    
END.  /* change_grid_units */

PROCEDURE refresh_grid_units :
    DEFINE VAR saved_gd   AS LOGICAL                             NO-UNDO.
    DEFINE VAR hf         AS WIDGET                              NO-UNDO.
    FOR EACH _U WHERE CAN-DO("DIALOG-BOX,FRAME", _U._TYPE) AND _U._HANDLE <> ?,
       EACH _L WHERE RECID(_L) = _U._lo-recid:
      /* Change the grid - first turn off the grid display so that
         everything does not flash. */
      ASSIGN            hf              = _U._HANDLE
                        saved_gd        = hf:GRID-VISIBLE
                        hf:GRID-VISIBLE = FALSE.
     /* Only change grid units on Graphical windows (not TTY) */
      IF _L._WIN-TYPE THEN DO:
        IF _cur_layout_unit
        THEN ASSIGN hf:GRID-UNIT-WIDTH-CHAR     = _cur_grid_wdth
                    hf:GRID-UNIT-HEIGHT-CHAR    = _cur_grid_hgt.
        ELSE ASSIGN hf:GRID-UNIT-WIDTH-PIXELS   = _cur_grid_wdth
                    hf:GRID-UNIT-HEIGHT-PIXELS  = _cur_grid_hgt.
      END.
      ASSIGN    hf:GRID-FACTOR-V = _cur_grid_factor_v
                hf:GRID-FACTOR-H = _cur_grid_factor_h
                hf:GRID-VISIBLE  = saved_gd.
     END.
end.

PROCEDURE change_label :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h_ttl_widg  AS WIDGET                              NO-UNDO.
  DEFINE VAR oldTitle    AS CHAR                                NO-UNDO.
  DEFINE VAR text-sa     AS CHAR                                NO-UNDO.
  DEFINE VAR wc          AS INTEGER                             NO-UNDO.

  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  error_on_leave = NO.
  DO WITH FRAME action_icons:
    /* Has it changed? */
    IF cur_widg_text <> SELF:SCREEN-VALUE THEN DO:
      FIND _U WHERE _U._HANDLE = h_display_widg NO-ERROR.
      IF AVAILABLE _U THEN DO:
        IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) THEN
          FIND _L WHERE RECID(_L) = _U._lo-recid.

        /* set the file-saved state to false */
        RUN adeuib/_winsave.p(_h_win, FALSE).

        ASSIGN cur_widg_text
               display_text = cur_widg_text.
        /* Text is a special case because you CAN-SET its label but we never
           use one in the UIB */
        IF _U._TYPE = "TEXT" THEN DO:
            FIND _F WHERE RECID(_F) = _U._x-recid.
            ASSIGN  _F._INITIAL-DATA         = cur_widg_text
                    wc                       = MAX(1,LENGTH(_F._INITIAL-DATA, "raw"))
                    _F._FORMAT               = "X(" + STRING(wc) + ")"
                    _U._HANDLE:FORMAT        = _F._FORMAT
                    _U._HANDLE:SCREEN-VALUE  = _F._INITIAL-DATA
                    /* Fill "label" for use in widg.browser */
                    _U._LABEL                = "~"" + _F._INITIAL-DATA + "~"" .
        END.
        ELSE IF _U._TYPE EQ "BROWSE":U THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
          /* Change the title - note we need to simulate browse contents */
          FIND _C WHERE RECID(_C) EQ _U._x-recid.
          IF _C._TITLE THEN DO:
            IF VALID-HANDLE(_U._PROC-HANDLE) THEN RUN destroyObject IN _U._PROC-HANDLE.
            ELSE IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET _U._HANDLE.
            RUN adeuib/_undbrow.p (RECID(_U)).
          END.
        END.
        ELSE IF _U._TYPE EQ "FRAME":U THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
           FIND _C WHERE RECID(_C) EQ _U._x-recid.
           IF _C._TITLE AND NOT _L._NO-BOX THEN DO:
             RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, NO, OUTPUT text-sa).
             IF text-sa NE _U._HANDLE:TITLE THEN _U._HANDLE:TITLE = text-sa.
           END.
        END.
        ELSE IF CAN-DO ("MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
          _U._LABEL = IF cur_widg_text EQ ? THEN "" ELSE cur_widg_text.
          RUN adeuib/_strfmt.p (_U._LABEL, _U._LABEL-ATTR, NO, OUTPUT text-sa).
          _U._HANDLE:LABEL = text-sa.
        END.
        ELSE IF CAN-SET(_U._HANDLE, "LABEL") THEN DO:
          IF cur_widg_text EQ "?" OR cur_widg_text EQ ?
          THEN DO:
            /* Label is "unknown", so use "D"efault -- note: for DB fields, we
               need to refetch the Default label. We only bother with this change
               if the old value was not "D"efault. */
            IF _U._LABEL-SOURCE NE "D" THEN DO:
              IF _U._DBNAME NE ? THEN RUN adeuib/_fldlbl.p
                            (_U._DBNAME, _U._TABLE, _U._NAME, _C._SIDE-LABELS,
                             OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
              _U._LABEL-SOURCE = "D".
            END.
          END.
          ELSE ASSIGN _U._LABEL = cur_widg_text
                      _U._LABEL-SOURCE = "E".
         IF NOT CAN-DO("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U, _U._TYPE)
         THEN RUN adeuib/_sim_lbl.p (_U._HANDLE). /* i.e. buttons and toggles */
         ELSE DO:
            FIND f_U WHERE RECID(f_U) = _U._PARENT-RECID.
            ASSIGN _h_frame = f_U._HANDLE.
            FIND _C WHERE RECID(_C) EQ f_U._x-recid.
            FIND f_L WHERE RECID(f_L) EQ f_U._lo-recid.
            FIND _F WHERE RECID(_F) EQ _U._x-recid.
            FIND _L WHERE RECID(_L) EQ _U._lo-recid.
            _L._NO-LABELS = (TRIM(_U._LABEL) EQ ""). /* Set no-label */
            IF NOT _C._SIDE-LABELS AND NOT f_L._NO-LABELS AND _L._NO-LABELS
            THEN RUN adeuib/_chkpos.p (_U._HANDLE).
            RUN adeuib/_showlbl.p (_U._HANDLE).
          END.
        END.
        ELSE IF CAN-DO("DIALOG-BOX,WINDOW",_U._TYPE) THEN DO:
          /* We have a window or dialog box. The only other widget with a
             title is MENU and it is not setable.  Display the title (note we
             need to find the window for a dialog box. Also note that frames
             have no title-bar, i.e. TITLE = ?.  If that is the case then
             don't set title. */
           ASSIGN _U._LABEL  = cur_widg_text
                  h_ttl_widg = IF _U._TYPE EQ "DIALOG-BOX"
                               THEN _U._HANDLE:PARENT ELSE _U._HANDLE.
           FIND _P WHERE _P._u-recid EQ RECID(_U).
           ASSIGN oldTitle = h_ttl_widg:TITLE.
           RUN adeuib/_wintitl.p (h_ttl_widg, _U._LABEL, _U._LABEL-ATTR,
                                  _P._SAVE-AS-FILE).
           /* Change the active window title on the Window menu. */
           IF (h_ttl_widg:TITLE <> oldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
             RUN WinMenuChangeName IN _h_WinMenuMgr
               (_h_WindowMenu, oldTitle, h_ttl_widg:TITLE).
        END.

        /* SEW call to update widget label in SEW. */
        RUN call_sew ("SE_PROPS").

      END.  /* IF AVAILABLE _U */
    END.    /* IF .. <> SCREEN-VALUE */
  END.      /* DO WITH FRAME */
  /* On return, don't do default action, just stay in the field */
  IF LAST-EVENT:FUNCTION EQ "RETURN":U THEN RETURN ERROR.
END. /*  change_label */


PROCEDURE change_name :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE valid_name AS LOGICAL NO-UNDO.
  DEFINE BUFFER f_U FOR _U.
  DEFINE BUFFER f_L FOR _L.

  error_on_leave = NO.
  /* Has it been modified ? */
  IF cur_widg_name <> SELF:SCREEN-VALUE THEN DO:
    FIND _U WHERE _U._HANDLE = h_display_widg NO-ERROR.
    IF AVAILABLE _U AND (_U._TYPE NE "TEXT") THEN DO:
      IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) THEN
        FIND _L WHERE RECID(_L) EQ _U._lo-recid.

      RUN adeuib/_ok_name.p (SELF:SCREEN-VALUE, RECID(_U), OUTPUT valid_name).
      IF NOT valid_name THEN DO:
        ASSIGN error_on_leave    = YES
               SELF:SCREEN-VALUE = cur_widg_name.
        RETURN ERROR.
      END.
      ELSE DO WITH FRAME action_icons:
        ASSIGN cur_widg_name
               display_name     = cur_widg_name
               _U._NAME         = cur_widg_name
               error_on_leave   = NO.

        /* If this is a OCX control then CORE needs to know the change */

        IF _U._TYPE = "{&WT-CONTROL}" THEN _U._HANDLE:NAME = _U._NAME.

        /* set the file-saved state to false */
        RUN adeuib/_winsave.p(_h_win, FALSE).

        /* For some fields, if there are defaults then update the label */
        IF (_U._LABEL-SOURCE = "D") AND (_U._TABLE = ?) AND
           CAN-DO ("BUTTON,FILL-IN,TOGGLE-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER", _U._TYPE) THEN DO:
          IF CAN-DO("COMBO-BOX,FILL-IN,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U, _U._TYPE) THEN DO:
            FIND f_U WHERE f_U._HANDLE EQ _h_frame.
            FIND f_L WHERE RECID(f_L) EQ f_U._lo-recid.
            FIND _C WHERE RECID(_C) EQ f_U._x-recid.
            IF NOT _C._SIDE-LABELS AND NOT f_L._NO-LABELS AND _L._NO-LABELS
            THEN RUN adeuib/_chkpos.p (_U._HANDLE).
            RUN adeuib/_showlbl.p (_U._HANDLE).
          END. /* IF fill-in */
          ELSE RUN adeuib/_sim_lbl.p (_U._HANDLE).
        END.

        /* SEW call to update widget name in SEW. */
        RUN call_sew ("SE_PROPS":U).

      END.
    END.
  END.
  /* On return, don't do default action, just stay in the field */
  IF LAST-EVENT:FUNCTION EQ "RETURN":U THEN RETURN ERROR.
END. /* change_name */


PROCEDURE choose-pointer :
/*------------------------------------------------------------------------------
  Purpose:  change the _next_draw tool back to the pointer tool   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE toolframe AS WIDGET-HANDLE.

  /* Unhilite the current tool  - if it isn't the pointer  */
  IF hDrawTool NE ? AND hDrawTool:PRIVATE-DATA NE "POINTER":U
  THEN DO:
    ASSIGN hDrawTool:HIDDEN  = NO
           toolframe         = hDrawTool:FRAME
           toolframe:bgcolor = ?.
  END.
  /* Hide the old lock -- pointer mode is NEVER locked */
  IF h_lock NE ? AND h_lock:HIDDEN NE YES
  THEN h_lock:HIDDEN = YES.
  /* Set the current selection to the pointer.                */
  ASSIGN hDrawTool         = h_wp_Pointer
         hDrawTool:HIDDEN  = YES
         goBack2pntr       = TRUE
         ldummy            = _h_object_win:LOAD-MOUSE-POINTER("":U)
         toolframe         = hDrawTool:FRAME
         toolframe:bgcolor = 7.

  /* Make everything selectable and movable again.
     For speed, only do this if the old mode was not pointer.  */
  IF _next_draw <> ? THEN DO:
    FOR EACH _U WHERE _U._HANDLE <> ? AND
        NOT CAN-DO("WINDOW,DIALOG-BOX,MENU,SUB-MENU,MENU-ITEM", _U._TYPE):
      ASSIGN _U._HANDLE:MOVABLE  = TRUE
             _U._HANDLE:SELECTABLE = (_U._SUBTYPE <> "LABEL").
    END.
    IF _h_win NE ? THEN ldummy = _h_win:LOAD-MOUSE-POINTER("":U).
  END.
  ASSIGN _next_draw = ? /* Indicates POINTER mode (nothing to draw next) */
         _object_draw = ?
         _custom_draw = ?
         _palette_choice = ?
         _palette_custom_choice = ?
         widget_click_cnt = 0
         .
  RUN adeuib/_setpntr.p (_next_draw, INPUT-OUTPUT _object_draw).
  /* Show the user we are using the Pointer Tool */
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Tool},  h_wp_Pointer:HELP).
  RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, "":U).
END PROCEDURE. /* choose-pointer */


PROCEDURE choose_assign_widgetID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lContinue AS LOGICAL    NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    if OEIDEIsRunning then
      lContinue = ShowMessageInIDE("Widget IDs will be written to all frames and widgets of this container.
                                    If widget IDs have already been assigned to frames and widgets they will be overwritten. 
                                    Do you wish to continue?",
                                    "Question",?,"YES-NO",YES).
    else  
    MESSAGE "Widget IDs will be written to all frames and widgets of this container. " +
            "If widget IDs have already been assigned to frames and widgets they will be overwritten. " +
            "Do you wish to continue?" 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lContinue.
    IF lContinue THEN
    do:
      RUN adeuib/_assignwidgid.p (INPUT _h_win).
      RUN adeuib/_winsave.p(_h_win, FALSE).
    END.
  END.
END PROCEDURE.  /* choose_assign_widgetID */


PROCEDURE choose_attributes :
/*------------------------------------------------------------------------------
  Purpose: called by UIB to trigger events in the Attributes Editor
           floating window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  /* If it doesn't exist, them create it.  Otherwise, move it to the top.
     NOTE that we need to make sure the handle points to the same item
     (because PROGRESS reuses procedure handles). */
  IF VALID-HANDLE(hAttrEd) AND hAttrED:FILE-NAME EQ "{&AttrEd}"
  THEN RUN move-to-top IN hAttrEd NO-ERROR.
  ELSE RUN {&AttrEd} PERSISTENT SET hAttrEd .

  /* Show the current values. */
  RUN show-attributes IN hAttrEd NO-ERROR.

END PROCEDURE. /* choose_attributes */


PROCEDURE choose_check_syntax :
/*------------------------------------------------------------------------------
  Purpose: Check the syntax of the current window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBroker     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cScrap      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTitleWin   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iErrOffset  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lScrap      AS LOGICAL   NO-UNDO.

  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Checking syntax...").

    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    FIND _U WHERE _U._HANDLE        EQ _h_win.
    ASSIGN
      web-tmp-file = ""
      _save_mode   = "".

    /* Check syntax on remote WebSpeed agent if Broker URL is known for this
       file or the file is new, untitled and Development Mode is remote. */
    IF _P._BROKER-URL NE "" OR (_P._SAVE-AS-FILE EQ ? AND _remote_file)
      THEN DO:
      RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT cTempFile).

      /* DO NOT change or reuse web-tmp-file until AFTER adeweb/_webcom.w
         runs in DELETE mode further down in this procedure. If the object
         to be checked is a SmartDataObject, then this variable is used to
         hold the field definition include filename. */
      ASSIGN
        web-tmp-file = cTempFile
        _save_mode   = (IF _P._SAVE-AS-FILE EQ ? THEN "T":U ELSE "F":U) +
                        ",":U +
                       (IF _P._SAVE-AS-FILE EQ ? AND _remote_file
                        THEN "T":U ELSE "F":U).

      IF _P._file-version BEGINS "WDT_v2":U THEN
        RUN adeweb/_genweb.p (RECID(_P), "SAVE":U, ?, _P._SAVE-AS-FILE,
                              OUTPUT cScrap).
      ELSE
        RUN adeshar/_gen4gl.p ("SAVE:CHECK":U).

      ASSIGN
        cBroker   = (IF _P._BROKER-URL NE ""
                     THEN _P._BROKER-URL ELSE _BrokerURL)
        hTitleWin = (IF (_U._TYPE = "DIALOG-BOX") THEN
                      _U._HANDLE:PARENT ELSE _U._HANDLE)
        cFileName = TRIM((IF _P._SAVE-AS-FILE EQ ? THEN
                            SUBSTRING(hTitleWin:TITLE,
                              INDEX(hTitleWin:TITLE,"-":U) + 1,
                              -1, "CHARACTER":U)
                     ELSE _P._SAVE-AS-FILE))
        cScrap    = "".

      /* Copy the file to a WebSpeed agent as a temp file and check syntax
         remotely. */
      RUN adeweb/_webcom.w (RECID(_P), cBroker, cFileName,
                            "checkSyntax":U, OUTPUT cRelName,
                            INPUT-OUTPUT cTempFile).

      /* If there's an error, we want to load the correct section in the
         Section Editor.  We do this by setting _err_recid based on the
         COMPILER:FILE-OFFSET. */
      IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
        iErrOffset = INTEGER(ENTRY(2,ENTRY(1,RETURN-VALUE,CHR(10))," ":U)).
        
        if OEIDE_CanShowMessage() then
            ShowMessageInIDE(SUBSTRING(RETURN-VALUE,INDEX(RETURN-VALUE,CHR(10)),-1),"error",?,"OK",yes).
    
        else 
            RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
                       SUBSTRING(RETURN-VALUE,INDEX(RETURN-VALUE,CHR(10)),-1,"CHARACTER":U)).
         
        FIND LAST _TRG WHERE _TRG._pRECID  EQ RECID(_P)
                         AND _TRG._tOFFSET LT iErrOffset
                         USE-INDEX _tOFFSET NO-ERROR.
        _err_recid = IF AVAILABLE _TRG THEN RECID(_TRG) ELSE ?.
      END. /* RETURN-VALUE BEGINS "ERROR:" */
      ELSE
      do: 
        if OEIDE_CanShowMessage() then
         ShowMessageInIDE("Syntax is correct.","Information",?,"OK",YES).
        else  
        MESSAGE "Syntax is correct."
          VIEW-AS ALERT-BOX INFORMATION.
      end.
      /* Cleanup any left over remote .ab.i files. */
      RUN adeweb/_webcom.w (?, cBroker, web-tmp-file, "DELETE":U,
                          OUTPUT cScrap, INPUT-OUTPUT cScrap).
      web-tmp-file = "".
    END.
    ELSE
    DO: /* IZ 993 - Check Syntax support for WebSpeed V2 files. */
      IF _P._file-version BEGINS "WDT_v2":U THEN
        RUN adeweb/_genweb.p (RECID(_P), "CHECK-SYNTAX":U, ?, _P._SAVE-AS-FILE, OUTPUT cScrap).
      ELSE
        RUN adeshar/_gen4gl.p ("CHECK-SYNTAX":U).
    END.


    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).

    /* If Syntax Error, call SEW to show error. */
    IF _err_recid <> ? THEN DO:
      RUN call_sew ("SE_ERROR":U).
      ASSIGN _err_recid = ?.
    END.
  END.
END PROCEDURE. /* choose_check_syntax */


PROCEDURE choose_close :
/*------------------------------------------------------------------------------
  Purpose: Close the current window    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  IF _h_win = ? THEN  
    RUN report-no-win.
  ELSE
    /* Close the window */
    RUN wind-close (_h_win).
END PROCEDURE. /* choose_close */


PROCEDURE choose_close_all :
/*------------------------------------------------------------------------------
  Purpose:  Close one or more windows    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  
  IF _h_win = ? THEN 
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code regardless of what the
       current window is in UIB.  */
    RUN call_sew ("SE_STORE":U).

    RUN adeuib/_closeup.p.
    RUN del_cur_widg_check.   /* Have we deleted the current widget */

    /* Update the Window menu active window items. */
    RUN WinMenuRebuild IN _h_uib.
  END.
END PROCEDURE. /* choose_close_all */


PROCEDURE choose_codedit :
/*------------------------------------------------------------------------------
  Purpose: called by mi_code_edit, button-bar and Accelerators.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  IF NOT mi_code_edit:SENSITIVE THEN RETURN NO-APPLY.
  RUN adecomm/_setcurs.p ("WAIT":U) NO-ERROR.
  RUN call_sew ("SE_OPEN":U).
  RUN adecomm/_setcurs.p ("":U) NO-ERROR.

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_codedit */


PROCEDURE choose_code_preview :
/*------------------------------------------------------------------------------
  Purpose:  called by menu and button-bar   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScrap AS CHARACTER NO-UNDO.
  
  /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) 
    This would need to be changed to embedded dialog to support this from ide, not important the code can be seen with view source  */
  if IDEIntegrated then 
      return.
  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    IF NOT MENU-ITEM mi_preview:SENSITIVE IN MENU m_compile THEN RETURN NO-APPLY.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Generating code to preview...").

    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "PREVIEW":U, ?, ?, OUTPUT cScrap).
    ELSE
      RUN adeshar/_gen4gl.p ("PREVIEW":U).

    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).
    RUN adeuib/_prvw4gl.p (_comp_temp_file, ?, ?, ?).
    /* The temp file is no longer needed */
    OS-DELETE VALUE(_comp_temp_file).
  END.
END. /* choose_code_preview */


PROCEDURE choose_control_props :
/*------------------------------------------------------------------------------
  Purpose:  Bring up the OCX property editor    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE multControls AS  INTEGER NO-UNDO.
  DEFINE VARIABLE s            AS  INTEGER NO-UNDO.
  DEFINE BUFFER   f_u          FOR _U.

  /* Set and display the Property Editor window. */
  RUN show_control_properties (1).

END PROCEDURE. /* choose_control_props */


PROCEDURE choose_copy :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Copy; Copy Accelerators.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE VAR dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win EQ ? THEN RUN report-no-win.
  ELSE DO:
    RUN adeuib/_chksel.p(OUTPUT ivCount). /* check selection for same parents */
    IF ivCount > 0 THEN DO: /* Valid Copy */
      /* SEW store current trigger code before copying to clipboard. */
      RUN call_sew ("SE_STORE_SELECTED":U).

      RUN setstatus ("WAIT":U, "Copying to clipboard...").
      IF _comp_temp_file = ? THEN
        RUN adecomm/_tmpfile.p({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                               OUTPUT _comp_temp_file).
      ASSIGN cvCurrentSaveFile = _save_file
             _save_file = _comp_temp_file.

      /* Delete any OCX binary cut files */
      IF OPSYS = "WIN32":U THEN
      DO:
          OS-DELETE VALUE(_control_cut_file).
          ASSIGN _control_cb_op = TRUE.
      END.

      RUN adeuib/_chsxprt.p (FALSE).
      ASSIGN _save_file = cvCurrentSaveFile
             _control_cb_op = FALSE.
     /* ADE only works with a single clipboard format - text only. */
     ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
            CLIPBOARD:MULTIPLE = FALSE.
      /* Move the text into the clipboard */
      DO WITH FRAME _clipboard_editor_frame:
        ASSIGN _clipboard_editor:SCREEN-VALUE = ""
               dummy = _clipboard_editor:INSERT-FILE(_comp_temp_file)
               CLIPBOARD:VALUE = _clipboard_editor:SCREEN-VALUE.
      END.
      /* Restore clipboard multiple value. */
      ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple.
      RUN setstatus ("":U, "":U).
      OS-DELETE VALUE(_comp_temp_file).
    END. /* Valid Copy */
    ELSE DO: /* Invalid Copy */
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
      DO:
      IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,BROWSE-COLUMN":U,SELF:TYPE) THEN
            SELF:Edit-Copy().
      END.
      ELSE DO:
        IF ivCount = 0 THEN
        do:
           if OEIDEIsRunning then
              ShowMessageInIDE("There is nothing selected to copy.","Information",?,"OK",YES).
           else 
           MESSAGE "There is nothing selected to copy." VIEW-AS ALERT-BOX
              INFORMATION BUTTONS OK.
        end.      
        ELSE
        do:
          if OEIDEIsRunning then
              ShowMessageInIDE("There are selected objects with different parents. ~n
                               Copy only works on objects with the same parent.",
                               "Information",?,"OK",YES).
          else  
          MESSAGE "There are selected objects with different parents." SKIP
              "Copy only works on objects with the same parent."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        end.      
      END.
    END.  /* Invalid Copy */
  END. /* IF _h_win...ELSE DO: */
END PROCEDURE. /* choose_copy  */


PROCEDURE choose_cut :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Cut; Cut Accelerators    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE ivCount AS INTEGER INITIAL 0.
  DEFINE VARIABLE dummy AS LOGICAL.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.

  IF _h_win EQ ? THEN RUN report-no-win.
  ELSE DO:
    /* check selection: if different parents, then ivCount will be < 0 */
    RUN adeuib/_chksel.p (OUTPUT ivCount).
    IF ivCount > 0 THEN DO: /* Valid Cut */
      /* Cannot cut from alternate layouts. */
      IF CAN-FIND (FIRST _U WHERE _U._SELECTEDib
                     AND _U._LAYOUT-NAME ne "{&Master-Layout}":U)
      THEN
      do: 
          if OEIDEIsRunning then
              ShowMessageInIDE("Objects cannot be cut from alternate layouts. ~n 
                               Return to the Master Layout to cut these objects, 
                               or go to their property sheets to remove them from 
                               this layout.",
                               "Information",?,"OK",YES).
          else
          MESSAGE "Objects cannot be cut from alternate layouts." SKIP(1)
                   "Return to the Master Layout to cut these objects,"
                   "or go to their property sheets to remove them from"
                   "this layout."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      end.             
      ELSE DO:
        /* SEW store current trigger code before cutting to clipboard. */
        RUN call_sew ("SE_STORE_SELECTED":U).
        RUN setstatus ("WAIT":U, "Cutting to clipboard...").
        /* If any of the selected objects are in the current frame, then remove
           the selected objects from the current query. */
        IF _h_frame NE ? THEN RUN adeuib/_vrfyqry.p (_h_frame, "REMOVE-SELECTED-FIELDS":U, "").
        IF _comp_temp_file = ? THEN
          RUN adecomm/_tmpfile.p({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB},
                             OUTPUT _comp_temp_file).
        ASSIGN cvCurrentSaveFile = _save_file
              _save_file = _comp_temp_file.

        /* Delete any OCX binary cut files. */
        IF OPSYS = "WIN32":u THEN
        DO:
            OS-DELETE VALUE(_control_cut_file).
            ASSIGN _control_cb_op = TRUE.
        END.

        RUN adeuib/_chsxprt.p (FALSE).
        RUN CutSelected.  /* This is where the object gets deleted */

        ASSIGN _save_file = cvCurrentSaveFile
               _control_cb_op = FALSE.

        /* ADE only works with a single clipboard format - text only. */
        ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
               CLIPBOARD:MULTIPLE = FALSE.
        /* Move the text into the clipboard */
        DO WITH FRAME _clipboard_editor_frame:
          ASSIGN _clipboard_editor:SCREEN-VALUE = ""
               dummy = _clipboard_editor:INSERT-FILE(_comp_temp_file)
               CLIPBOARD:VALUE = _clipboard_editor:SCREEN-VALUE.
        END.
        /* Restore clipboard multiple value. */
        ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple.

        RUN adeuib/_winsave.p(_h_win, FALSE). /* update the file-saved state */
        OS-DELETE VALUE(_comp_temp_file).
        RUN del_cur_widg_check. /* Have we deleted the current widget? */
        RUN setstatus ("":U, "":U).
      END. /* IF...Master-Layout... */
      if OEIDEIsRunning and avail _U then 
       run CallWidgetEvent in _h_uib(input recid(_U),"DELETE").
    END. /* Valid Cut */
    ELSE DO:  /* Invalid Cut */
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
        APPLY LASTKEY TO SELF.
      ELSE DO:
        IF ivCount = 0 THEN
        do: 
           if OEIDEIsRunning then
              ShowMessageInIDE("There is nothing selected to cut.",
                               "Information",?,"OK",YES).
           else 
           MESSAGE "There is nothing selected to cut."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        end.           
        ELSE
        do: 
            if OEIDEIsRunning then
              ShowMessageInIDE("There are selected objects with different parents. ~n
                               Cut only works on objects with the same parent.",
                               "Information",?,"OK",YES).
           else
           MESSAGE "There are selected objects with different parents." SKIP
                   "Cut only works on objects with the same parent."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        end.
      END.
    END. /* Invalid Cut */
  END.
END PROCEDURE.  /* choose_cut */


PROCEDURE choose_debug :
/*------------------------------------------------------------------------------
  Purpose: run the current window with the debugger      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) 
    Causes errors if executed from ide */
  if IDEIntegrated then 
      return.
  RUN call_run ("DEBUG").
END PROCEDURE. /* choose_debug */


PROCEDURE choose_duplicate :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Duplicate.      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE ivCount           AS INTEGER    INITIAL 0.
  DEFINE VARIABLE OCXCount          AS INTEGER    NO-UNDO INITIAL 0.
  DEFINE VARIABLE dup_file          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE par-rec           AS RECID      NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib:
    ivCount = ivCount + 1.
    IF _U._TYPE = "{&WT-CONTROL}" THEN OCXCount = OCXCount + 1.
  END.

  IF ivCount = 0 THEN
  do:
    if OEIDEIsRunning then
              ShowMessageInIDE("There is nothing selected to duplicate.",
                               "Information",?,"OK",YES).
    else  
    MESSAGE "There is nothing selected to duplicate." VIEW-AS ALERT-BOX
            INFORMATION BUTTONS OK.
  end.          
  ELSE DO:

    /* SEW store current trigger code before duplicating in UIB. */
    RUN call_sew ("SE_STORE_SELECTED":U).

    cvCurrentSaveFile = _save_file.
    RUN "adecomm/_tmpfile.p"({&STD_TYP_UIB_DUP}, {&STD_EXT_UIB}, OUTPUT dup_file).

    /* set the file-saved state to false, since we will create object(s) */
    RUN adeuib/_winsave.p (_h_win, FALSE).

     _save_file = dup_file.
    IF _h_win = ? THEN RUN report-no-win.
    ELSE RUN adeuib/_chsxprt.p (FALSE).
    /* Make sure we don't duplicate a frame into its self */
    IF VALID-HANDLE(_h_frame) THEN DO:
      FIND _U WHERE _U._HANDLE EQ _h_frame.
      IF _U._TYPE EQ "FRAME":U AND _U._SELECTEDib THEN DO:
        par-rec = _U._PARENT-RECID.
        FIND _U WHERE RECID(_U) = par-rec.
        IF _U._TYPE EQ "WINDOW":U THEN _h_frame = ?.
        ELSE _h_frame = _U._HANDLE.  /* Parent duplicate to frame or dialog. */
      END.
    END.
    RUN adeuib/_qssuckr.p (dup_file, "", "IMPORT", FALSE).
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    WidgetAction = "Add".
    RUN display_current.
    WidgetAction = "".
    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).

    _save_file = cvCurrentSaveFile.

    /* The analyzer creates a file that we have to delete. It is based on
     * name of dup_file, with a different extension
     */

    OS-DELETE VALUE(dup_file)
              VALUE((SUBSTR(dup_file, 1, R-INDEX(dup_file, ".") - 1) + {&STD_EXT_UIB_QS})).

    /*
     * If this is a control then delete the temporary OCX binary file that was
     * created for the duplicate.
     */
      IF OPSYS = "WIN32":u AND (OCXCount > 0) THEN
         OS-DELETE VALUE((SUBSTR(dup_file, 1, R-INDEX(dup_file, ".") - 1) + {&STD_EXT_UIB_WVX})).

  END.

END PROCEDURE. /* Duplicate */


PROCEDURE choose_editor :
/*------------------------------------------------------------------------------
  Purpose: called from the mnu_editor dynamic menu-item in the mnu-tools menu
           This summons the Procedure Editor                         
Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN _RunTool("_edit.p":U).
  SESSION:DATE-FORMAT = _orig_dte_fmt.
END PROCEDURE. /* Choose editor */

PROCEDURE RightClick_viewSource:
    RUN choose_viewSource(INPUT "RightClick":U).
END PROCEDURE.

PROCEDURE choose_viewSource:
    DEFINE INPUT PARAMETER clickType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE wType       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE wName       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE wSection    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE wTrigger    AS CHARACTER NO-UNDO.
    DEFINE BUFFER   buff_U      FOR _U.
    DEFINE VARIABLE windowName  AS CHARACTER no-undo .
    IF AVAILABLE _P THEN 
       ASSIGN FILE-INFO:FILE-NAME = _P._save-as-file.
        
    IF clickType = "DoubleClick":U THEN 
    DO:
        FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
        IF AVAILABLE(_U) THEN 
        DO:
            ASSIGN wName = _U._Name
                   wType = _U._TYPE.

            IF VALID-HANDLE(OEIDE_ABSecEd) THEN 
                 RUN get_default_event IN OEIDE_ABSecEd(wType, OUTPUT wTrigger).
            /* OPEN_QUERY is not a real trigger */
            if wTrigger = "OPEN_QUERY" then 
               wTrigger = "". 
            IF wTrigger = "" THEN 
                ASSIGN  wSection = "MAIN BLOCK":U.
            ELSE   
                ASSIGN  wSection = "TRIGGER":U.      
        END.
    END.      
    else
        ASSIGN wType    = ""
               wName    = ""
               wSection = ""
               wTrigger = "". 
    if valid-handle (hOEIDEService) and IDEIntegrated THEN 
         viewSource(_h_win,wName,wType,wSection,wTrigger). 
   
END PROCEDURE.
 
PROCEDURE choose_erase :
/*------------------------------------------------------------------------------
  Purpose:  Erase marked widgets 
            called by Edit/Delete; Delete Anywhere     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cnt           AS INTEGER INITIAL 0 NO-UNDO.

  DEFINE BUFFER   x_U  FOR _U.

  /*
     NOTE: when we delete a dialog-box, this trigger is not run. If this
     is changed, then there would be an empty action record start and end
     created.  This trigger needs to be changed appropriately, when this
     happens.
  */
  FOR EACH _U WHERE _U._SELECTEDib:
    ASSIGN cnt = cnt + 1.
  END.

  IF cnt = 0 THEN DO:
    IF _DynamicsIsRunning THEN
    DO:
        IF SELF:TYPE = "EDITOR":U THEN
        DO:
           IF SELF:TEXT-SELECTED THEN
             SELF:REPLACE-SELECTION-TEXT("":U).
           ELSE
              SELF:DELETE-CHAR().
        END.
        ELSE DO:
          APPLY LASTKEY TO SELF.
          RETURN NO-APPLY.
       END.
    END.
    ELSE
    do:
      if OEIDEIsRunning then
              ShowMessageInIDE("There is nothing selected for deletion.",
                               "Information",?,"OK",YES).
      else  
      MESSAGE "There is nothing selected for deletion."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    end.      
  END.
  ELSE DO: /* objects to delete */
    /* Bailout if user is attempting to delete the browser off a DynBrows */
    IF _DynamicsIsRunning AND AVAILABLE _P THEN DO:
      IF LOOKUP(_P.OBJECT_type_code,
                  DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynBrow":U)) <> 0 THEN
        RETURN NO-APPLY.
    END.

    /* SEW store current trigger code before deleting. */
    RUN call_sew ("SE_STORE_SELECTED":U).

    RUN setstatus ("WAIT":U, ?).
    /* For each frame that is not selected itself, run through the selected
       widgets that it contains and remove them from the query */
    FOR EACH _U WHERE NOT _U._SELECTEDib
                  AND _U._WINDOW-HANDLE EQ _h_win
                  AND CAN-DO("DIALOG-BOX,FRAME":U,_U._TYPE):
      RUN adeuib/_vrfyqry.p (_U._HANDLE, "REMOVE-SELECTED-FIELDS":U, "":U).
    END.
    /* IF the current layout is the Master Layout then do an old fashioned delete */
    FIND _U WHERE _U._HANDLE = _h_win.

    /* Now create the undo record and DELETE the objects */
    CREATE _action.
    ASSIGN cnt                = _undo-seq-num /* note: cnt is clobbered */
           _action._seq-num   = _undo-seq-num
           _action._operation = "StartDelete":U
           _undo-seq-num      = _undo-seq-num + 1.

    IF _U._LAYOUT-NAME = "Master Layout" THEN
      RUN delselected.  /* Here is where we delete the widgets */
    ELSE DO:  /* Only mark things "remove-from-layout" */
      FOR EACH _U WHERE _U._SELECTEDib:
        IF _U._TYPE = "FRAME" THEN DO:
          FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win AND
                   x_U._PARENT-RECID = RECID(_U) AND
                   NOT x_U._NAME BEGINS "_LBL-":
            FIND _L WHERE RECID(_L) = x_U._lo-recid.
            IF x_U._HANDLE:HIDDEN = FALSE AND _L._REMOVE-FROM-LAYOUT = FALSE THEN DO:
              CREATE _action.
              ASSIGN _action._seq-num       = _undo-seq-num
                     _action._operation     = "Delete"
                     _action._u-recid       = RECID(x_U)
                     _action._window-handle = x_U._WINDOW-HANDLE
                     _undo-seq-num          = _undo-seq-num + 1
                     x_U._HANDLE:HIDDEN     = TRUE
                     _L._REMOVE-FROM-LAYOUT = TRUE.
              /* See if it is in any layout */
              IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(x_U) AND
                                NOT _L._REMOVE-FROM-LAYOUT) THEN
                x_U._STATUS = "DELETED".
            END.  /* If not all ready done */
          END.  /* For each field level widget of the frame */
        END.  /* If  a frame */

        FIND _L WHERE RECID(_L) = _U._lo-recid.
        CREATE _action.
        ASSIGN _action._seq-num       = _undo-seq-num
               _action._operation     = "Delete"
               _action._u-recid       = RECID(_U)
               _action._window-handle = _U._WINDOW-HANDLE
               _undo-seq-num          = _undo-seq-num + 1
               _U._HANDLE:HIDDEN      = IF _U._TYPE NE "SmartObject":U THEN TRUE
                                        ELSE FALSE    /* Hide this later */
               _L._REMOVE-FROM-LAYOUT = TRUE.

        IF _U._TYPE EQ "SmartObject":U THEN DO:
          FIND _S WHERE RECID(_S) EQ _U._x-recid.
          RUN HideObject IN _S._HANDLE.
        END.

        /* See if it is in any layout */
        IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                          NOT _L._REMOVE-FROM-LAYOUT) THEN
          _U._STATUS = "DELETED".

        IF NOT CAN-DO("WINDOW,DIALOG-BOX,FRAME":U,_U._TYPE) THEN
          ASSIGN _h_cur_widg = _h_frame.
      END.  /* For each selected widget */
      IF VALID-HANDLE(_h_cur_widg) AND _h_cur_widg:TYPE = "FRAME" THEN
        RUN display_current.
    END.  /* Else an altenative layout */

    CREATE _action.
    ASSIGN _action._seq-num = _undo-seq-num
           _action._operation = "EndDelete":U
           _undo-seq-num = _undo-seq-num + 1
           _action._data = STRING(cnt).

    /* set the file-saved state to false, since we just deleted object(s) */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    RUN UpdateUndoMenu("&Undo Delete").
    RUN setstatus ("":U, ?).
  END. /* objects to delete */
END. /* choose_erase */


PROCEDURE choose_export_file :
/*------------------------------------------------------------------------------
  Purpose: Export selected objects to an export file.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   if IdeIntegrated then   
      runDialog(_h_win,"exportFile":U).
  else
      run do_export_file.    
END. /* choose_export_file */


PROCEDURE choose_file_new :
/*------------------------------------------------------------------------------
  Purpose:  creates a new window or dialog-box and makes sure that the new item 
            is the current object    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR choice    AS CHAR NO-UNDO.
  DEFINE VAR cChoice   AS CHAR NO-UNDO.
  DEFINE VAR cFileExt  AS CHAR NO-UNDO.
  DEFINE VAR lHtmlFile AS LOG  NO-UNDO.
  DEFINE VAR h_curwin  AS HANDLE NO-UNDO.
  /* prevent this from being triggered by hotkey from ide design window */
  if IDEIntegrated then 
      return.
      
  /* Save off the current object design window handle. Use it to determine
     if a new object was actually created (handle will change). */
  ASSIGN h_curwin = _h_win.

  RUN adeuib/_newobj.w ( OUTPUT choice ).
  /* DESELECT everything that is selected if a choice was made. */
  IF choice NE "" AND choice NE ? THEN DO:
    RUN adecomm/_osfext.p ( choice, OUTPUT cFileExt ).
    IF (cFileExt EQ ".htm":U OR cFileExt EQ ".html":U) AND
      _AB_license > 1 THEN DO:

      lHtmlFile = TRUE.
      RUN adeweb/_trimdsc.p (choice, OUTPUT cChoice) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        choice = cChoice.
    END.

    RUN Open_Untitled (choice).

    /* Delete temp file. */
    IF lHtmlFile THEN
      OS-DELETE VALUE(choice).

    RUN display_curwin.

    /* je-icf: Show the property sheet of new dynamic repository object. */
    IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
    DO:
      run startDynPropSheet.  
    END.

  END. /* If a valid choice */
  
END PROCEDURE.  /* choose_file_new */


PROCEDURE choose_file_open :
/*------------------------------------------------------------------------------
  Purpose:  called by File/Open or Ctrl-O    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN choose_open (INPUT "FILE":u).

END PROCEDURE.  /* choose_file_open */


PROCEDURE choose_file_print :
/*------------------------------------------------------------------------------
  Purpose:   called by File/Print   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cScrap AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lPrinted AS LOGICAL NO-UNDO.

  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN setstatus ("WAIT":U, "Generating code to print...").

    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "PREVIEW":U, ?, ?, OUTPUT cScrap).
    ELSE
      RUN adeshar/_gen4gl.p ("PRINT":U).

    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
    RUN setstatus ("":U, "":U).
    RUN adeuib/_abprint.p ( INPUT _comp_temp_file,
                            INPUT _h_win,
                            INPUT _P._save-as-file,
                            INPUT ?,
                            OUTPUT lPrinted ) .

    /* The temp file is no longer needed */
    OS-DELETE VALUE(_comp_temp_file).
  END.  /* else do - _h_win <> ? */
END PROCEDURE.  /* choose_file_print */

procedure choose_file_save :
    /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
    if IDEIntegrated then 
      return.
    run do_file_save.
end procedure.


PROCEDURE ide_file_save :
/*------------------------------------------------------------------------------
  Purpose: called by adeuib.ide.request._saverequest on behalf of ide  
  Parameters: phwin  window handle>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter phWin as handle no-undo.
    define variable lrefresh as log  no-undo.
    define buffer b_u for _u. 
    
    find b_u where b_U._HANDLE = phwin no-error.
    
    if not avail b_U then
    do:
        if phwin:type = "WINDOW":U then
             phwin = phwin:first-child.
        find b_U where b_U._HANDLE = phwin no-error.   
    end.
    if not avail b_u then 
       undo, throw new Progress.Lang.AppError("Invalid window handle reference passed to save method.",?).
    
    if phwin <> _h_win then
    do:
        _h_win = phWin.
        lRefresh = true.
    end.    
    
    run do_file_save.
    finally: 
        if lRefresh then
        do:
            run display_curwin.
        end. 
    end finally.
end procedure.

PROCEDURE do_file_save :
/*------------------------------------------------------------------------------
  Purpose: called by File/Save or Ctrl-S    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cancel       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE notSavedYet  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE pError       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE pAssocError  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOK          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRegisterObj AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDefCode     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iReciD       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE _save_file   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE h_title_win  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE OldTitle     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNew         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSaveFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE rRecid       AS RECID      NO-UNDO.
  DEFINE VARIABLE cAbort       AS CHARACTER  NO-UNDO.
  
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    ASSIGN notSavedYet = YES.
    FIND _U WHERE _U._HANDLE = _h_win.
    /* If we are running Dynamics, check to see if this is a dynamic
       object and save it as such if it is                         */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN 
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
      
      IF (NOT _P.static_object) AND
         LOOKUP(_P._TYPE,"SmartDataBrowser,SmartDataObject,SmartDataViewer,SmartViewer":U) > 0 THEN 
      DO:
        /* Wizard Confirmation Dialog */
        IF CAN-DO(_P.design_action,"NEW":u) THEN 
        DO:
            RUN adeuib/_accsect.p("GET":U,
                                   ?,
                                   "DEFINITIONS":U,
                                   INPUT-OUTPUT iRecID,
                                   INPUT-OUTPUT cDefCode ).
            ASSIGN
              iStart     = INDEX(cDefCode,"File:")
              iEnd       = INDEX(cDefCode,CHR(10),iStart)
              _save_file = IF iStart > 0 AND iEnd > 0
                           THEN TRIM(SUBSTRING(cDefCode,iStart + 5,  iEnd - iStart - 5 ))
                           ELSE _save_file
            NO-ERROR.
            
            ASSIGN cSaveFile       = _P._SAVE-AS-FILE
                   _P._SAVE-AS-FILE = _save_File
                   rRecid           = RECID(_P).
                 /* The call to _saveaswizd.w requires a valid _h_cur_widg, but this
               won't be the case if multiple objects are choosen. In this case
               set it to _h_win.  */
               
            IF NOT VALID-HANDLE(_h_cur_widg) THEN 
              _h_cur_widg = _h_win.
            if OEIDEisRunning then
            do:
                /* wait state locks the ui when embedded (probably becuase there is no automatic turn off
                   since there is no dialog) */
                run setstatus("","").
                run adeuib/ide/_dialog_saveaswizd.p (no,
                                                     output lRegisterObj,
                                                     output lOK).
            end.
            else
                run adeuib/_saveaswizd.w (input no, output lRegisterObj, output lOK).
            
            IF rRecid <> RECID(_P) THEN
               FIND _P WHERE  RECID(_P) = rRecid .
            IF NOT lOK THEN DO:
              _P._SAVE-AS-FILE = cSaveFile.
              RETURN.
            END.
        END.

         /* The design action might have been "NEW", but now object is save. So the
            action is changed to "OPEN". */
        ASSIGN lNew              = LOOKUP("NEW":U,_P.design_action) > 0
               _P.design_action  = REPLACE (_P.design_action, "NEW":U, "OPEN":U)
               notSavedYet        = NO NO-ERROR. /* This is to clear the ERROR handle */

        RUN setstatus ("WAIT":U,"Saving object...":U).

        /* Here's where we save the dynamic object */
        RUN ry/prc/rygendynp.p (INPUT RECID(_P),
                                OUTPUT pError,              /* Error saving object */
                                OUTPUT pAssocError).        /* Error saving data logic procedure */

        RUN setstatus ("":U, "":U).

        IF (pError <> "") THEN
        DO:
            RUN showMessages IN gshSessionManager (INPUT pError,
                                                   INPUT "ERR":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "OK":U,
                                                   INPUT "Object Save Error",
                                                   INPUT YES,
                                                   INPUT ?,
                                                 OUTPUT cAbort).

           IF lNew THEN
              ASSIGN _P._SAVE-AS-FILE = ?
                     _P.design_action = REPLACE (_P.design_action, "OPEN":U,"NEW":U ).
           RETURN.
        END. /* If there was an error */

        ASSIGN
          _P._FILE-SAVED         = TRUE
          h_title_win            = _P._WINDOW-HANDLE:WINDOW
          OldTitle               = h_title_win:TITLE.
          .

        IF NOT AVAILABLE _U THEN
          FIND _U WHERE _U._HANDLE = h_title_win.
        RUN adeuib/_wintitl.p (h_title_win, _U._LABEL + "(" + _P.OBJECT_type_code + ")", _U._LABEL-ATTR,
                               _P._SAVE-AS-FILE).

        /* Change the active window title on the Window menu. */
        IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
          RUN WinMenuChangeName IN _h_WinMenuMgr
            (_h_WindowMenu, OldTitle, h_title_win:TITLE).

        /* Notify the Section Editor of the window title change. Data after
           "SE_PROPS" added for 19990910-003. */
        RUN call_sew ( "SE_PROPS":U ).

        /* Update most recently used filelist */

        IF _mru_filelist THEN
          RUN adeshar/_mrulist.p (ENTRY(NUM-ENTRIES(_P._SAVE-AS-FILE,"/":U),_P._SAVE-AS-FILE,"/":U), IF _remote_file THEN _BrokerURL ELSE "").

        /* IZ 776 Redisplay current filename in AB Main window. */
        RUN display_current IN _h_uib.

        /* Dynamics: IZ 6618. When saving an object, force tools to refresh its instances of the saved smartobject */
        IF _DynamicsIsRunning                 AND
           VALID-HANDLE(gshRepositoryManager) AND
           _P.smartObject_obj <> ?            AND
           _P.smartObject_obj <> 0            THEN
          PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT _P.smartObject_obj, INPUT _P.Object_FileName).

        IF _P._TYPE = "SmartDataObject":U AND pAssocError NE "":U THEN
        DO:
          pAssocError = "The SDO's data logic procedure failed to compile with the following errors: ":U
                        + CHR(10) + CHR(10) + pAssocError + CHR(10)
                        + "Do you wish to open the data logic procedure to correct its compile errors?":U.

          RUN showMessages IN gshSessionManager (INPUT pAssocError,
                                                 INPUT "ERR":U,
                                                 INPUT "YES,NO,CANCEL":U,
                                                 INPUT "YES":U,
                                                 INPUT "CANCEL":U,
                                                 INPUT "Data Logic Procedure Compile Error",
                                                 INPUT YES,
                                                 INPUT ?,
                                                 OUTPUT cAbort).
          IF cAbort = "YES":U AND VALID-HANDLE(_h_menubar_proc) THEN
            RUN runOpenProcedure IN _h_menubar_proc.
        END.  /* if SDO and data logic procedure did not compile */

      END. /* if it is a dynamic SDV object */
      ELSE DO:
         IF VALID-HANDLE(_h_menubar_proc) AND _P.smartObject_Obj > 0 THEN
            RUN PropUpdateMaster IN _h_menubar_proc
                      (_P._WINDOW-HANDLE, _P.smartObject_Obj).
      END.
    END. /* If we are running dynamics */

    IF notSavedYet THEN DO:
      /* SEW call to store current trigger code for specific window. */
      RUN call_sew ("SE_STORE_WIN":U).
      
      RUN save_window (NO, OUTPUT cancel).
      
    END. /* If saving a static object */
  END. /* Else we have a valid window handle */
END PROCEDURE. /* do_file_save */


PROCEDURE choose_file_saveAsStatic_Undo :
/*------------------------------------------------------------------------------
  Purpose:     Returns _U records to their previous state
  Parameters:  plIsSBO      Yes - Data Object is an SBO
                            NO  - Data Object is an SDO
               phL          Handle of temp-table buffer built against _L table
               pcResultCode Custom result code
  Notes:       Called from choose_file_save_as_static
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plIsSBO      AS LOGICAL   NO-UNDO.
DEFINE INPUT PARAMETER phL          AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode AS CHARACTER NO-UNDO.

DEFINE VARIABLE hLBuf  AS HANDLE NO-UNDO.

/* Re-aasign the _U._Table back to what it was */
IF NOT plIsSBO THEN
DO:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
             AND _U._BUFFER        = "RowObject":U:
     IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA,CHR(4)) = 2 THEN
       ASSIGN _U._TABLE = ENTRY(1,_U._HANDLE:PRIVATE-DATA,CHR(4))
              _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA,CHR(4))
              NO-ERROR.
  END.
END.
ELSE DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        > "":

     IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA,CHR(4)) = 2 THEN
     ASSIGN _U._BUFFER = ENTRY(1,_U._HANDLE:PRIVATE-DATA,CHR(4))
            _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA,CHR(4))
            NO-ERROR.
   END. /* End For each _U */
END.

/* Restore the custom _L records from the temp-table buffer */
IF phL NE ? THEN
DO:
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE AND _U._STATUS = "NORMAL":U :
    
     phL:FIND-FIRST("where Undo_L._u-recid = " + STRING(RECID(_U))). 
     IF phL:AVAILABLE THEN
     DO:
        FIND _L WHERE _L._lo-name = "Master Layout":U AND _L._u-recid = RECID(_U) NO-ERROR.
        IF AVAIL _L THEN
        DO:
           hLBuf = BUFFER _L:HANDLE.  
           hLBuf:BUFFER-CREATE().
           hLBuf:BUFFER-COPY(phL).
           ASSIGN _U._Layout-name = pcResultCode
                  _U._lo-recid    = hLBuf:RECID.
        END.
     END.
     
  END.
END.

END PROCEDURE. /* choose_file_saveAsStatic_Undo */


PROCEDURE choose_file_save_all :
/*------------------------------------------------------------------------------
  Purpose: called by File/Save All     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER x_U FOR _U.
  DEFINE BUFFER x_P FOR _P.
  
  /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  FOR EACH x_U WHERE CAN-DO("WINDOW,DIALOG-BOX",x_U._TYPE)
                                         AND x_U._STATUS NE "DELETED":

    IF x_U._TYPE = "DIALOG-BOX":U THEN RUN changewidg (x_U._HANDLE, YES).
    ELSE APPLY "ENTRY":U TO x_U._HANDLE.

    FIND x_P WHERE x_P._u-recid EQ RECID(x_U).
    IF x_P._SAVE-AS-FILE = ? THEN
    do:
      if OEIDEIsRunning then
              ShowMessageInIDE(IF x_U._SUBTYPE EQ "Design-Window" THEN x_U._LABEL ELSE x_U._NAME + "~n" 
                               + "This window has not been previously saved.",
                               "Information",?,"OK",YES).
      else  
      MESSAGE IF x_U._SUBTYPE EQ "Design-Window" THEN x_U._LABEL ELSE x_U._NAME SKIP
        "This window has not been previously saved."
        VIEW-AS ALERT-BOX INFORMATION.
    end.
    RUN choose_file_save.

  END.  /* for each x_u */
END PROCEDURE.  /* choose_file_save_all */

procedure choose_file_save_as :
    /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
    if IDEIntegrated then 
      return.
    run do_file_save_as.
end procedure.


PROCEDURE do_file_save_as :
/*------------------------------------------------------------------------------
  Purpose:  Save current window with a new name   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cancel        AS LOGICAL    NO-UNDO.
 
  IF _h_win = ? THEN  RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.
    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).
    RUN save_window (YES, OUTPUT cancel).
    
  END.

END PROCEDURE. /*do_file_save_as */


PROCEDURE choose_file_save_as_dynamic :
/*------------------------------------------------------------------------------
  Purpose: Save current window with a new name     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pressed-OK    AS LOGICAL    NO-UNDO.

  IF _h_win = ? THEN  RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_win.

    /* SEW call to store current trigger code for specific window. */
    RUN call_sew ("SE_STORE_WIN":U).

    /* Choose the Product module and object Name */
    RUN adeuib/_chsPM.p
        (INPUT _h_menu_win,             /* Parent Window    */
         INPUT RECID(_P),               /* _P recid         */
         INPUT _P.product_module_code,  /* Product Module   */
         INPUT _P._SAVE-AS-FILE,        /* Object to add    */
         INPUT _P._TYPE,                /* File type        */
         OUTPUT pressed-ok).
  END.

END PROCEDURE. /*  choose_file_save_as_dynamic */


PROCEDURE choose_file_save_as_static :
/*------------------------------------------------------------------------------
  Purpose:     Save dynamic object as static
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lCancel        AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cOldSaveAsFile AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldObjectType AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldTitle      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE h_title_win    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTemplateWin   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE rTemplateRecid AS RECID      NO-UNDO.
 DEFINE VARIABLE r_URecid       AS RECID      NO-UNDO.
 DEFINE VARIABLE r_PRecid       AS RECID      NO-UNDO.
 DEFINE VARIABLE lMRUFileList   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hOldWin        AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hOldWidg       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDesignManager AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cEventCode     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cEventTarget   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE c_UName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lisSBO         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE dOldObjectObj  AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE cResultCode    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCustom        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE tthL           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE bhL            AS HANDLE     NO-UNDO.

 DEFINE BUFFER template_P    FOR _P.
 DEFINE BUFFER template_TRG  FOR _TRG.
 DEFINE BUFFER template_XFTR FOR _XFTR.
 DEFINE BUFFER Event_U       FOR _U.
 DEFINE BUFFER b_L           FOR _L.

 IF _h_win = ? THEN 
 DO: 
    RUN report-no-win IN THIS-PROCEDURE.
    RETURN.
 END.
 
 FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
 FIND _U WHERE _U._HANDLE        = _h_win.

 /* Determine the equivalent static object type   */

 IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynView":U) THEN
    cObjectType = "StaticSDV":U.
 ELSE IF DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, _P.object_type_code,"DynSDO":U) THEN
    cObjectType = "SDO":U.
 ELSE IF DYNAMIC-FUNCTION('classIsA':u in gshRepositoryManager, _P.Object_Type_Code, 'DynDataView':u) THEN
     cObjectType = 'StaticDataView':u.
 ELSE DO:
   if OEIDEIsRunning then
     ShowMessageInIDE("Only Dynamic Viewers, Dynamic SDOs and Dynamic DataViews are supported for saving as static.",
                       "Information",?,"OK",YES).
   else  
   MESSAGE "Only Dynamic Viewers, Dynamic SDOs and Dynamic DataViews are supported for saving as static." view-as alert-box.
   RETURN.
 END.

 ASSIGN r_PRecid               = RECID(_P)
        cOldSaveAsFile         = _P._SAVE-AS-FILE
        _P._SAVE-AS-FILE       = ?
        _P.static_object       = YES
        cOldObjectType         = _P.object_type_code
        _P.object_type_code    = cObjectType
        _P.smartObject_obj     = 0
        r_URecid               = RECID(_U)
        hOldWin                = _h_win
        hOldWidg               = _h_cur_widg
        dOldObjectObj          = _P.smartObject_obj        
        cResultCode            = IF _U._LAYOUT-NAME = "Master Layout":U THEN "" ELSE _U._LAYOUT-NAME
        NO-ERROR.

/* Get object's Data Object from repository and check whether it is derived from a dynamic SBO */
IF _P._data-Object > "" THEN 
DO:
  hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
  RUN retrieveDesignObject IN hDesignManager 
     (INPUT _P._data-Object ,
      INPUT  "",  /* Get default  result Codes */
      OUTPUT TABLE ttObject,
      OUTPUT TABLE ttPage,
      OUTPUT TABLE ttLink,
      OUTPUT TABLE ttUiEvent,
      OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 
  FIND FIRST ttObject WHERE ttObject.tLogicalObjectName = _P._data-Object NO-ERROR.
  IF AVAIL ttObject THEN
    lIsSBO = DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager, ttObject.tClassName,"SBO":U). 
END.


 /* For Objects whose data-object is a SDO, change the _U._Table field from the table name to RowObject */
 /* Save the current _TABLE record in the private data in case the user cancels the save */.
 IF NOT lisSBO THEN
 DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        = "RowObject":U:
      IF VALID-HANDLE(_U._HANDLE) THEN
      DO:
        ASSIGN _U._HANDLE:PRIVATE-DATA = _U._TABLE + CHR(4) + _U._HANDLE:PRIVATE-DATA
               _U._TABLE = "RowObject":U.
        /* If the source data type is CLOB, the local name must be set.

           SDO data source: _U._NAME is the data field name (e.g. custnum)
           and is the instance name of the field in the dynamic viewer,
           therefore it is unique.

           SBO data source: _U._NAME is the data field name (e.g. custnum) but
           the instance name of the field in the dynamic viewer is qualified
           with the SDO name (e.g. custfullo.custnum) therefore it is not
           unique and requires logic to set the _LOCAL-NAME to a unqiue name.
           This cannot be done until 20040427-038 is resolved.  */
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._SOURCE-DATA-TYPE = "CLOB":U THEN
          _U._LOCAL-NAME = _U._NAME.
      END.
   END.
 END.
 /* IF data source is an SBO,change Buffer to equal the SDO object */
 ELSE DO:
   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
                 AND _U._BUFFER        > "":
      IF VALID-HANDLE(_U._HANDLE) THEN
      DO:
        ASSIGN _U._HANDLE:PRIVATE-DATA = _U._BUFFER + CHR(4) + _U._HANDLE:PRIVATE-DATA
               _U._BUFFER = _U._TABLE.
        
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._SOURCE-DATA-TYPE = "CLOB":U THEN
          _U._LOCAL-NAME = _U._NAME.
      END.
   END.
 END.
 /* Load template into the Appbuilder so that the code sections (Main block, definitions, etc) of the 
    template can be copied to the static object */
 IF SEARCH(_P.design_template_file) <> ? THEN
 DO:
  ASSIGN lMRUFileList  = _mru_filelist
         _mru_filelist = NO.

   RUN adeuib/_qssuckr.p (INPUT _P.design_template_file,   /* File to read        */
                          INPUT "",                 /* WebObject           */
                          INPUT "WINDOW-SILENT":U,  /* Import mode         */
                          INPUT FALSE).             /* Reading from schema */
   ASSIGN _mru_filelist = lMRUFileList.
   IF RETURN-VALUE BEGINS "_ABORT":U THEN
   DO:
     if OEIDEIsRunning then
     ShowMessageInIDE(RETURN-VALUE,"Information",?,"OK",YES).
     else  
  
     MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  
     FIND _P WHERE RECID(_P) =  r_PRecid.
     ASSIGN _P._SAVE-AS-FILE   = cOldSaveAsFile
           _P.static_object    = NO
           _P.object_type_code = cOldObjectType
           _P.smartObject_obj  = dOldObjectObj.
     
     /* Re-aasign the _U._Table back to what it was */
     RUN choose_file_saveAsStatic_Undo (lIsSBO,?,cResultCode).
     RETURN.
   END.
 END. /* End if SEARCH(_P._Design_template_file) */
 ELSE DO:
    if OEIDEIsRunning then
     ShowMessageInIDE("Could not save object as static. ~n 
                      Template file " +  _P.design_template_file + "was not found",
                      "Information",?,"OK",YES).
    else 
    MESSAGE "Could not save object as static." SKIP(1)
            "Template file " +  _P.design_template_file + "was not found"
       VIEW-AS ALERT-BOX INFO BUTTONS OK.
    FIND _P WHERE RECID(_P) =  r_PRecid.
    ASSIGN _P._SAVE-AS-FILE    = cOldSaveAsFile
           _P.static_object    = NO
           _P.object_type_code = cOldObjectType
           _P.smartObject_obj  = dOldObjectObj            .
    /* Re-aasign the _U._Table back to what it was */
    RUN choose_file_saveAsStatic_Undo (lIsSBO,?,cResultCode).
    RETURN.
 END.
 
 FIND template_P WHERE template_P._WINDOW-HANDLE = _h_win.
 FIND _P WHERE RECID(_P)                         = r_PRecid.
 FIND _U         WHERE RECID(_U)                 = r_URecid.
 ASSIGN hTemplateWin   = _h_win
        rTemplateRecid = RECID(template_P)
        _P._links      = template_P._links.

 /* For each _TRG record in the template file, copy to the current object */
 FOR EACH template_TRG WHERE template_TRG._pRECID = rTemplateRecid:
    FIND FIRST _TRG WHERE _TRG._pRecid = RECID(_P)
                      AND _TRG._wRecid = RECID(_U)
                      AND _TRG._tevent = template_TRG._tevent NO-ERROR.
    /* Skip XFTR sections */
    IF  template_TRG._tsection = "_XFTR":U THEN
       NEXT.
    IF NOT AVAIL _TRG THEN
    DO:
       CREATE _TRG.
       BUFFER-COPY template_TRG TO _TRG
         ASSIGN _TRG._pRECID = RECID(_P)
                _TRG._wRECID = RECID(_U).
    END.
    ELSE
       BUFFER-COPY template_TRG EXCEPT _pRECID _wRECID _tEvent TO _TRG.
 END.  /* End For Each template_TRG */
 

DO iCustom = 1 TO (IF cResultCode = "" THEN 1 ELSE 2):
   /* Retrieve the UI events specified for the dynamic object and create a 
      trigger for each */ 
   EMPTY TEMP-TABLE ttUIEvent.
   RUN retrieveDesignObject IN hDesignManager 
       (INPUT _P.Object_Filename ,
        INPUT  (IF iCustom = 1 THEN "" ELSE cResultCode) ,  /* Get default  result Codes */
        OUTPUT TABLE ttObject,
        OUTPUT TABLE ttPage,
        OUTPUT TABLE ttLink,
        OUTPUT TABLE ttUiEvent,
        OUTPUT TABLE ttObjectAttribute ) NO-ERROR. 

   FOR EACH ttUIEvent:
       FIND FIRST ttObject WHERE ttObject.tSmartObjectObj    = ttUIEvent.tSmartObjectObj
                             AND ttObject.tObjectInstanceObj = ttUIEvent.tObjectInstanceObj NO-ERROR.
       IF NOT AVAIL ttObject THEN NEXT.

       /* If the data source is an SBO, the instance name will contain the SDO prefixed. Strip it out 
          to find the _U record. */
       ASSIGN c_UName = IF NUM-ENTRIES(ttObject.tObjectInstanceName,".") >= 2 
                        THEN ENTRY(2,ttObject.tObjectInstanceName,".")
                        ELSE ttObject.tObjectInstanceName.

       FIND Event_U WHERE Event_U._NAME = c_UName NO-ERROR. 
       IF NOT AVAIL Event_U AND c_UName > "" THEN 
          NEXT.

       IF NOT AVAIL Event_U THEN 
       DO: /* Find the Frame widget */
           FIND FIRST Event_U WHERE Event_U._TYPE = "FRAME":U AND Event_U._parent = hOldWin NO-ERROR.
           IF NOT AVAIL Event_U THEN NEXT.
       END.
       ASSIGN cEventCode   = "/*  Generated trigger from Dynamic Object '" + _P.Object_Filename + "' */" + CHR(10) + "DO:" + CHR(10)
              cEventTarget = "".


      CASE ttUIEvent.tActionTarget:

         WHEN "SELF":U      THEN ASSIGN cEventTarget =  "TARGET-PROCEDURE" .
         WHEN "CONTAINER":U THEN ASSIGN cEventTarget = "  ~{get ContainerSource hTarget~}.":U.
         /* Run anywhere. This is only valid for an action type of PUB. */
         WHEN "ANYWHERE":U  THEN ASSIGN cEventTarget = "":U.
         /* Run on the AppServer. This is only valid for an action type of RUN. */
         WHEN "AS":U        THEN ASSIGN cEventTarget = "gshAstraAppServer":U.
         /* Managers: of the manager handle is used, we use the hard-coded,
          * predefined handle variables.                                        */
         WHEN "GM":U        THEN ASSIGN cEventTarget = "gshGenManager":U.
         WHEN "SM":U        THEN ASSIGN cEventTarget = "gshSessionManager":U.
         WHEN "SEM":U       THEN ASSIGN cEventTarget = "gshSecurityManager":U.
         WHEN "PM":U        THEN ASSIGN cEventTarget = "gshProfileManager":U.
         WHEN "RM":U        THEN ASSIGN cEventTarget = "gshRepositoryManager":U.
         WHEN "TM":U        THEN ASSIGN cEventTarget = "gshTranslationManager":U.
         OTHERWISE  DO:
           IF ttUIEvent.tActionTarget > "" THEN
              cEventTarget = "  hTarget = DYNAMIC-FUNCTION('getManagerHandle':U, INPUT " + '"' + ttUIEvent.tActionTarget + '":U' + ") NO-ERROR.":U. 
         END.
       END CASE.

      /* If event is disabled, comment out trigger */
      IF ttUIEvent.tEventDisabled THEN
         cEventCode   = cEventCode + "/******************** Disabled Event ********************" + CHR(10).
    /* Add the code to retrieve the target for container and other targets.*/
       IF NUM-ENTRIES(cEventTarget, " ") > 1 THEN
          cEventCode = cEventCode + "  DEFINE VARIABLE hTarget AS HANDLE NO-UNDO.":U + CHR(10)
                                  + cEventTarget + CHR(10).

       IF ttUIEvent.tActionType = "RUN":U THEN
           cEventCode = cEventCode + "  RUN ":U + ttUIEvent.tEventAction
                                   + (IF ttUIEvent.tActionTarget = "AS":U OR ttUIEvent.tActionTarget = "AppServerConnectionManager":U THEN " ON ":U 
                                      ELSE IF cEventTarget > "" THEN " IN ":U ELSE "") 
                                   + (IF NUM-ENTRIES(cEventTarget, " ") > 1 THEN "hTarget":U  ELSE cEventTarget).
       ELSE 
           cEventCode = cEventCode + "  PUBLISH ":U + '"' + ttUIEvent.tEventAction + '":U'
                                   + (IF NUM-ENTRIES(cEventTarget, " ") > 1 
                                      THEN " FROM hTarget ":U  
                                      ELSE IF cEventTarget > "" THEN " FROM " + cEventTarget
                                                                ELSE "")  .

       IF ttUIEvent.tEventParameter > "" THEN
           cEventCode = cEventCode + " ( INPUT " + '"' + ttUIEvent.tEventParameter + '":U' + ")":U.

       IF ttUIEvent.tActionType = "RUN":U THEN 
          cEventCode = cEventCode + " NO-ERROR.":U.
       ELSE
          cEventCode = cEventCode + ".":U .

       IF ttUIEvent.tActionType = "RUN":U  THEN
          cEventCode = cEventCode + CHR(10) 
                                  + "  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE '' THEN"
                                  + CHR(10) + "     RETURN NO-APPLY.".

      IF ttUIEvent.tEventDisabled THEN
       cEventCode = cEventCode + CHR(10) + "*******************************************************/":U .

      cEventCode = cEventCode + CHR(10) + "END.":U.

      FIND FIRST _TRG WHERE _TRG._pRecid = RECID(_P)
                        AND _TRG._wRecid = RECID(Event_U)
                        AND _TRG._tevent = ttUIEvent.tEventNAME NO-ERROR.

      IF NOT AVAIL _TRG THEN
         CREATE _TRG.
      ASSIGN _TRG._tSECTION = "_CONTROL":U
             _TRG._wRECID   = RECID(Event_U)
             _TRG._tEVENT   = CAPS(ttUIEvent.tEventNAME)
             _TRG._tCODE    = cEventCode
             _TRG._STATUS   = "NORMAL":U
             _TRG._pRECID   = RECID(_P).
  END.
END. /* End iCustom  1 to 1 or 2) */

/* Need to copy the _L records from the custom code to the master layout */
IF cResultCode > "" THEN
DO:
   /* Store the contents of _L to a temp table in case we need to undo the copying of _L records */
   CREATE TEMP-TABLE tthL.
   tthL:CREATE-LIKE(BUFFER _L:HANDLE).
   tthL:TEMP-TABLE-PREPARE("Undo_L").

   FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE 
                 AND _U._STATUS = "NORMAL":U:
      
      RELEASE _L NO-ERROR.
      /* Find b_L of custom */      
      FIND b_L WHERE b_L._lo-name = cResultCode AND b_L._u-recid = RECID(_U) NO-ERROR.
      /* Find _L of Master Layout */
      IF AVAIL b_L THEN
        FIND _L WHERE _L._lo-name = "Master Layout":U AND _L._u-recid = b_L._u-recid NO-ERROR.

      IF AVAIL _L THEN
      DO:
         bhL = tthl:DEFAULT-BUFFER-HANDLE.
         bhL:BUFFER-CREATE.
         bhL:BUFFER-COPY(BUFFER _L:HANDLE).
         /* Now copy the _L records from the custom to the master, so that the save will use the _l records. */
         BUFFER-COPY b_L EXCEPT _LO-NAME _BASE-LAYOUT TO _L.
         /* Now delete the custom record */
         DELETE b_L.
        ASSIGN _U._lo-recid = RECID(_L)
               _U._layout-name = "Master Layout":U.
       END.
   END. /* For each _U */
END. /* End if cResultCode > "" */
 
 /* Refind _P after closing template window and reassign _h_Win incase it was confused*/
 FIND _P WHERE RECID(_P) = r_PRecid.
 FIND _U WHERE RECID(_U) = r_URecid.
 
 IF _h_win NE hOldWin THEN
 DO:
    ASSIGN _h_Win      = hOldWin
           _h_cur_widg = hOldWidg.
    FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
    IF AVAILABLE _F THEN 
       _h_frame = _F._FRAME.
    ELSE DO:
        IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN 
           _h_frame = _U._HANDLE.
        ELSE _h_frame = ?.
    END.
    RUN curframe IN THIS-PROCEDURE (_h_cur_widg).
 END.

 FIND _P WHERE RECID(_P) = r_PRecid.
 FIND _U WHERE RECID(_U) = r_URecid.

 RUN save_window IN THIS-PROCEDURE (YES, OUTPUT lCancel).

 IF VALID-HANDLE(hTemplateWin)THEN
    RUN wind-close IN THIS-PROCEDURE (hTemplateWin).
 
 IF lCancel THEN
 DO:
    FIND _P WHERE RECID(_P) =  r_PRecid.
    ASSIGN _P._SAVE-AS-FILE       = cOldSaveAsFile
           _P.static_object       = NO
           _P.object_type_code    = cOldObjectType
           _P.smartObject_obj     = dOldObjectObj.          
     
    RUN choose_file_saveAsStatic_Undo (lIsSBO,bHL,cResultCode).
    
 END.
 ELSE DO:
   /* Un register dynamic object in property sheet */
   IF VALID-HANDLE(_h_menubar_proc) THEN
       RUN Unregister_PropSheet IN _h_menubar_proc (_h_win,"*") NO-ERROR. 
   
 END.
 RUN display_current IN THIS-PROCEDURE.
 DELETE OBJECT ttHL NO-ERROR.
END PROCEDURE. /* choose_file_save_as_static */


PROCEDURE choose_goto_page:
/*------------------------------------------------------------------------------
  Purpose: change the page number shown for the current window     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if IdeIntegrated then   
      runDialog(_h_win,"gotoPage":U).
  else
      run do_goto_page.     
END PROCEDURE. /* choose_goto_page */


PROCEDURE choose_import_fields :
/*------------------------------------------------------------------------------
  Purpose:  load fields (and their VIEW-AS) from the database   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VAR drawn AS LOGICAL INITIAL FALSE NO-UNDO.
  DEFINE VAR tfile AS CHARACTER NO-UNDO.
  IF NUM-DBS = 0 THEN DO:
    RUN adecomm/_dbcnnct.p (
      "You must have at least one connected database to insert database fields.",
      OUTPUT ldummy).
    IF ldummy EQ NO THEN RETURN.
  END.
  IF _h_frame = ? THEN DO:
    /* Assume the first frame in the window (if there is one). */
    FIND _U WHERE _U._TYPE EQ "FRAME":U
              AND _U._STATUS NE "DELETED":U
              AND _U._WINDOW-HANDLE EQ _h_win NO-ERROR.
    IF AVAILABLE _U THEN _h_frame = _U._HANDLE.
    ELSE DO:
      if OEIDEIsRunning then
        ShowMessageInIDE("Please select a frame in which to insert database fields.",
                      "Information",?,"OK",YES).
      else  
      MESSAGE "Please select a frame in which to insert database fields."
             VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END.
  END.

  drawn = FALSE.
  RUN setstatus (?, "Choose fields.").

  IF LDBNAME("DICTDB":U) = ? OR DBTYPE("DICTDB":U)NE "PROGRESS":U THEN
  FIND-PRO:
  DO i = 1 TO NUM-DBS:
    IF DBTYPE(i) = "PROGRESS":U THEN DO:
      CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(LDBNAME(i)).
      LEAVE FIND-PRO.
    END.
  END.

  RUN adeuib/_drwflds.p (INPUT "", INPUT-OUTPUT drawn, OUTPUT tfile).
  IF drawn THEN DO:
    RUN setstatus ("WAIT":U, "Inserting fields...").
    SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    RUN adeuib/_qssuckr.p (tfile, "", "IMPORT", TRUE).
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

    /* When drawing a data field for an object that is using a SmartData
       object, set the data field's Enable property based on the data object
       getUpdatableColumns. Must do this here since its not picked up automatically
       in the temp-table definition like format and label.  jep-code 4/29/98 */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    IF (AVAILABLE _P) AND (_P._data-object <> "") THEN
      RUN setDataFieldEnable IN _h_uib (INPUT RECID(_P)).

    RUN display_current.

    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).

    /* set the file-saved state to false */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    /*
     * Delete the temp file
     */
    OS-DELETE VALUE(tfile) NO-ERROR.
  END.
  SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
  RUN setstatus ("":U, "":U).  /* Reset status and wait-cursor */
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE. /* choose_import_fields */


PROCEDURE choose_import_file :
/*------------------------------------------------------------------------------
  Purpose: Import an exported file    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if IdeIntegrated then   
      runDialog(_h_win,"importFile":U).
  else
      run do_import_file.   
END PROCEDURE. /* choose_import_file */


PROCEDURE choose_insert_trigger :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Choose Event dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
/*  IF NOT mi_insert_trigger:SENSITIVE THEN RETURN NO-APPLY.*/
  
  if IdeIntegrated then
      AddTrigger(_h_win,cur_widg_name,cur-widget-type).
/*      runDialog(_h_win,"insertTrigger":U).*/
  else
      run do_insert_trigger.   
   
END PROCEDURE. /* choose_insert_trigger */


PROCEDURE choose_insert_procedure :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Add Procedure dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
  IF NOT mi_insert_procedure:SENSITIVE THEN RETURN NO-APPLY.
  if IdeIntegrated then   
      AddCodeSection(_h_win,"PROCEDURE").
/*      runDialog(_h_win,"insertProcedure":U).*/
  else
      run do_insert_procedure.   
END PROCEDURE. /* choose_insert_procedure */


PROCEDURE choose_insert_function :
/*------------------------------------------------------------------------------
  Purpose:   bring up the Add Function dialog from the Section Editor 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF NOT OEIDEIsRunning THEN RETURN NO-APPLY.
  IF NOT mi_insert_function:SENSITIVE THEN RETURN NO-APPLY.
  if IdeIntegrated then  
       AddCodeSection(_h_win,"FUNCTION").
/*       runDialog(_h_win,"insertFunction":U).*/
   else
       run do_insert_function .     

END PROCEDURE. /* choose_insert_function */


PROCEDURE choose_mru_file :
/*------------------------------------------------------------------------------
  Purpose: opens file from the MRU Filelist    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ifile AS INTEGER NO-UNDO.

  DEFINE VARIABLE cTempFile   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE glScrap     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE h_curwin    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lFileError  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOpenObject AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lStayList   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE relPathName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFileName   AS CHARACTER NO-UNDO.

  FIND _mru_files WHERE _mru_files._position = ifile NO-ERROR.
  IF AVAILABLE _mru_files THEN DO:

    ASSIGN h_curwin = _h_win.

    /* Deselect the currently selected widgets */
    RUN deselect_all (?, ?).

    IF _mru_files._broker <> "" THEN DO:
      
      /* for web files, this may include the path, so need to pass full
         path name to _webcom.w 
      */
      ASSIGN cFileName = ws-get-absolute-path (INPUT _mru_files._file).
      
      RUN adeweb/_webcom.w (?, _mru_files._broker, cFileName, "open",
        OUTPUT relpathname, INPUT-OUTPUT ctempfile).

      IF RETURN-VALUE BEGINS "ERROR":U THEN
      DO:
        /* _mru_files._file may have info to construct the full path name.
           For the error message, we just want the relative path name, if available.
        */        
        IF INDEX(RETURN-VALUE,"Not readable":U) NE 0 THEN
          RUN adecomm/_s-alert.p (INPUT-OUTPUT glScrap, "error":U, "ok":U,
            SUBSTITUTE("Cannot open &1.  WebSpeed agent does not have read permission.",
            ws-get-relative-path (INPUT _mru_files._file) )).

        IF INDEX(RETURN-VALUE,"File not found":U) NE 0 THEN
        do:
          if OEIDEIsRunning then
            ShowMessageInIDE(ws-get-relative-path (INPUT _mru_files._file) + " not found in WebSpeed agent PROPATH.",
                      "Information",?,"OK",YES).
          else  
          MESSAGE ws-get-relative-path (INPUT _mru_files._file) "not found in WebSpeed agent PROPATH."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        end.
        DELETE _mru_files.
        RUN adeshar/_mrulist.p("":U, "":U).
        lFileError = TRUE.
      END. /* if return-value begins 'error' */
      ELSE _mru_broker_url = _mru_files._broker.  /* need to set _mru_broker_url so that
                                                     the remote file can be opened on the
                                                     broker it was saved to - not necessarily
                                                     the current broker url */
    END.  /* if broker <> "" - remote file */
    ELSE DO:
      /* jep-icf IZ 2342 If ICF, look for the MRU file in the repository. Currently Works for dynamic object only. */
      IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
      DO:
         ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
         IF VALID-HANDLE(ghRepositoryDesignManager) THEN
            ASSIGN lOpenObject  = DYNAMIC-FUNCTION("openRyObjectAB" IN ghRepositoryDesignManager, INPUT _mru_files._file)
                   lFileError   = (lOpenObject = NO).

      END.
      /* IZ 2342 If not ICF or can't find the repository object, look for the MRU file in the file system. */
      IF NOT CAN-DO(_AB_Tools, "Enable-ICF":u) OR lFileError THEN
      DO:
          ASSIGN FILE-INFO:FILE-NAME = _mru_files._file.
          ASSIGN lFileError = (FILE-INFO:FILE-TYPE = ?).
      END.

      IF lFileError THEN DO:
        if OEIDEIsRunning then
            ShowMessageInIDE(_mru_files._file + "cannot be found.",
                      "Error",?,"OK",YES).
        else   
        MESSAGE _mru_files._file "cannot be found." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        DELETE _mru_files.
        RUN adeshar/_mrulist.p("":U, "":U).
        lFileError = TRUE.
      END.  /* if file type = ? */
    END.  /* else - local file */

    IF NOT lFileError THEN DO:
      IF lOpenObject THEN
        RUN setstatus (?, "Opening object...").
      ELSE
        RUN setstatus (?, "Opening file...").

      RUN adeuib/_open-w.p (TRIM(_mru_files._file), TRIM(cTempFile), "WINDOW":U).
    END.  /* if not file error */

    /* Need to re-set _mru_broker_url to blank after file has been opened */
    _mru_broker_url = "".

    RUN setstatus ("":U, "":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.

    /* If no file was opened, leave now. */
    IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.

    /* Show the property sheet of a dynamic repository object. */
    IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
    DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
      IF AVAILABLE(_P) AND (NOT _P.static_object) AND
               LOOKUP("DynView":U,_P.parent_classes)= 0
           AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
           AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
           AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0  THEN
         RUN choose_prop_sheet IN _h_UIB.
    END.

    /* Special Sanity check -- sanitize our records.  Always do this (even if
     the user cancelled the file open)  */
    RUN adeuib/_sanitiz.p.

  END.  /* if avail mru files */

END PROCEDURE.  /*choose_mru_file */


PROCEDURE choose_new_adm2_class :
/*------------------------------------------------------------------------------
  Purpose: create a new ADM2 class    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   if OEIDEIsRunning then
      run adeuib/ide/_dialog_clasnew.p.
   else
   RUN adeuib/_clasnew.w.
END PROCEDURE.


PROCEDURE choose_new_pw :
/*------------------------------------------------------------------------------
  Purpose: creates a new Procedure Window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DO ON STOP UNDO, LEAVE:
    RUN adecomm/_pwmain.p ("_ab.p":U /* PW Parent ID */,
                           ""  /* Files to open */,
                           ""  /* PW Command */ ).
  END.

END PROCEDURE. /* choose_new_pw */


PROCEDURE choose_object_open :
/*------------------------------------------------------------------------------
  Purpose: called by File/Open Object to Open Repository Object     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*prevent accelerator when in ide   */
  if IDEIntegrated then 
      return.
  RUN choose_open (INPUT "OBJECT":u).

END PROCEDURE.  /* choose_object_open */

/** called from _oideuib - generates .wrx,  refreshes smartobjects and sends save event, 
*  pcfile - file name (used to open silently if no handle passed)
*  phhandle the handle of the design window (if open)
*/
PROCEDURE ide_texteditor_save_event  :
    define input  parameter pcFile   as character no-undo.
    define input  parameter phhandle as handle no-undo.
    define variable lSilentOpen    as logical no-undo.
    
    if valid-handle(OEIDE_ABSecEd) then
    do:
        if phHandle = ? then
        do:
            /* No window open -  run the _qssuckr to open the file silently */       
            RUN adeuib/_qssuckr.p (pcFile,"","Window-Silent", FALSE).        
            phhandle = _h_win.
            lSilentOpen = true.
        end.
        run saveFileEvent IN OEIDE_ABSecEd (phhandle).
    end.
    finally:
        /** close if silent open 
           To keep this around we would need to be able to make it visible and embedd in eclipse if 
           design window is opened while it is alive 
           @TODO this is likely not very difficult in uib , but may also require work on java side to deal with linking   */ 
        if lSilentOpen then 
           run wind-close (phhandle).      
                
    end finally.
   
END PROCEDURE.

/** pctype - 'Procedures' or 'Functions'
*   pcfile - file name (used to open silently if no handle passed)
*   phhandle - the handle of the design window (if open)
*   out response - list of overridable procedures or functions (supports adm1)
*/
PROCEDURE ide_get_overrides  :
    define input  parameter pcType   as character no-undo.
    define input  parameter pcFile   as character no-undo.
    define input  parameter phhandle as handle no-undo.
    define output parameter response as longchar  no-undo.
    define variable cSection as character no-undo.
    define variable lSilentOpen    as logical no-undo.
    cSection = if pcType = "Procedures" then "_PROCEDURE" else "_FUNCTION".
    
    if phHandle = ? then
    do:
        /* No window open -  run the _qssuckr to open the file silently */       
        RUN adeuib/_qssuckr.p (pcFile,"","Window-Silent", FALSE).        
        phhandle = _h_win.
        lSilentOpen = true.
    end.
    
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
       RUN GetOverrides IN OEIDE_ABSecEd (phhandle,cSection, output response).
    
    finally:
        /** close if silent open 
           To keep this around we would need to be able to make it visible and embedd in eclipse if 
           design window is opened while it is alive 
           @TODO this is likely not very difficult in uib , but may also require work on java side to deal with linking   */ 
        if lSilentOpen then 
           run wind-close (phhandle).      
        		
    end finally.
   
END PROCEDURE.

/** pclinkedfilename - linked file name
*   pcfile - file name (used to open silently if no handle passed)
*   phhandle - the handle of the design window (if open)
*/
PROCEDURE ide_syncFromFile :
    define input  parameter pcLinkedFileName  as character no-undo.
    define input  parameter phhandle as handle no-undo.
    define variable lSilentOpen    as logical no-undo.
    
/*    /* not used by ide - somewhat unlikely and requires management of linked file by caller  */*/
/*    if phHandle = ? then                                                                       */
/*    do:                                                                                        */
/*        /* No window open -  run the _qssuckr to open the file silently */                     */
/*        RUN adeuib/_qssuckr.p (pcFile,"","Window-Silent", FALSE).                              */
/*        phhandle = _h_win.                                                                     */
/*        lSilentOpen = true.                                                                    */
/*    end.                                                                                       */
    
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
       RUN syncFromIDE IN OEIDE_ABSecEd (phHandle,pcLinkedFileName).
    
/*    finally:                                                                                                                */
/*        /** close if silent open                                                                                            */
/*           To keep this around we would need to be able to make it visible and embedd in eclipse if                         */
/*           design window is opened while it is alive                                                                        */
/*           @TODO this is likely not very difficult in uib , but may also require work on java side to deal with linking   */*/
/*        if lSilentOpen then                                                                                                 */
/*           run wind-close (phhandle).                                                                                       */
/*                                                                                                                            */
/*    end finally.                                                                                                            */
   
END PROCEDURE.


/** pclinkedfilename - linked file name
*   pcfile - file name (used to open silently if no handle passed)
*   phhandle - the handle of the design window (if open)
*/
PROCEDURE ide_syncFromAppbuilder :
    define input  parameter pcLinkedFileName  as character no-undo.
    define input  parameter pcFile   as character no-undo.
    define input  parameter phhandle as handle no-undo.
    define variable lSilentOpen    as logical no-undo.
    
    /* not used by ide - requires management of linked file by caller  */
    if phHandle = ? then
    do:
        /* No window open -  run the _qssuckr to open the file silently */       
        RUN adeuib/_qssuckr.p (pcFile,"","Window-Silent", FALSE).        
        phhandle = _h_win.
        lSilentOpen = true.
    end.
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
       RUN syncFromAppbuilder IN OEIDE_ABSecEd (phHandle,pcLinkedFileName).
    
    finally:
        /** close if silent open 
           To keep this around we would need to be able to make it visible and embedd in eclipse if 
           design window is opened while it is alive 
           @TODO this is likely not very difficult in uib , but may also require work on java side to deal with linking   */ 
        if lSilentOpen then 
           run wind-close (phhandle).      
                
    end finally.
   
END PROCEDURE.

procedure debugshowstuff :
    define buffer b_u for _u.
    define buffer b_trg for _trg.
     define variable cc as character no-undo.
     
     for each b_u:
             cc = cc + chr(10)
             + "u: " + b_u._name +   " type:  " + b_u._type  
            + " parent " +    (if b_U._PARENT = ? then  "?" else string(b_U._PARENT))  +  "wh  " + string(b_u._WINDOW-HANDLE) + " def " + b_U._DEFINED-BY + " stat " + b_U._STATUS.
    end.

/*    for each b_u:                                                                                        */
/*        for each b_trg where  b_TRG._wRECID   EQ RECID(b_U):                                             */
/*          cc = cc + chr(10)                                                                              */
/*             + "u: " + b_u._name                                                                         */
/*             + " section: " + b_TRG._tSECTION + " event: " + b_TRG._tEVENT + " status: " + b_TRG._STATUS.*/
/*        end.                                                                                             */
/*    end.                                                                                                 */
    message cc
    view-as alert-box.
end.

/** get the override body with parameters 
*   pctype - 'Procedures' or 'Functions'
*   pcfile - file name (used to open silently if no handle passed)
*   phhandle - the handle of the design window (if open)
*   pcname = procedure or function name to override - (adm1 supported returns local- for adm--) 
*   out response - code body  (no block start and end and no top comments )
*/
PROCEDURE ide_get_override_body  :
    define input  parameter pcType   as character no-undo.
    define input  parameter pcFile   as character no-undo.
    define input  parameter phhandle as handle no-undo.
    define input  parameter pcname   as character no-undo.
    define output parameter response as longchar  no-undo.
    define variable cSection as character no-undo.
    define variable lSilentOpen    as logical no-undo.
    cSection = if pcType = "Procedures" then "_PROCEDURE" else "_FUNCTION".
    
    if phHandle = ? then
    do:
        /* No window open -  run the _qssucker to open the file silently */       
        RUN adeuib/_qssuckr.p (pcFile,"","Window-Silent", FALSE).        
        phhandle = _h_win.
        lSilentOpen = true.
    end.
    
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
       RUN GetOverrideBody IN OEIDE_ABSecEd (phhandle,cSection,pcname, output response).
    
    finally:
        if lSilentOpen then 
           run wind-close (phhandle).      
                
    end finally.
   
END PROCEDURE.




PROCEDURE ide_choose_object_open :
/*------------------------------------------------------------------------------
  Purpose: called by _oeideuib to Open Repository Object     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable cFile as character no-undo.
    define variable pressed-ok as logical no-undo.
    define variable cRelname as character no-undo.
    define variable cRelnamefull as character no-undo.
    define variable lDynPropSheet as logical no-undo.
  
    /* Deselect the currently selected widgets */
    RUN deselect_all (?, ?).
    
    RUN adecomm/_getobject.p ( _h_menu_win   /* Window Handle             */
                              , ""            /* Product Module            */
                              ,YES           /* Open in AppBuilder        */
                              ,"Open Object" /* Title to display          */
                              ,OUTPUT cFile    /* Name of File being opened */
                              ,OUTPUT pressed-ok   /* Pressed OK on selection   */
                              ).
    if pressed-ok then
    do:                         
        find _RyObject where _RyObject.OBJECT_filename = cFile no-error.
        if avail _ryobject then 
        do: 
            if _RyObject.static_object then
            do:
                assign
                    cRelName =  _RyObject.object_path 
                              + (if _RyObject.object_path = "" then "" else "~/":U) 
                                 + cFile
                                 + (if num-entries(cFile,".") le 1 and _RyObject.object_extension <> "" 
                                    then "." + _RyObject.object_extension 
                                    else "")
                   file-info:file-name = cRelName              
                   cRelNameFull        = file-info:full-pathname
                   cRelNameFull        = replace(cRelNameFull,"~\":U,"/":U) .   
                openDesignEditor(getProjectName(),cRelNameFull).
            end.
            else do:
                openDynamicsEditor(getProjectName(),cFile).
            end.
        end.
    end.
     
END PROCEDURE.  /* choose_object_open */


PROCEDURE choose_open :
/*------------------------------------------------------------------------------
  Purpose: Displays Open File or Open Object dialog and performs the open     
 
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pOpenMode AS CHARACTER NO-UNDO.
  /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  
  DEFINE VARIABLE cTempFile    AS CHARACTER              NO-UNDO.
  DEFINE VARIABLE h_curwin     AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE h_active_win AS HANDLE                 NO-UNDO.
  DEFINE VARIABLE lnth_sf      AS INTEGER                NO-UNDO.
  DEFINE VARIABLE pressed-ok   AS LOGICAL                NO-UNDO.
  DEFINE VARIABLE cOpenMsg     AS CHARACTER              NO-UNDO.
  DEFINE VARIABLE hRepDesignManager  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE cAbort       AS CHARACTER              NO-UNDO.

  ASSIGN
    h_curwin = _h_win.

  /* Deselect the currently selected widgets */
  RUN deselect_all (?, ?).

  CASE pOpenMode:
    WHEN "FILE":U
      THEN DO:
        /* Get a file name to open. */
        /* If WebSpeed is licensed, call web file dialog, unless user has also licensed Enterprise and wants local file management. */
        IF _AB_license > 1
        AND _remote_file
        THEN
          RUN adeweb/_webfile.w (INPUT "uib":U
                                ,INPUT "Open":U
                                ,INPUT "Open":U
                                ,INPUT "":U
                                ,INPUT-OUTPUT open_file
                                ,OUTPUT cTempFile
                                ,OUTPUT pressed-ok
                                ).

        IF _AB_license = 1
        OR NOT _remote_file
        OR RETURN-VALUE = "HTTPFailure":U
        THEN
          RUN adecomm/_getfile.p(INPUT CURRENT-WINDOW
                                ,INPUT "uib"
                                ,INPUT "Open"
                                ,INPUT "Open"
                                ,INPUT "OPEN"
                                ,INPUT-OUTPUT open_file
                                ,OUTPUT pressed-ok
                                ).
        ASSIGN
          cOpenMsg = "Opening file...".
       /* Check whether the file is registered in the repository */
       IF pressed-ok AND CAN-DO(_AB_Tools, "Enable-ICF":U) THEN
       DO:
         hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
         IF VALID-HANDLE(hRepDesignManager) THEN
            DYNAMIC-FUNCTION("openRyObjectAB" IN hRepDesignManager, INPUT open_file).
       END.


      END.

    WHEN "OBJECT":U
    THEN DO:
      /* jep-icf: If ICF is running, get an object name to open using Open dialog. */
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)
      THEN DO:
        RUN adecomm/_getobject.p (INPUT _h_menu_win   /* Window Handle             */
                                 ,INPUT ""            /* Product Module            */
                                 ,INPUT YES           /* Open in AppBuilder        */
                                 ,INPUT "Open Object" /* Title to display          */
                                 ,OUTPUT open_file    /* Name of File being opened */
                                 ,OUTPUT pressed-ok   /* Pressed OK on selection   */
                                 ).

        ASSIGN
          cOpenMsg = "Opening object...".
      END.
    END.

  END CASE.

  IF pressed-ok THEN
  DO:
    RUN setstatus (?, cOpenMsg).
        
    RUN adeuib/_open-w.p (open_file, cTempFile, "WINDOW":U).
    IF _DynamicsIsRunning AND RETURN-VALUE > "" AND NOT RETURN-VALUE BEGINS  "_":U THEN
    DO:
       RUN showMessages IN gshSessionManager (INPUT RETURN-VALUE,
                                                  INPUT "ERR":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "OK":U,
                                                  INPUT "Object Open Error",
                                                  INPUT YES,
                                                  INPUT ?,
                                                 OUTPUT cAbort).
       RETURN RETURN-VALUE.
    END.

    IF RETURN-VALUE > "" THEN RETURN RETURN-VALUE.

    /* In case of _qssuckr failure, reset the cursors . */
    RUN setstatus ("":U, "":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.

    /* If no file was opened, leave now. */
    IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.
  END.

  /* Show the property sheet of a dynamic repository object. */
  IF (_h_win <> ?) AND (_h_win <> h_curwin) THEN
  DO:
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
    IF AVAILABLE(_P) AND (NOT _P.static_object) AND
              LOOKUP("DynView":U,_P.parent_classes)= 0
          AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
          AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
          AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0  THEN
      RUN choose_prop_sheet IN _h_UIB.
  END.

  /* Special Sanity check -- sanitize our records.  Always do this (even if
   the user cancelled the file open)  */
  RUN adeuib/_sanitiz.p.

END PROCEDURE.    /* choose_open */


PROCEDURE choose_paste :
/*------------------------------------------------------------------------------
  Purpose: called by Edit/Paste; PASTE Accelerators     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cvCurrentSaveFile AS CHARACTER.
  DEFINE VARIABLE temp_file         AS CHARACTER.
  DEFINE VARIABLE dummy             AS LOGICAL.
  DEFINE VARIABLE Clip_Multiple     AS LOGICAL    NO-UNDO INIT FALSE.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
  /* ADE only works with a single clipboard format - text only. */
  ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
         CLIPBOARD:MULTIPLE = FALSE.

  ASSIGN temp_file = CLIPBOARD:VALUE NO-ERROR.  /* Using temp_file */
  IF temp_file = "" OR temp_file = ? THEN
    if OEIDEIsRunning then
            ShowMessageInIDE("The clipboard is empty, there are no objects to paste.",
                             "Information",?,"OK",YES).
    else   
    MESSAGE "The clipboard is empty, there are no objects to paste."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE DO:
  /* we have to check for the clipbaord format, before we save the stuff */


    RUN adecomm/_tmpfile.p ({&STD_TYP_UIB_CLIP},
                                {&STD_EXT_UIB}, OUTPUT temp_file).
    cvCurrentSaveFile = _save_file.

    _clipboard_editor:SCREEN-VALUE IN FRAME _clipboard_editor_frame = "".
    _clipboard_editor:SCREEN-VALUE IN FRAME _clipboard_editor_frame = CLIPBOARD:VALUE.
    dummy = _clipboard_editor:SAVE-FILE(temp_file)
                IN FRAME _clipboard_editor_frame.

    /*
     * Check to see if the contents of the clipboard contain stuff that
     * we understand
     */

    IF  (ENTRY(1, _clipboard_editor:SCREEN-VALUE, " ") = "&ANALYZE-SUSPEND")
    AND (ENTRY(2, _clipboard_editor:SCREEN-VALUE, " ") = "_EXPORT-NUMBER") THEN DO:

      /* Make sure the OCX control file is retrieved. Windows 3.1 only. */
      IF (OPSYS = "WIN32":u) THEN ASSIGN _control_cb_op = TRUE.

      RUN adeuib/_qssuckr.p(temp_file, "", "IMPORT":U, FALSE).
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      WidgetAction = "Add".
      RUN display_current.
      WidgetAction = "".
      /* SEW Update after adding widgets in UIB. */
      RUN call_sew ("SE_ADD":U).

      OS-DELETE VALUE((SUBSTR(temp_file, 1, R-INDEX(temp_file, ".") - 1) + {&STD_EXT_UIB_QS})).
      _save_file = cvCurrentSaveFile.

      IF OPSYS = "WIN32":u THEN ASSIGN _control_cb_op = FALSE.

      /* set the file-saved state to false, since we just pasted object(s) */
      RUN adeuib/_winsave.p(_h_win, FALSE).
    END.
    ELSE DO:
      IF CAN-DO(_AB_Tools, "Enable-ICF":U)  THEN
      APPLY LASTKEY TO SELF.
      ELSE
      do:
         if OEIDEIsRunning then
            ShowMessageInIDE("The contents of the clipboard cannot be pasted into the design window.",
                             "Information",?,"OK",YES).
         else  
         MESSAGE "The contents of the clipboard cannot be pasted into the design window."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      end.        
    END.
    OS-DELETE VALUE(temp_file).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.
  END.
  END. /* DO ON STOP */

  /* Restore clipboard multiple value. */
  ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple.
END PROCEDURE. /* choose_paste   */


PROCEDURE choose_proc_settings :
/*------------------------------------------------------------------------------
  Purpose:  bring up the property sheet for current procedure   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VAR cur_page AS INTEGER NO-UNDO.
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    /* Save the current page incase the user changes it. */
    
    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    cur_page = _P._page-current.
    if IDEIntegrated then 
        run adeuib/ide/_dialog_edtproc.p(_h_win).
    else    
        RUN adeuib/_edtproc.p (_h_win).
    
    APPLY "ENTRY" TO _h_win. 
    IF cur_page NE _P._page-current THEN RUN display_page_number.
    
  END.
END PROCEDURE.

/* some code calls property_sheet directly */ 
PROCEDURE choose_prop_sheet :
/*------------------------------------------------------------------------------
  Purpose:  bring up the property sheet - redirect from ide if integrated   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* the ide will use UIBDialogCommnad that makes the IDE modal 
      before calling back to openPropertySheet in _oeideuib and then
      do_choose_prop_sheet, which calls do_property_sheet */
   if IDEIntegrated then
   do:
       openPropertySheet(_h_win) .
   end.
   else 
       run do_choose_prop_sheet. 
 END PROCEDURE.

/* called directly from choose or from ide if integrated */ 
PROCEDURE do_choose_prop_sheet :
/*------------------------------------------------------------------------------
  Purpose:  bring up the property sheet   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_cur_widg <> ? THEN
  do: 
      /* APPLY "ENTRY" TO _h_menu_win.  */
      APPLY "ENTRY" TO _h_cur_widg.
      RUN do_property_sheet (_h_cur_widg).
      APPLY "ENTRY" TO _h_cur_widg.
      
    
  end.    
  ELSE 
  do:
      if OEIDEIsRunning then
            ShowMessageInIDE("No object is currently selected. ~n
                             Please select an object with the pointer and try again.",
                             "Information",?,"OK",YES).
      else
      MESSAGE "No object is currently selected." {&SKP}
              "Please select an object with the pointer and try again."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  end.          
END PROCEDURE.

procedure choose_reg_in_repos :
    run choose_reg_in_repos in _h_menubar_proc.
end procedure.

PROCEDURE choose_run :
/*------------------------------------------------------------------------------
  Purpose: called by F2 or Compile/Run    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if OEIDEIsRunning then
  RunDesign(_h_win).
  else
  RUN call_run ("RUN").
END PROCEDURE.

   
PROCEDURE choose_show_palette :
/*------------------------------------------------------------------------------
  Purpose:  This shows or hides the tool palette   
  Parameters:  <none>
  Notes:   called by CTRL-T or Windows/Show Tool Palette.     
------------------------------------------------------------------------------*/
 DEFINE VAR h AS WIDGET  NO-UNDO.
    /*prevent accelerator when in ide  (was not able to fix this by setting accelerator = "" or ? ) */
  if IDEIntegrated then 
      return.
  IF _AB_License EQ 2 THEN RETURN.
  h = mi_show_toolbox.
  IF _h_object_win:VISIBLE THEN
    ASSIGN _h_object_win:HIDDEN = YES
           h:LABEL              = "Show Object &Palette".
  ELSE DO:
    /* Restore iconinized (Minimized) palette. (Note we have to apply
       the WINDOW-RESTORED event manually because it won't fire in
       this case.)  */
    IF _h_object_win:WINDOW-STATE = WINDOW-MINIMIZED THEN DO:
      _h_object_win:WINDOW-STATE = WINDOW-NORMAL.
      APPLY "WINDOW-RESTORED":U TO _h_object_win.
    END.
    /* Show the palette window */
    ASSIGN _h_object_win:HIDDEN  = NO
           ldummy                = _h_object_win:MOVE-TO-TOP()
           h:LABEL               = "&Hide Object Palette".
  END.
END PROCEDURE. /* choose_show_palette */

PROCEDURE choose_tab_edit :
/*------------------------------------------------------------------------------
  Purpose: fires off the tab-editor    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if IdeIntegrated then   
      runDialog(_h_win,"tabOrder":U).
  else
    run do_tab_edit.   
END PROCEDURE.


PROCEDURE choose_tempdb_maint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Called from selecting TEMP-DB Maintenance Tool in the Tools menu      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cChoice AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK     AS LOGICAL   NO-UNDO.

  ASSIGN Db_Pname = "TEMP-DB":U
                           Db_Lname = ?
                           Db_Type  = "PROGRESS".

  IF NOT CONNECTED("TEMP-DB":U) THEN
  DO:
     RUN adeuib/_advisor.w (
                    INPUT "This utility requires a connection to the 'TEMP-DB' database."
                     + CHR(10) + "Would you like to connect to this database?",
                    INPUT  "Co&nnect.  Connect to '" + 'TEMP-DB' + "' now.,_CONNECT,
&Cancel.  Do not start this utility.,_CANCEL" ,
                    INPUT FALSE,
                    INPUT "",
                    INPUT 0,
                    INPUT-OUTPUT cChoice,
                    OUTPUT ldummy ).
     IF cChoice = "_CONNECT":U THEN
             RUN adecomm/_dbconn.p
                     (INPUT-OUTPUT  Db_Pname,
                            INPUT-OUTPUT  Db_Lname,
                            INPUT-OUTPUT  Db_Type).
  END.

  IF NOT CONNECTED("TEMP-DB":U) THEN
    RETURN "ERROR":U.

  IF NOT VALID-HANDLE(hTempDB) THEN
  DO:
      SESSION:SET-WAIT-STATE('GENERAL':U).
      RUN adeuib/_TempDBCheck.p (OUTPUT lOK).       
      IF lOK THEN
      DO:
         RUN adeuib/_tempdb.w PERSISTENT SET hTempDB .
         RUN initializeObject IN hTempDB.
      END.  
      SESSION:SET-WAIT-STATE('':U). 
  END.
  ELSE 
    RUN MoveToTop IN hTempDB.

END PROCEDURE.

PROCEDURE ide_choose_template :
/*------------------------------------------------------------------------------
  Purpose:  called from ide  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define output parameter pAbsoluteFileName as character no-undo.
  DEFINE VARIABLE cFileName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK               AS LOGICAL   NO-UNDO.
 
  RUN adeuib/ide/_dialog_fndfile.p (INPUT "Choose Other Template",             /* pTitle            */
                                        INPUT "TEMPLATE",                          /* pMode             */
                                        INPUT "Windows (*.w)|*.w|All Files|*.*":U, /* pFilters          */
                                        INPUT-OUTPUT {&TEMPLATE-DIRS},             /* pDirList          */
                                        INPUT-OUTPUT cFileName,                    /* pFileName         */
                                        OUTPUT       pAbsoluteFileName,            /* pAbsoluteFileName */
                                        OUTPUT       lOK).                         /* pOK               */
  
  /* probably not necessary */
  IF not lOK then 
      pAbsoluteFileName = "".
       

END PROCEDURE. /* choose_template */

PROCEDURE choose_template :
/*------------------------------------------------------------------------------
  Purpose:  called by 'New' popup menu   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pFileName         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pAbsoluteFileName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE pOK               AS LOGICAL   NO-UNDO.

  RUN adecomm/_fndfile.p (INPUT "Choose Other Template",             /* pTitle            */
                          INPUT "TEMPLATE",                          /* pMode             */
                          INPUT "Windows (*.w)|*.w|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&TEMPLATE-DIRS},             /* pDirList          */
                          INPUT-OUTPUT pFileName,                    /* pFileName         */
                          OUTPUT       pAbsoluteFileName,            /* pAbsoluteFileName */
                          OUTPUT       pOK).                         /* pOK               */
  IF pOK AND pAbsoluteFileName <> "" THEN
    RUN adeuib/_open-w.p (pAbsoluteFileName, "", "UNTITLED":U).

END PROCEDURE. /* choose_template */


PROCEDURE choose_uib_browser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: First we deselect everything, because"
      1) the browser doesn't show the cur_widg [due to 7.1C browser limitation
         setting the CURRENT-ITERATION.
      2) we need to have nothing selected for the reinstantiation logic to work
         (in case user goes into a property sheet and changes NO-BOX, for example)
         selected objects .       
------------------------------------------------------------------------------*/

   IF NOT CAN-FIND(FIRST _U) THEN DO:
     if OEIDEIsRunning then
            ShowMessageInIDE("There are no objects to list.",
                             "Information",?,"OK",YES).
     else  
     MESSAGE "There are no objects to list." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
     RETURN.
   END.
   RUN deselect_all (?, ?).  /* 7.1C needed for our new reinstantiation logic */

   /* SEW call to store current trigger code for specific window. */
   RUN call_sew ("SE_STORE_WIN":U).
   RUN adeuib/_uibrows.p.

   IF VALID-HANDLE(_h_cur_widg) THEN DO:
     /*The no-error and the return no-apply were added for the fix of OE00120832.
       The FIND fails if _h_cur_widg is the window itself. This won't happen once an object is selected either in
       the window or in the object lists, h_cur_widg will always return an object
       type that could be found in _U.*/
     FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
     IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
     IF _U._LAYOUT-NAME NE "Master Layout"  AND _U._TYPE = "TEXT" THEN DO:
       /* Can't select a text widget in an alternate layout */
       FIND _U WHERE _U._HANDLE = _h_frame.
       ASSIGN _h_cur_widg = _h_frame.
     END.
     /* If removed from layout everywhere, delete it */
     IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                                NOT _L._REMOVE-FROM-LAYOUT) AND
                                NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU",_U._TYPE) AND
                                _U._STATUS = "NORMAL" THEN RUN choose_erase.

     RUN display_current.

     /* Pop the window with the current widget to the top and make it active. */
     ldummy = _h_win:MOVE-TO-TOP ().
     APPLY "ENTRY":U TO _h_win.  /* See bug #94-06-13-04 */
   END.

   /* SEW Update after adding widgets in UIB. */
   RUN call_sew ("SE_PROPS":U).

END PROCEDURE.


PROCEDURE choose_undo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  called by CTRL-Z or Edit/Undo     
------------------------------------------------------------------------------*/
 /* Say that we are undoing the current action (Note: the undo menu-item is
     of the form "Undo Move". */
  /* This is necessary as the CTRL-Z will fire this even if there is nothing to undo */
  IF NUM-ENTRIES(_undo-menu-item:LABEL," ":U) < 2 THEN DO:
    if OEIDEIsRunning then
       ShowMessageInIDE("There is nothing to undo.",
                        "Information",?,"OK",YES).
    else  
    MESSAGE "There is nothing to undo." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
  END.
  
  RUN setstatus ("WAIT":U, "Undoing " + ENTRY(2,_undo-menu-item:LABEL, " ":U) +
                          "...":U).   /* Show the wait-cursor  */
  RUN adeuib/_undo.p.
  RUN setstatus ("":U, " ":U).        /* Clear the wait-cursor */
  WidgetAction = "Add".
  RUN display_current.  /* Show the last widget undone */
  WidgetAction = "".
  /* SEW Update after adding/deleting widgets in UIB. */
  RUN call_sew ("SE_UNDO":U).

  FIND LAST _action NO-ERROR.
  IF (NOT AVAILABLE _action) THEN RUN DisableUndoMenu.
  ELSE RUN UpdateUndoMenu( "&Undo " +
                           SUBSTRING(_action._operation, 4, -1, "CHARACTER":U) ).
END PROCEDURE. /* choose_undo */


PROCEDURE CreateDataFieldPopup :
/*------------------------------------------------------------------------------
  Purpose: creates popup menus for all datafield objects     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER hField      AS HANDLE                    NO-UNDO.

  DEFINE VARIABLE hPopupMenu          AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hEditMaster         AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hEditInstance       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hRule               AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hCut                AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hCopy               AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hDelete             AS HANDLE                    NO-UNDO.

  CREATE MENU hPopupMenu
    ASSIGN POPUP-ONLY = TRUE.

  CREATE MENU-ITEM heditMaster
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Edit DataField &Master..."
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN editMasterDataField IN _h_uib (INPUT hField).
    END TRIGGERS.

  CREATE MENU-ITEM heditInstance
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Edit DataField &Instance..."
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN property_sheet IN _h_uib (INPUT hField).
    END TRIGGERS.

  CREATE MENU-ITEM hRule
    ASSIGN PARENT = hPopupMenu
           SUBTYPE = "Rule":U.

  CREATE MENU-ITEM hCut
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Cut"
           ACCELERATOR = "Ctrl+X"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_cut IN _h_uib.
    END TRIGGERS.

  CREATE MENU-ITEM hCopy
    ASSIGN PARENT = hPopupMenu
           LABEL  = "Copy"
           ACCELERATOR = "Ctrl+C"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_copy IN _h_uib.
    END TRIGGERS.

  CREATE MENU-ITEM hDelete
    ASSIGN PARENT = hPopupMenu
           LABEL  = "&Delete"
    TRIGGERS:
      ON CHOOSE PERSISTENT
        RUN choose_erase IN _h_uib.
    END TRIGGERS.

    ASSIGN hField:POPUP-MENU = hPopupMenu.

END PROCEDURE. /* CreateDataFieldPopup */


PROCEDURE curframe :
/*------------------------------------------------------------------------------
  Purpose:  change the currently frame and window.  
            This procedure is called when the user clicks anywhere but you 
            don't want to change the curwidg    
 
  Notes: _h_cur_widg is set to ? if the frame is different   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER h_thing AS WIDGET                         NO-UNDO.

  DEFINE VAR old_frame  AS WIDGET-HANDLE                           NO-UNDO.
  DEFINE VAR old_win    AS WIDGET-HANDLE                           NO-UNDO.
  DEFINE VAR hframe     AS WIDGET-HANDLE                           NO-UNDO.
  /* Is this widget in a frame that differs from the _h_cur_widg. */
  IF h_thing <> _h_cur_widg THEN DO:
    /* Set the current widget and check that the frame has changed */
    ASSIGN old_frame   = _h_frame
           old_win     = _h_win.

    FIND _U WHERE _U._HANDLE = h_thing NO-ERROR.
    IF NOT AVAIL _U THEN
    DO:
      /* May be a Dialog, get the frame widget handle */
      ASSIGN hFrame = h_thing:FIRST-CHILD NO-ERROR.
      FIND _U WHERE _U._HANDLE =  hFrame NO-ERROR.
      IF NOT AVAIL _U THEN RETURN.
      ELSE IF _U._TYPE = "DIALOG-BOX":U THEN
      DO:
          
        ASSIGN _h_Frame        = hFrame
               _h_win          = h_thing
               _h_cur_widg     = ?
                h_display_widg = ?
               NO-ERROR.
        RUN changewidg (hFrame, NO).
        RETURN "ERROR":U.
      END.
    END.

    _h_win = _U._WINDOW-HANDLE.
    CASE _U._TYPE:
      WHEN "WINDOW" THEN
        ASSIGN _h_frame = ?.
      /* Dialog boxes*/
      WHEN "DIALOG-BOX" THEN
        ASSIGN _h_frame = h_thing.
      /* frames (can parent to frames OR windows) */
      WHEN "FRAME" THEN
        ASSIGN _h_frame = h_thing.
      /* menus, sub-menus and menu-items */
      WHEN "MENU" OR WHEN "SUB-MENU" OR WHEN "MENU-ITEM" THEN
        ASSIGN _h_frame = ?.
      /* SmartObjects and Queries can parent to frames or windows */
      WHEN "SmartObject" OR WHEN "QUERY" THEN
        ASSIGN _h_frame = h_thing:PARENT    /* Window OR field-group */
               _h_frame = (IF _h_frame:TYPE EQ "WINDOW" THEN ?
                           ELSE _h_frame:PARENT).
      OTHERWISE
        ASSIGN _h_frame = h_thing:PARENT    /* field-group    */
               _h_frame = _h_frame:PARENT.  /* the real frame */
    END CASE.

    /* If we are in a new frame, then there is no current widget. */
    IF (_h_frame <> old_frame) THEN  _h_cur_widg = ?.

    /* Finally, if we are in a new window, update various things. */
    IF (_h_win <> old_win) THEN DO:
        _h_cur_widg    = ?.
      FIND _U WHERE _U._HANDLE = _h_win.
      FIND _L WHERE RECID(_L)  = _U._lo-recid.
      FIND _C WHERE RECID(_C)  = _U._x-recid.
      IF VALID-HANDLE(old_win) THEN ldummy = old_win:LOAD-MOUSE-POINTER("":U).
      ASSIGN  ldummy        = _h_win:LOAD-MOUSE-POINTER(IF _next_draw = ?
                                     THEN "" ELSE {&start_draw_cursor})
              _cur_win_type = _L._WIN-TYPE
              _cur_col_mult = _L._COL-MULT
              _cur_row_mult = _L._ROW-MULT
              .
      /* DESELECT everything that is selected in other windows. */
      RUN deselect_all (?, _h_win).
    END.
  END.
  RETURN .
END PROCEDURE. /* curframe */


PROCEDURE curwidg :
/*------------------------------------------------------------------------------
  Purpose: change the currently selected widget frame and window    
  Parameters:  <none>
  Notes: This procedure is called when the user clicks anywhere 
         the user selects a widget.      
------------------------------------------------------------------------------*/      
  /* Has anything changed? */
  IF SELF NE _h_cur_widg THEN DO:
    RUN curframe (SELF).
    IF RETURN-VALUE <> "ERROR":U THEN
       _h_cur_widg = SELF.
  END.
  /* Show the new current widget, if necessary. */
  IF _h_cur_widg NE h_display_widg THEN RUN display_current.
  IF VALID-HANDLE(_h_cur_widg) THEN DO:
    IF _h_cur_widg:TYPE NE "WINDOW":U AND _h_cur_widg:TYPE NE "FRAME":U THEN
      APPLY "SELECTION":U TO _h_cur_widg.
  END.
  
  if IDENotInEditor and IDEIntegrated and valid-handle(hOEIDEService) then
      activateWindow(_h_win).
 
  IDENotInEditor = false.
    
END PROCEDURE. /* curwidg */


PROCEDURE delselected :
/*------------------------------------------------------------------------------
  Purpose: deleted all selected widgets    
  Parameters:  <none>
  Notes:  the user has confirmed that this is what they want.     
------------------------------------------------------------------------------*/
  /* Delete selected FRAME and DIALOG-BOX first. */
  RUN DeleteSelectedComposite.

  /* Now delete all other selected field-level widgets. */
  FOR EACH _U WHERE _U._SELECTEDib:
    /* Do not put menus on the UNDO stack */
    IF NOT CAN-DO("MENU,MENU-ITEM,SUB-MENU", _U._TYPE) THEN DO:
      CREATE _action.
      ASSIGN _action._seq-num       = _undo-seq-num
             _action._operation     = "Delete"
             _action._u-recid       = RECID(_U)
             _action._window-handle = _U._WINDOW-HANDLE
             _undo-seq-num          = _undo-seq-num + 1.

      /* If this is an OCX control then save and remember
       * the state of the OCX in a binary file.
       */
      IF OPSYS = "WIN32":u THEN
      DO:
        DEFINE VARIABLE S AS INTEGER NO-UNDO.
        IF _U._TYPE = "{&WT-CONTROL}" THEN
        DO:
            FIND _F WHERE RECID(_F) = _U._x-recid.
            RUN adecomm/_tmpfile.p({&STD_TYP_UIB_CLIP}, {&STD_EXT_UIB_WVX},
                                   OUTPUT _F._VBX-BINARY).
/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.
            RUN ControlSaveControl IN _h_controls (_U._HANDLE,
                                                   _F._VBX-BINARY,
                                                   OUTPUT s).
*/
            _U._COM-HANDLE:SaveControls(_F._VBX-BINARY, _U._NAME).
            _F._VBX-BINARY = _F._VBX-BINARY + "," + _U._NAME.
        END.
      END.

    END.

    {adeuib/delete_u.i &TRASH = FALSE}
    
  END.  /* For each selected widget */
  /* Have we deleted the current widget? */
  RUN del_cur_widg_check.
END PROCEDURE. /* delselected */


PROCEDURE del_cur_widg_check :
/*------------------------------------------------------------------------------
  Purpose: Check to see if the "current widget" still exists    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Show the current widget, which should be empty. */
  FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  IF (NOT AVAILABLE _U) OR _U._STATUS = "DELETED" THEN DO:
    /* The current widget was deleted, find another current object */
    /* Was the current widget a field level object? */
    IF _h_cur_widg NE _h_frame AND _h_cur_widg NE _h_win THEN DO:
      _h_cur_widg = ?.
      FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
      IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
      THEN _h_cur_widg = _h_frame.
      ELSE DO:  /* No frame available, find a window */
        _h_frame = ?.
        FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
        IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
        THEN _h_cur_widg = _h_win.
        ELSE RUN adeuib/_vldwin.p (?). /* Find normal window */
      END.  /* Else find a window */
    END.  /* Deleted current widget wasn't the current frame or window */

    /* Was the current frame a deleted object? */
    ELSE IF _h_cur_widg = _h_frame THEN DO:
      ASSIGN _h_cur_widg    = ?
             _h_frame       = ?
             .
      FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
      IF (AVAILABLE _U) AND (_U._STATUS <> "DELETED")
      THEN _h_cur_widg = _h_win.
      ELSE RUN adeuib/_vldwin.p (?).
    END.  /* Current widget was a deleted frame */

    ELSE RUN adeuib/_vldwin.p (?). /* The current widget was a window */
  END.  /* The current object was deleted */

  /* Show the current window/widget (if there is one). */
  RUN display_current.

  /* IZ 1508 This call can create a Section Editor window for
     a procedure that's being closed. Only make the call if the
     procedure already has a Section Editor window open for it. - jep */
  /* jep - SEW Update after delete event in UIB. */
  IF VALID-HANDLE(hSecEd) THEN
    RUN call_sew ("SE_DELETE":U).

END PROCEDURE. /* del_cur_widg_check */


PROCEDURE deselect_all :
/*------------------------------------------------------------------------------
  Purpose: Deselect all widgets (except except_h) that are not in window 
           except_h_win      

  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAMETER except_h     AS widget NO-UNDO.
  DEF INPUT PARAMETER except_h_win AS widget NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib
                AND _U._HANDLE NE except_h
                AND _U._WINDOW-HANDLE NE except_h_win:
     _U._SELECTEDib      = FALSE.
     IF VALID-HANDLE(_U._HANDLE) THEN _U._HANDLE:SELECTED = FALSE.
  END.
END PROCEDURE. /* deselect_all */


PROCEDURE designFrame.ControlNameChanged :
/*------------------------------------------------------------------------------
  Purpose: Special trigger for Control-Frames...     
           Gets the new name of a control when it's changed in the 
           Property Editor 
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER hCtrl      AS COM-HANDLE. /* OCX Control   */
  DEFINE INPUT PARAMETER oldname    AS CHARACTER.  /* old name of control */
  DEFINE INPUT PARAMETER newname    AS CHARACTER.  /* new name of control */

  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = newname
         _U._LABEL    = newname.
  RUN Display_Current IN _h_uib.   /* update data in the Main Window */
  RUN call_sew ("SE_PROPS":U). /* notify Section Editor of change */
END PROCEDURE. /* designFrame.ControlNameChanged */


PROCEDURE designFrame.ObjectCreated :
/*------------------------------------------------------------------------------
  Purpose: Special trigger for Control-Frames...
           Grab the name of each OCX control created within a Control-Frame     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER name       AS CHARACTER.  /* name of control */

  FIND _U WHERE _U._COM-HANDLE = COM-SELF. /* the control-frame */
  ASSIGN _U._OCX-NAME = name
         _U._LABEL    = name.
END PROCEDURE. /* designFrame.ObjectCreated */


PROCEDURE dialog-close :
/*------------------------------------------------------------------------------
  Purpose: redirects this to wind-close after making sure that h_self points 
           to the proper widget (and not the dummy window itself).    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER h_self  AS WIDGET  NO-UNDO.
  IF h_self:TYPE = "WINDOW":U THEN
    h_self = h_self:FIRST-CHILD.
  RUN wind-close (h_self).
END PROCEDURE.


PROCEDURE disable_widgets :
/*------------------------------------------------------------------------------
  Purpose:  disable the UIB so that another tool can run   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h           AS WIDGET  NO-UNDO.
  DEFINE VAR ldummy      AS LOGICAL NO-UNDO.
  DEFINE VAR h-menubar   AS WIDGET  NO-UNDO.

  /* DESELECTION everything (because if we don't we might run setdeselection
     when we click in the windows we are running */
  FOR EACH _U WHERE _U._SELECTEDib AND _U._TYPE <> "WINDOW":
    _U._SELECTEDib        = FALSE.
    IF _U._STATUS <> "DELETED" THEN _U._HANDLE:SELECTED = FALSE.
  END.

  /* SEW call to hide the SEW if its visible. */
  RUN call_sew ("SE_HIDE":U).

  ASSIGN
    _h_menu_win:SENSITIVE      = NO
    _h_status_line:SENSITIVE   = NO /* Status bar has some dbl-click actions */
    h-menubar                  = _h_menu_win:MENU-BAR   /* jep-icf avoids static m_menbar ref */
    h-menubar:SENSITIVE        = NO.                    /* jep-icf avoids static m_menbar ref */

  /* Hide all children of the UIB Main window.  This should include:
         Object Palette, Design Windows, Attribute Window, Section Editor
         and Cue Cards
     Keep a list of these windows so we can show them again later. */
  ASSIGN h = _h_menu_win:FIRST-CHILD
         windows2view = "".
  DO WHILE VALID-HANDLE(h):
    IF h:TYPE EQ "WINDOW" AND h:VISIBLE THEN DO:
      IF windows2view EQ "" THEN  windows2view = STRING(h).
      ELSE windows2view = windows2view + "," + STRING(h).
      h:HIDDEN = YES.
    END.
    ASSIGN h = h:NEXT-SIBLING.
  END.
  /* Hide OCX Property Editor window. */
  RUN show_control_properties (2).

  DO WITH FRAME action_icons:
    /* Desensitize the action bar. */
    DO i = 1 TO bar_count:
      _h_button_bar[i]:SENSITIVE = NO.
    END.
    ASSIGN
      /* Store the sensitivity of the fill-in fields */
      cur_widg_text:PRIVATE-DATA = IF cur_widg_text:SENSITIVE THEN "y" ELSE "n"
      cur_widg_text:SENSITIVE    = NO
      cur_widg_name:PRIVATE-DATA = IF cur_widg_name:SENSITIVE THEN "y" ELSE "n"
      cur_widg_name:SENSITIVE    = NO.
    IF VALID-HANDLE(Mode_Button) THEN Mode_Button:SENSITIVE = NO.
    IF VALID-HANDLE(OpenObject_Button) THEN OpenObject_Button:SENSITIVE = NO.
  END.

  /* Restore the users value for THREE-D. Ditto for DATE-FORMAT. */
  ASSIGN SESSION:THREE-D     = save_3d
         SESSION:DATE-FORMAT = _orig_dte_fmt.

  /* Set Pause before-hide so that running from the UIB acts like running
     from the editor. */
  PAUSE BEFORE-HIDE.

  /* Unset UIB as active ADE tool. */
  ASSIGN h_ade_tool = ?.

END PROCEDURE. /* disable_widgets */

PROCEDURE display_current :
/*------------------------------------------------------------------------------
  Purpose: shows the name and label of the current widget in in the menu window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* debugging code to see if current window/frame/widget is set correctly 
  ---------------------------------
  DISPLAY ((IF _h_cur_widg NE ? THEN STRING(_h_cur_widg) ELSE "?") + " " +
           (IF _h_frame NE ?    THEN STRING(_h_frame)    ELSE "?") + " " +
           (IF _h_win NE ?      THEN STRING(_h_win)      ELSE "?"))
           AT ROW 2.8 COL 38 BGC 1 FGC 15 FORMAT "X(30)"  VIEW-AS TEXT
       WITH FRAME action_icons.
  -------------------------------------------------------------------- */
  DEFINE VARIABLE cs-char       AS CHARACTER CASE-SENSITIVE NO-UNDO.
  DEFINE VARIABLE l_master      AS LOGICAL                  NO-UNDO.
  DEFINE VARIABLE l_DynLabel    AS LOGICAL                  NO-UNDO.
  
  DEFINE BUFFER ipU FOR _U.

  DEFINE BUFFER b_U FOR _U.
  /* DBG STATEMENTs to help reduce flashing
  def var zzz as char no-undo.
  zzz =  LAST-EVENT:LABEL +      "  " + LAST-EVENT:FUNCTION + "  " +
      /* LAST-EVENT:EVENT-TYPE + "  " + */ LAST-EVENT:TYPE +     "  (" +
           STRING(LAST-EVENT:X) + "," +   STRING(LAST-EVENT:Y) + ")".
    run adecomm/_statdsp.p (_h_status_line, {&STAT-Main}, zzz). */

  /* To reduce flashing, check the last event.  If we did a MOUSE-SELECT
     DOWN in a UIB widget, then ignore the event. */
  IF NOT (LAST-EVENT:LABEL EQ "MOUSE-SELECT-DOWN":U AND
          CAN-FIND (ipU WHERE ipU._HANDLE eq SELF))
  THEN DO WITH FRAME action_icons:

    /* Before changing the current displayed widget, make sure any user
       changes to cur_widg_name and cur_widg_text are dealt with.

      [This is because clicking in another window does not explicitly send
      LEAVE to the fields in the main window].  First check for VALID-HANDLE
      to avoid changing deleted widgets or current widget UNKNOWN.

      Note 1:
      We don't need to check for changes on fill-ins that aren't sensitive.

      Note 2:
      This code is also in uibmtrig.i ON LEAVE OF _h_menu_win. Its needed here
      because under Windows, clicking back into the design window's frame
      does not fire the LEAVE event.  It does under Motif. I think this
      is a bug, but I'll have to figure it out better and log a separate bug.
      The ON LEAVE trigger fixes bug 94-03-11-046. (jep 08/08/94).
      */

    IF VALID-HANDLE(h_display_widg) THEN DO:
      error_on_leave = NO.
      if cur_widg_name:SENSITIVE AND INPUT cur_widg_name NE display_name THEN
        APPLY "LEAVE":U TO cur_widg_name.
      IF cur_widg_text:SENSITIVE AND INPUT cur_widg_text NE display_text THEN
        APPLY "LEAVE":U TO cur_widg_text.
      IF error_on_leave THEN RETURN.
    END.
    FIND b_U WHERE b_U._HANDLE = _h_cur_widg AND b_U._STATUS <> "DELETED"
            NO-ERROR.
    IF AVAILABLE b_U AND _next_draw EQ ? THEN DO:
      /* Menus don't have _L's */
      FIND _L WHERE RECID(_L) = b_U._lo-recid NO-ERROR.
      IF FOCUS EQ ? and valid-handle(_h_win) THEN APPLY "ENTRY":U TO _h_win.
      /* Show it selected */
      IF CAN-SET(_h_cur_widg,"SELECTED":U) AND b_U._TYPE NE "DIALOG-BOX":U
      THEN ASSIGN b_U._SELECTEDib       = YES
                  _h_cur_widg:SELECTED = YES.

      /* Edit the name (except for text widgets which will be literals)   */
      /* and db fields where we shouldn't allow name changes.             */
      /* The trigger button is disabled for widgets that don't have names */
      ASSIGN cur_widg_name            = IF (b_U._TABLE = ?) THEN b_U._NAME
                                        ELSE b_U._NAME + " (" +  b_U._TABLE + ")"
             cur_widg_name:SENSITIVE  = (b_U._TYPE <> "TEXT") AND
                                           (b_U._TABLE = ?)
             cur-widget-parent        = b_U._PARENT-RECID
             cur-widget-type          = b_U._TYPE.
      IF b_U._TABLE NE ? THEN DO:
        FIND _F WHERE RECID(_F) = b_U._x-recid NO-ERROR.
        IF AVAILABLE _F AND _F._DISPOSITION EQ "LIKE" THEN
          ASSIGN cur_widg_name = b_U._NAME.
      END.  /* If there is a table name */

      /* Label, etc. is only edittable in Master Layout. */
      l_master = b_U._LAYOUT-NAME EQ "{&Master-Layout}".
      IF NOT l_master THEN DO:
        /* We will allow label of fields of dynamic viewers to be sensitive */
        IF NOT AVAILABLE _P THEN
          FIND _P WHERE _P._WINDOW-HANDLE = _h_win.

        IF AVAILABLE _P AND _DynamicsIsRunning THEN l_DynLabel = (LOOKUP(_P.OBJECT_type_code,
                        DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynView":U)) <> 0).
      END.

      /* What is it? Is it text (then show value). Does it have a label?   */
      /* then show it (NOTE: TEXT has a LABEL but the UIB doesn't use it). */
      /* Show TITLE for frames/windows                                     */
      /* Show name for html objects and don't check their widget type */
      IF CAN-FIND (_HTM WHERE _HTM._U-recid = RECID(b_U)) THEN DO:
        FIND _HTM WHERE _HTM._U-recid = RECID(b_U).
        ASSIGN cur_widg_text:SENSITIVE    = FALSE
               cur_widg_text              = _htm._HTM-NAME.
        IF cur_widg_text:LABEL <> "Name":R7 THEN
          ASSIGN cur_widg_text:LABEL = "Name":R7.
      END.  /* If an HTML object */
      ELSE IF CAN-DO("EDITOR,IMAGE,MENU,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,{&WT-CONTROL}",
                b_U._TYPE) THEN DO:
        IF b_U._TYPE <> "{&WT-CONTROL}" THEN DO:
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = "":U.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.  /* If not an OCX */
        ELSE DO: /* Must be one of Ed, Img, Menu, RS, Rect, Sel-L or Slider */
          ASSIGN cur_widg_text:SENSITIVE    = FALSE
                 cur_widg_text              = b_U._OCX-NAME.
          IF cur_widg_text:LABEL <> "OCX":R7 THEN
            ASSIGN cur_widg_text:LABEL = "OCX":R7.
        END.  /* Must be one of the list above */
      END.  /* If can-do a bunch */
      ELSE DO:  /* Else something else */
        IF b_U._TYPE = "TEXT" THEN DO:
          FIND _F WHERE RECID(_F)  = b_U._x-recid.
          ASSIGN cur_widg_text           = _F._INITIAL-DATA
                 cur_widg_text:SENSITIVE = l_master.
          IF cur_widg_text:LABEL <> "Text":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Text":R7.
        END.  /* If text */
        ELSE IF b_U._TYPE = "SmartObject" THEN DO:
          FIND _S WHERE RECID(_S)  = b_U._x-recid.
          ASSIGN cur_widg_text           = _S._FILE-NAME
                 cur_widg_text:SENSITIVE = NO.
          IF cur_widg_text:LABEL <> "Master":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Master":R7.
        END.  /* If SmartObject */
        ELSE IF b_U._TYPE EQ "WINDOW" THEN DO:
          /* Don't show the Window if it is not allowed */
          IF b_U._SUBTYPE NE "Design-Window":U THEN DO:
            FIND _C WHERE RECID(_C) = b_U._x-recid.
            ASSIGN cur_widg_text        = IF b_U._LABEL NE ?
                                          THEN b_U._LABEL ELSE "".
            IF cur_widg_text:LABEL <> "Title":R7
            THEN cur_widg_text:LABEL = "Title":R7.
            cur_widg_text:SENSITIVE = l_master.
          END.
          ELSE DO:
            /* Don't show the true name */
            FIND _P WHERE _P._u-recid EQ RECID(b_U).
            ASSIGN cur_widg_text = IF _P._SAVE-AS-FILE EQ ? THEN "Untitled"
                                   ELSE _P._SAVE-AS-FILE
                   cur_widg_name = _P._TYPE
                   cur_widg_text:SENSITIVE = NO
                   cur_widg_name:SENSITIVE = NO.
            IF cur_widg_text:LABEL <> "File":R7 THEN
              ASSIGN cur_widg_text:LABEL = "File":R7.
          END.
        END.  /* If Window */
        ELSE IF CAN-DO("BROWSE,DIALOG-BOX,FRAME":U, b_U._TYPE) THEN DO:
          FIND _C WHERE RECID(_C) = b_U._x-recid.
          ASSIGN cur_widg_text        = IF b_U._LABEL NE ?
                                        THEN b_U._LABEL ELSE "".
          IF cur_widg_text:LABEL <> "Title":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Title":R7.

          /* Browses and frames with no-box can't change title */
          IF CAN-DO("BROWSE,FRAME":U, b_U._TYPE)
             AND (_L._NO-BOX OR _C._TITLE EQ NO)
          THEN ASSIGN cur_widg_text:SENSITIVE = NO
                      cur_widg_text           = "<No Title>".
          ELSE cur_widg_text:SENSITIVE = l_master.
        END.  /* If Browse, Dialog or Frame */
        ELSE IF CAN-SET(b_U._HANDLE, "LABEL") THEN DO:
          ASSIGN cur_widg_text           = (IF b_U._LABEL-SOURCE EQ "D"
                                            THEN "?" ELSE b_U._LABEL)
                 cur_widg_text:SENSITIVE = l_master OR l_DynLabel.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.  /* If if label is a valid, setable attribute */
        ELSE DO:
          ASSIGN cur_widg_text           = "<not defined>":U
                 cur_widg_text:SENSITIVE = NO.
          IF cur_widg_text:LABEL <> "Label":R7 THEN
            ASSIGN cur_widg_text:LABEL = "Label":R7.
        END.
      END.  /* ELSE DO (not editor,image,radio-set etc. */
    END.  /* If AVAIL b_U AND next_draw eq ? */

    /* No current widget -- blank everything out.  (Or show multiple
       selections.)*/
    ELSE ASSIGN cur_widg_name           = "":U
                cur_widg_text           = "":U
                cur_widg_text:SENSITIVE = NO
                cur_widg_name:SENSITIVE = NO
                /* This is a safety net incase CURRENT-WINDOW is ever reset */
                CURRENT-WINDOW          = _h_menu_win.
    
    /* To avoid unnecessary flashing only display things that changed */
    ASSIGN cs-char = cur_widg_name.
    IF cs-char NE INPUT cur_widg_name THEN
      DISPLAY cur_widg_name.
    /* Now redisplay the text field to get around a 4GL bug that was
       eating all the "&" characters when I set the SCREEN-VALUE. */
    ASSIGN cs-char = cur_widg_text.
    IF cs-char NE INPUT cur_widg_text THEN
      DISPLAY cur_widg_text.
    /* Change the sensitivity on buttons etc. */
    RUN sensitize_main_window ("WIDGET").
    /* Store the currently displayed values */
    ASSIGN h_display_widg = _h_cur_widg
           display_name   = cur_widg_name
           display_text   = cur_widg_text.
 
    /* Now display (or hide) items depending on the current window.
       This catches changing the current window, or changing pages
       in the current window. */
    RUN display_curwin.
        /* Show the current values in the Attributes window. */
    IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME EQ "{&AttrEd}" THEN 
      RUN show-attributes IN hAttrEd NO-ERROR.
    /* Show the current values in the dynamic attribute window */
    IF VALID-HANDLE(_h_menubar_proc) THEN
      RUN Display_PropSheet IN _h_menubar_proc (YES) NO-ERROR.
    /* Show OCX Property Editor Window. Don't do this if the user is changing
       the Name attribute in the Prop Ed. We don't need to refresh the Prop Ed
       window at that point. */
    IF NOT PROGRAM-NAME(2) BEGINS "DesignFrame.ControlNameChanged":U THEN
      RUN show_control_properties (0).
      
    if WidgetAction = "" then WidgetAction = "FOCUS".
    if OEIDEIsRunning and cur_widg_name <> "" then
       run CallWidgetEvent in _h_uib(input recid(b_U),WidgetAction).
        
  END. /* If not mouse-select-down. */
END PROCEDURE. /* display_current */


PROCEDURE display_curwin :
/*------------------------------------------------------------------------------
  Purpose: when the current window changes, then hide or show information 
           relevant to it     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR h_true_win     AS HANDLE      NO-UNDO.
  DEFINE VAR new-visual-obj AS LOGICAL     NO-UNDO.
  DEFINE VAR new-mode       AS CHARACTER   NO-UNDO.

  /* If the current window has not changed then do nothing */
  IF _h_win NE h_display_win THEN DO:
    IF VALID-HANDLE(_h_win) THEN FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win NO-ERROR.
    IF AVAILABLE _P THEN DO:
      ASSIGN new-visual-obj = CAN-FIND(FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND
                                                     (_U._TYPE = "FRAME" OR
                                                      _U._TYPE = "DIALOG-BOX")) AND
                                                      _P._TYPE NE "WEB-OBJECT":U
             new-mode       = IF _P._TYPE = "WEB-OBJECT" THEN "WEB" ELSE "UIB".
      IF new-visual-obj NE _visual-obj OR new-mode NE last-mode THEN DO:
        _visual-obj = new-visual-obj.
 
        RUN mode-morph (new-mode).
      END.
    END.
 
    /* Sensitize the UIB main window based on the type of window. */
    RUN sensitize_main_window ("WINDOW").
    
    IF VALID-HANDLE(mi_goto_page) THEN DO:
      /* Show page information */
      IF VALID-HANDLE(_h_win) AND CAN-DO (_P._links, "PAGE-TARGET") THEN DO:
        mi_goto_page:SENSITIVE = YES.
        RUN display_page_number.
      END.
      ELSE DO:
        mi_goto_page:SENSITIVE = NO.
        RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Page}, "").
      END.
    END.  /* If it is a visual object */

    /* Save the value for next time */
    ASSIGN h_display_win = _h_win.

    /* Update the checked active window on the Window menu. */
    IF VALID-HANDLE( _h_WinMenuMgr ) AND VALID-HANDLE(_h_win) THEN DO:
      ASSIGN h_true_win = (IF _h_win:TYPE = "WINDOW":U
                             THEN _h_win ELSE _h_win:PARENT).
      RUN WinMenuSetActive IN _h_WinMenuMgr (_h_WindowMenu, h_true_win:TITLE).
    END.
  END.

END PROCEDURE.


PROCEDURE display_page_number :
/*------------------------------------------------------------------------------
  Purpose: show the current page number in the UIB's status line.
          If the page number is long, then show it as "p. 123", if it is very
          long, then just show it.  Remove commas from really big numbers.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF VAR cPage AS CHAR NO-UNDO.
  IF _P._page-current EQ ? THEN cPage = "All Pages".
  ELSE DO:
    cPage = LEFT-TRIM(STRING(_P._page-current, ">,>>>,>>9":U)).
    IF LENGTH (cPage, "CHARACTER") <= 1 THEN cPage = "Page " + cPage.
    ELSE IF LENGTH (cPage, "CHARACTER") <=3 THEN cPage = "p. " + cPage.
    ELSE IF LENGTH (cPage, "CHARACTER") < 6 THEN cPage = REPLACE(cPage,",":U,"":U).
  END.
  /* Show the new value. */
  RUN adecomm/_statdsp.p  (_h_status_line, {&STAT-Page}, cPage).
END PROCEDURE.


PROCEDURE disp_help :
/*------------------------------------------------------------------------------
  Purpose: Dispatches help for the current widget.  This means that it calls 
           help with the context-id set to the property sheet help of the 
           widget type      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE help-context AS INTEGER NO-UNDO.
  DEFINE BUFFER i_U FOR _U.
  DEFINE BUFFER i_P FOR _P.

  FIND i_U WHERE i_U._HANDLE = _h_cur_widg NO-ERROR.

  IF AVAILABLE i_U THEN DO:
    FIND i_P WHERE i_p._WINDOW-HANDLE = i_u._WINDOW-HANDLE NO-ERROR.
     /* tree-view have different help */
    IF VALID-HANDLE(i_p._tv-proc) THEN
    DO:
      CASE i_U._TYPE:
        WHEN "EDITOR"         THEN help-context = {&EDITOR_Web}.
        WHEN "FILL-IN"        THEN help-context = {&FILL_IN_Web}.
        WHEN "RADIO-SET"      THEN help-context = {&RADIO_SET_Web}.
        WHEN "SELECTION-LIST" THEN help-context = {&SELECTION_LIST_Web}.
        WHEN "TOGGLE-BOX"     THEN help-context = {&TOGGLE_BOX_Web}.
        OTHERWISE DO:
          help-context = IF DYNAMIC-FUNCTION('FileIsHTMLMapping':U IN i_p._tv-proc)
                         THEN {&HTML_Mapping_Procedure_Treeview}
                         ELSE {&Code_only_Treeview}.
        END.
      END CASE.
    END.
    ELSE DO:
      CASE i_U._TYPE:
        WHEN "BROWSE"         THEN help-context = {&BROWSER_Attrs}.
        WHEN "BUTTON"         THEN help-context = {&BUTTON_Attrs}.
        WHEN "COMBO-BOX"      THEN help-context = {&COMBO_BOX_Attrs}.
        WHEN "DIALOG-BOX"     THEN help-context = {&DIALOG_BOX_Attrs}.
        WHEN "EDITOR"         THEN help-context = {&EDITOR_Attrs}.
        WHEN "FILL-IN"        THEN help-context = {&FILL_IN_Attrs}.
        WHEN "FRAME"          THEN help-context = {&FRAME_Attrs}.
        WHEN "IMAGE"          THEN help-context = {&IMAGE_Attrs}.
        WHEN "RADIO-SET"      THEN help-context = {&RADIO_SET_Attrs}.
        WHEN "RECTANGLE"      THEN help-context = {&RECTANGLE_Attrs}.
        WHEN "SELECTION-LIST" THEN help-context = {&SELECTION_LIST_Attrs}.
        WHEN "SmartObject"    THEN help-context = {&Property_Sheet_SmartObjects}.
        WHEN "SLIDER"         THEN help-context = {&SLIDER_Attrs}.
        WHEN "TEXT"           THEN help-context = {&TEXT_Attrs}.
        WHEN "TOGGLE-BOX"     THEN help-context = {&TOGGLE_BOX_Attrs}.
        WHEN "{&WT-CONTROL}"  THEN i_U._COM-HANDLE:ShowHelp().
        WHEN "WINDOW"         THEN help-context = {&WINDOW_Attrs}.
      END CASE.
    END. /* not htm */

    IF i_U._TYPE NE "{&WT-CONTROL}":U THEN
    DO:
      RUN adecomm/_adehelp.p ( "AB", "CONTEXT", help-context, ? ).
    END.
  END. /* if avail i_U */
END PROCEDURE. /* disp_help */

PROCEDURE do_export_file :
/*------------------------------------------------------------------------------
  Purpose: Export selected objects to an export file.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cnt AS INTEGER NO-UNDO.

  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    RUN adeuib/_chksel.p ( OUTPUT cnt ).
    IF cnt >= 0 THEN
    DO:
      /* SEW store current trigger code before copying to file. */
      RUN call_sew ("SE_STORE_SELECTED":U).
      if OEIDEIsRunning then
      RUN adeuib/ide/_dialog_chsxprt.p (TRUE).
      else
      RUN adeuib/_chsxprt.p (TRUE).
    END.
    ELSE DO: /* Invalid Selection */
      if OEIDEIsRunning then
       ShowMessageInIDE("There are selected objects with different parents. ~n
                        Copy to File only works on objects with the same parent.",
                        "Information",?,"OK",YES).
      else    
      MESSAGE "There are selected objects with different parents." SKIP
              "Copy to File only works on objects with the same parent."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.
    END. /* Invalid Selection */
  END.
END. /* do_export_file */

PROCEDURE do_goto_page :
/*------------------------------------------------------------------------------
  Purpose: change the page number shown for the current window     
  Parameters:  <none>
  Notes:  call from choose_goto_page      
------------------------------------------------------------------------------*/
 /* Does this procedure support paging? If so change the page and display
     it? */
  /* define input parameter pFileName as character no-undo. */
  define variable cResult as character no-undo.
  IF _h_win = ? THEN RUN report-no-win.
  ELSE DO:
    FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
    
    IF CAN-DO (_P._links, "PAGE-TARGET") THEN DO:
      /* Only page 0 is allowed on alternate layouts. */
      FIND _U WHERE RECID(_U) EQ _P._u-recid.
      IF _U._LAYOUT-NAME EQ '{&Master-Layout}':U THEN DO:
        if OEIDE_CanLaunchDialog() then
            run adeuib/ide/_dialog_gotopag.p(recid(_P)).
        else    
            run adeuib/_gotopag.w (RECID(_P)).
        
        RUN display_page_number.
        if IDEIntegrated and valid-handle(hOEIDEService) then      
            gotoPage(_h_win,_P._page-current).
      
      END.
      ELSE DO:
        if OEIDE_CanShowMessage() then
            ShowMessageInIDE("Changing pages is not supported except in the {&Master-Layout}.",
                        "Information",?,"OK",YES).
        else  
        MESSAGE "Changing pages is not supported except in the {&Master-Layout}."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        IF _P._page-current NE 0 THEN RUN adeuib/_showpag.p (0).
      END. /* IF <not master layout>... */
    END. /* IF CAN-DO...Page-Target... */
  END. /* IF valid window... */
END PROCEDURE. /*do_goto_page */

procedure IDEEnablePageNo:
    define output parameter pageNumber as integer no-undo.
    define variable cResult    as character no-undo.
    IF _h_win = ? THEN pageNumber = ?.
    else
    do:
       FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win.
       if avail(_P) then
       do:
           IF CAN-DO (_P._links, "PAGE-TARGET") THEN
           DO:
               FIND _U WHERE RECID(_U) EQ _P._u-recid.
               IF _U._LAYOUT-NAME EQ '{&Master-Layout}':U THEN 
                  pageNumber = _P._page-current.
               ELSE
                  pageNumber = 0.
               
           END.
           ELSE
              pageNumber = ?.    
       end.
       else
       pageNumber = ?.
    end.  
    
    
end procedure.

procedure setPage:
    define input parameter piPage as integer no-undo. 
    
    find _P where _P._WINDOW-HANDLE eq _h_win.
    if can-do (_P._links, "PAGE-TARGET") then 
    do:
        
        /* Only page 0 is allowed on alternate layouts. */
        find _U where recid(_U) eq _P._u-recid.
        if _U._LAYOUT-NAME eq '{&Master-Layout}':U then 
        do:
           if piPage ne _P._page-current then 
           do: 
               _P._page-current = piPage.
               run adeuib/_showpag.p (recid(_P), piPage).
           END.
           run display_page_number.
           return "yes".
        end.
        else do:
            /*
            MESSAGE "Changing pages is not supported except in the {&Master-Layout}."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                */
            if _P._page-current ne 0 then 
                run adeuib/_showpag.p (recid(_P),0).
           return "NO". 
        end. /* IF <not master layout>... */
    end.
    else
    return "NO" .
end procedure.


PROCEDURE do_import_file :
/*------------------------------------------------------------------------------
  Purpose: Import an exported file    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR lnth_sf AS INTEGER NO-UNDO.
  DEF VAR pressed_ok AS LOGICAL NO-UNDO.
  DEF VAR absolute_name AS CHAR NO-UNDO.

  /* Choose a *.wx file from the saved set of WIDGET-DIRS.  Use TEMPLATE
     mode here so that we can show related pictures of the choosen file
     (if they exist). */
  open_file = "".
  if OEIDEIsRunning then
  RUN adeuib/ide/_dialog_fndfile.p (INPUT "From File",                          /* pTitle            */
                          INPUT "TEMPLATE",                           /* pMode             */
                          INPUT "Export (*.wx)|*.wx|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&WIDGET-DIRS},                /* pDirList          */
                          INPUT-OUTPUT open_file,                     /* pFileName         */
                          OUTPUT absolute_name,                       /* pAbsoluteFileName */
                          OUTPUT pressed_ok).                         /* pOK               */
  else                        
  RUN adecomm/_fndfile.p (INPUT "From File",                          /* pTitle            */
                          INPUT "TEMPLATE",                           /* pMode             */
                          INPUT "Export (*.wx)|*.wx|All Files|*.*":U, /* pFilters          */
                          INPUT-OUTPUT {&WIDGET-DIRS},                /* pDirList          */
                          INPUT-OUTPUT open_file,                     /* pFileName         */
                          OUTPUT absolute_name,                       /* pAbsoluteFileName */
                          OUTPUT pressed_ok).                         /* pOK               */
  IF pressed_OK THEN DO:
    open_file = absolute_name.
    /* Deselect the currently selected widgets. */
    RUN deselect_all (?, ?).
    RUN setstatus ("":U, "Insert from file...").
    IF open_file <> "" AND open_file <> ? THEN
      RUN adeuib/_qssuckr.p (open_file, "", "IMPORT":U, FALSE).

    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

    /* In case of _qssuckr failure, reset the cursors. */
    RUN setstatus ("":U, "":U).

    /* Special Sanity check -- sanitize our records */
    RUN adeuib/_sanitiz.p.

    IF (_h_win = ?) THEN RETURN.

    /* set the file-saved state to false */
    RUN adeuib/_winsave.p(_h_win, FALSE).

    FIND _U WHERE _U._HANDLE = _h_win.
    ASSIGN _h_cur_widg    = _U._HANDLE
           _h_frame       = (IF _U._TYPE EQ "WINDOW":U THEN ? ELSE _U._HANDLE)
           .
    RUN display_current.

    /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN
      RUN choose-pointer.
  END.
END PROCEDURE. /* do_import_file */

PROCEDURE do_insert_function:
 /** removed call to ide - possible future call ide text editor add procedure 
    IN any case it should not be called from here.. but from choose_insert_function */
/*  if OEIDEIsRunning then               */
/*     AddCodeSection(_h_win,"FUNCTION").*/
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
       RUN NewCodeBlock IN OEIDE_ABSecEd ("_FUNCTION":U) NO-ERROR.
   /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE.
    
PROCEDURE do_insert_procedure:
   /** removed call to ide - possible future call ide text editor add procedure 
    IN any case it should not be called from here.. but from choose_insert_procedure */
/*  if OEIDEIsRunning then                */
/*     AddCodeSection(_h_win,"PROCEDURE").*/
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
        RUN NewCodeBlock IN OEIDE_ABSecEd ("_PROCEDURE":U) NO-ERROR.
    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE.
    
PROCEDURE do_insert_trigger:
   /** removed call to ide - possible future call ide text editor add procedure 
    IN any case it should not be called from here.. but from choose_insert_trigger */  
    /* 
   if OEIDEIsRunning then  
       AddTrigger(_h_win,cur_widg_name,cur-widget-type). */
    IF VALID-HANDLE(OEIDE_ABSecEd) THEN
        RUN NewTriggerBlock IN OEIDE_ABSecEd (?) NO-ERROR.  /* prompt for event name */

    /* Return to pointer mode. */
    IF _next_draw NE ? THEN RUN choose-pointer.
END PROCEDURE.

PROCEDURE do_tab_edit :
/*------------------------------------------------------------------------------
  Purpose: fires off the tab-editor    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF _h_win = ? THEN
    RUN report-no-win.
  ELSE DO:
    FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
    IF NOT AVAILABLE _U THEN DO:
      /* This happens when a smartviewer is opened, but not entered */
      FIND FIRST _U WHERE _U._WINDOW-HANDLE = _h_win AND _U._TYPE = "FRAME":U
        NO-ERROR.
      IF NOT AVAILABLE _U THEN
      do:
        if OEIDEIsRunning then
          ShowMessageInIDE("Please click on the frame you want to edit.",
                        "Information",?,"OK",YES).
        else  
        MESSAGE "Please click on the frame you want to edit."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      end.    
      ELSE _h_frame = _U._HANDLE.
    END.  /* If not available _U */
    if avail _u then 
    do:
        if IDEIntegrated then 
            run adeuib/ide/_dialog_tabedit.p (RECID(_U)).
        else
            RUN adeuib/_tabedit.w (RECID (_U)).
    end.
  END.
END PROCEDURE.


PROCEDURE double-click :
/*------------------------------------------------------------------------------
  Purpose: called by persistent triggers on UIB objects  
           It calls the standard MOUSE-SELECT-DBLCLICK action.      
  Parameters:  <none>
  Notes:   
------------------------------------------------------------------------------*/
  /* For everything but a OCX control, run the property sheet or section
     editor (depending on _dblclick_section_ed). IF a control, then use
     OCX property editor                                                   */

  FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.

  IF NOT AVAILABLE _U AND SELF NE _h_cur_widg THEN DO:
    ASSIGN _h_cur_widg = SELF.
    FIND FIRST _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
  END.
  
  IF NOT AVAILABLE _U THEN RETURN.

  IF _U._TYPE = "{&WT-CONTROL}" THEN DO:
    IF _U._LAYOUT-NAME = "Master Layout" THEN DO:
      /* Set and display the Property Editor window. */
      RUN show_control_properties (1).
    END.
    ELSE
    do:
      if OEIDEIsRunning then
          ShowMessageInIDE("You may not change OCX properties in an alternate layout. ~n 
                           You may change the size, position and color of the Control Frame.",
                            "Information",?,"OK",YES).
      else  
      MESSAGE "You may not change OCX properties in an alternate layout." SKIP
              "You may change the size, position and color of the Control Frame."
              VIEW-AS ALERT-BOX INFORMATION.
    end.          
  END.
  ELSE DO:  /* A normal progress widget */
    IF _dblclick_section_ed THEN DO:
        /* Find _P of _h_cur_widg and if it is dynamic don't bring up the editor */
      FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
      IF AVAILABLE _P AND NOT _P.static_object THEN DO:
        /* A dynamic object, don't open the section editor */
        if OEIDEIsRunning then
          ShowMessageInIDE("The Text Editor is not used for dynamic objects.",
                            "Information",?,"OK",YES).
        else
        MESSAGE "The Section Editor is not used for dynamic objects."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      END.  /* If a dynamic object */
      ELSE
      DO: 
         IF IDEIntegrated THEN 
            RUN choose_viewSource(INPUT "DoubleClick").
         ELSE RUN choose_codedit.
      END.
    END. /* If dection editor */
    ELSE 
        RUN property_sheet (?).
  END. /* DO for a normal progress widget */
END PROCEDURE.


PROCEDURE drawobj :
/*------------------------------------------------------------------------------
  Purpose: drawobj is a procedure to figure out what widget is to be drawn 
           in a frame    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE fproc      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lValid     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRowObj    AS LOGICAL   NO-UNDO INIT TRUE.

  &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("drawobj"). &ENDIF

  IF _next_draw NE ? THEN DO:
    /* check 'drawing' permissions for this procedure */
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
 
    FIND _palette_item WHERE _palette_item._name = _next_draw.
    IF _palette_item._type EQ {&P-BASIC} OR _palette_item._type EQ {&P-XCONTROL} THEN DO:
      CASE _next_draw:
        WHEN "DB-Fields" OR WHEN "Browse" OR WHEN "Query" THEN DO:
          IF NOT CAN-DO (_P._Allow, _next_draw) THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* DB-Fields, browse or Query */
        WHEN "Frame" THEN DO:
          RUN adeuib/_uibinfo.p (INT(RECID(_P)), ?, "FRAMES", OUTPUT fproc).
          CASE _P._max-frame-count:
            WHEN 0 THEN DO: /* No frames allowed */
              BELL.
              RETURN.
            END. /* When 0 */
            WHEN 1 THEN DO: /* Exactly 1 frame allowed */
              IF fproc NE ? AND fproc NE "" THEN DO:
                BELL.
                RETURN.
              END.
            END. /* When 1 */
          END CASE. /* _P._max-frame-count */
        END.  /* Frame */
        OTHERWISE DO:
          IF NOT CAN-DO(_P._ALLOW,"Basic") THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* Otherwise */
      END CASE.  /* CASE _next_draw */
    END.  /* If thing to draw is either a basic control or an Xcontrol */
    ELSE DO:  /* The thing to draw is either a SmartObject or a User object */
      CASE _next_draw:
        WHEN "SmartFolder" THEN IF NOT CAN-DO(_P._LINKS,"Page-Target") THEN DO:
            BELL.
            RETURN.
        END.

        WHEN "SmartDataField" THEN DO:
          /* First make sure that _P is a SmartViewer or simple SmartObject. IZ 1611 */
          IF NOT CAN-DO("SmartDataViewer,SmartObject":U, _P._TYPE) THEN DO:
            BELL.
            RETURN.
          END.

          /* Find the field to replace */
          ASSIGN hField = _h_win:FIRST-CHILD  /* The frame       */
                 hField = hField:FIRST-CHILD  /* The field group */
                 hField = hField:FIRST-CHILD. /* The first field */
          SEARCH-BLOCK:
          REPEAT WHILE hField NE ?:
            IF hField:X < _frmx AND
               hField:Y < _frmy AND
               hField:X + hField:WIDTH-PIXELS > _frmx AND
               hField:Y + hField:HEIGHT-PIXELS > _frmy THEN DO:
                 ASSIGN _h_cur_widg   = hField.
                 FIND _U WHERE _U._HANDLE = hField.

                 /* Presume the field is not a Data Field and save its name
                    for displaying in messages. */
                 ASSIGN lRowObj = NO
                        cName   = _U._NAME.

                 /* Determine if user clicked into a Data Field (e.g., an SDO
                    RowObject field or SBO field). Since Data Field objects are
                    managed using the _P object's temp tables, we can check for that
                    first. It could be a user-defined temp-table, so we need to
                    check its table type as well. "D" types are Data Fields, "T"
                    types are user defined temp-tables, etc. We want "D" types. -jep */
                 IF _U._DBNAME = "Temp-Tables":u THEN
                 DO:
                   /* In 9.1B, with SBOs, a Viewer can have fields which are qualified
                      by the SDO's ObjectName, not always RowObject, as is the case
                      with SDO's. _U._TABLE and _TT._NAME hold these values and we
                      use them to see if the _TT is for a Data Source object. -jep */
                   IF _U._CLASS-NAME = "DataField" THEN lRowObj = YES.
                   ELSE IF _U._BUFFER = "RowObject" THEN lRowObj = YES.
                   ELSE DO:
                     FIND FIRST _TT WHERE _TT._P-RECID = RECID(_P)
                                      AND _TT._NAME    = _U._TABLE NO-LOCK NO-ERROR.
                     IF AVAILABLE _TT THEN
                        ASSIGN lRowObj = (_TT._TABLE-TYPE = "D":U).
                     ELSE IF _U._BUFFER = "RowObject" THEN lRowObj = YES.
                     ELSE /* This should not happen. If it does, its not a valid field. */
                        ASSIGN lRowObj = NO.
                   END.
                 END. /* IF Temp-Table THEN */

                 /* User did click in a Data Source field. */
                 IF lRowObj OR (_U._TYPE = "FILL-IN":U AND _U._dbName = ? AND _U._TABLE = ?)
                 THEN DO:
                   /* A field was clicked into and it is a Data Source
                     (RowObject or SBO) field or a local field. IZ 1611 */
                   ASSIGN lValid        = TRUE
                          _h_cur_widg   = hField
                          hField:HIDDEN = TRUE
                          _U._HIDDEN    = TRUE.
                   LEAVE SEARCH-BLOCK.
                 END.
             END. /* If this field was clicked into */
             hField = hField:NEXT-SIBLING.
          END.  /* SEARCH-BLOCK: Repeat WHILE looking for the field */
          /* If a widget was clicked into but it was not a RowObject field
             we need to let the user know and return */
          IF NOT lRowObj AND NOT lValid THEN DO:
           if OEIDEIsRunning then
              ShowMessageInIDE(cName + "is not a Data Source field. A SmartDataField must be dropped onto a Data Source field.",
                               "Information",?,"OK",YES).
            else  
            MESSAGE cName "is not a Data Source field. A SmartDataField must be dropped onto a Data Source field.".
            BELL.
            RETURN.
          END.  /* If not lRowObj and not lValid */
          /* If no widget was clicked into then we need to let the user
             know and return */
          ELSE IF NOT lValid THEN DO:
            if OEIDEIsRunning then
              ShowMessageInIDE("A SmartDataField must be dropped onto a Data Source field.",
                               "Information",?,"OK",YES).
            else  
            MESSAGE "A SmartDataField must be dropped onto a Data Source field.".
            BELL.
            RETURN.
          END.  /* Else if not lValid */
        END.  /* When drawing a SmartDataField */

        OTHERWISE DO:
          ASSIGN canDraw = FALSE
                 canRun  = TRUE.
          {adeuib/sookver.i _object_draw canDraw YES}
          IF NOT canDraw THEN DO:
            BELL.
            RETURN.
          END.
        END.  /* Otherwise */
      END CASE.
    END.
   
    /* Special case of TTY mode */
    IF (NOT _cur_win_type) AND CAN-DO("IMAGE,{&WT-CONTROL}",_next_draw) THEN DO:
      if OEIDEIsRunning then
         ShowMessageInIDE("Character mode windows cannot contain " + _next_draw + " objects.",
                               "Information",?,"OK",YES).
      else  
      MESSAGE "Character mode windows cannot contain" _next_draw "objects."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      RUN choose-pointer.

      /*
       * No sense in trying to draw something that can't be drawn.
       */
      RETURN.
    END.
    IF VALID-HANDLE(mi_color) THEN DO:
      IF (NOT _cur_win_type) OR _next_draw = "IMAGE":U THEN
        ASSIGN _h_button_bar[9]:SENSITIVE = FALSE
               mi_color:SENSITIVE         = FALSE.
      ELSE
        ASSIGN _h_button_bar[9]:SENSITIVE = TRUE
               mi_color:SENSITIVE         = TRUE.
    END.

       
    /* Now draw... */
    RUN setstatus ("WAIT":U, "Drawing " + _next_draw + "...").
    IF LDBNAME("DICTDB":U) = ? OR DBTYPE("DICTDB":U)NE "PROGRESS":U THEN
    FIND-PRO:
    DO i = 1 TO NUM-DBS:
      IF DBTYPE(i) = "PROGRESS":U THEN DO:
        CREATE ALIAS "DICTDB":U FOR DATABASE VALUE(LDBNAME(i)).
        LEAVE FIND-PRO.
      END.
    END.
    RUN adeuib/_drawobj.p (goback2pntr).
 
    IF RETURN-VALUE NE "NO DRAW" and RETURN-VALUE NE "IDE DRAW" THEN 
    DO:
      /* Show the current widget and reset the pointer. */
      IF goback2pntr THEN RUN choose-pointer.
      RUN display_current.

      /* SEW Update after adding widgets in UIB. */
      RUN call_sew ("SE_ADD":U).

    END.
    RUN setstatus ("":U, "":U).
  END. /* IF _next_draw ne ? */
END PROCEDURE.  /* drawobj */


PROCEDURE drawobj-in-box :
/*------------------------------------------------------------------------------
  Purpose: called at the end of a box-select and it computes the second-corner 
           of a draw before calling draw-obj.
  Parameters:  <none>
  Notes:    Can be called from a WINDOW or a FRAME.      
------------------------------------------------------------------------------*/
 &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("draw..in-box"). &ENDIF
  DEFINE VAR itemp AS   INTEGER                                  NO-UNDO.
  DEFINE VARIABLE hOldFrame AS HANDLE NO-UNDO.
  ASSIGN _second_corner_x = LAST-EVENT:X
         _second_corner_y = LAST-EVENT:Y.

  /* Check for drawing the "wrong" way (from lower-right to upper-left) */
  IF _second_corner_x < _frmx THEN
    ASSIGN itemp            = _frmx
           _frmx            = _second_corner_x
           _second_corner_x = itemp.
  IF _second_corner_y < _frmy THEN
    ASSIGN itemp            = _frmy
           _frmy            = _second_corner_y
           _second_corner_y = itemp.

  /* Now draw the widget. */
        ASSIGN hOldFrame = _h_frame
               _h_frame = SELF.
        RUN drawobj.
        ASSIGN _h_frame = hOldFrame.
END PROCEDURE.  /* drawobj-in-box */


PROCEDURE drawobj-or-select :
/*------------------------------------------------------------------------------
  Purpose: called when we want to either select the frame draw   
           draw a default widget (depending on what _next_draw is).  
  Parameters:  <none>
  Notes:    we do not draw widgets if we are on the border          
------------------------------------------------------------------------------*/
DEFINE VARIABLE hOldFrame AS HANDLE NO-UNDO.
  &IF {&dbgmsg_lvl} > 0
      &THEN RUN msg_watch("draw..or-select" + _next_draw). &ENDIF
  /* Draw an object -- let progress select the frame but we need to
    "select" the dialog-box because it is not selectable. */
  FIND _U WHERE _U._HANDLE = SELF.
  IF _next_draw EQ ? THEN DO:
    /* Select the dialog-box and deselect all other widgets. */
    IF _U._TYPE EQ "DIALOG-BOX" THEN RUN changewidg (SELF, YES).
  END.
  ELSE DO:
    /* Note that we cannot draw frames in dialog-boxes, and the only
       thing we can draw on frame borders is another frame.   */
    IF LAST-EVENT:ON-FRAME-BORDER THEN RETURN.
    ELSE DO:
        ASSIGN hOldFrame = _h_frame
               _h_frame = SELF.
        RUN drawobj.
        ASSIGN _h_frame = hOldFrame.
    END.
  END.
END PROCEDURE. /* drawobj-or-select */

/* wraps the external call to adeuib/_drwbrow.p in order to allow call thru ide */
procedure draw_browse:
   if IdeIntegrated then   
       runDialog(_h_win,"runDrawBrowse":U).
   else
       run adeuib/_drwbrow.p.     
end procedure. /* draw_query */ 

/* wraps the external call to adeuib/_drwqry.p. in order to allow call thru ide */
procedure draw_query:
   if IdeIntegrated then   
       runDialog(_h_win,"runDrawQuery":U).
   else
       run adeuib/_drwqry.p.     
end procedure. /* draw_query */ 

procedure run_xftr_procedure:
    define input        parameter pcProcedure as character no-undo.
    define input        parameter piContextId as integer   no-undo.
    define input-output parameter pcCode      as character no-undo.
    
    define variable cContextIn  as character extent 3 no-undo.
    define variable cContextOut as character extent 2 no-undo.
    
    if IdeIntegrated then  
    do: 
        assign 
            cContextIn[1] = pcProcedure
            cContextIn[2] = string(piContextId)
            cContextIn[3] = pcCode.  
        setContext(cContextIn).  
        /* call run_xftr_procedure_context_runner from the ide */  
        runDialog(_h_win,"runXFTRProcedure":U).
       /* wait until ide calls run_xftr_procedure_context_runner */
        wait-for "U8":u of _h_win.
        cContextOut = getContext().
        pcCode = cContextOut[1].
        return cContextOut[2].
    end.
    else do:   
        run value(pcProcedure) (piContextId, input-output pcCode).
        return return-value.
    end.   
end procedure.

procedure run_xftr_procedure_context_runner:
    define variable cContextIn  as character extent 3 no-undo.
    define variable cContextOut as character extent 2 no-undo.
     
    cContextIn = getContext().
    /* TODO check for side effects  */
    apply "entry" to _h_win.
    run value(cContextIn[1]) (int(cContextIn[2]), input-output cContextIn[3]).
    cContextOut[1] = cContextIn[3].
    cContextOut[2] = return-value.
    setContext(cContextOut).
    /* tell run_xftr_procedure that context is ready */ 
    apply "u8":u to _h_win.    
end procedure.

procedure choose_smartobject:
    define input parameter pcTool as char no-undo.
    define input parameter pcCustomtool as character no-undo.
    define input parameter pcAttr as char no-undo.
    define input parameter pcTemplate as char no-undo.
    define input parameter pcAction as char no-undo.
    define variable chooseSmartObject as adeuib.ide._choosesmartobject no-undo.
    
    if IDEIntegrated then
    do:  
        assign
            chooseSmartObject = new adeuib.ide._choosesmartobject()
            chooseSmartObject:Tool = pcTool
            chooseSmartObject:CustomTool = pcCustomtool
            chooseSmartObject:Attributes = pcAttr
            chooseSmartObject:Template = pcTemplate
            chooseSmartObject:Action = pcAction.
        
        chooseSmartObject:SetCurrentEvent(this-procedure,"do_choose_smartobject":U).
        run runChildDialog in hOEIDEService(chooseSmartObject). 
    end.
    else 
        run do_choose_smartobject(pcTool,pccustomTool,pcAttr,pcTemplate,pcAction). 
    
end procedure.

procedure do_choose_smartobject:
    define input parameter pcTool as char no-undo.
    define input parameter pcCustomTool as char no-undo.
    define input parameter pcAttr as char no-undo.
    define input parameter pcTemplate as char no-undo.
    define input parameter pcAction as char no-undo.
 
    define variable cTool             as character initial "smartObject" no-undo.
    define variable cFile             as character no-undo.
    define variable cUnused           as character no-undo.
    define variable lCancelled        as logical no-undo.
 
    run adecomm/_setcurs.p("WAIT").
    
    session:date-format = _orig_dte_fmt.
    
    IF pcTool = "SmartDataObject":U THEN 
        ctool = pcTool. /* Otherwise smartObject */
    if IDEIntegrated then 
        RUN adeuib/ide/_dialog_chosobj.p 
                               (ctool, 
                                pcAttr, 
                                pcTemplate,
                                pcAction,
                                output cFile,
                                output cUnused ,
                                output lCancelled).
    else
        RUN adecomm/_chosobj.w (ctool,
                                pcAttr, 
                                pcTemplate,
                                pcAction,
                                output cFile,
                                output cUnused ,
                                output lCancelled).
    if cFile <> "" then 
        _object_draw = cFile.
    else assign 
        _object_draw = ?.
   
    if _object_draw eq ? then 
    do:
        /* If there is no object draw at this point (usually happens when
         * a user cancels out of a picker) then go back to the pointer */
        run choose-pointer.
        return.
    end.
    
    run setDrawMode.
    
    ASSIGN _next_draw   = pctool
           _custom_draw = pcCustomTool.
           
    /* Set mouse pointer to selected item */
    RUN adeuib/_setpntr.p (_next_draw, input-output _object_draw).
    
    if not IDEIntegrated then
        run setToolStatus(pcCustomTool).                                
end.

/* call back from _drawobj for most cases.  */
procedure post_drawobj_picked: 
    define input  parameter plDrawn as logical no-undo.
    /* set the window-saved state to false, since we just created an obj. */
    if plDrawn then 
        RUN adeuib/_winsave.p(_h_win, FALSE).

    /* Go back to the pointer, if desired - or if there is no point to     */
    /* staying in this mode.                                               */
    IF goback2pntr THEN
      ldummy = _h_menu_win:LOAD-MOUSE-POINTER("":U).
    ELSE DO:
      /* Make the last item drawn (which will be _h_cur_widg)
        deselected (and not selectabe) and unmovable. Also, because we are
        in draw mode. Get the correct cursor - and set _h_cur_widg to "?" */
      FIND _U WHERE _U._HANDLE = _h_cur_widg NO-ERROR.
      IF AVAIL _u THEN
        ASSIGN _U._HANDLE:MOVABLE    = FALSE 
               _U._HANDLE:SELECTABLE = FALSE
               _U._HANDLE:SELECTED   = FALSE
               _U._SELECTEDib        = FALSE  .        
      ASSIGN ldummy      = _h_win:LOAD-MOUSE-POINTER({&start_draw_cursor})
             _h_cur_widg = ?.    

      /* Reset the pointers correctly. */
      RUN adeuib/_setpntr.p (_next_draw, INPUT-OUTPUT _object_draw).
    END.
end procedure.

/* call back from _drawobj for all cases. after post_drawobj_picked   */
procedure post_drawobj: 
   /* Dynamics - Find the current object-name and assign to _U.Object-name */
  IF _next_draw NE "DB-FIELDS":U THEN
  DO:
    FIND _U WHERE _U._HANDLE = _h_cur_widg no-error.
    IF AVAIL _U AND _palette_custom_choice <> ? THEN
    DO:
      FIND _custom WHERE RECID(_custom) = _palette_custom_choice.
      ASSIGN _U._OBJECT-NAME = _custom._object_name
             _U._CLASS-NAME  = _custom._object_type_code.  
    END.
    ELSE IF AVAIL _U AND _palette_choice <> ? THEN
    DO:
      FIND _palette_item WHERE RECID(_palette_item) = _palette_choice.
      ASSIGN _U._OBJECT-NAME = _palette_item._object_name
             _u._CLASS-NAME  = _palette_item._object_class.  
    END.
     if OEIDEIsRunning and avail _U then
        run CallWidgetEvent in _h_uib(input recid(_U),"Add").
         
  END.  /* if not db-fields */
end procedure.
 
/** select tables step of field selection 
   called for non-smart objects */ 
procedure ide_select_tables_and_draw_fields:
    define input parameter MultiSelect       as logical no-undo.
    define input parameter TempTableInfo     as character no-undo.
    define input parameter DataBaseName       as character no-undo.
    define input parameter TableNames        as character no-undo.
    define variable lok                      as logical no-undo.
    
    RUN adeuib/ide/_dialog_tblsel.p 
                    (MultiSelect, 
                     TempTableInfo,
                     INPUT-OUTPUT DataBaseName, 
                     INPUT-OUTPUT TableNames,
                     OUTPUT lok).
    if not lok  or TableNames = "" or TableNames = ? then
    do:
                 
       if lok then
       do:
           if OEIDEIsRunning then
             ShowMessageInIDE("There are no database tables selected.",
                               "Information",?,"OK",YES).
           else
           MESSAGE "There are no database tables selected."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
       end.            
       RUN adecomm/_setcurs.p ("":U).       
       IF goback2pntr THEN 
          RUN choose-pointer.              
    end. 
    else      
        run select_fields_for_table(TempTableInfo,DataBaseName,TableNames).
end.  

/** called after table selection to start multi field slection
   used by drawflds  and ide_select_tables_and_draw_fields */
procedure select_fields_for_table:
    define input parameter TempTableInfo     as character no-undo.
    define input parameter DataBaseName as character no-undo.
    define input parameter TableNames   as character no-undo.
    
    define variable num_ent as integer no-undo.
    define variable tbl_list as char no-undo.
    define variable exclude-fields as character no-undo.
    define variable drawService as adeuib.ide._drawfields no-undo.
    DEFINE BUFFER x_U FOR _U.
    
    ASSIGN num_ent = NUM-ENTRIES(TableNames)
          tbl_list = TableNames.
    IF num_ent > 0 THEN DO:
    /* Get a list of "database.table,database.table" */
    DO i = 1 TO num_ent:
      ENTRY(i,tbl_list) = DataBaseName + "." + ENTRY(i,TableNames).
    END.
    
    /* Build an exclude field list of those database fields already in
       the object. Don't want them to display in the available fields list.
    */
    
    IF AVAILABLE _U THEN
    DO:
        FOR EACH x_U WHERE x_U._PARENT-Recid = RECID(_U)
                     AND   (IF x_u._TABLE = x_u._BUFFER 
                            THEN CAN-DO(tbl_list,x_u._DBNAME + "." + x_U._TABLE) 
                            
                            /* if this is a buffer the 'temp-tables' in 
                               tbl-list cannot be used to compare x_u, 
                               so we compare only the buffername  */
                            ELSE CAN-DO(REPLACE(tbl_list,"Temp-Tables.":U,"":U),
                                        x_u._BUFFER)  
                           )                       
                     AND   x_U._STATUS <> "DELETED":U NO-LOCK:
            ASSIGN exclude-fields = exclude-fields + x_u._BUFFER + "." + x_U._NAME + ",".
        END.
        ASSIGN exclude-fields = TRIM(exclude-fields, ',') NO-ERROR.
    END.
    if IDEIntegrated then
    do:
        drawService = new adeuib.ide._drawfields().
        assign
            drawService:TableList = tbl_list
            drawService:TempTableInfo = TempTableInfo
            drawService:Items = "2"
            drawService:Delimiter = ","
            drawService:ExcludeFieldNames = exclude-fields
            drawService:FieldNames = _fld_names.
        drawService:SetCurrentEvent(_h_uib,"ide_select_and_draw_fields").    
        run runChildDialog in hOEIDEService (drawService) .
/*        RETURN "IDE DRAW".*/
    end.
    else do:
        RUN adecomm/_mfldsel.p (INPUT tbl_list, INPUT ?, INPUT TempTableInfo, "2", ",", 
                                INPUT exclude-fields, INPUT-OUTPUT _fld_names).
                                
        
        RUN adecomm/_setcurs.p ("":U).
    end.
  END.
end.

/* run multi field selector and draw selected fields 
   It calls vaious post procedures that are refactored from _drawflds.p 
   which also calls these post procedures. 
 */
procedure ide_select_and_draw_fields:
    define input parameter pcTableList  as character no-undo.
    define input parameter pcTT         as character no-undo.
    define input parameter pcItems      as character no-undo.
    define input parameter pcDlmtr      as character no-undo.
    define input parameter pcExclude    as character no-undo.
    define input parameter pcFields     as character no-undo.
    
    define variable lUseDataObject      as logical   no-undo.
    define variable cSDOClobCols        as character no-undo.
    define variable hDataSource         as handle    no-undo.
    define variable cFile               as character no-undo.
    define variable cDbName             as character no-undo.
    
    FIND _U WHERE _U._HANDLE = _h_frame NO-ERROR.
    FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
    
    luseDataObject = (_P._DATA-OBJECT <> "").
    
    if luseDataObject then
    do:
       hDataSource = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, INPUT _P._DATA-OBJECT,
                                                             INPUT TARGET-PROCEDURE).
       IF NOT VALID-HANDLE(hDataSource) THEN
       DO:
           if OEIDEIsRunning then
             ShowMessageInIDE("Unable to start data object " + _P._DATA-OBJECT + ".",
                               "Information",?,"OK",yes).
           else
           MESSAGE "Unable to start data object " _P._DATA-OBJECT "."
                   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
            
           RETURN.
       END.
    
    end.
    
    RUN adeuib/ide/_dialog_mfldsel.p (pcTableList, 
                                      hDataSource, 
                                      pcTT, 
                                      pcItems, 
                                      pcDlmtr, 
                                      pcExclude, 
                                      INPUT-OUTPUT pcFields).
    if pcFields > "" then 
    do:                                  
        if lUseDataObject then
        do:
             cSDOClobCols = DYNAMIC-FUNCTION("getCLOBColumns":U IN hDataSource).
             cDbName = "Temp-Tables":U.
        end.     
        else 
            cDbName = entry(1,entry(1,pcTableList),".").
        run adeuib/_drwflds2.p(cDbName,pcTableList,pcFields,luseDataObject,cSDOClobCols,output cFile).  
        run draw_fields_from_file(cFile).
    
    end.
    RUN adecomm/_setcurs.p ("":U).
    run post_drawobj_picked(pcFields > ""). 
    run post_drawobj. 
    /* this is duplication of the code after run _drawobj.p */
    /* Show the current widget and reset the pointer. */
    IF goback2pntr THEN 
        RUN choose-pointer.
    RUN display_current.

      /* SEW Update after adding widgets in UIB. */
    RUN call_sew ("SE_ADD":U).
    
    finally:
        if luseDataObject then
           {fnarg shutdown-sdo target-procedure _h_func_lib}.    
    end finally.
END.

/**
  currently called from draw_obj which does FIND  _P 
*/     
procedure draw_fields_from_file:
    define input parameter pcFile as character no-undo.
    /* Get a list of fields, and import them into the UIB */
    SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    RUN adeuib/_qssuckr.p (pcFile, "", "IMPORT":U, TRUE).
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
     
    /* When drawing a data field for an object that is using a SmartData
       object, set the data field's Enable property based on the data object
       getUpdatableColumns. Must do this here since its not picked up automatically
       in the temp-table definition like format and label.  jep-code 4/29/98 */
    IF (AVAILABLE _P) AND (_P._data-object <> "") THEN
        RUN setDataFieldEnable IN _h_uib (INPUT RECID(_P)).
      
      /* Delete the temporary file */
    OS-DELETE VALUE(pcFile) NO-ERROR.
end.

/*****************************************************************************
  The majority of the methods used to implemented in two include files
  uibmproa.i uibmproe.i due to size limitations in the section editor. 
  The split was alphabetical... 
  The comments below are from uibmproe.i and is included for sentimental 
  reasons more than historical. They do NOT represent the actual history as 
  we stopped adding comments in headers for fixes around 2001 as it simply was 
  unpractical with the amount if changes that we were doing at this time. 
****************************************************************************/    

/*---- OLD HISTORY START -----------------------------------------------------------

File: uibmproe.i

Description:
   The internal procedures of the main routine of the UIB.  E -> Z

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

Modified:
    04/07/99  tsm  - Added support for various Intl Numeric Formats (in addition
                     to American and European) by using session set-numeric-format
                     to set format back to user's setting after setting it to 
                     American
    04/09/99  tsm  - Changed call to protools/_dblist.w (DB Connections) to call
                     run-dblist internal procedure instead which will run 
                     protools/_dblist.w persistently
    04/21/99  tsm  - Added print button to toolbar
    05/04/99  tsm  - Added support for most recently used file list 
    05/17/99  tsm  - Added support for Save All option
    06/02/99  jep  - Added Code References Window support.
    06/25/99  tsm  - Added print button to menu items that are disabled when
                     there is no file open in the AppBuilder
    06/30.99  tsm  - Changed call to mrulist.p to always use _save_file instead of
                     FILE-INFO:FULL-PATHNAME.  When a file failed to compile it
                     showed up as blank on the mru filelist.                 
    07/08/99  jep  - Added support for Editing Options menu for
                     Advanced Editing features.
    08/06/01  jep  - IZ 1508 : AppBuilder Memory Leak w/Section Editors
    08/19/01  jep  - jep-icf: Search on jep-icf changes for details.
    09/18/01  jep  - jep-icf: Display icf related status bar info with call
                     to displayStatusBarInfo. Added call for isModified to
                     determine changed status of dynamic object properties
                     in property sheet window.
    09/18/01  jep  - jep-icf: Add OpenObject_Button create for AB toolbar
                     to procedure mode-morph and enable it in enable_widgets.
    09/25/01  jep  - jep-icf: Added ICF custom files handling. Search on
                     _custom_files_savekey and _custom_files_default.
    10/02/01  jep  - IZ 1981 Saving asks for Module even if already given in New dialog
                     Fix: Saving static objects is processed in save_window
                      now.
    10/10/01  jep-icf IZ 2101 Run button enabled when editing dynamic objects.
                     Renamed h_button_bar to _h_button_bar (new shared).
    10/12/01  jep-icf IZ 2381 Save static file always asks to save to repository.
                     Revised procedure save_window and added save_window_static
                     to handle static saves properly. Static files are now saved
                     when they are already from the repository or when they are
                     being added using AppBuilder's Add to Repository option.
    02/12/02 Ross  - Revised save_window_static to check to see if it should save
                     as dynamic (viewers and browsers only at this point) then
                     call ry/prc/rygendynp.p if it should.
--- OLD HISTORY END ---------------------------------------------------------*/

PROCEDURE edit_preferences:
  RUN adeuib/_edtpref.w.
  
  /* The MRU filelist may need to be adjusted b/c the MRU preferences may
     have been changed by the user */
     
  RUN adeshar/_mrulist.p ("":U, "":U).
  
  Schema_Prefix = IF _suppress_dbname THEN 1 ELSE 2.
END.

/* editing_options - Editing Options dialog box. */
PROCEDURE editing_options.
    RUN ABEditingOptions (INPUT _h_menu_win, INPUT 'w':u).
END.

/* editMasterDataField - Procedure to bring up the data field master editor */
PROCEDURE editMasterDataField:
  DEFINE INPUT  PARAMETER hField AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cProcType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProcHandle    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(hField) THEN RETURN.
  FIND _U WHERE _U._HANDLE = hField NO-ERROR.
  IF NOT AVAILABLE _U THEN RETURN.

  RUN launchContainer IN gshSessionManager
      (INPUT "rydfobjcw",
       INPUT "",
       INPUT "rydfobjcw",
       INPUT NO,
       INPUT "",
       INPUT "",
       INPUT "",
       INPUT "",
       INPUT ?,
       INPUT ?,
       INPUT ?,
       OUTPUT hProcHandle,
       OUTPUT cProcType).

  DYNAMIC-FUNCTION("setMasterName":U IN hProcHandle,                    
                    INPUT _U._OBJECT-NAME).  

  hSDO = WIDGET-HANDLE(DYNAMIC-FUNCTION("linkHandles":U IN hProcHandle,
                                        INPUT "Datafield-Target":U)).

  DYNAMIC-FUNCTION("setUserProperty":U IN hSDO,
                   INPUT "ABDesignField":U,
                   INPUT _U._NAME + "|":U +
                         _U._TYPE + "|":U +
                         STRING(_U._WINDOW-HANDLE)).
      
  SUBSCRIBE PROCEDURE _h_menubar_proc TO "DataFieldMasterChanged":U  IN hSDO.

END PROCEDURE.  /* editMasterDataField */


/* enable_widgets - procedure to enable the UIB after another tool ran      */
procedure enable_widgets.
  DEFINE VAR cnt         AS INTEGER   NO-UNDO.
  DEFINE VAR h           AS WIDGET    NO-UNDO.
  DEFINE VAR h-tmp       AS WIDGET    NO-UNDO.
  DEFINE VAR i           AS INTEGER   NO-UNDO. 
  DEFINE VAR c           AS INTEGER   NO-UNDO.
  DEFINE VAR h-menubar   AS WIDGET    NO-UNDO.

  PAUSE 0 BEFORE-HIDE.
  ASSIGN SESSION:SYSTEM-ALERT-BOXES = YES
         SESSION:DATA-ENTRY-RETURN  = NO
         /* Reenable for user input - in case user set wait state */
         ldummy                     = SESSION:SET-WAIT-STATE ("")
         _h_menu_win:SENSITIVE      = yes    
         _h_status_line:SENSITIVE   = yes /* Status bar has dbl-click actions */
         h-menubar                  = _h_menu_win:MENU-BAR  /* jep-icf: avoid static ref */
         h-menubar:SENSITIVE        = yes                   /* jep-icf: avoid static ref */
         CURRENT-WINDOW             = _h_menu_win 
         SESSION:THREE-D            = YES
         SESSION:DATE-FORMAT        = _orig_dte_fmt.

  /* Assign UIB as currently active ade tool. */
  ASSIGN h_ade_tool = _h_uib.

  /* Restore the UIB's main window */
  IF _h_menu_win:WINDOW-STATE eq WINDOW-MINIMIZED THEN _h_menu_win:WINDOW-STATE = WINDOW-NORMAL.
  
  /* View all previously hidden child windows (this includes Cue Cards,
     object palette, design windows, and attribute window). */
  cnt = NUM-ENTRIES (windows2view).
  DO i = 1 to cnt:
    ASSIGN h = WIDGET-HANDLE(ENTRY(i,windows2view))
           h:HIDDEN = no NO-ERROR.  
    IF ERROR-STATUS:ERROR AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
    DO c = 1 TO ERROR-STATUS:NUM-MESSAGES:  
      if OEIDEIsRunning then
         ShowMessageInIDE(ERROR-STATUS:GET-MESSAGE(c),
                          "Error",?,"OK",yes).
      else  
      MESSAGE ERROR-STATUS:GET-MESSAGE(c) VIEW-AS ALERT-BOX ERROR.
    END.
  END.
  /* Show Property Editor window if need to. */
  RUN show_control_properties (INPUT 3).

  /* There is a frame bug where z-order changes when window is made visible.
     This causes SmartObjects on a FOLDER to move under the folder.  As a 
     workaround, force all PAGE-SOURCE objects to move to the bottom.
     To test the feature, add some SmO's on top of a SmartFolder.  Run the
     window.  When you return, the SmO's are under the SmartFolder. */
  FOR EACH _admlinks WHERE _admlinks._link-type eq "Page":U,
      EACH _U WHERE RECID(_U) eq INTEGER(_admlinks._link-source)
                AND _U._STATUS eq "NORMAL":
    ldummy = _U._HANDLE:MOVE-TO-BOTTOM().
  END.
  

  /* Hiding and viewing the current window will have turned off the
     display of all the visible marking of selected widgets.  Redisplay
     the current widget. */
  RUN display_current.
    
  DO WITH FRAME action_icons:
    /* Sensitize the UIB Main Window. */
    ASSIGN _h_button_bar[1]:SENSITIVE  = YES /* New */
           _h_button_bar[2]:SENSITIVE  = YES /* Open */
           Mode_Button:SENSITIVE       = YES WHEN VALID-HANDLE(Mode_Button)
           OpenObject_Button:SENSITIVE = YES WHEN VALID-HANDLE(OpenObject_Button)
           .
    RUN sensitize_main_window ("WIDGET,WINDOW").
    /* Reset the sensitivity of the fill-in fields */ 
    ASSIGN cur_widg_text:SENSITIVE = cur_widg_text:PRIVATE-DATA eq "y"
           cur_widg_name:SENSITIVE  = cur_widg_name:PRIVATE-DATA eq "y".
  END.  /* DO WITH FRAME action_icons */
      
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.

  /* SEW call to make SEW visible if it was before disabling UIB. */
  RUN call_sew ( INPUT "SE_VIEW" ).
    
  /* Go to _h_win or to the _h_menu_win if there is no _h_win. */
  IF _h_win = ? THEN h-tmp = _h_menu_win.
  ELSE IF _h_win:TYPE = "WINDOW" THEN h-tmp = _h_win.
  ELSE h-tmp = _h_win:PARENT. /* i.e. a UIB dialog-box */
  
  /* Ensure UIB Palette, Main and current design window are on top. */
  ASSIGN ldummy = _h_object_win:MOVE-TO-TOP() WHEN _AB_License NE 2
         ldummy = _h_menu_win:MOVE-TO-TOP()
         ldummy = h-tmp:MOVE-TO-TOP().

  /* If possbile, put focus in a widget in the design window. */  
  IF VALID-HANDLE( _h_cur_widg ) THEN
    APPLY "ENTRY":U TO _h_cur_widg. 
  ELSE
    APPLY "ENTRY":U TO h-tmp.
 
  /* If widget in current design window can't get focus, try UIB Main
     widget name or label fields. */
  IF NOT VALID-HANDLE( FOCUS ) THEN
  DO:
     IF cur_widg_name:SENSITIVE = TRUE THEN 
       APPLY "ENTRY":U TO cur_widg_name.
     ELSE
       APPLY "ENTRY":U TO cur_widg_text.
  END.

  /* Get rid user specified cursors */
  RUN setstatus ("":U, "":U).

END. /* PROCEDURE enable_widgets */

PROCEDURE endmove.
  DEFINE BUFFER parent_U    FOR _U.
  DEFINE BUFFER x_U         FOR _U.
  DEFINE BUFFER parent_L    FOR _L.
  DEFINE BUFFER sync_L      FOR _L.
  DEFINE VAR    recid-string AS CHARACTER NO-UNDO.
  

  FIND _U WHERE _U._HANDLE = SELF.
  FIND _L WHERE RECID(_L) = _U._lo-recid.

  /* Is this widget in a frame? */
  FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
  IF parent_U._TYPE eq "FRAME":U THEN DO:
    FIND _C WHERE RECID(_C) eq parent_U._x-recid.
    FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
    IF NOT parent_L._NO-LABELS AND NOT _C._SIDE-LABELS  /* If column labels...   */
    THEN RUN adeuib/_chkpos.p (INPUT SELF).         /* Check iteration & header  */
  END.

  IF RETURN-VALUE = "NO-ROOM" THEN RETURN.
  
  IF _undo-num-objects = ? THEN DO:
    _undo-num-objects = 0.
    FOR EACH x_U WHERE x_U._SELECTEDib:
      _undo-num-objects = _undo-num-objects + 1.
    END.
    CREATE _action.
    ASSIGN _undo-start-seq-num = _undo-seq-num
           _action._seq-num    = _undo-seq-num
           _action._operation  = "StartMove"
           _undo-seq-num       = _undo-seq-num + 1.
  END.

  recid-string = "".
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid =  _L._u-recid AND
                          sync_L._lo-name NE _L._lo-name AND
                          NOT sync_L._CUSTOM-POSITION:
       ASSIGN sync_L._ROW = ((SELF:ROW - 1) / _cur_row_mult) + 1
              sync_L._COL = ((SELF:COL - 1) / _cur_col_mult) + 1
              recid-string    = recid-string + STRING(RECID(sync_L)) + ",".
    END.  /* For each alternative layout */
  END.  /* If moving something in the master layout */
  ELSE _L._CUSTOM-POSITION = TRUE.   /* This is now a custom position. */
                     
  CREATE _action.
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Move"
         _action._u-recid       = RECID(_U)
         _action._window-handle = _U._WINDOW-HANDLE
         _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW)
         _action._other_Ls      = recid-string
         _undo-seq-num          = _undo-seq-num + 1
         _undo-num-objects      = _undo-num-objects - 1.

  IF _undo-num-objects < 1 THEN DO:
    CREATE _action.
    ASSIGN _action._seq-num    = _undo-seq-num
           _action._operation  = "EndMove"
           _undo-seq-num       = _undo-seq-num + 1
           _action._data       = STRING(_undo-start-seq-num)
           _undo-start-seq-num = ?
           _undo-num-objects   = ?.
    RUN UpdateUndoMenu("&Undo Move").

    /* The move operation is complete, now update the file-saved field */
    RUN adeuib/_winsave.p(_h_win, FALSE).
  END.      
    
  /* If a SmartObject has been moved, use the set-position method to
     try and move it. */
  IF _U._TYPE eq "SmartObject":U THEN DO:
    FIND _S WHERE RECID(_S) eq _U._x-recid.
    IF _S._visual THEN DO:
      FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
      IF _P._adm-version < "ADM2" THEN
        RUN set-position IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
      ELSE
        RUN repositionObject IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.        
    END. /* If _S._VISUAL */
  END.

  /* Assign the new location. */
  ASSIGN _L._COL  = ((SELF:COL - 1) / _cur_col_mult) + 1
         _L._ROW  = ((SELF:ROW - 1) / _cur_row_mult) + 1.

  /* Adjusts for TTY Frames, and takes care of storing integer values for TTY. 
     Will overwrite the above assigned values when it needs to. */
  { adeuib/ttysnap.i &hSELF   = SELF       
                     &hPARENT = parent_U._HANDLE
                     &U_Type  = _U._TYPE
                     &Mode    = "MOVE"
                     }

  /* Move a fill-in's label */
  IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
    RUN adeuib/_showlbl.p (SELF).
    SELF:SELECTED = TRUE.
  END. 
  
  /* Update the Geometry in the Attribute Window, if necessary. */
  IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
  THEN RUN show-geometry IN hAttrEd NO-ERROR.

  /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_Changegeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.


END.


PROCEDURE endresize.
  DEFINE BUFFER parent_U    FOR _U.
  DEFINE BUFFER parent_L    FOR _L.
  DEFINE BUFFER x_U    FOR _U.
  DEFINE BUFFER x_L    FOR _L.
  DEFINE BUFFER sync_L FOR _L.
  DEFINE VARIABLE frame_rec    AS RECID                                  NO-UNDO.
  DEFINE VARIABLE fg_handle    AS WIDGET-HANDLE                          NO-UNDO.
  DEFINE VARIABLE recid-string AS CHAR                                   NO-UNDO. 
  
  FIND _U WHERE _U._HANDLE = SELF.
  FIND _L WHERE RECID(_L)  = _U._lo-recid.

  /* Have we resized a widget in a column-label frame? */
  /* First see if the widget is in a frame. */
  FIND parent_U WHERE RECID(parent_U) eq _U._parent-recid.
  IF parent_U._TYPE eq "FRAME":U THEN DO:
    FIND _C WHERE RECID(_C) eq parent_U._x-recid.
    FIND parent_L WHERE RECID(parent_L) eq parent_U._lo-recid.
    IF NOT parent_L._NO-LABELS AND NOT _C._SIDE-LABELS   /* If column labels ...  */
    THEN DO:
      RUN adeuib/_chkpos.p (INPUT SELF).              /* Check iteration & header  */
      IF RETURN-VALUE = "NO-ROOM" THEN RETURN.        
    END.
  END.
  
  /* Are we resizing a frame? */
  IF _U._TYPE eq "FRAME":U THEN DO: 
    FIND x_U WHERE x_U._HANDLE = SELF.         /* See if all children fit   */
    FIND _C WHERE RECID(_C) eq x_U._x-recid.
    FIND x_L WHERE RECID(x_L) eq x_U._lo-recid.
    frame_rec = RECID(x_U).
    IF NOT x_L._NO-LABELS AND NOT _C._SIDE-LABELS   /* If column labels          */
    THEN DO:
      FOR EACH x_U WHERE x_U._PARENT-RECID = frame_rec AND
                         NOT x_U._NAME BEGINS "_LBL":
        RUN adeuib/_chkpos.p (INPUT x_U._HANDLE).
        IF RETURN-VALUE = "NO-ROOM" THEN RETURN.
      END.  /* For each child widget                                        */
    END.  /* A down frame with labels - make sure everything fits           */
  END.  /*  A frame has been resized                                        */
  
  CREATE _action.
  ASSIGN _undo-start-seq-num = _undo-seq-num
         _action._seq-num    = _undo-seq-num
         _action._operation  = "StartResize"
         _undo-seq-num       = _undo-seq-num + 1.

  recid-string = "".
  IF _L._LO-NAME = "Master Layout" THEN DO:
    FOR EACH sync_L WHERE sync_L._u-recid  = _L._u-recid AND
                          sync_L._LO-NAME NE _L._LO-NAME AND
                          NOT sync_L._CUSTOM-SIZE:
      recid-string = recid-string + STRING(RECID(sync_L)) + ",".
    END.
  END.  /* If changing the Master Layout */
  ELSE _L._CUSTOM-SIZE = TRUE.
  
  CREATE _action.
  ASSIGN _action._seq-num       = _undo-seq-num
         _action._operation     = "Resize"
         _action._u-recid       = RECID(_U)
         _action._window-handle = _U._WINDOW-HANDLE
         _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW) + "|":U +
                    STRING(_L._WIDTH) + "|":U + STRING(_L._HEIGHT)
         _action._other_Ls      = recid-string                   
         _undo-seq-num          = _undo-seq-num + 1.

  CREATE _action.
  ASSIGN _action._seq-num = _undo-seq-num
         _action._operation = "EndResize"
         _undo-seq-num = _undo-seq-num + 1
         _action._data = STRING(_undo-start-seq-num)
         _undo-start-seq-num = ?.
  RUN UpdateUndoMenu("&Undo Resize").

  /* Setting size can cause a variety of errors... trap these explicitly. */
  Size-Block:
  DO ON ERROR UNDO Size-Block, LEAVE Size-Block 
     ON STOP  UNDO Size-Block, LEAVE Size-Block:
    /* Handle TTY mode for all objects. */
    IF (_L._WIN-TYPE eq NO) 
    THEN DO:
      SELF:HIDDEN = TRUE.
      /* Make sure TTY mode heights are 1 row high                              */
      IF CAN-DO("BROWSE,BUTTON,TEXT,FILL-IN,COMBO-BOX,TOGGLE-BOX":U,_U._TYPE) THEN
        ASSIGN SELF:HEIGHT  = _L._ROW-MULT
               _L._HEIGHT = 1
               _L._WIDTH  = SELF:WIDTH / _L._COL-MULT.
      ELSE IF _U._TYPE eq "SLIDER" THEN DO:
        fg_handle = SELF:PARENT.
        IF SELF:HORIZONTAL THEN DO:
          IF (SELF:ROW - 1) + 2 * _L._ROW-MULT > fg_handle:HEIGHT THEN
            SELF:ROW = (fg_handle:HEIGHT - 2 * _L._ROW-MULT) + 1.          
          ASSIGN SELF:HEIGHT = 2 * _L._ROW-MULT
                 _L._HEIGHT  = 2
                 _L._WIDTH   = INTEGER(SELF:WIDTH / _L._COL-MULT).
        END. /* HORIZONTAL */
        ELSE DO:
          IF (SELF:COLUMN - 1) + 9 * _cur_col_mult > fg_handle:WIDTH THEN
            SELF:COLUMN = (fg_handle:WIDTH - 9 * _L._COL-MULT) + 1.
          ASSIGN SELF:WIDTH = MAX(SELF:WIDTH, 9 * _L._COL-MULT)
                  _L._WIDTH = INTEGER(SELF:WIDTH-CHARS / _L._COL-MULT).
        END. /* Not HORIZONTAL */  
      END. /* A SLider */   
      ELSE IF _U._TYPE eq "SmartObject":U THEN DO:
      RUN adeuib/_setsize.p (RECID(_U), INTEGER(SELF:HEIGHT / _L._ROW-MULT),
                                        INTEGER(SELF:WIDTH  / _L._COL-MULT)).
      END.
      IF CAN-DO("BUTTON,COMBO-BOX,FILL-IN",_U._TYPE) THEN DO:
        IF _U._SUBTYPE NE "TEXT" THEN RUN adeuib/_sim_lbl.p (SELF).
      END. /* A Button */
      ASSIGN SELF:HIDDEN   = FALSE
             SELF:SELECTED = _U._SELECTEDib.
    END. /* IF TTY MODE */
    
    /* If a SmartObject has been resized.  Make sure that the widget knows about
       the new size (so that it can respond to the size change).   We do this 
       by sending the Object the "set-size" method. This is done inside
       the "_setsize.p" which also handles sizing our visualization.
       (Note that a RESIZE can also change an object's position, 
        so call set-position as well.) */
    ELSE IF _U._TYPE eq "SmartObject":U THEN DO:
      RUN adeuib/_setsize.p (RECID(_U), SELF:HEIGHT / _L._ROW-MULT,
                                        SELF:WIDTH  / _L._COL-MULT).
      FIND _S WHERE RECID(_S) eq _U._x-recid.
      IF _S._visual THEN DO: 
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
        IF _P._adm-version < "ADM2" THEN
          RUN set-position IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
        ELSE
          RUN repositionObject IN _S._HANDLE (SELF:ROW, SELF:COLUMN) NO-ERROR.
      END.  /* If _S._VISUAL */
    END. /* IF..."SmartObject"... */

    ELSE IF _U._TYPE = "IMAGE":U THEN DO:
      FIND _F WHERE RECID(_F) = _U._x-recid.
      IF _F._IMAGE-FILE NE "" THEN _U._HANDLE:LOAD-IMAGE(_F._IMAGE-FILE).    
    END.  /* If an end-resize of an image */
      
    /* The resize operation is complete, now update the file-saved field */
    RUN adeuib/_winsave.p(_h_win, FALSE).
  
    /* Assign the new size and position (NOTE if you resize the top left, you
       change the position as well as size )*/
    IF _U._TYPE = "FRAME" AND NOT _L._WIN-TYPE THEN DO:
      /* Update the Universal widget's H,W, Row, and Col and adjust for TTY Frame. 
        We also update the _U pixels information as well (X,Y,H-P,W-P) and
        store tty values as integers. Overwrites above assigned values
        when needed for frames */
    { adeuib/ttysnap.i &hSELF   = SELF       
                       &hPARENT = parent_U._HANDLE
                       &U_Type  = _U._TYPE
                       &Mode    = "RESIZE" 
                       }
    END.
    ELSE ASSIGN _L._COL      = ((SELF:COL - 1) / _L._COL-MULT) + 1
                _L._ROW      = ((SELF:ROW - 1) / _L._ROW-MULT) + 1
                _L._HEIGHT   = SELF:HEIGHT-CHARS / _L._ROW-MULT
                _L._WIDTH    = SELF:WIDTH-CHARS / _L._COL-MULT.
     
    IF _U._TYPE = "FRAME" THEN DO:
      IF NOT _C._SCROLLABLE THEN
         ASSIGN _L._VIRTUAL-WIDTH  = _L._WIDTH
                _L._VIRTUAL-HEIGHT = _L._HEIGHT.
      ELSE ASSIGN _L._VIRTUAL-WIDTH  = SELF:VIRTUAL-WIDTH
                  _L._VIRTUAL-HEIGHT = SELF:VIRTUAL-HEIGHT.
    END. /* A Frame */
           
    IF recid-string NE "" THEN DO i = 1 TO NUM-ENTRIES(recid-string) - 1:
      FIND sync_L WHERE RECID(sync_L) = INTEGER(ENTRY(i,recid-string)).
      ASSIGN sync_L._COL    = _L._COL
             sync_L._ROW    = _L._ROW
             sync_L._HEIGHT = _L._HEIGHT
             sync_L._WIDTH  = _L._WIDTH.
      IF _U._TYPE = "FRAME" THEN DO:
        IF NOT _C._SCROLLABLE THEN
          ASSIGN sync_L._VIRTUAL-WIDTH  = _L._WIDTH
                 sync_L._VIRTUAL-HEIGHT = _L._HEIGHT.
      END. /* A Frame */
    END. /* DO  1 to num-entries */
             
    /* Move a fill-in's label */
    IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
      RUN adeuib/_showlbl.p (SELF).
      SELF:SELECTED = TRUE.
    END. /* Fill-in or combo-box */
             
    /* Do our own redraw for editor in tty-mode */
    IF (NOT _L._WIN-TYPE AND _U._TYPE = "Editor") THEN DO:
      FIND _F WHERE RECID(_F) = _U._x-recid.
      RUN adeuib/_ttyedit.p (_U._HANDLE, _F._SCROLLBAR-H, _U._SCROLLBAR-V).
      IF _F._INITIAL-DATA NE "" THEN
        _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.
    END.  /* Editor in TTY Mode */
  END. /* Size-Block: DO:... */

  /* Check to see if this is a "LIKE" variable so we can set SIZE-SOURCE
     to Explicit                                                          */
  FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
  IF AVAILABLE (_F) AND _F._DISPOSITION = "LIKE":U THEN
    _F._SIZE-SOURCE = "E":U.
  
  /* Update the Geometry in the Attribute Window, if necessary. */
  IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
  THEN RUN show-geometry IN hAttrEd NO-ERROR.

  /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_Changegeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.

END.  /* endresize */


PROCEDURE Even-l-to-r.  /* Evenly space widgets from left to right */
  RUN adeuib/_align.p ("E-l-to-r", ?).
END PROCEDURE.  /* Even-l-to-r */


PROCEDURE Even-t-to-b.  /* Even spacing from top to bottom */
  RUN adeuib/_align.p (?, "E-t-to-b").
END PROCEDURE.  /* Even-t-to-b */

PROCEDURE exit_proc:
  APPLY "WINDOW-CLOSE":U TO _h_menu_win.
END PROCEDURE.  /* exit_proc */

/* frame-select-up  - short tag to run this on frame select up.            */
/*             This is run for both FRAMES and DIALOG-BOXES.               */
/*             Look at the function and decide what to do.  This routine   */
/*        This routine lets us click respond differently toframe      */
/*             events which are all triggered by a MOUSE-SELECT-UP         */
/*             We also call this with MOUSE-EXTEND-UP, because it uses the */
/*             same mouse button in MS-WINDOWS (Ctrl-SELECT == EXTEND)     */
procedure frame-select-up.
  DEFINE BUFFER frame_U FOR _U.
  DEFINE BUFFER ipU FOR _U.
  
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("frame-select-up"). &ENDIF
 
  CASE LAST-EVENT:FUNCTION :
     WHEN "" OR WHEN "MOUSE-SELECT-CLICK" OR WHEN "MOUSE-EXTEND-CLICK" THEN 
      run drawobj-or-select.
    WHEN "MOUSE-SELECT-DBLCLICK" THEN RUN double-click.
    WHEN "END-BOX-SELECTION" THEN DO:
      IF _next_draw ne ? THEN RUN drawobj-in-box. 
      ELSE DO:
        /* Box-selecting is over. Redisplay the current widget. */
        box-selecting = no.
    
        /* If nothing is selected in the frame, then the current widget has been set
           to the window, but this has not been displayed.  (display_current did not
           actually display the widget because we wanted to avoid flashing).  If this
           is the case, then we need to actually display the current selection.  If
           something was selected, then we want to show the selection. */
        FIND frame_U WHERE frame_U._HANDLE eq SELF.
        FIND FIRST _U WHERE _U._SELECTEDib 
                        AND _U._parent-recid eq RECID(frame_U) NO-ERROR.
        IF AVAILABLE _U THEN DO: 
          /* Is there anything selected in any other window? If so, deselect it. */     
          IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                                   AND ipU._WINDOW-HANDLE ne _U._WINDOW-HANDLE) 
          THEN RUN deselect_all (SELF, _U._WINDOW-HANDLE).
                                                              
          /* Are there still two things selected?  If so, don't show a single
             current widget. */
          IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib 
                                   AND ipU._HANDLE ne _U._HANDLE)
          THEN _h_cur_widg = ?.
          ELSE RUN changewidg (_U._HANDLE, no).
        END.   
        /* If there is a new widget selected then display the values.
           Even if no new widget is selected, the number of widgets selected
           may have changed, so we still want to sensitize the buttons in
           the window. */
        IF h_display_widg ne _h_cur_widg THEN RUN display_current.
        ELSE DO:
          /* Show the current values of the selected set of widgets in the 
             Attributes window. (Note: This was done in "display_current.) */
          IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
          THEN RUN show-attributes IN hAttrEd NO-ERROR.
          RUN show_control_properties (INPUT 0).
          /* Update the main window. */
          RUN sensitize_main_window ("WIDGET").    
        END. 
      END.
    END. /* when end-box-selection... */   
  END CASE.
END PROCEDURE.

/* frame-startboxselect  - Change the cursor in the current window to the    */
/*                         end-draw value if we are drawing.  If we are      */
/*                         actually marking, note that we don't need to      */
/*                         redisplay the selection.                          */
procedure frame-startboxselect.
  if _next_draw <> ? THEN
    ASSIGN ldummy = _h_win:MOVE-TO-TOP()
           ldummy = _h_win:LOAD-MOUSE-POINTER({&end_draw_cursor}). 
  ELSE box-selecting = YES.
END.

/* get-attribute  - Return some internal attribute of the UIB (as the RETURN-
 * VALUE.  For example, return the handle of the Section Editor. 
 */
procedure get-attribute :
  define input parameter p_name as char no-undo.
  
  CASE p_name:
    WHEN "Section-Editor-Handle"   THEN RETURN STRING(hSecEd).
    WHEN "Attribute-Window-Handle" OR WHEN "Group-Properties-Window-Handle" 
    THEN DO:
      /* Watch out -- the attribute window could have been deleted and the
         procedure handle reused.  Check for this case. */
      IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME ne "{&AttrEd}"
      THEN hAttrEd = ?.
      RETURN STRING(hAttrEd).
    END.
  END CASE.

END.

/* Load another custom object file */
PROCEDURE get_custom_widget_defs : 
  DEFINE VARIABLE rc       AS LOGICAL NO-UNDO. /* return code yes=ok no=cancel */
  DEFINE VARIABLE cList AS CHARACTER NO-UNDO. /* Add Palette/Template to list */

  RUN setstatus ("":U, "Select custom object files...":U).
   /* If Dynamics is running and it's using the cst in the repository, send template and palette objects */
  IF CAN-DO(_AB_Tools,"Enable-ICF") AND _dyn_cst_template > "" AND _dyn_cst_palette > "" THEN
  DO:
     ASSIGN cList = "~~@DummyTemplates:,*************,":U +  _dyn_cst_template
            cList = clist + ",,Palettes:,************," + _dyn_cst_palette.
  
     if IDEIntegrated then  
         RUN adeuib/ide/_dialog_getcust.p (INPUT-OUTPUT cList, OUTPUT rc). /* ask for file */  
  
     else    
         RUN adeuib/_getcust.w (INPUT-OUTPUT cList, OUTPUT rc). /* ask for file */  
  END.
  ELSE DO: 
     if IDEIntegrated then  
         RUN adeuib/ide/_dialog_getcust.p (INPUT-OUTPUT {&CUSTOM-FILES}, OUTPUT rc). /* ask for file */  
  
     else    
         RUN adeuib/_getcust.w (INPUT-OUTPUT {&CUSTOM-FILES}, OUTPUT rc). /* ask for file */  
  end.  
  IF NOT rc THEN DO: /* cancelled. */
    RUN setstatus("":U,"":U).
    RETURN.
  END.
  RUN update_palette.
END.       

PROCEDURE hide_ab_in_desktop:
    run show_uibmain_in_desktop(false).
    run show_palette_in_desktop(false).
END.

/* GetParent - Get the parent of a Progress window (real HWND) */
PROCEDURE GetParent EXTERNAL "USER32.DLL":
   DEFINE INPUT  PARAMETER in-hwn AS LONG.
   DEFINE RETURN PARAMETER hwnd   AS LONG.
END.  

procedure LoadIDEPreferences:
    define variable phand as handle no-undo. 
    run adeuib/_oeidepref.p PERSISTENT SET phand.
    run getIDEproperties in phand (input open_file).
    run getIDEpreferences in phand (input open_file).
       
    finally:
        if valid-handle(phand) then
            delete object phand no-error.
    end finally.
end procedure.      

/* Check to see if there any dirty OCX controls */
PROCEDURE is_control_dirty.
  DEFINE INPUT  PARAMETER hWindow   AS WIDGET  NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Dirty   AS LOGICAL NO-UNDO INITIAL FALSE.
  
  DEFINE VARIABLE s AS INTEGER NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.
  

  FOR EACH x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                AND (    x_U._WINDOW-HANDLE = hWindow 
                     AND x_U._STATUS <> "DELETED":u):
      p_Dirty = x_U._COM-HANDLE:Dirty.
      IF p_Dirty THEN LEAVE.
  END.

END.

/* Set Dirty attribute for all OCX controls. */
PROCEDURE Set_Control_Dirty.
  DEFINE INPUT  PARAMETER hWindow   AS WIDGET  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Dirty   AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE s AS INTEGER NO-UNDO.
  
  DEFINE BUFFER x_U FOR _U.

  FOR EACH x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                AND (    x_U._WINDOW-HANDLE = hWindow 
                     AND x_U._STATUS <> "DELETED":u):
      ASSIGN x_U._COM-HANDLE:Dirty = p_Dirty.
  END.

END.


/* Launch a dynamic object */
PROCEDURE launch_object.
  DEFINE INPUT  PARAMETER pRecid     AS RECID      NO-UNDO.

  DEFINE VARIABLE lMultiInstance              AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cChildDataKey               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRunAttribute               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerWindow            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerSource            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObject                     AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hRunContainer               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cRunContainerType           AS CHARACTER    NO-UNDO.

  FIND _P WHERE RECID(_P) = pRecid.

  /* Assume user wants the cache cleared, if not they need to use the 
     dynamic launcher noddy                                           */
  IF VALID-HANDLE(gshRepositoryManager) THEN
    RUN clearClientCache IN gshRepositoryManager.

  ASSIGN
    lMultiInstance    = NO
    cChildDataKey     = "":U
    cRunAttribute     = "":U
    hContainerWindow  = ?
    hContainerSource  = ?
    hObject           = ?
    hContainerWindow  = ?
    cRunContainerType = "":U
    .

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
    RUN launchContainer IN gshSessionManager
        (INPUT  _P._save-as-file     /* object filename if physical/logical names unknown */
        ,INPUT  "":U                 /* physical object name (with path and extension) if known */
        ,INPUT  _P._save-as-file     /* logical object name if applicable and known */
        ,INPUT  (NOT lMultiInstance) /* run once only flag YES/NO */
        ,INPUT  "":U                 /* instance attributes to pass to container */
        ,INPUT  cChildDataKey        /* child data key if applicable */
        ,INPUT  cRunAttribute        /* run attribute if required to post into container run */
        ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
        ,INPUT  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
        ,INPUT  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
        ,INPUT  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
        ,OUTPUT hRunContainer        /* procedure handle of object run/running */
        ,OUTPUT cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
        ).
    
    IF VALID-HANDLE(hRunContainer) THEN
    WAIT-FOR WINDOW-CLOSE, CLOSE OF hRunContainer. 

  END.  /* do on stop, on error */

  /* Choosing the stop button raises the stop condition and leaves the DO 
     block so the container that was launched needs to be closed. */
  IF VALID-HANDLE(hRunContainer) THEN APPLY "CLOSE":U TO hRunContainer.

END.  /* PROCEDURE launch_object */


/* The mode between local and remote has changed */
PROCEDURE mode_change.
  IF SELF:PRIVATE-DATA EQ "Local" THEN DO:
    /* Switching from local to remote */
    ASSIGN SELF:PRIVATE-DATA = "Remote"
           SELF:TOOLTIP      = "Switch to local development"
           _remote_file      = Yes
           SELF:VISIBLE      = NO.
    ASSIGN ldummy = SELF:LOAD-IMAGE-UP({&ADEICON-DIR} + "remote" +
                    "{&BITMAP-EXT}") NO-ERROR.
    IF ldummy ne YES or ERROR-STATUS:ERROR                
    THEN ASSIGN Stop_Button:LABEL = "Remote".
    PUT-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE("Yes":U).
  END.  /* If switching from local to remote */
  ELSE DO:  /* Switching from remote to local */
    ASSIGN SELF:PRIVATE-DATA = "Local"
           SELF:TOOLTIP      = "Switch to remote development"
           _remote_file      = No
           SELF:VISIBLE      = NO.
    ASSIGN ldummy = SELF:LOAD-IMAGE-UP({&ADEICON-DIR} + "Local" +
                    "{&BITMAP-EXT}") NO-ERROR.
    IF ldummy ne YES or ERROR-STATUS:ERROR                
    THEN ASSIGN Stop_Button:LABEL = "Local".
    PUT-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE("No":U).
  END. /* Else switch from remote to local */
  SELF:VISIBLE = YES.
END.  /* Procedure mode_change */

/* The _visual-obj variable has changed, have the tool morph */
PROCEDURE mode-morph.
  DEFINE INPUT PARAMETER mode   AS CHARACTER   NO-UNDO.
  /* Mode is one of "INIT", "UIB", or "WEB"                  */
  
  DEFINE VARIABLE ActiveWindows AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE ActiveItem    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE h_menu-bar    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_sm          AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_s           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h             AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_f           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE v             AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE rh            AS HANDLE      NO-UNDO.
  DEFINE VARIABLE h_icfmenubar  AS HANDLE      NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER NO-UNDO.
  DEFINE VARIABLE AboutImage    AS CHARACTER   NO-UNDO.

  /* jep-icf: Check to see if we should replace the AB menubar with ICF menubar. */
  IF (mode = "INIT":U) AND CAN-DO(_AB_Tools,"Enable-ICF") THEN
  DO ON ERROR UNDO, LEAVE:
      /* Start persistent AB Menubar Procedure. */
      RUN adeuib/_abmbar.w PERSISTENT SET _h_menubar_proc.
      IF VALID-HANDLE(_h_menubar_proc) THEN
      DO:
        /* Get the handle of the menubar that replaces the AB default menubar. */
        RUN getMenubarHandle IN _h_menubar_proc (INPUT MENU m_menubar:HANDLE, OUTPUT h_icfmenubar).
        /* Replace the AB's default menu-bar with the new one. */
        ASSIGN _h_menu_win:MENU-BAR = h_icfmenubar.
        /* Display icf related status bar info. */
        RUN displayStatusbarInfo IN _h_menubar_proc.
      END.
  END.

  ASSIGN last-mode  = mode
         h_menu-bar = _h_menu_win:MENU-BAR.

  IF mode = "INIT" THEN DO: /* This is the INIT case - create necessary stuff */
  
    /* Set AppBuilder's About box image. */
    ASSIGN AboutImage = IF (_AB_License = 2) THEN "adeicon/workshp%.ico":U ELSE "adeicon/uib%.ico":U.
    ASSIGN AboutImage = "adeicon/icfdev.ico" WHEN CAN-DO(_AB_Tools, "Enable-ICF":u).

    /* jep-icf: Set handles of several AB menus and items. The menubar may be the
       default statically defined AB menubar or one that's taken it's place. So
       we must reference menus and menu items with handles instead.
       Note: If the order of the File and Edit menu's ever changes, this code will
       need updating. */
    ASSIGN m_menubar  = _h_menu_win:MENU-BAR.
    ASSIGN m_hFile    = h_menu-bar:FIRST-CHILD. /* jep-icf: File menu. */
    ASSIGN m_hEdit    = m_hFile:NEXT-SIBLING.   /* jep-icf: Edit menu. */
  
    /* jep-icf: "Open Object" Button takes the place of "Open" button and shifts all remaining buttons to the right. */
    IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
    DO:
      ASSIGN i = LOOKUP( "Open" , bar_labels).
      CREATE BUTTON OpenObject_Button
        ASSIGN FRAME        = _h_button_bar[i]:FRAME
               X            = _h_button_bar[i]:X
               Y            = _h_button_bar[i]:Y
               WIDTH-P      = _h_button_bar[i]:WIDTH-P
               HEIGHT-P     = _h_button_bar[i]:HEIGHT-P
               PRIVATE-DATA = "openobject":U
               BGCOLOR      = _h_button_bar[i]:BGCOLOR
               FONT         = _h_button_bar[i]:FONT
               TOOLTIP      = "Open Object"
               NO-FOCUS     = YES
               FLAT-BUTTON  = YES
               HIDDEN       = YES
               SENSITIVE    = FALSE
        TRIGGERS:
            ON CHOOSE PERSISTENT RUN choose_object_open IN _h_UIB.
        END TRIGGERS.

      ldummy = OpenObject_Button:LOAD-IMAGE-UP({&ADEICON-DIR} + OpenObject_Button:PRIVATE-DATA) NO-ERROR.
      
      /* Starting with the "Open" button (2), move the remaining toolbar buttons to the right. */
      DO i = 2 to bar_count:
          /* Make adjustments for buttons that have the rectangles between them. */
          IF i = 5 OR i = 8 THEN
            ASSIGN _h_button_bar[i]:X = _h_button_bar[i]:X + 30.
          ELSE
            ASSIGN _h_button_bar[i]:X = _h_button_bar[i]:X + 25.
      END.  /* DO i = 1 to bar_count */
      
      /* Adjust all the icon group rectangles for the new icf buttons. */
      ASSIGN  group1:WIDTH-P IN FRAME action_icons = group1:WIDTH-P IN FRAME action_icons + 25
              group2:WIDTH-P IN FRAME action_icons = group2:WIDTH-P IN FRAME action_icons + 25
              group3:WIDTH-P IN FRAME action_icons = group3:WIDTH-P IN FRAME action_icons + 50
              group4:WIDTH-P IN FRAME action_icons = group4:WIDTH-P IN FRAME action_icons + 50 NO-ERROR.
              
      ASSIGN OpenObject_Button:HIDDEN    = FALSE
             OpenObject_Button:SENSITIVE = YES.
      
      IF CAN-DO(_AB_Tools,"Enable-ICF") AND VALID-HANDLE(_h_menubar_proc) THEN
         RUN addPropertyButton IN _h_menubar_proc (INPUT bar_count) NO-ERROR.

    END. /* Enable-ICF */


    /* Do the visual part first */
    IF _AB_license > 1 THEN DO: /* WebSpeed is licensed then create the 
                                   mode button.                          */
 
      CREATE BUTTON Mode_Button
      ASSIGN FRAME       = FRAME action_icons:HANDLE
            X            = /*_h_status_line:X + _h_status_line:WIDTH-PIXELS -
                                              _h_button_bar[1]:WIDTH-PIXELS -
                                              SESSION:PIXELS-PER-COLUMN*/
                           IF CAN-DO(_AB_Tools,"Enable-ICF") AND VALID-HANDLE(_h_menubar_proc) 
                           THEN  _h_button_bar[10]:X + _h_button_bar[10]:WIDTH-P + 31
                           ELSE  _h_button_bar[10]:X + _h_button_bar[10]:WIDTH-P + 6
            Y            = _h_button_bar[1]:Y
            WIDTH-P      = _h_button_bar[1]:WIDTH-P
            HEIGHT-P     = _h_button_bar[1]:HEIGHT-P
            PRIVATE-DATA = "Local":U
            BGCOLOR      = _h_button_bar[1]:BGCOLOR
            FONT         = 4
            TOOLTIP      = "(Local/Remote)"
            NO-FOCUS     = YES
            FLAT-BUTTON  = YES
            HIDDEN       = YES
            SENSITIVE    = FALSE
          TRIGGERS:
            ON CHOOSE PERSISTENT RUN mode_change.
          END TRIGGERS. 
      /* Initialize the button */
      GET-KEY-VALUE SECTION "ProAB" KEY "RemoteFileManagement" VALUE v.
      ASSIGN _remote_file = NOT((last-mode EQ ?) OR CAN-DO ("False,no,off", v))
             Mode_Button:PRIVATE-DATA = IF _remote_file THEN "remote" ELSE "local"
             Mode_Button:TOOLTIP = IF _remote_file THEN "Switch to local development"
                                                   ELSE "Switch to remote development"
             ldummy       = Mode_Button:LOAD-IMAGE-UP({&ADEICON-DIR} + 
                            Mode_Button:PRIVATE-DATA + 
                           "{&BITMAP-EXT}") NO-ERROR.
      /* Add label in case image fails to load */
      IF ldummy ne YES or ERROR-STATUS:ERROR 
      THEN ASSIGN Mode_Button:LABEL = "Mode".

      IF OEIDEIsRunning THEN
        ASSIGN Mode_button:HIDDEN    = FALSE
               Mode_button:SENSITIVE = NO
               _remote_file          = FALSE.
      ELSE      
        ASSIGN Mode_button:HIDDEN    = FALSE
               Mode_button:SENSITIVE = YES.
    END.  /* If WebSpeed is licensed create the mode button */
  
    /* Create the visible menu-bar items */
    ASSIGN h           = h_menu-bar
           _visual-obj = no.
    /* _h_button_bar[10] is the color button */
    IF _AB_License = 2 THEN DO: /* WebSpeed only */
      ASSIGN _h_button_bar[10]:HIDDEN = TRUE.
      /* Reposition the last two toolbar rectangles
         and the mode button */
      ASSIGN rh = _h_button_bar[10]:FRAME
             rh = rh:FIRST-CHILD
             rh = rh:FIRST-CHILD.
      DO WHILE rh <> ?:
        IF rh:PRIVATE-DATA = "group3":U OR
           rh:PRIVATE-DATA = "group4":U THEN 
             rh:WIDTH-P = rh:WIDTH-P - _h_button_bar[10]:WIDTH-P.
        ASSIGN rh = rh:NEXT-SIBLING.
      END.
      ASSIGN Mode_Button:X = Mode_Button:X - _h_button_bar[10]:WIDTH-P.
    END.
    ELSE DO:  /* UIB is licensed */
      ASSIGN _h_button_bar[10]:HIDDEN    = FALSE
             _h_button_bar[10]:SENSITIVE = FALSE.

      /* Add Layout Menu */
      CREATE SUB-MENU m_layout ASSIGN LABEL = "&Layout" SENSITIVE = YES
                   PARENT = h.
      CREATE MENU-ITEM mi_chlayout ASSIGN LABEL = "Alternate &Layout..."
                   PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN morph_layout in _h_uib. END TRIGGERS.
      CREATE MENU-ITEM mi_chCustLayout ASSIGN LABEL = "Custom &Layout..."
                   PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN morph_layout in _h_uib. END TRIGGERS.
      IF _DynamicsIsRunning THEN
        CREATE MENU-ITEM mi_CustomParams ASSIGN LABEL = "Customization &Priority..."
                     PARENT = m_layout
           TRIGGERS: ON CHOOSE PERSISTENT RUN Change_Customization_Parameters.
           END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                   PARENT = m_layout.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "&Center Left-to-Right in Frame"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Center-l-to-r. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Center Top-to-Bottom in &Frame"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Center-t-to-b. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                   PARENT = m_layout.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "&Even Spacing Left-to-Right"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Even-l-to-r. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Even &Spacing Top-to-Bottom"
                   PARENT = m_layout SENSITIVE = TRUE
         TRIGGERS: ON CHOOSE PERSISTENT RUN Even-t-to-b. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                    PARENT = m_layout.
      CREATE MENU-ITEM mi_topmost ASSIGN LABEL = "Move-to-&Top"       PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN movetotop. END TRIGGERS.
      CREATE MENU-ITEM mi_bottommost ASSIGN LABEL = "Move-to-&Bottom" PARENT = m_layout
         TRIGGERS: ON CHOOSE PERSISTENT RUN movetobottom. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                    PARENT = m_layout.
      CREATE SUB-MENU m_align ASSIGN LABEL = "&Align"                 PARENT = m_layout.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Colons"                     PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("COLON", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN SUBTYPE = "RULE"                      PARENT = m_align.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Left Sides"                 PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("LEFT", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Horizontal Centers"         PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("CENTER", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Right Sides"                PARENT = m_align
        TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p ("RIGHT", ?). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN SUBTYPE = "RULE"                      PARENT = m_align.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Top Edges"                  PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "TOP"). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Vertical Centers"           PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "CENTER"). END TRIGGERS.
      CREATE MENU-ITEM h ASSIGN LABEL = "&Bottom Edges"               PARENT = m_align
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_align.p (?, "BOTTOM"). END TRIGGERS.
    END.  /* When UIB is licensed */
  
    h = h_menu-bar.
    /* Always add Windows and Help Menus */

    /* Windows Menu */
    CREATE SUB-MENU _h_WindowMenu ASSIGN LABEL = "&Window"                 PARENT = h.
    CREATE MENU-ITEM mi_code_edit ASSIGN LABEL = "Code &Section Editor" 
         ACCELERATOR = "Ctrl-S"                                            PARENT = _h_WindowMenu
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_codedit. END TRIGGERS.
    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_show_toolbox ASSIGN LABEL = "&Hide Object Palette"
          ACCELERATOR = "Ctrl-T"                                             PARENT = _h_WindowMenu
           TRIGGERS: ON CHOOSE PERSISTENT RUN choose_show_palette. END TRIGGERS.
    CREATE MENU-ITEM mi_attributes ASSIGN LABEL = "&Properties Window"
         ACCELERATOR = "Ctrl-P"                                            PARENT = _h_WindowMenu
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_attributes. END TRIGGERS.
    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_control_props ASSIGN LABEL = "&OCX Property Editor"
                                                                           PARENT = _h_WindowMenu
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_control_props. END TRIGGERS.
    /* Check whether Dynamics is Running */
    IF CAN-DO(_AB_Tools, "Enable-ICF":u) AND VALID-HANDLE(_h_menubar_proc) THEN
       RUN AddPropertyMenu IN _h_menubar_proc NO-ERROR.
      

    /* Help Menu */
    CREATE SUB-MENU h_sm ASSIGN LABEL = "&Help"                            PARENT = h.
    CREATE MENU-ITEM mi_master ASSIGN LABEL = "OpenEdge &Master Help"      PARENT = h_sm
        TRIGGERS:  ON CHOOSE
          PERSISTENT RUN adecomm/_adehelp.p ( "mast", "TOPICS", ?, ? ).
        END TRIGGERS.
    CREATE MENU-ITEM mi_contents ASSIGN LABEL = "AppBuilder &Help Topics"             PARENT = h_sm
         TRIGGERS: ON CHOOSE
          PERSISTENT RUN adecomm/_adehelp.p ("AB", "TOPICS", {&Main_Contents}, ? ).
       END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_messages ASSIGN LABEL = "M&essages..."             PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN prohelp/_msgs.p. END TRIGGERS.
    CREATE MENU-ITEM mi_recent ASSIGN LABEL = "&Recent Messages..."         PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN prohelp/_rcntmsg.p. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_cuecards ASSIGN LABEL = "&Cue Cards..."            PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_cuelist.w. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_about ASSIGN LABEL = "&About AppBuilder"           PARENT = h_sm
       TRIGGERS: ON CHOOSE
          PERSISTENT RUN adecomm/_about.p 
                   ("{&UIB_NAME}", AboutImage).
       END TRIGGERS.
     
    /* Now go back and fill in non-visible stuff */

    /* Edit Menu */
    ASSIGN h_sm = h:FIRST-CHILD
           h_sm = h_sm:NEXT-SIBLING.  /* Edit Menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM mi_duplicate ASSIGN LABEL = "&Duplicate" SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_duplicate in _h_uib. END TRIGGERS.
    END.  /* IF UIB is licensed */
  
    /* Always do this */
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_erase ASSIGN LABEL = "De&lete"                     PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_erase in _h_uib. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_export ASSIGN LABEL = "Copy to &File..."           PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_export_file in _h_uib.  END TRIGGERS.
    CREATE MENU-ITEM mi_import ASSIGN LABEL = "&Insert from File..."       PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_import_file in _h_uib. END TRIGGERS.

    IF OEIDEIsRunning THEN DO:
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE SUB-MENU m_insert ASSIGN LABEL = "Insert"  SENSITIVE = FALSE
               PARENT = h_sm.
      CREATE MENU-ITEM mi_insert_trigger ASSIGN LABEL = "Trigger" SENSITIVE = FALSE
               PARENT = m_insert
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_insert_trigger in _h_uib. END TRIGGERS.      
      CREATE MENU-ITEM mi_insert_procedure ASSIGN LABEL = "Procedure" SENSITIVE = FALSE
               PARENT = m_insert
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_insert_procedure. END TRIGGERS.      
      CREATE MENU-ITEM mi_insert_function ASSIGN LABEL = "Function" SENSITIVE = FALSE
               PARENT = m_insert
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_insert_function in _h_uib. END TRIGGERS.               
         
    END.
    
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_tab_edit ASSIGN LABEL = "T&ab Order..." SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_tab_edit in _h_uib. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_goto_page ASSIGN LABEL = "&Goto Page..."
               SENSITIVE = FALSE      PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_goto_page in _h_uib. END TRIGGERS.
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm. 
      CREATE MENU-ITEM mi_assign_widgetid
           ASSIGN LABEL = "Assign &Widget IDs"
               SENSITIVE = FALSE      PARENT = h_sm
          TRIGGERS: ON CHOOSE PERSISTENT RUN choose_assign_widgetid in _h_uib. END TRIGGERS.
    END.  /* IF UIB */

    /* Compile Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Compile menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN LABEL = "Cl&ose Character Run Window"    PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_ttysx.p (INPUT TRUE). END TRIGGERS.
    END.  /* IF UIB or BOTH */

    /* jep-icf: If the location of the ICF menu changes in adeuib/_abmbar.w, then
       we must move this assignment as well. This assignment "skips over" the ICF
       menu defined by the AB's persistent menubar procedure. */
    /* ICF Menu */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN DO:
      ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* ICF menu */
    END.  /* ICF Menu */
 
    /* Tools Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Tools menu */
    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM mi_property_sheet ASSIGN LABEL = "Propert&y Sheet..."
               SENSITIVE = FALSE  PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN choose_prop_sheet. END TRIGGERS.
    END.

    CREATE MENU-ITEM mi_proc_settings ASSIGN LABEL = "Procedure &Settings..." PARENT = h_sm
       TRIGGERS: ON CHOOSE PERSISTENT RUN choose_proc_settings. END TRIGGERS.

    IF _AB_License NE 2 THEN
      CREATE MENU-ITEM mi_color ASSIGN LABEL = "&Color..." SENSITIVE = FALSE
               PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN adeuib/_selcolr. END TRIGGERS.

    /* jep-icf: Add ICF menu items to the Tools menu. */
    IF CAN-DO(_AB_Tools,"Enable-ICF") THEN DO:
      IF VALID-HANDLE(_h_menubar_proc) THEN
        RUN addICFTools IN _h_menubar_proc (INPUT h_sm).
    END.  /* ICF */


    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    CREATE MENU-ITEM mi_dbconnect ASSIGN LABEL = "Database Co&nnections" PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN run-dblist. END TRIGGERS.
    CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                           PARENT = h_sm.
    {adecomm/toolrun.i
      &PERSISTENT  = PERSISTENT
      &MENUBAR     = m_menubar
      &EXCLUDE_UIB = YES
      } 


    /* Options Menu */
    ASSIGN h_sm = h_sm:NEXT-SIBLING.  /* Options menu */
    IF {adecomm/editsrc.i} THEN DO:
      CREATE MENU-ITEM mi_editing_opts ASSIGN LABEL = "&Editing Options..."
                SENSITIVE = TRUE                                           PARENT = h_sm
         TRIGGERS: ON CHOOSE PERSISTENT RUN editing_options in _h_uib. END TRIGGERS.

    END.

    IF _AB_License NE 2 THEN DO:
      CREATE MENU-ITEM h_s ASSIGN SUBTYPE = "RULE"                         PARENT = h_sm.
      CREATE MENU-ITEM mi_grid_snap ASSIGN LABEL = "Snap to &Grid"
                SENSITIVE = FALSE    TOGGLE-BOX = YES                PARENT = h_sm
         TRIGGERS: ON VALUE-CHANGED PERSISTENT RUN change_grid_snap in _h_uib. END TRIGGERS.

      CREATE MENU-ITEM mi_grid_display ASSIGN LABEL = "&Display Grid"
                SENSITIVE = FALSE    TOGGLE-BOX = YES PARENT = h_sm
         TRIGGERS: ON VALUE-CHANGED PERSISTENT RUN change_grid_display in _h_uib. END TRIGGERS.

      ASSIGN mi_grid_snap:CHECKED    = _cur_grid_snap
             mi_grid_display:CHECKED = _cur_grid_visible.
    END.  /* If NOT WebSpeed only */
  END.  /* IF mode = "INIT" */

  ELSE DO: /* Mode is either UIB or WEB - NOT INIT */ 
 
    /* Show palette if UIB, hide if WEB */
    IF VALID-HANDLE(_h_object_win) THEN 
    DO:
      IF NOT IDEIntegrated 
      AND MODE = "UIB" 
      AND VALID-HANDLE(mi_show_toolbox) 
      AND mi_show_toolbox:LABEL = "&Hide Object Palette" 
      AND _h_menu_win:WINDOW-STATE NE 2 THEN 
          _h_object_win:HIDDEN = no.
      ELSE 
          _h_object_win:HIDDEN = yes.
    END.
    
    /* Hide "Label" field if a WEB object */
    DO WITH FRAME action_icons:
      IF MODE = "WEB" THEN ASSIGN cur_widg_text:HIDDEN = YES
                                  h = cur_widg_text:SIDE-LABEL-HANDLE
                                  h:HIDDEN = YES.
      ELSE ASSIGN cur_widg_text:HIDDEN = NO
                  h = cur_widg_text:SIDE-LABEL-HANDLE
                  h:HIDDEN = NO.
    END.  /* DO with FRAME action_icons */
    
    /* Appropriately grey or sensitize things */
    IF _AB_License NE 2 THEN
      ASSIGN _h_button_bar[10]:SENSITIVE = (mode = "UIB") AND _visual-obj
             m_layout:SENSITIVE          = IF _DynamicsIsRunning THEN
                                             _h_button_bar[1]:SENSITIVE
                                           ELSE
                                             _h_button_bar[10]:SENSITIVE
             mi_control_props:SENSITIVE  = _h_button_bar[10]:SENSITIVE
             mi_duplicate:SENSITIVE      = mi_control_props:SENSITIVE
             mi_tab_edit:SENSITIVE       = mi_control_props:SENSITIVE
             mi_goto_page:SENSITIVE      = mi_control_props:SENSITIVE
             mi_property_sheet:SENSITIVE = _h_button_bar[9]:SENSITIVE
             mi_color:SENSITIVE          = mi_control_props:SENSITIVE
             mi_grid_snap:SENSITIVE      = mi_control_props:SENSITIVE
             mi_grid_display:SENSITIVE   = mi_control_props:SENSITIVE.

    /* Update the menu of windows */
/*    IF VALID-HANDLE(_h_WinMenuMgr) THEN
      RUN WinMenuRebuild IN _h_uib.  */
  END. /* ELSE mode is not INIT */
 
END.  /* mode-morph */

/* In all other tools this is included in adecomm/toolsrun.i, but in the UIB
   it is here  */
{adecomm/toolsupp.i}

/* Morph the Layout  */
PROCEDURE morph_layout.
  DEFINE VARIABLE cObjType      AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cur-lo-name   AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cLayoutStack  AS CHARACTER                 NO-UNDO.
  DEFINE VARIABLE cLayoutToPop  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCustomLayout AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE lDynamic      AS LOGICAL                   NO-UNDO.
  DEFINE VARIABLE lPopping      AS LOGICAL                   NO-UNDO.
  DEFINE VARIABLE tmp-win       AS WIDGET-HANDLE             NO-UNDO.
  DEFINE VARIABLE hBase         AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hNew          AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hPop          AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hbField       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hnField       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hmField       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE hpField       AS HANDLE                    NO-UNDO.
  DEFINE VARIABLE iField        AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE iStack        AS INTEGER                   NO-UNDO.
  DEFINE VARIABLE pRecid        AS RECID                     NO-UNDO.

  DEFINE BUFFER b_U    FOR _U.
  DEFINE BUFFER b_L    FOR _L.  /* Base or old layout       */  
  DEFINE BUFFER n_L    FOR _L.  /* Current or new layout    */
  DEFINE BUFFER p_L    FOR _L.  /* Layout to pop            */
  DEFINE BUFFER m_L    FOR _L.  /* Master or default layout */
  DEFINE BUFFER sync_L FOR _L.

  tmp-win = _h_win.
  FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
  ASSIGN pRecid       = RECID(_P)
         cLayoutStack = _P.Layout_stack.
  FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  IF NOT AVAILABLE _U THEN DO:
    BELL.
    if OEIDEIsRunning then
         ShowMessageInIDE("To change to a different layout a window must be present.",
                          "Information",?,"OK",yes).
    else
    MESSAGE "To change to a different layout a window must be present."
            VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  ASSIGN cur-lo-name   = _U._LAYOUT-NAME
         _cur_win_type = _U._WIN-TYPE      /* This is probably redundant */
         lPopping      = FALSE
         .
      
  /* Determine if this is a customizable Dynamic object */
  IF _DynamicsIsRunning THEN
     lDynamic = DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) OR
                DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U).
  ELSE lDynamic = FALSE.

  IF lDynamic THEN DO:
    
    /* we cannot hide all windows opened in Eclipse...  oeideservice displayContainer hook will embedd it in
       Eclipse dialog */
    IF not OEIDEIsRunning THEN
        RUN disable_widgets.

    DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:

      /* Before morphing Copy all labels to _L record */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win:
        FIND b_L WHERE b_L._LO-NAME = cur-lo-name AND b_L._u-recid = RECID(b_U) NO-ERROR.
        IF AVAILABLE b_L THEN DO:
          /* If we are morphing "away" from the master change the _L of all labels that are 
             in sync with the master */
          IF b_L._LO-NAME = "Master Layout":U THEN DO:
            FOR EACH sync_L WHERE sync_L._u-recid = b_L._u-recid AND
                                  sync_L._LABEL   = b_L._LABEL:
              sync_L._LABEL = b_U._LABEL.  /* b_U._LABEL has the latest version */
            END.  /* Updated all labels in sync with the master */
          END.  /* If we're morphing away from the master layout */
          b_L._LABEL = b_U._LABEL.  /* Update _L of what we are morphing away from */
        END.  /* If this object has an _L */
      END.  /* Copy labels for layout morphing away from */
           
      RUN launchContainer IN gshSessionManager
          (INPUT  "rycstlow":U         /* object filename if physical/logical names unknown */
          ,INPUT  "":U                 /* physical object name (with path and extension) if known */
          ,INPUT  "rycstlow":U         /* logical object name if applicable and known */
          ,INPUT  YES                  /* run once only flag YES/NO */
          ,INPUT  "":U                 /* instance attributes to pass to container */
          ,INPUT  "":U                 /* child data key if applicable */
          ,INPUT  "":U                 /* run attribute if required to post into container run */
          ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
          ,INPUT  ?                    /* parent (caller) window handle if known (container window handle) */
          ,INPUT  ?                    /* parent (caller) procedure handle if known (container procedure handle) */
          ,INPUT  ?                    /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
          ,OUTPUT hCustomLayout        /* procedure handle of object run/running */
          ,OUTPUT cObjType             /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
          ).
    
      WAIT-FOR WINDOW-CLOSE, CLOSE OF hCustomLayout.   
     
    END.  /* do on stop, on error */
    /* no need to enable if OEIDE is running since we did not disable */
    IF not OEIDEIsRunning THEN
        RUN enable_widgets.
  END.  /* If we have a dynamic object */
  ELSE
  DO:
    IF OEIDEIsRunning THEN
      RUN adeuib/ide/_dialog_layout.p.
    ELSE    
      RUN adeuib/_layout.w.
  END.
  IF NOT AVAILABLE _U THEN DO:  /* It gets lost with the disable_widgets */
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
    FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
  END.

  IF (cur-lo-name <> _U._LAYOUT-NAME) OR (_cur_win_type <> _U._WIN-TYPE) THEN
  DO:
    /* Bug fix 19940518-055  jep
       If Section Editor window is open for window being morphed, then close it.
    */
    RUN call_sew ( INPUT "SE_CLOSE_SELECTED" ).

    ASSIGN _U._WIN-TYPE = _cur_win_type.

    IF lDynamic THEN DO:
      /* Before rendering the new layout, set the Labels in the _U */
      FOR EACH b_U WHERE b_U._WINDOW-HANDLE = _h_win AND NOT b_U._NAME BEGINS "_LBL-":U:
        FIND n_L WHERE n_L._LO-NAME = _U._LAYOUT-NAME AND n_L._u-recid = RECID(b_U) NO-ERROR.
        /* If n_L isn't already in the stack update its label */
        IF LOOKUP(_U._LAYOUT-NAME,cLayoutStack) = 0 THEN DO:
          IF AVAILABLE n_L THEN
            b_U._LABEL = n_L._LABEL. /* Copy the label from the new layout _L */
          ELSE DO:  /* There is no new _L ... create it from the old one */
            CREATE n_L.
            ASSIGN n_L._LO-NAME = _U._LAYOUT-NAME
                   n_L._u-recid = RECID(b_U).
            FIND sync_L WHERE sync_L._LO-NAME = cur-lo-name AND 
                              sync_L._u-recid = RECID(b_U) NO-ERROR.
            IF AVAILABLE sync_L THEN
              BUFFER-COPY sync_L EXCEPT _LO-NAME _u-recid TO n_L.
          END.
        END.  /* If this layout is not already in the stack */

        /* Get the Master layout record */
        FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = RECID(b_U).
        hMaster = BUFFER m_L:HANDLE.
        
        /* Determine if we need to push or pop the stack */
        IF LOOKUP(_U._LAYOUT-NAME,cLayoutStack) = 0 THEN DO: /* We are pushing the stack */

          ASSIGN n_L._BASE-LAYOUT = cur-lo-name
                 hNew             = BUFFER n_L:HANDLE.

          /* Get the old (base) record */
          FIND b_L WHERE b_L._LO-NAME = cur-lo-name AND b_L._u-recid = RECID(b_U) NO-ERROR.
          IF NOT AVAILABLE b_L THEN  /* It should be available, but just in case, we'll use 
                                        the master layout */
            FIND b_L WHERE b_L._LO-NAME = "Master Layout":U AND b_L._u-recid = RECID(b_U) NO-ERROR.
          hBase = BUFFER b_L:HANDLE.
           
          /* Get the Master layout record */
          FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = RECID(b_U).
          hMaster = BUFFER m_L:HANDLE.

          DO iField = 1 TO hMAster:NUM-FIELDS:
            hmField = hMaster:BUFFER-FIELD(iField).
            IF LOOKUP(hmField:NAME,"_LO-NAME,_u-recid,_BASE-LAYOUT,_WIN-TYPE":U) = 0 THEN DO:
              ASSIGN hnField = hNew:BUFFER-FIELD(iField)
                     hbField = hBase:BUFFER-FIELD(iField).
              /* If it is a container we need the maximum size to accomodate all contained objects */
              IF LOOKUP(b_U._TYPE,"WINDOW,FRAME,DIALOG-BOX":U) > 0 AND
                 LOOKUP(hmField:NAME,"_WIDTH,_HEIGHT,_VIRTUAL-WIDTH,_VIRTUAL-HEIGHT") > 0 THEN DO:
                /* We need the maximum to accomodate all fields */
                hnField:BUFFER-VALUE = MAX(hnField:BUFFER-VALUE, hbField:BUFFER-VALUE, hmField:BUFFER-VALUE).
              END.
              ELSE DO:
                /* If the old layout is changed from the master and the new layout
                 is the same as the Master, update the new layout to look like
                 the old layoout.                                               */
                IF hbField:BUFFER-VALUE NE hmField:BUFFER-VALUE AND
                   hnField:BUFFER-VALUE EQ hmField:BUFFER-VALUE THEN
                  ASSIGN hnField:BUFFER-VALUE = hbField:BUFFER-VALUE.
              END.  /* Else do */
            END. /* For any field that effects the layout */
          END. /* For each field in the buffers */
        END.  /* If we are poping the stack */
        ELSE DO:  /* We are popping the stack */
          lPopping = TRUE.
          /* Get the Master layout record */
          FIND m_L WHERE m_L._LO-NAME = "Master Layout":U AND m_L._u-recid = RECID(b_U).
          hMaster = BUFFER m_L:HANDLE.

          POP-THE-STACK:
          DO iStack = 1 TO NUM-ENTRIES(cLayoutStack):
            cLayoutToPop = ENTRY(iStack, cLayoutStack).
            IF cLayoutToPop = _U._LAYOUT-NAME OR 
               cLayoutToPop = "Master Layout":U THEN LEAVE POP-THE-STACK.

            /* Get the _L to pop */
            FIND p_L WHERE p_L._LO-NAME = cLayoutToPop AND p_L._u-recid = RECID(b_U) NO-ERROR.
            /* This may have been deleted so get then next one */
            IF NOT AVAILABLE p_L THEN NEXT POP-THE-STACK.
            hPop = BUFFER p_L:HANDLE.
            /* Get the next _L in the stack */
            IF iStack + 1 GT NUM-ENTRIES(cLayoutStack) THEN
              FIND b_L WHERE b_L._LO-NAME = "Master Layout":U AND b_L._u-recid = RECID(b_U) NO-ERROR.
            ELSE
              FIND b_L WHERE b_L._LO-NAME = ENTRY(iStack + 1, cLayoutStack) AND b_L._u-recid = RECID(b_U) NO-ERROR.
              IF NOT AVAILABLE b_L THEN  /* It should be available, but just in case, we'll use 
                                            the master layout */
                 FIND b_L WHERE b_L._LO-NAME = "Master Layout":U AND b_L._u-recid = RECID(b_U) NO-ERROR.
            hBase = BUFFER b_L:HANDLE.

            DO iField = 1 TO hMAster:NUM-FIELDS:
              hmField = hMaster:BUFFER-FIELD(iField).
              IF LOOKUP(hmField:NAME,"_LO-NAME,_u-recid,_BASE-LAYOUT,_WIN-TYPE":U) = 0 THEN DO:
                ASSIGN hpField = hPop:BUFFER-FIELD(iField)
                       hbField = hBase:BUFFER-FIELD(iField).
                /* If it is a container make sure the size is the max size */
                IF LOOKUP(b_U._TYPE,"WINDOW,FRAME,DIALOG-BOX":U) > 0 AND
                   LOOKUP(hmField:NAME,"_WIDTH,_HEIGHT,_VIRTUAL-WIDTH,_VIRTUAL-HEIGHT") > 0 THEN DO:
                  /* We need the maximum to accomodate all fields */
                  hpField:BUFFER-VALUE = MAX(hpField:BUFFER-VALUE, hbField:BUFFER-VALUE).
                END.
                ELSE DO:
                  /* If the layout to be popped is the same as the base , make it the same as
                     is the Master Layout */
                  IF hpField:BUFFER-VALUE EQ hbField:BUFFER-VALUE THEN
                    ASSIGN hpField:BUFFER-VALUE = hmField:BUFFER-VALUE.
                END. /* Not a container size */
              END. /* For any field that effects the layout */
            END. /* For each field in the buffers */
            /* Reset the p_L._BASE-LAYOUT to "Master Layout */
            p_L._BASE-LAYOUT = "Master Layout":U.
          END. /* POP the Stack , istack = 1 to new layout */
        END.  /* If we are popping the stack */
      END.  /* For each new layout record Copy labels for layout morphing away from */
      IF lPopping THEN DO:
        /* Now that all _L records have been processed for popping, adjust the layout_stack
           field in the _P */
        IF NOT AVAILABLE _P THEN
          FIND _P WHERE RECID(_P) = pRecid.
        _P.layout_stack = "Master Layout".
        IF _U._LAYOUT-NAME NE "Master Layout" THEN DO:
          DO iStack = NUM-ENTRIES(cLayoutStack) - 1 TO LOOKUP(_U._LAYOUT-NAME, cLayoutStack) BY -1:
            _P.layout_stack = ENTRY(iStack, cLayoutStack) + ",":U + _P.layout_stack.
          END.  /* Reverse loop to rebuild newly popped stack */
        END.  /* If we haven't popped all the way back to the master layout */
      END. /* If we popped the stack */
      ELSE _P.layout_stack = _U._LAYOUT-NAME + ",":U + cLayoutStack.
    END.  /* If Dynamics */

    RUN sensitize_main_window ("WINDOW").
    RUN adeuib/_recreat.p (RECID(_U)).
    /* If dynamic, may need to inform the Dynamic Property Sheet */
    IF lDynamic AND VALID-HANDLE(_h_menubar_proc) THEN
       RUN prop_changeContainer in _h_menubar_proc (STRING(tmp-win),STRING(_h_win)) NO-ERROR.
    /* After morphing disable undo */
    FOR EACH _action:
      DELETE _action.
    END.
    RUN DisableUndoMenu.
    RUN choose-pointer.
    RUN deselect_all(_h_win, ?).
    RUN curframe(_h_win).
    _h_cur_widg = _h_win.
    RUN display_current.
  END.  /* If the layout or window type has changed */
END.  

/* Move selected widgets to bottom. */
PROCEDURE movetobottom.
  DEFINE VAR h AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR cnt AS INTEGER INITIAL 0 NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib OR 
          (_U._HANDLE = _h_cur_widg AND _U._STATUS NE "DELETED"): 
    ASSIGN h = IF _U._TYPE NE "DIALOG-BOX" 
               THEN _U._HANDLE
               ELSE _U._HANDLE:PARENT  /* UIB dialog window */
           ldummy = h:MOVE-TO-BOTTOM()
           cnt = cnt + 1.
  END.

  /* set the file-saved state to false, since we just created an obj. */
  IF cnt > 0 THEN RUN adeuib/_winsave.p(_h_win, FALSE).
END. /* PROCEDURE movetobottom */

/* Move selected widgets to top. */
PROCEDURE movetotop.
  DEFINE VAR h AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR cnt AS INTEGER INITIAL 0 NO-UNDO.

  FOR EACH _U WHERE _U._SELECTEDib OR 
          (_U._HANDLE = _h_cur_widg AND _U._STATUS NE "DELETED"): 
    ASSIGN h = IF _U._TYPE NE "DIALOG-BOX" 
               THEN _U._HANDLE
               ELSE _U._HANDLE:PARENT  /* UIB dialog window */
           ldummy = h:MOVE-TO-TOP()
           cnt = cnt + 1.
  END.

  /* set the file-saved state to false, since we just created an obj. */
  IF cnt > 0 THEN RUN adeuib/_winsave.p(_h_win, FALSE).
END. /* PROCEDURE movetotop */

PROCEDURE mru_menu:
/* mru_menu : Update the most recently used file list in the File menu */

  DEFINE VARIABLE cAbbrevName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cName       AS CHAR      NO-UNDO.

  i = 1.
  DO WHILE i < 10:
    IF VALID-HANDLE(mi_mrulist[i]) THEN DELETE WIDGET mi_mrulist[i].
    i = i + 1. 
  END.  /* do while */
  IF VALID-HANDLE(mi_rule) THEN DELETE WIDGET mi_rule.
  IF VALID-HANDLE(mi_exit) THEN DELETE WIDGET mi_exit.
  
  FOR EACH _mru_files:
    /* Get abbreviated filename to display in menu */
    IF _mru_files._broker NE ? AND _mru_files._broker NE "" THEN
        /* web file may have fullpath name in string - just want the relative path
           to be displayed */
        cName = ws-get-relative-path (INPUT _mru_files._file).
    ELSE
        cName = _mru_files._file.

    RUN adecomm/_ossfnam.p 
      (INPUT cName, 
       INPUT 30,
       INPUT ?,
       OUTPUT cAbbrevName).
    IF _mru_files._broker NE ? AND _mru_files._broker NE "" THEN
      cAbbrevName = cAbbrevName + DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, 
                                                   FALSE, _mru_files._broker).
    CREATE MENU-ITEM mi_mrulist[_mru_files._position]
      ASSIGN PARENT = m_hFile   /* jep-icf: replaces static MENU m_File reference. */
             LABEL = STRING(_mru_files._position) + " ":U + cAbbrevName
             TRIGGERS: ON CHOOSE PERSISTENT RUN choose_mru_file (_mru_files._position). END TRIGGERS.
  END.  /* for each _mru_files */

  FIND FIRST _mru_files NO-ERROR.
  IF AVAIL _mru_files THEN 
    CREATE MENU-ITEM mi_rule
      ASSIGN SUBTYPE = "RULE"
             PARENT  = m_hFile. /* jep-icf: replaces static MENU m_File reference. */
         
  CREATE MENU-ITEM mi_exit
    ASSIGN PARENT = m_hFile     /* jep-icf: replaces static MENU m_File reference. */
           LABEL = "E&xit"
           TRIGGERS: ON CHOOSE PERSISTENT RUN exit_proc. END TRIGGERS.

END.  /* PROCEDURE mru_menu */

/* open_so_untitled : Open a .W file untitled for a SmartObject
 *                    Also checks SO type to see if a database
 *                    should be connected prior to selecting it.
 */
PROCEDURE Open_SO_Untitled:
  DEFINE INPUT PARAMETER so-type      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER file_to_open AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE l                   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cProductModuleCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRepDesignManager   AS HANDLE     NO-UNDO.
  
  FIND _palette_item WHERE _palette_item._name = so-type NO-ERROR.
  IF AVAILABLE _palette_item THEN DO:
    IF _palette_item._dbconnect and NUM-DBS = 0 THEN DO:
      RUN adecomm/_dbcnnct.p
        (INPUT "You must have at least one connected database to create a " 
               + (IF INDEX(_palette_item._name, 'object':U) = 0 THEN " object." ELSE ".":U),
         OUTPUT l).
        IF l EQ NO THEN 
        DO:
           RUN choose-pointer.
           RETURN.  
        END.
    END.
  END.
  
  IF _DynamicsIsRunning  THEN
  DO:
    FIND FIRST _custom WHERE _design_template_file     = file_to_open 
                         AND _custom._object_type_code = so-type NO-ERROR.
    IF AVAILABLE (_custom) THEN
    DO:
       ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
       IF VALID-HANDLE(hRepDesignManager) THEN
          ASSIGN cProductModuleCode = DYNAMIC-FUNC("getCurrentProductModule":U IN hRepDesignManager) 
                 cProductModuleCode = ENTRY(1,cProductModuleCode,"/":U)  NO-ERROR. 

       /* Fill in the _RyObject record for the AppBuilder. */
       FIND _RyObject WHERE _RyObject.object_filename = so-type NO-ERROR.
       IF NOT AVAILABLE _RyObject THEN
          CREATE _RyObject.

       ASSIGN _RyObject.object_type_code       = _custom._object_type_code
              _RyObject.parent_classes         = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.object_type_code)
              _RyObject.object_filename        = file_to_open
              _RyObject.product_module_code    = cProductModuleCode
              _RyObject.static_object          = _custom._static_object
              _RyObject.container_object       = _custom._type = "Container":u
              _RyObject.design_action          = "NEW":u
              _RyObject.design_ryobject        = YES
              _RyObject.design_template_file   = file_to_open
              _RyObject.design_propsheet_file  = _custom._design_propsheet_file
              _RyObject.design_image_file      = _custom._design_image_file.

    END. /* If AVAIL(_custom) */
            
  END.
  RUN Open_Untitled (file_to_open).


END PROCEDURE.
 
PROCEDURE OpenRyObject:
    define input  parameter pfile as character no-undo.
    define output parameter pok as logical no-undo.
    define variable hRepDesignManager as handle no-undo.
    define variable lok as logical no-undo.
    if _DynamicsIsRunning then
    do:
        hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
        IF VALID-HANDLE(hRepDesignManager) THEN
            pOk = DYNAMIC-FUNCTION("openRyObjectAB" IN hRepDesignManager, INPUT pfile).
    end.
    else pok = false.
end procedure.   

/**
 create _ryobject before open ing the template. 
 called from _oeideuib (standalone appbuilder uses the old similar code in _newobj.w )
 

*/
PROCEDURE NewRyObject:
    define input  parameter pcType as character no-undo.
    define input  parameter pcName as character no-undo.
    /* optional - uses custom info id not provided */
    define input  parameter pcTemplatename as character no-undo.
    define output parameter plAvail as logical no-undo.
    define variable cProductModuleCode as character no-undo.
    define variable cProdlist  as character no-undo.
    define variable hDesignManager as handle no-undo. 
    
    if _DynamicsIsRunning then
    do:
        /* there is no unique index on this table (arrggh)... name is probably unique by itself */
        find _custom where _custom._type = pctype and _custom._name =  pcName no-error.
        if available (_custom) then
        do:
            hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U). 
            
            assign cProductModuleCode =  
               DYNAMIC-FUNC("getCurrentProductModule":U in hDesignManager) .
            if cProductModuleCode = ? or cProductModuleCode = "" then 
            do:   
                /* @TODO this is expensive -find a better way - maybe just fix containerbuilder launch to 
                   handle unknown */
                cProdList = DYNAMIC-FUNCTION("getproductModuleList":U IN hDesignManager,
                                             "product_module_Code":U,
                                             "product_module_code":U,
                                             "&1":U,
                                             CHR(3)).
                   
                cProductModuleCode =  entry(2,cProdList,CHR(3)).
            end.
            else 
                cProductModuleCode = if index(cProductModuleCode,"//":U) > 0 
                                     then substr(cProductModuleCode,1,index(cProductModuleCode,"//":U) - 1)
                                     else cProductmoduleCode.
            /* Fill in the _RyObject record for the AppBuilder. */
            find _RyObject where _RyObject.object_filename = pcTemplatename no-error.
            if not available _RyObject then
                create _RyObject.
            assign 
                 _RyObject.object_type_code       = _custom._object_type_code
                 _RyObject.parent_classes         = DYNAMIC-FUNC("getClassParentsFromDB":U in gshRepositoryManager, input _RyObject.Object_type_code)
                 _RyObject.object_filename        = if pcTemplatename > "" then pcTemplatename else _custom._design_template_file
                 _RyObject.product_module_code    = cProductModuleCode
                 _RyObject.static_object          = _custom._static_object
                 _RyObject.container_object       = _custom._type = "Container":u
                 _RyObject.design_action          = "NEW":u
                 _RyObject.design_ryobject        = if _custom._static_object then no else yes
                 _RyObject.design_template_file   =  _RyObject.object_filename
                 _RyObject.design_propsheet_file  = _custom._design_propsheet_file
                 _RyObject.design_image_file      = _custom._design_image_file.
           
           plAvail = true.
        end. /* If AVAIL(_custom) */
    
    end.
    
end procedure.   
 
/* open_untitled : Open a .W file untitled (i.e. template) */
PROCEDURE Open_Untitled:
  DEFINE INPUT PARAMETER file_to_open AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hWin             AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lNativeDynObject AS LOGICAL    NO-UNDO.
  define variable cReturn as character no-undo.
  RUN deselect_all (?, ?).
  /* Open the choice as an untitled window. */
  RUN setstatus ("WAIT":U, "Opening template...").
  /* Open the window for the SmartObject if we can find it.  
     Otherwise report an error if we cannot edit the master. */
                                       
  RUN adeuib/_open-w.p (file_to_open, "","UNTITLED":U).
  
  cReturn = RETURN-VALUE.
  IF cReturn <> "_ABORT":U AND _DynamicsIsRunning AND AVAILABLE _P THEN 
  DO:
     IF DYNAMIC-FUNCTION("isDynamicClassNative":U IN _h_func_lib,_P.object_type_code) THEN
       ASSIGN hWin        =  _P._WINDOW-HANDLE:WINDOW
              hWin:TITLE  = IF NUM-ENTRIES(hWin:TITLE,"-") >= 2
                            THEN ENTRY(1,hWin:TITLE,"-") + "(":U + _P.object_type_code + ")" + " - " + ENTRY(2,hWin:TITLE,"-") 
                            ELSE hwin:TITLE + "(":U + _P.object_type_code + ")"
              NO-ERROR.
  END.
  /* Select the current name of the base widget. */
  APPLY "ENTRY":U TO cur_widg_name IN FRAME action_icons.
  
  RUN setstatus ("":U, "":U).
   /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.
  /* _oeideuib need to know  this  */
  return cReturn.
END PROCEDURE.

PROCEDURE property_sheet:
    DEFINE INPUT PARAMETER h_self AS WIDGET   NO-UNDO.
    
    DEFINE VAR   h_parent_win     AS WIDGET                       NO-UNDO.
    DEFINE VAR   h_current_win    AS WIDGET                       NO-UNDO.
    define variable ideevent as adeuib.ide._widgetevent  no-undo.
    /* Don't go into property sheets if the last event was a dbl-click and
      we were in draw mode */
    IF LAST-EVENT:FUNCTION = "MOUSE-SELECT-DBLCLICK" AND _next_draw NE ? THEN 
        RETURN.

    /* Tell the user we are doing something, then draw it. */
    RUN setstatus ("WAIT":U, "Edit properties of current object."). 
    /* If h_self is not specified, then use SELF -- also, parent the dialog boxes
       that will come up to the window where SELF is */
    IF h_self = ? THEN 
    DO:
        /* Run this in the window where the user clicked (if, keep getting parents
           of self until we have a window). */
        ASSIGN  h_self = SELF
                h_parent_win = SELF.
        DO WHILE h_parent_win:TYPE NE "WINDOW":
            IF CAN-QUERY(h_parent_win, "PARENT") THEN 
                h_parent_win = h_parent_win:PARENT. /* Normal case */
            ELSE 
                h_parent_win = h_parent_win:OWNER.  /* For menus   */
        END.
        CURRENT-WINDOW = h_parent_win.
    END.
    if IDEIntegrated then
    do:
       ideevent = new adeuib.ide._widgetevent().
       ideevent:EventHandle = h_self.
       ideevent:SetCurrentEvent(this-procedure,"do_property_sheet").
       run runChildDialog in hOEIDEService (ideevent) .
    end.
    else 
        run do_property_sheet(h_self). 
end.

/* property_sheet : Edit the property sheet of a widget (h_self).       */
PROCEDURE do_property_sheet:
  DEFINE INPUT PARAMETER h_self AS WIDGET   NO-UNDO.
  define variable h_current_win as handle no-undo.
  DEFINE VAR   cType            AS CHARACTER                    NO-UNDO.
  DEFINE VAR   ldummy           AS LOGICAL                      NO-UNDO.
  DEFINE VAR   r_U              AS ROWID                        NO-UNDO.
  
  /* Deselect All widgets (except h_self) */
  RUN deselect_all (h_self, ?).
  /* Make this the current widget */
  RUN curframe (h_self).
  _h_cur_widg = h_self.
  RUN display_current.
  
  /* Now fork depending on the type of the widget, h_self. */
  FIND _U WHERE _U._HANDLE = h_self.

  /* Display the property sheet.  Keep track of the TYPE in case the _U 
     record is deleted. */
  cType       = _U._TYPE.

  /* SEW call to store current trigger code for specific window. */
  /* Needed for check syntax of calculated fields */
  IF cType = "BROWSE":U THEN RUN call_sew ( INPUT "SE_STORE_WIN").

  /* WEB: */
  FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE.
  IF _P._TYPE BEGINS "WEB":U THEN
    RUN choose_attributes.
  ELSE DO:
    
    ASSIGN r_U = ROWID(_U).
    h_current_win = _h_win.
    RUN adeuib/_proprty.p (h_self).
    FIND _U WHERE ROWID(_U) = r_U.     
  END.
  /* For menus, the property sheet may have deleted the widget. */
  IF CAN-DO("MENU,MENU-ITEM,SUB-MENU",cTYPE) THEN DO:
    IF AVAILABLE _U THEN  
      ASSIGN h_self      = _U._HANDLE
             _h_cur_widg = h_self. 
    RUN del_cur_widg_check.
  END.
  ELSE DO:
     IF NOT AVAILABLE _U THEN
        FIND _U WHERE _U._HANDLE = h_self.  
    /* If removed from layout everywhere, delete it */
    IF NOT CAN-FIND(FIRST _L WHERE _L._u-recid = RECID(_U) AND
                               NOT _L._REMOVE-FROM-LAYOUT) THEN RUN choose_erase.

    /* The following is necessary if the widget was recreated. */
    IF h_self ne _U._HANDLE THEN DO:
      h_self = _U._HANDLE.
      RUN changewidg (_U._HANDLE, TRUE).
    END.

  END. /* Not a menu. */

  /* Restore the current window */
  CURRENT-WINDOW = _h_menu_win.
  
  /* Update the current widget display, in case label or name
     has changed. */
  RUN display_current.

  /* SEW call to update widget name and label in SEW if necessary. */
  RUN call_sew ( INPUT "SE_PROPS" ).

  /* Reset the current cursor and wait for user input. */
  RUN setstatus ("":U, "":U).
  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer. 
  /* Set the default-window cursor back to normal */
  if _h_win <> ? THEN
    ldummy = _h_win:LOAD-MOUSE-POINTER(IF _next_draw = ? 
                                       THEN "" ELSE {&start_draw_cursor}).
END PROCEDURE. /* property_sheet */

/* report-no-win   is a procedure that tells the user _h_win is unknown.  */
PROCEDURE report-no-win.
  BELL.
  if OEIDEIsRunning then
      ShowMessageInIDE("No window is selected. ~n 
                       Please choose an existing window, ~n or new one. ",
                       "Error",?,"OK",yes).
  else
  MESSAGE  "No window is selected." {&SKP}
           "Please choose an existing window," {&SKP}
      "or new one." VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END PROCEDURE.

/* save_palette  Save the position and orientation of the object palette as
 *               well as custom file list.
 */
PROCEDURE save_palette: /* by GFS 2/95 */
    DEFINE VAR sctn           AS CHAR INITIAL "Pro{&UIB_SHORT_NAME}" NO-UNDO.
    DEFINE VAR textout        AS CHAR                                NO-UNDO.
    DEFINE VAR okflag         AS LOGICAL INITIAL no                  NO-UNDO.
    DEFINE VAR v              AS CHARACTER                           NO-UNDO.
    DEFINE VAR c_v            AS CHARACTER                           NO-UNDO.
    
    USE "" NO-ERROR.  /* Make sure that we are using startup defaults file */
    ASSIGN SESSION:NUMERIC-FORMAT = "AMERICAN":U.
    PUTPREFS-BLOCK:
    DO ON STOP  UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK
       ON ERROR UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK:
            
       PUT-KEY-VALUE SECTION sctn KEY "PaletteLoc" VALUE 
                     STRING(_h_object_win:X) + "," + STRING(_h_object_win:Y) NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.

       ASSIGN textout = "".
       IF MENU-ITEM mi_menu_only:CHECKED   IN MENU m_toolbox THEN 
         ASSIGN textout = textout + (IF textout NE "" THEN ",Menu" ELSE "Menu").
       &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
         IF MENU-ITEM mi_top_only:CHECKED IN MENU m_toolbox THEN 
           ASSIGN textout = textout +
                            (IF textout NE "" THEN ",Top-Only" ELSE "Top-Only").
       &ENDIF
       /* 7/14 (gfs) - changed textout to be a CDL of selected options */
       PUT-KEY-VALUE SECTION sctn KEY "PaletteVisualization" VALUE textout NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.
       
       ASSIGN h = _h_object_win:LAST-CHILD.
       IF NOT VALID-HANDLE(h) THEN LEAVE PUTPREFS-BLOCK.  /* Just in case no children */
       ASSIGN textout = STRING(TRUNCATE((_h_object_win:WIDTH-P + (h:WIDTH-P / 3)) / 
                         h:WIDTH-P, 0)). 
       PUT-KEY-VALUE SECTION sctn KEY "PaletteItemsPerRow" VALUE textout NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.    
       
       GET-KEY-VALUE SECTION sctn KEY _custom_files_savekey VALUE v.
       ASSIGN c_v = {&CUSTOM-FILES}.
       IF c_v eq _custom_files_default
         THEN c_v = ?. /* Default Value */
       IF v ne c_v THEN 
         PUT-KEY-VALUE SECTION sctn KEY _custom_files_savekey VALUE c_v NO-ERROR.
       IF ERROR-STATUS:ERROR THEN STOP.    

       ASSIGN okflag = yes. /* got through w/o error */
    END.
    SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal). 

    IF NOT okflag THEN
        RUN adeshar/_puterr.p ( INPUT "Object Palette" , INPUT _h_object_win ).
END PROCEDURE. /* Save Palette */

/* caled from _oeideuib.p to save when open new file from ide *
   assumes current window. could be improved to use the file param */
procedure save_new_file:
    DEFINE INPUT  PARAMETER pcFile       AS CHARACTER NO-UNDO.
    
    DEFINE OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
    
    FIND _U WHERE _U._HANDLE = _h_win.
    
    FIND _P WHERE _P._u-recid eq RECID(_U).       
    _P._save-as-file = pcFile.
    /* SEW call to store current trigger code for specific window. */
     
    RUN call_sew in _h_uib("SE_STORE_WIN":U).
    RUN save_window in _h_uib(NO, OUTPUT plCancel).

end.

/* called from _oeideuib.p to save as after file is selected 
     assumes current window. could be improved to use the file param */

procedure save_as_file:
    define input  parameter pcFile       as character no-undo.
    define input  parameter pcNewFile    as character no-undo.
    
    define output parameter plCancel as logical no-undo.
    
    find _U where _U._HANDLE = _h_win.
    
    find _P where _P._u-recid eq RECID(_U).       
     _save_file    = pcNewFile.
    plCancel = yes.
    run save_file(yes,no,no,no,"",input-output plCancel).
end.

/* save_window   Saves the current _U to the related _P._SAVE-AS-FILE and 
                 updates the window title. */
PROCEDURE save_window:
  DEFINE INPUT  PARAMETER ask_file_name  AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER user_cancel    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cAction       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBrokerURL    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFile         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFirstLine    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOptions      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPath         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRelName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSaveFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTempFile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE file_ext      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_title_win   AS WIDGET    NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lMRUSave      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lOk           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lok2save      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSaveUntitled AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE OldTitle      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAssocError   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iRecID        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRegisterObj  AS LOGICAL    NO-UNDO.  
  DEFINE VARIABLE lNew          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE rRecid        AS RECID      NO-UNDO.
  DEFINE VARIABLE rURecid       AS RECID      NO-UNDO.
  DEFINE VARIABLE cTables       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTempDBLib    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFileWeb      AS CHARACTER  NO-UNDO INIT ?.
 

  DEFINE BUFFER x_U FOR _U.
 
  FIND _P WHERE _P._u-recid eq RECID(_U).    
  
  DEFINE VARIABLE cProjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lProjectFile AS LOGICAL    NO-UNDO INITIAL FALSE.
  DEFINE VARIABLE cLinkedFile  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE pFileName    AS CHARACTER  NO-UNDO.
  /* Is the file missing any links, or is it OK to Save */
  RUN adeuib/_advsrun.p (_h_win,"SAVE":U, OUTPUT lok2save).  
  IF NOT lOk2save THEN RETURN.

  ASSIGN 
    h_title_win   = _U._HANDLE
    _save_file    = _P._SAVE-AS-FILE
    user_cancel   = YES 
    lSaveUntitled = (_remote_file AND NOT ask_file_name AND _save_file = ?) 
   NO-ERROR.

  IF _save_file NE ? AND _remote_file AND _P._broker-url NE "" THEN 
  DO:
      /* for remote files - webspeed - we have the path to construct the 
         full path in _save-as-path, so qualify the file name now.
      */
      IF _P._save-as-path NE ? THEN
         ASSIGN _save_file = _P._save-as-path + _P._save-as-file
          /* let's construct the string as if we got it from _webfile.w,
             so that we set all the info correctly when upddating the
             _P record and the MRU list (down below in this function) */
          cFileWeb = ws-set-path-info(_P._save-as-file, _save_file).
  END.
 

  IF _P.design_ryobject AND _DynamicsIsRunning
  AND (NOT _P.static_object) THEN 
  DO:

    
/*     Set the cursor pointer in all windows*/
    
    
    RUN setstatus ("WAIT":U,"Saving object...").

    IF _P.container_object THEN
    DO:
      IF VALID-HANDLE(_P.design_hpropsheet)
      THEN DO:
        DEFINE VARIABLE lNewObject  AS LOGICAL NO-UNDO.
      
        /* Plan to add this object to the MRU list of its new and save is completed. */
        ASSIGN lNewObject = CAN-DO(_P.design_action ,"NEW":u)
               lMRUSave   = lNewObject.
        /* Call the object's property sheet to save the object. */
        RUN saveObject IN _P.design_hpropsheet
          (INPUT-OUTPUT _save_file, OUTPUT user_cancel).
        
        /* Update MRU list if save of new object is successful. */
        ASSIGN lMRUSave = (lNewObject AND user_cancel = NO).

        IF NOT user_cancel THEN
        DO:
          ASSIGN
            user_cancel            = NO 
            _P._FILE-SAVED         = TRUE
            _P._SAVE-AS-FILE       = _save_file
            _P.design_action       = "OPEN":u
            h_title_win            = _P._WINDOW-HANDLE:WINDOW
            OldTitle               = h_title_win:TITLE.

          RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                                 _P._SAVE-AS-FILE).
  
          /* Change the active window title on the Window menu. */
          IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
            RUN WinMenuChangeName IN _h_WinMenuMgr
              (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
  
          /* Notify the Section Editor of the window title change. Data after 
             "SE_PROPS" added for 19990910-003. */
          RUN call_sew ( "SE_PROPS":U ). 
  
          /* Update most recently used filelist */    
          IF lMRUSave AND _mru_filelist THEN 
            RUN adeshar/_mrulist.p (_save_file, IF _remote_file THEN _BrokerURL ELSE "").
  
          /* IZ 776 Redisplay current filename in AB Main window. */
          RUN display_current IN _h_uib.
        END. /* save ok */
  
      END. /* valid-handle prop sheet */
      /* This message should never be given.  The container builder will now open
         for any container opened in the AppBuilder.  When a container is run in the 
         AppBuilder, the container builder will not be destroyed (it was to avoid being
         viewed when the container stopped running even if it was hidden before it was run). */
      ELSE 
      do:
        if OEIDEIsRunning then
         ShowMessageInIDE("Container not saved to the repository.  Its property sheet is not open.":U,
                          "Error",?,"OK",yes).
        else  
        MESSAGE "Container not saved to the repository.  Its property sheet is not open.":U  VIEW-AS ALERT-BOX.
      end.  
    END.  /* if container object */
    /* Check for DynBrowse, DynView and DynSDO which are not containers */
    ELSE DO:
       ASSIGN lNew = CAN-DO(_P.design_action, "NEW":u).
       
       IF lNew OR ask_file_name THEN 
       DO: 
          
          ASSIGN 
            _save_file       = _P.Object_filename
            cSaveFile        = _P._SAVE-AS-FILE
            _P._SAVE-AS-FILE = _save_File 
            rRecID           = RECID(_P)
            NO-ERROR.
          /* If we are saving As, set the save-as-file equal to the original object name */
          IF _P._SAVE-AS-FILE = "" THEN
             ASSIGN _P._SAVE-AS-FILE = _P.object_fileName.
         
          if OEIDEisRunning then
          do:
              /* locks the ui when embedded (probably becuase there is no automatic turn off
              since there is no dialog) */
              run setstatus("","").
              run adeuib/ide/_dialog_saveaswizd.p (no,
                                                   output lRegisterObj,
                                                   output lOK).
          end.
          else
             run adeuib/_saveaswizd.w (input no, output lRegisterObj, output lOK).
          
          IF rRecid <> RECID(_P) THEN
            FIND _P WHERE  RECID(_P) = rRecid .
          IF NOT lOK THEN 
          DO:
             ASSIGN _P._SAVE-AS-FILE = cSaveFile
                    user_cancel      = YES.
             RETURN.
          END.
       END.

       /* If we are saving an existing dynamic object as another dynamic object, we must */
       /* set the object_obj to zero for all instances */
       IF NOT lNew AND ask_file_name THEN
       DO:
          /* Need to change the object filename */
          FIND _RyObject WHERE _RyObject.design_precid = RECID(_P) NO-ERROR.
          IF AVAIL _RyObject THEN ASSIGN _RyObject.object_filename = _P.object_filename.
          IF AVAIL _U THEN
          DO:
           /* Save the object-obj values in private data in case save fails and it needs to be reset */
             IF VALID-HANDLE(_U._HANDLE) AND _U._OBJECT-OBJ <> ? THEN
               ASSIGN _U._HANDLE:PRIVATE-DATA = STRING(_U._OBJECT-OBJ) + CHR(4) + _save_file + CHR(4)
                                                 + IF _U._HANDLE:PRIVATE-DATA = ? THEN "" ELSE _U._HANDLE:PRIVATE-DATA.

           
             ASSIGN _U._OBJECT-OBJ = 0. 
             FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                              x_U._STATUS = "NORMAL":U AND
                              NOT x_U._NAME BEGINS "_LBL-":U AND
                              x_U._TYPE NE "WINDOW":U AND
                              x_U._TYPE NE "FRAME":U:
                IF VALID-HANDLE(x_U._HANDLE) AND x_U._OBJECT-OBJ <> ? THEN
                   ASSIGN x_U._HANDLE:PRIVATE-DATA = STRING(x_U._OBJECT-OBJ) + CHR(4) + x_U._HANDLE:PRIVATE-DATA.
                ASSIGN x_U._OBJECT-OBJ = 0.
             END.
          END.
       END.

       /* The design action might have been "NEW", but now object is save. So the
          action is changed to "OPEN". */
       IF lNew THEN
         ASSIGN _P.design_action  = REPLACE(_P.design_action, "NEW":U, "OPEN":U).

       RUN setstatus ("WAIT":U,"Saving object...":U).
       
       ASSIGN rURecid = RECID(_U).
       /* Here's where we save the dynamic object */
       RUN ry/prc/rygendynp.p (INPUT RECID(_P), 
                               OUTPUT cError,             /* Error saving object */
                               OUTPUT cAssocError).       /* Error saving associated object - if there is one */
         /* 20031118-003  - causes _U to be unavailable 
            ab pds integration - synch _p and _h_win also not only _u
            - rygendynp calls wind-close after creating super proc 
              wind-close find some other window than this */  
       IF rURecid <> RECID(_U) THEN
       do:
           FIND _U WHERE RECID(_U) = rURecid.
           FIND _P WHERE _P._u-recid eq RECID(_U).    
           _h_win = _P._window-handle.
       end.
       RUN setstatus ("":U, "":U).

       IF (cError <> "" AND NOT cError BEGINS "Associated data":U) THEN
       DO:
          IF NUM-ENTRIES(cError,"^") GE 3 THEN
            RUN showMessages IN gshSessionManager 
                            (INPUT cError,
                             INPUT "ERR":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "Object Register Error",
                             INPUT YES,
                             INPUT ?,
                             OUTPUT cError).
          ELSE
          do:
             if OEIDEIsRunning then
                ShowMessageInIDE("Object was not saved to the repository. ~n" +
                                 cError,
                                 "Warning",?,"OK",yes).
             else 
             MESSAGE "Object was not saved to the repository." SKIP(1)
                cError
                VIEW-AS ALERT-BOX WARNING.
          end.      
          IF lNew THEN
             ASSIGN _P._SAVE-AS-FILE = ?
                    _P.design_action = REPLACE (_P.design_action, "OPEN":U,"NEW":U ).
          ELSE DO:
             /* Reset the Object-Obj fields back to their original state */
             FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
             IF AVAIL _U THEN
             DO:
             /* Save the object-obj values in private data in case user cancels and it needs to be rest */
                IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                   ASSIGN _U._OBJECT-OBJ = DECIMAL(ENTRY(1,_U._HANDLE:PRIVATE-DATA, CHR(4))) 
                          _U._HANDLE:PRIVATE-DATA = ENTRY(3,_U._HANDLE:PRIVATE-DATA, CHR(4))
                          NO-ERROR.
                FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                                   x_U._STATUS = "NORMAL":U AND
                                   NOT x_U._NAME BEGINS "_LBL-":U AND
                                   x_U._TYPE NE "WINDOW":U AND
                                   x_U._TYPE NE "FRAME":U:
                   IF VALID-HANDLE(x_U._HANDLE) AND NUM-ENTRIES(x_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                      ASSIGN x_U._OBJECT-OBJ = DECIMAL(ENTRY(1,x_U._HANDLE:PRIVATE-DATA, CHR(4))) 
                             x_U._HANDLE:PRIVATE-DATA = ENTRY(2,x_U._HANDLE:PRIVATE-DATA, CHR(4))
                             NO-ERROR.
                END.
             END. /* End if avail _U */
          END. /* End if existing object */

          RETURN.
       END. /* If there was an error */

      /* Return the private data to it's original state */
       IF NOT lNew AND ask_file_name THEN
       DO:
          FIND _U WHERE RECID(_U) = _P._u-recid NO-ERROR.
          IF AVAIL _U THEN
          DO:
          /* Save the object-obj values in private data in case user cancels and it needs to be rest */
             IF VALID-HANDLE(_U._HANDLE) AND NUM-ENTRIES(_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                ASSIGN _U._HANDLE:PRIVATE-DATA = ENTRY(2,_U._HANDLE:PRIVATE-DATA, CHR(4)) NO-ERROR.
             
             FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _U._WINDOW-HANDLE AND
                                x_U._STATUS = "NORMAL":U AND
                                NOT x_U._NAME BEGINS "_LBL-":U AND
                                x_U._TYPE NE "WINDOW":U AND
                                x_U._TYPE NE "FRAME":U:
                IF VALID-HANDLE(x_U._HANDLE) AND NUM-ENTRIES(x_U._HANDLE:PRIVATE-DATA, CHR(4)) = 2 THEN
                   ASSIGN x_U._HANDLE:PRIVATE-DATA = ENTRY(2,x_U._HANDLE:PRIVATE-DATA, CHR(4)) NO-ERROR.
             END.
           END. /* End if avail _U */
       END.
       
       ASSIGN
         _P._FILE-SAVED         = TRUE
         h_title_win            = _P._WINDOW-HANDLE:WINDOW
         OldTitle               = h_title_win:TITLE
         User_cancel            = NO.

       RUN adeuib/_wintitl.p (h_title_win, _U._LABEL + "(" + _P.OBJECT_type_code + ")", _U._LABEL-ATTR, 
                              _P._SAVE-AS-FILE).
        
       /* Change the active window title on the Window menu. */
       IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
         RUN WinMenuChangeName IN _h_WinMenuMgr
           (_h_WindowMenu, OldTitle, h_title_win:TITLE). 
 
       /* Notify the Section Editor of the window title change. Data after 
          "SE_PROPS" added for 19990910-003. */
       RUN call_sew ( "SE_PROPS":U ). 
 
       /* Update most recently used filelist */  
       
       IF _mru_filelist THEN 
         RUN adeshar/_mrulist.p (_P.Object_fileName,IF _remote_file THEN _BrokerURL ELSE "").
 
       /* IZ 776 Redisplay current filename in AB Main window. */
       RUN display_current IN _h_uib.

    END. /* End check for DynBrowse, DynView or DynSDO */

    RUN setstatus ("":U,"":U).  /* Set the cursor pointer in all windows */

    /* Dynamics: IZ 6618. When saving an object, force tools to refresh its instances of the saved smartobject */
    IF _DynamicsIsRunning                 AND
       VALID-HANDLE(gshRepositoryManager) AND
       _P.smartObject_obj <> ?            AND
       _P.smartObject_obj <> 0            THEN
      PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT _P.smartObject_obj, INPUT _P.Object_FileName).
    
    RETURN.
  END. /* dynamic repository object save */          

  /* If there is no name, or we need to ask, or if there was a wizard which 
     assigned a product_module, then get a new file name. */
     
  IF ask_file_name OR _save_file = ?  THEN 
  DO:
    /* When saving a new file or saving an existing file as something
       else we need to update the MRU filelist after the save is done */
    ASSIGN lMRUSave    = TRUE.
    /*  If we can't find the file, that means this is a new file. */
    
    IF _save_file = ? THEN 
    DO:
      IF _P._html-file <> "":U THEN 
      DO:
        /* Set the filename to be like the name of the HTML file. */
        ASSIGN 
          cSaveFile = IF _remote_file
                      THEN _P._html-file
                      ELSE SEARCH(_P._html-file)
          ix        = R-INDEX(cSaveFile, ".":U).
        IF i > 0 AND INDEX(cSaveFile, "/":U, ix) = 0 THEN
          cSaveFile = SUBSTRING(cSaveFile, 1, ix - 1, "CHARACTER":U).

        /* Watch for cases of a period in the directory, but not in the file 
           extension, e,g. /user/test.dir/myfile) */
        IF ix > 0 AND INDEX(REPLACE(cSaveFile,"~\":U,"/":U), "/":U, ix) = 0
        THEN
          ASSIGN cSaveFile = SUBSTRING(cSaveFile, 1, ix - 1, "CHARACTER":U).
        IF _P._file-type = "":U
        OR _P._file-type = ?
        THEN _P._file-type = "w":U.
        ASSIGN
          _save_file = cSaveFile + ".":U + _P._file-type.
      END.
      ELSE DO:
        /* If dynamics is running and an object filename has already been specified in the comments wizard */
        IF _DynamicsIsRunning AND _P.Object_fileName > "" THEN       
             _save_file = _P.object_filename.

        /* WIN95-LFN - Win95 long filename support. jep 12/14/95 */
        IF _save_file = ? THEN
          _save_file = IF LENGTH(_U._NAME, "RAW":U) < 9 OR OPSYS <> "WIN32":u
                       THEN lc(_U._NAME) + ".":U + _P._FILE-TYPE
                       ELSE lc(SUBSTRING(_U._NAME,1,8,"FIXED":U)) + ".":U + 
                         _P._FILE-TYPE.
      END.

    END. /* END _Save-file = ? */

      /* Handle cases where local file is being saved remotely or remote file is being saved locally.
         Strip off the file path, since it will invariably be invalid. */
    IF ask_file_name  AND _save_file <> "" AND _save_file <> ?
       AND ((   _remote_file AND _P._broker-url =  "")
       OR  (NOT _remote_file AND _P._broker-url <> ""))
    THEN DO:
      RUN adecomm/_osprefx.p (_save_file, OUTPUT cPath, OUTPUT cFile).
      _save_file = cFile.
    END.

    /* Get name for an untitled, remote file, check to see if it exists and is writeable.
       _save_file will contain the relative file path. */
    IF _remote_file
    THEN DO:
      RUN adeweb/_webfile.w ("uib":U, "saveas":U, "Save As":U, "":U,
                             INPUT-OUTPUT _save_file, OUTPUT cTempFile, 
                             OUTPUT lOk).
      IF NOT lOk THEN RETURN.   /* the user cancelled */

      /* need to handle case where _webfile.w returned the relative and full 
         pathname */
      IF ws-get-save-as-path (INPUT _save_file) NE ? THEN DO:
          ASSIGN cFileWeb = _save_file
                 _save_file = ws-get-absolute-path (INPUT _save_file).
      END.
    END.
    ELSE DO:
       /* Check whether wizard previously saved the filename and module */
      IF _DynamicsIsRunning AND _P.Product_module_code > "" THEN
      DO: /* Run wizard confirmation dialog */
         ASSIGN cSaveFile        = _P._SAVE-AS-FILE
                _P._SAVE-AS-FILE = _save_file
                rRecID           = RECID(_P).

         /* IZ 9872 and IZ 9903 Workaround to be fixed properly later */
         IF NOT VALID-HANDLE(_h_cur_widg) THEN _h_cur_widg = _h_win.
         if OEIDEisRunning then
            run adeuib/ide/_dialog_saveaswizd.p (input (if ask_file_name then yes else no),
                                                 output lRegisterObj,
                                                 output lOK).
         else
            run adeuib/_saveaswizd.w (input (if ask_file_name then yes else no),
                                      output lRegisterObj,
                                      output lOK).                                 
                                 
         IF rRecid <> RECID(_P) THEN
           FIND _P WHERE  RECID(_P) = rRecid .
         /* Fix for IZ 10098 */
         IF NOT AVAILABLE _U AND AVAILABLE _P THEN
           FIND _U WHERE RECID(_U) = _P._u-recid.

         IF NOT lOK THEN DO:
            ASSIGN _P._SAVE-AS-FILE = cSaveFile.
            RETURN.
         END.
         
         ASSIGN _save_file = _P._SAVE-AS-FILE 
                _P.design_ryObject = lRegisterObj.
      
      END.
      ELSE DO:
         RUN adeuib/_sel_fn.p ("Save As", 
               IF (_save_file = ? OR _save_file = "") THEN "":U 
               ELSE ENTRY(NUM-ENTRIES(_save_file,"/":U), _save_file, "/":U)).
         IF _save_file = ? THEN RETURN.  /* the user cancelled */
      END.
    END.
  end. /* IF ask_file_name OR _save_file = ? */  
  
  run save_file(ask_file_name,lsaveuntitled,lRegisterObj,lmrusave,cfileWeb,input-output user_cancel).
  
  /* This code executes only if the file was not in a project before saving. */
  /* This code is similar to the one in adeuib/_open-w.p */
  IF NOT AVAILABLE _P OR _save_file = ? THEN RETURN.
  pFileName = _P._SAVE-AS-FILE.

 
END PROCEDURE. /* save_window */

/* separated out from save_window to be called from ide with already selected file name
   _P must be avail
   _save_file has the new file name */
procedure save_file  private:
    define input  parameter ask_file_name as logical no-undo.
    define input  parameter lsaveuntitled as logical no-undo.
    define input  parameter lRegisterObj as logical no-undo.
    define input  parameter lmrusave as logical no-undo.
    define input  parameter cfileWeb as character no-undo.
    
    define input-output parameter user_cancel as logical no-undo.
    
    define variable cPath         as character no-undo.
    define variable cFile         as character no-undo.
    define variable hcurwidg as handle no-undo.
    define variable hWin as handle no-undo.
    define variable cScrap as character no-undo.
    define variable cBrokerUrl as character no-undo.
    define variable cOptions as character no-undo.    
    define variable cRelName as character no-undo.
    define variable cFirstLine as character no-undo.
    define variable cAction as character no-undo.
    define variable cReturnValue as character no-undo.
    define variable proxy-file as character no-undo.
    define variable h_title_win as handle no-undo.
    define variable OldTitle as character no-undo.
    define variable cTables as character no-undo.
    define variable hTempDBLib as handle no-undo. 
    define variable cObjectType as character no-undo. 
    define variable cError as character no-undo.
    
    define buffer x_u for _u.
    define buffer d_P for _P.
    
    IF ask_file_name OR _save_file = ? then
    do:  
  
    /*
     * If ask_file_name is set then a "save as" is occuring.
     * Cover a situation with a OCX control. If an existing
     * file is being saved-as something else and the OCX binary
     * file is not using the default name, find out if the 
     * user wants to keep or reset the OCX binary name
     */
    IF OPSYS = "WIN32":U
    THEN DO:
      IF ask_file_name
      AND CAN-FIND(FIRST x_U WHERE x_U._TYPE = "{&WT-CONTROL}")
      THEN DO:
        /* There is a OCX control and this a save as.
           If the OCX binary file is not being saved in the default location
           then ask the user for direction. */

        IF _P._VBX-FILE <> ?
        THEN DO:
          if OEIDEIsRunning then
             lOk = ShowMessageInIDE("Do you want to continue to save the ~n
                                 {&WT-CONTROL} binary file in" + _P._VBX-FILE + "? ~n
                                 Choose YES to to continue; Choose NO to ~n 
                                 reset to the default location. ~n",
                                 "Question","Save {&WT-CONTROL} Binary File?","YES-NO",YES).
          else
          MESSAGE "Do you want to continue to save the" SKIP
                  "{&WT-CONTROL} binary file in" _P._VBX-FILE + "?" SKIP
                  "Choose YES to to continue; Choose NO to" SKIP
                  "reset to the default location." SKIP
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                  TITLE "Save {&WT-CONTROL} Binary File?"
                  UPDATE lOk.

          IF lOk = NO THEN _P._VBX-FILE = ?.
        END.
      END.
    END. /* MS-WINDOWS OCX */

    /* If the filename doesn't have an extension, use the proc type extension. - jep */
    RUN adecomm/_osfext.p
        (INPUT  _save_file , OUTPUT File_Ext ).
    IF (File_Ext = "") THEN
      ASSIGN _save_file = _save_file + "." + _P._FILE-TYPE.

    /*  Make sure that we have the full pathname of the local file,
        not just a local path. Build the full pathname.  */
    IF NOT _remote_file
    THEN DO:
      _save_file = REPLACE(_save_file,"~\":U, "/").
      /* If filename has not been selected, fix it up */
      FILE-INFO:FILE-NAME = _save_file.
      IF FILE-INFO:FULL-PATHNAME = ? 
          AND _P._save-as-path <> "":U
          AND _P._save-as-path <> ".":U
          AND NOT _save_file BEGINS (_P._save-as-path + "/":U) /* Don't double it */
      THEN
        FILE-INFO:FILE-NAME = RIGHT-TRIM(_P._save-as-path, "/":U) + "/":U + _save_file.


      IF FILE-INFO:FULL-PATHNAME = ?
      THEN DO:
        /* Figure out the current path, but first, figure out if the
           proposed name already is a fully qualified name. 
           If the path is "?" then there was no path. The _save_file 
           is a simple name. Build a full path for it.  */
        RUN adecomm/_osprefx.p(_save_file, OUTPUT cPath, OUTPUT cFile).
        IF (LENGTH(cPath) = 0)
        THEN DO:
          FILE-INFO:FILE-NAME = ".":U.
          RUN adecomm/_osfmush.p(FILE-INFO:FULL-PATHNAME, _save_file,
                                 OUTPUT _save_file).
        END.
      END.
      ELSE
        _save_file = FILE-INFO:FULL-PATHNAME.

      _save_file = REPLACE(_save_file, "/", "~\":U).

    END. /* NOT remote_file */

    /*
     * Now check to see if the file that the user selected is already in
     * the list of active windows. If it is, then let the user know there
     * is a conflict. It is up to the user to get everything figured
     * out. We check to see if there are 2 records with the same name.
     * If there are 0 or 1 the FIND NEXT will fail.
     */
    IF NOT _remote_file OR cFileWeb = ? OR cFileWeb = "" THEN
        FIND d_P WHERE d_P._SAVE-AS-FILE = _save_file  AND
                       RECID(d_P) <> RECID(_P) NO-ERROR.
    ELSE DO:
        DEF VAR sv AS CHAR NO-UNDO.
        DEF VAR sa AS CHAR NO-UNDO.

        ASSIGN sv = ws-get-relative-path (INPUT cFileWeb)
               sa = ws-get-save-as-path (INPUT cFileWeb).

        /* for remote files, we may have got a file name with the path
           which we store in _save-path-as, so we need to check if it
           matches the exact same file.
        */
        FIND d_P WHERE d_P._SAVE-AS-FILE = sv AND d_P._save-as-path = sa AND
                       RECID(d_P) <> RECID(_P) NO-ERROR.
    END.

    IF AVAILABLE d_P THEN DO:
      if OEIDEIsRunning then
           ShowMessageInIDE("Another window uses ~n" +
                                 (IF cFileWeb NE ? THEN ws-get-relative-path (INPUT cFileWeb) ELSE _save_file)
                                + "to save into. ~n
                                Either close that window or choose another filename ~n 
                                for this window. The 'Save As...' operation has been cancelled.",
                                 "Warning",?,"OK",YES).
      else  
      MESSAGE
        "Another window uses" 
        (IF cFileWeb NE ? THEN ws-get-relative-path (INPUT cFileWeb) ELSE _save_file)
        "to save into." SKIP
        "Either close that window or choose another filename" SKIP
        "for this window. The 'Save As...' operation has been cancelled."
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      _save_file = ?.
    END.
  END.

  /*
   * Now check to see if the local file to save is writable. If not, tell the 
   * user and abort the save.  Note: Message used here is the same as the 
   * Procedure Editor and Procedure Windows use.
   */
  IF NOT _remote_file THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = _save_file.
    IF (FILE-INFO:FULL-PATHNAME <> ?) AND
       (INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0)
    THEN DO:
      DO ON STOP   UNDO, LEAVE
         ON ENDKEY UNDO, LEAVE
         ON ERROR  UNDO, LEAVE:
        if OEIDEIsRunning then
           ShowMessageInIDE(_save_file + 
                            "Cannot save to this file. ~n
                            File is read-only or the path specified ~n
                            is invalid. Use a different filename.",
                            "Warning",?,"OK",YES).
        else     
        MESSAGE _save_file SKIP
          "Cannot save to this file."  SKIP(1)
          "File is read-only or the path specified" SKIP
          "is invalid. Use a different filename."
          VIEW-AS ALERT-BOX WARNING BUTTONS OK IN WINDOW ACTIVE-WINDOW.
      END.
      ASSIGN _save_file = ?.
    END.
  END. /* NOT remote_file */

  /*  
   * We'll live off the state of the _save_file variable. If there is no
   * value then the user cancelled out of the save. That means that
   * the user wants to abort the operation. If the use of _save_file
   * changes then this check could be hosed.
   */
  IF _save_file NE ? THEN DO:
    /* Set the cursor pointer in all windows */
    RUN setstatus ("WAIT":U,"Saving file...").
    ASSIGN
      _h_win       = _U._HANDLE
      web-tmp-file = ""
      _save_mode   = (IF ask_file_name THEN "T":U ELSE "F":U) + ",":U +
                     (IF lSaveUntitled THEN "T":U ELSE "F":U).
    /* Save existing or untitled WebSpeed file to a local temp file first. */
    IF (NOT ask_file_name AND _P._broker-url ne "") OR 
       (    ask_file_name AND _remote_file        ) OR lSaveUntitled THEN
      RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT web-tmp-file).

    ASSIGN hWin     = _h_win
           hCurWidg = _h_cur_widg.
    IF _P._file-version BEGINS "WDT_v2":U THEN
      RUN adeweb/_genweb.p (RECID(_P), "SAVE":U, ?, _save_file, OUTPUT cScrap).
    ELSE  
      RUN adeshar/_gen4gl.p (IF ask_file_name THEN "SAVEAS" ELSE "SAVE":U).
  
    /* Closing/saving a SmartObject may cause focus to move to the instance of
       the object in a SmartWindow due to it being recreated after code generation.
       This can set the current window and widget _h_win and _h_cur_widg to the
       SmartWindow containing the instance, which is undesirable. So if it does
       change, reset the current window and widget back to what it was before
       the close/save/code generation. 9.1B Fix 20000510-005 -jep. */
    IF _h_win <> hWin THEN
    DO:
      /* If the "current widget" prior to code gen is gone or we never had one
         (for example, multiple widgets were selected), set current widget to
         design window. -jep */
      IF NOT VALID-HANDLE(hCurWidg) THEN
        ASSIGN hCurWidg = hWin.
      RUN changewidg (INPUT hCurWidg , INPUT NO /* deselect others */).
    END.

    /* With user defined code in SmartObjects it is possible that focus is lost.
       This causes _U to get lost, so we restore it here. */
    IF NOT AVAILABLE _U THEN
      FIND _U WHERE _U._HANDLE = _h_win.

    /* Save remote file to a WebSpeed agent and restore web-tmp-file. */
    IF (NOT ask_file_name AND _P._broker-url <> "") OR 
       (    ask_file_name AND _remote_file        ) OR lSaveUntitled THEN DO:
      IF NOT RETURN-VALUE BEGINS "Error":U THEN DO:
        ASSIGN
          cBrokerURL = IF (ask_file_name OR _P._broker-url eq "")
                       THEN _BrokerURL ELSE _P._broker-url
          cOptions   = (IF ask_file_name OR lSaveUntitled 
                         THEN "SAVEAS":U ELSE "SAVE":U) +
                       (IF (_P._compile AND NOT _P._template) 
                         THEN ",COMPILE":U ELSE "").

        RUN disable_widgets.
        
        RUN adeweb/_webcom.w (RECID(_P), cBrokerURL, _save_file, cOptions,
                              OUTPUT cRelName, INPUT-OUTPUT web-tmp-file).
        
        IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
          ASSIGN
            cFirstLine   = ENTRY(1, RETURN-VALUE, CHR(10))
            cAction      = IF NUM-ENTRIES(cFirstLine, " ":U) ge 3 THEN
                             ENTRY(3, cFirstLine, " ":U) ELSE "saved".
            cReturnValue = SUBSTRING(RETURN-VALUE, INDEX(RETURN-VALUE,CHR(10)) + 1,
                                     -1, "CHARACTER":U).
          RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
            SUBSTITUTE("&1 could not be &2 for the following reason:^^&3",
            _save_file, cAction, cReturnValue)).
        END.
        ELSE DO:
          IF cRelName ne ? AND cRelName ne "" THEN 
            _save_file = cRelName.
            
          /* If saving a DB-Aware object, compile the proxy file now.  We 
             couldn't do it before (adeshar/_gen4gl.p), since the .w did not
             yet exist. */
          IF _P._DB-AWARE THEN DO:
            proxy-file = SUBSTRING(_save_file,1,R-INDEX(_save_file,".":U) - 1,
                              "CHARACTER":U) + "_cl.w":U.

            RUN adeweb/_webcom.w (RECID(_P), cBrokerURL, proxy-file, 
                                  "compile":U, OUTPUT cRelName, 
                                  INPUT-OUTPUT web-tmp-file).
            IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
              cReturnValue = SUBSTRING(RETURN-VALUE, INDEX(RETURN-VALUE,CHR(10)) + 1,
                                       -1, "CHARACTER":U).
              RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
                SUBSTITUTE("&1 could not be compiled for the following reason:^^&2",
                proxy-file, cReturnValue)).
            END.
          END. /* writing a proxy file */
          
          /* check for _u SmartObjects, use preselect because 
             adeuib/_recreat.p deletes and creates an _u.
            Note that recreat will reset _h_win  */
          hWin = _h_win. 
          REPEAT PRESELECT EACH _U WHERE _U._TYPE EQ "SmartObject" 
                                 AND   _U._STATUS NE "DELETED":U:
          
         FIND NEXT _U.
         FIND _S WHERE RECID(_S) = _u._x-recid.
                           
            /* If the smartObject is the saved one */
            IF _s._file-name = _save_file THEN 
            DO: 
              /* find the procedure and recreate the smartobject if the 
                 url matches */                  
              FIND d_P WHERE d_P._window-handle = _U._window-handle no-error.
              IF AVAIL d_P 
              AND d_P._broker-url <> "" 
              AND d_P._broker-url = cBrokerUrl 
              AND VALID-HANDLE(d_p._tv-proc) THEN 
                RUN adeuib/_recreat.p (RECID(_U)).
         END.
       END. /* repeat preselect */ 
          _h_win = hWin. /* window handle may change in  _recreat.p  */
        END.
                    
        RUN enable_widgets.                              
  
  /* Refind _U that was "lost" during previous run of enable_widgets. */
        FIND _U WHERE _U._HANDLE = _h_win.
      END.
      OS-DELETE VALUE(web-tmp-file).
      ASSIGN web-tmp-file = "".
    END.
    
    IF NOT (RETURN-VALUE BEGINS "Error":U) THEN DO:
      SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
      ASSIGN
        user_cancel            = NO 
        _P._FILE-SAVED         = TRUE
        _P._SAVE-AS-FILE       = _save_file
        h_title_win            = IF (_U._TYPE = "DIALOG-BOX":U)
                                  THEN _U._HANDLE:PARENT
                                  ELSE _U._HANDLE
        OldTitle               = h_title_win:TITLE.

      /* for remote files, need to save path into _save-as-path, if path
         was passed 
      */
      IF _remote_file AND (cFileWeb NE ?) THEN DO:
         ASSIGN _P._save-as-file = ws-get-relative-path (INPUT cFileWeb)
                _P._save-as-path = ws-get-save-as-path (INPUT cFileWeb).
      END.

      IF ask_file_name OR lSaveUntitled THEN
        _P._BROKER-URL = IF _remote_file THEN _BrokerURL ELSE "".
        
      RUN adeuib/_wintitl.p (h_title_win, _U._LABEL, _U._LABEL-ATTR, 
                             _P._SAVE-AS-FILE).
      /* Change the active window title on the Window menu. */
      IF (h_title_win:TITLE <> OldTitle) AND VALID-HANDLE(_h_WinMenuMgr) THEN
        RUN WinMenuChangeName IN _h_WinMenuMgr
          (_h_WindowMenu, OldTitle, h_title_win:TITLE). 

      /* We updated the dirty setting for OCX controls in _gen4gl.p by calling
         Set_Control_Dirty. Just wanted you to know. -jep */
         
      /* Notify the Section Editor of the window title change. Data after 
         "SE_PROPS" added for 19990910-003. */
      RUN call_sew ( "SE_PROPS":U ). 

      /* If we are saving a Method Library, LIB-MGR reopens it in memory. */
      /* Fixes bug 19950601-042. */
      IF _P._TYPE = "Method-Library":U THEN
        RUN reopen-lib IN _h_mlmgr (_save_file, _P._Broker-URL).     
          
      /* Update most recently used filelist */    
      IF lMRUSave AND _mru_filelist AND NOT lRegisterObj THEN 
        RUN adeshar/_mrulist.p ( (IF cFileWeb NE ? THEN cFileWeb ELSE _save_file), IF _remote_file THEN _BrokerURL ELSE "").
 
      /* lMRUSave is TRUE when this is a new object being saved for the first
         time or if it is an existing object being saved with a new name.  In
         those situations, the temp file name for the object needs to be 
         reset. */
      IF lMRUSave THEN
        _P._comp_temp_file = "":U.

      /* IZ 776 Redisplay current filename in AB Main window. */
      RUN display_current IN _h_uib.
      
      /*Temp-DB maintenance tool integration. If this is an existing file, check whether the file
        exists in the TEMP-DB control table */
      IF CONNECTED ("TEMP-DB":U) THEN
      DO:
         RUN adeuib/_tempdbvalid.p (OUTPUT lOK). /* Check that control file is present in TEMP-DB */
         IF lOK THEN
         DO:          
            GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBIntegration":U VALUE cValue.
      IF CAN-DO ("true,yes,on":U,cValue) THEN
      DO:
         GET-KEY-VALUE SECTION  "ProAB":U KEY "TempDBExtension":U VALUE cValue.
               IF cValue > "" AND _save_file MATCHES cValue THEN 
               DO:
                  RUN adecomm/_relname.p (INPUT _save_file, INPUT "", OUTPUT cRelName).
                  RUN adeuib/_tempdbfind.p (INPUT "SOURCE":U,
                                            INPUT cRelName ,
                                            OUTPUT cTables).
                  /* Only update if source file already exists */                          
                  IF cTables > "" THEN
                  DO:
                     hTempDBLib = SESSION:FIRST-PROCEDURE.
                     DO WHILE VALID-HANDLE(hTempDBLib) AND hTempDBLib:FILE-NAME NE "adeuib/_tempdblib.p":U:
                        hTempDBLib = hTempDBLib:NEXT-SIBLING.
                     END.
     
                     IF NOT VALID-HANDLE(hTempDBLib) THEN
                     DO:
                        RUN VALUE("adeuib/_tempdblib.p":U) PERSISTENT SET hTempDBLib.
                        RUN RebuildImport in hTempDBLib (cRelName).
                        IF VALID-HANDLE(hTempDBLib) THEN
                           DELETE PROCEDURE hTempDBLib.
                     END.
                     ELSE   
                        RUN RebuildImport in hTempDBLib (cRelName).
                        
                  END.
               END. /* End if file extension matches */
            END. /* End if flag is set to yes to do perfrom TEmp-DB rebuild */
         END. /* End if temp-db is valid */
      END.  /* End If connected Temp-DB */
      
      
    END. /* If no _gen4gl error */
    
    RUN setstatus ("":U,"":U).  /* Set the cursor pointer in all windows */
    
    /* If we compiled (and found an error) then show the Error in the SEW. */
    IF _P._compile AND _err_recid <> ? THEN DO:
      RUN call_sew ( INPUT "SE_ERROR":U).
      ASSIGN _err_recid = ?.
    END.

    /* Unlike other UIB actions, don't Return to pointer mode 
       (see bug 19931206-02). */
       
    /* jep-icf: IZ 1981 Save static repository object. */
    /* Only save if user specified to register the object */
    IF _DynamicsIsRunning  AND lRegisterObj THEN
    do: 
        /*  historical name, saves dynamics non native */
       RUN save_window_static (INPUT RECID(_P), OUTPUT cError).
    end.  
    _P.design_action = "OPEN":U.
  END. /* _save_file NE ? */

  /* Dynamics: IZ 6618. When saving an object, force tools to refresh its instances of the saved smartobject */
  IF _DynamicsIsRunning                 AND
     VALID-HANDLE(gshRepositoryManager) AND
     _P.smartObject_obj <> ?            AND
     _P.smartObject_obj <> 0            THEN
    PUBLISH "MasterObjectModified":U FROM gshRepositoryManager (INPUT _P.smartObject_obj, INPUT _P.Object_FileName).
 
 
END PROCEDURE. /* save_window */


/* save_window_static Saves the current _P as a static repository object. */
PROCEDURE save_window_static :
  
/* Note this is the historical name.  This will also identify if a window is
   to be converted to a dynamic window and save it accordingly           */

    DEFINE INPUT  PARAMETER pPrecid       AS RECID      NO-UNDO.
    DEFINE OUTPUT PARAMETER pError        AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE lPrompt               AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cAssociatedDataObject AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSavedPath            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjPath              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFilename             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cLine                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cRelname              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cObjectType           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dDlObj                AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hAttributeBuffer      AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hAttributeTable       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hRepDesManager        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lmrusave              AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lregLP                AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iEnd                  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iStart                AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cObjectFileName       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcRelativePath     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcRootDir          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcRelPathSCM       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcFullPath         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcObject           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcFile             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCalcError            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSDOToRun             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cError                AS CHARACTER  NO-UNDO.
    
    /* If we aren't running ICF, leave now. */
    IF NOT CAN-DO(_AB_Tools,"Enable-ICF") THEN RETURN.

    /* Save off type code as we may need it later (IZ 6132) */
    ASSIGN cObjectType = _P.object_type_code.

    FIND _P WHERE RECID(_P) = pPrecid NO-ERROR.
    IF NOT AVAILABLE _P THEN
    DO:
      RETURN.
    END.

    FIND _U WHERE RECID(_U) eq _P._u-recid NO-ERROR.
    FIND _C WHERE RECID(_C)  = _U._x-recid NO-ERROR.

    ASSIGN  lMRUSave   = CAN-DO(_P.design_action ,"NEW":u).

    /* If this is a NEW static SDO and user has indicated it should be registered,
       then the logic procedure should be registered also                      */
    IF lMRUSave AND _P.OBJECT_type_code = "SmartDataObject":U AND 
       _P.static_object THEN lregLP = YES.

    /* If the object isn't to be defined as a repository object */
    IF (_P.design_ryobject = NO) THEN RETURN.
      
    /* If the object is to be stored as a dynamic object then call rygendynp.p */
    IF (_P.static_object = NO) THEN DO ON ERROR UNDO, LEAVE:

      RUN setstatus ("WAIT":U,"Saving object...":U).
      
      /* The design action might have been "NEW", but now object is save. So the
         action is changed to "OPEN". */
      IF CAN-DO(_P.design_action, "NEW":U) THEN
        ASSIGN _P.design_action = REPLACE(_P.design_action, "NEW":U, "OPEN":U).

      RUN ry/prc/rygendynp.p (INPUT pPrecid, 
                              OUTPUT pError,   /* Error saving object */
                              OUTPUT cError).  /* Error saving associated procedure - if there is one */
         
      RUN setstatus ("":U,"":U).

      IF (pError <> "" AND NOT pError BEGINS "Associated data":U) THEN
      DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
         IF NUM-ENTRIES(pError,"^") GE 3 THEN
            RUN showMessages IN gshSessionManager 
                            (INPUT pError,
                             INPUT "ERR":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "Object Register Error",
                             INPUT YES,
                             INPUT ?,
                             OUTPUT cError).
         ELSE
         if OEIDEIsRunning then
           ShowMessageInIDE("Object not saved to repository. ~n" 
                            + pError,
                            "Warning",?,"OK",yes).
          else
          MESSAGE "Object not saved to repository." SKIP(1)
                  pError
            VIEW-AS ALERT-BOX WARNING.
      END.

    END. /* If a dynamic or logical object */

    ELSE DO ON ERROR UNDO, LEAVE:
    
      RUN setstatus ("":U,"":U).

      /* The design action might have been "NEW", but now object is save. So the
         action is changed to "OPEN". */
      IF CAN-DO(_P.design_action, "NEW":U) THEN
        ASSIGN _P.design_action = REPLACE(_P.design_action, "NEW":U, "OPEN":U).


      /* If the user changed the filename during a save as, update the object filename.
         This results in the file being saved to the repository with a different name. */
      RUN adecomm/_osprefx.p (INPUT _P._SAVE-AS-FILE, OUTPUT cSavedPath, OUTPUT cFilename).
      ASSIGN _P.object_filename = cFilename.

      /* Determine the propath relative name for this object. This may be different
         than the product module and even where the object was originally opened
         from. */
      RUN adecomm/_relfile.p
          (INPUT _P._SAVE-AS-FILE, INPUT NO /* plCheckRemote */,
           INPUT "" /* pcOptions */, OUTPUT cRelname).

      ASSIGN cSDOToRun = cRelname.

      /* cRelname contains filename. Take it off so we just have propath relative path. */
      RUN adecomm/_osprefx.p
          (INPUT cRelname, OUTPUT cRelname, OUTPUT cFilename).

      /* Trim trailing directory slashes (\ or /) and replace remaining ones with
         forward slash for portability with how repository stores paths. */
      ASSIGN cRelname = REPLACE(LC(RIGHT-TRIM(cRelname, '~\/')), "~\", "/").
      ASSIGN _P.object_path = cRelname.
      

      /* Prompt for Product Module if for some reason we don't have it. */
      ASSIGN lPrompt = (_P.product_module_code = "":u).
      
      RUN setstatus ("WAIT":U,"Saving object...":U).

      /* Create master SDF object */
      ASSIGN hAttributeBuffer = ?
             hAttributeTable  = ?
             .

      cAssociatedDataObject = "".
      ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) 
          NO-ERROR.
      IF VALID-HANDLE(ghRepositoryDesignManager) AND _P._data-object NE "":U THEN DO:
        IF DYNAMIC-FUNCTION("ObjectExists":U IN ghRepositoryDesignManager, INPUT _P._data-object) THEN
          cAssociatedDataObject = _P._data-object.
      END.
      
      /* Check physical file is stored in same relative directory as module */ 
      RUN calculateObjectPaths IN gshRepositoryManager
                         ("",  /* ObjectName */          0.0, /* Object Obj */      
                          "",  /* Object Type */         _P.product_module_code,  /* Product Module Code */
                          "", /* Param */                "",
                          OUTPUT cCalcRootDir,           OUTPUT cCalcRelativePath,
                          OUTPUT cCalcRelPathSCM,        OUTPUT cCalcFullPath,
                          OUTPUT cCalcObject,            OUTPUT cCalcFile,
                          OUTPUT cCalcError).
         
      IF cCalcError > "" THEN
      DO:
        if OEIDEIsRunning then
           ShowMessageInIDE(cCalcError,"Warning",?,"OK",yes).
        else  
        MESSAGE cCalcError VIEW-AS ALERT-BOX.
        DELETE _RYObject.
        RETURN.
      END.

      IF cCalcRelPathSCM > "" THEN
         cCalcRelativePath = cCalcRelPathSCM.    

      /* Call Dynamics procedure to save static object to repository. You'll see
         a similar call in save_window_static  IN _h_uib. */
      ASSIGN cObjectFileName = REPLACE(_P.object_filename, "~\", "/")
             cObjectFileName = TRIM(ENTRY(NUM-ENTRIES(cObjectFileName, "/":U), cObjectFileName, "/")).
      IF R-INDEX(cObjectFileName,".") > 0 
         AND SEARCH(cCalcRelativePath 
                    + (IF cCalcRelativePath > "" THEN "~/":U ELSE "") 
                    + cObjectFileName ) = ? THEN 
      DO:
         if OEIDEIsRunning then
           ShowMessageInIDE(cObjectFileName +  " is not located in the ' " 
                           + (IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                              THEN cCalcRelativePath
                              ELSE "default")
                           + "' directory." + CHR(10) + 
                           "The file must be located in the same directory as the product module's relative path. ":U,
                           "Warning",?,"OK",yes).
         else 
         MESSAGE cObjectFileName +  " is not located in the '" 
                        + (IF cCalcRelativePath > "" AND cCalcRelativePath <> "."
                          THEN cCalcRelativePath
                          ELSE "default")
                        + "' directory." + CHR(10) + 
                        "The file must be located in the same directory as the product module's relative path.":U VIEW-AS ALERT-BOX WARNING.
         pError = "Object: " + cObjectFileName.
      
      END.                  
      ELSE DO:  
         IF _P._TYPE = "SmartDataObject":U THEN 
           RUN createSDOLabelAttr IN _h_menubar_proc 
               (INPUT cSDOToRun, 
                INPUT RECID(_P), 
                OUTPUT hAttributeBuffer).

         RUN insertObjectMaster IN ghRepositoryDesignManager 
            ( INPUT  _P.object_filename,     /* pcObjectName         */
              INPUT  "":U,                   /* pcResultCode         */
              INPUT  _P.product_module_code, /* pcProductModuleCode  */
              INPUT  IF cObjectType > "" 
                     THEN cObjectType ELSE _P._TYPE,               /* pcObjectTypeCode     */
              INPUT  _P.object_description,  /* pcObjectDescription  */
              INPUT  _P.object_path,         /* pcObjectPath         */
              INPUT  cAssociatedDataObject,  /* pcSdoObjectName      */
              INPUT  "":U,                   /* pcSuperProcedureName */
              INPUT  NO,                     /* plIsTemplate         */
              INPUT  YES,                    /* plIsStatic           */
              INPUT  "":U,                   /* pcPhysicalObjectName */
              INPUT  NO,                     /* plRunPersistent      */
              INPUT  "":U,                   /* pcTooltipText        */
              INPUT  "":U,                   /* pcRequiredDBList     */
              INPUT  "":U,                   /* pcLayoutCode         */
              INPUT  hAttributeBuffer,
              INPUT  TABLE-HANDLE hAttributeTable,
              OUTPUT dDlObj                                   ) NO-ERROR.
         pError = RETURN-VALUE.
      END.
      
      IF dDlObj NE 0 AND _P.deployment_type NE "" AND VALID-HANDLE(ghRepositoryDesignManager) THEN
        RUN updateDeploymentType IN ghRepositoryDesignManager (INPUT dDlObj, INPUT _P.deployment_type) NO-ERROR.

      /* If registering a static SDO then register its logic procedure (if specified) */
      IF pError = "" OR pError = ? THEN
      DO:
         IF (lregLP AND AVAIL _C AND _C._DATA-LOGIC-PROC > "") 
             OR (AVAIL _C AND _C._DATA-LOGIC-PROC  <> "" AND _C._DATA-LOGIC-PROC-NEW) THEN 
         DO:
            ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
            IF VALID-HANDLE(ghRepositoryDesignManager) THEN 
            DO:
              RUN insertObjectMaster IN ghRepositoryDesignManager 
                  ( INPUT  _C._DATA-LOGIC-PROC,                      /* pcObjectName         */
                    INPUT  "":U,                                     /* pcResultCode         */
                    INPUT  _P.product_module_code,                   /* pcProductModuleCode  */
                    INPUT  "DLProc":U,                               /* pcObjectTypeCode     */
                    INPUT  "Logic Procedure for ":U + cFilename,     /* pcObjectDescription  */
                    INPUT  "":U,                                     /* pcObjectPath         */
                    INPUT  _P._SAVE-AS-FILE,                         /* pcSdoObjectName      */
                    INPUT  "":U,                                     /* pcSuperProcedureName */
                    INPUT  NO,                                       /* plIsTemplate         */
                    INPUT  YES,                                      /* plIsStatic           */
                    INPUT  "":U,                                     /* pcPhysicalObjectName */
                    INPUT  NO,                                       /* plRunPersistent      */
                    INPUT  "":U,                                     /* pcTooltipText        */
                    INPUT  "":U,                                     /* pcRequiredDBList     */
                    INPUT  "":U,                                     /* pcLayoutCode         */
                    INPUT  hAttributeBuffer,
                    INPUT  TABLE-HANDLE hAttributeTable,
                    OUTPUT dDlObj                                   ) NO-ERROR.
               pError = RETURN-VALUE.
            END.  /* We have the handle of the Repository Design Manager */
            ASSIGN _C._DATA-LOGIC-PROC-NEW = FALSE.
         END. /* If we should attempt to register the LP */
      END.  /* If no error registering SDO */

      RUN setstatus ("":U,"":U).
      
      hRepDesManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
      /* Retrieve the objects for the specified object */
      EMPTY TEMP-TABLE ttObject.
      RUN retrieveDesignObject IN hRepDesManager ( INPUT  cFilename,
                                                   INPUT  "",  /* Get default result Code */
                                                   OUTPUT TABLE ttObject ,
                                                   OUTPUT TABLE ttPage,
                                                   OUTPUT TABLE ttLink,
                                                   OUTPUT TABLE ttUiEvent,
                                                   OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
      FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = cFilename 
                            AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
      IF NOT AVAIL ttObject THEN
      DO:
        RUN retrieveDesignObject IN hRepDesManager ( INPUT  ENTRY(1,cFilename,".":U),
                                                     INPUT  "",  /* Get default result Code */
                                                     OUTPUT TABLE ttObject ,
                                                     OUTPUT TABLE ttPage,
                                                     OUTPUT TABLE ttLink,
                                                     OUTPUT TABLE ttUiEvent,
                                                     OUTPUT TABLE ttObjectAttribute ) NO-ERROR.  
        FIND FIRST ttObject WHERE ttObject.tLogicalObjectname       = ENTRY(1,cFileName,".":U) 
                              AND ttObject.tContainerSmartObjectObj = 0 NO-ERROR.
      END.
      IF AVAIL ttObject THEN
         ASSIGN _P.SmartObject_Obj = ttobject.tSmartObjectObj
                _P.Object_FileName = ttObject.tLogicalObjectname
                _P.design_RyObject = yes.
/*
      message "Saving object..." SKIP(1)
              "File:  " _P._SAVE-AS-FILE  SKIP
              "Type:  " _P._TYPE          SKIP
              "PMCode:" _P.product_module_code SKIP
              "OType: " _P.object_type_code SKIP
              "Path:  " _P.object_path    SKIP
              "Name:  " _P.object_filename SKIP
              "Desc:  " _P.object_description SKIP
              "Action:" _P.design_action    SKIP
              "Object:" _P.object_filename SKIP
              "SmartObj:" _P.smartObject_Obj SKIP
              "ParClasses:" _P.PARENT_classes
           VIEW-AS ALERT-BOX.
*/
  
      IF (pError <> "") THEN
      DO ON  STOP UNDO, LEAVE ON ERROR UNDO, LEAVE:
        IF NUM-ENTRIES(pError,"^") GE 3 THEN
            RUN showMessages IN gshSessionManager 
                            (INPUT pError,
                             INPUT "ERR":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "OK":U,
                             INPUT "Object Register Error",
                             INPUT YES,
                             INPUT ?,
                             OUTPUT cError).

        ELSE
        do: 
          if OEIDEIsRunning then
           ShowMessageInIDE("Object not saved to repository. ~n" 
                            + pError,"Warning",?,"OK",yes).
          else    
          MESSAGE "Object not saved to repository." SKIP(1)
                  pError
            VIEW-AS ALERT-BOX WARNING.
        end.    
      END.
      ELSE
      DO:   /* Add static registered object to mru list */
         IF lMRUSave AND _mru_filelist  THEN 
            RUN adeshar/_mrulist.p ( _P.Object_FileName, IF _remote_file THEN _BrokerURL ELSE "").
         RUN display_current IN _h_uib.
      END.
    END. /* DO ON ERROR */
  
END PROCEDURE.  /* save_window_static */


/* sensitize_main_window - change the sensitive status of widgets in the UIB's
 *       main window based on the current state of affairs.
 *       There are various things we can check for in this procedure.  These are
 *       listed in the pCheck string.  The items are:
 *          WINDOW - check for the existance of a window, and its type
 *          WIDGET - check for the existance and type of _h_cur_widg
 */
PROCEDURE sensitize_main_window :
  DEFINE INPUT PARAMETER pCheck AS CHAR NO-UNDO.
  DEFINE VARIABLE l             AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE lDynamic      AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE lMulti        AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE menu_handle   AS HANDLE            NO-UNDO.
  DEFINE VARIABLE window-check  AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE widget-check  AS LOGICAL           NO-UNDO.
  DEFINE VARIABLE frame_cnt     AS INTEGER INITIAL 0 NO-UNDO.
 
  /* Decide what items to check. */
  ASSIGN widget-check = CAN-DO(pCheck, "WIDGET") 
         window-check = CAN-DO(pCheck, "WINDOW").
     /* Do window checking. */
  IF window-check THEN DO:
    /* Disable things if there is NO window - the "key" widget here is the
       "Save" button.  If that is already set, then don't worry about it. */
    l = VALID-HANDLE(_h_win).
    IF l THEN FIND _P WHERE _P._WINDOW-HANDLE eq _h_win NO-ERROR.
    IF l NE _h_button_bar[3]:SENSITIVE THEN
    DO:
      ASSIGN _h_button_bar[3]:SENSITIVE = l /* save */
             _h_button_bar[4]:SENSITIVE = l /* print */
             _h_button_bar[5]:SENSITIVE = l /* proc */
             _h_button_bar[6]:SENSITIVE = l /* run */
             _h_button_bar[7]:SENSITIVE = l /* edit */
             _h_button_bar[8]:SENSITIVE = l /* list */
             _h_button_bar[10]:SENSITIVE = l AND _visual-obj.  /* color */
     /* IF VALID-HANDLE(_h_button_bar[11]) THEN
         ASSIGN
           _h_button_bar[11]:SENSITIVE = l.
           
     */
             /* File Menu */
      ASSIGN MENU-ITEM mi_close:SENSITIVE     IN MENU m_file = l 
             MENU-ITEM mi_close_all:SENSITIVE IN MENU m_file = l
             MENU-ITEM mi_save:SENSITIVE      IN MENU m_file = l
             MENU-ITEM mi_save_all:SENSITIVE  IN MENU m_file = l
             MENU-ITEM mi_save_as:SENSITIVE   IN MENU m_file = l 
             MENU-ITEM mi_print:SENSITIVE     IN MENU m_file = l.
             
             /* Edit Menu */
      ASSIGN MENU-ITEM mi_paste:SENSITIVE     IN MENU m_edit = l AND
                AVAILABLE _P AND (NOT _P._TYPE BEGINS "WEB":U OR 
                                  CAN-FIND(FIRST _U WHERE _U._SELECTEDib))
             mi_export:SENSITIVE  = l AND
                                    MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit
                                              WHEN VALID-HANDLE(mi_export) 
             /* Note: we can export a file of internal procedures, even if no
                widgets are selected.  "Copy to File..." does not depend on
                the existance of selected widgets (like COPY). */ 
             mi_import:SENSITIVE  = l AND
                                    MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit
                                               WHEN VALID-HANDLE(mi_import) .
                                               
             /* Compile Menu */
      ASSIGN MENU-ITEM mi_run:SENSITIVE       IN MENU m_compile = l 
             MENU-ITEM mi_check:SENSITIVE     IN MENU m_compile = l
             MENU-ITEM mi_debugger:SENSITIVE  IN MENU m_compile = l
             MENU-ITEM mi_preview:SENSITIVE   IN MENU m_compile = l .

             /* Tools Menu Menu */
      ASSIGN mi_proc_settings:SENSITIVE = l   WHEN VALID-HANDLE(mi_proc_settings)
             mi_color:SENSITIVE         = _h_button_bar[10]:SENSITIVE
                                              WHEN VALID-HANDLE(mi_color)
              /* Windows Menu */
             mi_code_edit:SENSITIVE     = l   WHEN VALID-HANDLE(mi_code_edit).
    END.
    
    /* Determine if this is a customizable Dynamic object */
    IF _DynamicsIsRunning THEN
       mi_CustomParams:SENSITIVE = _DynamicsIsRunning = YES.

    /* Some actions depend on the _P settings. This is the
       Pages (which only work in PAGE-TARGETS) and Alternate Layouts. */
    IF NOT l THEN
      ASSIGN mi_goto_page:SENSITIVE    = NO WHEN VALID-HANDLE(mi_goto_page)
             mi_chlayout:SENSITIVE     = NO WHEN VALID-HANDLE(mi_chlayout)
             mi_chCustLayout:SENSITIVE = NO WHEN VALID-HANDLE(mi_chCustLayout)
             mi_assign_widgetid:SENSITIVE = NO WHEN VALID-HANDLE(mi_assign_widgetid)
      .
    ELSE DO:
      IF _DynamicsIsRunning THEN
         lDynamic = DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynView":U) OR
                    DYNAMIC-FUNCTION("ClassIsA" IN gshRepositoryManager, _P.object_type_code, "DynBrow":U).
      ELSE lDynamic = FALSE.
      
      /* Does the SmartContainer support paging. */
      ASSIGN mi_goto_page:SENSITIVE = CAN-DO(_P._links, "PAGE-TARGET")
                        WHEN VALID-HANDLE(mi_goto_page)
             lMulti = (_P._FILE-TYPE eq "w":U) AND NOT lDynamic
                      /* Are multi-layout supported by this type? 
                         That is, by anything that is a .w file. */
             mi_chlayout:SENSITIVE = lMulti WHEN VALID-HANDLE(mi_chlayout)
             mi_chCustLayout:SENSITIVE = lDynamic WHEN VALID-HANDLE(mi_chCustLayout)
             /* Assign Widget IDs should be senstive for GUI, static design windows
                that allow drawing of basic objects */
             mi_assign_widgetid:SENSITIVE = NOT lDynamic AND 
                                            CAN-DO(_P._ALLOW, "BASIC":U) AND 
                                            _cur_win_type
                                            WHEN VALID-HANDLE(mi_assign_widgetid)
             /* Disable Debug for WebSpeed Web objects. */
             MENU-ITEM mi_debugger:SENSITIVE IN MENU m_compile = 
               (NOT _P._TYPE BEGINS "WEB":U AND
                NOT CAN-FIND(FIRST _TRG WHERE 
                      _TRG._pRECID   eq RECID(_P) 
                  AND _TRG._tSECTION eq "_PROCEDURE":U
                  AND _TRG._tEVENT   eq "process-web-request":U))
             .
       
    END.  /* Else do */
                   
    /* Disable things if there is TTY window - the "key" widget here is the
       "Snap to Grid" menu-item button.  If that is already set, then don't
       worry about it. */
    l = (_cur_win_type ne NO).  /* This can be ? at startup. */
      
    IF VALID-HANDLE(mi_grid_snap) AND l ne mi_grid_snap:SENSITIVE THEN
      ASSIGN _h_button_bar[10]:SENSITIVE = l AND _visual-obj  /* Color */
             mi_grid_snap:SENSITIVE    = l AND _visual-obj
             mi_color:SENSITIVE        = _h_button_bar[10]:SENSITIVE
                                             WHEN VALID-HANDLE(mi_color).
                                             
    /* OpenEdge IDE - Edit->Insert->Procedure,
                      Edit->Insert->Function */
    IF OEIDEIsRunning AND 
       VALID-HANDLE(m_insert) AND 
       VALID-HANDLE(mi_insert_procedure) AND
       VALID-HANDLE(mi_insert_function) THEN DO:
      l = VALID-HANDLE(_h_win).
      ASSIGN m_insert:SENSITIVE            = l 
             mi_insert_procedure:SENSITIVE = l
             mi_insert_function:SENSITIVE  = l.  
    END.    

  END.  /* IF window-check...*/
  
  /* Now do test for the current widgets. */
  IF widget-check THEN DO:
    /* Disable things if there is NO current widget - the "key" widget 
       here is the "Property" button.  If that is already set, then don't 
       worry about it. */
    l = VALID-HANDLE(_h_cur_widg).
    IF l NE _h_button_bar[9]:SENSITIVE THEN
      ASSIGN _h_button_bar[9]:SENSITIVE   = l  /* properties */
             /* Tools Menu Menu */
             mi_property_sheet:SENSITIVE = l WHEN VALID-HANDLE(mi_property_sheet).

    /* Disable things if there is NO current or selected widgets - the "key"
       here is the "Attribute" menu-item.  If that is already set, then don't 
       worry about it. */
    l = VALID-HANDLE(_h_cur_widg) OR CAN-FIND (FIRST _U WHERE _U._SELECTEDib).
    IF l ne mi_attributes:SENSITIVE THEN DO:
      ASSIGN mi_attributes:SENSITIVE    = l WHEN VALID-HANDLE(mi_attributes)
             mi_control_props:SENSITIVE = l WHEN VALID-HANDLE(mi_control_props).

      /* Only change the Color button and menu if we are in GUI mode. */
      IF _cur_win_type AND VALID-HANDLE(mi_color) THEN 
        ASSIGN _h_button_bar[10]:SENSITIVE = l AND _visual-obj   /* color */
               mi_color:SENSITIVE        = _h_button_bar[10]:SENSITIVE.
                                                          /* Tools Menu Menu */
    END.  /* If l ne mi_attributes:SENSITIVE */

    /* Disable things that imply a selected widget. */
    l = CAN-FIND (FIRST _U WHERE _U._SELECTEDib).
    IF AVAILABLE _P AND _P._TYPE BEGINS "WEB":U THEN DO:
      IF CAN-FIND(FIRST _U WHERE _U._SELECTEDib AND
                                 _U._TYPE = "FILL-IN":U) THEN l = FALSE.
      IF NOT CAN-FIND(FIRST _U WHERE _U._SELECTEDib) THEN
        ASSIGN MENU-ITEM mi_paste:SENSITIVE IN MENU m_edit = FALSE
               mi_export:SENSITIVE = FALSE
               mi_import:SENSITIVE = FALSE.
    END.

    IF l NE MENU-ITEM mi_copy:SENSITIVE IN MENU m_edit THEN DO:
      /* Note that PASTE and IMPORT depend on the existence of a place
         to put it, not whether anything is assigned. */
      ASSIGN MENU-ITEM mi_copy:SENSITIVE IN MENU m_edit = l
             mi_duplicate:SENSITIVE   = l WHEN VALID-HANDLE(mi_duplicate)
             mi_erase:SENSITIVE       = l WHEN VALID-HANDLE(mi_erase)
             mi_topmost:SENSITIVE     = l WHEN VALID-HANDLE(mi_topmost)
             mi_bottommost:SENSITIVE  = l WHEN VALID-HANDLE(mi_bottommost)
             m_align:SENSITIVE        = l WHEN VALID-HANDLE(m_align).
      IF VALID-HANDLE(mi_topmost) THEN DO:
        /* The four menu-items above mi_topmost (but not the 2 rules) must
           be set according to l                                            */
        ASSIGN menu_handle = mi_topmost:PREV-SIBLING
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l
               menu_handle = menu_handle:PREV-SIBLING
               menu_handle:SENSITIVE = l.
      END.
    END.
    
    /* Edit/Cut cannot be done for Alternate layouts. */
    IF l AND CAN-FIND (FIRST _U WHERE _U._SELECTEDib 
                          AND _U._LAYOUT-NAME ne "{&Master-Layout}":U)
    THEN l = false.

    IF l NE MENU-ITEM mi_cut:SENSITIVE IN MENU m_edit 
    THEN MENU-ITEM mi_cut:SENSITIVE    IN MENU m_edit = l. 

    /* OpenEdge IDE - Edit->Insert->Trigger */
    IF OEIDEIsRunning AND 
       VALID-HANDLE(m_insert) AND 
       VALID-HANDLE(mi_insert_trigger) AND
       VALID-HANDLE(mi_insert_procedure) AND
       VALID-HANDLE(mi_insert_function) THEN DO:
      l = FALSE.
      IF VALID-HANDLE(_h_cur_widg) THEN DO:
        FIND _U WHERE _U._HANDLE = _h_cur_widg NO-LOCK NO-ERROR.
        IF AVAILABLE _U THEN DO:
          l = _U._TYPE <> "TEXT":U AND _U._TYPE <> "SmartObject":U.
        END.      
      END.    
      ASSIGN m_insert:SENSITIVE          = l 
                                         OR mi_insert_procedure:SENSITIVE
                                         OR mi_insert_function:SENSITIVE
             mi_insert_trigger:SENSITIVE = l.  
    END.    

    /* Set Tab Edit menu item's sensitivity based upon whether    */
    /* a single frame is selected, or a dialog box is active, and */
    /* the master layout is active.                               */
    
    /* IZ 839 Changing _U reference to a local buffer has         */
    /* undesirable side effects. Leave direct _U reference as is. */

    l = false.
    FOR EACH _U WHERE  _U._STATUS <> "DELETED":U AND
                       _U._TYPE = "FRAME":U AND
                       _U._SELECTEDib = TRUE:
      frame_cnt = frame_cnt + 1.
    END.

    IF frame_cnt = 1 AND VALID-HANDLE(_h_win) THEN DO:
      FIND _U WHERE _U._HANDLE = _h_win.
      FIND _L WHERE RECID (_L) = _U._lo-recid.
      l = _L._LO-NAME = "Master Layout".
    END.
    ELSE IF CAN-FIND (FIRST _U WHERE _U._TYPE = "DIALOG-BOX":U AND 
                            _U._HANDLE = _h_win AND
                            _U._STATUS <> "DELETED":U) THEN l = TRUE.
    
    IF VALID-HANDLE(mi_tab_edit) THEN ASSIGN mi_tab_edit:SENSITIVE = l. 
    
  END.  /* IF widget-check...*/
  
  /* Disable menu options when running in the OpenEdge IDE */
  IF OEIDEIsRunning THEN
    MENU-ITEM mi_debugger:SENSITIVE  IN MENU m_compile = FALSE.
  
  /* jep-icf: Sensitize icf menubar if there is one. The menubar procedure uses the
     already set enable/disable states of the AB's default static menubar to enable/disable
     it's menubar. */
  IF VALID-HANDLE(_h_menubar_proc) THEN
    RUN sensitize_main_window IN _h_menubar_proc (INPUT pCheck).
  
END PROCEDURE. /* sensitize_main_window */


/* setBrowseRow
     When the user uses the mouse to change the height of a Browse Row, this
     gets called to store the change in the _C record.                       */
PROCEDURE setBrowseRow.
  FIND _U WHERE _U._HANDLE = SELF.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  ASSIGN _C._ROW-HEIGHT = SELF:ROW-HEIGHT.
  RUN adeuib/_winsave.p(_h_win, FALSE).         
END PROCEDURE. /* setBrowseRow */


/* setDataFieldEnable
     When drawing a data field for an object that is using a SmartData
     object, set the data field's Enable property based on the data object
     getUpdatableColumns. Must do this here since its not picked up automatically
     in the temp-table definition like format and label. Mainly used in a
     SmartObject that allows the drawing of SmartData field columns.
     jep-code 4/29/98 */
PROCEDURE setDataFieldEnable.

  DEFINE INPUT PARAMETER p-rec AS RECID  NO-UNDO.
  DEFINE VAR upd-fields       AS CHARACTER NO-UNDO.
  DEFINE VAR hSDO             AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQualFields AS LOGICAL    NO-UNDO.
  
  DEFINE BUFFER x_U            FOR _U.
  DEFINE BUFFER x_P            FOR _P.

  
  FIND x_P WHERE RECID(x_P) = p-rec.
  
  /* Get the handle of the SDO. */
  hSDO  = DYNAMIC-FUNCTION("get-sdo-hdl" IN _h_func_lib,
                                            x_P._data-object,THIS-PROCEDURE).
  IF NOT VALID-HANDLE(hSDO) THEN 
    RETURN.

  /* Get the comma-list of updatable colums from the data object. */
  upd-fields = DYNAMIC-FUNCTION("getUpdatableColumns":U IN hSDO).
  lQualfields = INDEX(upd-fields,'.') > 0.
  /* Go through all SmartViewer fields that are not in the updatable list and set
     enable attribute to no. */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE = _h_win
                 AND x_U._DBNAME = "Temp-Tables":U:
    IF LOOKUP((IF lQualFields THEN x_U._TABLE + '.':U ELSE '') + x_U._NAME,upd-fields
              ) = 0 THEN 
       x_U._ENABLE = NO.
    IF _DynamicsIsRunning = TRUE 
    AND DYNAMIC-FUNCTION("ClassIsA":U IN gshRepositoryManager,
                         x_P.OBJECT_type_code,"DynView":U) THEN
    DO:
      IF NOT VALID-HANDLE(X_U._HANDLE:POPUP-MENU) THEN
        RUN createDataFieldPopup IN _h_uib (x_U._HANDLE).
    END.  /* If working with a dynamic viewer */
  END.
  DYNAMIC-FUNCTION("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).
END.


/* setdeselection is a procedure to set the universal widget record to be    */
/*           deselectioned each time that a widget becomes deselected.       */
PROCEDURE setdeselection.
  DEFINE BUFFER ipU FOR _U.

  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setdeselection"). &ENDIF
  FIND _U WHERE _U._HANDLE = SELF.
  ASSIGN _U._SELECTEDib = FALSE.
  IF _U._TYPE eq "FRAME":U THEN DO:   
    FIND _C WHERE RECID(_C) = _U._x-recid.
    IF NOT _C._SIDE-LABELS THEN 
      _C._FRAME-BAR:WIDTH-P = SELF:WIDTH-P -
                              (SELF:BORDER-LEFT-P + SELF:BORDER-RIGHT-P).
  END.
  /* Current widget must be selected */
  IF SELF EQ _h_cur_widg THEN DO:
    /* Is there another widget selected with the same parent? */
    FIND FIRST ipU WHERE ipU._SELECTEDib AND ipU._PARENT EQ _U._PARENT AND 
         ipU._HANDLE NE ? NO-ERROR.
    /* Is there another widget selected at all? */
    IF NOT AVAILABLE ipU
    THEN FIND FIRST ipU WHERE ipU._SELECTEDib 
                          AND ipU._STATUS ne "DELETED":U NO-ERROR.
    /* At least select the current window (unless it is a Design Window, in which
       case, look for a frame. */
    IF NOT AVAILABLE ipU 
    THEN FIND ipU WHERE ipU._HANDLE = _U._WINDOW-HANDLE NO-ERROR.
    /* Don't select a design window. */
    IF AVAILABLE ipU AND ipU._SUBTYPE eq "Design-Window":U 
    THEN FIND FIRST ipU WHERE ipU._TYPE eq "FRAME":U 
                          AND ipU._STATUS ne "DELETED":U
                          AND ipU._parent eq _U._WINDOW-HANDLE 
                        NO-ERROR.
    /* Set the current widget to the new ipU. */
    IF AVAILABLE ipU THEN DO:
       RUN curframe (ipU._HANDLE).
      _h_cur_widg = ipU._HANDLE.
    END.
    ELSE ASSIGN _h_cur_widg = ?.  
    RUN display_current.
  END. /* Deselecting the current widget. */
  ELSE DO:
    /* If there is now only one widget selected, then display it. */  
    FIND FIRST _U WHERE _U._SELECTEDib NO-ERROR.
    IF AVAILABLE _U AND 
       NOT CAN-FIND(FIRST ipU WHERE ipU._SELECTEDib 
                                AND ipU._HANDLE ne _U._HANDLE)
    THEN RUN changewidg (_U._HANDLE, false).
  END.
END.  /* PROCEDURE setdeselection */

/* setselect is a procedure to set the universal widget record to be         */
/*         selected each time that a widget becomes selected.  Note that     */
/*         we don't select widgets when the pointer is not selected          */
PROCEDURE setselect.
  &IF {&dbgmsg_lvl} > 0 &THEN RUN msg_watch("setselect"). &ENDIF
  DEFINE BUFFER f_U      FOR _U.
  DEFINE BUFFER ipU      FOR _U.
  DEFINE BUFFER f_L      FOR _L.
  DEFINE BUFFER linked_U FOR _U.
  DEFINE VAR    h_linked AS WIDGET NO-UNDO.
  DEFINE VAR    s        AS INTEGER NO-UNDO.    
  DEFINE VAR    utype    AS CHAR NO-UNDO.

  /* Select the current widget */
  FIND _U WHERE _U._HANDLE = SELF NO-ERROR.
  IF NOT AVAILABLE _U THEN RUN adeuib/_sanitiz.p.
  ELSE DO:    
    utype = _U._TYPE.
    /* Check the down frame iteration and display. */
    IF _U._TYPE eq "FRAME" THEN DO:
      FIND _C WHERE RECID(_C) = _U._x-recid.
      IF NOT _C._SIDE-LABELS THEN _C._FRAME-BAR:WIDTH-P = 1.
    END.  
    ELSE IF _U._PARENT:TYPE ne "WINDOW":U THEN DO:  
      /* Its not a frame, and its parent is not a window.   i.e. its
         parent is a frame, so check the iteration. */
      FIND f_U WHERE RECID(f_U) eq _U._parent-recid.
      FIND _C WHERE RECID(_C) eq f_U._x-recid.
      FIND f_L WHERE RECID(f_L) eq f_U._lo-recid.
      IF NOT f_L._NO-LABELS AND NOT _C._SIDE-LABELS  /* If column labels          */
      THEN RUN adeuib/_chkpos.p (INPUT SELF).        /* Check iteration & header  */
    END.
    IF VALID-HANDLE(mi_color) THEN DO:   
      IF utype = "IMAGE":U THEN
        /* Turn off color button if the current widget is an image */
        ASSIGN _h_button_bar[10]:SENSITIVE = FALSE
               mi_color:SENSITIVE        = FALSE.
      ELSE IF _cur_win_type AND _visual-obj THEN
        ASSIGN _h_button_bar[10]:SENSITIVE = TRUE
               mi_color:SENSITIVE        = TRUE.
    END.
            
    /* Mark the widget selected */
    _U._SELECTEDib = TRUE.
    /* If we are in the middle of BOX-SELECTION then don't update the screen. */
    IF NOT box-selecting THEN DO:
 
      /* Is there anything selected in any other window? If so, deselect it. */     
      IF CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                               AND ipU._WINDOW-HANDLE ne _U._WINDOW-HANDLE) 
      THEN RUN deselect_all (SELF, _U._WINDOW-HANDLE).
      
      /* Make this the current widget if the current widget is not also selected.*/
      IF NOT CAN-FIND (FIRST ipU WHERE ipU._SELECTEDib
                                   AND ipU._HANDLE ne SELF) 
      THEN DO:
        IF NOT ((CAN-QUERY(_h_cur_widg,"SELECTED") EQ yes) AND _h_cur_widg:SELECTED)
        THEN RUN curwidg.     
      END.
      ELSE DO:  
        /* If there is more than one widget selected then there is no current
           widget.  Make sure that that is displayed.  Display-current will
           show-attributes.  However, if we don't call display-current, then
           call show-attributes directly so that we can update the display
           for the multiple selection. */
        _h_cur_widg = ?.
        IF h_display_widg ne _h_cur_widg 
        THEN RUN display_current.     
        ELSE DO:
          /* Show the current values of the selected set of widgets in the 
             Attributes window. */
          IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
          THEN RUN show-attributes IN hAttrEd NO-ERROR.

           /* Show the current values in the dynamic attribute window */
          IF VALID-HANDLE(_h_menubar_proc) THEN
             RUN Display_PropSheet IN _h_menubar_proc (YES) NO-ERROR.

          RUN show_control_properties (INPUT 0).
        END.
      END.     
    END.
  END.
END.  /* PROCEDURE setselect */

/* setstatus sets the WAIT cursor and writes a message to the status line.   */
/*           This is really just a front end to adeuib/_setcurs.p that also  */
/*           sets the status line.                                           */
PROCEDURE setstatus:
  DEFINE INPUT PARAMETER pcCursor AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER pcStatus AS CHAR NO-UNDO.  
  
  /* Set the cursor (if not unknown) */
  IF pcCursor ne ? THEN 
    RUN adecomm/_setcurs.p (pcCursor). 
  
  /* Set the status message (if not unknown) */
  IF pcStatus ne ? THEN 
    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Main}, pcStatus).

END PROCEDURE. /* setstatus */

/* setxy saves the current value of X and Y within a frame when          */
/*       the user clicks down (i.e. she is starting to draw a widget.)   */
PROCEDURE setxy:
  DEFINE VARIABLE utype AS CHAR NO-UNDO.
  
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setxy"). &ENDIF

  /* See where the user clicked and record this as the start of a draw.  */
  /* (if we are drawing)              */
  IF _next_draw eq  ? THEN ASSIGN _frmx = ?
                                  _frmy = ?.
  ELSE DO:
    /* Find the current object */
    FIND _U WHERE _U._HANDLE eq SELF.
    utype = _U._TYPE.
  
    /* Set the current frame/window context [and make curwidg unknown]. */
    RUN curframe (_U._HANDLE).

    ASSIGN  _frmx            = LAST-EVENT:X
            _frmy            = LAST-EVENT:Y
            _second_corner_x = ?
            _second_corner_y = ? .

    /* _frmx and _frmy need to be adjusted for non-resizable targets */
    IF utype = "SmartObject":U AND NOT SELF:RESIZABLE THEN
      ASSIGN _frmx = _frmx + SELF:X
             _frmy = _frmy + SELF:Y.
  END.
END.  /* PROCEDURE setxy */

/* setxy_lbl is only slightly similar to setuxy. It applies the lastkey */
/*           to the related fill-in (hopefully).                        */
PROCEDURE setxy_lbl.
  DEFINE BUFFER ipU for _U.
  &IF {&dbgmsg_lvl} > 0 &THEN run msg_watch("setxy_lbl"). &ENDIF
  FIND _U WHERE _U._HANDLE = SELF.
  FIND ipU WHERE RECID(ipU) = _U._l-recid.

  APPLY LASTKEY TO ipU._HANDLE.
END.  /* PROCEDURE setxy_lbl */

/*
 * show-control-properties  Display the OCX property window
 */
PROCEDURE show_control_properties:

DEFINE INPUT PARAM p_Mode AS INTEGER NO-UNDO.

DEFINE VARIABLE multControls AS INTEGER     NO-UNDO INITIAL 0.
DEFINE VARIABLE s            AS INTEGER     NO-UNDO.
DEFINE VARIABLE windowList   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE windowActive AS CHARACTER   NO-UNDO.
DEFINE VARIABLE chFrame      AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE hdlCtl       AS COM-HANDLE  NO-UNDO.
DEFINE VARIABLE hdlColl      AS COM-HANDLE  NO-UNDO.

DEFINE BUFFER   x_U FOR _U.
DEFINE BUFFER   y_U FOR _U.

  IF NOT VALID-HANDLE(_h_Controls) THEN RETURN.

  IF (p_Mode = 2 OR p_Mode = 3) THEN
  DO:
    /* p_Mode of 2 is Hide property editor window for Run or Tools menu call. */
    IF (p_Mode = 2) THEN
    DO:
      ASSIGN PropEditorVisible = _h_Controls:PropertyEditorVisible.
      ASSIGN _h_Controls:PropertyEditorVisible = No.
      RETURN.
    END.
    /* p_Mode of 3 is Show property editor window after Run or Tools menu call. */
    IF (p_Mode = 3) THEN
    DO:
      ASSIGN _h_Controls:PropertyEditorVisible = PropEditorVisible.
      /* Return now because display_current calls this proc already
         from enable_widgets. */
      RETURN. 
    END.
  END.
    
  /* If there are no open windows then close the property editor. This is
   * needed to take down the property editor when the last window is closed.
   */
  RUN WinMenuGetActive(OUTPUT windowList, OUTPUT windowActive).
  IF LENGTH(windowList) = 0 THEN
  DO:
    /* Hide OCX Property Editor window. */
    _h_Controls:PropertyEditorVisible = No.
    RETURN.
  END.

  /* Figure out if 0, 1, or 2+ things are selected. The property editor
   * doesn't work with group edit.
   */
  FIND FIRST x_U WHERE x_U._TYPE = "{&WT-CONTROL}"
                   AND (    x_U._HANDLE = _h_cur_widg 
                        AND x_U._STATUS <> "DELETED":u)
                 NO-ERROR.
  IF AVAILABLE x_U THEN
  DO:
    /* There's at least one thing selected. But is there only one? */ 
    IF NOT CAN-FIND(FIRST y_U
                    WHERE y_U._SELECTEDib AND RECID(y_U) ne RECID(x_U))
    THEN multControls = 1.
    ELSE multControls = 2.
  END.
  
  IF multControls = 0 OR multControls = 2 THEN
  DO:
    /* Clear Property Editor window. */
    _h_Controls:ClearProperties.
    /* Show Property Editor window if mode calls for it. */
    IF p_mode = 1 THEN _h_Controls:PropertyEditorVisible = Yes.
  END.
  ELSE
  DO:
    /* Set window to edit current control. */
    chFrame = x_U._COM-HANDLE.    
    hdlColl = chFrame:Controls.
    hdlCtl  = hdlColl:Item(1) NO-ERROR. /* NO-ERROR in case control was not created. */
    RELEASE OBJECT hdlColl.
    _h_Controls:EditProperties(hdlCtl) NO-ERROR.
    /* Show Property Editor window if mode calls for it. */
    IF p_mode = 1 THEN _h_Controls:PropertyEditorVisible = Yes.
  END.    

END PROCEDURE.

/* switch_palette_menu: Toggles menu-only mode in the object palette */
PROCEDURE switch_palette_menu: /* by GFS 2/95 */
  DEFINE INPUT PARAMETER setting AS LOGICAL.
  
  DEFINE VARIABLE h  AS WIDGET-HANDLE.

  ASSIGN _h_object_win:HIDDEN = yes           /* hide palette window */
         h                    = _h_object_win /* get palette window */
         h                    = h:FIRST-CHILD /* 1st frame */
         _palette_menu        = setting.
  DO WHILE h <> ?:
    IF setting THEN h:HIDDEN = yes. ELSE h:HIDDEN = no.
    h = h:NEXT-SIBLING. /* next frame */
  END.
  IF setting THEN 
    ASSIGN _h_object_win:WIDTH-PIXELS = {&ImageSize} + {&ImageSize} * 2
           _h_object_win:MAX-WIDTH-P  = _h_object_win:WIDTH-P
    .
  ELSE 
    ASSIGN _h_object_win:MAX-WIDTH-PIXELS  = MIN((_palette_count * {&ImageSize}),SESSION:WIDTH-P)
    .
  RUN adeuib/_rsz_wp.p (INPUT no). /* resize palette window */
END.

procedure isCurrentWindowDynamic:
    define output parameter plDynamic   as logical no-undo.
    define output parameter plNative    as logical no-undo.
    define variable ldummy as logical no-undo.
    define variable cdummy as character no-undo.
    run getCurrentWindowInfo(output cdummy,output ldummy,output ldummy, output plDynamic, output plNative ).
end.

procedure getCurrentWindowInfo:
    define output parameter pcFilename  as char no-undo.
    define output parameter plSaved     as logical no-undo.
    define output parameter plRepos     as logical no-undo.
    define output parameter plDynamic   as logical no-undo.
    define output parameter plNative    as logical no-undo.
    
    define buffer b_P for _P. 
    find b_P where b_P._WINDOW-HANDLE = _h_win no-error.
    if available(b_P) then 
    do:
        assign
            plSaved = b_p._save-as-file <> ? /* did not work- b_p._file-saved */
            pcfilename = b_p._save-as-file.
        if _DynamicsIsRunning then
        do:
            plDynamic =  not b_P.static_object. 
            plNative = DYNAMIC-FUNCTION("isDynamicClassNative":U IN _h_func_lib,_P.object_type_code).
            plRepos =  b_p.design_ryobject .
        end.
        /* else all params are false */
    end.
    else 
        assign plDynamic = ? 
               plNative = ? 
               plSaved = ?.
end.

procedure getCurrentWindowTitle:
    define output parameter pcTitle as char no-undo.
    define variable locHand as handle no-undo.
    if _h_win:type = "FRAME" then
       pctitle = _h_win:parent:title.
    else    
       pctitle = _h_win:title.
    
end.


PROCEDURE startDynPropSheet:
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  IF AVAILABLE(_P) AND (NOT _P.static_object) 
  AND LOOKUP("DynView":U,_P.parent_classes)= 0
  AND LOOKUP("DynSDO":U,_P.parent_classes) = 0
  AND LOOKUP("DynDataView":U,_P.parent_classes) = 0
  AND LOOKUP("Dynbrow":U,_P.parent_classes)= 0   THEN
    RUN choose_prop_sheet IN _h_UIB.
  
END.

PROCEDURE tapit.
  DEFINE BUFFER parent_U                FOR _U.
  DEFINE BUFFER parent_L                FOR _L.
  DEFINE BUFFER sync_L                  FOR _L.
  DEFINE VAR    recid-string            AS CHARACTER NO-UNDO.
  DEFINE VAR    x-increment             AS INTEGER   NO-UNDO.
  DEFINE VAR    y-increment             AS INTEGER   NO-UNDO.
  DEFINE VAR    h                       AS WIDGET    NO-UNDO.
  DEFINE VAR    h_parent                AS WIDGET    NO-UNDO.
  DEFINE VAR    tmp_x                   AS INTEGER   NO-UNDO.
  DEFINE VAR    tmp_y                   AS INTEGER   NO-UNDO.
  DEFINE VAR    other_action_taken      AS LOGICAL   NO-UNDO.
  DEFINE VAR    num_undoable_widgets    AS INTEGER   NO-UNDO.
  DEFINE VAR    max-height              AS INTEGER   NO-UNDO.
  DEFINE VAR    max-width               AS INTEGER   NO-UNDO.

  CASE LAST-EVENT:FUNCTION:
    WHEN "CURSOR-LEFT":U  THEN ASSIGN x-increment = -1.
    WHEN "CURSOR-RIGHT":U THEN ASSIGN x-increment =  1.
    WHEN "CURSOR-DOWN":U  THEN ASSIGN y-increment =  1.
    WHEN "CURSOR-UP":U    THEN ASSIGN y-increment = -1.
  END CASE.

  /* The following FOR EACH block checks if any of the selected widgets
     will be moved outside of the parent. It also builds a comma-separated
     list of recids of the selected widgets, which is used to see if we need
     to create a new sequence of undoable widgets.                             */
  FOR EACH _U WHERE _U._SELECTEDib AND
                    _U._STATUS <> "DELETED":
    FIND parent_U WHERE RECID(parent_U) = _U._parent-recid.
    FIND parent_L WHERE RECID(parent_L) = parent_U._lo-recid.

    ASSIGN h_parent   = parent_U._HANDLE
           h          = _U._HANDLE
           tmp_y      = h:Y + y-increment
           tmp_x      = h:X + x-increment
           max-width  = IF parent_U._TYPE = "FRAME" OR
                           parent_U._TYPE = "DIALOG-BOX" THEN
                          h_parent:WIDTH-PIXELS - 
                          (h_parent:BORDER-LEFT-PIXELS +
                           h_parent:BORDER-RIGHT-PIXELS)
                        ELSE
                          h_parent:WIDTH-PIXELS

           max-height = IF parent_U._TYPE = "FRAME" OR
                           parent_U._TYPE = "DIALOG-BOX" THEN
                          h_parent:HEIGHT-PIXELS - 
                          (h_parent:BORDER-TOP-PIXELS +
                           h_parent:BORDER-BOTTOM-PIXELS)
                        ELSE
                          h_parent:HEIGHT-PIXELS.
        
    IF tmp_y < 0 OR tmp_x < 0 OR
       (tmp_y + h:HEIGHT-P - 1 > max-height)   OR
       (tmp_x + h:WIDTH-P  - 1 > max-width) THEN  RETURN.

    ASSIGN recid-string = recid-string + STRING(RECID(_U)) + ",":U.  
  END.  /* For each selected object */
  recid-string = RIGHT-TRIM(recid-string, ",":U).

  /* Determine if other undoable actions (like Move, Resize or selecting
     another or different widgets) have been done since the last time; assume
     that another action has been taken.                                             */
  ASSIGN other_action_taken = TRUE.
  FIND LAST _action NO-ERROR.
  IF AVAILABLE _action THEN DO:

    IF _action._operation = "EndTapIt":U THEN
    test-tapit:
    DO:
      ASSIGN num_undoable_widgets = _action._seq-num - INT(_action._data) - 1.
      /* When this record was created we stored the starting sequence number
         in _action._data */
      
      IF NUM-ENTRIES(recid-string) = num_undoable_widgets THEN DO:
        /* This could be a continuation as at least the number of widgets is the same */
        LOOKING-FOR-START:
        DO WHILE TRUE:
          FIND PREV _action NO-ERROR.
          IF _action._operation = "StartTapIt" THEN LEAVE LOOKING-FOR-START.
          
          /* Compare the recid of the selected widgets in the previous undo
             sequence with the currently selected widgets. If there is a
             difference we want to create a new sequence in the undo stack;
             so leave test-tapit and 'other_action_taken' will be true
          */
          IF STRING(_action._u-recid) <>
             ENTRY(num_undoable_widgets, recid-string) THEN
            LEAVE test-tapit.  /* Not a match, must be a new series of TapIts */
          
          ASSIGN num_undoable_widgets = num_undoable_widgets - 1.
        END.  /* LOOKING-FOR-START: Do While True */
        
        /*  Have found the "StartTapIt" and it looks like this action is a 
            continuation of the same series                                 */
        ASSIGN other_action_taken = FALSE.
      END.  /* If num_undoable_widgets = NUM-ENTRIES */
    END.  /* test-tapit: DO: */
  END.  /* If available _action */

  /* At this point we are starting a new tapit series if other_action_taken is TRUE,
     or continuing an existing series if other_action_taken is FALSE.  If continuing
     then nothing needs to be done to the undo stack.  If starting then we need to
     create a StartTapIt record, followed by the positions of each selected object,
     followed by and EndTapIt record                                                */

  IF other_action_taken THEN DO:
    /* Create the initial StartTapIt record */
    CREATE _action.
    ASSIGN _undo-start-seq-num  = _undo-seq-num
           _action._seq-num     = _undo-seq-num
           _action._operation   = "StartTapIt"
           _undo-seq-num        = _undo-seq-num + 1
           num_undoable_widgets = 0.
  
    /* For each selected object, save its current position in a "TapIt" Record */
    FOR EACH _U WHERE _U._SELECTEDib AND
                      _U._STATUS <> "DELETED":
      /* For this widget, get a list of alternate layout _L's that are in sync
         with it because they need to be moved too!                            */
      FIND _L WHERE RECID(_L) = _U._lo-recid.
      recid-string = "".
      IF _L._LO-NAME = "Master Layout" THEN DO:
        FOR EACH sync_L WHERE sync_L._u-recid  = _L._u-recid AND
                              sync_L._LO-NAME NE _L._LO-NAME AND
                              NOT sync_L._CUSTOM-POSITION:
          recid-string = recid-string + STRING(RECID(sync_L)) + ",".
        END.
      END.  /* If changing the Master Layout */
      ELSE _L._CUSTOM-POSITION = TRUE.

      /* Now create the Undo record for this widget */
      CREATE _action.
      ASSIGN _action._seq-num       = _undo-seq-num
             _action._operation     = "TapIt"
             _action._u-recid       = RECID(_U)
             _action._window-handle = _U._WINDOW-HANDLE
             _action._data          = STRING(_L._COL) + "|":U + STRING(_L._ROW)
             _action._other_Ls      = RIGHT-TRIM(recid-string,",")
             num_undoable_widgets   = num_undoable_widgets + 1
             _undo-seq-num          = _undo-seq-num + 1.

    END.  /* For each selected goodie */

    /* Now that the original positions have been saved, create the "EndTapIt" record */
    CREATE _action.
    ASSIGN _action._seq-num    = _undo-seq-num
           _action._operation  = "EndTapit"
           _undo-seq-num       = _undo-seq-num + 1
           _action._data       = STRING(_undo-start-seq-num)
           _undo-start-seq-num = ?.
    RUN UpdateUndoMenu("&Undo Tapit").
  END. /* If other_action_taken */

  /* Now just wiggle the widgets */  
  FOR EACH _U WHERE _U._SELECTEDib AND
                    _U._STATUS <> "DELETED":
    FIND _L WHERE RECID(_L) = _U._lo-recid.
    ASSIGN h       = _U._HANDLE
           h:Y     = h:Y + y-increment
           h:X     = h:X + x-increment
           _L._ROW = ((h:ROW - 1) / _cur_row_mult) + 1
           _L._COL = ((h:COL - 1) / _cur_col_mult) + 1.

    /* Adjusts for TTY Frames, and takes care of storing integer values for TTY. 
     Will overwrite the above assigned values when it needs to. */
    { adeuib/ttysnap.i &hSELF   = _U._HANDLE
                       &hPARENT = parent_U._HANDLE
                       &U_Type  = _U._TYPE
                       &Mode    = "MOVE"
                       }

    /* Move a fill-in's label */
    IF CAN-DO("FILL-IN,COMBO-BOX,EDITOR,SELECTION-LIST,RADIO-SET,SLIDER":U,_U._TYPE) THEN DO:
      RUN adeuib/_showlbl.p (_U._HANDLE).
      _U._HANDLE:SELECTED = TRUE.
    END. /* For fill-ins and combos */

    /* If a SmartObject has been moved, use the set-position method to
       try and move it. */
    IF _U._TYPE = "SmartObject":U THEN DO:
      FIND _S WHERE RECID(_S) = _U._x-recid.
      IF _S._visual THEN DO:
        FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
        IF _P._adm-version < "ADM2" THEN
          RUN set-position IN _S._HANDLE (_L._ROW, _L._COL) NO-ERROR.
        ELSE
          RUN repositionObject IN _S._HANDLE (_L._ROW, _L._COL) NO-ERROR.        
      END.  /* IF _S._VISUAL */
    END.  /* If a SmartObject */

    /* Update the Geometry in the Attribute Window, if necessary. */
    IF VALID-HANDLE(hAttrEd) AND hAttrEd:FILE-NAME eq "{&AttrEd}"
    THEN RUN show-geometry IN hAttrEd NO-ERROR.

     /* Update the Dynamic Property Sheet */
  IF VALID-HANDLE(_h_menubar_proc) THEN
     RUN Prop_ChangeGeometry IN _h_menubar_proc (_U._HANDLE) NO-ERROR.

  END.  /* For each selected object */

  ASSIGN _undo-num-objects  = ?.

  /* The move operation is complete, now update the file-saved field */
  RUN adeuib/_winsave.p(_h_win, FALSE).
    
END. /* PROCEDURE tapit */


/* Message to tell users they can't manipulate test in alternative layouts */
PROCEDURE text_message.
  /* Text widgets are not changeable in an alternative layout */
  if OEIDEIsRunning then
     ShowMessageInIDE("Text objects may only be modified in the Master Layout. ~n
                      Use a fill-in with the VIEW-AS-TEXT attribute instead." 
                      ,"Warning",?,"OK",yes).
  else
  MESSAGE "Text objects may only be modified in the Master Layout." SKIP
          "Use a fill-in with the VIEW-AS-TEXT attribute instead."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* tool_choose - Select a tool (_next_draw).  Change the status bar to show
   the current tool and hide the up image associated with it. 
   
   cType = 0 if from palette
           1 if from palette menu or toolbar menu
           2 <future> tool bar menu
           3 other source
   
   tool  = The name of the palette tool to use. 
           ? if want to force another tool choose
           of the last tool.*/
             
procedure tool_choose:
  DEFINE INPUT PARAMETER cType  AS INTEGER                          NO-UNDO.
  DEFINE INPUT PARAMETER tool   AS CHAR                             NO-UNDO. 
  DEFINE INPUT PARAMETER custom AS CHAR                             NO-UNDO. 
 
  DEFINE VARIABLE cancelled      AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE cStatus_line   AS CHARACTER                       NO-UNDO. 
  DEFINE VARIABLE customTool     AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE filechosen     AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE ParentHWND     AS INTEGER                         NO-UNDO.
  DEFINE VARIABLE parse          AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE sameCustom     AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE sameTool       AS LOGICAL                         NO-UNDO.
  DEFINE VARIABLE saveCustom     AS RECID                           NO-UNDO.
  DEFINE VARIABLE saveCustomDraw AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE saveItem       AS RECID                           NO-UNDO.
  DEFINE VARIABLE saveNextDraw   AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE toolframe      AS WIDGET-HANDLE                   NO-UNDO.
  DEFINE VARIABLE unused         AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE tmpString      AS CHARACTER                       NO-UNDO.
  DEFINE VARIABLE cFullPath      AS CHARACTER                       NO-UNDO.
  
  /*
   * The "rules" for tool choosing and locking:
   *
   *  1. Choosing the POINTER will set all flags and
   *     variables to ?
   *  2. Choosing a tool or custom different than the current
   *     object will change state to that tool or custom
   *     and the click_cnt set to 1
   *  3. Choosing the same tool will lock the tool in
   *     whatever was chosen in the previous click
   *  4. Choosing the same tool  again will unlock
   *     the tool.
   *  5. When the user clicks "too many" times on the same
   *     tool or custom the UIB will inform the user to
   *     "cut it out."
   *  6. If the user cancels out of any picker dialog box, 
   *     under any circumsance, the UIB will go to the POINTER
   *  7. Any custom item that forces a picker to be displayed
   *     breaks any lock
   *
   *  In effect the odd numbered clicks unlock the tool and
   *  bring up pickers / choose defaults. Even clicks lock
   *  the tool on the last pick.
   */
   
  /*
   * Don't set the watch cursor for all items, only those that
   * bring up a dialog box.
   */
   
    IF tool = "POINTER":U THEN 
    DO:
        RUN choose-pointer.
        RETURN.
    END.

    /* Don't let people draw on a dynamic browse */
    IF _DynamicsIsRunning AND AVAILABLE _P THEN 
    DO:
        IF LOOKUP(_P.OBJECT_type_code,
              DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager,
                                                  INPUT "DynBrow":U)) <> 0 THEN 
        DO:
            RUN choose-pointer.
            RETURN.
        END.
    END.
    /*
    * Force this tool choose to run like the
    * previous call
    */

    /*message "tool" tool skip
              "custom" custom skip
              "ctype" cType skip
                view-as alert-box. */
    IF (tool = ?) AND (cType = 3) THEN 
    DO:
  
        FIND _palette_item WHERE RECID(_palette_item) = _palette_choice NO-ERROR.
        IF AVAILABLE (_palette_item) THEN 
            ASSIGN tool = _palette_item._name.
        ELSE 
            RETURN.
    END. 
    /*
     * In case the user first comes in through the
     * "other path" before any tool is chosen.
     */
    IF tool = ? THEN 
        RETURN.
    
    ASSIGN
        customTool       = custom
        saveItem         = _palette_choice
        saveCustom       = _palette_custom_choice
        widget_click_cnt = widget_click_cnt + 1
        goBack2pntr      = YES
        saveNextDraw     = _next_draw
        saveCustomDraw   = _custom_draw
      .
     
    FIND _palette_item WHERE _palette_item._name = tool.
    _palette_choice = recid(_palette_item).
  
    FIND _custom WHERE _custom._name = custom 
                   AND   _custom._type = tool no-error.
  
    IF AVAILABLE _custom THEN 
    DO:
        ASSIGN
            _palette_custom_choice = recid(_custom)
            parse = TRIM(_custom._ATTR)
            .
            /*message "   CUSTOM REC" skip
                "tool     " tool skip
                "custom   " custom skip
                "base type" _custom._type skip
                         view-as alert-box.  */

    END.
    ELSE DO:
        ASSIGN
            _palette_custom_choice = ?
            parse = TRIM(_palette_item._ATTR)
            .
         
     /*    message "NO CUSTOM REC" skip
                    "tool     " tool skip
                    "custom   " custom skip
                    "cType    " cType skip
                    "parse    " parse skip
                view-as alert-box. */
    END.                
    /* If the click count is 1 then the user
     * moved off the POINTER.
     */

    IF widget_click_cnt > 1 THEN 
    DO:
        ASSIGN
            sameTool = (saveItem = _palette_choice)
            sameCustom = (saveCustom = _palette_custom_choice)
            .
        IF sameTool THEN 
        DO:
            /*
            * The user is working in the same tool.
            */
            IF (cType = 0) THEN 
            DO:
             /*
              * The tool_choose came from a palette icon
              * Lock/unlock the palette icon
              */
                RUN tool_lock (saveNextdraw, saveCustomdraw).
                IF ((widget_click_cnt modulo 2) = 0) THEN 
                    RETURN.
                IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN 
                    RETURN.
         
            END.
            ELSE IF cType = 3 THEN 
            DO:
                /*
                 * The tool_choose came from an outside source
                 * (the lock status area is one case). Perform
                 * the same operations as if cType = 0 
                 */
                RUN tool_lock (saveNextdraw, saveCustomdraw).
                IF ((widget_click_cnt modulo 2) = 0) THEN 
                    RETURN.
                 /*
                  * We've just unlocked.If we're working with a picker
                  * then don't bring it up in this case
                  */
                IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN 
                    RETURN.
            END. /* cType = 3 */
            ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN 
            DO:
                 /*
                  * The tool_choose came from a menu and the custom
                  * item is a picker. Break the lock.
                  */
                 widget_click_cnt = 1.
                 RUN tool_lock (saveNextdraw, saveCustomdraw). 
            END.
            ELSE IF sameCustom THEN 
            DO:
                /*
                 * The exact same tool and custom was picked
                 * twice in row. Force the lock.
                 */
                widget_click_cnt = 2.          
                RUN tool_lock (saveNextdraw, saveCustomdraw).
                RETURN.
            END.
            ELSE
                ASSIGN 
                    goBack2pntr      = YES
                    widget_click_cnt = 1
                    .
    
        END. /* if sametool */
        ELSE
            ASSIGN 
                goBack2pntr      = YES
                widget_click_cnt = 1
                .
    END. /* IF widget_click_cnt > 1  */
          
    /* Special cases - Browses or dbFields with no connected databases */
    IF _palette_item._dbconnect AND NUM-DBS = 0 THEN 
    DO:
        /* If we find the term 'object' anywhere in the palette item name,
           don't bother adding the 'object' part to the message we'll give
           the customer. Keeps from displaying something like
           'create a SmartObject object.' - jep */
        IF INDEX(_palette_item._name, 'object':U) = 0 THEN
            tmpString = " object.".
        ELSE
            tmpString = ".".
        
        RUN adecomm/_dbcnnct.p (INPUT "You must have at least one connected database to " 
                                + (IF _palette_item._name = "DB-FIELDS" THEN "add database fields."
                                   ELSE "create a " + _palette_item._name + tmpString),
                                OUTPUT ldummy).
        IF ldummy eq no THEN 
        DO:
            RUN choose-pointer.
            RETURN.
        END.
    END.
  
    /* If tool is text and not master layout give message and return */
    IF tool = "TEXT":U THEN 
    DO:
        FIND _U WHERE _U._HANDLE = _h_win NO-ERROR.
        IF AVAILABLE _U THEN 
        DO:
            IF _U._LAYOUT-NAME NE "Master Layout" THEN 
            DO:
                if OEIDEIsRunning then
                    ShowMessageInIDE("Text objects may only be drawn in the Master Layout. ~n
                                     Use a fill-in with the VIEW-AS-TEXT attribute instead.",
                                     "Warning",?,"OK",yes).
                else
                MESSAGE "Text objects may only be drawn in the Master Layout." SKIP
                "Use a fill-in with the VIEW-AS-TEXT attribute instead."
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                RETURN.
            END.
        END.
    END.

    /* Now see if we have a pointer or other tool */
    DO WITH FRAME widget_icons:
  
        /* Which palette entry corresponds to this tool */
        FIND _palette_item WHERE _palette_item._NAME = tool NO-ERROR.
        
        /* "Restore" the old choice to its "up" state */
        IF hDrawTool NE ? AND hDrawTool:PRIVATE-DATA NE tool THEN 
            hDrawTool:HIDDEN    = NO.
    
        IF h_lock NE ? THEN h_lock:HIDDEN       = YES.
    
        ASSIGN toolframe         = hDrawTool:FRAME
               toolframe:BGCOLOR = ?.
 
         /* "Depress" the new choice widget tool by hiding it. */
        ASSIGN
            hDrawTool   = _h_up_image
            h_lock      = WIDGET-HANDLE(ENTRY(2,_h_up_image:PRIVATE-DATA)).
    
        IF NOT hDrawTool:HIDDEN THEN 
            hDrawTool:HIDDEN = YES. 
        IF NOT h_lock:HIDDEN THEN 
            h_lock:HIDDEN = YES.
    
        ASSIGN toolframe         = hDrawTool:FRAME
               toolframe:BGCOLOR = 7.
      
         /* For SmartObjects, the user could have chosen "NEW" or cancel from
          * a "CHOOSE", in which case we don't want to do anything  */
        IF _palette_item._TYPE <> {&P-BASIC} THEN 
        DO: /* custom icon, SmartObject or OCX control*/
            IF custom eq "NEW" THEN 
            DO:
                IF _palette_item._New_Template <> "" THEN 
                DO: 
                    FILE-INFO:FILE-NAME = _palette_item._New_Template.
                    cFullPath = FILE-INFO:FULL-PATHNAME.
                    /* IF object will be registered in dynamics, we need to set the object 
                        information. This will only work for static objects */
                    IF _DynamicsIsRunning THEN 
                    DO:                     
                        /* Fill in the _RyObject record for the AppBuilder. */
                        FIND _RyObject WHERE _RyObject.object_filename = cFullPath NO-ERROR.

                        IF NOT AVAILABLE _RyObject THEN
                            CREATE _RyObject.

                        ASSIGN 
                            _RyObject.object_type_code       = _palette_item._object_class
                            _RyObject.parent_classes         = DYNAMIC-FUNCTION("getClassParentsFromDB":U IN gshRepositoryManager, INPUT _RyObject.object_type_code)
                            _RyObject.object_filename        =  cFullPath
                            _RyObject.product_module_code    = ""
                            _RyObject.static_object          = YES
                            _RyObject.container_object       = ?
                            _RyObject.design_action          = "NEW":u
                            _RyObject.design_ryobject        = YES
                            _RyObject.design_template_file   =  _palette_item._New_Template
                            _RyObject.design_propsheet_file  = ""
                            _RyObject.design_image_file      = "".
                    END.  
                    RUN adeuib/_open-w.p (cFullPath,"","UNTITLED").
                END. /* If _New_Template <> "" */
                RUN choose-pointer.
                RETURN.
            END. /* If custom = 'NEW' */
            ELSE DO:
                /* If this a OCX control then call out to the OCX picker */
                IF ENTRY(1, parse, CHR(10)) BEGINS "CONTROL" THEN
                     ASSIGN _object_draw = entry(2, parse, CHR(10))
                            customTool   = entry(3, parse, CHR(10))
                            tool         = "{&WT-CONTROL}".
                ELSE IF tool = "{&WT-CONTROL}" THEN 
                DO:
                    run adecomm/_setcurs.p("WAIT").
                    ASSIGN SESSION:DATE-FORMAT = _orig_dte_fmt.

                    /* Present OCX dialog via call to PROX. Get window parent handle
                       to position OCX dialog over Palette window. */
                    
/*                    if ideintegrated then*/
/*                    do:                  */
/*                        run runChildDialog in hOEIDEService("ide-choose-ocx").*/
                         RUN choose_ocx( INPUT _h_object_win:HWND).
                         
/*                    end.*/
/*                    RUN GetParent(INPUT _h_object_win:HWND, OUTPUT ParentHWND).    */
/*                    ASSIGN _ocx_draw = _h_Controls:GetControl(ParentHWND) NO-ERROR.*/
/*                                                                                   */
/*                    /* _ocx_draw will contain a valid com-handle. */               */
/*                    IF VALID-HANDLE(_ocx_draw) THEN                                */
/*                    DO:                                                            */
/*                        ASSIGN                                                     */
/*                             _object_draw = _ocx_draw:ClassID                      */
/*                             _custom_draw = _ocx_draw:ShortName                    */
/*                             customTool   = _custom_draw.                          */
/*                    END.                                                           */
/*                    ELSE _object_draw = ?.                                         */
/*                                                                                   */
/*                    run adecomm/_setcurs.p("").                                    */
                END.
                ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "USE" THEN
                    _object_draw = TRIM(SUBSTRING(ENTRY(1,parse,CHR(10)),4,-1,"CHARACTER")).
                ELSE IF ENTRY(1,parse,CHR(10)) BEGINS "DIRECTORY-LIST" THEN 
                DO:
                    /* wraps run adecomm/_chosobj.w to support modal call from IDE */ 
                    run choose_smartobject(INPUT tool,
                                           INPUT customTool,
                                           INPUT parse, 
                                           INPUT _palette_item._New_Template,
                                           INPUT "BROWSE,NEW,PREVIEW" ).
                     /* post logic is handled in choose_smartobject  */
                     RETURN.  
                    
                END.  /* IF directory list */
        
                IF _object_draw eq ? THEN 
                DO:
                   /* If there is no object draw at this point (usually happens when
                    * a user cancels out of a picker) then go back to the pointer */
                    RUN choose-pointer.
                    RETURN.
                END. 
            END. /* NOT "NEW" */
        END. /* NOT TYPE 1 */
        
        /* If we were in Pointer mode (next_draw = ?) and are now in draw mode,
           then make everything deselectionable (and deselectioned) if the
           last value of _next_draw was a pointer. Also set unmovable. */
        run setDrawMode.
         
        /* "Depress" the new choice widget tool by hiding it. */
        IF _palette_item._type eq {&P-BASIC} THEN 
            _object_draw = ?. 
    
        ASSIGN _next_draw   = tool
               _custom_draw = customTool.
   
        /* Set mouse pointer to selected item */
        RUN adeuib/_setpntr.p (_next_draw, input-output _object_draw).
        
        Run setToolStatus(custom).
    END. /* do with frame  */

END PROCEDURE. /* tool_choose - Click on widget tool button */

 /* If we were in Pointer mode (next_draw = ?) and are now in draw mode,
    then make everything deselectionable (and deselectioned) if the
    last value of _next_draw was a pointer. Also set unmovable. */
procedure setDrawMode: 
    if _next_draw EQ ? then  
    do:
        FOR EACH _U WHERE _U._HANDLE <> ? 
                      AND NOT CAN-DO("WINDOW,DIALOG-BOX,MENU,SUB-MENU,MENU-ITEM", _U._TYPE):
            ASSIGN _U._HANDLE:MOVABLE    = FALSE
                   _U._HANDLE:SELECTABLE = FALSE
                   _U._SELECTEDib        = FALSE.
        END.
    end.
end procedure. 

/* Show the user what the current tool is (in the HELP attribute of the drawing tool.*/
procedure setToolStatus: 
    define input parameter pCustom as character no-undo.
    
    define variable cStatusLine as character no-undo.
   
    IF pCustom eq ? THEN 
         cStatusLine = hDrawTool:HELP.  /* eg. "Button" or "Selection-List" */
    ELSE 
    DO:
        /* Set the status line to custom (eg.  "OK" or "Cancel").  */
        cStatusLine = pCustom.
        /* Remove underbars (& characters), but not ampersands (&&) */
        cStatusLine = REPLACE (  REPLACE ( REPLACE (
                        cStatusLine,
                        "&&":U,CHR(10)),
                        "&":U, "":U),
                        CHR(10), "&&":U).
        /* We would like the status line to list the widget type as well, 
           so add the hDrawTool:HELP  if we isn't already in the custom name.  
           (eg. if custom = "OK Button" we don't o say "OK Button Button".) */
        IF INDEX(cStatusLine, hDrawTool:HELP) eq 0 THEN 
            cStatusLine = RIGHT-TRIM(cStatusLine) + " ":U + hDrawTool:HELP.
    
    END.

    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Tool}, cStatusLine).
    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, 
                            IF goBack2Pntr THEN "" ELSE "Lock").
end procedure.


/* tool_lock - Select and "lock" a tool (_next_draw).  Clicking if
   if already locked, toggles it off. Continured clicking on the same tool
   (i.e. they are clicking on the hilite object or the lock) brings up an
   error message. (clicking off an icon also toggles the state).  
   
   If tool is UNKNOWN then assume it is the current tool. */

procedure tool_lock:
  DEFINE INPUT PARAMETER tool   AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER custom AS CHAR NO-UNDO.

  DEFINE VAR thing     AS CHAR. /* text string for what we are drawing      */
  DEFINE VAR draw_in_a AS CHAR. /* where drawing goes ("frame" or "window") */
  /* Tool defaults to the current tool. */
  IF tool eq ? THEN tool = _next_draw .
  IF custom eq ? THEN custom = _custom_draw .

  /* Make sure the desired tool is actually selected. (This will select it
     as being NOT locked.  The following line will lock it. */
    
  IF (_next_draw <> "{&WT-CONTROL}") THEN DO:
  
     IF (tool ne _next_draw) OR (custom ne _custom_draw) 
     THEN RUN tool_choose (tool, custom).
  
  END.
  /* Lock has no effect in Pointer mode (_next_draw eq ?). */
  IF _next_draw NE ? THEN DO:
    /* Toggle the lock state .*/
    goBack2pntr   = ((widget_click_cnt modulo 2) <> 0).
    h_lock:HIDDEN = goBack2pntr.

    RUN adecomm/_statdsp.p (_h_status_line, {&STAT-Lock}, 
                            IF goBack2Pntr THEN "" ELSE "Lock"). 
  END.

  IF (widget_click_cnt > 6) AND (_uib_prefs._user_hints) THEN DO:
     widget_click_cnt = 1. /* Reset the counter */
     IF _next_draw = ?
     THEN
     do: 
         if OEIDEIsRunning then
             ShowMessageInIDE("You have already chosen the POINTER tool.  This tool ~n
                             allows you to select and move objects that you have ~n
                             already created. Double-clicking on an object will ~n
                             bring up the Attribute Editor for that object.",
                             "Information","Pointer Tool","OK",yes).
         else
         MESSAGE "You have already chosen the POINTER tool.  This tool" {&SKP}
                  "allows you to select and move objects that you have" {&SKP}
                  "already created. Double-clicking on an object will" {&SKP}
                  "bring up the Attribute Editor for that object."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Pointer Tool".
     end.       
     ELSE DO:
       ASSIGN draw_in_a = IF _next_draw = "FRAME" THEN "window or frame" ELSE "frame"
              thing     = IF _next_draw = "SCHEMA-LIST" THEN "DB FIELDS"
                          ELSE IF _next_draw = "TOGGLE" THEN "TOGGLE BOX"
                          ELSE _next_draw.
       if OEIDEIsRunning then
             ShowMessageInIDE("You have already chosen the " + thing + "tool. ~n
                              There are two ways to create a new " + thing + " object - ~n
                               1) Click & Drag to define a position and size; OR ~n
                               2) Click in a " + draw_in_a + " to create a default " + thing  + "~n~n" +
                              "NOTE: Clicking with MOUSE-EXTEND will ~"lock~" your ~n 
                              choice of drawing tool.",
                              "Information",?,"OK",yes).
       else                   
       MESSAGE "You have already chosen the" thing "tool." {&SKP}
               "There are two ways to create a new" thing "object -" SKIP
               " 1) Click & Drag to define a position and size; OR" SKIP
               " 2) Click in a" draw_in_a "to create a default" thing SKIP SKIP
               "NOTE: Clicking with MOUSE-EXTEND will ~"lock~" your " {&SKP}
               "choice of drawing tool."
           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "Information".
     END.
   END.
END PROCEDURE.

/* Enables/Disables the UIB's Stop button image when user runs code. */
PROCEDURE uib-stopbutton.

  DEFINE INPUT PARAMETER p_Stop_Button AS WIDGET  NO-UNDO.
  DEFINE INPUT PARAMETER p_Sensitive   AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hWindow  AS WIDGET  NO-UNDO.  /* UIB Main window */
  DEFINE VARIABLE hFrame   AS WIDGET  NO-UNDO.
  DEFINE VARIABLE ldummy   AS LOGICAL NO-UNDO.
  DEFINE VARIABLE Imm_Disp AS LOGICAL NO-UNDO.

  DO ON STOP   UNDO, LEAVE
     ON ERROR  UNDO, LEAVE
     ON ENDKEY UNDO, LEAVE :
     
  ASSIGN Imm_Disp = SESSION:IMMEDIATE-DISPLAY
         SESSION:IMMEDIATE-DISPLAY = TRUE.
      
  /* We must enable the UIB Main window for input as well as the
     Stop button/image. Ditto for disabling.

     By enabling the window, we must handle window events.  This is done
     in _uibmain.p.

  */  
  ASSIGN hFrame                  = p_Stop_Button:FRAME
         hWindow                 = hFrame:PARENT
         hWindow:SENSITIVE       = p_Sensitive
         p_Stop_Button:SENSITIVE = p_Sensitive
         p_Stop_Button:HIDDEN    = NOT p_Sensitive
         ldummy                  = IF p_Sensitive
                                   THEN p_Stop_Button:MOVE-TO-TOP()
                                   ELSE p_Stop_Button:MOVE-TO-BOTTOM() 
  . /* ASSIGN */
  
  END. /* DO */
  
  /* Restore this session attribute. */
  ASSIGN SESSION:IMMEDIATE-DISPLAY = Imm_Disp.  
  
END PROCEDURE.

PROCEDURE update_palette :

  RUN setstatus ("WAIT":U, "Rebuilding palette icons and menus...":U).
  RUN copyPaletteCustom.
  FOR EACH _custom: /* remove old _custom records */
    DELETE _custom.
  END.    
  /* We are going to rebuild the palette window, after first hiding it.
     The Window System might then choose some other windows (eg. the 
     Program Manager) to take focus.  Avoid this by explicitly moving
     focus to the UIB main window. */  
  APPLY "ENTRY" TO _h_menu_win.
  RUN adeuib/_initpal.p.           /* re-initialize the palette */
  RUN adeuib/_cr_cust.p (INPUT no).           /* read new custom file */
/*  if valid-handle(hOEIDEService) then*/
/*      run adeuib/_oeidepalette.p.    */
  IF RETURN-VALUE = "_CANCEL" THEN RUN restorePaletteCustom.
  RUN adeuib/_cr_pal.p(INPUT yes). /* delete old palette items and rebuild */
  RUN adeuib/_cr_cmnu.p(INPUT MENU m_toolbox:HANDLE). /* add custom menus */

  /* Create popup menu on the 'New' button */
  RUN adeuib/_cr_npop.p (INPUT _h_button_bar[1]).
  ASSIGN hDrawTool = ?
         h_Lock    = ?.
  FIND _palette_item WHERE _palette_item._NAME = "Pointer".
  ASSIGN h_wp_pointer = _h_up_image.
  RUN choose-pointer.

  /* Reset the cursor pointer in all windows */
  RUN setstatus ("":U, "":U).
  
END.

PROCEDURE view_ab_in_desktop:
    run show_uibmain_in_desktop(true).
    run show_palette_in_desktop(true).
END.

/* wind-close  - delete the current window  */
procedure wind-close.
  DEFINE INPUT PARAMETER h_self  AS WIDGET NO-UNDO.

  DEFINE VAR save_opt   AS LOGICAL           NO-UNDO.
  DEFINE VAR cancel     AS LOGICAL           NO-UNDO.
  DEFINE VAR context    AS CHAR              NO-UNDO.
  DEFINE VAR file-name  AS CHAR              NO-UNDO.
  DEFINE VAR tmp-name   AS CHAR              NO-UNDO.
  DEFINE VAR lib_parent AS CHAR              NO-UNDO.
  DEFINE VAR askToSave  AS LOGICAL           NO-UNDO INITIAL FALSE.
  DEFINE VAR tmp_hSecEd AS HANDLE            NO-UNDO.
  DEFINE VAR hPropSheet AS HANDLE            NO-UNDO.
  DEFINE VARIABLE cProjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lProjectFile AS LOGICAL    NO-UNDO INITIAL FALSE.
  DEFINE VARIABLE lOEIDEReload AS LOGICAL    NO-UNDO INITIAL FALSE.
  
  FIND _U WHERE _U._HANDLE = h_self NO-ERROR.
  
  /* set in syncFromIDE. It is currently set on the window also when dialog, so check here 
     before changing h_self   
   @todo remove and replace this (always bad) use of private-data by proper mechanism  */ 
  IF OEIDEIsRunning THEN
     lOEIDEReload = h_self:PRIVATE-DATA = "_RELOAD". 
  
  if not avail _U then
  do:
      IF h_self:TYPE = "WINDOW":U THEN
          h_self = h_self:FIRST-CHILD.
      FIND _U WHERE _U._HANDLE = h_self NO-ERROR.   
  end.
  
  FIND _P WHERE _P._u-recid eq RECID(_U) no-error.

  /* jep-icf: Change the file saved state of design window based on prop sheet. */
  IF available _P and VALID-HANDLE(_P.design_hpropsheet) THEN
    ASSIGN _P._FILE-SAVED = NOT DYNAMIC-FUNC('isModified':u IN _P.design_hpropsheet) NO-ERROR.

  ASSIGN /* dma */
    tmp_hSecEd = hSecEd.

    IF available _P then
    hSecEd     = _P._hSecEd.
    
  /* IZ 1508 This call can create a Section Editor window for
     a procedure that's being closed. Only make the call if the
     procedure already has a Section Editor window open for it. - jep */
  /* SEW call to store current trigger code for specific window. */
  IF available _P and VALID-HANDLE(_P._hSecEd) THEN
    RUN call_sew ( INPUT "SE_STORE_WIN").

  /* If the file is dirty then save, if not, then check to
     see if OCX controls are dirty */
  IF avail _P and _P._FILE-SAVED EQ no THEN askToSave = yes.
  ELSE IF (OPSYS = "WIN32":u) THEN
  DO: /* OCX Dirty Check */
     RUN is_control_dirty(h_self, output askToSave).
  END.

  IF NOT OEIDEIsRunning OR (NOT lProjectFile AND NOT IDEIntegrated) THEN 
  DO:
    IF askToSave = yes THEN DO: 
      /* This save question should be similar to the one for dialogs and in closeup.p */
      /* Set default responce to "YES - Save changes! "                  */
      ASSIGN save_opt = yes
             tmp-name = IF _U._SUBTYPE eq "Design-Window" THEN _U._LABEL
                        ELSE _U._NAME.
        
      if OEIDEIsRunning then
          save_opt = ShowMessageInIDE((IF _P._SAVE-AS-FILE <> ? 
                              THEN tmp-name + " (" + _P._SAVE-AS-FILE  + ") " 
                              ELSE tmp-name ) +
                              "This window has changes which have not been saved. ~n
                              Save changes before closing?",
                              "Warning",?,"YES-NO-CANCEL",yes).
      else
      MESSAGE (IF _P._SAVE-AS-FILE <> ? 
              THEN tmp-name + " (" + _P._SAVE-AS-FILE  + ") " 
              ELSE tmp-name ) SKIP
             "This window has changes which have not been saved." SKIP(1)
             "Save changes before closing?"
            VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL UPDATE save_opt.
      IF save_opt THEN RUN save_window (INPUT no, OUTPUT cancel).
      ELSE IF save_opt = ? THEN cancel = yes.
      IF cancel THEN DO: /* dma */
        hSecEd = tmp_hSecEd.
        RETURN.
      END.
    END.
  END. /* OEIDEIsRunning */

  
  /* IZ 839 Save_window calls sensitize_main_window, which can move the current
     record out of _U so it's no longer available. Refind it here just in case. */
  FIND _U WHERE _U._HANDLE = h_self NO-ERROR.
    
  /* Check with source code control programs and see if we really should close 
     the file.  [Save the context and file name so that we can report the
     event after the file has closed and _U is no longer valid.] */
  if avail _U then   
  ASSIGN context    = STRING(RECID(_U))
         lib_parent = STRING(_U._WINDOW-HANDLE).
         
   if avail _P then      
   file-name  =  _P._SAVE-AS-FILE.
          
  IF NOT lOEIDEReload THEN
    RUN adecomm/_adeevnt.p 
         (INPUT "UIB", "Before-Close", context, file-name,
          OUTPUT save_opt).
  ELSE
    save_opt = TRUE.
  IF avail _U and save_opt THEN DO:
    RUN PurgeActionRecords( _U._HANDLE ).

    /* Hide the window to prevent flashing. */
    h_self:HIDDEN = TRUE.

    /* Delete this procedure's Section Editor, if it exists, and the "Display
       multiple Section Editors" preference has been selected. (dma) */
    IF _multiple_section_ed THEN
      RUN call_sew ( INPUT "SE_EXIT").

    /* db: dynamics propertysheet unregister */
    IF VALID-HANDLE(_h_menubar_proc) THEN
    DO:
        hPropSheet = DYNAMIC-FUNCTION("getpropertySheetBuffer":U IN _h_menubar_proc).
        IF VALID-HANDLE(hpropSheet) THEN
        DO:
          RUN unregisterObject IN hPropSheet (INPUT _h_menuBar_proc,
                                              INPUT STRING(_U._WINDOW-HANDLE),
                                              INPUT "*").
          RUN destroyObject IN hPropSheet.
        END.
    END.

    /* Tell the dynamics property sheets, like the Container Builder to close
       before we delete the frames, widgets, etc. */
    IF VALID-HANDLE(_P.design_hpropsheet) THEN
      PUBLISH "closePropSheet":U FROM _P.design_hpropsheet.

    /* Delete all the contained widgets. This will recursively call itself
       and delete contained frames. */
    RUN adeuib/_delet_u.p (INPUT RECID(_U), INPUT TRUE /* Trash */) .
    
    /* Delete the procedure record */
    {adeuib/delete_p.i} 

    
    /* Have we deleted the current widget */
    RUN del_cur_widg_check.

    /* Deactivate any layouts not being used any more */
    FOR EACH _layout WHERE _layout._LO-NAME NE "Master Layout" AND _layout._ACTIVE:
      IF NOT CAN-FIND(FIRST _L WHERE _L._LO-NAME = _layout._LO-NAME) THEN
        _layout._ACTIVE = FALSE.
    END.

    /* Note the CLOSE as being finished */
    IF NOT lOEIDEReload THEN
      RUN adecomm/_adeevnt.p 
         (INPUT "UIB", "Close", context, file-name, OUTPUT save_opt).
    ELSE
      save_opt = TRUE.

    /* Tell the ADE LIB-MGR Object that this UIB object is closing. */
    IF VALID-HANDLE( _h_mlmgr ) THEN
        RUN close-parent IN _h_mlmgr ( INPUT lib_parent ).

    /* Update the Window menu active window items. */
    RUN WinMenuRebuild IN _h_uib.
  
    /* Update hSecEd for current window. (dma) */
    IF NOT AVAILABLE _P THEN
      FIND _P WHERE _P._WINDOW-HANDLE EQ _h_win NO-ERROR.
    IF AVAILABLE _P THEN
      RUN call_sew_setHandle (INPUT _P._hSecEd).
    /* Don't add an ELSE here that sets the section editor handle
       to ?. Doing so can cause AB to create extra section editor
       instances when they aren't necessary.

       See bug 19991013-024 "Extra Section Editor instances created"
       for details. - jep Oct 13, 1999. */

  END.
END.  /* procedure wind-close...*/

/* wind-select-down  - short tag to run this on window select down */
procedure wind-select-down.
  RUN curwidg.
  RUN adeuib/_windsdn.p.
END.

/* wind-select-up  - short tag to run this on window select up.  */
/*                   Look at the function and decide what to do. */
procedure wind-select-up.
  DEFINE VAR action-string       AS CHAR                               NO-UNDO.
  /* If we are not drawing, then see if we want to go into the property sheet */
  IF _next_draw eq ? THEN DO:  
    IF LAST-EVENT:FUNCTION eq "MOUSE-SELECT-DBLCLICK":U 
    THEN RUN double-click.
    ELSE RUN curwidg.
  END.
  ELSE DO:
    
    /* We can only draw FRAMES and SmartObjects in a Window */
    IF    CAN-DO ("FRAME,QUERY":U, _next_draw)
       OR ((_object_draw ne ?) /* i.e. SmartObject */
            AND (_next_draw <> "{&WT-CONTROL}":U))
    THEN DO:
      /* Draw these legal cases */
      CASE LAST-EVENT:FUNCTION :
        WHEN "":U THEN RUN drawobj-in-box.
        WHEN "MOUSE-SELECT-CLICK":U THEN RUN drawobj.
      END CASE.
    END.
    ELSE DO: /* Report illegal cases */
      /*  Action_string will be either "create" or "select" depending on 
          whether any frames exist */
      IF CAN-FIND (_U WHERE _U._WINDOW-HANDLE eq SELF 
                        AND _U._TYPE eq "FRAME":U
                        AND _U._STATUS ne "DELETED":U)
      THEN action-string = "select".
      ELSE action-string = "create".
      if OEIDEIsRunning then
         ShowMessageInIDE("An " + _next_draw + " object cannot be drawn outside a frame.~n
                          Please " + action-string + " a frame.",
                          "Information",?,"OK",yes).
      else
      MESSAGE "An" _next_draw "object cannot be drawn outside a frame." SKIP
              "Please" action-string  "a frame."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
  END.
END PROCEDURE.

/* wind-event - common processor of all PERSISTENT window and dialog events . */
/*            NOTE: ENTRY events are ignored under MOTIF because they happen  */
/*            every time the mouse crosses the window. (wood 9/15/93).        */
/* NOTE: this used to be an exteranl .p (_winevnt.p) before we could run      */
/* persistent triggers IN a given context.                                    */
PROCEDURE wind-event:
  DEF INPUT PARAMETER p_case AS CHAR NO-UNDO.
 
  /* NOTE: there have been reported cases of events being issued to a 
     deleted window.  For example, the MS-WINDOW's Task Manager closes a
     PROGRESS window by first sending the CLOSE event, then the ENTRY event.
     ENTRY fails because the window is no longer valid. 
     
     The following check is purely to handle this degenerate case */
  IF NOT VALID-HANDLE(SELF) THEN RETURN.
   
  CASE p_case:
    WHEN "DIALOG-CLOSE"     THEN RUN dialog-close (SELF).
    WHEN "DIALOG-MINIMIZED" THEN DO:
      RUN adeuib/_vldwin.p (SELF:FIRST-CHILD).
      RUN display_current.
    END.
    WHEN "DIALOG-MAXIMIZED" THEN 
    DO: 
     &IF "{&WINDOW-SYSTEM}" ne "OSF/MOTIF" &THEN
        IF SELF NE _h_win THEN DO:
          IF NOT VALID-HANDLE(_h_win) THEN _h_win = SELF:FIRST-CHILD.
          RUN curframe(SELF:FIRST-CHILD).
          RUN display_current.
          RUN show_control_properties (INPUT 0).
        END.
     &ENDIF
    END.
    WHEN "DIALOG-RESTORED" THEN 
    DO: 
     &IF "{&WINDOW-SYSTEM}" ne "OSF/MOTIF" &THEN
        IF SELF NE _h_win THEN DO:
          IF NOT VALID-HANDLE(_h_win) THEN _h_win = SELF:FIRST-CHILD.
          RUN curframe(SELF:FIRST-CHILD).
          RUN display_current.
          RUN show_control_properties (INPUT 0).
        END.
     &ENDIF
    END.
    WHEN "WINDOW-CLOSE"     THEN
    DO:
        if not IDEIntegrated then
            RUN wind-close (SELF).
    END.
    WHEN "WINDOW-ENTRY" OR WHEN "DIALOG-ENTRY":U THEN DO: 
      
      IF  SELF:TYPE EQ "WINDOW" 
      AND SELF:WINDOW-STATE NE WINDOW-MINIMIZED 
      AND SELF NE _h_win THEN 
      DO:
        IF NOT VALID-HANDLE(_h_win) THEN 
            _h_win = SELF.
        RUN curwidg.
        RUN show_control_properties (INPUT 0).
      END.
      else if IDENotInEditor AND IDEIntegrated and valid-handle(hOEIDEService) then
      do:
           IDENotInEditor = false.
           if SetFocustoUI then   
              activateWindow(_h_win).
      end.
    END.
    WHEN "WINDOW-MINIMIZED" THEN DO:
        RUN adeuib/_vldwin.p (SELF).
        RUN display_current.
    END.
    OTHERWISE
    do:
       if OEIDEIsRunning then
         ShowMessageInIDE("Unexpected Window Event called:" + p_case,
                          "Information",?,"OK",yes).
      else  
       MESSAGE "Unexpected Window Event called:" p_case.
    end.
  END CASE.
END PROCEDURE.

/* WinExec
 *      Run a Windows program using Win32 API
 */
PROCEDURE WinExec EXTERNAL "KERNEL32.DLL":
  DEFINE INPUT PARAMETER prog_name  AS CHARACTER.
  DEFINE INPUT PARAMETER prog_style AS LONG.
END.

/* WinMenuGetActive -                                                       */
/*      Return delimited window title list of all active AB design          */
/*      windows and the current active title.                               */
PROCEDURE WinMenuGetActive :
  DEFINE OUTPUT PARAMETER p_ActiveWindows AS CHARACTER  NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE OUTPUT PARAMETER p_ActiveItem    AS CHARACTER  NO-UNDO.

  DEFINE BUFFER x_P FOR _P.
  
  DEFINE VARIABLE Delim        AS CHARACTER NO-UNDO INITIAL ",":U.
  DEFINE VARIABLE hWindow      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE h_active_win AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER NO-UNDO.
  
  DO:
    ASSIGN h_active_win = _h_win.
    /* _h_win can be invalid if the current active window got deleted/closed. */
    IF NOT VALID-HANDLE( h_active_win ) THEN
    DO:
        /* Make the first valid window the active window. */
        FOR EACH x_P NO-LOCK:
            IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
            ASSIGN h_active_win = x_P._WINDOW-HANDLE.
        END.
        IF NOT VALID-HANDLE(h_active_win) THEN RETURN.
    END.
    
    ASSIGN h_active_win = (IF h_active_win:TYPE = "WINDOW":U
                           THEN h_active_win ELSE h_active_win:PARENT).
    FOR EACH x_P NO-LOCK :
        IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
        ASSIGN hWindow = x_P._WINDOW-HANDLE
               hWindow = (IF hWindow:TYPE = "WINDOW":U
                          THEN hWindow ELSE hWindow:PARENT).
        IF NOT VALID-HANDLE( hWindow ) THEN NEXT.
        
        ASSIGN p_ActiveWindows = p_ActiveWindows + Delim + hWindow:TITLE.
        IF (hWindow = h_active_win) THEN       
          ASSIGN p_ActiveItem = h_active_win:TITLE.
          
        /* Add this window's Section Editor, if it's visible. (dma) */
        IF VALID-HANDLE(x_P._hSecEd) THEN DO:
          RUN GetAttribute IN x_P._hSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
          hWindow = WIDGET-HANDLE(cHandle).
          IF NOT VALID-HANDLE(hWindow) THEN NEXT.
          
          IF hWindow:VISIBLE THEN
            ASSIGN p_ActiveWindows = p_ActiveWindows + Delim + hWindow:TITLE.
        END.
    END.
    ASSIGN p_ActiveWindows = TRIM(p_ActiveWindows, Delim).
  END.

END PROCEDURE.

/* WinMenuRebuild -                                                         */
/*      Rebuild the Window menu active window items and assign one as the   */
/*      current active window.                                              */
PROCEDURE WinMenuRebuild :
  DEFINE VAR ActiveWindows AS CHARACTER  NO-UNDO.
         /* Handle to Window menu. */ 
  DEFINE VAR ActiveItem    AS CHARACTER  NO-UNDO.

  DO:
    IF NOT VALID-HANDLE( _h_WinMenuMgr ) THEN RETURN.
       
    RUN WinMenuGetActive IN THIS-PROCEDURE
        (OUTPUT ActiveWindows , OUTPUT ActiveItem).
    
    RUN WinMenuRebuild IN _h_WinMenuMgr
        (INPUT _h_WindowMenu ,
         INPUT ActiveWindows , INPUT ActiveItem , INPUT THIS-PROCEDURE).
         
  END.

END PROCEDURE.

/* WinMenuChoose -                                                          */
/*      Handles the action where user chooses an active window from the     */
/*      Window menu or More Windows dialog.  This procedure is actually     */
/*      called by the WinMenuMgr object. The active window items run        */
/*      a routine in the WinMenuMgr and that in turn calls this procedure   */
/*      with window title of the window to make current.                    */
PROCEDURE WinMenuChoose :
  DEFINE INPUT PARAMETER p_ActiveItem AS CHARACTER      NO-UNDO.
         /* Title of active window menu item chosen. */

  DEFINE BUFFER x_P FOR _P.
  
  DEFINE VARIABLE hWindow      AS HANDLE         NO-UNDO.
  DEFINE VARIABLE lIsSE        AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE RetValue     AS LOGICAL        NO-UNDO.
  DEFINE VARIABLE cHandle      AS CHARACTER      NO-UNDO.

  DO:
    IF NOT VALID-HANDLE( _h_WinMenuMgr ) THEN RETURN.
    FOR EACH x_P NO-LOCK :
        IF NOT VALID-HANDLE( x_P._WINDOW-HANDLE ) THEN NEXT.
        ASSIGN hWindow         = x_P._WINDOW-HANDLE
               hWindow         = (IF hWindow:TYPE = "WINDOW":U
                                  THEN hWindow ELSE hWindow:PARENT).
        IF NOT VALID-HANDLE(hWindow) THEN NEXT.
        
        IF (hWindow:TITLE <> p_ActiveItem) THEN DO:
          /* Did user select this window's Section Editor instance? (dma) */
          IF VALID-HANDLE(x_P._hSecEd) THEN DO:
            RUN GetAttribute IN x_P._hSecEd (INPUT "SE-WINDOW":U , OUTPUT cHandle).
            hWindow = WIDGET-HANDLE(cHandle).
            IF NOT VALID-HANDLE(hWindow) THEN NEXT.
            
            IF (hWindow:VISIBLE AND hWindow:TITLE <> p_activeItem) OR
              NOT hWindow:VISIBLE THEN NEXT.
            ASSIGN lIsSE = TRUE.
          END.
          ELSE NEXT.
        END.
        
        /* We've found the window to make active. */
        ASSIGN hWindow:WINDOW-STATE = WINDOW-NORMAL
                       WHEN hWindow:WINDOW-STATE = WINDOW-MINIMIZED
               hWindow:VISIBLE      = YES
               RetValue             = hWindow:MOVE-TO-TOP().
  
        /* Only "make current" if its not already current. */
        IF x_P._WINDOW-HANDLE <> _h_win AND NOT lIsSE THEN
        DO:
            RUN changewidg (INPUT x_P._WINDOW-HANDLE , INPUT TRUE).
            /* Open Section Editor for non-.w files (.p and .i files) or
               enter the current window. */
            IF (x_P._FILE-TYPE <> "w":U) THEN
                RUN call_sew (INPUT "SE_OPEN":U ).
            ELSE
                APPLY "ENTRY" TO hWindow.
        END.
        ELSE APPLY "ENTRY" TO hWindow.
        
        LEAVE.
    END. /* FOR EACH x_P */
  END.

END PROCEDURE.

/* WinIDEChoose -                                                          */
/*      Handles the action where user chooses an tab with an active window */ 
/*        in the IDE    */

PROCEDURE WinIDEChoose :
  DEFINE INPUT PARAMETER pHWND AS INT NO-UNDO.
  DEFINE VARIABLE hWindow      AS HANDLE         NO-UNDO.
  
  run GetWindowHandleFromIDEParent(pHwnd,output hWindow).
 
  if hWindow = ? then 
     return.
       
  /* We've found the window to make active. */
/*  assign hWindow:WINDOW-STATE = WINDOW-NORMAL when hWindow:WINDOW-STATE = WINDOW-MINIMIZED*/
/*         hWindow:VISIBLE      = true.                                                     */
/*  hWindow:MOVE-TO-TOP().                                                                  */
  IDENotInEditor = false.
  IDEEnterWindow = hWindow.
  apply "ENTRY" to hWindow.
        
END PROCEDURE.        

/*     Get the _P window that belongs to a parent in the IDE */ 
/*     Assumes one design window per IDE    */

PROCEDURE GetWindowHandleFromIDEParent:
  DEFINE INPUT  PARAMETER pHWND   AS INT NO-UNDO.
  DEFINE OUTPUT PARAMETER pHandle AS HANDLE NO-UNDO.
  
  DEFINE BUFFER x_P FOR _P.
  
  DEFINE VARIABLE hWindow      AS HANDLE         NO-UNDO.

  if pHWND = ? or pHWND = 0 then return. 
 
  for each x_p:
      assign hWindow = x_P._WINDOW-HANDLE.
       
      if hWindow:TYPE = "FRAME":U then
      do:
          pHandle = hWindow.
          leave. 
      end.
      else
      do:   
          hWindow = (IF hWindow:TYPE = "WINDOW":U THEN hWindow ELSE hWindow:PARENT). 
      if not valid-handle(hWindow) or hWindow:IDE-PARENT-HWND <> pHWND then
         next.   
      pHandle = hWindow.
      LEAVE.
      end.      
  end. /* FOR EACH x_P */
   
  /*
  for each x_p:
      assign hWindow = x_P._WINDOW-HANDLE.
             hWindow = (IF hWindow:TYPE = "WINDOW":U THEN hWindow ELSE hWindow:PARENT).
              
      if not valid-handle(hWindow) or hWindow:IDE-PARENT-HWND <> pHWND then
         next.   
      pHandle = hWindow.
      LEAVE.
            
  end.
  */
END PROCEDURE.


PROCEDURE copyPaletteCustom:
  FOR EACH _save_palette_item: DELETE _save_palette_item. END.
  FOR EACH _save_custom: DELETE _save_custom. END.
  FOR EACH _palette_item:
     CREATE _save_palette_item.
     {adeuib/setcwidp.i "_save_palette_item" "_palette_item"}
  END.
  FOR EACH _custom:
     CREATE _save_custom.
     {adeuib/setcwidc.i "_save_custom" "_custom"}
  END.
END PROCEDURE. /* copy PaletteCustom */

PROCEDURE restorePaletteCustom:
   
  FOR EACH _palette_item: DELETE _palette_item. END.
  FOR EACH _custom: DELETE _custom. END.
  FOR EACH _save_palette_item:
     CREATE _palette_item.
     {adeuib/setcwidp.i "_palette_item" "_save_palette_item"}
     DELETE _save_palette_item.
  END.
  FOR EACH _save_custom:
     CREATE _custom.
     {adeuib/setcwidc.i "_custom" "_save_custom"}
     DELETE _save_custom.
  END.
END PROCEDURE. /* restore PaletteCustom */

/* setAppBuilder_UBuffer -                                                  */
/*      Sets the _U buffer used in adeuib/_uibmain.p.                       */
/*      This is used by the integration code between the OpenEdge IDE code  */
/*      to ensure that _U is correct after loading a .w file in a           */
/*      syncFromIDE call.                                                   */
PROCEDURE setAppBuilder_UBuffer:
  DEFINE INPUT PARAMETER p_Recid      AS RECID          NO-UNDO.
  FIND _U WHERE RECID(_U) = p_Recid.
END.
 
PROCEDURE initializeIDEClient:
    DEFINE VARIABLE cNames   AS CHARACTER NO-UNDO EXTENT 19.
    DEFINE VARIABLE hHandles AS HANDLE    NO-UNDO EXTENT 19.
    define variable MitemHandle as handle no-undo.
    run adeuib/_oeideuib.p persistent set IDEClient.
    
    
    if valid-handle(IDEClient) then
    do:
        Assign
            cNames[1]   = "CUT":U
            hHandles[1] =  MENU-ITEM mi_cut:handle in menu m_edit
            cNames[2]   = "COPY":U
            hHandles[2] = MENU-ITEM mi_copy:handle in menu m_edit
            cNames[3]   = "PASTE":U
            hHandles[3] = MENU-ITEM mi_paste:handle in menu m_edit
            cNames[4]   = "UNDO":U
            hHandles[4] = _undo-menu-item 
/*            hHandles[4] = MENU-ITEM mi_undo:handle in menu m_edit*/
            cNames[5]   = "DUPLICATE":U
            /* dynamic */
            hHandles[5] =  mi_duplicate:handle     
            cNames[6]   = "DELETE":U
            /* dynamic */
            hHandles[6] =  mi_erase:handle     
            cNames[7]   = "ALIGN":U
            /* dynamic */
            hHandles[7] =  m_align:handle     
            cNames[8]   = "AlternateLayout":U
            /* dynamic */
            hHandles[8] =  mi_chlayout:handle     
            cNames[9]   = "CustomLayout":U
            /* dynamic */
            hHandles[9] =  mi_chCustlayout:handle    
            cNames[10]   = "TabOrder":U
            /* dynamic */
            hHandles[10] =  mi_tab_edit:handle     
            cNames[11]   = "UIB":U
            hHandles[11] =  _h_uib
            cNames[12]   = "window":U
            hHandles[12] = _h_menu_win
            cNames[13]  = "SAVE"    
            hHandles[13] = MENU-ITEM mi_save:handle in menu m_file. 
        if valid-handle(_h_menubar_proc) then 
        do:
               
            run getSubMenuHandle in _h_menubar_proc(input "OpenAssociateProcedure", output MitemHandle).
            assign cNames[14]   = "OpenAssociateProcedure"
                   hHandles[14] = MitemHandle.
            run getSubMenuHandle in _h_menubar_proc(input "SaveDynamicAsStatic", output MitemHandle).
            assign cNames[15]   = "SaveDynamicAsStatic"
                   hHandles[15] = MitemHandle.
            run getSubMenuHandle in _h_menubar_proc(input "SaveStaticAsDynamic", output MitemHandle).       
            assign cNames[16]   = "SaveStaticAsDynamic"
                   hHandles[16] = MitemHandle.
            run getSubMenuHandle in _h_menubar_proc(input "RegisterinRepository", output MitemHandle).       
            assign cNames[17]   = "RegisterinRepository"
                   hHandles[17] = MitemHandle.
            run getSubMenuHandle in _h_menubar_proc(input "DynamicObjectGenerator", output MitemHandle).
            assign cNames[18]   = "DynamicObjectGenerator"
                   hHandles[18] = MitemHandle.
        end.      
        IF _DynamicsIsRunning THEN
           assign cNames[19]   = "CustomizationPriority"
                  hHandles[19] = mi_CustomParams:handle.
        run setHandles in IDEClient (cNames,hHandles).
    end.  
 END. 


procedure context_menu_drop :
/* TODO static menus */   
    DEFINE INPUT  PARAMETER hParent AS HANDLE NO-UNDO.
    DEFINE VARIABLE hMenu AS HANDLE NO-UNDO.
    define variable lDyn as logical no-undo.
    define variable lNat as logical  no-undo.
    define variable ActionRecord as logical no-undo.
    define buffer b_p for _p.
    run isCurrentWindowDynamic(output lDyn, output lNat).
    
    hMenu = hParent:first-child.
    do while valid-handle(hmenu):
        case hmenu:name:
           when "GotoPage" then
           do:
                FIND b_P WHERE b_P._WINDOW-HANDLE EQ _h_win no-error.
                hMenu:sensitive =  avail b_p and CAN-DO (b_P._links, "PAGE-TARGET").
           end.      
           when "AddFunction":U or 
           when "AddProcedure":U or 
           when "AddTrigger":U or
           when "ViewSource":U or 
           when "Compile":U or 
           when "CopytoFile":U or 
           when "InsertFromFile":U then  
               hMenu:sensitive = not lDyn.
           when "undo":U then 
           do:
               run canundocurrentwindow (output ActionRecord).
               if not ActionRecord then 
                   hMenu:sensitive = false. 
               else   
                   hMenu:sensitive = _undo-menu-item:sensitive . 
           end.
           when "cut":U then 
               hMenu:sensitive = MENU-ITEM mi_cut:sensitive in menu m_edit.
           when "copy":U then 
               hMenu:sensitive = MENU-ITEM mi_copy:sensitive in menu m_edit.
           when "paste":U then 
               hMenu:sensitive = MENU-ITEM mi_paste:sensitive in menu m_edit.
           when "duplicate":U then 
               hMenu:sensitive = mi_duplicate:sensitive.
           when "delete":U then 
               hMenu:sensitive = mi_duplicate:sensitive.
        end.    
        hMenu = hMenu:next-sibling.
    end.      
end.    

PROCEDURE choose_ocx:
    define input parameter pHWND as INTEGER no-undo.
     
    define variable chooseOcx as adeuib.ide._chooseocx no-undo.
    
    if IDEIntegrated then
    do:  
        assign
            chooseOcx                    = new adeuib.ide._chooseocx()
            chooseOcx:pHWND              = pHWND.
                    
        chooseOcx:SetCurrentEvent(this-procedure,"do_choose_ocx":U).
        run runChildDialog in hOEIDEService(chooseOcx). 
    end.
    else 
        run do_choose_ocx(pHWND). 
END PROCEDURE.    

PROCEDURE do_choose_ocx:
    
    define input parameter pHWND as integer no-undo.
    DEFINE VARIABLE ParentHWND AS integer NO-UNDO.
    DEFINE VARIABLE ihwnd AS INTEGER NO-UNDO.
    if IDEIntegrated then
    do:  
        ihwnd = getOpenDialogHwnd().
        ASSIGN _ocx_draw = _h_Controls:GetControl(ihwnd) NO-ERROR.
    END.
    else
    DO:
        ASSIGN _ocx_draw = _h_Controls:GetControl(pHWND) NO-ERROR.
        RUN GetParent(INPUT pHWND, OUTPUT ParentHWND).
    END.
    /* _ocx_draw will contain a valid com-handle. */
    IF VALID-HANDLE(_ocx_draw) THEN
    DO:
        ASSIGN
          _object_draw = _ocx_draw:ClassID
          _custom_draw = _ocx_draw:ShortName.
/*          customTool   = _custom_draw.*/
    END.
    ELSE _object_draw = ?.

    run adecomm/_setcurs.p("").
    
END PROCEDURE.    

/* ************************  Function Implementations ***************** */
function createContextMenu returns handle 
        (  ):

/*------------------------------------------------------------------------------
        Purpose:  create a design time popup menu                                                                     
        Notes:    Currently only used when IDEIntegrated                                                                      
------------------------------------------------------------------------------*/    
    define variable hMenu as handle no-undo.
    define variable hItem as handle no-undo.
    create menu hMenu
        assign popup-only = true 
        triggers:
            on menu-drop persistent run context_menu_drop in this-procedure(hMenu).
        end.
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Undo":U
            label = "Undo"
        triggers:
            on choose persistent run choose_undo in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Cut":U
            label = "Cut"
        triggers:
            on choose persistent run choose_cut in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Copy":U
            label = "Copy"
        triggers:
            on choose persistent run choose_copy in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name  = "Paste":U
            label = "Paste"
        triggers:
            on choose persistent run choose_paste in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Duplicate":U
            label = "Duplicate"
        triggers:
            on choose persistent run choose_duplicate in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Delete":U
            label = "Delete"
        triggers:
            on choose persistent run choose_erase in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "ViewSource":U
            label = "View Source"
        triggers:
            on choose persistent run RightClick_viewSource in this-procedure.
                               
        end.
        
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Run":U
            label = "Run"
        triggers:
            on choose persistent run choose_run in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent = hMenu
            name = "Compile":U
            label = "Compile"
        triggers:
            on choose persistent run choose_compile in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
      
    create menu-item hItem
        assign 
            parent = hMenu
            name = "AddFunction":U
            label = "Add Function..."
         triggers:
             on choose persistent run choose_insert_function in this-procedure.
         end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            name = "AddProcedure":U
            label = "Add Procedure..."
        triggers:
            on choose persistent run choose_insert_procedure in this-procedure.
        end.
     
    create menu-item hItem
        assign 
            parent  = hMenu
            name = "AddTrigger":U
            label = "Add Trigger..."
        triggers:
            on choose persistent run choose_insert_trigger in this-procedure.
        end.
   
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
      
    create menu-item hItem
        assign 
            parent  = hMenu
            name = "CopytoFile":U
            label = "Copy to File..."
        triggers:
            on choose persistent run choose_export_file in this-procedure.
        end.

    create menu-item hItem
        assign 
            parent  = hMenu
            name = "InsertfromFile":U
            label = "Insert from File..."
        triggers:
            on choose persistent run choose_import_file in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            name = "TabOrder":U
            label = "Tab Order..."
        triggers:
            on choose persistent run choose_tab_edit in this-procedure.
        end.
    
    create menu-item hItem
        assign 
            parent  = hMenu
            subtype = "RULE":U.
    
    create menu-item hItem
        assign 
            parent  = hMenu
           name = "GotoPage":U         
           label = "Goto Page..."
        triggers:
            on choose persistent run choose_goto_page in this-procedure.
        end.
    return hMenu.   
end function.

function setContext returns logical 
    ( pcContext as char extent ):
    extent(fContext) = ?. 
    fContext = pccontext.    
    return true.        
end function.

function getContext returns char extent 
    (  ):
   return fContext.
end function.
      
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
  
  ASSIGN HelpFileName        = LC((HelpFileDir + p_HelpID + LanguageExtension + ".chm":u))
         FILE-INFO:FILE-NAME = HelpFileName
         HelpFileFullName    = LC(FILE-INFO:FULL-PATHNAME).

  IF HelpFileFullName = ? THEN
    ASSIGN HelpFileFullName = LC(HelpFileDir + p_HelpID + "eng":u + ".chm":u).

  RETURN LC(HelpFileFullName).
  
END. /* DO */

END FUNCTION.

procedure canUndoCurrentWindow:
    define output parameter ActionRecord as logical.
    
    define buffer buff_action for _action.
    if can-find (first buff_action where buff_action._window-handle = _h_win ) then  
       ActionRecord = true.
    ELSE 
       ActionRecord = false.
end procedure.

PROCEDURE OpenAssociatedProcedure:
/*------------------------------------------------------------------------------
  Purpose:     Open associated procedure for an object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   run runOpenProcedure in _h_menubar_proc.
END PROCEDURE.

procedure CanConvertFormToDynamic:
  
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  convertType = 1 then Static to dynamic
            convertType = 2 then dynamic to static
            converttype = 0 then nothing
------------------------------------------------------------------------------*/
  define output parameter ConvertType    AS integer no-undo.
  define variable lCanConvert as logical no-undo.
  define buffer local_P  for _P.
  define buffer local_U  for _U.
  assign ConvertType = 0.
  find local_U where local_U._HANDLE = _h_win no-error.  
  find local_P where local_P._WINDOW-HANDLE = local_U._WINDOW-HANDLE no-error.
  if available local_P then do:
    if local_P.static_object then  /* Going from static to dynamic */
      assign lCanConvert = lookup(local_P._TYPE,
                         "SmartDataViewer,SmartViewer,SmartDataBrowser,SmartBrowser,SmartDataObject":U) > 0
                         and lookup("NEW":U,local_P.design_action) = 0
             ConvertType = if lCanConvert then 1 else 0.
    ELSE  /* Going from Dynamic to Static (Limit the choices for now) */
      assign lCanConvert = lookup(local_P._TYPE,
         /* IZ 9851 & 9855 "SmartDataViewer,SmartViewer,SmartDataBrowser,SmartBrowser,SmartDataObject":U) > 0 */
                         "SmartDataViewer,SmartViewer,SmartDataObject":U) > 0
                         and lookup("NEW":U,local_P.design_action) = 0
              ConvertType = if lCanConvert then 2 else 0.
    
  end. /* If available local_P */
end procedure.
  
procedure RunDynamicPropertySheet:
    if valid-handle(_h_menubar_proc) then
        run choose_dynProperties in _h_menubar_proc.
end procedure.                      

procedure ExportCurrentWidgetTree  :
    define input parameter pcPath as character no-undo.
    define input parameter pcFile as character no-undo.
    run adeuib/_oeidewidgets.p (pcPath,pcfile,_h_win).
end procedure.                      

procedure SelectWidgetinUI:
    define input parameter widgetName as character.
    find _U where _U._WINDOW-HANDLE = _h_win and _U._NAME = trim(widgetName) no-error.
    IF AVAILABLE _U THEN 
    DO:
        ASSIGN _h_cur_widg  = _U._HANDLE
               SetFocustoUI = no.
                   
        FIND _F WHERE RECID(_F) = _U._x-recid NO-ERROR.
        IF AVAILABLE _F THEN _h_frame = _F._FRAME.
        ELSE IF CAN-DO("FRAME,DIALOG-BOX",_U._TYPE) THEN _h_frame = _U._HANDLE.
        ELSE _h_frame = ?.
    
        /* Deselect all widgets (except _h_cur_widg) */
        RUN deselect_all  IN _h_uib (_h_cur_widg, ?).
        /* Make this the current widget */
        RUN curframe  IN _h_uib (_h_cur_widg).
        RUN display_current IN _h_uib.
        SetFocustoUI = yes. /* Activate this flag to set focus for other events from outline view */
  END.
end procedure.    

procedure choose_compile:
    if IDEIntegrated then
       CompileDesign(_h_win).
end.    
function findWidgetName return character 
         (WidgetParentrecId as recid):
    define buffer loc_u for _u.
    find first loc_u where recid(loc_u) = WidgetParentrecId no-error.
    if  available loc_U then   
    return loc_U._NAME.
    else
    return "". 
end function. 

procedure CallWidgetEvent:
    define input parameter U_Recid as recid no-undo.
    define input parameter WidgetAction as character no-undo.
    define buffer loc_U for _U.
    find loc_U where recid(loc_U) = U_Recid no-lock no-error.
    if available(loc_U) then
       WidgetEvent(_h_win,
                   loc_U._NAME,
                   loc_U._LABEL,
                   loc_U._TYPE,
                   findWidgetName(loc_U._PARENT-RECID),
                   WidgetAction).
      
end procedure.    

procedure CallRenameWidget:
    define input parameter U_Recid as recid no-undo.
    define input parameter WidgetOldName as character no-undo.
    define buffer loc_U for _U.
    find loc_U where recid(loc_U) = U_Recid no-lock no-error.
    if available(loc_U) then
       RenameWidget(_h_win,
                   WidgetOldName,
                   loc_U._NAME,
                   loc_U._LABEL,
                   loc_U._TYPE,
                   findWidgetName(loc_U._PARENT-RECID),
                   "Rename").
       
end procedure.
    
procedure isTTY:
    define output parameter pistty  as logical no-undo.
    define variable childhandle as handle no-undo.
    define buffer loc_U for _U.
    if _h_win:type <> "FRAME" then
       childhandle = _h_win:first-child.
    else
       childhandle = _h_win.
     
    find loc_U where loc_u._HANDLE = childhandle no-lock no-error.
    
    if available loc_u then
       assign pistty  =  loc_U._WIN-TYPE = false.
         
end procedure.    
