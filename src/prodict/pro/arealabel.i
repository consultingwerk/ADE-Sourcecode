/*************************************************************/
/* Copyright (c) 1984-2010 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*
   File: prodict/pro/arealabel.i
   
   Description:
     Include file containing functions for area visual state 
     in the Data Dictionary Table Properties dialogs 
     (TTY and create and edit GUI).
    Author(s)   : hdaniels

    Created     : Thu Jun 17 2010
    Notes       :
  ----------------------------------------------------------------------*/
 
function setKeepDefault returns logical(phkeepdefault as handle,pCheck as log ):
    if phKeepDefault:type = "toggle-box" then 
        phKeepDefault:checked = pCheck.
    else
        phKeepDefault:screen-value = string(pCheck).
end.    

function hideArea returns logical(phAreaField as handle):
     if phAreaField:type  = "fill-in" then
         phAreaField:screen-value = "".
     else do:
         phAreaField:add-first (" ").
         phAreaField:screen-value = "".
         
/*         phAreaField:hidden  = true.*/
     end.    
end.    

function showArea returns logical(phAreaField as handle,pcvalue as char,plnew as log):
    if phAreaField:type  = "fill-in" then 
    do:
       if phAreaField:screen-value = "" then
            phAreaField:screen-value = pcvalue.
    end.
    else do:       
        phAreaField:delete(" ").
        if plNew then 
            phAreaField:screen-value = pcvalue.
         
    end.
end.    



function getKeepDefault returns logical(phkeepdefault as handle):
   return  if phKeepDefault:type = "toggle-box" 
           then phKeepDefault:checked
           else phKeepDefault:input-value.
end.    

function setAreaState returns logical 
            (plMt as log, /*multi tenant*/
             plKeepDefault as log,
             plChange as log,  /* changing (not display of current) */
             plNew as log,     /*create (not edit) */
             phKeepDefault as handle,  
             phAreaField as handle,
             phAreaButton as handle, /* some screens have a "home made" combo */
             pcAreaValue as char):
    
    define variable lMtChange as log no-undo.
       
    if plChange and valid-handle(self) and self:name = "_File-attributes" and self <> phKeepDefault then
       lMtChange = true.
      
    if plMt then
    do: 
        if lMtChange then 
        do:
            setKeepDefault(phKeepDefault,true).
            plKeepDefault = true.
        end.   
        phKeepDefault:sensitive = plChange and plNew.  
        phAreaField:sensitive = plnew and plKeepDefault and plChange.
        if not plKeepDefault then 
        do:
            hideArea(phAreaField).
            if valid-handle(phAreaButton) then 
               phAreaButton:sensitive = false.
        end.
        else do: 
            showArea(phAreaField,pcAreaValue,plnew).
            if valid-handle(phAreaButton) then 
               phAreaButton:sensitive = true.
        end.
    end.
    else do:
        if lMtChange then 
             setKeepDefault(phKeepDefault,false).
        phKeepDefault:sensitive = false.
        phAreaField:sensitive = plnew.
        
        showArea(phAreaField,pcAreaValue,plnew).
        
        if valid-handle(phAreaButton) then 
               phAreaButton:sensitive = true.
    end.
    if phKeepDefault:sensitive then 
        phKeepDefault:move-before-tab-item (phAreaField).
    return true. /* not used */
end. 
 