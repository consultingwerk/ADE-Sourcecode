/*************************************************************/
/* Copyright (c) 2012 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _oeidepref.p
    Purpose     : Program to set/get IDE preferences, properties for app builder

    Syntax      :

    Description : 

    Author(s)   : rkamboj
    Created     : Mon Jan 02 12:37:07 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Shared variables to store Preferences for session */
{adeuib/sharvars.i}   /* Shared variables                */    
{adeuib/gridvars.i}   /* Shared grid and layout variables */  
{adecomm/oeideservice.i}
{adeuib/advice.i}     /* Shared Advisor variables         */
define new global shared temp-table ttpropObject no-undo
       field projName         as character
       field qual_dbname      as character
       field sup_dict_view-as as character
       field tty_bgcolor      as integer
       field tty_fgcolor      as integer.

/*** forward declaration of oeideservice function(s) not defined in oeideservice.i ***/   
function setTTYTerminalColor returns logical
         (pFg as int,
          pBg as int) in hOEIDEService.

/* this procedure is used to save prefrences */
procedure setIDEpreferences:
    define input parameter prefOptions as char no-undo.
    define input parameter pRefresh as log no-undo.
    /*  same as statics in  com.openedge.pdt.oestudio.preferences.OEAppBuilderPreference */
    define variable OBJ_DOUBLE_CLICK as  character init "DblClickSectionEd" no-undo.
    define variable DEF_FUN_DATA_TYPE as  character init "DefaultFunctionType" no-undo.
    define variable GRID_USE as  character init "GridUse" no-undo.
    define variable GRID_SNAP as  character init "GridSnap" no-undo.
    define variable GRID_UNIT_WIDTH as  character init "GridUnitWidth" no-undo.
    define variable GRID_UNIT_HEIGHT as  character init "GridUnitHeight" no-undo.
    define variable GRID_UNIT_BTWN_LINE_HORIZANTAL as  character init "GridFactorHorizontal" no-undo.
    define variable GRID_UNIT_BTWN_LINE_VERTICAL as  character init "GridFactorVertical" no-undo.
    define variable LAYOUT_UNITS as  character init "DefaultLayoutUnit" no-undo.
    define variable STRT_WD_ID_FOR_FRAME as  character init "WidgetIDStart" no-undo.
    define variable FRAME_WD_ID_INCRMNT as  character init "WidgetIDIncrement" no-undo.
    define variable AUTO_ASSGN_WIGD_ID as  character init "AssignWidgetID" no-undo.
    define variable SAVE_WIDGET_ID_FILENAME as  character init "WidgetIDSaveFileName" no-undo.
    define variable WIDGET_ID_USE_DEFAULT_FILENAME as  character init "WidgetIdUseDefaultFileName" no-undo.
    define variable WIDGET_ID_CUSTOM_FILENAME as  character init "WidgetIDCustomFileName" no-undo.
    define variable ADVISOR_PREFERENCE as  character init "Advisor" no-undo.
    
     
    define variable ix as integer no-undo.
    define variable cNumSeparator as char no-undo.
    define variable cDecSeparator as char no-undo.
    define variable cPref as character no-undo.
    define variable cProp as character no-undo.
    define variable cValue as character no-undo.
    define variable iPos as integer no-undo.
    define variable lLayoutUnitchanged as logical no-undo.
    define variable lLayoutFactorchanged as logical no-undo.
    
    cNumSeparator = session:numeric-separator.
    cDecSeparator = session:numeric-decimal-point. 
    /* decimals from eclipse are using american format */
    session:numeric-format = "american".
    
    do ix = 1 to num-entries(prefOptions): 
        cPref = entry(ix,prefOptions).   
        iPos = index(cPref,"=").
        if iPos > 1 then
        do:
            cProp = substr(cPref,1,iPos - 1).
            cValue = substr(cPref,iPos + 1). 
            if cValue = "?" then 
                cValue = ?.  
            case cProp:
                when OBJ_DOUBLE_CLICK then 
                    _dblclick_section_ed   = logical(cValue).
                when DEF_FUN_DATA_TYPE then 
                    _default_function_type = cValue.
                when GRID_USE then 
                do:
                    _cur_grid_visible = logical(cValue). 
                    if pRefresh then
                        run refresh_grid_display in _h_uib.
                end.       
                when GRID_SNAP then 
                do:
                    _cur_grid_snap = logical(cValue). 
                    if pRefresh then
                        run refresh_grid_snap in _h_uib.
                end.        
                when GRID_UNIT_WIDTH then 
                do:
                    _cur_grid_wdth = decimal(cValue).
                    lLayoutUnitchanged = true.     
                end.
                when GRID_UNIT_HEIGHT then 
                do:
                    _cur_grid_hgt = decimal(cValue).  
                    lLayoutUnitchanged = true.     
                end.
                when GRID_UNIT_BTWN_LINE_HORIZANTAL then 
                do:
                    _cur_grid_factor_h = int(cValue). 
                    lLayoutFactorchanged = true.
                end.    
                when GRID_UNIT_BTWN_LINE_VERTICAL then 
                do:     
                    _cur_grid_factor_v = int(cValue). 
                     lLayoutFactorchanged = true.
                end.    
                when LAYOUT_UNITS then 
                do:
                    _cur_layout_unit = logical(cValue). 
                    lLayoutUnitchanged = true.     
                end.
                when AUTO_ASSGN_WIGD_ID then 
                    _widgetid_assign = logical(cValue).
                when STRT_WD_ID_FOR_FRAME then 
                    _widgetid_start = int(cValue).  
                when FRAME_WD_ID_INCRMNT then 
                    _widgetid_increment = int(cValue).                                                 
                when SAVE_WIDGET_ID_FILENAME then 
                    _widgetid_save_filename = logical(cValue).
                when WIDGET_ID_USE_DEFAULT_FILENAME then 
                    _widgetid_default_filename = logical(cValue).
                when WIDGET_ID_CUSTOM_FILENAME then 
                    _widgetid_custom_filename = cValue.
                when ADVISOR_PREFERENCE then 
                do:
                    run setAdvisor(logical(cValue)).
                end.
            end case.    
        end.
    end.                                  
    if lLayoutUnitchanged then
    do:
        if not _cur_layout_unit then
            assign _cur_grid_wdth = if _cur_grid_wdth < 1 then 1 else _cur_grid_wdth
                   _cur_grid_hgt  = if _cur_grid_hgt < 1 then 1 else _cur_grid_hgt .
    end.
    if (lLayoutUnitchanged or lLayoutFactorchanged) and pRefresh then 
        run refresh_grid_units in _h_uib.     
    
/*    message "project" getProjectName() skip  prefOptions skip "dbl" _dblclick_section_ed*/
/*                skip   "dflt"  _default_function_type                                   */
/*                 skip "gwidth" _cur_grid_wdth                                           */
/*              skip "gfactor" _cur_grid_hgt                                              */
/*              skip  "_cur_grid_visible" _cur_grid_visible                               */
/*              skip  "_cur_grid_snap" _cur_grid_snap                                     */
/*             skip "_cur_grid_factor_h"   _cur_grid_factor_h                             */
/*             skip "_cur_grid_factor_v" _cur_grid_factor_v                               */
/*             skip "_cur_layout_unit" _cur_layout_unit                                   */
/*             skip "_widgetid_assign" _widgetid_assign                                   */
/*            skip "_widgetid_start"  _widgetid_start                                     */
/*            skip "_widgetid_increment"  _widgetid_increment                             */
/*            skip "_widgetid_save_filename"  _widgetid_save_filename                     */
/*            skip "_widgetid_default_filename"  _widgetid_default_filename               */
/*            skip "_widgetid_custom_filename"  _widgetid_custom_filename                 */
/*         view-as alert-box.                                                             */
  
/*    assign                                                                                */
/*        _dblclick_section_ed       = if entry(1,prefOptions,",") = "yes" then yes else no */
/*        _default_function_type     = entry(2,prefOptions,",")                             */
/*        _cur_grid_visible          = logical(entry(3,prefOptions,","))                    */
/*        _cur_grid_snap             = logical(entry(4,prefOptions,","))                    */
/*        _cur_grid_wdth             = decimal(entry(5,prefOptions,","))                    */
/*        _cur_grid_hgt              = decimal(entry(6,prefOptions,","))                    */
/*        _cur_grid_factor_h         = integer(entry(7,prefOptions,","))                    */
/*        _cur_grid_factor_v         = INTEGER(entry(8,prefOptions,","))                    */
/*        _cur_layout_unit           = if entry(9,prefOptions,",") = "yes" then yes else no */
/*        _widgetid_assign           = if entry(10,prefOptions,",") = "yes" then yes else no*/
/*        _widgetid_start            = integer(entry(11,prefOptions,","))                   */
/*        _widgetid_increment        = integer(entry(12,prefOptions,","))                   */
/*        _widgetid_save_filename    = if entry(13,prefOptions,",") = "yes" then yes else no*/
/*        _widgetid_default_filename = if entry(14,prefOptions,",") = "yes" then yes else no*/
/*        _widgetid_custom_filename  = entry(15,prefOptions,",").                           */
     
    catch e as Progress.Lang.Error :
    	ShowOkMessageInIDE("Unexpected error when applying AppBuilder preferences to AVM for project" + getProjectName() + "~n" 
                        	+  e:GetMessage(1),"error",?).
    end catch.             
    finally:
       	session:SET-NUMERIC-FORMAT ( cNumSeparator , cDecSeparator).
    end finally.             
end.           

procedure getIDEpreferences:
/*------------------------------------------------------------------------------
  Purpose: Returns the preferences set in the IDE for initalization 
    
------------------------------------------------------------------------------*/
  define input parameter pcfile   as character  no-undo. 
  define variable cIDEpreferences as character  no-undo.
  
  run GetPreferences in hOEIDEService ( output cIDEpreferences). 
  run setIDEpreferences(cIDEpreferences,false /* no need to change - called before windows opened */). 
end procedure.


/* this procedure is used to save project properties */
procedure setIDEproperties:
   define input parameter projName    as char no-undo.
   define input parameter prefOptions as char no-undo.

   find first ttpropObject where ttpropObject.projName = trim(projName) no-error.
   if not avail(ttpropObject) then create ttpropObject.
   Assign ttpropObject.projName = projName.
   if num-entries(prefOptions,",") >= 4 then
   assign ttpropObject.qual_dbname       = entry(1,prefOptions,",")  
          ttpropObject.sup_dict_view-as  = entry(2,prefOptions,",") 
          ttpropObject.tty_bgcolor       = integer(entry(3,prefOptions,","))
          ttpropObject.tty_fgcolor       = integer(entry(4,prefOptions,",")).
          
   /* Set default value of "Create a Default &Window at Startup" preference to false for IDE" */
   FIND FIRST _uib_prefs NO-ERROR.
   IF AVAILABLE(_uib_prefs) THEN 
      ASSIGN _uib_prefs._user_dfltwindow = NO.
    
    
    if ttpropObject.qual_dbname <> "" then 
       Assign _suppress_dbname         = not logical(ttpropObject.qual_dbname).
       
    if ttpropObject.sup_dict_view-as <> "" then 
       _suppress_dict_view-as   = logical(ttpropObject.sup_dict_view-as).
           
       assign   _tty_bgcolor             = ttpropObject.tty_bgcolor
                _tty_fgcolor             = ttpropObject.tty_fgcolor.  
         
 
end procedure.           

procedure setAdvisor:
    define input parameter plValue as logical  no-undo.
    define variable ix as integer no-undo.
    find first _uib_prefs no-error.
    if not avail _uib_prefs then 
        create _uib_prefs.
    assign _uib_prefs._user_advisor  = plValue.    
    
    if ( _uib_prefs._user_advisor <> ? ) then  
    do: 
        do ix = 1 to {&Advisor-Count} :
            assign _never-advise[ ix ] = not _uib_prefs._user_advisor.
        end.
    end.
end procedure.           


procedure getIDEproperties:
/*------------------------------------------------------------------------------
  Purpose: Use to Get properties for project from IDE.
    
------------------------------------------------------------------------------*/
 define input parameter pcfile   as character  no-undo.
 define variable pcIDEproperties as character  no-undo.
  
 run GetProjectProperties in hOEIDEService ( output pcIDEproperties). 
  
 if num-entries(pcIDEproperties,",") >= 4 then  
      run setIDEproperties(getProjectName(),pcIDEproperties).
      
end procedure.

procedure SetCurrentProjectProperties:
   define input parameter projName    as char no-undo.

   find first ttpropObject where ttpropObject.projName = trim(projName) no-error.
   if avail(ttpropObject) then
   do:
      if ttpropObject.qual_dbname <> "" then  
        _suppress_dbname       = not logical(ttpropObject.qual_dbname).
      if ttpropObject.sup_dict_view-as <> "" then 
           _suppress_dict_view-as = logical(ttpropObject.sup_dict_view-as).
           
           
      Assign  _tty_bgcolor           = ttpropObject.tty_bgcolor
              _tty_fgcolor           = ttpropObject.tty_fgcolor.
   end.        
end procedure.

procedure runTTYTerminalColorChooser:
   
    define input parameter pProject as char  no-undo.
    define input parameter pBGColor as int  no-undo.
    define input parameter pFGColor as int  no-undo.
    
    define variable ans      as logical  no-undo.
    define variable cur_bg   as integer  no-undo.
    define variable cur_fg   as integer  no-undo.
    define variable cur_sp   as integer  no-undo.
    define variable cResult  as character   no-undo.
    

    ASSIGN cur_bg   = pBGColor 
           cur_fg   = pFGColor.     
    find first ttpropObject where ttpropObject.projName = trim(pProject) no-error.
    if avail(ttpropObject) then
    Assign cur_bg = ttpropObject.tty_bgcolor 
           cur_fg = ttpropObject.tty_fgcolor.

    RUN adeuib/ide/_dialog_chscolr.p ("Character Terminal Simulator Colors", "", FALSE, ?, ?, ?,
                         INPUT-OUTPUT cur_bg, 
                         INPUT-OUTPUT cur_fg, 
                         INPUT-OUTPUT cur_sp,
                         OUTPUT ans).
    IF ans THEN
    DO: 
        RUN adeuib/_updtclr.p (cur_fg, cur_bg).
        if not avail(ttpropObject) then 
             create ttpropObject.
        assign ttpropObject.projName    = pProject
               ttpropObject.tty_bgcolor = cur_bg
               ttpropObject.tty_fgcolor = cur_fg
               _tty_bgcolor             = cur_bg
               _tty_fgcolor             = cur_fg.

        setTTYTerminalColor(cur_bg,cur_fg).
    end.  
end procedure.

