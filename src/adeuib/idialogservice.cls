/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : idialogservice
    Purpose     : Service dialog requests from the IDE
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sat Jan 28 15:49:35 EST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using adeuib.iideeventservice.

interface adeuib.idialogservice inherits iideeventservice:  
    define public property Title as char no-undo get. set.  
    define public property HeightPixels as integer no-undo get.  
    define public property WidthPixels as integer no-undo get.  
    define public property CancelEventNum as int no-undo get. set.  
    define public property Cancelled as logical no-undo get.
       
    /* optional return value  (blank is nothing) */
    define public property ReturnValue as character no-undo 
    get.
    set. 
    
    /* optional ok - defaults to true (false=cancel) 
       NOTE: for external use - not managed by object events 
       (except setting ReturnValue which sets it to true) */
    define public property OK as logical no-undo 
    get.
    set. 
      
	method public void OK(  ).
    method public void Cancel(  ).
    
    /* Must be called before the frame is visible */
    method public void View(  ).
   
    /* increase window size to fit virtual sizes 
       The window is parented to the frame early and code resizings of frame 
       while not visible does not affect the window size.
       This can be called before wait to fix this.
       (can also be resolved by calling view early, but this can cause
        frame errors if done too early)  */
    method public void SizeToFit(  ).    
   /* inherit from iideeventservice */
   /*    method public void RunEvent().*/
   /*    method public void SetCurrentEvent(phHandle as handle,pevent as char).*/
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as char extent ).
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as char ).
    method public void SetCurrentEvent(phHandle as handle,pevent as char, pcparam as int ).
    method public void SetOkButton(pok as handle).
    method public void SetCancelButton(pcancel as handle).
    /* for resize..  */
    method public void SetOtherButtons(pbuttons as handle extent).
       
end interface.