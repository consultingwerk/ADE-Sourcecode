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

File: _putpref.p

Description:
   Loads user preferences using the PUT-KEY-VALUE syntax.

Input Parameters:
   p_save_settings - TRUE if we want to save all the settings.
   
Output Parameters:
  <none>  
  
Author:  Wm.T.Wood

Date Created: February 3, 1993 

Modified:
  wood 7/19/95  - No longer save COLOR and FONT here.
  gfs  12/17/97 - Added WebBrowser
  gfs  03/14/97 - Added PropertyEditorLocation support
  rde  11/06/97 - Added UIBMainLocation support
  gfs  03/13/98 - Made default template & cst lists conditional on product installed.
  slk  03/24/98 - Change sdo.cst to shared.cst
  slk  03/31/98 - Changed order for C/S shared.cst, smart.cst, 
                  progress.cst so that smartContainers are on top
  gfs  04/01/98 - Added activex.cst
  tsm  04/07/99 - Added support for various Intl Numeric Formats (in addition
                  to American and European) by using session set-numeric-format
                  method to set format back to user's setting after setting it
                  to Amerian
  tsm  05/04/99 - Added MostRecentlyUsedFileList, MRUEntries, MRUFile1-9, and
                  MRUBrokerURL1-9 keys for AppBuilder MRU File List  
  tsm  05/12/99 - Added PrintPageLength, PrintFont and PrintDialog
  tsm  05/25/99 - Made MRU Filelist TRUE as default
  tsm  06/29/99 - Only put out printpagelength and printfont when they are
                  not equal to the defaults of 60 and 2
  jep  09/25/01 - jep-icf: ICF custom files handling.
  jep  11/14/01 - jep-icf: Added web.cst to ICF custom files default list. IZ 2845.
----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_save_settings     AS LOGICAL                NO-UNDO.

DEFINE VARIABLE PropEdPos AS INTEGER EXTENT 4 NO-UNDO.

{adeuib/tool.i}       /* Include this 1st - Defines &TOOL */

{adeuib/sharvars.i}   /* Shared variables                 */
{adeuib/gridvars.i}   /* Shared grid and layout variables */
{adeuib/advice.i}     /* Shared Advisor variables         */
{adecomm/adefext.i}   /* Defines Preprocessor variables   */
{adeshar/mrudefs.i}   /* MRU Filelist shared vars and temp table */

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
DEFINE VAR v          AS CHAR      NO-UNDO.
DEFINE VAR c_v        AS CHAR      NO-UNDO.
DEFINE VAR l_v        AS LOGICAL   NO-UNDO.
DEFINE VAR i_v        AS INTEGER   NO-UNDO.
DEFINE VAR filekey    AS CHAR      NO-UNDO.
DEFINE VAR brokerkey  AS CHAR      NO-UNDO.
DEFINE VAR mru_actual AS INTEGER   NO-UNDO.
DEFINE VAR mru_count  AS INTEGER   NO-UNDO.
DEFINE VAR vbroker    AS CHAR      NO-UNDO.
DEFINE VAR c_vbroker  AS CHAR      NO-UNDO.

DEFINE VAR dflt       AS DECIMAL   NO-UNDO.

DEFINE VAR ok_save    AS LOGICAL   NO-UNDO.
DEFINE VAR check_save AS LOGICAL   NO-UNDO.

DEFINE VAR sctn       AS CHAR NO-UNDO.

USE "" NO-ERROR.  /* Make sure that we are using startup defaults file */

/* Define the section. */
sctn = "Pro":U + CAPS("{&TOOL}":U).

/* Always save in AMERICAN format */
SESSION:NUMERIC-FORMAT = "AMERICAN":U.

/* Surround this with a ON ERROR statement to trap error of PUT-KEY-VALUE.
   Something could still technically go wrong in the save, so reset the 
   "ok_save" flag to no -- this will be reset to YES if all the values are
   saved. */
ok_save = no.
PUTPREFS-BLOCK:
DO ON STOP  UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK
   ON ERROR UNDO PUTPREFS-BLOCK, LEAVE PUTPREFS-BLOCK:

  /* If the user does not want to save settings, then record this fact and
     return. (NOTE this means we always record a new value SaveSettings even if  
     if its value is "no".) */
  GET-KEY-VALUE SECTION sctn KEY "SaveSettings" VALUE v.
     l_v =  NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
     IF l_v <> p_save_settings 
     THEN PUT-KEY-VALUE SECTION sctn KEY "SaveSettings" VALUE 
			STRING(p_save_settings) NO-ERROR.
     IF ERROR-STATUS:ERROR THEN STOP.
			
  IF p_save_settings THEN DO:     
  
    /* Check the ability to save settings - this routine writes a Test
       Setting, and then tries to read it back in.  OK_SAVE is set to
       false if there is a problem. */
    RUN adeshar/_chksave.p (INPUT sctn, OUTPUT check_save).
    IF NOT check_save THEN STOP.
    
    /* Send a temp entry to the environment file.  If there is an error,
       then we can skip all the saves.  */
     PUT-KEY-VALUE SECTION sctn KEY "TempKey"
		   VALUE "YES" NO-ERROR.
     IF ERROR-STATUS:ERROR THEN STOP.
     /* If no error, get rid of tempkey. */
     PUT-KEY-VALUE SECTION sctn KEY "TempKey" VALUE ? NO-ERROR.
    
    /* Get the user prefs temp-table.  If it doesn't exist then we have a
       BIG problem. (so just return). */
    FIND FIRST _uib_prefs NO-ERROR.
    IF NOT AVAILABLE _uib_prefs THEN RETURN.
  
    /* Read in the Logical values - If they differ from the current value then
       save them. Most of these values default to yes, except for:
	 _minimize_on_run => MinimizeOnRun
	 _uib_prefs.user_dfltwindow ==> AutoDefaultWindow (this was changed to
					FALSE in 7.3A for performance. 
     */
    GET-KEY-VALUE SECTION sctn KEY "AutoDefaultWindow" VALUE v.
      l_v = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
      IF l_v <> _uib_prefs._user_dfltwindow 
      THEN PUT-KEY-VALUE SECTION sctn KEY "AutoDefaultWindow" 
			 VALUE (if l_v THEN ? ELSE "yes":U).

    GET-KEY-VALUE SECTION sctn KEY "MinimizeOnRun" VALUE v.
      l_v = NOT ((v EQ ?) OR CAN-DO ("false,no,off",v)).
      IF l_v <> _minimize_on_run 
      THEN PUT-KEY-VALUE SECTION sctn KEY "MinimizeOnRun" 
			 VALUE (if l_v THEN ? ELSE "yes":U).

    GET-KEY-VALUE SECTION sctn KEY "QualifyFieldsWithDBName" VALUE v.
      l_v = (v EQ ?) OR NOT CAN-DO ("true,yes,on",v).
      IF l_v <> _suppress_dbname 
      THEN PUT-KEY-VALUE SECTION sctn KEY "QualifyFieldsWithDBName" 
			 VALUE (if _suppress_dbname THEN ? ELSE "yes").

    GET-KEY-VALUE SECTION sctn KEY "DefaultLayoutUnit" VALUE v.
       l_v = (v EQ ?) OR NOT CAN-DO("Pixels,pixel",v).
       IF l_v <> _cur_layout_unit 
       THEN PUT-KEY-VALUE SECTION sctn KEY "DefaultLayoutUnit" 
			  VALUE (if l_v THEN "Pixels" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "DblClickSectionEd" VALUE v.
      l_v = (v NE ?) AND CAN-DO ("true,yes,on",v).
      IF l_v <> _dblclick_section_ed 
      THEN PUT-KEY-VALUE SECTION sctn KEY "DblClickSectionEd" 
			 VALUE (if _dblclick_section_ed THEN "yes" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "MultipleSectionEd" VALUE v.
      l_v = (v NE ?) AND CAN-DO ("true,yes,on",v).
      IF l_v <> _multiple_section_ed 
      THEN PUT-KEY-VALUE SECTION sctn KEY "MultipleSectionEd" 
			 VALUE (if _multiple_section_ed THEN "yes" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "GiveHints" VALUE v.
      l_v = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
      IF l_v <> _uib_prefs._user_hints 
      THEN PUT-KEY-VALUE SECTION sctn KEY "GiveHints" 
			 VALUE (if l_v THEN "no" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "GridSnap" VALUE v.
      l_v = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
      IF l_v <> _cur_grid_snap 
      THEN PUT-KEY-VALUE SECTION sctn KEY "GridSnap" 
			 VALUE (if l_v THEN "no" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "GridVisible" VALUE v.
      l_v = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
      IF l_v <> _cur_grid_visible 
      THEN PUT-KEY-VALUE SECTION sctn KEY "GridVisible" 
			 VALUE (if l_v THEN "no" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "ShowAdvisor" VALUE v.
      l_v = (v EQ ?) OR NOT CAN-DO ("false,no,off",v).
      IF l_v <> _uib_prefs._user_hints 
      THEN PUT-KEY-VALUE SECTION sctn KEY "ShowAdvisor" 
			 VALUE (if l_v THEN "no" ELSE ?).

    GET-KEY-VALUE SECTION sctn KEY "SuppressDictViewAs" VALUE v.
      l_v = (v NE ?) AND CAN-DO ("true,yes,on",v).
      IF l_v <> _suppress_dict_view-as 
      THEN PUT-KEY-VALUE SECTION sctn KEY "SuppressDictViewAS" 
			 VALUE (if _suppress_dict_view-as THEN "yes" ELSE ?).
    
    GET-KEY-VALUE SECTION sctn KEY "MostRecentlyUsedFileList" VALUE v.
      l_v = ((v NE ?) AND CAN-DO ("true,yes,on",v)) OR v = ?.
      IF l_v <> _mru_filelist
      THEN PUT-KEY-VALUE SECTION sctn KEY "MostRecentlyUsedFileList"
                      VALUE (if _mru_filelist THEN "yes" ELSE "no").
    
    GET-KEY-VALUE SECTION sctn KEY "PrintDialog" VALUE v.
      l_v = ((v NE ?) AND CAN-DO ("true,yes,on",v)) OR v = ?.
      IF l_v <> _print_dialog
      THEN PUT-KEY-VALUE SECTION sctn KEY "PrintDialog"
                      VALUE (if _print_dialog THEN "yes" ELSE "no").
                                        
    /* Always export Numeric Values (or ? for defaults) */
  
    /* Compute the default grid height */
    IF _cur_layout_unit eq NO                 THEN dflt = 10.
    ELSE                                           dflt = .25.
    IF _cur_grid_hgt eq dflt THEN v = ?.
    ELSE v = STRING(_cur_grid_hgt).
    PUT-KEY-VALUE SECTION sctn KEY "GridUnitHeight" VALUE v.
   
    /* Compute the default grid width */
    IF _cur_layout_unit eq NO                    THEN dflt = 10.
    ELSE IF SESSION:PIXELS-PER-COLUMN MOD 2 eq 0 THEN dflt = 0.5.
    ELSE                                              dflt = 1.0.
    IF _cur_grid_wdth eq dflt THEN v = ?.
    ELSE v = STRING(_cur_grid_wdth).
    PUT-KEY-VALUE SECTION sctn KEY "GridUnitWidth" VALUE v.
  
    PUT-KEY-VALUE SECTION sctn KEY "GridFactorHorizontal" 
      VALUE (IF _cur_grid_factor_h = 10 THEN ? ELSE STRING(_cur_grid_factor_h)).
  
    PUT-KEY-VALUE SECTION sctn KEY "GridFactorVertical" 
      VALUE (IF _cur_grid_factor_v = 4 THEN ? ELSE STRING(_cur_grid_factor_v)).
    
    PUT-KEY-VALUE SECTION sctn KEY "MRUEntries"
      VALUE (IF _mru_entries = 0 THEN ? ELSE STRING(_mru_entries)).
      
    PUT-KEY-VALUE SECTION sctn KEY "PrintPageLength"
      VALUE (IF _print_pg_length = 60 THEN ? ELSE STRING(_print_pg_length)).
      
    PUT-KEY-VALUE SECTION sctn KEY "PrintFont"
      VALUE (IF _print_font = 2 THEN ? ELSE STRING(_print_font)).
      
    /* Write in the Character Values.  
     * Saved Directories:   Icon Directories, Template Directories, 
     *                      WidgetListDirectories and CodeListDirectories  
     * Specific File Names: Custom Widget Text file. 
     * Set the current value (c_v) equal to "?" if it is default value.
     * Then get the existing KEY-VALUE.  Put a new KEY-VALUE if this is 
     * not the same as c_v. 
     */
    GET-KEY-VALUE SECTION sctn KEY "IconDirectories" VALUE v.
      c_v = {&ICON-DIRS}.
      IF c_v eq "adeicon" THEN c_v = ?.
      IF v ne c_v THEN 
	PUT-KEY-VALUE SECTION sctn KEY "IconDirectories"  VALUE c_v.
    GET-KEY-VALUE SECTION sctn KEY "TemplateDirectories" VALUE v.
      c_v = {&TEMPLATE-DIRS}.
      CASE _AB_license:
        WHEN 1 THEN IF c_v = "{&DEFAULT-TEMPLATE-DIRS-CS-ONLY}" THEN c_v = ?.
        WHEN 2 THEN IF c_v = "{&DEFAULT-TEMPLATE-DIRS-WS-ONLY}" THEN c_v = ?.
        WHEN 3 THEN IF c_v = "{&DEFAULT-TEMPLATE-DIRS-BOTH}"    THEN c_v = ?.
      END CASE.  
      IF v ne c_v THEN 
	PUT-KEY-VALUE SECTION sctn KEY "TemplateDirectories" VALUE c_v.
    GET-KEY-VALUE SECTION sctn KEY "WidgetListDirectories" VALUE v.
      c_v = {&WIDGET-DIRS}.
      IF c_v eq "src{&SLSH}template,." 
      THEN c_v = ?.   /* templates AND current dir */
      IF v ne c_v THEN 
	PUT-KEY-VALUE SECTION sctn KEY "WidgetListDirectories" VALUE c_v.
    GET-KEY-VALUE SECTION sctn KEY "CodeListDirectories" VALUE v.
      c_v = {&CODE-DIRS}.
      IF c_v eq "src{&SLSH}template,." 
      THEN c_v = ?. /* templates AND current dir */
      IF v ne c_v THEN 
	PUT-KEY-VALUE SECTION sctn KEY "CodeListDirectories" VALUE c_v.

    /* Export the TTY simulator Values */
    CASE _tty_bgcolor:
      WHEN ? THEN v = "DEFAULT".
      WHEN 7 THEN v = ?.
      OTHERWISE   v = STRING(_tty_bgcolor).
    END CASE.
    PUT-KEY-VALUE SECTION sctn KEY "TTYBackgroundColor" VALUE v.
  
    CASE _tty_fgcolor:
      WHEN ?   THEN v = "DEFAULT".
      WHEN 14  THEN v = ?.
      OTHERWISE     v = STRING(_tty_fgcolor).
    END CASE.
    PUT-KEY-VALUE SECTION sctn KEY "TTYForegroundColor" VALUE v.
  
    /* Put out the Advisor settings in one string of the form "--X--X" where
       X's are used for advisors that we never want to see again.  */
    GET-KEY-VALUE SECTION sctn KEY "AdvisorSettings" VALUE v.
    c_v = "".
    DO i_v = 1 TO {&Advisor-Count} :
      ASSIGN c_v = c_v + (IF _never-advise[ i_v ] THEN "X" ELSE "-") .
    END.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "AdvisorSettings" VALUE c_v.
  
    /* Save the Default function return type */
    GET-KEY-VALUE SECTION sctn KEY "DefaultFunctionType" VALUE v.
    IF _default_function_type eq "Character":U THEN c_v = ?.
    ELSE c_v = _default_function_type.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "DefaultFunctionType" VALUE c_v.

    /* Export the Default Tabbing */
    GET-KEY-VALUE SECTION sctn KEY "DefaultTabbing" VALUE v.
    IF _default_tabbing eq "Default":U THEN c_v = ?.
    ELSE c_v = _default_tabbing.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "DefaultTabbing" VALUE c_v.

    /* Name of local host machine. */
    GET-KEY-VALUE SECTION sctn KEY "LocalHost" VALUE v.
    c_v = _LocalHost.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "LocalHost" VALUE c_v.          

    /* WebBrowser */
    GET-KEY-VALUE SECTION sctn KEY "WebBrowser" VALUE v.
    c_v = _WebBrowser.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "WebBrowser" VALUE c_v.          
    
    /* Open a new instance of a web browser for each RUN if the user the
       user has specifically requested it after the initial AppBuilder
       startup. */
    l_v = (_open_new_browse eq TRUE).
    PUT-KEY-VALUE SECTION sctn KEY "OpenNewBrowser" 
      VALUE (if l_v THEN "yes":U ELSE "no":U).

    /* WebSpeed Broker */
    GET-KEY-VALUE SECTION sctn KEY "WebBroker" VALUE v.
    c_v = _BrokerURL.
    IF v ne c_v THEN 
      PUT-KEY-VALUE SECTION sctn KEY "WebBroker" VALUE c_v.

    /* Default File Open/Save As/Compile behavior */
    GET-KEY-VALUE SECTION sctn KEY "RemoteFileManagement" VALUE v.
      l_v = (_remote_file eq TRUE).
    PUT-KEY-VALUE SECTION sctn KEY "RemoteFileManagement" 
      VALUE (if l_v THEN "yes":U ELSE "no":U).

    /* OCX Property Editor Window Position */
    IF VALID-HANDLE(_h_Controls) THEN DO:
      _h_Controls:GetPropertyEditorPosition(OUTPUT PropEdPos[1] BY-POINTER,
                                            OUTPUT PropEdPos[2] BY-POINTER,
                                            OUTPUT PropEdPos[3] BY-POINTER,
                                            OUTPUT PropEdPos[4] BY-POINTER).
      /* left,top,width,height */
      c_v = STRING(PropEdPos[1]) + "," +
            STRING(PropEdPos[2]) + "," +
            STRING(PropEdPos[3]) + "," +
            STRING(PropEdPos[4]).
      IF PropEdPos[1] NE 0 AND PropEdPos[1] NE 0 THEN
      PUT-KEY-VALUE SECTION sctn KEY "PropertyEditorPosition" VALUE c_v.
    END.
    
    /* AB Main Window Location */
    GET-KEY-VALUE SECTION sctn KEY "ABMainLocation" VALUE v.
    IF INT(ENTRY(1,v)) NE _h_menu_win:X OR
       INT(ENTRY(2,v)) NE _h_menu_win:Y THEN DO:
      c_v = STRING(_h_menu_win:X) + "," + STRING(_h_menu_win:Y).
      PUT-KEY-VALUE SECTION sctn KEY "ABMainLocation" VALUE c_v.
    END.

  END . /* If p_save_settings.. */

  /*    If MostRecentlyUsedFileList key is false and _mru_filelist
        is TRUE then the user turned on MRU FileList for the session and
        did not save settings.  In this scenario we want to remove the
        internal mru filelist (_mru_files temp table records) so that
        keys are not written for them */ 
  GET-KEY-VALUE SECTION sctn KEY "MostRecentlyUsedFileList" VALUE v.
  IF v NE ? AND CAN-DO("false,no,off",v) AND _mru_filelist THEN DO:
    FOR EACH _mru_files:
      DELETE _mru_files.
    END.  /* for each _mru_files */
  END.  /* if v = ? and _mru_filelist */

  mru_count = 1.
  DO WHILE mru_count < 10:
    
    ASSIGN filekey   = "MRUFile" + STRING(mru_count).
           brokerkey = "MRUBrokerURL" + STRING(mru_count).
           
    /* We need to find out if the entries being used is less then what is
       in the registry - if the user changed the setting just for that 
       session so that we don't write out extra keys */
    GET-KEY-VALUE SECTION sctn KEY "MRUEntries" VALUE v.
    IF (v NE ?) AND (v <= STRING(_mru_entries)) THEN mru_actual = INTEGER(v).
    ELSE mru_actual = _mru_entries.     
       
    GET-KEY-VALUE SECTION sctn KEY filekey VALUE v.
    FIND _mru_files where _mru_files._position = mru_count NO-ERROR.
    IF AVAILABLE _mru_files THEN DO:
      IF mru_count <= mru_actual THEN DO:
        c_v = _mru_files._file.
        IF v NE c_v THEN 
          PUT-KEY-VALUE SECTION sctn KEY filekey VALUE c_v NO-ERROR.
          IF ERROR-STATUS:ERROR THEN STOP.
        GET-KEY-VALUE SECTION sctn KEY brokerkey VALUE vbroker.
        c_vbroker = _mru_files._broker.
        IF vbroker NE c_vbroker THEN 
          PUT-KEY-VALUE SECTION sctn KEY brokerkey VALUE c_vbroker.
      END.  /* if mru_count < mru entries */
      ELSE DO:
        PUT-KEY-VALUE SECTION sctn KEY filekey VALUE ? NO-ERROR.
        IF ERROR-STATUS:ERROR THEN STOP.
        PUT-KEY-VALUE SECTION sctn KEY brokerkey VALUE ?.
      END.  /* else do - mru_count > mru entries */    
    END.  /* if avail _mru_files */
    ELSE DO:
      PUT-KEY-VALUE SECTION sctn KEY filekey VALUE ? NO-ERROR.
      IF ERROR-STATUS:ERROR THEN STOP.
      PUT-KEY-VALUE SECTION sctn KEY brokerkey VALUE ?.
    END.  /* else do _mru_files not avail */
    
    mru_count = mru_count + 1 NO-ERROR.
  END.  /* do while */    
  
  /* If we got here, then all desired save were successful. */
  ok_save = yes.
  
END. /* DO ON ERROR UNDO, LEAVE: */
 
/* Report any saving error! */
IF ok_save eq no
THEN RUN adeshar/_puterr.p ( INPUT "{&UIB_NAME}" , INPUT CURRENT-WINDOW ).

/* Reset user's Numeric Format. */
SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).



