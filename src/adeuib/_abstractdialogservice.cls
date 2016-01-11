 /*************************************************************/
 /* Copyright (c) 2012 by Progress Software Corporation.      */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _abstractdialogservice.
    Purpose     : Services dialog requests for ide 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Jan 28 16:00:26 EST 2012
    Notes       :  
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.idialogservice from propath.
using adeuib._ideeventservice from propath.
routine-level on error undo, throw.

class adeuib._abstractdialogservice abstract inherits _ideeventservice implements idialogservice: 
	
	define protected property WindowHandle as handle no-undo 
        get.
        protected set.
        
    define protected abstract property CancelHandle as handle no-undo get.  
    
	define public abstract property Title as char no-undo get. set.
	
	define variable mchar as character no-undo. 
	define variable mint as int no-undo. 
    define variable mcharext as character extent no-undo. 
    define variable mhasparam as log  no-undo. 
        
    define public property CancelEventNum as int no-undo get. set.  
    define public abstract property HeightPixels as integer no-undo get. 
    define public abstract property WidthPixels as integer no-undo get.
        
    define variable mOk as handle no-undo.
    define variable mCancel as handle no-undo.
     
	constructor public _abstractdialogservice ( ):
		super ().
	end constructor.
    
    method public abstract void View(  ) .
    
    /* increase window size to fit virtual sizes 
       The window is parented to the frame early and code resizings of frame 
       while not visible does not affect the window size.
       This can be called before wait to fix this.
       (can also be resolved by calling view early, but this can cause
        frame errors if done too early)  */
    method public abstract void SizeToFit(  ).
    
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as char extent ).
        this-object:SetCurrentEvent(phHandle,pevent,?,?,pcparam).
    end method.
    
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as char ).
         define variable cempty as character extent no-undo.  
         this-object:SetCurrentEvent(phHandle,pevent,pcparam,?, GetEmptyExtent()).
    end method.
    
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as int ).
         this-object:SetCurrentEvent(phHandle,pevent,?,pcparam, GetEmptyExtent()).
    end method.
    
    method public override void SetCurrentEvent(phHandle as handle,pevent as char).
         this-object:SetCurrentEvent(phHandle,pevent,?,?, GetEmptyExtent()).
    end method.
    
    method private void SetCurrentEvent(phHandle as handle,pevent as char, pchar as char, pint as int, pcext as char extent).
        super:SetCurrentEvent(phHandle,pevent).
        mchar = pchar.
        mint = pint.
        mcharext = pcext.
    end method.
    
    method private character extent GetEmptyExtent().
        define variable cempty as character extent no-undo.  
        return cempty.
    end method.
    
    
    method public override void RunEvent():
        if mchar <> ? then 
            run value(ProcedureMethod) in ProcedureHandle (mchar).
        else if mint <> ? then 
            run value(ProcedureMethod) in ProcedureHandle (mint).    
        else if extent(mcharext) <> ? then 
            run value(ProcedureMethod) in ProcedureHandle (mcharext).    
        else 
            super:RunEvent().
    end method. 
      
    method public void Ok(  ):
        apply "choose" to mok.
    end method.
    
    method public void Cancel(  ).
        ApplyCancelEvent(  ).
    end method.
    
    method private void ApplyCancelEvent(  ).
        define variable cevent as character no-undo.
        if CancelEventNum = 0 or CancelEventNum = ? then
            apply "choose" to mcancel.
        else do:
            apply "U" + String(CancelEventNum) to CancelHandle.
        end.
    end method.
 
    method public void SetOkButton(pok as handle).
        mok = pok.
    end method.
    
    method public void SetCancelButton(pcancel as handle).
        mcancel = pcancel.
    end method.
    
    method public void SetOtherButtons(pbuttons as handle extent).
        undo, throw new AppError("SetOtherButtons is not supported").
    end method.  
    
    
 end class.