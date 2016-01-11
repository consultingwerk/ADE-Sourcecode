 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _dialogservice
    Purpose     : Services dialog requests for ide 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Jan 28 16:00:26 EST 2012
    Notes       : Creates a window that is made into a child of the 
                  IDE dialog box and a parent of the ABL dialog's frame.
                  The ABL dialog must NOT be defined as dialog-box. 
                  The abl dialog that is run need to have oeideservice.i
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.idialogservice from propath.
using adeuib._abstractdialogservice from propath.
routine-level on error undo, throw.

class adeuib._dialogservice inherits _abstractdialogservice implements idialogservice: 
	
    define protected property FrameHandle as handle no-undo 
        get. 
        private set.  
        
    define protected override property CancelHandle as handle no-undo 
        get():
            return Framehandle.
        end. 
        private set. 
        
	define public override property Title as char no-undo
	    init ? 
	    get():
	        if this-object:Title = ? then 
	            return FrameHandle:title.
	        else
	            return this-object:Title.   
	    end. 
	    set. 
     
    define public override property HeightPixels as integer no-undo 
        get():
            return FrameHandle:height-pixels.
        end. 
        
         
    define public override property WidthPixels as integer no-undo 
        get():
            return FrameHandle:width-pixels.
        end. 
        
     
	constructor public _dialogservice (phFrame as handle,piHwnd as int64):
		super ().
		FrameHandle = phFrame.
		WindowHandle = CreateWindow().
		
        WindowHandle:IDE-WINDOW-TYPE = 0 .
        WindowHandle:IDE-PARENT-HWND = piHwnd.
        FrameHandle:parent = WindowHandle.
       
	end constructor.

	destructor public _dialogservice ( ):
        delete object WindowHandle no-error. 
	end destructor.
    
    method public override void View(  ).
        /* we're emulating a dialog so turn off any wait-state 
        native dialog boxes probably does this also? - 
        (it makes the UI unresponsove when embedded)  */
        session:set-wait-state("").
        assign
            WindowHandle:width  = FrameHandle:width 
            WindowHandle:height = FrameHandle:height 
            WindowHandle:visible = true
            FrameHandle:visible = true no-error.
    end method.
    
    /* increase window size to fit virtual sizes 
       The window is parented to the frame early and code resizings of frame 
       while not visible does not affect the window size.
       This can be called before wait to fix this.
       (can also be resolved by calling view early, but this can cause
        frame errors if done too early)  */
    method public override void SizeToFit(  ).  
        assign
            FrameHandle:scrollable = false
            WindowHandle:width  = FrameHandle:virtual-width 
            WindowHandle:height = FrameHandle:virtual-width 
            FrameHandle:width   = FrameHandle:virtual-width 
            FrameHandle:height = FrameHandle:virtual-height  .
    end method.
   
    method private handle CreateWindow(  ).
        define var hWin as handle no-undo.
        create window hWin assign
         hidden             = yes
         width              = 20
         height             = 20
         resize             = no
         status-area        = no
         three-d            = yes
         message-area       = no
         status-area        = no
         sensitive          = yes.
           
       return hWin.  
    end method.

 end class.