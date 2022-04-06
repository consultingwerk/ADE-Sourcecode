/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: sharvars.i

Description:
    Include file that contains all the "global" or shared variables.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter 

Date Created: 1992 

Modified by gfs on 12/18/96 - Changed _h_Controls to COM-HANDLE
                              Added _ocx_draw
            tsm on 04/05/99 - Added _numeric_decimal and 
                              _numeric_separator for support of various
                              Intl Numeric formats (in addition to
                              American and European)  
            tsm on 05/11/99 - Added _mru_filelist and _mru_entries for
                              support of AppBuilder MRU FileList
            tsm on 05/12/99 - Added _print_page_length, _print_font and
                              _print_dialog for support of print 
                              preferences
            tsm on 05/14/99 - Removed _numeric_format in support of 
                              various Intl Numeric formats
            tsm on 06/24/99 - Added _mru_broker_url
            jep on 08/09/01 - jep-icf: Added _AB_Tools and _h_menubar_proc for icf.
            jep on 09/25/01 - jep-icf: Added ICF custom files handling. Search on
                              _custom_files_savekey and _custom_files_default.
            jep on 10/10/01 - jep-icf IZ 2101 Run button enabled when editing
                              dynamic objects. Var h_button_bar renamed to
                              _h_button_bar and moved here from uibmdefs.i.
            drh on 05/09/03 - Added _DynamicsIsRunning which is set early in 
                              adeuib/_uibmain.p
----------------------------------------------------------------------------*/
{adeuib/pre_proc.i}

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
&IF "{1}" = "NEW" &THEN
&SCOPED-DEFINE NEWGLOB NEW GLOBAL
&ENDIF

DEFINE {1} SHARED VAR _AB_license     AS INTEGER                    NO-UNDO.
       /* _AB_license      is 1 when only UIB is licensed, 2 when only   */
       /*                  WebSpeed is licensed and 3 when both are      */
       /*                  licensed.                                     */

DEFINE {1} SHARED VAR _AB_Tools       AS CHARACTER                  NO-UNDO.  /* jep-icf */
       /* _AB_Tools        Comma list of "UIB,Workshop,Enable-ICF"       */
       /*                  Used in conjunction with _AB_license          */

DEFINE {1} SHARED VAR _auto_check     AS LOGICAL INITIAL FALSE      NO-UNDO
                               VIEW-AS TOGGLE-BOX LABEL "Auto Syntax Check".
       /* _auto-check      is a user preference on whether trigger code  */
       /*                  is automatically checked for syntax errors    */
       /*                  when the trigger editor stores the code       */

DEFINE {1} SHARED VAR _BrokerUrl     AS CHARACTER                   NO-UNDO.
       /* _BrokerUrl       is the URL of the WebSpeed broker currently   */
       /*                  being used.                                   */

DEFINE {&NEWGLOB} SHARED VAR _comp_temp_file  AS CHARACTER INITIAL ? NO-UNDO.
       /* _comp_temp_file  is the temporary file used for compilation    */
       /*                  formally known as UIB_last                    */

DEFINE {1} SHARED VAR _control_cut_file AS CHARACTER                NO-UNDO.
       /* _control_cut_file is the name of cut file to hold the ocx      */
       /*                   binary information during cut/copy           */

DEFINE {1} SHARED VAR _control_cb_op AS LOGICAL     INITIAL FALSE   NO-UNDO.
       /* _control_cb_op   is this op going to the clipboard             */

DEFINE {1} SHARED VAR _count          AS INTEGER                    NO-UNDO
                                      EXTENT {&WIDGET-COUNT-DIMENSION}.
       /* _count           is the array of counts of how many widgets of */
       /*                  each type have been created.  These counts    */
       /*                  used to generate unique widget names.         */

DEFINE {1} SHARED VAR _cur_col_mult   AS DECIMAL  INITIAL 1.0       NO-UNDO.
       /*  _cur_col_mult   TTY simulators have wider columns             */
       /*         than GUI mode - this  is the multiplier       */
       /*                  showing this expansion (usually 1.2)          */

DEFINE {1} SHARED VAR _cur_row_mult   AS DECIMAL  INITIAL 1.0       NO-UNDO.
       /*  _cur_row_mult   TTY simulators shows rows closer together     */
       /*         than GUI mode - this  is the multiplier       */
       /*                  showing this compression (usually 0.62)       */

DEFINE {1} SHARED VAR _cur_user_id    AS CHAR   FORMAT "X(8)"       NO-UNDO
                  INITIAL "0000001".
       /* _cur_user_id     is the id of the current user which lets us   */
       /*                  access information in the uib_prefs record.   */

DEFINE {1} SHARED VAR _cur_win_type   AS LOGICAL INITIAL ?          NO-UNDO
                                      LABEL "Window Type".
       /* _cur_win_type    is true if we are working in GUI mode and     */
       /*                  false if we are in TTY mode                   */

DEFINE {1} SHARED VAR _custom_draw   AS CHAR     INITIAL ?        NO-UNDO.
       /* _custom_draw     is the name of custom object to be drawn      */
       /*                  next.  custom_draw is ? if no custom widget   */
       /*                  has been selected (NOTE: _next_draw is the    */
       /*                  TYPE of the next widget to draw).             */

DEFINE {1} SHARED VAR _custom_files_default   AS CHAR     NO-UNDO.
       /* _custom_files_default is the list of the session's default     */
       /*                  custom files (.cst). Initialized in _getpref.p. */

DEFINE {1} SHARED VAR _custom_files_savekey   AS CHAR     NO-UNDO.
       /* _custom_files_savekey is the registry/ini save location for    */
       /*                  the custom files list used to build the object*/
       /*                  palette. Initialized in _getpref.p.           */

DEFINE {1} SHARED VAR _db_name         AS CHARACTER                 NO-UNDO.
       /* _db_name         is the name of the schema picker  selected    */
       /*                  data base                                     */

DEFINE {1} SHARED VAR _dblclick_section_ed AS LOGICAL               NO-UNDO.
       /* _dblclick_section_ed is the switch to determine if a property  */
       /*                  sheet or the section editor should come up on */
       /*                  the double click of and object.               */

DEFINE {1} SHARED VAR _DynamicsIsRunning AS LOGICAL                 NO-UNDO.
       /* _DynamicsIsRunning is a flag for the AppBuilder that is TRUE   */
       /*                  if and only if Dynamics is running when the   */
       /*                  AppBuilder is started.                        */

DEFINE {1} SHARED VAR _multiple_section_ed AS LOGICAL               NO-UNDO.
       /* _multiple_section_ed is the switch to determine if multiple    */
       /*                  section editors will be displayed.  Default   */
       /*                  is FALSE.                                     */

DEFINE {1} SHARED VAR _default        AS RECID   INITIAL ?          NO-UNDO
                                      EXTENT {&WIDGET-COUNT-DIMENSION}.
       /* _default         is the array of RECIDs of the default widget  */
       /*                  of each type.  The default widget is used as  */
       /*                  a template for new widgets of that type.      */

DEFINE {1} SHARED VAR _default_function_type AS CHARACTER           NO-UNDO
                                      INITIAL "CHARACTER".
       /* _default_function_type determines what the default return type */
       /*                  is when creating a new function in the        */
       /*                  section editor.                               */

DEFINE {1} SHARED VAR _default_tabbing AS CHAR INITIAL "L-to-R":U   NO-UNDO.
       /* _default_tabbing decides how to compute the default tabbing in */
       /*                  frames and dialog-boxes                       */

DEFINE {1} SHARED VAR _directory       AS CHARACTER                 NO-UNDO
                                       EXTENT {&DIR-DIMENSION}.
       /* _directories     Array of directory lists that we want to      */
       /*                  save.  Including: icon directory, template    */
       /*                  directory, .wx file directory etc.            */

DEFINE {1} SHARED VAR _dyn_cst_template AS CHARACTER                 NO-UNDO.
       /* Contains a list of all dynamic template objects */

DEFINE {1} SHARED VAR _dyn_cst_palette AS CHARACTER                 NO-UNDO.       
       /* Contains a list of all dynamic palette objects */

DEFINE {1} SHARED VAR _err_msg         AS CHARACTER                 NO-UNDO.
       /* _err_msg         is the first error message from the last      */
       /*                  compile attempt                               */

DEFINE {1} SHARED VAR _err_recid       AS RECID INITIAL ?           NO-UNDO.
       /* _err_recid       is the record ID of the trigger temptable     */
       /*                  record containing the trigger code that       */
       /*                  caused the compiler to choke.                 */

DEFINE {1} SHARED VAR _file_new_config AS INTEGER                   NO-UNDO.
       /* _file_new_config holds the configuration information of the    */
       /*                  toggles in the File->New dialog. This is the  */
       /*                  sum of these bits: 1 Containers toggle is on, */
       /*                  2 SmartObjects toggle is on, 4 Procedures     */
       /*                  toggle is on, and 8 WebObjects toggle is on   */

DEFINE {1} SHARED VAR _fl_name         AS CHARACTER                 NO-UNDO.
       /* _fl_name         is the name of the schema picker selected     */
       /*                  file.                                         */

DEFINE {1} SHARED VAR _fld_names       AS CHARACTER                 NO-UNDO.
       /* _fld_names       are the names of schema picker slected fields */

DEFINE {1} SHARED VAR _frmx            AS INTEGER                   NO-UNDO.
       /* _frmx            is the x-position within the frame where      */
       /*                  the object will be drawn                      */

DEFINE {1} SHARED VAR _frmy            AS INTEGER                   NO-UNDO.
       /* _frmy            is the y-position within the frame where      */
       /*                  the object will be drawn                      */

DEFINE {1} SHARED VAR _h_button_bar    AS WIDGET-HANDLE EXTENT 20   NO-UNDO.  /* jep-icf */
       /* _h_button_bar    is the toolbar button widget list array used   */
       /* icf IZ 2101      to enable and disable AB toolbar buttons.      */

DEFINE {1} SHARED VAR _h_func_lib      AS HANDLE                    NO-UNDO.
       /* _h_func_lib      is the handle of the persistent procedure     */
       /*                  holds all the functions to be used throughout */
       /*                  the AppBuilder                                */

DEFINE {1} SHARED VAR _h_controls      AS COMPONENT-HANDLE          NO-UNDO.
       /* _h_control      is the handle of the PROX.PROIDE COM object */

DEFINE {1} SHARED VAR _h_cur_widg      AS WIDGET-HANDLE             NO-UNDO.
       /* _h_cur_widg      is the handle of the currently active widget  */

DEFINE {1} SHARED VAR _h_frame         AS WIDGET-HANDLE             NO-UNDO.
       /* _h_frame         is the handle of the currently selected frame */

DEFINE {1} SHARED VAR _h_mlmgr         AS HANDLE                    NO-UNDO.
       /* _h_mlmgr         is the procedure handle of the Meth Lib Mgr.  */

DEFINE {1} SHARED VAR _h_menubar_proc  AS HANDLE                    NO-UNDO.  /* jep-icf */
       /* _h_menubar_proc  is the handle of the menubar procedure that   */
       /*                  replaces the default AB menu bar with ICF one.*/

DEFINE {1} SHARED VAR _h_menu_win      AS WIDGET-HANDLE             NO-UNDO.
       /* _h_menu_win      is the handle of the menu window containing   */
       /*                  the main bar menu and the action icons        */

DEFINE {1} SHARED VAR _h_object_win    AS WIDGET-HANDLE             NO-UNDO.
       /* _h_object_win    is the handle of the menu window containing   */
       /*                  then object icons.                            */

DEFINE {1} SHARED VAR _h_status_line   AS WIDGET-HANDLE             NO-UNDO.
       /* _h_status_line   is the handle of the frame containing the 
                           status line                                   */

DEFINE {1} SHARED VAR _h_uib          AS WIDGET-HANDLE             NO-UNDO.
       /* _h_uib           is the handle of the UIB's main procedure.    */
       /*                  (_h_win:FILE-NAME = "adeuib/_uibmain.p")      */

DEFINE {1} SHARED VAR _h_win           AS WIDGET-HANDLE             NO-UNDO.
       /* _h_win           is the handle of the currently selected       */
       /*                  window                                        */

DEFINE {1} SHARED VAR _h_WinMenuMgr    AS HANDLE                    NO-UNDO.
       /* _h_WinMenuMgr    is the procedure handle of the Window Menu    */
       /*                  Mgr Object for Active UIB windows.            */

DEFINE {1} SHARED VAR _h_WindowMenu    AS HANDLE                    NO-UNDO.
       /* _h_WindowMenu    is the procedure handle of the Window menu.   */

DEFINE {1} SHARED VAR _h_CodeRefs      AS HANDLE                    NO-UNDO.
       /* _h_CodeRefs      is the procedure handle of the code references*/
       /*                  window.                                       */

DEFINE {1} SHARED VAR _LocalHost       AS CHAR                      NO-UNDO.
       /* _LocalHost       is the name of the Windows 95/98/NT machine   */
       /*                  is running.                                   */    

DEFINE {1} SHARED VAR _minimize_on_run AS LOGICAL INITIAL no        NO-UNDO.
       /* _minimize_on_run Minimize the UIB Main Window when the user    */
       /*                  chooses the run option.                       */

DEFINE {1} SHARED VAR _mru_broker_url  AS CHARACTER INITIAL ""      NO-UNDO.
       /* _mru_broker_url  Stores the broker url for a remote file being */
       /*                  opened from the MRU File list, it is used to  */
       /*                  open the file from the broker it was saved to */
       /*                  which could be different from the current url */

/*    Shared variables used to store the most recently used filelist
      preferences */
DEFINE {1} SHARED VAR _mru_filelist    AS LOGICAL INITIAL no        NO-UNDO.
       /* _mru_filelist    A most recently used file list is maintained  */
       /*                  in the AppBuilder file menu                   */

DEFINE {1} SHARED VAR _mru_entries     AS INTEGER  INITIAL 0        NO-UNDO.
       /* _mru_entries     The number of files to keep in the most       */
       /*                  recently used file list                       */

DEFINE {1} SHARED VAR _next_draw       AS CHAR     INITIAL ?        NO-UNDO.
       /* _next_draw       is the type of object to be drawn next.       */
       /*                  next-draw is ? if nothing has been selected   */

DEFINE {1} SHARED VAR _numeric_decimal  AS CHAR                     NO-UNDO. 
       /* _numeric_decimal  is any character allowed by the 4GL to       */
       /*                   represent the decimal point, it is set in    */
       /*                   one of three ways 1) -numdec startup option, */
       /*                   2) setting SESSION:NUMERIC-DECIMAL-POINT, or */
       /*                   3) if NUMERIC-FORMAT is "AMERICAN", this is  */
       /*                   "." and if NUMERIC-FORMAT is "EUROPEAN", it  */
       /*                   is ",".  There are many various places in    */
       /*                   the ADE tools where this is changed back to  */
       /*                   the user's setting after NUMERIC-FORMAT is   */
       /*                   changed to "AMERICAN" for generating 4GL and */
       /*                   compiling code                               */

DEFINE {1} SHARED VAR _numeric_separator  AS CHAR                   NO-UNDO.
       /* _numeric_separator  is any character allowed by the 4GL to     */
       /*                     represent the thousands separator, it is   */
       /*                     set in one of three ways 1) -numsep        */
       /*                     startup option, 2) setting                 */
       /*                     SESSION:NUMERIC-SEPARATOR, or 3) if        */
       /*                     NUMERIC-FORMAT is "AMERICAN", this is ","  */
       /*                     and if NUMERIC-FORMAT is "EUROPEAN", it is */
       /*                     ".".  There are various places in the ADE  */
       /*                     tools where this is changed back to the    */
       /*                     user's setting after NUMERIC-FORMAT is     */
       /*                     changed to "AMERICAN" for generating 4GL   */
       /*                     and compiling code                         */       

DEFINE {1} SHARED VAR _ocx_draw   AS COMPONENT-HANDLE               NO-UNDO.
       /* _object_draw      is the ocx chosen via OCX dialog-box   */

DEFINE {1} SHARED VAR _object_draw   AS CHAR       INITIAL ?        NO-UNDO.
       /* _object_draw      is the filename of a SmartObject to be drawn */

DEFINE {1} SHARED VAR _open_new_browse AS LOGICAL                   NO-UNDO.
       /* _open_new_browse  is the variable that determines whether or   */
       /*                   not to reuse the existing browse window.     */

DEFINE {1} SHARED VAR _orig_dte_fmt    AS CHARACTER                 NO-UNDO.
       /* _orig_dte_fmt    is the date format specified on the command   */
       /*                  line.  Internally to the UIB it is set to     */
       /*                  "mdy" to give the UIB the same behavior as    */
       /*                  the compiler.                                 */

DEFINE {1} SHARED VAR _palette_choice AS RECID    INITIAL ?        NO-UNDO.
       /* The recid of the palette item (not custom)currently selected   */

DEFINE {1} SHARED VAR _palette_count   AS INTEGER                   NO-UNDO.
       /* _palette_count   number of items on the object palette         */

DEFINE {1} SHARED VAR _palette_custom_choice AS RECID    INITIAL ?  NO-UNDO.
       /* The recid of the custom item currently selected   */

DEFINE {1} SHARED VAR _palette_labels  AS LOGICAL                   NO-UNDO.
       /* _palette_labels  does the palette display labels? yes/no       */

DEFINE {1} SHARED VAR _palette_menu    AS LOGICAL                   NO-UNDO.
       /* _palette_menu  does the palette display only the menu? yes/no  */

DEFINE {1} SHARED VAR _palette_top     AS LOGICAL                   NO-UNDO.
       /* _palette_top  is the palette display top-only? yes/no          */

DEFINE {1} SHARED VAR _print_pg_length AS INTEGER                   NO-UNDO.
       /* _print_pg_length   determines the page length for printing 
                             procedures and sections of procedures       */

DEFINE {1} SHARED VAR _print_font      AS INTEGER                   NO-UNDO.
       /* _print_font        determines the font used when printing      */

DEFINE {1} SHARED VAR _print_dialog    AS LOGICAL                   NO-UNDO.
       /* _print_dialog      determines if the print dialog is used
                             when printing                               */

DEFINE {1} SHARED VAR _remote_file     AS LOGICAL                   NO-UNDO.
       /* _remote_file     is the option that determines if File Open    */
       /*                  and Save As defaults to a local disk (false)  */
       /*                  or a remote WebSpeed agent (true).            */

DEFINE {1} SHARED VAR _query-u-rec     AS RECID                     NO-UNDO.
       /* _query-i-rec     is the recid of the _U record for the browse  */
       /*                  that has an attached query                    */

DEFINE {1} SHARED VAR _save_file       AS CHARACTER                 NO-UNDO.
       /* _save_file       is the file-name (8 + .w = 10 chars) of       */
       /*                  .w file being edited                          */

DEFINE {1} SHARED VAR _save_mode       AS CHARACTER                 NO-UNDO.
       /* _save_mode       is a comma-separated list of T/F settings in  */
       /*                  affect when save/save as is selected.  Entry  */
       /*                  1 is ask_file_name, 2 is (_remote_file AND    */
       /*                  NOT ask_file_name AND _save_file eq ?).  See  */
       /*                  adeuib/uibmproe.i for example.                */

DEFINE {1} SHARED VAR _second_corner_x AS INTEGER                   NO-UNDO.
       /* _second_corner_x is the x co-ordinate when the user releases   */
       /*                  the mouse button while drawing a box.         */

DEFINE {1} SHARED VAR _second_corner_y AS INTEGER                   NO-UNDO.
       /* _second_corner_y is the y co-ordinate when the user releases   */
       /*                  the mouse button while drawing a box.         */

DEFINE {1} SHARED VAR _sp_last_drawn   AS INTEGER                   NO-UNDO.
       /* _sp_last_drawn   is the last item in the schema picker list of */
       /*                  field names that was drawn.  sp_last_drawn is */
       /*                  set to 0 when a new list is selected          */

DEFINE {1} SHARED VAR _suppress_dbname AS LOGICAL                   NO-UNDO.
       /* _suppress_dbname is the option that causes the suppression     */
       /*                  of the database name when writing database    */
       /*                  fields into the UIB 4GL output code           */

DEFINE {1} SHARED VAR _suppress_dict_view-as AS LOGICAL             NO-UNDO.
       /* _suppress_dict_view-as is the option that determines whether   */
       /*                  or not write out the view-as phrase of a      */
       /*                  table field that is defined with a view-as    */
       /*                  phrase in the data dictionary.                */

DEFINE {1} SHARED VAR _tt_log_name    AS CHAR
                                 INITIAL "TEMP-TABLES,TEMP-DB"      NO-UNDO.
       /* _tt_log_name     is the logical name of the database holding   */
       /*                  temp-table definitions                        */

DEFINE {1} SHARED VAR _tty_bgcolor    AS INTEGER   INITIAL 0        NO-UNDO.
       /*  _tty_bgcolor    TTY simulators use this background color      */

DEFINE {1} SHARED VAR _tty_col_mult    AS DECIMAL  INITIAL 1.0      NO-UNDO.
       /*  _tty_row_mult   TTY simulators shows columns differently      */
       /*                  than GUI mode - this  is the multiplier       */
       /*                  showing this expansion (usually 1.2)          */

DEFINE {1} SHARED VAR _tty_fgcolor    AS INTEGER   INITIAL 10       NO-UNDO.
       /*  _tty_fgcolor    TTY simulators use this foreground color      */

DEFINE {1} SHARED VAR _tty_font       AS INTEGER   INITIAL 3        NO-UNDO.
       /*  _tty_font       TTY simulators use this font                  */

DEFINE {1} SHARED VAR _tty_row_mult    AS DECIMAL  INITIAL 1.0      NO-UNDO.
       /*  _tty_row_mult   TTY simulators shows rows closer together     */
       /*                  than GUI mode - this  is the multiplier       */
       /*                  showing this compression (usually 0.62)       */

DEFINE {1} SHARED VAR _visual-obj      AS LOGICAL  INITIAL yes      NO-UNDO.
       /*  _visual-obj     True if the "current procedure" has a         */
       /*                  visualization, otherwise false                */

DEFINE {1} SHARED VAR _wid-list        AS CHAR                      NO-UNDO
       INITIAL "BROWSE,BUTTON,COMBO-BOX,DIALOG-BOX,EDITOR,FILL-IN,FRAME,IMAGE,~
MENU,SUB-MENU,MENU-ITEM,QUERY,RADIO-SET,RECTANGLE,SELECTION-LIST,SLIDER,~
SmartObject,TOGGLE-BOX,TEXT,{&WT-CONTROL},WINDOW".
       /* _wid-list        is the list of widget types to be displayed   */
       /*                  in the widget browser                         */

DEFINE {1} SHARED VAR _widgetid_assign  AS LOGICAL                   NO-UNDO.
       /* _widgetid_assign   determines whether to assign widget IDs     */
       /*                    automatially                                */ 

DEFINE {1} SHARED VAR _widgetid_start   AS INTEGER                   NO-UNDO.
       /* _widgetid_start    starting widget ID value                    */

DEFINE {1} SHARED VAR _widgetid_increment AS INTEGER                 NO-UNDO.
       /* _widgetid_increment  widget ID increment value                 */

DEFINE {1} SHARED VAR _widgetid_save_filename     AS LOGICAL         NO-UNDO.
       /* _widgetid_assign   determines whether to save the widget-id    */
       /*                    file name automatially                      */ 

DEFINE {1} SHARED VAR _widgetid_default_filename  AS LOGICAL         NO-UNDO.
       /* _widgetid_assign   determines whether the widget-id file name  */
       /*                    is the default value                        */ 

DEFINE {1} SHARED VAR _widgetid_custom_filename   AS CHARACTER       NO-UNDO.
       /* _widgetid_assign   the custom name of the widget-id file name. */
       /*                    The default value is blank.                 */

DEFINE {1} SHARED VAR _UIB_VERSION    AS CHAR   INITIAL "AB_v10r12"  NO-UNDO.  
       /*  _UIB_VERSION      UIB Verson Number                           */
       /*    7.1A002  (WTW 2/8/93)  Added Code Sections                  */
       /*    UIB_v7r2 (WTW 2/18/93) Added Default Procedures             */
       /*    UIB_v7r3 (WTW 3/29/93) _Top-of-file renamed _DEFINITIONS    */   
       /*    UIB_v7r4 (WTW 4/24/93) SPECIAL comments                     */
       /*    UIB_v7r5 (DRH 5/17/93) Improved comments                    */   
       /*    WB_v7r6  (DRH 5/28/93) Changed UIB to WB everywhere         */   
       /*    UIB_v7r7 (DRH 6/17/93) Changed WB to UIB everywhere         */   
       /*    UIB_v7r8 (WTW 7/9/93)  Specify Widgets frames "IN FRAME x"  */   
       /*    UIB_v7r9 (GJO 7/20/93) CHanged Browse Order info format     */   
       /*    UIB_v7r10 (WTW 1/12/94) Default to DISPLAY on read          */   
       /*    UIB_v7r11 (DRH 12/28/94) Browse JoinCode offset corrected   */   
       /*    UIB_v8r1  (DRH 6/14/95)  Browse JoinCode offset corrected   */   
       /*    UIB_v8r2  (DRH 7/19/95)  Freeform Open Query Change         */   
       /*    UIB_v8r11 (WTW 7/29/96)  Tab Editor Change                  */ 
       /*               NOTE: v8.0a loads UIB_v8r3 to r9 with no error   */
       /*               That is why we need to skip to r11               */
       /*    UIB_v8r12 (GFS 1/09/97)  Added Temp-table support           */
       /*    AB_v9r12  (DRH 3/06/98) Moving upto V9                      */
       /*    AB_v10r12 (DB  11/05/03) Moving to V10                      */

DEFINE {1} SHARED VAR _WebBrowser   AS CHARACTER INITIAL ?          NO-UNDO.
       /* _WebBrowser    is the name of the web browser to use to call   */
       /*                the Technical Services web page                 */ 

DEFINE {1} SHARED VAR s_tmp-file    AS CHARACTER.
       /* s_tmp-file     is the variable that holds the temporary        */
       /*                filename of the procedure that is to be run     */ 
       /*                testing tty-mode                                */

DEFINE {1} SHARED VAR Stop_Button   AS WIDGET-HANDLE                NO-UNDO.
       /* Stop_Button    is the handle of the UIB Stop Button            */

DEFINE {1} SHARED VAR xPalette      AS HANDLE                       NO-UNDO.
       /* xPalette       is currently not used but is the procedure      */
       /*                handle for a persistent procedure of a palette  */
       /*                of non-inline XFTRs                             */

DEFINE {1} SHARED VAR web-tmp-file    AS CHARACTER                  NO-UNDO.
       /* web-tmp-file   is the variable that holds the temporary        */
       /*                filename used for remote file management        */ 

/* Section Editor Window Shared Vars. */
DEFINE {1} SHARED VARIABLE   se_section  AS CHARACTER               NO-UNDO.
       /* se_section     is a section type like _CONTROL, _PROCEDURE,    */
       /*                etc. of the current section in the section ed.  */

DEFINE {1} SHARED VARIABLE   se_recid    AS RECID                   NO-UNDO.
       /* se_recid       is recid of the recid of the current _trg */

DEFINE {1} SHARED VARIABLE _p_status     AS CHARACTER               NO-UNDO.
       /* _p_status      same purpose as p_status in gen4gl      */
       /*                so far only used for syntax check       */

DEFINE {1} SHARED VARIABLE _iTabOrder    AS INTEGER                 NO-UNDO
                                            INITIAL 100000.
       /* _iTabOrder     Used to set _TAB-ORDER for non field-level */
       /*                widgets when they're read in.              */

&IF DEFINED(SE_Name) = 0 &THEN
/* This is defined as a shared object in _sewin.w. We must preprocess
   out the DEFINE SHARED or we get a duplicate var name error when
   compiling adeuib/_semain.w.
*/
DEFINE {1} SHARED VARIABLE   se_event    AS CHARACTER               NO-UNDO.
       /* se_evnt        is the name of the current section editor code  */
       /*                block. eg. LEAVE, CHOOSE, proc-name             */

&ENDIF


/*    Temp-Table definitions for UIB preference settings. */

DEFINE {1} SHARED TEMP-TABLE _uib_prefs                             NO-UNDO
    FIELD _user_dfltwindow      AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Create a Default &Window at Startup"
    FIELD _user_advisor         AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Display &Advisor Messages"
    FIELD _user_hints           AS LOGICAL      INITIAL TRUE
                                VIEW-AS TOGGLE-BOX
                                LABEL "Display &Cue Cards"
    .

