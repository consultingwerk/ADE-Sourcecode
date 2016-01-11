 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _windowservice
    Purpose     : Service for adm2 window hostet in ide 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Oct 2012
    Notes       : currently used for windows that needs to run modal. 
                  (dynamics have some that hides AB desing windows and goes in wait-for) 
                  
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.idialogservice from propath.
using adeuib._abstractdialogservice from propath.
routine-level on error undo, throw.

class adeuib._windowservice inherits _abstractdialogservice implements idialogservice: 
	
    define protected override property CancelHandle as handle no-undo 
        get .
        private set. 
        
    define public override property Title as char no-undo
        init ? 
        get():
            if this-object:Title = ? then 
                return WindowHandle:title.
            else
                return this-object:Title.   
        end. 
        set. 
     
    define public override property HeightPixels as integer no-undo 
        get():
            return WindowHandle:height-pixels.
        end. 
        
    define public override property WidthPixels as integer no-undo 
        get():
            return WindowHandle:width-pixels.
        end. 

    constructor public _windowservice (phWindow as handle,piHwnd as int,prochandle as handle):
        super ().
        WindowHandle = phWindow.
        WindowHandle:IDE-WINDOW-TYPE = 0 .
        WindowHandle:IDE-PARENT-HWND = piHwnd.
        windowhandle:row = 1.
        windowhandle:col = 1.
        ProcedureHandle = prochandle. 
    end constructor.
    
    method override public void Cancel():
        run exitObject in ProcedureHandle.
    end method.
     
    method public override void View(  ).
        /* we're emulating a dialog so turn off any wait-state 
        native dialog boxes probably does this also? - 
        (it makes the UI unresponsove when embedded)  */
        session:set-wait-state("").
        WindowHandle:visible = true no-error.
    end method.
    
    /* do nothing - not applicable  */
    method public override void SizeToFit(  ).  
    end method.
   
 end class.