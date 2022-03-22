/*******************************************************************************
* Copyright (C) 2000,2014,2020-2021 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions                   *
* contributed by participants of Possenet.                                     *
*                                                                              *
*******************************************************************************/
/******************************************************************************
*
*   PROGRAM:  _desktop.p
*
*   PROGRAM SUMMARY:
*       This is the front end to all tools in the PROGRESS ADE. 
*
*   RUN/CALL SYNTAX:
*       RUN adedesk/_desktop.p
*
*   PARAMETERS/ARGUMENTS LIST:
*       None
*
*   REVISION HISTORY:
    05/25/21 tmasood Disable dictionary button for 32-bit
*   08/19/01 jep   Added output parameter to _ablic.p call. ICF support. jep-icf.
*   10/15/99 gfs   Changed "Report Designer" to "e.Report Designer"
*   05/07/99 gfs   Added Actuate WB and RD
*   10/08/98 gfs   Removed red focus rectangle. It was obsolete.
*   07/20/98 gfs   Installed new desktop images (MS-like), 
*                  removed insensitive ones & make all buttons NO-FOCUS & FLAT
*   04/03/98 gfs   Use workshop icon if webspeed-only.
*   01/23/98 gfs   Added MAX-BUTTON = FALSE to Window defn.
*   04/30/97 slk   Fixed Desktop window sizing when desktop must
*		   display fewer than 4 icons. btn_spacing test is the fix.
*		   Changed spacing depending on <=2, 3, 4 icons 
*   02/19/97 slk   Extra width for win31 Shell - NT 3.51 
*   10/21/96 gfs   Removed text labels and added tooltips
*   02/01/96 gfs   For Win95, added call to adeshar/_taskbar.p to adjust window
*   01/29/96 jep   Removed Librarian tool (PLIB/proclib) from desktop code.
*   06/29/95 jep   Fixed 93-06-23-111 Uninstalled products. We used to display
*                  the product's icon and gray out the text. We can't gray text
*                  because it does not display in 3D backgrounds. Now we use
*                  insenitive image for the icon.
*   05/17/95 jep   Support Translation Manager and Visual Translator in
*                  MS-Windows only.
*   06/27/94 jep   94-06-16-099 Fixed Desktop window sizing when desktop must
*                  display fewer than 4 icons.  btn_spacing test is the fix.
*   06/27/94 jep   93-12-08-079 Fixed orphan dynamic windows/widgets.
*   06/15/94 ptullman Added Profiler Checkpoints for tools' startup.
*   06/13/94 ryan  Added _icon-dir global shared variable for performance
*                  considerations.
*   05/18/94 ryan  For Greg O'Connor:changed from 64x64 pixel bitmaps to 32x32
*                  icons.
*                  Also used new, reserved font 4 for desktop to reduce size.
*   04/27/94 jep   Desktop suppress PROGRESS PUT-KEY-VALUE error and
*                  displays one of its own using _puterr.p.
*   09/09/93 wood  Change desktop to set adecomm/_setcurs.p ("WAIT") before
*                  calling tools. [And set cursor back before WAIT-FOR.].
*   08/16/93 wood  Removed reference to FOCUS:HANDLE which bombed if FOCUS = ?.
*   07/14/93 mikep 93-06-23-111 gray out uninstalled apps - MS-Windows only.
*   07/12/93 mikep 93-07-06-004 fix write to .ini failures.
*                  93-07-08-071 check sensitivity of menubar, not file menu.
*   06/20/93 mikep 93-06-07-089 fix
*                  93-06-14-035 fix
*                  93-06-14-122 fix
*   06/01/93 mikep Labels as literals not variables.
*   94/05/02 hutegger create dictdb-alias before calling the dictionary.
*
*   AUTHORS:  John Palazzo, Mike Pacholec
*   DATE:     02/11/92
*
******************************************************************************/

/*-----------------------------  PREPROC VARIABLES  --------------------------*/

&GLOB TOOL_STACKING 0 /* set to 1 to enable this feature */

/* tall_window is here to support screen capture of the Tools menu for doc */
&GLOB TALL_WINDOW   0 /* set to 1 to enable this feature */

&GLOB DEBUG         0

&GLOB TEXT_FONT     4
&GLOB REPORT-WRITER 1

/*-----------------------------  DEFINE VARIABLES  --------------------------*/

/* Setup Profiler */
{adedesk/timectrl.i}                   /* Controls profiler for startup */
{adeshar/mpdecl.i &timer="DESK_uibstart"}
{adeshar/mpdecl.i &timer="DESK_startup"}
{adeshar/mp.i &timer="DESK_startup" &mp-macro="start"}
{adeshar/mp.i &timer="DESK_startup" &mp-macro="stotal"
              &infostr="[_desktop.p] Entered _desktop.p"}

DEFINE VARIABLE ok             AS LOGICAL.
DEFINE VARIABLE Desktop_Window AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Lic            AS INTEGER       NO-UNDO.
DEFINE VARIABLE Tools          AS CHARACTER     NO-UNDO.

&IF {&TOOL_STACKING} = 1 &THEN
DEFINE VARIABLE Pref_Enable AS LOGICAL INIT NO.
&GLOB ENABLE_PREF "Enable &Panel After Selection"
&ENDIF

{ adecomm/adestds.i}

&IF DEFINED(ADEICONDIR) = 0 &THEN
 {adecomm/icondir.i}
&ENDIF

/* From adecomm/_runcode.p.  Used to manage orphaned persistent procedures. */
DEFINE WORK-TABLE PersistProc NO-UNDO
    FIELD hProc     AS HANDLE
    . /* WORK-TABLE */   

/*-----------------------------  DEFINE BUTTONS  ----------------------------*/

/* All icons are of size-pixels 32 x 32  plus a margin (which varies by platform). */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
&GLOB BTN_SIZE  SIZE-PIXELS 39 BY 39          
&ELSE
&GLOB BTN_SIZE  SIZE-PIXELS 44 BY 44
&ENDIF

/* IMAGE-SIZE-PIXELS commented out per bug fix 92-12-18-075 */
DEFINE BUTTON btn_dict  {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "dict{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
DEFINE BUTTON btn_uib   {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "uib{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
DEFINE BUTTON btn_edit  {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "edit{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
DEFINE BUTTON btn_rpt   {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "results{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
DEFINE BUTTON btn_rb    {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "rbuild{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
&ENDIF
DEFINE BUTTON btn_dbg   {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "debug{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
DEFINE BUTTON btn_dwb   {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "devwb{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.
DEFINE BUTTON btn_ard   {&BTN_SIZE}
              IMAGE             FILE {&ADEICON-DIR} + "ard{&BMP-EXT}" 
              NO-FOCUS FLAT-BUTTON.

/*-----------------------------  DEFINE FORMS -------------------------------*/

&IF {&TALL_WINDOW} = 1 &THEN
&GLOB FRAME_VERT_MARGIN          20 /* tall window only */
&ELSE
&GLOB FRAME_VERT_MARGIN           5 /* normal value */
&ENDIF
&GLOB TEXT_VERT_MARGIN            5
&GLOB MARGIN                      5 /* general small margin */

/*  
   ?              ?
|-----|        |-----|
      -      ?
    5 | |------------|
      - XXXXXXXX     XXXXXXXX
      | XXXXXXXX     XXXXXXXX
   32 | XXXXXXXX     XXXXXXXX
      - XXXXXXXX     XXXXXXXX
*/

FORM  
    /* keep help text short for dict edit - width of status may be
       small if only those two tools are licensed */
    btn_dict HELP "Maintain database schema."
    btn_edit HELP "Write 4GL procedures."
    btn_uib  HELP "Build and assemble application components."
    btn_rpt  HELP "Create end-user queries and reports."
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    btn_rb   HELP "Develop professional reports."
&ENDIF
    btn_dbg  HELP "Debug application code."
    btn_dwb  HELP "Actuate Developer Workbench"
    btn_ard  HELP "e.Report Designer"
    WITH FRAME Develop THREE-D NO-BOX USE-TEXT NO-LABELS FONT {&TEXT_FONT}.
      
/* Assign tooltips to the buttons */
ASSIGN btn_dict:TOOLTIP = "Data Dictionary"
       btn_edit:TOOLTIP = "Procedure Editor"
       btn_uib:TOOLTIP  = "AppBuilder"
       btn_rpt:TOOLTIP  = "RESULTS"
       btn_rb:TOOLTIP   = "Report Builder"
       btn_dbg:TOOLTIP  = "Application Debugger"
       btn_dwb:TOOLTIP  = "Actuate Developer Workbench"
       btn_ard:TOOLTIP  = "e.Report Designer"
.
/* Check AB license */
RUN adeshar/_ablic.p (INPUT NO /* Show Msgs */, OUTPUT lic, OUTPUT Tools).
/* If Webspeed Workshop-only, then change UIB image to Workshop image */
IF Lic = 2 THEN DO:
  btn_uib:LOAD-IMAGE-UP({&ADEICON-DIR} + "workshp{&BMP-EXT}").
END.

/*-------------------------  MENUS AND TRIGGERS ---------------------*/

{ adedesk/menus.i }

/*-----------------------------  LICENSE MGNT  ------------------------------*/

&GLOB REPORT-WRITER 1

DEFINE VARIABLE dict_licensed  AS LOGICAL INIT Yes.
DEFINE VARIABLE edit_licensed  AS LOGICAL INIT Yes.
DEFINE VARIABLE admin_licensed AS LOGICAL INIT Yes.
DEFINE VARIABLE uib_licensed   AS LOGICAL.
DEFINE VARIABLE dbg_licensed   AS LOGICAL.
DEFINE VARIABLE comp_licensed  AS LOGICAL.
DEFINE VARIABLE rb_licensed    AS LOGICAL.
DEFINE VARIABLE rpt_licensed   AS LOGICAL.
DEFINE VARIABLE dwb_licensed   AS LOGICAL.
DEFINE VARIABLE ard_licensed   AS LOGICAL.

&IF 0 &THEN /* for 7.2A, this check has been made obsolete */
DEFINE VARIABLE desk_licensed  AS INTEGER.
desk_licensed = GET-LICENSE("DESKTOP").
IF desk_licensed <> 0 THEN DO:
    RUN LicenseMsg(INPUT desk_licensed, INPUT "Desktop").
    RETURN.
END.
&ENDIF

/* Establish license and availablility of Desktop icon tools. */
assign
  dict_licensed  = ade_licensed[{&DICT_IDX}] <> {&NOT_AVAIL}
  edit_licensed  = ade_licensed[{&EDIT_IDX}] <> {&NOT_AVAIL}
  uib_licensed   = ade_licensed[{&UIB_IDX}] <> {&NOT_AVAIL}
  dbg_licensed   = ade_licensed[{&DBG_IDX}] <> {&NOT_AVAIL}
  comp_licensed  = ade_licensed[{&COMP_IDX}] <> {&NOT_AVAIL}
  rpt_licensed   = ade_licensed[{&RPT_IDX}] <> {&NOT_AVAIL}
  rb_licensed    = ade_licensed[{&RB_IDX}] <> {&NOT_AVAIL}
  dwb_licensed   = ade_licensed[{&DWB_IDX}] <> {&NOT_AVAIL}
  ard_licensed   = ade_licensed[{&ARD_IDX}] <> {&NOT_AVAIL}
  .

/*-------------------------  RUNTIME LAYOUT -----------------------*/
/* ---- let's adjust the layout of this frame before it's seen --- */

DEFINE VARIABLE button_count      AS INTEGER.
DEFINE VARIABLE btn_spacing       AS INTEGER.
DEFINE VARIABLE frame_horz_margin AS INTEGER.
DEFINE VARIABLE btn_width         AS INTEGER.
DEFINE VARIABLE btn_height        AS INTEGER.

DEFINE VARIABLE current_x         AS INTEGER.

/* Variables used to determine menu minimum width */
DEFINE VARIABLE l-mnuitem AS WIDGET-HANDLE.
DEFINE VARIABLE totalMenuItemWidth  AS INTEGER.
DEFINE VARIABLE menuItemWidth  AS INTEGER.

/* Initialize button_count to 2 - Editor and Dictionary. */
ASSIGN button_count = 2.
ASSIGN button_count = button_count +
                      (IF uib_licensed  THEN 1 ELSE 0) +
                      (IF rpt_licensed  THEN 1 ELSE 0) +
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
                          (IF rb_licensed   THEN 1 ELSE 0) +
&endif
                          (IF dbg_licensed  THEN 1 ELSE 0)
                       + (IF dwb_licensed THEN 1 ELSE 0)
                       + (IF ard_licensed THEN 1 ELSE 0)
       btn_width  = btn_edit:WIDTH-PIXELS
       btn_height = btn_edit:HEIGHT-PIXELS.

/* How apart should each button be horizontally? */
btn_spacing = {&MARGIN}.
IF btn_spacing < btn_width + {&MARGIN} THEN
    btn_spacing = btn_width + {&MARGIN}.

l-mnuitem = MENU mnb_Desktop:FIRST-CHILD.
DO WHILE VALID-HANDLE(l-mnuitem):
   menuItemWidth = FONT-TABLE:GET-TEXT-WIDTH-P(l-mnuitem:LABEL)
     + SESSION:PIXELS-PER-COLUMN * 3.
   totalMenuItemWidth = totalMenuItemWidth + menuItemWidth.
   l-mnuitem = l-mnuitem:NEXT-SIBLING.
END.

/* With less than 4 buttons, the pulldown menu spills over on two
   lines.  This will attempt to compensate by increasing the width
   between the buttons - maintaining centered buttons. 
*/
IF button_count <= 2 THEN
    btn_spacing = btn_spacing * 1.90.
ELSE IF button_count <= 4 THEN
DO WHILE ((btn_spacing * button_count) + (btn_spacing - btn_width)) < totalMenuItemWidth:
    btn_spacing = btn_spacing + 5.
END.

/* The left margin should be equal to the right margin.  
   The right margin is the same as the gap between the buttons. */   
frame_horz_margin = btn_spacing - btn_width.

&IF {&DEBUG} &THEN
message 
    "btn_spacing"        btn_spacing skip
    "frame_horz_margin"  frame_horz_margin skip
    view-as alert-box information buttons ok.
&ENDIF

current_x       = frame_horz_margin.

/* position the Dictionary - always present */    
ASSIGN
    btn_dict:X   = current_x
    btn_dict:Y   = {&FRAME_VERT_MARGIN}
    current_x    = current_x + btn_spacing.

/* position the Editor - always present */
ASSIGN
    btn_edit:X   = current_x
    btn_edit:Y   = {&FRAME_VERT_MARGIN}
    current_x    = current_x + btn_spacing.

/* position the UIB - 99% present */
IF uib_licensed THEN DO:
    ASSIGN
        btn_uib:X    = current_x
        btn_uib:Y    = {&FRAME_VERT_MARGIN}
        current_x    = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_uib:HIDDEN   = TRUE.

/* position the RW - 99% present */
IF rpt_licensed THEN DO:
    ASSIGN
        btn_rpt:X = current_x
        btn_rpt:Y = {&FRAME_VERT_MARGIN}
        current_x = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_rpt:HIDDEN   = TRUE.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
/* position the RB - 99% present */
IF rb_licensed THEN DO:
    ASSIGN
        btn_rb:X = current_x
        btn_rb:Y = {&FRAME_VERT_MARGIN}
        current_x = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_rb:HIDDEN   = TRUE.

&ENDIF

/* position the Debugger - ?% present */
IF dbg_licensed THEN DO:
    ASSIGN
        btn_dbg:X = current_x
        btn_dbg:Y = {&FRAME_VERT_MARGIN} 
        current_x = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_dbg:HIDDEN   = TRUE.

/* position Actuate Developer Workbench - ?% present */
IF dwb_licensed THEN DO:
    ASSIGN
        btn_dwb:X = current_x
        btn_dwb:Y = {&FRAME_VERT_MARGIN} 
        current_x = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_dwb:HIDDEN   = TRUE.

/* position Actuate e.Report Designer - ?% present */
IF ard_licensed THEN DO:
    ASSIGN
        btn_ard:X = current_x
        btn_ard:Y = {&FRAME_VERT_MARGIN} 
        current_x = current_x + btn_spacing.
END.
ELSE
    ASSIGN btn_ard:HIDDEN   = TRUE.

/* make the frame wider */
FRAME Develop:WIDTH-PIXELS = frame_horz_margin + (btn_spacing * button_count).

/* Extra width for Win.31 shell */
IF SESSION:WINDOW-SYSTEM = "MS-WINDOWS" /* NT 3.51 */ 
THEN
ASSIGN 
     FRAME Develop:WIDTH-PIXELS = FRAME Develop:WIDTH-PIXELS + SESSION:PIXELS-PER-COLUMN * 9
   .

/* now fix the frame */
FRAME Develop:HEIGHT-PIXELS = (2 * {&FRAME_VERT_MARGIN}) + btn_height.

&IF {&DEBUG} &THEN
message 
    "FRAME Develop:WIDTH-PIXELS"   FRAME Develop:WIDTH-PIXELS
    "FRAME Develop:HEIGHT-PIXELS"  FRAME Develop:HEIGHT-PIXELS
    view-as alert-box information buttons ok.
&ENDIF

/* ---- done adjusting layout ---- */

/*----------------------------  MAIN  ----------------------------------*/

DO: /* desktop.p */

    DEFINE VARIABLE key_value AS CHAR NO-UNDO.
    DEFINE VARIABLE initial_hide_setting AS LOGICAL NO-UNDO.
    
                            
    /* Set global active ade tool procedure handle to Desktop. */
    ASSIGN h_ade_tool = THIS-PROCEDURE.

    DEFAULT-WINDOW:VISIBLE = FALSE.
    CREATE WINDOW Desktop_Window
        ASSIGN
            X                = &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 15
                               &ELSE 10 &ENDIF
            Y                = &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 35
                               &ELSE 10 &ENDIF
            HEIGHT-PIXELS    = FRAME Develop:HEIGHT-PIXELS
            WIDTH-PIXELS     = FRAME Develop:WIDTH-PIXELS
            TITLE            = "PROGRESS"
            VISIBLE          = FALSE
            MESSAGE-AREA     = NO
            MENUBAR          = MENU mnb_desktop:HANDLE
            HIDDEN           = True
            MAX-BUTTON       = FALSE
            STATUS-AREA      = FALSE
            RESIZE           = FALSE
            TRIGGERS:
                ON "WINDOW-CLOSE" DO:
                    IF MENU mnb_Desktop:SENSITIVE = FALSE 
                    THEN
                        MESSAGE 
"Application still active. Exit the application before exiting the Desktop." 
                            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                    ELSE
                        APPLY "CHOOSE" TO MENU-ITEM _exit IN MENU mnu_File.
                    RETURN NO-APPLY.
                END.
           END TRIGGERS.

    IF NOT Desktop_Window:LOAD-ICON({&ADEICON-DIR} + "desktop.ico":U) THEN
		Desktop_Window:LOAD-ICON({&ADEICON-DIR} + "progress.ico":U).

    ok = Desktop_Window:LOAD-MOUSE-POINTER("WAIT":U).
    
    /* If there is a Windows 95 Taskbar, adjust the position of
     * the desktop window so that it does not appear behind it (gfs)
     */
    IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO:
      DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
      DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
      DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
      DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.
    
      RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                              OUTPUT TBWIdth,       OUTPUT AutoHide).
      IF NOT AutoHide THEN DO:
        IF TBOrientation = "LEFT":U THEN 
          Desktop_Window:X = Desktop_Window:X + TBWidth.
        IF TBOrientation = "TOP":U THEN
          Desktop_Window:Y = Desktop_Window:Y + TBHeight.
      END.
    END.

    SESSION:SYSTEM-ALERT-BOXES = YES.

    GET-KEY-VALUE SECTION "Desktop" KEY "Minimize" VALUE key_value.
    /* MESSAGE key_value view-as alert-box information buttons ok. */
    ASSIGN 
        initial_hide_setting = IF key_value = "yes" THEN True ELSE False
        MENU-ITEM mnu_Hide:CHECKED IN MENU mnu_Pref = initial_hide_setting.

    ENABLE 
        btn_dict   WHEN dict_licensed AND PROCESS-ARCHITECTURE = 64
        btn_edit   WHEN edit_licensed 
        btn_uib    WHEN uib_licensed  
        btn_rpt    WHEN rpt_licensed  
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
        btn_rb     WHEN rb_licensed  
&ENDIF
        btn_dbg    WHEN dbg_licensed  
        btn_dwb    WHEN dwb_licensed
        btn_ard    WHEN ard_licensed
        WITH FRAME Develop IN WINDOW Desktop_Window.

    CURRENT-WINDOW = Desktop_Window.

    /* Profiler Checkpoint */
    {adeshar/mp.i &timer="DESK_startup" &mp-macro="stotal"
                  &infostr="[_desktop.p] Hit VIEW Desktop_Window"}
    VIEW Desktop_Window.

    /* If a product is licensed but not installed, gray out menu options and
       buttons as necessary. */

    IF ade_licensed[{&DICT_IDX}] <> {&INSTALLED} THEN DO:
	MENU-ITEM mnu_new_db:SENSITIVE IN MENU mnu_New = No.
	MENU-ITEM mnu_open_db:SENSITIVE IN MENU mnu_Open = No.
        btn_dict:SENSITIVE IN FRAME Develop = No.
        dict_licensed = No.
    END.

    IF ade_licensed[{&EDIT_IDX}] <> {&INSTALLED} THEN DO:
	MENU-ITEM mnu_new_proc:SENSITIVE IN MENU mnu_New = No.
	MENU-ITEM mnu_open_proc:SENSITIVE IN MENU mnu_Open = No.
        btn_edit:SENSITIVE IN FRAME Develop = No.
        edit_licensed = No.
    END.

    IF uib_licensed AND ade_licensed[{&UIB_IDX}] <> {&INSTALLED} THEN DO:
	mnu_new_win_wh:SENSITIVE = No.
	mnu_open_win_wh:SENSITIVE = No.
        btn_uib:SENSITIVE IN FRAME Develop = No.
        uib_licensed = No.
    END.

    IF rpt_licensed AND ade_licensed[{&RPT_IDX}] <> {&INSTALLED} THEN DO:
	btn_rpt:SENSITIVE = No.
        rpt_licensed = No.
    END.

    IF dbg_licensed AND ade_licensed[{&DBG_IDX}] <> {&INSTALLED} THEN DO:
	btn_dbg:SENSITIVE = No.
        dbg_licensed = No.
    END.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    IF rb_licensed AND ade_licensed[{&RB_IDX}] <> {&INSTALLED} THEN DO:
	btn_rb:SENSITIVE = No.
        rb_licensed = No.
    END.
&ENDIF


    REPEAT ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
        /* 8/6/92 - harris
        ** Enable all widgets inside this loop in case of a compile or
        ** run failure - if a run of a subprocedure fails from within
        ** the trigger, the procedure enable_widgets will not be run,
        ** leaving us hosed....
        */
        IF RETRY THEN RUN enable_widgets.

        ok = Desktop_Window:LOAD-MOUSE-POINTER("":U).
        &IF {&DEBUG} &THEN
        IF NOT ok THEN
            MESSAGE "Cannot change mouse to arrow." 
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        &ENDIF
        /* Make sure the cursor is set to input */
        RUN adecomm/_setcurs.p ("").

        /* Profiler Checkpoint */
        {adeshar/mp.i &timer="DESK_startup" &mp-macro="stotal"
                      &infostr="[_desktop.p] Entered _desktop.p"}
        WAIT-FOR CHOOSE OF MENU-ITEM _Exit IN MENU mnu_File.
        LEAVE.
    END.

    IF initial_hide_setting <> MENU-ITEM mnu_Hide:CHECKED IN MENU mnu_Pref THEN
    DO:
	ASSIGN key_value = 
	     IF MENU-ITEM mnu_Hide:CHECKED IN MENU mnu_Pref = True THEN "yes" 
								   ELSE "no".
        ok = False.
        DO ON ERROR UNDO, LEAVE:
           PUT-KEY-VALUE SECTION "Desktop" KEY "Minimize" 
                         VALUE key_value NO-ERROR.
           ASSIGN ok = NOT ERROR-STATUS:ERROR.
        END.
        IF NOT ok THEN
            RUN adeshar/_puterr.p ( INPUT "Desktop" , INPUT Desktop_Window ).
    END.

    /* 6/21/93 - RCR Send a QUIT Message to the HELP System */
    RUN adecomm/_adehelp.p ( "desk", "QUIT", ?, ? ).

    DELETE WIDGET Desktop_Window.

END. /* desktop.p */

/*-------------------------  INTERNAL PROCEDURES  --------------------------*/

DEFINE VARIABLE save_focus AS WIDGET-HANDLE.

PROCEDURE disable_widgets.

    DEFINE VARIABLE not_debugger AS LOGICAL NO-UNDO.
    
    save_focus = FOCUS.
    not_debugger = NOT ((SELF = mnu_dbg_wh) OR (SELF = btn_dbg:HANDLE IN FRAME Develop)).
    
    /* Unset global active ade tool variable. */
    ASSIGN h_ade_tool = ?.

    CASE SELF:
        WHEN MENU-ITEM mnu_dict:HANDLE IN MENU mnu_Tools THEN
            save_focus = btn_dict:HANDLE IN FRAME Develop.
        WHEN MENU-ITEM mnu_editor:HANDLE IN MENU mnu_Tools THEN
            save_focus = btn_edit:HANDLE IN FRAME Develop.
        WHEN mnu_uib_wh THEN
            save_focus = btn_uib:HANDLE IN FRAME Develop.
        WHEN mnu_dbg_wh THEN
            save_focus = btn_dbg:HANDLE IN FRAME Develop.
    END CASE.

    IF MENU-ITEM mnu_Hide:CHECKED IN MENU mnu_Pref = True THEN
        Desktop_Window:WINDOW-STATE = IF not_debugger THEN WINDOW-DELAYED-MINIMIZE
                                                      ELSE WINDOW-MINIMIZE.

&IF {&TOOL_STACKING} = 1 &THEN
    IF Pref_Enable = NO THEN
&ENDIF
    DO:
        DISABLE ALL WITH FRAME Develop.
        MENU mnb_Desktop:sensitive = NO. 
        /* taken out to conform to mau consistency spec */
        /* ok = Desktop_Window:LOAD-MOUSE-POINTER("WAIT":U).*/
    END.
END.

PROCEDURE enable_widgets.
    /* Set global active ade tool procedure handle to Desktop. */
    ASSIGN h_ade_tool = THIS-PROCEDURE.

    /* Assigning window state to "normal" (restored state) only 
       when the current state is minimized fixes bug 95-04-20-063. */
    ASSIGN CURRENT-WINDOW = Desktop_Window
           Desktop_Window:window-state = WINDOW-NORMAL 
                      WHEN Desktop_Window:window-state = WINDOW-MINIMIZED.
    VIEW FRAME Develop.

&IF {&TOOL_STACKING} = 1 &THEN
    IF Pref_Enable = NO THEN
&ENDIF
    DO:
        ENABLE 
            btn_dict   WHEN dict_licensed AND PROCESS-ARCHITECTURE = 64
            btn_edit   WHEN edit_licensed 
            btn_uib    WHEN uib_licensed 
            btn_rpt    WHEN rpt_licensed 
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
            btn_rb     WHEN rb_licensed 
&ENDIF
            btn_dbg    WHEN dbg_licensed 
            btn_dwb    WHEN dwb_licensed
            btn_ard    WHEN ard_licensed
            WITH FRAME Develop IN WINDOW Desktop_Window.
        MENU mnb_Desktop:sensitive = YES.
        /* taken out to conform to mau consistency spec */
        /* ok = Desktop_Window:LOAD-MOUSE-POINTER("":U). */
   
        /* save focus will be unknown if no tools have been launched
           and ENDKEY is pressed */
        IF VALID-HANDLE(save_focus) THEN APPLY "ENTRY":U TO save_focus.
    END.
END.
 
PROCEDURE NewOpenDatabase.
    Define input parameter mode as integer.

    Define var newdb  as char     NO-UNDO initial ?.
    Define var olddb  as char     NO-UNDO initial ?.
    Define var Db_Pname as char.
    Define var Db_Lname as char.
    Define var Db_Type as char initial ?.

    if mode = 0 then
        run adecomm/_dbcreat.p (INPUT olddb, INPUT-OUTPUT newdb).
    else
        SYSTEM-DIALOG GET-FILE newdb FILTERS "Databases(*.db)" "*.db".      
    if newdb <> ? and newdb <> "" then do:
        Db_Lname = ?.
        Db_Pname = newdb.
        run adecomm/_dbconn.p
            (INPUT-OUTPUT  Db_Pname,
            INPUT-OUTPUT  Db_Lname,
            INPUT-OUTPUT  Db_Type).
        if Db_Lname <> ? then  /* connect succeeded */
        do:
            CREATE ALIAS DICTDB FOR DATABASE value(Db_Lname).
            RUN _RunTool(INPUT "_dict.p").
        end.
        else
            message "Database " + trim(newdb) + " was not opened." 
                view-as alert-box warning buttons ok. 
    end.
END.

PROCEDURE EditorOpenCommonDialog.
    def INPUT-OUTPUT PARAMETER v_GotFile as char no-undo.

    define var Filter_NameString as char extent 5.
    define var Filter_FileSpec   as char extent 5.

    ASSIGN 
        Filter_NameString[ 1 ] = IF OPSYS = "UNIX":U
                                 THEN "All Source(*.[pwi])"
                                 ELSE "All Source(*.p~;*.w~;*.i)"
        Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX":U
                                 THEN "*.[pwi]"
                                 ELSE "*.p~;*.w~;*.i"

        Filter_NameString[ 2 ] = "Procedures(*.p)"
        Filter_FileSpec[ 2 ]   = "*.p"

        Filter_NameString[ 3 ] = "Windows(*.w)"
        Filter_FileSpec[ 3 ]   = "*.w"

        Filter_NameString[ 4 ] = "Includes(*.i)"
        Filter_FileSpec[ 4 ]   = "*.i"

        Filter_NameString[ 5 ] = IF OPSYS = "UNIX":U
                                 THEN "All Files(*)"
                                 ELSE "All Files(*.*)"
        Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX":U
                                 THEN "*"
                                 ELSE "*.*".

    SYSTEM-DIALOG GET-FILE v_GotFile FILTERS
        Filter_NameString[ 1 ]  Filter_FileSpec[ 1 ],
        Filter_NameString[ 2 ]  Filter_FileSpec[ 2 ],
        Filter_NameString[ 3 ]  Filter_FileSpec[ 3 ],
        Filter_NameString[ 4 ]  Filter_FileSpec[ 4 ],
        Filter_NameString[ 5 ]  Filter_FileSpec[ 5 ].
END.

/* PROCEDURE LicenseMsg
*/

PROCEDURE LicenseMsg.

    DEFINE INPUT PARAMETER err AS INTEGER.
    DEFINE INPUT PARAMETER msg AS CHAR.

    CASE err:
    WHEN 1 OR WHEN 3 THEN 
        MESSAGE "A license for" msg "is not available."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    WHEN 2 THEN 
        MESSAGE "Your copy of the" msg "is past it's expiration date."
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    OTHERWISE.
    END CASE.

END PROCEDURE.


/* From adecomm/_runcode.p.  Internal Procedures used to manage orphaned
   persistent procedures after a debugger session from desktop.
*/
PROCEDURE BuildPersistProc.
  /* Build a work-table of existing Persistent Procedures. After user's
     code runs, any ones in addition to these are user created and
     will be deleted before ending.
  */
  DEFINE VARIABLE hProcedure  AS HANDLE  NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    CREATE PersistProc.
    ASSIGN PersistProc.hProc = hProcedure
           hProcedure        = hProcedure:NEXT-SIBLING.
  END.

END PROCEDURE.


PROCEDURE DeletePersistProc.
  /* Delete user-created Persistent Procedures by deleting the ones not
     in the work-table (ie, not present before running user's code.
  */
  DEFINE VARIABLE hProcedure  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE Delete_Proc AS HANDLE  NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    FIND FIRST PersistProc WHERE PersistProc.hProc = hProcedure NO-ERROR.
    IF NOT AVAILABLE PersistProc THEN
      ASSIGN Delete_Proc = hProcedure.
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
    IF VALID-HANDLE( Delete_Proc ) THEN
      DELETE PROCEDURE Delete_Proc .    
  END.

END PROCEDURE.




