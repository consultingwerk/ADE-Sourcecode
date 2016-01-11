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
/*----------------------------------------------------------------------------

File: _getpref.p

Description:
   Loads user preferences using the GET-KEY-VALUE syntax.  Note the Section
   of the file used depends on the value of {&UIB_SHORT_NAME} at compile time.

Input Parameters:
   <None>
Output Parameters:
   p_save_settings - TRUE if SaveSettings parameter is not false.

Author:  Wm.T.Wood

Date Created: November 16, 1992 

Last modifed on 9/29/94  by GFS - Added XFTR file support
                12/17/97 by GFS - Added WebBrowser support
                03/14/97 by GFS - Added PropertyEditorLocation support
                11/06/97 by RDE - Added UIBMainLocation support
                03/13/98 by GFS - Made default template & cst lists conditional
                                  on product installed.
                03/24/98 by SLK - Changed sdo.cst to shared.cst
                03/31/98 by SLK - Changed order for C/S shared.cst, smart.cst, 
                                  progress.cst so that smartContainers are on top
                04/01/98 by GFS - Moved ActiveX controls to Active.cst 
                04/17/98 by HD  - Moved WebBrowser preferences to aduib/_getwebp.p 
                                  Because this is needed also outside the
                                  uib whenever a web browser should be started.                                     
                                  In those cases the sharvars is defined new 
                                  locally, and will NOT be stored for the
                                  session. 
                                  (would an include b better ?) 
                04/07/99 by TSM - Added support for various Intl Numeric Formats 
                                  (in addition to American and European) by using
                                  session set-numeric-format method to set 
                                  format back to user's setting after setting it
                                  to American.  
                05/04/99 by TSM - Added MostRecentlyUsedFileList, MRUEntries,
                                  MRUFile1-9 and MRUBrokerURL1-9 keys for AppBuilder 
                                  MRU File List 
                05/12/99 by TSM - Added PrintPageLength, PrintFont and PrintDialog
                05/25/99 by TSM - Made MRU Filelist true as default
                09/25/01 by JEP - jep-icf: ICF custom files handling.
                11/14/01 by JEP - jep-icf: Added web.cst to ICF custom files default list.
                                  Done via IZ 2845.
----------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER p_save_settings    AS LOGICAL                NO-UNDO.

{adeuib/tool.i}       /* Include this 1st - Defines &TOOL */
{adeuib/sharvars.i}   /* Shared variables                 */
{adeuib/gridvars.i}   /* Shared grid and layout variables */
{adeuib/advice.i}     /* Shared Advisor variables         */
{adecomm/adefext.i}   /* Defines Preprocessor variables   */
{adeshar/mrudefs.i}   /* Defines MRU filelist temp table */

/* NOTE: when we set directory/path information, user the appropriate
   SLASH under that is platform depentant */
&IF LOOKUP(OPSYS, "MSDOS,WIN32":u) = 0 
&THEN &Scoped-define SLSH /
&ELSE &Scoped-define SLSH ~~~\
&ENDIF

/* Default values for some settings. */
&Scope DEFAULT-TEMPLATE-DIRS-CS-ONLY src{&SLSH}template,src{&SLSH}adm2{&SLSH}template
&Scope DEFAULT-TEMPLATE-DIRS-WS-ONLY src{&SLSH}template,src{&SLSH}adm2{&SLSH}template,src{&SLSH}web{&SLSH}template
&Scope DEFAULT-TEMPLATE-DIRS-BOTH    src{&SLSH}template,src{&SLSH}adm2{&SLSH}template,src{&SLSH}web{&SLSH}template
&Scope DEFAULT-CUSTOM-FILES-CS-ONLY  src{&SLSH}template{&SLSH}activex.cst,src{&SLSH}template{&SLSH}shared.cst,src{&SLSH}template{&SLSH}smart.cst,src{&SLSH}template{&SLSH}progress.cst
&Scope DEFAULT-CUSTOM-FILES-WS-ONLY  src{&SLSH}template{&SLSH}shared.cst,src{&SLSH}template{&SLSH}web.cst
&Scope DEFAULT-CUSTOM-FILES-BOTH     src{&SLSH}template{&SLSH}activex.cst,src{&SLSH}template{&SLSH}shared.cst,src{&SLSH}template{&SLSH}smart.cst,src{&SLSH}template{&SLSH}progress.cst,src{&SLSH}template{&SLSH}web.cst
&Scope DEFAULT-CUSTOM-FILES-ICF-ONLY src{&SLSH}template{&SLSH}activex.cst,src{&SLSH}template{&SLSH}icfshared.cst,src{&SLSH}template{&SLSH}icfdyn.cst,src{&SLSH}template{&SLSH}icfsmart.cst,src{&SLSH}template{&SLSH}icfprogress.cst,src{&SLSH}template{&SLSH}web.cst

/* Local Variables */
DEFINE VAR  cnt           AS INTEGER NO-UNDO.
DEFINE VAR  i_v           AS INTEGER NO-UNDO.
DEFINE VAR  v             AS CHAR NO-UNDO.
DEFINE VAR  vbroker       AS CHAR NO-UNDO.
DEFINE VAR sctn           AS CHAR NO-UNDO.
DEFINE VAR mru_count      AS INTEGER NO-UNDO.
DEFINE VAR keyname        AS CHAR NO-UNDO.

/*
** NOTE: Force format type to "AMERICAN".  Once done, swap back
*/
SESSION:NUMERIC-FORMAT = "AMERICAN".
    
/* jep-icf: Setup registry/ini key for saving custom files and the default custom files list. */
IF CAN-DO(_AB_Tools, "Enable-ICF":u) THEN
DO:
  _custom_files_savekey = "CustomObjectFilesICF":u.
  _custom_files_default = "{&DEFAULT-CUSTOM-FILES-ICF-ONLY}".
END.
ELSE
DO:
  _custom_files_savekey = "CustomObjectFiles":u.
  CASE _AB_license:
    WHEN 1 THEN _custom_files_default = "{&DEFAULT-CUSTOM-FILES-CS-ONLY}" .
    WHEN 2 THEN _custom_files_default = "{&DEFAULT-CUSTOM-FILES-WS-ONLY}" .
    WHEN 3 THEN _custom_files_default = "{&DEFAULT-CUSTOM-FILES-BOTH}" .
  END CASE.
END.

FIND FIRST _uib_prefs NO-ERROR.
IF NOT AVAILABLE _uib_prefs THEN CREATE _uib_prefs.

USE "" NO-ERROR.  /* Make sure that we are using the startup defaults file */

/* Define the section. */
sctn = "Pro":U + CAPS("{&TOOL}":U).

/* Read in the Logical values - most things are TRUE except SaveSettings
   and MinimizeOnRun.  In 7.3A, AutoDefaultWindow was changed to FALSE. */
/* Default FALSE settings */
GET-KEY-VALUE SECTION sctn KEY "SaveSettings" VALUE v.
  p_save_settings = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
GET-KEY-VALUE SECTION sctn KEY "AutoDefaultWindow" VALUE v.
  _uib_prefs._user_dfltwindow = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
GET-KEY-VALUE SECTION sctn KEY "MinimizeOnRun" VALUE v.
  _minimize_on_run = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
/* Default TRUE settings */
GET-KEY-VALUE SECTION sctn KEY "QualifyFieldsWithDBName" VALUE v.
  _suppress_dbname = (v EQ ?) OR NOT CAN-DO ("true,yes,on",v).   
GET-KEY-VALUE SECTION sctn KEY "DefaultLayoutUnit" VALUE v.
  _cur_layout_unit = (v EQ ?) OR NOT CAN-DO("Pixels,pixel",v).   
GET-KEY-VALUE SECTION sctn KEY "DblClickSectionEd" VALUE v.
  _dblclick_section_ed = (v NE ?) AND CAN-DO ("true,yes,on",v).
GET-KEY-VALUE SECTION sctn KEY "MultipleSectionEd" VALUE v.
  _multiple_section_ed = (v NE ?) AND CAN-DO ("true,yes,on",v).
GET-KEY-VALUE SECTION sctn KEY "GiveHints" VALUE v.
  _uib_prefs._user_hints = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
GET-KEY-VALUE SECTION sctn KEY "GridSnap" VALUE v.
  _cur_grid_snap = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
GET-KEY-VALUE SECTION sctn KEY "GridVisible" VALUE v.
  _cur_grid_visible = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
GET-KEY-VALUE SECTION sctn KEY "ShowAdvisor" VALUE v.
  _uib_prefs._user_advisor = IF (v EQ ?) THEN ? 
                             ELSE IF NOT CAN-DO ("false,no,off",v) THEN TRUE
                             ELSE FALSE.
GET-KEY-VALUE SECTION sctn KEY "SuppressDictViewAs" VALUE v.
  _suppress_dict_view-as = (v NE ?) AND CAN-DO ("true,yes,on",v).
GET-KEY-VALUE SECTION sctn KEY "MostRecentlyUsedFileList" VALUE v.
  IF v = ? THEN _mru_filelist = TRUE.
  ELSE IF CAN-DO ("true,yes,on",v) THEN _mru_filelist = TRUE.
    ELSE _mru_filelist = FALSE.
GET-KEY-VALUE SECTION sctn KEY "PrintDialog" VALUE v.
  IF v = ? THEN _print_dialog = TRUE.
  ELSE IF CAN-DO ("true,yes,on",v) THEN _print_dialog = TRUE. 
    ELSE _print_dialog = FALSE.
     
/* Read in Numeric Values  */
GET-KEY-VALUE SECTION sctn KEY "GridUnitHeight" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _cur_grid_hgt = DECIMAL(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
  IF v EQ ? THEN DO:
    /* What is a good default for _cur_grid_hgt? */
    IF _cur_layout_unit eq NO  THEN _cur_grid_hgt = 10.
    ELSE                            _cur_grid_hgt = .25.
  END.
GET-KEY-VALUE SECTION sctn KEY "GridUnitWidth" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _cur_grid_wdth = DECIMAL(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
  IF v EQ ? THEN DO:
    /* What is a good default for _cur_grid_wdth? */
    IF _cur_layout_unit eq NO                    THEN _cur_grid_wdth = 10.
    ELSE IF SESSION:PIXELS-PER-COLUMN MOD 2 eq 0 THEN _cur_grid_wdth = 0.5.
    ELSE                                              _cur_grid_wdth = 1.0.
  END.
GET-KEY-VALUE SECTION sctn KEY "GridFactorHorizontal" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _cur_grid_factor_h = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
  IF v EQ ? THEN _cur_grid_factor_h = 10.
GET-KEY-VALUE SECTION sctn KEY "GridFactorVertical" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _cur_grid_factor_v = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
 IF v EQ ? THEN _cur_grid_factor_v = 4.
GET-KEY-VALUE SECTION sctn KEY "NewObjectToggles" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _file_new_config = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
 IF v EQ ? THEN _file_new_config = 15.
GET-KEY-VALUE SECTION sctn KEY "MRUEntries" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _mru_entries = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.  
  IF v EQ ? AND _mru_filelist THEN _mru_entries = 4.
GET-KEY-VALUE SECTION sctn KEY "PrintPageLength" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _print_pg_length = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN v = ?.
  END.
  ELSE ASSIGN _print_pg_length = 60.
GET-KEY-VALUE SECTION sctn KEY "PrintFont" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN _print_font = INTEGER(v) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN V = ?.
  END.
  ELSE ASSIGN _print_font = 2.

/* Read in the Character Values.  
 * Saved Directories:   Icon Directories, Template Directories, 
 *                      WidgetListDirectories and CodeListDirectories. 
 * Specific File Names: Custom Widget Text file.
 *                      Extended Features file (XFTR).
 */
GET-KEY-VALUE SECTION sctn KEY "IconDirectories" VALUE v.
  IF v eq ? THEN ASSIGN v = "adeicon".
  {&ICON-DIRS} = v.
/* The following all default to the same direcory, so we use FILE-INFO once. */
GET-KEY-VALUE SECTION sctn KEY "TemplateDirectories" VALUE v.
  IF v eq ? THEN
    CASE _AB_license:
       WHEN 1 THEN v = "{&DEFAULT-TEMPLATE-DIRS-CS-ONLY}".
       WHEN 2 THEN v = "{&DEFAULT-TEMPLATE-DIRS-WS-ONLY}".
       WHEN 3 THEN v = "{&DEFAULT-TEMPLATE-DIRS-BOTH}".
     END CASE.
  {&TEMPLATE-DIRS} = v.
GET-KEY-VALUE SECTION sctn KEY "WidgetListDirectories" VALUE v.
  IF v eq ? THEN
    v = "src{&SLSH}template,.".  /* template AND current directory */
  {&WIDGET-DIRS} = v.
GET-KEY-VALUE SECTION sctn KEY "CodeListDirectories" VALUE v.
  IF v eq ? THEN
    v = "src{&SLSH}template,.".  /* templates AND current directory */
  {&CODE-DIRS} = v.
GET-KEY-VALUE SECTION sctn KEY _custom_files_savekey VALUE v.
  IF v eq ? THEN
    v = _custom_files_default.
  {&CUSTOM-FILES} = v.
GET-KEY-VALUE SECTION sctn KEY "XFTRfile" VALUE v.
  IF v eq ? THEN
    v = "adeuib{&SLSH}startup.xft" .
  {&XFTR-FILE} = v.

/* Read in TTY simulator Values */
GET-KEY-VALUE SECTION sctn KEY "TTYBackgroundColor" VALUE v.
  CASE v:
    WHEN "DEFAULT" THEN _tty_bgcolor = ?.
    WHEN ?         THEN _tty_bgcolor = 7. /* Grey */
    OTHERWISE DO:
      ASSIGN _tty_bgcolor = INTEGER(v) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _tty_bgcolor = 7.
    END.
   END CASE.
GET-KEY-VALUE SECTION sctn KEY "TTYForegroundColor" VALUE v.
  CASE v:
    WHEN "DEFAULT" THEN _tty_fgcolor = ?.
    WHEN ?         THEN _tty_fgcolor = 14. /* Yellow */
    OTHERWISE DO:
      ASSIGN _tty_fgcolor = INTEGER(v) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN _tty_fgcolor = 14.
    END.
  END CASE.

/* All the advisor settings are in one string of the form "---X-X" where X's
   indicate advisors we never want to see again.  We just are going to 
   pop through this list and recover the values.  We assume the list is in
   the correct format. */
GET-KEY-VALUE SECTION sctn KEY "AdvisorSettings" VALUE v.
  IF ( v <> ? ) THEN DO:
    cnt = MIN(LENGTH(v,"CHARACTER":U), {&Advisor-Count}).
    DO i_v = 1 TO cnt:
      _never-advise[ i_v ] = SUBSTRING(v, i_v, 1, "CHARACTER":U) eq "X".
    END.
  END.

/* Default Frame Tabbing. */
GET-KEY-VALUE SECTION sctn KEY "DefaultTabbing" VALUE v.
  IF ( v eq ? ) THEN v = "Default":U.
  _default_tabbing = v.

/* Default Function type */
GET-KEY-VALUE SECTION sctn KEY "DefaultFunctionType" VALUE v.
  IF ( v eq ? ) THEN v = "Character":U.
  _default_function_type = v.

/* Open/Save/Compiles remotely by default for users who have Enterprise
   and WebSpeed licensed. */
GET-KEY-VALUE SECTION sctn KEY "RemoteFileManagement" VALUE v.
  _remote_file = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
  
/* The WebBrowser related sections WebBroker, OpenNewBrowser, WebBrowser, and
   SavePacketSize is read into _BrokerURL, _open_new_browse, _webbroker, and 
   _save_packet_size. */
RUN adeuib/_getwebp.p(sctn).

/* OCX Property Editor Window Position */
IF VALID-HANDLE(_h_Controls) THEN DO:
  DEFINE VARIABLE PropEd AS INTEGER EXTENT 4 NO-UNDO.
  
  GET-KEY-VALUE SECTION sctn KEY "PropertyEditorPosition" VALUE v.
  IF v NE ? THEN DO:
    ASSIGN PropEd[1] = INT(ENTRY(1,v))  /* left   */
           PropEd[2] = INT(ENTRY(2,v))  /* top    */
           PropEd[3] = INT(ENTRY(3,v))  /* width  */
           PropEd[4] = INT(ENTRY(4,v)). /* height */
    
    /* special adjustment for Win95 TaskBar */
    DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
    DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

    RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                            OUTPUT TBWIdth,       OUTPUT AutoHide).
    IF NOT AutoHide THEN DO:
      IF TBOrientation = "LEFT":U AND PropEd[1] <= TBWidth THEN
        ASSIGN PropEd[1] = TBWidth.
      IF TBOrientation = "TOP":U AND PropEd[2] <= TBHeight THEN 
        ASSIGN PropEd[2] = TBHeight.
      IF TBOrientation = "BOTTOM" AND PropEd[2] + PropEd[4] > SESSION:HEIGHT-P - TBHeight THEN
        PropEd[2] = PropEd[2] - ((PropEd[2] + PropEd[4]) - (SESSION:HEIGHT-P - TBHeight)).
      IF TBOrientation = "RIGHT" AND PropEd[1] + PropEd[3] > SESSION:WIDTH-P - TBWidth THEN
        PropEd[1] = PropEd[1] - ((PropEd[1] + PropEd[3]) - (SESSION:WIDTH-P - TBWidth)).
    END.
    
    /* Set position and size */       
    _h_Controls:SetPropertyEditorPosition(PropEd[1],PropEd[2],PropEd[3],PropEd[4]).
  END.
END.  /* If _h_controls valid */
  
/* AB Main Window Location */
IF VALID-HANDLE(_h_menu_win) THEN 
DO:
  GET-KEY-VALUE SECTION sctn KEY "ABMainLocation" VALUE v.
  IF v NE ? THEN
    ASSIGN _h_menu_win:X = INT(ENTRY(1,v))  /* X-coordinate of AB Main Window */
           _h_menu_win:Y = INT(ENTRY(2,v)). /* Y-coordinate of AB Main Window */
  
END.

/* If the AppBuilder terminated abnormally but the session remained, there 
   may be stale _mru_files temp table records that we should remove */
FOR EACH _mru_files:
  DELETE _mru_files.
END.  /* for each mru */

mru_count = 1.
IF _mru_filelist THEN DO WHILE mru_count <= _mru_entries:
  keyname = "MRUFile" + STRING(mru_count).
  
  GET-KEY-VALUE SECTION sctn KEY keyname VALUE v.
  IF v NE ? THEN DO:
    CREATE _mru_files.
    ASSIGN 
      _mru_files._file = v
      _mru_files._position = mru_count.
    keyname = "MRUBrokerURL" + STRING(mru_count).
    GET-KEY-VALUE SECTION sctn KEY keyname VALUE vbroker.
    ASSIGN _mru_files._broker = IF vbroker = ? THEN "" ELSE vbroker.
  END.  /* if v NE ? */
  
  mru_count = mru_count + 1.
END.  /* if _mru_filelist then do while */

SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).

/* _getpref.p - end of file */


