/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _treeview.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Mon Jun 17 01:49:43 EDT 2013
    Notes       : lifecycle 
                 - starts and receives events to add nodes does not send to ide 
                 - ide asks for widgets exportWidgets is called and gExported flag is set.
                 - when gExported every node change is sent to IDE
                 restart. (NOTE: sycnFromIde opens new before it closes old)  
                 new 
                 - starts and receives events to add nodes 
                 - _oeidesync.w.sycnFromIde runs reloaded which set gexported true
                 close of old 
                  - avoid sending delete when win private-date is '_reload' 
                    also when gexported to avpid remving nodes from ide
                    (the private-data  was not added for this, but for text editor )
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable ghTv       as handle no-undo.
define variable gExported  as logical no-undo.
define variable ghWin as handle no-undo.

{adecomm/oeideservice.i}
{adeuib/idewidgets.i}

/* ********************  Preprocessor Definitions  ******************** */


/* ************************  Function Prototypes ********************** */

function DeleteNode returns logical
    (pKey as character) forward.
    
function FindWidget returns logical 
	(pKey as character,pText as char) forward.

function GetNameFromText returns character 
	(pctext as  char) forward.
	
function int64Value return int64  
    (pcchar as char) forward.
    
function setUseOCX returns logical 
  (pl as logical) in super.
  
function SetText returns logical 
  (pKey as char,  pName as char, ptext as char ) forward:
  

/* ***************************  Main Block  *************************** */

run adeuib/_tview.w persistent set ghTv.
this-procedure:add-super-procedure (ghTv,search-target).
run subscribeEvents.
setUseOCX(false).

/* **********************  Internal Procedures  *********************** */


procedure enable_UI:
/*    run control_load.*/
    ghWin = dynamic-function("getWinHandle").
    ghWin:width = 60 .
    ghWin:height = 3.5.
    
    run winResize(?).
    run viewFrame.
  
end.    

/* see header notes */
procedure reopened:
    gExported = true. 
end.

procedure exportWidgets:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
   define input  parameter pcPath     as character no-undo.
   define input  parameter pcfilename as character no-undo.
   
   pcfilename = if index(pcFilename,".") > 1 then pcfilename else pcfilename + ".xml":U.

   dataset dsWidget:write-xml("file", pcPath + pcfilename ,false,?,?,false,false).
   gExported = true.

end procedure.


/* ************************  Function Implementations ***************** */

/** name is in theory not unique for widgets so we use id */
function FindWidget returns logical 
	( pKey as character,pName as char ):
        
    define variable iKey as integer no-undo.
     
    ikey = int64Value(pKey).
    if ikey <> ? then
    do:
        find ttwidget where ttwidget.id = ikey no-error.
    end.  
    else do:
        release ttwidget.
        /* query is treated as regular widget in pds so use text, which have the _u name   */
        if pKey = "_query" or pKey = "_DataObject" then
        do:
            /* delete does not pass name */
            if pname <> "" then
                find ttwidget where ttwidget.name = pName no-error.
                
            /* called from settext - could be rename  there's only one */
            if not avail ttWidget then 
            do:
                case pKey:
                    when "_query" then 
                         find ttwidget where ttwidget.Type = "Query" no-error.
                    when "_DataObject" then 
                         find ttwidget where ttwidget.Type = "SmartObject" no-error.
                end case.
            end.   
        end.
        else 
            find ttwidget where ttwidget.name = pKey no-error.
    
    end.
    return avail ttwidget.
end function.

function GetNameFromText returns character 
	(ptext as  char ):
	 define variable cName  as character no-undo.   
	 define variable iPos  as integer no-undo.
     cName = pText.
     iPos = index(pText,"(").
     if ipos > 0 then
     do:
         cName = trim(substr(pText,ipos + 1)).
         cName = trim(cName,")").
     end.    
     return cName.
end function.

function int64Value return int64  (pcchar as char):
    define variable iTest as int64  no-undo.
    iTest = int64(pcchar).
    return iTest.
    catch e as Progress.Lang.Error :
    	return ?.	
    end catch.
 
end function.     

function GetNameFromId returns character
     (pId as char):
     define buffer bwidget for ttwidget.
     define variable iKey as integer no-undo.
     define variable cname as character no-undo.
     ikey = int64Value(pId).
     if ikey <> ? then
     do:
         find bwidget where bwidget.id = ikey no-error.
         if not avail bwidget then 
             return ?.
         return bwidget.name.
     end.    
     return pid. 
end function.

/** 
 add child node -  key, name and text are all used to derive the unique  name for pds  
*/
function AddChild returns logical
    (pRelative as character,pKey as character,pName as char,pText as character,pType as character) :  
     define variable ikey    as int64 no-undo.
     define variable cName   as character no-undo.
     define variable cParent as character no-undo.
     
     ikey = int64Value(pKey).
     
     if ikey <> ? then  
     do:
         /** the  text have mapping info from which old and new name can be derrived */
         cName = GetNameFromText(pText).
     end.
     else do:
         if pRelative <> "_Data-Source" and lookup(pkey,"_Fields,_Data-Source,_query") = 0 then
         do:
              return true. /* don't send again */
         end.
         /* these are really widgets, so use the  name as key  */
         if pkey = "_query" or pKey = "_DataObject" then 
             cName = pName.
         else
             cName = pKey.
     end.       
     
     if pRelative > "" and pRelative <> pKey then
     do:
         /* really integer check only - requires parent to be present 
            integers may not even be used as parent - 
            characters are just returned as-is (note that this may be necessary
            as there is currently no attemot to send this in order on the first creation )
            
             */
         cParent = GetNameFromId(pRelative).
         if cParent = ? then
         do:
             undo, throw new Progress.Lang.AppError("Invald Parent " + quoter(pRelative) + " passed to AddChild() for node "  + quoter(pText),?).
         end.
     end.
     create ttwidget.
     assign
        ttWidget.id =  ikey
        ttWidget.name = cName
        ttWidget.parentname = cParent    
        ttWidget.type = pType
        ttWidget.widgetLabel = pText. 
/*      message                                              */
/*      "paramkey" pkey  "paramname" pname  "paramtext" ptext*/
/*       "id " ttWidget.id skip                              */
/*       "name " ttWidget.name skip                          */
/*       "pname "  ttWidget.parentname skip                  */
/*       "type "  ttWidget.type skip                         */
/*        "label " ttWidget.widgetLabel skip                 */
/*      view-as alert-box.                                   */
    /* export once on first request- send each node after ..  */    
    if gExported then 
    do:
        WidgetEvent(ghWin,
                    ttWidget.name,
                    ttWidget.widgetLabel,
                    ttWidget.type,
                    ttWidget.parentname,
                    "Add" ).
    end.    
    return true.    
end.

function DeleteNode returns logical
    (pKey as character) :
    if FindWidget(pKey,"") then
    do:
        if ghwin:PRIVATE-DATA <> "_Reload" and gExported then
        do:
            WidgetEvent(ghWin,
                        ttWidget.name,
                        ttWidget.widgetLabel,
                        ttWidget.type,
                        ttWidget.parentname,
                        "DELETE" ).
        end.
        delete ttWidget.   
        return true.
    end.
    return false.
end.

function SetText returns logical 
  (pKey as char, pName as char, ptext as char ):
    define variable iKey as integer no-undo.
    define variable cNewName as character no-undo.
    define variable cOldName as character no-undo.
    
    if FindWidget(pKey,pName) then
    do:
        ttWidget.widgetLabel = ptext. 
        if ttWidget.Type > "" then
        do:
            if ttWidget.Type = "Query" or ttWidget.Type  = "SmartObject" then
            do:
                cNewName = pname. 
            end.        
            else if ttWidget.Type > "" then
            do:
                cNewName = GetNameFromText(ptext).
            end.
            if cNewName > "" and cNewName <> ttWidget.name then
               assign cOldName = ttWidget.name 
                      ttWidget.name = cNewName. 
        
        end.
        if gExported then 
        do:
            if cOldName > "" then
                RenameWidget(ghWin,
                            cOldName,
                            ttWidget.name,
                            ttWidget.widgetLabel,
                            ttWidget.type,
                            ttWidget.parentname,
                            "RenameAndUpdate" ).
            else
                WidgetEvent(ghWin,
                            ttWidget.name,
                            ttWidget.widgetLabel,
                            ttWidget.type,
                            ttWidget.parentname,
                            "UPDATE" ).
        end.
        return true.
    end.
    return false.  
end.      
 